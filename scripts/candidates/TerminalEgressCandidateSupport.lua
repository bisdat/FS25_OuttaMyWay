-- FS25_OuttaMyWay v0.1.14.4 TEST — D-0199 Courtesy Budget Ownership + Bounded Centroid Settlement.
-- D-0147 keeps D-0194 Double Courtesy with D-0199 ownership/bounding refinement: first
-- toward the Field World centroid by at most 60 m, then (only after Continuation Renewal
-- and a later native block positively attributed to the same moved completed assembly) one
-- final deterministic boundary move. Stage 2 travels on the single boundary ray away from the authorising
-- productive occupancy and is admitted only when that complete straight translation is
-- clear of the protected worker's current positive physical occupancy. No search or third
-- automatic relocation exists.

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

local function rawRing(source)
    local result={}
    for _,point in OuttaMyWay.ValueRecord.ipairs(source or {}) do
        if finite(tonumber(point.x)) and finite(tonumber(point.z)) then result[#result+1]={x=tonumber(point.x),z=tonumber(point.z)} end
    end
    return result
end
local function pointSegmentDistanceAndPoint(px,pz,a,b)
    local vx,vz=b.x-a.x,b.z-a.z
    local denom=vx*vx+vz*vz
    local t=denom>0 and (((px-a.x)*vx+(pz-a.z)*vz)/denom) or 0
    t=math.max(0,math.min(1,t))
    local qx,qz=a.x+t*vx,a.z+t*vz
    local dx,dz=px-qx,pz-qz
    return math.sqrt(dx*dx+dz*dz),qx,qz
end
local function nearestPointOnRing(px,pz,source)
    local ring=rawRing(source)
    if #ring<2 then return nil end
    local bestDistance,bestX,bestZ=nil,nil,nil
    for index=1,#ring do
        local nextIndex=(index % #ring)+1
        local distance,qx,qz=pointSegmentDistanceAndPoint(px,pz,ring[index],ring[nextIndex])
        if bestDistance==nil or distance<bestDistance then bestDistance,bestX,bestZ=distance,qx,qz end
    end
    return bestDistance,bestX,bestZ
end
local function cross2(ax,az,bx,bz) return ax*bz-az*bx end
local function forwardBoundaryPoint(px,pz,dx,dz,source)
    local ring=rawRing(source)
    if #ring<2 then return nil end
    local bestT,bestX,bestZ=nil,nil,nil
    for index=1,#ring do
        local nextIndex=(index % #ring)+1
        local a,b=ring[index],ring[nextIndex]
        local sx,sz=b.x-a.x,b.z-a.z
        local denom=cross2(dx,dz,sx,sz)
        if math.abs(denom)>0.0000001 then
            local qx,qz=a.x-px,a.z-pz
            local t=cross2(qx,qz,sx,sz)/denom
            local u=cross2(qx,qz,dx,dz)/denom
            if t>=0 and u>=-0.0000001 and u<=1.0000001 and (bestT==nil or t<bestT) then
                bestT,bestX,bestZ=t,px+dx*t,pz+dz*t
            end
        end
    end
    return bestT,bestX,bestZ
end
local function pointInRing(px,pz,source)
    local ring=rawRing(source)
    if #ring<3 then return false end
    local inside=false
    local previous=#ring
    for index=1,#ring do
        local a,b=ring[index],ring[previous]
        if ((a.z>pz)~=(b.z>pz)) then
            local denom=b.z-a.z
            local intersectX=a.x+(pz-a.z)*(b.x-a.x)/denom
            if px<intersectX then inside=not inside end
        end
        previous=index
    end
    return inside
end
local function discFitsFieldWorld(x,z,radius,fieldWorld)
    if not pointInRing(x,z,fieldWorld and fieldWorld.boundary or {}) then return false end
    local outerDistance=nearestPointOnRing(x,z,fieldWorld and fieldWorld.boundary or {})
    if outerDistance==nil or outerDistance+0.000001<radius then return false end
    for _,island in OuttaMyWay.ValueRecord.ipairs(fieldWorld and fieldWorld.islands or {}) do
        if pointInRing(x,z,island) then return false end
        local islandDistance=nearestPointOnRing(x,z,island)
        if islandDistance~=nil and islandDistance+0.000001<radius then return false end
    end
    return true
end
local function footprintPrimitives(record)
    local result={}
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(record.physicalSpace and record.physicalSpace.primitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true and finite(primitive.x) and finite(primitive.z) and finite(primitive.radius) then
            result[#result+1]={x=primitive.x,z=primitive.z,radius=math.max(0,primitive.radius),identity=primitive.identity}
        end
    end
    return result
end
local function currentOccupancyByReference(snapshot,referenceKey)
    for _,item in OuttaMyWay.ValueRecord.ipairs(snapshot and snapshot.geometry and snapshot.geometry.currentSpaceEvidence or {}) do
        if item.assemblyReferenceKey==referenceKey then
            local occupancy=item.occupancy or {}
            if finite(tonumber(occupancy.x)) and finite(tonumber(occupancy.z)) then return {x=tonumber(occupancy.x),z=tonumber(occupancy.z)} end
        end
    end
    return nil
end
local function currentPhysicalPrimitivesByReference(snapshot,referenceKey)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(snapshot and snapshot.geometry and snapshot.geometry.shadowPlanViewEvidence or {}) do
        if item.assemblyReferenceKey==referenceKey then
            for _,primitive in OuttaMyWay.ValueRecord.ipairs(item.primitives or {}) do
                if primitive.kind=="DISC" and primitive.positiveConflictSupport==true and finite(tonumber(primitive.x)) and finite(tonumber(primitive.z)) and finite(tonumber(primitive.radius)) then
                    result[#result+1]={x=tonumber(primitive.x),z=tonumber(primitive.z),radius=math.max(0,tonumber(primitive.radius)),identity=primitive.identity}
                end
            end
        end
    end
    return result
end
local function protectedCurrentEvidence(snapshot,protected)
    local centres,primitives={},{}
    for _,item in ipairs(protected or {}) do
        if type(item.referenceKey)~="string" then return nil,nil,"PROTECTED_DEMAND_REFERENCE_UNAVAILABLE" end
        local occupancy=currentOccupancyByReference(snapshot,item.referenceKey)
        if occupancy==nil then return nil,nil,"PROTECTED_DEMAND_CURRENT_OCCUPANCY_UNAVAILABLE:"..tostring(item.assemblyId) end
        centres[#centres+1]=occupancy
        local current=currentPhysicalPrimitivesByReference(snapshot,item.referenceKey)
        if #current==0 then return nil,nil,"PROTECTED_DEMAND_CURRENT_PHYSICAL_OCCUPANCY_UNAVAILABLE:"..tostring(item.assemblyId) end
        for _,primitive in ipairs(current) do primitives[#primitives+1]=primitive end
    end
    if #centres==0 then return nil,nil,"PROTECTED_DEMAND_UNAVAILABLE" end
    local x,z=0,0
    for _,centre in ipairs(centres) do x=x+centre.x; z=z+centre.z end
    return {x=x/#centres,z=z/#centres,count=#centres},primitives,nil
end
local function sweptFootprintClearsStatic(moving,static,dx,dz,progress)
    for _,movingPrimitive in ipairs(moving) do
        local endPoint={x=movingPrimitive.x+dx*progress,z=movingPrimitive.z+dz*progress}
        for _,staticPrimitive in ipairs(static) do
            local distance=pointSegmentDistanceAndPoint(staticPrimitive.x,staticPrimitive.z,{x=movingPrimitive.x,z=movingPrimitive.z},endPoint)
            local required=movingPrimitive.radius+staticPrimitive.radius
            if distance+0.000001<required then
                return false,{movingPrimitiveId=movingPrimitive.identity,protectedPrimitiveId=staticPrimitive.identity,minimumCentreDistanceM=distance,requiredCentreDistanceM=required}
            end
        end
    end
    return true,nil
end
local function translatedFootprintFits(primitives,fieldWorld,dx,dz,progress)
    for _,primitive in ipairs(primitives) do
        if not discFitsFieldWorld(primitive.x+dx*progress,primitive.z+dz*progress,primitive.radius,fieldWorld) then return false end
    end
    return true
end
local function maximumContainedProgress(primitives,fieldWorld,dx,dz,upper)
    if upper<=0 then return 0 end
    if not translatedFootprintFits(primitives,fieldWorld,dx,dz,0) then return nil,"CURRENT_COMPACT_FOOTPRINT_NOT_FIELD_CONTAINED" end
    if translatedFootprintFits(primitives,fieldWorld,dx,dz,upper) then return upper end
    local low,high=0,upper
    for _=1,32 do
        local mid=(low+high)*0.5
        if translatedFootprintFits(primitives,fieldWorld,dx,dz,mid) then low=mid else high=mid end
    end
    return low
end
local function centreSettlementObjective(record,fieldWorld,occupancy,primitives)
    local metrics=fieldWorld and fieldWorld.geometryMetrics or nil
    local cx,cz=metrics and tonumber(metrics.centroidX),metrics and tonumber(metrics.centroidZ)
    if not finite(cx) or not finite(cz) then return nil,"FIELD_WORLD_CENTROID_UNAVAILABLE" end
    local dx,dz=cx-occupancy.x,cz-occupancy.z
    local distance=math.sqrt(dx*dx+dz*dz)
    local dirX,dirZ=0,0
    if distance>0.0001 then dirX,dirZ=dx/distance,dz/distance end
    -- D-0199 Bounded Centroid Settlement: 60 m is a maximum courtesy allowance,
    -- never a minimum prerequisite. Small fields still reach the centroid; larger
    -- fields stop after the bounded progress on the same immutable centroid bearing.
    local configuredCap=tonumber(OuttaMyWay.TERMINAL_INTERIOR_SETTLEMENT_MAX_DISTANCE_M) or 60.0
    local distanceCap=math.max(0,configuredCap)
    local targetProgress=math.min(distance,distanceCap)
    local capped=targetProgress+0.000001<distance
    local targetX,targetZ=occupancy.x+dirX*targetProgress,occupancy.z+dirZ*targetProgress
    return {
        objectiveKind="TERMINAL_INTERIOR_SETTLEMENT",courtesyStage=1,destinationKind=capped and "CENTROID_BEARING_DISTANCE_CAP" or "FIELD_CENTROID",
        alignmentMode="FIXED_INITIAL_CENTRE_BEARING",fieldCentreX=cx,fieldCentreZ=cz,
        initialDistanceToCentreM=distance,infieldDirectionX=dirX,infieldDirectionZ=dirZ,
        retreatDistanceM=targetProgress,targetProgressM=targetProgress,targetX=targetX,targetZ=targetZ,
        maximumCourtesyDistanceM=distanceCap,distanceCapped=capped,physicalPrimitiveCount=#primitives,
        fieldCentreIsDestination=not capped,continuousCourseCorrection=false,settlement="INTERIOR_SETTLEMENT"
    },nil
end
local function boundarySettlementObjective(record,fieldWorld,occupancy,primitives,snapshot,protected)
    local protectedCentre,protectedPrimitives,protectedReason=protectedCurrentEvidence(snapshot,protected)
    if protectedCentre==nil then return nil,"FINAL_BOUNDARY_SETTLEMENT_UNSUPPORTED:"..tostring(protectedReason) end
    local awayX,awayZ=occupancy.x-protectedCentre.x,occupancy.z-protectedCentre.z
    local awayLength=math.sqrt(awayX*awayX+awayZ*awayZ)
    if awayLength<=0.0001 then return nil,"FINAL_BOUNDARY_SETTLEMENT_UNSUPPORTED:PROTECTED_DEMAND_AWAY_BEARING_UNRESOLVED" end
    local dirX,dirZ=awayX/awayLength,awayZ/awayLength
    local boundaryDistance,bx,bz=forwardBoundaryPoint(occupancy.x,occupancy.z,dirX,dirZ,fieldWorld and fieldWorld.boundary or {})
    if boundaryDistance==nil or not finite(bx) or not finite(bz) then return nil,"OUTER_FIELD_BOUNDARY_UNAVAILABLE_ON_PROTECTED_AWAY_BEARING" end
    local progress,reason=maximumContainedProgress(primitives,fieldWorld,dirX,dirZ,boundaryDistance)
    if progress==nil then return nil,"FINAL_BOUNDARY_SETTLEMENT_UNSUPPORTED:"..tostring(reason) end
    local clear,clearanceEvidence=sweptFootprintClearsStatic(primitives,protectedPrimitives,dirX,dirZ,progress)
    if clear~=true then return nil,"FINAL_BOUNDARY_SETTLEMENT_UNSUPPORTED:PROTECTED_OCCUPANCY_TRANSITION_NOT_CLEAR" end
    return {
        objectiveKind="TERMINAL_FINAL_BOUNDARY_SETTLEMENT",courtesyStage=2,destinationKind="OUTER_BOUNDARY_AWAY_FROM_PROTECTED_DEMAND",
        alignmentMode="FIXED_INITIAL_AWAY_FROM_PROTECTED_DEMAND_BEARING",boundaryPointX=bx,boundaryPointZ=bz,
        initialDistanceToBoundaryM=boundaryDistance,infieldDirectionX=dirX,infieldDirectionZ=dirZ,
        retreatDistanceM=progress,targetProgressM=progress,targetX=occupancy.x+dirX*progress,targetZ=occupancy.z+dirZ*progress,
        physicalPrimitiveCount=#primitives,protectedDemandCount=protectedCentre.count,protectedPhysicalPrimitiveCount=#protectedPrimitives,
        protectedCentroidX=protectedCentre.x,protectedCentroidZ=protectedCentre.z,boundaryContainmentSupported=true,
        protectedOccupancyTransitionClearanceSupported=true,transitionClearanceEvidence=clearanceEvidence,continuousCourseCorrection=false,
        settlement="FINAL_BOUNDARY_SETTLEMENT"
    },nil
end
local function infieldObjective(record,fieldWorld,snapshot,protected)
    local occupancy=record.currentSpace and record.currentSpace.occupancy or nil
    if occupancy==nil or not finite(occupancy.x) or not finite(occupancy.z) then return nil,"TERMINAL_CENTRE_UNAVAILABLE" end
    local primitives=footprintPrimitives(record)
    if #primitives==0 then return nil,"POSITIVE_TERMINAL_FOOTPRINT_UNAVAILABLE" end
    local completed=tonumber(record.courtesyMoveCount) or 0
    if completed<=0 then return centreSettlementObjective(record,fieldWorld,occupancy,primitives) end
    if completed==1 then return boundarySettlementObjective(record,fieldWorld,occupancy,primitives,snapshot,protected) end
    return {objectiveKind="TERMINAL_COURTESY_EXHAUSTED",courtesyStage=3,courtesyExhausted=true},nil
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
    constraints.FIELD_WORLD_CONTAINMENT=courtesyExemption("D-0147 Courtesy Constraint Exception: player-consented buy-time movement is exempt from generic predictive full-sweep Field World containment proof; the fixed courtesy bearing is not route-planned containment evidence",{objective=objective,specialCase="D0147_COURTESY_CONSTRAINT_EXCEPTION",predictiveContainmentClaim=false,routePlanning=false,continuousCourseCorrection=false})
    local stageTwoClearance=objective~=nil and tonumber(objective.courtesyStage)==2 and objective.protectedOccupancyTransitionClearanceSupported==true
    if stageTwoClearance then
        constraints.TRANSITION_CLEARANCE=packet("D-0196 Final Boundary Settlement is admitted only when the one deterministic straight translation is continuously clear of the authorising productive worker's current positive physical occupancy",{currentProtectedOccupancyProof=true,protectedDemandCount=objective.protectedDemandCount,protectedPhysicalPrimitiveCount=objective.protectedPhysicalPrimitiveCount,negativeFutureClearanceAuthority=false,parking=false,routePlanning=false})
    else
        constraints.TRANSITION_CLEARANCE=courtesyExemption("D-0147 Interior Settlement remains exempt from generic predictive complete-envelope Transition Clearance proof; no future-demand exclusion map, parking search or permanent-clearance claim is made",{specialCase="D0147_COURTESY_CONSTRAINT_EXCEPTION",predictiveTransitionClearanceClaim=false,negativeFutureClearanceAuthority=false,parking=false,routePlanning=false})
    end
    constraints.REPRESENTATION_FITNESS=packet("The current completed-assembly represented footprint positively supports Terminal Occupancy and the current terminal centre needed to derive one fixed Infield Alignment",{representationId=record.representationId})
    constraints.CONTROL_CAPABILITY_AVAILABILITY=packet("TerminalEgressControl reuses supported compaction, Vehicle Activity Context and forward-only driveInDirection actuation; the existing Regulation lease substrate provides a zero-speed Protected Yield hold for the authorising productive assembly/assemblies during translation",{controlModule="TerminalEgressControl",postJobActuation=true,protectedYieldHold=true,holdActuator="REGULATE_SPEED_0",moveForwards=true,playerClaimWitness="vehicle:getIsEntered()"})
    constraints.CONTINUING_INTENT_PRIORITY=packet("The completed assembly moves while the active assembly/assemblies whose conflict authorised D-0147 retain their GIANTS jobs but are temporarily held for the translational Protected Yield Interval",{terminalAssemblyId=record.assemblyId,activeDemandAssemblyIds=record.obstructedDemandAssemblyIds,protectedDemandAssemblies=protected,productiveJobsRemainGiantsOwned=true})
    constraints.PROGRESS_PRESERVATION=packet("The subject has no productive progress to preserve; the double courtesy exists only to restore current continuation without searching for permanent safe parking",{productiveJobEnded=true,parking=false,doubleCourtesy=true})
    constraints.RESPONSIBILITY_COMPATIBILITY=packet("The Terminal Occupancy obligation belongs independently to this completed assembly; unrelated completed assemblies remain constraints rather than transitive relocation authority",{terminalEpisodeId=record.terminalEpisodeId})
    constraints.OBLIGATION_COMPATIBILITY=packet("The moved completed Job Episode owns a two-move courtesy budget. The first obstruction permits Interior Settlement; after Continuation Renewal, any later active worker positively blocked by the same completed assembly may permit Final Boundary Settlement; no third automatic relocation exists",{oneMovePerCommitment=true,repeatRequiresContinuationRenewal=true,repeatBlockerIdentityBound=false,courtesyBudgetOwner="MOVED_COMPLETED_JOB_EPISODE",maximumCourtesyMovesPerEpisode=2,terminalResolutionCommitment=true})
    constraints.COMMITMENT_PRECONDITIONS=packet("Job Episode ended by authoritative source-intent termination; positive Terminal Occupancy was admitted or is already committed; consent is enabled and Player Claim is absent",{automaticTerminalEgress=OuttaMyWay.AUTOMATIC_TERMINAL_EGRESS==true,playerClaimed=false,terminalResolutionCommitted=record.existingCommitmentId~=nil or record.obstructionPositive==true})
    constraints.EFFECTIVE_ACTUATION_COMPOSITION=packet("One D-0147 Commitment owns POST_JOB_ACTUATION for the completed assembly and bounded PROGRESS_ACTUATION only for zero-speed protection of the authorising productive assembly/assemblies",{terminalAssemblyId=record.assemblyId,postJobAuthorityClass="POST_JOB_ACTUATION",protectedDemandAssemblies=protected,progressAuthorityClass="PROGRESS_ACTUATION",effectClass="HOLD"})
    constraints.SAFE_RELEASE_HANDOVER=packet("Player Claim/source reactivation ends terminal authority immediately. Every Protected Yield exit releases its zero-speed productive hold; owned completion/failure positively neutralises terminal actuation before Vehicle Activity Context and all D-0147 authority are released",{playerClaimSticky=true,actuationNeutralisation=true,protectedYieldHoldRelease=true,maximumCourtesyMovesPerEpisode=2})
    local requirement="terminal-occupancy:"..record.terminalEpisodeId
    local protectedIds={}; local relevantIds={record.assemblyId}; local compositionEntries={{assemblyId=record.assemblyId,commitmentId="$NEW_COMMITMENT",capability="REPOSITION",effectClass="TERMINAL_YIELD",postJobActuation=true}}
    for _,item in ipairs(protected or {}) do
        protectedIds[#protectedIds+1]=item.assemblyId; relevantIds[#relevantIds+1]=item.assemblyId
        compositionEntries[#compositionEntries+1]={assemblyId=item.assemblyId,commitmentId="$NEW_COMMITMENT",capability="REGULATE_SPEED",effectClass="HOLD",progressActuation=true}
    end
    return {
        referenceKey="d0147-terminal-yield:"..record.terminalEpisodeId..":"..phase,
        purpose={kind="D0147_TWO_STAGE_TERMINAL_COURTESY",result="BUY_PLAYER_RECLAMATION_TIME_BY_RESTORING_CURRENT_CONTINUATION"},subject={assemblyId=record.assemblyId},capability="REPOSITION",
        expectedEffect={physicalChange=true,phase=phase,mandatoryCompaction=true,terminalCourtesyMovement=phase=="INFIELD",courtesyStage=objective and objective.courtesyStage or nil,oneFixedAlignment=true,parking=false},
        evidenceBasis={constraintEvidence=constraints,courtesyConstraintException={kind="D0147_COURTESY_CONSTRAINT_EXCEPTION",exemptMandatoryConstraintIds=stageTwoClearance and {"FIELD_WORLD_CONTAINMENT"} or {"FIELD_WORLD_CONTAINMENT","TRANSITION_CLEARANCE"},scope="PLAYER_CONSENTED_BOUNDED_BUY_TIME_MOVEMENT_ONLY"},governingBasis={kind="TERMINAL_OCCUPANCY",responsibilityKey=requirement,terminalEpisodeId=record.terminalEpisodeId,operationIds=picture.identities.operations.active,sourceIntentIds=picture.identities.jobEpisodes.active,authorizingDemandAssemblyIds=protectedIds},progressActuationOwnership={assemblyIds=protectedIds},postJobActuationOwnership={assemblyIds={record.assemblyId}},effectiveActuationComposition={identity="d0147-composition:"..record.terminalEpisodeId..":"..picture.identity,epoch=picture.epoch,relevantAssemblyIds=relevantIds,entries=compositionEntries},maintainsExistingCommitment=record.existingCommitmentId~=nil,terminalEgressBridge={architecture="D0147",phase=phase,terminalEpisodeId=record.terminalEpisodeId,assemblyId=record.assemblyId,assemblyReferenceKey=record.assemblyReferenceKey,objective=objective,objectiveReason=objectiveReason,configurationEvidence=record.configurationEvidence,existingCommitmentId=record.existingCommitmentId,protectedDemandAssemblies=protected}},
        representationFitness={requirements={{representationId=record.representationId,acceptedStates={"FIT_FOR_LIMITED_HORIZON","CURRENTLY_FIT"}}}},
        preconditions={evidenceContracts={{kind=record.existingCommitmentId~=nil and "D0147_TERMINAL_RESOLUTION_COMMITTED" or "D0147_POSITIVE_TERMINAL_OCCUPANCY_ADMISSION",terminalEpisodeId=record.terminalEpisodeId},{kind="PLAYER_CLAIM_ABSENT"}}},
        invalidationConditions={{kind="PLAYER_CLAIM"},{kind="SOURCE_INTENT_REACTIVATES"}},reversibility={kind="ONE_COURTESY_MOVE_THEN_REASSESS"},
        obligationsCreated={{origin={kind="TERMINAL_OCCUPANCY",terminalEpisodeId=record.terminalEpisodeId},basis={kind="D0147_POSITIVE_OBSTRUCTION",obstructedDemandAssemblyIds=record.obstructedDemandAssemblyIds},requiredOutcome={kind="CURRENT_TERMINAL_CONFLICT_YIELDED_OR_ESCALATED"},requiredAuthority={classes={"POST_JOB_ACTUATION","PROGRESS_ACTUATION"}},evidenceContract={kind="TWO_STAGE_TERMINAL_COURTESY_OR_PLAYER_CLAIM_OR_EXHAUSTION"},ownershipClass="ORIGIN_BOUND",transferPolicy={allowed=false},terminalDependency=true,creationEvidence={obstructionEvidence=record.obstructionEvidence}}},
        releaseImplications={releasePostJobAuthorityOnTerminal=true,laterRetryRequiresContinuationRenewal=true,maximumCourtesyMovesPerEpisode=2},uncertainty={{kind="CRUDE_INFIELD_ARC_NOT_GLOBALLY_PATH_PLANNED"}},comparisonCost=1
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
        local protected=protectedDemandAssemblies(record,context,snapshot)
        local objective,objectiveReason=nil,nil
        if config.retainCurrent==true or config.allFolded==true then phase="INFIELD"; objective,objectiveReason=infieldObjective(record,snapshot.fieldWorld,snapshot,protected) end
        specification=physicalSpec(picture,record,phase,objective,objectiveReason,protected)
    end
    local values=OuttaMyWay.ValueRecord.toTable(picture); local pictureId=self.identities:issue("PICTURE")
    values.identity=pictureId; values.epoch=self.epochs:next(); values.provenance={source="TerminalEgressCandidateSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity,authority="D0147_BOUNDED_INFIELD_RETREAT"}
    values.candidateSupportEvidence={complete=true,supportBoundary={mode="D0147_BOUNDED_TERMINAL_EGRESS",supportedCandidateClasses={specification.capability},physicalCapabilitiesImplemented=true,controlAuthority="D0147_POST_JOB_PLUS_PROTECTED_YIELD_HOLD",boundedScope="ONE_COMPLETED_ASSEMBLY_MAX_TWO_FIXED_DIRECTION_COURTESY_MOVES_INTERIOR_THEN_PROTECTED_AWAY_BOUNDARY_WITH_CURRENT_OCCUPANCY_CLEARANCE",automaticTerminalEgress=true},candidateSpecifications={specification},provenance={source="TerminalEgressCandidateSupport",observationSnapshotId=snapshot.identity}}
    self.publishedCount=self.publishedCount+1; self.lastStatus="D0147_"..tostring(specification.capability).."_PUBLISHED"
    return OuttaMyWay.OperationalPicture.new(values)
end
function Support:getPublishedCount() return self.publishedCount end
function Support:getLastStatus() return self.lastStatus end
