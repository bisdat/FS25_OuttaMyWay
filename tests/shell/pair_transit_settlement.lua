-- Asymmetric paired TRANSIT: demand configuration on the selected mover
-- only; no fold-position or optional WORKING getter is a movement gate.
OuttaMyWay={}
for _,name in ipairs({"NativeTranslationHoldMechanism",
    "NativeSpeedRegulationMechanism","NativeReverseMechanism",
    "NativeStaticAssemblyDriveMechanism",
    "NativeFieldworkJobReplacementMechanism"}) do
    OuttaMyWay[name]={new=function()return {} end}
end
dofile("scripts/control/mechanisms/NativeTransitRequestMechanism.lua")
dofile("scripts/coordination/PairTransitRegion.lua")
dofile("scripts/control/HoldRelocatePhysicalControl.lua")
local Control=OuttaMyWay.HoldRelocatePhysicalControl
g_server={}
local commands={}
local coords=setmetatable({},{__mode="k"})
getWorldTranslation=function(node)
    local p=assert(coords[node]);return p.x,0,p.z
end
localToWorld=function(node,x,y,z)
    local p=assert(coords[node]);return p.x+x,y,p.z+z
end
local function member(name,foldable)
    local node={};coords[node]={x=name=="A" and 10 or 20,z=10}
    local spec=foldable and {hasFoldingParts=true,
        foldingParts={{name="boom"}},foldAnimTime=nil} or nil
    return {rootNode=node,sizeWidth=3,sizeLength=6,spec_foldable=spec,
        getAttachedImplements=function()return {} end,
        getIsTurnedOn=function()
            error("WORK_GETTER_MUST_NOT_GATE_TRANSIT")
        end,
        setIsTurnedOn=function(_,v)commands[#commands+1]=name..":WORK:"..tostring(v)end,
        getIsLowered=function()
            error("LOWERED_GETTER_MUST_NOT_GATE_TRANSIT")
        end,
        setLowered=function(_,v)commands[#commands+1]=name..":RAISE:"..tostring(v)end,
        setFoldDirection=function(_,v)commands[#commands+1]=name..":FOLD:"..tostring(v)end,
        getToggledFoldDirection=function()
            if foldable then return 1 end
            error("NONMOVER_FOLD_DIRECTION_MUST_NOT_BE_POLLED")
        end,
        getFoldAnimTime=function()
            if foldable then return 0 end
            error("NONMOVER_FOLD_STATUS_MUST_NOT_BE_POLLED")
        end}
end
local a,b=member("A",true),member("B",false)
local commitment={participants={{vehicle=a},{vehicle=b}}}
local authority={active=commitment}
local control=Control.new(authority)
-- Both candidates' nominal footprints can be examined without requesting
-- or verifying configuration on either machine.
local first=assert(control:pairTransitFootprint(a))
local second=assert(control:pairTransitFootprint(b))
assert(first.configurationBasis=="NOMINAL_TRANSIT_BEFORE_REQUEST"
    and second.configurationBasis=="NOMINAL_TRANSIT_BEFORE_REQUEST"
    and first.foldSettled==false and second.foldSettled==false)
assert(#commands==0)
assert(control:preflightPairMover({commitment=commitment,
    relocator={vehicle=a}}))
local plan=assert(control:getTransitRequests(a))
assert(#plan.transitActions==3 and #plan.foldTargets==1)
assert(control:getTransitRequests(b)==nil)
assert(control:requestTransit(a))
assert(#commands==3 and commands[1]=="A:WORK:false"
    and commands[2]=="A:RAISE:false"
    and commands[3]:sub(1,7)=="A:FOLD:",
    "both other-worker configuration and fold-readiness checks are forbidden")
assert(control:cancelTransit(a))
assert(control:getTransitRequests(a)==nil
    and control:getTransitRequests(b)==nil)
-- An unreadable fold position never blocks the move. Its known native
-- work-off/raise requests still go through without waiting for readback.
local unknown=member("A",true)
unknown.getFoldAnimTime=function()
    error("FOLD_POSITION_NOT_AVAILABLE")
end
local unknownControl=Control.new(authority)
assert(unknownControl:preflightPairMover({commitment=commitment,
    relocator={vehicle=unknown}}))
local planUnknown=assert(unknownControl:getTransitRequests(unknown))
assert(#planUnknown.transitActions==2
    and planUnknown.unknownFoldCount==1)
assert(unknownControl:requestTransit(unknown))
assert(unknownControl:cancelTransit(unknown))
for _,command in ipairs(commands) do
    assert(command:sub(1,2)=="A:","remaining worker must never change")
end
-- Either member is a legitimate mover, including non-foldable equipment.
commands={}
local nextControl=Control.new(authority)
assert(nextControl:preflightPairMover({commitment=commitment,
    relocator={vehicle=b}}))
local planB=assert(nextControl:getTransitRequests(b))
assert(#planB.foldTargets==0 and #planB.transitActions==2)
assert(nextControl:getTransitRequests(a)==nil)
assert(nextControl:requestTransit(b))
assert(#commands==2 and commands[1]=="B:WORK:false"
    and commands[2]=="B:RAISE:false")
assert(nextControl:cancelTransit(b))
assert(nextControl:getTransitRequests(a)==nil)
-- No vehicle has an active fold command or configuration lease.
print("Asymmetric pair selected-mover-only TRANSIT (no fold/pose readiness): PASS")
