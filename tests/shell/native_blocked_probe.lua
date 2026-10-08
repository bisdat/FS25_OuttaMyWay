-- Observes real native state fields; never operates on GIANTS jobs or vehicles.
local events={}
OuttaMyWay={LogPublication={origin=function()
    return {publish=function(_,class,_,code,builder)
        assert(class=="DEBUG")
        events[#events+1]={code=code,values=builder()}
    end}
end}}
dofile("scripts/diagnostics/NativeBlockedProbe.lua")
local enabled,debug=true,true
local config={
    isResolved=function() return true end,
    isEnabled=function() return enabled end,
    isDebugEnabled=function() return debug end
}
local probe=OuttaMyWay.NativeBlockedProbe.new(config,{publicationPolicy=function() return "NORMAL" end})
local course={className="AIDriveStrategyFieldCourse",isBlocked=false,hasStaticCollision=false}
local field={isActive=true,isBlocked=false,driveStrategies={course}}
local worker={rootNode=123,spec_aiFieldWorker=field,spec_aiJobVehicle={job={jobId=7}},
    getName=function() return "Test worker" end}
local active={[worker]=true}
g_currentMission={aiSystem={activeJobVehicles=active}}
probe:loadMap()
probe:update(500)
assert(#events==1 and events[1].code=="NATIVE_BLOCKED_STATE_SAMPLE")
assert(events[1].values.fieldBlocked=="false" and events[1].values.courseBlocked=="false")
assert(events[1].values.staticCollision=="false")
probe:update(500)
assert(#events==1)
field.isBlocked=true;course.isBlocked=true
probe:update(500)
assert(#events==2 and events[2].values.fieldBlocked=="true")
for _=1,10 do probe:update(500) end
assert(#events==3 and events[3].code=="NATIVE_BLOCKED_STILL_PRESENT")
course.hasStaticCollision=true
probe:update(500)
assert(#events==4 and events[4].values.staticCollision=="true")
field.isBlocked=false;course.isBlocked=false;course.hasStaticCollision=false
probe:update(500)
assert(#events==5 and events[5].values.fieldBlocked=="false")
-- Job absence cannot be confused with a positive native clearance.
active[worker]=nil
probe:update(500)
assert(#events==5 and next(probe.states)==nil)
active[worker]=true
debug=false
probe:update(500)
assert(#events==5 and next(probe.states)==nil)
debug=true;enabled=false
probe:update(500)
assert(#events==5)
enabled=true
probe:update(500)
assert(#events==6)
g_currentMission.aiSystem.activeJobVehicles=nil
probe:update(500)
assert(#events==7 and events[7].code=="NATIVE_BLOCKED_SOURCE_UNAVAILABLE")
probe:update(500)
assert(#events==7)
probe:deleteMap()
assert(next(probe.states)==nil)
print("Native blocked read-only probe / lifecycle / opt-in: PASS")
