return function(test,equal)
    local function jobs()
        local episode={identity="JE-RMD",assemblyId="AS-BENEFICIARY",sourceJobToken="JOB-RMD",status="ACTIVE"}
        return {
            getActiveForAssembly=function(_,assemblyId)
                return assemblyId=="AS-BENEFICIARY" and episode or nil
            end,
            list=function() return {episode} end
        }
    end

    local function context(options)
        options=options or {}
        local commitments={}
        if options.owned==true then
            commitments={{
                identity="CM-RMD",state="ACTIVE",strategy={capability="REPOSITION"},
                progressActuationOwnership={{assemblyId="AS-BENEFICIARY",authorityTokenId="AU-RMD"}},
                obstructionRelocationActuationOwnership={}
            }}
        elseif options.relocationHold==true then
            commitments={{
                identity="CM-RELOCATION",state="WAITING_FOR_EVIDENCE",strategy={capability="REPOSITION"},
                progressActuationOwnership={{assemblyId="AS-BENEFICIARY",authorityTokenId="AU-HOLD"}},
                obstructionRelocationActuationOwnership={{assemblyId="AS-BLOCKER",authorityTokenId="AU-MOVE"}}
            }}
        end
        return {
            observationSnapshotId="OS-RMD",
            activeOperationMemberSet={["AS-BENEFICIARY"]=true},
            operationByAssembly={["AS-BENEFICIARY"]="OR-RMD"},
            jobEpisodes=jobs(),
            commitments=commitments,
            motionEvidence={{
                assemblyId="AS-BENEFICIARY",assemblyReferenceKey="vehicle-root:beneficiary",
                sourceJobToken="JOB-RMD",positionDerivedSpeedMps=4,
                travelDirectionX=1,travelDirectionZ=0,
                motionClassification="STABLE_FORWARD",localIntentClassification="TURNING"
            }},
            trajectoryKnowledge={{
                assemblyId="AS-BENEFICIARY",assemblyReferenceKey="vehicle-root:beneficiary",
                jobToken="JOB-RMD",established=true,
                establishedDirectionX=1,establishedDirectionZ=0,
                currentExcursion=options.excursion==true,
                currentAlignedDistanceM=options.alignedDistanceM or 120,
                contextProductivePositive=false,
                provenance={source="TrajectoryConflictAssessment"}
            }},
            physicalSpaceEvidence={{
                assemblyId="AS-BENEFICIARY",assemblyReferenceKey="vehicle-root:beneficiary",
                primitives={{identity="BENEFICIARY-DISC",kind="DISC",x=0,z=0,radius=1,positiveConflictSupport=true}}
            }}
        }
    end

    test("Realised Motion Demand is positive during TURNING semantic intent when realised trajectory is stable",function()
        local records=OuttaMyWay.RealisedMotionDemandAssessment.build(context())
        equal(#records,1)
        local record=records[1]
        equal(record.beneficiaryAssemblyId,"AS-BENEFICIARY")
        equal(record.jobEpisodeId,"JE-RMD")
        equal(record.localIntentClassification,"TURNING")
        equal(record.productiveContextPositive,false)
        equal(record.realisedMotionReachM,100)
        equal(record.horizonM,100)
        equal(record.currentAlignedDistanceM,120)
        equal(record.claimLimits.futureRouteAuthority,false)
        equal(record.claimLimits.negativeClearanceAuthority,false)
        equal(#record.physicalDemandSweeps,1)
        equal(record.physicalDemandSweeps[1].startX,0)
        equal(record.physicalDemandSweeps[1].endX,100)
    end)

    test("Realised Motion Reach is bounded by fresh aligned persistence after trajectory supersession",function()
        local records=OuttaMyWay.RealisedMotionDemandAssessment.build(context({alignedDistanceM=5}))
        equal(#records,1)
        local record=records[1]
        equal(record.realisedMotionReachM,5)
        equal(record.horizonM,5)
        equal(record.currentAlignedDistanceM,5)
        equal(record.physicalDemandSweeps[1].endX,5)
        equal(record.provenance.reachBasis,"CURRENT_ALIGNED_DISTANCE_M")
    end)

    test("Realised Motion Demand fails closed during current trajectory excursion",function()
        local records=OuttaMyWay.RealisedMotionDemandAssessment.build(context({excursion=true}))
        equal(#records,0)
    end)

    test("Realised Motion Demand fails closed while OMW owns beneficiary progress actuation",function()
        local records=OuttaMyWay.RealisedMotionDemandAssessment.build(context({owned=true}))
        equal(#records,0)
    end)

    test("Retained Obstruction Relocation beneficiary authority does not masquerade as current movement ownership",function()
        local records=OuttaMyWay.RealisedMotionDemandAssessment.build(context({relocationHold=true}))
        equal(#records,1)
        equal(records[1].beneficiaryAssemblyId,"AS-BENEFICIARY")
    end)

    local function obstructionFixture(blockerZ,future,alignedDistanceM)
        local rmd=OuttaMyWay.RealisedMotionDemandAssessment.build(context({alignedDistanceM=alignedDistanceM}))
        local snapshot={
            assemblies={
                {assemblyId="AS-BENEFICIARY",referenceKey="vehicle-root:beneficiary"},
                {assemblyId="AS-BLOCKER",referenceKey="vehicle-root:blocker"}
            },
            aiStates={
                ["vehicle-root:beneficiary"]={aiActive=true,aiActiveObserved=true,observedActive=true},
                ["vehicle-root:blocker"]={aiActive=false,aiActiveObserved=true,observedActive=false}
            },
            playerControl={
                ["vehicle-root:blocker"]={playerEntered=false,playerEnteredObserved=true}
            }
        }
        local physical={
            {assemblyId="AS-BENEFICIARY",assemblyReferenceKey="vehicle-root:beneficiary",
                primitives={{identity="BENEFICIARY-DISC",kind="DISC",x=0,z=0,radius=1,positiveConflictSupport=true}}},
            {assemblyId="AS-BLOCKER",assemblyReferenceKey="vehicle-root:blocker",
                primitives={{identity="BLOCKER-DISC",kind="DISC",x=50,z=blockerZ or 0,radius=1,positiveConflictSupport=true}}}
        }
        local assessment=OuttaMyWay.CausalObstructionAssessment.new(jobs())
        local futureSpace={{assemblyId="AS-BENEFICIARY",alternatives=future and {{startX=0,startZ=0,endX=100,endZ=0}} or {}}}
        return assessment:assess(
            snapshot,futureSpace,physical,
            {["AS-BENEFICIARY"]=true},
            {["AS-BENEFICIARY"]="OR-RMD"},
            rmd
        )
    end

    test("Causal Obstruction consumes Realised Motion Demand when prospective continuation is unavailable",function()
        local records=obstructionFixture(0,false)
        equal(#records,1)
        equal(records[1].blockerClassification,"NON_ACTIVE_UNCLAIMED")
        equal(records[1].relocationEligible,true)
        equal(records[1].obstructionEvidence.kind,"REALISED_MOTION_DEMAND")
        equal(records[1].obstructionEvidence.witnessDistanceM,48)
        equal(records[1].obstructionEvidence.estimatedTimeToWitnessSeconds,12)
        equal(records[1].obstructionEvidence.futureRouteAuthority,false)
    end)

    test("Fresh superseded trajectory does not project causal demand beyond supported Reach",function()
        local records=obstructionFixture(0,false,5)
        equal(#records,0)
    end)

    test("Existing future-space obstruction basis retains precedence over Realised Motion Demand",function()
        local records=obstructionFixture(0,true)
        equal(#records,1)
        equal(records[1].obstructionEvidence.kind,"CONTINUING_ACTIVE_FUTURE_SPACE")
    end)

    test("Non-active physical presence outside Realised Motion Demand corridor remains non-causal",function()
        local records=obstructionFixture(10,false)
        equal(#records,0)
    end)
end
