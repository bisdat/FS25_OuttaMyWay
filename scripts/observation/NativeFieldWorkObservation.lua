--- Acquires current GIANTS native field-work evidence without converting it into Situation or Control authority.
-- Specification Jurisdictions: `OBSERVATION`

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
    return width,left,right
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

local function validWidth(value)
    value=tonumber(value)
    if not finite(value) or value<0.5 or value>100 then return nil end
    return value
end

local function variableWorkWidthSpan(object)
    local spec=type(object)=="table" and object.spec_variableWorkWidth or nil
    local nodes=type(spec)=="table" and spec.sectionNodes or nil
    if type(nodes)~="table" then return nil end
    local leftMax,rightMax=nil,nil
    for _,entry in pairs(nodes) do
        if type(entry)=="table" then
            local startX=tonumber(entry.startTransX)
                or (type(entry.startTrans)=="table" and tonumber(entry.startTrans[1]) or nil)
            local endX=tonumber(entry.endTransX)
                or (type(entry.endTrans)=="table" and tonumber(entry.endTrans[1]) or nil)
            local extent=nil
            if finite(startX) then extent=math.abs(startX) end
            if finite(endX) then extent=extent==nil and math.abs(endX) or math.max(extent,math.abs(endX)) end
            if finite(extent) then
                if entry.isLeft==true then leftMax=leftMax==nil and extent or math.max(leftMax,extent)
                else rightMax=rightMax==nil and extent or math.max(rightMax,extent) end
            end
        end
    end
    if not finite(leftMax) or not finite(rightMax) then return nil end
    return validWidth(leftMax+rightMax)
end

local function memberWorkingWidthEvidence(object)
    local leftPoint,rightPoint,currentMarkerSpanM=nil,nil,nil
    local intrinsicAIMarkerWidthM=nil
    if type(object.getAIMarkers)=="function" then
        -- GIANTS' automatic-width path refreshes this cached semantic width
        -- before reading the fifth getAIMarkers() return. This differs from
        -- current world-space marker separation while an implement is folded.
        if type(object.updateAIMarkerWidth)=="function" then
            pcall(object.updateAIMarkerWidth,object)
        end
        local ok,left,right,_back,_inverted,aiMarkerWidth=pcall(object.getAIMarkers,object)
        if ok then
            currentMarkerSpanM,leftPoint,rightPoint=markerWidth(left,right)
            intrinsicAIMarkerWidthM=validWidth(aiMarkerWidth)
        end
    end

    local aiWorkAreaWidthM=nil
    if type(object.getAIWorkAreaWidth)=="function" then
        local ok,width=pcall(object.getAIWorkAreaWidth,object)
        if ok then aiWorkAreaWidthM=validWidth(width) end
    end

    local variableWorkWidthSpanM=variableWorkWidthSpan(object)

    local aiCollisionWidthM=nil
    if type(object.getAIImplementCollisionTrigger)=="function" then
        local ok,trigger=pcall(object.getAIImplementCollisionTrigger,object)
        if ok and type(trigger)=="table" then aiCollisionWidthM=validWidth(trigger.width) end
    elseif type(object.spec_aiImplement)=="table" and type(object.spec_aiImplement.collisionTrigger)=="table" then
        aiCollisionWidthM=validWidth(object.spec_aiImplement.collisionTrigger.width)
    end

    local widthMetres,source=nil,nil
    local function consider(width,candidateSource)
        if width~=nil and (widthMetres==nil or width>widthMetres) then
            widthMetres=width
            source=candidateSource
        end
    end
    consider(intrinsicAIMarkerWidthM,"GIANTS_AI_MARKER_WIDTH")
    consider(aiWorkAreaWidthM,"GIANTS_AI_WORK_AREA_WIDTH")
    consider(variableWorkWidthSpanM,"GIANTS_VARIABLE_WORK_WIDTH_RANGE")

    return {
        rootNode=object.rootNode,
        available=widthMetres~=nil,
        widthMetres=widthMetres,
        source=source or "UNAVAILABLE",
        leftPoint=leftPoint,
        rightPoint=rightPoint,
        markerBacked=leftPoint~=nil and rightPoint~=nil,
        currentMarkerSpanM=currentMarkerSpanM,
        intrinsicAIMarkerWidthM=intrinsicAIMarkerWidthM,
        aiWorkAreaWidthM=aiWorkAreaWidthM,
        variableWorkWidthSpanM=variableWorkWidthSpanM,
        aiCollisionWidthM=aiCollisionWidthM
    }
end

-- Raw productive-width Knowledge seed. It deliberately excludes the player's
-- FieldCourseSettings width override: that is a lane-planning choice and can be
-- smaller than the real implement. Intrinsic GIANTS AI-marker/work-area width,
-- current marker pose and AI collision width remain separate evidence classes.
function Observation.workingWidth(vehicle)
    local members={}
    local best=nil
    for _,object in ipairs(collectAttached(vehicle)) do
        local evidence=memberWorkingWidthEvidence(object)
        members[#members+1]=evidence
        if evidence.available and (best==nil or evidence.widthMetres>best.widthMetres) then
            best=evidence
        end
    end
    return {
        available=best~=nil,
        widthMetres=best and best.widthMetres or nil,
        source=best and best.source or "UNAVAILABLE",
        leftPoint=best and best.leftPoint or nil,
        rightPoint=best and best.rightPoint or nil,
        markerBacked=best~=nil and best.markerBacked==true or false,
        currentMarkerSpanM=best and best.currentMarkerSpanM or nil,
        intrinsicAIMarkerWidthM=best and best.intrinsicAIMarkerWidthM or nil,
        aiWorkAreaWidthM=best and best.aiWorkAreaWidthM or nil,
        variableWorkWidthSpanM=best and best.variableWorkWidthSpanM or nil,
        aiCollisionWidthM=best and best.aiCollisionWidthM or nil,
        members=members,
        authority="PRODUCTIVE_WIDTH_EVIDENCE_ONLY"
    }
end

-- Exact SDK and live native-command evidence identify aiDriveParams as the immediate
-- native field-worker command before OuttaMyWay Native Drive actuation. Reading it
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
    local workingWidth=Observation.workingWidth(vehicle)
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
