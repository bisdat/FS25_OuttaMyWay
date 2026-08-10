-- D-0141 aligned Follower Boundary-Demand assessment.
--
-- Situation Knowledge only.  This module separates:
--   1. current Adjacent Following topology;
--   2. a Representation-Fit Provisional Demand Seed;
--   3. Action-Space Compression / current Control magnitude evidence.
--
-- It grants no Decision or Control authority.  In particular, historical
-- Native Manoeuvre observations are not consumed here while their boundary-
-- demand Representation Fitness remains UNRESOLVED.

OuttaMyWay.FollowerBoundaryDemandAssessment = {}
local Assessment=OuttaMyWay.FollowerBoundaryDemandAssessment

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function clamp(value,low,high)
    if value<low then return low end
    if value>high then return high end
    return value
end

local function pairKey(leaderAssemblyId,followerAssemblyId)
    return tostring(leaderAssemblyId).."|"..tostring(followerAssemblyId)
end
Assessment.pairKey=pairKey

local function positiveProductive(worker)
    return worker~=nil and worker.productivePositive==true and worker.settledContinuation==true
end

local function completeCurrentTopology(worker)
    return worker~=nil and finite(worker.x) and finite(worker.z) and finite(worker.dx) and finite(worker.dz)
        and finite(worker.boundaryDistanceM) and finite(worker.workingWidthM) and worker.workingWidthM>0
end

local function currentRelationship(leader,follower,minHeadingDot)
    if not positiveProductive(leader) or not positiveProductive(follower) then
        return {status="UNRESOLVED",reason="CURRENT_PRODUCTIVE_SETTLED_CONTINUATIONS_UNRESOLVED"}
    end
    if not completeCurrentTopology(leader) or not completeCurrentTopology(follower) then
        return {status="UNRESOLVED",reason="CURRENT_FOLLOWING_TOPOLOGY_EVIDENCE_INCOMPLETE"}
    end
    local dot=leader.dx*follower.dx+leader.dz*follower.dz
    local rx,rz=follower.x-leader.x,follower.z-leader.z
    local forward=rx*leader.dx+rz*leader.dz
    local lateral=rx*(-leader.dz)+rz*leader.dx
    local corridorHalfWidth=0.5*(leader.workingWidthM+follower.workingWidthM)
    local corridorOverlap=math.abs(lateral)<=corridorHalfWidth
    if dot<(minHeadingDot or 0.99) then
        return {status="NEGATIVE",reason="CURRENT_PRODUCTIVE_CONTINUATIONS_NOT_COHERENTLY_CO_DIRECTIONAL",headingDot=dot,leaderToFollowerForwardM=forward,lateralOffsetM=lateral,corridorHalfWidthM=corridorHalfWidth,corridorOverlap=corridorOverlap}
    end
    if forward>=0 then
        return {status="NEGATIVE",reason="CURRENT_ORDERING_IS_NOT_LEADER_THEN_FOLLOWER",headingDot=dot,leaderToFollowerForwardM=forward,lateralOffsetM=lateral,corridorHalfWidthM=corridorHalfWidth,corridorOverlap=corridorOverlap}
    end
    if not corridorOverlap then
        return {status="NEGATIVE",reason="CURRENT_PRODUCTIVE_WORK_CORRIDORS_DO_NOT_OVERLAP",headingDot=dot,leaderToFollowerForwardM=forward,lateralOffsetM=lateral,corridorHalfWidthM=corridorHalfWidth,corridorOverlap=false}
    end
    return {status="POSITIVE",reason="CURRENT_COHERENT_LINE_ASTERN_PRODUCTIVE_TOPOLOGY",headingDot=dot,leaderToFollowerForwardM=forward,lateralOffsetM=lateral,corridorHalfWidthM=corridorHalfWidth,corridorOverlap=true}
end
Assessment.currentRelationship=currentRelationship

local function provisionalDemandSeed(leader,follower,durationSec)
    if not finite(leader.workingWidthM) or leader.workingWidthM<=0 or not finite(follower.workingWidthM) or follower.workingWidthM<=0 then
        return {status="UNRESOLVED",reason="WORKING_WIDTH_SEED_UNAVAILABLE",representationFitness="UNRESOLVED"}
    end
    local duration=tonumber(durationSec)
    if not finite(duration) or duration<=0 then
        return {status="UNRESOLVED",reason="PROVISIONAL_TEMPORAL_SEED_UNAVAILABLE",representationFitness="UNRESOLVED"}
    end
    return {
        status="SUPPORTED",
        kind="PROVISIONAL_DEMAND_SEED",
        leaderEntryBoundaryDistanceM=leader.workingWidthM,
        followerEntryBoundaryDistanceM=follower.workingWidthM,
        durationSec=duration,
        spatialSeedSource="OBSERVED_GIANTS_WORKING_WIDTH",
        temporalSeedSource="BOUNDED_TEST_LITERAL_PENDING_REPRESENTATION_REFINEMENT",
        representationFitness="USABLE_WITH_UNCERTAINTY",
        uncertainty={"SPATIAL_SEED_IS_WORKING_WIDTH_NOT_ASSEMBLY_FOOTPRINT","TEMPORAL_SEED_IS_TEST_MECHANIC_NOT_NATIVE_ROUTE_PREDICTION"}
    }
end
Assessment.provisionalDemandSeed=provisionalDemandSeed

local function positiveNativeForwardRate(worker)
    if worker==nil or worker.nativeCommandValid~=true or worker.nativeZeroCommand==true or worker.nativeMoveForwards~=true then return nil end
    local rate=tonumber(worker.nativeMaxSpeedKmh)
    if not finite(rate) or rate<=0 then return nil end
    return rate
end

local function followerNativeRate(follower)
    if follower.nativeZeroCommand==true then return nil,"FOLLOWER_NATIVE_ZERO_COMMAND_HAS_NO_RATE_AUTHORITY" end
    local native=follower.nativeCommandValid==true and follower.nativeMoveForwards~=false and tonumber(follower.nativeMaxSpeedKmh) or nil
    if not finite(native) or native<0 then return nil,"FOLLOWER_UNRESTRICTED_NATIVE_COMMAND_RATE_UNRESOLVED" end
    return native,nil
end

local function applyClearanceFactor(native,unscaledCap,factor)
    local epsilon=0.05
    local f=tonumber(factor) or 1.0
    if not finite(f) or f<=0 or f>1 then f=1.0 end
    local cap=math.max(0,tonumber(unscaledCap) or 0)
    -- The factor is a clearance margin, not admission authority. Only apply it
    -- after the unscaled calculation is already restrictive.
    if native>cap+epsilon then return cap*f,true end
    return cap,false
end
Assessment.applyClearanceFactor=applyClearanceFactor

local function magnitude(leader,follower,seed,clearanceFactor)
    if seed==nil or seed.status~="SUPPORTED" then return {status="UNRESOLVED",reason="DEMAND_SEED_UNRESOLVED"} end
    local leaderObservedSpeed=tonumber(leader.progressSpeedKmh)
    if not finite(leaderObservedSpeed) or leaderObservedSpeed<=0 then return {status="UNRESOLVED",reason="LEADER_CURRENT_PROGRESS_RATE_UNRESOLVED"} end
    -- The immediate GIANTS command rate is pre-OuttaMyWay and may reveal an
    -- imminent native deceleration before vehicle speed has physically caught up.
    -- Zero-command remains ambiguous and therefore never contributes a zero rate.
    local leaderNativeRate=positiveNativeForwardRate(leader)
    local leaderSpeed=leaderNativeRate~=nil and math.min(leaderObservedSpeed,leaderNativeRate) or leaderObservedSpeed
    local native,nativeReason=followerNativeRate(follower)
    if native==nil then return {status="UNRESOLVED",reason=nativeReason} end

    local leaderApproachM=math.max(0,leader.boundaryDistanceM-seed.leaderEntryBoundaryDistanceM)
    local followerApproachM=math.max(0,follower.boundaryDistanceM-seed.followerEntryBoundaryDistanceM)
    local timeToLeaderDemandSec=leaderApproachM/(leaderSpeed/3.6)
    local requiredPreservationSec=timeToLeaderDemandSec+seed.durationSec
    if not finite(requiredPreservationSec) or requiredPreservationSec<=0 then return {status="UNRESOLVED",reason="PRESERVATION_HORIZON_UNRESOLVED"} end
    local safeKmh=(followerApproachM/requiredPreservationSec)*3.6
    if not finite(safeKmh) then return {status="UNRESOLVED",reason="SAFE_CAP_UNRESOLVED"} end
    safeKmh=math.max(0,safeKmh)
    -- Never let the follower's bounded rate exceed a positive GIANTS-native
    -- leader command once that command has already slowed below the timing cap.
    -- This catches GIANTS' pre-turn 25 -> low-speed deceleration directly.
    -- The bounded clearance factor is applied below only if the unscaled result
    -- is already restrictive.
    if leaderNativeRate~=nil then safeKmh=math.min(safeKmh,leaderNativeRate) end
    if leaderApproachM<=0 and finite(leaderObservedSpeed) and leaderObservedSpeed>=0 then safeKmh=math.min(safeKmh,leaderObservedSpeed) end
    local unscaledSafeKmh=safeKmh
    local factoredSafeKmh,factorApplied=applyClearanceFactor(native,unscaledSafeKmh,clearanceFactor)
    local appliedKmh=math.min(native,factoredSafeKmh)
    local epsilon=0.05
    local regulationRequired=native>unscaledSafeKmh+epsilon
    return {
        status="SUPPORTED",
        regulationRequired=regulationRequired,
        nativeUnrestrictedFollowerKmh=native,
        maxAdmissibleFollowerKmh=factoredSafeKmh,
        unscaledMaxAdmissibleFollowerKmh=unscaledSafeKmh,
        clearanceFactor=tonumber(clearanceFactor) or 1.0,
        clearanceFactorApplied=factorApplied,
        requestedFollowerCapKmh=appliedKmh,
        leaderObservedProgressKmh=leaderObservedSpeed,
        leaderNativeCommandKmh=leaderNativeRate,
        leaderRateUsedKmh=leaderSpeed,
        leaderApproachToSeedM=leaderApproachM,
        followerApproachToSeedM=followerApproachM,
        timeToLeaderDemandSec=timeToLeaderDemandSec,
        requiredPreservationSec=requiredPreservationSec,
        reason=regulationRequired and "UNRESTRICTED_NATIVE_FOLLOWER_PROGRESSION_WOULD_MATURE_BEFORE_PROVISIONAL_LEADER_DEMAND_VACATES" or "NATIVE_FOLLOWER_PROGRESSION_CURRENTLY_PRESERVES_PROVISIONAL_DEMAND_ORDERING"
    }
end
Assessment.magnitude=magnitude

-- Once a follower-protection purpose already exists, a leader entering GIANTS'
-- native transition must not leave the follower running at the last Productive
-- cap.  Use the leader's positive immediate native transition rate as a temporary
-- ceiling.  A positive reverse command stops follower progression; a zero/default
-- command remains UNRESOLVED and preserves the previous lease unchanged.
local function transitionPreservationMagnitude(leader,follower,clearanceFactor)
    local native,nativeReason=followerNativeRate(follower)
    if native==nil then return {status="UNRESOLVED",reason=nativeReason} end

    -- A positive reverse command is direct evidence that forward follower
    -- progression must stop while the already-admitted purpose remains live.
    if leader.nativeCommandValid==true and leader.nativeZeroCommand~=true and leader.nativeMoveForwards==false then
        return {
            status="SUPPORTED",regulationRequired=native>0.05,nativeUnrestrictedFollowerKmh=native,
            maxAdmissibleFollowerKmh=0,requestedFollowerCapKmh=0,leaderNativeCommandKmh=tonumber(leader.nativeMaxSpeedKmh),
            leaderObservedProgressKmh=tonumber(leader.progressSpeedKmh),leaderRateUsedKmh=0,transitionPreservation=true,
            reason="LEADER_NATIVE_REVERSE_COMMAND_REQUIRES_FOLLOWER_STOP"
        }
    end

    local leaderNativeRate=positiveNativeForwardRate(leader)
    local observed=tonumber(leader.progressSpeedKmh)
    if not finite(observed) or observed<0 then observed=nil end
    local leaderRate=nil
    if leaderNativeRate~=nil and observed~=nil then leaderRate=math.min(leaderNativeRate,observed)
    elseif leaderNativeRate~=nil then leaderRate=leaderNativeRate
    elseif observed~=nil then leaderRate=observed end
    if leaderRate==nil then return {status="UNRESOLVED",reason="LEADER_TRANSITION_PROGRESS_RATE_UNRESOLVED"} end
    local unscaledCap=math.min(native,math.max(0,leaderRate))
    local cap,factorApplied=applyClearanceFactor(native,unscaledCap,clearanceFactor)
    return {
        status="SUPPORTED",regulationRequired=native>unscaledCap+0.05,nativeUnrestrictedFollowerKmh=native,
        maxAdmissibleFollowerKmh=cap,unscaledMaxAdmissibleFollowerKmh=unscaledCap,
        clearanceFactor=tonumber(clearanceFactor) or 1.0,clearanceFactorApplied=factorApplied,
        requestedFollowerCapKmh=cap,leaderNativeCommandKmh=leaderNativeRate,
        leaderObservedProgressKmh=observed,leaderRateUsedKmh=leaderRate,transitionPreservation=true,
        reason="EXISTING_FOLLOWER_PURPOSE_BOUNDED_BY_LEADER_TRANSITION_PROGRESS_RATE"
    }
end
Assessment.transitionPreservationMagnitude=transitionPreservationMagnitude

local function applyEstablishedPurposeRetention(relation,options)
    if type(relation)~="table" or relation.status~="NEGATIVE" then return relation end
    if relation.reason=="CURRENT_PRODUCTIVE_WORK_CORRIDORS_DO_NOT_OVERLAP" then
        local margin=tonumber(options.establishedLateralRetentionM) or 1.0
        local lateral=math.abs(tonumber(relation.lateralOffsetM) or math.huge)
        local half=tonumber(relation.corridorHalfWidthM) or -math.huge
        if lateral<=half+margin then
            relation.status="UNRESOLVED"
            relation.reason="ESTABLISHED_FOLLOWER_CORRIDOR_WITHIN_RETENTION_MARGIN"
            relation.establishedRetentionMarginM=margin
            return relation
        end
    elseif relation.reason=="CURRENT_PRODUCTIVE_CONTINUATIONS_NOT_COHERENTLY_CO_DIRECTIONAL" then
        local retainDot=tonumber(options.establishedAlignmentMinDot) or 0.95
        local opposedDot=tonumber(options.establishedOpposedSuccessionMaxDot) or -0.95
        if finite(relation.headingDot) and relation.headingDot>=retainDot then
            relation.status="UNRESOLVED"
            relation.reason="ESTABLISHED_FOLLOWER_ALIGNMENT_WITHIN_RETENTION_BAND"
            relation.establishedRetentionMinDot=retainDot
            return relation
        elseif finite(relation.headingDot) and relation.headingDot<=opposedDot then
            -- D-0130 already established that clean opposed continuation can be
            -- strategy succession rather than positive retirement. Preserve the
            -- admitted purpose until a stronger lifecycle witness (notably the
            -- existing Progress Passage event) retires it.
            relation.status="UNRESOLVED"
            relation.reason="ESTABLISHED_PURPOSE_PRESERVED_THROUGH_OPPOSED_CONTINUATION"
            relation.establishedOpposedSuccessionMaxDot=opposedDot
            return relation
        end
    end
    return relation
end

-- Evaluate one ordered pair. existingPurpose means Commitment already owns the
-- follower-protection obligation.  A temporary loss of current Productive
-- evidence is UNRESOLVED and therefore cannot retire that purpose.
function Assessment.evaluatePair(leader,follower,options)
    options=options or {}
    local existingPurpose=options.existingPurpose==true
    local passage=options.progressPassage==true
    local clearanceFactor=options.clearanceFactor or OuttaMyWay.FOLLOWER_BOUNDARY_TRANSITION_CLEARANCE_FACTOR or 0.90
    local relation=currentRelationship(leader,follower,options.minHeadingDot or 0.99)
    if existingPurpose then relation=applyEstablishedPurposeRetention(relation,options) end

    if existingPurpose and passage then
        return {
            pairKey=pairKey(leader.assemblyId,follower.assemblyId),leaderAssemblyId=leader.assemblyId,followerAssemblyId=follower.assemblyId,
            status="RETIRE_SUPPORTED",purposeState="RETIRE",reason="PROGRESS_PASSAGE_SUPERSEDES_FOLLOWER_BOUNDARY_PROTECTION",
            relationship=relation,representationFitness="CURRENTLY_FIT",governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING"
        }
    end

    -- During the already-admitted P22 outbound refuge manoeuvre, do not let the
    -- elastic follower magnitude relax upward merely because the Yield worker's
    -- productive/native evidence has changed under OuttaMyWay Control. Preserve
    -- the last admitted D-0141 lease unchanged until the existing compact-Refuge
    -- Progress Passage witness retires it. This is lease continuity, not a new
    -- egress controller or speed policy.
    if existingPurpose and options.headOnOutboundEgress==true then
        return {
            pairKey=pairKey(leader.assemblyId,follower.assemblyId),leaderAssemblyId=leader.assemblyId,followerAssemblyId=follower.assemblyId,
            status="UNRESOLVED",purposeState="PERSIST_UNRESOLVED",reason="ESTABLISHED_FOLLOWER_LEASE_PRESERVED_DURING_HEAD_ON_OUTBOUND_EGRESS",
            relationship=relation,representationFitness="UNRESOLVED",governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING",
            outboundEgress=true,outboundEgressPhase=options.headOnOutboundEgressPhase
        }
    end

    -- Once GIANTS positively enters a native turn, the previously established
    -- line-astern heading/corridor test is no longer a valid retirement test for
    -- that same purpose. Keep updating the existing lease from the leader's
    -- current transition rate until the turn ends or a stronger lifecycle event
    -- (for example Progress Passage) retires it.
    if existingPurpose and leader.turning==true then
        local transitionMagnitude=transitionPreservationMagnitude(leader,follower,clearanceFactor)
        if transitionMagnitude.status=="SUPPORTED" then
            return {
                pairKey=pairKey(leader.assemblyId,follower.assemblyId),leaderAssemblyId=leader.assemblyId,followerAssemblyId=follower.assemblyId,
                status="REGULATE_SUPPORTED",purposeState="PERSIST",reason=transitionMagnitude.reason,
                relationship=relation,controlMagnitude=transitionMagnitude,transitionPreservation=true,
                representationFitness="USABLE_WITH_UNCERTAINTY",governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING",
                provenance={source="FollowerBoundaryDemandAssessment",layer="KNOWLEDGE",historicalNativeManoeuvreAuthority=false}
            }
        end
    end

    if relation.status=="NEGATIVE" then
        return {
            pairKey=pairKey(leader.assemblyId,follower.assemblyId),leaderAssemblyId=leader.assemblyId,followerAssemblyId=follower.assemblyId,
            status=existingPurpose and "RETIRE_SUPPORTED" or "NOT_APPLICABLE",purposeState=existingPurpose and "RETIRE" or "NONE",reason=relation.reason,
            relationship=relation,representationFitness="CURRENTLY_FIT",governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING"
        }
    elseif relation.status~="POSITIVE" then
        if existingPurpose and relation.reason=="CURRENT_PRODUCTIVE_SETTLED_CONTINUATIONS_UNRESOLVED" then
            local transitionMagnitude=transitionPreservationMagnitude(leader,follower,clearanceFactor)
            if transitionMagnitude.status=="SUPPORTED" then
                return {
                    pairKey=pairKey(leader.assemblyId,follower.assemblyId),leaderAssemblyId=leader.assemblyId,followerAssemblyId=follower.assemblyId,
                    status="REGULATE_SUPPORTED",purposeState="PERSIST",reason=transitionMagnitude.reason,
                    relationship=relation,controlMagnitude=transitionMagnitude,transitionPreservation=true,
                    representationFitness="USABLE_WITH_UNCERTAINTY",governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING",
                    provenance={source="FollowerBoundaryDemandAssessment",layer="KNOWLEDGE",historicalNativeManoeuvreAuthority=false}
                }
            end
        end
        return {
            pairKey=pairKey(leader.assemblyId,follower.assemblyId),leaderAssemblyId=leader.assemblyId,followerAssemblyId=follower.assemblyId,
            status="UNRESOLVED",purposeState=existingPurpose and "PERSIST_UNRESOLVED" or "NONE",reason=relation.reason,
            relationship=relation,representationFitness="UNRESOLVED",governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING"
        }
    end

    local seed=provisionalDemandSeed(leader,follower,options.provisionalDurationSec or 13.0)
    local controlMagnitude=magnitude(leader,follower,seed,clearanceFactor)
    if controlMagnitude.status~="SUPPORTED" then
        return {
            pairKey=pairKey(leader.assemblyId,follower.assemblyId),leaderAssemblyId=leader.assemblyId,followerAssemblyId=follower.assemblyId,
            status="UNRESOLVED",purposeState=existingPurpose and "PERSIST_UNRESOLVED" or "NONE",reason=controlMagnitude.reason,
            relationship=relation,demandSeed=seed,controlMagnitude=controlMagnitude,representationFitness=seed.representationFitness or "UNRESOLVED",
            governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING"
        }
    end

    local admit=controlMagnitude.regulationRequired==true
    local purposeState=existingPurpose and "PERSIST" or (admit and "ADMIT" or "NONE")
    local status=admit and "REGULATE_SUPPORTED" or "OBSERVE_SUPPORTED"
    if existingPurpose then status="REGULATE_SUPPORTED" end -- sticky purpose; magnitude may equal native speed.
    return {
        pairKey=pairKey(leader.assemblyId,follower.assemblyId),leaderAssemblyId=leader.assemblyId,followerAssemblyId=follower.assemblyId,
        status=status,purposeState=purposeState,reason=controlMagnitude.reason,
        relationship=relation,demandSeed=seed,controlMagnitude=controlMagnitude,
        representationFitness="USABLE_WITH_UNCERTAINTY",governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING",
        provenance={source="FollowerBoundaryDemandAssessment",layer="KNOWLEDGE",historicalNativeManoeuvreAuthority=false}
    }
end


local function byAssembly(values)
    local out={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if item.assemblyId~=nil then out[item.assemblyId]=item end
    end
    return out
end

local function productiveMap(values)
    local out={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do out[item.assemblyId]=item end
    return out
end

local function futureMap(values)
    local out={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        local alt=item.alternatives and item.alternatives[1] or nil
        if type(alt)=="table" and alt.kind=="FIELD_WORLD_BOUNDED_LOCAL_CONTINUATION" then out[item.assemblyId]=alt end
    end
    return out
end

local function activePurposeMap(commitmentContext)
    local out={}
    for _,context in OuttaMyWay.ValueRecord.ipairs(commitmentContext or {}) do
        for _,obligation in OuttaMyWay.ValueRecord.ipairs(context.openObligations or {}) do
            local basis=obligation.basis
            local outcome=obligation.requiredOutcome
            if type(basis)=="table" and basis.kind=="FOLLOWER_BOUNDARY_PROTECTION"
                and type(basis.leaderAssemblyId)=="string" and type(basis.followerAssemblyId)=="string"
                and type(outcome)=="table" and outcome.kind=="FOLLOWER_BOUNDARY_ORDERING_PRESERVED_UNTIL_POSITIVE_RETIREMENT" then
                out[pairKey(basis.leaderAssemblyId,basis.followerAssemblyId)]={
                    commitmentId=context.commitmentId,obligationId=obligation.identity,
                    leaderAssemblyId=basis.leaderAssemblyId,followerAssemblyId=basis.followerAssemblyId,
                    leaderReferenceKey=basis.leaderReferenceKey,followerReferenceKey=basis.followerReferenceKey
                }
            end
        end
    end
    return out
end

local function relocationPhaseMaps(controlOutcomes,assemblyIdForReference)
    local passage,outbound={},{}
    local outboundPhases={
        TS015_SETTLING=true,TS015_COMPACTING=true,TS015_MOVING=true,TS015_TARGET_COMPACTING=true
    }
    for _,observation in OuttaMyWay.ValueRecord.ipairs(controlOutcomes or {}) do
        if observation.kind=="P22_TS015_CONTROL_EXECUTION_OBSERVATION" then
            local yieldId=assemblyIdForReference(observation.yieldReferenceKey)
            local progressId=assemblyIdForReference(observation.progressReferenceKey)
            if yieldId~=nil and progressId~=nil then
                local key=pairKey(yieldId,progressId)
                if observation.phase=="TS015_COMPACT_REFUGE_HOLD" then
                    passage[key]={yieldAssemblyId=yieldId,progressAssemblyId=progressId,commitmentId=observation.commitmentId,sourcePhase=observation.phase}
                elseif outboundPhases[observation.phase]==true then
                    outbound[key]={yieldAssemblyId=yieldId,progressAssemblyId=progressId,commitmentId=observation.commitmentId,sourcePhase=observation.phase}
                end
            end
        end
    end
    return passage,outbound
end

local function workerRecord(assemblyId,current,motion,future,productive,operationByAssembly)
    local c=current[assemblyId]; local m=motion[assemblyId]; local f=future[assemblyId]; local p=productive[assemblyId]
    local raw=m and m.nativeFieldWork or nil
    local width=raw and raw.workingWidth or nil
    local command=raw and raw.nativeDriveCommand or nil
    local occupancy=c and c.occupancy or nil
    return {
        assemblyId=assemblyId,name=m and m.name or nil,assemblyReferenceKey=m and m.assemblyReferenceKey or nil,operationId=operationByAssembly[assemblyId],
        x=occupancy and tonumber(occupancy.x) or nil,z=occupancy and tonumber(occupancy.z) or nil,
        dx=m and tonumber(m.headingX) or (occupancy and tonumber(occupancy.headingX) or nil),
        dz=m and tonumber(m.headingZ) or (occupancy and tonumber(occupancy.headingZ) or nil),
        boundaryDistanceM=f and tonumber(f.boundaryDistance) or nil,boundarySource=f and f.boundarySource or nil,
        workingWidthM=width and tonumber(width.widthMetres) or nil,workingWidthSource=width and width.source or nil,
        productivePositive=p and p.productivePositive==true or false,
        settledContinuation=m and m.localIntentClassification=="SETTLED_CONTINUATION" and m.intentValid==true or false,
        turning=raw and raw.isTurn==true or false,
        progressSpeedKmh=m and finite(tonumber(m.reportedSpeedMps)) and math.abs(tonumber(m.reportedSpeedMps))*3.6 or nil,
        nativeCommandValid=command and command.valid==true or false,nativeMoveForwards=command and command.moveForwards or nil,
        nativeZeroCommand=command and command.zeroCommand==true or false,nativeMaxSpeedKmh=command and tonumber(command.maxSpeedKmh) or nil,
        commandAuthority=command and command.authority or nil
    }
end

function Assessment.buildKnowledge(values)
    values=values or {}
    local current=byAssembly(values.currentSpace); local motion=byAssembly(values.motionEvidence)
    local future=futureMap(values.futureSpace); local productive=productiveMap(values.productiveKnowledge)
    local operationByAssembly=values.operationByAssembly or {}
    local active=activePurposeMap(values.commitmentContext)
    local passage,outbound=relocationPhaseMaps(values.controlOutcomes,function(ref) return values.assemblyIdForReference and values.assemblyIdForReference(ref) or nil end)
    local ids={}
    for assemblyId,_ in pairs(operationByAssembly) do ids[#ids+1]=assemblyId end
    table.sort(ids)
    local workers={}
    for _,id in ipairs(ids) do workers[id]=workerRecord(id,current,motion,future,productive,operationByAssembly) end
    local records,seen={},{}

    -- Existing purposes are evaluated first so absence of fresh admission
    -- evidence cannot silently discard responsibility.
    for key,purpose in pairs(active) do
        local leader,follower=workers[purpose.leaderAssemblyId],workers[purpose.followerAssemblyId]
        if leader~=nil and follower~=nil then
            local result=Assessment.evaluatePair(leader,follower,{
                existingPurpose=true,progressPassage=passage[key]~=nil,
                headOnOutboundEgress=outbound[key]~=nil,headOnOutboundEgressPhase=outbound[key] and outbound[key].sourcePhase or nil,
                minHeadingDot=values.minHeadingDot,provisionalDurationSec=values.provisionalDurationSec,
                establishedLateralRetentionM=values.establishedLateralRetentionM,
                establishedAlignmentMinDot=values.establishedAlignmentMinDot,
                establishedOpposedSuccessionMaxDot=values.establishedOpposedSuccessionMaxDot,
                clearanceFactor=values.clearanceFactor
            })
            result.existingCommitmentId=purpose.commitmentId; result.existingObligationId=purpose.obligationId
            result.leaderName=leader.name; result.followerName=follower.name
            result.operationId=leader.operationId
            result.leaderReferenceKey=purpose.leaderReferenceKey or leader.assemblyReferenceKey
            result.followerReferenceKey=purpose.followerReferenceKey or follower.assemblyReferenceKey
            result.progressPassage=passage[key]
            result.headOnOutboundEgress=outbound[key]
            records[#records+1]=result; seen[key]=true
        end
    end

    -- Discover new current line-astern relationships from current topology, not
    -- from historical manoeuvre sweep geometry.
    for i=1,#ids-1 do
        for j=i+1,#ids do
            local a,b=workers[ids[i]],workers[ids[j]]
            if a.operationId~=nil and a.operationId==b.operationId then
                local ab=Assessment.evaluatePair(a,b,{existingPurpose=false,minHeadingDot=values.minHeadingDot,provisionalDurationSec=values.provisionalDurationSec,clearanceFactor=values.clearanceFactor})
                local ba=Assessment.evaluatePair(b,a,{existingPurpose=false,minHeadingDot=values.minHeadingDot,provisionalDurationSec=values.provisionalDurationSec,clearanceFactor=values.clearanceFactor})
                local chosen=nil
                if ab.relationship and ab.relationship.status=="POSITIVE" then chosen=ab
                elseif ba.relationship and ba.relationship.status=="POSITIVE" then chosen=ba end
                if chosen~=nil and not seen[chosen.pairKey] then
                    chosen.leaderName=workers[chosen.leaderAssemblyId].name; chosen.followerName=workers[chosen.followerAssemblyId].name
                    chosen.operationId=workers[chosen.leaderAssemblyId].operationId
                    chosen.leaderReferenceKey=workers[chosen.leaderAssemblyId].assemblyReferenceKey
                    chosen.followerReferenceKey=workers[chosen.followerAssemblyId].assemblyReferenceKey
                    records[#records+1]=chosen; seen[chosen.pairKey]=true
                end
            end
        end
    end
    table.sort(records,function(a,b) return tostring(a.pairKey)<tostring(b.pairKey) end)
    return records
end
