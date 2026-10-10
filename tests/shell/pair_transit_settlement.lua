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
dofile("scripts/control/HoldRelocatePhysicalControl.lua")
local Control=OuttaMyWay.HoldRelocatePhysicalControl
g_server={}
local commands={}
local function member(hasParts)
    local node={}
    local spec=hasParts and {hasFoldingParts=true,
        foldingParts={{name="boom"}},foldAnimTime=0} or nil
    return {
        rootNode=node,spec_foldable=spec,
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
local missing,unsupported=control:pairTransitFootprint(a)
assert(missing==nil and unsupported=="PAIR_TRANSIT_FOOTPRINT_NOT_REALIZED",
    "unfinished folding must never be interpreted as compact geometry")
a.spec_foldable.foldAnimTime=0.56
assert(not control:transitStatus(a).isSettled,
    "intermediate fold animation is not endpoint readiness")
a.spec_foldable.foldAnimTime=1
assert(control:transitStatus(a).isSettled)
-- Once the actual fold endpoint is achieved, geometry can be considered.
-- Here no GIANTS transform stub exists, so the next representation layer
-- reports its own missing evidence rather than a stale-fold veto.
local _,geometryReason=control:pairTransitFootprint(a)
assert(geometryReason~="PAIR_TRANSIT_FOOTPRINT_NOT_REALIZED")
assert(control:cancelTransit(a) and control:cancelTransit(b))
-- A discovered but unobservable fold waits only until the global
-- coordinator's 15-second bound; no command result manufactures readiness.
a.spec_foldable.foldAnimTime=nil
assert(control:preflightPair({commitment=commitment}))
local unknown=assert(control:transitStatus(a))
assert(unknown.isSettled==false and unknown.unresolvedFoldCount==1)
local unknownFoot,unknownWhy=control:pairTransitFootprint(a)
assert(unknownFoot==nil and unknownWhy=="PAIR_TRANSIT_FOOTPRINT_NOT_REALIZED")
assert(control:cancelTransit(a) and control:cancelTransit(b))
print("Paired selective fold readiness and TRANSIT commands: PASS")
