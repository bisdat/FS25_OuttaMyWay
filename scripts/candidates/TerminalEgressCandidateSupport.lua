-- FS25_OuttaMyWay v4.7.121 CANONICAL CANDIDATE — v4.7.120 external-egress mechanical expression retained; broader Terminal Yield policy is not yet implemented here.
-- D-0147 Bounded Terminal Egress Candidate expression.
-- Consumes Terminal Occupancy Knowledge. It chooses no refuge/parking region:
-- exactly one deterministic OUTER Field Boundary egress expression is permitted.

OuttaMyWay.TerminalEgressCandidateSupport={}
local Support=OuttaMyWay.TerminalEgressCandidateSupport
Support.__index=Support

local mandatory={"FIELD_WORLD_CONTAINMENT","TRANSITION_CLEARANCE","REPRESENTATION_FITNESS","CONTROL_CAPABILITY_AVAILABILITY","CONTINUING_INTENT_PRIORITY","PROGRESS_PRESERVATION","RESPONSIBILITY_COMPATIBILITY","OBLIGATION_COMPATIBILITY","COMMITMENT_PRECONDITIONS","EFFECTIVE_ACTUATION_COMPOSITION","SAFE_RELEASE_HANDOVER"}
local function packet(reason,evidence)
    return {result="PASS",applicable=true,evidence=evidence or {},reason=reason,provenance={source="TerminalEgressCandidateSupport",authority="D0147_BOUNDED_TERMINAL_EGRESS"},revalidationTrigger={kind="NEXT_LIVE_OPERATIONAL_PICTURE"}}
end
local function finite(v) return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge end
local function nearestPoint(px,pz,a,b)
    local vx,vz=b.x-a.x,b.z-a.z; local denom=vx*vx+vz*vz
    if denom<=0.0000001 then return a.x,a.z,0 end
    local t=((px-a.x)*vx+(pz-a.z)*vz)/denom; t=math.max(0,math.min(1,t))
    return a.x+t*vx,a.z+t*vz,t
end
local function raySegmentIntersection(px,pz,dx,dz,a,b)
    local sx,sz=b.x-a.x,b.z-a.z
    local denominator=dx*sz-dz*sx
    if math.abs(denominator)<=0.0000001 then return nil end
    local apx,apz=a.x-px,a.z-pz
    local distance=(apx*sz-apz*sx)/denominator
    local fraction=(apx*dz-apz*dx)/denominator
    if distance<=0.0001 or fraction<0 or fraction>1 then return nil end
    return distance,fraction,px+distance*dx,pz+distance*dz
end
local function firstBoundaryIntersection(px,pz,dx,dz,boundary)
    local best=nil
    local boundaryLength=OuttaMyWay.ValueRecord.length(boundary)
    for i=1,boundaryLength do
        local a,b=boundary[i],boundary[(i % boundaryLength)+1]
        if finite(a and a.x) and finite(a and a.z) and finite(b and b.x) and finite(b and b.z) then
            local distance,fraction,x,z=raySegmentIntersection(px,pz,dx,dz,a,b)
            if distance~=nil and (best==nil or distance<best.distanceM) then
                best={segmentIndex=i,segmentFraction=fraction,distanceM=distance,boundaryX=x,boundaryZ=z}
            end
        end
    end
    return best
end
local function boundaryObjective(record,boundary)
    local occupancy=record.currentSpace and record.currentSpace.occupancy or nil
    if occupancy==nil or not finite(occupancy.x) or not finite(occupancy.z) or type(boundary)~="table" then return nil,"OUTER_BOUNDARY_OR_TERMINAL_CENTRE_UNAVAILABLE" end
    local boundaryLength=OuttaMyWay.ValueRecord.length(boundary)
    if boundaryLength<2 then return nil,"OUTER_BOUNDARY_OR_TERMINAL_CENTRE_UNAVAILABLE" end
    local cx,cz=occupancy.x,occupancy.z; local nearest=nil
    for i=1,boundaryLength do
        local a,b=boundary[i],boundary[(i % boundaryLength)+1]
        if finite(a and a.x) and finite(a and a.z) and finite(b and b.x) and finite(b and b.z) then
            local qx,qz,t=nearestPoint(cx,cz,a,b); local dx,dz=qx-cx,qz-cz; local d=math.sqrt(dx*dx+dz*dz)
            if nearest==nil or d<nearest.distanceM then nearest={segmentIndex=i,boundaryX=qx,boundaryZ=qz,distanceM=d,segmentFraction=t} end
        end
    end
    if nearest==nil or nearest.distanceM<=0.05 then return nil,"OUTWARD_REFERENCE_DIRECTION_DEGENERATE" end
    local nx=(nearest.boundaryX-cx)/nearest.distanceM; local nz=(nearest.boundaryZ-cz)/nearest.distanceM
    local hx,hz=tonumber(occupancy.headingX),tonumber(occupancy.headingZ)
    if not finite(hx) or not finite(hz) then return nil,"COMPACT_ASSEMBLY_HEADING_UNAVAILABLE" end
    local headingLength=math.sqrt(hx*hx+hz*hz)
    if headingLength<=0.0001 then return nil,"COMPACT_ASSEMBLY_HEADING_DEGENERATE" end
    hx,hz=hx/headingLength,hz/headingLength

    -- D-0147 v4.7.115: the nearest outer boundary supplies the outward reference,
    -- but the driven direction is kinematically aligned. When the assembly is
    -- already materially outward-facing we retain its heading; otherwise the
    -- normalized heading + outward-reference vector yields one deterministic
    -- oblique lead-in/crossing direction (roughly 45 degrees from a parallel start)
    -- without canonising a fixed angle or searching alternate routes.
    local outwardDot=hx*nx+hz*nz
    local ex,ez,alignmentMode
    if outwardDot>=0.5 then
        ex,ez=hx,hz; alignmentMode="RETAIN_OUTWARD_HEADING"
    else
        ex,ez=hx+nx,hz+nz
        local exitLength=math.sqrt(ex*ex+ez*ez)
        if exitLength<=0.0001 then return nil,"OBLIQUE_EXIT_DIRECTION_DEGENERATE" end
        ex,ez=ex/exitLength,ez/exitLength; alignmentMode="OBLIQUE_HEADING_OUTWARD_BISECTOR"
    end
    local exitOutwardDot=ex*nx+ez*nz
    if exitOutwardDot<=0.05 then return nil,"OBLIQUE_EXIT_LACKS_DECISIVE_OUTWARD_COMPONENT" end

    local crossing=firstBoundaryIntersection(cx,cz,ex,ez,boundary)
    if crossing==nil then return nil,"OBLIQUE_BOUNDARY_CROSSING_UNAVAILABLE" end
    local physicalCount=0
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(record.physicalSpace and record.physicalSpace.primitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true and finite(primitive.x) and finite(primitive.z) and finite(primitive.radius) then
            physicalCount=physicalCount+1
        end
    end
    if physicalCount==0 then return nil,"POSITIVE_TERMINAL_FOOTPRINT_UNAVAILABLE" end
    -- v4.7.120: Candidate supplies Exit Alignment, not a destination point.
    -- 4.7.119 showed that pursuing a fixed oblique point drove the vehicle through
    -- an approximately 90-degree arc even though the desired crossing heading was
    -- only the heading/outward bisector. Control now holds this world direction
    -- until Positive Field-Exit Settlement proves the compact footprint is clear.
    local objective={
        referenceSegmentIndex=nearest.segmentIndex,referenceBoundaryX=nearest.boundaryX,referenceBoundaryZ=nearest.boundaryZ,referenceDistanceM=nearest.distanceM,
        segmentIndex=crossing.segmentIndex,boundaryX=crossing.boundaryX,boundaryZ=crossing.boundaryZ,distanceM=crossing.distanceM,segmentFraction=crossing.segmentFraction,
        outwardX=nx,outwardZ=nz,currentHeadingX=hx,currentHeadingZ=hz,headingOutwardDot=outwardDot,
        exitDirectionX=ex,exitDirectionZ=ez,exitOutwardDot=exitOutwardDot,alignmentMode=alignmentMode,
        physicalPrimitiveCount=physicalCount,islandCandidatesConsidered=false,
        settlement="POSITIVE_FIELD_EXIT_ONLY",
        objectiveKind="OBLIQUE_OUTER_FIELD_BOUNDARY_EGRESS"
    }
    objective.outerBoundary={}
    for _,point in OuttaMyWay.ValueRecord.ipairs(boundary) do
        objective.outerBoundary[#objective.outerBoundary+1]={x=point.x,z=point.z}
    end
    return objective,nil
end
local function activeTerminalContext(picture)
    local contexts=picture.commitmentContext or {}
    if #contexts==0 then return nil,nil end
    if #contexts~=1 then return nil,"OTHER_OR_MULTIPLE_COMMITMENTS_ACTIVE" end
    local basis=contexts[1].governingBasis or {}
    if basis.kind~="TERMINAL_OCCUPANCY" then return nil,"OTHER_COMMITMENT_ACTIVE" end
    return contexts[1],nil
end
local function selectRecord(picture,context)
    if context~=nil then
        local episodeId=context.governingBasis and context.governingBasis.terminalEpisodeId or nil
        for _,record in OuttaMyWay.ValueRecord.ipairs(picture.terminalOccupancyKnowledge or {}) do if record.terminalEpisodeId==episodeId then return record end end
        return nil
    end
    for _,record in OuttaMyWay.ValueRecord.ipairs(picture.terminalOccupancyKnowledge or {}) do
        if record.obstructionPositive==true and record.playerClaimed~=true and record.exhausted~=true then return record end
    end
    return nil
end
local function settlementSpec(record,eventKind)
    local capability=eventKind=="OBJECTIVE_FAILED" and "ESCALATE" or "CONTINUE_UNCHANGED"
    local constraints={}
    for _,id in ipairs(mandatory) do
        constraints[id]=packet("D-0147 terminal settlement consumes positive lifecycle evidence; no new physical authority is requested",{terminalEvent=eventKind,terminalEpisodeId=record.terminalEpisodeId})
    end
    return {
        referenceKey="d0147-terminal-settlement:"..record.terminalEpisodeId..":"..eventKind,
        purpose={kind="D0147_TERMINAL_EGRESS_SETTLEMENT",eventKind=eventKind},subject={assemblyId=record.assemblyId},capability=capability,
        expectedEffect={physicalChange=false,terminalEvent=eventKind,playerEscalationRequired=eventKind=="OBJECTIVE_FAILED"},
        evidenceBasis={constraintEvidence=constraints,terminalEgressBridge={architecture="D0147",terminalEvent=eventKind,terminalEpisodeId=record.terminalEpisodeId,assemblyId=record.assemblyId,assemblyReferenceKey=record.assemblyReferenceKey,existingCommitmentId=record.existingCommitmentId}},
        representationFitness={requirements={}},preconditions={evidenceContracts={}},invalidationConditions={},reversibility={kind="NOT_APPLICABLE_TERMINAL_SETTLEMENT"},obligationsCreated={},releaseImplications={releasePostJobAuthority=true},uncertainty={},comparisonCost=0
    }
end
local function physicalSpec(picture,record,phase,objective,objectiveReason)
    local constraints={}; for _,id in ipairs(mandatory) do constraints[id]=packet("D-0147 bounded Terminal Egress constraint",{bounded=true}) end
    constraints.FIELD_WORLD_CONTAINMENT=packet("D-0147 explicitly permits one bounded displacement across the selected local outer Field Boundary into the immediate margin; no general off-field navigation authority is created",{objective=objective,immediateMarginOnly=true,routePlanning=false})
    constraints.TRANSITION_CLEARANCE=packet("One continuous outward manoeuvre is E&OE and bounded by exhaustion; no negative-clearance or traversable-margin guarantee is asserted. Success requires positive represented Field World exit.",{negativeClearanceAuthority=false,terminalEgressExhaustionOnFailure=true,secondDirectionPermitted=false,positiveFieldExitRequired=true})
    constraints.REPRESENTATION_FITNESS=packet("The current completed-assembly represented footprint positively supports the Terminal Occupancy question and the current terminal pose/heading and local oblique egress calculation",{representationId=record.representationId})
    constraints.CONTROL_CAPABILITY_AVAILABILITY=packet("Production TerminalEgressControl composes supported configuration compaction with direct post-job AIVehicleUtil actuation",{controlModule="TerminalEgressControl",postJobActuation=true,playerClaimWitness="vehicle:getIsEntered()"})
    constraints.CONTINUING_INTENT_PRIORITY=packet("Only the genuinely completed assembly is moved; continuing active Field World demand remains GIANTS-owned and unmodified",{terminalAssemblyId=record.assemblyId,activeDemandAssemblyIds=record.obstructedDemandAssemblyIds})
    constraints.PROGRESS_PRESERVATION=packet("The subject has no productive progress to preserve; the intervention exists solely to remove its realised Terminal Occupancy from continuing demand",{productiveJobEnded=true,parking=false})
    constraints.RESPONSIBILITY_COMPATIBILITY=packet("The Terminal Occupancy obligation belongs independently to this completed assembly and does not create a global relocation problem",{terminalEpisodeId=record.terminalEpisodeId})
    constraints.OBLIGATION_COMPATIBILITY=packet("One positively admitted Terminal Occupancy obligation commits through supported compaction and one decisive egress; transient disappearance of the initiating obstruction does not dissolve it",{retry=false,alternateBoundary=false,terminalResolutionCommitment=true})
    constraints.COMMITMENT_PRECONDITIONS=packet("Job Episode ended by authoritative source-intent termination; the Terminal Occupancy obligation was positively admitted or is already committed; config switch is enabled and Player Claim is absent",{automaticTerminalEgress=OuttaMyWay.AUTOMATIC_TERMINAL_EGRESS==true,playerClaimed=false,terminalResolutionCommitted=record.existingCommitmentId~=nil or record.obstructionPositive==true})
    constraints.EFFECTIVE_ACTUATION_COMPOSITION=packet("Exactly one completed assembly owns POST_JOB_ACTUATION; no productive-progress owner is created",{assemblyId=record.assemblyId,authorityClass="POST_JOB_ACTUATION"})
    constraints.SAFE_RELEASE_HANDOVER=packet("Player Claim ends authority immediately; after positive Terminal Occupancy admission compaction cannot settle the obligation; only positive Field World exit succeeds and manoeuvre failure exhausts without retry",{playerClaimSticky=true,oneManoeuvre=true,compactionOnlySettlement=false,positiveFieldExitRequired=true})
    local requirement="terminal-occupancy:"..record.terminalEpisodeId
    return {
        referenceKey="d0147-terminal-egress:"..record.terminalEpisodeId..":"..phase,
        purpose={kind="D0147_BOUNDED_TERMINAL_EGRESS",result="REMOVE_COMPLETED_ASSEMBLY_FROM_CONTINUING_FIELD_WORLD_DEMAND"},subject={assemblyId=record.assemblyId},capability="REPOSITION",
        expectedEffect={physicalChange=true,phase=phase,mandatoryCompaction=true,obliqueBoundaryEgress=phase=="EGRESS",oneContinuousManoeuvre=true,parking=false},
        evidenceBasis={constraintEvidence=constraints,governingBasis={kind="TERMINAL_OCCUPANCY",responsibilityKey=requirement,terminalEpisodeId=record.terminalEpisodeId,operationIds=picture.identities.operations.active,sourceIntentIds=picture.identities.jobEpisodes.active},postJobActuationOwnership={assemblyIds={record.assemblyId}},effectiveActuationComposition={identity="d0147-composition:"..record.terminalEpisodeId..":"..picture.identity,epoch=picture.epoch,relevantAssemblyIds={record.assemblyId},entries={{assemblyId=record.assemblyId,commitmentId="$NEW_COMMITMENT",capability="REPOSITION",effectClass="TERMINAL_EGRESS",postJobActuation=true}},},maintainsExistingCommitment=record.existingCommitmentId~=nil,terminalEgressBridge={architecture="D0147",phase=phase,terminalEpisodeId=record.terminalEpisodeId,assemblyId=record.assemblyId,assemblyReferenceKey=record.assemblyReferenceKey,objective=objective,objectiveReason=objectiveReason,configurationEvidence=record.configurationEvidence,existingCommitmentId=record.existingCommitmentId}},
        representationFitness={requirements={{representationId=record.representationId,acceptedStates={"FIT_FOR_LIMITED_HORIZON","CURRENTLY_FIT"}}}},
        preconditions={evidenceContracts={{kind=record.existingCommitmentId~=nil and "D0147_TERMINAL_RESOLUTION_COMMITTED" or "D0147_POSITIVE_TERMINAL_OCCUPANCY_ADMISSION",terminalEpisodeId=record.terminalEpisodeId},{kind="PLAYER_CLAIM_ABSENT"}}},
        invalidationConditions={{kind="PLAYER_CLAIM"},{kind="SOURCE_INTENT_REACTIVATES"}},reversibility={kind="BOUNDED_ONE_MANOEUVRE_THEN_EXHAUSTION"},
        obligationsCreated={{origin={kind="TERMINAL_OCCUPANCY",terminalEpisodeId=record.terminalEpisodeId},basis={kind="D0147_POSITIVE_OBSTRUCTION",obstructedDemandAssemblyIds=record.obstructedDemandAssemblyIds},requiredOutcome={kind="TERMINAL_OCCUPANCY_RESOLVED_OR_ESCALATED"},requiredAuthority={class="POST_JOB_ACTUATION"},evidenceContract={kind="POSITIVE_FIELD_EXIT_OR_PLAYER_CLAIM_OR_EXHAUSTION"},ownershipClass="ORIGIN_BOUND",transferPolicy={allowed=false},terminalDependency=true,creationEvidence={obstructionEvidence=record.obstructionEvidence}}},
        releaseImplications={releasePostJobAuthorityOnTerminal=true,noRetry=true},uncertainty={{kind="IMMEDIATE_EXTERNAL_MARGIN_TRAVERSABILITY_NOT_GLOBALLY_MODELLED"}},comparisonCost=1
    }
end
function Support.new(identityRegistry,epochSequence)
    return setmetatable({identities=identityRegistry,epochs=epochSequence,publishedCount=0,lastStatus="INACTIVE"},Support)
end
function Support:attach(picture,snapshot)
    if OuttaMyWay.AUTOMATIC_TERMINAL_EGRESS~=true then self.lastStatus="DISABLED"; return nil end
    local context,contextReason=activeTerminalContext(picture); if contextReason~=nil then self.lastStatus=contextReason; return nil end
    local record=selectRecord(picture,context); if record==nil then self.lastStatus="NO_TERMINAL_OCCUPANCY_ACTION"; return nil end
    local specification
    if record.playerClaimed==true then specification=settlementSpec(record,"PLAYER_CLAIM")
    elseif record.exhausted==true then specification=settlementSpec(record,"OBJECTIVE_FAILED")
    elseif record.manoeuvreCompleted==true then specification=settlementSpec(record,"OBJECTIVE_SATISFIED")
    else
        local config=record.configurationEvidence or {}; local phase="COMPACT"
        local objective,objectiveReason=nil,nil
        if config.retainCurrent==true or config.allFolded==true then phase="EGRESS"; objective,objectiveReason=boundaryObjective(record,snapshot.fieldWorld and snapshot.fieldWorld.boundary or {}) end
        specification=physicalSpec(picture,record,phase,objective,objectiveReason)
    end
    local values=OuttaMyWay.ValueRecord.toTable(picture); local pictureId=self.identities:issue("PICTURE")
    values.identity=pictureId; values.epoch=self.epochs:next(); values.provenance={source="TerminalEgressCandidateSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity,authority="D0147_BOUNDED_TERMINAL_EGRESS"}
    values.candidateSupportEvidence={complete=true,supportBoundary={mode="D0147_BOUNDED_TERMINAL_EGRESS",supportedCandidateClasses={specification.capability},physicalCapabilitiesImplemented=true,controlAuthority="D0147_POST_JOB_ONLY",boundedScope="ONE_COMPLETED_ASSEMBLY_ONE_LOCAL_OUTER_BOUNDARY_REFERENCE_ONE_OBLIQUE_MANOEUVRE_NO_RETRY",automaticTerminalEgress=true},candidateSpecifications={specification},provenance={source="TerminalEgressCandidateSupport",observationSnapshotId=snapshot.identity}}
    self.publishedCount=self.publishedCount+1; self.lastStatus="D0147_"..tostring(specification.capability).."_PUBLISHED"
    return OuttaMyWay.OperationalPicture.new(values)
end
function Support:getPublishedCount() return self.publishedCount end
function Support:getLastStatus() return self.lastStatus end
