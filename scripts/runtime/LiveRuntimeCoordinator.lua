--- Returns authorised Control outcomes through raw Observation and coordinates publication before downstream processing.
-- Specification Jurisdictions: `OBSERVATION`

-- Runtime-owned live coordinator. Reality capture and sealed processing are
-- causally upstream of diagnostics. Diagnostics receive results only after the
-- Runtime has completed Situation -> Decision -> bounded Control dispatch.

OuttaMyWay.LiveRuntimeCoordinator={}
local Coordinator=OuttaMyWay.LiveRuntimeCoordinator
Coordinator.__index=Coordinator

-- Runtime-owned cadence for one complete live Observation -> Situation -> Decision ->
-- bounded Control cycle. Diagnostics observe completed cycles; they do not own this clock.
local LIVE_RUNTIME_CONTROL_INTERVAL_MS=250

local function logError(message)
    if Logging~=nil and type(Logging.error)=="function" then Logging.error("[FS25_OuttaMyWay][LIVE-RUNTIME] %s",message) else print("[FS25_OuttaMyWay][LIVE-RUNTIME][ERROR] "..message) end
end
local function rawContainsReference(raw, referenceKey)
    if referenceKey==nil then return false end
    for _,assembly in OuttaMyWay.ValueRecord.ipairs(raw.assemblies or {}) do
        if assembly.referenceKey==referenceKey then return true end
    end
    return false
end
local function appendRegulationControlObservation(raw, observation)
    if type(observation)~="table" then return false end
    if not rawContainsReference(raw,observation.yieldReferenceKey) or not rawContainsReference(raw,observation.progressReferenceKey) then return false end
    raw.controlOutcomes=raw.controlOutcomes or {}
    raw.controlOutcomes[#raw.controlOutcomes+1]=observation
    return true
end
local function appendObstructionRelocationObservation(raw,observation)
    if type(observation)~="table" or observation.kind~="OBSTRUCTION_RELOCATION_CONTROL_OBSERVATION" then return false end
    if not rawContainsReference(raw,observation.assemblyReferenceKey) then return false end
    raw.controlOutcomes=raw.controlOutcomes or {}
    raw.controlOutcomes[#raw.controlOutcomes+1]=observation
    return true
end
function Coordinator.new(runtime,source,fieldWorldSnapshots,diagnosticObserver)
    return setmetatable({runtime=runtime,source=source,fieldWorldSnapshots=fieldWorldSnapshots,diagnosticObserver=diagnosticObserver,elapsed=0,cycleCount=0,errorCount=0},Coordinator)
end
function Coordinator:loadMap()
    self.elapsed=0; self.cycleCount=0; self.errorCount=0
    if self.source and type(self.source.reset)=="function" then self.source:reset() end
    if self.fieldWorldSnapshots and type(self.fieldWorldSnapshots.reset)=="function" then self.fieldWorldSnapshots:reset() end
    if self.runtime and type(self.runtime.resetLiveTrafficCandidateSupportStatus)=="function" then self.runtime:resetLiveTrafficCandidateSupportStatus() end
    if self.runtime and type(self.runtime.resetSituationKnowledge)=="function" then self.runtime:resetSituationKnowledge() end
end
function Coordinator:deleteMap()
    if self.source and type(self.source.reset)=="function" then self.source:reset() end
    if self.fieldWorldSnapshots and type(self.fieldWorldSnapshots.reset)=="function" then self.fieldWorldSnapshots:reset() end
    if self.runtime and self.runtime.bubbleBulletTime and type(self.runtime.bubbleBulletTime.releaseAll)=="function" then self.runtime.bubbleBulletTime:releaseAll("MAP_DELETE") end
    if self.runtime and type(self.runtime.resetSituationKnowledge)=="function" then self.runtime:resetSituationKnowledge() end
    self.elapsed=0
end
function Coordinator:keyEvent() end
function Coordinator:mouseEvent() end
function Coordinator:draw() end
function Coordinator:update(dt)
    if g_currentMission==nil then return end
    if g_client~=nil and g_server==nil then return end
    if self.fieldWorldSnapshots~=nil then self.fieldWorldSnapshots:update(dt or 0,g_currentMission) end
    self.elapsed=self.elapsed+(dt or 0)
    local interval=LIVE_RUNTIME_CONTROL_INTERVAL_MS
    if self.elapsed<interval then return end
    self.elapsed=self.elapsed%interval
    local now=(tonumber(g_time) or 0)/1000
    local nowMilliseconds=tonumber(g_time) or 0
    local observations=self.source:capture(g_currentMission,now)
    local due=false
    if self.diagnosticObserver and type(self.diagnosticObserver.beginRuntimeCycle)=="function" then due=self.diagnosticObserver:beginRuntimeCycle(self.source:getLastDiagnostics(),nowMilliseconds)==true end
    local regulationControlObservation=self.runtime and self.runtime.liveControlDispatcher and self.runtime.liveControlDispatcher:getRegulationControlObservation() or nil
    local obstructionRelocationObservation=self.runtime and self.runtime.liveControlDispatcher and self.runtime.liveControlDispatcher:getObstructionRelocationObservation() or nil
    for _,raw in OuttaMyWay.ValueRecord.ipairs(observations) do
        appendRegulationControlObservation(raw,regulationControlObservation)
        appendObstructionRelocationObservation(raw,obstructionRelocationObservation)
        local ok,live=pcall(self.runtime.processLiveObservation,self.runtime,raw)
        if ok then
            if self.runtime.bubbleBulletTime~=nil and type(self.runtime.bubbleBulletTime.releaseUnsupportedProtection)=="function" then
                local okBubble,bubbleResult=pcall(self.runtime.bubbleBulletTime.releaseUnsupportedProtection,self.runtime.bubbleBulletTime,live)
                if okBubble then
                    live.bubbleBulletTime=bubbleResult
                else
                    self.errorCount=self.errorCount+1
                    logError("Bubble Bullet Time release assessment failed: "..tostring(bubbleResult))
                end
            end
            if self.diagnosticObserver and type(self.diagnosticObserver.observeRuntimeResult)=="function" then
                local okDiagnostic,diagnosticError=pcall(self.diagnosticObserver.observeRuntimeResult,self.diagnosticObserver,live,due,nowMilliseconds)
                if not okDiagnostic then
                    self.errorCount=self.errorCount+1
                    logError("Diagnostic observer failed: "..tostring(diagnosticError))
                end
            end
        else
            self.errorCount=self.errorCount+1
            logError(tostring(live))
        end
    end
    self.cycleCount=self.cycleCount+1
end
function Coordinator:getCycleCount() return self.cycleCount end
function Coordinator:getErrorCount() return self.errorCount end
