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
        equal(candidate.expectedEffect.configurationRestoredBeforeHandback,true)
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

    test("Recovery Control requests Transit then reverses directly to Anchor and hands back",function()
        local vehicle={name="Condor"}
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
        local transitCalls=0
        local configuration={
            prepareCachedTransit=function()
                transitCalls=transitCalls+1
                return false,"bootstrap-non-foldable"
            end,
            getState=function() return nil end,
            clear=function() end
        }
        local runtime={
            boundedAuthority={validateRequest=function() return true end},
            liveObservationSource={getCurrentPhysicalObject=function(_,ref)
                if ref=="vehicle-root:recovery" then return vehicle end
            end},
            jobEpisodes={getActiveForAssembly=function(_,id)
                if id=="AS-RECOVERY" then return {identity="JE-RECOVERY",sourceJobToken="JOB-RECOVERY"} end
            end},
            assemblyRepresentationCache={getTransitFoldCapability=function() return nil end}
        }
        local control=OuttaMyWay.BlockedWorkerRecoveryControl.new(runtime,{
            driveMechanism=drive,configurationMechanism=configuration
        })
        local completion=nil
        control:setCompletionHandler(function(result) completion=result end)
        local request={
            identity="CR-RECOVERY",commitmentId="CM-RECOVERY",assemblyId="AS-RECOVERY",
            capability="REPOSITION",boundedAuthorityId="BA-RECOVERY",
            target={
                kind="BLOCKED_WORKER_RECOVERY",assemblyReferenceKey="vehicle-root:recovery",
                jobEpisodeId="JE-RECOVERY",sourceJobToken="JOB-RECOVERY",recoveryKey="blocked-worker-recovery:test",
                configurationPolicy="ALWAYS_REQUEST_TRANSIT_THEN_RESTORE",
                recoveryAnchor={x=4.25,z=17.5}
            }
        }
        local started,result=control:executeControlRequest(request,{})
        equal(started,true)
        equal(transitCalls,1)
        if reposition==nil then error("Recovery movement not started") end
        equal(reposition.x,4.25); equal(reposition.z,17.5)
        equal(reposition.moveForwards,false)
        equal(control:getStatus().phase,"MOVING_TO_RECOVERY_ANCHOR")

        driveState.targetReached=true
        control:update(16)
        if completion==nil then error("Recovery completion missing") end
        equal(completion.status,"SUCCEEDED")
        equal(completion.evidence.kind,"RECOVERY_ANCHOR_REACHED_RESTORED_AND_HANDED_BACK")
        equal(control:isActive(),false)
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
