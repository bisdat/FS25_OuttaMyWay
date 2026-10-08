-- Regression for TEST 0.4.10.15: Shared Protected Demand composition must
-- not erase the exact Shared Category-2 incumbent allocation needed to observe
-- protected-participant native boundary-turn dissolution.
return function(test,equal)
    test("Shared Category-2 incumbent survives multi-subject composed Regulation ownership",function()
        local assessment=OuttaMyWay.BoundaryDemandAssessment.new()
        local identity="shared-category-2:OR-1:AS-P:AS-S"
        local requirement="shared-category-2-regulation:"..identity

        assessment.retained[identity]={
            relation={
                identity=identity,operationId="OR-1",fieldWorldReferenceKey="FW-1",
                classification="SHARED_CATEGORY_2_DEMAND",relationshipStatus="POSITIVE",
                subjectAssemblyId="AS-P",otherAssemblyId="AS-S",
                participants={
                    {
                        assemblyId="AS-P",assemblyReferenceKey="ref:AS-P",
                        terminatingBoundaryEdgeKey="EDGE-1",boundaryRingKind="OUTER_BOUNDARY",
                        boundaryRingIndex=1,boundaryDistanceM=20,boundaryInteractionReachM=5,
                        intentClassification="SETTLED_CONTINUATION",intentEpoch=10,intentValid=true
                    },
                    {
                        assemblyId="AS-S",assemblyReferenceKey="ref:AS-S",
                        terminatingBoundaryEdgeKey="EDGE-1",boundaryRingKind="OUTER_BOUNDARY",
                        boundaryRingIndex=1,boundaryDistanceM=18,boundaryInteractionReachM=5,
                        intentClassification="SETTLED_CONTINUATION",intentEpoch=10,intentValid=true
                    }
                },
                competingDemand=true,currentEvidenceState="SUPPORTED",
                regulationSpeedKmh=1,governingRequirementKey=requirement
            }
        }

        local result=assessment:assess({
            operationId="OR-1",fieldWorldReferenceKey="FW-1",fieldWorld={},
            projections={},physicalSpaceEvidence={},
            motionEvidence={
                {
                    assemblyId="AS-P",assemblyReferenceKey="ref:AS-P",
                    localIntentClassification="SETTLED_CONTINUATION",intentEpoch=11,intentValid=true
                },
                {
                    assemblyId="AS-S",assemblyReferenceKey="ref:AS-S",
                    localIntentClassification="TURNING",intentEpoch=11,intentValid=true
                }
            },
            commitmentContext={{
                commitmentId="CM-COMPOSED",
                governingBasis={responsibilityKey=requirement},
                -- Patriot owns the Category-2 1 km/h regulation while a second
                -- controlled follower has been composed into the same responsibility.
                progressActuationOwnership={
                    {assemblyId="AS-P"},
                    {assemblyId="AS-C"}
                },
                openObligations={{
                    basis={
                        kind="SHARED_CATEGORY_2_DEMAND_REGULATION",
                        conflictIdentity=identity,
                        regulatedAssemblyId="AS-P",
                        protectedAssemblyId="AS-S"
                    },
                    requiredOutcome={
                        kind="SHARED_CATEGORY_2_ORDERING_PRESERVED_UNTIL_BOUNDARY_TURN",
                        conflictIdentity=identity
                    }
                }}
            }}
        })

        equal(#result.sharedCategory2Demands,1)
        local relation=result.sharedCategory2Demands[1]
        equal(relation.identity,identity)
        equal(relation.incumbentRegulatedAssemblyId,"AS-P")
        equal(relation.incumbentProtectedAssemblyId,"AS-S")
        equal(relation.classification,"SHARED_CATEGORY_2_DEMAND_DISSOLVED_BY_BOUNDARY_TURN")
        equal(relation.currentEvidenceState,"POSITIVE_DISSOLUTION")
        equal(relation.positiveDissolution,true)
        equal(relation.boundaryTurnCompletion,true)
        equal(relation.reason,"PROTECTED_PARTICIPANT_BEGAN_NATIVE_BOUNDARY_TURN")
    end)
end
