-- Prototype22 manual capability-validation harness.
-- Production Hold and Drive mechanisms are injected by the composition root.
-- This Prototype may exercise them manually but owns no production Decision,
-- Commitment, Responsibility or Control lifecycle.

OuttaMyWay.Prototype22CapabilityGate = {}
local Probe = OuttaMyWay.Prototype22CapabilityGate
Probe.__index = Probe

local function logInfo(formatText, ...)
    local message = string.format(formatText, ...)
    if Logging ~= nil and type(Logging.info) == "function" then
        Logging.info("[FS25_OuttaMyWay][P22] %s", message)
    else
        print("[FS25_OuttaMyWay][P22] " .. message)
    end
end

local function logWarning(formatText, ...)
    local message = string.format(formatText, ...)
    if Logging ~= nil and type(Logging.warning) == "function" then
        Logging.warning("[FS25_OuttaMyWay][P22] %s", message)
    else
        print("[FS25_OuttaMyWay][P22][WARN] " .. message)
    end
end

local function safeCall(object, methodName, ...)
    if object == nil or type(object[methodName]) ~= "function" then return false, nil end
    return pcall(object[methodName], object, ...)
end

local function nameOf(vehicle)
    local ok, value = safeCall(vehicle, "getName")
    if ok and value ~= nil and value ~= "" then return tostring(value) end
    return tostring(vehicle and (vehicle.name or vehicle.typeName or vehicle.rootNode) or "AI vehicle")
end

local function referenceKey(vehicle)
    return "vehicle-root:" .. tostring(vehicle and (vehicle.rootNode or vehicle) or "nil")
end

local function actualSpeedKmh(vehicle)
    return math.abs(tonumber(vehicle and vehicle.lastSpeedReal) or 0) * 3600
end

local function pose(vehicle)
    if vehicle == nil then return nil end
    local node = nil
    local ok, value = safeCall(vehicle, "getAISteeringNode")
    if ok and value ~= nil and value ~= 0 then node = value end
    node = node or vehicle.rootNode
    if node == nil or node == 0 or type(getWorldTranslation) ~= "function" or type(localDirectionToWorld) ~= "function" then return nil end
    local okPos, x, y, z = pcall(getWorldTranslation, node)
    local okDir, dx, _, dz = pcall(localDirectionToWorld, node, 0, 0, 1)
    if not okPos or not okDir then return nil end
    local len = math.sqrt(dx * dx + dz * dz)
    if len <= 0.0001 then return nil end
    return {node = node, x = x, y = y, z = z, dx = dx / len, dz = dz / len}
end

local function distanceFrom(run, currentPose)
    if run == nil or currentPose == nil or run.startX == nil or run.startZ == nil then return nil end
    local dx, dz = currentPose.x - run.startX, currentPose.z - run.startZ
    return math.sqrt(dx * dx + dz * dz)
end

local function currentJobToken(vehicle)
    local job = OuttaMyWay.LiveAIJobEvidence.currentJob(vehicle)
    return OuttaMyWay.LiveAIJobEvidence.jobToken(job)
end

local function activeVehicles()
    return OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(g_currentMission)
end

local function lower(value)
    return string.lower(tostring(value or ""))
end

function Probe.new(runtime, mechanisms)
    mechanisms = mechanisms or {
        holdMechanism = OuttaMyWay.FieldWorkHoldMechanism.new(),
        driveMechanism = OuttaMyWay.NativeDriveMechanism.new()
    }
    if mechanisms.holdMechanism == nil or mechanisms.driveMechanism == nil then
        error("Prototype22CapabilityGate requires Hold and Drive mechanisms", 2)
    end
    return setmetatable({
        runtime = runtime,
        holdMechanism = mechanisms.holdMechanism,
        driveMechanism = mechanisms.driveMechanism,
        run = nil,
        releasedMonitor = nil,
        commandsRegistered = false,
        elapsedMs = 0,
        nextHeartbeatMs = 0,
        hudTitle = "OTM P22 — IDLE",
        hudInstruction = "Use otmP22 help",
        hudDetail = "Manual capability gate"
    }, Probe)
end

function Probe:_registerCommands()
    if self.commandsRegistered or type(addConsoleCommand) ~= "function" then return end
    addConsoleCommand("otmP22", "Bounded physical capability donor diagnostics: otmP22 help", "consoleCommand", self)
    self.commandsRegistered = true
end

function Probe:_unregisterCommands()
    if not self.commandsRegistered then return end
    if type(removeConsoleCommand) == "function" then pcall(removeConsoleCommand, "otmP22") end
    self.commandsRegistered = false
end

function Probe:loadMap()
    self:_registerCommands()
    local ok, reason = self.driveMechanism:install()
    logInfo("CAPABILITY_GATE loaded enabled=%s productionControlAuthority=%s driveHook=%s reason=%s retiredReposition=false retiredTs015Relocation=false",
        tostring(OuttaMyWay.PROTOTYPE_22_CAPABILITY_GATE_ENABLED == true),
        tostring(self.runtime ~= nil and self.runtime.generalControlAuthorityEnabled == true),
        tostring(ok), tostring(reason or "ready"))
    self:_setHud("OTM P22 — READY", "Manual capability gate", "Traffic Policeman production authority remains OFF")
end

function Probe:deleteMap()
    self:_clearAuthority(false)
    self.holdMechanism:clear()
    self:_unregisterCommands()
    self.run = nil
    self.releasedMonitor = nil
    if self.runtime ~= nil and type(self.runtime.clearHeadOnTestPlan) == "function" then self.runtime:clearHeadOnTestPlan() end
end

function Probe:keyEvent() end
function Probe:mouseEvent() end

function Probe:_setHud(title, instruction, detail)
    self.hudTitle = tostring(title or "OTM P22")
    self.hudInstruction = tostring(instruction or "")
    self.hudDetail = tostring(detail or "")
end

local function renderHudLine(x, y, size, text)
    if renderText == nil or text == nil or text == "" then return end
    if setTextAlignment ~= nil then setTextAlignment((RenderText and RenderText.ALIGN_RIGHT) or 2) end
    if setTextColor ~= nil then setTextColor(0, 0, 0, 0.9) end
    renderText(x + 0.0012, y - 0.0012, size, text)
    if setTextColor ~= nil then setTextColor(1, 1, 1, 1) end
    renderText(x, y, size, text)
end

function Probe:draw()
    if OuttaMyWay.PROTOTYPE_22_HUD_ENABLED ~= true or g_currentMission == nil or renderText == nil then return end
    local x = OuttaMyWay.PROTOTYPE_22_HUD_X or 0.985
    local y = OuttaMyWay.PROTOTYPE_22_HUD_Y or 0.590
    local line = OuttaMyWay.PROTOTYPE_22_HUD_LINE_HEIGHT or 0.021
    renderHudLine(x, y, OuttaMyWay.PROTOTYPE_22_HUD_TITLE_SIZE or 0.016, self.hudTitle)
    renderHudLine(x, y - line, OuttaMyWay.PROTOTYPE_22_HUD_TEXT_SIZE or 0.014, self.hudInstruction)
    renderHudLine(x, y - line * 2, OuttaMyWay.PROTOTYPE_22_HUD_TEXT_SIZE or 0.013, self.hudDetail)
    if setTextColor ~= nil then setTextColor(1, 1, 1, 1) end
end

function Probe:_vehicleListText()
    local vehicles = activeVehicles()
    if #vehicles == 0 then return "P22: no active GIANTS AI field workers" end
    local parts = {}
    for index, vehicle in ipairs(vehicles) do
        parts[#parts + 1] = string.format("%d=%s{%s job=%s speed=%.2f}", index, nameOf(vehicle), referenceKey(vehicle), tostring(currentJobToken(vehicle)), actualSpeedKmh(vehicle))
    end
    return "P22 active workers: " .. table.concat(parts, " | ")
end

function Probe:_resolveVehicle(selector)
    local vehicles = activeVehicles()
    if #vehicles < 2 then return nil, "P22 requires at least two active GIANTS AI field workers" end
    local index = tonumber(selector)
    if index ~= nil and vehicles[index] ~= nil then return vehicles[index] end
    local needle = lower(selector)
    if needle == "" then return nil, "vehicle selector required; use 'otmP22 list'" end
    local match = nil
    for _, vehicle in ipairs(vehicles) do
        local haystacks = {lower(nameOf(vehicle)), lower(referenceKey(vehicle))}
        local matched = false
        for _, haystack in ipairs(haystacks) do
            if string.find(haystack, needle, 1, true) ~= nil then matched = true; break end
        end
        if matched then
            if match ~= nil and match ~= vehicle then return nil, "vehicle selector is ambiguous" end
            match = vehicle
        end
    end
    if match == nil then return nil, "active vehicle not found; use 'otmP22 list'" end
    return match
end

function Probe:_newRun(kind, vehicle)
    local p = pose(vehicle)
    local token = currentJobToken(vehicle)
    if p == nil then return nil, "vehicle pose unavailable" end
    if token == nil then return nil, "current GIANTS Job Episode identity unavailable" end
    return {
        kind = kind,
        vehicle = vehicle,
        vehicleName = nameOf(vehicle),
        referenceKey = referenceKey(vehicle),
        startJobToken = token,
        startX = p.x,
        startZ = p.z,
        startedAt = g_time or 0,
        maxActualSpeedKmh = actualSpeedKmh(vehicle),
        nextLogAt = 0,
        jobStable = true,
        phase = kind
    }
end

function Probe:_clearAuthority(wake)
    local run = self.run
    if run ~= nil and run.vehicle ~= nil then
        self.driveMechanism:clear(run.vehicle)
        self.holdMechanism:release(run.vehicle)
        if wake == true then self:_wakeNativeContinuation(run.vehicle) end
    end
end

function Probe:_wakeNativeContinuation(vehicle)
    if vehicle == nil then return "vehicle-unavailable" end
    local strategy = nil
    local aiSpec = vehicle.spec_aiVehicle
    local fieldSpec = vehicle.spec_aiFieldWorker
    if aiSpec ~= nil then strategy = aiSpec.driveStrategy or aiSpec.currentDriveStrategy end
    if strategy == nil and fieldSpec ~= nil then strategy = fieldSpec.driveStrategy end
    local method = "none"
    if strategy ~= nil then
        local attempts = {
            {"setIsPaused", false}, {"setPaused", false}, {"resume", nil}, {"continue", nil}, {"onAIFieldWorkerContinue", nil}
        }
        for _, attempt in ipairs(attempts) do
            local fn = strategy[attempt[1]]
            if type(fn) == "function" then
                local ok
                if attempt[2] ~= nil then ok = pcall(fn, strategy, attempt[2]) else ok = pcall(fn, strategy) end
                if ok then method = attempt[1]; break end
            end
        end
    end
    if SpecializationUtil ~= nil and type(SpecializationUtil.raiseEvent) == "function" then
        pcall(SpecializationUtil.raiseEvent, vehicle, "onAIFieldWorkerContinue")
        pcall(SpecializationUtil.raiseEvent, vehicle, "onAIImplementContinue")
    end
    if type(vehicle.aiContinue) == "function" then
        local ok = pcall(vehicle.aiContinue, vehicle)
        if ok then method = method .. "+aiContinue" end
    end
    return method
end

function Probe:_startRegulate(selector, speedText)
    if self.run ~= nil or self.releasedMonitor ~= nil then return "P22 already active; release/cancel and allow handoff monitoring to complete" end
    local vehicle, reason = self:_resolveVehicle(selector)
    if vehicle == nil then return reason end
    local speed = tonumber(speedText) or OuttaMyWay.PROTOTYPE_22_REGULATE_DEFAULT_KMH
    local minSpeed = OuttaMyWay.PROTOTYPE_22_REGULATE_MIN_KMH or 0.5
    local maxSpeed = OuttaMyWay.PROTOTYPE_22_REGULATE_MAX_KMH or 10.0
    if speed < minSpeed or speed > maxSpeed then return string.format("P22 Regulation speed must be %.1f..%.1f km/h", minSpeed, maxSpeed) end
    local run, runReason = self:_newRun("REGULATE", vehicle)
    if run == nil then return runReason end
    local ok, authorityReason = self.driveMechanism:setRegulation(vehicle, speed)
    if not ok then return "P22 Regulation unavailable: " .. tostring(authorityReason) end
    run.speedKmh = speed
    self.run = run
    logInfo("REGULATE_START vehicle=%s ref=%s job=%s cap=%.2fkmh activeWorkers=%d routeOwner=GIANTS steeringOwner=GIANTS directionOwner=GIANTS",
        run.vehicleName, run.referenceKey, run.startJobToken, speed, #activeVehicles())
    self:_setHud("OTM P22 — REGULATE", run.vehicleName .. " may creep under GIANTS", string.format("cap %.1f km/h — release when observed", speed))
    return string.format("P22 REGULATE %s at %.2f km/h; use 'otmP22 release'", run.vehicleName, speed)
end

function Probe:_startHold(selector)
    if self.run ~= nil or self.releasedMonitor ~= nil then return "P22 already active; release/cancel and allow handoff monitoring to complete" end
    local vehicle, reason = self:_resolveVehicle(selector)
    if vehicle == nil then return reason end
    local run, runReason = self:_newRun("HOLD", vehicle)
    if run == nil then return runReason end
    local ok, gateReason = self.holdMechanism:setHold(vehicle, "P22-HOLD")
    if not ok then return "P22 Hold unavailable: " .. tostring(gateReason) end
    run.phase = "HOLDING"
    self.run = run
    logInfo("HOLD_START vehicle=%s ref=%s job=%s activeWorkers=%d authority=getCanAIFieldWorkerContinueWork",
        run.vehicleName, run.referenceKey, run.startJobToken, #activeVehicles())
    self:_setHud("OTM P22 — HOLD", "Stopping " .. run.vehicleName, "Wait for HOLD PASS, then release")
    return string.format("P22 HOLD %s; use 'otmP22 release'", run.vehicleName)
end

function Probe:_startReleaseMonitor(run, reason)
    local p = pose(run.vehicle)
    local method = self:_wakeNativeContinuation(run.vehicle)
    self.releasedMonitor = {
        vehicle = run.vehicle,
        vehicleName = run.vehicleName,
        referenceKey = run.referenceKey,
        startJobToken = run.startJobToken,
        releasedAt = g_time or 0,
        releaseX = p and p.x or nil,
        releaseZ = p and p.z or nil,
        reason = reason,
        wakeMethod = method,
        kind = run.kind,
        spatialResult = run.spatialResult,
        nextLogAt = 0
    }
    logInfo("RELEASE vehicle=%s ref=%s startJob=%s currentJob=%s reason=%s wake=%s gateCalls=%d",
        run.vehicleName, run.referenceKey, run.startJobToken, tostring(currentJobToken(run.vehicle)), tostring(reason), tostring(method),
        self.holdMechanism:getCallCount(run.vehicle))
end

function Probe:_releaseImmediate(run, reason)
    self.driveMechanism:clear(run.vehicle)
    self.holdMechanism:release(run.vehicle)
    local p = pose(run.vehicle)
    local travelled = distanceFrom(run, p)
    logInfo("CAPABILITY_END kind=%s phase=%s vehicle=%s startJob=%s currentJob=%s sameJob=%s travel=%s maxActualSpeed=%.2fkmh spatialResult=%s reason=%s",
        run.kind, tostring(run.phase), run.vehicleName, tostring(run.startJobToken), tostring(currentJobToken(run.vehicle)),
        tostring(currentJobToken(run.vehicle) == run.startJobToken), travelled and string.format("%.2fm", travelled) or "n/a",
        tonumber(run.maxActualSpeedKmh) or 0, tostring(run.spatialResult or "n/a"), tostring(reason))
    self.run = nil
    self:_startReleaseMonitor(run, reason)
    self:_setHud("OTM P22 — HANDOFF", "GIANTS authority restored", "Watching same-Job native continuation")
    return string.format("P22 released %s; monitoring same-job GIANTS continuation", run.vehicleName)
end

function Probe:_release(reason)
    local run=self.run
    if run==nil then return "P22 has no active capability" end
    return self:_releaseImmediate(run,reason)
end

function Probe:_cancelToHold()
    local run=self.run
    if run==nil then return "P22 has no active capability" end
    self.driveMechanism:clear(run.vehicle)
    local ok,reason=self.holdMechanism:setHold(run.vehicle,"P22-MANUAL-CANCEL")
    if not ok then
        self.holdMechanism:release(run.vehicle); self.run=nil
        return "P22 cancel could not establish Hold: "..tostring(reason)
    end
    run.kind="HOLD"; run.phase="CANCEL_HOLD"; run.holdEffectLogged=false
    self:_setHud("OTM P22 — CANCEL HOLD",run.vehicleName.." remains stopped","Use release when safe")
    return string.format("P22 cancelled active capability for %s; HOLD retained. Use 'otmP22 release' when safe",run.vehicleName)
end

function Probe:_statusText()
    if self.run == nil and self.releasedMonitor == nil then
        local regulationStatus=self.runtime and self.runtime.guardedRecoveryCompatibility and self.runtime.guardedRecoveryCompatibility:getGuardedRecoveryStatus() or nil
        return string.format("P22 idle; boundedControlDonor=true d0123Regulation=%s",regulationStatus and tostring(regulationStatus.active) or "n/a")
    end
    if self.run ~= nil then
        local run = self.run
        local p = pose(run.vehicle)
        local travelled = distanceFrom(run, p)
        local drive = self.driveMechanism:getState(run.vehicle)
        return string.format("P22 %s/%s vehicle=%s job=%s sameJob=%s speed=%.2f travel=%s gateCalls=%d driveCalls=%d remaining=%s",
            run.kind, tostring(run.phase), run.vehicleName, tostring(run.startJobToken), tostring(currentJobToken(run.vehicle) == run.startJobToken),
            actualSpeedKmh(run.vehicle), travelled and string.format("%.2fm", travelled) or "n/a", self.holdMechanism:getCallCount(run.vehicle),
            drive and (drive.driveCalls or 0) or 0, drive and drive.lastRemainingM and string.format("%.2fm", drive.lastRemainingM) or "n/a")
    end
    local monitor = self.releasedMonitor
    return string.format("P22 RELEASE_MONITOR vehicle=%s startJob=%s currentJob=%s speed=%.2f wake=%s",
        monitor.vehicleName, tostring(monitor.startJobToken), tostring(currentJobToken(monitor.vehicle)), actualSpeedKmh(monitor.vehicle), tostring(monitor.wakeMethod))
end

function Probe:consoleCommand(action, selector, a, b, c)
    action = lower(action)
    if action == "" or action == "help" then
        return "P22: list | status | regulate <vehicle> [kmh] | hold <vehicle> | release | cancel"
    end
    if OuttaMyWay.PROTOTYPE_22_CAPABILITY_GATE_ENABLED ~= true then return "Prototype 22 capability gate disabled in config" end
    if action == "list" then return self:_vehicleListText() end
    if action == "status" then return self:_statusText() end
    if action == "regulate" then return self:_startRegulate(selector, a) end
    if action == "hold" then return self:_startHold(selector) end
    if action == "release" then return self:_release("manual-release") end
    if action == "cancel" then return self:_cancelToHold() end
    return "Unknown P22 action; use 'otmP22 help'"
end

function Probe:_updateReleaseMonitor(nowMs)
    local monitor = self.releasedMonitor
    if monitor == nil then return end
    local token = currentJobToken(monitor.vehicle)
    local p = pose(monitor.vehicle)
    local moved = nil
    if p ~= nil and monitor.releaseX ~= nil and monitor.releaseZ ~= nil then
        moved = math.sqrt((p.x - monitor.releaseX)^2 + (p.z - monitor.releaseZ)^2)
    end
    local speed = actualSpeedKmh(monitor.vehicle)
    if token ~= monitor.startJobToken then
        logWarning("RELEASE_MONITOR_FAIL vehicle=%s startJob=%s currentJob=%s reason=JOB_EPISODE_CHANGED", monitor.vehicleName, tostring(monitor.startJobToken), tostring(token))
        logWarning("SUMMARY kind=%s vehicle=%s result=FAIL sameJob=false spatialResult=%s reason=JOB_EPISODE_CHANGED", tostring(monitor.kind or "n/a"), monitor.vehicleName, tostring(monitor.spatialResult or "n/a"))
        self:_setHud("OTM P22 — FAIL", monitor.vehicleName, "Job Episode changed during handoff")
        self.releasedMonitor = nil
        return
    end
    if (moved ~= nil and moved >= (OuttaMyWay.PROTOTYPE_22_RELEASE_RESUME_TRAVEL_M or 0.5)) or speed >= (OuttaMyWay.PROTOTYPE_22_RELEASE_RESUME_SPEED_KMH or 0.5) then
        logInfo("RELEASE_MONITOR_PASS vehicle=%s job=%s sameJob=true speed=%.2f moved=%s result=INDEPENDENT_NATIVE_CONTINUATION",
            monitor.vehicleName, tostring(token), speed, moved and string.format("%.2fm", moved) or "n/a")
        logInfo("SUMMARY kind=%s vehicle=%s result=PASS sameJob=true spatialResult=%s nativeContinuation=true", tostring(monitor.kind or "n/a"), monitor.vehicleName, tostring(monitor.spatialResult or "n/a"))
        self:_setHud("OTM P22 — PASS", monitor.vehicleName .. " same-Job handoff", tostring(monitor.kind or "capability") .. " complete")
        self.releasedMonitor = nil
        return
    end
    if nowMs >= (monitor.nextLogAt or 0) then
        monitor.nextLogAt = nowMs + (OuttaMyWay.PROTOTYPE_22_HEARTBEAT_MS or 1000)
        logInfo("RELEASE_MONITOR vehicle=%s job=%s speed=%.2f moved=%s wake=%s",
            monitor.vehicleName, tostring(token), speed, moved and string.format("%.2fm", moved) or "n/a", tostring(monitor.wakeMethod))
    end
    local timeout = OuttaMyWay.PROTOTYPE_22_RELEASE_MONITOR_MS or 5000
    if nowMs - monitor.releasedAt >= timeout then
        logWarning("RELEASE_MONITOR_UNRESOLVED vehicle=%s job=%s sameJob=true speed=%.2f moved=%s observationWindowMs=%d authority=NONE",
            monitor.vehicleName, tostring(token), speed, moved and string.format("%.2fm", moved) or "n/a", timeout)
        logWarning("SUMMARY kind=%s vehicle=%s result=UNRESOLVED sameJob=true spatialResult=%s nativeContinuation=false", tostring(monitor.kind or "n/a"), monitor.vehicleName, tostring(monitor.spatialResult or "n/a"))
        self:_setHud("OTM P22 — UNRESOLVED", monitor.vehicleName, "Same-Job continuation not observed in window")
        self.releasedMonitor = nil
    end
end

function Probe:update(dt)
    if OuttaMyWay.PROTOTYPE_22_CAPABILITY_GATE_ENABLED ~= true then return end
    local nowMs = g_time or 0
    self:_updateReleaseMonitor(nowMs)
    local run = self.run
    if run == nil then return end

    local token = currentJobToken(run.vehicle)
    if token ~= run.startJobToken then
        logWarning("CAPABILITY_ABORT kind=%s phase=%s vehicle=%s startJob=%s currentJob=%s reason=JOB_EPISODE_CHANGED authority=RELEASED",
            run.kind, tostring(run.phase), run.vehicleName, tostring(run.startJobToken), tostring(token))
        self:_clearAuthority(false)
        self:_setHud("OTM P22 — ABORT", run.vehicleName, "Job Episode changed; probe authority removed")
        self.run = nil
        return
    end

    local speed = actualSpeedKmh(run.vehicle)
    run.maxActualSpeedKmh = math.max(run.maxActualSpeedKmh or 0, speed)
    local p = pose(run.vehicle)
    local travelled = distanceFrom(run, p)

    if run.kind == "HOLD" and run.holdEffectLogged ~= true then
        local gateCalls = self.holdMechanism:getCallCount(run.vehicle)
        if gateCalls > 0 and speed <= (OuttaMyWay.PROTOTYPE_22_HOLD_EFFECT_SPEED_KMH or 0.25) then
            run.holdEffectLogged = true
            logInfo("HOLD_EFFECT_PASS vehicle=%s job=%s sameJob=true speed=%.2f gateCalls=%d travel=%s",
                run.vehicleName, tostring(token), speed, gateCalls, travelled and string.format("%.2fm", travelled) or "n/a")
            self:_setHud("OTM P22 — HOLD PASS", run.vehicleName .. " stationary", "Use otmP22 release")
        end
    end

    if nowMs >= (run.nextLogAt or 0) then
        run.nextLogAt = nowMs + (OuttaMyWay.PROTOTYPE_22_HEARTBEAT_MS or 1000)
        local drive = self.driveMechanism:getState(run.vehicle)
        logInfo("SAMPLE kind=%s phase=%s vehicle=%s job=%s sameJob=true speed=%.2f travel=%s gateCalls=%d driveCalls=%d inputMax=%s outputMax=%s inputForward=%s remaining=%s",
            run.kind, tostring(run.phase), run.vehicleName, tostring(token), speed,
            travelled and string.format("%.2fm", travelled) or "n/a", self.holdMechanism:getCallCount(run.vehicle),
            drive and (drive.driveCalls or 0) or 0,
            drive and drive.lastInputMaxSpeed and string.format("%.2f", drive.lastInputMaxSpeed) or "n/a",
            drive and drive.lastOutputMaxSpeed and string.format("%.2f", drive.lastOutputMaxSpeed) or "n/a",
            drive and tostring(drive.lastInputForward) or "n/a",
            drive and drive.lastRemainingM and string.format("%.2fm", drive.lastRemainingM) or "n/a")
    end
end
