-- Pair TRANSIT readiness examines selected runtime foldable actuators only.
OuttaMyWay={}
local mechanisms={"NativeTranslationHoldMechanism",
    "NativeSpeedRegulationMechanism","NativeReverseMechanism",
    "NativeStaticAssemblyDriveMechanism",
    "NativeFieldworkJobReplacementMechanism"}
for _,name in ipairs(mechanisms) do
    OuttaMyWay[name]={new=function()return {} end}
end
dofile("scripts/control/mechanisms/NativeTransitRequestMechanism.lua")
dofile("scripts/coordination/PairTransitRegion.lua")
dofile("scripts/control/HoldRelocatePhysicalControl.lua")
local Control=OuttaMyWay.HoldRelocatePhysicalControl
g_server={}
local commands={}
local positions=setmetatable({},{__mode="k"})
getWorldTranslation=function(node)
    local p=assert(positions[node]);return p.x,0,p.z
end
localToWorld=function(node,x,y,z)
    local p=assert(positions[node]);return p.x+x,y,p.z+z
end
local function member(hasParts)
    local node={}
    positions[node]={x=hasParts and 10 or 20,z=10}
    local spec=hasParts and {hasFoldingParts=true,
        foldingParts={{name="boom"}},foldAnimTime=0} or nil
    return {
        rootNode=node,spec_foldable=spec,sizeWidth=3,sizeLength=6,
        getAttachedImplements=function()return {} end,
        getIsTurnedOn=function()return true end,
        setIsTurnedOn=function(_,v)commands[#commands+1]={"WORK",v}end,
        getIsLowered=function()return true end,
        setLowered=function(_,v)commands[#commands+1]={"RAISE",v}end,
        -- The second participant can expose toggle methods but lack any
        -- discovered selected-runtime folding parts: it must not be polled.
        setFoldDirection=function(_,v)commands[#commands+1]={"FOLD",v}end,
        getToggledFoldDirection=function()return 1 end,
        getFoldAnimTime=function(self)
            if self.spec_foldable==nil then
                error("NON_FOLDABLE_MUST_NOT_BE_POLLED")
            end
            return self.spec_foldable.foldAnimTime
        end
    }
end
local a,b=member(true),member(false)
local commitment={participants={{vehicle=a},{vehicle=b}}}
local authority={active=commitment}
local control=Control.new(authority)
assert(control:preflightPair({commitment=commitment}))
local pa,pb=control:getTransitRequests(a),control:getTransitRequests(b)
assert(#pa.foldTargets==1 and #pa.transitActions==3)
assert(#pb.foldTargets==0 and #pb.transitActions==2)
assert(control:requestTransit(a))
assert(control:requestTransit(b))
assert(#commands==5)
local sa=assert(control:transitStatus(a))
local sb=assert(control:transitStatus(b))
assert(not sa.isSettled and sa.requiredFoldCount==1
    and sa.settledFoldCount==0)
assert(sb.isSettled and sb.requiredFoldCount==0
    and sb.unresolvedFoldCount==0)
local nominal=assert(control:pairTransitFootprint(a))
assert(nominal.memberCount==1 and #nominal.corners==4
    and nominal.foldSettled==false
    and nominal.configurationBasis=="NOMINAL_TRANSIT_AFTER_WAIT"
    and nominal.negativeClearanceAuthority==false,
    "an unfinished fold retains nominal TRANSIT planning geometry")
a.spec_foldable.foldAnimTime=0.56
assert(not control:transitStatus(a).isSettled,
    "intermediate fold animation is not endpoint readiness")
a.spec_foldable.foldAnimTime=1
assert(control:transitStatus(a).isSettled)
-- A completed fold allows early egress, but uses the same geometry.
local achieved=assert(control:pairTransitFootprint(a))
assert(achieved.foldSettled==true
    and achieved.configurationBasis=="FOLD_ENDPOINTS_OBSERVED"
    and #achieved.corners==#nominal.corners)
assert(control:cancelTransit(a) and control:cancelTransit(b))
-- A discovered but unobservable fold waits only until the global
-- coordinator's 15-second bound; no command result manufactures readiness.
a.spec_foldable.foldAnimTime=nil
assert(control:preflightPair({commitment=commitment}))
local unknown=assert(control:transitStatus(a))
assert(unknown.isSettled==false and unknown.unresolvedFoldCount==1)
local unresolved=assert(control:pairTransitFootprint(a))
assert(unresolved.foldSettled==false
    and unresolved.configurationBasis=="NOMINAL_TRANSIT_AFTER_WAIT",
    "unknown selected fold actuator must not veto post-timeout planning")
assert(control:cancelTransit(a) and control:cancelTransit(b))
print("Paired selective fold wait and non-veto nominal TRANSIT geometry: PASS")
