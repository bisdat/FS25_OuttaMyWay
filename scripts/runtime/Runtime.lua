OuttaMyWay.Runtime = {}
local Runtime = OuttaMyWay.Runtime
Runtime.__index = Runtime

function Runtime.new()
    local identities=OuttaMyWay.IdentityRegistry.new(); local epochs=OuttaMyWay.EpochSequence.new(0)
    local commitments=OuttaMyWay.CommitmentRegistry.new(identities,epochs)
    local obligations=OuttaMyWay.ObligationLedger.new(identities,epochs,commitments)
    local authorities=OuttaMyWay.AuthorityRegistry.new(identities,epochs,commitments)
    local jobEpisodes=OuttaMyWay.JobEpisodeAdmission.new(identities,epochs)
    local operations=OuttaMyWay.OperationAdmission.new(identities,epochs,jobEpisodes)
    return setmetatable({
        identities=identities,epochs=epochs,observationAdapter=OuttaMyWay.RuntimeObservationAdapter.new(identities,epochs),jobEpisodes=jobEpisodes,operations=operations,
        commitments=commitments,obligations=obligations,authorities=authorities,
        situationAssessment=OuttaMyWay.SituationAssessment.new(identities,epochs,jobEpisodes,operations,commitments),
        trace=OuttaMyWay.ArchitectureTrace.new(),initialized=false,runtimeMode=OuttaMyWay.RUNTIME_MODE,controlAuthorityEnabled=false
    },Runtime)
end
function Runtime:initialize()
    if self.initialized then return end; self.initialized=true
    self.trace:append("OPERATIONAL_PICTURE_FOUNDATION_INITIALIZED",self.epochs:next(),"architecture="..OuttaMyWay.ARCHITECTURE_VERSION)
    print(string.format("FS25_OuttaMyWay v%s Operational Picture foundation loaded; Control authority disabled",OuttaMyWay.VERSION))
end
function Runtime:publishObservation(raw) return self.observationAdapter:publish(raw) end
function Runtime:admitJobEpisodes(snapshot) return self.jobEpisodes:observe(snapshot) end
function Runtime:admitOperation(snapshot,episodeResult) return self.operations:observe(snapshot,episodeResult) end
function Runtime:assessOperationalPicture(snapshot,episodeResult,operationResult) return self.situationAssessment:assess(snapshot,episodeResult,operationResult) end
function Runtime:processSealedObservation(raw)
    local snapshot=self:publishObservation(raw)
    local episodes=self:admitJobEpisodes(snapshot)
    local operation=self:admitOperation(snapshot,episodes)
    local picture=self:assessOperationalPicture(snapshot,episodes,operation)
    return {snapshot=snapshot,jobEpisodes=episodes,operation=operation,picture=picture}
end
function Runtime:getStatus()
    return {initialized=self.initialized,runtimeMode=self.runtimeMode,controlAuthorityEnabled=self.controlAuthorityEnabled,
        observationCount=self.observationAdapter:getPublishedCount(),jobEpisodeCount=#self.jobEpisodes:list(),operationCount=#self.operations:list(),operationalPictureCount=self.situationAssessment:getPublishedCount(),commitmentCount=#self.commitments:list(),traceCount=self.trace:count()}
end
