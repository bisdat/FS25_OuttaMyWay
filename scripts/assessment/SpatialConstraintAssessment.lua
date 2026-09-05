-- Situation Assessment for prospective competition at Field World boundary
-- transitions. This representation is diagnostic knowledge only: it grants no
-- Candidate, Decision, responsibility, authority or Control permission.

OuttaMyWay.SpatialConstraintAssessment = {}
local Assessment=OuttaMyWay.SpatialConstraintAssessment
Assessment.__index=Assessment

local GEOMETRY_EPSILON_M=0.00001

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function point(value)
    if type(value)~="table" then return nil end
    local x=tonumber(value.x or value[1])
    local z=tonumber(value.z or value[2] or value[3])
    if not finite(x) or not finite(z) then return nil end
    return {x=x,z=z}
end

local function distance(a,b)
    local dx,dz=a.x-b.x,a.z-b.z
    return math.sqrt(dx*dx+dz*dz)
end

local function pointSegmentDistance(p,a,b)
    local dx,dz=b.x-a.x,b.z-a.z
    local lengthSquared=dx*dx+dz*dz
    if lengthSquared<=GEOMETRY_EPSILON_M*GEOMETRY_EPSILON_M then return distance(p,a) end
    local t=((p.x-a.x)*dx+(p.z-a.z)*dz)/lengthSquared
    if t<0 then t=0 elseif t>1 then t=1 end
    return distance(p,{x=a.x+t*dx,z=a.z+t*dz})
end

local function collectRings(fieldWorld)
    local rings={}
    local boundary=fieldWorld and fieldWorld.boundary or {}
    if OuttaMyWay.ValueRecord.length(boundary)>=2 then
        rings[#rings+1]={kind="OUTER_BOUNDARY",index=1,points=boundary}
    end
    for index,island in OuttaMyWay.ValueRecord.ipairs(fieldWorld and fieldWorld.islands or {}) do
        if OuttaMyWay.ValueRecord.length(island)>=2 then
            rings[#rings+1]={kind="ISLAND_BOUNDARY",index=index,points=island}
        end
    end
    return rings
end

local function vertexKey(ring,index)
    return string.format("%s:%d:VERTEX:%d",ring.kind,ring.index,index)
end

local function edgeForContact(fieldWorld,contact,boundarySource)
    local matches={}
    for _,ring in OuttaMyWay.ValueRecord.ipairs(collectRings(fieldWorld)) do
        local sourceMatches=(boundarySource=="FIELD_WORLD_OUTER_BOUNDARY" and ring.kind=="OUTER_BOUNDARY")
            or (boundarySource=="FIELD_WORLD_ISLAND_BOUNDARY" and ring.kind=="ISLAND_BOUNDARY")
        if sourceMatches then
            local count=OuttaMyWay.ValueRecord.length(ring.points)
            for index=1,count do
                local nextIndex=(index % count)+1
                local a,b=point(ring.points[index]),point(ring.points[nextIndex])
                if a~=nil and b~=nil and pointSegmentDistance(contact,a,b)<=GEOMETRY_EPSILON_M then
                    matches[#matches+1]={
                        ringKind=ring.kind,ringIndex=ring.index,edgeIndex=index,
                        edgeKey=string.format("%s:%d:EDGE:%d",ring.kind,ring.index,index),
                        startVertex={identity=vertexKey(ring,index),index=index,x=a.x,z=a.z},
                        endVertex={identity=vertexKey(ring,nextIndex),index=nextIndex,x=b.x,z=b.z},
                        startX=a.x,startZ=a.z,endX=b.x,endZ=b.z
                    }
                end
            end
        end
    end
    if OuttaMyWay.ValueRecord.length(matches)==1 then return matches[1],nil end
    if OuttaMyWay.ValueRecord.length(matches)==0 then return nil,"TERMINATING_BOUNDARY_EDGE_UNRESOLVED" end
    return nil,"TERMINATING_BOUNDARY_EDGE_AMBIGUOUS_AT_VERTEX"
end

local function byAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do result[item.assemblyId]=item end
    return result
end

local function firstContinuation(future)
    for _,alternative in OuttaMyWay.ValueRecord.ipairs(future and future.alternatives or {}) do
        if alternative.kind=="FIELD_WORLD_BOUNDED_LOCAL_CONTINUATION" then return alternative end
    end
    return nil
end

local function positiveProgressRate(motion)
    if motion~=nil and finite(motion.positionDerivedSpeedMps) and motion.positionDerivedSpeedMps>0 then
        return motion.positionDerivedSpeedMps,"POSITION_DERIVED_PROGRESS_RATE"
    end
    if motion~=nil and finite(motion.reportedSpeedMps) and motion.reportedSpeedMps>0 then
        return motion.reportedSpeedMps,"GIANTS_REPORTED_PROGRESS_RATE"
    end
    return nil,"POSITIVE_PROGRESS_RATE_UNAVAILABLE"
end

local function projection(fieldWorld,fieldWorldReferenceKey,assemblyId,future,motion)
    local alternative=firstContinuation(future)
    local width=motion and motion.nativeFieldWork and motion.nativeFieldWork.workingWidth or nil
    local base={
        assemblyId=assemblyId,assemblyReferenceKey=motion and motion.assemblyReferenceKey or nil,
        fieldWorldReferenceKey=fieldWorldReferenceKey,
        fieldWorldSnapshotReferenceKey=fieldWorld and fieldWorld.representativeSnapshotReferenceKey or nil,
        futureSpaceIdentity=future and future.identity or nil,
        futureSpaceBasis=alternative and alternative.kind or nil,
        status="UNRESOLVED",reason=nil,decisionAuthority=false,controlAuthority=false,
        positiveOnly=true,authority="SITUATION_KNOWLEDGE_ONLY_NO_NEGATIVE_CLEARANCE_AUTHORITY",
        provenance={source="SpatialConstraintAssessment",layer="SITUATION_ASSESSMENT",futureSpaceSource=future and future.provenance and future.provenance.source or nil}
    }
    if alternative==nil then base.reason="FIELD_BOUNDED_PROJECTION_UNAVAILABLE"; return base end
    local start={x=tonumber(alternative.startX),z=tonumber(alternative.startZ)}
    local contact={x=tonumber(alternative.endX),z=tonumber(alternative.endZ)}
    local hx,hz=tonumber(alternative.headingX),tonumber(alternative.headingZ)
    local boundaryDistance=tonumber(alternative.boundaryDistance)
    if not finite(start.x) or not finite(start.z) or not finite(contact.x) or not finite(contact.z)
        or not finite(hx) or not finite(hz) or not finite(boundaryDistance) then
        base.reason="FIELD_BOUNDED_PROJECTION_INVALID"; return base
    end
    local headingLength=math.sqrt(hx*hx+hz*hz)
    if headingLength<=GEOMETRY_EPSILON_M then base.reason="PROJECTED_HEADING_INVALID"; return base end
    local edge,edgeReason=edgeForContact(fieldWorld,contact,alternative.boundarySource)
    if edge==nil then base.reason=edgeReason; return base end
    base.currentX=start.x; base.currentZ=start.z
    base.headingX=hx/headingLength; base.headingZ=hz/headingLength
    base.contactX=contact.x; base.contactZ=contact.z
    base.boundaryDistanceM=boundaryDistance;base.boundarySource=alternative.boundarySource
    base.boundaryRingKind=edge.ringKind;base.boundaryRingIndex=edge.ringIndex
    base.terminatingBoundaryEdge=edge
    base.incidentVertices={edge.startVertex,edge.endVertex}
    base.workingWidthM=width and tonumber(width.widthMetres) or nil
    base.workingWidthSource=width and width.source or "UNAVAILABLE"
    base.workingWidthAuthority=width and width.authority or "PROVISIONAL_DEMAND_SEED_INPUT_ONLY"
    if width==nil or width.available~=true or not finite(base.workingWidthM) or base.workingWidthM<=0 then
        base.reason="PROVISIONAL_WORKING_WIDTH_UNAVAILABLE"; return base
    end
    base.provisionalHalfWidthM=base.workingWidthM/2
    local rate,rateSource=positiveProgressRate(motion)
    base.progressRateMps=rate;base.progressRateSource=rateSource
    if rate~=nil then base.provisionalTimeToBoundarySec=boundaryDistance/rate end
    base.status="SUPPORTED";base.reason="FIELD_BOUNDARY_TRANSITION_PROJECTION_SUPPORTED"
    return base
end

local function sharedVertex(a,b)
    local ae,be=a.terminatingBoundaryEdge,b.terminatingBoundaryEdge
    if ae==nil or be==nil or ae.edgeKey==be.edgeKey then return nil end
    for _,av in OuttaMyWay.ValueRecord.ipairs(a.incidentVertices or {}) do
        for _,bv in OuttaMyWay.ValueRecord.ipairs(b.incidentVertices or {}) do
            if av.identity==bv.identity then return av end
        end
    end
    return nil
end

local function relativeContact(source,target)
    local dx,dz=target.contactX-source.currentX,target.contactZ-source.currentZ
    local longitudinal=dx*source.headingX+dz*source.headingZ
    local lateral=dx*(-source.headingZ)+dz*source.headingX
    local positive=longitudinal>=-GEOMETRY_EPSILON_M
        and longitudinal<=source.boundaryDistanceM+GEOMETRY_EPSILON_M
        and math.abs(lateral)<=source.provisionalHalfWidthM+GEOMETRY_EPSILON_M
    return {sourceAssemblyId=source.assemblyId,targetAssemblyId=target.assemblyId,longitudinalM=longitudinal,lateralM=lateral,
        sourceBoundaryDistanceM=source.boundaryDistanceM,sourceProvisionalHalfWidthM=source.provisionalHalfWidthM,positive=positive}
end

local function pairKnowledge(operationId,a,b)
    local record={
        operationId=operationId,subjectAssemblyId=a.assemblyId,otherAssemblyId=b.assemblyId,
        subjectProjection=a,otherProjection=b,classification="UNRESOLVED",reason=nil,
        decisionAuthority=false,controlAuthority=false,positiveOnly=true,
        authority="SITUATION_KNOWLEDGE_ONLY_NO_CANDIDATE_OR_CONTROL_AUTHORITY",
        provenance={source="SpatialConstraintAssessment",layer="SITUATION_ASSESSMENT",hypothesis="PROSPECTIVE_CONSTRAINED_SPACE_REPRESENTATION"}
    }
    if a.status~="SUPPORTED" or b.status~="SUPPORTED" then
        record.reason="BOUNDARY_TRANSITION_PROJECTION_UNRESOLVED"
        return record
    end
    local vertex=sharedVertex(a,b)
    if vertex~=nil then
        local vertexPoint={x=vertex.x,z=vertex.z}
        local ad=distance({x=a.contactX,z=a.contactZ},vertexPoint)
        local bd=distance({x=b.contactX,z=b.contactZ},vertexPoint)
        record.sharedVertex=vertex
        record.subjectContactToSharedVertexM=ad
        record.otherContactToSharedVertexM=bd
        record.category1Evidence={
            distinctTerminatingEdges=true,sharedVertexIdentity=vertex.identity,
            subjectContactToSharedVertexM=ad,otherContactToSharedVertexM=bd,
            subjectProvisionalHalfWidthM=a.provisionalHalfWidthM,otherProvisionalHalfWidthM=b.provisionalHalfWidthM,
            subjectWithinSeed=ad<=a.provisionalHalfWidthM+GEOMETRY_EPSILON_M,
            otherWithinSeed=bd<=b.provisionalHalfWidthM+GEOMETRY_EPSILON_M
        }
        if record.category1Evidence.subjectWithinSeed and record.category1Evidence.otherWithinSeed then
            record.classification="CATEGORY_1_PROSPECTIVE_CANDIDATE"
            record.reason="DISTINCT_BOUNDARY_EDGES_SHARE_VERTEX_WITHIN_REPRESENTATION_RELATIVE_SEEDS"
            return record
        end
    end
    local subjectBand=relativeContact(a,b)
    local otherBand=relativeContact(b,a)
    record.category2Evidence={subjectProgressionBandContainsOtherContact=subjectBand,otherProgressionBandContainsSubjectContact=otherBand}
    if subjectBand.positive or otherBand.positive then
        record.classification="CATEGORY_2_PROSPECTIVE_CANDIDATE"
        record.reason="BOUNDARY_TRANSITION_CONTACT_WITHIN_OTHER_PROJECTED_PROGRESSION_BAND"
    else
        record.classification="NO_POSITIVE_CANDIDATE"
        record.reason=vertex~=nil and "SHARED_VERTEX_OUTSIDE_REPRESENTATION_RELATIVE_SEED_AND_NO_BAND_COUPLING" or "NO_POSITIVE_PROSPECTIVE_CONSTRAINED_SPACE_COUPLING"
    end
    return record
end

local function numberText(value)
    if value==nil then return "UNRESOLVED" end
    return string.format("%.3f",value)
end

local function logInfo(message)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][SPATIAL-CONSTRAINT] %s",message)
    else print("[FS25_OuttaMyWay][SPATIAL-CONSTRAINT] "..message) end
end

function Assessment.new()
    return setmetatable({lastSignatures={}},Assessment)
end

function Assessment:reset()
    self.lastSignatures={}
end

function Assessment:assess(input)
    local futures=byAssembly(input.futureSpace)
    local motions=byAssembly(input.motionEvidence)
    local projections={}
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(input.assemblyIds or {}) do
        projections[#projections+1]=projection(input.fieldWorld,input.fieldWorldReferenceKey,assemblyId,futures[assemblyId],motions[assemblyId])
    end
    table.sort(projections,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
    local pairs={}
    for first=1,OuttaMyWay.ValueRecord.length(projections)-1 do
        for second=first+1,OuttaMyWay.ValueRecord.length(projections) do
            local record=pairKnowledge(input.operationId,projections[first],projections[second])
            pairs[#pairs+1]=record
            local pairKey=tostring(input.operationId).."|"..tostring(record.subjectAssemblyId).."|"..tostring(record.otherAssemblyId)
            local signature=table.concat({record.classification,record.reason,
                record.subjectProjection.terminatingBoundaryEdge and record.subjectProjection.terminatingBoundaryEdge.edgeKey or "UNRESOLVED",
                record.otherProjection.terminatingBoundaryEdge and record.otherProjection.terminatingBoundaryEdge.edgeKey or "UNRESOLVED"},"|")
            if self.lastSignatures[pairKey]~=signature then
                self.lastSignatures[pairKey]=signature
                local c1=record.category1Evidence or {}
                local c2=record.category2Evidence or {}
                local ab=c2.subjectProgressionBandContainsOtherContact or {}
                local ba=c2.otherProgressionBandContainsSubjectContact or {}
                logInfo(string.format("SPATIAL_CONSTRAINT_ASSESSED operation=%s pair=%s|%s classification=%s subjectContact=(%s,%s) otherContact=(%s,%s) subjectEdge=%s otherEdge=%s sharedVertex=%s widths=%s|%s halfWidths=%s|%s vertexDistances=%s|%s category2Longitudinal=%s|%s category2Lateral=%s|%s boundaryDistances=%s|%s timeToTransition=%s|%s reason=%s decisionAuthority=false controlAuthority=false",
                    tostring(input.operationId),tostring(record.subjectAssemblyId),tostring(record.otherAssemblyId),record.classification,
                    numberText(record.subjectProjection.contactX),numberText(record.subjectProjection.contactZ),numberText(record.otherProjection.contactX),numberText(record.otherProjection.contactZ),
                    tostring(record.subjectProjection.terminatingBoundaryEdge and record.subjectProjection.terminatingBoundaryEdge.edgeKey or "UNRESOLVED"),tostring(record.otherProjection.terminatingBoundaryEdge and record.otherProjection.terminatingBoundaryEdge.edgeKey or "UNRESOLVED"),
                    tostring(record.sharedVertex and record.sharedVertex.identity or "none"),numberText(record.subjectProjection.workingWidthM),numberText(record.otherProjection.workingWidthM),numberText(record.subjectProjection.provisionalHalfWidthM),numberText(record.otherProjection.provisionalHalfWidthM),
                    numberText(c1.subjectContactToSharedVertexM),numberText(c1.otherContactToSharedVertexM),numberText(ab.longitudinalM),numberText(ba.longitudinalM),numberText(ab.lateralM),numberText(ba.lateralM),
                    numberText(record.subjectProjection.boundaryDistanceM),numberText(record.otherProjection.boundaryDistanceM),numberText(record.subjectProjection.provisionalTimeToBoundarySec),numberText(record.otherProjection.provisionalTimeToBoundarySec),tostring(record.reason)))
            end
        end
    end
    return {operationId=input.operationId,boundaryTransitionProjections=projections,pairRelationships=pairs,
        decisionAuthority=false,controlAuthority=false,provenance={source="SpatialConstraintAssessment",layer="SITUATION_ASSESSMENT",representationOnly=true}}
end
