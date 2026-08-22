-- FS25_OuttaMyWay v0.1.0.4 TEST — D-0146 Pair-Specific Passage Clearance helper.
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
