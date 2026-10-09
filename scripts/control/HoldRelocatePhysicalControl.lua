-- Connects independently admitted Hold & Relocate steps to native mechanisms.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- This is physical Control, not Pair Commitment or field/blocked-state assessment.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.HoldRelocatePhysicalControl={}
local Control=OuttaMyWay.HoldRelocatePhysicalControl
Control.__index=Control

local MAX_MEMBERS=16 -- defensive traversal budget, not a field traffic threshold

local function finite(n)
    return type(n)=="number" and n==n and n~=math.huge and n~=-math.huge
end

local function method(object,name,...)
    if type(object)~="table" or type(object[name])~="function" then
        return false,nil
    end
    local ok,value=pcall(object[name],object,...)
    return ok,value
end

-- Capture the actual native assembly once per admitted relocation. The cached
-- plan has no semantic capability beyond selected, reversible native commands.
-- Unsupported or unobservable fold shapes are NOT guessed as 'already folded'.
local function buildTransitPlan(vehicle)
    local members,seen={},{}
    local function include(object)
        if type(object)~="table" or object.isDeleted==true then
            return false,"ASSEMBLY_MEMBER_UNAVAILABLE"
        end
        if seen[object] then return true end
        if #members>=MAX_MEMBERS then return false,"ASSEMBLY_MEMBER_BUDGET_EXCEEDED" end
        seen[object]=true
        members[#members+1]=object
        if type(object.getAttachedImplements)=="function" then
            local ok,attached=method(object,"getAttachedImplements")
            if not ok or type(attached)~="table" then
                return false,"ATTACHMENT_EVIDENCE_UNAVAILABLE"
            end
            for _,descriptor in pairs(attached) do
                local child=type(descriptor)=="table" and (descriptor.object or descriptor) or nil
                local accepted,reason=include(child)
                if not accepted then return false,reason end
            end
        end
        return true
    end
    local collected,reason=include(vehicle)
    if not collected then return nil,reason end
    local commands,reversals={},{}
    local function append(object,name,value,restore)
        commands[#commands+1]={object=object,method=name,value=value}
        -- Native job replacement owns productive continuation on success;
        -- these inverses exist ONLY for an abandoned relocation.
        reversals[#reversals+1]={object=object,method=name,value=restore}
    end
    for i=1,#members do
        local object=members[i]
        if type(object.getIsTurnedOn)=="function"
            and type(object.setIsTurnedOn)=="function" then
            local ok,value=method(object,"getIsTurnedOn")
            if not ok or type(value)~="boolean" then
                return nil,"WORK_STATE_UNAVAILABLE"
            end
            if value then append(object,"setIsTurnedOn",false,true) end
        end
        if type(object.getIsLowered)=="function"
            and type(object.setLowered)=="function" then
            local ok,value=method(object,"getIsLowered")
            if not ok or type(value)~="boolean" then
                return nil,"LOWERED_STATE_UNAVAILABLE"
            end
            if value then append(object,"setLowered",false,true) end
        end
        if type(object.setFoldDirection)=="function"
            and type(object.getToggledFoldDirection)=="function" then
            local position=nil
            local ok,value=method(object,"getFoldAnimTime")
            if ok and finite(value) then position=value
            elseif type(object.spec_foldable)=="table" then
                position=object.spec_foldable.foldAnimTime
            end
            if not finite(position) then return nil,"FOLD_START_UNKNOWN" end
            if position<=0.001 then
                local known,direction=method(object,"getToggledFoldDirection")
                if not known or not finite(direction) or direction<=0 then
                    return nil,"FOLD_DIRECTION_UNAVAILABLE"
                end
                append(object,"setFoldDirection",direction,-direction)
            elseif position<0.999 then
                return nil,"FOLD_POSITION_AMBIGUOUS"
            end
        end
    end
    -- Reverse inverse application order: fold, raise, power (no readiness wait).
    local reverseOrder={}
    for i=#reversals,1,-1 do
        reverseOrder[#reverseOrder+1]=reversals[i]
    end
    return {transitActions=commands,restoreActions=reverseOrder}
end

function Control.new(authority)
    local control=setmetatable({authority=authority,
        plans=setmetatable({},{__mode="k"})},Control)
    control.holdMechanism=OuttaMyWay.NativeTranslationHoldMechanism.new()
    control.reverseMechanism=OuttaMyWay.NativeReverseMechanism.new()
    control.transitMechanism=OuttaMyWay.NativeTransitRequestMechanism.new(control)
    control.jobMechanism=OuttaMyWay.NativeFieldworkJobReplacementMechanism.new(authority)
    return control
end

-- Called only after an independently issued pair commitment is validated.
function Control:preflight(state)
    if g_server==nil or type(state)~="table" or state.relocator==nil then
        return false,"PHYSICAL_PREFLIGHT_UNAVAILABLE"
    end
    local vehicle=state.relocator.vehicle
    if self.authority.active~=state.commitment then
        return false,"PHYSICAL_COMMITMENT_MISSING"
    end
    if self.plans[vehicle]~=nil then return false,"TRANSIT_PLAN_ALREADY_ACTIVE" end
    local plan,why=buildTransitPlan(vehicle)
    if plan==nil then return false,why end
    self.plans[vehicle]=plan
    return true
end

function Control:getTransitRequests(vehicle)
    return self.plans[vehicle]
end

function Control:hold(vehicle,purpose)
    return self.holdMechanism:hold(vehicle,purpose)
end

function Control:releaseHold(vehicle,purpose)
    return self.holdMechanism:releaseHold(vehicle,purpose)
end

function Control:requestTransit(vehicle)
    return self.transitMechanism:requestTransit(vehicle)
end

function Control:cancelTransit(vehicle)
    local ok,evidence=self.transitMechanism:cancelTransit(vehicle)
    if ok then self.plans[vehicle]=nil end
    return ok,evidence
end

function Control:startReverse(vehicle,objective)
    return self.reverseMechanism:startReverse(vehicle,objective)
end

function Control:reverseStatus(vehicle)
    return self.reverseMechanism:reverseStatus(vehicle)
end

function Control:stopReverse(vehicle)
    return self.reverseMechanism:stopReverse(vehicle)
end

function Control:cancelReverse(vehicle)
    return self.reverseMechanism:cancelReverse(vehicle)
end

function Control:restartNativeFieldwork(vehicle)
    local ok,evidence=self.jobMechanism:restartNativeFieldwork(vehicle)
    if ok then
        -- Job replacement assumes GIANTS control of the new field worker;
        -- do not replay cached work/raise/fold inverses onto its new job.
        self.transitMechanism:relinquishTransit(vehicle)
        self.plans[vehicle]=nil
    end
    return ok,evidence
end
