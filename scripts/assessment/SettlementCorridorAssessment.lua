-- Pure nominal polygon assessment of one actual selected Physical Assembly.
-- Specification Jurisdictions: `SETTLEMENT_CORRIDOR_ASSESSMENT`
-- NO positive result from this module is physical clearance, a route or Control.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.SettlementCorridorAssessment={}
local Assessment=OuttaMyWay.SettlementCorridorAssessment
local G=OuttaMyWay.FarmEdgeGeometry
local EPS=0.00001
-- Finite diagnostic stations, not a claim of continuous longitudinal coverage.
local STATION_FRACTIONS={0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9}
local DEPTHS_M={2,3,4,5,6,8,10,12}
local DIRECTIONS={1,-1}
local CORNER_ORDER={1,2,4,3}

local function finite(x)
    return type(x)=="number" and x==x
        and x~=math.huge and x~=-math.huge
end
local function cross(ax,az,bx,bz,cx,cz)
    return (bx-ax)*(cz-az)-(bz-az)*(cx-ax)
end
local function onSegment(ax,az,bx,bz,x,z)
    return math.abs(cross(ax,az,bx,bz,x,z))<=EPS
        and x>=math.min(ax,bx)-EPS and x<=math.max(ax,bx)+EPS
        and z>=math.min(az,bz)-EPS and z<=math.max(az,bz)+EPS
end
local function intersect(ax,az,bx,bz,cx,cz,dx,dz)
    local a,b=cross(ax,az,bx,bz,cx,cz),cross(ax,az,bx,bz,dx,dz)
    local c,d=cross(cx,cz,dx,dz,ax,az),cross(cx,cz,dx,dz,bx,bz)
    if (a>EPS and b < -EPS or a < -EPS and b>EPS)
        and (c>EPS and d < -EPS or c < -EPS and d>EPS) then return true end
    return (math.abs(a)<=EPS and onSegment(ax,az,bx,bz,cx,cz))
        or (math.abs(b)<=EPS and onSegment(ax,az,bx,bz,dx,dz))
        or (math.abs(c)<=EPS and onSegment(cx,cz,dx,dz,ax,az))
        or (math.abs(d)<=EPS and onSegment(cx,cz,dx,dz,bx,bz))
end
local function withinRing(points,x,z)
    local inside=false
    for i=1,#points do
        local j=i==#points and 1 or i+1
        local a,b=points[i],points[j]
        if onSegment(a.x,a.z,b.x,b.z,x,z) then return true end
        if (a.z>z)~=(b.z>z) then
            local hit=a.x+(b.x-a.x)*(z-a.z)/(b.z-a.z)
            if x<hit then inside=not inside end
        end
    end
    return inside
end
local function shapeIntersectsPolygon(rect,poly)
    if type(rect)~="table" or #rect<3 or poly==nil
        or type(poly.xs)~="table" or type(poly.zs)~="table"
        or not finite(poly.vertexCount) then return nil end
    -- Check both containments and all boundary intersections. Four corners
    -- outside a concave polygon are NOT proof of a clear rectangle.
    for i=1,#rect do
        local p=rect[i]
        if G.inside(poly,p.x,p.z) then return true end
        for j=1,poly.vertexCount do
            local k=j==poly.vertexCount and 1 or j+1
            if onSegment(poly.xs[j],poly.zs[j],
                poly.xs[k],poly.zs[k],p.x,p.z) then return true end
        end
    end
    for i=1,poly.vertexCount do
        if withinRing(rect,poly.xs[i],poly.zs[i]) then return true end
    end
    for i=1,#rect do
        local j=i==#rect and 1 or i+1
        for k=1,poly.vertexCount do
            local l=k==poly.vertexCount and 1 or k+1
            if intersect(rect[i].x,rect[i].z,rect[j].x,rect[j].z,
                poly.xs[k],poly.zs[k],poly.xs[l],poly.zs[l]) then
                return true
            end
        end
    end
    return false
end
-- Also accepts the 4–6 point convex hull of a rigid straight member sweep.
Assessment.shapeIntersectsPolygon=shapeIntersectsPolygon

local function candidateRects(foot,rootFX,rootFZ,edge,station,depth,direction)
    local tx,tz=edge.dx/edge.length*direction,edge.dz/edge.length*direction
    local cos=rootFX*tx+rootFZ*tz
    local sin=rootFX*tz-rootFZ*tx
    local x=edge.ax+edge.dx/edge.length*station+edge.nx*depth
    local z=edge.az+edge.dz/edge.length*station+edge.nz*depth
    local rects,minAlong,maxAlong,minDepth,maxDepth={},math.huge,-math.huge,math.huge,-math.huge
    for member=1,foot.memberCount do
        local rect={}
        for c=1,4 do
            local p=foot.corners[(member-1)*4+CORNER_ORDER[c]]
            local rx=p.x*cos-p.z*sin
            local rz=p.x*sin+p.z*cos
            local along=rx*(edge.dx/edge.length)+rz*(edge.dz/edge.length)
            local lateral=rx*edge.nx+rz*edge.nz
            minAlong,maxAlong=math.min(minAlong,along),math.max(maxAlong,along)
            minDepth,maxDepth=math.min(minDepth,lateral),math.max(maxDepth,lateral)
            rect[c]={x=x+rx,z=z+rz}
        end
        rects[#rects+1]=rect
    end
    return rects,minAlong,maxAlong,minDepth,maxDepth
end

-- Inputs are GIANTS' current, nominal member rectangles, NOT guaranteed
-- folded geometry. Rotation freezes current articulation into a hypothetical
-- edge-parallel pose. This is a necessary polygon-only screening experiment.
function Assessment.assess(foot,rootFX,rootFZ,poly,edge,neighbors,
    catalogueTruncated)
    local outcome={approach="WAITING_FOR_EVIDENCE",
        runOut="WAITING_FOR_EVIDENCE",terminal="WAITING_FOR_EVIDENCE",
        reason="NO_CONTINUOUS_OR_TRANSIT_CLOSURE_EVIDENCE",
        nominalBasis="CURRENT_MEMBER_BASE_RECTANGLES_FROZEN_ARTICULATION",
        assessed=0,nominalNoPolygonConflict=0,
        sourceConflicts=0,neighborConflicts=0,edgeSpill=0,
        unknown=0,best=nil,travelDirections=2,sweepSeeds={}}
    if catalogueTruncated==true or type(neighbors)~="table"
        or type(foot)~="table" or type(foot.corners)~="table"
        or not finite(foot.memberCount) or foot.memberCount<1
        or foot.memberCount>16 or #foot.corners~=foot.memberCount*4
        or type(poly)~="table" or type(edge)~="table"
        or not finite(edge.length) or edge.length<1
        or not finite(edge.nx) or not finite(edge.nz) then
        outcome.reason="GEOMETRY_OR_NEIGHBOR_CATALOGUE_UNAVAILABLE"
        return outcome
    end
    if not finite(rootFX) or not finite(rootFZ) then
        outcome.reason="ROOT_HEADING_UNAVAILABLE"
        return outcome
    end
    local norm=math.sqrt(rootFX*rootFX+rootFZ*rootFZ)
    if norm<0.001 or math.abs(norm-1)>0.05 then
        outcome.reason="ROOT_HEADING_INVALID"
        return outcome
    end
    rootFX,rootFZ=rootFX/norm,rootFZ/norm
    for i=1,#foot.corners do
        if not finite(foot.corners[i].x) or not finite(foot.corners[i].z) then
            outcome.reason="MEMBER_CORNER_INVALID"
            return outcome
        end
    end
    -- No verified fold state, static obstacle coverage, worker demand or
    -- steering/run-out is available; these statuses always stay unresolved.
    outcome.reason="POLYGON_ONLY_NOMINAL_TEST_NOT_CLEARANCE"
    local sweepChoices={}
    for di=1,#DIRECTIONS do
        local direction=DIRECTIONS[di]
        for si=1,#STATION_FRACTIONS do
            local station=edge.length*STATION_FRACTIONS[si]
            local bx,bz=edge.ax+edge.dx*STATION_FRACTIONS[si],
                edge.az+edge.dz*STATION_FRACTIONS[si]
            local nx,nz=G.outwardAt(poly,edge,bx,bz)
            if nx==nil then
                outcome.unknown=outcome.unknown+#DEPTHS_M
            else
                -- The edge's actual local outward orientation, which can
                -- differ from its winding-based normal on unusual polygons.
                local localEdge={ax=edge.ax,az=edge.az,dx=edge.dx,dz=edge.dz,
                    length=edge.length,nx=nx,nz=nz}
                for d=1,#DEPTHS_M do
                    local depth=DEPTHS_M[d]
                    local rects,minAlong,maxAlong,minDepth,maxDepth=
                        candidateRects(foot,rootFX,rootFZ,localEdge,
                            station,depth,direction)
                    outcome.assessed=outcome.assessed+1
                    if station+minAlong<0.5 or station+maxAlong>edge.length-0.5 then
                        outcome.edgeSpill=outcome.edgeSpill+1
                    else
                        local sourceConflict,neighborConflict,invalid=false,false,false
                        for r=1,#rects do
                            local hit=shapeIntersectsPolygon(rects[r],poly)
                            if hit==nil then invalid=true
                            elseif hit then sourceConflict=true end
                            if not sourceConflict then
                                for n=1,#neighbors do
                                    local other=neighbors[n].polygon
                                    local overlap=shapeIntersectsPolygon(rects[r],other)
                                    if overlap==nil then invalid=true;break end
                                    if overlap then neighborConflict=true;break end
                                end
                            end
                        end
                        if invalid then outcome.unknown=outcome.unknown+1
                        elseif sourceConflict then
                            outcome.sourceConflicts=outcome.sourceConflicts+1
                        elseif neighborConflict then
                            outcome.neighborConflicts=outcome.neighborConflicts+1
                        else
                            outcome.nominalNoPolygonConflict=
                                outcome.nominalNoPolygonConflict+1
                            local headroom=direction==1 and
                                station+minAlong or edge.length-(station+maxAlong)
                            local candidate={
                                stationM=station,depthM=depth,direction=direction,
                                nominalWidthM=maxDepth-minDepth,
                                nominalLengthM=maxAlong-minAlong,
                                distanceFromEdgeStartM=headroom
                            }
                            -- Preserve the existing illustrative static
                            -- example separately from *forward* run-out.
                            local forwardHeadroom=direction==1
                                and edge.length-(station+maxAlong)-0.5
                                or station+minAlong-0.5
                            if forwardHeadroom>0 then
                                local seed={
                                    stationM=station,depthM=depth,
                                    direction=direction,
                                    forwardHeadroomM=forwardHeadroom,
                                    tx=edge.dx/edge.length*direction,
                                    tz=edge.dz/edge.length*direction,
                                    rects=rects
                                }
                                local choices=sweepChoices[direction]
                                if choices==nil then
                                    choices={}
                                    sweepChoices[direction]=choices
                                end
                                if choices.longest==nil
                                    or forwardHeadroom
                                        >choices.longest.forwardHeadroomM
                                    or (forwardHeadroom==
                                            choices.longest.forwardHeadroomM
                                        and depth<choices.longest.depthM) then
                                    choices.longest=seed
                                end
                                if choices.shallowest==nil
                                    or depth<choices.shallowest.depthM
                                    or (depth==choices.shallowest.depthM
                                        and forwardHeadroom
                                            >choices.shallowest.forwardHeadroomM) then
                                    choices.shallowest=seed
                                end
                            end
                            if outcome.best==nil or depth<outcome.best.depthM
                                or (depth==outcome.best.depthM
                                    and candidate.distanceFromEdgeStartM
                                        >outcome.best.distanceFromEdgeStartM) then
                                outcome.best=candidate
                            end
                        end
                    end
                end
            end
        end
    end
    -- Two deterministic witnesses per direction: longest available
    -- *edge endpoint* horizon, and shallowest tested outward depth.
    -- They remain hypothetical and never become navigation targets.
    for _,direction in ipairs(DIRECTIONS) do
        local c=sweepChoices[direction]
        if c then
            outcome.sweepSeeds[#outcome.sweepSeeds+1]=c.longest
            if c.shallowest~=c.longest then
                outcome.sweepSeeds[#outcome.sweepSeeds+1]=c.shallowest
            end
        end
    end
    return outcome
end

return Assessment
