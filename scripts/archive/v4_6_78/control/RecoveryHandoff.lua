-- FS25_OuttaMyWay v4.2.6.3
-- Diagnostic manual-handoff boundary experiment.
-- A handoff closes the current automated recovery episode. This module only
-- observes subsequent external changes and suppresses immediate recreation of
-- the same incident until the situation changes materially.
OuttaMyWay.RecoveryHandoff = OuttaMyWay.RecoveryHandoff or {}
local Handoff = OuttaMyWay.RecoveryHandoff

local function nameOf(state)
    return state ~= nil and (state.name or "AI vehicle") or "AI vehicle"
end

local function positionOf(state)
    if state == nil then return nil, nil end
    return tonumber(state.x), tonumber(state.z)
end

local function distanceFrom(state, x, z)
    local sx, sz = positionOf(state)
    if sx == nil or sz == nil or x == nil or z == nil then return nil end
    local dx, dz = sx - x, sz - z
    return math.sqrt(dx * dx + dz * dz)
end

local function stateFor(vehicle, fallback)
    if vehicle ~= nil and OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.states ~= nil then
        return OuttaMyWay.Observer.states[vehicle] or fallback
    end
    return fallback
end

local function signature(state)
    if state == nil then return "missing" end
    return table.concat({
        tostring(state.active == true),
        tostring(state.blocked == true),
        tostring(state.phase or "nil"),
        tostring(state.isTurn == true),
        string.format("%.1f", tonumber(state.actualSpeed) or 0)
    }, "|")
end

function Handoff:init()
    self.markers = {}
    self.lastHeartbeat = 0
    OuttaMyWay.Logger:info("Recovery handoff observer active: manual intervention closes the current episode")
end

function Handoff:isSuppressed(key)
    return self.markers ~= nil and self.markers[key] ~= nil
end

function Handoff:begin(hold, reason, nowMs)
    if hold == nil or hold.key == nil then return end
    if self.markers == nil then self:init() end

    local yielding = stateFor(hold.yielding ~= nil and hold.yielding.vehicle or nil, hold.yielding)
    local priority = stateFor(hold.priority ~= nil and hold.priority.vehicle or nil, hold.priority)
    local yx, yz = positionOf(yielding)
    local px, pz = positionOf(priority)

    self.markers[hold.key] = {
        key = hold.key,
        contextId = hold.contextId,
        createdAt = nowMs,
        reason = reason,
        yieldingVehicle = yielding ~= nil and yielding.vehicle or nil,
        priorityVehicle = priority ~= nil and priority.vehicle or nil,
        yieldingFallback = yielding,
        priorityFallback = priority,
        yieldingStartX = yx,
        yieldingStartZ = yz,
        priorityStartX = px,
        priorityStartZ = pz,
        yieldingSignature = signature(yielding),
        prioritySignature = signature(priority),
        lastLogAt = nowMs,
        changeDetectedAt = nil
    }

    OuttaMyWay.Logger:warning("REC", "Recovery handoff to player t=%.1fs incident=%s context=%s vehicle=%s other=%s reason=%s episode=closed observer=continues reentry=suppressed-until-material-change",
        (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
        tostring(hold.key), tostring(hold.contextId), nameOf(yielding), nameOf(priority), tostring(reason))
end

function Handoff:updateMarker(key, marker, nowMs)
    local yielding = stateFor(marker.yieldingVehicle, marker.yieldingFallback)
    local priority = stateFor(marker.priorityVehicle, marker.priorityFallback)
    local yMove = distanceFrom(yielding, marker.yieldingStartX, marker.yieldingStartZ)
    local pMove = distanceFrom(priority, marker.priorityStartX, marker.priorityStartZ)
    local ySig = signature(yielding)
    local pSig = signature(priority)
    local stateChanged = ySig ~= marker.yieldingSignature or pSig ~= marker.prioritySignature
    local moved = (yMove ~= nil and yMove >= (OuttaMyWay.RECOVERY_HANDOFF_MOVE_THRESHOLD_M or 8.0))
        or (pMove ~= nil and pMove >= (OuttaMyWay.RECOVERY_HANDOFF_MOVE_THRESHOLD_M or 8.0))
    local activeChanged = yielding ~= nil and marker.yieldingFallback ~= nil
        and yielding.active ~= marker.yieldingFallback.active

    if stateChanged and nowMs - (marker.lastLogAt or 0) >= 1000 then
        marker.lastLogAt = nowMs
        OuttaMyWay.Logger:rec("Recovery handoff observed t=%.1fs incident=%s vehicle=%s active=%s blocked=%s phase=%s speed=%.1f moved=%s otherActive=%s otherBlocked=%s otherPhase=%s otherMoved=%s",
            (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
            tostring(key), nameOf(yielding), tostring(yielding ~= nil and yielding.active == true),
            tostring(yielding ~= nil and yielding.blocked == true), tostring(yielding ~= nil and yielding.phase or "missing"),
            yielding ~= nil and (tonumber(yielding.actualSpeed) or 0) or 0,
            yMove ~= nil and string.format("%.1fm", yMove) or "unknown",
            tostring(priority ~= nil and priority.active == true), tostring(priority ~= nil and priority.blocked == true),
            tostring(priority ~= nil and priority.phase or "missing"),
            pMove ~= nil and string.format("%.1fm", pMove) or "unknown")
        marker.yieldingSignature = ySig
        marker.prioritySignature = pSig
    end

    if moved or activeChanged then
        marker.changeDetectedAt = marker.changeDetectedAt or nowMs
        if nowMs - marker.changeDetectedAt >= (OuttaMyWay.RECOVERY_HANDOFF_SETTLE_MS or 2000) then
            OuttaMyWay.Logger:rec("Recovery handoff rearm t=%.1fs incident=%s reason=material-change yieldingMoved=%s priorityMoved=%s yieldingActive=%s priorityActive=%s nextIncident=new-evaluation",
                (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
                tostring(key), yMove ~= nil and string.format("%.1fm", yMove) or "unknown",
                pMove ~= nil and string.format("%.1fm", pMove) or "unknown",
                tostring(yielding ~= nil and yielding.active == true), tostring(priority ~= nil and priority.active == true))
            self.markers[key] = nil
        end
    else
        marker.changeDetectedAt = nil
    end
end

function Handoff:update(dt)
    if self.markers == nil then self:init() end
    local nowMs = g_time or 0
    local keys = {}
    for key in pairs(self.markers) do keys[#keys + 1] = key end
    for _, key in ipairs(keys) do
        local marker = self.markers[key]
        if marker ~= nil then self:updateMarker(key, marker, nowMs) end
    end
end
