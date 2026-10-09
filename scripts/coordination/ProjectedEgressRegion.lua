-- BWR-derived projected Egress Return Region. This is physical retreat
-- progress, NOT an assertion that the two physical envelopes have cleared.
-- Direction is sampled once; membership requires only a dot product.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.ProjectedEgressRegion={}
local Region=OuttaMyWay.ProjectedEgressRegion
local REQUIRED_RETREAT_M=20 -- archived BWR calibrated retreat; test hypothesis
local STEERING_HORIZON_M=40 -- guidance point, NOT the stopping condition
local SAMPLE_STEP_M=2 -- admission-time field containment, not per-frame planning
local function finite(x)
    return type(x)=="number" and x==x and x~=math.huge and x~=-math.huge
end
local function normalise(x,z)
    if not finite(x) or not finite(z) then return nil,nil end
    local d=math.sqrt(x*x+z*z)
    if d<0.0001 then return nil,nil end
    return x/d,z/d
end
local function inField(poly,x,z)
    if type(poly)~="table" or type(poly.xs)~="table"
        or type(poly.zs)~="table" or #poly.xs<3
        or #poly.xs~=#poly.zs then return false end
    local inside=false
    for i=1,#poly.xs do
        local j=i==1 and #poly.xs or i-1
        if (poly.zs[i]>z)~=(poly.zs[j]>z) then
            local crossing=poly.xs[j]+(poly.xs[i]-poly.xs[j])
                *(z-poly.zs[j])/(poly.zs[i]-poly.zs[j])
            if x<crossing then inside=not inside end
        end
    end
    return inside
end
local function segmentSupported(poly,x,z,dx,dz,distance)
    local count=math.ceil(distance/SAMPLE_STEP_M)
    for i=0,count do
        local t=i/count*distance
        if not inField(poly,x+dx*t,z+dz*t) then return false end
    end
    return true
end
local function nativeReverseHeading(vehicle)
    if type(vehicle.getAIReverserNode)~="function"
        or type(localDirectionToWorld)~="function" then
        return nil,nil,"NATIVE_REVERSE_HEADING_UNAVAILABLE"
    end
    local ok,node=pcall(vehicle.getAIReverserNode,vehicle)
    if not ok or node==nil or node==0 then
        return nil,nil,"NATIVE_REVERSER_NODE_UNAVAILABLE"
    end
    local read,x,_,z=pcall(localDirectionToWorld,node,0,0,1)
    if not read then return nil,nil,"NATIVE_REVERSE_HEADING_UNAVAILABLE" end
    local ux,uz=normalise(-x,-z)
    if ux==nil then return nil,nil,"NATIVE_REVERSE_HEADING_UNAVAILABLE" end
    return ux,uz
end
function Region.plan(commitment,relocator,other)
    if type(commitment)~="table" or type(relocator)~="table"
        or type(other)~="table" or type(commitment.fieldCentroid)~="table"
        or type(commitment.fieldPolygon)~="table" then
        return nil,"EGRESS_REGION_EVIDENCE_UNAVAILABLE"
    end
    local awayX,awayZ=normalise(relocator.x-other.x,relocator.z-other.z)
    local centreX,centreZ=normalise(
        commitment.fieldCentroid.x-relocator.x,
        commitment.fieldCentroid.z-relocator.z)
    if awayX==nil then return nil,"PAIR_SEPARATION_VECTOR_UNAVAILABLE" end
    local backX,backZ,reason=nativeReverseHeading(relocator.vehicle)
    if backX==nil then return nil,reason end
    local choices={}
    local function try(x,z,name)
        if x==nil or x*awayX+z*awayZ<=0.15
            or x*backX+z*backZ<0.25
            or not segmentSupported(commitment.fieldPolygon,
                relocator.x,relocator.z,x,z,REQUIRED_RETREAT_M) then return end
        choices[#choices+1]={x=x,z=z,kind=name,
            alignment=x*backX+z*backZ,
            centre=centreX~=nil and x*centreX+z*centreZ or 0}
    end
    -- Prefer feasible reverse directions; preserve centroid as a preference,
    -- not an arrival target. No 45-degree construction or width scaling.
    try(centreX,centreZ,"CENTROID_PREFERENCE")
    try(awayX,awayZ,"AWAY_FROM_OTHER")
    try(backX,backZ,"NATIVE_REVERSE_AXIS")
    if #choices==0 then return nil,"NO_SUPPORTED_EGRESS_DIRECTION" end
    local chosen=choices[1]
    for i=2,#choices do
        local c=choices[i]
        if c.alignment>chosen.alignment+0.1
            or (math.abs(c.alignment-chosen.alignment)<=0.1
                and c.centre>chosen.centre) then chosen=c end
    end
    local dx,dz=chosen.x,chosen.z
    return {
        isReverse=true,steeringHorizonM=STEERING_HORIZON_M,
        targetX=relocator.x+dx*STEERING_HORIZON_M,
        targetZ=relocator.z+dz*STEERING_HORIZON_M,
        returnRegion={
            originX=relocator.x,originZ=relocator.z,
            directionX=dx,directionZ=dz,
            requiredProgressM=REQUIRED_RETREAT_M,
            source="ARCHIVED_BWR_PROJECTED_RETREAT",
            isPhysicalPairClearanceConfirmed=false
        },
        directionSource=chosen.kind,
        nativeReverseHeadingX=backX,nativeReverseHeadingZ=backZ
    }
end
function Region.progress(region,x,z)
    if type(region)~="table" or not finite(x) or not finite(z) then return nil end
    local dx,dz=x-region.originX,z-region.originZ
    local longitudinal=dx*region.directionX+dz*region.directionZ
    local lateral=math.abs(dx*region.directionZ-dz*region.directionX)
    return {progressM=longitudinal,lateralOffsetM=lateral,
        remainingM=math.max(0,region.requiredProgressM-longitudinal),
        isInRegion=longitudinal>=region.requiredProgressM}
end
