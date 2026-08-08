-- FS25_OuttaMyWay Prototype 22 — Traffic Policeman Capability Gate.
--
-- Manual-only diagnostic actuator.  It validates three GIANTS integration
-- capabilities required by the already-canonical Traffic Policeman Decision
-- ordering without implementing Traffic Policeman activation, role assignment,
-- Candidate selection, Commitments, production refuge selection or Safe Release
-- policy. v4.7.39 exposes the explicit-command TS015 evidence harness with restoration-first handback that
-- orchestrates these demonstrated mechanisms with fixture-only literals.

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

local function hullSpan(summary)
    local hull = summary and summary.hull or nil
    if type(hull) ~= "table" or #hull < 2 then return nil end
    local maximum = 0
    for i = 1, #hull do
        for j = i + 1, #hull do
            local a, b = hull[i], hull[j]
            if a ~= nil and b ~= nil and a.x ~= nil and a.z ~= nil and b.x ~= nil and b.z ~= nil then
                local dx, dz = b.x - a.x, b.z - a.z
                maximum = math.max(maximum, math.sqrt(dx * dx + dz * dz))
            end
        end
    end
    return maximum > 0 and maximum or nil
end

local function foldEvidenceText(evidence)
    if evidence == nil then return "fold=n/a" end
    return string.format("fold=%d deployed=%d transition=%d folded=%d unknown=%d range=%s..%s",
        evidence.foldableCount or 0, evidence.deployedCount or 0, evidence.transitionCount or 0,
        evidence.foldedCount or 0, evidence.unknownCount or 0,
        evidence.minimum ~= nil and string.format("%.3f", evidence.minimum) or "n/a",
        evidence.maximum ~= nil and string.format("%.3f", evidence.maximum) or "n/a")
end

function Probe.new(runtime)
    return setmetatable({
        runtime = runtime,
        permissionGate = OuttaMyWay.Prototype22PermissionGate.new(),
        driveAuthority = OuttaMyWay.Prototype22DriveAuthority.new(),
        configurationAuthority = OuttaMyWay.Prototype22ConfigurationAuthority.new(),
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
    addConsoleCommand("otmP22", "Prototype 22 capability gate + TS015 autonomous fixture: otmP22 help", "consoleCommand", self)
    self.commandsRegistered = true
end

function Probe:_unregisterCommands()
    if not self.commandsRegistered then return end
    if type(removeConsoleCommand) == "function" then pcall(removeConsoleCommand, "otmP22") end
    self.commandsRegistered = false
end

function Probe:loadMap()
    self:_registerCommands()
    local ok, reason = self.driveAuthority:install()
    logInfo("CAPABILITY_GATE loaded enabled=%s automaticDecision=false productionControlAuthority=%s driveHook=%s reason=%s",
        tostring(OuttaMyWay.PROTOTYPE_22_CAPABILITY_GATE_ENABLED == true),
        tostring(self.runtime ~= nil and self.runtime.controlAuthorityEnabled == true),
        tostring(ok), tostring(reason or "ready"))
    self:_setHud("OTM P22 — READY", "Manual capability gate", "Traffic Policeman production authority remains OFF")
end

function Probe:deleteMap()
    self:_clearAuthority(false)
    self.permissionGate:clear()
    self.driveAuthority:clearAll()
    self.configurationAuthority:clearAll()
    self:_unregisterCommands()
    self.run = nil
    self.releasedMonitor = nil
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

function Probe:_representedSpan(vehicle)
    local source = self.runtime and self.runtime.liveObservationSource or nil
    local track = source and source.tracks and source.tracks[referenceKey(vehicle)] or nil
    local shadow = track and track.shadowRepresentation or nil
    local span = hullSpan(shadow and shadow.planViewSummary or nil)
    return span, shadow and shadow.configurationKey or nil, shadow and shadow.configurationProfileId or nil
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
        self.driveAuthority:clear(run.vehicle)
        self.permissionGate:release(run.vehicle)
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
    local ok, authorityReason = self.driveAuthority:setRegulation(vehicle, speed)
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
    local ok, gateReason = self.permissionGate:setHold(vehicle, "P22-HOLD")
    if not ok then return "P22 Hold unavailable: " .. tostring(gateReason) end
    run.phase = "HOLDING"
    self.run = run
    logInfo("HOLD_START vehicle=%s ref=%s job=%s activeWorkers=%d authority=getCanAIFieldWorkerContinueWork",
        run.vehicleName, run.referenceKey, run.startJobToken, #activeVehicles())
    self:_setHud("OTM P22 — HOLD", "Stopping " .. run.vehicleName, "Wait for HOLD PASS, then release")
    return string.format("P22 HOLD %s; use 'otmP22 release'", run.vehicleName)
end

function Probe:_startReposition(selector, forwardText, rightText, speedText)
    if self.run ~= nil or self.releasedMonitor ~= nil then return "P22 already active; release/cancel and allow handoff monitoring to complete" end
    local vehicle, reason = self:_resolveVehicle(selector)
    if vehicle == nil then return reason end
    local forwardM = tonumber(forwardText)
    local rightM = tonumber(rightText)
    if forwardM == nil or rightM == nil then
        return "Usage: otmP22 reposition <vehicle> <forwardM>=0..20 <rightM=-20..20> [kmh]"
    end
    if forwardM < 0 then
        logWarning("REVERSE_REPOSITION_UNRESOLVED vehicle=%s requestedForward=%.2fm action=REFUSED", nameOf(vehicle), forwardM)
        return "P22 reverse Reposition is architecturally valid but UNRESOLVED; negative forwardM refused"
    end
    local offset = math.sqrt(forwardM * forwardM + rightM * rightM)
    local maxOffset = OuttaMyWay.PROTOTYPE_22_REPOSITION_MAX_OFFSET_M or 20.0
    if offset <= 0.1 or offset > maxOffset then return string.format("P22 Reposition offset must be >0.1m and <=%.1fm", maxOffset) end
    local speed = tonumber(speedText) or OuttaMyWay.PROTOTYPE_22_REPOSITION_SPEED_KMH
    local maxSpeed = OuttaMyWay.PROTOTYPE_22_REPOSITION_MAX_SPEED_KMH or 8.0
    if speed <= 0 or speed > maxSpeed then return string.format("P22 Reposition speed must be >0 and <=%.1f km/h", maxSpeed) end

    local initialSpan, initialConfigKey, initialProfileId = self:_representedSpan(vehicle)
    if initialSpan == nil then
        return "P22 Reposition requires a current represented plan-view span; wait for passive observation then retry"
    end
    local configEvidence = self.configurationAuthority:getEvidence(vehicle)
    if configEvidence.foldableCount == 0 then return "P22-C spatial Reposition requires a foldable test assembly" end
    if not configEvidence.allDeployed then
        return "P22-C requires the selected assembly to begin fully deployed and stable"
    end

    local run, runReason = self:_newRun("REPOSITION", vehicle)
    if run == nil then return runReason end
    run.phase = "REPOSITION_SETTLING"
    run.requestedForwardM = forwardM
    run.requestedRightM = rightM
    run.speedKmh = speed
    run.targetRadiusM = OuttaMyWay.PROTOTYPE_22_REPOSITION_TARGET_RADIUS_M or 1.0
    run.initialSpanM = initialSpan
    run.initialConfigurationKey = initialConfigKey
    run.initialConfigurationProfileId = initialProfileId
    run.initialFoldEvidence = configEvidence
    run.spatialResult = "PENDING"
    local ok, gateReason = self.permissionGate:setHold(vehicle, "P22-REPOSITION-SETTLE")
    if not ok then return "P22 Reposition pre-Hold unavailable: " .. tostring(gateReason) end
    self.run = run
    logInfo("REPOSITION_ARMED vehicle=%s ref=%s job=%s forward=%.2fm right=%.2fm speed=%.2fkmh activeWorkers=%d reverseAuthority=UNRESOLVED action=HOLD_COMPACT_OVERLAP_ONE_FORWARD_LEG initialSpan=%.2fm initialProfile=%s %s",
        run.vehicleName, run.referenceKey, run.startJobToken, forwardM, rightM, speed, #activeVehicles(), run.initialSpanM,
        tostring(initialProfileId or "n/a"), foldEvidenceText(configEvidence))
    self:_setHud("OTM P22 — REPOSITION", "Stopping " .. run.vehicleName, "Next: compact + move (overlap permitted)")
    return string.format("P22 REPOSITION %s armed: settle, compact while moving, then forward %.1fm / right %.1fm at %.1f km/h", run.vehicleName, forwardM, rightM, speed)
end

function Probe:_beginCompaction(run)
    local ok, stateOrReason = self.configurationAuthority:prepareCompact(run.vehicle)
    if not ok then return false, stateOrReason end
    run.compactRequestedAt = g_time or 0
    run.phase = "REPOSITION_COMPACTING"
    logInfo("REPOSITION_COMPACT_START vehicle=%s job=%s initialSpan=%.2fm workMutations=%d raisedMutations=%d foldMutations=%d movementOverlap=WAIT_FOR_ACTUAL_FOLD_MOTION",
        run.vehicleName, run.startJobToken, run.initialSpanM or -1,
        stateOrReason.workMutations or 0, stateOrReason.raisedMutations or 0, stateOrReason.foldMutations or 0)
    self:_setHud("OTM P22 — COMPACTING", run.vehicleName .. " boom folding", "Movement starts after fold motion is observed")
    return true
end

function Probe:_beginRepositionMovement(run)
    local p = pose(run.vehicle)
    if p == nil then return false, "settled-pose-unavailable" end
    local forwardM, rightM = run.requestedForwardM, run.requestedRightM
    -- Right vector for heading (dx,dz) is (dz,-dx).
    run.targetX = p.x + p.dx * forwardM + p.dz * rightM
    run.targetZ = p.z + p.dz * forwardM - p.dx * rightM
    run.moveStartX, run.moveStartZ = p.x, p.z
    run.moveStartedAt = g_time or 0
    -- Retain the proven temporary Hold permission gate while the scoped drive
    -- interceptor owns this one Manoeuvre Leg. This mirrors the archived
    -- empirically successful sidestep integration: GIANTS job ownership stays
    -- intact while the final drive call is temporarily overridden.
    local ok, reason = self.driveAuthority:setReposition(run.vehicle, run.targetX, run.targetZ, run.speedKmh, run.targetRadiusM)
    if not ok then return false, reason end
    run.phase = "REPOSITION_MOVING"
    run.foldMotionAtMoveStart = self.configurationAuthority:getEvidence(run.vehicle)
    logInfo("REPOSITION_MOVE_START vehicle=%s job=%s from=(%.2f,%.2f) target=(%.2f,%.2f) forward=%.2fm right=%.2fm speed=%.2fkmh routeOwner=P22_ONE_LEG moveForwards=true foldMovementOverlap=true %s",
        run.vehicleName, run.startJobToken, p.x, p.z, run.targetX, run.targetZ, forwardM, rightM, run.speedKmh, foldEvidenceText(run.foldMotionAtMoveStart))
    self:_setHud("OTM P22 — REPOSITIONING", run.vehicleName .. " moving while compacting", "One bounded forward Manoeuvre Leg")
    return true
end

function Probe:_finishRepositionAtTarget(run)
    self.driveAuthority:clear(run.vehicle)
    -- Permission gate remains active.  The worker is stationary at the target
    -- while configuration motion is allowed to finish; spatial PASS requires
    -- both compact configuration and positive represented-span reduction.
    run.phase = "REPOSITION_TARGET_COMPACTING"
    run.targetReachedAt = g_time or 0
    local p = pose(run.vehicle)
    logInfo("REPOSITION_TARGET_REACHED vehicle=%s job=%s target=(%.2f,%.2f) actual=(%s,%s) gateCalls=%d action=HOLD_AND_COMPLETE_COMPACTION",
        run.vehicleName, run.startJobToken, run.targetX, run.targetZ,
        p and string.format("%.2f", p.x) or "n/a", p and string.format("%.2f", p.z) or "n/a",
        self.permissionGate:getCallCount(run.vehicle))
    self:_setHud("OTM P22 — TARGET HOLD", run.vehicleName .. " at target", "Waiting for compact + spatial reduction proof")
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
        progressVehicle = run.progressVehicle,
        progressVehicleName = run.progressVehicleName,
        progressReferenceKey = run.progressReferenceKey,
        progressStartJobToken = run.progressStartJobToken,
        nextLogAt = 0,
        nextTs015LogAt = 0,
        maximumTravelM = 0
    }
    logInfo("RELEASE vehicle=%s ref=%s startJob=%s currentJob=%s reason=%s wake=%s gateCalls=%d",
        run.vehicleName, run.referenceKey, run.startJobToken, tostring(currentJobToken(run.vehicle)), tostring(reason), tostring(method),
        self.permissionGate:getCallCount(run.vehicle))
end

function Probe:_releaseImmediate(run, reason)
    self.driveAuthority:clear(run.vehicle)
    self.permissionGate:release(run.vehicle)
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
    local run = self.run
    if run == nil then return "P22 has no active capability" end
    if run.kind == "TS015_RELOCATE" then return "P22 TS015 relocate is autonomous; use cancel only if you must abort the fixture" end
    if run.kind ~= "REPOSITION" then return self:_releaseImmediate(run, reason) end

    if run.phase == "REPOSITION_MOVING" or run.phase == "REPOSITION_COMPACTING" or run.phase == "REPOSITION_SETTLING" then
        return "P22 Reposition is still active; use 'otmP22 cancel' before release"
    end
    if run.phase == "REPOSITION_TARGET_COMPACTING" then
        return "P22 target reached but spatial compaction result is still pending; wait for PASS/UNRESOLVED or cancel"
    end
    if run.phase == "REPOSITION_RESTORING" or run.phase == "REPOSITION_CANCEL_RESTORING" then
        return "P22 configuration restoration already in progress"
    end

    local ok, restoreReason = self.configurationAuthority:requestRestore(run.vehicle)
    if not ok then
        logWarning("REPOSITION_RESTORE_START_FAIL vehicle=%s reason=%s action=HOLD_RETAINED", run.vehicleName, tostring(restoreReason))
        return "P22 could not start configuration restoration; Hold retained: " .. tostring(restoreReason)
    end
    run.phase = "REPOSITION_RESTORING"
    run.restoreRequestedAt = g_time or 0
    logInfo("REPOSITION_RESTORE_START vehicle=%s job=%s spatialResult=%s action=UNFOLD_WHILE_HELD_THEN_NATIVE_HANDOFF",
        run.vehicleName, run.startJobToken, tostring(run.spatialResult or "UNRESOLVED"))
    self:_setHud("OTM P22 — RESTORING", run.vehicleName .. " boom deploying", "Hold retained until original work configuration returns")
    return string.format("P22 restoring %s before same-Job GIANTS handoff", run.vehicleName)
end

function Probe:_cancelToHold()
    local run = self.run
    if run == nil then return "P22 has no active capability" end
    self.driveAuthority:clear(run.vehicle)
    local ok, reason = self.permissionGate:setHold(run.vehicle, "P22-MANUAL-CANCEL")
    if not ok then
        self.permissionGate:release(run.vehicle)
        self.run = nil
        return "P22 cancel could not establish Hold: " .. tostring(reason)
    end
    logWarning("CAPABILITY_CANCEL_TO_HOLD previousKind=%s previousPhase=%s vehicle=%s job=%s action=HOLD_RETAINED_UNTIL_EXPLICIT_RELEASE",
        tostring(run.kind), tostring(run.phase), run.vehicleName, tostring(run.startJobToken))
    if (run.kind == "REPOSITION" or run.kind == "TS015_RELOCATE") and self.configurationAuthority:getState(run.vehicle) ~= nil then
        local restoreOk, restoreReason = self.configurationAuthority:requestRestore(run.vehicle)
        if restoreOk then
            -- Reuse the established generic Reposition cancellation restoration
            -- path after an emergency TS015 abort; autonomous TS015 processing
            -- must stop at this point.
            if run.kind == "TS015_RELOCATE" then run.kind = "REPOSITION" end
            run.phase = "REPOSITION_CANCEL_RESTORING"
            run.spatialResult = run.spatialResult == "PASS" and "PASS" or "CANCELLED"
            self:_setHud("OTM P22 — CANCEL RESTORE", run.vehicleName .. " stopped", "Restoring original configuration; Hold retained")
            return string.format("P22 cancelled movement for %s; restoring configuration while HOLD remains", run.vehicleName)
        end
        logWarning("CAPABILITY_CANCEL_RESTORE_UNRESOLVED vehicle=%s reason=%s", run.vehicleName, tostring(restoreReason))
    end
    run.kind = "HOLD"
    run.phase = "CANCEL_HOLD"
    run.holdEffectLogged = false
    self:_setHud("OTM P22 — CANCEL HOLD", run.vehicleName .. " remains stopped", "Use release when safe")
    return string.format("P22 cancelled active movement for %s; HOLD retained. Use 'otmP22 release' when safe", run.vehicleName)
end

function Probe:_statusText()
    if self.run == nil and self.releasedMonitor == nil then return "P22 idle; use 'otmP22 list' or 'otmP22 help'" end
    if self.run ~= nil then
        local run = self.run
        local p = pose(run.vehicle)
        local travelled = distanceFrom(run, p)
        local drive = self.driveAuthority:getState(run.vehicle)
        return string.format("P22 %s/%s vehicle=%s job=%s sameJob=%s speed=%.2f travel=%s gateCalls=%d driveCalls=%d remaining=%s",
            run.kind, tostring(run.phase), run.vehicleName, tostring(run.startJobToken), tostring(currentJobToken(run.vehicle) == run.startJobToken),
            actualSpeedKmh(run.vehicle), travelled and string.format("%.2fm", travelled) or "n/a", self.permissionGate:getCallCount(run.vehicle),
            drive and (drive.driveCalls or 0) or 0, drive and drive.lastRemainingM and string.format("%.2fm", drive.lastRemainingM) or "n/a")
    end
    local monitor = self.releasedMonitor
    return string.format("P22 RELEASE_MONITOR vehicle=%s startJob=%s currentJob=%s speed=%.2f wake=%s",
        monitor.vehicleName, tostring(monitor.startJobToken), tostring(currentJobToken(monitor.vehicle)), actualSpeedKmh(monitor.vehicle), tostring(monitor.wakeMethod))
end

function Probe:consoleCommand(action, selector, a, b, c)
    action = lower(action)
    if action == "" or action == "help" then
        return "P22: list | status | regulate <vehicle> [kmh] | hold <vehicle> | reposition <vehicle> <forwardM> <rightM> [kmh] | relocate <Condor|Patriot> | release | cancel"
    end
    if OuttaMyWay.PROTOTYPE_22_CAPABILITY_GATE_ENABLED ~= true then return "Prototype 22 capability gate disabled in config" end
    if action == "list" then return self:_vehicleListText() end
    if action == "status" then return self:_statusText() end
    if action == "regulate" then return self:_startRegulate(selector, a) end
    if action == "hold" then return self:_startHold(selector) end
    if action == "reposition" then return self:_startReposition(selector, a, b, c) end
    if action == "relocate" then return OuttaMyWay.Prototype22TS015Relocation.start(self, selector) end
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
    if monitor.kind == "TS015_RELOCATE" then
        return OuttaMyWay.Prototype22TS015Relocation.updateReleaseMonitor(self, monitor, nowMs, token, p, moved, speed)
    end
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
        self.configurationAuthority:clear(run.vehicle)
        self:_setHud("OTM P22 — ABORT", run.vehicleName, "Job Episode changed; probe authority removed")
        self.run = nil
        return
    end

    local speed = actualSpeedKmh(run.vehicle)
    run.maxActualSpeedKmh = math.max(run.maxActualSpeedKmh or 0, speed)
    local p = pose(run.vehicle)
    local travelled = distanceFrom(run, p)

    if run.kind == "HOLD" and run.holdEffectLogged ~= true then
        local gateCalls = self.permissionGate:getCallCount(run.vehicle)
        if gateCalls > 0 and speed <= (OuttaMyWay.PROTOTYPE_22_HOLD_EFFECT_SPEED_KMH or 0.25) then
            run.holdEffectLogged = true
            logInfo("HOLD_EFFECT_PASS vehicle=%s job=%s sameJob=true speed=%.2f gateCalls=%d travel=%s",
                run.vehicleName, tostring(token), speed, gateCalls, travelled and string.format("%.2fm", travelled) or "n/a")
            self:_setHud("OTM P22 — HOLD PASS", run.vehicleName .. " stationary", "Use otmP22 release")
        end
    elseif run.kind == "TS015_RELOCATE" then
        OuttaMyWay.Prototype22TS015Relocation.update(self, run, nowMs, speed)
        if self.run == nil then return end
    elseif run.kind == "REPOSITION" then
        local fold = self.configurationAuthority:getEvidence(run.vehicle)
        if run.phase == "REPOSITION_SETTLING" then
            local gateCalls = self.permissionGate:getCallCount(run.vehicle)
            if gateCalls > 0 and speed <= (OuttaMyWay.PROTOTYPE_22_HOLD_EFFECT_SPEED_KMH or 0.25) then
                local ok, reason = self:_beginCompaction(run)
                if not ok then
                    logWarning("REPOSITION_ABORT vehicle=%s reason=%s", run.vehicleName, tostring(reason))
                    run.spatialResult = "UNRESOLVED"
                    run.phase = "REPOSITION_SPATIAL_UNRESOLVED"
                    self:_setHud("OTM P22 — UNRESOLVED", run.vehicleName, "Compaction authority unavailable; Hold retained")
                    return
                end
            end
        elseif run.phase == "REPOSITION_COMPACTING" then
            if fold.motionObserved then
                local ok, reason = self:_beginRepositionMovement(run)
                if not ok then
                    logWarning("REPOSITION_ABORT vehicle=%s reason=%s", run.vehicleName, tostring(reason))
                    run.spatialResult = "UNRESOLVED"
                    run.phase = "REPOSITION_SPATIAL_UNRESOLVED"
                    self:_setHud("OTM P22 — UNRESOLVED", run.vehicleName, "Forward Manoeuvre Leg unavailable; Hold retained")
                    return
                end
            elseif nowMs - (run.compactRequestedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_FOLD_MOTION_TIMEOUT_MS or 5000) then
                logWarning("REPOSITION_FOLD_MOTION_UNRESOLVED vehicle=%s %s", run.vehicleName, foldEvidenceText(fold))
                run.spatialResult = "UNRESOLVED"
                run.phase = "REPOSITION_SPATIAL_UNRESOLVED"
                self:_setHud("OTM P22 — UNRESOLVED", run.vehicleName, "No fold motion observed; Hold retained")
                return
            end
        elseif run.phase == "REPOSITION_MOVING" then
            local drive = self.driveAuthority:getState(run.vehicle)
            if drive ~= nil and drive.invalidReason ~= nil then
                logWarning("REPOSITION_ABORT vehicle=%s reason=%s", run.vehicleName, tostring(drive.invalidReason))
                run.spatialResult = "UNRESOLVED"
                run.phase = "REPOSITION_SPATIAL_UNRESOLVED"
                self.driveAuthority:clear(run.vehicle)
                self:_setHud("OTM P22 — UNRESOLVED", run.vehicleName, "Drive authority invalid; Hold retained")
                return
            end
            if drive ~= nil and drive.targetReached == true then
                self:_finishRepositionAtTarget(run)
            end
        elseif run.phase == "REPOSITION_TARGET_COMPACTING" then
            local span, configKey, profileId = self:_representedSpan(run.vehicle)
            local reduction = span ~= nil and run.initialSpanM ~= nil and (run.initialSpanM - span) or nil
            local targetSettled = speed <= (OuttaMyWay.PROTOTYPE_22_HOLD_EFFECT_SPEED_KMH or 0.25)
            if fold.allFolded and targetSettled and reduction ~= nil and reduction >= (OuttaMyWay.PROTOTYPE_22_SPAN_REDUCTION_MIN_M or 1.0) then
                run.phase = "REPOSITION_TARGET_HOLD"
                run.spatialResult = "PASS"
                run.compactSpanM = span
                run.spanReductionM = reduction
                run.compactConfigurationKey = configKey
                run.compactConfigurationProfileId = profileId
                logInfo("REPOSITION_SPATIAL_PASS vehicle=%s job=%s initialSpan=%.2fm compactSpan=%.2fm reduction=%.2fm initialProfile=%s compactProfile=%s %s instruction=REMAIN_UNTIL_MANUAL_RELEASE",
                    run.vehicleName, run.startJobToken, run.initialSpanM, span, reduction,
                    tostring(run.initialConfigurationProfileId or "n/a"), tostring(profileId or "n/a"), foldEvidenceText(fold))
                self:_setHud("OTM P22 — REPOSITION PASS", run.vehicleName .. " compact at target", string.format("span %.1f→%.1fm — use release", run.initialSpanM, span))
            elseif fold.allFolded and targetSettled and nowMs - (run.targetReachedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_SPATIAL_VERIFY_TIMEOUT_MS or 5000) then
                run.spatialResult = "UNRESOLVED"
                run.phase = "REPOSITION_SPATIAL_UNRESOLVED"
                logWarning("REPOSITION_SPATIAL_UNRESOLVED vehicle=%s job=%s initialSpan=%s compactSpan=%s reduction=%s reason=NO_POSITIVE_REPRESENTED_SPAN_REDUCTION %s",
                    run.vehicleName, run.startJobToken,
                    run.initialSpanM and string.format("%.2fm", run.initialSpanM) or "n/a",
                    span and string.format("%.2fm", span) or "n/a",
                    reduction and string.format("%.2fm", reduction) or "n/a", foldEvidenceText(fold))
                self:_setHud("OTM P22 — SPATIAL UNRESOLVED", run.vehicleName .. " folded at target", "Representation did not prove footprint reduction")
            elseif nowMs - (run.compactRequestedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_FULL_COMPACT_TIMEOUT_MS or 25000) then
                run.spatialResult = "UNRESOLVED"
                run.phase = "REPOSITION_SPATIAL_UNRESOLVED"
                logWarning("REPOSITION_SPATIAL_UNRESOLVED vehicle=%s job=%s reason=FULL_COMPACT_TIMEOUT %s", run.vehicleName, run.startJobToken, foldEvidenceText(fold))
                self:_setHud("OTM P22 — SPATIAL UNRESOLVED", run.vehicleName, "Full compact not observed; Hold retained")
            end
        elseif run.phase == "REPOSITION_RESTORING" or run.phase == "REPOSITION_CANCEL_RESTORING" then
            if fold.allDeployed then
                local finished, reason = self.configurationAuthority:finishRestore(run.vehicle)
                if not finished then
                    logWarning("REPOSITION_RESTORE_FINISH_UNRESOLVED vehicle=%s reason=%s", run.vehicleName, tostring(reason))
                    return
                end
                logInfo("REPOSITION_RESTORE_PASS vehicle=%s job=%s %s workAndLoweredState=RESTORED",
                    run.vehicleName, run.startJobToken, foldEvidenceText(fold))
                if run.phase == "REPOSITION_CANCEL_RESTORING" then
                    run.kind = "HOLD"
                    run.phase = "CANCEL_HOLD"
                    run.holdEffectLogged = true
                    self:_setHud("OTM P22 — CANCEL HOLD", run.vehicleName .. " restored and stopped", "Use release when safe")
                else
                    self:_releaseImmediate(run, "manual-release-after-configuration-restore")
                    return
                end
            elseif nowMs - (run.restoreRequestedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_RESTORE_TIMEOUT_MS or 25000) then
                if run.restoreTimeoutLogged ~= true then
                    run.restoreTimeoutLogged = true
                    logWarning("REPOSITION_RESTORE_UNRESOLVED vehicle=%s job=%s reason=DEPLOY_TIMEOUT %s action=HOLD_RETAINED",
                        run.vehicleName, run.startJobToken, foldEvidenceText(fold))
                    self:_setHud("OTM P22 — RESTORE UNRESOLVED", run.vehicleName, "Hold retained; do not hand back automatically")
                end
            end
        elseif run.phase == "FAILED" then
            run.spatialResult = run.spatialResult or "UNRESOLVED"
            self:_releaseImmediate(run, run.failureReason or "reposition-failed")
            return
        end
    end

    if nowMs >= (run.nextLogAt or 0) then
        run.nextLogAt = nowMs + (OuttaMyWay.PROTOTYPE_22_HEARTBEAT_MS or 1000)
        local drive = self.driveAuthority:getState(run.vehicle)
        local spatialKind = run.kind == "REPOSITION" or run.kind == "TS015_RELOCATE"
        local fold = spatialKind and self.configurationAuthority:getEvidence(run.vehicle) or nil
        local span = spatialKind and select(1, self:_representedSpan(run.vehicle)) or nil
        logInfo("SAMPLE kind=%s phase=%s vehicle=%s job=%s sameJob=true speed=%.2f travel=%s gateCalls=%d driveCalls=%d inputMax=%s outputMax=%s inputForward=%s remaining=%s span=%s %s",
            run.kind, tostring(run.phase), run.vehicleName, tostring(token), speed,
            travelled and string.format("%.2fm", travelled) or "n/a", self.permissionGate:getCallCount(run.vehicle),
            drive and (drive.driveCalls or 0) or 0,
            drive and drive.lastInputMaxSpeed and string.format("%.2f", drive.lastInputMaxSpeed) or "n/a",
            drive and drive.lastOutputMaxSpeed and string.format("%.2f", drive.lastOutputMaxSpeed) or "n/a",
            drive and tostring(drive.lastInputForward) or "n/a",
            drive and drive.lastRemainingM and string.format("%.2fm", drive.lastRemainingM) or "n/a",
            span and string.format("%.2fm", span) or "n/a", foldEvidenceText(fold))
    end
end
