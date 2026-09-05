-- Situation-owned prospective Forward Intersection knowledge. The represented
-- continuations end at Field World boundaries; no route is predicted beyond
-- that positive evidence.

OuttaMyWay.SpatialConstraintAssessment={}
local Assessment=OuttaMyWay.SpatialConstraintAssessment
Assessment.__index=Assessment
local EPSILON_M=0.00001

local function finite(v) return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge end
local function point(v)
    if type(v)~="table" then return nil end
    local x,z=tonumber(v.x or v[1]),tonumber(v.z or v[2] or v[3])
    if not finite(x) or not finite(z) then return nil end
    return {x=x,z=z}
end
local function distance(a,b) local x,z=a.x-b.x,a.z-b.z; return math.sqrt(x*x+z*z) end
local function pointSegmentDistance(p,a,b)
    local x,z=b.x-a.x,b.z-a.z; local squared=x*x+z*z
    if squared<=EPSILON_M*EPSILON_M then return distance(p,a) end
    local t=((p.x-a.x)*x+(p.z-a.z)*z)/squared
    if t<0 then t=0 elseif t>1 then t=1 end
    return distance(p,{x=a.x+t*x,z=a.z+t*z})
end
local function collectRings(world)
    local result={}; local boundary=world and world.boundary or {}
    if OuttaMyWay.ValueRecord.length(boundary)>=2 then result[#result+1]={kind="OUTER_BOUNDARY",index=1,points=boundary} end
    for index,island in OuttaMyWay.ValueRecord.ipairs(world and world.islands or {}) do
        if OuttaMyWay.ValueRecord.length(island)>=2 then result[#result+1]={kind="ISLAND_BOUNDARY",index=index,points=island} end
    end
    return result
end
local function vertexKey(ring,index) return string.format("%s:%d:VERTEX:%d",ring.kind,ring.index,index) end
local function edgeForContact(world,contact,source)
    local matches={}
    for _,ring in OuttaMyWay.ValueRecord.ipairs(collectRings(world)) do
        local sourceMatches=(source=="FIELD_WORLD_OUTER_BOUNDARY" and ring.kind=="OUTER_BOUNDARY") or (source=="FIELD_WORLD_ISLAND_BOUNDARY" and ring.kind=="ISLAND_BOUNDARY")
        if sourceMatches then
            local count=OuttaMyWay.ValueRecord.length(ring.points)
            for index=1,count do
                local nextIndex=(index%count)+1; local a,b=point(ring.points[index]),point(ring.points[nextIndex])
                if a and b and pointSegmentDistance(contact,a,b)<=EPSILON_M then
                    matches[#matches+1]={ringKind=ring.kind,ringIndex=ring.index,edgeIndex=index,edgeKey=string.format("%s:%d:EDGE:%d",ring.kind,ring.index,index),
                        startVertex={identity=vertexKey(ring,index),index=index,x=a.x,z=a.z},endVertex={identity=vertexKey(ring,nextIndex),index=nextIndex,x=b.x,z=b.z}}
                end
            end
        end
    end
    if OuttaMyWay.ValueRecord.length(matches)==1 then return matches[1] end
    return nil,OuttaMyWay.ValueRecord.length(matches)==0 and "TERMINATING_BOUNDARY_EDGE_UNRESOLVED" or "TERMINATING_BOUNDARY_EDGE_AMBIGUOUS_AT_VERTEX"
end
local function byAssembly(values)
    local result={}; for _,v in OuttaMyWay.ValueRecord.ipairs(values or {}) do result[v.assemblyId]=v end; return result
end
local function continuation(future)
    for _,v in OuttaMyWay.ValueRecord.ipairs(future and future.alternatives or {}) do if v.kind=="FIELD_WORLD_BOUNDED_LOCAL_CONTINUATION" then return v end end
end
local function positiveRate(motion)
    if motion and finite(motion.positionDerivedSpeedMps) and motion.positionDerivedSpeedMps>0 then return motion.positionDerivedSpeedMps,"POSITION_DERIVED_PROGRESS_RATE" end
    if motion and finite(motion.reportedSpeedMps) and motion.reportedSpeedMps>0 then return motion.reportedSpeedMps,"GIANTS_REPORTED_PROGRESS_RATE" end
    return nil,"POSITIVE_PROGRESS_RATE_UNAVAILABLE"
end
local function projection(world,worldKey,id,future,motion)
    local path=continuation(future); local width=motion and motion.nativeFieldWork and motion.nativeFieldWork.workingWidth
    local result={assemblyId=id,assemblyReferenceKey=motion and motion.assemblyReferenceKey,fieldWorldReferenceKey=worldKey,
        fieldWorldSnapshotReferenceKey=world and world.representativeSnapshotReferenceKey,futureSpaceIdentity=future and future.identity,
        futureSpaceBasis=path and path.kind,status="UNRESOLVED",decisionAuthority=false,controlAuthority=false,positiveOnly=true,
        authority="SITUATION_KNOWLEDGE_ONLY",provenance={source="SpatialConstraintAssessment",layer="SITUATION_ASSESSMENT"}}
    if not path then result.reason="FIELD_BOUNDED_PROJECTION_UNAVAILABLE"; return result end
    local x,z,ex,ez=tonumber(path.startX),tonumber(path.startZ),tonumber(path.endX),tonumber(path.endZ)
    local hx,hz,boundaryDistance=tonumber(path.headingX),tonumber(path.headingZ),tonumber(path.boundaryDistance)
    if not finite(x) or not finite(z) or not finite(ex) or not finite(ez) or not finite(hx) or not finite(hz) or not finite(boundaryDistance) then result.reason="FIELD_BOUNDED_PROJECTION_INVALID"; return result end
    local length=math.sqrt(hx*hx+hz*hz); if length<=EPSILON_M then result.reason="PROJECTED_HEADING_INVALID"; return result end
    local edge,reason=edgeForContact(world,{x=ex,z=ez},path.boundarySource); if not edge then result.reason=reason; return result end
    result.currentX=x; result.currentZ=z; result.headingX=hx/length; result.headingZ=hz/length
    result.contactX=ex; result.contactZ=ez; result.boundaryDistanceM=boundaryDistance; result.boundarySource=path.boundarySource
    result.boundaryRingKind=edge.ringKind; result.boundaryRingIndex=edge.ringIndex; result.terminatingBoundaryEdge=edge
    result.incidentVertices={edge.startVertex,edge.endVertex}
    result.workingWidthM=width and tonumber(width.widthMetres); result.workingWidthSource=width and width.source or "UNAVAILABLE"
    result.workingWidthAuthority=width and width.authority or "PROVISIONAL_DEMAND_SEED_INPUT_ONLY"
    if width and width.available==true and finite(result.workingWidthM) and result.workingWidthM>0 then result.provisionalHalfWidthM=result.workingWidthM/2 end
    result.progressRateMps,result.progressRateSource=positiveRate(motion)
    if result.progressRateMps then result.provisionalTimeToBoundarySec=boundaryDistance/result.progressRateMps end
    result.status="SUPPORTED"; result.reason="FIELD_BOUNDARY_TRANSITION_PROJECTION_SUPPORTED"; return result
end
local function sharedVertex(a,b)
    if a.terminatingBoundaryEdge.edgeKey==b.terminatingBoundaryEdge.edgeKey then return nil end
    for _,av in OuttaMyWay.ValueRecord.ipairs(a.incidentVertices or {}) do
        for _,bv in OuttaMyWay.ValueRecord.ipairs(b.incidentVertices or {}) do if av.identity==bv.identity then return av end end
    end
end
local function intersect(a,b)
    local rx,rz,sx,sz=a.headingX,a.headingZ,b.headingX,b.headingZ
    local qx,qz=b.currentX-a.currentX,b.currentZ-a.currentZ; local denominator=rx*sz-rz*sx
    if math.abs(denominator)<=EPSILON_M then return nil,"FORWARD_CONTINUATIONS_PARALLEL_OR_COLLINEAR" end
    local ad=(qx*sz-qz*sx)/denominator; local bd=(qx*rz-qz*rx)/denominator
    if ad<-EPSILON_M or bd<-EPSILON_M then return nil,"INTERSECTION_NOT_FORWARD_OF_BOTH_PARTICIPANTS" end
    if ad>a.boundaryDistanceM+EPSILON_M or bd>b.boundaryDistanceM+EPSILON_M then return nil,"INTERSECTION_OUTSIDE_SUPPORTED_FORWARD_EXTENT" end
    ad=math.max(0,ad); bd=math.max(0,bd)
    return {x=a.currentX+ad*rx,z=a.currentZ+ad*rz,subjectForwardDistanceM=ad,otherForwardDistanceM=bd}
end
local function incumbent(a,b,knowledge)
    for _,r in OuttaMyWay.ValueRecord.ipairs(knowledge or {}) do
        local same=(r.leaderAssemblyId==a.assemblyId and r.followerAssemblyId==b.assemblyId) or (r.leaderAssemblyId==b.assemblyId and r.followerAssemblyId==a.assemblyId)
        if same and (r.status=="REGULATE_SUPPORTED" or (type(r.existingCommitmentId)=="string" and r.status~="RETIRE_SUPPORTED")) then
            return {kind="FOLLOWER_BOUNDARY",pairKey=r.pairKey,commitmentId=r.existingCommitmentId,status=r.status,reason="ESTABLISHED_RELATIONSHIP_PRECEDENCE"}
        end
    end
end
local function overlay(a,b,x)
    local vertex=sharedVertex(a,b); if vertex then return "CATEGORY_1_CORNER",vertex end
    if math.abs(x.subjectForwardDistanceM-a.boundaryDistanceM)<=EPSILON_M or math.abs(x.otherForwardDistanceM-b.boundaryDistanceM)<=EPSILON_M then return "CATEGORY_2_HEADLAND_BOUNDARY" end
    return "OPEN_FIELD"
end
local function pairRecord(operationId,a,b,followerKnowledge)
    local r={identity="forward-intersection:"..tostring(operationId)..":"..tostring(a.assemblyId)..":"..tostring(b.assemblyId),operationId=operationId,
        subjectAssemblyId=a.assemblyId,otherAssemblyId=b.assemblyId,subjectReferenceKey=a.assemblyReferenceKey,otherReferenceKey=b.assemblyReferenceKey,
        subjectProjection=a,otherProjection=b,classification="UNRESOLVED",relationshipStatus="UNRESOLVED",decisionAuthority=false,controlAuthority=false,
        positiveOnly=true,provenance={source="SpatialConstraintAssessment",layer="SITUATION_ASSESSMENT",hypothesis="FORWARD_INTERSECTION"}}
    if a.status~="SUPPORTED" or b.status~="SUPPORTED" then r.reason="FORWARD_CONTINUATION_UNRESOLVED"; return r end
    local x,reason=intersect(a,b)
    if not x then r.classification="NO_FORWARD_INTERSECTION"; r.relationshipStatus="NEGATIVE"; r.reason=reason; return r end
    r.intersection=x; r.subjectForwardDistanceToIntersectionM=x.subjectForwardDistanceM; r.otherForwardDistanceToIntersectionM=x.otherForwardDistanceM
    r.subjectProgressRateMps=a.progressRateMps; r.otherProgressRateMps=b.progressRateMps
    r.subjectProgressRateSource=a.progressRateSource; r.otherProgressRateSource=b.progressRateSource
    r.spatialOverlay,r.sharedVertex=overlay(a,b,x); r.classification="FORWARD_INTERSECTION"; r.relationshipStatus="POSITIVE"
    r.incumbentRelationship=incumbent(a,b,followerKnowledge)
    if r.incumbentRelationship then r.actionable=false; r.reason="FORWARD_INTERSECTION_SUPPRESSED_BY_ESTABLISHED_RELATIONSHIP_PRECEDENCE"; return r end
    
    if not a.progressRateMps or not b.progressRateMps then r.temporalAllocationStatus="UNRESOLVED"; r.actionable=false; r.reason="POSITIVE_FORWARD_INTERSECTION_WITH_TIMING_UNRESOLVED"; return r end
    r.subjectTimeToIntersectionSec=x.subjectForwardDistanceM/a.progressRateMps; r.otherTimeToIntersectionSec=x.otherForwardDistanceM/b.progressRateMps
    if r.subjectTimeToIntersectionSec==r.otherTimeToIntersectionSec then r.temporalAllocationStatus="UNRESOLVED"; r.actionable=false; r.reason="EQUAL_TIME_TO_INTERSECTION_HAS_NO_AUTHORISED_TIE_BREAK"; return r end
    local subjectYields=r.subjectTimeToIntersectionSec>r.otherTimeToIntersectionSec
    r.temporalAllocationStatus="SUPPORTED"; r.actionable=true
    r.temporalYielderAssemblyId=subjectYields and a.assemblyId or b.assemblyId; r.temporalYielderReferenceKey=subjectYields and a.assemblyReferenceKey or b.assemblyReferenceKey
    r.continuingAssemblyId=subjectYields and b.assemblyId or a.assemblyId; r.continuingReferenceKey=subjectYields and b.assemblyReferenceKey or a.assemblyReferenceKey
    r.regulationSpeedKmh=OuttaMyWay.FORWARD_INTERSECTION_REGULATION_SPEED_KMH or 1
    r.actionSpaceConservation={status="REGULATE_SUPPORTED",supported=true,admissionKind="FORWARD_INTERSECTION",
        regulatedAssemblyId=r.temporalYielderAssemblyId,regulatedReferenceKey=r.temporalYielderReferenceKey,
        protectedAssemblyId=r.continuingAssemblyId,protectedReferenceKey=r.continuingReferenceKey,
        governingPurpose="MAXIMISE_FORWARD_INTERSECTION_INTENT_REVELATION_TIME",separationM=x.subjectForwardDistanceM+x.otherForwardDistanceM,
        nativeUnrestrictedKmh=r.regulationSpeedKmh,nativeClosureContributionKmh=0,nativeSignedClosureContributionKmh=0,nativeMoveForwards=true,
        fixedRegulationSpeedKmh=r.regulationSpeedKmh,reason="GREATER_TIME_TO_FORWARD_INTERSECTION_YIELDS_FOR_INTENT_REVELATION"}
    r.reason=r.actionSpaceConservation.reason; return r
end
local function numberText(v) return v==nil and "UNRESOLVED" or string.format("%.3f",v) end
local function logInfo(message)
    if Logging and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][FORWARD-INTERSECTION] %s",message) else print("[FS25_OuttaMyWay][FORWARD-INTERSECTION] "..message) end
end
function Assessment.new() return setmetatable({lastSignatures={}},Assessment) end
function Assessment:reset() self.lastSignatures={} end
function Assessment:assess(input)
    local futures,motions=byAssembly(input.futureSpace),byAssembly(input.motionEvidence); local projections={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(input.assemblyIds or {}) do projections[#projections+1]=projection(input.fieldWorld,input.fieldWorldReferenceKey,id,futures[id],motions[id]) end
    table.sort(projections,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
    local relationships={}
    for i=1,OuttaMyWay.ValueRecord.length(projections)-1 do for j=i+1,OuttaMyWay.ValueRecord.length(projections) do
        local r=pairRecord(input.operationId,projections[i],projections[j],input.followerBoundaryKnowledge); relationships[#relationships+1]=r
        local signature=table.concat({r.classification,r.reason,tostring(r.temporalYielderAssemblyId),tostring(r.spatialOverlay)},"|")
        if self.lastSignatures[r.identity]~=signature then self.lastSignatures[r.identity]=signature; local x=r.intersection or {}
            logInfo(string.format("FORWARD_INTERSECTION_ASSESSED relationship=%s pair=%s|%s state=%s intersection=(%s,%s) distances=%s|%s rates=%s|%s rateSources=%s|%s times=%s|%s yielder=%s continuing=%s overlay=%s regulation=%s incumbent=%s reason=%s",
                r.identity,tostring(r.subjectAssemblyId),tostring(r.otherAssemblyId),r.relationshipStatus,numberText(x.x),numberText(x.z),numberText(r.subjectForwardDistanceToIntersectionM),numberText(r.otherForwardDistanceToIntersectionM),
                numberText(r.subjectProgressRateMps),numberText(r.otherProgressRateMps),tostring(r.subjectProgressRateSource),tostring(r.otherProgressRateSource),numberText(r.subjectTimeToIntersectionSec),numberText(r.otherTimeToIntersectionSec),
                tostring(r.temporalYielderAssemblyId or "UNRESOLVED"),tostring(r.continuingAssemblyId or "UNRESOLVED"),tostring(r.spatialOverlay or "UNRESOLVED"),numberText(r.regulationSpeedKmh),tostring(r.incumbentRelationship and r.incumbentRelationship.kind or "none"),tostring(r.reason))) end
    end end
    return {operationId=input.operationId,boundaryTransitionProjections=projections,pairRelationships=relationships,decisionAuthority=false,controlAuthority=false,
        provenance={source="SpatialConstraintAssessment",layer="SITUATION_ASSESSMENT",forwardIntersection=true}}
end
