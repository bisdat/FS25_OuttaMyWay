--- Interprets fresh realised physical progression into bounded Realised Motion Demand Situation evidence.
-- Specification Jurisdictions: `SITUATION_ASSESSMENT`

OuttaMyWay.RealisedMotionDemandAssessment={}
local Assessment=OuttaMyWay.RealisedMotionDemandAssessment

local publication=OuttaMyWay.LogPublication.origin("SITUATION_ASSESSMENT")

local LOOKAHEAD_MAX_M=100.0
local MIN_REALISED_SPEED_MPS=0.05
local TRAJECTORY_ALIGNMENT_MIN_DOT=0.85

Assessment.LOOKAHEAD_MAX_M=LOOKAHEAD_MAX_M

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function normalize(x,z)
    if not finite(x) or not finite(z) then return nil,nil end
    local length=math.sqrt(x*x+z*z)
    if length<=0.000001 then return nil,nil end
    return x/length,z/length
end

local function dot(ax,az,bx,bz)
    if not finite(ax) or not finite(az) or not finite(bx) or not finite(bz) then return nil end
    return ax*bx+az*bz
end

local function byAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if type(item.assemblyId)=="string" then result[item.assemblyId]=item end
    end
    return result
end

local function sortedKeys(map)
    local result={}
    for key in OuttaMyWay.ValueRecord.pairs(map or {}) do result[#result+1]=key end
    table.sort(result)
    return result
end

local function liveProgressActuationOwner(commitments,assemblyId)
    for _,record in OuttaMyWay.ValueRecord.ipairs(commitments or {}) do
        local live=record.state=="ACTIVE" or record.state=="WAITING_FOR_EVIDENCE" or record.state=="SETTLING"
        if live then
            for _,item in OuttaMyWay.ValueRecord.ipairs(record.progressActuationOwnership or {}) do
                if item.assemblyId==assemblyId then return record.identity end
            end
        end
    end
    return nil
end

local function usableDisc(primitive)
    return type(primitive)=="table"
        and primitive.kind=="DISC"
        and primitive.positiveConflictSupport==true
        and finite(primitive.x) and finite(primitive.z)
        and finite(primitive.radius) and primitive.radius>=0
end

local function demandSweeps(physical,dx,dz,horizonM)
    local result={}
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical and physical.primitives or {}) do
        if usableDisc(primitive) then
            result[#result+1]={
                kind="DISC_SWEEP",
                beneficiaryPrimitiveId=primitive.identity,
                startX=primitive.x,startZ=primitive.z,
                endX=primitive.x+dx*horizonM,endZ=primitive.z+dz*horizonM,
                radius=primitive.radius
            }
        end
    end
    table.sort(result,function(a,b) return tostring(a.beneficiaryPrimitiveId)<tostring(b.beneficiaryPrimitiveId) end)
    return result
end

function Assessment.build(context)
    context=context or {}
    local motion=byAssembly(context.motionEvidence)
    local trajectories=byAssembly(context.trajectoryKnowledge)
    local physical=byAssembly(context.physicalSpaceEvidence)
    local records={}

    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(sortedKeys(context.activeOperationMemberSet or {})) do
        local operationId=context.operationByAssembly and context.operationByAssembly[assemblyId] or nil
        local activeEpisode=context.jobEpisodes and context.jobEpisodes:getActiveForAssembly(assemblyId) or nil
        local motionItem=motion[assemblyId]
        local trajectory=trajectories[assemblyId]
        local physicalItem=physical[assemblyId]
        local owner=liveProgressActuationOwner(context.commitments,assemblyId)

        if type(operationId)=="string"
            and activeEpisode~=nil
            and motionItem~=nil
            and trajectory~=nil
            and physicalItem~=nil
            and owner==nil
            and trajectory.established==true
            and trajectory.currentExcursion~=true
            and trajectory.jobToken==motionItem.sourceJobToken
            and activeEpisode.sourceJobToken==motionItem.sourceJobToken then

            local speed=tonumber(motionItem.positionDerivedSpeedMps)
            local currentX,currentZ=normalize(
                tonumber(motionItem.travelDirectionX),
                tonumber(motionItem.travelDirectionZ))
            local establishedX,establishedZ=normalize(
                tonumber(trajectory.establishedDirectionX),
                tonumber(trajectory.establishedDirectionZ))
            local alignment=currentX~=nil and establishedX~=nil
                and dot(currentX,currentZ,establishedX,establishedZ)
                or nil
            local movingClass=motionItem.motionClassification=="STABLE_FORWARD"
                or motionItem.motionClassification=="TURNING"
                or motionItem.motionClassification=="REVERSING_OR_OPPOSED_TRAVEL"

            if finite(speed) and speed>=MIN_REALISED_SPEED_MPS
                and movingClass
                and finite(alignment) and alignment>=TRAJECTORY_ALIGNMENT_MIN_DOT then
                local sweeps=demandSweeps(physicalItem,establishedX,establishedZ,LOOKAHEAD_MAX_M)
                if OuttaMyWay.ValueRecord.length(sweeps)>0 then
                    records[#records+1]={
                        identity="realised-motion-demand:"..operationId..":"..assemblyId,
                        operationId=operationId,
                        beneficiaryAssemblyId=assemblyId,
                        beneficiaryAssemblyReferenceKey=motionItem.assemblyReferenceKey,
                        jobEpisodeId=activeEpisode.identity,
                        sourceJobToken=motionItem.sourceJobToken,
                        positive=true,
                        horizonM=LOOKAHEAD_MAX_M,
                        progressionRateMps=speed,
                        directionX=establishedX,directionZ=establishedZ,
                        alignment=alignment,
                        currentAlignedDistanceM=trajectory.currentAlignedDistanceM,
                        currentMotionClassification=motionItem.motionClassification,
                        localIntentClassification=motionItem.localIntentClassification,
                        productiveContextPositive=trajectory.contextProductivePositive==true,
                        physicalDemandSweeps=sweeps,
                        claimLimits={
                            positiveLocalDemandOnly=true,
                            futureRouteAuthority=false,
                            negativeClearanceAuthority=false,
                            decisionAuthority=false,
                            controlAuthority=false
                        },
                        provenance={
                            source="RealisedMotionDemandAssessment",
                            observationSnapshotId=context.observationSnapshotId,
                            trajectorySource=trajectory.provenance and trajectory.provenance.source or nil,
                            basis="FRESH_ALIGNED_REALISED_PROGRESS_ON_ESTABLISHED_TRAJECTORY",
                            lookaheadCalibration="TEST_0_4_5_1_100M",
                            turningPromoted=false
                        }
                    }
                end
            end
        end
    end

    table.sort(records,function(a,b) return tostring(a.identity)<tostring(b.identity) end)

    if publication:isEligible("DIAGNOSTIC","INFO","REALISED_MOTION_DEMAND_CENSUS") then
        local entries={}
        for _,record in OuttaMyWay.ValueRecord.ipairs(records) do
            entries[#entries+1]=string.format(
                "%s|operation=%s|horizon=%.3f|speed=%.3f|alignment=%.3f|motion=%s|intent=%s|productive=%s",
                tostring(record.beneficiaryAssemblyId),tostring(record.operationId),
                tonumber(record.horizonM) or 0,tonumber(record.progressionRateMps) or 0,
                tonumber(record.alignment) or 0,tostring(record.currentMotionClassification),
                tostring(record.localIntentClassification),tostring(record.productiveContextPositive))
        end
        publication:info("DIAGNOSTIC","REALISED_MOTION_DEMAND_CENSUS",
            "count=%d records=%s",OuttaMyWay.ValueRecord.length(records),table.concat(entries,","))
    end

    return records
end
