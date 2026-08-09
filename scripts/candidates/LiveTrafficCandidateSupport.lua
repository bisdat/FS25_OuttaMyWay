-- FS25_OuttaMyWay v4.7.44 implementation TEST BUILD.
--
-- Promotes the settled D-0113/D-0115/D-0118 initial pure-head-on role
-- comparison into the live Candidate/Constraint/Decision path without an
-- operator role pin. The bounded test scope is deliberately narrow:
--   * same active Encounter / same Job Episodes;
--   * positive field-bounded Future-Space interaction;
--   * both Local Intents SETTLED_CONTINUATION;
--   * both workers have positive Productive Continuation evidence;
--   * headings are opposed (negative heading dot);
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

local function productiveEvidence(source, referenceKey, jobToken)
    if source == nil or type(source.getEvidence) ~= "function" then return nil, "PRODUCTIVE_EVIDENCE_SOURCE_UNAVAILABLE" end
    local evidence = source:getEvidence(referenceKey, jobToken)
    if type(evidence) ~= "table" then return nil, "PRODUCTIVE_EVIDENCE_UNAVAILABLE" end
    if evidence.jobToken ~= jobToken then return nil, "PRODUCTIVE_EVIDENCE_JOB_MISMATCH" end
    if evidence.productivePositive ~= true then return nil, "PRODUCTIVE_CONTINUATION_NOT_POSITIVE" end
    return evidence, nil
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

local function supportedAutonomousHeadOnPair(picture, continuationSource, consumed)
    local diagnostics = picture.diagnostics or {}
    local pairs = {}
    for _, pair in OuttaMyWay.ValueRecord.ipairs(diagnostics.pairPipeline or {}) do pairs[#pairs+1] = pair end
    table.sort(pairs, function(a,b) return tostring(a.pairReferenceKey) < tostring(b.pairReferenceKey) end)

    local lastReason = "NO_ACTIVE_AUTONOMOUS_HEAD_ON"
    local matches = {}
    for _, pair in ipairs(pairs) do
        local key = requirementKey(pair)
        if consumed[key] then
            lastReason = "HEAD_ON_REQUIREMENT_ALREADY_DISPATCHED"
        elseif pair.sameOperation ~= true or pair.encounterActive ~= true or pair.evaluated ~= true then
            lastReason = "PAIR_NOT_ACTIVE_ENCOUNTER"
        elseif pair.futureSpacePositive ~= true and pair.fieldBoundedFutureSpacePositive ~= true then
            lastReason = "PAIR_HAS_NO_POSITIVE_FUTURE_SPACE_INTERSECTION"
        elseif pair.subjectLocalIntentClassification ~= "SETTLED_CONTINUATION"
            or pair.otherLocalIntentClassification ~= "SETTLED_CONTINUATION" then
            lastReason = "PAIR_NOT_SETTLED_CONTINUATION"
        elseif pair.currentSpaceIntersects == true or pair.currentFootprintIntersects == true then
            lastReason = "PAIR_ALREADY_IN_CURRENT_PHYSICAL_INTERACTION"
        elseif tonumber(pair.headingDot) == nil or tonumber(pair.headingDot) >= 0 then
            lastReason = "PAIR_HEADINGS_NOT_OPPOSED"
        else
            local subjectEvidence, subjectReason = productiveEvidence(continuationSource, pair.subjectAssemblyReferenceKey, pair.subjectSourceJobToken)
            local otherEvidence, otherReason = productiveEvidence(continuationSource, pair.otherAssemblyReferenceKey, pair.otherSourceJobToken)
            if subjectEvidence == nil then
                lastReason = "SUBJECT_" .. tostring(subjectReason)
            elseif otherEvidence == nil then
                lastReason = "OTHER_" .. tostring(otherReason)
            else
                matches[#matches+1] = {pair=pair, subjectEvidence=subjectEvidence, otherEvidence=otherEvidence}
            end
        end
    end
    if #matches == 0 then return nil, lastReason end
    if #matches > 1 then return nil, "MULTIPLE_SIMULTANEOUS_AUTONOMOUS_HEAD_ON_MATCHES" end
    return matches[1], nil
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
        continuationEvidenceSource=nil,
        consumedRequirements={},
        publishedCount=0,
        lastStatus="PASSIVE"
    }, Support)
end

function Support:setContinuationEvidenceSource(source)
    self.continuationEvidenceSource = source
end

function Support:markAutonomousHeadOnDispatched(governingRequirementKey)
    if type(governingRequirementKey) == "string" and governingRequirementKey ~= "" then
        self.consumedRequirements[governingRequirementKey] = true
        self.lastStatus = "AUTONOMOUS_HEAD_ON_DISPATCHED"
    end
end

function Support:resetAutonomousState()
    self.consumedRequirements = {}
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

function Support:attach(picture, snapshot)
    OuttaMyWay.ValueRecord.assertType(picture, "OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(snapshot, "ObservationSnapshot")

    local match, reason = supportedAutonomousHeadOnPair(picture, self.continuationEvidenceSource, self.consumedRequirements)
    if match == nil then
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
        authority="BOUNDED_AUTONOMOUS_D0113_D0115_D0118"
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
            mode="AUTONOMOUS_INITIAL_HEAD_ON_TEST",
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
