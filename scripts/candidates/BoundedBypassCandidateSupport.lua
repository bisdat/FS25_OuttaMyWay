--- Projects independently supported Fixed Bypass Dogleg sides into ordinary prospective Candidate admission.
-- Specification Jurisdictions: `CANDIDATE_SUPPORT`, `BOUNDED_BYPASS`
OuttaMyWay.BoundedBypassCandidateSupport={}
local Support=OuttaMyWay.BoundedBypassCandidateSupport
Support.__index=Support
local V=OuttaMyWay.ValueRecord
local E=OuttaMyWay.BoundedBypassEvidence
function Support.new(runtime) return setmetatable({runtime=runtime,lastStatus="INACTIVE",publishedCount=0},Support) end
local function exhausted(picture,k)
    for _,r in V.ipairs(picture.blockedWorkerRecoveryRecurrenceKnowledge or {}) do
        if r.correlated==true and r.status=="RECOVERY_STRATEGY_EXHAUSTED" and r.assemblyId==k.assemblyId
            and r.successorJobEpisodeId==k.jobEpisodeId and r.successorSourceJobToken==k.sourceJobToken
            and k.stallEvidence~=nil and r.currentStallObservationSnapshotId==k.stallEvidence.establishedAtObservationSnapshotId then return true end
    end
    return false
end
local function specification(bridge,epoch)
    local key=bridge.bypassKey
    return {
        referenceKey=key..":"..tostring(bridge.guide.side),purpose={kind="BOUNDED_BYPASS",result="FIXED_DOGLEG_THEN_CURRENT_JOB_HANDBACK"},
        subject={assemblyId=bridge.assemblyId},capability="REPOSITION",
        expectedEffect={physicalChange=true,transitRequested=true},
        evidenceBasis={boundedBypassBridge=bridge,
            governingBasis={kind="BOUNDED_BYPASS",responsibilityKey=key,operationIds={bridge.operationId},sourceIntentIds={bridge.sourceJobToken}},
            progressActuationOwnership={assemblyIds={bridge.assemblyId}},independentConcurrentCommitment=true,
            effectiveActuationComposition={identity=key..":composition:"..epoch,epoch=epoch,relevantAssemblyIds={bridge.assemblyId},
                entries={{assemblyId=bridge.assemblyId,commitmentId="$NEW_COMMITMENT",capability="REPOSITION",effectClass="BOUNDED_BYPASS",progressActuation=true}}}},
        representationFitness={requirements={{representationId=bridge.guideRepresentationId,acceptedStates={"FIT_FOR_LIMITED_HORIZON"}}}},preconditions={evidenceContracts={{kind="SUPPORTED_FIXED_BYPASS_DOGLEG"}}},
        invalidationConditions={{kind="PLAYER_CLAIM"},{kind="JOB_CONTINUITY_LOST"},{kind="BYPASS_SUPPORT_CONTRADICTED"}},
        reversibility={kind="ONE_FORWARD_EXCURSION"},
        obligationsCreated={{origin={kind="CORRELATED_RECOVERY_RECURRENCE"},basis={kind="BOUNDED_BYPASS",bypassKey=key},
            requiredOutcome={kind="BYPASS_AXIS_REJOIN_OR_PLAYER_ESCALATION"},requiredAuthority={classes={"PROGRESS_ACTUATION"}},
            evidenceContract={kind="FINAL_REJOIN_REACHED_OR_UNSUPPORTED_EXECUTION_ESCALATED"},ownershipClass="ORIGIN_BOUND",
            transferPolicy={allowed=false},terminalDependency=true,creationEvidence={observationSnapshotId=bridge.observationSnapshotId}}},
        releaseImplications={existingJobHandback=true},uncertainty={{kind="REFERENCE_GUIDE_NOT_ARTICULATED_SWEEP"}},comparisonCost=1}
end
function Support:buildFreshProjectedGroup(picture,snapshot,targetPictureId,targetEpoch)
    local function refuse(reason) self.lastStatus=reason; return nil,reason end
    if picture.observationSnapshotId~=snapshot.identity then return refuse("BYPASS_EVIDENCE_CONTEXT_MISMATCH") end
    for _,context in V.ipairs(picture.commitmentContext or {}) do
        if context.governingBasis and context.governingBasis.kind=="BLOCKED_WORKER_RECOVERY" then return refuse("RECOVERY_BUBBLE_CURRENT") end
    end
    local available={}
    for _,k in V.ipairs(picture.blockedProgressKnowledge or {}) do
        if k.blockedProgressStall==true and exhausted(picture,k) then available[#available+1]=k end
    end
    if #available~=1 then return refuse("ONE_EXHAUSTED_SUCCESSOR_STALL_REQUIRED") end
    local k=available[1]
    if not E.isMember(picture,k.operationId,k.assemblyId) then return refuse("BYPASS_OPERATION_MEMBERSHIP_UNAVAILABLE") end
    local key="bounded-bypass:"..k.operationId..":"..k.assemblyId..":"..k.jobEpisodeId..":"..tostring(k.stallEvidence.establishedAtObservationSnapshotId)
    for _,commitment in V.ipairs(self.runtime.commitments:list()) do
        if commitment.governingBasis and commitment.governingBasis.responsibilityKey==key then return refuse("BYPASS_STALL_ALREADY_ATTEMPTED") end
    end
    local episode=self.runtime.jobEpisodes:getActiveForAssembly(k.assemblyId)
    if episode==nil or episode.identity~=k.jobEpisodeId or episode.sourceJobToken~=k.sourceJobToken
        or E.hasPlayerClaim(snapshot,k.assemblyReferenceKey,true) then return refuse("BYPASS_CURRENT_JOB_OR_PLAYER_AUTHORITY_UNSUPPORTED") end
    if self.runtime.authorities:ownerOf(k.assemblyId)~=nil then return refuse("BYPASS_MOVEMENT_ALREADY_OWNED") end
    local activeCausalBlockerAssemblyIds=E.activeCausalBlockerIds(self.runtime,picture,k.operationId,k.assemblyId)
    local frame=E.frame(picture,snapshot,k)
    if frame==nil then return refuse("CURRENT_SUCCESSOR_CONTINUATION_FRAME_UNSUPPORTED") end
    local capability=self.runtime.assemblyRepresentationCache:getTransitFoldCapability(k.assemblyReferenceKey,k.sourceJobToken)
    if type(capability)~="table" or type(capability.members)~="table" then return refuse("BYPASS_TRANSIT_UNSUPPORTED") end
    local candidates,fitness={},{}
    for _,side in ipairs({1,-1}) do
        local guide=OuttaMyWay.FixedBypassDogleg.build(frame,side)
        local supported,reserve=OuttaMyWay.FixedBypassDogleg.support(snapshot.fieldWorld,guide)
        if supported then
            local bridge={architecture="BOUNDED_BYPASS",bypassKey=key,operationId=k.operationId,
                assemblyId=k.assemblyId,assemblyReferenceKey=k.assemblyReferenceKey,jobEpisodeId=k.jobEpisodeId,sourceJobToken=k.sourceJobToken,
                observationSnapshotId=snapshot.identity,activeCausalBlockerAssemblyIds=activeCausalBlockerAssemblyIds,
                guide=guide,fieldInteriorReserveM=reserve,
                guideRepresentationId=key..":"..side..":"..targetPictureId}
            fitness[#fitness+1]={representationId=bridge.guideRepresentationId,assemblyId=k.assemblyId,
                question="FIXED_BYPASS_REFERENCE_GUIDE_INSIDE_FIELD",state="FIT_FOR_LIMITED_HORIZON",
                claimPermissions={"FIXED_REFERENCE_GUIDE_SUPPORT"},
                coverage={complete=false,conservative=false,underApproximationRisk=true},
                uncertainty={"REFERENCE_GUIDE_NOT_ARTICULATED_SWEEP","NO_NEGATIVE_CLEARANCE_AUTHORITY"},
                provenance={source="BoundedBypassCandidateSupport",observationSnapshotId=snapshot.identity,negativeClearanceAuthority=false}}
            candidates[#candidates+1]=specification(bridge,targetEpoch)
        end
    end
    if #candidates==0 then return refuse("NO_SUPPORTED_FIXED_DOGLEG_SIDE") end
    self.lastStatus="BYPASS_CANDIDATES_SUPPORTED"; self.publishedCount=self.publishedCount+1
    return {supportBoundary={mode="BOUNDED_BYPASS",supportedCandidateClasses={"REPOSITION"},physicalCapabilitiesImplemented=true,
        controlAuthority="FIXED_BYPASS_DOGLEG",boundedScope="ONE_EXCURSION",targetOperationalPictureId=targetPictureId,parentOperationalPictureId=picture.identity},
        candidateSpecifications=candidates,representationFitness=fitness}
end
function Support:getLastStatus() return self.lastStatus end
function Support:getPublishedCount() return self.publishedCount end
