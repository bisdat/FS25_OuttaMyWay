OuttaMyWay.FieldBoundedFutureSpace = {}
local Future=OuttaMyWay.FieldBoundedFutureSpace

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function pointXZ(point)
    if type(point)~="table" then return nil,nil end
    return tonumber(point.x or point[1]),tonumber(point.z or point[2] or point[3])
end

local function raySegmentDistance(ox,oz,dx,dz,ax,az,bx,bz)
    local sx,sz=bx-ax,bz-az
    local den=dx*sz-dz*sx
    if math.abs(den)<0.000001 then return nil end
    local qx,qz=ax-ox,az-oz
    local t=(qx*sz-qz*sx)/den
    local u=(qx*dz-qz*dx)/den
    if t>=0 and u>=0 and u<=1 then return t end
    return nil
end

local function ringRayDistance(points,ox,oz,dx,dz)
    if type(points)~="table" or #points<2 then return nil end
    local best=nil
    for index=1,#points do
        local nextIndex=(index % #points)+1
        local ax,az=pointXZ(points[index])
        local bx,bz=pointXZ(points[nextIndex])
        if finite(ax) and finite(az) and finite(bx) and finite(bz) then
            local distance=raySegmentDistance(ox,oz,dx,dz,ax,az,bx,bz)
            if distance~=nil and (best==nil or distance<best) then best=distance end
        end
    end
    return best
end

function Future.forwardBoundaryDistance(fieldWorldSnapshot,pose)
    if type(fieldWorldSnapshot)~="table" or type(pose)~="table" then return nil,"FIELD_WORLD_OR_POSE_UNAVAILABLE" end
    if not finite(pose.x) or not finite(pose.z) or not finite(pose.dx) or not finite(pose.dz) then return nil,"POSE_INVALID" end
    local headingLength=math.sqrt(pose.dx*pose.dx+pose.dz*pose.dz)
    if headingLength<=0.000001 then return nil,"HEADING_INVALID" end
    local dx,dz=pose.dx/headingLength,pose.dz/headingLength
    local best=ringRayDistance(fieldWorldSnapshot.boundary or {},pose.x,pose.z,dx,dz)
    local source=best~=nil and "FIELD_WORLD_OUTER_BOUNDARY" or nil
    for _,island in OuttaMyWay.ValueRecord.ipairs(fieldWorldSnapshot.islands or {}) do
        local distance=ringRayDistance(island,pose.x,pose.z,dx,dz)
        if distance~=nil and (best==nil or distance<best) then best=distance; source="FIELD_WORLD_ISLAND_BOUNDARY" end
    end
    if best==nil then return nil,"FORWARD_FIELD_WORLD_INTERSECTION_UNAVAILABLE" end
    return best,source
end

local function physicalDiscs(representation)
    local result={}
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(representation and representation.worldPrimitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true and finite(primitive.x) and finite(primitive.z) and finite(primitive.radius) then
            result[#result+1]=primitive
        end
    end
    return result
end

function Future.build(worker)
    if worker==nil or worker.activeObserved~=true then return {bounded=false,outcome="FUTURE_SPACE_UNRESOLVED",reason="WORKER_NOT_ACTIVE"} end
    local intent=worker.localIntent or {}
    if intent.classification=="TURNING" then
        return {bounded=false,outcome="FUTURE_SPACE_UNRESOLVED",reason="MANOEUVRE_SWEEP_NOT_YET_REPRESENTED",intentClassification="TURNING",intentEpoch=intent.intentEpoch,authority="NO_NEGATIVE_CLEARANCE_AUTHORITY"}
    end
    if intent.classification~="SETTLED_CONTINUATION" or intent.intentValid~=true then
        return {bounded=false,outcome="FUTURE_SPACE_UNRESOLVED",reason=intent.reason or "LOCAL_INTENT_UNRESOLVED",intentClassification=intent.classification,intentEpoch=intent.intentEpoch,authority="NO_NEGATIVE_CLEARANCE_AUTHORITY"}
    end
    if worker.fieldWorldSnapshot==nil or worker.pose==nil then
        return {bounded=false,outcome="FUTURE_SPACE_UNRESOLVED",reason="FIELD_WORLD_OR_POSE_UNAVAILABLE",intentClassification=intent.classification,intentEpoch=intent.intentEpoch,authority="NO_NEGATIVE_CLEARANCE_AUTHORITY"}
    end
    local distance,boundarySource=Future.forwardBoundaryDistance(worker.fieldWorldSnapshot,worker.pose)
    if distance==nil then
        return {bounded=false,outcome="FUTURE_SPACE_UNRESOLVED",reason=boundarySource,intentClassification=intent.classification,intentEpoch=intent.intentEpoch,authority="NO_NEGATIVE_CLEARANCE_AUTHORITY"}
    end
    local discs=physicalDiscs(worker.shadowRepresentation)
    if #discs==0 then
        return {bounded=false,outcome="FUTURE_SPACE_UNRESOLVED",reason="PHYSICAL_COMPONENT_FOOTPRINT_UNAVAILABLE",intentClassification=intent.classification,intentEpoch=intent.intentEpoch,boundaryDistance=distance,boundarySource=boundarySource,authority="NO_NEGATIVE_CLEARANCE_AUTHORITY"}
    end
    return {
        bounded=true,
        outcome="FIELD_WORLD_BOUNDED_LOCAL_CONTINUATION",
        reason="SETTLED_GIANTS_LOCAL_INTENT_WITH_FIELD_WORLD_BOUNDARY",
        intentClassification=intent.classification,
        intentEpoch=intent.intentEpoch,
        boundaryDistance=distance,
        boundarySource=boundarySource,
        startX=worker.pose.x,startZ=worker.pose.z,
        endX=worker.pose.x+worker.pose.dx*distance,
        endZ=worker.pose.z+worker.pose.dz*distance,
        headingX=worker.pose.dx,headingZ=worker.pose.dz,
        physicalPrimitiveCount=#discs,
        authority="POSITIVE_FUTURE_SPACE_SUPPORT_ONLY",
        negativeClearanceAuthority=false
    }
end

local function orientation(a,b,c)
    return (b.x-a.x)*(c.z-a.z)-(b.z-a.z)*(c.x-a.x)
end

local function onSegment(p,a,b)
    local epsilon=0.000001
    if math.abs(orientation(a,b,p))>epsilon then return false end
    return p.x>=math.min(a.x,b.x)-epsilon and p.x<=math.max(a.x,b.x)+epsilon and p.z>=math.min(a.z,b.z)-epsilon and p.z<=math.max(a.z,b.z)+epsilon
end

local function segmentsIntersect(a,b,c,d)
    local epsilon=0.000001
    local o1,o2=orientation(a,b,c),orientation(a,b,d)
    local o3,o4=orientation(c,d,a),orientation(c,d,b)
    if ((o1>epsilon and o2<-epsilon) or (o1<-epsilon and o2>epsilon)) and ((o3>epsilon and o4<-epsilon) or (o3<-epsilon and o4>epsilon)) then return true end
    return onSegment(c,a,b) or onSegment(d,a,b) or onSegment(a,c,d) or onSegment(b,c,d)
end

local function pointSegmentDistance(p,a,b)
    local dx,dz=b.x-a.x,b.z-a.z
    local lengthSquared=dx*dx+dz*dz
    if lengthSquared<=0.000000000001 then
        local px,pz=p.x-a.x,p.z-a.z
        return math.sqrt(px*px+pz*pz)
    end
    local t=((p.x-a.x)*dx+(p.z-a.z)*dz)/lengthSquared
    if t<0 then t=0 elseif t>1 then t=1 end
    local qx,qz=a.x+t*dx,a.z+t*dz
    local px,pz=p.x-qx,p.z-qz
    return math.sqrt(px*px+pz*pz)
end

local function segmentDistance(a,b,c,d)
    if segmentsIntersect(a,b,c,d) then return 0 end
    return math.min(pointSegmentDistance(a,c,d),pointSegmentDistance(b,c,d),pointSegmentDistance(c,a,b),pointSegmentDistance(d,a,b))
end

function Future.evaluatePair(subject,other,subjectFuture,otherFuture)
    subjectFuture=subjectFuture or Future.build(subject)
    otherFuture=otherFuture or Future.build(other)
    if subjectFuture.bounded~=true or otherFuture.bounded~=true then
        local reason
        if subjectFuture.intentClassification=="TURNING" or otherFuture.intentClassification=="TURNING" then reason="MANOEUVRING_FUTURE_SPACE_UNRESOLVED"
        else reason="BOUNDED_LOCAL_CONTINUATION_UNAVAILABLE" end
        return {positive=false,unresolved=true,outcome="FUTURE_SPACE_INTERACTION_UNRESOLVED",reason=reason,authority="NO_NEGATIVE_CLEARANCE_AUTHORITY",subject=subjectFuture,other=otherFuture}
    end

    local subjectDiscs=physicalDiscs(subject and subject.shadowRepresentation)
    local otherDiscs=physicalDiscs(other and other.shadowRepresentation)
    local best=nil
    for _,a in ipairs(subjectDiscs) do
        local a0={x=a.x,z=a.z}
        local a1={x=a.x+subjectFuture.headingX*subjectFuture.boundaryDistance,z=a.z+subjectFuture.headingZ*subjectFuture.boundaryDistance}
        for _,b in ipairs(otherDiscs) do
            local b0={x=b.x,z=b.z}
            local b1={x=b.x+otherFuture.headingX*otherFuture.boundaryDistance,z=b.z+otherFuture.headingZ*otherFuture.boundaryDistance}
            local distance=segmentDistance(a0,a1,b0,b1)
            local required=(a.radius or 0)+(b.radius or 0)
            if best==nil or distance<best.distance then
                best={distance=distance,required=required,subjectPrimitiveId=a.identity,otherPrimitiveId=b.identity}
            end
            if distance<=required then
                return {
                    positive=true,unresolved=false,outcome="FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION_POSITIVE",
                    authority="POSITIVE_FUTURE_SPACE_SUPPORT_ONLY",negativeClearanceAuthority=false,
                    distance=distance,required=required,subjectPrimitiveId=a.identity,otherPrimitiveId=b.identity,
                    subject=subjectFuture,other=otherFuture
                }
            end
        end
    end
    best=best or {distance=nil,required=nil}
    best.positive=false; best.unresolved=true; best.outcome="NO_POSITIVE_FUTURE_SPACE_INTERSECTION_OBSERVED"
    best.reason="NON_INTERSECTION_CANNOT_ESTABLISH_CLEARANCE"
    best.authority="NO_NEGATIVE_CLEARANCE_AUTHORITY"; best.negativeClearanceAuthority=false
    best.subject=subjectFuture; best.other=otherFuture
    return best
end
