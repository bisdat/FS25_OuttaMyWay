OuttaMyWay.PassiveLiveCandidateSupport = {}
local Support = OuttaMyWay.PassiveLiveCandidateSupport
Support.__index = Support

local mandatory={"FIELD_WORLD_CONTAINMENT","TRANSITION_CLEARANCE","REPRESENTATION_FITNESS","CONTROL_CAPABILITY_AVAILABILITY","CONTINUING_INTENT_PRIORITY","PROGRESS_PRESERVATION","RESPONSIBILITY_COMPATIBILITY","OBLIGATION_COMPATIBILITY","COMMITMENT_PRECONDITIONS","EFFECTIVE_ACTUATION_COMPOSITION","SAFE_RELEASE_HANDOVER"}

local function packet(reason,applicable)
    return {result="PASS",applicable=applicable,evidence={passive=true},provenance={source="PassiveLiveCandidateSupport"},reason=reason,revalidationTrigger={kind="NEXT_PASSIVE_SAMPLE"}}
end

function Support.new(identityRegistry,epochSequence)
    return setmetatable({identities=identityRegistry,epochs=epochSequence,publishedCount=0},Support)
end

function Support:attach(picture,snapshot)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(snapshot,"ObservationSnapshot")
    local observe=OuttaMyWay.ValueRecord.length(snapshot.assemblies)>0 or OuttaMyWay.ValueRecord.length(snapshot.unavailableSources)>0 or OuttaMyWay.ValueRecord.length(picture.encounters)>0 or OuttaMyWay.ValueRecord.length(picture.uncertainty)>0
    local capability=observe and "CONTINUE_OBSERVATION" or "CONTINUE_UNCHANGED"
    local evidence={constraintEvidence={},governingBasis={responsibilityKey="passive-live:"..picture.identity,sourceIntentIds=picture.identities.jobEpisodes.active,operationIds=picture.identities.operations.active}}
    for _,id in OuttaMyWay.ValueRecord.ipairs(mandatory) do evidence.constraintEvidence[id]=packet("Non-actuating passive validation candidate",false) end
    local preconditions={evidenceContracts={}}
    if observe then
        preconditions.boundedObservationContract={knowledgeGap="LIVE_ADMISSION_OR_REPRESENTATION_EVIDENCE_REMAINS_INCOMPLETE",expectedRealityEvolution="NEXT_PASSIVE_SAMPLE",preservedUsefulAction="GIANTS_NATIVE_PROGRESS_UNCHANGED",exhaustionCondition="MATERIAL_TRACE_CHANGE_OR_REASSESSMENT_DEADLINE",reassessmentDeadline=snapshot.timestamp+((OuttaMyWay.PASSIVE_SAMPLE_INTERVAL_MS or 1000)/1000),progressParticipantId=picture.identities.assemblies[1] or picture.identities.jobEpisodes.active[1] or "PASSIVE_FIELD_WORLD"}
    end
    local specification={
        referenceKey="passive:"..picture.identity..":"..capability,
        purpose={kind="PASSIVE_LIVE_VALIDATION",result="PUBLISH_CANONICAL_TRACE"},
        subject={assemblyIds=picture.identities.assemblies},capability=capability,
        expectedEffect={physicalChange=false,giantsAuthorityPreserved=true},evidenceBasis=evidence,
        representationFitness={requirements={}},preconditions=preconditions,
        invalidationConditions={{kind="NEXT_PASSIVE_SAMPLE"}},reversibility={physicalEffect=false},
        obligationsCreated={},releaseImplications={none=true},uncertainty=picture.uncertainty,
        comparisonCost=observe and 1 or 0
    }
    local values=OuttaMyWay.ValueRecord.toTable(picture)
    values.identity=self.identities:issue("PICTURE"); values.epoch=self.epochs:next()
    values.provenance={source="PassiveLiveCandidateSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity}
    values.candidateSupportEvidence={complete=true,supportBoundary={mode="PASSIVE_LIVE_ZERO_CONTROL",supportedCandidateClasses={capability},physicalCapabilitiesImplemented=false,controlAuthority=false},candidateSpecifications={specification},provenance={source="PassiveLiveCandidateSupport",observationSnapshotId=snapshot.identity}}
    self.publishedCount=self.publishedCount+1
    return OuttaMyWay.OperationalPicture.new(values)
end
function Support:getPublishedCount() return self.publishedCount end
