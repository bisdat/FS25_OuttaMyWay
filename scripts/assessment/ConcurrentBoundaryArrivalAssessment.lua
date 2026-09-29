--- Interprets Category-2 Concurrent Boundary Arrival from current boundary-transition, physical-reach and native-timing evidence.
-- Specification Jurisdictions: `SITUATION_ASSESSMENT`
--
-- This module owns Situation meaning only. It predicts no GIANTS turn path,
-- chooses no temporal yielder and grants no Candidate, Responsibility,
-- Bounded Authority or Control permission.

OuttaMyWay.ConcurrentBoundaryArrivalAssessment={}
local Assessment=OuttaMyWay.ConcurrentBoundaryArrivalAssessment

local EPSILON_M=0.00001

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function distance(ax,az,bx,bz)
    local dx,dz=bx-ax,bz-az
    return math.sqrt(dx*dx+dz*dz)
end

local function physicalReach(physical,projection)
    if type(physical)~="table" or type(projection)~="table"
        or not finite(projection.currentX) or not finite(projection.currentZ) then return nil end
    local best=nil
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical.primitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(primitive.x) and finite(primitive.z)
            and finite(primitive.radius) and primitive.radius>=0 then
            local centreDistanceM=distance(projection.currentX,projection.currentZ,primitive.x,primitive.z)
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

local function sameBoundaryDomain(a,b)
    return a.boundaryRingKind==b.boundaryRingKind
        and tonumber(a.boundaryRingIndex)==tonumber(b.boundaryRingIndex)
end

local function participant(projection,reach,timeToBoundarySec)
    return {
        assemblyId=projection.assemblyId,
        assemblyReferenceKey=projection.assemblyReferenceKey,
        futureSpaceIdentity=projection.futureSpaceIdentity,
        terminatingBoundaryEdgeKey=projection.terminatingBoundaryEdge and projection.terminatingBoundaryEdge.edgeKey or nil,
        boundaryRingKind=projection.boundaryRingKind,
        boundaryRingIndex=projection.boundaryRingIndex,
        boundaryContact={x=projection.contactX,z=projection.contactZ},
        boundaryDistanceM=projection.boundaryDistanceM,
        nativeProgressRateMps=projection.progressRateMps,
        nativeProgressRateSource=projection.progressRateSource,
        timeToBoundarySec=timeToBoundarySec,
        physicalReachM=reach and reach.reachM or nil,
        physicalReachPrimitiveId=reach and reach.primitiveId or nil
    }
end

function Assessment.assessPair(input)
    input=input or {}
    local a,b=input.subjectProjection,input.otherProjection
    if type(a)~="table" or type(b)~="table" then return nil,"BOUNDARY_ARRIVAL_PROJECTIONS_REQUIRED" end
    local first,second=tostring(a.assemblyId),tostring(b.assemblyId)
    if second<first then first,second=second,first end
    local result={
        identity="concurrent-boundary-arrival:"..tostring(input.operationId)..":"..first..":"..second,
        operationId=input.operationId,
        fieldWorldReferenceKey=input.fieldWorldReferenceKey,
        subjectAssemblyId=a.assemblyId,otherAssemblyId=b.assemblyId,
        subjectReferenceKey=a.assemblyReferenceKey,otherReferenceKey=b.assemblyReferenceKey,
        classification="UNRESOLVED",relationshipStatus="UNRESOLVED",
        candidateSupportReady=false,decisionAuthority=false,controlAuthority=false,
        negativeClearanceAuthority=false,
        spatialOverlay="CATEGORY_2_HEADLAND_BOUNDARY",
        regulationSpeedKmh=tonumber(input.regulationSpeedKmh) or 1,
        provenance={source="ConcurrentBoundaryArrivalAssessment",layer="SITUATION_ASSESSMENT"}
    }

    if type(input.supersedingRelationship)=="table" then
        result.classification="CONCURRENT_BOUNDARY_ARRIVAL_SUPERSEDED"
        result.relationshipStatus="NEGATIVE"
        result.positiveSupersession=true
        result.supersedingRelationship=input.supersedingRelationship
        result.reason="STRONGER_CURRENT_SPATIAL_RELATIONSHIP_POSITIVELY_SUPERSEDES_BOUNDARY_ARRIVAL"
        return result,nil
    end

    if a.status~="SUPPORTED" or b.status~="SUPPORTED" then
        result.reason="BOUNDARY_ARRIVAL_EVIDENCE_TEMPORARILY_UNRESOLVED"
        return result,nil
    end
    if not sameBoundaryDomain(a,b) then
        result.classification="NO_CONCURRENT_BOUNDARY_ARRIVAL"
        result.relationshipStatus="NEGATIVE"
        result.positiveDissolution=true
        result.reason="BOUNDARY_TRANSITIONS_OCCUPY_DIFFERENT_FIELD_WORLD_BOUNDARY_DOMAINS"
        return result,nil
    end
    if not finite(a.contactX) or not finite(a.contactZ) or not finite(b.contactX) or not finite(b.contactZ)
        or not finite(a.boundaryDistanceM) or not finite(b.boundaryDistanceM) then
        result.reason="BOUNDARY_ARRIVAL_CONTACT_OR_DISTANCE_UNRESOLVED"
        return result,nil
    end
    if not finite(a.progressRateMps) or a.progressRateMps<=0
        or not finite(b.progressRateMps) or b.progressRateMps<=0 then
        result.reason="BOUNDARY_ARRIVAL_NATIVE_PROGRESS_OPPORTUNITY_UNRESOLVED"
        return result,nil
    end

    local aReach=physicalReach(input.subjectPhysicalSpace,a)
    local bReach=physicalReach(input.otherPhysicalSpace,b)
    if aReach==nil or bReach==nil then
        result.reason="BOUNDARY_ARRIVAL_CURRENT_PHYSICAL_REACH_UNRESOLVED"
        return result,nil
    end

    local contactDistanceM=distance(a.contactX,a.contactZ,b.contactX,b.contactZ)
    local localDemandReachM=aReach.reachM+bReach.reachM
    local aTime=a.boundaryDistanceM/a.progressRateMps
    local bTime=b.boundaryDistanceM/b.progressRateMps
    local arrivalDifferenceSec=math.abs(aTime-bTime)
    local aReachTraversalSec=aReach.reachM/a.progressRateMps
    local bReachTraversalSec=bReach.reachM/b.progressRateMps
    local overlapWindowSec=math.max(aReachTraversalSec,bReachTraversalSec)

    result.subject=participant(a,aReach,aTime)
    result.other=participant(b,bReach,bTime)
    result.boundaryContactDistanceM=contactDistanceM
    result.localDemandReachM=localDemandReachM
    result.arrivalDifferenceSec=arrivalDifferenceSec
    result.arrivalOverlapWindowSec=overlapWindowSec
    result.arrivalOverlapWindowBasis="MAX_CURRENT_PHYSICAL_REACH_TRAVERSAL_TIME_AT_NATIVE_PROGRESS"
    result.boundaryDomain={
        ringKind=a.boundaryRingKind,ringIndex=a.boundaryRingIndex,
        source="CURRENT_FIELD_WORLD_BOUNDED_TERMINATING_CONTACTS"
    }

    if contactDistanceM>localDemandReachM+EPSILON_M then
        result.classification="NO_CONCURRENT_BOUNDARY_ARRIVAL"
        result.relationshipStatus="NEGATIVE"
        result.positiveDissolution=true
        result.reason="BOUNDARY_CONTACTS_NOT_LOCALLY_COUPLED_BY_CURRENT_PHYSICAL_REACH"
        return result,nil
    end
    if arrivalDifferenceSec>overlapWindowSec+EPSILON_M then
        result.classification="NO_CONCURRENT_BOUNDARY_ARRIVAL"
        result.relationshipStatus="NEGATIVE"
        result.positiveDissolution=true
        result.reason="NATIVE_BOUNDARY_ARRIVAL_WINDOWS_DO_NOT_MATERIALLY_OVERLAP"
        return result,nil
    end

    result.classification="CONCURRENT_BOUNDARY_ARRIVAL"
    result.relationshipStatus="POSITIVE"
    result.candidateSupportReady=true
    result.reason="LOCAL_CATEGORY_2_BOUNDARY_DEMAND_HAS_OVERLAPPING_NATIVE_ARRIVAL_WINDOWS"
    return result,nil
end
