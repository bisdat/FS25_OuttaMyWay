-- FS25_OuttaMyWay v4.7.128 CANONICAL CANDIDATE — D-0147 Courtesy Constraint Exception audit alignment.
-- Legacy module/bridge names are retained to minimise plumbing change. Candidate owns
-- one fixed Infield Alignment sampled after supported compaction. The immutable Field
-- World centroid is a directional reference only; it is not a refuge or destination.
-- v4.7.127 preserves the validated v4.7.126 movement/lifecycle unchanged and makes the
-- player-consented Courtesy Constraint Exception explicit instead of fabricating spatial PASS evidence.

OuttaMyWay.TerminalEgressCandidateSupport={}
local Support=OuttaMyWay.TerminalEgressCandidateSupport
Support.__index=Support

local mandatory={"FIELD_WORLD_CONTAINMENT","TRANSITION_CLEARANCE","REPRESENTATION_FITNESS","CONTROL_CAPABILITY_AVAILABILITY","CONTINUING_INTENT_PRIORITY","PROGRESS_PRESERVATION","RESPONSIBILITY_COMPATIBILITY","OBLIGATION_COMPATIBILITY","COMMITMENT_PRECONDITIONS","EFFECTIVE_ACTUATION_COMPOSITION","SAFE_RELEASE_HANDOVER"}
local function packet(reason,evidence)
    return {result="PASS",applicable=true,evidence=evidence or {},reason=reason,provenance={source="TerminalEgressCandidateSupport",authority="D0147_BOUNDED_INFIELD_RETREAT"},revalidationTrigger={kind="NEXT_LIVE_OPERATIONAL_PICTURE"}}
end
local function courtesyExemption(reason,evidence)
    return {result="PASS",applicable=false,evidence=evidence or {},reason=reason,provenance={source="TerminalEgressCandidateSupport",authority="D0147_COURTESY_CONSTRAINT_EXCEPTION"},revalidationTrigger={kind="NEXT_LIVE_OPERATIONAL_PICTURE"}}
end
local function finite(v) return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge end

local function infieldObjective(record,fieldWorld)
    local occupancy=record.currentSpace and record.currentSpace.occupancy or nil
    local metrics=fieldWorld and fieldWorld.geometryMetrics or nil
    local cx,cz=metrics and tonumber(metrics.centroidX),metrics and tonumber(metrics.centroidZ)
    if occupancy==nil or not finite(occupancy.x) or not finite(occupancy.z) or not finite(cx) or not finite(cz) then
        return nil,"FIELD_WORLD_CENTROID_OR_TERMINAL_CENTRE_UNAVAILABLE"
    end
    local dx,dz=cx-occupancy.x,cz-occupancy.z
    local distance=math.sqrt(dx*dx+dz*dz)
    if distance<=0.0001 then
        return {objectiveKind="BOUNDED_INFIELD_RETREAT",alignmentMode="FIXED_INITIAL_CENTRE_BEARING",fieldCentreX=cx,fieldCentreZ=cz,initialDistanceToCentreM=distance,courtesyExhausted=true},nil
    end
    local retreat=tonumber(OuttaMyWay.TERMINAL_INFIELD_RETREAT_DISTANCE_M) or 60.0
    if distance<=retreat then
        return {objectiveKind="BOUNDED_INFIELD_RETREAT",alignmentMode="FIXED_INITIAL_CENTRE_BEARING",fieldCentreX=cx,fieldCentreZ=cz,initialDistanceToCentreM=distance,retreatDistanceM=retreat,courtesyExhausted=true},nil
    end
    local physicalCount=0
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(record.physicalSpace and record.physicalSpace.primitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true and finite(primitive.x) and finite(primitive.z) and finite(primitive.radius) then physicalCount=physicalCount+1 end
    end
    if physicalCount==0 then return nil,"POSITIVE_TERMINAL_FOOTPRINT_UNAVAILABLE" end
    return {
        objectiveKind="BOUNDED_INFIELD_RETREAT",alignmentMode="FIXED_INITIAL_CENTRE_BEARING",
        fieldCentreX=cx,fieldCentreZ=cz,initialDistanceToCentreM=distance,
        infieldDirectionX=dx/distance,infieldDirectionZ=dz/distance,
        retreatDistanceM=retreat,completionDistanceToCentreM=distance-retreat,
        physicalPrimitiveCount=physicalCount,fieldCentreIsDirectionalReferenceOnly=true,
        continuousCourseCorrection=false,settlement="BOUNDED_INFIELD_PROGRESS"
    },nil
end

local function activeTerminalContext(picture)
    local contexts=picture.commitmentContext or {}
    if OuttaMyWay.ValueRecord.length(contexts)==0 then return nil,nil end
    if OuttaMyWay.ValueRecord.length(contexts)~=1 then return nil,"OTHER_OR_MULTIPLE_COMMITMENTS_ACTIVE" end
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
        if record.obstructionPositive==true and record.playerClaimed~=true and record.exhausted~=true and record.yieldAwaitingContinuation~=true then return record end
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
        purpose={kind="D0147_TERMINAL_YIELD_SETTLEMENT",eventKind=eventKind},subject={assemblyId=record.assemblyId},capability=capability,
        expectedEffect={physicalChange=false,terminalEvent=eventKind,playerEscalationRequired=eventKind=="OBJECTIVE_FAILED"},
        evidenceBasis={constraintEvidence=constraints,terminalEgressBridge={architecture="D0147",terminalEvent=eventKind,terminalEpisodeId=record.terminalEpisodeId,assemblyId=record.assemblyId,assemblyReferenceKey=record.assemblyReferenceKey,existingCommitmentId=record.existingCommitmentId}},
        representationFitness={requirements={}},preconditions={evidenceContracts={}},invalidationConditions={},reversibility={kind="NOT_APPLICABLE_TERMINAL_SETTLEMENT"},obligationsCreated={},releaseImplications={releasePostJobAuthority=true},uncertainty={},comparisonCost=0
    }
end
local function snapshotReferenceByAssembly(snapshot)
    local refs={}
    for _,assembly in OuttaMyWay.ValueRecord.ipairs(snapshot and snapshot.assemblies or {}) do
        if type(assembly.assemblyId)=="string" and type(assembly.referenceKey)=="string" then refs[assembly.assemblyId]=assembly.referenceKey end
    end
    return refs
end

local function protectedDemandAssemblies(record,context,snapshot)
    local ids={}
    local basis=context and context.governingBasis or nil
    local source=type(basis)=="table" and basis.authorizingDemandAssemblyIds or record.obstructedDemandAssemblyIds
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(source or {}) do
        if type(assemblyId)=="string" and assemblyId~=record.assemblyId then ids[#ids+1]=assemblyId end
    end
    table.sort(ids)
    local refs=snapshotReferenceByAssembly(snapshot)
    local entries={}
    for _,assemblyId in ipairs(ids) do entries[#entries+1]={assemblyId=assemblyId,referenceKey=refs[assemblyId]} end
    return entries
end

local function physicalSpec(picture,record,phase,objective,objectiveReason,protected)
    local constraints={}; for _,id in ipairs(mandatory) do constraints[id]=packet("D-0147 bounded Infield Yield constraint",{bounded=true}) end
    constraints.FIELD_WORLD_CONTAINMENT=courtesyExemption("D-0147 Courtesy Constraint Exception: player-consented buy-time movement is exempt from generic predictive full-sweep Field World containment proof; the centroid bearing is a crude directional heuristic, not containment evidence",{objective=objective,specialCase="D0147_COURTESY_CONSTRAINT_EXCEPTION",predictiveContainmentClaim=false,routePlanning=false,continuousCourseCorrection=false})
    constraints.TRANSITION_CLEARANCE=courtesyExemption("D-0147 Courtesy Constraint Exception: player-consented buy-time movement is exempt from generic predictive complete-envelope Transition Clearance proof; no future-demand exclusion map, parking search or permanent-clearance claim is made",{specialCase="D0147_COURTESY_CONSTRAINT_EXCEPTION",predictiveTransitionClearanceClaim=false,negativeFutureClearanceAuthority=false,parking=false,routePlanning=false})
    constraints.REPRESENTATION_FITNESS=packet("The current completed-assembly represented footprint positively supports Terminal Occupancy and the current terminal centre needed to derive one fixed Infield Alignment",{representationId=record.representationId})
    constraints.CONTROL_CAPABILITY_AVAILABILITY=packet("TerminalEgressControl reuses supported compaction, Vehicle Activity Context and forward-only driveInDirection actuation; the existing Regulation lease substrate provides a zero-speed Protected Yield hold for the authorising productive assembly/assemblies during translation",{controlModule="TerminalEgressControl",postJobActuation=true,protectedYieldHold=true,holdActuator="REGULATE_SPEED_0",moveForwards=true,playerClaimWitness="vehicle:getIsEntered()"})
    constraints.CONTINUING_INTENT_PRIORITY=packet("The completed assembly moves while the active assembly/assemblies whose conflict authorised D-0147 retain their GIANTS jobs but are temporarily held for the translational Protected Yield Interval",{terminalAssemblyId=record.assemblyId,activeDemandAssemblyIds=record.obstructedDemandAssemblyIds,protectedDemandAssemblies=protected,productiveJobsRemainGiantsOwned=true})
    constraints.PROGRESS_PRESERVATION=packet("The subject has no productive progress to preserve; the optional intervention exists only to buy player-reclamation time by restoring current continuation",{productiveJobEnded=true,parking=false})
    constraints.RESPONSIBILITY_COMPATIBILITY=packet("The Terminal Occupancy obligation belongs independently to this completed assembly; unrelated completed assemblies remain constraints rather than transitive relocation authority",{terminalEpisodeId=record.terminalEpisodeId})
    constraints.OBLIGATION_COMPATIBILITY=packet("One admitted conflict owns one bounded retreat Commitment. A later retreat requires post-release physical continuation and then a later attributed native blocked state to renew courtesy authority",{oneRetreatPerCommitment=true,repeatRequiresContinuationRenewal=true,terminalResolutionCommitment=true})
    constraints.COMMITMENT_PRECONDITIONS=packet("Job Episode ended by authoritative source-intent termination; positive Terminal Occupancy was admitted or is already committed; consent is enabled and Player Claim is absent",{automaticTerminalEgress=OuttaMyWay.AUTOMATIC_TERMINAL_EGRESS==true,playerClaimed=false,terminalResolutionCommitted=record.existingCommitmentId~=nil or record.obstructionPositive==true})
    constraints.EFFECTIVE_ACTUATION_COMPOSITION=packet("One D-0147 Commitment owns POST_JOB_ACTUATION for the completed assembly and bounded PROGRESS_ACTUATION only for zero-speed protection of the authorising productive assembly/assemblies",{terminalAssemblyId=record.assemblyId,postJobAuthorityClass="POST_JOB_ACTUATION",protectedDemandAssemblies=protected,progressAuthorityClass="PROGRESS_ACTUATION",effectClass="HOLD"})
    constraints.SAFE_RELEASE_HANDOVER=packet("Player Claim/source reactivation ends terminal authority immediately. Every Protected Yield exit releases its zero-speed productive hold; owned completion/failure positively neutralises terminal actuation before Vehicle Activity Context and all D-0147 authority are released",{playerClaimSticky=true,actuationNeutralisation=true,protectedYieldHoldRelease=true,oneBoundedRetreat=true})
    local requirement="terminal-occupancy:"..record.terminalEpisodeId
    local protectedIds={}; local relevantIds={record.assemblyId}; local compositionEntries={{assemblyId=record.assemblyId,commitmentId="$NEW_COMMITMENT",capability="REPOSITION",effectClass="TERMINAL_YIELD",postJobActuation=true}}
    for _,item in ipairs(protected or {}) do
        protectedIds[#protectedIds+1]=item.assemblyId; relevantIds[#relevantIds+1]=item.assemblyId
        compositionEntries[#compositionEntries+1]={assemblyId=item.assemblyId,commitmentId="$NEW_COMMITMENT",capability="REGULATE_SPEED",effectClass="HOLD",progressActuation=true}
    end
    return {
        referenceKey="d0147-terminal-yield:"..record.terminalEpisodeId..":"..phase,
        purpose={kind="D0147_BOUNDED_INFIELD_RETREAT",result="BUY_PLAYER_RECLAMATION_TIME_BY_RESTORING_CURRENT_CONTINUATION"},subject={assemblyId=record.assemblyId},capability="REPOSITION",
        expectedEffect={physicalChange=true,phase=phase,mandatoryCompaction=true,boundedInfieldRetreat=phase=="INFIELD",oneFixedAlignment=true,parking=false},
        evidenceBasis={constraintEvidence=constraints,courtesyConstraintException={kind="D0147_COURTESY_CONSTRAINT_EXCEPTION",exemptMandatoryConstraintIds={"FIELD_WORLD_CONTAINMENT","TRANSITION_CLEARANCE"},scope="PLAYER_CONSENTED_BOUNDED_BUY_TIME_MOVEMENT_ONLY"},governingBasis={kind="TERMINAL_OCCUPANCY",responsibilityKey=requirement,terminalEpisodeId=record.terminalEpisodeId,operationIds=picture.identities.operations.active,sourceIntentIds=picture.identities.jobEpisodes.active,authorizingDemandAssemblyIds=protectedIds},progressActuationOwnership={assemblyIds=protectedIds},postJobActuationOwnership={assemblyIds={record.assemblyId}},effectiveActuationComposition={identity="d0147-composition:"..record.terminalEpisodeId..":"..picture.identity,epoch=picture.epoch,relevantAssemblyIds=relevantIds,entries=compositionEntries},maintainsExistingCommitment=record.existingCommitmentId~=nil,terminalEgressBridge={architecture="D0147",phase=phase,terminalEpisodeId=record.terminalEpisodeId,assemblyId=record.assemblyId,assemblyReferenceKey=record.assemblyReferenceKey,objective=objective,objectiveReason=objectiveReason,configurationEvidence=record.configurationEvidence,existingCommitmentId=record.existingCommitmentId,protectedDemandAssemblies=protected}},
        representationFitness={requirements={{representationId=record.representationId,acceptedStates={"FIT_FOR_LIMITED_HORIZON","CURRENTLY_FIT"}}}},
        preconditions={evidenceContracts={{kind=record.existingCommitmentId~=nil and "D0147_TERMINAL_RESOLUTION_COMMITTED" or "D0147_POSITIVE_TERMINAL_OCCUPANCY_ADMISSION",terminalEpisodeId=record.terminalEpisodeId},{kind="PLAYER_CLAIM_ABSENT"}}},
        invalidationConditions={{kind="PLAYER_CLAIM"},{kind="SOURCE_INTENT_REACTIVATES"}},reversibility={kind="BOUNDED_ONE_RETREAT_THEN_REASSESS"},
        obligationsCreated={{origin={kind="TERMINAL_OCCUPANCY",terminalEpisodeId=record.terminalEpisodeId},basis={kind="D0147_POSITIVE_OBSTRUCTION",obstructedDemandAssemblyIds=record.obstructedDemandAssemblyIds},requiredOutcome={kind="CURRENT_TERMINAL_CONFLICT_YIELDED_OR_ESCALATED"},requiredAuthority={classes={"POST_JOB_ACTUATION","PROGRESS_ACTUATION"}},evidenceContract={kind="BOUNDED_INFIELD_RETREAT_OR_PLAYER_CLAIM_OR_EXHAUSTION"},ownershipClass="ORIGIN_BOUND",transferPolicy={allowed=false},terminalDependency=true,creationEvidence={obstructionEvidence=record.obstructionEvidence}}},
        releaseImplications={releasePostJobAuthorityOnTerminal=true,laterRetryRequiresContinuationRenewal=true},uncertainty={{kind="CRUDE_INFIELD_ARC_NOT_GLOBALLY_PATH_PLANNED"}},comparisonCost=1
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
    else
        local config=record.configurationEvidence or {}; local phase="COMPACT"
        local objective,objectiveReason=nil,nil
        if config.retainCurrent==true or config.allFolded==true then phase="INFIELD"; objective,objectiveReason=infieldObjective(record,snapshot.fieldWorld) end
        specification=physicalSpec(picture,record,phase,objective,objectiveReason,protectedDemandAssemblies(record,context,snapshot))
    end
    local values=OuttaMyWay.ValueRecord.toTable(picture); local pictureId=self.identities:issue("PICTURE")
    values.identity=pictureId; values.epoch=self.epochs:next(); values.provenance={source="TerminalEgressCandidateSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity,authority="D0147_BOUNDED_INFIELD_RETREAT"}
    values.candidateSupportEvidence={complete=true,supportBoundary={mode="D0147_BOUNDED_TERMINAL_EGRESS",supportedCandidateClasses={specification.capability},physicalCapabilitiesImplemented=true,controlAuthority="D0147_POST_JOB_PLUS_PROTECTED_YIELD_HOLD",boundedScope="ONE_COMPLETED_ASSEMBLY_ONE_FIXED_INITIAL_CENTRE_BEARING_ONE_BOUNDED_FORWARD_RETREAT_WITH_AUTHORISING_PRODUCTIVE_HOLD",automaticTerminalEgress=true},candidateSpecifications={specification},provenance={source="TerminalEgressCandidateSupport",observationSnapshotId=snapshot.identity}}
    self.publishedCount=self.publishedCount+1; self.lastStatus="D0147_"..tostring(specification.capability).."_PUBLISHED"
    return OuttaMyWay.OperationalPicture.new(values)
end
function Support:getPublishedCount() return self.publishedCount end
function Support:getLastStatus() return self.lastStatus end
