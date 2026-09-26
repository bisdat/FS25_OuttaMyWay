--- Constructs one Blocked Worker Recovery Candidate from current positive Stall + Anchor knowledge.
-- Specification Jurisdictions: `CANDIDATE_SUPPORT`, `BLOCKED_WORKER_RECOVERY`

OuttaMyWay.BlockedWorkerRecoveryCandidateSupport={}
local Support=OuttaMyWay.BlockedWorkerRecoveryCandidateSupport
Support.__index=Support

local function finite(v) return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge end

local function recoveryAlreadyCurrent(picture,recoveryKey)
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture.commitmentContext or {}) do
        local basis=context.governingBasis or {}
        if basis.kind=="BLOCKED_WORKER_RECOVERY" and basis.responsibilityKey==recoveryKey then return true end
    end
    return false
end

local function currentPhysicalRepresentation(picture,knowledge)
    for _,physical in OuttaMyWay.ValueRecord.ipairs(picture.physicalSpaceEvidence or {}) do
        if physical.assemblyId==knowledge.assemblyId
            and physical.assemblyReferenceKey==knowledge.assemblyReferenceKey then
            return physical
        end
    end
    return nil
end

local function recoveryRepresentationFitness(picture,knowledge,anchor,recoveryKey,targetPictureId)
    local physical=currentPhysicalRepresentation(picture,knowledge)
    local representationId="blocked-worker-recovery-physical:"..recoveryKey..":"..targetPictureId
    local primitiveCount=physical and OuttaMyWay.ValueRecord.length(physical.primitives or {}) or 0
    local summaryCount=physical and physical.summary and tonumber(physical.summary.physicalPrimitiveCount) or nil
    local profile=physical and physical.configurationProfileId or nil
    local fit=physical~=nil
        and type(profile)=="string"
        and profile==anchor.configurationProfileId
        and primitiveCount>0
        and (summaryCount==nil or summaryCount>0)
    return {
        representationId=representationId,
        assemblyId=knowledge.assemblyId,
        question="BLOCKED_WORKER_RECOVERY_LOCAL_RETURN_REFERENCE",
        assessmentHorizon="CURRENT_STALL_TO_SELECTED_RECOVERY_ANCHOR",
        state=fit and "FIT_FOR_LIMITED_HORIZON" or "REFRESH_REQUIRED",
        claimPermissions=fit and {"BLOCKED_WORKER_RECOVERY_LOCAL_RETURN_REFERENCE"} or {},
        coverage={complete=false,conservative=false,underApproximationRisk=true},
        uncertainty=fit and {
            "RECOVERY_ANCHOR_PURPOSE_SPECIFIC_NOT_GENERAL_CLEARANCE",
            "REVERSE_FEASIBILITY_NOT_INFERRED_FROM_REPRESENTATION",
            "NO_PRODUCTIVE_ROUTING_AUTHORITY"
        } or {"CURRENT_RECOVERY_PHYSICAL_REFERENCE_UNAVAILABLE_OR_CONFIGURATION_MISMATCH"},
        validityDependencies={
            "CURRENT_OPERATIONAL_PICTURE","SAME_PHYSICAL_ASSEMBLY","SAME_JOB_EPISODE",
            "SAME_RECOVERY_ANCHOR_CONFIGURATION","CURRENT_POSITIVE_PHYSICAL_PRIMITIVES"
        },
        evidence={
            recoveryKey=recoveryKey,
            assemblyReferenceKey=knowledge.assemblyReferenceKey,
            currentConfigurationProfileId=profile,
            anchorConfigurationProfileId=anchor.configurationProfileId,
            physicalPrimitiveCount=primitiveCount,
            summaryPhysicalPrimitiveCount=summaryCount,
            negativeClearanceAuthority=physical and physical.negativeClearanceAuthority==true or false
        },
        provenance={
            source="BlockedWorkerRecoveryCandidateSupport",
            layer="CANDIDATE_SUPPORT_PROJECTION",
            authority="BLOCKED_WORKER_RECOVERY_PURPOSE_LOCAL_REPRESENTATION_FITNESS",
            parentPhysicalEvidence=physical and physical.provenance or nil,
            anchorObservationSnapshotId=anchor.observationSnapshotId,
            negativeClearanceAuthority=false
        }
    }
end

local function recoveryKnowledge(picture)
    local result={}
    for _,knowledge in OuttaMyWay.ValueRecord.ipairs(picture.blockedProgressKnowledge or {}) do
        local anchor=knowledge.recoveryAnchor
        if knowledge.blockedProgressStall==true and type(anchor)=="table"
            and finite(anchor.poseX) and finite(anchor.poseZ)
            and type(anchor.configurationProfileId)=="string"
            and type(knowledge.assemblyId)=="string" and type(knowledge.assemblyReferenceKey)=="string"
            and type(knowledge.jobEpisodeId)=="string" and type(knowledge.operationId)=="string"
            and type(knowledge.sourceJobToken)=="string" then
            result[#result+1]=knowledge
        end
    end
    table.sort(result,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
    return result
end

function Support.new()
    return setmetatable({publishedCount=0,lastStatus="INACTIVE"},Support)
end

function Support:buildFreshProjectedGroup(picture,snapshot,targetPictureId,targetEpoch)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(snapshot,"ObservationSnapshot")
    local available=recoveryKnowledge(picture)
    if #available==0 then self.lastStatus="NO_RECOVERY_STALL_WITH_ANCHOR"; return nil,"NO_RECOVERY_STALL_WITH_ANCHOR" end
    if #available>1 then self.lastStatus="MULTIPLE_RECOVERY_STALLS_REQUIRE_COMPARATOR"; return nil,"MULTIPLE_RECOVERY_STALLS_REQUIRE_COMPARATOR" end
    local knowledge=available[1]
    local anchor=knowledge.recoveryAnchor
    local recoveryKey="blocked-worker-recovery:"..knowledge.operationId..":"..knowledge.assemblyId..":"..knowledge.jobEpisodeId
    if recoveryAlreadyCurrent(picture,recoveryKey) then self.lastStatus="RECOVERY_ALREADY_CURRENT"; return nil,"RECOVERY_ALREADY_CURRENT" end
    local fitness=recoveryRepresentationFitness(picture,knowledge,anchor,recoveryKey,targetPictureId)
    local specification={
        referenceKey=recoveryKey..":to-anchor",
        purpose={kind="BLOCKED_WORKER_RECOVERY",result="RETURN_TO_RECOVERY_ANCHOR_AND_HAND_BACK"},
        subject={assemblyId=knowledge.assemblyId},
        capability="REPOSITION",
        expectedEffect={physicalChange=true,recoveryPoint="RECOVERY_ANCHOR",transitRequested=true,configurationRestoredBeforeHandback=true,handbackToGiants=true},
        evidenceBasis={
            governingBasis={
                kind="BLOCKED_WORKER_RECOVERY",responsibilityKey=recoveryKey,
                operationIds={knowledge.operationId},sourceIntentIds={knowledge.sourceJobToken},
                recoveryAssemblyId=knowledge.assemblyId,jobEpisodeId=knowledge.jobEpisodeId
            },
            progressActuationOwnership={assemblyIds={knowledge.assemblyId}},
            effectiveActuationComposition={
                identity="blocked-worker-recovery-composition:"..recoveryKey..":"..targetPictureId,
                epoch=targetEpoch,relevantAssemblyIds={knowledge.assemblyId},
                entries={{assemblyId=knowledge.assemblyId,commitmentId="$NEW_COMMITMENT",capability="REPOSITION",effectClass="BLOCKED_WORKER_RECOVERY",progressActuation=true}}
            },
            independentConcurrentCommitment=true,
            blockedWorkerRecoveryBridge={
                architecture="BLOCKED_WORKER_RECOVERY",recoveryKey=recoveryKey,
                operationId=knowledge.operationId,assemblyId=knowledge.assemblyId,
                assemblyReferenceKey=knowledge.assemblyReferenceKey,jobEpisodeId=knowledge.jobEpisodeId,
                sourceJobToken=knowledge.sourceJobToken,
                recoveryAnchor={
                    observationSnapshotId=anchor.observationSnapshotId,
                    x=anchor.poseX,z=anchor.poseZ,usefulSpanM=anchor.usefulSpanM,
                    configurationProfileId=anchor.configurationProfileId
                }
            }
        },
        representationFitness={requirements={{representationId=fitness.representationId,acceptedStates={"FIT_FOR_LIMITED_HORIZON"}}}},
        preconditions={evidenceContracts={{kind="BLOCKED_PROGRESS_STALL"},{kind="RECOVERY_ANCHOR"}}},
        invalidationConditions={{kind="PLAYER_CLAIM"},{kind="JOB_EPISODE_CHANGED"},{kind="RECOVERY_ANCHOR_INVALIDATED"}},
        reversibility={kind="ONE_RECOVERY_EXCURSION_TO_ANCHOR_THEN_GIANTS_HANDBACK"},
        obligationsCreated={{
            origin={kind="BLOCKED_PROGRESS_STALL",recoveryKey=recoveryKey},
            basis={kind="BLOCKED_WORKER_RECOVERY",assemblyId=knowledge.assemblyId,jobEpisodeId=knowledge.jobEpisodeId},
            requiredOutcome={kind="BLOCKED_WORKER_RECOVERY_RESTORED_AND_HANDED_BACK"},
            requiredAuthority={classes={"PROGRESS_ACTUATION"}},
            evidenceContract={kind="RECOVERY_ANCHOR_REACHED_RESTORED_AND_HANDED_BACK"},
            ownershipClass="ORIGIN_BOUND",transferPolicy={allowed=false},terminalDependency=true,
            creationEvidence={stall=knowledge.stallEvidence,anchor=knowledge.recoveryAnchor}
        }},
        releaseImplications={releaseBoundedAuthorityAfterActuation=true,handBackToGiants=true},
        uncertainty={{kind="RECOVERY_ANCHOR_PURPOSE_SPECIFIC_NOT_GENERAL_CLEARANCE"}},
        comparisonCost=1
    }
    self.publishedCount=self.publishedCount+1
    self.lastStatus="RECOVERY_CANDIDATE_SUPPORTED"
    return {
        supportBoundary={
            mode="BLOCKED_WORKER_RECOVERY",supportedCandidateClasses={"REPOSITION"},physicalCapabilitiesImplemented=true,
            controlAuthority="SELECTED_RECOVERY_ANCHOR_ONLY",boundedScope="ONE_RECOVERY_EXCURSION_TO_SELECTED_ANCHOR",
            targetOperationalPictureId=targetPictureId,parentOperationalPictureId=picture.identity
        },
        candidateSpecifications={specification},
        representationFitness={fitness}
    },nil
end

function Support:getPublishedCount() return self.publishedCount end
function Support:getLastStatus() return self.lastStatus end
