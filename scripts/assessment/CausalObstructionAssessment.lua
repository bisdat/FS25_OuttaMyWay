--- Archived positive Causal Obstruction kernels, adapted to live 0.5 current evidence.
-- Specification Jurisdictions: `OBSTRUCTION_RELOCATION`
-- Copied from archive/0.4.11.0 CausalObstructionAssessment.lua lines 66-209.
-- Only ordinary-array iteration replaces retired ValueRecord proxies.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CausalObstructionAssessment={}
local Assessment=OuttaMyWay.CausalObstructionAssessment
local function finite(value)
    return type(value)=="number" and value==value
        and value~=math.huge and value~=-math.huge
end

local function pointSegmentDistance(px,pz,ax,az,bx,bz)
    local vx,vz=bx-ax,bz-az
    local denom=vx*vx+vz*vz
    local t=denom>0 and (((px-ax)*vx+(pz-az)*vz)/denom) or 0
    t=math.max(0,math.min(1,t))
    local qx,qz=ax+t*vx,az+t*vz
    local dx,dz=px-qx,pz-qz
    return math.sqrt(dx*dx+dz*dz),t,qx,qz
end

local function currentOverlap(blockerPhysical,beneficiaryPhysical)
    if blockerPhysical==nil or beneficiaryPhysical==nil then return nil end
    local result=OuttaMyWay.PlanViewFootprint.evaluateCurrentOverlap(
        {worldPrimitives=blockerPhysical.primitives},
        {worldPrimitives=beneficiaryPhysical.primitives}
    )
    if result and result.current==true then
        return {
            kind="CURRENT_PHYSICAL_OCCUPANCY",
            distance=result.distance,
            required=result.required,
            blockerPrimitiveId=result.subjectPrimitiveId,
            beneficiaryPrimitiveId=result.otherPrimitiveId,
            authority="POSITIVE_CONFLICT_SUPPORT_ONLY"
        }
    end
    return nil
end

local function futureSweepConflict(blockerPhysical,beneficiaryPhysical,beneficiaryFuture)
    local alternative=beneficiaryFuture
        and beneficiaryFuture.alternatives
        and beneficiaryFuture.alternatives[1]
        or nil
    if alternative==nil
        or not finite(alternative.startX) or not finite(alternative.startZ)
        or not finite(alternative.endX) or not finite(alternative.endZ) then
        return nil
    end

    for _,blockerPrimitive in ipairs(blockerPhysical and blockerPhysical.primitives or {}) do
        if blockerPrimitive.kind=="DISC"
            and blockerPrimitive.positiveConflictSupport==true
            and finite(blockerPrimitive.x) and finite(blockerPrimitive.z)
            and finite(blockerPrimitive.radius) then
            for _,beneficiaryPrimitive in ipairs(beneficiaryPhysical and beneficiaryPhysical.primitives or {}) do
                if beneficiaryPrimitive.kind=="DISC"
                    and beneficiaryPrimitive.positiveConflictSupport==true
                    and finite(beneficiaryPrimitive.x) and finite(beneficiaryPrimitive.z)
                    and finite(beneficiaryPrimitive.radius) then
                    local offsetX=beneficiaryPrimitive.x-alternative.startX
                    local offsetZ=beneficiaryPrimitive.z-alternative.startZ
                    local ax,az=alternative.startX+offsetX,alternative.startZ+offsetZ
                    local bx,bz=alternative.endX+offsetX,alternative.endZ+offsetZ
                    local distance,t,qx,qz=pointSegmentDistance(
                        blockerPrimitive.x,blockerPrimitive.z,ax,az,bx,bz
                    )
                    local required=blockerPrimitive.radius+beneficiaryPrimitive.radius
                    if distance<=required then
                        return {
                            kind="CONTINUING_ACTIVE_FUTURE_SPACE",
                            distance=distance,
                            required=required,
                            blockerPrimitiveId=blockerPrimitive.identity,
                            beneficiaryPrimitiveId=beneficiaryPrimitive.identity,
                            segmentFraction=t,
                            closestX=qx,
                            closestZ=qz,
                            authority="POSITIVE_CONFLICT_SUPPORT_ONLY"
                        }
                    end
                end
            end
        end
    end
    return nil
end

local function realisedMotionDemandConflict(blockerPhysical,demand)
    if blockerPhysical==nil or type(demand)~="table" or demand.positive~=true then return nil end
    local directionX,directionZ=tonumber(demand.directionX),tonumber(demand.directionZ)
    local horizonM=tonumber(demand.horizonM)
    if not finite(directionX) or not finite(directionZ) or not finite(horizonM) or horizonM<=0 then return nil end

    local best=nil
    for _,blockerPrimitive in ipairs(blockerPhysical.primitives or {}) do
        if blockerPrimitive.kind=="DISC"
            and blockerPrimitive.positiveConflictSupport==true
            and finite(blockerPrimitive.x) and finite(blockerPrimitive.z)
            and finite(blockerPrimitive.radius) then
            for _,sweep in ipairs(demand.physicalDemandSweeps or {}) do
                if sweep.kind=="DISC_SWEEP"
                    and finite(sweep.startX) and finite(sweep.startZ)
                    and finite(sweep.radius) then
                    local rx,rz=blockerPrimitive.x-sweep.startX,blockerPrimitive.z-sweep.startZ
                    local forward=rx*directionX+rz*directionZ
                    local lateralSquared=math.max(0,rx*rx+rz*rz-forward*forward)
                    local required=blockerPrimitive.radius+sweep.radius
                    local requiredSquared=required*required
                    if lateralSquared<=requiredSquared then
                        local halfChord=math.sqrt(math.max(0,requiredSquared-lateralSquared))
                        local entry=forward-halfChord
                        local exit=forward+halfChord
                        if exit>=0 and entry<=horizonM then
                            local witnessDistance=math.max(0,entry)
                            if witnessDistance<=horizonM and (best==nil or witnessDistance<best.witnessDistanceM) then
                                local rate=tonumber(demand.progressionRateMps)
                                best={
                                    kind="REALISED_MOTION_DEMAND",
                                    witnessDistanceM=witnessDistance,
                                    estimatedTimeToWitnessSeconds=finite(rate) and rate>0 and witnessDistance/rate or nil,
                                    beneficiaryProgressionRateMps=rate,
                                    centreForwardDistanceM=forward,
                                    lateralOffsetM=math.sqrt(lateralSquared),
                                    required=required,
                                    blockerPrimitiveId=blockerPrimitive.identity,
                                    beneficiaryPrimitiveId=sweep.beneficiaryPrimitiveId,
                                    horizonM=horizonM,
                                    demandIdentity=demand.identity,
                                    demandJobEpisodeId=demand.jobEpisodeId,
                                    localIntentClassification=demand.localIntentClassification,
                                    currentMotionClassification=demand.currentMotionClassification,
                                    trajectoryAlignment=demand.alignment,
                                    authority="POSITIVE_CONFLICT_SUPPORT_ONLY",
                                    futureRouteAuthority=false,
                                    negativeClearanceAuthority=false
                                }
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

local function positiveObstruction(blockerPhysical,beneficiaryPhysical,beneficiaryFuture,realisedDemand)
    local current=currentOverlap(blockerPhysical,beneficiaryPhysical)
    if current~=nil then return current end
    local future=futureSweepConflict(blockerPhysical,beneficiaryPhysical,beneficiaryFuture)
    if future~=nil then return future end
    return realisedMotionDemandConflict(blockerPhysical,realisedDemand)
end

function Assessment.positiveObstruction(blockerPhysical,beneficiaryPhysical,
    beneficiaryFuture,realisedDemand)
    return positiveObstruction(blockerPhysical,beneficiaryPhysical,
        beneficiaryFuture,realisedDemand)
end
