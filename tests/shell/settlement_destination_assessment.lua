-- Situation assessment: present physical movement versus unproven future
-- demand. No native driving or AI trajectory fabrication.
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/observation/CompletionFieldMembership.lua")
dofile("scripts/observation/CompletionParkingGeometry.lua")
local G=OuttaMyWay.FarmEdgeGeometry
local xs={131.79,143.52,153.81,162.43,165.16,165.55,175.32,
    182.15,228.15,-0.06,-10.56,-40.20}
local zs={-701.23,-656.06,-608.91,-561.34,-542.86,-526.92,
    -480.63,-468.38,-243.04,-207.44,-343.82,-677.42}
local source={densityMapPolygon={pointsX=xs,pointsZ=zs},fieldId=77}
local poly=assert(G.polygonFor(source))
local root={rootNode=100}
local peer={rootNode=200}
g_fieldManager={fields={[77]=source},
    getFieldById=function(_,id)return g_fieldManager.fields[id]end}
local moving={x=212,z=-353,fx=0,fz=1}
local known=true
local function makePeers()
    if not known then return {},true end
    return {{vehicle=peer,x=moving.x,z=moving.z,radius=17}},true
end
OuttaMyWay.ExtendedInfieldApproach={activePeers=function()
    return makePeers()
end}
localDirectionToWorld=function(node)
    local p=node==200 and moving or {fx=0,fz=1}
    return p.fx,0,p.fz
end
dofile("scripts/coordination/SettlementDestinationAssessment.lua")
local S=OuttaMyWay.SettlementDestinationAssessment
local sourceField={fieldId=77,field=source,polygon=poly}
local edge=G.edges(poly)[9]
local nx,nz=G.outwardAt(poly,edge,
    (edge.ax+edge.bx)*0.5,(edge.az+edge.bz)*0.5)
local frame={ax=edge.ax,az=edge.az,nx=nx,nz=nz,
    ux=edge.dx/edge.length,uz=edge.dz/edge.length,length=edge.length}
local origin={x=165.047,z=-465.489}
local function sites()
    local result={}
    for _,station in ipairs({20,45,70,95,120,145,170,195}) do
        result[#result+1]={station=station,
            entry={x=frame.ax+station*frame.ux-frame.nx*18,
                z=frame.az+station*frame.uz-frame.nz*18}}
    end
    return result
end
local scene=assert(S.observe(root,poly))
assert(scene.workingCount==1 and scene.headingCount==1
    and scene.motionCount==0,
    "a heading alone is not a measured movement vector")
S.sample(root,500,sourceField)
moving.z=moving.z+5
S.sample(root,500,sourceField)
scene=assert(S.observe(root,poly))
assert(scene.motionCount==1 and scene.peers[1].speedMps>0,
    "two samples provide measured motion separate from heading")
local ranking=assert(S.rank(sites(),origin,frame,scene))
assert(ranking[1].station>=70 and ranking[1].station<=145,
    "one working peer near the eastern turn should favour center")
local byStation={}
for i=1,#ranking do byStation[ranking[i].station]=ranking[i] end
assert(byStation[20].peerRisk>=3,
    "east-end candidate intrudes on observed moving peer's corridor")
assert(byStation[20].score>byStation[120].score,
    "17m shorter Euclidean entry must not override demand")
local edges=S.edgeEvidence(poly)
local narrow={densityMapPolygon={pointsX={0,18,18,0},
    pointsZ={0,0,14,14}}}
assert(#S.edgeEvidence(assert(G.polygonFor(narrow)))==4,
    "eligible short edges must appear in Situation Assessment evidence")
assert(#edges>=2,"candidate edges must not be limited to one fixture")
local seen={}
for i=1,#edges do
    local candidate=edges[i]
    assert(candidate.status=="GEOMETRIC_CANDIDATE_PENDING_ROUTE_QUALIFICATION")
    assert(not seen[candidate.edge])
    seen[candidate.edge]=true
end
assert(seen[9],"the historical edge remains a geometric candidate")
S.reset()
scene=assert(S.observe(root,poly))
assert(scene.motionCount==0 and scene.headingCount==1,
    "reset invalidates old movement estimates without losing current heading")
known=false
scene=assert(S.observe(root,poly))
ranking=assert(S.rank(sites(),origin,frame,scene))
assert(ranking[1].station==20,
    "without a working peer retain the old distance-only preference")
print("destination situation assessment: observed motion, central choice, candidate-only west edge PASS")
