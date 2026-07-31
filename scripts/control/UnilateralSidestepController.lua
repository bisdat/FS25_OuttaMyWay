-- FS25_OuttaMyWay v4.6.31
-- Prototype 16 / TS015-B actuator plus Prototype 17 / TS017-B shadow clearance calculation.
--
-- The validated Condor-yields/Patriot-progresses manoeuvre remains behaviourally
-- unchanged: manual arm, fixed test side and fixed 28 m lateral Control target.
-- Prototype 17 observes the same run and logs a geometry-derived required separation
-- before movement, at refuge and through passage. Shadow values have no Control authority.
OuttaMyWay.UnilateralSidestepController = OuttaMyWay.UnilateralSidestepController or {}
local Controller = OuttaMyWay.UnilateralSidestepController

local function nameOf(vehicle)
    if vehicle ~= nil and type(vehicle.getName) == "function" then
        local ok, name = pcall(vehicle.getName, vehicle)
        if ok and name ~= nil and name ~= "" then return tostring(name) end
    end
    return "AI vehicle"
end

local function getNode(vehicle)
    if vehicle == nil or vehicle.isDeleted == true then return nil end
    if type(vehicle.getAISteeringNode) == "function" then
        local ok, node = pcall(vehicle.getAISteeringNode, vehicle)
        if ok and node ~= nil and node ~= 0 then return node end
    end
    local node = vehicle.rootNode
    return node ~= nil and node ~= 0 and node or nil
end

local function positionOf(vehicle)
    local node = getNode(vehicle)
    if node == nil then return nil, nil, nil end
    local x, y, z = getWorldTranslation(node)
    return x, y, z
end

local function distance2d(ax, az, bx, bz)
    if ax == nil or az == nil or bx == nil or bz == nil then return nil end
    local dx, dz = bx - ax, bz - az
    return math.sqrt(dx * dx + dz * dz)
end

local function signedLateral(run, x, z)
    if run == nil or x == nil or z == nil then return nil end
    local dx, dz = x - run.startX, z - run.startZ
    return dx * run.rightX + dz * run.rightZ
end

local function longitudinal(run, x, z)
    if run == nil or x == nil or z == nil then return nil end
    local dx, dz = x - run.startX, z - run.startZ
    return dx * run.forwardX + dz * run.forwardZ
end

local function foldableObjects(root)
    local output, seen = {}, {}
    local function scan(object)
        if object == nil or object.isDeleted == true or seen[object] then return end
        seen[object] = true
        if object.spec_foldable ~= nil then output[#output + 1] = object end
        if type(object.getAttachedImplements) == "function" then
            local ok, implements = pcall(object.getAttachedImplements, object)
            if ok and type(implements) == "table" then
                for _, implement in pairs(implements) do
                    scan(implement ~= nil and (implement.object or implement) or nil)
                end
            end
        end
    end
    scan(root)
    return output
end

local function foldEvidence(vehicle)
    local objects = foldableObjects(vehicle)
    local count, high, low, interior = #objects, 0, 0, 0
    local minimum, maximum = nil, nil
    local compactThreshold = OuttaMyWay.TS015_FULL_COMPACT_FOLD_ANIM_TIME or 0.98
    for _, object in ipairs(objects) do
        local value = object.spec_foldable ~= nil and tonumber(object.spec_foldable.foldAnimTime) or nil
        if value ~= nil then
            minimum = minimum == nil and value or math.min(minimum, value)
            maximum = maximum == nil and value or math.max(maximum, value)
            if value >= compactThreshold then
                high = high + 1
            elseif value <= 0.02 then
                low = low + 1
            else
                interior = interior + 1
            end
        end
    end
    return {
        objects = count,
        high = high,
        low = low,
        interior = interior,
        minimum = minimum,
        maximum = maximum,
        compact = count > 0 and high == count,
        deployed = count > 0 and low == count
    }
end

local function activeStates()
    local states = {}
    local observed = OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.states or nil
    if type(observed) == "table" then
        for _, state in pairs(observed) do
            if state ~= nil and state.active == true and state.vehicle ~= nil then
                states[#states + 1] = state
            end
        end
    end
    table.sort(states, function(a, b)
        local an, bn = nameOf(a.vehicle), nameOf(b.vehicle)
        if an ~= bn then return an < bn end
        return tostring(a.vehicle) < tostring(b.vehicle)
    end)
    return states
end

local function stateFor(vehicle)
    if vehicle == nil or OuttaMyWay.Observer == nil or OuttaMyWay.Observer.states == nil then return nil end
    return OuttaMyWay.Observer.states[vehicle]
end

local function vehicleAsset(vehicle)
    return string.lower(tostring(vehicle and (vehicle.configFileName or vehicle.configFileNameClean or vehicle.xmlFilename) or ""))
end

local function contains(value, token)
    return string.find(string.lower(tostring(value or "")), string.lower(tostring(token or "")), 1, true) ~= nil
end

local function fixtureRole(state)
    if state == nil or state.vehicle == nil then return nil end
    local name = nameOf(state.vehicle)
    local asset = vehicleAsset(state.vehicle)
    if contains(name, "condor") or contains(asset, "condor") then return "YIELD_CONDOR" end
    if contains(name, "patriot") or contains(asset, "patriot") then return "PROGRESS_PATRIOT" end
    return nil
end

local function findFixtureStates(states)
    local yieldState, progressState = nil, nil
    for _, state in ipairs(states or {}) do
        local role = fixtureRole(state)
        if role == "YIELD_CONDOR" then
            if yieldState ~= nil then return nil, nil, "multiple-condor-candidates" end
            yieldState = state
        elseif role == "PROGRESS_PATRIOT" then
            if progressState ~= nil then return nil, nil, "multiple-patriot-candidates" end
            progressState = state
        end
    end
    if yieldState == nil or progressState == nil then
        return yieldState, progressState, "fixture-pair-incomplete"
    end
    return yieldState, progressState, nil
end

local function headingDifference(a, b)
    if a == nil or b == nil then return nil end
    local diff = math.abs((tonumber(a) or 0) - (tonumber(b) or 0)) % 360
    if diff > 180 then diff = 360 - diff end
    return diff
end


local function directionVector(node, localX, localZ)
    local x, _, z = localDirectionToWorld(node, localX, 0, localZ)
    local length = math.sqrt(x * x + z * z)
    if length < 0.001 then return nil, nil end
    return x / length, z / length
end

local function nowSeconds()
    if OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.startedAt ~= nil then
        return ((g_time or 0) - OuttaMyWay.Observer.startedAt) / 1000
    end
    return (g_time or 0) / 1000
end

function Controller:init()
    self.enabled = OuttaMyWay.UNILATERAL_SIDESTEP_ENABLED == true
    self.elapsedMs = 0
    self.armedSide = nil
    self.run = nil
    self.lastHeartbeatMs = 0
    self.driveHookInstalled = false
    self.originalDriveToPoint = nil

    OuttaMyWay.Logger:info(
        "PROTOTYPE 16 ACTIVE: TS015-B validated passage actuator enabled=%s exclusive=%s trigger=manual fixture=Condor-yields/Patriot-progresses controlTarget=28m progressHold=false testSideMapping=known-inverted",
        tostring(self.enabled), tostring(OuttaMyWay.UNILATERAL_SIDESTEP_EXCLUSIVE == true))
    OuttaMyWay.Logger:info(
        "PROTOTYPE 17 ACTIVE: TS017-B shadow-clearance calculation enabled=%s authority=false stages=pre-estimate/refuge-live/closest-approach/passage-confirmed controlTargetSource=TS015-fixed",
        tostring(OuttaMyWay.TS017_SHADOW_CLEARANCE_ENABLED == true))

    if self.enabled and OuttaMyWay.UNILATERAL_SIDESTEP_EXCLUSIVE ~= true then
        OuttaMyWay.Logger:error("VAL",
            "PROTOTYPE 16 SAFETY BOUNDARY FAILED: UNILATERAL_SIDESTEP_EXCLUSIVE must be true")
        self.enabled = false
    end
end

function Controller:installDriveHook()
    if self.driveHookInstalled == true then return true end
    if AIVehicleUtil == nil or type(AIVehicleUtil.driveToPoint) ~= "function" then
        return false
    end

    local original = AIVehicleUtil.driveToPoint
    self.originalDriveToPoint = original
    AIVehicleUtil.driveToPoint = function(vehicle, dt, acceleration, isAllowedToDrive, moveForwards, lx, lz, maxSpeed)
        local command = Controller:driveCommand(vehicle)
        if command ~= nil then
            return original(vehicle, dt,
                command.acceleration or 0,
                command.allowed == true,
                command.forward ~= false,
                command.lx or 0,
                command.lz or 1,
                command.maxSpeed or 0)
        end
        return original(vehicle, dt, acceleration, isAllowedToDrive, moveForwards, lx, lz, maxSpeed)
    end
    self.driveHookInstalled = true
    OuttaMyWay.Logger:ctl("PROTOTYPE16 DRIVE_HOOK installed target=AIVehicleUtil.driveToPoint")
    return true
end

function Controller:driveCommand(vehicle)
    local run = self.run
    if run == nil or run.vehicle ~= vehicle then return nil end

    local phase = run.phase
    -- Before the hold and after handback, GIANTS retains the unmodified drive
    -- call. All intermediate phases are exclusively owned by this probe.
    if phase == "STABILISING" or phase == "OBSERVE_HANDOFF" or phase == "COMPLETE" then
        return nil
    end
    if phase ~= "EGRESS" and phase ~= "REJOIN" then
        return {acceleration=0, allowed=false, forward=true, lx=0, lz=1, maxSpeed=0}
    end

    local targetX = phase == "EGRESS" and run.egressTargetX or run.rejoinTargetX
    local targetZ = phase == "EGRESS" and run.egressTargetZ or run.rejoinTargetZ
    local node = getNode(vehicle)
    if node == nil or targetX == nil or targetZ == nil then
        return {acceleration=0, allowed=false, forward=true, lx=0, lz=1, maxSpeed=0}
    end

    local x, _, z = getWorldTranslation(node)
    local dx, dz = targetX - x, targetZ - z
    local remaining = math.sqrt(dx * dx + dz * dz)
    if remaining <= (OuttaMyWay.TS015_TARGET_RADIUS_M or 1.0) then
        run.targetReached = true
        run.lastCommandedSpeed = 0
        return {acceleration=0, allowed=false, forward=true, lx=0, lz=1, maxSpeed=0}
    end

    local localX, _, localZ = worldDirectionToLocal(node, dx, 0, dz)
    local length = math.sqrt(localX * localX + localZ * localZ)
    if length > 0.001 then
        localX, localZ = localX / length, localZ / length
    else
        localX, localZ = 0, 1
    end

    local precisionRadius = phase == "EGRESS"
        and (OuttaMyWay.TS015_EGRESS_PRECISION_RADIUS_M or 6.0)
        or (OuttaMyWay.TS015_REJOIN_PRECISION_RADIUS_M or 8.0)
    local cruiseSpeed = phase == "EGRESS"
        and (OuttaMyWay.TS015_EGRESS_SPEED_KMH or 15.0)
        or (OuttaMyWay.TS015_INGRESS_SPEED_KMH or 15.0)
    local maxSpeed = remaining <= precisionRadius
        and (OuttaMyWay.TS015_PRECISION_SPEED_KMH or 6.0)
        or cruiseSpeed
    run.lastCommandedSpeed = maxSpeed

    return {
        acceleration = 1,
        allowed = true,
        forward = true,
        lx = localX,
        lz = localZ,
        maxSpeed = maxSpeed
    }
end

function Controller:setPhase(phase, reason, nowMs)
    local run = self.run
    if run == nil then return end
    local previous = run.phase
    run.phase = phase
    run.phaseStartedAt = nowMs or (g_time or 0)
    if phase ~= "EGRESS" and phase ~= "REJOIN" then run.lastCommandedSpeed = 0 end
    run.targetReached = false
    run.nextSampleAt = 0
    OuttaMyWay.transientText = string.format("TS015 %s: %s", phase, nameOf(run.vehicle))
    OuttaMyWay.transientUntil = (g_time or 0) + 4000
    OuttaMyWay.Logger:ctl(
        "PROTOTYPE16 PHASE t=%.1fs vehicle=%s previous=%s phase=%s reason=%s side=%s",
        nowSeconds(), nameOf(run.vehicle), tostring(previous), tostring(phase), tostring(reason or "none"),
        run.sideSign == 1 and "right" or "left")
end

function Controller:arm(side)
    if self.enabled ~= true then return false, "TS015 is disabled" end
    if self.run ~= nil then return false, "TS015 already active; use otmTS015Status or otmTS015Cancel" end

    side = string.lower(tostring(side or ""))
    if side ~= "left" and side ~= "right" then
        return false, "Usage: otmTS015Arm left|right"
    end

    local states = activeStates()
    if #states > 2 then
        return false, string.format("TS015 requires the Condor/Patriot pair only; observed %d active workers", #states)
    end

    self.armedSide = side
    OuttaMyWay.Logger:val(
        "PROTOTYPE16 ARMED t=%.1fs requestedSide=%s resolvedLateralSign=%s activeWorkers=%d trigger=pending-two-worker-head-on testSideMapping=known-inverted progressHold=false",
        nowSeconds(), side, side == "right" and "+1" or "-1", #states)
    return true, string.format("TS015 armed %s; waiting for active Condor and Patriot in stable opposed work", side)
end

function Controller:cancel()
    self.armedSide = nil
    if self.run == nil then return true, "TS015 arm cleared; no active manoeuvre" end
    local nowMs = g_time or 0
    self.run.cancelRequested = true
    if self.run.phase == "STABILISING" then
        self:clearRun("cancel-before-hold", nowMs)
        return true, "TS015 cancelled before intervention"
    end
    if self.run.phase == "OBSERVE_HANDOFF" or self.run.phase == "COMPLETE" then
        self:clearRun("cancel-after-handback", nowMs)
        return true, "TS015 observation ended"
    end
    self:setPhase("RESTORE_COMPACT", "operator-cancel", nowMs)
    return true, "TS015 cancellation requested; restoring Condor before handback"
end

function Controller:statusText()
    if self.run ~= nil then
        local x, _, z = positionOf(self.run.vehicle)
        local lateral = signedLateral(self.run, x, z)
        local forward = longitudinal(self.run, x, z)
        local shadow = self.run.shadowLatest or self.run.shadowPre
        return string.format("TS015 phase=%s yield=%s progress=%s requestedSide=%s lateral=%s forward=%s separation=%s passage=%s shadowRequired=%s shadowReserve=%s",
            tostring(self.run.phase), nameOf(self.run.vehicle), nameOf(self.run.progressVehicle),
            tostring(self.run.requestedSide),
            lateral ~= nil and string.format("%.1fm", lateral) or "unknown",
            forward ~= nil and string.format("%.1fm", forward) or "unknown",
            self.run.lastPairSeparation ~= nil and string.format("%.1fm", self.run.lastPairSeparation) or "unknown",
            tostring(self.run.passageConfirmedAt ~= nil),
            shadow ~= nil and shadow.requiredSeparation ~= nil and string.format("%.2fm", shadow.requiredSeparation) or "n/a",
            shadow ~= nil and shadow.reserve ~= nil and string.format("%.2fm", shadow.reserve) or "n/a")
    end
    if self.armedSide ~= nil then return "TS015 armed " .. self.armedSide .. "; waiting for Condor/Patriot pair" end
    return "TS015 idle"
end

function Controller:startRun(state, progressState, side, nowMs)
    if state == nil or state.vehicle == nil or progressState == nil or progressState.vehicle == nil then return false end
    local vehicle = state.vehicle
    local progressVehicle = progressState.vehicle
    local node = getNode(vehicle)
    if node == nil then return false end
    if not self:installDriveHook() then
        OuttaMyWay.Logger:error("CTL", "PROTOTYPE16 START failed: AIVehicleUtil.driveToPoint unavailable")
        return false
    end

    local x, _, z = getWorldTranslation(node)
    local forwardX, forwardZ = directionVector(node, 0, 1)
    local rightX, rightZ = directionVector(node, 1, 0)
    if forwardX == nil or rightX == nil then return false end

    -- Preserve the validated TS014 movement mapping unchanged. Runtime evidence
    -- shows the human test labels are inverted relative to physical motion.
    local sideSign = side == "right" and 1 or -1
    local px, _, pz = positionOf(progressVehicle)
    local initialSeparation = distance2d(x, z, px, pz)

    self.run = {
        vehicle = vehicle,
        progressVehicle = progressVehicle,
        requestedSide = side,
        phase = "STABILISING",
        phaseStartedAt = nowMs,
        startedAt = nowMs,
        sideSign = sideSign,
        armX = x,
        armZ = z,
        startX = x,
        startZ = z,
        startHeading = state.heading,
        progressStartHeading = progressState.heading,
        forwardX = forwardX,
        forwardZ = forwardZ,
        rightX = rightX,
        rightZ = rightZ,
        egressTargetX = nil,
        egressTargetZ = nil,
        rejoinTargetX = nil,
        rejoinTargetZ = nil,
        stableSince = nil,
        stopSince = nil,
        foldRequested = false,
        unfoldRequested = false,
        targetReached = false,
        nextSampleAt = 0,
        handoffX = nil,
        handoffZ = nil,
        fenceViolation = false,
        cancelRequested = false,
        holdRequestedAt = nil,
        stopConfirmedAt = nil,
        foldRequestedAt = nil,
        foldMotionAt = nil,
        egressReadyAt = nil,
        egressMotionAt = nil,
        fullCompactAt = nil,
        egressTargetAt = nil,
        passageCandidateAt = nil,
        passageConfirmedAt = nil,
        rejoinTargetAt = nil,
        deployRequestedAt = nil,
        deployedAt = nil,
        dwellSince = nil,
        rejoinStartedAt = nil,
        lastCommandedSpeed = 0,
        maxEgressSpeed = 0,
        maxRejoinSpeed = 0,
        minEgressRemaining = nil,
        minRejoinRemaining = nil,
        minPairSeparation = initialSeparation,
        minEnvelopeClearance = nil,
        envelopeIntersected = false,
        lastPairSeparation = initialSeparation,
        lastPairAt = nowMs,
        lastSeparationRate = nil,
        lastProgressLongitudinal = nil,
        nextGeometryAt = 0,
        yieldGeometryInventory = nil,
        progressGeometryInventory = nil,
        progressBlockedSince = nil,
        shadowPre = nil,
        shadowLatest = nil,
        shadowRefuge = nil,
        shadowRefugeLogged = false,
        shadowClosest = nil,
        shadowClosestPairSeparation = nil,
        shadowClosestLogged = false,
        shadowPassage = nil
    }
    self.armedSide = nil

    OuttaMyWay.Logger:val(
        "PROTOTYPE16 RUN_START t=%.1fs scenario=TS017-B-FACING-EXTENT-PROVIDER yield=%s progress=%s requestedSide=%s resolvedLateralSign=%d initialSeparation=%s yieldHeading=%.1f progressHeading=%.1f headingDelta=%s targetReference=confirmed-stop egress=rearward-outward foldOverlap=candidate-threshold progressControl=GIANTS_UNMODIFIED testSideMapping=known-inverted",
        nowSeconds(), nameOf(vehicle), nameOf(progressVehicle), side, sideSign,
        initialSeparation ~= nil and string.format("%.2fm", initialSeparation) or "unknown",
        tonumber(state.heading) or -1, tonumber(progressState.heading) or -1,
        headingDifference(state.heading, progressState.heading) ~= nil and string.format("%.1fdeg", headingDifference(state.heading, progressState.heading)) or "unknown")
    return true
end

function Controller:beginHold(nowMs)
    local run = self.run
    if run == nil then return false end
    local gate = OuttaMyWay.TrafficPermissionGate
    if gate == nil or type(gate.setHold) ~= "function" then
        self:fail("permission-gate-unavailable", nowMs)
        return false
    end
    local ok, reason = gate:setHold(run.vehicle, "TS015-UNPROTECTED-TWO-WORKER-PASSAGE", nil, nowMs)
    if not ok then
        self:fail("hold-failed:" .. tostring(reason), nowMs)
        return false
    end
    run.holdStartX, _, run.holdStartZ = positionOf(run.vehicle)
    run.holdRequestedAt = nowMs
    OuttaMyWay.Logger:val(
        "PROTOTYPE16 TIMING_MARK t=%.1fs yield=%s progress=%s mark=HOLD_REQUESTED pos=(%s,%s) pairSeparation=%s progressControl=GIANTS_UNMODIFIED",
        nowSeconds(), nameOf(run.vehicle), nameOf(run.progressVehicle),
        run.holdStartX ~= nil and string.format("%.2f", run.holdStartX) or "unknown",
        run.holdStartZ ~= nil and string.format("%.2f", run.holdStartZ) or "unknown",
        run.lastPairSeparation ~= nil and string.format("%.2fm", run.lastPairSeparation) or "unknown")
    self:setPhase("HOLD_EFFECT", "stable-opposed-working-pair", nowMs)
    return true
end

function Controller:requestCompact(nowMs)
    local run = self.run
    if run == nil then return end
    if OuttaMyWay.setParkedWorkState ~= nil then OuttaMyWay:setParkedWorkState(run.vehicle, true) end
    if OuttaMyWay.setBackoutRaisedState ~= nil then OuttaMyWay:setBackoutRaisedState(run.vehicle, true) end
    OuttaMyWay.parkedFoldState = OuttaMyWay.parkedFoldState or {}
    if run.foldRequestedAt == nil then run.foldRequestedAt = nowMs end
    if OuttaMyWay.parkedFoldState[run.vehicle] ~= true and OuttaMyWay.setParkedFoldState ~= nil then
        local toggled = OuttaMyWay:setParkedFoldState(run.vehicle, true) == true
        run.foldRequested = toggled or run.foldRequested == true
        OuttaMyWay.Logger:ctl(
            "PROTOTYPE16 COMPACT_REQUEST t=%.1fs vehicle=%s foldToggle=%s workOff=true raised=true",
            nowSeconds(), nameOf(run.vehicle), tostring(toggled))
    end
end

function Controller:requestDeploy(nowMs)
    local run = self.run
    if run == nil then return end
    OuttaMyWay.parkedFoldState = OuttaMyWay.parkedFoldState or {}
    if run.deployRequestedAt == nil then run.deployRequestedAt = nowMs end
    if OuttaMyWay.parkedFoldState[run.vehicle] == true and OuttaMyWay.setParkedFoldState ~= nil then
        local toggled = OuttaMyWay:setParkedFoldState(run.vehicle, false) == true
        run.unfoldRequested = toggled or run.unfoldRequested == true
        OuttaMyWay.Logger:ctl(
            "PROTOTYPE16 DEPLOY_REQUEST t=%.1fs vehicle=%s unfoldToggle=%s",
            nowSeconds(), nameOf(run.vehicle), tostring(toggled))
    end
end

local function elapsedSeconds(startMs, endMs)
    if startMs == nil or endMs == nil then return nil end
    return (endMs - startMs) / 1000
end

local function fmtSeconds(value)
    return value == nil and "n/a" or string.format("%.2fs", value)
end

local function fmtMetres(value)
    return value == nil and "n/a" or string.format("%.2fm", value)
end

local function logShadow(stage, run, sample, nowMs, pairSeparation)
    if run == nil or sample == nil then return end
    local controlReserve = sample.requiredSeparation ~= nil
        and sample.controlTarget - sample.requiredSeparation or nil
    OuttaMyWay.Logger:val(
        "PROTOTYPE17 SHADOW_CLEARANCE t=%.1fs stage=%s yield=%s progress=%s authority=false controlTarget=%.2fm progressExtent=%s progressSource=%s progressConfidence=%s yieldExtent=%s yieldSource=%s yieldConfidence=%s yieldCoverage=%s yieldCatalogue=%s/%s yieldBounded=%s yieldOrigins=%s yieldOriginExtent=%s yieldPhysicalAllowance=%s yieldBoundApis=%s yieldScanTruncated=%s yieldPoseSource=%s geometryMargin=%.2fm trackingMargin=%.2fm motionMargin=%.2fm policyMargin=%.2fm totalMargin=%.2fm requiredReferenceSeparation=%s controlTargetReserve=%s liveReferenceSeparation=%s liveReserve=%s pairSeparation=%s progressWorkingWidth=%s yieldMetadataWidth=%s yieldMetadataLength=%s pose=%s combinedConfidence=%s reference=%s corridorAssumption=%s diagnosticPolygonClearance=%s diagnosticIntersected=%s",
        nowSeconds(), tostring(stage), nameOf(run.vehicle), nameOf(run.progressVehicle),
        tonumber(sample.controlTarget) or 0,
        fmtMetres(sample.progressExtent), tostring(sample.progressExtentSource), tostring(sample.progressExtentConfidence),
        fmtMetres(sample.yieldExtent), tostring(sample.yieldExtentSource), tostring(sample.yieldExtentConfidence),
        tostring(sample.yieldProviderCoverage),
        tostring(sample.yieldProviderResolved or "n/a"), tostring(sample.yieldProviderExpected or "n/a"),
        tostring(sample.yieldProviderBounded or "n/a"), tostring(sample.yieldProviderOrigins or "n/a"),
        fmtMetres(sample.yieldProviderOriginExtent), fmtMetres(sample.yieldProviderPhysicalAllowance),
        tostring(sample.yieldProviderApiSummary), tostring(sample.yieldProviderScanTruncated == true),
        tostring(sample.yieldProviderPoseSource),
        tonumber(sample.margins and sample.margins.geometry) or 0,
        tonumber(sample.margins and sample.margins.tracking) or 0,
        tonumber(sample.margins and sample.margins.motion) or 0,
        tonumber(sample.margins and sample.margins.policy) or 0,
        tonumber(sample.margins and sample.margins.total) or 0,
        fmtMetres(sample.requiredSeparation), fmtMetres(controlReserve),
        sample.mode == "PRE" and "n/a" or fmtMetres(sample.referenceSeparation),
        sample.mode == "PRE" and "n/a" or fmtMetres(sample.reserve),
        fmtMetres(pairSeparation), fmtMetres(sample.progressWorkingMarkerWidth),
        fmtMetres(sample.yieldMetadataWidth), fmtMetres(sample.yieldMetadataLength),
        tostring(sample.predictedPoseAssumption), tostring(sample.combinedConfidence),
        tostring(sample.referenceSource), tostring(sample.corridorAssumption),
        fmtMetres(sample.diagnosticClearance), tostring(sample.diagnosticIntersected == true))
end

function Controller:sampleShadow(mode, nowMs)
    if OuttaMyWay.TS017_SHADOW_CLEARANCE_ENABLED ~= true then return nil end
    local calculator = OuttaMyWay.ShadowClearanceCalculator
    if calculator == nil or type(calculator.sample) ~= "function" or self.run == nil then return nil end
    local ok, sample = pcall(calculator.sample, calculator, self.run, nowMs, mode)
    if not ok then
        OuttaMyWay.Logger:error("VAL",
            "PROTOTYPE17 SHADOW_CALCULATION_FAILED t=%.1fs stage=%s error=%s authority=false action=continue-fixed-28m-control",
            nowSeconds(), tostring(mode), tostring(sample))
        return nil
    end
    return sample
end

function Controller:logShadowPreEstimate(nowMs)
    local run = self.run
    if run == nil or run.shadowPre ~= nil then return end
    run.shadowPre = self:sampleShadow("PRE", nowMs)
    logShadow("PRE_ESTIMATE", run, run.shadowPre, nowMs, run.lastPairSeparation)
end

function Controller:logShadowRefuge(nowMs)
    local run = self.run
    if run == nil or run.shadowRefugeLogged == true or run.shadowLatest == nil then return end
    run.shadowRefugeLogged = true
    run.shadowRefuge = run.shadowLatest
    logShadow("REFUGE_LIVE", run, run.shadowRefuge, nowMs, run.lastPairSeparation)
end

function Controller:logShadowClosest(nowMs)
    local run = self.run
    if run == nil or run.shadowClosestLogged == true then return end
    run.shadowClosestLogged = true
    logShadow("CLOSEST_APPROACH", run, run.shadowClosest or run.shadowLatest, nowMs,
        run.shadowClosestPairSeparation or run.lastPairSeparation)
end

function Controller:logShadowPassage(nowMs)
    local run = self.run
    if run == nil then return end
    run.shadowPassage = run.shadowLatest
    logShadow("PASSAGE_CONFIRMED", run, run.shadowPassage, nowMs, run.lastPairSeparation)
end

function Controller:releaseToGiants(reason, nowMs)
    local run = self.run
    if run == nil then return end
    if OuttaMyWay.setBackoutRaisedState ~= nil then OuttaMyWay:setBackoutRaisedState(run.vehicle, false) end
    if OuttaMyWay.setParkedWorkState ~= nil then OuttaMyWay:setParkedWorkState(run.vehicle, false) end

    local gate = OuttaMyWay.TrafficPermissionGate
    local gateState = gate ~= nil and gate.releaseHold ~= nil and gate:releaseHold(run.vehicle) or nil
    local resumeRequested = false
    if OuttaMyWay.requestAIFieldWorkerResume ~= nil then
        resumeRequested = OuttaMyWay:requestAIFieldWorkerResume(run.vehicle, "TS017-B facing-extent observation handback") == true
    end

    run.handoffAt = nowMs
    run.handoffX, _, run.handoffZ = positionOf(run.vehicle)
    OuttaMyWay.Logger:ctl(
        "PROTOTYPE16 HANDOFF t=%.1fs yield=%s progress=%s reason=%s gateReleased=%s gateCalls=%d resumeRequested=%s handoff=(%s,%s) passageConfirmed=%s jobOwnership=GIANTS progressControl=GIANTS_UNMODIFIED",
        nowSeconds(), nameOf(run.vehicle), nameOf(run.progressVehicle), tostring(reason), tostring(gateState ~= nil),
        gate ~= nil and gate.getCallCount ~= nil and gate:getCallCount(run.vehicle) or 0,
        tostring(resumeRequested),
        run.handoffX ~= nil and string.format("%.2f", run.handoffX) or "unknown",
        run.handoffZ ~= nil and string.format("%.2f", run.handoffZ) or "unknown",
        tostring(run.passageConfirmedAt ~= nil))
    OuttaMyWay.Logger:val(
        "PROTOTYPE16 TIMING_SUMMARY yield=%s progress=%s holdToStop=%s stopToFoldMotion=%s stopToEgressReady=%s readyToEgressMotion=%s stopToEgressMotion=%s foldRequestToFullCompact=%s egressMotionDuration=%s refugeToPassage=%s passageConfirmDuration=%s postPassDwell=%s rejoinDuration=%s deployDuration=%s maxEgressSpeed=%.2f maxRejoinSpeed=%.2f minPairSeparation=%s minDiagnosticEnvelopeClearance=%s diagnosticEnvelopeIntersected=%s totalIntervention=%s",
        nameOf(run.vehicle), nameOf(run.progressVehicle),
        fmtSeconds(elapsedSeconds(run.holdRequestedAt, run.stopConfirmedAt)),
        fmtSeconds(elapsedSeconds(run.stopConfirmedAt, run.foldMotionAt)),
        fmtSeconds(elapsedSeconds(run.stopConfirmedAt, run.egressReadyAt)),
        fmtSeconds(elapsedSeconds(run.egressReadyAt, run.egressMotionAt)),
        fmtSeconds(elapsedSeconds(run.stopConfirmedAt, run.egressMotionAt)),
        fmtSeconds(elapsedSeconds(run.foldRequestedAt, run.fullCompactAt)),
        fmtSeconds(elapsedSeconds(run.egressMotionAt, run.egressTargetAt)),
        fmtSeconds(elapsedSeconds(run.egressTargetAt, run.passageConfirmedAt)),
        fmtSeconds(elapsedSeconds(run.passageCandidateAt, run.passageConfirmedAt)),
        fmtSeconds(elapsedSeconds(run.passageConfirmedAt, run.rejoinStartedAt)),
        fmtSeconds(elapsedSeconds(run.rejoinStartedAt, run.rejoinTargetAt)),
        fmtSeconds(elapsedSeconds(run.deployRequestedAt, run.deployedAt)),
        tonumber(run.maxEgressSpeed) or 0,
        tonumber(run.maxRejoinSpeed) or 0,
        run.minPairSeparation ~= nil and string.format("%.2fm", run.minPairSeparation) or "n/a",
        run.minEnvelopeClearance ~= nil and string.format("%.2fm", run.minEnvelopeClearance) or "n/a",
        tostring(run.envelopeIntersected == true),
        fmtSeconds(elapsedSeconds(run.holdRequestedAt, nowMs)))
    OuttaMyWay.Logger:val(
        "PROTOTYPE17 SHADOW_SUMMARY yield=%s progress=%s authority=false controlTarget=%.2fm preRequired=%s preControlReserve=%s refugeRequired=%s refugeReferenceSeparation=%s refugeReserve=%s closestPairSeparation=%s closestRequired=%s closestReferenceSeparation=%s closestReserve=%s passageRequired=%s passageReserve=%s result=observation-only",
        nameOf(run.vehicle), nameOf(run.progressVehicle),
        tonumber(OuttaMyWay.TS015_LATERAL_OFFSET_M) or 28.0,
        run.shadowPre ~= nil and fmtMetres(run.shadowPre.requiredSeparation) or "n/a",
        run.shadowPre ~= nil and run.shadowPre.requiredSeparation ~= nil
            and fmtMetres((tonumber(OuttaMyWay.TS015_LATERAL_OFFSET_M) or 28.0) - run.shadowPre.requiredSeparation) or "n/a",
        run.shadowRefuge ~= nil and fmtMetres(run.shadowRefuge.requiredSeparation) or "n/a",
        run.shadowRefuge ~= nil and fmtMetres(run.shadowRefuge.referenceSeparation) or "n/a",
        run.shadowRefuge ~= nil and fmtMetres(run.shadowRefuge.reserve) or "n/a",
        fmtMetres(run.shadowClosestPairSeparation),
        run.shadowClosest ~= nil and fmtMetres(run.shadowClosest.requiredSeparation) or "n/a",
        run.shadowClosest ~= nil and fmtMetres(run.shadowClosest.referenceSeparation) or "n/a",
        run.shadowClosest ~= nil and fmtMetres(run.shadowClosest.reserve) or "n/a",
        run.shadowPassage ~= nil and fmtMetres(run.shadowPassage.requiredSeparation) or "n/a",
        run.shadowPassage ~= nil and fmtMetres(run.shadowPassage.reserve) or "n/a")
    self:setPhase("OBSERVE_HANDOFF", reason, nowMs)
end

function Controller:fail(reason, nowMs)
    local run = self.run
    if run == nil then return end
    run.failureReason = reason
    self:requestCompact(nowMs)
    self:setPhase("FAILED_HELD", reason, nowMs)
    OuttaMyWay.Logger:error("CTL",
        "PROTOTYPE16 FAILED_HELD t=%.1fs vehicle=%s reason=%s action=remain-stopped-compact command=otmTS015Cancel",
        nowSeconds(), nameOf(run.vehicle), tostring(reason))
end

function Controller:clearRun(reason, nowMs)
    local run = self.run
    if run == nil then return end
    local gate = OuttaMyWay.TrafficPermissionGate
    if gate ~= nil and gate.releaseHold ~= nil then gate:releaseHold(run.vehicle) end
    OuttaMyWay.activeWaitCount = 0
    OuttaMyWay.priorityName = ""
    OuttaMyWay.Logger:val(
        "PROTOTYPE16 RUN_END t=%.1fs yield=%s progress=%s reason=%s duration=%.1fs failure=%s fenceViolation=%s passageConfirmed=%s minPairSeparation=%s minDiagnosticEnvelopeClearance=%s diagnosticEnvelopeIntersected=%s",
        nowSeconds(), nameOf(run.vehicle), nameOf(run.progressVehicle), tostring(reason),
        ((nowMs or (g_time or 0)) - (run.startedAt or (nowMs or 0))) / 1000,
        tostring(run.failureReason), tostring(run.fenceViolation == true), tostring(run.passageConfirmedAt ~= nil),
        run.minPairSeparation ~= nil and string.format("%.2fm", run.minPairSeparation) or "n/a",
        run.minEnvelopeClearance ~= nil and string.format("%.2fm", run.minEnvelopeClearance) or "n/a",
        tostring(run.envelopeIntersected == true))
    self.run = nil
end

function Controller:updateFence(run, x, z, nowMs)
    if run == nil or run.stopConfirmedAt == nil then return end
    if run.phase ~= "COMPACTING" and run.phase ~= "EGRESS"
        and run.phase ~= "SIDESTEP_HOLD" and run.phase ~= "REJOIN"
        and run.phase ~= "UNFOLDING" then return end
    local lateral = signedLateral(run, x, z)
    if lateral == nil then return end
    local signedForSide = lateral * run.sideSign
    local tolerance = OuttaMyWay.TS015_FENCE_TOLERANCE_M or 0.75
    if signedForSide < -tolerance and run.fenceViolation ~= true then
        run.fenceViolation = true
        OuttaMyWay.Logger:error("VAL",
            "PROTOTYPE16 CENTRELINE_FENCE_VIOLATION t=%.1fs vehicle=%s lateral=%.2fm selectedSide=%s tolerance=%.2fm fullAssemblyFence=not-evaluated",
            nowSeconds(), nameOf(run.vehicle), lateral,
            run.sideSign == 1 and "right" or "left", tolerance)
        self:fail("centreline-fence-violation", nowMs)
    end
end

local function diagnosticEnvelope(run, nowMs)
    if run == nil or nowMs < (run.nextGeometryAt or 0) then return end
    run.nextGeometryAt = nowMs + (OuttaMyWay.TS015_PAIR_GEOMETRY_INTERVAL_MS or 500)

    local calculator = OuttaMyWay.ShadowClearanceCalculator
    if calculator == nil or type(calculator.sample) ~= "function" then return end
    local ok, sample = pcall(calculator.sample, calculator, run, nowMs, "LIVE")
    if not ok or sample == nil then return end

    run.shadowLatest = sample
    run.lastEnvelopeClearance = sample.diagnosticClearance
    run.lastEnvelopeIntersected = sample.diagnosticIntersected == true
    run.lastYieldGeometryConfidence = sample.yieldGeometryConfidence
    run.lastProgressGeometryConfidence = sample.progressGeometryConfidence
    if sample.diagnosticClearance ~= nil then
        run.minEnvelopeClearance = run.minEnvelopeClearance == nil and sample.diagnosticClearance
            or math.min(run.minEnvelopeClearance, sample.diagnosticClearance)
    end
    if sample.diagnosticIntersected == true then run.envelopeIntersected = true end

    if run.phase == "SIDESTEP_HOLD" and run.passageConfirmedAt == nil
        and run.lastPairSeparation ~= nil then
        if run.shadowClosestPairSeparation == nil
            or run.lastPairSeparation < run.shadowClosestPairSeparation then
            run.shadowClosestPairSeparation = run.lastPairSeparation
            run.shadowClosest = sample
        end
    end
end

function Controller:updatePairEvidence(yieldState, progressState, nowMs)
    local run = self.run
    if run == nil or yieldState == nil or progressState == nil then return end
    local yx, _, yz = positionOf(run.vehicle)
    local px, _, pz = positionOf(run.progressVehicle)
    local separation = distance2d(yx, yz, px, pz)
    local progressLongitudinal = nil
    if run.stopConfirmedAt ~= nil and px ~= nil and pz ~= nil then
        local dx, dz = px - run.startX, pz - run.startZ
        progressLongitudinal = dx * run.forwardX + dz * run.forwardZ
    end

    local previousSeparationRate = run.lastSeparationRate
    local separationRate = nil
    if separation ~= nil and run.lastPairSeparation ~= nil and run.lastPairAt ~= nil and nowMs > run.lastPairAt then
        separationRate = (separation - run.lastPairSeparation) / ((nowMs - run.lastPairAt) / 1000)
    end
    if separation ~= nil then
        run.minPairSeparation = run.minPairSeparation == nil and separation or math.min(run.minPairSeparation, separation)
        run.lastPairSeparation = separation
        run.lastPairAt = nowMs
    end
    run.lastSeparationRate = separationRate
    run.lastProgressLongitudinal = progressLongitudinal

    diagnosticEnvelope(run, nowMs)

    if run.phase == "SIDESTEP_HOLD" and run.passageConfirmedAt == nil
        and run.shadowClosestLogged ~= true
        and previousSeparationRate ~= nil and previousSeparationRate < 0
        and separationRate ~= nil and separationRate >= 0 then
        self:logShadowClosest(nowMs)
    end

    if progressState.blocked == true and run.passageConfirmedAt == nil then
        run.progressBlockedSince = run.progressBlockedSince or nowMs
        if nowMs - run.progressBlockedSince >= (OuttaMyWay.TS015_PROGRESS_BLOCKED_CONFIRM_MS or 1500) then
            self:fail("progress-blocked-before-passage", nowMs)
            return
        end
    else
        run.progressBlockedSince = nil
    end

    if run.phase ~= "SIDESTEP_HOLD" or run.passageConfirmedAt ~= nil then return end
    local behind = OuttaMyWay.TS015_PASS_BEHIND_STOP_M or 20.0
    local clearDistance = OuttaMyWay.TS015_PASS_CLEAR_DISTANCE_M or 35.0
    local minDivergence = OuttaMyWay.TS015_PASS_MIN_DIVERGENCE_MPS or 0.20
    local candidate = progressLongitudinal ~= nil and progressLongitudinal <= -behind
        and separation ~= nil and separation >= clearDistance
        and separationRate ~= nil and separationRate >= minDivergence
        and (progressState.actualSpeed or 0) >= (OuttaMyWay.TS015_MIN_PROGRESS_SPEED_KMH or 2.0)
        and progressState.blocked ~= true

    if candidate then
        if run.passageCandidateAt == nil then
            run.passageCandidateAt = nowMs
            OuttaMyWay.Logger:val(
                "PROTOTYPE16 PASSAGE_CANDIDATE t=%.1fs yield=%s progress=%s separation=%.2fm progressLongitudinal=%.2fm separationRate=%.2fmps envelopeClearance=%s envelopeAuthority=false",
                nowSeconds(), nameOf(run.vehicle), nameOf(run.progressVehicle), separation,
                progressLongitudinal, separationRate,
                run.lastEnvelopeClearance ~= nil and string.format("%.2fm", run.lastEnvelopeClearance) or "unknown")
        elseif nowMs - run.passageCandidateAt >= (OuttaMyWay.TS015_PASS_CONFIRM_MS or 1500) then
            run.passageConfirmedAt = nowMs
            OuttaMyWay.Logger:val(
                "PROTOTYPE16 PASSAGE_CONFIRMED t=%.1fs yield=%s progress=%s separation=%.2fm progressLongitudinal=%.2fm separationRate=%.2fmps confirm=%.2fs progressControl=GIANTS_UNMODIFIED fullAssemblyClearance=video-required",
                nowSeconds(), nameOf(run.vehicle), nameOf(run.progressVehicle), separation,
                progressLongitudinal, separationRate,
                (nowMs - run.passageCandidateAt) / 1000)
            self:logShadowPassage(nowMs)
        end
    else
        run.passageCandidateAt = nil
    end
end

function Controller:logSample(run, state, progressState, fold, nowMs)
    if nowMs < (run.nextSampleAt or 0) then return end
    run.nextSampleAt = nowMs + (OuttaMyWay.TS015_LOG_INTERVAL_MS or 500)
    local x, _, z = positionOf(run.vehicle)
    local lateral = signedLateral(run, x, z)
    local forward = longitudinal(run, x, z)
    local targetX = run.phase == "EGRESS" and run.egressTargetX
        or (run.phase == "REJOIN" and run.rejoinTargetX or nil)
    local targetZ = run.phase == "EGRESS" and run.egressTargetZ
        or (run.phase == "REJOIN" and run.rejoinTargetZ or nil)
    local remaining = distance2d(x, z, targetX, targetZ)
    local handoffTravel = run.handoffX ~= nil and distance2d(run.handoffX, run.handoffZ, x, z) or nil

    OuttaMyWay.Logger:val(
        "PROTOTYPE16 SAMPLE t=%.1fs yield=%s progress=%s phase=%s yieldActive=%s yieldWorkerPhase=%s yieldTurn=%s yieldBlocked=%s yieldSpeed=%.2f progressActive=%s progressWorkerPhase=%s progressTurn=%s progressBlocked=%s progressSpeed=%.2f pairSeparation=%s separationRate=%s progressLongitudinal=%s envelopeClearance=%s envelopeIntersected=%s geometryConfidence=%s/%s shadowRequired=%s shadowReferenceSeparation=%s shadowReserve=%s shadowConfidence=%s commandedMax=%.1f yieldPos=(%s,%s) lateral=%s forward=%s targetRemaining=%s foldObjects=%d foldHigh=%d foldLow=%d foldInterior=%d foldRange=%s..%s compact=%s deployed=%s passageConfirmed=%s handoffTravel=%s",
        nowSeconds(), nameOf(run.vehicle), nameOf(run.progressVehicle), tostring(run.phase),
        tostring(state ~= nil and state.active == true), state ~= nil and tostring(state.phase) or "missing",
        tostring(state ~= nil and state.isTurn == true), tostring(state ~= nil and state.blocked == true),
        state ~= nil and (tonumber(state.actualSpeed) or 0) or 0,
        tostring(progressState ~= nil and progressState.active == true), progressState ~= nil and tostring(progressState.phase) or "missing",
        tostring(progressState ~= nil and progressState.isTurn == true), tostring(progressState ~= nil and progressState.blocked == true),
        progressState ~= nil and (tonumber(progressState.actualSpeed) or 0) or 0,
        run.lastPairSeparation ~= nil and string.format("%.2fm", run.lastPairSeparation) or "unknown",
        run.lastSeparationRate ~= nil and string.format("%.2fmps", run.lastSeparationRate) or "unknown",
        run.lastProgressLongitudinal ~= nil and string.format("%.2fm", run.lastProgressLongitudinal) or "unknown",
        run.lastEnvelopeClearance ~= nil and string.format("%.2fm", run.lastEnvelopeClearance) or "unknown",
        tostring(run.lastEnvelopeIntersected == true),
        tostring(run.lastYieldGeometryConfidence or "unknown"), tostring(run.lastProgressGeometryConfidence or "unknown"),
        run.shadowLatest ~= nil and fmtMetres(run.shadowLatest.requiredSeparation) or "n/a",
        run.shadowLatest ~= nil and fmtMetres(run.shadowLatest.referenceSeparation) or "n/a",
        run.shadowLatest ~= nil and fmtMetres(run.shadowLatest.reserve) or "n/a",
        run.shadowLatest ~= nil and tostring(run.shadowLatest.combinedConfidence) or "UNKNOWN",
        tonumber(run.lastCommandedSpeed) or 0,
        x ~= nil and string.format("%.2f", x) or "unknown", z ~= nil and string.format("%.2f", z) or "unknown",
        lateral ~= nil and string.format("%.2fm", lateral) or "unknown",
        forward ~= nil and string.format("%.2fm", forward) or "unknown",
        remaining ~= nil and string.format("%.2fm", remaining) or "n/a",
        fold.objects, fold.high, fold.low, fold.interior,
        fold.minimum ~= nil and string.format("%.3f", fold.minimum) or "n/a",
        fold.maximum ~= nil and string.format("%.3f", fold.maximum) or "n/a",
        tostring(fold.compact), tostring(fold.deployed), tostring(run.passageConfirmedAt ~= nil),
        handoffTravel ~= nil and string.format("%.2fm", handoffTravel) or "n/a")
end

function Controller:updateRun(nowMs)
    local run = self.run
    if run == nil then return end
    local state = stateFor(run.vehicle)
    local progressState = stateFor(run.progressVehicle)
    local currentWorkers = activeStates()

    if #currentWorkers > 2 then
        if run.phase == "STABILISING" then
            self:clearRun("unexpected-third-worker-before-hold", nowMs)
        else
            self:fail("unexpected-third-worker", nowMs)
        end
        return
    end
    if run.vehicle == nil or run.vehicle.isDeleted == true then
        self:clearRun("yield-vehicle-deleted", nowMs)
        return
    end
    if state == nil or state.active ~= true then
        local gate = OuttaMyWay.TrafficPermissionGate
        if gate ~= nil and gate.releaseHold ~= nil then gate:releaseHold(run.vehicle) end
        OuttaMyWay.Logger:error("CTL",
            "PROTOTYPE16 YIELD_WORKER_DETACHED t=%.1fs vehicle=%s phase=%s action=control-cleared configuration-restoration-unconfirmed",
            nowSeconds(), nameOf(run.vehicle), tostring(run.phase))
        self:clearRun("yield-worker-detached", nowMs)
        return
    end
    if progressState == nil or progressState.active ~= true then
        if run.passageConfirmedAt ~= nil or run.phase == "OBSERVE_HANDOFF" then
            if run.progressDetachedLogged ~= true then
                run.progressDetachedLogged = true
                OuttaMyWay.Logger:val(
                    "PROTOTYPE16 PROGRESS_DETACHED_AFTER_PASSAGE t=%.1fs progress=%s phase=%s passageConfirmed=%s action=continue-yield-restoration",
                    nowSeconds(), nameOf(run.progressVehicle), tostring(run.phase), tostring(run.passageConfirmedAt ~= nil))
            end
        elseif run.phase == "STABILISING" then
            self:clearRun("progress-worker-detached-before-hold", nowMs)
            return
        else
            self:fail("progress-worker-detached-before-passage", nowMs)
            return
        end
    end

    local settings = OuttaMyWay.settings
    if settings ~= nil and (settings.enabled == false or settings.simulationMode == true) then
        run.cancelRequested = true
        if run.phase ~= "RESTORE_COMPACT" and run.phase ~= "UNFOLDING" and run.phase ~= "OBSERVE_HANDOFF" then
            self:setPhase("RESTORE_COMPACT", settings.enabled == false and "mod-disabled" or "simulation-enabled", nowMs)
        end
    end

    local x, _, z = positionOf(run.vehicle)
    self:updateFence(run, x, z, nowMs)
    if self.run == nil or self.run.phase == "FAILED_HELD" and run.failureReason == "centreline-fence-violation" then return end

    local fold = foldEvidence(run.vehicle)
    if progressState ~= nil then
        self:updatePairEvidence(state, progressState, nowMs)
        if self.run == nil or self.run.phase == "FAILED_HELD" then return end
    end
    self:logSample(run, state, progressState, fold, nowMs)
    if run.phase == "SIDESTEP_HOLD" and fold.compact and run.shadowRefugeLogged ~= true then
        self:logShadowRefuge(nowMs)
    end
    OuttaMyWay.activeWaitCount = run.phase == "OBSERVE_HANDOFF" and 0 or 1
    OuttaMyWay.priorityName = progressState ~= nil and ("TS015 progress: " .. nameOf(run.progressVehicle)) or "TS015 passage complete"

    local phaseElapsed = nowMs - (run.phaseStartedAt or nowMs)

    if run.phase == "EGRESS" then
        local remaining = distance2d(x, z, run.egressTargetX, run.egressTargetZ)
        if remaining ~= nil then
            run.minEgressRemaining = run.minEgressRemaining == nil and remaining or math.min(run.minEgressRemaining, remaining)
        end
        run.maxEgressSpeed = math.max(run.maxEgressSpeed or 0, tonumber(state.actualSpeed) or 0)
        local movedFromStop = distance2d(run.startX, run.startZ, x, z)
        if run.egressMotionAt == nil and movedFromStop ~= nil and movedFromStop >= 0.25 then
            run.egressMotionAt = nowMs
            OuttaMyWay.Logger:val(
                "PROTOTYPE16 TIMING_MARK t=%.1fs vehicle=%s mark=EGRESS_MOTION_STARTED movedFromStop=%.2fm foldRange=%s..%s sinceReady=%s pairSeparation=%s",
                nowSeconds(), nameOf(run.vehicle), movedFromStop,
                fold.minimum ~= nil and string.format("%.3f", fold.minimum) or "n/a",
                fold.maximum ~= nil and string.format("%.3f", fold.maximum) or "n/a",
                fmtSeconds(elapsedSeconds(run.egressReadyAt, nowMs)),
                run.lastPairSeparation ~= nil and string.format("%.2fm", run.lastPairSeparation) or "unknown")
        end
    elseif run.phase == "REJOIN" then
        local remaining = distance2d(x, z, run.rejoinTargetX, run.rejoinTargetZ)
        if remaining ~= nil then
            run.minRejoinRemaining = run.minRejoinRemaining == nil and remaining or math.min(run.minRejoinRemaining, remaining)
        end
        run.maxRejoinSpeed = math.max(run.maxRejoinSpeed or 0, tonumber(state.actualSpeed) or 0)
    end

    if run.phase == "STABILISING" then
        local headingDelta = progressState ~= nil and headingDifference(state.heading, progressState.heading) or nil
        local eligibleYield = state.phase == "WORKING"
            and state.isTurn ~= true
            and state.blocked ~= true
            and (state.actualSpeed or 0) >= (OuttaMyWay.TS015_MIN_WORKING_SPEED_KMH or 2.0)
        local eligibleProgress = progressState ~= nil
            and progressState.phase == "WORKING"
            and progressState.isTurn ~= true
            and progressState.blocked ~= true
            and (progressState.actualSpeed or 0) >= (OuttaMyWay.TS015_MIN_PROGRESS_SPEED_KMH or 2.0)
        local opposed = headingDelta ~= nil and headingDelta >= (OuttaMyWay.TS015_HEAD_ON_MIN_DEG or 150.0)
        if eligibleYield and eligibleProgress and opposed then
            run.stableSince = run.stableSince or nowMs
            if nowMs - run.stableSince >= (OuttaMyWay.TS015_STABLE_WORKING_MS or 3000) then
                self:beginHold(nowMs)
            end
        else
            run.stableSince = nil
        end
        if phaseElapsed >= (OuttaMyWay.TS015_ARM_TIMEOUT_MS or 90000) then
            self:fail("stable-opposed-working-timeout", nowMs)
        end

    elseif run.phase == "HOLD_EFFECT" then
        local moved = distance2d(run.holdStartX, run.holdStartZ, x, z)
        local stopped = (state.actualSpeed or 0) <= (OuttaMyWay.TS015_STOP_SPEED_KMH or 0.75)
        if stopped then
            run.stopSince = run.stopSince or nowMs
            if nowMs - run.stopSince >= (OuttaMyWay.TS015_STOP_CONFIRM_MS or 1000) then
                run.stopConfirmedAt = nowMs
                local anchorX, _, anchorZ = positionOf(run.vehicle)
                local anchorNode = getNode(run.vehicle)
                local forwardX, forwardZ = directionVector(anchorNode, 0, 1)
                local rightX, rightZ = directionVector(anchorNode, 1, 0)
                if anchorX == nil or forwardX == nil or rightX == nil then
                    self:fail("stop-anchor-unavailable", nowMs)
                    return
                end
                run.startX, run.startZ = anchorX, anchorZ
                run.forwardX, run.forwardZ = forwardX, forwardZ
                run.rightX, run.rightZ = rightX, rightZ
                local lateral = OuttaMyWay.TS015_LATERAL_OFFSET_M or 28.0
                local rearward = OuttaMyWay.TS015_EGRESS_REARWARD_M or 12.0
                local rejoinForward = OuttaMyWay.TS015_REJOIN_FORWARD_M or 6.0
                run.egressTargetX = anchorX - forwardX * rearward + rightX * run.sideSign * lateral
                run.egressTargetZ = anchorZ - forwardZ * rearward + rightZ * run.sideSign * lateral
                run.rejoinTargetX = anchorX + forwardX * rejoinForward
                run.rejoinTargetZ = anchorZ + forwardZ * rejoinForward
                OuttaMyWay.Logger:val(
                    "PROTOTYPE16 HOLD_CONFIRMED t=%.1fs yield=%s progress=%s moved=%s speed=%.2f jobActive=%s pairSeparation=%s stopAnchor=(%.2f,%.2f) egressTarget=(%.2f,%.2f) rejoinTarget=(%.2f,%.2f) lateral=%.1fm rearward=%.1fm rejoinForward=%.1fm progressControl=GIANTS_UNMODIFIED",
                    nowSeconds(), nameOf(run.vehicle), nameOf(run.progressVehicle),
                    moved ~= nil and string.format("%.2fm", moved) or "unknown",
                    state.actualSpeed or 0, tostring(state.active == true),
                    run.lastPairSeparation ~= nil and string.format("%.2fm", run.lastPairSeparation) or "unknown",
                    anchorX, anchorZ, run.egressTargetX, run.egressTargetZ, run.rejoinTargetX, run.rejoinTargetZ,
                    lateral, rearward, rejoinForward)
                self:logShadowPreEstimate(nowMs)
                self:setPhase("COMPACTING", "hold-effective", nowMs)
                self:requestCompact(nowMs)
            end
        else
            run.stopSince = nil
        end
        if phaseElapsed >= (OuttaMyWay.TS015_HOLD_EFFECT_TIMEOUT_MS or 10000) then
            self:fail("hold-effect-timeout", nowMs)
        end

    elseif run.phase == "COMPACTING" then
        self:requestCompact(nowMs)
        if fold.objects == 0 then
            self:fail("no-foldable-object", nowMs)
        else
            if run.foldMotionAt == nil and not fold.deployed then
                run.foldMotionAt = nowMs
                OuttaMyWay.Logger:val(
                    "PROTOTYPE16 TIMING_MARK t=%.1fs vehicle=%s mark=FIRST_FOLD_MOTION foldRange=%s..%s pairSeparation=%s",
                    nowSeconds(), nameOf(run.vehicle),
                    fold.minimum ~= nil and string.format("%.3f", fold.minimum) or "n/a",
                    fold.maximum ~= nil and string.format("%.3f", fold.maximum) or "n/a",
                    run.lastPairSeparation ~= nil and string.format("%.2fm", run.lastPairSeparation) or "unknown")
            end
            local readyThreshold = OuttaMyWay.TS015_EGRESS_READY_FOLD_ANIM_TIME or 0.15
            local egressReady = fold.minimum ~= nil and fold.minimum >= readyThreshold
            if egressReady then
                run.egressReadyAt = nowMs
                OuttaMyWay.Logger:val(
                    "PROTOTYPE16 EGRESS_READY_CANDIDATE t=%.1fs vehicle=%s foldRange=%.3f..%.3f threshold=%.3f sinceFoldRequest=%s pairSeparation=%s clearanceAuthority=false evidence=timing-candidate-only",
                    nowSeconds(), nameOf(run.vehicle), fold.minimum or -1, fold.maximum or -1,
                    readyThreshold, fmtSeconds(elapsedSeconds(run.foldRequestedAt, nowMs)),
                    run.lastPairSeparation ~= nil and string.format("%.2fm", run.lastPairSeparation) or "unknown")
                self:setPhase("EGRESS", "folding-retreat-overlap-candidate", nowMs)
            elseif phaseElapsed >= (OuttaMyWay.TS015_EGRESS_READY_TIMEOUT_MS or 12000) then
                self:fail("egress-ready-timeout", nowMs)
            end
        end

    elseif run.phase == "EGRESS" then
        self:requestCompact(nowMs)
        if fold.compact and run.fullCompactAt == nil then
            run.fullCompactAt = nowMs
            OuttaMyWay.Logger:val(
                "PROTOTYPE16 FULL_COMPACT_CONFIRMED t=%.1fs vehicle=%s phase=%s foldObjects=%d range=%.3f..%.3f sinceFoldRequest=%s pairSeparation=%s",
                nowSeconds(), nameOf(run.vehicle), tostring(run.phase), fold.objects,
                fold.minimum or -1, fold.maximum or -1,
                fmtSeconds(elapsedSeconds(run.foldRequestedAt, nowMs)),
                run.lastPairSeparation ~= nil and string.format("%.2fm", run.lastPairSeparation) or "unknown")
        end
        if run.foldRequestedAt ~= nil and not fold.compact
            and nowMs - run.foldRequestedAt >= (OuttaMyWay.TS015_FOLD_TIMEOUT_MS or 22000) then
            self:fail("compact-timeout-during-egress", nowMs)
        elseif run.targetReached == true then
            run.egressTargetAt = nowMs
            OuttaMyWay.Logger:val(
                "PROTOTYPE16 REFUGE_REACHED t=%.1fs yield=%s progress=%s pairSeparation=%s progressLongitudinal=%s fullCompact=%s action=hold-for-positive-passage",
                nowSeconds(), nameOf(run.vehicle), nameOf(run.progressVehicle),
                run.lastPairSeparation ~= nil and string.format("%.2fm", run.lastPairSeparation) or "unknown",
                run.lastProgressLongitudinal ~= nil and string.format("%.2fm", run.lastProgressLongitudinal) or "unknown",
                tostring(fold.compact))
            self:setPhase("SIDESTEP_HOLD", "egress-target-reached-await-passage", nowMs)
        elseif phaseElapsed >= (OuttaMyWay.TS015_DRIVE_TIMEOUT_MS or 45000) then
            self:fail("egress-timeout", nowMs)
        end

    elseif run.phase == "SIDESTEP_HOLD" then
        self:requestCompact(nowMs)
        if fold.compact and run.fullCompactAt == nil then
            run.fullCompactAt = nowMs
            OuttaMyWay.Logger:val(
                "PROTOTYPE16 FULL_COMPACT_CONFIRMED t=%.1fs vehicle=%s phase=%s foldObjects=%d range=%.3f..%.3f sinceFoldRequest=%s",
                nowSeconds(), nameOf(run.vehicle), tostring(run.phase), fold.objects,
                fold.minimum or -1, fold.maximum or -1,
                fmtSeconds(elapsedSeconds(run.foldRequestedAt, nowMs)))
        end
        if run.passageConfirmedAt ~= nil and fold.compact then
            run.dwellSince = run.dwellSince or nowMs
            if nowMs - run.dwellSince >= (OuttaMyWay.TS015_POST_PASS_DWELL_MS or 1000) then
                run.rejoinStartedAt = nowMs
                self:setPhase("REJOIN", "positive-passage-confirmed", nowMs)
            end
        elseif phaseElapsed >= (OuttaMyWay.TS015_PASSAGE_TIMEOUT_MS or 90000) then
            self:fail("passage-timeout", nowMs)
        elseif run.foldRequestedAt ~= nil and not fold.compact
            and nowMs - run.foldRequestedAt >= (OuttaMyWay.TS015_FOLD_TIMEOUT_MS or 22000) then
            self:fail("compact-timeout-at-refuge", nowMs)
        end

    elseif run.phase == "REJOIN" then
        if run.targetReached == true then
            run.rejoinTargetAt = nowMs
            self:setPhase("UNFOLDING", "rejoin-target-reached-after-passage", nowMs)
            self:requestDeploy(nowMs)
        elseif phaseElapsed >= (OuttaMyWay.TS015_DRIVE_TIMEOUT_MS or 45000) then
            self:fail("rejoin-timeout", nowMs)
        end

    elseif run.phase == "RESTORE_COMPACT" then
        self:requestCompact(nowMs)
        if fold.compact or fold.objects == 0 or phaseElapsed >= 3000 then
            self:setPhase("UNFOLDING", "safe-cancel-restoration", nowMs)
            self:requestDeploy(nowMs)
        end

    elseif run.phase == "UNFOLDING" then
        self:requestDeploy(nowMs)
        if fold.deployed then
            run.deployedAt = run.deployedAt or nowMs
            self:releaseToGiants(run.cancelRequested and "cancel-restored" or "two-worker-passage-complete", nowMs)
        elseif fold.objects == 0 then
            self:releaseToGiants("no-foldable-object-during-restore", nowMs)
        elseif phaseElapsed >= (OuttaMyWay.TS015_FOLD_TIMEOUT_MS or 22000) then
            self:fail("deploy-timeout", nowMs)
        end

    elseif run.phase == "OBSERVE_HANDOFF" then
        if phaseElapsed >= (OuttaMyWay.TS015_HANDOFF_OBSERVE_MS or 20000) then
            self:clearRun("handoff-observation-complete", nowMs)
        end

    elseif run.phase == "FAILED_HELD" then
        self:requestCompact(nowMs)
    end
end

function Controller:update(dt)
    if self.enabled == nil then self:init() end
    if self.enabled ~= true then return end

    self.elapsedMs = self.elapsedMs + dt
    local interval = OuttaMyWay.TS015_INTERVAL_MS or 100
    if self.elapsedMs < interval then return end
    self.elapsedMs = self.elapsedMs % interval

    local nowMs = g_time or 0
    if not self:installDriveHook() then
        if nowMs - (self.lastHookWarningMs or 0) >= 5000 then
            self.lastHookWarningMs = nowMs
            OuttaMyWay.Logger:warning("CTL", "PROTOTYPE16 waiting for AIVehicleUtil.driveToPoint")
        end
        return
    end

    if self.run ~= nil then
        self:updateRun(nowMs)
    elseif self.armedSide ~= nil then
        local states = activeStates()
        if #states == 2 then
            local yieldState, progressState, reason = findFixtureStates(states)
            if yieldState ~= nil and progressState ~= nil then
                self:startRun(yieldState, progressState, self.armedSide, nowMs)
            else
                OuttaMyWay.Logger:error("VAL",
                    "PROTOTYPE16 ARM_CANCELLED t=%.1fs reason=%s activeWorkers=%d fixture=Condor+Patriot-required",
                    nowSeconds(), tostring(reason), #states)
                self.armedSide = nil
            end
        elseif #states > 2 then
            OuttaMyWay.Logger:error("VAL",
                "PROTOTYPE16 ARM_CANCELLED t=%.1fs reason=unexpected-active-workers count=%d",
                nowSeconds(), #states)
            self.armedSide = nil
        end
    else
        OuttaMyWay.activeWaitCount = 0
        OuttaMyWay.priorityName = ""
    end

    if nowMs - (self.lastHeartbeatMs or 0) >= (OuttaMyWay.TS015_HEARTBEAT_MS or 15000) then
        self.lastHeartbeatMs = nowMs
        OuttaMyWay.Logger:val(
            "PROTOTYPE16 HEARTBEAT t=%.1fs activeWorkers=%d armed=%s run=%s phase=%s passage=%s exclusive=true progressHold=false",
            nowSeconds(), #activeStates(), tostring(self.armedSide), tostring(self.run ~= nil),
            self.run ~= nil and tostring(self.run.phase) or "IDLE",
            self.run ~= nil and tostring(self.run.passageConfirmedAt ~= nil) or "false")
    end
end

function Controller:clear()
    local nowMs = g_time or 0
    if self.run ~= nil then
        local gate = OuttaMyWay.TrafficPermissionGate
        if gate ~= nil and gate.releaseHold ~= nil then gate:releaseHold(self.run.vehicle) end
        if OuttaMyWay.setParkedFoldState ~= nil then OuttaMyWay:setParkedFoldState(self.run.vehicle, false) end
        if OuttaMyWay.setBackoutRaisedState ~= nil then OuttaMyWay:setBackoutRaisedState(self.run.vehicle, false) end
        if OuttaMyWay.setParkedWorkState ~= nil then OuttaMyWay:setParkedWorkState(self.run.vehicle, false) end
        OuttaMyWay.Logger:warning("CTL",
            "PROTOTYPE16 CLEAR t=%.1fs vehicle=%s phase=%s restoration=requested-not-confirmed",
            nowSeconds(), nameOf(self.run.vehicle), tostring(self.run.phase))
    end
    self.armedSide = nil
    self.run = nil
    self.elapsedMs = 0
    self.lastHeartbeatMs = nowMs
    OuttaMyWay.activeWaitCount = 0
    OuttaMyWay.priorityName = ""
end
