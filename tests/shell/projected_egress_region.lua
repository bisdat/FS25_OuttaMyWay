-- Archived-BWR projected retreat, with no width-derived target or point arrival.
OuttaMyWay={}
dofile("scripts/coordination/ProjectedEgressRegion.lua")
local Plan=OuttaMyWay.ProjectedEgressRegion
local polygon={xs={0,100,100,0},zs={0,0,100,100}}
local locations={}
localDirectionToWorld=function(node,x,y,z)
    local p=locations[node];assert(p)
    return p.dx*x+p.fx*z,y,p.dz*x+p.fz*z
end
local function participant(x,z,fx,fz)
    local node={}
    locations[node]={fx=fx,fz=fz,dx=fz,dz=-fx}
    return {vehicle={getAIReverserNode=function()return node end},
        x=x,z=z,assemblyReferenceKey=tostring(node)}
end
local blocker=participant(20,20,1,0)
local mover=participant(23,20,-1,0)
local commitment={fieldCentroid={x=50,z=50},fieldPolygon=polygon}
local objective,reason=Plan.plan(commitment,mover,blocker)
assert(objective,reason)
assert(objective.directionSource~=nil and objective.returnRegion.requiredProgressM==20)
assert(objective.steeringHorizonM==40 and objective.maxTravelM==nil)
assert(objective.targetX>mover.x)
local r=objective.returnRegion
local p=Plan.progress(r,mover.x+19*r.directionX,mover.z+19*r.directionZ)
assert(not p.isInRegion and math.abs(p.remainingM-1)<0.0001)
p=Plan.progress(r,mover.x+20*r.directionX+5*r.directionZ,
    mover.z+20*r.directionZ-5*r.directionX)
assert(p.isInRegion and math.abs(p.progressM-20)<0.0001
    and math.abs(p.lateralOffsetM-5)<0.0001,
    "region admission is projected progress, not proximity to steering point")
assert(math.sqrt((objective.targetX-mover.x)^2+(objective.targetZ-mover.z)^2)>20,
    "steering reference deliberately beyond completion region")
assert(not Plan.progress(r,nil,0))
-- Unsupported native direction or an unavailable field route prevents admission,
-- but no speculative point-distance abort is introduced after successful start.
local saved=localDirectionToWorld
localDirectionToWorld=nil
local none,why=Plan.plan(commitment,mover,blocker)
assert(none==nil and why=="NATIVE_REVERSE_HEADING_UNAVAILABLE")
localDirectionToWorld=saved
local small={fieldCentroid={x=5,z=5},fieldPolygon={
    xs={0,15,15,0},zs={0,0,15,15}}}
none,why=Plan.plan(small,mover,blocker)
assert(none==nil and why=="NO_SUPPORTED_EGRESS_DIRECTION")
assert(Plan.progress(r,mover.x,mover.z).progressM==0)
print("Projected Return Region / separate 40 m steering / no chord-abort: PASS")
