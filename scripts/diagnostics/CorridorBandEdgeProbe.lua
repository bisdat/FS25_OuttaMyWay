--- Engineering-only probe for the positive DISC bands used by opposed-corridor Situation Assessment.
-- This module publishes DIAGNOSTIC evidence only. It owns no Situation,
-- Candidate, Decision, Responsibility, Bounded Authority or Control semantics.

OuttaMyWay.CorridorBandEdgeProbe={}
local Probe=OuttaMyWay.CorridorBandEdgeProbe

local publication=OuttaMyWay.LogPublication.origin("SITUATION_ASSESSMENT")

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function numberText(value)
    return value==nil and "UNRESOLVED" or string.format("%.3f",value)
end

local function valueText(value)
    return value==nil and "UNRESOLVED" or tostring(value)
end

local function envelopeWidth(physical,key)
    local envelope=physical and physical[key] or nil
    return type(envelope)=="table" and tonumber(envelope.widthM) or nil
end

local function contributor(primitive,centreOffsetM,lowM,highM)
    return {
        identity=primitive.identity,
        nodeName=primitive.nodeName,
        memberReferenceKey=primitive.memberReferenceKey,
        source=primitive.source,
        class=primitive.class,
        participationStatus=primitive.participationStatus,
        runtimeCompoundChild=primitive.runtimeCompoundChild,
        radiusM=tonumber(primitive.radius),
        centreOffsetM=centreOffsetM,
        lowM=lowM,
        highM=highM
    }
end

function Probe.measureBand(physical,currentSpace,rightX,rightZ)
    local result={
        status="UNRESOLVED",
        reason="CORRIDOR_BAND_EVIDENCE_UNAVAILABLE",
        decisionAuthority=false,
        controlAuthority=false,
        diagnosticOnly=true
    }
    if type(physical)~="table" then
        result.reason="CURRENT_PHYSICAL_ASSEMBLY_REPRESENTATION_UNAVAILABLE"
        return result
    end
    if type(currentSpace)~="table" or type(currentSpace.occupancy)~="table" then
        result.reason="CURRENT_SPACE_POSE_UNAVAILABLE"
        return result
    end
    local originX,originZ=tonumber(currentSpace.occupancy.x),tonumber(currentSpace.occupancy.z)
    local rx,rz=tonumber(rightX),tonumber(rightZ)
    if not finite(originX) or not finite(originZ) or not finite(rx) or not finite(rz) then
        result.reason="CORRIDOR_LATERAL_FRAME_UNAVAILABLE"
        return result
    end

    local minimum,maximum=nil,nil
    local minimumContributor,maximumContributor=nil,nil
    local contributors={}
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical.primitives or {}) do
        local px,pz,radius=tonumber(primitive.x),tonumber(primitive.z),tonumber(primitive.radius)
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(px) and finite(pz) and finite(radius) and radius>0 then
            local centreOffsetM=(px-originX)*rx+(pz-originZ)*rz
            local lowM=centreOffsetM-radius
            local highM=centreOffsetM+radius
            local item=contributor(primitive,centreOffsetM,lowM,highM)
            contributors[#contributors+1]=item
            if minimum==nil or lowM<minimum then
                minimum=lowM
                minimumContributor=item
            end
            if maximum==nil or highM>maximum then
                maximum=highM
                maximumContributor=item
            end
        end
    end
    if minimum==nil or maximum==nil then
        result.reason="NO_POSITIVE_CURRENT_PHYSICAL_DISC_SUPPORT"
        return result
    end

    table.sort(contributors,function(a,b) return tostring(a.identity)<tostring(b.identity) end)
    result.status="SUPPORTED"
    result.reason="POSITIVE_DISC_CORRIDOR_BAND_MEASURED"
    result.minOffsetM=minimum
    result.maxOffsetM=maximum
    result.widthM=maximum-minimum
    result.minContributor=minimumContributor
    result.maxContributor=maximumContributor
    result.contributors=contributors
    result.contributorCount=#contributors
    result.directionalPassageWidthM=envelopeWidth(physical,"directionalPassageEnvelope")
    result.transitPassageWidthM=envelopeWidth(physical,"transitPassageEnvelope")
    result.configurationProfileId=physical.configurationProfileId
    result.coverageComplete=physical.coverageComplete==true
    result.negativeClearanceAuthority=physical.negativeClearanceAuthority==true
    return result
end

local function edgeText(item)
    if type(item)~="table" then return "UNRESOLVED" end
    return string.format(
        "id=%s,node=%s,member=%s,source=%s,class=%s,participation=%s,runtimeCompoundChild=%s,radius=%s,centre=%s,low=%s,high=%s",
        valueText(item.identity),valueText(item.nodeName),valueText(item.memberReferenceKey),
        valueText(item.source),valueText(item.class),valueText(item.participationStatus),
        valueText(item.runtimeCompoundChild),numberText(item.radiusM),numberText(item.centreOffsetM),
        numberText(item.lowM),numberText(item.highM))
end

local function contributorsText(measurement)
    local values={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(measurement and measurement.contributors or {}) do
        values[#values+1]=edgeText(item)
    end
    return #values>0 and table.concat(values,";") or "none"
end

function Probe.observe(observationSnapshotId,relationship,subjectPhysical,otherPhysical,subjectSpace,otherSpace)
    local eligible=publication:isEligible("DIAGNOSTIC","INFO","CORRIDOR_BAND_EDGE_PROBE")
    if eligible~=true then return false,"DIAGNOSTIC_PUBLICATION_NOT_ELIGIBLE" end
    if type(relationship)~="table"
        or relationship.classification~="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT" then
        return false,"ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT_NOT_CURRENT"
    end
    local overlap=relationship.supportedCorridorOverlap
    if type(overlap)~="table" or overlap.positive~=true then
        return false,"POSITIVE_SUPPORTED_CORRIDOR_OVERLAP_NOT_CURRENT"
    end

    local rightX,rightZ=tonumber(overlap.sharedRightX),tonumber(overlap.sharedRightZ)
    if not finite(rightX) or not finite(rightZ) then
        return false,"SUPPORTED_CORRIDOR_LATERAL_AXIS_UNAVAILABLE"
    end
    local subject=Probe.measureBand(subjectPhysical,subjectSpace,rightX,rightZ)
    local other=Probe.measureBand(otherPhysical,otherSpace,rightX,rightZ)

    publication:info("DIAGNOSTIC","CORRIDOR_BAND_EDGE_PROBE",
        "observation=%s operation=%s pair=%s|%s classification=%s overlapM=%s axis=(%s,%s) right=(%s,%s) subjectBand=[%s,%s] otherBand=[%s,%s] subjectLocal=[%s,%s] subjectDiscWidth=%s subjectDirectionalWidth=%s subjectTransitWidth=%s subjectMin={%s} subjectMax={%s} otherLocal=[%s,%s] otherDiscWidth=%s otherDirectionalWidth=%s otherTransitWidth=%s otherMin={%s} otherMax={%s} decisionAuthority=false controlAuthority=false",
        valueText(observationSnapshotId),valueText(relationship.operationId),
        valueText(relationship.subjectAssemblyId),valueText(relationship.otherAssemblyId),
        valueText(relationship.classification),numberText(overlap.overlapM),
        numberText(overlap.sharedAxisX),numberText(overlap.sharedAxisZ),numberText(rightX),numberText(rightZ),
        numberText(overlap.subjectBandMinM),numberText(overlap.subjectBandMaxM),
        numberText(overlap.otherBandMinM),numberText(overlap.otherBandMaxM),
        numberText(subject.minOffsetM),numberText(subject.maxOffsetM),numberText(subject.widthM),
        numberText(subject.directionalPassageWidthM),numberText(subject.transitPassageWidthM),
        edgeText(subject.minContributor),edgeText(subject.maxContributor),
        numberText(other.minOffsetM),numberText(other.maxOffsetM),numberText(other.widthM),
        numberText(other.directionalPassageWidthM),numberText(other.transitPassageWidthM),
        edgeText(other.minContributor),edgeText(other.maxContributor))

    publication:info("DIAGNOSTIC","CORRIDOR_BAND_PRIMITIVES_PROBE",
        "observation=%s operation=%s pair=%s|%s subjectStatus=%s subjectPrimitiveCount=%s subjectPrimitives=%s otherStatus=%s otherPrimitiveCount=%s otherPrimitives=%s decisionAuthority=false controlAuthority=false",
        valueText(observationSnapshotId),valueText(relationship.operationId),
        valueText(relationship.subjectAssemblyId),valueText(relationship.otherAssemblyId),
        valueText(subject.status),tostring(subject.contributorCount or 0),contributorsText(subject),
        valueText(other.status),tostring(other.contributorCount or 0),contributorsText(other))
    return true,"PUBLISHED"
end
