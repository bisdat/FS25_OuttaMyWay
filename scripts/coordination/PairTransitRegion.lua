-- Bounded pair-local TRANSIT geometry for egress-region candidates.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- GIANTS base-size rectangles are directional *candidate* evidence, not
-- comprehensive collision-shape closure or proof of native steering sweep.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.PairTransitRegion={}
local Region=OuttaMyWay.PairTransitRegion
local MARGIN_M=1 -- nominal physical gap for envelope/scene intersections
local WORK_CORRIDOR_MARGIN_M=5 -- accepted pair relocation distance addition
local STEP_M=2
local MAX_MEMBERS=16

local function finite(v)
    return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge
end
local function direction(x,z)
    if not finite(x) or not finite(z) then return nil,nil end
    local d=math.sqrt(x*x+z*z)
    if d<0.0001 then return nil,nil end
    return x/d,z/d
end
-- A genuine pair exit is lateral to both participants, not longitudinal.
local function lateralDominates(dx,dz,fx,fz)
    return math.abs(dx*(-fz)+dz*fx)>math.abs(dx*fx+dz*fz)+0.000001
end

local function heading(vehicle,name,reverse)
    if type(vehicle)~="table" or type(vehicle[name])~="function"
        or type(localDirectionToWorld)~="function" then return nil,nil end
    local ok,node=pcall(vehicle[name],vehicle)
    if not ok or node==nil or node==0 then return nil,nil end
    local result,x,_,z=pcall(localDirectionToWorld,node,0,0,1)
    if not result then return nil,nil end
    local fx,fz=direction(x,z)
    if fx==nil then return nil,nil end
    return reverse and -fx or fx,reverse and -fz or fz
end
local function memberSize(object)
    local width,length,woff,loff
    local xml=object.xmlFile
    if type(xml)=="table" and type(xml.getValue)=="function" then
        local function read(key)
            local ok,value=pcall(xml.getValue,xml,key)
            return ok and tonumber(value) or nil
        end
        width=read("vehicle.base.size#width")
        length=read("vehicle.base.size#length")
        woff=read("vehicle.base.size#widthOffset") or 0
        loff=read("vehicle.base.size#lengthOffset") or 0
    end
    if not finite(width) or not finite(length) then
        width=tonumber(object.sizeWidth)
        length=tonumber(object.sizeLength)
        woff,loff=0,0
    end
    if not finite(width) or not finite(length) or width<=0
        or length<=0 or width>=150 or length>=150
        or not finite(woff) or not finite(loff) then
        return nil
    end
    return width,length,woff,loff
end
-- Capture the selected real assembly once after TRANSIT preparation; no
-- catalogue variants, optimistic folding widths, or working-area dimensions.
function Region.capture(vehicle)
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(getWorldTranslation)~="function"
        or type(localToWorld)~="function" then
        return nil,"TRANSIT_ROOT_EVIDENCE_UNAVAILABLE"
    end
    local ok,rootX,_,rootZ=pcall(getWorldTranslation,vehicle.rootNode)
    if not ok or not finite(rootX) or not finite(rootZ) then
        return nil,"TRANSIT_ROOT_EVIDENCE_UNAVAILABLE"
    end
    local corners,seen,count={}, {},0
    local function visit(object)
        if type(object)~="table" or object.isDeleted==true
            or object.rootNode==nil then return false,"TRANSIT_MEMBER_UNAVAILABLE" end
        if seen[object] then return true end
        seen[object]=true
        count=count+1
        if count>MAX_MEMBERS then return false,"TRANSIT_MEMBER_BUDGET_EXCEEDED" end
        local w,l,wo,lo=memberSize(object)
        if w==nil then return false,"TRANSIT_MEMBER_SIZE_UNAVAILABLE" end
        for _,right in ipairs({-1,1}) do
            for _,forward in ipairs({-1,1}) do
                local placed,x,_,z=pcall(localToWorld,object.rootNode,
                    wo+right*w*0.5,0,lo+forward*l*0.5)
                if not placed or not finite(x) or not finite(z) then
                    return false,"TRANSIT_MEMBER_TRANSFORM_UNAVAILABLE"
                end
                corners[#corners+1]={x=x-rootX,z=z-rootZ}
            end
        end
        if type(object.getAttachedImplements)=="function" then
            local got,attachments=pcall(object.getAttachedImplements,object)
            if not got or type(attachments)~="table" then
                return false,"TRANSIT_ATTACHMENT_EVIDENCE_UNAVAILABLE"
            end
            for _,item in pairs(attachments) do
                local child=type(item)=="table" and (item.object or item)
                local valid,why=visit(child)
                if not valid then return false,why end
            end
        end
        return true
    end
    local valid,reason=visit(vehicle)
    if not valid or #corners==0 then return nil,reason or "TRANSIT_ENVELOPE_UNAVAILABLE" end
    return {rootX=rootX,rootZ=rootZ,corners=corners,memberCount=count,
        memberObjects=seen,
        basis="GIANTS_SELECTED_RUNTIME_BASE_SIZE_UNION",
        negativeClearanceAuthority=false},nil
end

local function inside(poly,x,z)
    if type(poly)~="table" or type(poly.xs)~="table"
        or type(poly.zs)~="table" or #poly.xs<3
        or #poly.xs~=#poly.zs then return false end
    local result=false
    for i=1,#poly.xs do
        local j=i==1 and #poly.xs or i-1
        if (poly.zs[i]>z)~=(poly.zs[j]>z) then
            local edge=poly.xs[j]+(poly.xs[i]-poly.xs[j])*
                (z-poly.zs[j])/(poly.zs[i]-poly.zs[j])
            if x<edge then result=not result end
        end
    end
    return result
end
-- One finite scene census per admitted pair assessment, never per frame.
-- Other active/non-active physical assemblies may occupy candidate regions.
-- Missing shapes remain root-only uncertainty, never claimed full clearance.
local function sceneOccupancy(first,second,poly)
    local source=g_currentMission and g_currentMission.vehicles
    if type(source)~="table" then return {},false end
    local objects,seen={},{}
    local count=0
    for _,vehicle in pairs(source) do
        count=count+1
        if count>512 then return objects,false end
        if type(vehicle)=="table" and vehicle~=first.vehicle
            and vehicle~=second.vehicle
            and not (first.transitFootprint.memberObjects
                and first.transitFootprint.memberObjects[vehicle])
            and not (second.transitFootprint.memberObjects
                and second.transitFootprint.memberObjects[vehicle])
            and vehicle.rootNode~=nil
            and not seen[vehicle.rootNode] then
            seen[vehicle.rootNode]=true
            local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
            if ok and finite(x) and finite(z) and inside(poly,x,z) then
                local footprint=Region.capture(vehicle)
                local lowX,highX,lowZ,highZ=x,x,z,z
                if footprint~=nil then
                    for i=1,#footprint.corners do
                        local p=footprint.corners[i]
                        local px,pz=x+p.x,z+p.z
                        lowX,highX=math.min(lowX,px),math.max(highX,px)
                        lowZ,highZ=math.min(lowZ,pz),math.max(highZ,pz)
                    end
                end
                objects[#objects+1]={minX=lowX,maxX=highX,
                    minZ=lowZ,maxZ=highZ,hasShape=footprint~=nil}
            end
        end
    end
    return objects,true
end

-- Translation-sweep candidate: every *represented member corner* is
-- sampled at every step. This is stronger than root containment, but native
-- steering curvature and missing collision primitives remain validation risks.
local function pathInField(poly,foot,dx,dz,distance,scene)
    local count=math.max(1,math.ceil(distance/STEP_M))
    for i=0,count do
        local t=distance*i/count
        local lowX,highX,lowZ,highZ
        for j=1,#foot.corners do
            local p=foot.corners[j]
            local x,z=foot.rootX+p.x+dx*t,foot.rootZ+p.z+dz*t
            if not inside(poly,x,z) then return false end
            lowX=lowX and math.min(lowX,x) or x
            highX=highX and math.max(highX,x) or x
            lowZ=lowZ and math.min(lowZ,z) or z
            highZ=highZ and math.max(highZ,z) or z
        end
        for j=1,#scene do
            local occupied=scene[j]
            if lowX<occupied.maxX+MARGIN_M
                and highX>occupied.minX-MARGIN_M
                and lowZ<occupied.maxZ+MARGIN_M
                and highZ>occupied.minZ-MARGIN_M then
                return false
            end
        end
    end
    return true
end
-- Evaluate both 70-degree oblique reverse sides for each mover first,
-- then only non-axial centroid alternatives. All routes must withdraw from
-- the other assembly. Keep the remaining worker's WORKING width + 5 m travel.
function Region.planPair(commitment,preferred,alternative)
    if type(commitment)~="table" or type(commitment.fieldPolygon)~="table"
        or type(commitment.fieldCentroid)~="table" then
        return nil,nil,nil,"PAIR_REGION_EVIDENCE_UNAVAILABLE"
    end
    local scene,sceneAvailable=sceneOccupancy(
        preferred,alternative,commitment.fieldPolygon)
    local best,chosenMover,chosenOther,attempts=nil,nil,nil,0
    for _,mover in ipairs({preferred,alternative}) do
        local other=mover==preferred and alternative or preferred
        local foot,otherFoot=mover.transitFootprint,other.transitFootprint
        local otherWorkingWidth=other.workingWidthM
        if type(foot)=="table" and type(otherFoot)=="table"
            and finite(otherWorkingWidth) and otherWorkingWidth>0 then
            local fx,fz=heading(other.vehicle,"getAISteeringNode",false)
            local backX,backZ=heading(mover.vehicle,"getAIReverserNode",true)
            local forwardX,forwardZ=heading(mover.vehicle,"getAISteeringNode",false)
            if fx~=nil and forwardX~=nil then
                local nx,nz=-fz,fx
                local centreX=commitment.fieldCentroid.x-foot.rootX
                local centreZ=commitment.fieldCentroid.z-foot.rootZ
                local cx,cz=direction(centreX,centreZ)
                local centreDist=math.sqrt(centreX*centreX+centreZ*centreZ)
                local rays={}
                if backX~=nil then
                    local cosine=math.cos(math.rad(70))
                    local sine=math.sin(math.rad(70))
                    for _,side in ipairs({-1,1}) do
                        rays[#rays+1]={mode="OBLIQUE_REVERSE",side=side,
                            dx=cosine*backX-side*sine*backZ,
                            dz=cosine*backZ+side*sine*backX,
                            reverse=true}
                    end
                end
                if cx~=nil then
                    rays[#rays+1]={mode="CENTROID",side=0,
                        dx=cx,dz=cz,reverse=false}
                end
                local toOtherX=otherFoot.rootX-foot.rootX
                local toOtherZ=otherFoot.rootZ-foot.rootZ
                for _,ray in ipairs(rays) do
                    attempts=attempts+1
                    local rate=ray.dx*nx+ray.dz*nz
                    -- Exclude axial paths on EITHER participant. A centroid
                    -- request must not start forward into a head-on worker.
                    if math.abs(rate)>0.1
                        and lateralDominates(ray.dx,ray.dz,forwardX,forwardZ)
                        and lateralDominates(ray.dx,ray.dz,fx,fz)
                        and ray.dx*toOtherX+ray.dz*toOtherZ<=0.001
                        and (ray.reverse or forwardX*toOtherX
                            +forwardZ*toOtherZ<=0.001) then
                        local sign=rate>0 and 1 or -1
                        local travel=otherWorkingWidth+WORK_CORRIDOR_MARGIN_M
                        local canReach=ray.mode~="CENTROID"
                            or travel<=centreDist
                        if canReach and pathInField(commitment.fieldPolygon,
                            foot,ray.dx,ray.dz,travel,scene) then
                            local rootCross=(foot.rootX-otherFoot.rootX)*nx+
                                (foot.rootZ-otherFoot.rootZ)*nz
                            local signedStart=sign*rootCross
                            local crossProgress=travel*math.abs(rate)
                            local centreScore=ray.dx*centreX+ray.dz*centreZ
                            local candidate={
                                isReverse=ray.reverse,moveForwards=not ray.reverse,
                                steeringHorizonM=ray.mode=="CENTROID"
                                    and centreDist or travel+40,
                                returnRegion={
                                    source="PAIR_WORKING_CORRIDOR_TRAVEL_REGION",
                                    originX=foot.rootX,originZ=foot.rootZ,
                                    directionX=ray.dx,directionZ=ray.dz,
                                    blockerOriginX=otherFoot.rootX,
                                    blockerOriginZ=otherFoot.rootZ,
                                    corridorNormalX=nx,corridorNormalZ=nz,
                                    sideSign=sign,initialCrossTrackM=signedStart,
                                    projectedCrossTrackProgressM=crossProgress,
                                    requiredProgressM=travel,
                                    isPhysicalPairClearanceConfirmed=false},
                                directionSource=ray.reverse
                                    and "OBLIQUE_REVERSE" or "PAIR_CENTROID",
                                cascadeMode=ray.mode,egressSide=ray.side,
                                regionTravelM=travel,vectorDistanceM=travel,
                                remainingWorkingWidthM=otherWorkingWidth,
                                workingCorridorMarginM=WORK_CORRIDOR_MARGIN_M,
                                marginM=MARGIN_M,targetInField=true,
                                fieldInteriorScore=centreScore,
                                transitGeometryBasis=foot.basis,
                                sceneOccupancyChecked=sceneAvailable,
                                nominalBearingOffsetDeg=ray.reverse and 70 or nil,
                                nativeReverseHeadingX=backX,
                                nativeReverseHeadingZ=backZ}
                            candidate.targetX=foot.rootX+
                                ray.dx*candidate.steeringHorizonM
                            candidate.targetZ=foot.rootZ+
                                ray.dz*candidate.steeringHorizonM
                            -- Actual cascade: 70-degree oblique reverse
                            -- before centroid. Within each mode prefer the
                            -- centroid-nearer mover, then best in-field side.
                            local tier=ray.reverse and 1 or 2
                            local previousTier=best and (best.isReverse and 1 or 2)
                                or 3
                            local firstMover=mover==preferred
                            local previousFirst=chosenMover==preferred
                            if best==nil or tier<previousTier
                                or (tier==previousTier
                                    and ((firstMover and not previousFirst)
                                        or (firstMover==previousFirst
                                            and centreScore>best.fieldInteriorScore
                                                +0.01))) then
                                best,chosenMover,chosenOther=candidate,mover,other
                            end
                        end
                    end
                end
            end
        end
    end
    if best==nil then return nil,nil,nil,"NO_FEASIBLE_PAIR_EGRESS" end
    best.cascadeAttempts=attempts
    return best,chosenMover,chosenOther
end
