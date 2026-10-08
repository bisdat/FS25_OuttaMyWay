-- Accepted pure candidate rule: no GIANTS runtime, no vehicle Control.
OuttaMyWay={}
dofile("scripts/assessment/SpatialPairInference.lua")
local eval=OuttaMyWay.SpatialPairInference.evaluate
local function root(id,x,z,eligible)
    return {rootId=id,x=x,z=z,eligible=eligible}
end
local blocked=root("A",0,0)
local near=root("near",6,8,true)
local far=root("far",20,20,true)

assert(eval(999,blocked,{near})==nil,"under one second")
assert(eval(1000,blocked,{near}).rootId=="near","at one second")
assert(eval(1000,blocked,{near}).distanceMetres==10,"X/Z distance")
assert(eval(1900,blocked,{far,near}).rootId=="near","nearest regardless of input order")
assert(eval(1900,blocked,{near,far}).rootId=="near","nearest in reverse order")
assert(eval(1000,blocked,{root("edge",30,0,true)}).rootId=="edge","30 m inclusive")
assert(eval(1000,blocked,{root("outside",30.01,0,true)})==nil,">30 m excluded")
assert(eval(1000,blocked,{root("remote",300,0,true)})==nil,"no distant fallback")
assert(eval(1000,blocked,{root("A",0,0,true),near}).rootId=="near","exclude own assembly")
assert(eval(1000,blocked,{root("ineligible",1,0,false),near}).rootId=="near","explicit eligibility")
assert(eval(1000,blocked,{root("ineligible",1,0)})==nil,"unknown eligibility")
assert(eval(1000,blocked,{root("invalid",0/0,0,true),near}).rootId=="near","invalid x")
assert(eval(1000,blocked,{})==nil,"no candidates")
assert(eval(1000,blocked,{root("notBlocked",8,1,true)}).rootId=="notBlocked","other need not be blocked")
assert(eval(nil,blocked,{near})==nil,"unknown duration")
assert(eval(-1,blocked,{near})==nil,"invalid duration")
assert(eval(math.huge,blocked,{near})==nil,"infinite duration")
assert(eval(1000,root("A",0/0,0),{near})==nil,"invalid blocked root")
assert(eval(1000,blocked,nil)==nil,"no population")
assert(OuttaMyWay.nativeBlockedEventTap==nil,"retired event tap absent")
assert(OuttaMyWay.runtime==nil,"no worker Control runtime")
print("Spatial Pair Inference pure candidate: PASS")
