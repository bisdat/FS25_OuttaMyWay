OuttaMyWay.LocalIntentObservation = {}
local Observation=OuttaMyWay.LocalIntentObservation

local function className(value)
    if value==nil then return "nil" end
    if type(value)=="table" then
        if value.className~=nil then return tostring(value.className) end
        if type(value.class)=="table" and value.class.className~=nil then return tostring(value.class.className) end
    end
    return tostring(value)
end

local function appendStrategies(candidates,spec,source)
    if type(spec)~="table" or type(spec.driveStrategies)~="table" then return end
    for index,strategy in pairs(spec.driveStrategies) do
        candidates[#candidates+1]={strategy=strategy,source=string.format("%s.driveStrategies[%s]",source,tostring(index))}
    end
end

local function findFieldCourseStrategy(vehicle)
    if vehicle==nil then return nil,"NO_VEHICLE" end
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

function Observation.observe(vehicle)
    local strategy,strategySource=findFieldCourseStrategy(vehicle)
    if strategy==nil then
        return {classification="UNRESOLVED",valid=false,reason="GIANTS_FIELD_COURSE_STRATEGY_UNAVAILABLE",strategySource=strategySource,source="GIANTS_AI_FIELD_COURSE"}
    end
    local course=strategy.aiFieldCourse
    if course==nil or type(course.getActiveSegmentData)~="function" then
        return {classification="UNRESOLVED",valid=false,reason="ACTIVE_SEGMENT_DATA_UNAVAILABLE",strategySource=strategySource,source="GIANTS_AI_FIELD_COURSE"}
    end
    local ok,isTurn,segmentIndex,progress,segmentLength,slot5,remainingMetric=pcall(course.getActiveSegmentData,course)
    if not ok then
        return {classification="UNRESOLVED",valid=false,reason="ACTIVE_SEGMENT_DATA_CALL_FAILED",strategySource=strategySource,source="GIANTS_AI_FIELD_COURSE",error=tostring(isTurn)}
    end
    if type(isTurn)~="boolean" then
        return {classification="UNRESOLVED",valid=false,reason="ACTIVE_SEGMENT_TURN_FLAG_UNAVAILABLE",strategySource=strategySource,source="GIANTS_AI_FIELD_COURSE"}
    end
    return {
        classification=isTurn and "TURNING" or "SETTLED_CONTINUATION",
        valid=true,
        isTurn=isTurn,
        segmentIndex=segmentIndex,
        progress=tonumber(progress),
        segmentLength=tonumber(segmentLength),
        remainingMetric=tonumber(remainingMetric),
        strategySource=strategySource,
        source="GIANTS_AI_FIELD_COURSE_ACTIVE_SEGMENT"
    }
end

function Observation.updateTrack(track,observed)
    track=track or {}
    observed=observed or {classification="UNRESOLVED",valid=false,reason="NO_OBSERVATION"}
    local previous=track.localIntentClassification
    local epoch=tonumber(track.localIntentEpoch) or 0
    local transition=nil
    local intentValid=false

    if observed.classification=="SETTLED_CONTINUATION" and observed.valid==true then
        if epoch==0 then
            epoch=1
            transition="LOCAL_INTENT_REVEALED"
        elseif previous=="TURNING" then
            epoch=epoch+1
            transition="LOCAL_INTENT_REVEALED_AFTER_MANOEUVRE"
        elseif previous=="UNRESOLVED" then
            transition="LOCAL_INTENT_RESTORED"
        end
        intentValid=true
    elseif observed.classification=="TURNING" and observed.valid==true then
        if previous=="SETTLED_CONTINUATION" then transition="INTENT_EXPIRED_BY_MANOEUVRE" end
        intentValid=false
    else
        if previous=="SETTLED_CONTINUATION" then transition="INTENT_EXPIRED_BY_UNRESOLVED_EVIDENCE" end
        intentValid=false
    end

    track.localIntentClassification=observed.classification
    track.localIntentEpoch=epoch
    track.localIntentValid=intentValid

    return {
        classification=observed.classification,
        intentEpoch=epoch,
        intentValid=intentValid,
        transition=transition,
        nativeTurn=observed.isTurn==true,
        segmentIndex=observed.segmentIndex,
        progress=observed.progress,
        segmentLength=observed.segmentLength,
        remainingMetric=observed.remainingMetric,
        strategySource=observed.strategySource,
        source=observed.source,
        reason=observed.reason
    }
end
