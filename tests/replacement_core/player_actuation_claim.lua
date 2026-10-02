local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay = {}
g_time=0

Utils={
    appendedFunction=function(original,after)
        return function(...)
            local results={original(...)}
            after(...)
            return unpack(results)
        end
    end
}
Drivable={
    actionEventAccelerate=function() end,
    actionEventBrake=function() end,
    actionEventSteer=function() end
}
Motorized={
    actionEventToggleMotorState=function() end,
    actionEventSetMotorStateIgnition=function() end,
    actionEventSetMotorStateOn=function() end,
    actionEventSetMotorStateOff=function() end
}

load("scripts/config.lua")
load("scripts/publication/LogPublication.lua")
OuttaMyWay.logPublication=OuttaMyWay.LogPublication.new(function() return "DIAGNOSTIC" end)
load("scripts/contracts/ValueRecord.lua")
load("scripts/observation/PlayerActuationObservation.lua")
load("scripts/assessment/PlayerActuationClaimAssessment.lua")

local passed,failed=0,0
local function test(name,fn)
    local ok,err=pcall(fn)
    if ok then
        passed=passed+1
        print("PASS "..name)
    else
        failed=failed+1
        print("FAIL "..name..": "..tostring(err))
    end
end
local function equal(actual,expected,message)
    if actual~=expected then error(message or (tostring(actual).." ~= "..tostring(expected)),2) end
end
local function count(values)
    return OuttaMyWay.ValueRecord.length(values or {})
end

local vehicle={rootNode=9901}
function vehicle:getRootVehicle() return self end

local function snapshot(identity,controlled)
    return {
        identity=identity,
        playerControl={
            ["vehicle-root:9901"]={
                playerControlled=controlled==true,
                playerPresent=controlled==true,
                playerEntered=controlled==true,
                playerEnteredObserved=true,
                causalActionSourceAvailable=true,
                causalActionSourceReason="INSTALLED",
                latestCausalAction=OuttaMyWay.PlayerActuationObservation.latest("vehicle-root:9901")
            }
        }
    }
end

test("causal action source installs and passive control context does not establish claim",function()
    local available,reason=OuttaMyWay.PlayerActuationObservation.isAvailable()
    equal(available,true)
    equal(reason,"INSTALLED")
    local assessment=OuttaMyWay.PlayerActuationClaimAssessment.new()
    local knowledge=assessment:assess(snapshot("OS-PASSIVE",true))
    equal(count(knowledge),0)
    equal(assessment:isClaimedReference("vehicle-root:9901"),false)
end)

test("steering command establishes and zero input does not erase retained claim",function()
    OuttaMyWay.PlayerActuationObservation.reset()
    local assessment=OuttaMyWay.PlayerActuationClaimAssessment.new()

    g_time=100
    Drivable.actionEventSteer(vehicle,"AXIS_MOVE_SIDE_VEHICLE",0.75,nil,true)
    local first=assessment:assess(snapshot("OS-STEER",true))
    equal(count(first),1)
    equal(first[1].establishedAction,"STEER")
    equal(assessment:isClaimedReference("vehicle-root:9901"),true)

    g_time=110
    Drivable.actionEventSteer(vehicle,"AXIS_MOVE_SIDE_VEHICLE",0,nil,true)
    local retained=assessment:assess(snapshot("OS-ZERO",true))
    equal(count(retained),1)
    equal(retained[1].retainedByCurrentPlayerControl,true)
    equal(assessment:isClaimedReference("vehicle-root:9901"),true)
end)

test("tab-out releases claim and stale command cannot reclaim on passive re-entry",function()
    OuttaMyWay.PlayerActuationObservation.reset()
    local assessment=OuttaMyWay.PlayerActuationClaimAssessment.new()

    g_time=200
    Drivable.actionEventBrake(vehicle,"AXIS_BRAKE_VEHICLE",1,nil,true)
    equal(count(assessment:assess(snapshot("OS-BRAKE",true))),1)

    equal(count(assessment:assess(snapshot("OS-TAB-OUT",false))),0)
    equal(assessment:isClaimedReference("vehicle-root:9901"),false)

    local reentered=assessment:assess(snapshot("OS-REENTER",true))
    equal(count(reentered),0)
    equal(assessment:isClaimedReference("vehicle-root:9901"),false)
end)

test("engine-independent accelerate command remains causal evidence",function()
    OuttaMyWay.PlayerActuationObservation.reset()
    local assessment=OuttaMyWay.PlayerActuationClaimAssessment.new()

    g_time=300
    Drivable.actionEventAccelerate(vehicle,"AXIS_ACCELERATE_VEHICLE",1,nil,true)
    local action=OuttaMyWay.PlayerActuationObservation.latest("vehicle-root:9901")
    equal(action.action,"ACCELERATE")
    equal(action.inputValue,1)

    local claimed=assessment:assess(snapshot("OS-ACCEL",true))
    equal(count(claimed),1)
    equal(claimed[1].establishedAction,"ACCELERATE")
end)

test("explicit motor command is causal even with zero callback magnitude",function()
    OuttaMyWay.PlayerActuationObservation.reset()
    local assessment=OuttaMyWay.PlayerActuationClaimAssessment.new()

    g_time=400
    Motorized.actionEventToggleMotorState(vehicle,"TOGGLE_MOTOR_STATE",0,nil,false)
    local action=OuttaMyWay.PlayerActuationObservation.latest("vehicle-root:9901")
    equal(action.action,"MOTOR_TOGGLE")
    equal(action.inputValue,0)

    local claimed=assessment:assess(snapshot("OS-MOTOR",true))
    equal(count(claimed),1)
    equal(claimed[1].establishedAction,"MOTOR_TOGGLE")
end)

print(string.format("player actuation claim focused validation: %d passed, %d failed",passed,failed))
if failed>0 then os.exit(1) end
