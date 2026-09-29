return function(test,equal)
    local function projection(id,x,z,contactX,contactZ,boundaryDistance,rate)
        return {
            assemblyId=id,assemblyReferenceKey="vehicle-root:"..id,status="SUPPORTED",
            currentX=x,currentZ=z,contactX=contactX,contactZ=contactZ,
            boundaryDistanceM=boundaryDistance,boundaryRingKind="OUTER_BOUNDARY",boundaryRingIndex=1,
            terminatingBoundaryEdge={edgeKey="OUTER_BOUNDARY:1:EDGE:1"},
            futureSpaceIdentity="FS-"..id,progressRateMps=rate,progressRateSource="GIANTS_IMMEDIATE_NATIVE_MAX_SPEED"
        }
    end

    local function physical(id,x,z,radius)
        return {
            assemblyId=id,
            primitives={{identity="disc-"..id,kind="DISC",x=x,z=z,radius=radius,positiveConflictSupport=true}}
        }
    end

    test("Concurrent Boundary Arrival supports parallel local boundary demand without Forward Intersection",function()
        local a=projection("AS-A",0,0,0,20,20,4)
        local b=projection("AS-B",10,0,10,19,19,4)
        local result=assert(OuttaMyWay.ConcurrentBoundaryArrivalAssessment.assessPair({
            operationId="OR-1",fieldWorldReferenceKey="FW-1",subjectProjection=a,otherProjection=b,
            subjectPhysicalSpace=physical("AS-A",0,0,6),otherPhysicalSpace=physical("AS-B",10,0,6),
            regulationSpeedKmh=1
        }))
        equal(result.classification,"CONCURRENT_BOUNDARY_ARRIVAL")
        equal(result.relationshipStatus,"POSITIVE")
        equal(result.candidateSupportReady,true)
        equal(result.spatialOverlay,"CATEGORY_2_HEADLAND_BOUNDARY")
        equal(result.regulationSpeedKmh,1)
        equal(result.negativeClearanceAuthority,false)
    end)

    test("Concurrent Boundary Arrival rejects unrelated distant contacts on the same boundary",function()
        local a=projection("AS-A",0,0,0,20,20,4)
        local b=projection("AS-B",30,0,30,20,20,4)
        local result=assert(OuttaMyWay.ConcurrentBoundaryArrivalAssessment.assessPair({
            operationId="OR-1",fieldWorldReferenceKey="FW-1",subjectProjection=a,otherProjection=b,
            subjectPhysicalSpace=physical("AS-A",0,0,5),otherPhysicalSpace=physical("AS-B",30,0,5)
        }))
        equal(result.classification,"NO_CONCURRENT_BOUNDARY_ARRIVAL")
        equal(result.relationshipStatus,"NEGATIVE")
        equal(result.reason,"BOUNDARY_CONTACTS_NOT_LOCALLY_COUPLED_BY_CURRENT_PHYSICAL_REACH")
    end)

    test("Concurrent Boundary Arrival rejects materially separated native arrival windows",function()
        local a=projection("AS-A",0,0,0,20,20,4)
        local b=projection("AS-B",8,0,8,20,80,4)
        local result=assert(OuttaMyWay.ConcurrentBoundaryArrivalAssessment.assessPair({
            operationId="OR-1",fieldWorldReferenceKey="FW-1",subjectProjection=a,otherProjection=b,
            subjectPhysicalSpace=physical("AS-A",0,0,5),otherPhysicalSpace=physical("AS-B",8,0,5)
        }))
        equal(result.classification,"NO_CONCURRENT_BOUNDARY_ARRIVAL")
        equal(result.relationshipStatus,"NEGATIVE")
        equal(result.reason,"NATIVE_BOUNDARY_ARRIVAL_WINDOWS_DO_NOT_MATERIALLY_OVERLAP")
    end)

    test("Concurrent Boundary Arrival becomes unresolved when protected A8 is temporarily unavailable",function()
        local a=projection("AS-A",0,0,0,20,20,4)
        local b=projection("AS-B",8,0,8,20,20,4)
        b.status="UNRESOLVED"
        local result=assert(OuttaMyWay.ConcurrentBoundaryArrivalAssessment.assessPair({
            operationId="OR-1",fieldWorldReferenceKey="FW-1",subjectProjection=a,otherProjection=b,
            subjectPhysicalSpace=physical("AS-A",0,0,5),otherPhysicalSpace=physical("AS-B",8,0,5)
        }))
        equal(result.classification,"UNRESOLVED")
        equal(result.relationshipStatus,"UNRESOLVED")
        equal(result.reason,"BOUNDARY_ARRIVAL_EVIDENCE_TEMPORARILY_UNRESOLVED")
    end)

    test("Concurrent Boundary Arrival Decision protects earlier native arrival and regulates later arrival",function()
        local picture=OuttaMyWay.OperationalPicture.new({
            identity="PI-CBA",epoch=1,observationSnapshotId="OS-CBA",
            situations={},currentPairAssessmentScope={},identities={},currentSpace={},futureSpace={},
            demand={committedDemand={},potentialDemand={},temporarySlack={}},
            responsibilityRelations={},uncertainty={},representationFitness={},provenance={},
            controlOutcomeEvidence={},candidateSupportEvidence={},commitmentContext={}
        })
        local requirement="concurrent-boundary-arrival-regulation:CBA-1"
        local inventory=OuttaMyWay.CandidateInventory.new({
            identity="CI-CBA",epoch=1,operationalPictureId=picture.identity,
            candidateIds={"CA-REGULATE-DEERE","CA-REGULATE-MT"},
            complete=true,
            supportBoundary={decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=requirement}},
            provenance={}
        })
        local function candidate(id,regulatedId,regulatedTime,protectedId,protectedTime)
            return {
                identity=id,capability="REGULATE_SPEED",comparisonCost=0,
                evidenceBasis={trafficPolicemanPreference={
                    primaryResolution=true,governingRequirementKey=requirement,
                    exhaustionEvidence={CONTINUE_OBSERVATION={
                        result="PASS",operationalPictureId=picture.identity,
                        governingRequirementKey=requirement,capability="CONTINUE_OBSERVATION"
                    }},
                    concurrentBoundaryArrival={
                        situationIdentity="CBA-1",
                        regulatedParticipant={assemblyId=regulatedId,timeToBoundarySec=regulatedTime},
                        protectedParticipant={assemblyId=protectedId,timeToBoundarySec=protectedTime}
                    }
                }}
            }
        end
        local regulateDeere=candidate("CA-REGULATE-DEERE","AS-DEERE",8.93,"AS-MT",8.65)
        local regulateMt=candidate("CA-REGULATE-MT","AS-MT",8.65,"AS-DEERE",8.93)
        local result=OuttaMyWay.TrafficPolicemanDecisionPolicy:select(
            picture,inventory,{regulateDeere,regulateMt})
        equal(result.selected.identity,"CA-REGULATE-DEERE")
        equal(result.rule,"CONCURRENT_BOUNDARY_ARRIVAL:PROTECT_EARLIER_NATIVE_BOUNDARY_ARRIVAL")
    end)

    test("Concurrent Boundary Arrival current responsibility waits for evidence and requires positive terminal evidence",function()
        local runtime=OuttaMyWay.Runtime.new()
        local unresolved={
            identity="concurrent-boundary-arrival:OR-1:AS-A:AS-B",
            classification="UNRESOLVED",relationshipStatus="UNRESOLVED",
            reason="BOUNDARY_ARRIVAL_EVIDENCE_TEMPORARILY_UNRESOLVED"
        }
        local assessment=runtime.currentResponsibilityAssessment:assessActionSpaceRegulation(
            {provenance={admissionKind="CONCURRENT_BOUNDARY_ARRIVAL"}},unresolved)
        equal(assessment.disposition,"PERSIST")
        equal(assessment.evidenceState,"WAITING_FOR_EVIDENCE")

        local dissolved={
            identity=unresolved.identity,classification="NO_CONCURRENT_BOUNDARY_ARRIVAL",
            relationshipStatus="NEGATIVE",positiveDissolution=true,
            reason="NATIVE_BOUNDARY_ARRIVAL_WINDOWS_DO_NOT_MATERIALLY_OVERLAP"
        }
        local ended=runtime.currentResponsibilityAssessment:assessActionSpaceRegulation(
            {provenance={admissionKind="CONCURRENT_BOUNDARY_ARRIVAL"}},dissolved)
        equal(ended.disposition,"TERMINATE")
        equal(ended.terminationEvidenceKind,"CONCURRENT_BOUNDARY_ARRIVAL_POSITIVE_DISSOLUTION")
    end)
end
