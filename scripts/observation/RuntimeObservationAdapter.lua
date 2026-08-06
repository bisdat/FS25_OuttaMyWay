OuttaMyWay.RuntimeObservationAdapter = {}
local Adapter = OuttaMyWay.RuntimeObservationAdapter
Adapter.__index = Adapter

local function requirePlainTable(value, name)
    if type(value) ~= "table" or getmetatable(value) ~= nil then
        error(name .. " must be a plain table", 3)
    end
end

local function shallowCopy(value)
    local result = {}
    for key, item in pairs(value or {}) do result[key] = item end
    return result
end

local jobEvidenceFields = {
    "sourceJobToken",
    "jobPresent",
    "aiControlled",
    "aiActive",
    "blocked",
    "outtaMyWayHold",
    "temporarilyInactive",
    "playerStopObserved",
    "playerTakeoverObserved",
    "playerControlled",
    "giantsAbortObserved",
    "giantsFaultObserved",
    "restartObserved",
    "replacementObserved",
    "provenance"
}

function Adapter.new(identityRegistry, epochSequence)
    local self = setmetatable({}, Adapter)
    self.identities = identityRegistry
    self.epochs = epochSequence
    self.publishedCount = 0
    return self
end

function Adapter:publish(raw)
    requirePlainTable(raw, "raw observation")
    if raw.timestamp == nil then error("raw observation requires timestamp", 2) end
    if raw.provenance == nil then error("raw observation requires provenance", 2) end

    local assemblies = {}
    local referenceToAssembly = {}
    for _, item in ipairs(raw.assemblies or {}) do
        requirePlainTable(item, "assembly observation")
        if item.referenceKey == nil then error("assembly observation requires referenceKey", 2) end
        local referenceIndex = type(item.referenceKey) .. ":" .. tostring(item.referenceKey)
        if referenceToAssembly[referenceIndex] ~= nil then error("duplicate assembly referenceKey in one observation", 2) end
        local assemblyId = self.identities:resolve("ASSEMBLY", item.referenceKey)
        referenceToAssembly[referenceIndex] = assemblyId
        local componentIds = {}
        for _, componentKey in ipairs(item.componentReferenceKeys or {}) do
            componentIds[#componentIds + 1] = self.identities:resolve("COMPONENT", componentKey)
        end
        table.sort(componentIds)
        assemblies[#assemblies + 1] = {
            assemblyId = assemblyId,
            referenceKey = item.referenceKey,
            componentIds = componentIds,
            componentReferenceKeys = item.componentReferenceKeys or {},
            source = item.source
        }
    end
    table.sort(assemblies, function(a, b) return a.assemblyId < b.assemblyId end)

    local jobEpisodeEvidence = {}
    for _, item in ipairs(raw.jobEpisodeEvidence or {}) do
        requirePlainTable(item, "Job Episode evidence")
        if item.assemblyReferenceKey == nil then error("Job Episode evidence requires assemblyReferenceKey", 2) end
        local referenceIndex = type(item.assemblyReferenceKey) .. ":" .. tostring(item.assemblyReferenceKey)
        local assemblyId = referenceToAssembly[referenceIndex]
            or self.identities:resolve("ASSEMBLY", item.assemblyReferenceKey)
        for _, existing in ipairs(jobEpisodeEvidence) do
            if existing.assemblyId == assemblyId then error("duplicate Job Episode evidence for one assembly", 2) end
        end
        local evidence = { assemblyId = assemblyId }
        for _, field in ipairs(jobEvidenceFields) do
            if item[field] ~= nil then evidence[field] = item[field] end
        end
        jobEpisodeEvidence[#jobEpisodeEvidence + 1] = evidence
    end
    table.sort(jobEpisodeEvidence, function(a, b) return a.assemblyId < b.assemblyId end)

    local snapshot = OuttaMyWay.ObservationSnapshot.new({
        identity = self.identities:issue("OBSERVATION"),
        epoch = self.epochs:next(),
        timestamp = raw.timestamp,
        provenance = raw.provenance,
        fieldWorld = shallowCopy(raw.fieldWorld),
        assemblies = assemblies,
        geometry = shallowCopy(raw.geometry),
        motion = shallowCopy(raw.motion),
        aiStates = shallowCopy(raw.aiStates),
        playerControl = shallowCopy(raw.playerControl),
        jobEpisodeEvidence = jobEpisodeEvidence,
        operationMembershipEvidence = shallowCopy(raw.operationMembershipEvidence),
        physicalRepresentationEvidence = shallowCopy(raw.physicalRepresentationEvidence),
        controlOutcomes = shallowCopy(raw.controlOutcomes),
        unavailableSources = shallowCopy(raw.unavailableSources)
    })
    self.publishedCount = self.publishedCount + 1
    return snapshot
end

function Adapter:getPublishedCount()
    return self.publishedCount
end
