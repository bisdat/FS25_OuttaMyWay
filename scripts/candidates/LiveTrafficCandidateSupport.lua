-- FS25_OuttaMyWay v4.7.44 implementation TEST BUILD.
--
-- Promotes the settled D-0113/D-0115/D-0118 initial pure-head-on role
-- comparison into the live Candidate/Constraint/Decision path without an
-- operator role pin. The bounded test scope is deliberately narrow:
--   * same active Encounter / same Job Episodes;
--   * positive field-bounded Future-Space interaction;
--   * both Local Intents SETTLED_CONTINUATION;
--   * both workers have positive Productive Continuation evidence;
--   * headings are positively established as cleanly opposed by the bounded test-fit gate;
--   * positive current physical interaction has not already begun.
--
-- Both admissible Yield assignments are published as materially equivalent
-- Reposition candidates when no stronger settled preference distinguishes
-- them. D-0118 then permits a deterministic implementation tie-break with no
-- policy meaning. The selected candidate still dispatches the established P22
-- TS015 relocation harness, so production Refuge Region qualification,
-- transition clearance, Safe Release and general Control authority remain
-- explicitly unimplemented in this test build.

OuttaMyWay.LiveTrafficCandidateSupport = {}
local Support = OuttaMyWay.LiveTrafficCandidateSupport
Support.__index = Support

local mandatory = {
    "FIELD_WORLD_CONTAINMENT","TRANSITION_CLEARANCE","REPRESENTATION_FITNESS",
    "CONTROL_CAPABILITY_AVAILABILITY","CONTINUING_INTENT_PRIORITY",
    "PROGRESS_PRESERVATION","RESPONSIBILITY_COMPATIBILITY",
    "OBLIGATION_COMPATIBILITY","COMMITMENT_PRECONDITIONS",
    "EFFECTIVE_ACTUATION_COMPOSITION","SAFE_RELEASE_HANDOVER"
}

local function packet(reason, evidence, applicable)
    return {
        result="PASS",
        applicable=applicable ~= false,
        evidence=evidence or {},
        provenance={source="LiveTrafficCandidateSupport",authority="BOUNDED_AUTONOMOUS_HEAD_ON_TEST"},
        reason=reason,
        revalidationTrigger={kind="NEXT_LIVE_OPERATIONAL_PICTURE"}
    }
end

local function responsibilityCompatible(picture, yieldAssemblyId)
    for _, relation in OuttaMyWay.ValueRecord.ipairs(picture.responsibilityRelations or {}) do
        if relation.relation == "FOLLOWER_OWNS_CLOSURE" and relation.leaderAssemblyId == yieldAssemblyId then
            return false
        end
    end
    return true
end

local function requirementKey(pair)
    return "traffic:" .. tostring(pair.encounterIdentity or pair.pairReferenceKey)
end

local function indexByAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do if item.assemblyId~=nil then result[item.assemblyId]=item end end
    return result
end

local function productiveByAssembly(picture)
    return indexByAssembly(picture.productiveContinuationKnowledge or {})
end

local function representationByAssembly(picture)
    return indexByAssembly(picture.representationFitness or {})
end

local function shadowByAssembly(picture)
    return indexByAssembly(picture.physicalSpaceEvidence or {})
end

local function encounterByInteraction(picture)
    local result={}
    for _,encounter in OuttaMyWay.ValueRecord.ipairs(picture.encounters or {}) do
        local key=encounter.evidence and encounter.evidence.interactionReferenceKey or nil
        if key~=nil then result[key]=encounter end
    end
    return result
end

local function relationshipRecords(picture)
    local result={}
    for _,situation in OuttaMyWay.ValueRecord.ipairs(picture.situations or {}) do
        for _,relationship in OuttaMyWay.ValueRecord.ipairs(situation.futureSpaceRelationships or {}) do
            result[#result+1]={situation=situation,relationship=relationship}
        end
    end
    table.sort(result,function(a,b) return tostring(a.relationship.interactionReferenceKey)<tostring(b.relationship.interactionReferenceKey) end)
    return result
end

local function participantRecords(pair)
    return {
        {
            yieldReferenceKey=pair.subjectAssemblyReferenceKey,
            progressReferenceKey=pair.otherAssemblyReferenceKey,
            yieldJobToken=pair.subjectSourceJobToken,
            progressJobToken=pair.otherSourceJobToken,
            yieldAssemblyId=pair.subjectAssemblyId,
            progressAssemblyId=pair.otherAssemblyId,
            shadowAvailable=pair.subjectShadowRepresentationAvailable == true,
            scalarFitness=pair.subjectRepresentationFitnessState
        },
        {
            yieldReferenceKey=pair.otherAssemblyReferenceKey,
            progressReferenceKey=pair.subjectAssemblyReferenceKey,
            yieldJobToken=pair.otherSourceJobToken,
            progressJobToken=pair.subjectSourceJobToken,
            yieldAssemblyId=pair.otherAssemblyId,
            progressAssemblyId=pair.subjectAssemblyId,
            shadowAvailable=pair.otherShadowRepresentationAvailable == true,
            scalarFitness=pair.otherRepresentationFitnessState
        }
    }
end

local function supportedAutonomousHeadOnPair(picture)
    local motion=indexByAssembly(picture.motionEvidence or {})
    local productive=productiveByAssembly(picture)
    local representations=representationByAssembly(picture)
    local shadows=shadowByAssembly(picture)
    local encounters=encounterByInteraction(picture)
    local lastReason="NO_ACTIVE_AUTONOMOUS_HEAD_ON"
    local matches={}

    for _,record in ipairs(relationshipRecords(picture)) do
        local relationship=record.relationship
        local subject=motion[relationship.subjectAssemblyId]
        local other=motion[relationship.otherAssemblyId]
        local encounter=encounters[relationship.interactionReferenceKey]
        if encounter==nil or encounter.lifecycleState~="ACTIVE" then
            lastReason="PAIR_NOT_ACTIVE_ENCOUNTER"
        elseif relationship.positiveIntersection~=true then
            lastReason="PAIR_HAS_NO_POSITIVE_FUTURE_SPACE_INTERSECTION"
        elseif subject==nil or other==nil then
            lastReason="PAIR_MOTION_KNOWLEDGE_UNAVAILABLE"
        elseif subject.localIntentClassification~="SETTLED_CONTINUATION" or other.localIntentClassification~="SETTLED_CONTINUATION" then
            lastReason="PAIR_NOT_SETTLED_CONTINUATION"
        elseif encounter.evidence and encounter.evidence.currentSpaceIntersects==true then
            lastReason="PAIR_ALREADY_IN_CURRENT_PHYSICAL_INTERACTION"
        else
            local headingDot=nil
            if tonumber(subject.headingX) and tonumber(subject.headingZ) and tonumber(other.headingX) and tonumber(other.headingZ) then
                headingDot=subject.headingX*other.headingX+subject.headingZ*other.headingZ
            end
            local subjectProductive=productive[relationship.subjectAssemblyId]
            local otherProductive=productive[relationship.otherAssemblyId]
            if headingDot==nil or headingDot>(OuttaMyWay.AUTONOMOUS_HEAD_ON_TEST_MAX_HEADING_DOT or -0.99) then
                lastReason="PAIR_HEADINGS_NOT_POSITIVELY_OPPOSED"
            elseif subjectProductive==nil or subjectProductive.productivePositive~=true or subjectProductive.jobToken~=subject.sourceJobToken then
                lastReason="SUBJECT_PRODUCTIVE_CONTINUATION_NOT_POSITIVE"
            elseif otherProductive==nil or otherProductive.productivePositive~=true or otherProductive.jobToken~=other.sourceJobToken then
                lastReason="OTHER_PRODUCTIVE_CONTINUATION_NOT_POSITIVE"
            else
                local subjectFit=representations[relationship.subjectAssemblyId]
                local otherFit=representations[relationship.otherAssemblyId]
                local pair={
                    pairReferenceKey=relationship.interactionReferenceKey,
                    encounterIdentity=encounter.identity,
                    subjectAssemblyId=relationship.subjectAssemblyId,
                    otherAssemblyId=relationship.otherAssemblyId,
                    subjectAssemblyReferenceKey=subject.assemblyReferenceKey,
                    otherAssemblyReferenceKey=other.assemblyReferenceKey,
                    subjectSourceJobToken=subject.sourceJobToken,
                    otherSourceJobToken=other.sourceJobToken,
                    subjectShadowRepresentationAvailable=shadows[relationship.subjectAssemblyId]~=nil,
                    otherShadowRepresentationAvailable=shadows[relationship.otherAssemblyId]~=nil,
                    subjectRepresentationFitnessState=subjectFit and subjectFit.state or nil,
                    otherRepresentationFitnessState=otherFit and otherFit.state or nil,
                    headingDot=headingDot,
                    subjectLocalIntentClassification=subject.localIntentClassification,
                    otherLocalIntentClassification=other.localIntentClassification,
                    futureSpacePositive=true,
                    currentSpaceIntersects=false
                }
                matches[#matches+1]={pair=pair,subjectEvidence=subjectProductive,otherEvidence=otherProductive}
            end
        end
    end
    if #matches==0 then return nil,lastReason end
    if #matches>1 then return nil,"MULTIPLE_SIMULTANEOUS_AUTONOMOUS_HEAD_ON_MATCHES" end
    return matches[1],nil
end

local function bandExhaustion(pictureId, governingRequirementKey, capability, reason)
    return {
        result="PASS",
        operationalPictureId=pictureId,
        governingRequirementKey=governingRequirementKey,
        capability=capability,
        reason=reason,
        evidence={pureEstablishedHeadOn=true,productionPriorityAuthority=true,operatorPin=false},
        provenance={source="LiveTrafficCandidateSupport",authority="D0113_D0115_D0118_BOUNDED_HEAD_ON"}
    }
end

function Support.new(identityRegistry, epochSequence, passiveSupport)
    return setmetatable({
        identities=identityRegistry,
        epochs=epochSequence,
        passiveSupport=passiveSupport,
        publishedCount=0,
        lastStatus="PASSIVE"
    }, Support)
end


function Support:markAutonomousHeadOnDispatched(governingRequirementKey)
    if type(governingRequirementKey) == "string" and governingRequirementKey ~= "" then
        -- v4.7.54: this is diagnostic only. A prior head-on resolution must not
        -- consume head-on competence for the lifetime of the Encounter. Duplicate
        -- actuation is bounded by the currently active refuge-resolution harness.
        self.lastStatus = "AUTONOMOUS_HEAD_ON_DISPATCHED_ACTIVE_RESOLUTION_GUARDS_REDISPATCH"
    end
end

function Support:resetAutonomousState()
    self.lastStatus = "PASSIVE"
end

function Support:getLastStatus() return self.lastStatus end

local function makeCandidateSpecification(pictureId, pictureEpoch, match, role, governingRequirementKey, representationId)
    local constraints = {}
    for _, id in ipairs(mandatory) do
        constraints[id] = packet("bounded autonomous initial-head-on test constraint", {productionAuthority=false})
    end
    constraints.FIELD_WORLD_CONTAINMENT = packet(
        "P22 TS015 refuses movement unless its fixture target passes same-source-field sampling",
        {validation="P22_TS015_PRE_MOVEMENT_FAIL_CLOSED",productionRefugeAuthority=false})
    constraints.TRANSITION_CLEARANCE = packet(
        "Production transition-clearance authority is not yet promoted; the established TS015 fixture clearance boundary remains test-only",
        {fixtureAssumption=true,productionTransitionClearanceAuthority=false})
    constraints.CONTROL_CAPABILITY_AVAILABILITY = packet(
        "Established P22 TS015 Hold/compact/forward-Reposition/restoration mechanisms are available to the selected bounded head-on candidate",
        {testHarness="Prototype22TS015Relocation",productionControlAuthority=false})
    constraints.CONTINUING_INTENT_PRIORITY = packet(
        "Both participants are positively Productive; D-0113 therefore supplies no Productive Continuation preference and D-0118 permits downstream comparison",
        {productiveTie=true,semanticPriorityTie=true,deterministicTieBreakPolicyMeaning=false})
    constraints.PROGRESS_PRESERVATION = packet(
        "The alternate participant remains GIANTS-owned Progress while the selected Yield participant is relocated",
        {progressParticipantReferenceKey=role.progressReferenceKey,giantsAuthorityPreserved=true})
    constraints.RESPONSIBILITY_COMPATIBILITY = packet(
        "No Follower-Owns-Closure relation prohibits this Yield assignment in the current Operational Picture",
        {yieldAssemblyId=role.yieldAssemblyId})
    constraints.OBLIGATION_COMPATIBILITY = packet(
        "The bounded live test now creates explicit Native Continuation Restoration and Durable Separation obligations inside one continuing Commitment",
        {testOnly=true,liveCommitmentKernel=true,productionDurableSeparationAuthority=false})
    constraints.COMMITMENT_PRECONDITIONS = packet(
        "Physical actuation dispatches only after the real live Decision selects one of the two autonomous role candidates",
        {operatorCommandRequired=false})
    constraints.EFFECTIVE_ACTUATION_COMPOSITION = packet(
        "Only the selected Yield participant receives P22 movement authority; the Progress participant remains GIANTS-owned",
        {yieldAssemblyId=role.yieldAssemblyId,progressAssemblyId=role.progressAssemblyId,neverHoldAll=true})
    constraints.SAFE_RELEASE_HANDOVER = packet(
        "Production Safe Release is not claimed; the existing P22 restoration/handoff evidence harness remains test-only",
        {productionSafeReleaseAuthority=false,p22RestorationHarness=true})

    return {
        referenceKey="auto-head-on-reposition:" .. tostring(role.yieldReferenceKey),
        purpose={kind="AUTONOMOUS_INITIAL_HEAD_ON",result="PROGRESS_BEYOND_INITIAL_HEAD_ON"},
        subject={assemblyId=role.yieldAssemblyId,assemblyIds={role.yieldAssemblyId}},
        capability="REPOSITION",
        expectedEffect={
            physicalChange=true,
            testHarness="Prototype22TS015Relocation",
            progressParticipantGiantsAuthorityPreserved=true,
            productionRoleSelection=true,
            productionRefugeQualification=false,
            multiStageCommitment=true,
            recoveryAdmissionRequiresCurrentTrafficCompatibility=true,
            mechanicalHandoverDoesNotSettleTrafficCommitment=true
        },
        evidenceBasis={
            constraintEvidence=constraints,
            governingBasis={
                responsibilityKey=governingRequirementKey,
                operationIds=pictureEpoch.identities.operations.active,
                sourceIntentIds=pictureEpoch.identities.jobEpisodes.active
            },
            -- "progressActuationOwnership" means OTM physical-actuation ownership,
            -- not the traffic-role Progress participant. For REPOSITION this is
            -- exactly the selected Yield assembly; Progress remains GIANTS-owned.
            progressActuationOwnership={assemblyIds={role.yieldAssemblyId}},
            effectiveActuationComposition={
                identity="auto-head-on-composition:" .. tostring(role.yieldAssemblyId) .. ":" .. pictureId,
                epoch=pictureEpoch.epoch,
                relevantAssemblyIds={role.yieldAssemblyId,role.progressAssemblyId},
                entries={{
                    assemblyId=role.yieldAssemblyId,
                    commitmentId="$NEW_COMMITMENT",
                    capability="REPOSITION",
                    effectClass="MOVE",
                    progressActuation=true
                }}
            },
            trafficPolicemanPreference={
                primaryResolution=true,
                governingRequirementKey=governingRequirementKey,
                exhaustionEvidence={
                    CONTINUE_OBSERVATION=bandExhaustion(
                        pictureId, governingRequirementKey, "CONTINUE_OBSERVATION",
                        "Positive same-Operation same-Job opposed Productive Future-Space conflict makes further observation non-directive for the established initial head-on"),
                    REGULATE_SPEED=bandExhaustion(
                        pictureId, governingRequirementKey, "REGULATE_SPEED",
                        "D-0115: bounded creep cannot resolve the pure established head-on spatial incompatibility"),
                    HOLD=bandExhaustion(
                        pictureId, governingRequirementKey, "HOLD",
                        "D-0115: in-path Hold would leave the selected Yield participant as a Static Obstacle for GIANTS-owned Progress")
                }
            },
            autonomousHeadOnBridge={
                yieldParticipantReferenceKey=role.yieldReferenceKey,
                progressParticipantReferenceKey=role.progressReferenceKey,
                yieldJobToken=role.yieldJobToken,
                progressJobToken=role.progressJobToken,
                pairReferenceKey=match.pair.pairReferenceKey,
                encounterIdentity=match.pair.encounterIdentity,
                governingRequirementKey=governingRequirementKey,
                roleSelectionAuthority="D0113_TIE_THEN_D0118_COMPARISON",
                deterministicTieBreakPolicyMeaning=false,
                operatorPin=false,
                productionRefugeQualification=false
            }
        },
        representationFitness={requirements={{representationId=representationId,acceptedStates={"USABLE_WITH_UNCERTAINTY"}}}},
        preconditions={
            evidenceContracts={},
            operatorCommandRequired=false,
            sameJobEpisodes=true,
            settledContinuation=true,
            bothProductiveContinuation=true,
            opposedHeadings=true,
            opposedHeadingDot=match.pair.headingDot,
            opposedHeadingThreshold=OuttaMyWay.AUTONOMOUS_HEAD_ON_TEST_MAX_HEADING_DOT,
            positiveFutureSpaceIntersection=true
        },
        invalidationConditions={
            {kind="JOB_EPISODE_CHANGE"},{kind="ENCOUNTER_CHANGE"},{kind="LOCAL_INTENT_CHANGE"},{kind="CURRENT_PHYSICAL_INTERACTION"}
        },
        reversibility={physicalEffect=true,restorationHarness="P22_TS015"},
        obligationsCreated={
            {
                origin={kind="OTM_MATERIAL_DISPLACEMENT",decision="D-0122",encounterIdentity=match.pair.encounterIdentity},
                basis={kind="NATIVE_CONTINUATION_RESTORATION",yieldReferenceKey=role.yieldReferenceKey,progressReferenceKey=role.progressReferenceKey},
                requiredOutcome={kind="NATIVE_CONTINUATION_RESTORED_AND_GIANTS_REACQUIRED",yieldReferenceKey=role.yieldReferenceKey,jobToken=role.yieldJobToken},
                requiredAuthority={capabilities={"REPOSITION","RESTORE_CONFIGURATION","HANDOVER_TO_GIANTS"}},
                evidenceContract={kind="POSITIVE_SAME_JOB_NATIVE_REACQUISITION"},
                ownershipClass="ORIGIN_BOUND",transferPolicy={allowed=false},terminalDependency=true
            },
            {
                origin={kind="TRAFFIC_INTERVENTION",decision="D-0119",encounterIdentity=match.pair.encounterIdentity},
                basis={kind="DURABLE_SEPARATION",governingRequirementKey=governingRequirementKey},
                requiredOutcome={kind="DURABLE_SEPARATION_SUPPORTED",encounterIdentity=match.pair.encounterIdentity},
                requiredAuthority={trafficPoliceman=true},
                evidenceContract={kind="CONTINUATION_AWARE_TRAFFIC_SETTLEMENT_NO_FIXED_DISTANCE_OR_TIME"},
                ownershipClass="CONTINUITY",transferPolicy={allowed=false},terminalDependency=true
            }
        },
        releaseImplications={productionSafeReleaseAuthority=false,p22RestorationObservationOnly=true,mechanicalHandoverDoesNotSettleTrafficCommitment=true},
        uncertainty={
            "PRODUCTION_REFUGE_REGION_QUALIFICATION_UNIMPLEMENTED",
            "PRODUCTION_TRANSITION_CLEARANCE_UNIMPLEMENTED",
            "PRODUCTION_GUARDED_RECOVERY_GENERALISATION_INCOMPLETE"
        },
        -- D-0118 permits deterministic implementation tie-breaks only after
        -- material equivalence. The bounded TS015 reciprocal live tests support
        -- both role assignments mechanically; no semantic priority is encoded.
        comparisonCost=1
    }
end


-- D-0141 aligned follower-boundary candidate support.  The Situation layer has
-- already decided whether current topology + a Provisional Demand Seed are
-- Representation-Fit enough to support follower protection.  Candidate support
-- does not inspect raw GIANTS state or historical manoeuvre probes.
local function followerBoundaryRecord(picture)
    if OuttaMyWay.FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED~=true then return nil,nil end
    local actionable={}
    for _,record in OuttaMyWay.ValueRecord.ipairs(picture.followerBoundaryKnowledge or {}) do
        local existing=type(record.existingCommitmentId)=="string"
        if record.status=="RETIRE_SUPPORTED" and existing then
            actionable[#actionable+1]={record=record,priority=1}
        elseif record.status=="UNRESOLVED" and existing then
            actionable[#actionable+1]={record=record,priority=2}
        elseif record.status=="REGULATE_SUPPORTED" then
            actionable[#actionable+1]={record=record,priority=existing and 2 or 3}
        end
    end
    if #actionable==0 then return nil,nil end
    table.sort(actionable,function(a,b)
        if a.priority~=b.priority then return a.priority<b.priority end
        return tostring(a.record.pairKey)<tostring(b.record.pairKey)
    end)
    local best=actionable[1]
    local same=0
    for _,entry in ipairs(actionable) do if entry.priority==best.priority then same=same+1 end end
    if same>1 then return nil,"MULTIPLE_SIMULTANEOUS_FOLLOWER_BOUNDARY_CONTEXTS" end
    return best.record,nil
end

local function followerPacket(reason,evidence)
    return {
        result="PASS",applicable=true,evidence=evidence or {},reason=reason,
        provenance={source="LiveTrafficCandidateSupport",authority="D0141_ALIGNED_FOLLOWER_BOUNDARY"},
        revalidationTrigger={kind="NEXT_LIVE_OPERATIONAL_PICTURE"}
    }
end

local function followerConstraints(record,physicalCandidate)
    local constraints={}
    local transition=record.transitionPreservation==true
    for _,id in ipairs(mandatory) do constraints[id]=followerPacket("D-0141 aligned follower-boundary candidate constraint",{pairKey=record.pairKey}) end
    constraints.FIELD_WORLD_CONTAINMENT=followerPacket("The protected pair remains inside the same active Field World Operation",{operationId=record.operationId})
    constraints.TRANSITION_CLEARANCE=followerPacket(transition and "An already-admitted follower purpose is being rate-bounded by the leader's current GIANTS native transition command" or "Regulation preserves ordering before follower boundary demand matures; it does not invent a route or manoeuvre pose",{provisionalDemandSeed=not transition,transitionPreservation=transition})
    constraints.REPRESENTATION_FITNESS=followerPacket(transition and "Existing follower purpose plus a positive immediate GIANTS transition-rate observation support magnitude maintenance only" or "Current Adjacent Following topology and the explicit Provisional Demand Seed are the only active follower-demand representations",{representationFitness=record.representationFitness,historicalNativeManoeuvreAuthority=false,transitionPreservation=transition})
    constraints.CONTROL_CAPABILITY_AVAILABILITY=followerPacket(physicalCandidate and "Existing bounded P22 Regulation lease can cap GIANTS-native follower speed only" or "No new physical capability is required",{giantsRoutePreserved=true,giantsSteeringPreserved=true})
    constraints.CONTINUING_INTENT_PRIORITY=followerPacket(transition and "The existing follower obligation is retained while GIANTS transitions the leader; only follower speed magnitude is updated" or "Both participants are positively Productive and co-directional; this candidate preserves their existing GIANTS continuations",{leaderAssemblyId=record.leaderAssemblyId,followerAssemblyId=record.followerAssemblyId,transitionPreservation=transition})
    constraints.PROGRESS_PRESERVATION=followerPacket("Follower remains GIANTS-owned Progress; only its current speed ceiling may be bounded",{followerAssemblyId=record.followerAssemblyId})
    constraints.RESPONSIBILITY_COMPATIBILITY=followerPacket("Follower-boundary protection is pair-scoped and composes inside the current unresolved traffic responsibility",{existingCommitmentId=record.existingCommitmentId})
    constraints.OBLIGATION_COMPATIBILITY=followerPacket("One explicit follower-boundary ordering obligation owns purpose persistence until positive retirement",{existingObligationId=record.existingObligationId})
    constraints.COMMITMENT_PRECONDITIONS=followerPacket("Physical Regulation requires a selected all-PASS Candidate and a live Commitment",{existingCommitmentId=record.existingCommitmentId})
    constraints.EFFECTIVE_ACTUATION_COMPOSITION=followerPacket(physicalCandidate and "Follower speed Regulation composes with independent purpose-bound leases under the same Commitment" or "No new actuation is proposed",{neverHoldAll=true})
    constraints.SAFE_RELEASE_HANDOVER=followerPacket("Retirement requires positive purpose invalidation/satisfaction; absence or temporary uncertainty cannot release the purpose",{stickyPurpose=true,elasticMagnitude=true})
    return constraints
end

local function followerRepresentation(values,pictureId,record)
    local representationId="d0141-follower-demand:"..tostring(record.pairKey)..":"..tostring(pictureId)
    values.representationFitness=values.representationFitness or {}
    values.representationFitness[#values.representationFitness+1]={
        representationId=representationId,
        assemblyId=record.followerAssemblyId,
        question="FOLLOWER_BOUNDARY_DEMAND_REGULATION",
        assessmentHorizon=record.transitionPreservation==true and "EXISTING_FOLLOWER_PURPOSE_PLUS_CURRENT_NATIVE_TRANSITION_RATE" or "CURRENT_ADJACENT_FOLLOWING_PLUS_PROVISIONAL_DEMAND_SEED",
        state="USABLE_WITH_UNCERTAINTY",
        claimPermissions={"FOLLOWER_BOUNDARY_REGULATION"},
        coverage={complete=false,conservative=true},
        uncertainty=record.transitionPreservation==true and {"TRANSITION_RATE_MAGNITUDE_ONLY","NATIVE_ROUTE_REMAINS_UNRESOLVED"} or (record.demandSeed and record.demandSeed.uncertainty or {"PROVISIONAL_DEMAND_SEED"}),
        validityDependencies=record.transitionPreservation==true and {"EXISTING_FOLLOWER_PURPOSE","CURRENT_GIANTS_NATIVE_TRANSITION_RATE"} or {"CURRENT_ADJACENT_FOLLOWING_TOPOLOGY","CURRENT_PRODUCTIVE_CONTINUATION","PROVISIONAL_DEMAND_SEED"},
        provenance={source="FollowerBoundaryDemandAssessment",layer="KNOWLEDGE",historicalNativeManoeuvreAuthority=false}
    }
    return representationId
end

local function followerObligation(record)
    return {
        origin={kind="TRAFFIC_INTERVENTION",decision="D-0141",pairKey=record.pairKey},
        basis={kind="FOLLOWER_BOUNDARY_PROTECTION",pairKey=record.pairKey,
            leaderAssemblyId=record.leaderAssemblyId,followerAssemblyId=record.followerAssemblyId,
            leaderName=record.leaderName,followerName=record.followerName,
            leaderReferenceKey=record.leaderReferenceKey,followerReferenceKey=record.followerReferenceKey,
            governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING"},
        requiredOutcome={kind="FOLLOWER_BOUNDARY_ORDERING_PRESERVED_UNTIL_POSITIVE_RETIREMENT",pairKey=record.pairKey},
        requiredAuthority={capabilities={"REGULATE_SPEED"},trafficPoliceman=true},
        evidenceContract={kind="POSITIVE_CURRENT_RELATIONSHIP_INVERSE_OR_PURPOSE_SUCCESSION",absenceDoesNotRetire=true},
        ownershipClass="CONTINUITY",transferPolicy={allowed=false},terminalDependency=true
    }
end

local function followerSpecification(pictureId,pictureValues,record,representationId)
    local requirement="follower-boundary:"..tostring(record.operationId)..":"..tostring(record.leaderAssemblyId)..":"..tostring(record.followerAssemblyId)
    local existing=type(record.existingCommitmentId)=="string"
    local capability="CONTINUE_OBSERVATION"
    local operation="PRESERVE"
    if record.status=="RETIRE_SUPPORTED" then capability="CONTINUE_UNCHANGED"; operation="RETIRE"
    elseif record.status=="REGULATE_SUPPORTED" then capability="REGULATE_SPEED"; operation="APPLY" end
    local physicalCandidate=capability=="REGULATE_SPEED"
    local exhaustion={}
    if physicalCandidate then
        local currentlyRestrictive=record.controlMagnitude and record.controlMagnitude.regulationRequired==true
        local exhaustionReason=currentlyRestrictive
            and "Positive Action-Space Compression evidence shows unrestricted native follower progression would mature before leader demand can vacate"
            or "Previously admitted follower-protection purpose remains positively current; elastic magnitude may relax without treating temporary current supportability as retirement"
        exhaustion.CONTINUE_OBSERVATION={
            result="PASS",operationalPictureId=pictureId,governingRequirementKey=requirement,capability="CONTINUE_OBSERVATION",
            reason=exhaustionReason,
            evidence={pairKey=record.pairKey,relationship=record.relationship,demandSeed=record.demandSeed,controlMagnitude=record.controlMagnitude,existingPurpose=existing,currentMagnitudeRestrictive=currentlyRestrictive},
            provenance={source="FollowerBoundaryDemandAssessment",authority="D0141_OBSERVE_EXHAUSTION"}
        }
    end
    local constraints=followerConstraints(record,physicalCandidate)
    local preference=nil
    if capability~="CONTINUE_UNCHANGED" then preference={primaryResolution=true,governingRequirementKey=requirement,exhaustionEvidence=exhaustion} end
    local evidence={
        constraintEvidence=constraints,
        governingBasis={responsibilityKey=requirement,operationIds=pictureValues.identities.operations.active,sourceIntentIds=pictureValues.identities.jobEpisodes.active},
        maintainsExistingCommitment=existing or (#(pictureValues.commitmentContext or {})==1),
        existingProgressMayContinue=true,
        trafficPolicemanPreference=preference,
        followerBoundaryBridge={
            action=operation,pairKey=record.pairKey,operationId=record.operationId,
            leaderAssemblyId=record.leaderAssemblyId,followerAssemblyId=record.followerAssemblyId,
            leaderName=record.leaderName,followerName=record.followerName,
            leaderReferenceKey=record.leaderReferenceKey,followerReferenceKey=record.followerReferenceKey,
            existingCommitmentId=record.existingCommitmentId,existingObligationId=record.existingObligationId,
            governingRequirementKey=requirement,governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING",
            requestedFollowerCapKmh=record.controlMagnitude and record.controlMagnitude.requestedFollowerCapKmh or nil,
            nativeUnrestrictedFollowerKmh=record.controlMagnitude and record.controlMagnitude.nativeUnrestrictedFollowerKmh or nil,
            leaderRateUsedKmh=record.controlMagnitude and record.controlMagnitude.leaderRateUsedKmh or nil,
            transitionPreservation=record.transitionPreservation==true,
            representationId=representationId,reason=record.reason,purposeState=record.purposeState
        }
    }
    if physicalCandidate then
        evidence.progressActuationOwnership={assemblyIds={record.followerAssemblyId}}
        evidence.effectiveActuationComposition={
            identity="d0141-composition:"..tostring(record.pairKey)..":"..tostring(pictureId),epoch=pictureValues.epoch,
            relevantAssemblyIds={record.leaderAssemblyId,record.followerAssemblyId},
            entries={{assemblyId=record.followerAssemblyId,commitmentId=record.existingCommitmentId or "$NEW_COMMITMENT",capability="REGULATE_SPEED",effectClass="SPEED_LIMIT",progressActuation=true}}
        }
    end
    return {
        referenceKey="d0141:"..string.lower(capability)..":"..tostring(record.pairKey),
        purpose={kind="FOLLOWER_BOUNDARY_DEMAND_PROTECTION",result=operation=="RETIRE" and "RETIRE_SUPERSEDED_OR_SATISFIED_FOLLOWER_PURPOSE" or "PRESERVE_BOUNDARY_TRANSITION_ORDERING"},
        subject={assemblyId=record.followerAssemblyId,assemblyIds={record.followerAssemblyId}},capability=capability,
        expectedEffect=physicalCandidate and {physicalChange=true,speedCeilingOnly=true,giantsRoute=true,giantsSteering=true,giantsDirection=true,elasticMagnitude=true} or {physicalChange=false,existingProgressMayContinue=true},
        evidenceBasis=evidence,
        representationFitness=physicalCandidate and {requirements={{representationId=representationId,acceptedStates={"USABLE_WITH_UNCERTAINTY"}}}} or {requirements={}},
        preconditions={evidenceContracts={},existingCommitmentId=record.existingCommitmentId,relationshipStatus=record.relationship and record.relationship.status,
            boundedObservationContract=capability=="CONTINUE_OBSERVATION" and {knowledgeGap="CURRENT_FOLLOWER_BOUNDARY_PURPOSE_REASSESSMENT",expectedRealityEvolution="CURRENT_TOPOLOGY_OR_NATIVE_COMMAND_CHANGES",preservedUsefulAction="EXISTING_PURPOSE_AND_LEASE_REMAIN_UNCHANGED",exhaustionCondition="POSITIVE_REGULATION_OR_RETIREMENT_EVIDENCE",reassessmentDeadline="NEXT_LIVE_OPERATIONAL_PICTURE",progressParticipantId=record.followerAssemblyId} or nil},
        invalidationConditions={{kind="CURRENT_FOLLOWING_RELATIONSHIP_CHANGE"},{kind="JOB_EPISODE_CHANGE"},{kind="PROGRESS_PASSAGE_PURPOSE_SUCCESSION"}},
        reversibility={physicalEffect=physicalCandidate,releaseOnPurposeExpiry=true},
        obligationsCreated=(physicalCandidate and not existing) and {followerObligation(record)} or {},
        releaseImplications={trafficSettlement=false,releaseOnlyPurposeBoundFollowerRegulation=operation=="RETIRE"},
        uncertainty=record.demandSeed and record.demandSeed.uncertainty or {"CURRENT_PURPOSE_REASSESSMENT"},
        comparisonCost=0
    },requirement
end

local function attachFollowerBoundary(self,picture,snapshot,record)
    local values=OuttaMyWay.ValueRecord.toTable(picture)
    local pictureId=self.identities:issue("PICTURE")
    values.identity=pictureId; values.epoch=self.epochs:next()
    values.provenance={source="LiveTrafficCandidateSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity,authority="D0141_ALIGNED_FOLLOWER_BOUNDARY"}
    local representationId=followerRepresentation(values,pictureId,record)
    local specification,requirement=followerSpecification(pictureId,values,record,representationId)
    local decisionPolicy=nil
    if specification.capability~="CONTINUE_UNCHANGED" then decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=requirement} end
    values.candidateSupportEvidence={
        complete=true,
        supportBoundary={mode="FOLLOWER_BOUNDARY_D0141",supportedCandidateClasses={specification.capability},physicalCapabilitiesImplemented=specification.capability=="REGULATE_SPEED",controlAuthority=false,boundedScope="CURRENT_ADJACENT_FOLLOWING_WITH_PROVISIONAL_DEMAND_SEED",decisionPolicy=decisionPolicy},
        candidateSpecifications={specification},
        provenance={source="LiveTrafficCandidateSupport",observationSnapshotId=snapshot.identity,authority="D0141_ALIGNED_FOLLOWER_BOUNDARY"}
    }
    self.publishedCount=self.publishedCount+1
    self.lastStatus="FOLLOWER_BOUNDARY_"..tostring(record.status).."_CANDIDATE_PUBLISHED"
    return OuttaMyWay.OperationalPicture.new(values)
end


local function activeGuardedRecovery(picture)
    local matches={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(picture.guardedRecoveryKnowledge or {}) do
        if item.nativeReacquired~=true and item.activeRecovery==true and type(item.commitmentId)=="string" then matches[#matches+1]=item end
    end
    if #matches==1 then return matches[1] end
    if #matches>1 then return nil,"MULTIPLE_ACTIVE_GUARDED_RECOVERY_CONTEXTS" end
    return nil,nil
end

local function guardPacket(reason,evidence)
    return {
        result="PASS",applicable=true,evidence=evidence or {},reason=reason,
        provenance={source="LiveTrafficCandidateSupport",authority="D0123_GUARDED_RECOVERY_BOUNDED_TEST"},
        revalidationTrigger={kind="NEXT_LIVE_OPERATIONAL_PICTURE"}
    }
end

local function guardConstraints(guard, physicalCandidate)
    local constraints={}
    for _,id in ipairs(mandatory) do constraints[id]=guardPacket("D-0123 Guarded Recovery bounded candidate constraint",{commitmentId=guard.commitmentId}) end
    constraints.FIELD_WORLD_CONTAINMENT=guardPacket("Guarded Recovery remains inside the already-admitted local Encounter/Refuge context",{existingCommitment=true})
    constraints.TRANSITION_CLEARANCE=guardPacket("D-0123 protects already-Committed recovery Action Space; no new Refuge transition is initiated",{existingRecovery=true})
    constraints.CONTROL_CAPABILITY_AVAILABILITY=guardPacket(physicalCandidate and "Existing P22 Regulation capability can bound GIANTS-owned Progress without replacing route or steering" or "No new physical capability is required while Observe remains supportable",{giantsRoutePreserved=true})
    constraints.CONTINUING_INTENT_PRIORITY=guardPacket("Current D-0123 evidence protects an existing recovery obligation and does not assign new production route priority",{guardedRecovery=true})
    constraints.PROGRESS_PRESERVATION=guardPacket("Progress remains GIANTS-owned; Regulation changes only the bounded speed ceiling",{progressReferenceKey=guard.progressReferenceKey,giantsAuthorityPreserved=true})
    constraints.RESPONSIBILITY_COMPATIBILITY=guardPacket("The existing Commitment already owns recovery responsibility",{commitmentId=guard.commitmentId})
    constraints.OBLIGATION_COMPATIBILITY=guardPacket("Candidate protects the existing Native Continuation Restoration obligation and creates no new obligation",{commitmentId=guard.commitmentId})
    constraints.COMMITMENT_PRECONDITIONS=guardPacket("Candidate is valid only for the named live Guarded Recovery Commitment",{commitmentId=guard.commitmentId})
    constraints.EFFECTIVE_ACTUATION_COMPOSITION=guardPacket(physicalCandidate and "Existing Yield Reposition and temporary Progress speed Regulation are composable under one Commitment" or "No new actuation composition is proposed",{neverHoldAll=true})
    constraints.SAFE_RELEASE_HANDOVER=guardPacket("D-0123 Regulation retirement is purpose expiry, not traffic settlement",{mechanicalHandoverDoesNotSettleTraffic=true})
    return constraints
end

local function guardedRecoverySpecification(pictureId,pictureValues,guard)
    local requirement=guard.governingRequirementKey or ("guarded-recovery:"..tostring(guard.commitmentId))
    local positive=guard.signalStatus=="POSITIVE"
    local capability=positive and "REGULATE_SPEED" or "CONTINUE_OBSERVATION"
    local constraints=guardConstraints(guard,positive)
    local exhaustion={}
    if positive then
        exhaustion.CONTINUE_OBSERVATION={
            result="PASS",operationalPictureId=pictureId,governingRequirementKey=requirement,capability="CONTINUE_OBSERVATION",
            reason="D-0123 positive Convergent Projection intersection consumes protected recovery Action Space; Observe is exhausted",
            evidence={signalStatus=guard.signalStatus,reason=guard.reason,combination=guard.combination},
            provenance={source="SituationAssessment.GuardedRecovery",authority="D0123_OBSERVE_EXHAUSTION"}
        }
    end
    local evidence={
        constraintEvidence=constraints,
        governingBasis={responsibilityKey=requirement,operationIds=pictureValues.identities.operations.active,sourceIntentIds=pictureValues.identities.jobEpisodes.active},
        maintainsExistingCommitment=true,existingProgressMayContinue=true,
        trafficPolicemanPreference={primaryResolution=true,governingRequirementKey=requirement,exhaustionEvidence=exhaustion},
        guardedRecoveryBridge={
            commitmentId=guard.commitmentId,governingRequirementKey=requirement,encounterIdentity=guard.encounterIdentity,
            yieldAssemblyId=guard.yieldAssemblyId,progressAssemblyId=guard.progressAssemblyId,
            yieldReferenceKey=guard.yieldReferenceKey,progressReferenceKey=guard.progressReferenceKey,
            progressJobToken=guard.progressJobToken,governingPurpose=guard.governingPurpose,
            signalStatus=guard.signalStatus,signalReason=guard.reason,representationId=guard.representationId
        }
    }
    local representation={requirements={}}
    if positive then
        evidence.progressActuationOwnership={assemblyIds={guard.progressAssemblyId}}
        evidence.effectiveActuationComposition={
            identity="d0123-composition:"..tostring(guard.commitmentId)..":"..pictureId,epoch=pictureValues.epoch,
            relevantAssemblyIds={guard.yieldAssemblyId,guard.progressAssemblyId},
            entries={
                {assemblyId=guard.yieldAssemblyId,commitmentId=guard.commitmentId,capability="REPOSITION",effectClass="MOVE",progressActuation=true},
                {assemblyId=guard.progressAssemblyId,commitmentId=guard.commitmentId,capability="REGULATE_SPEED",effectClass="SPEED_LIMIT",progressActuation=true}
            }
        }
        representation={requirements={{representationId=guard.representationId,acceptedStates={"FIT_FOR_LIMITED_HORIZON"}}}}
    end
    return {
        referenceKey="d0123:"..string.lower(capability)..":"..tostring(guard.commitmentId),
        purpose={kind="GUARDED_RECOVERY_PROTECTION",result=positive and "PRESERVE_COMMITTED_RECOVERY_ACTION_SPACE" or "CONTINUE_RECOVERY_WITH_BOUNDED_OBSERVATION"},
        subject={assemblyId=guard.progressAssemblyId,assemblyIds={guard.progressAssemblyId}},capability=capability,
        expectedEffect=positive and {physicalChange=true,giantsRoute=true,giantsSteering=true,giantsDirection=true,speedCeilingOnly=true} or {physicalChange=false,existingRecoveryMayContinue=true},
        evidenceBasis=evidence,representationFitness=representation,
        preconditions={
            evidenceContracts={},existingCommitmentId=guard.commitmentId,signalStatus=guard.signalStatus,
            boundedObservationContract=positive and nil or {
                knowledgeGap="CURRENT_GUARDED_RECOVERY_TRAFFIC_COMPATIBILITY",
                expectedRealityEvolution="RECOVERY_OR_PROGRESS_GEOMETRY_CHANGES",
                preservedUsefulAction="EXISTING_GUARDED_RECOVERY_CONTINUES_WITHOUT_NEW_PROGRESS_CONTROL",
                exhaustionCondition="SIGNAL_BECOMES_POSITIVE_OR_POSITIVE_NATIVE_REACQUISITION_ENDS_RECOVERY_WINDOW",
                reassessmentDeadline="NEXT_LIVE_OPERATIONAL_PICTURE",
                progressParticipantId=guard.progressAssemblyId
            }
        },
        invalidationConditions={{kind="GUARDED_RECOVERY_SIGNAL_CHANGE"},{kind="PROGRESS_JOB_EPISODE_CHANGE"},{kind="POSITIVE_GIANTS_REACQUISITION"}},
        reversibility={physicalEffect=positive,releaseOnPurposeExpiry=true},obligationsCreated={},
        releaseImplications={trafficSettlement=false,releaseOnlyPurposeBoundProgressRegulation=true},
        uncertainty=positive and {"D0123_SPEED_IS_TEMPORARY_TEST_LITERAL"} or {"CONTINUE_OBSERVATION_REQUIRES_NEXT_PICTURE_REASSESSMENT"},
        comparisonCost=0
    },requirement
end

local function attachGuardedRecovery(self,picture,snapshot,guard)
    local values=OuttaMyWay.ValueRecord.toTable(picture)
    local pictureId=self.identities:issue("PICTURE")
    values.identity=pictureId; values.epoch=self.epochs:next()
    values.provenance={source="LiveTrafficCandidateSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity,authority="D0123_GUARDED_RECOVERY_ALIGNMENT"}
    local specification,requirement=guardedRecoverySpecification(pictureId,values,guard)
    values.candidateSupportEvidence={
        complete=true,
        supportBoundary={mode="GUARDED_RECOVERY_D0123",supportedCandidateClasses={specification.capability},physicalCapabilitiesImplemented=specification.capability=="REGULATE_SPEED",controlAuthority=false,boundedScope="ACTIVE_GUARDED_RECOVERY_COMMITMENT",decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=requirement}},
        candidateSpecifications={specification},
        provenance={source="LiveTrafficCandidateSupport",observationSnapshotId=snapshot.identity,authority="D0123_GUARDED_RECOVERY_ALIGNMENT"}
    }
    self.publishedCount=self.publishedCount+1
    self.lastStatus="GUARDED_RECOVERY_"..tostring(guard.signalStatus).."_CANDIDATE_PUBLISHED"
    return OuttaMyWay.OperationalPicture.new(values)
end

local function followerMatchesHeadOn(follower,match)
    if type(follower)~="table" or type(match)~="table" or type(match.pair)~="table" then return false end
    local a,b=match.pair.subjectAssemblyId,match.pair.otherAssemblyId
    local leader,following=follower.leaderAssemblyId,follower.followerAssemblyId
    return (leader==a and following==b) or (leader==b and following==a)
end

function Support:attach(picture, snapshot)
    OuttaMyWay.ValueRecord.assertType(picture, "OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(snapshot, "ObservationSnapshot")

    local follower,followerReason=followerBoundaryRecord(picture)
    -- Positive follower retirement remains highest priority: once the protected
    -- purpose has genuinely ended (notably Progress Passage), its speed lease
    -- must be released before another strategy continues.
    if follower~=nil and follower.status=="RETIRE_SUPPORTED" then return attachFollowerBoundary(self,picture,snapshot,follower) end
    if followerReason~=nil then
        self.lastStatus=followerReason
        return self.passiveSupport:attach(picture,snapshot)
    end

    local guard,guardReason=activeGuardedRecovery(picture)
    if guard~=nil then return attachGuardedRecovery(self,picture,snapshot,guard) end
    if guardReason~=nil then
        self.lastStatus=guardReason
        return self.passiveSupport:attach(picture,snapshot)
    end

    -- v4.7.73 regression repair: an existing follower purpose may remain
    -- UNRESOLVED during the clean co-directional -> opposed transition so that
    -- its already-admitted Regulation lease is not discarded.  That preserved
    -- lease is supporting Control only; it must not suppress a positively
    -- established head-on REPOSITION candidate.  Evaluate the independent
    -- head-on picture before publishing the follower PRESERVE candidate.
    local match, reason = supportedAutonomousHeadOnPair(picture)
    if match == nil or (follower~=nil and not followerMatchesHeadOn(follower,match)) then
        if follower~=nil then return attachFollowerBoundary(self,picture,snapshot,follower) end
        self.lastStatus = reason or "NO_ACTIVE_AUTONOMOUS_HEAD_ON"
        return self.passiveSupport:attach(picture, snapshot)
    end

    local roles = participantRecords(match.pair)
    local admissible = {}
    for _, role in ipairs(roles) do
        if role.yieldAssemblyId ~= nil and role.progressAssemblyId ~= nil
            and role.shadowAvailable == true
            and responsibilityCompatible(picture, role.yieldAssemblyId) then
            admissible[#admissible+1] = role
        end
    end
    if #admissible == 0 then
        self.lastStatus = "NO_ADMISSIBLE_HEAD_ON_ROLE_ASSIGNMENT"
        return self.passiveSupport:attach(picture, snapshot)
    end

    local values = OuttaMyWay.ValueRecord.toTable(picture)
    local pictureId = self.identities:issue("PICTURE")
    values.identity = pictureId
    values.epoch = self.epochs:next()
    values.provenance = {
        source="LiveTrafficCandidateSupport",
        parentOperationalPictureId=picture.identity,
        observationSnapshotId=snapshot.identity,
        authority="BOUNDED_AUTONOMOUS_D0113_D0115_D0118",
        followerBoundarySupportingLeaseRetained=follower~=nil,
        followerBoundaryCandidateSupersededByPositiveHeadOn=follower~=nil
    }

    values.representationFitness = values.representationFitness or {}
    local representations = {}
    for _, role in ipairs(admissible) do
        local id = "auto-head-on-shadow:" .. tostring(role.yieldAssemblyId) .. ":" .. pictureId
        representations[role.yieldAssemblyId] = id
        values.representationFitness[#values.representationFitness + 1] = {
            representationId=id,
            assemblyId=role.yieldAssemblyId,
            question="P22_TS015_FIXTURE_REPOSITION_INITIATION",
            assessmentHorizon="CURRENT_TEST_DISPATCH_ONLY",
            state="USABLE_WITH_UNCERTAINTY",
            claimPermissions={"P22_TS015_FIXTURE_REPOSITION_INITIATION"},
            coverage={complete=false,conservative=false,underApproximationRisk=true},
            uncertainty={"NO_NEGATIVE_CLEARANCE_AUTHORITY","PRODUCTION_REFUGE_QUALIFICATION_UNIMPLEMENTED"},
            validityDependencies={"CURRENT_SHADOW_PLAN_VIEW_REPRESENTATION","SAME_JOB_EPISODES","SAME_OPERATIONAL_PICTURE"},
            provenance={source="LiveTrafficCandidateSupport",authority="TEST_FIXTURE_POSITIVE_SUPPORT_ONLY"}
        }
    end
    table.sort(values.representationFitness, function(a,b) return tostring(a.representationId) < tostring(b.representationId) end)

    local governingRequirementKey = requirementKey(match.pair)
    local specifications = {}
    for _, role in ipairs(admissible) do
        specifications[#specifications+1] = makeCandidateSpecification(pictureId, values, match, role, governingRequirementKey, representations[role.yieldAssemblyId])
    end
    table.sort(specifications, function(a,b) return a.referenceKey < b.referenceKey end)

    values.candidateSupportEvidence = {
        complete=true,
        supportBoundary={
            mode="AUTONOMOUS_HEAD_ON_RESOLUTION_TEST",
            supportedCandidateClasses={"REPOSITION"},
            physicalCapabilitiesImplemented=true,
            controlAuthority=false,
            productionRoleSelection=true,
            productionRefugeQualification=false,
            boundedScope="PURE_ESTABLISHED_OPPOSED_BOTH_PRODUCTIVE_HEAD_ON",
            decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=governingRequirementKey}
        },
        candidateSpecifications=specifications,
        provenance={
            source="LiveTrafficCandidateSupport",
            observationSnapshotId=snapshot.identity,
            authority="BOUNDED_AUTONOMOUS_D0113_D0115_D0118",
            operatorCommandRequired=false,
            productionRefugeAuthority=false
        }
    }

    self.publishedCount = self.publishedCount + 1
    self.lastStatus = "AUTONOMOUS_HEAD_ON_CANDIDATES_PUBLISHED"
    return OuttaMyWay.OperationalPicture.new(values)
end

function Support:getPublishedCount() return self.publishedCount end
