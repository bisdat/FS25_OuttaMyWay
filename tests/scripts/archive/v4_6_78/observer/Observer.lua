-- FS25_OuttaMyWay v4.2.6.3
-- Central read-only observer. Consumers must use this state instead of reading GIANTS AI directly.
OuttaMyWay.Observer = OuttaMyWay.Observer or {}
local Observer = OuttaMyWay.Observer

local function appendVehicleTable(output, seen, vehicles, source)
    if type(vehicles) ~= "table" then return 0 end
    local added = 0
    for key, vehicle in pairs(vehicles) do
        if vehicle ~= nil and vehicle.isDeleted ~= true and not seen[vehicle] then
            seen[vehicle] = true
            output[#output+1] = {vehicle=vehicle, source=source, key=key}
            added = added + 1
        end
    end
    return added
end

-- Enumerate every known mission vehicle source additively. A valid-but-empty
-- mission.vehicles table must not suppress vehicleSystem.vehicles.
function Observer:enumerateVehicles()
    local output = {}
    local seen = {}
    local mission = g_currentMission
    local counts = {missionVehicles=0, vehicleSystemVehicles=0, total=0}
    if mission == nil then return output, counts end

    counts.missionVehicles = appendVehicleTable(output, seen, mission.vehicles, "mission.vehicles")
    if mission.vehicleSystem ~= nil then
        counts.vehicleSystemVehicles = appendVehicleTable(output, seen, mission.vehicleSystem.vehicles, "mission.vehicleSystem.vehicles")
    end
    counts.total = #output
    return output, counts
end

function Observer:init()
    self.elapsedMs=0
    self.startedAt=g_time or 0
    self.states={}
    self.lastHeartbeat=0
    self.discoveryMisses={}
    OuttaMyWay.Logger:info("Observer active: Explorer-equivalent discovery, central read-only worker model")
end

function Observer:subscribe(eventName,callback,owner)
    if OuttaMyWay.EventBus == nil then return false end
    return OuttaMyWay.EventBus:subscribe(eventName,callback,owner)
end

function Observer:emit(eventName,current,previous)
    if OuttaMyWay.EventBus == nil then return end
    OuttaMyWay.EventBus:emit(eventName,{current=current,previous=previous,timestamp=current ~= nil and current.timestamp or (previous ~= nil and previous.timestamp or nil)})
end

function Observer:getState(vehicle) return self.states[vehicle] end
function Observer:getStates() return self.states end

function Observer:update(dt)
    if self.states==nil then self:init() end
    self.elapsedMs=self.elapsedMs+dt
    if self.elapsedMs < (OuttaMyWay.OBSERVER_INTERVAL_MS or 250) then return end
    self.elapsedMs=self.elapsedMs % (OuttaMyWay.OBSERVER_INTERVAL_MS or 250)

    local now=(g_time-(self.startedAt or g_time))/1000
    local seen={}
    local activeFlagCount=0
    local strategyCount=0
    local courseCount=0
    local observedCount=0
    local entries, enumeration = self:enumerateVehicles()

    for _, entry in ipairs(entries) do
        local vehicle = entry.vehicle
        local anyActive = OuttaMyWay.NativeAI.getActivityFlags(vehicle)
        if anyActive then activeFlagCount=activeFlagCount+1 end

        -- Read all vehicles before filtering, matching the proven Explorer order.
        local native, missReason = OuttaMyWay.NativeAI.read(vehicle)
        if native~=nil then
            strategyCount=strategyCount+1
            if native.course ~= nil then courseCount=courseCount+1 end

            local current=OuttaMyWay.WorkerState.fromNative(vehicle,native,now)
            if current.active then
                observedCount=observedCount+1
                seen[vehicle]=true
                local previous=self.states[vehicle]
                self.states[vehicle]=current
                if OuttaMyWay.EventBus ~= nil then OuttaMyWay.EventBus:emit("workerObserved",current) end
                local signature=OuttaMyWay.WorkerState.signature(current)
                if previous==nil then
                    OuttaMyWay.Logger:obs("Worker attached t=%.1fs vehicle=%s source=%s vehicleSource=%s", now, current.name, native.strategySource, entry.source)
                    self:emit("workerAttached",current,nil)
                elseif signature~=previous.signature then
                    OuttaMyWay.Logger:obs("Worker state changed t=%.1fs vehicle=%s phase=%s turn=%s progress=%s requested=%s actual=%.1f ratio=%s blocked=%s",
                        now,current.name,current.phase,tostring(current.isTurn),tostring(current.progress),tostring(current.requestedSpeed),current.actualSpeed,tostring(current.speedRatio),tostring(current.blocked))
                    self:emit("workerStateChanged",current,previous)
                    if current.phase ~= previous.phase then self:emit("workerPhaseChanged",current,previous) end
                    if current.isTurn ~= previous.isTurn then
                        self:emit(current.isTurn and "workerTurnStarted" or "workerTurnCompleted",current,previous)
                    end
                    if current.blocked ~= previous.blocked then self:emit("workerBlockedChanged",current,previous) end
                end
                current.signature=signature
            end
        elseif anyActive then
            self.discoveryMisses[vehicle] = missReason or "unknown"
        end
    end

    for vehicle,state in pairs(self.states) do
        if not seen[vehicle] then
            self.states[vehicle]=nil
            self:emit("workerDetached",nil,state)
        end
    end

    if g_time-(self.lastHeartbeat or 0) >= (OuttaMyWay.OBSERVER_HEARTBEAT_MS or 15000) then
        self.lastHeartbeat=g_time
        OuttaMyWay.Logger:val("Observer heartbeat t=%.1fs scanned=%d missionVehicles=%d vehicleSystemVehicles=%d activeFlags=%d strategies=%d fieldCourses=%d observedStates=%d",
            now, enumeration.total, enumeration.missionVehicles, enumeration.vehicleSystemVehicles,
            activeFlagCount, strategyCount, courseCount, observedCount)
    end
end
