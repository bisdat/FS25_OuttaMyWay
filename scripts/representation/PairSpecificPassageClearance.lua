--- Derives dedicated Passage-clearance representation support without choosing Passage roles, configuration, burden or motion.
-- Specification Jurisdictions: `ASSESSMENT_REPRESENTATION`, `COOPERATIVE_PASSAGE`

-- Pair-Specific Passage Clearance geometry support.
--
-- This representation adapter derives one-sided Facing Clearance Extents and
-- translated represented-DISC clearance from current Situation-owned physical
-- evidence. It does not choose passage roles, configuration, burden or motion.
-- The caller supplies the Nominal Inter-Assembly Clearance policy margin.
-- Current bootstrap representation remains explicitly bounded: these values are
-- derived from participating represented components and do not manufacture
-- generic Coverage Closure or negative-clearance authority.

OuttaMyWay.PairSpecificPassageClearance={}
local Clearance=OuttaMyWay.PairSpecificPassageClearance

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end
local function distance(ax,az,bx,bz)
    local dx,dz=bx-ax,bz-az
    return math.sqrt(dx*dx+dz*dz)
end

local function referencePose(space)
    if type(space)~="table" or type(space.occupancy)~="table" then return nil,nil,"CURRENT_REFERENCE_POSE_UNAVAILABLE" end
    local x,z=tonumber(space.occupancy.x),tonumber(space.occupancy.z)
    if not finite(x) or not finite(z) then return nil,nil,"CURRENT_REFERENCE_POSE_UNAVAILABLE" end
    return x,z,nil
end

function Clearance.representedLateralSupport(physical,space,rightX,rightZ)
    if type(physical)~="table" then return nil,"CURRENT_PHYSICAL_SPACE_UNAVAILABLE" end
    if not finite(rightX) or not finite(rightZ) then return nil,"SHARED_LATERAL_AXIS_UNAVAILABLE" end
    local originX,originZ,poseReason=referencePose(space)
    if originX==nil then return nil,poseReason end
    local minimum,maximum=nil,nil
    local count=0
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical.primitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(tonumber(primitive.x)) and finite(tonumber(primitive.z))
            and finite(tonumber(primitive.radius)) and tonumber(primitive.radius)>0 then
            local offset=(tonumber(primitive.x)-originX)*rightX+(tonumber(primitive.z)-originZ)*rightZ
            local radius=tonumber(primitive.radius)
            minimum=minimum==nil and offset-radius or math.min(minimum,offset-radius)
            maximum=maximum==nil and offset+radius or math.max(maximum,offset+radius)
            count=count+1
        end
    end
    if count<1 then return nil,"NO_CURRENT_PARTICIPATING_PHYSICAL_PRIMITIVES" end
    return {minOffsetM=minimum,maxOffsetM=maximum,physicalPrimitiveCount=count},nil
end

function Clearance.currentPair(aPhysical,aSpace,bPhysical,bSpace,rightX,rightZ,nominalClearanceM)
    local ax,az,aPoseReason=referencePose(aSpace)
    if ax==nil then return nil,"SUBJECT_"..tostring(aPoseReason) end
    local bx,bz,bPoseReason=referencePose(bSpace)
    if bx==nil then return nil,"OTHER_"..tostring(bPoseReason) end
    local aSupport,aReason=Clearance.representedLateralSupport(aPhysical,aSpace,rightX,rightZ)
    if aSupport==nil then return nil,"SUBJECT_"..tostring(aReason) end
    local bSupport,bReason=Clearance.representedLateralSupport(bPhysical,bSpace,rightX,rightZ)
    if bSupport==nil then return nil,"OTHER_"..tostring(bReason) end
    local margin=tonumber(nominalClearanceM)
    if not finite(margin) or margin<=0 then return nil,"NOMINAL_INTER_ASSEMBLY_CLEARANCE_INVALID" end

    local function relation(sign)
        local aFacing,bFacing
        if sign>0 then
            -- B lies on +sharedRight from A: A's + side faces B; B's - side faces A.
            aFacing=math.max(0,aSupport.maxOffsetM)
            bFacing=math.max(0,-bSupport.minOffsetM)
        else
            -- B lies on -sharedRight from A: A's - side faces B; B's + side faces A.
            aFacing=math.max(0,-aSupport.minOffsetM)
            bFacing=math.max(0,bSupport.maxOffsetM)
        end
        local contact=aFacing+bFacing
        return {
            relationSign=sign,
            subjectFacingExtentM=aFacing,
            otherFacingExtentM=bFacing,
            physicalContactThresholdM=contact,
            nominalInterAssemblyClearanceM=margin,
            policyRequiredSeparationM=contact+margin
        }
    end

    local signed=(bx-ax)*rightX+(bz-az)*rightZ
    local lateral=math.abs(signed)
    local positive=relation(1)
    local negative=relation(-1)
    local currentRelation=signed>=0 and positive or negative
    return {
        currentSignedSeparationM=signed,
        currentLateralSeparationM=lateral,
        currentRelationSign=currentRelation.relationSign,
        subjectFacingExtentM=currentRelation.subjectFacingExtentM,
        otherFacingExtentM=currentRelation.otherFacingExtentM,
        physicalContactThresholdM=currentRelation.physicalContactThresholdM,
        nominalInterAssemblyClearanceM=margin,
        policyRequiredSeparationM=currentRelation.policyRequiredSeparationM,
        policyReserveM=lateral-currentRelation.policyRequiredSeparationM,
        positiveRelation=positive,
        negativeRelation=negative,
        subjectLateralSupport={minOffsetM=aSupport.minOffsetM,maxOffsetM=aSupport.maxOffsetM},
        otherLateralSupport={minOffsetM=bSupport.minOffsetM,maxOffsetM=bSupport.maxOffsetM},
        subjectPhysicalPrimitiveCount=aSupport.physicalPrimitiveCount,
        otherPhysicalPrimitiveCount=bSupport.physicalPrimitiveCount,
        representationBasis="CURRENT_PARTICIPATING_REPRESENTED_COMPONENTS",
        coverageComplete=aPhysical.coverageComplete==true and bPhysical.coverageComplete==true,
        negativeClearanceAuthority=aPhysical.negativeClearanceAuthority==true and bPhysical.negativeClearanceAuthority==true
    },nil
end

function Clearance.relativeDiscs(physical,space)
    if type(physical)~="table" then return nil,"CURRENT_PHYSICAL_SPACE_UNAVAILABLE" end
    local originX,originZ,poseReason=referencePose(space)
    if originX==nil then return nil,poseReason end
    local result={}
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical.primitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(tonumber(primitive.x)) and finite(tonumber(primitive.z))
            and finite(tonumber(primitive.radius)) and tonumber(primitive.radius)>0 then
            result[#result+1]={
                dx=tonumber(primitive.x)-originX,
                dz=tonumber(primitive.z)-originZ,
                radius=tonumber(primitive.radius),
                identity=primitive.identity
            }
        end
    end
    if #result<1 then return nil,"NO_CURRENT_PARTICIPATING_PHYSICAL_PRIMITIVES" end
    return result,nil
end


function Clearance.relativeDiscsFromObservedProfile(profile,space)
    if type(profile)~="table" or type(profile.relativeDiscs)~="table" then return nil,"OBSERVED_CONFIGURATION_PROFILE_GEOMETRY_UNAVAILABLE" end
    if type(space)~="table" or type(space.occupancy)~="table" then return nil,"CURRENT_REFERENCE_POSE_UNAVAILABLE" end
    local headingX,headingZ=tonumber(space.occupancy.headingX),tonumber(space.occupancy.headingZ)
    if not finite(headingX) or not finite(headingZ) then return nil,"CURRENT_REFERENCE_HEADING_UNAVAILABLE" end
    local length=math.sqrt(headingX*headingX+headingZ*headingZ)
    if length<=0.0001 then return nil,"CURRENT_REFERENCE_HEADING_UNAVAILABLE" end
    headingX,headingZ=headingX/length,headingZ/length
    local rightX,rightZ=headingZ,-headingX
    local result={}
    for _,disc in OuttaMyWay.ValueRecord.ipairs(profile.relativeDiscs or {}) do
        local localRight,localForward,radius=tonumber(disc.localRightM),tonumber(disc.localForwardM),tonumber(disc.radius)
        if finite(localRight) and finite(localForward) and finite(radius) and radius>0 then
            result[#result+1]={
                dx=rightX*localRight+headingX*localForward,
                dz=rightZ*localRight+headingZ*localForward,
                radius=radius,identity=disc.identity
            }
        end
    end
    if #result<1 then return nil,"OBSERVED_CONFIGURATION_PROFILE_GEOMETRY_EMPTY" end
    return result,nil
end

function Clearance.lateralSupportFromRelativeDiscs(discs,rightX,rightZ)
    if type(discs)~="table" or not finite(rightX) or not finite(rightZ) then return nil,"RELATIVE_DISC_OR_LATERAL_AXIS_UNAVAILABLE" end
    local minimum,maximum,count=nil,nil,0
    for _,disc in ipairs(discs) do
        local dx,dz,radius=tonumber(disc.dx),tonumber(disc.dz),tonumber(disc.radius)
        if finite(dx) and finite(dz) and finite(radius) and radius>0 then
            local offset=dx*rightX+dz*rightZ
            minimum=minimum==nil and offset-radius or math.min(minimum,offset-radius)
            maximum=maximum==nil and offset+radius or math.max(maximum,offset+radius)
            count=count+1
        end
    end
    if count<1 then return nil,"RELATIVE_DISC_GEOMETRY_EMPTY" end
    return {minOffsetM=minimum,maxOffsetM=maximum,physicalPrimitiveCount=count},nil
end


function Clearance.longitudinalSupportFromRelativeDiscs(discs,forwardX,forwardZ)
    if type(discs)~="table" or not finite(forwardX) or not finite(forwardZ) then return nil,"RELATIVE_DISC_OR_LONGITUDINAL_AXIS_UNAVAILABLE" end
    local length=math.sqrt(forwardX*forwardX+forwardZ*forwardZ)
    if length<=0.0001 then return nil,"LONGITUDINAL_AXIS_UNAVAILABLE" end
    forwardX,forwardZ=forwardX/length,forwardZ/length
    local minimum,maximum,count=nil,nil,0
    for _,disc in ipairs(discs) do
        local dx,dz,radius=tonumber(disc.dx),tonumber(disc.dz),tonumber(disc.radius)
        if finite(dx) and finite(dz) and finite(radius) and radius>0 then
            local offset=dx*forwardX+dz*forwardZ
            minimum=minimum==nil and offset-radius or math.min(minimum,offset-radius)
            maximum=maximum==nil and offset+radius or math.max(maximum,offset+radius)
            count=count+1
        end
    end
    if count<1 then return nil,"RELATIVE_DISC_GEOMETRY_EMPTY" end
    return {
        minOffsetM=minimum,maxOffsetM=maximum,
        frontExtentM=math.max(0,maximum),rearExtentM=math.max(0,-minimum),
        physicalPrimitiveCount=count
    },nil
end

function Clearance.radialReserveFromRelativeDiscs(discs)
    if type(discs)~="table" then return nil end
    local reserve,count=0,0
    for _,disc in ipairs(discs) do
        local dx,dz,radius=tonumber(disc.dx),tonumber(disc.dz),tonumber(disc.radius)
        if finite(dx) and finite(dz) and finite(radius) and radius>0 then reserve=math.max(reserve,math.sqrt(dx*dx+dz*dz)+radius); count=count+1 end
    end
    if count<1 then return nil end
    return reserve,count
end

function Clearance.minimumTranslatedDiscClearance(aDiscs,ax,az,bDiscs,bx,bz)
    if type(aDiscs)~="table" or type(bDiscs)~="table" then return nil end
    local minimum=math.huge
    for _,a in ipairs(aDiscs) do
        for _,b in ipairs(bDiscs) do
            local clearance=distance(ax+a.dx,az+a.dz,bx+b.dx,bz+b.dz)-a.radius-b.radius
            minimum=math.min(minimum,clearance)
        end
    end
    return minimum
end

function Clearance.minimumTranslatedDiscToWorldClearance(discs,x,z,worldPrimitives)
    if type(discs)~="table" or type(worldPrimitives)~="table" then return nil end
    local minimum=math.huge
    for _,disc in ipairs(discs) do
        for _,primitive in ipairs(worldPrimitives) do
            local clearance=distance(x+disc.dx,z+disc.dz,primitive.x,primitive.z)-disc.radius-primitive.radius
            minimum=math.min(minimum,clearance)
        end
    end
    return minimum
end

function Clearance.representedRadialReserve(physical,space)
    local discs,reason=Clearance.relativeDiscs(physical,space)
    if discs==nil then return nil,reason end
    local reserve=0
    for _,disc in ipairs(discs) do
        reserve=math.max(reserve,math.sqrt(disc.dx*disc.dx+disc.dz*disc.dz)+disc.radius)
    end
    return reserve,#discs
end


-- Purpose-scoped sequential Return-Space Clearance support.
--
-- Mutual Return Region is deliberately approximate: it bounds the realised
-- Shared Crossing Core and inflates that core by the waiting participant's
-- Transit-configured radial reserve. It does not reconstruct a swept path,
-- retain a historical Passage axis corridor or predict GIANTS-native motion.
function Clearance.mutualReturnRegion(guide,waitingAssemblyId,waitingTransitEnvelope)
    if type(guide)~="table" or type(guide.gates)~="table" then return nil,"MUTUAL_RETURN_GUIDE_UNAVAILABLE" end
    if type(waitingTransitEnvelope)~="table" then return nil,"MUTUAL_RETURN_WAITING_TRANSIT_ENVELOPE_UNAVAILABLE" end

    local entry,exit=nil,nil
    for _,gate in OuttaMyWay.ValueRecord.ipairs(guide.gates or {}) do
        if gate.kind=="CROSSING_WINDOW_ENTRY" then entry=gate
        elseif gate.kind=="CROSSING_WINDOW_EXIT" then exit=gate end
    end
    if entry==nil or exit==nil then return nil,"MUTUAL_RETURN_SHARED_CROSSING_CORE_UNAVAILABLE" end

    local points={}
    local function appendTarget(target)
        local x,z=tonumber(target and target.x),tonumber(target and target.z)
        if not finite(x) or not finite(z) then return false end
        points[#points+1]={x=x,z=z,assemblyId=target.assemblyId}
        return true
    end
    if not appendTarget(entry.subject) or not appendTarget(entry.other)
        or not appendTarget(exit.subject) or not appendTarget(exit.other) then
        return nil,"MUTUAL_RETURN_SHARED_CROSSING_TARGET_UNAVAILABLE"
    end

    local centreX,centreZ=0,0
    for _,point in OuttaMyWay.ValueRecord.ipairs(points) do
        centreX=centreX+point.x
        centreZ=centreZ+point.z
    end
    centreX=centreX/#points
    centreZ=centreZ/#points

    local coreRadius=0
    for _,point in OuttaMyWay.ValueRecord.ipairs(points) do
        coreRadius=math.max(coreRadius,distance(centreX,centreZ,point.x,point.z))
    end

    local minRight,maxRight=tonumber(waitingTransitEnvelope.minRightM),tonumber(waitingTransitEnvelope.maxRightM)
    local minForward,maxForward=tonumber(waitingTransitEnvelope.minForwardM),tonumber(waitingTransitEnvelope.maxForwardM)
    if not finite(minRight) or not finite(maxRight) or not finite(minForward) or not finite(maxForward) then
        return nil,"MUTUAL_RETURN_WAITING_TRANSIT_EXTENTS_UNAVAILABLE"
    end
    local maxRightAbs=math.max(math.abs(minRight),math.abs(maxRight))
    local maxForwardAbs=math.max(math.abs(minForward),math.abs(maxForward))
    local waitingReserve=math.sqrt(maxRightAbs*maxRightAbs+maxForwardAbs*maxForwardAbs)
    if not finite(waitingReserve) or waitingReserve<=0 then
        return nil,"MUTUAL_RETURN_WAITING_TRANSIT_RESERVE_INVALID"
    end

    return {
        centreX=centreX,centreZ=centreZ,
        coreRadiusM=coreRadius,
        waitingTransitReserveM=waitingReserve,
        radiusM=coreRadius+waitingReserve,
        waitingAssemblyId=waitingAssemblyId,
        pointCount=#points,
        basis="REALISED_SHARED_CROSSING_CORE_PLUS_WAITING_TRANSIT_RESERVE",
        negativeClearanceAuthority=false
    },nil
end

function Clearance.representedReturnSpaceClearance(region,physical,referenceX,referenceZ)
    if type(region)~="table" then return nil,"MUTUAL_RETURN_REGION_UNAVAILABLE" end
    local centreX,centreZ,radius=tonumber(region.centreX),tonumber(region.centreZ),tonumber(region.radiusM)
    local refX,refZ=tonumber(referenceX),tonumber(referenceZ)
    if not finite(centreX) or not finite(centreZ) or not finite(radius) or radius<=0 then
        return nil,"MUTUAL_RETURN_REGION_INVALID"
    end
    if not finite(refX) or not finite(refZ) then return nil,"RELEASED_PARTICIPANT_REFERENCE_UNAVAILABLE" end
    if type(physical)~="table" then return nil,"RELEASED_PARTICIPANT_PHYSICAL_REPRESENTATION_UNAVAILABLE" end

    local maximumReach=nil
    local count=0
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical.worldPrimitives or physical.primitives or {}) do
        local x,z,primitiveRadius=tonumber(primitive.x),tonumber(primitive.z),tonumber(primitive.radius)
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(x) and finite(z) and finite(primitiveRadius) and primitiveRadius>0 then
            local reach=distance(refX,refZ,x,z)+primitiveRadius
            maximumReach=maximumReach==nil and reach or math.max(maximumReach,reach)
            count=count+1
        end
    end
    if maximumReach==nil then
        return nil,"RELEASED_PARTICIPANT_CURRENT_PHYSICAL_PRIMITIVES_UNAVAILABLE"
    end

    local referenceDistance=distance(refX,refZ,centreX,centreZ)
    local clearance=referenceDistance-(maximumReach+radius)
    return {
        clear=clearance>=0,
        clearanceM=clearance,
        releasedReferenceDistanceM=referenceDistance,
        releasedRepresentedReachM=maximumReach,
        mutualReturnRegionRadiusM=radius,
        mutualReturnCoreRadiusM=tonumber(region.coreRadiusM),
        waitingTransitReserveM=tonumber(region.waitingTransitReserveM),
        physicalPrimitiveCount=count,
        basis="CURRENT_REPRESENTED_RADIAL_OCCUPANCY_VS_MUTUAL_RETURN_REGION",
        negativeClearanceAuthority=false
    },nil
end
