-- Raw GIANTS field-worker observation surface.
-- Observation only: this module reports native field-course facts and grants no
-- Productive/Transitional semantic authority. SituationAssessment owns any
-- promotion of these facts into operational Knowledge.

OuttaMyWay.NativeFieldWorkObservation = {}
local Observation = OuttaMyWay.NativeFieldWorkObservation

local function safeCall(object, methodName, ...)
    if object == nil or type(object[methodName]) ~= "function" then return false, nil end
    return pcall(object[methodName], object, ...)
end


local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function nodePoint(node)
    if node==nil or node==0 or type(getWorldTranslation)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,node)
    if not ok or not finite(x) or not finite(z) then return nil end
    return {x=x,z=z}
end

local function markerWidth(leftNode,rightNode)
    local left,right=nodePoint(leftNode),nodePoint(rightNode)
    if left==nil or right==nil then return nil end
    local dx,dz=right.x-left.x,right.z-left.z
    local width=math.sqrt(dx*dx+dz*dz)
    if not finite(width) or width<0.5 or width>100 then return nil end
    return width
end

local function collectAttached(root)
    local out,seen={},{}
    local function scan(object)
        if object==nil or seen[object] or object.isDeleted==true then return end
        seen[object]=true; out[#out+1]=object
        if type(object.getAttachedImplements)=="function" then
            local ok,attached=pcall(object.getAttachedImplements,object)
            if ok and type(attached)=="table" then
                for _,entry in pairs(attached) do
                    if type(entry)=="table" then scan(entry.object or entry.implement or entry.vehicle or entry[1]) else scan(entry) end
                end
            end
        end
    end
    scan(root)
    return out
end

-- Raw working-width observation used only as an evidence seed.  It is not the
-- physical Assembly footprint and does not qualify boundary demand by itself.
local function workingWidthObservation(vehicle)
    local bestWidth,bestSource=nil,nil
    local function consider(width,source)
        if width~=nil and (bestWidth==nil or width>bestWidth) then bestWidth=width; bestSource=source end
    end
    for _,object in ipairs(collectAttached(vehicle)) do
        if type(object.getAIMarkers)=="function" then
            local ok,left,right=pcall(object.getAIMarkers,object)
            if ok then consider(markerWidth(left,right),"GIANTS_AI_MARKERS") end
        end
        local spec=object.spec_workArea
        if type(spec)=="table" and type(spec.workAreas)=="table" then
            for _,area in pairs(spec.workAreas) do
                if type(area)=="table" then
                    consider(markerWidth(area.start or area.startNode,area.width or area.widthNode),"GIANTS_WORK_AREA_MARKERS")
                end
            end
        end
        if type(object.getWorkingWidth)=="function" then
            local ok,width=pcall(object.getWorkingWidth,object)
            width=ok and tonumber(width) or nil
            if finite(width) and width>=0.5 and width<=100 then consider(width,"GIANTS_WORKING_WIDTH_ACCESSOR") end
        end
    end
    return {available=bestWidth~=nil,widthMetres=bestWidth,source=bestSource or "UNAVAILABLE",authority="PROVISIONAL_DEMAND_SEED_INPUT_ONLY"}
end

-- Exact SDK + D-0138 live evidence identify aiDriveParams as the immediate
-- native field-worker command before the P22 driveToPoint wrapper.  Reading it
-- here makes that raw Observation available to Situation Assessment without
-- letting Diagnostics become an authority source.
local function nativeDriveCommandObservation(vehicle)
    local spec=vehicle and vehicle.spec_aiFieldWorker or nil
    local params=spec and spec.aiDriveParams or nil
    if type(params)~="table" then return {available=false,valid=false,reason="AI_DRIVE_PARAMS_UNAVAILABLE"} end
    local valid=params.valid==true
    local moveForwards=params.moveForwards
    if moveForwards~=true and moveForwards~=false then moveForwards=nil end
    local maxSpeed=tonumber(params.maxSpeed)
    return {
        available=true,valid=valid,moveForwards=moveForwards,maxSpeedKmh=maxSpeed,
        targetX=tonumber(params.tX),targetY=tonumber(params.tY),targetZ=tonumber(params.tZ),
        zeroCommand=valid and maxSpeed==0 and tonumber(params.tX)==0 and tonumber(params.tZ)==0 or false,
        authority="IMMEDIATE_NATIVE_FIELD_WORKER_DRIVE_COMMAND_ONLY"
    }
end

local function className(value)
    if value == nil then return "nil" end
    if type(value) == "table" then
        if value.className ~= nil then return tostring(value.className) end
        if type(value.class) == "table" and value.class.className ~= nil then return tostring(value.class.className) end
    end
    return tostring(value)
end

local function appendStrategies(candidates, spec, source)
    if type(spec) ~= "table" or type(spec.driveStrategies) ~= "table" then return end
    for index, strategy in pairs(spec.driveStrategies) do
        candidates[#candidates + 1] = {strategy=strategy,source=string.format("%s.driveStrategies[%s]",source,tostring(index))}
    end
end

local function findFieldCourseStrategy(vehicle)
    if vehicle == nil then return nil,"NO_VEHICLE" end
    local candidates={}
    appendStrategies(candidates,vehicle.spec_aiVehicle,"spec_aiVehicle")
    appendStrategies(candidates,vehicle.spec_aiFieldWorker,"spec_aiFieldWorker")
    appendStrategies(candidates,vehicle,"vehicle")
    for _,candidate in ipairs(candidates) do
        local strategy=candidate.strategy
        local name=className(strategy)
        if strategy~=nil and (strategy.aiFieldCourse~=nil or string.find(name,"FieldCourse",1,true)~=nil) then
            return strategy,candidate.source
        end
    end
    return nil,#candidates>0 and ("SEARCHED_"..tostring(#candidates).."_STRATEGIES") or "NO_STRATEGY_ARRAYS"
end

local function activeSegmentEvidence(strategy)
    local course=strategy and strategy.aiFieldCourse or nil
    if course==nil or type(course.getActiveSegmentData)~="function" then
        return {available=false,reason="ACTIVE_SEGMENT_DATA_UNAVAILABLE"}
    end
    local ok,isTurn,isInitial,segmentPosition,segmentLength,subSegmentPosition,subSegmentLength=pcall(course.getActiveSegmentData,course)
    if not ok then return {available=false,reason="ACTIVE_SEGMENT_DATA_CALL_FAILED"} end
    return {
        available=true,isTurn=isTurn,isInitial=isInitial,
        segmentPosition=tonumber(segmentPosition),segmentLength=tonumber(segmentLength),
        subSegmentPosition=tonumber(subSegmentPosition),subSegmentLength=tonumber(subSegmentLength)
    }
end

local function implementLineEvidence(strategy)
    local data=strategy and strategy.implementData or nil
    if type(data)~="table" then
        return {classification="UNAVAILABLE",total=0,resolved=0,lowered=0,raised=0,unresolved=0}
    end
    local result={classification="UNRESOLVED",total=0,resolved=0,lowered=0,raised=0,unresolved=0}
    for _,entry in pairs(data) do
        if type(entry)=="table" then
            result.total=result.total+1
            if entry.isLowered==true then result.resolved=result.resolved+1; result.lowered=result.lowered+1
            elseif entry.isLowered==false then result.resolved=result.resolved+1; result.raised=result.raised+1
            else result.unresolved=result.unresolved+1 end
        end
    end
    if result.total==0 then result.classification="EMPTY"
    elseif result.unresolved>0 then result.classification="UNRESOLVED"
    elseif result.lowered>0 and result.raised>0 then result.classification="MIXED"
    elseif result.lowered>0 then result.classification="ACTIVE"
    elseif result.raised>0 then result.classification="INACTIVE" end
    return result
end

function Observation.observe(vehicle)
    local strategy,strategySource=findFieldCourseStrategy(vehicle)
    local segment=activeSegmentEvidence(strategy)
    local line=implementLineEvidence(strategy)
    local settings=strategy and strategy.fieldCourseSettings or nil
    local workingWidth=workingWidthObservation(vehicle)
    local nativeDriveCommand=nativeDriveCommandObservation(vehicle)
    return {
        strategyAvailable=strategy~=nil,
        strategySource=strategySource,
        strategyClassName=className(strategy),
        segmentAvailable=segment.available==true,
        segmentReason=segment.reason,
        isTurn=segment.isTurn,
        isInitial=segment.isInitial,
        segmentPosition=segment.segmentPosition,
        segmentLength=segment.segmentLength,
        subSegmentPosition=segment.subSegmentPosition,
        subSegmentLength=segment.subSegmentLength,
        implementLineClassification=line.classification,
        implementTotal=line.total,
        implementResolved=line.resolved,
        implementLowered=line.lowered,
        implementRaised=line.raised,
        implementUnresolved=line.unresolved,
        movingDirection=strategy and tonumber(strategy.lastMovingDirection) or nil,
        toolAlwaysActive=settings and settings.toolAlwaysActive or nil,
        continueWork=strategy and strategy.lastContinueWorkState or nil,
        workingWidth=workingWidth,
        nativeDriveCommand=nativeDriveCommand,
        provenance={source="NativeFieldWorkObservation",layer="OBSERVATION",semanticAuthority=false}
    }
end
