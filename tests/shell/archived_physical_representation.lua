-- Source-level contract for the exact archived positive shape representation.
OuttaMyWay={}
ClassIds={SHAPE=10}
local poses={[1]={x=0,z=0},[2]={x=0,z=1.5}}
getHasClassId=function(node,class)return class==10 and poses[node]~=nil end
getNumOfChildren=function()return 0 end
getChildAt=function()error("no child")end
getIsCompoundChild=function()return false end
getShapeGeometryBoundingSphere=function()return 0,0,0,1 end
getShapeBoundingSphere=function()return 0,0,0,1 end
getShapeWorldBoundingSphere=function(node)return poses[node].x,0,poses[node].z,1 end
localToWorld=function(node,x,y,z)
    return poses[node].x+x,y,poses[node].z+z
end
dofile("scripts/representation/EntityLocalShapeEvidence.lua")
dofile("scripts/representation/PlanViewFootprint.lua")
dofile("scripts/representation/CurrentPhysicalConflictRepresentation.lua")
dofile("scripts/assessment/CausalObstructionAssessment.lua")
local first={rootNode=1,getChildVehicles=function()return {} end}
local second={rootNode=2,getChildVehicles=function()return {} end}
local source=OuttaMyWay.CurrentPhysicalConflictRepresentation.new()
local a=assert(source:observe(first,"first",10))
local b=assert(source:observe(second,"second",10))
assert(a.structurallyValid and b.structurallyValid
    and a.positivePrimitiveCount==1 and b.positivePrimitiveCount==1)
local overlap=OuttaMyWay.PlanViewFootprint.evaluateCurrentOverlap(a,b)
assert(overlap.current and overlap.authority=="POSITIVE_CONFLICT_SUPPORT_ONLY")
local positive=OuttaMyWay.CausalObstructionAssessment.positiveObstruction(
    {primitives=b.worldPrimitives},{primitives=a.worldPrimitives},nil,nil)
assert(positive.kind=="CURRENT_PHYSICAL_OCCUPANCY")
poses[2].z=11
b=assert(source:observe(second,"second",11))
local current=OuttaMyWay.PlanViewFootprint.evaluateCurrentOverlap(a,b)
assert(not current.current and current.authority=="NO_NEGATIVE_CLEARANCE_AUTHORITY")
local future=OuttaMyWay.CausalObstructionAssessment.positiveObstruction(
    {primitives=b.worldPrimitives},{primitives=a.worldPrimitives},
    {alternatives={{startX=0,startZ=0,endX=0,endZ=15}}},nil)
assert(future.kind=="CONTINUING_ACTIVE_FUTURE_SPACE",
    "archived future-current conflict must survive as distinct kernel")
local realised=OuttaMyWay.CausalObstructionAssessment.positiveObstruction(
    {primitives=b.worldPrimitives},{primitives=a.worldPrimitives},nil,
    {positive=true,directionX=0,directionZ=1,horizonM=15,
        physicalDemandSweeps={{kind="DISC_SWEEP",
            startX=0,startZ=0,endX=0,endZ=15,radius=1}}})
assert(realised.kind=="REALISED_MOTION_DEMAND")
print("Archived GIANTS world-shape and positive current/future/demand geometry: PASS")
