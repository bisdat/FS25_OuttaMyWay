return function(test,equal)
    local O=OuttaMyWay
    local V=O.ValueRecord
    local function fixture(active)
        g_time=10000
        local runtime=O.Runtime.new()
        local vehicles={m={rootNode=1},b={rootNode=2},c={rootNode=3}}
        local episodes={["AS-M"]={identity="JM",sourceJobToken="successor"}}
        if active then episodes["AS-B"]={identity="JB",sourceJobToken="blocker"}; episodes["AS-C"]={identity="JC",sourceJobToken="third"} end
        runtime.jobEpisodes.getActiveForAssembly=function(_,id) return episodes[id] end
        runtime.liveObservationSource.getCurrentPhysicalObject=function(_,ref) return vehicles[ref] end
        local drive={installed=true,states={},leases={},moves={}}
        function drive:getState(v) return self.states[v] end
        function drive:setAxisTravel(v) self.states[v]={}; return true end
        function drive:setReposition(v,x,z,speed,radius,forward)
            self.moves[#self.moves+1]={x=x,z=z,forward=forward}; self.states[v]={}; return true
        end
        function drive:clearMovementObjective(v) self.states[v]=nil end
        function drive:setRegulationLease(v,speed,owner,role)
            self.leases[v]=self.leases[v] or {}; self.leases[v][owner]={speedKmh=speed,authorityRole=role}; return true
        end
        function drive:getRegulationLease(v,owner) return self.leases[v] and self.leases[v][owner] end
        function drive:clearRegulationLease(v,owner) if self.leases[v] then self.leases[v][owner]=nil end; return true end
        local regulation=O.RegulationControl.new(runtime,drive)
        regulation._vehicleForReferenceKey=function(_,ref) return vehicles[ref] end
        runtime:setRegulationControl(regulation)
        local configuration={settled=false,requested=false,cleared=false}
        function configuration:prepareCachedTransit(_,_,strict) self.requested=strict; return true end
        function configuration:getCachedTransitSettlement() return {settled=self.settled,exhausted=false} end
        function configuration:getState() return self.requested and {} or nil end
        function configuration:clear() self.cleared=true end
        runtime.assemblyRepresentationCache.getTransitFoldCapability=function() return {members={},actuators={},isFoldable=false} end
        local control=O.BoundedBypassControl.new(runtime,{driveMechanism=drive,configurationMechanism=configuration})
        runtime.liveControlDispatcher.boundedBypassControl=control
        local p={identity="P",epoch=20,observationSnapshotId="S",situations={{identity="SI",operationId="OP",memberAssemblyIds=active and {"AS-M","AS-B","AS-C"} or {"AS-M"}}},
            currentPairAssessmentScope={},identities={},currentSpace={},futureSpace={},demand={committedDemand={},potentialDemand={},temporarySlack={}},
            responsibilityRelations={},uncertainty={},representationFitness={},provenance={},controlOutcomeEvidence={},candidateSupportEvidence={},commitmentContext={},
            blockedProgressKnowledge={{assemblyId="AS-M",assemblyReferenceKey="m",operationId="OP",jobEpisodeId="JM",sourceJobToken="successor",blockedProgressStall=true,
                stallEvidence={establishedAtObservationSnapshotId="STALL",poseX=0,poseZ=0},recoveryAnchor={poseX=-99,poseZ=0}}},
            blockedWorkerRecoveryRecurrenceKnowledge={{assemblyId="AS-M",correlated=true,status="RECOVERY_STRATEGY_EXHAUSTED",successorJobEpisodeId="JM",successorSourceJobToken="successor",currentStallObservationSnapshotId="STALL"}},
            causalObstructionKnowledge={{identity="R",operationId="OP",beneficiaryAssemblyId="AS-M",blockerAssemblyId="AS-B",blockerAssemblyReferenceKey="b",provenance={authority="CURRENT_POSITIVE_CAUSAL_OBSTRUCTION"}}},
            motionEvidence={{assemblyId="AS-M",assemblyReferenceKey="m",sourceJobToken="successor",headingX=0,headingZ=1,motionClassification="STATIONARY"},
                {assemblyId="AS-B",assemblyReferenceKey="b",motionClassification="STATIONARY",positionDerivedSpeedMps=0,reportedSpeedMps=0},
                {assemblyId="AS-C",assemblyReferenceKey="c"}},
            productiveContinuationKnowledge={{assemblyId="AS-M",jobToken="successor",productivePositive=true,isTurn=false}}}
        local s={identity="S",epoch=19,timestamp=10,provenance={},fieldWorld={boundary={{x=-15,z=-5},{x=100,z=-5},{x=100,z=100},{x=-15,z=100}},islands={}},
            assemblies={},geometry={currentPhysicalPoseEvidence={{assemblyReferenceKey="m",x=0,z=0},{assemblyReferenceKey="b",x=0,z=3}}},motion={},
            aiStates={b={aiActiveObserved=true,aiActive=active==true,observedActive=active==true}},
            playerControl={m={playerEnteredObserved=true,playerEntered=false},b={playerEnteredObserved=true,playerEntered=false}},
            jobEpisodeEvidence={},operationMembershipEvidence={},physicalRepresentationEvidence={},controlOutcomes={},unavailableSources={}}
        local function publish()
            local picture,snapshot=O.OperationalPicture.new(p),O.ObservationSnapshot.new(s)
            runtime.boundedBypassRuntime:observe({picture=picture,snapshot=snapshot})
            return picture,snapshot
        end
        local function group()
            local picture,snapshot=publish()
            return runtime.boundedBypassCandidateSupport:buildFreshProjectedGroup(picture,snapshot,"P2",21)
        end
        local function dispatch()
            local base,snapshot=publish()
            local picture=runtime.prospectiveDecisionPortfolioSupport:publishDecisionPicture(base,snapshot)
            local evaluated=runtime:evaluateSealedOperationalPicture(picture)
            local candidate
            for _,c in V.ipairs(evaluated.candidates) do if c.identity==evaluated.decision.selectedCandidateId then candidate=c end end
            assert(candidate,"Decision did not select Bypass")
            local result=runtime:dispatchEvaluatedOperationalPicture(picture,evaluated)
            assert(result.status~="NO_DISPATCH",tostring(result.reason))
            return result,candidate
        end
        return {runtime=runtime,p=p,s=s,group=group,publish=publish,dispatch=dispatch,control=control,drive=drive,configuration=configuration,vehicles=vehicles,episodes=episodes}
    end
    test("Bypass exhaustion alone cannot manufacture a causal blocker",function()
        local f=fixture();f.p.causalObstructionKnowledge={};equal(f.group(),nil)
    end)
    test("Bypass requires exact fresh Stall and successor recurrence",function()
        for _,field in ipairs({"blockedProgressKnowledge","blockedWorkerRecoveryRecurrenceKnowledge"}) do local f=fixture();f.p[field]={};equal(f.group(),nil) end
        local f=fixture();f.p.blockedWorkerRecoveryRecurrenceKnowledge[1].successorSourceJobToken="old";equal(f.group(),nil)
    end)
    test("Bypass refuses unresolved stability and player claim",function()
        local f=fixture();f.p.motionEvidence[2].motionClassification="MOTION_EVIDENCE_UNRESOLVED";equal(f.group(),nil)
        f=fixture();f.s.playerControl.b.playerEntered=true;equal(f.group(),nil)
        f=fixture();f.s.aiStates.b.aiActiveObserved=false;equal(f.group(),nil)
    end)
    test("Bypass active blocker needs an establishable hold",function()
        local f=fixture(true);assert(f.group());f.drive.installed=false;equal(f.group(),nil)
    end)
    test("Bypass uses current successor frame and ignores historical Recovery geometry",function()
        local f=fixture();local group=assert(f.group());local guide=group.candidateSpecifications[1].evidenceBasis.boundedBypassBridge.guide
        equal(guide.frame.forwardX,0);equal(guide.frame.forwardZ,1);equal(guide.frame.sourceJobToken,"successor")
        f.p.motionEvidence[1].sourceJobToken="old";equal(f.group(),nil)
    end)
    test("Bypass considers both sides and rejects unsupported side",function()
        local f=fixture();equal(#assert(f.group()).candidateSpecifications,2)
        f.s.fieldWorld.boundary[1].x=-5;f.s.fieldWorld.boundary[4].x=-5
        local group=assert(f.group());equal(#group.candidateSpecifications,1);equal(group.candidateSpecifications[1].evidenceBasis.boundedBypassBridge.guide.side,1)
    end)
    test("Bypass fixed guide has three forward legs and later on-axis Rejoin",function()
        local f=fixture();local guide=assert(f.group()).candidateSpecifications[1].evidenceBasis.boundedBypassBridge.guide
        equal(#guide.targets,3);equal(guide.targets[1].x,10);equal(guide.targets[1].z,20)
        equal(guide.targets[2].x,10);equal(guide.targets[2].z,30)
        equal(guide.targets[3].x,0);equal(guide.targets[3].z,50)
    end)
    test("Bypass rejects a narrow island between reference samples",function()
        local f=fixture();f.s.fieldWorld.islands={{{x=4.9,z=9.7},{x=5.1,z=9.7},{x=5.1,z=10.3},{x=4.9,z=10.3}}}
        local group=assert(f.group());equal(#group.candidateSpecifications,1);equal(group.candidateSpecifications[1].evidenceBasis.boundedBypassBridge.guide.side,-1)
    end)
    test("Bypass Decision prefers field interior and settles Transit before three forward targets",function()
        local f=fixture(true);local result,candidate=f.dispatch();equal(result.status,"ACCEPTED")
        equal(candidate.evidenceBasis.boundedBypassBridge.guide.side,1)
        equal(f.configuration.requested,true);equal(#f.drive.moves,0)
        equal(f.runtime.assemblyRepresentationCache:isOuttaMyWayConfigurationAuthorityActive("m","successor"),true)
        local protection=f.runtime.bubbleBulletTime:getProtection(result.commitment.identity)
        equal(#protection.leases,2);equal(f.drive:getRegulationLease(f.vehicles.b,"BYPASS_BLOCKER_HOLD").speedKmh,0)
        equal(f.drive:getRegulationLease(f.vehicles.c,"BYPASS_BUBBLE_BULLET_TIME").speedKmh,1)
        f.control:update();equal(#f.drive.moves,0)
        f.configuration.settled=true;f.control:update();equal(#f.drive.moves,1)
        for i=1,3 do f.drive.states[f.vehicles.m].targetReached=true;f.control:update() end
        equal(#f.drive.moves,3)
        for _,move in ipairs(f.drive.moves) do equal(move.forward,true) end
        equal(f.control:isActive(),false);equal(f.configuration.cleared,true)
        equal(f.runtime.assemblyRepresentationCache:isOuttaMyWayConfigurationAuthorityActive("m","successor"),false)
        equal(f.runtime.commitments:get(result.commitment.identity).state,"SUCCEEDED")
        equal(f.runtime.bubbleBulletTime:getProtection(result.commitment.identity),nil)
        equal(f.runtime.responsibilityTransitionAuthority:getCurrentResolutionCommitment(result.commitment.identity),nil)
        equal(f.episodes["AS-M"].identity,"JM");equal(f.group(),nil)
    end)
    test("Bypass fails closed when protection, blocker movement, Job or Field guide contradicts",function()
        for _,contradiction in ipairs({"lease","motion","job","field","transit","authority","player"}) do
            local f=fixture(true);local result=f.dispatch();equal(result.status,"ACCEPTED");f.configuration.settled=true;f.control:update()
            if contradiction=="lease" then f.drive:clearRegulationLease(f.vehicles.b,"BYPASS_BLOCKER_HOLD")
            elseif contradiction=="motion" then f.p.motionEvidence[2].motionClassification="STABLE_FORWARD"
            elseif contradiction=="job" then f.episodes["AS-M"]=nil
            elseif contradiction=="field" then f.s.fieldWorld.boundary[2].x=5;f.s.fieldWorld.boundary[3].x=5
            elseif contradiction=="transit" then f.configuration.settled=false
            elseif contradiction=="authority" then f.runtime.boundedAuthority:release(result.request.boundedAuthorityId,"TEST")
            else f.s.playerControl.m.playerControlled=true end
            f.publish();f.control:update();equal(f.control:isActive(),false);equal(#f.drive.moves,1)
            equal(f.runtime.assemblyRepresentationCache:isOuttaMyWayConfigurationAuthorityActive("m","successor"),false)
            equal(f.runtime.bubbleBulletTime:getProtection(result.commitment.identity),nil)
        end
    end)
    test("Bypass remains independent of a concurrent supported purpose",function()
        local inventory={supportBoundary={mode="PROSPECTIVE_DECISION_PORTFOLIO",groups={
            {groupKey="bypass",family="BOUNDED_BYPASS"},{groupKey="traffic",family="PASSAGE"}}}}
        local candidates={{evidenceBasis={candidateSupportGroup={groupKey="bypass"}}},{evidenceBasis={candidateSupportGroup={groupKey="traffic"}}}}
        equal(O.ProspectivePortfolioDecisionPolicy:selectGroup(inventory,candidates),nil)
    end)
    test("Bypass current Recovery Bubble and movement ownership veto admission",function()
        local f=fixture();f.p.commitmentContext={{governingBasis={kind="BLOCKED_WORKER_RECOVERY"}}};equal(f.group(),nil)
        f=fixture();f.runtime.authorities.ownerOf=function() return "CM-OTHER" end;equal(f.group(),nil)
    end)
    test("Bypass tied sides use deterministic positive-side preference",function()
        local f=fixture();f.s.fieldWorld.boundary[1].x=-100;f.s.fieldWorld.boundary[4].x=-100
        local result,candidate=f.dispatch();equal(result.status,"ACCEPTED");equal(candidate.evidenceBasis.boundedBypassBridge.guide.side,1)
    end)
    test("Bypass cannot move when Bubble activation fails",function()
        local f=fixture(true)
        f.drive.setRegulationLease=function() return false,"fixture-hold-unavailable" end
        local result=f.dispatch();equal(result.status,"REJECTED");equal(#f.drive.moves,0)
        equal(f.runtime.commitments:get(result.commitment.identity).state,"FAILED")
        equal(f.runtime.bubbleBulletTime:getProtection(result.commitment.identity),nil)
    end)
    test("Bypass strict Transit handles non-foldable work-off and raise settlement",function()
        local mechanism=O.TransitConfigurationMechanism.new()
        local v={enabled=true,lowered=true}
        function v:getIsTurnedOn() return self.enabled end
        function v:setIsTurnedOn(value) self.enabled=value end
        function v:getIsLowered() return self.lowered end
        function v:setLowered(value) self.lowered=value end
        local capability={isFoldable=false,members={v},actuators={},settlementTimeoutMs=1000}
        equal(mechanism:prepareCachedTransit(v,capability),false)
        equal(mechanism:prepareCachedTransit(v,capability,true),true)
        equal(v.enabled,false);equal(v.lowered,false);equal(mechanism:getCachedTransitSettlement(v).settled,true)
        v.lowered=true;equal(mechanism:getCachedTransitSettlement(v).settled,false)
        mechanism:clear(v);equal(v.lowered,true)
    end)
    test("Bypass strict Transit cannot accept a missing fold actuator",function()
        local mechanism=O.TransitConfigurationMechanism.new()
        local v={}
        equal(mechanism:prepareCachedTransit(v,{isFoldable=true,members={v},actuators={{object=v}},settlementTimeoutMs=10},true),true)
        equal(mechanism:getCachedTransitSettlement(v).settled,false)
        g_time=g_time+20
        equal(mechanism:getCachedTransitSettlement(v).exhausted,true)
    end)

    test("Bypass non-active blocker gains no speed authority and activity change invalidates stability",function()
        local f=fixture();local result=f.dispatch();equal(result.status,"ACCEPTED")
        equal(f.runtime.bubbleBulletTime:getProtection(result.commitment.identity).status,"NOT_REQUIRED")
        f.configuration.settled=true;f.control:update();equal(#f.drive.moves,1)
        f.episodes["AS-B"]={identity="NEW",sourceJobToken="new"};f.s.aiStates.b.observedActive=true
        f.publish();f.control:update();equal(f.control:isActive(),false);equal(#f.drive.moves,1)
    end)

    test("Bypass preserves active GIANTS passenger presence without inventing Player Claim",function()
        local f=fixture(true);f.s.playerControl.m.playerEntered=true;f.s.playerControl.b.playerEntered=true
        assert(f.group())
        f.s.playerControl.m.playerControlled=true;equal(f.group(),nil)
    end)

end
