--- Engineering-only probe for Category-2 Boundary Interaction Reach.
-- This module publishes DIAGNOSTIC evidence only. It owns no Situation,
-- Candidate, Decision, Responsibility, Bounded Authority or Control semantics.

OuttaMyWay.BoundaryInteractionReachProbe={}
local Probe=OuttaMyWay.BoundaryInteractionReachProbe

local publication=OuttaMyWay.LogPublication.origin("SITUATION_ASSESSMENT")
local EPSILON_M=0.00001

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function numberText(value)
    return value==nil and "UNRESOLVED" or string.format("%.3f",value)
end

local function byAssembly(values)
    local result={}
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if value.assemblyId~=nil then result[value.assemblyId]=value end
    end
    return result
end

local function contactPoint(measurement)
    if type(measurement)~="table" or not finite(measurement.contactX) or not finite(measurement.contactZ) then return nil end
    return {x=measurement.contactX,z=measurement.contactZ}
end

function Probe.measure(projection,physical)
    local result={
        status="UNRESOLVED",
        reason="BOUNDARY_INTERACTION_REACH_EVIDENCE_UNAVAILABLE",
        decisionAuthority=false,
        controlAuthority=false,
        diagnosticOnly=true
    }
    if type(projection)~="table" or projection.status~="SUPPORTED" then
        result.reason="SUPPORTED_BOUNDARY_PROJECTION_UNAVAILABLE"
        return result
    end
    if not finite(projection.currentX) or not finite(projection.currentZ)
        or not finite(projection.contactX) or not finite(projection.contactZ) then
        result.reason="BOUNDARY_PROJECTION_REFERENCE_OR_CONTACT_UNAVAILABLE"
        return result
    end
    if type(physical)~="table" then
        result.reason="CURRENT_PHYSICAL_ASSEMBLY_REPRESENTATION_UNAVAILABLE"
        return result
    end

    local contributors={}
    local maximum=nil
    local maximumPrimitiveId=nil
    local count=0
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical.primitives or {}) do
        local radius=tonumber(primitive.radius)
        local px,pz=tonumber(primitive.x),tonumber(primitive.z)
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(px) and finite(pz) and finite(radius) and radius>=0 then
            local dx,dz=px-projection.currentX,pz-projection.currentZ
            local centreDistanceM=math.sqrt(dx*dx+dz*dz)
            local reachM=centreDistanceM+radius
            count=count+1
            contributors[#contributors+1]={
                identity=primitive.identity,
                centreDistanceM=centreDistanceM,
                primitiveRadiusM=radius,
                radialReachM=reachM
            }
            if maximum==nil or reachM>maximum then
                maximum=reachM
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
    result.referenceX=projection.currentX
    result.referenceZ=projection.currentZ
    result.contactX=projection.contactX
    result.contactZ=projection.contactZ
    result.boundaryRingKind=projection.boundaryRingKind
    result.boundaryRingIndex=projection.boundaryRingIndex
    result.terminatingBoundaryEdgeKey=projection.terminatingBoundaryEdge and projection.terminatingBoundaryEdge.edgeKey or nil
    result.boundaryInteractionReachM=maximum
    result.maximumPrimitiveId=maximumPrimitiveId
    result.contributorCount=count
    result.contributors=contributors
    result.workingWidthM=projection.workingWidthM
    result.coverageComplete=physical.coverageComplete==true
    result.negativeClearanceAuthority=physical.negativeClearanceAuthority==true
    result.configurationProfileId=physical.configurationProfileId
    result.representationSource=physical.provenance and physical.provenance.source or "UNAVAILABLE"
    return result
end

function Probe.compare(subject,other)
    local a=contactPoint(subject)
    local b=contactPoint(other)
    if a==nil or b==nil or not finite(subject.boundaryInteractionReachM) or not finite(other.boundaryInteractionReachM) then
        return {
            status="UNRESOLVED",
            reason="PAIR_BOUNDARY_INTERACTION_REACH_EVIDENCE_UNAVAILABLE",
            decisionAuthority=false,
            controlAuthority=false,
            diagnosticOnly=true
        }
    end
    local dx,dz=b.x-a.x,b.z-a.z
    local separationM=math.sqrt(dx*dx+dz*dz)
    local reachSumM=subject.boundaryInteractionReachM+other.boundaryInteractionReachM
    local overlapMarginM=reachSumM-separationM
    return {
        status="SUPPORTED",
        reason=overlapMarginM>EPSILON_M and "RAW_BOUNDARY_DEMAND_DISCS_OVERLAP" or "RAW_BOUNDARY_DEMAND_DISCS_DO_NOT_OVERLAP",
        subjectAssemblyId=subject.assemblyId,
        otherAssemblyId=other.assemblyId,
        contactSeparationM=separationM,
        subjectReachM=subject.boundaryInteractionReachM,
        otherReachM=other.boundaryInteractionReachM,
        reachSumM=reachSumM,
        overlapMarginM=overlapMarginM,
        rawDiscOverlap=overlapMarginM>EPSILON_M,
        sameBoundaryRing=subject.boundaryRingKind==other.boundaryRingKind
            and subject.boundaryRingIndex==other.boundaryRingIndex,
        decisionAuthority=false,
        controlAuthority=false,
        diagnosticOnly=true
    }
end

local function contributorText(measurement)
    local values={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(measurement.contributors or {}) do
        values[#values+1]=string.format("%s@centre=%s,radius=%s,reach=%s",
            tostring(item.identity),numberText(item.centreDistanceM),numberText(item.primitiveRadiusM),numberText(item.radialReachM))
    end
    return OuttaMyWay.ValueRecord.length(values)>0 and table.concat(values,";") or "none"
end

function Probe.observe(operationId,projections,physicalSpaceEvidence)
    local eligible=publication:isEligible("DIAGNOSTIC","INFO","BOUNDARY_INTERACTION_REACH_PROBE")
    if eligible~=true then return false,"DIAGNOSTIC_PUBLICATION_NOT_ELIGIBLE" end

    local physicalByAssembly=byAssembly(physicalSpaceEvidence)
    local measurements={}
    for _,projection in OuttaMyWay.ValueRecord.ipairs(projections or {}) do
        local measurement=Probe.measure(projection,physicalByAssembly[projection.assemblyId])
        measurements[#measurements+1]=measurement
        publication:info("DIAGNOSTIC","BOUNDARY_INTERACTION_REACH_PROBE",
            "operation=%s assembly=%s ref=%s status=%s reason=%s reference=(%s,%s) contact=(%s,%s) ring=%s:%s edge=%s reachM=%s workingWidthM=%s primitiveCount=%s maxPrimitive=%s coverageComplete=%s negativeClearanceAuthority=%s configProfile=%s representationSource=%s contributors=%s decisionAuthority=false controlAuthority=false",
            tostring(operationId),tostring(projection.assemblyId),tostring(projection.assemblyReferenceKey),
            tostring(measurement.status),tostring(measurement.reason),
            numberText(measurement.referenceX),numberText(measurement.referenceZ),
            numberText(measurement.contactX),numberText(measurement.contactZ),
            tostring(measurement.boundaryRingKind or "UNRESOLVED"),tostring(measurement.boundaryRingIndex or "UNRESOLVED"),
            tostring(measurement.terminatingBoundaryEdgeKey or "UNRESOLVED"),
            numberText(measurement.boundaryInteractionReachM),numberText(measurement.workingWidthM),
            tostring(measurement.contributorCount or 0),tostring(measurement.maximumPrimitiveId or "UNRESOLVED"),
            tostring(measurement.coverageComplete==true),tostring(measurement.negativeClearanceAuthority==true),
            tostring(measurement.configurationProfileId or "UNRESOLVED"),tostring(measurement.representationSource or "UNAVAILABLE"),
            contributorText(measurement))
    end

    local count=OuttaMyWay.ValueRecord.length(measurements)
    for i=1,count-1 do
        for j=i+1,count do
            local pair=Probe.compare(measurements[i],measurements[j])
            publication:info("DIAGNOSTIC","BOUNDARY_INTERACTION_REACH_PAIR_PROBE",
                "operation=%s pair=%s|%s status=%s reason=%s contactSeparationM=%s reachM=%s|%s reachSumM=%s overlapMarginM=%s rawDiscOverlap=%s sameBoundaryRing=%s decisionAuthority=false controlAuthority=false",
                tostring(operationId),tostring(pair.subjectAssemblyId or measurements[i].assemblyId or "UNRESOLVED"),
                tostring(pair.otherAssemblyId or measurements[j].assemblyId or "UNRESOLVED"),
                tostring(pair.status),tostring(pair.reason),numberText(pair.contactSeparationM),
                numberText(pair.subjectReachM),numberText(pair.otherReachM),numberText(pair.reachSumM),
                numberText(pair.overlapMarginM),tostring(pair.rawDiscOverlap==true),tostring(pair.sameBoundaryRing==true))
        end
    end
    return true,"PUBLISHED"
end
