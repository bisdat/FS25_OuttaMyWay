-- Completed Source Field is registered spatial evidence retained against the
-- exact native FIELDWORK Job Episode, including after the last worker finishes.
OuttaMyWay={}
local positions={}
getWorldTranslation=function(node)
    local p=positions[node]
    if p==nil then error("unknown node") end
    return p.x,0,p.z
end
local function field(id,x1,z1,x2,z2)
    return {fieldId=id,densityMapPolygon={
        pointsX={x1,x2,x2,x1},
        pointsZ={z1,z1,z2,z2}}}
end
local field77=field(77,0,0,100,100)
local field29=field(29,200,200,300,300)
g_fieldManager={fields={[77]=field77,[29]=field29}}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/observation/CompletionFieldMembership.lua")
local identify=OuttaMyWay.CompletionFieldMembership.identify
local root={rootNode=801}
positions[801]={x=40,z=45}
local member={rootNode=802,getRootVehicle=function()return root end}
positions[802]={x=250,z=250}
local associated=assert(identify(member))
assert(associated.fieldId==77 and associated.field==field77
    and associated.rootNode==801 and associated.rootX==40
    and associated.rootZ==45
    and associated.provenance=="ASSEMBLY_ROOT_REGISTERED_POLYGON_MEMBERSHIP",
    "assembly root position, not a child or job identity, selects the field")
positions[801]={x=250,z=250}
local second=assert(identify(root))
assert(second.fieldId==29 and second.field==field29
    and second.fieldId~=2,
    "registered field ID, never the displayed farmland label")
g_fieldManager.fields[99]=field(99,220,220,270,270)
local ambiguous,reason=identify(root)
assert(ambiguous==nil and reason=="ASSEMBLY_FIELD_MEMBERSHIP_AMBIGUOUS",
    "overlapping registered field polygons must remain ambiguous")
g_fieldManager.fields[99]=nil
g_fieldManager.fields[100]=field29
assert(assert(identify(root)).fieldId==29,
    "a second registry reference to one field is not a second field")
g_fieldManager.fields[100]=nil
positions[801]={x=1000,z=1000}
local outside,why=identify(root)
assert(outside==nil and why=="ASSEMBLY_OUTSIDE_REGISTERED_FIELDS",
    "never infer the completed Source Field from its job or proximity")
positions[801]={x=40,z=45}
g_fieldManager.fields[17]={fieldId=17,densityMapPolygon={}}
local broken,bwhy=identify(root)
assert(broken==nil and bwhy=="REGISTERED_FIELD_POLYGON_UNAVAILABLE",
    "incomplete field registry cannot positively prove uniqueness")
g_fieldManager.fields[17]=nil
g_fieldManager.fields=nil
local absent,absentReason=identify(root)
assert(absent==nil and absentReason=="REGISTERED_FIELD_CATALOGUE_UNAVAILABLE")
g_fieldManager.fields={[77]=field77,[29]=field29}
local noRoot,noRootWhy=identify({getRootVehicle=function()return nil end})
assert(noRoot==nil and noRootWhy=="COMPLETED_ASSEMBLY_ROOT_UNAVAILABLE")
local noPose,noPoseWhy=identify({rootNode=0})
assert(noPose==nil and noPoseWhy=="COMPLETED_ASSEMBLY_POSE_UNAVAILABLE")
assert(assert(identify({rootNode=801,fieldId=29})).fieldId==77,
    "field identity is never read from vehicle properties")
-- The final worker leaves the GIANTS registry before its positive stop event.
local enabled=true
local configuration={isResolved=function() return true end,
    isEnabled=function() return enabled end}
g_server={}
AIJobFieldWork={}
local function job(id)
    return {jobId=id,isa=function(_,klass) return klass==AIJobFieldWork end}
end
local witness=OuttaMyWay.CompletionFieldMembership.new(configuration)
local episode=job(71)
root.spec_aiFieldWorker={isActive=true}
root.spec_aiJobVehicle={job=episode}
g_currentMission={aiSystem={activeJobVehicles={[root]=true}}}
positions[801]={x=40,z=45}
witness:update(1000)
g_currentMission.aiSystem.activeJobVehicles={}
positions[801]={x=102,z=45}
local retained=assert(witness:take(episode,root,true))
assert(retained.fieldId==77
    and retained.provenance=="ACTIVE_FIELDWORK_REGISTERED_POLYGON_MEMBERSHIP",
    "last completed worker retains its own positively sampled Source Field")
assert(witness.byJob[episode]==nil,"witness consumed exactly once")
local newEpisode=job(72)
root.spec_aiJobVehicle.job=newEpisode
local missing,why=witness:take(newEpisode,root,true)
assert(missing==nil and why=="ASSEMBLY_OUTSIDE_REGISTERED_FIELDS",
    "a second job must not inherit the earlier field")
g_currentMission.aiSystem.activeJobVehicles={[root]=true}
witness:update(1000) -- outside: no positive source association
positions[801]={x=250,z=250}
witness:update(1000) -- subsequently positive native work sample
positions[801]={x=3000,z=3000}
local nextField=assert(witness:take(newEpisode,root,true))
assert(nextField.fieldId==29,
    "retry unresolved work-time samples instead of treating a miss as final")
local interrupted=job(73)
root.spec_aiJobVehicle.job=interrupted
positions[801]={x=40,z=45}
witness:update(1000)
assert(witness:take(interrupted,root,false)==nil,
    "unsuccessful termination discards the witness")
positions[801]={x=3000,z=3000}
assert(witness:take(interrupted,root,true)==nil,
    "a discarded sample must never become a later parking admission")
local disabledJob=job(74)
root.spec_aiJobVehicle.job=disabledJob
positions[801]={x=40,z=45}
witness:update(1000)
enabled=false
witness:update(1)
positions[801]={x=3000,z=3000}
assert(witness:take(disabledJob,root,true)==nil,
    "product disablement erases retained job membership")
witness:reset()
assert(next(witness.byJob)==nil)
print("Completion Field Membership and job-scoped Source Field witness PASS")
