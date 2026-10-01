return function(test,equal)
    local function pictureWithRecovery(contexts,physicalSpaceEvidence,causalObstructionKnowledge,situations,motionEvidence)
        return OuttaMyWay.OperationalPicture.new({
            identity="PI-RECOVERY",epoch=101,observationSnapshotId="OS-RECOVERY",
            situations=situations or {},currentPairAssessmentScope={},identities={},currentSpace={},futureSpace={},
            demand={committedDemand={},potentialDemand={},temporarySlack={}},
            responsibilityRelations={},uncertainty={},representationFitness={},provenance={source="BlockedWorkerRecoveryTest"},
            motionEvidence=motionEvidence or {},
            physicalSpaceEvidence=physicalSpaceEvidence or {{
                assemblyId="AS-RECOVERY",assemblyReferenceKey="vehicle-root:recovery",
                configurationProfileId="CFG-WORKING",
                primitives={{kind="DISC"}},
                summary={physicalPrimitiveCount=1},
                coverageComplete=false,negativeClearanceAuthority=false,
                provenance={source="BlockedWorkerRecoveryTest"}
            }},
            controlOutcomeEvidence={},candidateSupportEvidence={},commitmentContext=contexts or {},
            causalObstructionKnowledge=causalObstructionKnowledge or {},
            blockedProgressKnowledge={{
                assemblyId="AS-RECOVERY",assemblyReferenceKey="vehicle-root:recovery",
                jobEpisodeId="JE-RECOVERY",sourceJobToken="JOB-RECOVERY",operationId="OR-RECOVERY",
                status="BLOCKED_PROGRESS_STALL",blockedProgressStall=true,
                stallEvidence={establishedAtObservationSnapshotId="OS-STALL",establishedAtTimestamp=10,poseX=10,poseZ=20,collapseObservedSeconds=1.25},
                recoveryAnchor={
                    observationSnapshotId="OS-ANCHOR",timestamp=1,
                    poseX=4.25,poseZ=17.5,travelDirectionX=1,travelDirectionZ=0,
                    travelPolarity="FORWARD",motionClassification="TURNING",
                    configurationProfileId="CFG-WORKING",sourceJobToken="JOB-RECOVERY",
                    usefulSpanM=5.61,minimumUsefulSpanM=5.0
                }
            }}
        })
    end

    local function snapshot()
        return OuttaMyWay.ObservationSnapshot.new({
            identity="OS-RECOVERY",epoch=100,timestamp=10,provenance={source="test"},
            fieldWorld={},assemblies={},geometry={},motion={},aiStates={},playerControl={},
            jobEpisodeEvidence={},operationMembershipEvidence={},physicalRepresentationEvidence={},
            controlOutcomes={},unavailableSources={}
        })
    end

    test("Current Recovery suppresses duplicate admission from stale Stall knowledge",function()
        local support=OuttaMyWay.BlockedWorkerRecoveryCandidateSupport.new()
        local key="blocked-worker-recovery:OR-RECOVERY:AS-RECOVERY:JE-RECOVERY"
        local group,reason=support:buildFreshProjectedGroup(
            pictureWithRecovery({{commitmentId="CM-RECOVERY",governingBasis={kind="BLOCKED_WORKER_RECOVERY",responsibilityKey=key}}}),
            snapshot(),"PI-RECOVERY-TARGET",102)
        equal(group,nil)
        equal(reason,"RECOVERY_ALREADY_CURRENT")
    end)

    test("Sealed correlated successor Stall knowledge exhausts Recovery strategy before Candidate admission",function()
        local recurrence=OuttaMyWay.BlockedWorkerRecoveryRecurrenceAssessment.new()
        local recorded,recordReason=recurrence:recordSuccessfulRecovery({
            assemblyId="AS-RECOVERY",recoveryKey="blocked-worker-recovery:OR-RECOVERY:AS-RECOVERY:JE-RECOVERY",
            stallTimestamp=10,stallX=10,stallZ=20,
            successorJobEpisodeId="JE-SUCCESSOR",successorSourceJobToken="JOB-SUCCESSOR"
        })
        equal(recorded,true,recordReason)

        local freshKnowledge={
            assemblyId="AS-RECOVERY",assemblyReferenceKey="vehicle-root:recovery",
            jobEpisodeId="JE-SUCCESSOR",sourceJobToken="JOB-SUCCESSOR",operationId="OR-RECOVERY",
            status="BLOCKED_PROGRESS_STALL",blockedProgressStall=true,
            stallEvidence={
                establishedAtObservationSnapshotId="OS-STALL-SUCCESSOR",establishedAtTimestamp=36,
                poseX=10.4,poseZ=20.1,collapseObservedSeconds=1.25
            },
            recoveryAnchor={
                observationSnapshotId="OS-ANCHOR-SUCCESSOR",timestamp=34,
                poseX=4.4,poseZ=17.6,travelDirectionX=1,travelDirectionZ=0,
                travelPolarity="FORWARD",motionClassification="STABLE_FORWARD",
                configurationProfileId="CFG-WORKING",sourceJobToken="JOB-SUCCESSOR",
                usefulSpanM=6.5,minimumUsefulSpanM=5.0
            }
        }
        local result=recurrence:assess(freshKnowledge)
        equal(result.correlated,true)
        equal(result.status,"RECOVERY_STRATEGY_EXHAUSTED")
        equal(result.successorJobEpisodeId,"JE-SUCCESSOR")
        equal(result.separationM<5,true)
        equal(result.elapsedSeconds,26)

        local picture=OuttaMyWay.OperationalPicture.new({
            identity="PI-RECOVERY-RECURRENCE",epoch=101,observationSnapshotId="OS-RECOVERY-RECURRENCE",
            situations={},currentPairAssessmentScope={},identities={},currentSpace={},futureSpace={},
            demand={committedDemand={},potentialDemand={},temporarySlack={}},
            responsibilityRelations={},uncertainty={},representationFitness={},provenance={source="BlockedWorkerRecoveryTest"},
            physicalSpaceEvidence={{
                assemblyId="AS-RECOVERY",assemblyReferenceKey="vehicle-root:recovery",
                configurationProfileId="CFG-WORKING",
                primitives={{kind="DISC"}},summary={physicalPrimitiveCount=1},
                coverageComplete=false,negativeClearanceAuthority=false,
                provenance={source="BlockedWorkerRecoveryTest"}
            }},
            controlOutcomeEvidence={},candidateSupportEvidence={},commitmentContext={},
            blockedProgressKnowledge={freshKnowledge},
            blockedWorkerRecoveryRecurrenceKnowledge={result}
        })
        local support=OuttaMyWay.BlockedWorkerRecoveryCandidateSupport.new()
        local group,reason=support:buildFreshProjectedGroup(
            picture,snapshot(),"PI-RECOVERY-RECURRENCE-TARGET",102)
        equal(group,nil)
        equal(reason,"RECOVERY_STRATEGY_EXHAUSTED")
        equal(support:getLastRecurrence().status,"RECOVERY_STRATEGY_EXHAUSTED")
    end)

    test("Recurrence correlation does not veto a fresh Stall outside the accepted bounds",function()
        local recurrence=OuttaMyWay.BlockedWorkerRecoveryRecurrenceAssessment.new()
        equal(recurrence:recordSuccessfulRecovery({
            assemblyId="AS-RECOVERY",stallTimestamp=10,stallX=10,stallZ=20,
            successorJobEpisodeId="JE-SUCCESSOR",successorSourceJobToken="JOB-SUCCESSOR"
        }),true)
        local result=recurrence:assess({
            assemblyId="AS-RECOVERY",jobEpisodeId="JE-SUCCESSOR",sourceJobToken="JOB-SUCCESSOR",
            blockedProgressStall=true,
            stallEvidence={establishedAtObservationSnapshotId="OS-OTHER",establishedAtTimestamp=30,poseX=16,poseZ=20}
        })
        equal(result.correlated,false)
        equal(result.status,"OUTSIDE_CORRELATION_RADIUS")
    end)

    test("Recovery Candidate derives an Anchor-bounded Recovery Return Region",function()
        local support=OuttaMyWay.BlockedWorkerRecoveryCandidateSupport.new()
        local group,reason=support:buildFreshProjectedGroup(
            pictureWithRecovery(),snapshot(),"PI-RECOVERY-TARGET",102)
        if group==nil then error(reason or "Recovery group missing") end
        equal(group.supportBoundary.mode,"BLOCKED_WORKER_RECOVERY")
        equal(#group.candidateSpecifications,1)
        local candidate=group.candidateSpecifications[1]
        equal(candidate.capability,"REPOSITION")
        equal(candidate.expectedEffect.recoveryCompletion,"RECOVERY_RETURN_REGION")
        equal(candidate.expectedEffect.transitRequested,true)
        equal(candidate.expectedEffect.nativeJobReplacement,true)
        equal(candidate.expectedEffect.physicalReleaseAfterReplacementStart,true)
        equal(#candidate.obligationsCreated,2)
        equal(candidate.obligationsCreated[1].requiredOutcome.kind,"BLOCKED_WORKER_RECOVERY_RETURN_REGION_REACHED_IN_TRANSIT")
        equal(candidate.obligationsCreated[2].requiredOutcome.kind,"BLOCKED_WORKER_RECOVERY_SUCCESSOR_JOB_EPISODE_ADMITTED")
        equal(candidate.evidenceBasis.independentConcurrentCommitment,true)
        equal(#candidate.representationFitness.requirements,1)
        equal(#group.representationFitness,1)
        equal(group.representationFitness[1].state,"FIT_FOR_LIMITED_HORIZON")
        equal(group.representationFitness[1].claimPermissions[1],"BLOCKED_WORKER_RECOVERY_LOCAL_RETURN_REFERENCE")
        equal(candidate.representationFitness.requirements[1].representationId,group.representationFitness[1].representationId)
        local verdict=OuttaMyWay.RepresentationFitnessConstraint.evaluate(candidate,{
            identity="PI-RECOVERY-TARGET",representationFitness=group.representationFitness
        })
        equal(verdict.result,"PASS")
        local bridge=candidate.evidenceBasis.blockedWorkerRecoveryBridge
        local anchor=bridge.recoveryAnchor
        equal(anchor.x,4.25); equal(anchor.z,17.5)
        equal(anchor.usefulSpanM,5.61)
        local region=bridge.recoveryReturnRegion
        equal(region.stallX,10); equal(region.stallZ,20)
        equal(region.calibratedTargetRetreatM,20)
        equal(region.cappedByAnchor,true)
        equal(math.abs(region.maximumSupportedRetreatM-math.sqrt(39.3125))<0.0001,true)
        equal(math.abs(region.requiredRetreatM-region.maximumSupportedRetreatM)<0.0001,true)
    end)

    test("Recovery Return Region uses full twenty metre calibration when Anchor permits it",function()
        local picture=OuttaMyWay.OperationalPicture.new({
            identity="PI-RECOVERY-LONG",epoch=101,observationSnapshotId="OS-RECOVERY",
            situations={},currentPairAssessmentScope={},identities={},currentSpace={},futureSpace={},
            demand={committedDemand={},potentialDemand={},temporarySlack={}},
            responsibilityRelations={},uncertainty={},representationFitness={},provenance={source="BlockedWorkerRecoveryTest"},
            physicalSpaceEvidence={{
                assemblyId="AS-RECOVERY",assemblyReferenceKey="vehicle-root:recovery",
                configurationProfileId="CFG-WORKING",
                primitives={{kind="DISC"}},summary={physicalPrimitiveCount=1},
                coverageComplete=false,negativeClearanceAuthority=false,
                provenance={source="BlockedWorkerRecoveryTest"}
            }},
            controlOutcomeEvidence={},candidateSupportEvidence={},commitmentContext={},
            blockedProgressKnowledge={{
                assemblyId="AS-RECOVERY",assemblyReferenceKey="vehicle-root:recovery",
                jobEpisodeId="JE-RECOVERY",sourceJobToken="JOB-RECOVERY",operationId="OR-RECOVERY",
                status="BLOCKED_PROGRESS_STALL",blockedProgressStall=true,
                stallEvidence={establishedAtObservationSnapshotId="OS-STALL",establishedAtTimestamp=10,poseX=30,poseZ=0,collapseObservedSeconds=1.25},
                recoveryAnchor={
                    observationSnapshotId="OS-ANCHOR",timestamp=1,
                    poseX=0,poseZ=0,travelDirectionX=1,travelDirectionZ=0,
                    travelPolarity="FORWARD",motionClassification="STABLE_FORWARD",
                    configurationProfileId="CFG-WORKING",sourceJobToken="JOB-RECOVERY",
                    usefulSpanM=30,minimumUsefulSpanM=5.0
                }
            }}
        })
        local support=OuttaMyWay.BlockedWorkerRecoveryCandidateSupport.new()
        local group,reason=support:buildFreshProjectedGroup(
            picture,snapshot(),"PI-RECOVERY-LONG-TARGET",102)
        if group==nil then error(reason or "Recovery group missing") end
        local region=group.candidateSpecifications[1].evidenceBasis.blockedWorkerRecoveryBridge.recoveryReturnRegion
        equal(region.calibratedTargetRetreatM,20)
        equal(region.requiredRetreatM,20)
        equal(region.maximumSupportedRetreatM,30)
        equal(region.cappedByAnchor,false)
        equal(region.directionX,-1)
        equal(region.directionZ,0)
    end)

    test("Recovery Resolution semantic preflight recognises both two-phase obligations",function()
        local support=OuttaMyWay.BlockedWorkerRecoveryCandidateSupport.new()
        local group,reason=support:buildFreshProjectedGroup(
            pictureWithRecovery(),snapshot(),"PI-RECOVERY-TARGET",102)
        if group==nil then error(reason or "Recovery group missing") end
        local candidate=group.candidateSpecifications[1]

        local preflight,preflightReason=OuttaMyWay.ResolutionCommitmentAdapter.preflightCandidate(candidate,{
            source="BlockedWorkerRecoveryResponsibilityTransition",
            purpose=candidate.purpose,
            beneficiaryAssemblyIds={"AS-RECOVERY"},
            controlledSubjectAssemblyIds={"AS-RECOVERY"},
            resolutionOutcomeKinds={
                "BLOCKED_WORKER_RECOVERY_RETURN_REGION_REACHED_IN_TRANSIT",
                "BLOCKED_WORKER_RECOVERY_SUCCESSOR_JOB_EPISODE_ADMITTED"
            },
            responsibilityIdentity="RS-RECOVERY"
        })
        if preflight==nil then error(preflightReason or "Recovery semantic preflight failed") end
        equal(preflight.matchingCandidateObligationCount,2)

        local rejected,rejectedReason=OuttaMyWay.ResolutionCommitmentAdapter.preflightCandidate(candidate,{
            source="BlockedWorkerRecoveryResponsibilityTransition",
            purpose=candidate.purpose,
            beneficiaryAssemblyIds={"AS-RECOVERY"},
            controlledSubjectAssemblyIds={"AS-RECOVERY"},
            resolutionOutcomeKinds={"BLOCKED_WORKER_RECOVERY_RESTORED_AND_HANDED_BACK"},
            responsibilityIdentity="RS-RECOVERY"
        })
        equal(rejected,nil)
        equal(rejectedReason,"INCOMPATIBLE_RESOLUTION_OBLIGATION_SEMANTICS")
    end)

    test("Recovery Representation Fitness fails closed when current configuration no longer matches the Anchor",function()
        local support=OuttaMyWay.BlockedWorkerRecoveryCandidateSupport.new()
        local picture=pictureWithRecovery(nil,{{
            assemblyId="AS-RECOVERY",assemblyReferenceKey="vehicle-root:recovery",
            configurationProfileId="CFG-OTHER",
            primitives={{kind="DISC"}},summary={physicalPrimitiveCount=1},
            coverageComplete=false,negativeClearanceAuthority=false,
            provenance={source="BlockedWorkerRecoveryTest"}
        }})
        local group,reason=support:buildFreshProjectedGroup(
            picture,snapshot(),"PI-RECOVERY-TARGET",102)
        if group==nil then error(reason or "Recovery group missing") end
        equal(group.representationFitness[1].state,"REFRESH_REQUIRED")
        local candidate=group.candidateSpecifications[1]
        local verdict=OuttaMyWay.RepresentationFitnessConstraint.evaluate(candidate,{
            identity="PI-RECOVERY-TARGET",representationFitness=group.representationFitness
        })
        equal(verdict.result,"UNRESOLVED")
    end)

    test("Recovery portfolio admits one unambiguous Recovery beside retained context",function()
        local support=OuttaMyWay.BlockedWorkerRecoveryCandidateSupport.new()
        local group=support:buildFreshProjectedGroup(
            pictureWithRecovery(),snapshot(),"PI-RECOVERY-TARGET",102)
        local spec=group.candidateSpecifications[1]
        spec.evidenceBasis.candidateSupportGroup={groupKey="blocked-worker-recovery",family="RECOVERY"}
        local candidate={identity="CA-RECOVERY",evidenceBasis=spec.evidenceBasis}
        local retainedCandidate={identity="CA-RETAINED",evidenceBasis={
            candidateSupportGroup={groupKey="retained-regulation",family="FOLLOWER"}
        }}
        local inventory={
            supportBoundary={mode="PROSPECTIVE_DECISION_PORTFOLIO",groups={
                {groupKey="retained-regulation",family="FOLLOWER",existingCommitmentId="CM-REGULATION"},
                {groupKey="blocked-worker-recovery",family="RECOVERY"}
            }}
        }
        local selected,reason=OuttaMyWay.ProspectivePortfolioDecisionPolicy:selectGroup(inventory,{candidate,retainedCandidate})
        if selected==nil then error(reason or "Recovery group not selected") end
        equal(selected.groupKey,"blocked-worker-recovery")
        equal(selected.rule,"BLOCKED_WORKER_RECOVERY_ESTABLISHMENT")
    end)

    test("Recovery Control enters Return Region before Anchor, replaces native job, releases physically, then settles on successor admission",function()
        local oldMission,oldTranslation=g_currentMission,getWorldTranslation
        local calls={}
        local currentJob={jobId=41}
        local replacement={jobId=nil}
        local currentEpisode={identity="JE-RECOVERY",sourceJobToken="JOB-RECOVERY"}
        local poseX=30
        local vehicle={name="Condor",rootNode=21001}
        vehicle.getAISteeringNode=function(self) return self.rootNode end
        vehicle.getJob=function() return currentJob end
        vehicle.getAIJobFarmId=function() return 7 end
        getWorldTranslation=function(node)
            equal(node,21001)
            return poseX,0,0
        end

        function replacement:applyCurrentState(v,mission,farmId,isDirectStart)
            calls[#calls+1]={kind="APPLY",vehicle=v,mission=mission,farmId=farmId,directStart=isDirectStart}
        end
        function replacement:setValues() calls[#calls+1]={kind="SET_VALUES"} end
        function replacement:validate(farmId)
            calls[#calls+1]={kind="VALIDATE",farmId=farmId}
            return true,nil
        end
        function replacement:delete() calls[#calls+1]={kind="DELETE"} end

        local manager={
            getJobTypeIndexByName=function(_,name) equal(name,"FIELDWORK"); return 3 end,
            getJobTypeIndex=function(_,job) equal(job,currentJob); return 3 end,
            createJob=function(_,jobType)
                equal(jobType,3)
                calls[#calls+1]={kind="CREATE"}
                return replacement
            end
        }
        local aiSystem={isServer=true}
        function aiSystem:stopJob(job,message)
            calls[#calls+1]={kind="STOP",job=job,message=message}
            equal(job,currentJob); equal(message,nil)
        end
        function aiSystem:startJob(job,farmId)
            calls[#calls+1]={kind="START",job=job,farmId=farmId}
            job.jobId=42
            currentJob=job
        end
        g_currentMission={aiSystem=aiSystem,aiJobTypeManager=manager}

        local driveState=nil
        local reposition=nil
        local drive={
            install=function() return true end,
            setReposition=function(self,v,x,z,speed,radius,moveForwards)
                reposition={vehicle=v,x=x,z=z,speed=speed,radius=radius,moveForwards=moveForwards}
                driveState={mode="REPOSITION",targetReached=false}
                return true
            end,
            getState=function() return driveState end,
            clearMovementObjective=function()
                if driveState~=nil then driveState=nil; return true end
                return false
            end
        }
        local transitCalls,clearCalls=0,0
        local configurationState=nil
        local configuration={
            prepareCachedTransit=function()
                transitCalls=transitCalls+1
                configurationState={owned=true}
                return true,configurationState
            end,
            getCachedTransitSettlement=function()
                return {settled=true,exhausted=false}
            end,
            getState=function() return configurationState end,
            clear=function()
                clearCalls=clearCalls+1
                configurationState=nil
            end,
            requestCachedTransitRestore=function() error("successful Recovery must not request restore") end,
            getCachedRestoreSettlement=function() error("successful Recovery must not wait for restore") end,
            finishCachedTransitRestore=function() error("successful Recovery must not finish restore") end
        }
        local runtime={
            boundedAuthority={validateRequest=function() return true end},
            liveObservationSource={getCurrentPhysicalObject=function(_,ref)
                if ref=="vehicle-root:recovery" then return vehicle end
            end},
            jobEpisodes={getActiveForAssembly=function(_,id)
                if id=="AS-RECOVERY" then return currentEpisode end
            end},
            assemblyRepresentationCache={getTransitFoldCapability=function() return nil end}
        }
        local control=OuttaMyWay.BlockedWorkerRecoveryControl.new(runtime,{
            driveMechanism=drive,configurationMechanism=configuration
        })
        local phaseEvent,completion=nil,nil
        control:setPhaseHandler(function(result) phaseEvent=result end)
        control:setCompletionHandler(function(result) completion=result end)

        local request={
            identity="CR-RECOVERY",commitmentId="CM-RECOVERY",assemblyId="AS-RECOVERY",
            capability="REPOSITION",boundedAuthorityId="BA-RECOVERY",
            target={
                kind="BLOCKED_WORKER_RECOVERY",assemblyReferenceKey="vehicle-root:recovery",
                jobEpisodeId="JE-RECOVERY",sourceJobToken="JOB-RECOVERY",recoveryKey="blocked-worker-recovery:test",
                configurationPolicy="ALWAYS_REQUEST_TRANSIT_THEN_NATIVE_REPLAN",
                recoveryAnchor={x=0,z=0},
                recoveryReturnRegion={
                    stallX=30,stallZ=0,directionX=-1,directionZ=0,
                    calibratedTargetRetreatM=20,requiredRetreatM=20,
                    maximumSupportedRetreatM=30,cappedByAnchor=false
                },
                recoveryRecurrenceContext={stallTimestamp=10,stallX=30,stallZ=0}
            }
        }
        local started=control:executeControlRequest(request,{})
        equal(started,true); equal(transitCalls,1)
        equal(control:getStatus().phase,"WAITING_FOR_TRANSIT")

        control:update(16)
        if reposition==nil then error("Recovery movement not started") end
        equal(reposition.x,0); equal(reposition.z,0)
        equal(reposition.moveForwards,false)
        equal(control:getStatus().phase,"MOVING_TO_RECOVERY_RETURN_REGION")

        poseX=10
        equal(driveState.targetReached,false)
        control:update(16)
        if phaseEvent==nil then error("Physical Recovery phase settlement missing") end
        equal(phaseEvent.phaseEvent,"PHYSICAL_RECOVERY_SATISFIED")
        equal(phaseEvent.evidence.kind,"RECOVERY_RETURN_REGION_REACHED_IN_TRANSIT")
        equal(phaseEvent.evidence.requiredRetreatM,20)
        equal(phaseEvent.evidence.retreatProgressM,20)
        equal(phaseEvent.evidence.completionBasis,"RECOVERY_RETURN_REGION_PROGRESS")
        equal(control:getStatus().phase,"WAITING_FOR_REPLACEMENT_JOB_EPISODE")
        equal(control:getStatus().expectedSuccessorSourceJobToken,"giants-ai-job-id:42")
        equal(driveState,nil)
        equal(configurationState,nil)
        equal(clearCalls,1)
        equal(completion,nil)

        control:update(16)
        equal(completion,nil)

        currentEpisode={identity="JE-SUCCESSOR",sourceJobToken="giants-ai-job-id:42"}
        control:update(16)
        if completion==nil then error("Recovery completion missing after successor admission") end
        equal(completion.status,"SUCCEEDED")
        equal(completion.evidence.kind,"RECOVERY_INTENDED_SUCCESSOR_JOB_EPISODE_ADMITTED")
        equal(completion.evidence.successorJobEpisodeId,"JE-SUCCESSOR")
        equal(completion.recoveryRecurrenceContext.stallTimestamp,10)
        equal(completion.recoveryRecurrenceContext.stallX,30)
        equal(control:isActive(),false)
        g_currentMission,getWorldTranslation=oldMission,oldTranslation
    end)

    test("Native job replacement prepares before synchronous stop-start commitment",function()
        local oldMission=g_currentMission
        local calls={}
        local currentJob={jobId=41}
        local replacement={jobId=nil}
        function replacement:applyCurrentState(vehicle,mission,farmId,isDirectStart)
            calls[#calls+1]={kind="APPLY",vehicle=vehicle,mission=mission,farmId=farmId,directStart=isDirectStart}
        end
        function replacement:setValues() calls[#calls+1]={kind="SET_VALUES"} end
        function replacement:validate(farmId)
            calls[#calls+1]={kind="VALIDATE",farmId=farmId}
            return true,nil
        end
        function replacement:delete() calls[#calls+1]={kind="DELETE"} end

        local vehicle={
            getJob=function() return currentJob end,
            getAIJobFarmId=function() return 7 end
        }
        local manager={
            getJobTypeIndexByName=function(_,name)
                equal(name,"FIELDWORK")
                return 3
            end,
            getJobTypeIndex=function(_,job)
                equal(job,currentJob)
                return 3
            end,
            createJob=function(_,jobType)
                equal(jobType,3)
                calls[#calls+1]={kind="CREATE"}
                return replacement
            end
        }
        local aiSystem={isServer=true}
        function aiSystem:stopJob(job,message)
            calls[#calls+1]={kind="STOP",job=job,message=message}
            equal(job,currentJob)
            equal(message,nil)
        end
        function aiSystem:startJob(job,farmId)
            calls[#calls+1]={kind="START",job=job,farmId=farmId}
            job.jobId=42
        end
        g_currentMission={aiSystem=aiSystem,aiJobTypeManager=manager}

        local drive={install=function() return true end,clearMovementObjective=function() return true end}
        local configuration={}
        local control=OuttaMyWay.BlockedWorkerRecoveryControl.new({},{
            driveMechanism=drive,configurationMechanism=configuration
        })
        local state={vehicle=vehicle,commitmentId="CM-REPLACEMENT",assemblyId="AS-RECOVERY"}
        local ok,evidence=control:_replaceNativeFieldWorkJob(state)
        equal(ok,true)
        equal(evidence.kind,"NATIVE_JOB_REPLACEMENT_STARTED")
        equal(evidence.oldJobId,41)
        equal(evidence.newJobId,42)
        equal(evidence.farmId,7)
        equal(evidence.directStart,true)
        equal(evidence.stopMessageNil,true)
        equal(evidence.expectedSourceJobToken,"giants-ai-job-id:42")
        equal(#calls,6)
        equal(calls[1].kind,"CREATE")
        equal(calls[2].kind,"APPLY")
        equal(calls[2].directStart,true)
        equal(calls[3].kind,"SET_VALUES")
        equal(calls[4].kind,"VALIDATE")
        equal(calls[5].kind,"STOP")
        equal(calls[6].kind,"START")
        g_currentMission=oldMission
    end)

    test("Reverse Reposition preserves exact point target, GIANTS reverser frame and Supporting Speed Ceiling",function()
        local oldAIVehicleUtil,oldTranslation,oldWorldDirection,oldWorldToLocal=
            AIVehicleUtil,getWorldTranslation,worldDirectionToLocal,worldToLocal
        local x,z=10,0
        local calls={}
        AIVehicleUtil={
            driveToPoint=function(vehicle,dt,accel,allowed,moveForwards,lx,lz,maxSpeed)
                calls[#calls+1]={allowed=allowed,moveForwards=moveForwards,lx=lx,lz=lz,maxSpeed=maxSpeed}
                return true
            end,
            getAIToolReverserDirectionNode=function() return nil end
        }
        getWorldTranslation=function() return x,0,z end
        worldDirectionToLocal=function(node,wx,wy,wz) return wx,wy,wz end
        worldToLocal=function(node,wx,wy,wz) return wx-x,wy,wz-z end
        local vehicle={
            rootNode=22001,
            getAISteeringNode=function(self) return self.rootNode end,
            getAIReverserNode=function(self) return self.rootNode end
        }
        local drive=OuttaMyWay.NativeDriveMechanism.new()
        equal(drive:setReposition(vehicle,4,0,8,1,false),true)
        equal(drive:setRegulationLease(vehicle,1,"BUBBLE_BULLET_TIME","SUPPORTING_SPEED_CEILING"),true)
        AIVehicleUtil.driveToPoint(vehicle,16,1,false,true,0,1,25)
        equal(calls[#calls].moveForwards,false)
        equal(calls[#calls].maxSpeed,1)
        equal(drive:getState(vehicle).targetX,4)
        equal(drive:getState(vehicle).repositionReferenceNodeSource,"AI_REVERSER_NODE")
        x=4.5
        AIVehicleUtil.driveToPoint(vehicle,16,1,false,true,0,1,25)
        equal(drive:getState(vehicle).targetReached,true)
        AIVehicleUtil,getWorldTranslation,worldDirectionToLocal,worldToLocal=
            oldAIVehicleUtil,oldTranslation,oldWorldDirection,oldWorldToLocal
    end)
    test("Recovery Candidate consumes one positive Situation-owned blocker relation without making it admission-required",function()
        local relation={
            identity="causal-obstruction:OR-RECOVERY:AS-B->AS-RECOVERY",
            operationId="OR-RECOVERY",
            blockerAssemblyId="AS-B",blockerAssemblyReferenceKey="vehicle-root:b",
            beneficiaryAssemblyId="AS-RECOVERY",beneficiaryAssemblyReferenceKey="vehicle-root:recovery",
            blockerClassification="ACTIVE_GIANTS_AI",
            obstructionEvidence={kind="CURRENT_PHYSICAL_OCCUPANCY"},
            provenance={authority="CURRENT_POSITIVE_CAUSAL_OBSTRUCTION"}
        }
        local support=OuttaMyWay.BlockedWorkerRecoveryCandidateSupport.new()
        local group,reason=support:buildFreshProjectedGroup(
            pictureWithRecovery(nil,nil,{relation}),snapshot(),"PI-RECOVERY-TARGET",102)
        if group==nil then error(reason or "Recovery group missing") end
        local bridge=group.candidateSpecifications[1].evidenceBasis.blockedWorkerRecoveryBridge
        equal(bridge.recoveryBlocker.assemblyId,"AS-B")
        equal(bridge.recoveryBlocker.assemblyReferenceKey,"vehicle-root:b")
        equal(bridge.recoveryBlocker.classification,"ACTIVE_GIANTS_AI")
        equal(bridge.recoveryBlockerStatus,"SUPPORTED")

        local noBlockerGroup,noBlockerReason=support:buildFreshProjectedGroup(
            pictureWithRecovery(),snapshot(),"PI-RECOVERY-NO-BLOCKER",103)
        if noBlockerGroup==nil then error(noBlockerReason or "Recovery without blocker should remain supportable") end
        local noBlockerBridge=noBlockerGroup.candidateSpecifications[1].evidenceBasis.blockedWorkerRecoveryBridge
        equal(noBlockerBridge.recoveryBlocker,nil)
        equal(noBlockerBridge.recoveryBlockerStatus,"NO_POSITIVE_CAUSAL_BLOCKER")
    end)

    test("Recovery Bubble holds active blocker and applies shared Bullet Time to uninvolved participant",function()
        local commitment={identity="CM-RECOVERY-BUBBLE",state="ACTIVE",effectiveActuationCompositionId="COMP-RECOVERY"}
        local currentResponsibility={identity="RS-RECOVERY-BUBBLE"}
        local grants,requests,dispatches,clears,releases={},{},{},{},{}
        local compositionSequence=0
        OuttaMyWay.CommitmentStateMachine={
            isTerminal=function(record) return record.state=="SUCCEEDED" or record.state=="FAILED" end
        }
        local runtime={
            identities={issue=function(_,kind)
                equal(kind,"COMPOSITION")
                compositionSequence=compositionSequence+1
                return "COMP-RECOVERY-SUPPORT-"..tostring(compositionSequence)
            end},
            epochs={next=function() return 22 end},
            commitments={get=function(_,id) if id==commitment.identity then return commitment end end},
            boundedAuthority={
                authorize=function(_,values)
                    grants[#grants+1]=values
                    equal(values.responsibilityId,currentResponsibility.identity)
                    equal(values.commitmentId,commitment.identity)
                    equal(values.capability,"REGULATE_SPEED")
                    equal(values.authorityRole,"SUPPORTING_SPEED_CEILING")
                    return {identity="BA-"..tostring(#grants),preconditions={},invalidationConditions={},authorityRole="SUPPORTING_SPEED_CEILING"},nil
                end,
                materializeRequest=function(_,values)
                    requests[#requests+1]=values
                    local grant=grants[#requests]
                    return {
                        identity="CR-"..tostring(#requests),boundedAuthorityId=values.boundedAuthorityId,
                        commitmentId=commitment.identity,assemblyId=grant.assemblyId,capability="REGULATE_SPEED",
                        target=values.target,authorityRole="SUPPORTING_SPEED_CEILING",
                        effectiveActuationCompositionId=commitment.effectiveActuationCompositionId
                    },nil
                end,
                release=function(_,id) releases[#releases+1]=id; return true end
            },
            liveControlDispatcher={
                dispatch=function(_,request) dispatches[#dispatches+1]=request; return true,"REGULATION_LEASE_APPLIED" end,
                notifyAccepted=function() return {identity="OUTCOME"} end,
                regulationControl={
                    clearRegulationLeaseByReference=function(_,referenceKey,ownerTag)
                        clears[#clears+1]={referenceKey=referenceKey,ownerTag=ownerTag}
                        return true
                    end
                }
            },
            responsibilityTransitionAuthority={
                getCurrentResolutionCommitment=function(_,id)
                    if id==commitment.identity and commitment.state=="ACTIVE" then return currentResponsibility end
                end
            }
        }
        local picture={
            epoch=20,
            situations={{operationId="OP-RECOVERY",memberAssemblyIds={"AS-RECOVERY","AS-A","AS-B"}}},
            motionEvidence={
                {assemblyId="AS-RECOVERY",assemblyReferenceKey="vehicle-root:recovery"},
                {assemblyId="AS-A",assemblyReferenceKey="vehicle-root:a"},
                {assemblyId="AS-B",assemblyReferenceKey="vehicle-root:b"}
            },
            physicalSpaceEvidence={},productiveContinuationKnowledge={}
        }
        local candidate={
            preconditions={},invalidationConditions={},
            evidenceBasis={blockedWorkerRecoveryBridge={
                architecture="BLOCKED_WORKER_RECOVERY",operationId="OP-RECOVERY",
                assemblyId="AS-RECOVERY",assemblyReferenceKey="vehicle-root:recovery",
                recoveryBlocker={assemblyId="AS-B",assemblyReferenceKey="vehicle-root:b",classification="ACTIVE_GIANTS_AI"}
            }}
        }
        local plan={
            operationId="OP-RECOVERY",
            releaseWhenAssemblyLeaves={"AS-RECOVERY"},
            logCodePrefix="RECOVERY_BUBBLE_PROTECTION",
            provenanceSource="BlockedWorkerRecoveryRuntimeIntegration",
            leaseSpecs={
                {
                    assemblyId="AS-A",maxSpeedKmh=1.0,ownerTag="BWR_BUBBLE_BULLET_TIME",
                    governingPurpose="BLOCKED_WORKER_RECOVERY_BUBBLE_BULLET_TIME",role="BULLET_TIME"
                },
                {
                    assemblyId="AS-B",maxSpeedKmh=0.0,ownerTag="BWR_BLOCKER_HOLD",
                    governingPurpose="PRESERVE_CAUSAL_BLOCKER_POSITION_DURING_BLOCKED_WORKER_RECOVERY",role="BLOCKER_HOLD"
                }
            }
        }
        local bubble=OuttaMyWay.BubbleBulletTime.new(runtime)
        local prepared,prepareReason=bubble:prepareProtection(picture,{commitment=commitment},plan)
        equal(prepareReason,nil)
        equal(prepared.status,"PREPARED")
        equal(#prepared.leases,2)
        equal(#dispatches,0)

        local active,activateReason=bubble:activatePrepared(commitment.identity,{
            effectiveActuationCompositionId="COMP-RECOVERY",operationalPictureEpoch=20,evidenceEpoch=21,
            preconditions={},invalidationConditions={}
        },candidate)
        equal(activateReason,nil)
        equal(active.status,"ACTIVE")
        equal(#grants,2)
        equal(#requests,2)
        equal(#dispatches,2)
        equal(grants[1].supportingSpeedCeilingComposition.identity,"COMP-RECOVERY-SUPPORT-1")
        equal(grants[2].supportingSpeedCeilingComposition.identity,"COMP-RECOVERY-SUPPORT-1")
        equal(grants[1].assemblyId,"AS-A")
        equal(grants[1].target.ownerTag,"BWR_BUBBLE_BULLET_TIME")
        equal(grants[1].target.maxSpeedKmh,1.0)
        equal(grants[2].assemblyId,"AS-B")
        equal(grants[2].target.ownerTag,"BWR_BLOCKER_HOLD")
        equal(grants[2].target.maxSpeedKmh,0.0)

        commitment.state="SUCCEEDED"
        bubble:update()
        equal(bubble:getProtection(commitment.identity),nil)
        equal(#clears,2)
        equal(#releases,2)
    end)

    test("Recovery Bubble without positive active blocker invents no hold",function()
        local runtime={
            identities={issue=function() return "COMP-NO-BLOCKER" end},
            epochs={next=function() return 1 end}
        }
        local picture={
            situations={{operationId="OP-RECOVERY",memberAssemblyIds={"AS-RECOVERY","AS-A","AS-B"}}},
            motionEvidence={
                {assemblyId="AS-A",assemblyReferenceKey="vehicle-root:a"},
                {assemblyId="AS-B",assemblyReferenceKey="vehicle-root:b"}
            }
        }
        local bridge={operationId="OP-RECOVERY",assemblyId="AS-RECOVERY",recoveryBlocker=nil}
        -- Mirror Runtime's BWR plan policy: with no supported blocker, every other active peer is Bullet Time.
        local leaseSpecs={}
        for _,assemblyId in ipairs({"AS-A","AS-B"}) do
            leaseSpecs[#leaseSpecs+1]={
                assemblyId=assemblyId,maxSpeedKmh=1.0,ownerTag="BWR_BUBBLE_BULLET_TIME",
                governingPurpose="BLOCKED_WORKER_RECOVERY_BUBBLE_BULLET_TIME",role="BULLET_TIME"
            }
        end
        local bubble=OuttaMyWay.BubbleBulletTime.new(runtime)
        local protection,reason=bubble:prepareProtection(picture,{commitment={
            identity="CM-NO-BLOCKER",effectiveActuationCompositionId="COMP-RECOVERY"
        }},{operationId=bridge.operationId,leaseSpecs=leaseSpecs,releaseWhenAssemblyLeaves={bridge.assemblyId}})
        equal(reason,nil)
        equal(#protection.leases,2)
        equal(protection.leases[1].maxSpeedKmh,1.0)
        equal(protection.leases[2].maxSpeedKmh,1.0)
        equal(protection.leases[1].role,"BULLET_TIME")
        equal(protection.leases[2].role,"BULLET_TIME")
    end)

end
