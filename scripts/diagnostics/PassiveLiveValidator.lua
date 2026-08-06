OuttaMyWay.PassiveLiveValidator = {}
local Validator=OuttaMyWay.PassiveLiveValidator
Validator.__index=Validator

local function logInfo(message)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][PASSIVE] %s",message) else print("[FS25_OuttaMyWay][PASSIVE] "..message) end
end
local function logError(message)
    if Logging~=nil and type(Logging.error)=="function" then Logging.error("[FS25_OuttaMyWay][PASSIVE] %s",message) else print("[FS25_OuttaMyWay][PASSIVE][ERROR] "..message) end
end
local function selectedCapability(result)
    local id=result.decision.selectedCandidateId
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(result.candidates or {}) do if candidate.identity==id then return candidate.capability end end
    return nil
end
local function activeAssemblyCount(snapshot)
    local count=0
    for _,state in OuttaMyWay.ValueRecord.pairs(snapshot.aiStates or {}) do if state.observedActive==true or state.fieldActive==true or state.aiActive==true then count=count+1 end end
    return count
end
local function candidateVerdictSummary(result)
    local states={}
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(result.candidates or {}) do states[candidate.identity]={failed=false,unresolved=false} end
    for _,verdict in OuttaMyWay.ValueRecord.ipairs(result.verdicts or {}) do
        local state=states[verdict.candidateId]
        if state~=nil then
            if verdict.result=="FAIL" then state.failed=true elseif verdict.result=="UNRESOLVED" then state.unresolved=true end
        end
    end
    local pass,unresolved,failed=0,0,0
    for _,state in OuttaMyWay.ValueRecord.pairs(states) do
        if state.failed then failed=failed+1 elseif state.unresolved then unresolved=unresolved+1 else pass=pass+1 end
    end
    return pass,unresolved,failed
end

function Validator.new(runtime,source,support,probe,fieldWorldSnapshots)
    return setmetatable({runtime=runtime,source=source,support=support,probe=probe,fieldWorldSnapshots=fieldWorldSnapshots,elapsed=0,lastLogAt=-math.huge,lastSignature=nil,records={},errorCount=0},Validator)
end
function Validator:loadMap()
    self.elapsed=0; self.lastSignature=nil; self.lastLogAt=-math.huge; self.records={}; self.errorCount=0; self.source:reset(); if self.probe~=nil then self.probe:reset() end; if self.fieldWorldSnapshots~=nil then self.fieldWorldSnapshots:reset() end
    logInfo("Field World equivalence evidence listener active; exact fingerprints remain provisional Operation authority; source-intent termination enabled; replacement Control authority disabled")
end
function Validator:deleteMap() self.source:reset(); if self.probe~=nil then self.probe:reset() end; if self.fieldWorldSnapshots~=nil then self.fieldWorldSnapshots:reset() end; self.elapsed=0; self.lastSignature=nil end
function Validator:keyEvent() end
function Validator:mouseEvent() end
function Validator:draw() end

function Validator:_record(raw)
    if self.runtime.controlAuthorityEnabled~=false or OuttaMyWay.CONTROL_AUTHORITY_ENABLED~=false then error("passive-live validation detected enabled Control authority",2) end
    local processed=self.runtime:processSealedObservation(raw)
    local supported=self.support:attach(processed.picture,processed.snapshot)
    local evaluated=self.runtime:evaluateSealedOperationalPicture(supported)
    local capability=selectedCapability(evaluated)
    local passCandidates,unresolvedCandidates,failedCandidates=candidateVerdictSummary(evaluated)
    local record=OuttaMyWay.PassiveLiveTraceRecord.new({
        identity=self.runtime.identities:issue("PASSIVE_LIVE_TRACE"),epoch=self.runtime.epochs:next(),timestamp=raw.timestamp,status="TRACE",
        observationSnapshotId=processed.snapshot.identity,operationalPictureId=supported.identity,candidateInventoryId=evaluated.candidateInventory.identity,verdictSetId=evaluated.verdictSet.identity,decisionId=evaluated.decision.identity,
        selectedCandidateId=evaluated.decision.selectedCandidateId,selectedCapability=capability,nonIntervention=evaluated.decision.nonIntervention,
        observedAssemblyCount=OuttaMyWay.ValueRecord.length(processed.snapshot.assemblies),activeAssemblyCount=activeAssemblyCount(processed.snapshot),activeJobEpisodeCount=OuttaMyWay.ValueRecord.length(processed.jobEpisodes.activeEpisodeIds),
        admittedEpisodeCount=OuttaMyWay.ValueRecord.length(processed.jobEpisodes.admittedEpisodeIds),endedEpisodeCount=OuttaMyWay.ValueRecord.length(processed.jobEpisodes.endedEpisodeIds),activeOperationCount=OuttaMyWay.ValueRecord.length(processed.operation.activeOperationIds),
        situationCount=OuttaMyWay.ValueRecord.length(supported.situations),encounterCount=OuttaMyWay.ValueRecord.length(supported.encounters),candidateCount=#evaluated.candidates,allPassCandidateCount=passCandidates,
        unresolvedCandidateCount=unresolvedCandidates,failedCandidateCount=failedCandidates,unavailableSourceCount=OuttaMyWay.ValueRecord.length(processed.snapshot.unavailableSources),
        fieldWorldReferenceKey=processed.snapshot.fieldWorld.referenceKey,fieldWorldFingerprint=processed.snapshot.fieldWorld.geometryFingerprint,
        playerFacingFieldLocators=processed.snapshot.fieldWorld.playerFacingFieldLocators or {},
        globalActiveOperationCount=OuttaMyWay.ValueRecord.length(self.runtime.operations:listActive()),controlAuthorityEnabled=false,
        provenance={source="PassiveLiveValidator",fieldWorld=supported.provenance,decisionCommitmentBoundaryApplied=false}
    })
    self.records[#self.records+1]=record
    self.runtime.trace:append("PASSIVE_LIVE_TRACE",record.epoch,OuttaMyWay.ValueRecord.canonical(record))
    return record
end

function Validator:update(dt)
    if g_currentMission==nil then return end
    if g_client~=nil and g_server==nil then return end
    if self.fieldWorldSnapshots~=nil then self.fieldWorldSnapshots:update(dt or 0,g_currentMission) end
    self.elapsed=self.elapsed+(dt or 0)
    local interval=OuttaMyWay.PASSIVE_SAMPLE_INTERVAL_MS or 1000
    if self.elapsed<interval then return end
    self.elapsed=self.elapsed%interval
    local now=(tonumber(g_time) or 0)/1000
    if self.probe~=nil then self.probe:update(g_currentMission,now,tonumber(g_time) or 0) end
    -- LiveObservationSource establishes the Job Episode activation boundary and requests the immutable Field World capture.
    local observations=self.source:capture(g_currentMission,now)
    for _,raw in OuttaMyWay.ValueRecord.ipairs(observations) do
        local ok,result=pcall(self._record,self,raw)
        if ok then
            local signature=table.concat({tostring(result.fieldWorldReferenceKey),tostring(result.observedAssemblyCount),tostring(result.activeAssemblyCount),tostring(result.activeJobEpisodeCount),tostring(result.activeOperationCount),tostring(result.globalActiveOperationCount),tostring(result.situationCount),tostring(result.encounterCount),tostring(result.candidateCount),tostring(result.allPassCandidateCount),tostring(result.unresolvedCandidateCount),tostring(result.failedCandidateCount),tostring(result.selectedCapability),tostring(result.nonIntervention and result.nonIntervention.classification),tostring(result.unavailableSourceCount)} ,"|")
            local due=(tonumber(g_time) or 0)-self.lastLogAt >= (OuttaMyWay.PASSIVE_HEARTBEAT_INTERVAL_MS or 10000)
            if signature~=self.lastSignature or due then
                self.lastSignature=signature; self.lastLogAt=tonumber(g_time) or 0
                local locators={}
                for _,id in OuttaMyWay.ValueRecord.ipairs(result.playerFacingFieldLocators or {}) do locators[#locators+1]=tostring(id) end
                logInfo(string.format("trace=%s field=%s fingerprint=%s locators=%s observed=%d active=%d episodes=%d admitted=%d ended=%d operations=%d globalOperations=%d situations=%d encounters=%d candidates=%d pass=%d unresolved=%d failed=%d gaps=%d selected=%s decision=%s control=false",result.identity,tostring(result.fieldWorldReferenceKey),tostring(result.fieldWorldFingerprint or "waiting"),#locators>0 and table.concat(locators,",") or "unresolved",result.observedAssemblyCount or 0,result.activeAssemblyCount,result.activeJobEpisodeCount,result.admittedEpisodeCount or 0,result.endedEpisodeCount or 0,result.activeOperationCount,result.globalActiveOperationCount or 0,result.situationCount,result.encounterCount,result.candidateCount or 0,result.allPassCandidateCount or 0,result.unresolvedCandidateCount or 0,result.failedCandidateCount or 0,result.unavailableSourceCount or 0,tostring(result.selectedCapability),tostring(result.nonIntervention and result.nonIntervention.classification)))
            end
        else
            self.errorCount=self.errorCount+1; logError(tostring(result))
        end
    end
end
function Validator:getRecords() local result={}; for i,v in OuttaMyWay.ValueRecord.ipairs(self.records) do result[i]=v end; return result end
function Validator:getErrorCount() return self.errorCount end
