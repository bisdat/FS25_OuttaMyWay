OuttaMyWay.Runtime = {}
local Runtime = OuttaMyWay.Runtime
Runtime.__index = Runtime

function Runtime.new()
    local identities = OuttaMyWay.IdentityRegistry.new()
    local epochs = OuttaMyWay.EpochSequence.new(0)
    local commitments = OuttaMyWay.CommitmentRegistry.new(identities, epochs)
    local obligations = OuttaMyWay.ObligationLedger.new(identities, epochs, commitments)
    local authorities = OuttaMyWay.AuthorityRegistry.new(identities, epochs, commitments)
    local self = setmetatable({
        identities = identities,
        epochs = epochs,
        observationAdapter = OuttaMyWay.RuntimeObservationAdapter.new(identities, epochs),
        jobEpisodes = OuttaMyWay.JobEpisodeAdmission.new(identities, epochs),
        commitments = commitments,
        obligations = obligations,
        authorities = authorities,
        trace = OuttaMyWay.ArchitectureTrace.new(),
        initialized = false,
        runtimeMode = OuttaMyWay.RUNTIME_MODE,
        controlAuthorityEnabled = false
    }, Runtime)
    return self
end

function Runtime:initialize()
    if self.initialized then return end
    self.initialized = true
    self.trace:append("OBSERVATION_IDENTITY_FOUNDATION_INITIALIZED", self.epochs:next(), "architecture=" .. OuttaMyWay.ARCHITECTURE_VERSION)
    print(string.format("FS25_OuttaMyWay v%s observation/identity foundation loaded; Control authority disabled", OuttaMyWay.VERSION))
end

function Runtime:publishObservation(raw)
    return self.observationAdapter:publish(raw)
end

function Runtime:admitJobEpisodes(snapshot)
    return self.jobEpisodes:observe(snapshot)
end

function Runtime:getStatus()
    return {
        initialized = self.initialized,
        runtimeMode = self.runtimeMode,
        controlAuthorityEnabled = self.controlAuthorityEnabled,
        observationCount = self.observationAdapter:getPublishedCount(),
        jobEpisodeCount = #self.jobEpisodes:list(),
        commitmentCount = #self.commitments:list(),
        traceCount = self.trace:count()
    }
end
