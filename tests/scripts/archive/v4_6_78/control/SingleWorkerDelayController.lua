-- FS25_OuttaMyWay v4.6.24
-- Prototype 14: one active Information-Gaining Delay commitment.
--
-- The controller consumes the established Conflict Confidence interpretation,
-- selects the later-admitted worker, and applies one native permission-gate
-- HOLD while the other worker continues. It deliberately does not release on
-- predictor CLEAR: TS011 proved that closing can cease because both workers
-- have collided. Safe-release candidates are observed and logged only.
OuttaMyWay.SingleWorkerDelayController = OuttaMyWay.SingleWorkerDelayController or {}
local Controller = OuttaMyWay.SingleWorkerDelayController

local function countTable(values)
    local count = 0
    if type(values) == "table" then
        for _ in pairs(values) do count = count + 1 end
    end
    return count
end

local function nameOf(state)
    return state ~= nil and (state.name or "AI vehicle") or "AI vehicle"
end

local function distance(a, b)
    if a == nil or b == nil or a.x == nil or a.z == nil or b.x == nil or b.z == nil then
        return nil
    end
    local dx, dz = b.x - a.x, b.z - a.z
    return math.sqrt(dx * dx + dz * dz)
end

local function movementFrom(state, x, z)
    if state == nil or state.x == nil or state.z == nil or x == nil or z == nil then return nil end
    local dx, dz = state.x - x, state.z - z
    return math.sqrt(dx * dx + dz * dz)
end

local function normalizeAngle(value)
    return (value + 180) % 360 - 180
end

local function headingDifference(a, b)
    return math.abs(normalizeAngle((a.heading or 0) - (b.heading or 0)))
end

local function isEligible(state)
    return state ~= nil
        and state.vehicle ~= nil
        and state.active == true
        and state.blocked ~= true
        and state.phase == "WORKING"
        and state.isTurn ~= true
end

local function sortedStates(observed)
    local states = {}
    if type(observed) == "table" then
        for _, state in pairs(observed) do
            if state ~= nil and state.active == true and state.vehicle ~= nil then
                states[#states + 1] = state
            end
        end
    end
    table.sort(states, function(a, b)
        local at = tonumber(a.timestamp) or math.huge
        local bt = tonumber(b.timestamp) or math.huge
        if at ~= bt then return at < bt end
        local an, bn = nameOf(a), nameOf(b)
        if an ~= bn then return an < bn end
        return tostring(a.vehicle) < tostring(b.vehicle)
    end)
    return states
end

function Controller:init()
    self.enabled = OuttaMyWay.SINGLE_WORKER_DELAY_ENABLED == true
    self.elapsedMs = 0
    self.admissions = setmetatable({}, {__mode = "k"})
    self.present = setmetatable({}, {__mode = "k"})
    self.nextAdmissionOrder = 1
    self.activeHold = nil
    self.completedPairs = {}
    self.lastHeartbeatMs = 0

    OuttaMyWay.Logger:info(
        "PROTOTYPE 14 ACTIVE: Single-Worker Information-Gaining Delay enabled=%s exclusive=%s trigger=ConflictConfidence.ESTABLISHED selection=later-admitted executor=native-permission-gate release=observation-only",
        tostring(self.enabled), tostring(OuttaMyWay.SINGLE_WORKER_DELAY_EXCLUSIVE == true))

    if self.enabled and OuttaMyWay.SINGLE_WORKER_DELAY_EXCLUSIVE ~= true then
        OuttaMyWay.Logger:error("VAL",
            "PROTOTYPE 14 SAFETY BOUNDARY FAILED: SINGLE_WORKER_DELAY_EXCLUSIVE must be true")
        self.enabled = false
    end
end

function Controller:trackAdmissions(states)
    local current = setmetatable({}, {__mode = "k"})
    for _, state in ipairs(states) do
        local vehicle = state.vehicle
        current[vehicle] = true
        if self.present[vehicle] ~= true then
            local admission = {
                order = self.nextAdmissionOrder,
                firstObservedAt = tonumber(state.timestamp) or 0,
                name = nameOf(state)
            }
            self.nextAdmissionOrder = self.nextAdmissionOrder + 1
            self.admissions[vehicle] = admission
            OuttaMyWay.Logger:val(
                "PROTOTYPE14 ADMISSION t=%.1fs order=%d vehicle=%s",
                admission.firstObservedAt, admission.order, admission.name)
        end
    end
    self.present = current
end

function Controller:chooseRoles(a, b)
    local aa = self.admissions[a.vehicle]
    local ba = self.admissions[b.vehicle]
    if aa == nil or ba == nil then return nil, nil, "admission-order-missing" end

    if aa.order > ba.order then return a, b, "later-admitted" end
    if ba.order > aa.order then return b, a, "later-admitted" end

    -- Defensive deterministic fallback; normal admission orders are unique.
    if tostring(a.vehicle) > tostring(b.vehicle) then
        return a, b, "stable-vehicle-order-fallback"
    end
    return b, a, "stable-vehicle-order-fallback"
end

function Controller:pairEvidence(a, b)
    local confidence = OuttaMyWay.ConflictConfidenceProbe
    local emergence = OuttaMyWay.ConflictEmergenceProbe
    if confidence == nil or confidence.pairStateFor == nil
        or emergence == nil or emergence.closestApproach == nil
        or emergence.pairKey == nil or emergence.relationship == nil then
        return nil
    end

    local pair = confidence.pairStateFor(a, b)
    if pair == nil or pair.state ~= "ESTABLISHED" then return nil end

    local result = emergence.closestApproach(a, b)
    local relation, headingDelta = emergence.relationship(a, b)
    if result == nil or relation ~= "HEAD_ON" then return nil end
    if headingDelta < (OuttaMyWay.SINGLE_WORKER_DELAY_HEAD_ON_MIN_DEG or 150.0) then return nil end
    if result.tcpa == nil or result.tcpa < (OuttaMyWay.SINGLE_WORKER_DELAY_MIN_TCPA_S or 5.0) then
        return nil
    end

    return {
        key = emergence.pairKey(a, b),
        confidence = pair,
        result = result,
        relation = relation,
        headingDelta = headingDelta
    }
end

function Controller:startHold(a, b, evidence, nowMs)
    if self.activeHold ~= nil or evidence == nil then return false end
    if self.completedPairs[evidence.key] == true then return false end
    if not isEligible(a) or not isEligible(b) then return false end

    local yielding, priority, reason = self:chooseRoles(a, b)
    if yielding == nil or priority == nil then return false end

    local gate = OuttaMyWay.TrafficPermissionGate
    if gate == nil or gate.setHold == nil then
        OuttaMyWay.Logger:error("CTL", "PROTOTYPE14 HOLD unavailable: TrafficPermissionGate missing")
        self.completedPairs[evidence.key] = true
        return false
    end

    local ok, failure = gate:setHold(yielding.vehicle, evidence.key, priority.vehicle, nowMs)
    if not ok then
        OuttaMyWay.Logger:error("CTL",
            "PROTOTYPE14 HOLD failed pair=%s vehicle=%s reason=%s",
            tostring(evidence.key), nameOf(yielding), tostring(failure))
        self.completedPairs[evidence.key] = true
        return false
    end

    self.activeHold = {
        key = evidence.key,
        yieldingVehicle = yielding.vehicle,
        priorityVehicle = priority.vehicle,
        yielding = yielding,
        priority = priority,
        startedAt = nowMs,
        timeoutAt = nowMs + (OuttaMyWay.SINGLE_WORKER_DELAY_OBSERVATION_TIMEOUT_MS or 90000),
        startDistance = distance(yielding, priority),
        yieldingStartX = yielding.x,
        yieldingStartZ = yielding.z,
        priorityStartX = priority.x,
        priorityStartZ = priority.z,
        triggerTcpa = evidence.result.tcpa,
        triggerDcpa = evidence.result.dcpa,
        triggerZoneX = evidence.result.zoneX,
        triggerZoneZ = evidence.result.zoneZ,
        triggerHeadingDelta = evidence.headingDelta,
        selectionReason = reason,
        priorityTurnSeen = priority.isTurn == true,
        priorityTurnCompleted = false,
        previousPriorityTurn = priority.isTurn == true,
        previousDistance = distance(yielding, priority),
        increasingSince = nil,
        releaseCandidateLogged = false,
        terminalLogged = false,
        effectObserved = false,
        ineffectiveLogged = false,
        nextLogAt = nowMs
    }

    self.completedPairs[evidence.key] = true
    OuttaMyWay.activeWaitCount = 1
    OuttaMyWay.priorityName = nameOf(priority)
    OuttaMyWay.transientText = string.format("TS012 HOLD: %s; observe %s", nameOf(yielding), nameOf(priority))
    OuttaMyWay.transientUntil = nowMs + 5000

    OuttaMyWay.Logger:ctl(
        "PROTOTYPE14 HOLD_START t=%.1fs pair=%s hold=%s priority=%s selection=%s admissionOrders=%d/%d confidenceState=%s distance=%s tCPA=%s dCPA=%s zone=%s headingDelta=%.1f executor=permission-gate automaticRelease=false",
        (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
        tostring(evidence.key), nameOf(yielding), nameOf(priority), tostring(reason),
        self.admissions[yielding.vehicle] ~= nil and self.admissions[yielding.vehicle].order or -1,
        self.admissions[priority.vehicle] ~= nil and self.admissions[priority.vehicle].order or -1,
        tostring(evidence.confidence.state),
        self.activeHold.startDistance ~= nil and string.format("%.2fm", self.activeHold.startDistance) or "unknown",
        evidence.result.tcpa ~= nil and string.format("%.2fs", evidence.result.tcpa) or "unknown",
        evidence.result.dcpa ~= nil and string.format("%.2fm", evidence.result.dcpa) or "unknown",
        evidence.result.zoneX ~= nil and string.format("(%.2f,%.2f)", evidence.result.zoneX, evidence.result.zoneZ) or "unknown",
        evidence.headingDelta or -1)
    return true
end

function Controller:releaseForInactive(reason, nowMs)
    local hold = self.activeHold
    if hold == nil then return end
    local gate = OuttaMyWay.TrafficPermissionGate
    local gateState = gate ~= nil and gate.releaseHold ~= nil and gate:releaseHold(hold.yieldingVehicle) or nil
    OuttaMyWay.Logger:val(
        "PROTOTYPE14 HOLD_END t=%.1fs pair=%s reason=%s held=%.1fs gateCalls=%d firstGateAt=%s",
        (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
        tostring(hold.key), tostring(reason), math.max(0, nowMs - hold.startedAt) / 1000,
        gate ~= nil and gate.getCallCount ~= nil and gate:getCallCount(hold.yieldingVehicle) or 0,
        gateState ~= nil and gateState.firstGateAt ~= nil and string.format("%.3fs", gateState.firstGateAt / 1000) or "nil")
    self.activeHold = nil
    OuttaMyWay.activeWaitCount = 0
    OuttaMyWay.priorityName = ""
end

function Controller:updateHold(statesByVehicle, nowMs)
    local hold = self.activeHold
    if hold == nil then return end

    local yielding = statesByVehicle[hold.yieldingVehicle]
    local priority = statesByVehicle[hold.priorityVehicle]
    if yielding == nil or priority == nil or yielding.active ~= true or priority.active ~= true then
        self:releaseForInactive("worker-inactive-or-detached", nowMs)
        return
    end

    hold.yielding = yielding
    hold.priority = priority
    OuttaMyWay.activeWaitCount = 1
    OuttaMyWay.priorityName = nameOf(priority)

    local gate = OuttaMyWay.TrafficPermissionGate
    if gate == nil or gate.isHolding == nil or not gate:isHolding(yielding.vehicle) then
        if hold.terminalLogged ~= true then
            hold.terminalLogged = true
            OuttaMyWay.Logger:error("CTL",
                "PROTOTYPE14 HOLD_LOST t=%.1fs pair=%s vehicle=%s",
                (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
                tostring(hold.key), nameOf(yielding))
        end
        self.activeHold = nil
        OuttaMyWay.activeWaitCount = 0
        OuttaMyWay.priorityName = ""
        return
    end

    local currentDistance = distance(yielding, priority)
    local yieldingTravel = movementFrom(yielding, hold.yieldingStartX, hold.yieldingStartZ)
    local priorityTravel = movementFrom(priority, hold.priorityStartX, hold.priorityStartZ)
    local gateCalls = gate:getCallCount(yielding.vehicle)
    local heldForMs = nowMs - hold.startedAt

    if hold.effectObserved ~= true
        and gateCalls > 0
        and (yielding.actualSpeed or 0) <= (OuttaMyWay.SINGLE_WORKER_DELAY_EFFECT_SPEED_KMH or 0.75) then
        hold.effectObserved = true
        OuttaMyWay.Logger:val(
            "PROTOTYPE14 HOLD_EFFECT_OBSERVED t=%.1fs pair=%s hold=%s heldFor=%.1fs speed=%.2fkm/h gateCalls=%d active=%s phase=%s",
            (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
            tostring(hold.key), nameOf(yielding), heldForMs / 1000,
            yielding.actualSpeed or 0, gateCalls, tostring(yielding.active == true), tostring(yielding.phase))
    elseif hold.effectObserved ~= true and hold.ineffectiveLogged ~= true
        and heldForMs >= (OuttaMyWay.SINGLE_WORKER_DELAY_EFFECT_DEADLINE_MS or 4000) then
        hold.ineffectiveLogged = true
        OuttaMyWay.Logger:warning("VAL",
            "PROTOTYPE14 HOLD_EFFECT_UNCONFIRMED t=%.1fs pair=%s hold=%s heldFor=%.1fs speed=%.2fkm/h gateCalls=%d reason=%s action=continue-observation",
            (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
            tostring(hold.key), nameOf(yielding), heldForMs / 1000,
            yielding.actualSpeed or 0, gateCalls, gateCalls == 0 and "permission-gate-not-called" or "vehicle-not-arrested")
    end

    if priority.isTurn == true and hold.previousPriorityTurn ~= true then
        hold.priorityTurnSeen = true
        OuttaMyWay.Logger:val(
            "PROTOTYPE14 PRIORITY_TURN_OBSERVED t=%.1fs pair=%s priority=%s heldFor=%.1fs separation=%s priorityTravel=%s",
            (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
            tostring(hold.key), nameOf(priority), (nowMs - hold.startedAt) / 1000,
            currentDistance ~= nil and string.format("%.2fm", currentDistance) or "unknown",
            priorityTravel ~= nil and string.format("%.2fm", priorityTravel) or "unknown")
    elseif priority.isTurn ~= true and hold.previousPriorityTurn == true and hold.priorityTurnSeen == true then
        hold.priorityTurnCompleted = true
        OuttaMyWay.Logger:val(
            "PROTOTYPE14 PRIORITY_TURN_COMPLETED t=%.1fs pair=%s priority=%s phase=%s separation=%s",
            (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
            tostring(hold.key), nameOf(priority), tostring(priority.phase),
            currentDistance ~= nil and string.format("%.2fm", currentDistance) or "unknown")
    end
    hold.previousPriorityTurn = priority.isTurn == true

    if currentDistance ~= nil and hold.previousDistance ~= nil
        and currentDistance >= hold.previousDistance + (OuttaMyWay.SINGLE_WORKER_DELAY_DIVERGENCE_EPSILON_M or 0.10) then
        hold.increasingSince = hold.increasingSince or nowMs
    else
        hold.increasingSince = nil
    end
    hold.previousDistance = currentDistance

    local increasingFor = hold.increasingSince ~= nil and (nowMs - hold.increasingSince) or 0
    local releaseCandidate = hold.priorityTurnCompleted == true
        and yielding.blocked ~= true
        and priority.blocked ~= true
        and (priority.actualSpeed or 0) >= (OuttaMyWay.SINGLE_WORKER_DELAY_MIN_PRIORITY_SPEED_KMH or 2.0)
        and currentDistance ~= nil
        and currentDistance >= (OuttaMyWay.SINGLE_WORKER_DELAY_RELEASE_CANDIDATE_DISTANCE_M or 55.0)
        and increasingFor >= (OuttaMyWay.SINGLE_WORKER_DELAY_DIVERGENCE_CONFIRM_MS or 2000)

    if releaseCandidate and hold.releaseCandidateLogged ~= true then
        hold.releaseCandidateLogged = true
        OuttaMyWay.Logger:val(
            "PROTOTYPE14 SAFE_RELEASE_CANDIDATE t=%.1fs pair=%s hold=%s priority=%s separation=%.2fm increasingFor=%.1fs prioritySpeed=%.2fkm/h priorityTravel=%s heldTravel=%s action=OBSERVE_ONLY holdRetained=true predictorClearInsufficient=true",
            (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
            tostring(hold.key), nameOf(yielding), nameOf(priority), currentDistance,
            increasingFor / 1000, priority.actualSpeed or 0,
            priorityTravel ~= nil and string.format("%.2fm", priorityTravel) or "unknown",
            yieldingTravel ~= nil and string.format("%.2fm", yieldingTravel) or "unknown")
        OuttaMyWay.transientText = "TS012 release candidate observed; HOLD retained"
        OuttaMyWay.transientUntil = nowMs + 5000
    end

    if (yielding.blocked == true or priority.blocked == true) and hold.terminalLogged ~= true then
        hold.terminalLogged = true
        OuttaMyWay.Logger:warning("VAL",
            "PROTOTYPE14 OUTCOME_FAILURE t=%.1fs pair=%s reason=blocked-during-delay hold=%s holdBlocked=%s priority=%s priorityBlocked=%s separation=%s heldFor=%.1fs action=HOLD_RETAINED_FOR_PLAYER",
            (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
            tostring(hold.key), nameOf(yielding), tostring(yielding.blocked == true),
            nameOf(priority), tostring(priority.blocked == true),
            currentDistance ~= nil and string.format("%.2fm", currentDistance) or "unknown",
            (nowMs - hold.startedAt) / 1000)
        OuttaMyWay.transientText = "TS012 blocked outcome; HOLD retained"
        OuttaMyWay.transientUntil = nowMs + 5000
    elseif nowMs >= hold.timeoutAt and hold.terminalLogged ~= true then
        hold.terminalLogged = true
        OuttaMyWay.Logger:warning("VAL",
            "PROTOTYPE14 OUTCOME_UNRESOLVED t=%.1fs pair=%s reason=observation-timeout heldFor=%.1fs separation=%s priorityTurnSeen=%s priorityTurnCompleted=%s releaseCandidate=%s action=HOLD_RETAINED_FOR_PLAYER",
            (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
            tostring(hold.key), (nowMs - hold.startedAt) / 1000,
            currentDistance ~= nil and string.format("%.2fm", currentDistance) or "unknown",
            tostring(hold.priorityTurnSeen), tostring(hold.priorityTurnCompleted),
            tostring(hold.releaseCandidateLogged))
        OuttaMyWay.transientText = "TS012 timeout; HOLD retained"
        OuttaMyWay.transientUntil = nowMs + 5000
    end

    if nowMs >= (hold.nextLogAt or 0) then
        hold.nextLogAt = nowMs + (OuttaMyWay.SINGLE_WORKER_DELAY_LOG_INTERVAL_MS or 1000)
        local confidence = OuttaMyWay.ConflictConfidenceProbe ~= nil
            and OuttaMyWay.ConflictConfidenceProbe.pairStateFor ~= nil
            and OuttaMyWay.ConflictConfidenceProbe.pairStateFor(yielding, priority) or nil
        local predictor = nil
        if OuttaMyWay.ConflictPredictor ~= nil and type(OuttaMyWay.ConflictPredictor.pairs) == "table" then
            for _, candidate in pairs(OuttaMyWay.ConflictPredictor.pairs) do
                if (candidate.a ~= nil and candidate.b ~= nil)
                    and ((candidate.a.vehicle == yielding.vehicle and candidate.b.vehicle == priority.vehicle)
                        or (candidate.a.vehicle == priority.vehicle and candidate.b.vehicle == yielding.vehicle)) then
                    predictor = candidate
                    break
                end
            end
        end
        OuttaMyWay.Logger:val(
            "PROTOTYPE14 HOLD_SAMPLE t=%.1fs pair=%s heldFor=%.1fs hold=%s phase=%s speed=%.2f blocked=%s travel=%s gateCalls=%d priority=%s phase=%s turn=%s speed=%.2f blocked=%s travel=%s separation=%s confidence=%s predictor=%s predictorClosing=%s turnSeen=%s turnCompleted=%s releaseCandidate=%s",
            (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
            tostring(hold.key), (nowMs - hold.startedAt) / 1000,
            nameOf(yielding), tostring(yielding.phase), yielding.actualSpeed or 0,
            tostring(yielding.blocked == true), yieldingTravel ~= nil and string.format("%.2fm", yieldingTravel) or "unknown",
            gateCalls,
            nameOf(priority), tostring(priority.phase), tostring(priority.isTurn == true), priority.actualSpeed or 0,
            tostring(priority.blocked == true), priorityTravel ~= nil and string.format("%.2fm", priorityTravel) or "unknown",
            currentDistance ~= nil and string.format("%.2fm", currentDistance) or "unknown",
            confidence ~= nil and tostring(confidence.state) or "missing",
            predictor ~= nil and tostring(predictor.classification) or "missing",
            predictor ~= nil and predictor.closing ~= nil and string.format("%.3fm/s", predictor.closing) or "unknown",
            tostring(hold.priorityTurnSeen), tostring(hold.priorityTurnCompleted), tostring(hold.releaseCandidateLogged))
    end
end

function Controller:update(dt)
    if self.admissions == nil then self:init() end
    if self.enabled ~= true then return end

    self.elapsedMs = self.elapsedMs + dt
    local interval = OuttaMyWay.SINGLE_WORKER_DELAY_INTERVAL_MS or 250
    if self.elapsedMs < interval then return end
    self.elapsedMs = self.elapsedMs % interval

    local observed = OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.states or nil
    local states = sortedStates(observed)
    self:trackAdmissions(states)

    local statesByVehicle = setmetatable({}, {__mode = "k"})
    for _, state in ipairs(states) do statesByVehicle[state.vehicle] = state end
    OuttaMyWay.lastActiveCount = #states

    local nowMs = g_time or 0
    local settings = OuttaMyWay.settings
    local controlAllowed = settings == nil
        or (settings.enabled ~= false and settings.simulationMode ~= true)
    if not controlAllowed then
        if self.activeHold ~= nil then
            self:releaseForInactive(settings ~= nil and settings.simulationMode == true
                and "simulation-mode-enabled" or "mod-disabled", nowMs)
        end
        OuttaMyWay.activeWaitCount = 0
        OuttaMyWay.priorityName = ""
        return
    end

    if self.activeHold ~= nil then
        self:updateHold(statesByVehicle, nowMs)
    else
        OuttaMyWay.activeWaitCount = 0
        OuttaMyWay.priorityName = ""
        for i = 1, #states - 1 do
            for j = i + 1, #states do
                local a, b = states[i], states[j]
                local evidence = self:pairEvidence(a, b)
                if evidence ~= nil and self:startHold(a, b, evidence, nowMs) then
                    break
                end
            end
            if self.activeHold ~= nil then break end
        end
    end

    if nowMs - (self.lastHeartbeatMs or 0) >= (OuttaMyWay.SINGLE_WORKER_DELAY_HEARTBEAT_MS or 15000) then
        self.lastHeartbeatMs = nowMs
        OuttaMyWay.Logger:val(
            "PROTOTYPE14 HEARTBEAT activeWorkers=%d admissions=%d activeHold=%s completedPairs=%d exclusive=true",
            #states, countTable(self.admissions), tostring(self.activeHold ~= nil), countTable(self.completedPairs))
    end
end

function Controller:clear()
    if self.activeHold ~= nil and OuttaMyWay.TrafficPermissionGate ~= nil
        and OuttaMyWay.TrafficPermissionGate.releaseHold ~= nil then
        OuttaMyWay.TrafficPermissionGate:releaseHold(self.activeHold.yieldingVehicle)
    end
    self.elapsedMs = 0
    self.admissions = setmetatable({}, {__mode = "k"})
    self.present = setmetatable({}, {__mode = "k"})
    self.nextAdmissionOrder = 1
    self.activeHold = nil
    self.completedPairs = {}
    self.lastHeartbeatMs = 0
    OuttaMyWay.activeWaitCount = 0
    OuttaMyWay.priorityName = ""
end
