-- Diagnostic-only feature-relative Corner Arrival probe.
return function(test,equal)
    local Probe=OuttaMyWay.CornerArrivalFeatureProbe

    local function picture(terminalX,terminalZ,radius)
        return {
            physicalSpaceEvidence={{
                assemblyId="AS-A",
                primitives={{
                    identity="DISC-A",kind="DISC",positiveConflictSupport=true,
                    x=0,z=0,radius=radius
                }}
            }},
            spatialConstraintKnowledge={{
                operationId="OR-1",
                boundaryTransitionProjections={{
                    assemblyId="AS-A",assemblyReferenceKey="REF-A",status="SUPPORTED",
                    boundaryRingKind="OUTER_BOUNDARY",boundaryRingIndex=1,
                    currentX=0,currentZ=0,headingX=1,headingZ=0,
                    contactX=terminalX,contactZ=terminalZ,boundaryDistanceM=terminalX
                }},
                cornerKnowledge={atlasEntries={{
                    cornerKey="C1",ringKind="OUTER_BOUNDARY",ringIndex=1,
                    representativePoint={x=100,z=0},
                    supportBefore={x=100,z=-100},
                    supportAfter={x=0,z=0}
                }}}
            }}
        }
    end

    test("Corner Arrival Feature Probe: terminal physical claim consuming both structural supports is positive diagnostic evidence",function()
        local result=Probe.evaluate(picture(95,-5,8))
        equal(#result,1)
        equal(result[1].outcome,"TERMINAL_PHYSICAL_ASSEMBLY_CONSUMES_BOTH_STRUCTURAL_SUPPORTS")
        equal(result[1].consumesSupportBefore,true)
        equal(result[1].consumesSupportAfter,true)
        equal(result[1].semanticAuthority,false)
        equal(result[1].decisionAuthority,false)
        equal(result[1].controlAuthority,false)
    end)

    test("Corner Arrival Feature Probe: one incident support alone does not become dual-support evidence",function()
        local result=Probe.evaluate(picture(100,-50,5))
        equal(#result,1)
        equal(result[1].outcome,"TERMINAL_PHYSICAL_ASSEMBLY_CONSUMES_ONE_STRUCTURAL_SUPPORT")
        equal(result[1].consumesSupportBefore,true)
        equal(result[1].consumesSupportAfter,false)
    end)

    test("Corner Arrival Feature Probe: unrelated terminal claim remains absent",function()
        local result=Probe.evaluate(picture(50,-50,2))
        equal(#result,0)
    end)
end
