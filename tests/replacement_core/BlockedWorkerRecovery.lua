return function(test,equal)
    local function pictureWithRecovery(contexts,physicalSpaceEvidence)
        return OuttaMyWay.OperationalPicture.new({
            identity="PI-RECOVERY",epoch=101,observationSnapshotId="OS-RECOVERY",
            situations={},currentPairAssessmentScope={},identities={},currentSpace={},futureSpace={},
            demand={committedDemand={},potentialDemand={},temporarySlack={}},
            responsibilityRelations={},uncertainty={},representationFitness={},provenance={source="BlockedWorkerRecoveryTest"},
            physicalSpaceEvidence=physicalSpaceEvidence or {{
                assemblyId="AS-RECOVERY",assemblyReferenceKey="vehicle-root:recovery",
                configurationProfileId="CFG-WORKING",
                primitives={{kind="DISC"}},
                summary={physicalPrimitiveCount=1},
                coverageComplete=false,negativeClearanceAuthority=false,
                provenance={source="BlockedWorkerRecoveryTest"}
            }},
            controlOutcomeEvidence={},candidateSupportEvidence={},commitmentContext=contexts or {},
            blockedProgressKnowledge={{
                assemblyId="AS-RECOVERY",assemblyReferenceKey="vehicle-root:recovery",
                jobEpisodeId="JE-RECOVERY",sourceJobToken="JOB-RECOVERY",operationId="OR-RECOVERY",
                status="BLOCKED_PROGRESS_STALL",blockedProgressStall=true,
                stallEvidence={establishedAtObservationSnapshotId="OS-STALL",poseX=10,poseZ=20,collapseObservedSeconds=1.25},
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

    test("Recovery Candidate uses the selected Recovery Anchor as its only Recovery Point",function()
        local support=OuttaMyWay.BlockedWorkerRecoveryCandidateSupport.new()
        local group,reason=support:buildFreshProjectedGroup(
            pictureWithRecovery(),snapshot(),"PI-RECOVERY-TARGET",102)
        if group==nil then error(reason or "Recovery group missing") end
        equal(group.supportBoundary.mode,"BLOCKED_WORKER_RECOVERY")
        equal(#group.candidateSpecifications,1)
        local candidate=group.candidateSpecifications[1]
        equal(candidate.capability,"REPOSITION")
        equal(candidate.expectedEffect.recoveryPoint,"RECOVERY_ANCHOR")
        equal(candidate.expectedEffect.transitRequested,true)
        equal(candidate.expectedEffect.nativeJobReplacement,true)
        equal(candidate.expectedEffect.physicalReleaseAfterReplacementStart,true)
        equal(#candidate.obligationsCreated,2)
        equal(candidate.obligationsCreated[1].requiredOutcome.kind,"BLOCKED_WORKER_RECOVERY_ANCHOR_REACHED_IN_TRANSIT")
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
        local anchor=candidate.evidenceBasis.blockedWorkerRecoveryBridge.recoveryAnchor
        equal(anchor.x,4.25); equal(anchor.z,17.5)
        equal(anchor.usefulSpanM,5.61)
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
                "BLOCKED_WORKER_RECOVERY_ANCHOR_REACHED_IN_TRANSIT",
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

    test("Recovery Control reaches Anchor, replaces native job, releases physically, then settles on successor admission",function()
        local oldMission=g_currentMission
        local calls={}
        local currentJob={jobId=41}
        local replacement={jobId=nil}
        local currentEpisode={identity="JE-RECOVERY",sourceJobToken="JOB-RECOVERY"}
        local vehicle={name="Condor"}
        vehicle.getJob=function() return currentJob end
        vehicle.getAIJobFarmId=function() return 7 end

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
        local axisTravel=nil
        local drive={
            install=function() return true end,
            setAxisTravel=function(self,v,originX,originZ,axisX,axisZ,targetStation,speed,moveForwards,tolerance)
                axisTravel={
                    vehicle=v,originX=originX,originZ=originZ,axisX=axisX,axisZ=axisZ,
                    targetStation=targetStation,speed=speed,moveForwards=moveForwards,tolerance=tolerance
                }
                driveState={mode="AXIS_TRAVEL",targetReached=false}
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
                recoveryAnchor={x=4.25,z=17.5},
                recoveryApproachAxis={forwardX=0,forwardZ=1}
            }
        }
        local started=control:executeControlRequest(request,{})
        equal(started,true); equal(transitCalls,1)
        equal(control:getStatus().phase,"WAITING_FOR_TRANSIT")

        control:update(16)
        if axisTravel==nil then error("Recovery axis movement not started") end
        equal(axisTravel.originX,4.25); equal(axisTravel.originZ,17.5)
        equal(axisTravel.axisX,0); equal(axisTravel.axisZ,1)
        equal(axisTravel.targetStation,0); equal(axisTravel.moveForwards,false)
        equal(axisTravel.tolerance,1.0)
        equal(control:getStatus().phase,"MOVING_TO_RECOVERY_ANCHOR")

        driveState.targetReached=true
        control:update(16)
        if phaseEvent==nil then error("Physical Recovery phase settlement missing") end
        equal(phaseEvent.phaseEvent,"PHYSICAL_RECOVERY_SATISFIED")
        equal(phaseEvent.evidence.kind,"RECOVERY_ANCHOR_REACHED_IN_TRANSIT")
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
        equal(control:isActive(),false)
        g_currentMission=oldMission
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

    test("Reverse Reposition preserves exact point target and Supporting Speed Ceiling",function()
        local oldAIVehicleUtil,oldTranslation,oldWorldDirection=AIVehicleUtil,getWorldTranslation,worldDirectionToLocal
        local x,z=10,0
        local calls={}
        AIVehicleUtil={driveToPoint=function(vehicle,dt,accel,allowed,moveForwards,lx,lz,maxSpeed)
            calls[#calls+1]={allowed=allowed,moveForwards=moveForwards,lx=lx,lz=lz,maxSpeed=maxSpeed}
            return true
        end}
        getWorldTranslation=function() return x,0,z end
        worldDirectionToLocal=function(node,wx,wy,wz) return wx,wy,wz end
        local vehicle={rootNode=22001,getAISteeringNode=function(self) return self.rootNode end}
        local drive=OuttaMyWay.NativeDriveMechanism.new()
        equal(drive:setReposition(vehicle,4,0,8,1,false),true)
        equal(drive:setRegulationLease(vehicle,1,"BUBBLE_BULLET_TIME","SUPPORTING_SPEED_CEILING"),true)
        AIVehicleUtil.driveToPoint(vehicle,16,1,false,true,0,1,25)
        equal(calls[#calls].moveForwards,false)
        equal(calls[#calls].maxSpeed,1)
        equal(drive:getState(vehicle).targetX,4)
        x=4.5
        AIVehicleUtil.driveToPoint(vehicle,16,1,false,true,0,1,25)
        equal(drive:getState(vehicle).targetReached,true)
        AIVehicleUtil,getWorldTranslation,worldDirectionToLocal=oldAIVehicleUtil,oldTranslation,oldWorldDirection
    end)
end
