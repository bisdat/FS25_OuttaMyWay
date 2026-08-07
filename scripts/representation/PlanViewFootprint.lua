OuttaMyWay.PlanViewFootprint = {}
local Footprint = OuttaMyWay.PlanViewFootprint

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function copyPoint(point)
    return {x=point.x,z=point.z}
end

local function cross(o,a,b)
    return (a.x-o.x)*(b.z-o.z)-(a.z-o.z)*(b.x-o.x)
end

function Footprint.convexHull(points)
    local sorted={}
    for _,point in OuttaMyWay.ValueRecord.ipairs(points or {}) do
        if finite(point.x) and finite(point.z) then sorted[#sorted+1]=copyPoint(point) end
    end
    table.sort(sorted,function(a,b) return a.x==b.x and a.z<b.z or a.x<b.x end)
    local unique={}
    for _,point in ipairs(sorted) do
        local previous=unique[#unique]
        if previous==nil or math.abs(previous.x-point.x)>0.000001 or math.abs(previous.z-point.z)>0.000001 then unique[#unique+1]=point end
    end
    if #unique<=2 then return unique end
    local lower={}
    for _,point in ipairs(unique) do
        while #lower>=2 and cross(lower[#lower-1],lower[#lower],point)<=0 do table.remove(lower) end
        lower[#lower+1]=point
    end
    local upper={}
    for index=#unique,1,-1 do
        local point=unique[index]
        while #upper>=2 and cross(upper[#upper-1],upper[#upper],point)<=0 do table.remove(upper) end
        upper[#upper+1]=point
    end
    table.remove(lower); table.remove(upper)
    for _,point in ipairs(upper) do lower[#lower+1]=point end
    return lower
end

local function primitivePoints(primitive)
    if primitive.kind=="DISC" then
        local result={}
        local segments=primitive.hullSegments or 12
        for index=0,segments-1 do
            local angle=(2*math.pi*index)/segments
            result[#result+1]={x=primitive.x+math.cos(angle)*primitive.radius,z=primitive.z+math.sin(angle)*primitive.radius}
        end
        return result
    end
    if primitive.kind=="ORIENTED_RECTANGLE" then return primitive.corners or {} end
    return {}
end

function Footprint.summarise(primitives)
    local points={}
    local minX,maxX,minZ,maxZ=nil,nil,nil,nil
    local physicalCount,diagnosticCount=0,0
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(primitives or {}) do
        if primitive.positiveConflictSupport==true then physicalCount=physicalCount+1 else diagnosticCount=diagnosticCount+1 end
        for _,point in ipairs(primitivePoints(primitive)) do
            points[#points+1]=point
            minX=minX==nil and point.x or math.min(minX,point.x)
            maxX=maxX==nil and point.x or math.max(maxX,point.x)
            minZ=minZ==nil and point.z or math.min(minZ,point.z)
            maxZ=maxZ==nil and point.z or math.max(maxZ,point.z)
        end
    end
    local hull=Footprint.convexHull(points)
    return {
        primitiveCount=#(primitives or {}),physicalPrimitiveCount=physicalCount,diagnosticPrimitiveCount=diagnosticCount,
        bounds=minX and {minX=minX,maxX=maxX,minZ=minZ,maxZ=maxZ,width=maxX-minX,length=maxZ-minZ} or nil,
        hull=hull,hullPointCount=#hull
    }
end

local function discPair(a,b,velocityA,velocityB,horizon)
    local dx=b.x-a.x; local dz=b.z-a.z
    local required=(a.radius or 0)+(b.radius or 0)
    local distance=math.sqrt(dx*dx+dz*dz)
    local current=distance<=required
    local rvx=(velocityB.x or 0)-(velocityA.x or 0)
    local rvz=(velocityB.z or 0)-(velocityA.z or 0)
    local rv2=rvx*rvx+rvz*rvz
    local tcpa=nil
    local cpa=distance
    if rv2>0.000001 then
        tcpa=-(dx*rvx+dz*rvz)/rv2
        local bounded=math.max(0,math.min(horizon,tcpa))
        local cx=dx+rvx*bounded; local cz=dz+rvz*bounded
        cpa=math.sqrt(cx*cx+cz*cz)
    end
    local future=not current and tcpa~=nil and tcpa>=0 and tcpa<=horizon and cpa<=required
    return {current=current,future=future,distance=distance,required=required,tcpa=tcpa,cpa=cpa}
end

function Footprint.evaluateShadowPair(subject,other,horizon,subjectVelocity,otherVelocity)
    local best=nil
    local physicalSubject,physicalOther={},{}
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(subject and subject.worldPrimitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true then physicalSubject[#physicalSubject+1]=primitive end
    end
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(other and other.worldPrimitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true then physicalOther[#physicalOther+1]=primitive end
    end
    for _,a in ipairs(physicalSubject) do
        for _,b in ipairs(physicalOther) do
            local result=discPair(a,b,subjectVelocity or {},otherVelocity or {},horizon or 0)
            result.subjectPrimitiveId=a.identity; result.otherPrimitiveId=b.identity
            if best==nil or result.cpa<best.cpa then best=result end
            if result.current then
                result.outcome="SHADOW_CURRENT_INTERACTION_POSITIVE"
                result.authority="POSITIVE_CONFLICT_SUPPORT_ONLY"
                result.subjectPhysicalPrimitiveCount=#physicalSubject; result.otherPhysicalPrimitiveCount=#physicalOther
                return result
            end
        end
    end
    if best~=nil and best.future then
        best.outcome="SHADOW_FUTURE_CONVERGENCE_POSITIVE"
        best.authority="POSITIVE_CONFLICT_SUPPORT_ONLY"
    else
        best=best or {distance=nil,required=nil,tcpa=nil,cpa=nil}
        best.current=false; best.future=false
        best.outcome="SHADOW_CLEARANCE_UNRESOLVED"
        best.authority="NO_NEGATIVE_CLEARANCE_AUTHORITY"
    end
    best.subjectPhysicalPrimitiveCount=#physicalSubject; best.otherPhysicalPrimitiveCount=#physicalOther
    return best
end
