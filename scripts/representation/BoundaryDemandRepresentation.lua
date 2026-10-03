--- Purpose-scoped representation for Category-2 boundary demand.
-- Specification Jurisdictions: `ASSESSMENT_REPRESENTATION`
-- Geometry here has Situation-support authority only through its published
-- provenance/claim limits. It creates no Candidate, Decision or Control authority.

OuttaMyWay.BoundaryDemandRepresentation={}
local Representation=OuttaMyWay.BoundaryDemandRepresentation

local EPSILON_M=0.00001
local NUMERICAL_RATIO_TOLERANCE=0.000001

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function atan2(y,x)
    if type(math.atan2)=="function" then return math.atan2(y,x) end
    if x>0 then return math.atan(y/x) end
    if x<0 and y>=0 then return math.atan(y/x)+math.pi end
    if x<0 and y<0 then return math.atan(y/x)-math.pi end
    if y>0 then return math.pi/2 end
    if y<0 then return -math.pi/2 end
    return 0
end

local function distance(a,b)
    local dx,dz=a.x-b.x,a.z-b.z
    return math.sqrt(dx*dx+dz*dz)
end

local function ringPoints(source)
    if type(source)~="table" then return {} end
    if type(source.boundaryLine)=="table" then source=source.boundaryLine end
    local result={}
    for _,point in OuttaMyWay.ValueRecord.ipairs(source or {}) do
        local x=tonumber(point and (point.x or point.worldX or point.posX or point[1]))
        local z=tonumber(point and (point.z or point.worldZ or point.posZ or point[3] or point[2]))
        if finite(x) and finite(z) then result[#result+1]={x=x,z=z} end
    end
    if #result>1 then
        local first,last=result[1],result[#result]
        if math.abs(first.x-last.x)<=EPSILON_M and math.abs(first.z-last.z)<=EPSILON_M then result[#result]=nil end
    end
    return result
end

local function uniqueAppend(values,value)
    for _,current in ipairs(values) do
        if math.abs(current-value)<=1e-10 then return end
    end
    values[#values+1]=value
end

-- Signed area contribution of circle ∩ triangle(O,A,B).  Segment subdivision at
-- circle crossings lets the integral use triangle area for inside subsegments
-- and sector area for outside subsegments.
local function edgeCircleArea(ax,az,bx,bz,radius)
    local dx,dz=bx-ax,bz-az
    local aa=dx*dx+dz*dz
    local parameters={0,1}
    if aa>1e-12 then
        local bb=2*(ax*dx+az*dz)
        local cc=ax*ax+az*az-radius*radius
        local discriminant=bb*bb-4*aa*cc
        if discriminant>1e-12 then
            local root=math.sqrt(discriminant)
            local t1=(-bb-root)/(2*aa)
            local t2=(-bb+root)/(2*aa)
            if t1>0 and t1<1 then uniqueAppend(parameters,t1) end
            if t2>0 and t2<1 then uniqueAppend(parameters,t2) end
        end
    end
    table.sort(parameters)
    local area=0
    for index=1,#parameters-1 do
        local ta,tb=parameters[index],parameters[index+1]
        local pax,paz=ax+dx*ta,az+dz*ta
        local pbx,pbz=ax+dx*tb,az+dz*tb
        local tm=(ta+tb)/2
        local mx,mz=ax+dx*tm,az+dz*tm
        local cross=pax*pbz-paz*pbx
        if mx*mx+mz*mz<=radius*radius+1e-9 then
            area=area+cross/2
        else
            local dot=pax*pbx+paz*pbz
            area=area+radius*radius*atan2(cross,dot)/2
        end
    end
    return area
end

local function ringDiscIntersectionArea(points,cx,cz,radius)
    local ring=ringPoints(points)
    if #ring<3 then return nil,"FIELD_WORLD_RING_UNAVAILABLE" end
    local sum=0
    for index=1,#ring do
        local nextIndex=(index%#ring)+1
        local a,b=ring[index],ring[nextIndex]
        sum=sum+edgeCircleArea(a.x-cx,a.z-cz,b.x-cx,b.z-cz,radius)
    end
    return math.abs(sum),nil
end

function Representation.measureReach(projection,physical)
    local result={
        status="UNRESOLVED",
        reason="BOUNDARY_INTERACTION_REACH_EVIDENCE_UNAVAILABLE",
        decisionAuthority=false,controlAuthority=false,
        negativeClearanceAuthority=false
    }
    if type(projection)~="table" or projection.status~="SUPPORTED"
        or not finite(tonumber(projection.currentX)) or not finite(tonumber(projection.currentZ)) then
        result.reason="SUPPORTED_PROGRESSION_REFERENCE_UNAVAILABLE"
        return result
    end
    if type(physical)~="table" then
        result.reason="CURRENT_PHYSICAL_ASSEMBLY_REPRESENTATION_UNAVAILABLE"
        return result
    end
    local reference={x=tonumber(projection.currentX),z=tonumber(projection.currentZ)}
    local maximum=nil
    local contributors={}
    local maximumPrimitiveId=nil
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical.primitives or physical.worldPrimitives or {}) do
        local radius=tonumber(primitive.radius)
        local px,pz=tonumber(primitive.x),tonumber(primitive.z)
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(px) and finite(pz) and finite(radius) and radius>0 then
            local centreDistance=distance(reference,{x=px,z=pz})
            local reach=centreDistance+radius
            contributors[#contributors+1]={
                identity=primitive.identity,memberReferenceKey=primitive.memberReferenceKey,
                centreDistanceM=centreDistance,primitiveRadiusM=radius,radialReachM=reach
            }
            if maximum==nil or reach>maximum then
                maximum=reach
                maximumPrimitiveId=primitive.identity
            end
        end
    end
    if maximum==nil then
        result.reason="NO_POSITIVE_CURRENT_PHYSICAL_DISC_SUPPORT"
        return result
    end
    table.sort(contributors,function(a,b) return tostring(a.identity)<tostring(b.identity) end)
    result.status="SUPPORTED"
    result.reason="CURRENT_POSITIVE_PHYSICAL_ASSEMBLY_RADIAL_REACH_SUPPORTED"
    result.assemblyId=projection.assemblyId
    result.assemblyReferenceKey=projection.assemblyReferenceKey
    result.referenceX=reference.x; result.referenceZ=reference.z
    result.boundaryInteractionReachM=maximum
    result.maximumPrimitiveId=maximumPrimitiveId
    result.contributors=contributors
    result.contributorCount=#contributors
    result.configurationProfileId=physical.configurationProfileId
    result.coverageComplete=physical.coverageComplete==true
    result.representationSource=physical.provenance and physical.provenance.source or "UNAVAILABLE"
    result.provenance={
        source="BoundaryDemandRepresentation",geometrySource=result.representationSource,
        purpose="CATEGORY_2_BOUNDARY_INTERACTION_REACH",
        configurationProfileId=result.configurationProfileId,
        structureReuse="JOB_EPISODE_ASSEMBLY_REPRESENTATION_CACHE_WITH_CURRENT_WORLD_TRANSFORMS"
    }
    return result
end

function Representation.measureOptionSpace(fieldWorld,disc)
    local result={
        status="UNRESOLVED",reason="BOUNDARY_OPTION_SPACE_UNAVAILABLE",
        decisionAuthority=false,controlAuthority=false,negativeClearanceAuthority=false
    }
    local cx,cz,radius=tonumber(disc and disc.contactX),tonumber(disc and disc.contactZ),tonumber(disc and disc.radiusM)
    if type(fieldWorld)~="table" or not finite(cx) or not finite(cz) or not finite(radius) or radius<=0 then
        result.reason="FIELD_WORLD_OR_BOUNDARY_DEMAND_DISC_UNAVAILABLE"
        return result
    end
    local outer,outerReason=ringDiscIntersectionArea(fieldWorld.boundary,cx,cz,radius)
    if outer==nil then result.reason=outerReason; return result end
    local islandArea=0
    for _,island in OuttaMyWay.ValueRecord.ipairs(fieldWorld.islands or {}) do
        local area=ringDiscIntersectionArea(island,cx,cz,radius)
        if area~=nil then islandArea=islandArea+area end
    end
    local full=math.pi*radius*radius
    local clipped=math.max(0,math.min(full,outer-islandArea))
    result.status="SUPPORTED"
    result.reason="FIELD_WORLD_CLIPPED_BOUNDARY_DEMAND_DISC_AREA_SUPPORTED"
    result.fullDiscAreaM2=full
    result.clippedAreaM2=clipped
    result.boundaryOptionSpaceRatio=full>0 and clipped/full or nil
    result.ratioNumericalTolerance=NUMERICAL_RATIO_TOLERANCE
    result.provenance={
        source="BoundaryDemandRepresentation",
        method="EXACT_POLYGON_CIRCLE_EDGE_INTEGRATION",
        fieldWorldReferenceKey=fieldWorld.fieldWorldReferenceKey or fieldWorld.fieldPolygonReferenceKey,
        geometryFingerprint=fieldWorld.geometryFingerprint
    }
    return result
end

local function pointInDiscStrict(point,disc)
    local radius=tonumber(disc and disc.radiusM)
    if not finite(radius) or radius<=0 then return false,nil end
    local d=distance(point,{x=disc.contactX,z=disc.contactZ})
    return d<radius-EPSILON_M,radius-d
end

local function fieldContains(fieldWorld,point)
    if type(OuttaMyWay.FieldWorldSnapshotRegistry)~="table"
        or type(OuttaMyWay.FieldWorldSnapshotRegistry.evaluatePositionContainment)~="function" then return false end
    local result=OuttaMyWay.FieldWorldSnapshotRegistry.evaluatePositionContainment(fieldWorld,point.x,point.z)
    return result and result.resolved==true and result.inside==true
end

local function interiorWitness(fieldWorld,discA,discB,point)
    if type(point)~="table" then return nil end
    local inA,marginA=pointInDiscStrict(point,discA)
    local inB,marginB=pointInDiscStrict(point,discB)
    if not inA or not inB then return nil end
    local margin=math.min(marginA or 0,marginB or 0)
    if margin<=EPSILON_M then return nil end

    if fieldContains(fieldWorld,point) then
        local step=math.max(EPSILON_M*4,math.min(margin*0.25,0.25))
        for ring=1,3 do
            local radius=step*ring
            for index=0,15 do
                local angle=index*math.pi/8
                local candidate={x=point.x+math.cos(angle)*radius,z=point.z+math.sin(angle)*radius}
                local ia=pointInDiscStrict(candidate,discA)
                local ib=pointInDiscStrict(candidate,discB)
                if ia and ib and fieldContains(fieldWorld,candidate) then return candidate end
            end
        end
        -- A point that is strictly interior to both discs and accepted by Field
        -- World containment is useful evidence even when the local field wedge is
        -- narrower than the finite perturbation search.
        return {x=point.x,z=point.z}
    end
    return nil
end

local function lensAnchor(a,b)
    local c1={x=a.contactX,z=a.contactZ}
    local c2={x=b.contactX,z=b.contactZ}
    local d=distance(c1,c2)
    if d<=EPSILON_M then return {x=c1.x,z=c1.z} end
    local r1,r2=a.radiusM,b.radiusM
    local along=(d+r1-r2)/2
    if along<0 then along=0 elseif along>d then along=d end
    local t=along/d
    return {x=c1.x+(c2.x-c1.x)*t,z=c1.z+(c2.z-c1.z)*t}
end

local function nearestOnSegment(point,a,b)
    local dx,dz=b.x-a.x,b.z-a.z
    local squared=dx*dx+dz*dz
    if squared<=1e-12 then return {x=a.x,z=a.z} end
    local t=((point.x-a.x)*dx+(point.z-a.z)*dz)/squared
    if t<0 then t=0 elseif t>1 then t=1 end
    return {x=a.x+t*dx,z=a.z+t*dz}
end

local function segmentCircleIntersections(a,b,disc)
    local cx,cz,radius=disc.contactX,disc.contactZ,disc.radiusM
    local ax,az=a.x-cx,a.z-cz
    local dx,dz=b.x-a.x,b.z-a.z
    local aa=dx*dx+dz*dz
    local result={}
    if aa<=1e-12 then return result end
    local bb=2*(ax*dx+az*dz)
    local cc=ax*ax+az*az-radius*radius
    local discriminant=bb*bb-4*aa*cc
    if discriminant<0 then return result end
    local root=math.sqrt(math.max(0,discriminant))
    for _,t in ipairs({(-bb-root)/(2*aa),(-bb+root)/(2*aa)}) do
        if t>=0 and t<=1 then result[#result+1]={x=a.x+dx*t,z=a.z+dz*t} end
    end
    return result
end

local function candidateToward(anchor,point,fraction)
    return {x=point.x+(anchor.x-point.x)*fraction,z=point.z+(anchor.z-point.z)*fraction}
end

local function inspectFieldRingForWitness(fieldWorld,ringSource,discA,discB,anchor)
    local ring=ringPoints(ringSource)
    for _,vertex in ipairs(ring) do
        local witness=interiorWitness(fieldWorld,discA,discB,vertex)
        if witness~=nil then return witness,"FIELD_VERTEX_INSIDE_BOTH_BOUNDARY_DEMAND_DISCS" end
    end
    for index=1,#ring do
        local nextIndex=(index%#ring)+1
        local a,b=ring[index],ring[nextIndex]
        local nearest=nearestOnSegment(anchor,a,b)
        local witness=interiorWitness(fieldWorld,discA,discB,nearest)
        if witness~=nil then return witness,"FIELD_EDGE_NEAREST_POINT_INSIDE_BOTH_BOUNDARY_DEMAND_DISCS" end
        for _,disc in ipairs({discA,discB}) do
            for _,intersection in ipairs(segmentCircleIntersections(a,b,disc)) do
                witness=interiorWitness(fieldWorld,discA,discB,candidateToward(anchor,intersection,0.05))
                if witness~=nil then return witness,"FIELD_EDGE_CROSSES_BOUNDARY_DEMAND_LENS" end
            end
        end
    end
    return nil,nil
end

function Representation.sharedOverlap(fieldWorld,discA,discB)
    local result={
        status="UNRESOLVED",reason="BOUNDARY_DEMAND_DISC_OVERLAP_UNAVAILABLE",
        positive=false,decisionAuthority=false,controlAuthority=false,
        negativeClearanceAuthority=false
    }
    if type(fieldWorld)~="table" or type(discA)~="table" or type(discB)~="table"
        or not finite(tonumber(discA.contactX)) or not finite(tonumber(discA.contactZ))
        or not finite(tonumber(discB.contactX)) or not finite(tonumber(discB.contactZ))
        or not finite(tonumber(discA.radiusM)) or not finite(tonumber(discB.radiusM))
        or discA.radiusM<=0 or discB.radiusM<=0 then
        result.reason="FIELD_WORLD_OR_BOUNDARY_DEMAND_DISC_UNAVAILABLE"
        return result
    end
    local separation=distance({x=discA.contactX,z=discA.contactZ},{x=discB.contactX,z=discB.contactZ})
    local reachSum=discA.radiusM+discB.radiusM
    local rawMargin=reachSum-separation
    result.contactSeparationM=separation
    result.reachSumM=reachSum
    result.rawOverlapMarginM=rawMargin
    result.rawDiscOverlap=rawMargin>EPSILON_M
    if result.rawDiscOverlap~=true then
        result.status="SUPPORTED"
        result.reason="NO_POSITIVE_RAW_BOUNDARY_DEMAND_DISC_OVERLAP"
        return result
    end

    local anchor=lensAnchor(discA,discB)
    local witness=interiorWitness(fieldWorld,discA,discB,anchor)
    local witnessReason=witness and "BOUNDARY_DEMAND_LENS_ANCHOR_INSIDE_FIELD_WORLD" or nil

    if witness==nil then
        local outerReason=nil
        witness,outerReason=inspectFieldRingForWitness(fieldWorld,fieldWorld.boundary,discA,discB,anchor)
        witnessReason=outerReason
    end
    if witness==nil then
        for _,island in OuttaMyWay.ValueRecord.ipairs(fieldWorld.islands or {}) do
            local islandReason=nil
            witness,islandReason=inspectFieldRingForWitness(fieldWorld,island,discA,discB,anchor)
            if witness~=nil then witnessReason=islandReason break end
        end
    end

    result.status="SUPPORTED"
    if witness~=nil then
        result.positive=true
        result.reason="POSITIVE_FIELD_WORLD_CLIPPED_BOUNDARY_DEMAND_DISC_OVERLAP"
        result.witness={x=witness.x,z=witness.z,reason=witnessReason}
        result.provenance={source="BoundaryDemandRepresentation",method="POSITIVE_INTERIOR_WITNESS",claim="SHARED_CATEGORY_2_LOCALITY"}
    else
        result.reason="RAW_DISC_OVERLAP_WITHOUT_POSITIVE_FIELD_WORLD_INTERIOR_WITNESS"
        result.provenance={source="BoundaryDemandRepresentation",method="POSITIVE_INTERIOR_WITNESS_SEARCH",claim="UNRESOLVED_CLIPPED_OVERLAP"}
    end
    return result
end

function Representation.currentOccupancyInDisc(fieldWorld,physical,disc)
    if type(physical)~="table" or type(disc)~="table" then return nil,"PHYSICAL_OR_BOUNDARY_DEMAND_DISC_UNAVAILABLE" end
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical.primitives or physical.worldPrimitives or {}) do
        local radius=tonumber(primitive.radius)
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(tonumber(primitive.x)) and finite(tonumber(primitive.z)) and finite(radius) and radius>0 then
            local overlap=Representation.sharedOverlap(fieldWorld,disc,{
                contactX=tonumber(primitive.x),contactZ=tonumber(primitive.z),radiusM=radius
            })
            if overlap.positive==true then
                return {
                    positive=true,primitiveId=primitive.identity,witness=overlap.witness,
                    reason="CURRENT_POSITIVE_PHYSICAL_DISC_INTERSECTS_BOUNDARY_DEMAND_DISC",
                    negativeClearanceAuthority=false
                },nil
            end
        end
    end
    return {
        positive=false,reason="NO_POSITIVE_CURRENT_PHYSICAL_DISC_INTERSECTION_OBSERVED",
        negativeClearanceAuthority=false
    },nil
end

return Representation
