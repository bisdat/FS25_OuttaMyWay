-- Oblique reverse to a signed Cross-Track Egress Region.
-- The blocker working width + 5 m scales the *vector length*, not an assumed
-- relocator collision envelope. Completion is lateral region entry, not the
-- steering point and not longitudinal retreat.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.ProjectedEgressRegion={}
local Region=OuttaMyWay.ProjectedEgressRegion
local EGRESS_MARGIN_M=5
local OBLIQUE_REVERSE_DEG=70 -- facing 0: reverse 180, left-rear approximately 250
local STEERING_LOOKAHEAD_M=40 -- archived BWR guidance beyond the nominal region
local SAMPLE_STEP_M=2 -- admission-time field containment only
local COS_OBLIQUE=math.cos(math.rad(OBLIQUE_REVERSE_DEG))
local SIN_OBLIQUE=math.sin(math.rad(OBLIQUE_REVERSE_DEG))
local function finite(x)
    return type(x)=="number" and x==x and x~=math.huge and x~=-math.huge
end
local function unit(x,z)
    if not finite(x) or not finite(z) then return nil,nil end
    local length=math.sqrt(x*x+z*z)
    if length<0.0001 then return nil,nil end
    return x/length,z/length
end
local function inside(poly,x,z)
    if type(poly)~="table" or type(poly.xs)~="table"
        or type(poly.zs)~="table" or #poly.xs<3
        or #poly.xs~=#poly.zs then return false end
    local result=false
    for i=1,#poly.xs do
        local j=i==1 and #poly.xs or i-1
        if (poly.zs[i]>z)~=(poly.zs[j]>z) then
            local boundary=poly.xs[j]+(poly.xs[i]-poly.xs[j])*
                (z-poly.zs[j])/(poly.zs[i]-poly.zs[j])
            if x<boundary then result=not result end
        end
    end
    return result
end
local function segmentInField(poly,x,z,dx,dz,length)
    local count=math.max(1,math.ceil(length/SAMPLE_STEP_M))
    for i=0,count do
        local t=length*i/count
        if not inside(poly,x+dx*t,z+dz*t) then return false end
    end
    return true
end
local function heading(vehicle,methodName,reverse)
    if type(vehicle)~="table" or type(vehicle[methodName])~="function"
        or type(localDirectionToWorld)~="function" then
        return nil,nil,"NATIVE_HEADING_UNAVAILABLE"
    end
    local ok,node=pcall(vehicle[methodName],vehicle)
    if not ok or node==nil or node==0 then
        return nil,nil,"NATIVE_DIRECTION_NODE_UNAVAILABLE"
    end
    local read,x,_,z=pcall(localDirectionToWorld,node,0,0,1)
    if not read then return nil,nil,"NATIVE_HEADING_UNAVAILABLE" end
    local ux,uz=unit(x,z)
    if ux==nil then return nil,nil,"NATIVE_HEADING_UNAVAILABLE" end
    return reverse and -ux or ux,reverse and -uz or uz
end

function Region.plan(commitment,relocator,blocker)
    if type(commitment)~="table" or type(relocator)~="table"
        or type(blocker)~="table"
        or not finite(relocator.x) or not finite(relocator.z)
        or not finite(blocker.x) or not finite(blocker.z)
        or type(commitment.fieldCentroid)~="table"
        or type(commitment.fieldPolygon)~="table" then
        return nil,"EGRESS_REGION_EVIDENCE_UNAVAILABLE"
    end
    local width=commitment.blockerWorkingWidthM
    if not finite(width) or width<=0 then
        return nil,"BLOCKER_WORK_WIDTH_UNAVAILABLE"
    end
    local vectorDistanceM=width+EGRESS_MARGIN_M
    local backX,backZ,reverseReason=heading(
        relocator.vehicle,"getAIReverserNode",true)
    if backX==nil then return nil,reverseReason end
    local forwardX,forwardZ,blockerReason=heading(
        blocker.vehicle,"getAISteeringNode",false)
    if forwardX==nil then return nil,blockerReason end
    local normalX,normalZ=-forwardZ,forwardX
    local startCross=(relocator.x-blocker.x)*normalX
        +(relocator.z-blocker.z)*normalZ
    local perpX,perpZ=-backZ,backX
    local choices={}
    for _,side in ipairs({-1,1}) do
        local dx=COS_OBLIQUE*backX+side*SIN_OBLIQUE*perpX
        local dz=COS_OBLIQUE*backZ+side*SIN_OBLIQUE*perpZ
        local lateralRate=dx*normalX+dz*normalZ
        local lateralSign=lateralRate<0 and -1 or 1
        local progress=vectorDistanceM*math.abs(lateralRate)
        -- A near-axial option cannot count as Cross-Track Egress.
        if progress>=vectorDistanceM*0.5 then
            local isInField=segmentInField(commitment.fieldPolygon,
                relocator.x,relocator.z,dx,dz,vectorDistanceM)
            local signedStart=lateralSign*startCross
            local centreX=commitment.fieldCentroid.x-relocator.x
            local centreZ=commitment.fieldCentroid.z-relocator.z
            choices[#choices+1]={
                side=side,dx=dx,dz=dz,sign=lateralSign,
                inField=isInField,
                alreadyOnSide=signedStart>=0,
                centreScore=dx*centreX+dz*centreZ,
                initialCrossTrackM=signedStart,
                requiredProgressM=progress,
                requiredCrossTrackM=math.max(0,signedStart)+progress
            }
        end
    end
    if #choices==0 then return nil,"NO_LATERAL_REVERSE_DIRECTION" end
    local chosen=nil
    for i=1,#choices do
        local option=choices[i]
        -- Inside-polygon eligibility does not itself establish inward intent.
        -- Prefer the direction facing the field centroid; old-side membership
        -- is only a tie-break. These are evaluated once at admission.
        if option.inField and (chosen==nil
            or option.centreScore>chosen.centreScore+0.001
            or (math.abs(option.centreScore-chosen.centreScore)<=0.001
                and option.alreadyOnSide and not chosen.alreadyOnSide)) then
            chosen=option
        end
    end
    if chosen==nil then return nil,"NO_SUPPORTED_INFIELD_EGRESS_REGION" end
    local steeringDistance=vectorDistanceM+STEERING_LOOKAHEAD_M
    return {
        isReverse=true,steeringHorizonM=steeringDistance,
        targetX=relocator.x+chosen.dx*steeringDistance,
        targetZ=relocator.z+chosen.dz*steeringDistance,
        returnRegion={
            originX=relocator.x,originZ=relocator.z,
            directionX=chosen.dx,directionZ=chosen.dz,
            blockerOriginX=blocker.x,blockerOriginZ=blocker.z,
            corridorNormalX=normalX,corridorNormalZ=normalZ,
            sideSign=chosen.sign,
            initialCrossTrackM=chosen.initialCrossTrackM,
            requiredCrossTrackM=chosen.requiredCrossTrackM,
            requiredProgressM=chosen.requiredProgressM,
            source="SIGNED_CROSS_TRACK_REGION",
            isPhysicalPairClearanceConfirmed=false
        },
        directionSource="OBLIQUE_REVERSE",
        egressSide=chosen.side,vectorDistanceM=vectorDistanceM,
        blockerWorkingWidthM=width,marginM=EGRESS_MARGIN_M,
        nominalBearingOffsetDeg=OBLIQUE_REVERSE_DEG,
        targetInField=true,fieldInteriorScore=chosen.centreScore,
        nativeReverseHeadingX=backX,nativeReverseHeadingZ=backZ
    }
end


-- No solo field-membership requirement. A documented native FIELDWORK worker
-- can be blocked outside the polygon; region destination membership is only
-- an inexpensive direction *preference*, never a veto.
local function soloEndpointInField(x,z)
    local manager=g_fieldManager
    local fields=manager and manager.fields
    if type(fields)~="table" then return false end
    for _,field in pairs(fields) do
        local native=type(field)=="table" and field.densityMapPolygon
        local xs=native and native.pointsX
        local zs=native and native.pointsZ
        if type(xs)=="table" and type(zs)=="table"
            and inside({xs=xs,zs=zs},x,z) then return true end
    end
    return false
end

function Region.planSingle(commitment,relocator)
    if type(commitment)~="table" or type(relocator)~="table"
        or not finite(relocator.x) or not finite(relocator.z)
        or commitment.singleRegionDistanceM~=40 then
        return nil,"SINGLE_REGION_EVIDENCE_UNAVAILABLE"
    end
    local backX,backZ,reason=heading(relocator.vehicle,"getAIReverserNode",true)
    if backX==nil then return nil,reason end
    local perpX,perpZ=-backZ,backX
    local chosen=nil
    for _,side in ipairs({-1,1}) do
        local dx=COS_OBLIQUE*backX+side*SIN_OBLIQUE*perpX
        local dz=COS_OBLIQUE*backZ+side*SIN_OBLIQUE*perpZ
        local endpointInField=soloEndpointInField(
            relocator.x+dx*40,relocator.z+dz*40)
        -- Prefer an endpoint in a known field; absent such evidence, the
        -- established left-rear candidate is deterministic and still valid.
        if chosen==nil or (endpointInField and not chosen.endpointInField) then
            chosen={side=side,dx=dx,dz=dz,endpointInField=endpointInField}
        end
    end
    local horizon=40+STEERING_LOOKAHEAD_M
    return {
        isReverse=true,steeringHorizonM=horizon,
        targetX=relocator.x+chosen.dx*horizon,
        targetZ=relocator.z+chosen.dz*horizon,
        returnRegion={
            source="SINGLE_REVERSE_REGION",
            originX=relocator.x,originZ=relocator.z,
            directionX=chosen.dx,directionZ=chosen.dz,
            requiredProgressM=40
        },
        directionSource="SINGLE_OBLIQUE_REVERSE",
        egressSide=chosen.side,vectorDistanceM=40,
        nominalBearingOffsetDeg=OBLIQUE_REVERSE_DEG,
        targetInField=chosen.endpointInField,
        nativeReverseHeadingX=backX,nativeReverseHeadingZ=backZ
    }
end

function Region.progress(region,x,z)
    if type(region)=="table" and region.source=="SINGLE_REVERSE_REGION" then
        if not finite(x) or not finite(z)
            or not finite(region.originX) or not finite(region.originZ)
            or not finite(region.directionX) or not finite(region.directionZ)
            or not finite(region.requiredProgressM) then return nil end
        local dx,dz=x-region.originX,z-region.originZ
        local progress=dx*region.directionX+dz*region.directionZ
        return {progressM=progress,crossTrackM=progress,
            lateralOffsetM=math.abs(dx*region.directionZ-dz*region.directionX),
            remainingM=math.max(0,region.requiredProgressM-progress),
            isInRegion=progress>=region.requiredProgressM}
    end
    if type(region)~="table" or not finite(x) or not finite(z)
        or not finite(region.blockerOriginX)
        or not finite(region.blockerOriginZ)
        or not finite(region.corridorNormalX)
        or not finite(region.corridorNormalZ)
        or not finite(region.sideSign)
        or not finite(region.requiredCrossTrackM) then return nil end
    local ox=x-region.originX
    local oz=z-region.originZ
    local signedCross=region.sideSign*(
        (x-region.blockerOriginX)*region.corridorNormalX
        +(z-region.blockerOriginZ)*region.corridorNormalZ)
    local signedProgress=signedCross-region.initialCrossTrackM
    local deviation=math.abs(ox*region.directionZ-oz*region.directionX)
    return {progressM=signedProgress,lateralOffsetM=deviation,
        crossTrackM=signedCross,
        remainingM=math.max(0,region.requiredCrossTrackM-signedCross),
        isInRegion=signedCross>=region.requiredCrossTrackM}
end
