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


-- The worker's generated GIANTS field course, not an arbitrary neighbouring
-- field in g_fieldManager, defines OUR field. Read it once when admitting
-- the 40 m solo objective; missing geometry never vetoes native recovery.
local function ownCourseField(commitment)
    local participant=type(commitment.participants)=="table"
        and commitment.participants[1] or nil
    local strategy=type(participant)=="table"
        and participant.sourceStrategyReference or nil
    local aiCourse=type(strategy)=="table" and strategy.aiFieldCourse or nil
    local fieldCourse=type(aiCourse)=="table" and aiCourse.fieldCourse or nil
    local courseField=type(fieldCourse)=="table" and fieldCourse.courseField or nil
    local points=type(courseField)=="table" and courseField.boundaryPositions or nil
    -- GIANTS' native field-detection coordinate identifies the current
    -- worker's selected field even when the generated boundary is absent.
    local fallback=type(strategy)=="table"
        and finite(strategy.fieldDetectionX) and finite(strategy.fieldDetectionZ)
        and {x=strategy.fieldDetectionX,z=strategy.fieldDetectionZ} or nil
    if type(points)~="table" or #points<3 then
        return nil,fallback,fallback~=nil
            and "GIANTS_FIELD_DETECTION_POSITION" or "NO_NATIVE_FIELD_REFERENCE"
    end
    local poly={xs={},zs={}}
    local area2,cx,cz=0,0,0
    for i=1,#points do
        local p=points[i]
        local x=type(p)=="table" and (p.x or p[1]) or nil
        local z=type(p)=="table" and (p.z or p[2]) or nil
        if not finite(x) or not finite(z) then return nil,nil end
        poly.xs[i],poly.zs[i]=x,z
    end
    for i=1,#points do
        local j=i==#points and 1 or i+1
        local a=poly.xs[i]*poly.zs[j]-poly.xs[j]*poly.zs[i]
        area2=area2+a
        cx=cx+(poly.xs[i]+poly.xs[j])*a
        cz=cz+(poly.zs[i]+poly.zs[j])*a
    end
    if math.abs(area2)<0.000001 then
        return nil,fallback,fallback~=nil
            and "GIANTS_FIELD_DETECTION_POSITION" or "NO_NATIVE_FIELD_REFERENCE"
    end
    return poly,{x=cx/(3*area2),z=cz/(3*area2)},
        "GIANTS_ACTIVE_COURSE_FIELD"
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
    local ownPolygon,ownCentroid,ownFieldSource=ownCourseField(commitment)
    local chosen=nil
    for _,side in ipairs({-1,1}) do
        local dx=COS_OBLIQUE*backX+side*SIN_OBLIQUE*perpX
        local dz=COS_OBLIQUE*backZ+side*SIN_OBLIQUE*perpZ
        local endpointInOwnField=ownPolygon~=nil and inside(ownPolygon,
            relocator.x+dx*40,relocator.z+dz*40) or false
        local towardOwnCentre=ownCentroid~=nil
            and (dx*(ownCentroid.x-relocator.x)
                +dz*(ownCentroid.z-relocator.z)) or nil
        -- Both directions remain eligible. Use only the current worker's
        -- GIANTS course field: prefer its interior endpoint, then the vector
        -- toward its centroid. No field data -> stable left-rear direction.
        if chosen==nil
            or (endpointInOwnField and not chosen.endpointInOwnField)
            or (endpointInOwnField==chosen.endpointInOwnField
                and towardOwnCentre~=nil
                and towardOwnCentre>chosen.centreScore+0.001) then
            chosen={side=side,dx=dx,dz=dz,
                endpointInOwnField=endpointInOwnField,
                centreScore=towardOwnCentre}
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
        targetInField=chosen.endpointInOwnField,
        fieldInteriorScore=chosen.centreScore,
        fieldIdentitySource=ownFieldSource,
        nativeReverseHeadingX=backX,nativeReverseHeadingZ=backZ
    }
end

-- An inferred static blocker must leave the blocked worker's productive
-- cross-track corridor, not merely drive away in a straight line. Reuse the
-- established 70-degree BWR steering angle and 5 m width allowance.
-- Choose side once, preferring the blocked worker's own GIANTS field.
function Region.planStatic(commitment,subject)
    local beneficiary=commitment and commitment.participants
        and commitment.participants[1] or nil
    if type(subject)~="table" or type(beneficiary)~="table"
        or not finite(subject.x) or not finite(subject.z)
        or not finite(subject.forwardX) or not finite(subject.forwardZ)
        or not finite(beneficiary.x) or not finite(beneficiary.z)
        or not finite(commitment.beneficiaryForwardX)
        or not finite(commitment.beneficiaryForwardZ)
        or not finite(commitment.beneficiaryWorkingWidthM)
        or commitment.beneficiaryWorkingWidthM<=0 then
        return nil,"STATIC_REGION_EVIDENCE_UNAVAILABLE"
    end
    local fx,fz=unit(subject.forwardX,subject.forwardZ)
    local bx,bz=unit(commitment.beneficiaryForwardX,
        commitment.beneficiaryForwardZ)
    if fx==nil or bx==nil then
        return nil,"STATIC_FACING_UNAVAILABLE"
    end
    local awayX,awayZ=subject.x-beneficiary.x,subject.z-beneficiary.z
    local isForward=fx*awayX+fz*awayZ>=0
    local travelX,travelZ=isForward and fx or -fx,isForward and fz or -fz
    local perpX,perpZ=-travelZ,travelX
    local normalX,normalZ=-bz,bx
    local vectorDistance=commitment.beneficiaryWorkingWidthM+EGRESS_MARGIN_M
    local field,centroid,fieldSource=ownCourseField(commitment)
    local chosen=nil
    for _,side in ipairs({-1,1}) do
        local dx=COS_OBLIQUE*travelX+side*SIN_OBLIQUE*perpX
        local dz=COS_OBLIQUE*travelZ+side*SIN_OBLIQUE*perpZ
        local lateral=dx*normalX+dz*normalZ
        local progress=vectorDistance*math.abs(lateral)
        if progress>=vectorDistance*0.5 then
            local endpointInField=field~=nil and segmentInField(field,
                subject.x,subject.z,dx,dz,vectorDistance) or false
            local towardCentre=centroid~=nil
                and (dx*(centroid.x-subject.x)
                    +dz*(centroid.z-subject.z)) or nil
            local candidate={
                side=side,dx=dx,dz=dz,lateralSign=lateral<0 and -1 or 1,
                requiredLateralM=progress,endpointInField=endpointInField,
                centreScore=towardCentre
            }
            if chosen==nil
                or (candidate.endpointInField and not chosen.endpointInField)
                or (candidate.endpointInField==chosen.endpointInField
                    and candidate.centreScore~=nil
                    and (chosen.centreScore==nil
                        or candidate.centreScore>chosen.centreScore+0.001)) then
                chosen=candidate
            end
        end
    end
    if chosen==nil then return nil,"STATIC_LATERAL_DIRECTION_UNAVAILABLE" end
    local horizon=vectorDistance+STEERING_LOOKAHEAD_M
    return {
        isReverse=not isForward,moveForwards=isForward,
        targetX=subject.x+chosen.dx*horizon,
        targetZ=subject.z+chosen.dz*horizon,
        steeringHorizonM=horizon,
        returnRegion={
            source="STATIC_CROSS_TRACK_REGION",
            originX=subject.x,originZ=subject.z,
            directionX=chosen.dx,directionZ=chosen.dz,
            normalX=normalX,normalZ=normalZ,
            sideSign=chosen.lateralSign,
            requiredProgressM=chosen.requiredLateralM
        },
        directionSource=isForward and "STATIC_FORWARD_OBLIQUE"
            or "STATIC_REVERSE_OBLIQUE",
        vectorDistanceM=vectorDistance,marginM=EGRESS_MARGIN_M,
        beneficiaryWorkingWidthM=commitment.beneficiaryWorkingWidthM,
        nominalBearingOffsetDeg=OBLIQUE_REVERSE_DEG,
        egressSide=chosen.side,targetInField=chosen.endpointInField,
        fieldInteriorScore=chosen.centreScore,
        fieldIdentitySource=fieldSource,
        staticSubjectRootId=subject.assemblyReferenceKey
    }
end

function Region.progress(region,x,z)
    if type(region)=="table" and region.source=="STATIC_CROSS_TRACK_REGION" then
        if not finite(x) or not finite(z)
            or not finite(region.originX) or not finite(region.originZ)
            or not finite(region.normalX) or not finite(region.normalZ)
            or not finite(region.sideSign)
            or not finite(region.requiredProgressM)
            or not finite(region.directionX) or not finite(region.directionZ) then
            return nil
        end
        local dx,dz=x-region.originX,z-region.originZ
        local progress=region.sideSign*(dx*region.normalX
            +dz*region.normalZ)
        return {progressM=progress,crossTrackM=progress,
            lateralOffsetM=math.abs(dx*region.directionZ
                -dz*region.directionX),
            remainingM=math.max(0,region.requiredProgressM-progress),
            isInRegion=progress>=region.requiredProgressM}
    end
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
