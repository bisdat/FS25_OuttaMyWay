-- Diagnostic facade for SituationAssessment-owned Productive Continuation
-- Knowledge. This module does not read GIANTS strategy internals and provides
-- no semantic evidence API to Decision/Control.

OuttaMyWay.ProductiveContinuationProbe = {}
local Probe=OuttaMyWay.ProductiveContinuationProbe
Probe.__index=Probe

local function logInfo(message)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][PROBE21] %s",message) else print("[FS25_OuttaMyWay][PROBE21] "..message) end
end
local function objectName(referenceKey)
    for _,vehicle in OuttaMyWay.ValueRecord.ipairs(OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(g_currentMission)) do
        if "vehicle-root:"..tostring(vehicle and (vehicle.rootNode or vehicle) or "nil")==referenceKey then
            if type(vehicle.getName)=="function" then local ok,name=pcall(vehicle.getName,vehicle); if ok and name and name~="" then return tostring(name) end end
        end
    end
    return referenceKey
end

function Probe.new(situationAssessment)
    return setmetatable({assessment=situationAssessment,elapsed=0,signatures={},lastHeartbeatAt={}},Probe)
end
function Probe:reset() self.elapsed=0; self.signatures={}; self.lastHeartbeatAt={} end
function Probe:loadMap()
    self:reset()
    logInfo("Productive Continuation diagnostic active; reports Situation Assessment Knowledge only; no Decision or Control authority")
end
function Probe:deleteMap() self:reset() end
function Probe:keyEvent() end
function Probe:mouseEvent() end
function Probe:draw() end
function Probe:update(dt)
    if OuttaMyWay.PRODUCTIVE_CONTINUATION_PROBE_ENABLED~=true or self.assessment==nil then return end
    if g_client~=nil and g_server==nil then return end
    self.elapsed=self.elapsed+(dt or 0)
    local interval=OuttaMyWay.PRODUCTIVE_CONTINUATION_PROBE_INTERVAL_MS or 250
    if self.elapsed<interval then return end
    self.elapsed=self.elapsed%interval
    local now=tonumber(g_time) or 0
    local evidenceMap=self.assessment.latestProductiveContinuationByReference or {}
    local seen={}
    for ref,evidence in OuttaMyWay.ValueRecord.pairs(evidenceMap) do
        seen[ref]=true
        local signature=table.concat({tostring(evidence.jobToken),tostring(evidence.evidenceClass),tostring(evidence.productivePositive),tostring(evidence.isTurn),tostring(evidence.implementLineClassification),tostring(evidence.movingDirection)},"|")
        local heartbeat=OuttaMyWay.PRODUCTIVE_CONTINUATION_PROBE_HEARTBEAT_MS or 2000
        if self.signatures[ref]~=signature or self.lastHeartbeatAt[ref]==nil or now-self.lastHeartbeatAt[ref]>=heartbeat then
            self.signatures[ref]=signature; self.lastHeartbeatAt[ref]=now
            logInfo(string.format("worker=%s ref=%s job=%s knowledge=%s productivePositive=%s turn=%s line=%s direction=%s representationFitness=%s source=SituationAssessment diagnosticOnly=true",
                objectName(ref),tostring(ref),tostring(evidence.jobToken or "unresolved"),tostring(evidence.evidenceClass),tostring(evidence.productivePositive==true),
                tostring(evidence.isTurn),tostring(evidence.implementLineClassification),tostring(evidence.movingDirection),tostring(evidence.representationFitness or "UNRESOLVED")))
        end
    end
    for ref in pairs(self.signatures) do if not seen[ref] then self.signatures[ref]=nil; self.lastHeartbeatAt[ref]=nil end end
end
