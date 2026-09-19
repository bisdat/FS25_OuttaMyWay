--- Interprets current space evidence into bounded Spatial Constraint and Resolution-Margin Situation knowledge.
-- Specification Jurisdictions: `SITUATION_ASSESSMENT`

-- Situation-owned prospective Forward Intersection knowledge. The represented
-- continuations end at Field World boundaries; no route is predicted beyond
-- that positive evidence.

OuttaMyWay.SpatialConstraintAssessment={}
local Assessment=OuttaMyWay.SpatialConstraintAssessment
Assessment.__index=Assessment
local EPSILON_M=0.00001
local FORWARD_INTERSECTION_INTENT_REVELATION_CREEP_KMH = 1
local CORNER_INTENT_REVELATION_CREEP_KMH = 1

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
    r.regulationSpeedKmh=FORWARD_INTERSECTION_INTENT_REVELATION_CREEP_KMH
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
local function copyKnowledge(value)
    if type(value)~="table" then return value end
    local result={}
    for key,item in OuttaMyWay.ValueRecord.pairs(value) do result[key]=copyKnowledge(item) end
    return result
end

-- Atlas Persistence Cannot Outlive Its Identity Evidence. The existing exact
-- polygon identity is below Operation/equivalence-class lifecycle identity.
-- An equivalent world with different fingerprints supplies no transfer proof.
local function atlasPolygonKey(world)
    if not world or not finite(world.quantizationMetres) or world.quantizationMetres<=0
        or type(world.canonicalizationVersion)~="string" or type(world.geometryFingerprint)~="string" then return nil end
    local expected="field-world-polygon:"..world.canonicalizationVersion..":"..world.geometryFingerprint
    if world.fieldPolygonReferenceKey==expected then return expected end
end

local function spatialPointKey(vertex,quantumM)
    -- Same symmetric nearest-quantum rounding as FieldWorldSnapshotRegistry.
    local function quantize(value)
        local result=value>=0 and math.floor(value/quantumM+0.5) or math.ceil(value/quantumM-0.5)
        return result==0 and 0 or result
    end
    return string.format("%.0f,%.0f",quantize(vertex.x),quantize(vertex.z))
end

local function spatialEdgeKey(edge,quantumM)
    local a,b=spatialPointKey(edge.startVertex,quantumM),spatialPointKey(edge.endVertex,quantumM)
    if b<a then a,b=b,a end
    return a.."/"..b
end

local function cornerEvent(events,kind,entry,details)
    local event=copyKnowledge(details or {})
    event.kind=kind; event.cornerKey=entry.cornerKey; event.polygonKey=entry.polygonKey
    events[#events+1]=event
    local message=string.format("%s polygon=%s corner=%s worker=%s job=%s observation=%s edge=%s extentM=%s cornerAlongAxisM=%s reason=%s",
        kind,entry.polygonKey,entry.cornerKey,tostring(event.assemblyId or "none"),tostring(event.sourceJobToken or "none"),
        tostring(event.observationSnapshotId),tostring(event.edgeKey or "none"),numberText(event.extentM),numberText(event.cornerAlongAxisM),tostring(event.reason or "none"))
    if Logging and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][CORNER-KNOWLEDGE] %s",message)
    else print("[FS25_OuttaMyWay][CORNER-KNOWLEDGE] "..message) end
end

-- Cross-corridor dimensions are a measurement hypothesis, retaining the raw
-- width's provisional demand claim. They are neither physical clearance nor a
-- predicted GIANTS turn path. Only positive larger witnesses change an extent.
local function learnCorner(atlas,relation,input,events)
    local quantumM=input.fieldWorld.quantizationMetres
    local a,b=relation.subjectProjection,relation.otherProjection
    local vertex=relation.sharedVertex
    local aKey,bKey=spatialEdgeKey(a.terminatingBoundaryEdge,quantumM),spatialEdgeKey(b.terminatingBoundaryEdge,quantumM)
    local first,second=aKey,bKey
    if second<first then first,second=second,first end
    local key=atlas.polygonKey.."|"..spatialPointKey(vertex,quantumM).."|"..first.."|"..second
    local entry=atlas.corners[key]
    if not entry then
        entry={cornerKey=key,polygonKey=atlas.polygonKey,vertex={x=vertex.x,z=vertex.z},incidentEdges={},
            discoveryProvenance={observationSnapshotId=input.observationSnapshotId,
                source="POSITIVE_CATEGORY_1_SHARED_VERTEX_TOPOLOGY",snapshotReferenceKey=input.fieldWorld.representativeSnapshotReferenceKey},
            envelope={hypothesis="CROSS_CORRIDOR_WORKING_WIDTH",authority="PROVISIONAL_DEMAND_SEED_INPUT_ONLY",
                representation="INCIDENT_EDGE_COORDINATE_INTERVALS",
                containment="INTERSECTION_WITH_FIELD_WORLD",negativeClearanceAuthority=false},enlargementProvenance={}}
        for _,p in OuttaMyWay.ValueRecord.ipairs({a,b}) do
            local edge=p.terminatingBoundaryEdge
            local other=spatialPointKey(edge.startVertex,quantumM)==spatialPointKey(vertex,quantumM) and edge.endVertex or edge.startVertex
            local lengthM=distance(vertex,other)
            if lengthM<=EPSILON_M then return end
            entry.incidentEdges[#entry.incidentEdges+1]={edgeKey=spatialEdgeKey(edge,quantumM),
                directionX=(other.x-vertex.x)/lengthM,directionZ=(other.z-vertex.z)/lengthM,
                startVertex={x=vertex.x,z=vertex.z},endVertex={x=other.x,z=other.z},extentState="UNRESOLVED"}
        end
        table.sort(entry.incidentEdges,function(left,right) return left.edgeKey<right.edgeKey end)
        atlas.corners[key]=entry
        cornerEvent(events,"CORNER_ATLAS_DISCOVERED",entry,{observationSnapshotId=input.observationSnapshotId})
    end
    for _,witness in OuttaMyWay.ValueRecord.ipairs({{edgeKey=aKey,corridor=b},{edgeKey=bKey,corridor=a}}) do
        local corridor=witness.corridor
        if corridor.provisionalHalfWidthM~=nil then
            for _,edge in OuttaMyWay.ValueRecord.ipairs(entry.incidentEdges) do
                if edge.edgeKey==witness.edgeKey and (edge.extentM==nil or corridor.workingWidthM>edge.extentM) then
                    local motion=byAssembly(input.motionEvidence)[corridor.assemblyId]
                    local provenance={edgeKey=edge.edgeKey,previousExtentM=edge.extentM,extentM=corridor.workingWidthM,
                        assemblyId=corridor.assemblyId,source=corridor.workingWidthSource,authority=corridor.workingWidthAuthority,
                        sourceJobToken=motion and motion.sourceJobToken,
                        observationSnapshotId=input.observationSnapshotId,futureSpaceIdentity=corridor.futureSpaceIdentity}
                    edge.extentM=corridor.workingWidthM; edge.extentState="POSITIVELY_LEARNED"
                    entry.enlargementProvenance[#entry.enlargementProvenance+1]=provenance
                    cornerEvent(events,"CORNER_ENVELOPE_ENLARGED",entry,provenance)
                end
            end
        end
    end
end

local function envelopeVertices(entry)
    local a,b=entry.incidentEdges[1],entry.incidentEdges[2]
    if not a.extentM or not b.extentM then return nil end
    local determinant=a.directionX*b.directionZ-a.directionZ*b.directionX
    if math.abs(determinant)<=EPSILON_M then return nil end
    local v=entry.vertex
    local av={x=v.x+a.directionX*a.extentM,z=v.z+a.directionZ*a.extentM}
    local bv={x=v.x+b.directionX*b.extentM,z=v.z+b.directionZ*b.extentM}
    return {v,av,{x=av.x+bv.x-v.x,z=av.z+bv.z-v.z},bv}
end

local function inEnvelope(p,entry)
    local a,b=entry.incidentEdges[1],entry.incidentEdges[2]
    local x,z=p.x-entry.vertex.x,p.z-entry.vertex.z
    local determinant=a.directionX*b.directionZ-a.directionZ*b.directionX
    local alongA=(x*b.directionZ-z*b.directionX)/determinant
    local alongB=(a.directionX*z-a.directionZ*x)/determinant
    return alongA>=0 and alongA<=a.extentM and alongB>=0 and alongB<=b.extentM
end

local function nearestOnSegment(p,a,b)
    local x,z=b.x-a.x,b.z-a.z
    local squared=x*x+z*z
    local t=squared>EPSILON_M*EPSILON_M and math.max(0,math.min(1,((p.x-a.x)*x+(p.z-a.z)*z)/squared)) or 0
    return {x=a.x+t*x,z=a.z+t*z}
end

local function segmentIntersection(a,b,c,d)
    local x,z,sx,sz=b.x-a.x,b.z-a.z,d.x-c.x,d.z-c.z
    local determinant=x*sz-z*sx
    if math.abs(determinant)<=EPSILON_M then return nil end
    local qx,qz=c.x-a.x,c.z-a.z
    local t,u=(qx*sz-qz*sx)/determinant,(qx*z-qz*x)/determinant
    if t>=0 and t<=1 and u>=0 and u<=1 then return {x=a.x+t*x,z=a.z+t*z} end
end

-- Positive Overlap Establishes Occupancy; Missing Overlap Does Not Establish
-- Departure. Find a concrete point common to a positive current DISC, the
-- edge-coordinate envelope and Field World. Boundary candidates also handle
-- envelopes clipped by concavities/islands; no whole-assembly clearance follows.
local function overlapWitness(entry,physical,world)
    local vertices=envelopeVertices(entry)
    if not vertices then return nil end
    for _,disc in OuttaMyWay.ValueRecord.ipairs(physical and physical.primitives or {}) do
        if disc.kind=="DISC" and disc.positiveConflictSupport==true and finite(disc.x) and finite(disc.z)
            and finite(disc.radius) and disc.radius>=0 then
            local centre={x=disc.x,z=disc.z}
            local function witness(p)
                if p and distance(p,centre)<=disc.radius and inEnvelope(p,entry) then
                    local containment=OuttaMyWay.FieldWorldSnapshotRegistry.evaluatePositionContainment(world,p.x,p.z)
                    if containment.resolved and containment.inside then return {primitiveId=disc.identity,x=p.x,z=p.z,
                        source="POSITIVE_CURRENT_ASSEMBLY_ENVELOPE_OVERLAP",negativeClearanceAuthority=false} end
                end
            end
            local found=witness(centre)
            if found then return found end
            local hasEnvelopeOverlap=inEnvelope(centre,entry)
            for i=1,4 do
                local a,b=vertices[i],vertices[i%4+1]
                local nearest=nearestOnSegment(centre,a,b)
                hasEnvelopeOverlap=hasEnvelopeOverlap or distance(centre,nearest)<=disc.radius
                found=witness(a) or witness(nearest)
                if found then return found end
            end
            -- Most workers are outside this small envelope. Only an intersecting
            -- disc needs the more expensive Field World clipping witnesses.
            if hasEnvelopeOverlap then for _,ring in OuttaMyWay.ValueRecord.ipairs(collectRings(world)) do
                local count=OuttaMyWay.ValueRecord.length(ring.points)
                for i=1,count do
                    local a,b=point(ring.points[i]),point(ring.points[i%count+1])
                    if a and b then
                        found=witness(a) or witness(nearestOnSegment(centre,a,b))
                        if found then return found end
                        for j=1,4 do
                            found=witness(segmentIntersection(a,b,vertices[j],vertices[j%4+1]))
                            if found then return found end
                        end
                    end
                end
            end end
        end
    end
end

-- A current A8-bounded centre axis is a narrow positive demand witness. Its
-- intersection with the Field-World-clipped envelope suffices; missing it says
-- nothing about safety or wider demand. No width inflation or turn prediction.
local function cornerDemandWitness(entry,p,motion,productive,path,input)
    if not motion or not productive or not path or p.status~="SUPPORTED"
        or motion.assemblyReferenceKey==nil or motion.sourceJobToken==nil or productive.jobToken~=motion.sourceJobToken
        or productive.productivePositive~=true or productive.isTurn==true
        or motion.localIntentClassification=="TURNING"
        or (path.intentEpoch~=nil and motion.intentEpoch~=nil and path.intentEpoch~=motion.intentEpoch) then return nil end
    local vertices=envelopeVertices(entry)
    if not vertices then return nil end
    local a,b={x=p.currentX,z=p.currentZ},{x=p.contactX,z=p.contactZ}
    local function witness(pointValue)
        if pointValue and inEnvelope(pointValue,entry) then
            local containment=OuttaMyWay.FieldWorldSnapshotRegistry.evaluatePositionContainment(input.fieldWorld,pointValue.x,pointValue.z)
            if containment.resolved and containment.inside then
                return {assemblyId=p.assemblyId,assemblyReferenceKey=motion.assemblyReferenceKey,
                    sourceJobToken=motion.sourceJobToken,futureSpaceIdentity=p.futureSpaceIdentity,
                    observationSnapshotId=input.observationSnapshotId,x=pointValue.x,z=pointValue.z,
                    source="CURRENT_A8_BOUNDED_AXIS_INTERSECTS_CORNER",negativeClearanceAuthority=false}
            end
        end
    end
    local found=witness(a) or witness(b)
    if found then return found end
    for i=1,4 do
        found=witness(segmentIntersection(a,b,vertices[i],vertices[i%4+1]))
        if found then return found end
    end
end

-- Fresh authoritative A8 is only the gate. Both independent topological
-- witnesses must hold on its current bounded axis; FI and overlap are absent
-- from this discharge predicate. EPSILON_M is the existing spatial tolerance.
local function departureEvidence(entry,p,productive,motion,input,engagement)
    if not engagement.hasObservedManoeuvring then return false,"MANOEUVRING_NOT_OBSERVED",false end
    if motion.localIntentClassification=="TURNING" or (productive and productive.isTurn==true) then
        return false,"CURRENT_MANOEUVRING_UNCERTAINTY",false
    end
    if not productive or productive.jobToken~=engagement.sourceJobToken or productive.productivePositive~=true
        or input.observationSnapshotId==nil or input.observationSnapshotId==engagement.manoeuvringObservationSnapshotId
        or not finite(input.observationEpoch) or not finite(engagement.manoeuvringObservationEpoch)
        or input.observationEpoch<=engagement.manoeuvringObservationEpoch then
        return false,"FRESH_A8_NOT_REACQUIRED",false
    end
    if p.status~="SUPPORTED" then return false,"BOUNDED_TOPOLOGY_UNRESOLVED",true end
    local path=continuation(byAssembly(input.futureSpace)[p.assemblyId])
    if path.intentEpoch~=nil and motion.intentEpoch~=nil and path.intentEpoch~=motion.intentEpoch then
        return false,"CONTINUATION_INTENT_PROVENANCE_MISMATCH",true
    end
    local edgeKey=spatialEdgeKey(p.terminatingBoundaryEdge,input.fieldWorld.quantizationMetres)
    local alongM=(entry.vertex.x-p.currentX)*p.headingX+(entry.vertex.z-p.currentZ)*p.headingZ
    for _,edge in OuttaMyWay.ValueRecord.ipairs(entry.incidentEdges) do
        if edge.edgeKey==edgeKey then return false,"CONTINUATION_TERMINATES_ON_INCIDENT_EDGE",true,alongM,edgeKey end
    end
    if alongM>=-EPSILON_M then return false,"CORNER_NOT_POSITIVELY_BEHIND_AXIS",true,alongM,edgeKey end
    return true,"CORNER_BEHIND_AXIS_AND_NON_INCIDENT_TERMINATION",true,alongM,edgeKey
end

-- Atlas knowledge belongs to this Situation Assessment instance and is cleared
-- by map reset, never by pair/Responsibility/Operation turnover. Worker state
-- additionally remains bounded by current membership and source Job Episode.
-- A departure record is the last dated positive event for that worker/job,
-- not a claim of perpetual clearance; new positive engagement replaces it.
-- Publications are detached values. Corner knowledge has no Candidate,
-- Decision, Responsibility, Bounded Authority or Control authority.
local function closestPointParameter(pointValue,a,b)
    local dx,dz=b.x-a.x,b.z-a.z
    local squared=dx*dx+dz*dz
    if squared<=EPSILON_M*EPSILON_M then return 0,distance(pointValue,a) end
    local t=((pointValue.x-a.x)*dx+(pointValue.z-a.z)*dz)/squared
    if t<0 then t=0 elseif t>1 then t=1 end
    local nearest={x=a.x+t*dx,z=a.z+t*dz}
    return t,distance(pointValue,nearest)
end

local function currentPhysicalReachEvidence(physical,p)
    local origin={x=p.currentX,z=p.currentZ}
    local best=nil
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical and physical.primitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(primitive.x) and finite(primitive.z) and finite(primitive.radius) and primitive.radius>=0 then
            local centreDistanceM=distance(origin,{x=primitive.x,z=primitive.z})
            local reachM=centreDistanceM+primitive.radius
            if best==nil or reachM>best.reachM+EPSILON_M then
                best={
                    primitiveId=primitive.identity,
                    primitiveRadiusM=primitive.radius,
                    centreDistanceFromA8M=centreDistanceM,
                    reachM=reachM
                }
            end
        end
    end
    return best
end

-- Corner Approach Demand is unilateral.  It is established only when the
-- current productive A8 bounded continuation positively carries the assembly's
-- current physical demand into a positively interpreted structural Corner
-- Feature.  The Field World boundary contact must itself already lie within the
-- assembly-specific current physical reach; an arbitrarily distant A8-to-boundary
-- continuation is topology, not current Corner demand.  Within that local demand
-- horizon, direct translated primitive contact remains the strongest witness.
-- Where that misses the feature's representative point, the local boundary
-- contact may still establish demand when the feature lies inside the same
-- assembly-specific physical reach.  No predicted GIANTS turn route, universal
-- distance literal, working-width substitution or elapsed-time gate is created.
local function cornerApproachDemand(feature,p,motion,productive,path,physical,input)
    if type(feature)~="table" or type(feature.representativePoint)~="table"
        or not motion or not productive or not path or p.status~="SUPPORTED"
        or motion.assemblyReferenceKey==nil or motion.sourceJobToken==nil
        or productive.jobToken~=motion.sourceJobToken
        or productive.productivePositive~=true or productive.isTurn==true
        or motion.localIntentClassification=="TURNING"
        or (path.intentEpoch~=nil and motion.intentEpoch~=nil and path.intentEpoch~=motion.intentEpoch)
        or type(physical)~="table" then return nil end
    if feature.ringKind~=p.boundaryRingKind or tonumber(feature.ringIndex)~=tonumber(p.boundaryRingIndex) then return nil end

    local representative=feature.representativePoint
    local along=(representative.x-p.currentX)*p.headingX+(representative.z-p.currentZ)*p.headingZ
    if along<-EPSILON_M then return nil end

    local physicalReach=currentPhysicalReachEvidence(physical,p)
    if physicalReach==nil or not finite(p.boundaryDistanceM)
        or p.boundaryDistanceM>physicalReach.reachM+EPSILON_M then
        return nil
    end

    local deltaX,deltaZ=p.contactX-p.currentX,p.contactZ-p.currentZ
    local translatedIntersection=nil
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical.primitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(primitive.x) and finite(primitive.z) and finite(primitive.radius) and primitive.radius>=0 then
            local startValue={x=primitive.x,z=primitive.z}
            local endValue={x=primitive.x+deltaX,z=primitive.z+deltaZ}
            local parameter,sweepDistance=closestPointParameter(representative,startValue,endValue)
            if sweepDistance<=primitive.radius+EPSILON_M
                and (translatedIntersection==nil or sweepDistance<translatedIntersection.sweepDistanceM) then
                translatedIntersection={
                    primitiveId=primitive.identity,primitiveRadiusM=primitive.radius,
                    sweepDistanceM=sweepDistance,closestSweepParameter=parameter,
                    sweepStart=startValue,sweepEnd=endValue
                }
            end
        end
    end

    local contactDistanceToFeatureM=distance(representative,{x=p.contactX,z=p.contactZ})
    local reachSupported=contactDistanceToFeatureM<=physicalReach.reachM+EPSILON_M
    if translatedIntersection==nil and not reachSupported then return nil end

    local witness=translatedIntersection~=nil
        and "CURRENT_PRODUCTIVE_A8_SWEEP_OF_POSITIVE_PHYSICAL_PRIMITIVE_INTERSECTS_STRUCTURAL_CORNER_FEATURE"
        or "CURRENT_PRODUCTIVE_A8_BOUNDARY_CONTACT_WITHIN_CURRENT_PHYSICAL_REACH_OF_STRUCTURAL_CORNER_FEATURE"

    return {
        cornerKey=feature.cornerKey,fieldWorldReferenceKey=input.fieldWorldReferenceKey,
        assemblyId=p.assemblyId,assemblyReferenceKey=motion.assemblyReferenceKey,sourceJobToken=motion.sourceJobToken,
        observationSnapshotId=input.observationSnapshotId,observationEpoch=input.observationEpoch,
        futureSpaceIdentity=p.futureSpaceIdentity,
        approachDistanceM=math.max(0,along),
        physicalSweepEvidence=translatedIntersection,
        physicalDemandEvidence={
            mode=translatedIntersection~=nil and "TRANSLATED_POSITIVE_PHYSICAL_PRIMITIVE_INTERSECTION"
                or "BOUNDARY_CONTACT_WITHIN_CURRENT_PHYSICAL_REACH",
            boundaryContact={x=p.contactX,z=p.contactZ},
            boundaryDistanceM=p.boundaryDistanceM,
            contactDistanceToFeatureM=contactDistanceToFeatureM,
            currentPhysicalReach=physicalReach,
            localDemandHorizonM=physicalReach.reachM
        },
        witness=witness,
        negativeClearanceAuthority=false,
        provenance={source="SpatialConstraintAssessment",layer="SITUATION_ASSESSMENT"}
    }
end

local function featureEntry(feature,input)
    local entry=copyKnowledge(feature)
    entry.polygonKey=input.fieldWorldReferenceKey
    entry.vertex={x=feature.representativePoint.x,z=feature.representativePoint.z}
    entry.discoveryProvenance={
        observationSnapshotId=input.observationSnapshotId,
        source="POSITIVE_STRUCTURAL_FIELD_SHAPE",
        fieldWorldReferenceKey=input.fieldWorldReferenceKey,
        snapshotReferenceKey=input.fieldWorld and input.fieldWorld.representativeSnapshotReferenceKey
    }
    return entry
end

local function positiveProductiveA8(productive,motion,engagement,input)
    return productive~=nil and motion~=nil
        and productive.jobToken==engagement.sourceJobToken
        and productive.productivePositive==true and productive.isTurn~=true
        and motion.localIntentClassification~="TURNING"
        and finite(input.observationEpoch)
end

local function featureBehindCurrentA8(feature,p)
    if p.status~="SUPPORTED" then return false,nil end
    local representative=feature.representativePoint
    local along=(representative.x-p.currentX)*p.headingX+(representative.z-p.currentZ)*p.headingZ
    return along<-EPSILON_M,along
end

-- Positive Corner Departure is a current A8 crossing witness.  When GIANTS
-- reveals a forward/reverse transition during retained Corner Engagement, the
-- last such transition is the stronger assembly-specific anchor.  Otherwise
-- the field-scoped structural feature crossing remains the conservative path.
local function cornerDepartureEvidence(feature,p,productive,motion,input,engagement,currentDemand)
    if currentDemand~=nil then return false,"CORNER_APPROACH_DEMAND_REMAINS_POSITIVE",false end
    if not positiveProductiveA8(productive,motion,engagement,input) then
        return false,"FRESH_PRODUCTIVE_A8_UNAVAILABLE",false
    end
    if input.observationEpoch<=tonumber(engagement.establishedObservationEpoch or -math.huge) then
        return false,"A8_NOT_FRESHER_THAN_CORNER_ADMISSION",false
    end

    local transition=engagement.finalDirectionTransition
    if type(transition)=="table" and finite(transition.x) and finite(transition.z) then
        local along=(transition.x-p.currentX)*p.headingX+(transition.z-p.currentZ)*p.headingZ
        if along<-EPSILON_M then
            return true,"A8_CROSSED_FINAL_MANOEUVRE_DIRECTION_TRANSITION_BOUNDARY",true,along
        end
        return false,"FINAL_DIRECTION_TRANSITION_BOUNDARY_NOT_CROSSED",true,along
    end

    if engagement.hasObservedManoeuvring==true
        and finite(engagement.manoeuvringObservationEpoch)
        and input.observationEpoch<=engagement.manoeuvringObservationEpoch then
        return false,"A8_NOT_FRESHER_THAN_MANOEUVRING_EVIDENCE",false
    end

    local crossed,along=featureBehindCurrentA8(feature,p)
    if crossed then
        return true,engagement.hasObservedManoeuvring==true
            and "A8_CROSSED_FIELD_SCOPED_CORNER_BOUNDARY_AFTER_MANOEUVRING"
            or "CONTINUOUS_A8_CROSSED_FIELD_SCOPED_CORNER_BOUNDARY",true,along
    end
    return false,"FIELD_SCOPED_CORNER_BOUNDARY_NOT_CROSSED",true,along
end

local function observeDirectionTransition(engagement,motion,isManoeuvring,input,entry,result)
    local native=motion and motion.nativeFieldWork and motion.nativeFieldWork.nativeDriveCommand or nil
    local current=nil
    if native~=nil and native.valid==true
        and (native.moveForwards==true or native.moveForwards==false) then
        current=native.moveForwards
    end
    if current~=true and current~=false then
        engagement.wasCurrentlyManoeuvring=isManoeuvring==true
        return
    end
    local previous=engagement.lastNativeMoveForwards
    if previous~=nil and previous~=current
        and (isManoeuvring==true or engagement.wasCurrentlyManoeuvring==true)
        and finite(motion.poseX) and finite(motion.poseZ) then
        engagement.finalDirectionTransition={
            x=motion.poseX,z=motion.poseZ,
            fromMoveForwards=previous,toMoveForwards=current,
            observationSnapshotId=input.observationSnapshotId,
            observationEpoch=input.observationEpoch,
            source="GIANTS_IMMEDIATE_NATIVE_DIRECTION_TRANSITION"
        }
        cornerEvent(result.events,"CORNER_DIRECTION_TRANSITION_OBSERVED",entry,{
            assemblyId=engagement.assemblyId,sourceJobToken=engagement.sourceJobToken,
            observationSnapshotId=input.observationSnapshotId,
            reason=previous and "FORWARD_TO_REVERSE" or "REVERSE_TO_FORWARD"
        })
    end
    engagement.lastNativeMoveForwards=current
    engagement.wasCurrentlyManoeuvring=isManoeuvring==true
end

local function assessCornerKnowledge(self,input,projections,relationships)
    local shape=self.structuralFieldShapeAssessment:assess(input.fieldWorld,input.fieldWorldReferenceKey)
    local result={
        fieldWorldReferenceKey=input.fieldWorldReferenceKey,
        polygonKey=input.fieldWorldReferenceKey,
        status=shape.status,
        structuralFieldShape=copyKnowledge(shape),
        atlasEntries={},approachDemands={},occupancies={},engagements={},positiveDepartures={},sharedCornerSituations={},events={},
        decisionAuthority=false,controlAuthority=false,authority="SITUATION_KNOWLEDGE_ONLY"
    }
    if OuttaMyWay.ValueRecord.length(shape.cornerFeatures or {})==0 then return result end

    local atlas=self.cornerAtlases[input.fieldWorldReferenceKey]
    if atlas==nil then
        atlas={fieldWorldReferenceKey=input.fieldWorldReferenceKey,engagements={},departures={},publishedFeatures={}}
        self.cornerAtlases[input.fieldWorldReferenceKey]=atlas
    end

    local motions=byAssembly(input.motionEvidence)
    local productive=byAssembly(input.productiveContinuationKnowledge)
    local futures=byAssembly(input.futureSpace)
    local physical=byAssembly(input.physicalSpaceEvidence)
    local currentIds={}
    for _,p in OuttaMyWay.ValueRecord.ipairs(projections) do currentIds[p.assemblyId]=true end

    for _,feature in OuttaMyWay.ValueRecord.ipairs(shape.cornerFeatures or {}) do
        local entry=featureEntry(feature,input)
        result.atlasEntries[#result.atlasEntries+1]=copyKnowledge(entry)
        if atlas.publishedFeatures[feature.cornerKey]~=true then
            atlas.publishedFeatures[feature.cornerKey]=true
            cornerEvent(result.events,"CORNER_ATLAS_DISCOVERED",entry,{
                observationSnapshotId=input.observationSnapshotId,
                reason="POSITIVE_STRUCTURAL_FIELD_SHAPE"
            })
        end

        local engagements=atlas.engagements[feature.cornerKey] or {}
        atlas.engagements[feature.cornerKey]=engagements
        local departures=atlas.departures[feature.cornerKey] or {}
        atlas.departures[feature.cornerKey]=departures

        for reference,record in OuttaMyWay.ValueRecord.pairs(engagements) do
            if not currentIds[record.assemblyId] then engagements[reference]=nil end
        end
        for reference,record in OuttaMyWay.ValueRecord.pairs(departures) do
            if not currentIds[record.assemblyId] then departures[reference]=nil end
        end

        local demandsByReference={}
        for _,p in OuttaMyWay.ValueRecord.ipairs(projections) do
            local motion=motions[p.assemblyId]
            local path=continuation(futures[p.assemblyId])
            local demand=cornerApproachDemand(feature,p,motion,productive[p.assemblyId],path,physical[p.assemblyId],input)
            if demand~=nil then
                demandsByReference[demand.assemblyReferenceKey]=demand
                result.approachDemands[#result.approachDemands+1]=copyKnowledge(demand)
            end
        end

        for _,p in OuttaMyWay.ValueRecord.ipairs(projections) do
            local motion=motions[p.assemblyId]
            local reference=motion and motion.assemblyReferenceKey
            local token=motion and motion.sourceJobToken
            if reference~=nil and token~=nil then
                local engagement=engagements[reference]
                if engagement~=nil and engagement.sourceJobToken~=token then
                    engagements[reference]=nil
                    engagement=nil
                end
                if departures[reference]~=nil and departures[reference].sourceJobToken~=token then
                    departures[reference]=nil
                end

                local demand=demandsByReference[reference]
                local departed=departures[reference]
                if engagement==nil and demand~=nil and departed==nil then
                    engagement={
                        cornerKey=feature.cornerKey,polygonKey=input.fieldWorldReferenceKey,
                        assemblyId=p.assemblyId,assemblyReferenceKey=reference,sourceJobToken=token,
                        establishedObservationSnapshotId=input.observationSnapshotId,
                        establishedObservationEpoch=input.observationEpoch,
                        approachEvidence=copyKnowledge(demand),
                        relevanceEvidenceState="POSITIVE_CORNER_APPROACH_DEMAND",
                        currentEvidenceState="CORNER_ENGAGEMENT_RETAINED",
                        hasObservedManoeuvring=false,isDepartureGateOpen=false
                    }
                    engagements[reference]=engagement
                    cornerEvent(result.events,"CORNER_ENGAGEMENT_ESTABLISHED",entry,{
                        assemblyId=p.assemblyId,sourceJobToken=token,
                        observationSnapshotId=input.observationSnapshotId,
                        reason="UNILATERAL_CORNER_ADMISSION"
                    })
                end

                if engagement~=nil then
                    engagement.assemblyId=p.assemblyId
                    engagement.currentApproachDemand=copyKnowledge(demand)
                    engagement.relevanceEvidenceState=demand~=nil and "POSITIVE_CURRENT_CORNER_APPROACH_DEMAND"
                        or "RETAINED_CORNER_ENGAGEMENT"
                    local turning=productive[p.assemblyId] and productive[p.assemblyId].jobToken==token
                        and productive[p.assemblyId].isTurn==true
                    turning=turning or motion.localIntentClassification=="TURNING"
                    engagement.isCurrentlyManoeuvring=turning==true
                    if turning then
                        if engagement.hasObservedManoeuvring~=true then
                            cornerEvent(result.events,"CORNER_MANOEUVRING_OBSERVED",entry,{
                                assemblyId=p.assemblyId,sourceJobToken=token,
                                observationSnapshotId=input.observationSnapshotId
                            })
                        end
                        engagement.hasObservedManoeuvring=true
                        engagement.manoeuvringObservationSnapshotId=input.observationSnapshotId
                        engagement.manoeuvringObservationEpoch=input.observationEpoch
                    end
                    observeDirectionTransition(engagement,motion,turning,input,entry,result)

                    local positive,reason,gate,alongM=cornerDepartureEvidence(
                        feature,p,productive[p.assemblyId],motion,input,engagement,demand)
                    engagement.isDepartureGateOpen=gate
                    engagement.departureReason=reason
                    engagement.cornerAlongAxisM=alongM
                    engagement.currentEvidenceState=turning and "CORNER_MANOEUVRING"
                        or (positive and "POSITIVE_CORNER_DEPARTURE" or "CORNER_ENGAGEMENT_RETAINED")
                    if positive then
                        engagement.isPositiveDeparture=true
                        engagement.departureObservationSnapshotId=input.observationSnapshotId
                        engagement.departureObservationEpoch=input.observationEpoch
                        departures[reference]=copyKnowledge(engagement)
                        engagements[reference]=nil
                        cornerEvent(result.events,"POSITIVE_CORNER_DEPARTURE",entry,{
                            assemblyId=p.assemblyId,sourceJobToken=token,
                            observationSnapshotId=input.observationSnapshotId,
                            reason=reason,cornerAlongAxisM=alongM
                        })
                    else
                        result.engagements[#result.engagements+1]=copyKnowledge(engagement)
                    end
                end
                if departures[reference]~=nil then
                    result.positiveDepartures[#result.positiveDepartures+1]=copyKnowledge(departures[reference])
                end
            end
        end

        local participants={}
        for _,engagement in OuttaMyWay.ValueRecord.pairs(engagements) do
            participants[engagement.assemblyId]={
                assemblyId=engagement.assemblyId,assemblyReferenceKey=engagement.assemblyReferenceKey,
                engagement=true,approachDemand=demandsByReference[engagement.assemblyReferenceKey]~=nil,
                establishedObservationEpoch=engagement.establishedObservationEpoch
            }
        end
        for reference,demand in OuttaMyWay.ValueRecord.pairs(demandsByReference) do
            local item=participants[demand.assemblyId]
            if item==nil then
                item={assemblyId=demand.assemblyId,assemblyReferenceKey=reference,engagement=false,approachDemand=true}
                participants[demand.assemblyId]=item
            else
                item.approachDemand=true
            end
            item.approachDistanceM=demand.approachDistanceM
        end
        local participantList={}
        for _,item in OuttaMyWay.ValueRecord.pairs(participants) do participantList[#participantList+1]=item end
        table.sort(participantList,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
        if #participantList>=2 then
            result.sharedCornerSituations[#result.sharedCornerSituations+1]={
                identity="shared-corner:"..tostring(input.operationId)..":"..tostring(feature.cornerKey),
                operationId=input.operationId,cornerKey=feature.cornerKey,
                fieldWorldReferenceKey=input.fieldWorldReferenceKey,
                participants=participantList,competingDemand=true,
                regulationSpeedKmh=CORNER_INTENT_REVELATION_CREEP_KMH,
                allocationStatus="UNALLOCATED_SITUATION_MEANING",
                decisionAuthority=false,controlAuthority=false,
                provenance={source="SpatialConstraintAssessment",layer="SITUATION_ASSESSMENT"}
            }
        end
    end
    return result
end

function Assessment.new()
    return setmetatable({lastSignatures={},cornerAtlases={},structuralFieldShapeAssessment=OuttaMyWay.StructuralFieldShapeAssessment.new()},Assessment)
end
function Assessment:reset()
    self.lastSignatures={}; self.cornerAtlases={}
    if self.structuralFieldShapeAssessment~=nil then self.structuralFieldShapeAssessment:reset() end
end
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
    local cornerKnowledge=assessCornerKnowledge(self,input,projections,relationships)
    return {operationId=input.operationId,boundaryTransitionProjections=projections,pairRelationships=relationships,cornerKnowledge=cornerKnowledge,decisionAuthority=false,controlAuthority=false,
        provenance={source="SpatialConstraintAssessment",layer="SITUATION_ASSESSMENT",forwardIntersection=true}}
end
