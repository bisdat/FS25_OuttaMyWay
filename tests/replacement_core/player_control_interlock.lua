local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay = {}
g_currentMission={controlledVehicle=nil}

load("scripts/config.lua")
load("scripts/observation/CurrentPlayerControlObservation.lua")
load("scripts/control/mechanisms/NonJobActuationMechanism.lua")

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

local controlled=false
local vehicle={rootNode=9901}
function vehicle:getRootVehicle() return self end
function vehicle:getIsControlled() return controlled end

test("Player Control Interlock and Observation share transient getIsControlled evidence",function()
    local mechanism=OuttaMyWay.NonJobActuationMechanism.new()
    controlled=false
    g_currentMission.controlledVehicle=nil
    equal(OuttaMyWay.CurrentPlayerControlObservation.isControlled(g_currentMission,vehicle),false)
    equal(mechanism:isPlayerControlled(vehicle),false)

    controlled=true
    equal(OuttaMyWay.CurrentPlayerControlObservation.isControlled(g_currentMission,vehicle),true)
    equal(mechanism:isPlayerControlled(vehicle),true)

    controlled=false
    equal(OuttaMyWay.CurrentPlayerControlObservation.isControlled(g_currentMission,vehicle),false)
    equal(mechanism:isPlayerControlled(vehicle),false)
end)

test("mission controlled-root context remains an independent positive fallback",function()
    local mechanism=OuttaMyWay.NonJobActuationMechanism.new()
    controlled=false
    g_currentMission.controlledVehicle=vehicle
    equal(OuttaMyWay.CurrentPlayerControlObservation.isControlled(g_currentMission,vehicle),true)
    equal(mechanism:isPlayerControlled(vehicle),true)

    g_currentMission.controlledVehicle=nil
    equal(OuttaMyWay.CurrentPlayerControlObservation.isControlled(g_currentMission,vehicle),false)
    equal(mechanism:isPlayerControlled(vehicle),false)
end)

test("interlock does not create retained state",function()
    local mechanism=OuttaMyWay.NonJobActuationMechanism.new()
    controlled=true
    equal(mechanism:isPlayerControlled(vehicle),true)
    controlled=false
    equal(mechanism:isPlayerControlled(vehicle),false)
    controlled=true
    equal(mechanism:isPlayerControlled(vehicle),true)
    controlled=false
    equal(mechanism:isPlayerControlled(vehicle),false)
end)

print(string.format("player control interlock focused validation: %d passed, %d failed",passed,failed))
if failed>0 then os.exit(1) end
