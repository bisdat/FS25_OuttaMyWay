local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay = {}
load("scripts/config.lua")
load("scripts/publication/LogPublication.lua")
OuttaMyWay.logPublication=OuttaMyWay.LogPublication.new(function() return "DIAGNOSTIC" end)
load("scripts/contracts/ValueRecord.lua")

local vehicles={}
OuttaMyWay.LiveAIJobEvidence={
    activeJobVehicles=function() return vehicles end
}

g_currentMission={}
g_server=nil
SetCruiseControlSpeedEvent=nil

load("scripts/control/mechanisms/PassageCruiseControl.lua")

local passed,failed=0,0
local function test(name,fn)
    local ok,err=pcall(fn)
    if ok then passed=passed+1; print("PASS "..name)
    else failed=failed+1; print("FAIL "..name..": "..tostring(err)) end
end
local function equal(a,b,message)
    if a~=b then error(message or (tostring(a).." ~= "..tostring(b)),2) end
end
local function near(a,b,epsilon,message)
    epsilon=epsilon or 0.0001
    if math.abs(a-b)>epsilon then error(message or (tostring(a).." !~= "..tostring(b)),2) end
end

local function fakeVehicle(rootNode,forward,reverse,failOnSetCall)
    local vehicle={
        rootNode=rootNode,
        spec_drivable={cruiseControl={speed=forward,speedReverse=reverse,state=1}},
        setCalls=0
    }
    function vehicle:getCruiseControlState() return self.spec_drivable.cruiseControl.state end
    function vehicle:setCruiseControlMaxSpeed(speed,speedReverse)
        self.setCalls=self.setCalls+1
        if failOnSetCall~=nil and self.setCalls==failOnSetCall then error("synthetic cruise setter failure") end
        self.spec_drivable.cruiseControl.speed=speed
        self.spec_drivable.cruiseControl.speedReverse=speedReverse
    end
    return vehicle
end

test("Passage Cruise Ceiling caps forward and reverse without increasing lower originals and restores exact values",function()
    local a=fakeVehicle(101,25,12)
    local b=fakeVehicle(201,8,6)
    vehicles={a,b}
    local cruise=OuttaMyWay.PassageCruiseControl.new()
    local ok,reason=cruise:acquirePair("CM-1",{
        {assemblyId="AS-A",referenceKey="vehicle-root:101"},
        {assemblyId="AS-B",referenceKey="vehicle-root:201"}
    },10)
    equal(ok,true); equal(reason,"PASSAGE_CRUISE_PAIR_APPLIED")
    near(a.spec_drivable.cruiseControl.speed,10)
    near(a.spec_drivable.cruiseControl.speedReverse,10)
    near(b.spec_drivable.cruiseControl.speed,8)
    near(b.spec_drivable.cruiseControl.speedReverse,6)
    equal(cruise:hasLease("CM-1"),true)

    local released=cruise:releaseForCommitment("CM-1","TEST_COMPLETE")
    equal(released,true)
    near(a.spec_drivable.cruiseControl.speed,25)
    near(a.spec_drivable.cruiseControl.speedReverse,12)
    near(b.spec_drivable.cruiseControl.speed,8)
    near(b.spec_drivable.cruiseControl.speedReverse,6)
    equal(cruise:hasLease("CM-1"),false)
end)

test("Passage Cruise pair apply rolls back first participant when second participant fails",function()
    local a=fakeVehicle(301,25,20)
    local b=fakeVehicle(401,24,18,1)
    vehicles={a,b}
    local cruise=OuttaMyWay.PassageCruiseControl.new()
    local ok,reason=cruise:acquirePair("CM-2",{
        {assemblyId="AS-C",referenceKey="vehicle-root:301"},
        {assemblyId="AS-D",referenceKey="vehicle-root:401"}
    },10)
    equal(ok,false)
    equal(string.find(reason,"PASSAGE_CRUISE_PAIR_APPLY_FAILED",1,true)~=nil,true)
    near(a.spec_drivable.cruiseControl.speed,25)
    near(a.spec_drivable.cruiseControl.speedReverse,20)
    near(b.spec_drivable.cruiseControl.speed,24)
    near(b.spec_drivable.cruiseControl.speedReverse,18)
    equal(cruise:hasLease("CM-2"),false)
end)

print(string.format("Passage Cruise Control focused contract: %d passed, %d failed",passed,failed))
if failed>0 then os.exit(1) end
