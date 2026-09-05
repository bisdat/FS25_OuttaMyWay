-- FS25_OuttaMyWay v0.1.3.6 TEST — D-0164 Passage rejection telemetry.
-- FS25_OuttaMyWay v0.1.1.0 CANONICAL CANDIDATE — D-0146 Resolution-Space Candidate contract inherited unchanged from v0.1.0.14 TEST.
-- FS25_OuttaMyWay v4.7.112 CANONICAL CANDIDATE — v4.7.109 D-0146 Candidate behaviour preserved; D-0147 is architecture-only.
--
-- Situation Assessment owns recognition of the supported encounter.  This
-- D-0181 production publishes only D-0146 Local Passage candidates; D-0143 is historical donor/test evidence.
-- REPOSITION Candidate.  It does not re-derive head-on meaning and contains no
-- King/Refuge selection or unilateral Yield/Progress role assignment.

OuttaMyWay.LiveTrafficCandidateSupport = {}
local Support = OuttaMyWay.LiveTrafficCandidateSupport
Support.__index = Support

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][COOPERATIVE-PRODUCTION] %s",message) else print("[FS25_OuttaMyWay][COOPERATIVE-PRODUCTION] "..message) end
end

local mandatory = {
    "FIELD_WORLD_CONTAINMENT","TRANSITION_CLEARANCE","REPRESENTATION_FITNESS",
    "CONTROL_CAPABILITY_AVAILABILITY","CONTINUING_INTENT_PRIORITY",
    "PROGRESS_PRESERVATION","RESPONSIBILITY_COMPATIBILITY",
    "OBLIGATION_COMPATIBILITY","COMMITMENT_PRECONDITIONS",
    "EFFECTIVE_ACTUATION_COMPOSITION","SAFE_RELEASE_HANDOVER"
}

local function d0146Packet(reason,evidence,applicable)
    return {
        result="PASS",applicable=applicable~=false,evidence=evidence or {},reason=reason,
        provenance={source="LiveTrafficCandidateSupport",authority="D0146_STEP2_ACTIVE_TEST"},
        revalidationTrigger={kind="NEXT_LIVE_OPERATIONAL_PICTURE"}
    }
end

function Support.new(identityRegistry,epochSequence,passiveSupport)
    return setmetatable({identities=identityRegistry,epochs=epochSequence,passiveSupport=passiveSupport,publishedCount=0,lastStatus="PASSIVE",lastCooperativeTraceKey=nil,lastPassageRejectionTraceKey=nil},Support)
end

-- Retained API for LiveRuntimeCoordinator compatibility.  D-0143 no longer
-- consumes a one-shot autonomous-head-on marker; current Situation evidence is
-- authoritative on each live cycle.
function Support:markAutonomousHeadOnDispatched(governingRequirementKey)
    if type(governingRequirementKey)=="string" and governingRequirementKey~="" then
        self.lastStatus="COOPERATIVE_PASSAGE_DISPATCHED_CURRENT_SITUATION_REASSESSMENT_CONTINUES"
    end
end
function Support:resetAutonomousState() self.lastStatus="PASSIVE" end
function Support:getLastStatus() return self.lastStatus end

-- D-0146 Step-2 active Candidate expression.  Established conflict meaning is
-- consumed, not re-derived. LocalPassagePlanner owns the progressive local
-- search and returns one sufficient Arrangement/Guide plus its bounded
-- mechanical Representation Fitness requirements.
local function d0146RequirementKey(plan)
    return "d0146-cooperative-passage:"..tostring(plan.conflictIdentity)
end

-- D-0200 dependency provenance is pair-specific. Situation dependencies on a
-- Commitment may include many simultaneously visible Encounters, so terminal
-- lifecycle authority must not infer the governing pair from that broad list.
-- Bind the selected D-0146 pair to its exact active Encounter/Job Episodes.
local function d0146PairDependency(pictureValues,subjectAssemblyId,otherAssemblyId,preferredEncounterId)
    for _,encounter in OuttaMyWay.ValueRecord.ipairs(pictureValues.encounters or {}) do
        local samePair=(encounter.subjectAssemblyId==subjectAssemblyId and encounter.otherAssemblyId==otherAssemblyId)
            or (encounter.subjectAssemblyId==otherAssemblyId and encounter.otherAssemblyId==subjectAssemblyId)
        if samePair and (preferredEncounterId==nil or encounter.identity==preferredEncounterId) then
            local episodes={encounter.subjectJobEpisodeId,encounter.otherJobEpisodeId}
            table.sort(episodes,function(a,b) return tostring(a)<tostring(b) end)
            return encounter.identity,episodes
        end
    end
    return preferredEncounterId,nil
end

local function d0146BandExhaustion(pictureId,governingRequirementKey,capability,reason)
    return {
        result="PASS",operationalPictureId=pictureId,governingRequirementKey=governingRequirementKey,
        capability=capability,reason=reason,
        evidence={establishedOpposedCorridorConflict=true,sufficientLocalPassageArrangement=true,passagePresumption=true},
        provenance={source="LiveTrafficCandidateSupport",authority="D0146_STEP2_PREFERENCE_EXHAUSTION"}
    }
end

local function makeD0146PassageCandidate(pictureId,pictureValues,plan,governingRequirementKey)
    local constraints={}
    for _,id in ipairs(mandatory) do constraints[id]=d0146Packet("D-0146 Step-2 supported local Cooperative Passage constraint",{d0146=true}) end
    constraints.FIELD_WORLD_CONTAINMENT=d0146Packet(
        "Candidate-owned Progressive Passage Search found a complete centreline Passage Guide inside the immutable current Field World; Boundary Encroachment was not required by this selected arrangement",
        {fieldWorldReferenceKey=plan.localPassageSpace and plan.localPassageSpace.fieldWorldReferenceKey,centrelineSweepSupported=true,boundaryEncroachment=false,whollyExtraField=false})
    constraints.TRANSITION_CLEARANCE=d0146Packet(
        "The selected multi-gate guide preserves the configured Nominal Inter-Assembly Clearance between Candidate-selected configuration-conditioned represented DISC sets throughout sampled simultaneous development/traversal/reacquisition and excludes known positive third-party occupancy; no generic negative-clearance claim is made",
        {pairSpecificPassageClearance=plan.pairSpecificPassageClearance,pairSweepSupport=plan.passageGuide and plan.passageGuide.pairSweepSupport,thirdPartySupport=plan.passageGuide and plan.passageGuide.thirdPartySupport,manoeuvreSweptOccupancySampled=true,vehicleNameAdmissionGate=false,generalVehicleAuthority=false,negativeClearanceAuthority=false})
    constraints.REPRESENTATION_FITNESS=d0146Packet(
        "Cached current geometry plus same-Job-Episode native configuration-profile provenance admits this established pair to configuration-first Pair-Specific Passage Clearance; compact selection requires a stable native-observed folded profile that positively releases conflict-side Facing Clearance Extent",
        {representationFitnessIds=plan.representationFitnessIds,controlProfile=plan.controlProfile,vehicleNameAdmissionGate=false,configurationReductionAuthority="AI_REACHABLE_PRODUCTIVE_CONFIGURATION_NATIVE_PROFILE_PLUS_POSITIVE_CONFLICT_SIDE_RELEASE",passageConfiguration=plan.passageConfiguration,generalVehicleAuthority=false})
    constraints.CONTROL_CAPABILITY_AVAILABILITY=d0146Packet(
        "Existing proven Hold, optional configuration reduction, target-Reposition and selective restore mechanisms can execute the Candidate-supplied Passage Guide without Control inventing geometry",
        {controlModule="CooperativePassageControl",passageGuideId=plan.passageGuide and plan.passageGuide.identity,mechanicalDonors={"Prototype22PermissionGate","Prototype22DriveAuthority","Prototype22ConfigurationAuthority"}})
    constraints.CONTINUING_INTENT_PRIORITY=d0146Packet(
        "Neither Established Trajectory is privileged; Pairwise Passage Economy apportioned only the necessary local lateral burden and both participants retain forward progression",
        {pairwisePassageEconomy=plan.passageArrangement and plan.passageArrangement.pairwisePassageEconomy,subjectOffsetM=plan.passageArrangement and plan.passageArrangement.subjectLateralOffsetM,otherOffsetM=plan.passageArrangement and plan.passageArrangement.otherLateralOffsetM})
    constraints.PROGRESS_PRESERVATION=d0146Packet(
        "The selected guide is a decisive Passage expression, not Information-Gaining Delay; both participants progress through development, traversal and native reacquisition gates",
        {informationGainingDelay=false,guideGateCount=plan.passageGuide and OuttaMyWay.ValueRecord.length(plan.passageGuide.gates or {}) or 0})
    constraints.RESPONSIBILITY_COMPATIBILITY=d0146Packet(
        "One pair-scoped Cooperative Passage Commitment resolves the Established Opposed Corridor Conflict while other active Operation assemblies remain Local Spatial Constraints rather than hidden passage participants",
        {conflictIdentity=plan.conflictIdentity,assemblyIds=plan.assemblyIds,thirdPartyConstraintCount=plan.localPassageSpace and plan.localPassageSpace.thirdPartyConstraintCount or 0})
    constraints.OBLIGATION_COMPATIBILITY=d0146Packet(
        "Material displacement creates the existing restoration-and-GIANTS-handoff terminal obligation for both assemblies",
        {sameJobRestoration=true,postHandoffCooldown=false})
    constraints.COMMITMENT_PRECONDITIONS=d0146Packet(
        "Actuation starts only after this same-picture D-0146 Candidate passes mandatory Constraints and normal Commitment admission/revision",
        {operatorCommandRequired=false,conflictIdentity=plan.conflictIdentity})
    constraints.EFFECTIVE_ACTUATION_COMPOSITION=d0146Packet(
        "Both assemblies are explicit REPOSITION/MOVE progress-actuation owners under one Commitment",
        {assemblyIds=plan.assemblyIds,jointCommitment=true})
    constraints.SAFE_RELEASE_HANDOVER=d0146Packet(
        "Control restores only configurations it actually changed, preserving unchanged participant configuration, before immediate GIANTS handoff with unchanged Job Episodes; Passage Support Loss halts held rather than broadening the Guide",
        {sameJobRequired=true,restoreBeforeHandoff=true,passageReassessmentOutcomeOnUnsupportedExecution="SAFE_ABANDON_ESCALATE",cooldown=false})

    local compositionEntries={}
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(plan.assemblyIds or {}) do
        compositionEntries[#compositionEntries+1]={assemblyId=assemblyId,commitmentId="$NEW_COMMITMENT",capability="REPOSITION",effectClass="MOVE",progressActuation=true}
    end
    table.sort(compositionEntries,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
    local requirements={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(plan.representationFitnessIds or {}) do requirements[#requirements+1]={representationId=id,acceptedStates={"FIT_FOR_LIMITED_HORIZON","CURRENTLY_FIT"}} end
    local dependentEncounterId,dependentJobEpisodeIds=d0146PairDependency(pictureValues,plan.subjectAssemblyId,plan.otherAssemblyId,plan.encounterIdentity)

    return {
        referenceKey="d0146-cooperative-passage:"..tostring(plan.conflictIdentity),
        purpose={kind="D0146_COOPERATIVE_PASSAGE",result="RESOLVE_ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT_BY_SUFFICIENT_LOCAL_PASSAGE"},
        subject={assemblyIds=plan.assemblyIds},capability="REPOSITION",
        expectedEffect={physicalChange=true,jointReposition=true,passageArrangementId=plan.passageArrangement and plan.passageArrangement.identity,passageGuideId=plan.passageGuide and plan.passageGuide.identity,bothParticipantsForwardThroughEncounter=true,sameJobRestorationRequired=true,postHandoffCooldown=false,king=false,refuge=false},
        evidenceBasis={
            constraintEvidence=constraints,
            governingBasis={responsibilityKey=governingRequirementKey,operationIds=pictureValues.identities.operations.active,sourceIntentIds=pictureValues.identities.jobEpisodes.active,dependentEncounterId=dependentEncounterId,dependentJobEpisodeIds=dependentJobEpisodeIds},
            progressActuationOwnership={assemblyIds=plan.assemblyIds},
            effectiveActuationComposition={identity="d0146-step2-composition:"..tostring(plan.conflictIdentity)..":"..pictureId,epoch=pictureValues.epoch,relevantAssemblyIds=plan.assemblyIds,entries=compositionEntries},
            trafficPolicemanPreference={primaryResolution=true,governingRequirementKey=governingRequirementKey,exhaustionEvidence={
                CONTINUE_OBSERVATION=d0146BandExhaustion(pictureId,governingRequirementKey,"CONTINUE_OBSERVATION","Established conflict is already locally actionable and Candidate search found a sufficient supported passage expression"),
                REGULATE_SPEED=d0146BandExhaustion(pictureId,governingRequirementKey,"REGULATE_SPEED","Regulation preserves Action Space but does not itself resolve the Established opposed spatial incompatibility"),
                HOLD=d0146BandExhaustion(pictureId,governingRequirementKey,"HOLD","In-path Hold alone does not create a Stable Passing Relationship")
            }},
            cooperativePassageBridge={
                architecture="D0146_STEP2",governingRequirementKey=governingRequirementKey,operationId=plan.operationId,
                conflictIdentity=plan.conflictIdentity,encounterIdentity=plan.encounterIdentity,
                assemblyIds=plan.assemblyIds,subjectAssemblyId=plan.subjectAssemblyId,otherAssemblyId=plan.otherAssemblyId,
                subjectReferenceKey=plan.subjectReferenceKey,otherReferenceKey=plan.otherReferenceKey,
                subjectJobToken=plan.subjectJobToken,otherJobToken=plan.otherJobToken,
                subjectStartX=plan.subjectStartX,subjectStartZ=plan.subjectStartZ,otherStartX=plan.otherStartX,otherStartZ=plan.otherStartZ,
                initialSeparationM=plan.separationM,trajectoryDot=plan.trajectoryDot,
                localPassageSpace=plan.localPassageSpace,
                passageArrangement=plan.passageArrangement,passageGuide=plan.passageGuide,passageConfiguration=plan.passageConfiguration,
                passageEntry=plan.passageEntry,passageExcursion=plan.passageExcursion,progressiveSearch=plan.progressiveSearch,
                controlProfile=plan.controlProfile
            }
        },
        representationFitness={requirements=requirements},
        preconditions={evidenceContracts={},operatorCommandRequired=false,sameJobEpisodes=true,establishedOpposedCorridorConflict=true,sufficientLocalPassageArrangement=true,controlProfile=plan.controlProfile},
        invalidationConditions={{kind="JOB_EPISODE_CHANGE"},{kind="ESTABLISHED_CONFLICT_CHANGE"},{kind="PASSAGE_SUPPORT_LOSS"},{kind="CURRENT_PHYSICAL_INTERACTION"}},
        reversibility={physicalEffect=true,restoreBothBeforeRelease=true,passageReassessment=true},
        obligationsCreated={{origin={kind="OTM_MATERIAL_DISPLACEMENT",decision="D-0146",conflictIdentity=plan.conflictIdentity},basis={kind="COOPERATIVE_PASSAGE_RESTORATION_AND_HANDOFF",assemblyIds=plan.assemblyIds},requiredOutcome={kind="COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK",assemblyIds=plan.assemblyIds},requiredAuthority={capabilities={"REPOSITION","RESTORE_CONFIGURATION","HANDOVER_TO_GIANTS"}},evidenceContract={kind="BOTH_SAME_JOB_BOTH_RESTORED_THEN_GIANTS_HANDOFF"},ownershipClass="ORIGIN_BOUND",transferPolicy={allowed=false},terminalDependency=true}},
        releaseImplications={releaseBothProgressAuthoritiesAfterPositiveHandoff=true,postHandoffObservationAuthority=false,cooldown=false},
        uncertainty={"GENERIC_NEGATIVE_CLEARANCE_AUTHORITY_NOT_CLAIMED","BOUNDARY_ENCROACHMENT_NOT_REQUIRED_BY_SELECTED_EXPRESSION","STATIC_OBSTACLE_EXCLUSION_BEYOND_ACTIVE_ASSEMBLIES_NOT_CLAIMED"},
        comparisonCost=plan.passageArrangement and tonumber(plan.passageArrangement.combinedLateralBurdenM) or 0
    }
end

-- D-0146 Resolution-Space Conservation. Situation owns admission evidence and
-- temporary role assignment. Candidate does not re-derive raw GIANTS state.
-- Current Excursion can justify early Potential-conflict admission; an already
-- Established conflict may also justify Regulation when Step-2 has not yet found
-- a supported Passage expression.
local function d0146ActionSpaceRecord(picture)
    local actionable={}
    for _,relation in OuttaMyWay.ValueRecord.ipairs(picture.opposedCorridorKnowledge or {}) do
        local action=relation.actionSpaceConservation
        if (relation.classification=="POTENTIAL_OPPOSED_CORRIDOR_CONFLICT" or relation.classification=="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT") and type(action)=="table"
            and action.status=="REGULATE_SUPPORTED" and action.supported==true then
            actionable[#actionable+1]={relation=relation,action=action}
        end
    end
    table.sort(actionable,function(a,b)
        local sa=tonumber(a.action.separationM) or math.huge
        local sb=tonumber(b.action.separationM) or math.huge
        if math.abs(sa-sb)>0.001 then return sa<sb end
        return tostring(a.relation.identity)<tostring(b.relation.identity)
    end)
    if #actionable==0 then return nil,nil end
    if #actionable>1 then return nil,"MULTIPLE_D0146_ACTION_SPACE_CONSERVATION_CONTEXTS" end
    return actionable[1],nil
end

-- Forward Intersection geometry and temporal allocation are owned by Situation.
-- Candidate support only publishes the already-assessed bounded Regulation.
local function forwardIntersectionRecord(picture)
    local actionable={}
    for _,knowledge in OuttaMyWay.ValueRecord.ipairs(picture.spatialConstraintKnowledge or {}) do
        for _,relation in OuttaMyWay.ValueRecord.ipairs(knowledge.pairRelationships or {}) do
            if relation.classification=="FORWARD_INTERSECTION" and relation.actionable==true
                and relation.incumbentRelationship==nil and type(relation.actionSpaceConservation)=="table" then
                actionable[#actionable+1]={relation=relation,action=relation.actionSpaceConservation}
            end
        end
    end
    table.sort(actionable,function(a,b) return tostring(a.relation.identity)<tostring(b.relation.identity) end)
    if #actionable==0 then return nil,nil end
    if #actionable>1 then return nil,"MULTIPLE_FORWARD_INTERSECTION_CONTEXTS" end
    return actionable[1],nil
end

local function d0146ExistingCommitmentForRequirement(pictureValues,requirement)
    local contexts=pictureValues.commitmentContext or {}
    local match=nil
    for _,context in OuttaMyWay.ValueRecord.ipairs(contexts) do
        local basis=context.governingBasis
        if type(basis)=="table" and basis.responsibilityKey==requirement then
            if match~=nil then return nil,"MULTIPLE_D0146_ACTION_SPACE_COMMITMENTS" end
            match=context.commitmentId
        end
    end
    if match==nil and OuttaMyWay.ValueRecord.length(contexts)>0 then return nil,"OTHER_LIVE_COMMITMENT_CONTEXT_PRECLUDES_NEW_D0146_ACTION_SPACE_PURPOSE" end
    return match,nil
end

local function d0146ActionSpacePacket(reason,evidence)
    return {
        result="PASS",applicable=true,evidence=evidence or {},reason=reason,
        provenance={source="LiveTrafficCandidateSupport",authority="D0146_RESOLUTION_SPACE_CONSERVATION"},
        revalidationTrigger={kind="NEXT_LIVE_OPERATIONAL_PICTURE"}
    }
end

local function d0146ActionSpaceRepresentation(values,pictureId,item)
    local relation=item.relation
    local action=item.action
    local representationId="d0146-action-space:"..tostring(relation.identity)..":"..tostring(pictureId)
    values.representationFitness=values.representationFitness or {}
    values.representationFitness[#values.representationFitness+1]={
        representationId=representationId,
        assemblyId=action.regulatedAssemblyId,
        question=action.admissionKind=="FORWARD_INTERSECTION" and "FORWARD_INTERSECTION_TEMPORAL_REGULATION" or "D0146_RESOLUTION_SPACE_CONSERVATION",
        assessmentHorizon=action.admissionKind=="FORWARD_INTERSECTION" and "CURRENT_POSITIVELY_SUPPORTED_FIELD_BOUNDED_FORWARD_CONTINUATIONS" or (action.admissionKind=="ESTABLISHED_CONFLICT" and "ESTABLISHED_OPPOSED_CONFLICT_INSIDE_LOCAL_PASSAGE_ENVELOPE" or "CURRENT_EXCURSION_PLUS_CURRENT_POSITIVE_CORRIDOR_CLOSURE_INSIDE_LOCAL_PASSAGE_ENVELOPE"),
        state="USABLE_WITH_UNCERTAINTY",
        claimPermissions={"REGULATE_SPEED_TO_PRESERVE_LOCAL_PASSAGE_ACTION_SPACE","ESCALATE_REALIZED_INSUFFICIENT_REGULATION_TO_ZERO_SPEED_HOLD"},
        coverage={complete=false,conservative=false},
        uncertainty={"RELATIONSHIP_MAY_CHANGE_BEFORE_PASSAGE_SUPPORT","NO_EVENTUAL_ROUTE_OR_PASSAGE_GEOMETRY_AUTHORITY","REGULATION_RATE_IS_TEST_CALIBRATION"},
        validityDependencies=action.admissionKind=="FORWARD_INTERSECTION" and {"CURRENT_FIELD_BOUNDED_FORWARD_CONTINUATIONS","POSITIVE_FORWARD_INTERSECTION","POSITIVE_PROGRESS_RATES"} or {"ACTIVE_OPPOSED_CORRIDOR_RELATIONSHIP","POSITIVE_CURRENT_CORRIDOR_SUPPORT","POSITIVE_CURRENT_CLOSURE","CURRENT_NATIVE_PROGRESS_RATE","LOCAL_PASSAGE_ENVELOPE"},
        provenance={source=action.admissionKind=="FORWARD_INTERSECTION" and "SpatialConstraintAssessment" or "TrajectoryConflictAssessment",layer="SITUATION_KNOWLEDGE",authority="REGULATION_CANDIDATE_SUPPORT",negativeClearanceAuthority=false}
    }
    return representationId
end

local function makeD0146ActionSpaceCandidate(pictureId,pictureValues,item,governingRequirementKey,existingCommitmentId,representationId)
    local relation=item.relation
    local action=item.action
    local forward=action.admissionKind=="FORWARD_INTERSECTION"
    local constraints={}
    for _,id in ipairs(mandatory) do constraints[id]=d0146ActionSpacePacket("D-0146 Resolution-Space Conservation constraint",{conflictIdentity=relation.identity,relationshipClassification=relation.classification}) end
    constraints.FIELD_WORLD_CONTAINMENT=d0146ActionSpacePacket(
        "The regulated participant is a current Operation member; the protected participant is either another member or a same-Field-World active GIANTS field-work job whose productive intent remains unrevealed. Regulation creates no route or spatial target",
        {operationId=relation.operationId,spatialTargetCreated=false,subjectOperationMember=relation.subjectOperationMember,otherOperationMember=relation.otherOperationMember,subjectProductiveCommencementPending=relation.subjectProductiveCommencementPending,otherProductiveCommencementPending=relation.otherProductiveCommencementPending})
    constraints.TRANSITION_CLEARANCE=d0146ActionSpacePacket(
        "No displacement transition is commanded; Regulation only bounds one participant's GIANTS-native progression while the active opposed relationship retains passage Action Space",
        {protectedAssemblyId=action.protectedAssemblyId or action.excursionAssemblyId,regulatedAssemblyId=action.regulatedAssemblyId,routeAuthority=false,admissionKind=action.admissionKind})
    constraints.REPRESENTATION_FITNESS=d0146ActionSpacePacket(
        forward and "Situation positively supports one Forward Intersection within both Field-World-bounded continuations and positive timing evidence" or "Situation positively supports an active opposed relationship, current physical corridor coupling, positive closure and bounded local-passage proximity",
        {currentCorridorOverlap=action.currentCorridorOverlap,separationM=action.separationM,maxSeparationM=action.maxSeparationM,negativeClearanceAuthority=false,admissionKind=action.admissionKind})
    constraints.CONTROL_CAPABILITY_AVAILABILITY=d0146ActionSpacePacket(
        "The existing P22 Regulation lease can express the Control-owned Resolution-Space Progression Envelope while GIANTS retains route, steering and direction; a zero integer cap is Hold as the terminal magnitude of the same envelope",
        {controlCapability="REGULATE_SPEED",leaseKind="P22_REGULATION_LEASE",giantsRoutePreserved=true,zeroSpeedHoldExpression=true,progressionEnvelope=true})
    constraints.CONTINUING_INTENT_PRIORITY=d0146ActionSpacePacket(
        "The protected participant remains GIANTS-native; an active pre-productive entrant is protected as unresolved native intent rather than folded/repositioned. Only the current Operation member selected by Situation is temporarily regulated, and that actuation role may migrate under the same unresolved obligation when Situation changes",
        {protectedAssemblyId=action.protectedAssemblyId or action.excursionAssemblyId,regulatedAssemblyId=action.regulatedAssemblyId,roleBasis=action.roleBasis,roleAssignmentMutable=true,protectedProductiveCommencementPending=(action.protectedAssemblyId==relation.subjectAssemblyId and relation.subjectProductiveCommencementPending==true) or (action.protectedAssemblyId==relation.otherAssemblyId and relation.otherProductiveCommencementPending==true)})
    constraints.PROGRESS_PRESERVATION=d0146ActionSpacePacket(
        forward and "Fixed 1 km/h Intent-Revelation Creep maximises practical revelation time while fresh Situation owns prompt release" or "Supportable Progression is the greatest present conflict-consuming progression that preserves the required next resolution opportunity; Control owns its elastic integer magnitude and withholds Reverse-Created Resolution Reserve from ordinary progression",
        {nativeUnrestrictedKmh=action.nativeUnrestrictedKmh,progressionEnvelope="ZERO_TERMINAL_POLICY_TRAJECTORY",reverseCreatedReserveSpendable=false,reposition=false})
    constraints.RESPONSIBILITY_COMPATIBILITY=d0146ActionSpacePacket(
        "The bounded Regulation and any later Established-conflict Passage share one pair-scoped D-0146 governing requirement",
        {conflictIdentity=relation.identity,governingRequirementKey=governingRequirementKey})
    constraints.OBLIGATION_COMPATIBILITY=d0146ActionSpacePacket(
        "One terminal-dependent Action-Space preservation obligation remains open only until the relationship dissolves or succeeds into Passage",
        {sameCommitmentPassageSuccession=true})
    constraints.COMMITMENT_PRECONDITIONS=d0146ActionSpacePacket(
        "Current Situation positively reports Resolution-Space Conservation support and a positive native closure-contribution opportunity for the active opposed relationship",
        {status=action.status,reason=action.reason,relationshipClassification=relation.classification,admissionKind=action.admissionKind})
    constraints.EFFECTIVE_ACTUATION_COMPOSITION=d0146ActionSpacePacket(
        "Only the regulated participant owns OuttaMyWay progress actuation; the protected participant remains wholly GIANTS-driven",
        {regulatedAssemblyId=action.regulatedAssemblyId,protectedAssemblyId=action.protectedAssemblyId or action.excursionAssemblyId})
    constraints.SAFE_RELEASE_HANDOVER=d0146ActionSpacePacket(
        "The Regulation lease expires on positive relationship dissolution and is physically cleared without revoking same-Commitment authority when Cooperative Passage succeeds it",
        {releaseOnPurposeExpiry=true,sameCommitmentPassageSuccession=true})

    local protectedAssemblyId=action.protectedAssemblyId or action.excursionAssemblyId
    local protectedReferenceKey=action.protectedReferenceKey or action.excursionReferenceKey
    local dependentEncounterId,dependentJobEpisodeIds=d0146PairDependency(pictureValues,relation.subjectAssemblyId,relation.otherAssemblyId,nil)
    local composition={
        identity="d0146-action-space-composition:"..tostring(relation.identity)..":"..pictureId,epoch=pictureValues.epoch,
        relevantAssemblyIds={protectedAssemblyId,action.regulatedAssemblyId},
        entries={{assemblyId=action.regulatedAssemblyId,commitmentId=existingCommitmentId or "$NEW_COMMITMENT",capability="REGULATE_SPEED",effectClass="SPEED_LIMIT_OR_HOLD",progressActuation=true}}
    }
    return {
        referenceKey=(forward and "forward-intersection-regulation:" or "d0146-action-space-regulation:")..tostring(relation.identity),
        purpose=forward and {kind="FORWARD_INTERSECTION_INTENT_REVELATION",result="PRESERVE_INTENT_REVELATION_TIME_UNTIL_FORWARD_INTERSECTION_DISSOLVES"} or {kind="D0146_PASSAGE_ACTION_SPACE_CONSERVATION",result="PRESERVE_LOCAL_PASSAGE_ACTION_SPACE_UNTIL_SUPPORTED_PASSAGE_OR_POSITIVE_DISSOLUTION"},
        subject={assemblyId=action.regulatedAssemblyId,assemblyIds={action.regulatedAssemblyId}},capability="REGULATE_SPEED",
        expectedEffect={physicalChange=true,speedCeilingOnly=true,giantsRoute=true,giantsSteering=true,giantsDirection=true,protectedParticipantUnrestricted=true,
            elasticProgressionEnvelope=not forward,fixedIntentRevelationCreep=forward,zeroSpeedHoldExpression=not forward},
        evidenceBasis={
            constraintEvidence=constraints,
            governingBasis={responsibilityKey=governingRequirementKey,operationIds=pictureValues.identities.operations.active,sourceIntentIds=pictureValues.identities.jobEpisodes.active,dependentEncounterId=dependentEncounterId,dependentJobEpisodeIds=dependentJobEpisodeIds},
            maintainsExistingCommitment=existingCommitmentId~=nil,existingProgressMayContinue=true,
            progressActuationOwnership={assemblyIds={action.regulatedAssemblyId}},effectiveActuationComposition=composition,
            trafficPolicemanPreference={primaryResolution=true,governingRequirementKey=governingRequirementKey,exhaustionEvidence={
                CONTINUE_OBSERVATION={result="PASS",operationalPictureId=pictureId,governingRequirementKey=governingRequirementKey,capability="CONTINUE_OBSERVATION",
                    reason="The active opposed relationship has no selected supported Passage expression while unrestricted progression is positively consuming the bounded local Passage envelope",
                    evidence={actionSpaceConservation=action},provenance={source="LiveTrafficCandidateSupport",authority="D0146_ACTION_SPACE_OBSERVE_EXHAUSTION"}}
            }},
            d0146ActionSpaceRegulationBridge={
                action="APPLY",architecture="D0146_RESOLUTION_SPACE_CONSERVATION",conflictIdentity=relation.identity,operationId=relation.operationId,
                governingRequirementKey=governingRequirementKey,existingCommitmentId=existingCommitmentId,
                regulatedAssemblyId=action.regulatedAssemblyId,regulatedReferenceKey=action.regulatedReferenceKey,
                protectedAssemblyId=protectedAssemblyId,protectedReferenceKey=protectedReferenceKey,
                excursionAssemblyId=action.excursionAssemblyId,excursionReferenceKey=action.excursionReferenceKey,admissionKind=action.admissionKind,
                nativeUnrestrictedKmh=action.nativeUnrestrictedKmh,
                nativeClosureContributionKmh=action.nativeClosureContributionKmh,nativeSignedClosureContributionKmh=action.nativeSignedClosureContributionKmh,nativeMoveForwards=action.nativeMoveForwards,
                governingPurpose=action.governingPurpose,separationM=action.separationM,actionSpaceReason=action.reason,
                cooperativePassageEligible=relation.cooperativePassageEligible~=false,
                subjectOperationMember=relation.subjectOperationMember,otherOperationMember=relation.otherOperationMember,
                subjectProductiveCommencementPending=relation.subjectProductiveCommencementPending,otherProductiveCommencementPending=relation.otherProductiveCommencementPending
            }
        },
        representationFitness={requirements={{representationId=representationId,acceptedStates={"USABLE_WITH_UNCERTAINTY"}}}},
        preconditions={evidenceContracts={},relationshipClassification=relation.classification,actionSpaceConservationStatus="REGULATE_SUPPORTED",cooperativePassageEligible=relation.cooperativePassageEligible~=false},
        invalidationConditions={{kind="POSITIVE_RELATIONSHIP_DISSOLUTION"},{kind="COOPERATIVE_PASSAGE_SUCCESSION"},{kind="JOB_EPISODE_CHANGE"}},
        reversibility={physicalEffect=true,releaseOnPurposeExpiry=true},
        obligationsCreated={{
            origin={kind="TRAFFIC_INTERVENTION",decision=forward and "FORWARD_INTERSECTION" or "D-0146",conflictIdentity=relation.identity},
            basis={kind=forward and "FORWARD_INTERSECTION_INTENT_REVELATION" or "D0146_PASSAGE_ACTION_SPACE_CONSERVATION",conflictIdentity=relation.identity,admissionKind=action.admissionKind,roleAssignmentMutable=not forward},
            requiredOutcome={kind=forward and "FORWARD_INTERSECTION_DISSOLVED_OR_SUCCEEDED" or "D0146_PASSAGE_ACTION_SPACE_PRESERVED_UNTIL_RELATIONSHIP_MATURES_OR_DISSOLVES",conflictIdentity=relation.identity},
            requiredAuthority={capabilities={"REGULATE_SPEED"},trafficPoliceman=true},
            evidenceContract={kind=forward and "FRESH_FORWARD_INTERSECTION_POSITIVE_OR_DISSOLVED" or "POSITIVE_RELATIONSHIP_DISSOLUTION_OR_COOPERATIVE_PASSAGE_SUCCESSION",absenceDoesNotRetire=not forward},
            ownershipClass="CONTINUITY",transferPolicy={allowed=false},terminalDependency=true
        }},
        releaseImplications={releaseOnlyPurposeBoundRegulation=true,trafficSettlement=false,sameCommitmentPassageSuccession=true,currentRoleMayMigrateWithoutSettlingObligation=true},
        uncertainty={"D0155_CONTINGENCY_RESERVE_FRACTION_IS_PROVISIONAL_POLICY_CALIBRATION","NO_ROUTE_OR_PASSAGE_GEOMETRY_AUTHORITY","PRE_PRODUCTIVE_ACTIVE_JOB_REMAINS_GIANTS_OWNED_UNTIL_POSITIVE_PRODUCTIVE_COMMENCEMENT"},comparisonCost=0
    }
end

local function attachD0146ActionSpace(self,picture,snapshot,item)
    local values=OuttaMyWay.ValueRecord.toTable(picture)
    local pictureId=self.identities:issue("PICTURE")
    values.identity=pictureId; values.epoch=self.epochs:next()
    local requirement=(item.action.admissionKind=="FORWARD_INTERSECTION" and "forward-intersection-regulation:" or "d0146-cooperative-passage:")..tostring(item.relation.identity)
    local existing,existingReason=d0146ExistingCommitmentForRequirement(values,requirement)
    if existingReason~=nil then self.lastStatus=existingReason; return self.passiveSupport:attach(picture,snapshot) end
    values.provenance={source="LiveTrafficCandidateSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity,authority="D0146_RESOLUTION_SPACE_CONSERVATION"}
    local representationId=d0146ActionSpaceRepresentation(values,pictureId,item)
    local specification=makeD0146ActionSpaceCandidate(pictureId,values,item,requirement,existing,representationId)
    values.candidateSupportEvidence={
        complete=true,
        supportBoundary={mode="D0146_RESOLUTION_SPACE_REGULATION",supportedCandidateClasses={"REGULATE_SPEED"},physicalCapabilitiesImplemented=true,controlAuthority="D0155_RESOLUTION_SPACE_PROGRESSION_ENVELOPE",boundedScope="POTENTIAL_CURRENT_EXCURSION_OR_ESTABLISHED_OPPOSED_CONFLICT_INSIDE_LOCAL_PASSAGE_ENVELOPE_INCLUDING_SAME_FIELD_WORLD_ACTIVE_JOB_INTENT_REVELATION_PENDING",decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=requirement}},
        candidateSpecifications={specification},provenance={source="LiveTrafficCandidateSupport",observationSnapshotId=snapshot.identity,authority="D0146_RESOLUTION_SPACE_CONSERVATION"}
    }
    local action=item.action
    logInfo("D0146_ACTION_SPACE_REGULATION_SUPPORTED conflict=%s classification=%s admission=%s regulated=%s protected=%s role=%s separation=%.2f overlap=%.2f native=%.2fkmh closureContribution=%.2fkmh moveForwards=%s envelope=CONTROL_OWNED existingCommitment=%s",
        tostring(item.relation.identity),tostring(item.relation.classification),tostring(action.admissionKind or "CURRENT_EXCURSION"),tostring(action.regulatedReferenceKey or action.regulatedAssemblyId),tostring(action.protectedReferenceKey or action.excursionReferenceKey or action.protectedAssemblyId or action.excursionAssemblyId),tostring(action.roleBasis or "CURRENT_EXCURSION_STABLE_PARTICIPANT"),
        tonumber(action.separationM) or -1,tonumber(action.currentCorridorOverlap and action.currentCorridorOverlap.overlapM) or -1,
        tonumber(action.nativeUnrestrictedKmh) or -1,tonumber(action.nativeClosureContributionKmh) or -1,tostring(action.nativeMoveForwards),tostring(existing or "NONE"))
    self.publishedCount=self.publishedCount+1
    self.lastStatus="D0146_RESOLUTION_SPACE_REGULATION_CANDIDATE_PUBLISHED"
    return OuttaMyWay.OperationalPicture.new(values)
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
            entries={{assemblyId=record.followerAssemblyId,commitmentId=record.existingCommitmentId or "$NEW_COMMITMENT",capability="REGULATE_SPEED",effectClass="SPEED_LIMIT_OR_HOLD",progressActuation=true}}
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
                {assemblyId=guard.progressAssemblyId,commitmentId=guard.commitmentId,capability="REGULATE_SPEED",effectClass="SPEED_LIMIT_OR_HOLD",progressActuation=true}
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


local function passageRejectionTelemetry(allRejected)
    if type(allRejected)~="table" then return nil,nil end
    local geometry,field,sweep,third,other,total=0,0,0,0,0,0
    local details={}
    local conflictId,topReason=nil,nil
    for _,conflict in ipairs(allRejected) do
        conflictId=conflictId or conflict.conflictIdentity
        topReason=topReason or conflict.reason
        for _,candidate in ipairs(conflict.rejected or {}) do
            total=total+1
            local reason=nil
            if candidate.guideReason~=nil then geometry=geometry+1; reason="GUIDE:"..tostring(candidate.guideReason)
            elseif candidate.fieldReason~=nil then field=field+1; reason="FIELD:"..tostring(candidate.fieldReason)
            elseif candidate.sweepReason~=nil then sweep=sweep+1; reason="SWEEP:"..tostring(candidate.sweepReason)
            elseif candidate.thirdPartyReason~=nil then third=third+1; reason="THIRD:"..tostring(candidate.thirdPartyReason)
            else other=other+1; reason="OTHER" end
            if #details<6 then details[#details+1]=tostring(candidate.index or "?").."="..reason end
        end
    end
    local signature=table.concat({tostring(conflictId),tostring(topReason),geometry,field,sweep,third,other,total,table.concat(details,"|")},":")
    local text=string.format("conflict=%s reason=%s candidates=%d geometry=%d field=%d sweep=%d thirdParty=%d other=%d details=%s",
        tostring(conflictId or "n/a"),tostring(topReason or "n/a"),total,geometry,field,sweep,third,other,#details>0 and table.concat(details,",") or "none")
    return signature,text
end

local function finiteNumber(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function clearanceTraceCandidate(candidate)
    if type(candidate)~="table" or type(candidate.sweepEvidence)~="table" then return nil end
    local sweep=candidate.sweepEvidence
    local crossing=tonumber(sweep.minimumCrossingWindowClearanceM)
    local required=tonumber(sweep.requiredNominalClearanceM)
    if not finiteNumber(crossing) or not finiteNumber(required) then return nil end
    return {
        candidate=candidate,
        crossing=crossing,
        required=required,
        residue=crossing-required,
        outside=tonumber(sweep.minimumOutsideCrossingClearanceM),
        minimum=tonumber(sweep.minimumRepresentedClearanceM),
        floor=tonumber(sweep.acceptedNominalClearanceFloorM),
        floorResidue=(finiteNumber(crossing) and finiteNumber(tonumber(sweep.acceptedNominalClearanceFloorM))) and (crossing-tonumber(sweep.acceptedNominalClearanceFloorM)) or nil
    }
end

-- v0.1.4.6 telemetry retained.  This consumes evidence already computed by the
-- ordinary LocalPassagePlanner pass.  It does not call the planner, sweep, or
-- geometry functions again.  The trace is intentionally limited to the local
-- 40 m approach so the field comparison exposes NO -> YES -> NO clearance
-- behaviour without recreating v0.1.4.5 Candidate Search Amplification.
local function passageClearanceRejectionTelemetry(allRejected)
    local lines={}
    if type(allRejected)~="table" then return lines end
    local maxTraceSeparation=tonumber(OuttaMyWay.D0146_CLEARANCE_TRACE_MAX_SEPARATION_M) or 40.0
    for _,conflict in ipairs(allRejected) do
        local best=nil
        local residues={}
        local firstCandidate=nil
        for _,candidate in ipairs(conflict.rejected or {}) do
            firstCandidate=firstCandidate or candidate
            local trace=clearanceTraceCandidate(candidate)
            if trace~=nil then
                residues[#residues+1]=string.format("%s=%+.3f",tostring(candidate.index or "?"),trace.residue)
                if best==nil or trace.residue>best.residue then best=trace end
            end
        end
        local reference=(best and best.candidate) or firstCandidate
        local separation=tonumber(reference and reference.separationM)
        if reference~=nil and finiteNumber(separation) and separation<=maxTraceSeparation then
            local c=best and best.candidate or reference
            local sweep=c and c.sweepEvidence or nil
            local crossing=best and best.crossing or nil
            local required=best and best.required or nil
            local residue=best and best.residue or nil
            local outside=best and best.outside or nil
            local minimum=best and best.minimum or nil
            local floor=best and best.floor or tonumber(sweep and sweep.acceptedNominalClearanceFloorM)
            local floorResidue=best and best.floorResidue or ((finiteNumber(crossing) and finiteNumber(floor)) and (crossing-floor) or nil)
            lines[#lines+1]=string.format(
                "D0146_PASSAGE_CLEARANCE_TRACE conflict=%s outcome=REJECTED separation=%.2f longitudinal=%.2f lateral=%.3f bestIndex=%s crossing=%s nominal=%s nominalResidue=%s floor=%s floorResidue=%s outside=%s minimum=%s contact=%.3f offsets=%+.3f/%+.3f relation=%s configuration=%s/%s geometry=%s sweepReason=%s residues=%s",
                tostring(conflict.conflictIdentity or "n/a"),separation,tonumber(c and c.longitudinalSeparationM) or -1,tonumber(c and c.currentLateralSeparationM) or -1,
                tostring(c and c.index or "n/a"),finiteNumber(crossing) and string.format("%.3f",crossing) or "n/a",finiteNumber(required) and string.format("%.3f",required) or "n/a",
                finiteNumber(residue) and string.format("%+.3f",residue) or "n/a",finiteNumber(floor) and string.format("%.3f",floor) or "n/a",finiteNumber(floorResidue) and string.format("%+.3f",floorResidue) or "n/a",finiteNumber(outside) and string.format("%.3f",outside) or "n/a",finiteNumber(minimum) and string.format("%.3f",minimum) or "n/a",
                tonumber(c and c.physicalContactThresholdM) or -1,tonumber(c and c.subjectLateralOffsetM) or 0,tonumber(c and c.otherLateralOffsetM) or 0,tostring(c and c.relationSign or "n/a"),
                tostring(c and c.subjectConfigurationMode or "n/a"),tostring(c and c.otherConfigurationMode or "n/a"),tostring(c and c.passageGeometrySource or "n/a"),tostring(c and c.sweepReason or "n/a"),#residues>0 and table.concat(residues,"|") or "none")
        end
    end
    return lines
end

local function passageClearanceSelectedTelemetry(plan)
    if type(plan)~="table" then return nil end
    local separation=tonumber(plan.separationM)
    local maxTraceSeparation=tonumber(OuttaMyWay.D0146_CLEARANCE_TRACE_MAX_SEPARATION_M) or 40.0
    if not finiteNumber(separation) or separation>maxTraceSeparation then return nil end
    local arrangement=plan.passageArrangement or {}
    local guide=plan.passageGuide or {}
    local sweep=guide.pairSweepSupport or {}
    local crossing=tonumber(sweep.minimumCrossingWindowClearanceM)
    local required=tonumber(sweep.requiredNominalClearanceM)
    local residue=(finiteNumber(crossing) and finiteNumber(required)) and (crossing-required) or nil
    local outside=tonumber(sweep.minimumOutsideCrossingClearanceM)
    local minimum=tonumber(sweep.minimumRepresentedClearanceM)
    local floor=tonumber(sweep.acceptedNominalClearanceFloorM)
    local floorResidue=(finiteNumber(crossing) and finiteNumber(floor)) and (crossing-floor) or nil
    local config=plan.passageConfiguration or {}
    local participants=config.participants or {}
    local c1,c2=participants[1] or {},participants[2] or {}
    return string.format(
        "D0146_PASSAGE_CLEARANCE_TRACE conflict=%s outcome=SELECTED separation=%.2f longitudinal=%.2f lateral=%.3f selectedIndex=%s crossing=%s nominal=%s nominalResidue=%s floor=%s floorResidue=%s outside=%s minimum=%s contact=%.3f offsets=%+.3f/%+.3f relation=%s configuration=%s/%s geometry=%s",
        tostring(plan.conflictIdentity or "n/a"),separation,tonumber(plan.longitudinalSeparationM) or -1,tonumber(arrangement.currentLateralSeparationM) or -1,
        tostring(plan.progressiveSearch and plan.progressiveSearch.selectedIndex or "n/a"),finiteNumber(crossing) and string.format("%.3f",crossing) or "n/a",finiteNumber(required) and string.format("%.3f",required) or "n/a",
        finiteNumber(residue) and string.format("%+.3f",residue) or "n/a",finiteNumber(floor) and string.format("%.3f",floor) or "n/a",finiteNumber(floorResidue) and string.format("%+.3f",floorResidue) or "n/a",finiteNumber(outside) and string.format("%.3f",outside) or "n/a",finiteNumber(minimum) and string.format("%.3f",minimum) or "n/a",
        tonumber(arrangement.physicalContactThresholdM) or -1,tonumber(arrangement.subjectLateralOffsetM) or 0,tonumber(arrangement.otherLateralOffsetM) or 0,tostring(arrangement.relationSign or "n/a"),
        tostring(c1.mode or "n/a"),tostring(c2.mode or "n/a"),tostring(arrangement.passageGeometrySource or arrangement.directionalPassageEnvelopeBasis or "n/a"))
end

local function followerMatchesCooperative(follower,record)
    if type(follower)~="table" or type(record)~="table" then return false end
    local ids={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(record.assemblyIds or {}) do ids[id]=true end
    return ids[follower.leaderAssemblyId]==true and ids[follower.followerAssemblyId]==true
end

function Support:attach(picture,snapshot)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(snapshot,"ObservationSnapshot")

    local follower,followerReason=followerBoundaryRecord(picture)
    if follower~=nil and follower.status=="RETIRE_SUPPORTED" then return attachFollowerBoundary(self,picture,snapshot,follower) end
    if followerReason~=nil then self.lastStatus=followerReason; return self.passiveSupport:attach(picture,snapshot) end

    local guard,guardReason=activeGuardedRecovery(picture)
    if guard~=nil then return attachGuardedRecovery(self,picture,snapshot,guard) end
    if guardReason~=nil then self.lastStatus=guardReason; return self.passiveSupport:attach(picture,snapshot) end

    -- An established follower purpose has precedence. Otherwise the earliest
    -- supported Forward Intersection is considered before Passage planning.
    if follower==nil then
        local forward,forwardReason=forwardIntersectionRecord(picture)
        if forward~=nil then return attachD0146ActionSpace(self,picture,snapshot,forward) end
        if forwardReason~=nil then self.lastStatus=forwardReason; return self.passiveSupport:attach(picture,snapshot) end
    end

    -- D-0181: D-0146 is the single production Cooperative Passage authority.
    -- There is no feature switch or D-0143 fallback path to resurrect.
        local plan,reason,rejected=OuttaMyWay.LocalPassagePlanner.plan(picture,snapshot)
        if plan==nil then
            for _,clearanceTrace in ipairs(passageClearanceRejectionTelemetry(rejected)) do logInfo("%s",clearanceTrace) end
            local rejectionKey,rejectionText=passageRejectionTelemetry(rejected)
            if rejectionKey~=nil and rejectionKey~=self.lastPassageRejectionTraceKey then
                self.lastPassageRejectionTraceKey=rejectionKey
                logInfo("D0146_PASSAGE_REJECTED %s",rejectionText)
            end
            local actionSpace,actionReason=d0146ActionSpaceRecord(picture)
            if actionSpace~=nil then return attachD0146ActionSpace(self,picture,snapshot,actionSpace) end
            if actionReason~=nil then self.lastStatus=actionReason; return self.passiveSupport:attach(picture,snapshot) end
            if follower~=nil then return attachFollowerBoundary(self,picture,snapshot,follower) end
            self.lastCooperativeTraceKey=nil
            self.lastStatus=reason or "NO_SUPPORTED_D0146_LOCAL_PASSAGE"
            return self.passiveSupport:attach(picture,snapshot)
        end
        self.lastPassageRejectionTraceKey=nil
        local selectedClearanceTrace=passageClearanceSelectedTelemetry(plan)
        if selectedClearanceTrace~=nil then logInfo("%s",selectedClearanceTrace) end
        if follower~=nil and not followerMatchesCooperative(follower,{assemblyIds=plan.assemblyIds or {}}) then
            return attachFollowerBoundary(self,picture,snapshot,follower)
        end

        -- D-0159 corrective boundary: Passage Selection immediately restores the
        -- proven v0.1.3.0 Resolution-to-Passage authority handoff.  Physical
        -- Passage Entry may still be delayed, but that delay is owned inside
        -- Cooperative Passage execution rather than by retaining D-0155.

        local values=OuttaMyWay.ValueRecord.toTable(picture)
        local pictureId=self.identities:issue("PICTURE")
        values.identity=pictureId; values.epoch=self.epochs:next()
        values.provenance={source="LiveTrafficCandidateSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity,authority="D0146_STEP2_ACTIVE_TEST",followerBoundarySupportingLeaseRetained=follower~=nil}
        local governingRequirementKey=d0146RequirementKey(plan)
        local traceKey=tostring(plan.conflictIdentity)
        local firstTrace=self.lastCooperativeTraceKey~=traceKey
        if firstTrace then
            self.lastCooperativeTraceKey=traceKey
            local arrangement=plan.passageArrangement or {}; local guide=plan.passageGuide or {}; local sweep=guide.pairSweepSupport or {}
            local config=plan.passageConfiguration or {}; local participants=config.participants or {}
            local c1=participants[1] or {}; local c2=participants[2] or {}
            logInfo("D0146_PASSAGE_SELECTED conflict=%s separation=%.2f entryReady=%s entryBoundary=%.2f lateral=%.2f contact=%.2f nominal=%.2f required=%.2f reserve=%+.2f envelopeBasis=%s sweepBasis=%s crossingBasis=%s arrangement=%s offsets=%+.2f/%+.2f deficit=%.2f configuration=%s/%s release=%.2f profiles=%s/%s guide=%s gates=%d development=%.2f crossingForward=%.2f recovery=%.2f minimumRepresentedClearance=%.2f searchIndex=%s",
                tostring(plan.conflictIdentity),tonumber(plan.separationM) or -1,tostring(plan.passageEntry and plan.passageEntry.ready==true),tonumber(plan.passageEntry and plan.passageEntry.boundarySeparationM) or -1,tonumber(arrangement.currentLateralSeparationM) or -1,tonumber(arrangement.physicalContactThresholdM) or -1,tonumber(arrangement.nominalInterAssemblyClearanceM) or -1,tonumber(arrangement.policyRequiredSeparationM) or -1,tonumber(arrangement.currentPolicyReserveM) or -1,
                tostring(arrangement.directionalPassageEnvelopeBasis or "DISC_FALLBACK"),tostring(sweep.supportBasis or "n/a"),tostring(plan.passageExcursion and plan.passageExcursion.crossingWindowBasis or "n/a"),tostring(arrangement.identity),tonumber(arrangement.subjectLateralOffsetM) or 0,tonumber(arrangement.otherLateralOffsetM) or 0,tonumber(plan.passageExcursion and plan.passageExcursion.clearanceDeficitM) or 0,
                tostring(c1.mode or "n/a"),tostring(c2.mode or "n/a"),tonumber(config.totalConfigurationReleasedSpaceM) or 0,tostring(c1.expectedCompactConfigurationProfileId or c1.currentConfigurationProfileId or "n/a"),tostring(c2.expectedCompactConfigurationProfileId or c2.currentConfigurationProfileId or "n/a"),
                tostring(guide.identity),#(guide.gates or {}),tonumber(plan.passageExcursion and plan.passageExcursion.developmentDistanceM) or 0,tonumber(plan.passageExcursion and plan.passageExcursion.crossingWindowForwardPerParticipantM) or 0,tonumber(plan.passageExcursion and plan.passageExcursion.recoveryDistanceM) or 0,tonumber(sweep.minimumRepresentedClearanceM) or -1,tostring(plan.progressiveSearch and plan.progressiveSearch.selectedIndex or "n/a"))
        end
        local specification=makeD0146PassageCandidate(pictureId,values,plan,governingRequirementKey)
        values.candidateSupportEvidence={
            complete=true,
            supportBoundary={mode="D0146_COOPERATIVE_PASSAGE_STEP2_TEST",supportedCandidateClasses={"REPOSITION"},physicalCapabilitiesImplemented=true,controlAuthority="D0146_BOUNDED_ACTIVE_TEST",boundedScope="ESTABLISHED_CONFLICT_CONFIGURATION_FIRST_PAIR_SPECIFIC_CLEARANCE_WITH_OPERATION_AWARE_LOCAL_SPACE",king=false,refuge=false,vehicleNameAdmissionGate=false,generalVehicleAuthority=false,decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=governingRequirementKey}},
            candidateSpecifications={specification},
            provenance={source="LiveTrafficCandidateSupport",observationSnapshotId=snapshot.identity,authority="D0146_STEP2_ACTIVE_TEST",operatorCommandRequired=false}
        }
        self.publishedCount=self.publishedCount+1
        self.lastStatus="D0146_STEP2_COOPERATIVE_PASSAGE_CANDIDATE_PUBLISHED"
        return OuttaMyWay.OperationalPicture.new(values)
end

function Support:getPublishedCount() return self.publishedCount end
