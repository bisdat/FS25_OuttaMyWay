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

-- Every candidate is sampled through the full represented member footprint.
-- A polygon edge bounds the reachable region; it does NOT veto a useful
-- shorter movement merely because WORKING width + 5 m will not fit.
-- This is nominal translation evidence, not a predicted steering/folding sweep.
local MIN_USEFUL_TRAVEL_M=3
local AXIAL_COS_LIMIT=math.cos(math.rad(12))
local STEERING_COS_LIMIT=math.cos(math.rad(80))
local DISCOVERY_DIRECTIONS=32

local function regionStepValid(poly,foot,dx,dz,t,scene,otherFoot)
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
    -- The other participant is not part of the generic third-party census.
    -- Its nominal body/TRANSIT rectangle still constrains the mover's sweep.
    -- The actual WORKING boom and changing fold envelope remain unknown.
    for j=1,#scene do
        local o=scene[j]
        if lowX<o.maxX+MARGIN_M and highX>o.minX-MARGIN_M
            and lowZ<o.maxZ+MARGIN_M and highZ>o.minZ-MARGIN_M then
            return false
        end
    end
    local minX,maxX,minZ,maxZ
    for j=1,#otherFoot.corners do
        local p=otherFoot.corners[j]
        local x,z=otherFoot.rootX+p.x,otherFoot.rootZ+p.z
        minX=minX and math.min(minX,x) or x
        maxX=maxX and math.max(maxX,x) or x
        minZ=minZ and math.min(minZ,z) or z
        maxZ=maxZ and math.max(maxZ,z) or z
    end
    -- Existing pair overlap at admission is not a reason to prohibit
    -- withdrawal. Its intersection area must never INCREASE along the
    -- sampled corridor. New overlap from a separated start is forbidden.
    local overlapX=math.max(0,math.min(highX,maxX+MARGIN_M)
        -math.max(lowX,minX-MARGIN_M))
    local overlapZ=math.max(0,math.min(highZ,maxZ+MARGIN_M)
        -math.max(lowZ,minZ-MARGIN_M))
    return true,overlapX*overlapZ
end

local function reachableTravel(poly,foot,dx,dz,desired,scene,otherFoot)
    -- Preserve exact full travel when it fits. For boundaries/obstacles,
    -- return the last sampled safe distance (never the first unsafe step).
    local valid,previousOverlap=regionStepValid(
        poly,foot,dx,dz,0,scene,otherFoot)
    if not valid then return 0 end
    local travelled=0
    while travelled+0.0001<desired do
        local nextM=math.min(desired,travelled+STEP_M)
        local allowed,overlap=regionStepValid(
            poly,foot,dx,dz,nextM,scene,otherFoot)
        if not allowed or overlap>previousOverlap+0.0001 then break end
        travelled,previousOverlap=nextM,overlap
    end
    return travelled
end

-- Read GIANTS' already populated immediate target only as a soft preference.
-- This is not a future-course cursor and MUST NOT veto an otherwise safe exit.
local function immediateDemand(other)
    local spec=other.vehicle.spec_aiFieldWorker
    local drive=type(spec)=="table" and spec.aiDriveParams or nil
    if type(drive)~="table" or drive.valid~=true then return nil,nil end
    return direction(drive.tX-other.x,drive.tZ-other.z)
end

-- Spatially discover reachable sectors for BOTH possible movers. The 70°
-- reverse is included explicitly because TS015 physically validated it.
-- Other sectors are sampled around the current location, then assigned the
-- native forward/reverse mechanism that can steer toward that region.
-- Only near-AXIAL directions are excluded, not directions predominantly
-- lateral to both workers (impossible at right-angle crossings).
function Region.planPair(commitment,preferred,alternative)
    if type(commitment)~="table" or type(commitment.fieldPolygon)~="table"
        or type(commitment.fieldCentroid)~="table" then
        return nil,nil,nil,"PAIR_REGION_EVIDENCE_UNAVAILABLE"
    end
    local scene,sceneAvailable=sceneOccupancy(
        preferred,alternative,commitment.fieldPolygon)
    local candidates,optionSectors={},{{},{}}
    local attempts=0
    for moverIndex,mover in ipairs({preferred,alternative}) do
        local other=mover==preferred and alternative or preferred
        local foot,otherFoot=mover.transitFootprint,other.transitFootprint
        local width=other.workingWidthM
        if type(foot)=="table" and type(otherFoot)=="table"
            and finite(width) and width>0 then
            local otherX,otherZ=heading(other.vehicle,"getAISteeringNode",false)
            local backX,backZ=heading(mover.vehicle,"getAIReverserNode",true)
            local frontX,frontZ=heading(mover.vehicle,"getAISteeringNode",false)
            if otherX~=nil and backX~=nil and frontX~=nil then
                local nx,nz=-otherZ,otherX
                local toOtherX=otherFoot.rootX-foot.rootX
                local toOtherZ=otherFoot.rootZ-foot.rootZ
                local startCross=(-toOtherX)*nx+(-toOtherZ)*nz
                local centreX=commitment.fieldCentroid.x-foot.rootX
                local centreZ=commitment.fieldCentroid.z-foot.rootZ
                local intentX,intentZ=immediateDemand(other)
                local rays={}
                local cosine=math.cos(math.rad(70))
                local sine=math.sin(math.rad(70))
                for _,side in ipairs({-1,1}) do
                    rays[#rays+1]={dx=cosine*backX-side*sine*backZ,
                        dz=cosine*backZ+side*sine*backX,
                        mode="OBLIQUE_REVERSE",side=side,reverse=true,
                        validatedBearing=true}
                end
                for k=0,DISCOVERY_DIRECTIONS-1 do
                    local radians=2*math.pi*k/DISCOVERY_DIRECTIONS
                    local dx,dz=math.cos(radians),math.sin(radians)
                    local forwardAlignment=dx*frontX+dz*frontZ
                    local reverse=forwardAlignment<0
                    rays[#rays+1]={dx=dx,dz=dz,
                        mode=reverse and "REVERSE_REGION" or "FORWARD_REGION",
                        side=0,reverse=reverse,validatedBearing=false}
                end
                for _,ray in ipairs(rays) do
                    attempts=attempts+1
                    local dx,dz=ray.dx,ray.dz
                    local crossRate=dx*nx+dz*nz
                    local alongMover=dx*frontX+dz*frontZ
                    local alongOther=dx*otherX+dz*otherZ
                    -- Genuine departure from the occupied area; neither
                    -- actor's forward OR reverse longitudinal axis may be
                    -- mistaken for an egress direction.
                    if math.abs(alongMover)<AXIAL_COS_LIMIT
                        and math.abs(alongOther)<AXIAL_COS_LIMIT
                        and math.abs(alongMover)>=STEERING_COS_LIMIT
                        and math.abs(crossRate)>=0.12
                        and dx*toOtherX+dz*toOtherZ<=0.0001
                        and (math.abs(startCross)<=0.5
                            or startCross*crossRate>=0) then
                        local fullTravel=width+WORK_CORRIDOR_MARGIN_M
                        local travel=reachableTravel(commitment.fieldPolygon,
                            foot,dx,dz,fullTravel,scene,otherFoot)
                        local separationGain=math.sqrt(
                            (toOtherX-dx*travel)^2+
                            (toOtherZ-dz*travel)^2)
                            -math.sqrt(toOtherX^2+toOtherZ^2)
                        local crossGain=travel*math.abs(crossRate)
                        if travel>=MIN_USEFUL_TRAVEL_M
                            and separationGain>=0.5 and crossGain>=0.5 then
                            local centreScore=dx*centreX+dz*centreZ
                            local crossSign=crossRate<0 and -1 or 1
                            local horizon=travel+40
                            local demandGain=0
                            if intentX~=nil then
                                -- Relative to the other worker's currently
                                -- commanded line, not an invented future pass.
                                local start=(-toOtherX)*(-intentZ)
                                    +(-toOtherZ)*intentX
                                local finish=start+travel*
                                    (dx*(-intentZ)+dz*intentX)
                                demandGain=math.abs(finish)-math.abs(start)
                            end
                            local sector=math.floor(
                                ((math.atan2 and math.atan2(dz,dx)
                                    or math.atan(dz,dx))+2*math.pi)
                                    /(math.pi/4))%8
                            optionSectors[moverIndex][sector]=true
                            local region={
                                source="PAIR_WORKING_CORRIDOR_TRAVEL_REGION",
                                originX=foot.rootX,originZ=foot.rootZ,
                                directionX=dx,directionZ=dz,
                                blockerOriginX=otherFoot.rootX,
                                blockerOriginZ=otherFoot.rootZ,
                                corridorNormalX=nx,corridorNormalZ=nz,
                                sideSign=crossSign,
                                initialCrossTrackM=crossSign*startCross,
                                projectedCrossTrackProgressM=crossGain,
                                requiredProgressM=travel,
                                isPhysicalPairClearanceConfirmed=false}
                            local c={
                                isReverse=ray.reverse,
                                moveForwards=not ray.reverse,
                                isPartialEgress=travel<fullTravel-0.001,
                                nominalFullTravelM=fullTravel,
                                steeringHorizonM=horizon,
                                targetX=foot.rootX+dx*horizon,
                                targetZ=foot.rootZ+dz*horizon,
                                returnRegion=region,
                                directionSource=ray.mode,
                                cascadeMode=ray.mode,egressSide=ray.side,
                                regionTravelM=travel,vectorDistanceM=travel,
                                remainingWorkingWidthM=width,
                                workingCorridorMarginM=WORK_CORRIDOR_MARGIN_M,
                                marginM=MARGIN_M,targetInField=true,
                                fieldInteriorScore=centreScore,
                                localDemandSeparationGainM=demandGain,
                                achievedNominalSeparationGainM=separationGain,
                                transitGeometryBasis=foot.basis,
                                sceneOccupancyChecked=sceneAvailable,
                                nominalBearingOffsetDeg=
                                    ray.validatedBearing and 70 or nil,
                                nativeReverseHeadingX=backX,
                                nativeReverseHeadingZ=backZ,
                                isValidatedBearing=ray.validatedBearing,
                                moverIndex=moverIndex,
                                mover=mover,other=other}
                            candidates[#candidates+1]=c
                        end
                    end
                end
            end
        end
    end
    local options={0,0}
    for i=1,2 do
        for _ in pairs(optionSectors[i]) do options[i]=options[i]+1 end
    end
    local best
    for i=1,#candidates do
        local c=candidates[i]
        c.egressOptionality=options[c.moverIndex]
        if best==nil then
            best=c
        else
            -- A complete egress outranks a staging move. Among complete
            -- paths retain TS015's proven ±70° reverse precedence; then
            -- prefer genuine spatial optionality before centroid position.
            local better=false
            if c.isPartialEgress~=best.isPartialEgress then
                better=not c.isPartialEgress
            elseif c.isValidatedBearing~=best.isValidatedBearing then
                better=c.isValidatedBearing
            elseif c.egressOptionality~=best.egressOptionality then
                better=c.egressOptionality>best.egressOptionality
            elseif math.abs(c.regionTravelM-best.regionTravelM)>0.01 then
                better=c.regionTravelM>best.regionTravelM
            elseif math.abs(c.localDemandSeparationGainM-
                    best.localDemandSeparationGainM)>0.01 then
                better=c.localDemandSeparationGainM>
                    best.localDemandSeparationGainM
            elseif c.moverIndex~=best.moverIndex then
                better=c.moverIndex<best.moverIndex
            else
                better=c.fieldInteriorScore>best.fieldInteriorScore+0.01
            end
            if better then best=c end
        end
    end
    if best==nil then return nil,nil,nil,"NO_SAFE_PAIR_EGRESS_REGION" end
    local mover,other=best.mover,best.other
    best.mover=nil;best.other=nil;best.moverIndex=nil
    best.cascadeAttempts=attempts
    return best,mover,other
end
