-- Consecutive polygon vertices, winding, side labelling and outward sampling.
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
local G=OuttaMyWay.FarmEdgeGeometry
local function make(xs,zs)
    return {densityMapPolygon={pointsX=xs,pointsZ=zs}}
end
local p=assert(G.polygonFor(make({0,24,24,0},{0,0,24,24})))
assert(p.vertexCount==4 and #G.edges(p)==4)
assert(G.inside(p,12,12))
assert(not G.inside(p,27,12))
local edges=G.edges(p)
assert(edges[1].side=="Z_MIN")
assert(edges[2].side=="X_MAX")
assert(edges[3].side=="Z_MAX")
assert(edges[4].side=="X_MIN")
for _,e in ipairs(edges) do
    local x,z=(e.ax+e.bx)/2,(e.az+e.bz)/2
    local nx,nz=G.outwardAt(p,e,x,z)
    assert(nx~=nil and nz~=nil)
    assert(G.inside(p,x-nx,z-nz),"inward must be inside")
    assert(not G.inside(p,x+nx,z+nz),"outward must be outside")
end
-- Counterclockwise and clockwise representations must be equivalent.
local reversed=assert(G.polygonFor(make({0,0,24,24},{24,0,0,24})))
for _,e in ipairs(G.edges(reversed)) do
    local x,z=(e.ax+e.bx)/2,(e.az+e.bz)/2
    local nx,nz=G.outwardAt(reversed,e,x,z)
    assert(nx and not G.inside(reversed,x+nx,z+nz))
end
-- Concave polygon: local outward determination remains grounded.
local concave=assert(G.polygonFor(make({0,30,30,20,20,0},
    {0,0,30,30,18,18})))
assert(not G.inside(concave,10,24))
assert(G.inside(concave,10,10))
local distance=G.pointSegmentDistance(12,5,0,0,24,0)
assert(math.abs(distance-5)<0.00001)
assert(math.abs(G.distanceToBoundary(p,12,12)-12)<0.00001)
assert(G.polygonFor(make({0,1,2},{0,0,0}))==nil)
assert(G.polygonFor(make({0,1,2},{0,1}))==nil)
print("Farm edge polygon geometry PASS")
