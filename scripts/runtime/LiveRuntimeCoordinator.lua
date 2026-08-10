-- Runtime-owned live coordinator. Reality capture and sealed processing are
-- causally upstream of diagnostics. Diagnostics receive results only after the
-- Runtime has completed Situation -> Decision -> bounded Control dispatch.

OuttaMyWay.LiveRuntimeCoordinator={}
local Coordinator=OuttaMyWay.LiveRuntimeCoordinator
Coordinator.__index=Coordinator

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

local function appendCapabilityObservation(raw, observation)
    if type(observation)~="table" then return false end
    if not rawContainsReference(raw,observation.yieldReferenceKey) or not rawContainsReference(raw,observation.progressReferenceKey) then return false end
    raw.controlOutcomes=raw.controlOutcomes or {}
    raw.controlOutcomes[#raw.controlOutcomes+1]=observation
    return true
end

function Coordinator.new(runtime,source,targetedFieldIdentityProbe,fieldWorldSnapshots,diagnosticObserver)
    return setmetatable({runtime=runtime,source=source,targetedFieldIdentityProbe=targetedFieldIdentityProbe,fieldWorldSnapshots=fieldWorldSnapshots,diagnosticObserver=diagnosticObserver,elapsed=0,cycleCount=0,errorCount=0},Coordinator)
end
function Coordinator:loadMap()
    self.elapsed=0; self.cycleCount=0; self.errorCount=0
    if self.source and type(self.source.reset)=="function" then self.source:reset() end
    if self.targetedFieldIdentityProbe and type(self.targetedFieldIdentityProbe.reset)=="function" then self.targetedFieldIdentityProbe:reset() end
    if self.fieldWorldSnapshots and type(self.fieldWorldSnapshots.reset)=="function" then self.fieldWorldSnapshots:reset() end
    if self.runtime and type(self.runtime.resetAutonomousHeadOnState)=="function" then self.runtime:resetAutonomousHeadOnState() end
end
function Coordinator:deleteMap()
    if self.source and type(self.source.reset)=="function" then self.source:reset() end
    if self.targetedFieldIdentityProbe and type(self.targetedFieldIdentityProbe.reset)=="function" then self.targetedFieldIdentityProbe:reset() end
    if self.fieldWorldSnapshots and type(self.fieldWorldSnapshots.reset)=="function" then self.fieldWorldSnapshots:reset() end
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
    local interval=OuttaMyWay.LIVE_RUNTIME_CONTROL_INTERVAL_MS or 250
    if self.elapsed<interval then return end
    self.elapsed=self.elapsed%interval
    local now=(tonumber(g_time) or 0)/1000
    local nowMilliseconds=tonumber(g_time) or 0
    if self.targetedFieldIdentityProbe~=nil and type(self.targetedFieldIdentityProbe.update)=="function" then self.targetedFieldIdentityProbe:update(g_currentMission,now,nowMilliseconds) end
    local observations=self.source:capture(g_currentMission,now)
    local due=false
    if self.diagnosticObserver and type(self.diagnosticObserver.beginRuntimeCycle)=="function" then due=self.diagnosticObserver:beginRuntimeCycle(self.source:getLastDiagnostics(),nowMilliseconds)==true end
    local records={}
    local capabilityObservation=self.runtime and self.runtime.liveControlDispatcher and self.runtime.liveControlDispatcher:getCapabilityObservation() or nil
    for _,raw in OuttaMyWay.ValueRecord.ipairs(observations) do
        appendCapabilityObservation(raw,capabilityObservation)
        local ok,live=pcall(self.runtime.processLiveObservation,self.runtime,raw)
        if ok then
            if self.diagnosticObserver and type(self.diagnosticObserver.observeRuntimeResult)=="function" then
                local okRecord,record=pcall(self.diagnosticObserver.observeRuntimeResult,self.diagnosticObserver,raw,live,due,nowMilliseconds)
                if okRecord then records[#records+1]=record else self.errorCount=self.errorCount+1; self.diagnosticObserver:observeRuntimeError(record) end
            end
        else
            self.errorCount=self.errorCount+1
            if self.diagnosticObserver and type(self.diagnosticObserver.observeRuntimeError)=="function" then self.diagnosticObserver:observeRuntimeError(live) else logError(tostring(live)) end
        end
    end
    self.cycleCount=self.cycleCount+1
    if self.diagnosticObserver and type(self.diagnosticObserver.endRuntimeCycle)=="function" then self.diagnosticObserver:endRuntimeCycle(records,nowMilliseconds) end
end
function Coordinator:getCycleCount() return self.cycleCount end
function Coordinator:getErrorCount() return self.errorCount end
