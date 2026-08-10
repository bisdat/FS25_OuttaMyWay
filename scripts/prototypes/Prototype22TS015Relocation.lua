-- TS015 bounded relocation/recovery capability donor. D-0140 retains this
-- owner-validated mechanical fixture beneath central Control. Its literal refuge
-- geometry, speed/configuration values and recovery choreography remain test
-- mechanism, not production Refuge/Decision policy. It publishes neutral fixture
-- and execution evidence; downstream Situation/diagnostics assign any legitimate
-- meaning.

OuttaMyWay.Prototype22TS015Relocation = {}
local Harness = OuttaMyWay.Prototype22TS015Relocation

local function logInfo(formatText, ...)
    local message = string.format(formatText, ...)
    if Logging ~= nil and type(Logging.info) == "function" then
        Logging.info("[FS25_OuttaMyWay][P22-TS015] %s", message)
    else
        print("[FS25_OuttaMyWay][P22-TS015] " .. message)
    end
end

local function logWarning(formatText, ...)
    local message = string.format(formatText, ...)
    if Logging ~= nil and type(Logging.warning) == "function" then
        Logging.warning("[FS25_OuttaMyWay][P22-TS015] %s", message)
    else
        print("[FS25_OuttaMyWay][P22-TS015][WARN] " .. message)
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

local function currentJobToken(vehicle)
    local job = OuttaMyWay.LiveAIJobEvidence.currentJob(vehicle)
    return OuttaMyWay.LiveAIJobEvidence.jobToken(job)
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
    local length = math.sqrt(dx * dx + dz * dz)
    if length <= 0.0001 then return nil end
    return {node=node, x=x, y=y, z=z, dx=dx / length, dz=dz / length}
end

local function distance(a, b)
    if a == nil or b == nil then return nil end
    local dx, dz = a.x - b.x, a.z - b.z
    return math.sqrt(dx * dx + dz * dz)
end

local function localDirectionToTarget(vehicle, targetX, targetZ)
    local p = pose(vehicle)
    if p == nil or type(worldDirectionToLocal) ~= "function" then return nil, nil, nil end
    local dx, dz = targetX - p.x, targetZ - p.z
    local remaining = math.sqrt(dx * dx + dz * dz)
    if remaining <= 0.0001 then return 0, 1, remaining end
    local ok, localX, _, localZ = pcall(worldDirectionToLocal, p.node, dx, 0, dz)
    if not ok then return nil, nil, remaining end
    local length = math.sqrt(localX * localX + localZ * localZ)
    if length <= 0.0001 then return nil, nil, remaining end
    return localX / length, localZ / length, remaining
end

local function headingDot(p, dx, dz)
    if p == nil or dx == nil or dz == nil then return nil end
    return p.dx * dx + p.dz * dz
end

local function activeVehicles()
    return OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(g_currentMission)
end

local function foldEvidenceText(evidence)
    if evidence == nil then return "fold=n/a" end
    return string.format("fold=%d deployed=%d transition=%d folded=%d unknown=%d range=%s..%s",
        evidence.foldableCount or 0, evidence.deployedCount or 0, evidence.transitionCount or 0,
        evidence.foldedCount or 0, evidence.unknownCount or 0,
        evidence.minimum ~= nil and string.format("%.3f", evidence.minimum) or "n/a",
        evidence.maximum ~= nil and string.format("%.3f", evidence.maximum) or "n/a")
end

local function fieldAt(x, z)
    if OuttaMyWay.LiveAIJobEvidence == nil or type(OuttaMyWay.LiveAIJobEvidence.fieldAtPosition) ~= "function" then return nil end
    return OuttaMyWay.LiveAIJobEvidence.fieldAtPosition(g_currentMission, x, z)
end

local function sameSourceField(x, z, sourceFieldId)
    local field = fieldAt(x, z)
    return field ~= nil and field.resolved == true and field.sourceFieldId == sourceFieldId, field
end

local function qualifyTarget(sourceFieldId, x, z)
    local radius = OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_FIT_SAMPLE_RADIUS_M or 8.0
    local count = math.max(4, math.floor(OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_FIT_SAMPLE_COUNT or 12))
    local matched = 0
    local required = count + 1
    local centerMatch = sameSourceField(x, z, sourceFieldId)
    if centerMatch then matched = matched + 1 end
    for index = 1, count do
        local angle = (index - 1) * (math.pi * 2 / count)
        local sx = x + math.cos(angle) * radius
        local sz = z + math.sin(angle) * radius
        if sameSourceField(sx, sz, sourceFieldId) then matched = matched + 1 end
    end
    return {
        qualified = matched == required,
        matched = matched,
        required = required,
        radius = radius
    }
end

local function selectFixtureTarget(run)
    local yieldPose = pose(run.vehicle)
    local progressPose = pose(run.progressVehicle)
    if yieldPose == nil then return nil, "yield-pose-unavailable" end
    local source = fieldAt(yieldPose.x, yieldPose.z)
    if source == nil or source.resolved ~= true or source.sourceFieldId == nil or source.sourceFieldId == 0 then
        return nil, "source-field-unresolved"
    end

    local forwardM = OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_FORWARD_M or 10.0
    local lateralM = OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_LATERAL_M or 30.0
    local candidates = {}
    for _, side in ipairs({1, -1}) do
        -- Right vector for heading (dx,dz) is (dz,-dx).
        local targetX = yieldPose.x + yieldPose.dx * forwardM + yieldPose.dz * lateralM * side
        local targetZ = yieldPose.z + yieldPose.dz * forwardM - yieldPose.dx * lateralM * side
        local fit = qualifyTarget(source.sourceFieldId, targetX, targetZ)
        local targetPose = {x=targetX, z=targetZ}
        local progressDistance = distance(targetPose, progressPose)
        candidates[#candidates + 1] = {
            side = side,
            targetX = targetX,
            targetZ = targetZ,
            fit = fit,
            progressDistance = progressDistance
        }
        logInfo("REFUGE_FIXTURE_CANDIDATE yield=%s progress=%s side=%+d target=(%.2f,%.2f) field=%s samples=%d/%d sampleRadius=%.1fm progressDistance=%s obstacleClearance=OPERATOR_OWNED productionAuthority=false",
            run.vehicleName, run.progressVehicleName, side, targetX, targetZ, tostring(source.sourceFieldId),
            fit.matched, fit.required, fit.radius,
            progressDistance and string.format("%.2fm", progressDistance) or "n/a")
    end

    run.refugeFixtureObservationSequence=(run.refugeFixtureObservationSequence or 0)+1
    run.refugeFixtureObservation={sequence=run.refugeFixtureObservationSequence,candidates=candidates,sourceFieldId=source.sourceFieldId,observedAt=tonumber(g_time) or 0}

    table.sort(candidates, function(a, b)
        if a.fit.qualified ~= b.fit.qualified then return a.fit.qualified end
        if a.fit.matched ~= b.fit.matched then return a.fit.matched > b.fit.matched end
        local ad = a.progressDistance or -math.huge
        local bd = b.progressDistance or -math.huge
        if math.abs(ad - bd) > 0.01 then return ad > bd end
        return a.side > b.side
    end)

    local selected = candidates[1]
    if selected == nil or selected.fit.qualified ~= true then
        return nil, "no-literal-refuge-target-has-complete-same-field-sample-support"
    end
    selected.sourceFieldId = source.sourceFieldId
    selected.forwardM = forwardM
    selected.lateralM = lateralM
    return selected
end

local function failHeld(probe, run, reason)
    probe.driveAuthority:clear(run.vehicle)
    probe.permissionGate:setHold(run.vehicle, "P22-TS015-FAIL-HELD")
    run.failureReason = tostring(reason or "unresolved")
    run.spatialResult = run.spatialResult == "PASS" and "PASS" or "UNRESOLVED"
    run.phase = "TS015_FAILED_HELD"
    if probe.configurationAuthority:getState(run.vehicle) ~= nil then
        local restoreOk, restoreReason = probe.configurationAuthority:requestRestore(run.vehicle)
        if restoreOk then
            run.phase = "TS015_FAILED_RESTORING"
            run.restoreRequestedAt = g_time or 0
        else
            logWarning("FAILURE_RESTORE_UNRESOLVED vehicle=%s reason=%s", run.vehicleName, tostring(restoreReason))
        end
    end
    logWarning("AUTONOMOUS_RELOCATE_HALTED vehicle=%s progress=%s phase=%s reason=%s authority=HOLD_RETAINED productionAuthority=false",
        run.vehicleName, run.progressVehicleName, tostring(run.phase), run.failureReason)
    probe:_setHud("OTM P22 — TS015 HELD", run.vehicleName .. " automation halted", "Failure safe: HOLD retained; use cancel/release manually")
end

function Harness.start(probe, selector, commitmentContext)
    if OuttaMyWay.PROTOTYPE_22_TS015_RELOCATE_ENABLED ~= true then
        return "P22 TS015 autonomous relocation disabled in config"
    end
    if probe.run ~= nil or probe.releasedMonitor ~= nil then
        return "P22 already active; allow current capability/observation to complete"
    end
    local vehicles = activeVehicles()
    if #vehicles ~= 2 then
        return string.format("P22 TS015 relocate requires exactly two active GIANTS AI field workers; found %d", #vehicles)
    end
    local vehicle, reason = probe:_resolveVehicle(selector)
    if vehicle == nil then return reason end
    local progress = vehicles[1] == vehicle and vehicles[2] or vehicles[1]
    if progress == nil or progress == vehicle then return "P22 TS015 progress participant unresolved" end

    local initialSpan, initialConfigKey, initialProfileId = probe:_representedSpan(vehicle)
    if initialSpan == nil then
        return "P22 TS015 relocate requires current represented plan-view span; wait for passive observation then retry"
    end
    local configEvidence = probe.configurationAuthority:getEvidence(vehicle)
    if configEvidence.foldableCount == 0 then return "P22 TS015 requires the selected foldable sprayer fixture" end
    if not configEvidence.allDeployed then return "P22 TS015 requires selected Yield assembly fully deployed and stable at initiation" end

    local run, runReason = probe:_newRun("TS015_RELOCATE", vehicle)
    if run == nil then return runReason end
    run.progressVehicle = progress
    run.progressVehicleName = nameOf(progress)
    run.progressReferenceKey = referenceKey(progress)
    run.progressStartJobToken = currentJobToken(progress)
    run.initialSpanM = initialSpan
    run.initialConfigurationKey = initialConfigKey
    run.initialConfigurationProfileId = initialProfileId
    run.initialFoldEvidence = configEvidence
    run.commitmentId = commitmentContext and commitmentContext.commitmentId or nil
    run.commitmentApplicationId = commitmentContext and commitmentContext.commitmentApplicationId or nil
    run.governingRequirementKey = commitmentContext and commitmentContext.governingRequirementKey or nil
    run.encounterIdentity = commitmentContext and commitmentContext.encounterIdentity or nil
    run.speedKmh = OuttaMyWay.PROTOTYPE_22_TS015_REPOSITION_SPEED_KMH or 15.0
    run.targetRadiusM = OuttaMyWay.PROTOTYPE_22_TS015_REPOSITION_TARGET_RADIUS_M or 1.0
    run.phase = "TS015_SETTLING"
    run.spatialResult = "PENDING"
    run.automatic = true

    local ok, gateReason = probe.permissionGate:setHold(vehicle, "P22-TS015-AUTONOMOUS-RELOCATE")
    if not ok then return "P22 TS015 Hold unavailable: " .. tostring(gateReason) end
    probe.run = run
    local horizonSealed,horizonSealReason=false,"BRIDGE_UNAVAILABLE"
    if probe.committedTransitionRegulationTestBridge~=nil and type(probe.committedTransitionRegulationTestBridge.sealProgressHorizon)=="function" then
        horizonSealed,horizonSealReason=probe.committedTransitionRegulationTestBridge:sealProgressHorizon(probe,run,"COMMITTED_REPOSITION_ADMISSION",g_time or 0)
    end
    logInfo("AUTONOMOUS_RELOCATE_START yield=%s yieldRef=%s yieldJob=%s progress=%s progressRef=%s progressJob=%s commitment=%s progressHorizonSealed=%s progressHorizonSealReason=%s literals=TEMPORARY_MECHANISM_ONLY policyAuthority=false sequence=HOLD_COMPACT_EGRESS_COMPACT_REFUGE_WAIT_FOR_RECOVERY_ADMISSION_REJOIN_RESTORE_HANDOFF_OBSERVE initialSpan=%.2fm %s",
        run.vehicleName, run.referenceKey, tostring(run.startJobToken), run.progressVehicleName, run.progressReferenceKey,
        tostring(run.progressStartJobToken), tostring(run.commitmentId or "none"), tostring(horizonSealed), tostring(horizonSealReason), run.initialSpanM, foldEvidenceText(configEvidence))
    probe:_setHud("OTM P22 — TS015", "Stopping " .. run.vehicleName, "Autonomous relocation armed; no further command needed")
    return string.format("P22 TS015 relocating %s (Yield) while %s remains GIANTS-owned Progress; automation will refuge/rejoin/restore/release and observe", run.vehicleName, run.progressVehicleName)
end

local function beginCompaction(probe, run)
    local anchor = pose(run.vehicle)
    if anchor == nil then return false, "rejoin-anchor-pose-unavailable" end
    run.rejoinAnchorX, run.rejoinAnchorZ = anchor.x, anchor.z
    run.rejoinForwardX, run.rejoinForwardZ = anchor.dx, anchor.dz
    run.rejoinRightX, run.rejoinRightZ = anchor.dz, -anchor.dx
    local rejoinForwardM = OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_FORWARD_M or 6.0
    run.rejoinTargetX = anchor.x + anchor.dx * rejoinForwardM
    run.rejoinTargetZ = anchor.z + anchor.dz * rejoinForwardM
    run.rejoinForwardM = rejoinForwardM

    local target, reason = selectFixtureTarget(run)
    if target == nil then return false, reason end
    run.fixtureTarget = target
    run.targetX = target.targetX
    run.targetZ = target.targetZ
    run.requestedForwardM = target.forwardM
    run.requestedRightM = target.lateralM * target.side

    local ok, stateOrReason = probe.configurationAuthority:prepareCompact(run.vehicle)
    if not ok then return false, stateOrReason end
    run.compactRequestedAt = g_time or 0
    run.phase = "TS015_COMPACTING"
    logInfo("COMPACT_START yield=%s job=%s anchor=(%.2f,%.2f) anchorForward=(%.4f,%.4f) rejoinTarget=(%.2f,%.2f) rejoinForward=%.1fm refugeTarget=(%.2f,%.2f) forward=%.1fm lateral=%+.1fm field=%s workMutations=%d raisedMutations=%d foldMutations=%d movementOverlap=WAIT_FOR_ACTUAL_FOLD_MOTION",
        run.vehicleName, tostring(run.startJobToken), run.rejoinAnchorX, run.rejoinAnchorZ, run.rejoinForwardX, run.rejoinForwardZ,
        run.rejoinTargetX, run.rejoinTargetZ, run.rejoinForwardM, run.targetX, run.targetZ, run.requestedForwardM, run.requestedRightM,
        tostring(target.sourceFieldId), stateOrReason.workMutations or 0, stateOrReason.raisedMutations or 0, stateOrReason.foldMutations or 0)
    probe:_setHud("OTM P22 — TS015 COMPACT", run.vehicleName .. " folding", string.format("Refuge %.0fm lateral; move starts on fold motion", math.abs(run.requestedRightM)))
    return true
end

local function beginMove(probe, run)
    local p = pose(run.vehicle)
    if p == nil then return false, "yield-pose-unavailable-at-move-start" end
    run.moveStartX, run.moveStartZ = p.x, p.z
    run.moveStartedAt = g_time or 0
    local ok, reason = probe.driveAuthority:setReposition(run.vehicle, run.targetX, run.targetZ, run.speedKmh, run.targetRadiusM)
    if not ok then return false, reason end
    run.phase = "TS015_MOVING"
    logInfo("MOVE_START yield=%s job=%s from=(%.2f,%.2f) target=(%.2f,%.2f) speed=%.1fkmh moveForwards=true foldMovementOverlap=true targetClearanceAuthority=FIXTURE_ONLY",
        run.vehicleName, tostring(run.startJobToken), p.x, p.z, run.targetX, run.targetZ, run.speedKmh)
    probe:_setHud("OTM P22 — TS015 MOVE", run.vehicleName .. " moving to refuge", "Folding continues during bounded fixture move")
    return true
end

local function recoveryAdmissionAssessment(probe, run)
    local recoveryPose=pose(run.vehicle)
    local progressPose=pose(run.progressVehicle)
    local recoverySpan=select(1,probe:_representedSpan(run.vehicle))
    local progressSpan=select(1,probe:_representedSpan(run.progressVehicle))
    local geometryEvaluator=OuttaMyWay.GuardedRecoveryThreatAssessment
    if geometryEvaluator==nil or type(geometryEvaluator.evaluateGeometry)~="function" or type(geometryEvaluator.evaluateCurrentHeadingSignal)~="function" then
        return {status="UNRESOLVED",reason="RECOVERY_ADMISSION_EVALUATOR_UNAVAILABLE"}
    end
    local geometry=geometryEvaluator.evaluateGeometry({
        recoveryPose=recoveryPose,progressPose=progressPose,previousProgressPose=nil,
        recoveryCurrentSpanM=recoverySpan,recoveryInitialSpanM=run.initialSpanM,progressSpanM=progressSpan,
        rejoinTargetX=run.rejoinTargetX,rejoinTargetZ=run.rejoinTargetZ,rejoinAnchorX=run.rejoinAnchorX,rejoinAnchorZ=run.rejoinAnchorZ
    })
    local evidenceSource=OuttaMyWay.runtime and OuttaMyWay.runtime.situationAssessment or nil
    local progressEvidence=evidenceSource and type(evidenceSource.getEvidence)=="function" and evidenceSource:getEvidence(run.progressReferenceKey,run.progressStartJobToken) or nil
    local sample={
        geometryResolved=geometry.resolved==true,geometryReason=geometry.reason,combinations=geometry.combinations,
        progressExpectedJobToken=run.progressStartJobToken,
        progressEvidenceJobToken=progressEvidence and progressEvidence.jobToken or nil,
        progressEvidenceClass=progressEvidence and progressEvidence.evidenceClass or nil,
        progressMovingDirection=progressEvidence and progressEvidence.movingDirection or nil
    }
    local signal=geometryEvaluator.evaluateCurrentHeadingSignal(sample)
    signal.recoverySpanM=recoverySpan
    signal.progressSpanM=progressSpan
    signal.progressPose=progressPose
    return signal
end

function Harness.recoveryAdmissionActionFromSignal(signal)
    local status=type(signal)=="table" and signal.status or "UNRESOLVED"
    if status=="NEGATIVE" then return "BEGIN_GUARDED_RECOVERY" end
    if status=="POSITIVE" then return "WAIT_AT_REFUGE" end
    if status=="INVALIDATED" then return "FAIL_CONTEXT" end
    return "WAIT_FOR_EVIDENCE"
end

local function startCompactHold(probe, run, nowMs, span, reduction, fold)
    run.spatialResult = "PASS"
    run.compactSpanM = span
    run.spanReductionM = reduction
    run.refugeReadyAt = nowMs
    run.phase = "TS015_COMPACT_REFUGE_HOLD"
    run.lastRecoveryAdmissionStatus=nil
    run.lastRecoveryAdmissionReason=nil
    logInfo("REFUGE_SPATIAL_PASS yield=%s job=%s initialSpan=%.2fm compactSpan=%.2fm reduction=%.2fm target=(%.2f,%.2f) recoveryAdmission=EVENT_DRIVEN_NO_DWELL_TIMER rejoinTarget=(%.2f,%.2f) %s",
        run.vehicleName, tostring(run.startJobToken), run.initialSpanM, span, reduction, run.targetX, run.targetZ,
        run.rejoinTargetX, run.rejoinTargetZ, foldEvidenceText(fold))
    probe:_setHud("OTM P22 — TS015 REFUGE", run.vehicleName .. " compact and Held", "Assessing traffic before recovery — no dwell timer")
end

local function chooseRejoinTurnSign(run)
    local p = pose(run.vehicle)
    if p == nil then return 1, "fallback-no-pose" end
    local targetLocalX = select(1, localDirectionToTarget(run.vehicle, run.rejoinTargetX, run.rejoinTargetZ))
    if math.abs(targetLocalX or 0) >= 0.05 then
        return targetLocalX > 0 and 1 or -1, "rejoin-target-shortest-turn"
    end

    local side = run.fixtureTarget and run.fixtureTarget.side or 1
    local refugeSideX = (run.rejoinRightX or 0) * side
    local refugeSideZ = (run.rejoinRightZ or 0) * side
    local okInward, localInwardX = pcall(worldDirectionToLocal, p.node, -refugeSideX, 0, -refugeSideZ)
    if okInward and math.abs(localInwardX or 0) >= 0.05 then
        return localInwardX > 0 and 1 or -1, "centreline-inward"
    end

    local okForward, localForwardX = pcall(worldDirectionToLocal, p.node,
        run.rejoinForwardX or 0, 0, run.rejoinForwardZ or 0)
    if okForward and math.abs(localForwardX or 0) >= 0.05 then
        return localForwardX > 0 and 1 or -1, "original-working-forward"
    end
    return 1, "deterministic-fallback"
end

local function beginDirectRejoin(probe, run, nowMs, reason)
    local p = pose(run.vehicle)
    if p == nil then return false, "rejoin-pose-unavailable" end
    local ok, driveReason = probe.driveAuthority:setReposition(run.vehicle,
        run.rejoinTargetX, run.rejoinTargetZ, run.speedKmh, run.targetRadiusM)
    if not ok then return false, driveReason end
    run.rejoinDirectStartedAt = nowMs
    run.phase = "TS015_REJOINING"
    logInfo("REJOIN_MOVE_START yield=%s job=%s from=(%.2f,%.2f) target=(%.2f,%.2f) anchor=(%.2f,%.2f) originalForward=(%.4f,%.4f) speed=%.1fkmh reason=%s configuration=COMPACT moveForwards=true legacyMechanismEvidenceOnly=true policyAuthority=false",
        run.vehicleName, tostring(run.startJobToken), p.x, p.z, run.rejoinTargetX, run.rejoinTargetZ,
        run.rejoinAnchorX, run.rejoinAnchorZ, run.rejoinForwardX, run.rejoinForwardZ, run.speedKmh, tostring(reason))
    probe:_setHud("OTM P22 — TS015 REJOIN", run.vehicleName .. " returning toward work", "Compact ingress toward pre-egress continuation state")
    return true
end

local function beginRejoin(probe, run, nowMs)
    local p = pose(run.vehicle)
    if p == nil then return false, "rejoin-pose-unavailable" end
    local localX, localZ, remaining = localDirectionToTarget(run.vehicle, run.rejoinTargetX, run.rejoinTargetZ)
    if localZ == nil then return false, "rejoin-target-local-direction-unavailable" end
    run.rejoinStartedAt = nowMs
    run.rejoinOrientationStartX, run.rejoinOrientationStartZ = p.x, p.z
    local threshold = OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_FORWARD_DOT or 0.25
    if localZ >= threshold then
        return beginDirectRejoin(probe, run, nowMs, "target-already-forward")
    end

    local sign, source = chooseRejoinTurnSign(run)
    local steerZ = OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_STEER_LZ or 0.30
    local orientationSpeed = OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_SPEED_KMH or 5.0
    local ok, reason = probe.driveAuthority:setRepositionOrientation(run.vehicle, sign, steerZ, orientationSpeed)
    if not ok then return false, reason end
    run.rejoinTurnSign = sign
    run.rejoinOrientationStartedAt = nowMs
    run.phase = "TS015_REJOIN_ORIENTING"
    logInfo("REJOIN_ORIENTATION_START yield=%s job=%s targetLocal=(%.3f,%.3f) remaining=%.2fm turnSign=%d turnSource=%s speed=%.1fkmh threshold=%.2f target=(%.2f,%.2f) configuration=COMPACT legacyMechanismEvidenceOnly=true policyAuthority=false",
        run.vehicleName, tostring(run.startJobToken), localX or 0, localZ or 0, remaining or -1,
        sign, tostring(source), orientationSpeed, threshold, run.rejoinTargetX, run.rejoinTargetZ)
    probe:_setHud("OTM P22 — TS015 ORIENT", run.vehicleName .. " turning back toward rejoin", "Temporary forward-only orientation before ingress")
    return true
end

local function maybeBeginRejoin(probe, run, nowMs)
    local signal=recoveryAdmissionAssessment(probe,run)
    local action=Harness.recoveryAdmissionActionFromSignal(signal)
    local changed=signal.status~=run.lastRecoveryAdmissionStatus or signal.reason~=run.lastRecoveryAdmissionReason
    run.lastRecoveryAdmissionStatus=signal.status
    run.lastRecoveryAdmissionReason=signal.reason

    if changed then
        local clearance=signal.combination and signal.combination.clearance or nil
        logInfo("RECOVERY_ADMISSION_ASSESS yield=%s job=%s progress=%s progressJob=%s status=%s reason=%s action=%s clearance=%s basis=D0122_D0123_PROPOSED_RECOVERY_COMPATIBILITY dwellTimerAuthority=false regulationBeforeIngress=false",
            run.vehicleName,tostring(run.startJobToken),run.progressVehicleName,tostring(currentJobToken(run.progressVehicle)),
            tostring(signal.status),tostring(signal.reason),tostring(action),clearance and string.format("%.2fm",clearance) or "n/a")
    end

    if action=="FAIL_CONTEXT" then
        failHeld(probe,run,"recovery-admission-invalidated:"..tostring(signal.reason))
        return false
    end
    if action=="WAIT_AT_REFUGE" then
        probe:_setHud("OTM P22 — REFUGE WAIT",run.vehicleName.." Held at Refuge","Progress continuation occupies recovery — let Progress pass")
        return false
    end
    if action=="WAIT_FOR_EVIDENCE" then
        probe:_setHud("OTM P22 — REFUGE WAIT",run.vehicleName.." Held at Refuge","Recovery compatibility unresolved — waiting for evidence")
        return false
    end

    logInfo("RECOVERY_ADMISSION_PASS yield=%s job=%s progress=%s progressJob=%s status=NEGATIVE reason=%s action=BEGIN_GUARDED_RECOVERY elapsedAtRefugeMs=%d elapsedAuthority=false",
        run.vehicleName,tostring(run.startJobToken),run.progressVehicleName,tostring(currentJobToken(run.progressVehicle)),
        tostring(signal.reason),nowMs-(run.refugeReadyAt or nowMs))
    local ok, reason = beginRejoin(probe, run, nowMs)
    if not ok then failHeld(probe, run, "rejoin-start-failed:" .. tostring(reason)) end
    return ok
end

local function requestRestoreAtRejoin(probe, run, nowMs)
    local state = probe.configurationAuthority:getState(run.vehicle)
    if state == nil then return false, "configuration-authority-lost-before-rejoin-restore" end
    local ok, reason = probe.configurationAuthority:requestRestore(run.vehicle)
    if not ok then return false, reason end
    run.restoreRequestedAt = nowMs
    run.phase = "TS015_REJOIN_RESTORING"
    logInfo("REJOIN_RESTORE_START yield=%s job=%s action=UNFOLD_WHILE_HELD target=(%.2f,%.2f) anchor=(%.2f,%.2f)",
        run.vehicleName, tostring(run.startJobToken), run.rejoinTargetX, run.rejoinTargetZ, run.rejoinAnchorX, run.rejoinAnchorZ)
    probe:_setHud("OTM P22 — TS015 RESTORE", run.vehicleName .. " back near work and unfolding", "Hold retained until original configuration restored")
    return true
end

function Harness.update(probe, run, nowMs, speed)
    local fold = probe.configurationAuthority:getEvidence(run.vehicle)

    if run.phase == "TS015_SETTLING" then
        local gateCalls = probe.permissionGate:getCallCount(run.vehicle)
        if gateCalls > 0 and speed <= (OuttaMyWay.PROTOTYPE_22_HOLD_EFFECT_SPEED_KMH or 0.25) then
            local ok, reason = beginCompaction(probe, run)
            if not ok then failHeld(probe, run, "compaction-start-failed:" .. tostring(reason)) end
        elseif nowMs - (run.startedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_TS015_SETTLE_TIMEOUT_MS or 15000) then
            failHeld(probe, run, "settle-timeout")
        end

    elseif run.phase == "TS015_COMPACTING" then
        if fold.motionObserved then
            local ok, reason = beginMove(probe, run)
            if not ok then failHeld(probe, run, "move-start-failed:" .. tostring(reason)) end
        elseif nowMs - (run.compactRequestedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_FOLD_MOTION_TIMEOUT_MS or 5000) then
            failHeld(probe, run, "fold-motion-unresolved")
        end

    elseif run.phase == "TS015_MOVING" then
        if fold.allFolded and run.fullCompactObservedAt == nil then
            run.fullCompactObservedAt = nowMs
            logInfo("COMPACT_CONFIRMED_DURING_MOVE yield=%s job=%s elapsedFromRequestMs=%d watchdog=RETIRED_FOR_MANOEUVRE %s",
                run.vehicleName, tostring(run.startJobToken), nowMs - (run.compactRequestedAt or nowMs), foldEvidenceText(fold))
        end
        local drive = probe.driveAuthority:getState(run.vehicle)
        if drive ~= nil and drive.invalidReason ~= nil then
            failHeld(probe, run, "drive-invalid:" .. tostring(drive.invalidReason))
        elseif drive ~= nil and drive.targetReached == true then
            probe.driveAuthority:clear(run.vehicle)
            run.targetReachedAt = nowMs
            run.phase = "TS015_TARGET_COMPACTING"
            local p = pose(run.vehicle)
            logInfo("TARGET_REACHED yield=%s job=%s target=(%.2f,%.2f) actual=(%s,%s) action=HOLD_COMPLETE_COMPACTION",
                run.vehicleName, tostring(run.startJobToken), run.targetX, run.targetZ,
                p and string.format("%.2f", p.x) or "n/a", p and string.format("%.2f", p.z) or "n/a")
            probe:_setHud("OTM P22 — TS015 TARGET", run.vehicleName .. " at refuge target", "Completing compact footprint proof")
        elseif nowMs - (run.moveStartedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_TS015_MOVE_TIMEOUT_MS or 45000) then
            failHeld(probe, run, "move-timeout")
        end

    elseif run.phase == "TS015_TARGET_COMPACTING" then
        if fold.allFolded and run.fullCompactObservedAt == nil then
            run.fullCompactObservedAt = nowMs
            logInfo("COMPACT_CONFIRMED_AT_TARGET yield=%s job=%s targetElapsedMs=%d %s",
                run.vehicleName, tostring(run.startJobToken), nowMs - (run.targetReachedAt or nowMs), foldEvidenceText(fold))
        end
        local span = select(1, probe:_representedSpan(run.vehicle))
        local reduction = span ~= nil and run.initialSpanM ~= nil and (run.initialSpanM - span) or nil
        local targetSettled = speed <= (OuttaMyWay.PROTOTYPE_22_HOLD_EFFECT_SPEED_KMH or 0.25)
        if fold.allFolded and targetSettled and reduction ~= nil and reduction >= (OuttaMyWay.PROTOTYPE_22_SPAN_REDUCTION_MIN_M or 1.0) then
            startCompactHold(probe, run, nowMs, span, reduction, fold)
        elseif fold.allFolded and targetSettled and nowMs - (run.targetReachedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_SPATIAL_VERIFY_TIMEOUT_MS or 5000) then
            failHeld(probe, run, "no-positive-represented-span-reduction")
        elseif run.fullCompactObservedAt == nil and nowMs - (run.targetReachedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_FULL_COMPACT_TIMEOUT_MS or 25000) then
            failHeld(probe, run, "target-full-compact-timeout")
        end

    elseif run.phase == "TS015_COMPACT_REFUGE_HOLD" then
        maybeBeginRejoin(probe, run, nowMs)

    elseif run.phase == "TS015_REJOIN_ORIENTING" then
        local drive = probe.driveAuthority:getState(run.vehicle)
        local p = pose(run.vehicle)
        local localX, localZ, remaining = localDirectionToTarget(run.vehicle, run.rejoinTargetX, run.rejoinTargetZ)
        local orientationTravel = p ~= nil and math.sqrt((p.x - (run.rejoinOrientationStartX or p.x))^2 + (p.z - (run.rejoinOrientationStartZ or p.z))^2) or nil
        local threshold = OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_FORWARD_DOT or 0.25
        if drive ~= nil and drive.invalidReason ~= nil then
            failHeld(probe, run, "rejoin-orientation-drive-invalid:" .. tostring(drive.invalidReason))
        elseif remaining ~= nil and remaining <= run.targetRadiusM then
            probe.driveAuthority:clear(run.vehicle)
            run.rejoinTargetReachedAt = nowMs
            run.phase = "TS015_REJOIN_SETTLING"
            logInfo("REJOIN_TARGET_REACHED_DURING_ORIENTATION yield=%s job=%s remaining=%.2fm orientationTravel=%s",
                run.vehicleName, tostring(run.startJobToken), remaining, orientationTravel and string.format("%.2fm", orientationTravel) or "n/a")
        elseif localZ ~= nil and localZ >= threshold then
            probe.driveAuthority:clear(run.vehicle)
            logInfo("REJOIN_ORIENTATION_COMPLETE yield=%s job=%s targetLocal=(%.3f,%.3f) remaining=%s travel=%s durationMs=%d next=DIRECT_REJOIN",
                run.vehicleName, tostring(run.startJobToken), localX or 0, localZ or 0,
                remaining and string.format("%.2fm", remaining) or "n/a", orientationTravel and string.format("%.2fm", orientationTravel) or "n/a",
                nowMs - (run.rejoinOrientationStartedAt or nowMs))
            local ok, reason = beginDirectRejoin(probe, run, nowMs, "target-entered-forward-hemisphere")
            if not ok then failHeld(probe, run, "rejoin-direct-start-failed:" .. tostring(reason)) end
        elseif orientationTravel ~= nil and orientationTravel >= (OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_MAX_TRAVEL_M or 20.0) then
            failHeld(probe, run, "rejoin-orientation-travel-limit")
        elseif nowMs - (run.rejoinOrientationStartedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_TIMEOUT_MS or 12000) then
            failHeld(probe, run, "rejoin-orientation-timeout")
        end

    elseif run.phase == "TS015_REJOINING" then
        local drive = probe.driveAuthority:getState(run.vehicle)
        if drive ~= nil and drive.invalidReason ~= nil then
            failHeld(probe, run, "rejoin-drive-invalid:" .. tostring(drive.invalidReason))
        elseif drive ~= nil and drive.targetReached == true then
            probe.driveAuthority:clear(run.vehicle)
            run.rejoinTargetReachedAt = nowMs
            run.phase = "TS015_REJOIN_SETTLING"
            local p = pose(run.vehicle)
            logInfo("REJOIN_TARGET_REACHED yield=%s job=%s target=(%.2f,%.2f) actual=(%s,%s) anchor=(%.2f,%.2f) action=HOLD_THEN_RESTORE",
                run.vehicleName, tostring(run.startJobToken), run.rejoinTargetX, run.rejoinTargetZ,
                p and string.format("%.2f", p.x) or "n/a", p and string.format("%.2f", p.z) or "n/a",
                run.rejoinAnchorX, run.rejoinAnchorZ)
            probe:_setHud("OTM P22 — TS015 REJOIN", run.vehicleName .. " back near work", "Settling before configuration restoration")
        elseif nowMs - (run.rejoinDirectStartedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_TS015_MOVE_TIMEOUT_MS or 45000) then
            failHeld(probe, run, "rejoin-move-timeout")
        end

    elseif run.phase == "TS015_REJOIN_SETTLING" then
        if speed <= (OuttaMyWay.PROTOTYPE_22_HOLD_EFFECT_SPEED_KMH or 0.25) then
            local ok, reason = requestRestoreAtRejoin(probe, run, nowMs)
            if not ok then failHeld(probe, run, "rejoin-restore-start-failed:" .. tostring(reason)) end
        elseif nowMs - (run.rejoinTargetReachedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_SETTLE_TIMEOUT_MS or 15000) then
            failHeld(probe, run, "rejoin-settle-timeout")
        end

    elseif run.phase == "TS015_REJOIN_RESTORING" then
        if fold.allDeployed then
            local finished, reason = probe.configurationAuthority:finishRestore(run.vehicle)
            if not finished then
                failHeld(probe, run, "rejoin-restore-finish-failed:" .. tostring(reason))
                return true
            end
            run.restoreCompleteAt = nowMs
            local p = pose(run.vehicle)
            local targetError = p and distance(p, {x=run.rejoinTargetX, z=run.rejoinTargetZ}) or nil
            local anchorError = p and distance(p, {x=run.rejoinAnchorX, z=run.rejoinAnchorZ}) or nil
            local alignment = headingDot(p, run.rejoinForwardX, run.rejoinForwardZ)
            logInfo("NATIVE_CONTINUATION_RESTORATION_PASS yield=%s job=%s %s workAndLoweredState=RESTORED targetError=%s anchorDistance=%s headingDotOriginal=%s authority=HOLD releaseNext=true",
                run.vehicleName, tostring(run.startJobToken), foldEvidenceText(fold),
                targetError and string.format("%.2fm", targetError) or "n/a", anchorError and string.format("%.2fm", anchorError) or "n/a",
                alignment and string.format("%.4f", alignment) or "n/a")
            probe:_releaseImmediate(run, "ts015-restoration-first-handoff")
            return true
        elseif nowMs - (run.restoreRequestedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_RESTORE_TIMEOUT_MS or 25000) then
            failHeld(probe, run, "rejoin-deploy-timeout")
        end

    elseif run.phase == "TS015_FAILED_RESTORING" then
        if fold.allDeployed then
            local finished = probe.configurationAuthority:finishRestore(run.vehicle)
            if finished then
                run.phase = "TS015_FAILED_HELD"
                logWarning("FAILURE_RESTORE_PASS yield=%s job=%s action=HOLD_RETAINED", run.vehicleName, tostring(run.startJobToken))
                probe:_setHud("OTM P22 — TS015 HELD", run.vehicleName .. " restored after failure", "Hold retained; use cancel/release manually")
            end
        end
    end
    return true
end

function Harness.updateReleaseMonitor(probe, monitor, nowMs, token, currentPose, moved, speed)
    if token ~= monitor.startJobToken then
        logWarning("OBSERVATION_END yield=%s startJob=%s currentJob=%s sameJob=false reason=JOB_EPISODE_CHANGED handsOff=true",
            monitor.vehicleName, tostring(monitor.startJobToken), tostring(token))
        probe:_setHud("OTM P22 — TS015 END", monitor.vehicleName, "Job Episode changed during hands-off observation")
        probe.releasedMonitor = nil
        return true
    end

    if monitor.firstNativeAt == nil and (((moved or 0) >= (OuttaMyWay.PROTOTYPE_22_RELEASE_RESUME_TRAVEL_M or 0.5)) or speed >= (OuttaMyWay.PROTOTYPE_22_RELEASE_RESUME_SPEED_KMH or 0.5)) then
        monitor.firstNativeAt = nowMs
        monitor.firstNativeTravelM = moved
        logInfo("NATIVE_CONTINUATION_FIRST yield=%s job=%s sameJob=true delayMs=%d speed=%.2f moved=%s wake=%s authority=GIANTS handsOff=true",
            monitor.vehicleName, tostring(token), nowMs - monitor.releasedAt, speed,
            moved and string.format("%.2fm", moved) or "n/a", tostring(monitor.wakeMethod))
        if monitor.commitmentId~=nil and OuttaMyWay.LiveTrafficCommitmentLifecycle~=nil then
            local result,commitmentReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.markNativeReacquisition(probe.runtime,monitor.commitmentId,{
                kind="POSITIVE_GIANTS_REACQUISITION",jobToken=tostring(token),delayMs=nowMs-monitor.releasedAt,
                movedM=moved,speedKmh=speed,source="Prototype22TS015Relocation.updateReleaseMonitor"
            })
            if result==nil then
                logWarning("LIVE_COMMITMENT_REACQUISITION_FAIL commitment=%s reason=%s trafficSettlementComplete=false",tostring(monitor.commitmentId),tostring(commitmentReason))
            else
                logInfo("LIVE_COMMITMENT_RECOVERY_OBLIGATION_SETTLED commitment=%s state=%s remainingObligations=%d trafficSettlementComplete=false next=ORDINARY_TRAFFIC_ASSESSMENT",
                    tostring(monitor.commitmentId),tostring(result.commitment.state),#(result.remainingObligations or {}))
            end
        end
        probe:_setHud("OTM P22 — TS015 GIANTS", monitor.vehicleName .. " released to GIANTS", "Recovery complete; traffic Commitment remains until Durable Separation")
    end

    monitor.maximumTravelM = math.max(monitor.maximumTravelM or 0, moved or 0)
    local progressPose = pose(monitor.progressVehicle)
    local pairSeparation = distance(currentPose, progressPose)
    local progressSpeed = actualSpeedKmh(monitor.progressVehicle)
    local progressJob = currentJobToken(monitor.progressVehicle)
    local intent = OuttaMyWay.LocalIntentObservation ~= nil and OuttaMyWay.LocalIntentObservation.observe(monitor.vehicle) or nil

    if nowMs >= (monitor.nextTs015LogAt or 0) then
        monitor.nextTs015LogAt = nowMs + (OuttaMyWay.PROTOTYPE_22_TS015_OBSERVE_LOG_MS or 2000)
        logInfo("GIANTS_OBSERVE yield=%s yieldJob=%s yieldSpeed=%.2f yieldMoved=%s yieldPos=(%s,%s) yieldIntent=%s progress=%s progressJob=%s progressSpeed=%.2f progressPos=(%s,%s) pairSeparation=%s elapsedMs=%d handsOff=true",
            monitor.vehicleName, tostring(token), speed, moved and string.format("%.2fm", moved) or "n/a",
            currentPose and string.format("%.2f", currentPose.x) or "n/a", currentPose and string.format("%.2f", currentPose.z) or "n/a",
            intent and tostring(intent.classification) or "UNRESOLVED",
            monitor.progressVehicleName or nameOf(monitor.progressVehicle), tostring(progressJob), progressSpeed,
            progressPose and string.format("%.2f", progressPose.x) or "n/a", progressPose and string.format("%.2f", progressPose.z) or "n/a",
            pairSeparation and string.format("%.2fm", pairSeparation) or "n/a", nowMs - monitor.releasedAt)
    end

    local window = OuttaMyWay.PROTOTYPE_22_TS015_OBSERVE_MS or 120000
    if nowMs - monitor.releasedAt >= window then
        logInfo("OBSERVATION_COMPLETE yield=%s job=%s sameJob=true nativeContinuationObserved=%s firstNativeDelayMs=%s maximumTravel=%.2fm observationWindowMs=%d progress=%s progressJobNow=%s authority=NONE handsOff=true",
            monitor.vehicleName, tostring(token), tostring(monitor.firstNativeAt ~= nil),
            monitor.firstNativeAt and tostring(monitor.firstNativeAt - monitor.releasedAt) or "n/a",
            monitor.maximumTravelM or 0, window, monitor.progressVehicleName or nameOf(monitor.progressVehicle), tostring(progressJob))
        logInfo("SUMMARY kind=TS015_RELOCATE vehicle=%s result=CHARACTERISED sameJob=true spatialResult=%s nativeContinuation=%s observationWindowMs=%d",
            monitor.vehicleName, tostring(monitor.spatialResult or "n/a"), tostring(monitor.firstNativeAt ~= nil), window)
        probe:_setHud("OTM P22 — TS015 DONE", monitor.vehicleName .. " observation complete", "Review log/video; P22 idle")
        probe.releasedMonitor = nil
    end
    return true
end
