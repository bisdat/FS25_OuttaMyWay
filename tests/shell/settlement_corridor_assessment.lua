-- Live polygon intersection contract following retirement of the standalone
-- hypothetical AssemblySettlementProbe. Original probe fixture is preserved
-- at docs/research/retired/tests__shell__settlement_corridor_assessment_experiment.lua.
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/assessment/SettlementCorridorAssessment.lua")
local test=OuttaMyWay.SettlementCorridorAssessment.shapeIntersectsPolygon
local poly={xs={0,20,20,0},zs={0,0,20,20},vertexCount=4}
local function box(ax,az,bx,bz)
    return {{x=ax,z=az},{x=bx,z=az},{x=bx,z=bz},{x=ax,z=bz}}
end

assert(test(box(22,4,24,7),poly)==false,
    "completely exterior nominal member must be polygon-separate")
assert(test(box(18,4,22,7),poly)==true,
    "edge crossing is conflict even with exterior root")
assert(test(box(4,4,5,5),poly)==true,
    "member fully contained by source field must be conflict")
assert(test(box(-2,-2,25,25),poly)==true,
    "polygon contained by the swept convex member hull must conflict")
assert(test(box(0,4,2,7),poly)==true,
    "touching registered field edge is a conflict")
assert(test(box(25,4,26,6),nil)==nil,
    "unavailable field polygon must remain unknown")
assert(test(nil,poly)==nil,
    "unavailable member geometry must remain unknown")
-- Concave 'C' shaped field: all rectangle corners may lie outside while
-- the tested assembly rectangle crosses the thin central arm.
local concave={xs={0,12,12,3,3,12,12,0},zs={0,0,3,3,9,9,12,12},vertexCount=8}
assert(test(box(2,4,6,8),concave)==true,
    "corner-only tests cannot dismiss concave polygon crossing")
print("Settlement Corridor live nominal polygon intersection PASS")
