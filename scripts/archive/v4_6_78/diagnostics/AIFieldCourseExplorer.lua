-- FS25_OuttaMyWay v4.1.3.0
-- Observer-only timeline explorer for the native GIANTS AIFieldCourse cursor.
-- It never changes steering, speed, implements, jobs or course state.

OuttaMyWay.AIFieldCourseExplorer = OuttaMyWay.AIFieldCourseExplorer or {}
local Explorer = OuttaMyWay.AIFieldCourseExplorer

local function nowMs()
    return g_time or 0
end

local function vehicleName(vehicle)
    if vehicle ~= nil and vehicle.getName ~= nil then
        local ok, name = pcall(vehicle.getName, vehicle)
        if ok and name ~= nil and name ~= "" then return name end
    end
    return "AI vehicle"
end

local function className(value)
    if value == nil then return "nil" end
    if type(value) == "table" then
        if value.className ~= nil then return tostring(value.className) end
        if type(value.class) == "table" and value.class.className ~= nil then
            return tostring(value.class.className)
        end
    end
    return tostring(value)
end

local function getActivityFlags(vehicle)
    if vehicle == nil or vehicle.isDeleted == true then return false, false, false end

    local fieldActive = false
    local aiActive = false
    local spec = vehicle.spec_aiFieldWorker

    if spec ~= nil and spec.isActive == true then fieldActive = true end

    if vehicle.getIsFieldWorkActive ~= nil then
        local ok, active = pcall(vehicle.getIsFieldWorkActive, vehicle)
        if ok and active == true then fieldActive = true end
    end

    if vehicle.getIsAIActive ~= nil then
        local ok, active = pcall(vehicle.getIsAIActive, vehicle)
        if ok and active == true then aiActive = true end
    end

    return fieldActive or aiActive, fieldActive, aiActive
end

local function appendStrategies(candidates, spec, source)
    if type(spec) ~= "table" or type(spec.driveStrategies) ~= "table" then return end
    for index, strategy in pairs(spec.driveStrategies) do
        candidates[#candidates + 1] = {
            strategy = strategy,
            source = string.format("%s.driveStrategies[%s]", source, tostring(index))
        }
    end
end

local function findFieldCourseStrategy(vehicle)
    local candidates = {}
    appendStrategies(candidates, vehicle.spec_aiVehicle, "spec_aiVehicle")
    appendStrategies(candidates, vehicle.spec_aiFieldWorker, "spec_aiFieldWorker")
    appendStrategies(candidates, vehicle, "vehicle")

    for _, candidate in ipairs(candidates) do
        local strategy = candidate.strategy
        local name = className(strategy)
        if strategy ~= nil and (strategy.aiFieldCourse ~= nil or string.find(name, "FieldCourse", 1, true) ~= nil) then
            return strategy, candidate.source
        end
    end
    return nil, #candidates > 0 and ("searched=" .. #candidates) or "no strategy arrays"
end

local function callReturns(object, methodName)
    if object == nil then return {available=false, ok=false, values={}} end
    local fn = object[methodName]
    if type(fn) ~= "function" then return {available=false, ok=false, values={}} end

    local ok, r1,r2,r3,r4,r5,r6,r7,r8,r9,r10 = pcall(fn, object)
    if not ok then
        return {available=true, ok=false, error=tostring(r1), values={}}
    end
    return {available=true, ok=true, values={r1,r2,r3,r4,r5,r6,r7,r8,r9,r10}}
end

local function safeWorldPosition(vehicle)
    local node = vehicle.rootNode
    if vehicle.getAISteeringNode ~= nil then
        local ok, candidate = pcall(vehicle.getAISteeringNode, vehicle)
        if ok and candidate ~= nil and candidate ~= 0 then node = candidate end
    end
    if node == nil or node == 0 then return nil,nil,nil end
    return getWorldTranslation(node)
end

local function safeVehicleHeading(vehicle)
    local node = vehicle.rootNode
    if vehicle.getAISteeringNode ~= nil then
        local ok, candidate = pcall(vehicle.getAISteeringNode, vehicle)
        if ok and candidate ~= nil and candidate ~= 0 then node = candidate end
    end
    if node == nil or node == 0 then return nil end
    local dx, _, dz = localDirectionToWorld(node, 0, 0, 1)
    if type(dx) ~= "number" or type(dz) ~= "number" then return nil end
    return math.deg(math.atan2(dx, dz))
end

local function valueText(value)
    if value == nil then return "nil" end
    if type(value) == "number" then return string.format("%.4f", value) end
    return tostring(value)
end

local function tupleText(result, count)
    if result == nil or result.available ~= true then return "UNAVAILABLE" end
    if result.ok ~= true then return "ERROR:" .. tostring(result.error) end
    local parts = {}
    for index=1,(count or 10) do
        parts[#parts+1] = string.format("r%d=%s", index, valueText(result.values[index]))
    end
    return table.concat(parts, " ")
end

local function quantize(value, quantum)
    if type(value) ~= "number" then return nil end
    quantum = quantum or 1
    return math.floor(value / quantum + 0.5) * quantum
end

local function normalizeAngle(degrees)
    while degrees > 180 do degrees = degrees - 360 end
    while degrees < -180 do degrees = degrees + 360 end
    return degrees
end

local function bearingDegrees(x1, z1, x2, z2)
    if type(x1) ~= "number" or type(z1) ~= "number" or type(x2) ~= "number" or type(z2) ~= "number" then
        return nil
    end
    return math.deg(math.atan2(x2-x1, z2-z1))
end

local function speedState(speedKmh)
    if speedKmh < 0.25 then return "STOPPED" end
    if speedKmh < 2.0 then return "CREEPING" end
    return "MOVING"
end

local function activeIsTurn(snapshot)
    return snapshot ~= nil and snapshot.active ~= nil and snapshot.active.ok == true
        and snapshot.active.values[1] == true
end

local function activeProgress(snapshot)
    if snapshot == nil or snapshot.active == nil or snapshot.active.ok ~= true then return nil end
    return tonumber(snapshot.active.values[3])
end

local function signWithDeadzone(value, deadzone)
    if type(value) ~= "number" then return 0 end
    deadzone = deadzone or 0
    if value > deadzone then return 1 end
    if value < -deadzone then return -1 end
    return 0
end

local function progressBucket(active)
    if active == nil or active.ok ~= true then return nil,nil end
    local progress = active.values[3]
    if type(progress) ~= "number" then return nil,nil end
    local isTurn = active.values[1] == true
    local divisions = isTurn and 20 or 10
    return math.max(0, math.min(divisions, math.floor(progress * divisions + 0.0001))), divisions
end

local function structuralSignature(snapshot)
    local a = snapshot.active and snapshot.active.values or {}
    local n = snapshot.next and snapshot.next.values or {}
    local s = snapshot.sideOffset and snapshot.sideOffset.values or {}
    local c = snapshot.cornerCutOut and snapshot.cornerCutOut.values or {}
    return table.concat({
        tostring(snapshot.strategy ~= nil),
        tostring(snapshot.aiFieldCourse ~= nil),
        tostring(snapshot.fieldActive),
        tostring(snapshot.aiActive),
        tostring(snapshot.fieldDetectionInProgress),
        tostring(snapshot.isBlocked),
        tostring(snapshot.hasStaticCollision),
        tostring(snapshot.lastSegmentIsTurn),
        tostring(snapshot.lastMovingDirection),
        tostring(snapshot.nextSegmentTurnSide),
        tostring(snapshot.lastSegmentTurnSide),
        tostring(snapshot.lastContinueWorkState),
        tostring(snapshot.active and snapshot.active.available),
        tostring(snapshot.active and snapshot.active.ok),
        tostring(a[1]), tostring(a[2]), valueText(a[4]), valueText(a[6]),
        tostring(snapshot.next and snapshot.next.available),
        tostring(snapshot.next and snapshot.next.ok),
        tostring(n[1]), valueText(n[2]), valueText(n[3]), valueText(n[4]),
        valueText(s[1]), valueText(c[1])
    }, "|")
end

local function targetDistance(snapshot)
    local vehiclePos = snapshot.lastVehiclePosition or {}
    local targetPos = snapshot.lastTargetPosition or {}
    if type(vehiclePos[1]) ~= "number" or type(vehiclePos[3]) ~= "number"
        or type(targetPos[1]) ~= "number" or type(targetPos[3]) ~= "number" then
        return nil
    end
    local dx = targetPos[1]-vehiclePos[1]
    local dz = targetPos[3]-vehiclePos[3]
    return math.sqrt(dx*dx+dz*dz)
end

function Explorer:init()
    self.sampleElapsed = 0
    self.startedAt = self.startedAt or nowMs()
    self.states = self.states or {}
    self.pairStates = self.pairStates or {}
    self.lastScanReportAt = self.lastScanReportAt or 0
    self.startedMessagePrinted = self.startedMessagePrinted or false
end

function Explorer:buildSnapshot(vehicle)
    local strategy, source = findFieldCourseStrategy(vehicle)
    local x,y,z = safeWorldPosition(vehicle)
    local speedKmh = math.abs((vehicle.lastSpeedReal or 0) * 3600)
    local anyActive, fieldActive, aiActive = getActivityFlags(vehicle)

    local snapshot = {
        vehicle=vehicle,
        name=vehicleName(vehicle),
        strategy=strategy,
        strategySource=source,
        strategyClass=className(strategy),
        x=x,y=y,z=z,
        vehicleHeading=safeVehicleHeading(vehicle),
        speedKmh=speedKmh,
        speedState=speedState(speedKmh),
        anyActive=anyActive,
        fieldActive=fieldActive,
        aiActive=aiActive,
        elapsed=(nowMs()-(self.startedAt or nowMs()))/1000
    }
    if strategy == nil then return snapshot end

    snapshot.fieldDetectionInProgress = strategy.fieldDetectionInProgress
    snapshot.isBlocked = strategy.isBlocked
    snapshot.hasStaticCollision = strategy.hasStaticCollision
    snapshot.collisionDistance = strategy.collisionDistance
    snapshot.lastSegmentIsTurn = strategy.lastSegmentIsTurn
    snapshot.lastMovingDirection = strategy.lastMovingDirection
    snapshot.nextSegmentTurnSide = strategy.nextSegmentTurnSide
    snapshot.lastSegmentTurnSide = strategy.lastSegmentTurnSide
    snapshot.lastContinueWorkState = strategy.lastContinueWorkState
    snapshot.lastVehiclePosition = strategy.lastVehiclePosition
    snapshot.lastTargetPosition = strategy.lastTargetPosition
    snapshot.aiFieldCourse = strategy.aiFieldCourse

    local course = snapshot.aiFieldCourse
    snapshot.active = callReturns(course, "getActiveSegmentData")
    snapshot.next = callReturns(course, "getNextSegmentData")
    snapshot.sideOffset = callReturns(course, "getActiveSegmentSideOffset")
    snapshot.cornerCutOut = callReturns(course, "getIsCornerCutOutActive")

    local vehiclePos = snapshot.lastVehiclePosition or {}
    local targetPos = snapshot.lastTargetPosition or {}
    snapshot.targetBearing = bearingDegrees(vehiclePos[1], vehiclePos[3], targetPos[1], targetPos[3])
    snapshot.targetDistance = targetDistance(snapshot)
    if type(snapshot.vehicleHeading) == "number" and type(snapshot.targetBearing) == "number" then
        snapshot.targetRelativeBearing = normalizeAngle(snapshot.targetBearing-snapshot.vehicleHeading)
    end
    snapshot.progressBucket, snapshot.progressDivisions = progressBucket(snapshot.active)
    snapshot.structuralSignature = structuralSignature(snapshot)
    return snapshot
end

function Explorer:logAttach(snapshot)
    print(string.format(
        "Info: [FS25_OuttaMyWay] EXPLORER ATTACH t=%.1fs vehicle=%s source=%s class=%s course=%s fieldActive=%s aiActive=%s",
        snapshot.elapsed, snapshot.name, tostring(snapshot.strategySource), tostring(snapshot.strategyClass),
        tostring(snapshot.aiFieldCourse ~= nil), tostring(snapshot.fieldActive), tostring(snapshot.aiActive)))
    print(string.format("Info: [FS25_OuttaMyWay] EXPLORER NATIVE ACTIVE %s", tupleText(snapshot.active, 10)))
    print(string.format("Info: [FS25_OuttaMyWay] EXPLORER NATIVE NEXT %s", tupleText(snapshot.next, 10)))
end

function Explorer:logStructure(snapshot, previous)
    previous.eventNumber = (previous.eventNumber or 0) + 1
    print(string.format(
        "Info: [FS25_OuttaMyWay] EXPLORER STATE event=%d t=%.1fs vehicle=%s speed=%s/%.1f blocked=%s turn=%s moveDir=%s nextSide=%s heading=%s targetBearing=%s targetRel=%s targetDistance=%s",
        previous.eventNumber, snapshot.elapsed, snapshot.name, snapshot.speedState, snapshot.speedKmh,
        tostring(snapshot.isBlocked), tostring(snapshot.lastSegmentIsTurn),
        tostring(snapshot.lastMovingDirection), tostring(snapshot.nextSegmentTurnSide),
        valueText(snapshot.vehicleHeading), valueText(snapshot.targetBearing),
        valueText(snapshot.targetRelativeBearing), valueText(snapshot.targetDistance)))
    print(string.format("Info: [FS25_OuttaMyWay] EXPLORER NATIVE ACTIVE %s", tupleText(snapshot.active, 10)))
    print(string.format("Info: [FS25_OuttaMyWay] EXPLORER NATIVE NEXT %s", tupleText(snapshot.next, 10)))
    print(string.format("Info: [FS25_OuttaMyWay] EXPLORER NATIVE AUX sideOffset={%s} cornerCutOut={%s}",
        tupleText(snapshot.sideOffset, 4), tupleText(snapshot.cornerCutOut, 4)))
end

function Explorer:logProgress(snapshot)
    local a = snapshot.active and snapshot.active.values or {}
    print(string.format(
        "Info: [FS25_OuttaMyWay] EXPLORER PROGRESS t=%.1fs vehicle=%s percent=%.0f raw=%s isTurn=%s segmentLength=%s remainingMetric=%s speed=%.1f",
        snapshot.elapsed, snapshot.name, ((snapshot.progressBucket or 0) / (snapshot.progressDivisions or 10)) * 100,
        valueText(a[3]), tostring(a[1]), valueText(a[4]), valueText(a[6]), snapshot.speedKmh))
end

function Explorer:logTarget(snapshot, previousBearing)
    local vehiclePos = snapshot.lastVehiclePosition or {}
    local targetPos = snapshot.lastTargetPosition or {}
    local delta = nil
    if type(previousBearing) == "number" and type(snapshot.targetBearing) == "number" then
        delta = normalizeAngle(snapshot.targetBearing-previousBearing)
    end
    print(string.format(
        "Info: [FS25_OuttaMyWay] EXPLORER TARGET t=%.1fs vehicle=%s heading=%s bearing=%s relative=%s delta=%s distance=%s speed=%.1f vehicle=(%s,%s) target=(%s,%s)",
        snapshot.elapsed, snapshot.name, valueText(snapshot.vehicleHeading), valueText(snapshot.targetBearing),
        valueText(snapshot.targetRelativeBearing), valueText(delta), valueText(snapshot.targetDistance), snapshot.speedKmh,
        valueText(vehiclePos[1]), valueText(vehiclePos[3]), valueText(targetPos[1]), valueText(targetPos[3])))
end

function Explorer:logPhase(snapshot, state, phase, reason)
    state.phaseEventNumber = (state.phaseEventNumber or 0) + 1
    local a = snapshot.active and snapshot.active.values or {}
    local vehiclePos = snapshot.lastVehiclePosition or {}
    local targetPos = snapshot.lastTargetPosition or {}
    local horizon = OuttaMyWay.AI_EXPLORER_PROJECTION_SECONDS or 3.0
    local speedMps = (snapshot.speedKmh or 0) / 3.6
    local projectionDistance = math.max(5.0, math.min(35.0, speedMps * horizon))
    local projectedX, projectedZ = nil, nil
    if type(snapshot.targetBearing) == "number" and type(vehiclePos[1]) == "number" and type(vehiclePos[3]) == "number" then
        local radians = math.rad(snapshot.targetBearing)
        projectedX = vehiclePos[1] + math.sin(radians) * projectionDistance
        projectedZ = vehiclePos[3] + math.cos(radians) * projectionDistance
    end
    print(string.format(
        "Info: [FS25_OuttaMyWay] EXPLORER PHASE event=%d t=%.1fs vehicle=%s phase=%s reason=%s isTurn=%s progress=%s speed=%.1f heading=%s targetBearing=%s targetRel=%s targetDistance=%s projection=%.1fm projected=(%s,%s)",
        state.phaseEventNumber, snapshot.elapsed, snapshot.name, phase, tostring(reason),
        tostring(a[1]), valueText(a[3]), snapshot.speedKmh, valueText(snapshot.vehicleHeading),
        valueText(snapshot.targetBearing), valueText(snapshot.targetRelativeBearing),
        valueText(snapshot.targetDistance), projectionDistance, valueText(projectedX), valueText(projectedZ)))
    print(string.format(
        "Info: [FS25_OuttaMyWay] EXPLORER PHASE HISTORY vehicle=%s samples=%d relMin=%s relMax=%s relStart=%s relNow=%s",
        snapshot.name, #(state.targetHistory or {}), valueText(state.historyRelMin),
        valueText(state.historyRelMax), valueText(state.historyRelStart), valueText(snapshot.targetRelativeBearing)))
end

function Explorer:updateTargetHistory(snapshot, state)
    if type(snapshot.targetRelativeBearing) ~= "number" then return end
    state.targetHistory = state.targetHistory or {}
    local history = state.targetHistory
    history[#history+1] = {
        t=snapshot.elapsed,
        relative=snapshot.targetRelativeBearing,
        bearing=snapshot.targetBearing,
        x=snapshot.x, z=snapshot.z
    }
    local window = OuttaMyWay.AI_EXPLORER_TARGET_HISTORY_SECONDS or 4.0
    while #history > 0 and snapshot.elapsed-(history[1].t or snapshot.elapsed) > window do
        table.remove(history, 1)
    end
    local minRel, maxRel = nil, nil
    for _, sample in ipairs(history) do
        local value = sample.relative
        if type(value) == "number" then
            minRel = minRel == nil and value or math.min(minRel, value)
            maxRel = maxRel == nil and value or math.max(maxRel, value)
        end
    end
    state.historyRelMin = minRel
    state.historyRelMax = maxRel
    state.historyRelStart = history[1] and history[1].relative or snapshot.targetRelativeBearing
end

function Explorer:detectTargetPhase(snapshot, state)
    self:updateTargetHistory(snapshot, state)

    local relative = snapshot.targetRelativeBearing
    if type(relative) ~= "number" then return end
    local isTurn = activeIsTurn(snapshot)
    local startAngle = OuttaMyWay.AI_EXPLORER_TURN_START_ANGLE_DEG or 12
    local apexAngle = OuttaMyWay.AI_EXPLORER_TURN_APEX_ANGLE_DEG or 3
    local stableAngle = OuttaMyWay.AI_EXPLORER_TURN_COMPLETE_ANGLE_DEG or 5
    local previousRelative = state.lastRelativeBearing
    local previousIsTurn = state.lastActiveIsTurn
    local currentSign = signWithDeadzone(relative, apexAngle)
    local previousSign = signWithDeadzone(previousRelative, apexAngle)

    if state.turnPhase == nil or state.turnPhase == "STRAIGHT" then
        local nativeTurnStarted = isTurn and previousIsTurn ~= true
        local targetSwingStarted = math.abs(relative) >= startAngle
            and state.historyRelMin ~= nil and state.historyRelMax ~= nil
            and (state.historyRelMax-state.historyRelMin) >= startAngle * 0.75
        if nativeTurnStarted or targetSwingStarted then
            state.turnPhase = "TURNING"
            state.turnStartSign = signWithDeadzone(relative, apexAngle)
            state.turnStartedAt = snapshot.elapsed
            state.apexLogged = false
            state.stableSince = nil
            self:logPhase(snapshot, state, "TURN_START", nativeTurnStarted and "native turn flag" or "steering target swing")
        end
    elseif state.turnPhase == "TURNING" then
        local crossedZero = previousSign ~= 0 and currentSign ~= 0 and previousSign ~= currentSign
        local nearCentre = math.abs(relative) <= apexAngle and math.abs(previousRelative or relative) > apexAngle
        if state.apexLogged ~= true and (crossedZero or nearCentre) then
            state.apexLogged = true
            self:logPhase(snapshot, state, "TURN_APEX", crossedZero and "target crossed vehicle heading" or "target reached centreline")
        end

        local nativeTurnFinished = previousIsTurn == true and isTurn ~= true
        local targetStable = math.abs(relative) <= stableAngle
        if targetStable then
            state.stableSince = state.stableSince or snapshot.elapsed
        else
            state.stableSince = nil
        end
        local stableFor = state.stableSince ~= nil and snapshot.elapsed-state.stableSince or 0
        if nativeTurnFinished or stableFor >= (OuttaMyWay.AI_EXPLORER_TURN_STABLE_SECONDS or 1.5) then
            self:logPhase(snapshot, state, "TURN_COMPLETE", nativeTurnFinished and "native straight segment" or "target bearing stabilised")
            state.turnPhase = "STRAIGHT"
            state.turnStartSign = nil
            state.turnStartedAt = nil
            state.apexLogged = false
            state.stableSince = nil
        end
    end

    state.lastRelativeBearing = relative
    state.lastActiveIsTurn = isTurn
end

function Explorer:processSnapshot(snapshot)
    local state = self.states[snapshot.vehicle]
    if state == nil then
        state = {}
        self.states[snapshot.vehicle] = state
    end

    if snapshot.strategy == nil and snapshot.anyActive ~= true then return end

    if state.attached ~= true and snapshot.strategy ~= nil then
        self:logAttach(snapshot)
        state.attached = true
        state.structuralSignature = snapshot.structuralSignature
        state.progressBucket = snapshot.progressBucket
        state.speedState = snapshot.speedState
        state.targetBearing = snapshot.targetBearing
        state.targetBearingBucket = quantize(snapshot.targetBearing, OuttaMyWay.AI_EXPLORER_TARGET_BEARING_STEP_DEG or 15)
        state.eventNumber = 0
        state.phaseEventNumber = 0
        state.turnPhase = activeIsTurn(snapshot) and "TURNING" or "STRAIGHT"
        state.lastActiveIsTurn = activeIsTurn(snapshot)
        state.lastRelativeBearing = snapshot.targetRelativeBearing
        state.targetHistory = {}
        self:updateTargetHistory(snapshot, state)
        return
    end

    if state.attached == true and snapshot.strategy == nil then
        print(string.format("Info: [FS25_OuttaMyWay] EXPLORER DETACH t=%.1fs vehicle=%s", snapshot.elapsed, snapshot.name))
        self.states[snapshot.vehicle] = nil
        return
    end

    if snapshot.strategy == nil then return end

    self:detectTargetPhase(snapshot, state)

    if state.structuralSignature ~= snapshot.structuralSignature or state.speedState ~= snapshot.speedState then
        self:logStructure(snapshot, state)
        state.structuralSignature = snapshot.structuralSignature
        state.speedState = snapshot.speedState
    end

    if snapshot.progressBucket ~= nil and state.progressBucket ~= snapshot.progressBucket then
        self:logProgress(snapshot)
        state.progressBucket = snapshot.progressBucket
    end

    local bearingStep = OuttaMyWay.AI_EXPLORER_TARGET_BEARING_STEP_DEG or 15
    local bearingBucket = quantize(snapshot.targetBearing, bearingStep)
    if bearingBucket ~= nil and state.targetBearingBucket ~= nil and bearingBucket ~= state.targetBearingBucket then
        self:logTarget(snapshot, state.targetBearing)
        state.targetBearingBucket = bearingBucket
    end
    state.targetBearing = snapshot.targetBearing
end

local function pairKey(a, b)
    local ka, kb = tostring(a.vehicle), tostring(b.vehicle)
    if ka < kb then return ka .. "|" .. kb end
    return kb .. "|" .. ka
end

function Explorer:processPairs(snapshots)
    for i=1,#snapshots-1 do
        local a = snapshots[i]
        for j=i+1,#snapshots do
            local b = snapshots[j]
            if type(a.x) == "number" and type(a.z) == "number" and type(b.x) == "number" and type(b.z) == "number" then
                local dx, dz = b.x-a.x, b.z-a.z
                local distance = math.sqrt(dx*dx+dz*dz)
                local key = pairKey(a,b)
                local state = self.pairStates[key] or {}
                self.pairStates[key] = state
                local elapsed = math.max(a.elapsed or 0, b.elapsed or 0)
                local closingRate = nil
                if type(state.distance) == "number" and type(state.elapsed) == "number" and elapsed > state.elapsed then
                    closingRate = (state.distance-distance)/(elapsed-state.elapsed)
                end
                local step = distance <= 40 and 5 or 10
                local bucket = math.floor(distance/step)
                local shouldLog = distance <= 100 and (state.bucket ~= bucket or state.step ~= step)
                if shouldLog then
                    local aa = a.active and a.active.values or {}
                    local ba = b.active and b.active.values or {}
                    print(string.format(
                        "Info: [FS25_OuttaMyWay] EXPLORER PAIR t=%.1fs a=%s b=%s distance=%.2f closing=%.2f aSpeed=%.1f bSpeed=%.1f aTurn=%s aProgress=%s aLen=%s bTurn=%s bProgress=%s bLen=%s aBlocked=%s bBlocked=%s",
                        elapsed, a.name, b.name, distance, closingRate or 0, a.speedKmh, b.speedKmh,
                        tostring(aa[1]), valueText(aa[3]), valueText(aa[4]),
                        tostring(ba[1]), valueText(ba[3]), valueText(ba[4]),
                        tostring(a.isBlocked), tostring(b.isBlocked)))
                    state.bucket, state.step = bucket, step
                end
                state.distance, state.elapsed = distance, elapsed
            end
        end
    end
end

function Explorer:update(dt)
    self.sampleElapsed = (self.sampleElapsed or 0) + dt
    local interval = OuttaMyWay.AI_EXPLORER_INTERVAL_MS or 250
    if self.sampleElapsed < interval then return end
    self.sampleElapsed = self.sampleElapsed % interval

    local mission = g_currentMission
    if mission == nil then return end

    if self.startedMessagePrinted ~= true then
        print("Info: [FS25_OuttaMyWay] AI FIELD COURSE EXPLORER 4.1.3 ACTIVE: steering-target phase timeline, observer only")
        self.startedMessagePrinted = true
    end

    local vehicles = mission.vehicles
    if type(vehicles) ~= "table" and mission.vehicleSystem ~= nil then
        vehicles = mission.vehicleSystem.vehicles
    end
    if type(vehicles) ~= "table" then return end

    local scanned, activeCount, strategyCount, courseCount = 0,0,0,0
    local activeSnapshots = {}
    for _, vehicle in pairs(vehicles) do
        if vehicle ~= nil and vehicle.isDeleted ~= true then
            scanned = scanned + 1
            local snapshot = self:buildSnapshot(vehicle)
            if snapshot.anyActive == true then activeCount = activeCount + 1 end
            if snapshot.strategy ~= nil then strategyCount = strategyCount + 1 end
            if snapshot.aiFieldCourse ~= nil then
                courseCount = courseCount + 1
                activeSnapshots[#activeSnapshots+1] = snapshot
            end
            self:processSnapshot(snapshot)
        end
    end

    self:processPairs(activeSnapshots)

    local now = nowMs()
    if now-(self.lastScanReportAt or 0) >= (OuttaMyWay.AI_EXPLORER_SCAN_HEARTBEAT_MS or 15000) then
        print(string.format(
            "Info: [FS25_OuttaMyWay] EXPLORER SCAN t=%.1fs vehicles=%d activeFlags=%d strategies=%d fieldCourses=%d",
            (now-(self.startedAt or now))/1000, scanned, activeCount, strategyCount, courseCount))
        self.lastScanReportAt = now
    end
end

Explorer:init()
