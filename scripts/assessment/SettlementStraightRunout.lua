-- Bounded, continuous planar swept-envelope diagnostic of a *rigidly
-- translated nominal member snapshot*. NO steering, driving or Control.
-- Specification Jurisdictions: `SETTLEMENT_CORRIDOR_ASSESSMENT`
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.SettlementStraightRunout={}
local Runout=OuttaMyWay.SettlementStraightRunout
local Assessment=OuttaMyWay.SettlementCorridorAssessment
local EPS=0.000001
local MAX_SEEDS=4
local MAX_BISECTIONS=8
local MAX_HORIZON_M=230 -- bound diagnostic work, NOT required run-out
local function finite(x)
    return type(x)=="number" and x==x and x~=math.huge and x~=-math.huge
end
local function cross(o,a,b)
    return (a.x-o.x)*(b.z-o.z)-(a.z-o.z)*(b.x-o.x)
end
-- The sweep of a *convex* rectangle under a constant straight translation
-- equals the convex hull of the starting and ending rectangles. This includes
-- all intermediate positions without longitudinal point sampling.
local function sweptHull(rect,dx,dz)
    local points={}
    for i=1,#rect do
        local p=rect[i]
        if not finite(p.x) or not finite(p.z) then return nil end
        points[#points+1]={x=p.x,z=p.z}
        points[#points+1]={x=p.x+dx,z=p.z+dz}
    end
    table.sort(points,function(a,b)
        if a.x==b.x then return a.z<b.z end
        return a.x<b.x
    end)
    local lower,upper={},{}
    for i=1,#points do
        local p=points[i]
        while #lower>=2 and cross(lower[#lower-1],lower[#lower],p)<=EPS do
            lower[#lower]=nil
        end
        lower[#lower+1]=p
    end
    for i=#points,1,-1 do
        local p=points[i]
        while #upper>=2 and cross(upper[#upper-1],upper[#upper],p)<=EPS do
            upper[#upper]=nil
        end
        upper[#upper+1]=p
    end
    lower[#lower],upper[#upper]=nil,nil
    for i=1,#upper do lower[#lower+1]=upper[i] end
    if #lower<3 then return nil end
    return lower
end

local function check(seed,source,neighbors,distance)
    local tx,tz=seed.tx*distance,seed.tz*distance
    for i=1,#seed.rects do
        local hull=sweptHull(seed.rects[i],tx,tz)
        if hull==nil then return nil,"INVALID_MEMBER_HULL" end
        local inSource=Assessment.shapeIntersectsPolygon(hull,source)
        if inSource==nil then return nil,"SOURCE_POLYGON_UNAVAILABLE" end
        if inSource then return false,"SOURCE_FIELD_INTERSECTION" end
        for n=1,#neighbors do
            local other=neighbors[n]
            local conflict=Assessment.shapeIntersectsPolygon(hull,
                type(other)=="table" and other.polygon)
            if conflict==nil then return nil,"NEIGHBOR_POLYGON_UNAVAILABLE" end
            if conflict then return false,"NEIGHBOR_FIELD_INTERSECTION" end
        end
    end
    return true,nil
end

-- Tests a *single* selected static nominal pose and its straight edge-parallel
-- continuation. A positive lower bound covers the entire swept union of
-- every current member base rectangle, against *registered field polygons
-- only*. It says nothing about road, hedge, dynamic space, steering or fold.
local function evaluate(seed,source,neighbors)
    local out={
        stationM=seed.stationM,depthM=seed.depthM,
        direction=seed.direction,
        horizonM=0,lowerBoundM=0,upperBoundM=0,
        queryCount=0,blockedBy="none",status="WAITING_FOR_EVIDENCE",
        basis="RIGID_NOMINAL_TRANSLATION_REGISTERED_POLYGONS_ONLY"
    }
    if type(seed.rects)~="table" or #seed.rects<1
        or not finite(seed.forwardHeadroomM)
        or not finite(seed.tx) or not finite(seed.tz)
        or not finite(seed.stationM) or not finite(seed.depthM)
        or (seed.direction~=1 and seed.direction~=-1) then
        out.blockedBy="SEED_GEOMETRY_UNAVAILABLE"
        return out
    end
    local horizon=math.min(MAX_HORIZON_M,math.max(0,seed.forwardHeadroomM))
    out.horizonM=horizon
    out.upperBoundM=horizon
    if horizon<=EPS then
        out.blockedBy="EDGE_ENDPOINT_LIMIT"
        return out
    end
    local hits,why=check(seed,source,neighbors,0)
    out.queryCount=out.queryCount+1
    if hits~=true then
        out.blockedBy=why or "START_NOT_POLYGON_CLEAR"
        return out
    end
    local whole,barrier=check(seed,source,neighbors,horizon)
    out.queryCount=out.queryCount+1
    if whole==true then
        out.lowerBoundM=horizon
        out.upperBoundM=horizon
        out.blockedBy="EDGE_ENDPOINT_LIMIT"
        out.status="POLYGON_ONLY_CONTINUOUS_GEOMETRY"
        return out
    end
    if whole==nil then
        out.blockedBy=barrier or "UNKNOWN_GEOMETRY"
        return out
    end
    local lo,hi=0,horizon
    out.blockedBy=barrier or "REGISTERED_FIELD_CONFLICT"
    for i=1,MAX_BISECTIONS do
        local mid=(lo+hi)*0.5
        local clear,reason=check(seed,source,neighbors,mid)
        out.queryCount=out.queryCount+1
        if clear==true then lo=mid
        elseif clear==false then
            hi=mid
            out.blockedBy=reason or out.blockedBy
        else
            out.blockedBy=reason or "UNKNOWN_GEOMETRY"
            return out
        end
    end
    out.lowerBoundM=lo
    out.upperBoundM=hi
    out.status="POLYGON_ONLY_CONTINUOUS_GEOMETRY"
    return out
end

function Runout.assess(staticResult,source,neighbors,truncated)
    local out={
        status="WAITING_FOR_EVIDENCE",
        basis="RIGID_NOMINAL_TRANSLATION_REGISTERED_POLYGONS_ONLY",
        reason="NO_STRAIGHT_SEED",assessedSeeds=0,
        continuousGeometrySeeds=0,unknownSeeds=0,
        maxLowerBoundM=0,results={},queryCount=0
    }
    if truncated==true or type(staticResult)~="table"
        or type(source)~="table" or type(neighbors)~="table"
        or type(staticResult.sweepSeeds)~="table"
        or #staticResult.sweepSeeds>MAX_SEEDS then
        out.reason="GEOMETRY_OR_NEIGHBOR_CATALOGUE_UNAVAILABLE"
        return out
    end
    for i=1,#staticResult.sweepSeeds do
        local sample=evaluate(staticResult.sweepSeeds[i],source,neighbors)
        out.results[#out.results+1]=sample
        out.assessedSeeds=out.assessedSeeds+1
        out.queryCount=out.queryCount+sample.queryCount
        if sample.status=="POLYGON_ONLY_CONTINUOUS_GEOMETRY" then
            out.continuousGeometrySeeds=out.continuousGeometrySeeds+1
            out.maxLowerBoundM=math.max(out.maxLowerBoundM,
                sample.lowerBoundM)
        else
            out.unknownSeeds=out.unknownSeeds+1
        end
    end
    out.reason=out.assessedSeeds==0 and "NO_STATIC_POLYGON_COMPATIBLE_SEEDS"
        or "REGISTERED_POLYGON_CONTINUITY_ONLY"
    return out
end

return Runout
