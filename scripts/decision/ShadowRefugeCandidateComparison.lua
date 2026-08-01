-- FS25_OuttaMyWay v4.6.43 cooperative passage evidence consolidation candidate.
-- Prototype 19: calculated refuge candidate comparison and Control selection.
--
-- At Automatic Encounter Admission this module calculates both lateral refuge
-- candidates for both possible Yield/Progress role assignments. Geometry-solved
-- candidates are compared without any Condor, side, 28 m or 12 m fallback. The
-- selected role becomes authoritative at admission; both sides are recalculated
-- from the confirmed stop position before the controller receives its target.

OuttaMyWay.ShadowRefugeCandidateComparison = OuttaMyWay.ShadowRefugeCandidateComparison or {}
local Comparison = OuttaMyWay.ShadowRefugeCandidateComparison

local function safeNumber(value)
    value = tonumber(value)
    if value == nil or value ~= value or value == math.huge or value == -math.huge then return nil end
    return value
end

local function fmt(value, decimals)
    if value == nil then return "n/a" end
    return string.format("%." .. tostring(decimals or 2) .. "f", value)
end

local function nameOf(state)
    return state ~= nil and tostring(state.name or "AI vehicle") or "AI vehicle"
end

local function nodeOf(vehicle)
    if vehicle == nil or vehicle.isDeleted == true then return nil end
    if type(vehicle.getAISteeringNode) == "function" then
        local ok, node = pcall(vehicle.getAISteeringNode, vehicle)
        if ok and node ~= nil and node ~= 0 then return node end
    end
    local node = vehicle.rootNode
    return node ~= nil and node ~= 0 and node or nil
end

local function positionOf(vehicle)
    local node = nodeOf(vehicle)
    if node == nil then return nil, nil end
    local ok, x, _, z = pcall(getWorldTranslation, node)
    if not ok then return nil, nil end
    return x, z
end

local function directionOf(vehicle)
    local node = nodeOf(vehicle)
    if node == nil then return nil, nil end
    local ok, x, _, z = pcall(localDirectionToWorld, node, 0, 0, 1)
    if not ok then return nil, nil end
    local length = math.sqrt(x * x + z * z)
    if length < 0.001 then return nil, nil end
    return x / length, z / length
end

local function normalized(x, z)
    local length = math.sqrt((x or 0) * (x or 0) + (z or 0) * (z or 0))
    if length < 0.001 then return nil, nil end
    return x / length, z / length
end

local function dot(ax, az, bx, bz)
    return (ax or 0) * (bx or 0) + (az or 0) * (bz or 0)
end

local function observerSeconds(nowMs)
    local current = safeNumber(nowMs) or safeNumber(g_time) or 0
    local observer = OuttaMyWay.Observer
    local startedAt = observer ~= nil and safeNumber(observer.startedAt) or nil
    if startedAt ~= nil then return (current - startedAt) / 1000 end
    return current / 1000
end

local function geometryFor(vehicle, budget, inventory, nowMs)
    local evidence = OuttaMyWay.PhysicalEnvelopeEvidence
    if evidence == nil or type(evidence.buildGeometry) ~= "function" then return nil, inventory end
    local ok, geometry = pcall(evidence.buildGeometry, vehicle, budget, inventory, nowMs)
    if not ok or geometry == nil then return nil, inventory end
    return geometry, geometry.inventory or inventory
end

local function cornersFor(geometry)
    local evidence = OuttaMyWay.PhysicalEnvelopeEvidence
    if evidence == nil or type(evidence.envelopeCorners) ~= "function" then return nil end
    local ok, corners = pcall(evidence.envelopeCorners, geometry)
    return ok and corners or nil
end

local function completeEnvelope(geometry)
    return geometry ~= nil
        and geometry.confidence == "HIGH_DISCOVERED"
        and geometry.coverage == "ALL_OBJECTS_DISCOVERED"
        and geometry.truncated ~= true
end

local function projectedOneSidedExtent(corners, referenceX, referenceZ, axisX, axisZ)
    if corners == nil or referenceX == nil or referenceZ == nil then return nil end
    local maximum = nil
    for _, point in ipairs(corners) do
        local value = (point.x - referenceX) * axisX + (point.z - referenceZ) * axisZ
        maximum = maximum == nil and value or math.max(maximum, value)
    end
    return maximum ~= nil and math.max(0, maximum) or nil
end

local function metadataDimensions(vehicle, geometry)
    local width = geometry ~= nil and safeNumber(geometry.sizeMetadataWidth) or nil
    local length = geometry ~= nil and safeNumber(geometry.sizeMetadataLength) or nil
    width = width or safeNumber(vehicle ~= nil and vehicle.sizeWidth or nil)
    length = length or safeNumber(vehicle ~= nil and vehicle.sizeLength or nil)
    if width ~= nil and (width < 0.25 or width > 150) then width = nil end
    if length ~= nil and (length < 0.25 or length > 150) then length = nil end
    return width, length
end

local function rectangleExtent(width, length, forwardX, forwardZ, axisX, axisZ)
    if width == nil or length == nil or forwardX == nil or forwardZ == nil then return nil end
    local fx, fz = normalized(forwardX, forwardZ)
    if fx == nil then return nil end
    local rightX, rightZ = fz, -fx
    return (width * 0.5) * math.abs(dot(rightX, rightZ, axisX, axisZ))
        + (length * 0.5) * math.abs(dot(fx, fz, axisX, axisZ))
end

local function progressFacingExtent(progressState, geometry, sideX, sideZ)
    local px, pz = positionOf(progressState.vehicle)
    local corners = completeEnvelope(geometry) and cornersFor(geometry) or nil
    local extent = projectedOneSidedExtent(corners, px, pz, sideX, sideZ)
    if extent ~= nil then
        return extent, "LIVE_COMPLETE_DISCOVERED_ENVELOPE", "HIGH_DISCOVERED", {
            coverage="ALL_OBJECTS_DISCOVERED",
            extentKind="ONE_SIDED_PHYSICAL_EXTENT"
        }
    end

    local markerWidth = geometry ~= nil and safeNumber(geometry.workingMarkerWidth) or nil
    if markerWidth ~= nil and markerWidth >= 0.25 and markerWidth <= 150 then
        return markerWidth * 0.5, "LIVE_AI_MARKER_WORKING_WIDTH_HALF", "MEDIUM_WORKING_EXTENT", {
            coverage="WORKING_MARKER_WIDTH",
            extentKind="WORKING_CORRIDOR_EXTENT"
        }
    end

    local width = metadataDimensions(progressState.vehicle, geometry)
    if width ~= nil then
        return width * 0.5, "SIZE_METADATA_WIDTH_HALF", "LOW_METADATA", {
            coverage="SIZE_METADATA",
            extentKind="METADATA_WIDTH_EXTENT"
        }
    end
    return nil, "UNAVAILABLE", "UNKNOWN", nil
end

local function predictedEgressDirection(yieldForwardX, yieldForwardZ, sideX, sideZ, lateral, rearward)
    if lateral == nil or rearward == nil then return nil, nil end
    return normalized(sideX * lateral - yieldForwardX * rearward,
        sideZ * lateral - yieldForwardZ * rearward)
end

-- Returns a conservative one-sided compact-assembly extent. Model-specific
-- compact evidence and generic vehicle metadata are both considered; the larger
-- available extent wins so model evidence cannot omit the carrier body. The live
-- working radius is used only when neither compact nor metadata evidence exists.
local function yieldFacingExtent(yieldState, geometry, axisX, axisZ,
        predictedForwardX, predictedForwardZ)
    local options = {}
    local provider = OuttaMyWay.FacingExtentProvider
    if provider ~= nil and type(provider.compactYieldExtent) == "function" then
        local ok, result = pcall(provider.compactYieldExtent, provider, yieldState.vehicle,
            axisX, axisZ, "PRE", predictedForwardX, predictedForwardZ)
        if ok and result ~= nil and safeNumber(result.extent) ~= nil then
            result.extentKind = result.extentKind or "PREDICTED_COMPACT_EXTENT"
            options[#options+1] = {
                extent=result.extent,
                source=result.source or "FACING_EXTENT_PROVIDER",
                confidence=result.confidence or "UNKNOWN",
                details=result
            }
        end
    end

    local currentForwardX, currentForwardZ = directionOf(yieldState.vehicle)
    if currentForwardX ~= nil and math.abs(dot(currentForwardX, currentForwardZ, axisX, axisZ)) >= 0.70 then
        local referenceX, referenceZ = positionOf(yieldState.vehicle)
        local liveCorners = completeEnvelope(geometry) and cornersFor(geometry) or nil
        local liveExtent = projectedOneSidedExtent(liveCorners, referenceX, referenceZ, axisX, axisZ)
        if liveExtent ~= nil then
            options[#options+1] = {
                extent=liveExtent,
                source="LIVE_COMPLETE_DISCOVERED_LONGITUDINAL_ENVELOPE",
                confidence="HIGH_DISCOVERED",
                details={coverage="ALL_OBJECTS_DISCOVERED", extentKind="LONGITUDINAL_BODY_AND_ASSEMBLY_EXTENT"}
            }
        end
    end

    local width, length = metadataDimensions(yieldState.vehicle, geometry)
    local metadataExtent = rectangleExtent(width, length, predictedForwardX, predictedForwardZ,
        axisX, axisZ)
    if metadataExtent ~= nil then
        options[#options+1] = {
            extent=metadataExtent,
            source="SIZE_METADATA_RECTANGLE_PREDICTED_EGRESS_BEARING",
            confidence="LOW_POSE_MODEL",
            details={coverage="SIZE_METADATA", extentKind="PREDICTED_COMPACT_RECTANGLE"}
        }
    end

    if #options == 0 then
        local markerWidth = geometry ~= nil and safeNumber(geometry.workingMarkerWidth) or nil
        if markerWidth ~= nil and markerWidth >= 0.25 and markerWidth <= 150 then
            options[#options+1] = {
                extent=markerWidth * 0.5,
                source="LIVE_AI_MARKER_WORKING_RADIUS_CONSERVATIVE_UPPER_BOUND",
                confidence="LOW_CONSERVATIVE",
                details={
                    coverage="COMPACT_UNPROVEN_CURRENT_WORKING_UPPER_BOUND",
                    extentKind="CONSERVATIVE_UPPER_BOUND",
                    poseSource="CURRENT_WORKING_MARKER_NOT_COMPACT_POSE"
                }
            }
        end
    end

    if #options == 0 then return nil, "UNAVAILABLE", "UNKNOWN", nil end
    table.sort(options, function(a,b) return a.extent > b.extent end)
    local selected = options[1]
    selected.details.candidateCount = #options
    selected.details.extentSelection = "MAX_AVAILABLE_COMPLETE_ASSEMBLY_OPERAND"
    return selected.extent, selected.source, selected.confidence, selected.details
end

local function policyMargins()
    local geometry = safeNumber(OuttaMyWay.TS017_GEOMETRY_UNCERTAINTY_M) or 0.75
    local tracking = safeNumber(OuttaMyWay.TS017_TRACKING_TOLERANCE_M) or 1.00
    local motion = safeNumber(OuttaMyWay.TS017_MOTION_ALLOWANCE_M) or 0.50
    local policy = safeNumber(OuttaMyWay.TS017_POLICY_MARGIN_M) or 1.50
    return {
        geometry=geometry,
        tracking=tracking,
        motion=motion,
        policy=policy,
        budget=geometry + tracking + motion + policy
    }
end

local function evidenceState(value, clearThreshold)
    if value == nil then return "UNKNOWN" end
    return value >= (clearThreshold or 0) and "CLEAR" or "BLOCKED"
end

local function aggregateState(evidence)
    local hasUnknown = false
    for _, value in pairs(evidence) do
        if value == "BLOCKED" then return "REJECTED" end
        if value == "UNKNOWN" then hasUnknown = true end
    end
    return hasUnknown and "UNRESOLVED" or "VIABLE"
end

local function confidenceSummary(progressConfidence, yieldConfidence)
    if progressConfidence == "UNKNOWN" or yieldConfidence == "UNKNOWN" then return "UNKNOWN" end
    if string.find(progressConfidence, "LOW", 1, true)
        or string.find(yieldConfidence, "LOW", 1, true) then
        return "LOW_MODELLED"
    end
    if string.find(progressConfidence, "HIGH", 1, true)
        and string.find(yieldConfidence, "HIGH", 1, true) then
        return "HIGH_DISCOVERED"
    end
    return "MEDIUM_MIXED"
end

local function unresolvedCandidate(epoch, yieldState, progressState, roleIndex, sideSign, reason)
    return {
        id=string.format("%s-R%d-S%+d", epoch, roleIndex, sideSign),
        assessmentEpoch=epoch,
        yieldName=nameOf(yieldState),
        progressName=nameOf(progressState),
        yieldState=yieldState,
        progressState=progressState,
        roleIndex=roleIndex,
        sideSign=sideSign,
        solutionStatus="UNAVAILABLE",
        solutionReason=reason or "evidence-unavailable",
        aggregate="UNRESOLVED",
        evidence={representation="UNKNOWN", refugePhysical="UNKNOWN", refugePolicy="UNKNOWN",
            rearwardCapture="UNKNOWN", egressPath="UNKNOWN", fieldContainment="UNKNOWN",
            obstacleClearance="UNKNOWN", progressPreservation="UNKNOWN"},
        costEligible=false,
        controlEligible=false,
        authority=false
    }
end

local function candidateLess(a, b)
    local al, bl = a.lateralTravel or math.huge, b.lateralTravel or math.huge
    if math.abs(al-bl) > 0.001 then return al < bl end
    local at, bt = a.totalTravel or math.huge, b.totalTravel or math.huge
    if math.abs(at-bt) > 0.001 then return at < bt end
    local ay, by = tostring(a.yieldName or ""), tostring(b.yieldName or "")
    if ay ~= by then return ay < by end
    return (a.sideSign or 1) < (b.sideSign or 1)
end

function Comparison:init()
    self.enabled = OuttaMyWay.TS019_SHADOW_REFUGE_COMPARISON_ENABLED == true
    self.epochSequence = 0
    self.lastEpoch = nil
    self.inventoryByVehicle = {}
    OuttaMyWay.Logger:info(
        "PROTOTYPE 19 ACTIVE: calculated refuge authority enabled=%s roles=2 sidesPerRole=2 clearanceFormula=true rearwardFormula=compact-forward-extent-plus-geometry-and-tracking-margin clock=observer-relative fixedRole=false fixedSide=false fixed28=false fixed12=false",
        tostring(self.enabled))
end

function Comparison:buildCandidate(epoch, yieldState, progressState, roleIndex, sideSign,
        nowMs, yieldGeometry, progressGeometry)
    local yieldX, yieldZ = positionOf(yieldState.vehicle)
    local progressX, progressZ = positionOf(progressState.vehicle)
    local progressForwardX, progressForwardZ = directionOf(progressState.vehicle)
    local yieldForwardX, yieldForwardZ = directionOf(yieldState.vehicle)
    if yieldX == nil or progressX == nil or progressForwardX == nil or yieldForwardX == nil then
        return unresolvedCandidate(epoch, yieldState, progressState, roleIndex, sideSign,
            "reference-frame-unavailable")
    end

    local positiveNormalX, positiveNormalZ = progressForwardZ, -progressForwardX
    local sideX, sideZ = positiveNormalX * sideSign, positiveNormalZ * sideSign
    local currentSignedOffset = (yieldX-progressX) * sideX + (yieldZ-progressZ) * sideZ
    local margins = policyMargins()
    local rearwardCaptureMargin = margins.geometry + margins.tracking

    local progressExtent, progressSource, progressConfidence, progressProvider = progressFacingExtent(
        progressState, progressGeometry, sideX, sideZ)
    local lateralTravel = progressExtent ~= nil
        and math.max(0, progressExtent + margins.budget - currentSignedOffset)
        or nil
    local rearwardTravel = rearwardCaptureMargin

    local yieldExtent, yieldSource, yieldConfidence, yieldProvider
    local yieldForwardExtent, yieldForwardSource, yieldForwardConfidence, yieldForwardProvider
    local predictedForwardX, predictedForwardZ
    local physicalThreshold, policyRequired
    local solved = false

    if lateralTravel ~= nil then
        for _=1,12 do
            predictedForwardX, predictedForwardZ = predictedEgressDirection(
                yieldForwardX, yieldForwardZ, sideX, sideZ, lateralTravel, rearwardTravel)
            yieldExtent, yieldSource, yieldConfidence, yieldProvider = yieldFacingExtent(
                yieldState, yieldGeometry, -sideX, -sideZ, predictedForwardX, predictedForwardZ)
            yieldForwardExtent, yieldForwardSource, yieldForwardConfidence, yieldForwardProvider = yieldFacingExtent(
                yieldState, yieldGeometry, yieldForwardX, yieldForwardZ,
                predictedForwardX, predictedForwardZ)
            physicalThreshold = progressExtent ~= nil and yieldExtent ~= nil
                and progressExtent + yieldExtent or nil
            policyRequired = physicalThreshold ~= nil and physicalThreshold + margins.budget or nil
            if policyRequired == nil or yieldForwardExtent == nil then
                lateralTravel, rearwardTravel = nil, nil
                break
            end

            local lateralForwardDelta = dot(sideX * lateralTravel, sideZ * lateralTravel,
                yieldForwardX, yieldForwardZ)
            local nextRearward = math.max(0,
                lateralForwardDelta + yieldForwardExtent + rearwardCaptureMargin)
            local rearwardSideDelta = dot(-yieldForwardX * nextRearward,
                -yieldForwardZ * nextRearward, sideX, sideZ)
            local nextLateral = math.max(0,
                policyRequired - currentSignedOffset - rearwardSideDelta)
            solved = true
            local converged = math.abs(nextLateral-lateralTravel) <= 0.001
                and math.abs(nextRearward-rearwardTravel) <= 0.001
            lateralTravel, rearwardTravel = nextLateral, nextRearward
            if converged then break end
        end
    end

    if not solved or lateralTravel == nil or rearwardTravel == nil
        or policyRequired == nil or yieldForwardExtent == nil then
        local candidate = unresolvedCandidate(epoch, yieldState, progressState,
            roleIndex, sideSign, progressExtent == nil and "progress-facing-extent-unavailable"
                or "yield-compact-assembly-extent-unavailable")
        candidate.sideDiagnostic = sideSign == 1
            and "progress-local-positive-normal" or "progress-local-negative-normal"
        candidate.sideX, candidate.sideZ = sideX, sideZ
        candidate.currentSignedOffset = currentSignedOffset
        candidate.progressExtent = progressExtent
        candidate.progressExtentSource = progressSource
        candidate.progressExtentConfidence = progressConfidence
        candidate.progressExtentCoverage = progressProvider ~= nil and progressProvider.coverage or "none"
        candidate.yieldExtent = yieldExtent
        candidate.yieldExtentSource = yieldSource
        candidate.yieldExtentConfidence = yieldConfidence
        candidate.yieldProviderCoverage = yieldProvider ~= nil and yieldProvider.coverage or "none"
        candidate.yieldExtentKind = yieldProvider ~= nil and yieldProvider.extentKind or "none"
        candidate.yieldForwardExtent = yieldForwardExtent
        candidate.yieldForwardExtentSource = yieldForwardSource
        candidate.yieldForwardExtentConfidence = yieldForwardConfidence
        candidate.yieldForwardCoverage = yieldForwardProvider ~= nil and yieldForwardProvider.coverage or "none"
        candidate.policyMarginBudget = margins.budget
        candidate.rearwardCaptureMargin = rearwardCaptureMargin
        return candidate
    end

    predictedForwardX, predictedForwardZ = predictedEgressDirection(
        yieldForwardX, yieldForwardZ, sideX, sideZ, lateralTravel, rearwardTravel)
    yieldExtent, yieldSource, yieldConfidence, yieldProvider = yieldFacingExtent(
        yieldState, yieldGeometry, -sideX, -sideZ, predictedForwardX, predictedForwardZ)
    yieldForwardExtent, yieldForwardSource, yieldForwardConfidence, yieldForwardProvider = yieldFacingExtent(
        yieldState, yieldGeometry, yieldForwardX, yieldForwardZ,
        predictedForwardX, predictedForwardZ)
    physicalThreshold = progressExtent + yieldExtent
    policyRequired = physicalThreshold + margins.budget

    local targetX = yieldX + sideX * lateralTravel - yieldForwardX * rearwardTravel
    local targetZ = yieldZ + sideZ * lateralTravel - yieldForwardZ * rearwardTravel
    local proposedSignedSeparation = (targetX-progressX) * sideX + (targetZ-progressZ) * sideZ
    local physicalReserve = proposedSignedSeparation - physicalThreshold
    local policyReserve = proposedSignedSeparation - policyRequired
    local lateralForwardDelta = dot(sideX * lateralTravel, sideZ * lateralTravel,
        yieldForwardX, yieldForwardZ)
    local rearwardCaptureReserve = rearwardTravel - lateralForwardDelta
        - yieldForwardExtent - rearwardCaptureMargin
    local totalTravel = math.sqrt(lateralTravel*lateralTravel + rearwardTravel*rearwardTravel)

    local evidence = {
        representation="CLEAR",
        refugePhysical=evidenceState(physicalReserve, -0.001),
        refugePolicy=evidenceState(policyReserve, -0.001),
        rearwardCapture=evidenceState(rearwardCaptureReserve, -0.001),
        egressPath="UNKNOWN",
        fieldContainment="UNKNOWN",
        obstacleClearance="UNKNOWN",
        progressPreservation=evidenceState(policyReserve, -0.001)
    }
    local aggregate = aggregateState(evidence)
    local controlEligible = evidence.representation == "CLEAR"
        and evidence.refugePhysical == "CLEAR"
        and evidence.refugePolicy == "CLEAR"
        and evidence.rearwardCapture == "CLEAR"
        and evidence.progressPreservation == "CLEAR"

    return {
        id=string.format("%s-R%d-S%+d", epoch, roleIndex, sideSign),
        assessmentEpoch=epoch,
        yieldName=nameOf(yieldState),
        progressName=nameOf(progressState),
        yieldState=yieldState,
        progressState=progressState,
        roleIndex=roleIndex,
        sideSign=sideSign,
        sideDiagnostic=sideSign == 1 and "progress-local-positive-normal" or "progress-local-negative-normal",
        sideX=sideX,
        sideZ=sideZ,
        currentSignedOffset=currentSignedOffset,
        progressExtent=progressExtent,
        progressExtentSource=progressSource,
        progressExtentConfidence=progressConfidence,
        progressExtentCoverage=progressProvider ~= nil and progressProvider.coverage or "none",
        yieldExtent=yieldExtent,
        yieldExtentSource=yieldSource,
        yieldExtentConfidence=yieldConfidence,
        yieldProviderCoverage=yieldProvider ~= nil and yieldProvider.coverage or "none",
        yieldExtentKind=yieldProvider ~= nil and yieldProvider.extentKind or "unspecified",
        yieldForwardExtent=yieldForwardExtent,
        yieldForwardExtentSource=yieldForwardSource,
        yieldForwardExtentConfidence=yieldForwardConfidence,
        yieldForwardCoverage=yieldForwardProvider ~= nil and yieldForwardProvider.coverage or "none",
        combinedConfidence=confidenceSummary(progressConfidence, yieldConfidence),
        physicalContactThreshold=physicalThreshold,
        policyMarginBudget=margins.budget,
        policyRequiredSeparation=policyRequired,
        proposedSignedSeparation=proposedSignedSeparation,
        physicalReserve=physicalReserve,
        policyReserve=policyReserve,
        rearwardCaptureMargin=rearwardCaptureMargin,
        rearwardCaptureReserve=rearwardCaptureReserve,
        lateralTravel=lateralTravel,
        rearwardTravel=rearwardTravel,
        totalTravel=totalTravel,
        targetX=targetX,
        targetZ=targetZ,
        predictedForwardX=predictedForwardX,
        predictedForwardZ=predictedForwardZ,
        solutionStatus="SOLVED",
        solutionReason="geometry-derived-lateral-and-rearward",
        evidence=evidence,
        aggregate=aggregate,
        costEligible=controlEligible,
        controlEligible=controlEligible,
        authority=false
    }
end

function Comparison:logCandidate(candidate)
    local evidence = candidate.evidence or {}
    OuttaMyWay.Logger:val(
        "PROTOTYPE19 CANDIDATE epoch=%s candidate=%s yield=%s progress=%s side=%s sideVector=(%s,%s) currentOffset=%sm solution=%s solutionReason=%s progressExtent=%sm progressSource=%s progressConfidence=%s progressCoverage=%s yieldFacingExtent=%sm yieldSource=%s yieldConfidence=%s yieldCoverage=%s yieldExtentKind=%s yieldForwardExtent=%sm yieldForwardSource=%s yieldForwardConfidence=%s yieldForwardCoverage=%s physicalThreshold=%sm policyMargin=%sm policyRequired=%sm proposedSeparation=%sm physicalReserve=%sm policyReserve=%sm lateralTravel=%sm rearwardTravel=%sm rearwardCaptureMargin=%sm rearwardCaptureReserve=%sm totalTravel=%sm target=(%s,%s) representation=%s refugePhysical=%s refugePolicy=%s rearwardCapture=%s egressPath=%s fieldContainment=%s obstacleClearance=%s progressPreservation=%s aggregate=%s controlEligible=%s authority=false action=none",
        tostring(candidate.assessmentEpoch), tostring(candidate.id), tostring(candidate.yieldName),
        tostring(candidate.progressName), tostring(candidate.sideDiagnostic or "unavailable"),
        fmt(candidate.sideX, 4), fmt(candidate.sideZ, 4), fmt(candidate.currentSignedOffset, 2),
        tostring(candidate.solutionStatus or "UNAVAILABLE"),
        tostring(candidate.solutionReason or "evidence-unavailable"),
        fmt(candidate.progressExtent, 2), tostring(candidate.progressExtentSource or "UNAVAILABLE"),
        tostring(candidate.progressExtentConfidence or "UNKNOWN"),
        tostring(candidate.progressExtentCoverage or "none"), fmt(candidate.yieldExtent, 2),
        tostring(candidate.yieldExtentSource or "UNAVAILABLE"),
        tostring(candidate.yieldExtentConfidence or "UNKNOWN"),
        tostring(candidate.yieldProviderCoverage or "none"),
        tostring(candidate.yieldExtentKind or "none"), fmt(candidate.yieldForwardExtent, 2),
        tostring(candidate.yieldForwardExtentSource or "UNAVAILABLE"),
        tostring(candidate.yieldForwardExtentConfidence or "UNKNOWN"),
        tostring(candidate.yieldForwardCoverage or "none"),
        fmt(candidate.physicalContactThreshold, 2), fmt(candidate.policyMarginBudget, 2),
        fmt(candidate.policyRequiredSeparation, 2), fmt(candidate.proposedSignedSeparation, 2),
        fmt(candidate.physicalReserve, 2), fmt(candidate.policyReserve, 2),
        fmt(candidate.lateralTravel, 2), fmt(candidate.rearwardTravel, 2),
        fmt(candidate.rearwardCaptureMargin, 2), fmt(candidate.rearwardCaptureReserve, 2),
        fmt(candidate.totalTravel, 2), fmt(candidate.targetX, 2), fmt(candidate.targetZ, 2),
        tostring(evidence.representation or "UNKNOWN"),
        tostring(evidence.refugePhysical or "UNKNOWN"),
        tostring(evidence.refugePolicy or "UNKNOWN"),
        tostring(evidence.rearwardCapture or "UNKNOWN"),
        tostring(evidence.egressPath or "UNKNOWN"),
        tostring(evidence.fieldContainment or "UNKNOWN"),
        tostring(evidence.obstacleClearance or "UNKNOWN"),
        tostring(evidence.progressPreservation or "UNKNOWN"),
        tostring(candidate.aggregate or "UNRESOLVED"), tostring(candidate.controlEligible == true))
end

function Comparison:buildEpoch(roles, nowMs, pairKey, admissionMetrics, stage)
    if self.enabled == nil then self:init() end
    if self.enabled ~= true then return nil end
    if type(roles) ~= "table" or #roles == 0 then return nil end

    self.epochSequence = (self.epochSequence or 0) + 1
    local rawNowMs = safeNumber(nowMs) or safeNumber(g_time) or 0
    local epoch = string.format("P19-%03d-%d", self.epochSequence, math.floor(rawNowMs))
    local budget = OuttaMyWay.TS015_PAIR_GEOMETRY_SCAN_BUDGET or 1000
    local geometryByVehicle = {}
    local inventoryByVehicle = self.inventoryByVehicle or {}
    self.inventoryByVehicle = inventoryByVehicle

    for _, role in ipairs(roles) do
        for _, state in ipairs({role.yieldState, role.progressState}) do
            if state ~= nil and state.vehicle ~= nil and geometryByVehicle[state.vehicle] == nil then
                local key = tostring(state.vehicle)
                local geometry, inventory = geometryFor(state.vehicle, budget,
                    inventoryByVehicle[key], rawNowMs)
                inventoryByVehicle[key] = inventory
                geometryByVehicle[state.vehicle] = geometry
            end
        end
    end

    OuttaMyWay.Logger:val(
        "PROTOTYPE19 ASSESSMENT_EPOCH epoch=%s stage=%s t=%.1fs clock=observer-relative pairKey=%s roles=%d candidates=%d fixedRole=false fixedSide=false fixed28=false fixed12=false headingDelta=%s tCPA=%s dCPA=%s",
        epoch, tostring(stage or "admission"), observerSeconds(rawNowMs), tostring(pairKey or "n/a"),
        #roles, #roles*2,
        admissionMetrics ~= nil and fmt(admissionMetrics.headingDelta, 1) or "n/a",
        admissionMetrics ~= nil and fmt(admissionMetrics.tcpa, 2) or "n/a",
        admissionMetrics ~= nil and fmt(admissionMetrics.dcpa, 2) or "n/a")

    local candidates = {}
    for roleIndex, role in ipairs(roles) do
        for _, sideSign in ipairs({-1, 1}) do
            local candidate = self:buildCandidate(epoch, role.yieldState, role.progressState,
                roleIndex, sideSign, rawNowMs,
                geometryByVehicle[role.yieldState.vehicle],
                geometryByVehicle[role.progressState.vehicle])
            candidates[#candidates+1] = candidate
            self:logCandidate(candidate)
        end
    end

    local eligible = {}
    local rejected, unresolved, solved, unavailable = 0, 0, 0, 0
    for _, candidate in ipairs(candidates) do
        if candidate.solutionStatus == "SOLVED" then solved = solved + 1 else unavailable = unavailable + 1 end
        if candidate.aggregate == "REJECTED" then rejected = rejected + 1
        elseif candidate.aggregate == "UNRESOLVED" then unresolved = unresolved + 1 end
        if candidate.controlEligible == true then eligible[#eligible+1] = candidate end
    end
    table.sort(eligible, candidateLess)
    local selected = eligible[1]
    if selected ~= nil then
        selected.authority = true
        selected.controlAuthority = true
        selected.selectionStage = stage or "admission"
        OuttaMyWay.Logger:ctl(
            "PROTOTYPE19 CONTROL_SELECTION epoch=%s stage=%s candidate=%s yield=%s progress=%s side=%s sideVector=(%.4f,%.4f) lateral=%.2fm rearward=%.2fm total=%.2fm selectionRule=least-lateral-then-total-then-deterministic-tie fixedRole=false fixedSide=false fixed28=false fixed12=false authority=true",
            epoch, tostring(stage or "admission"), tostring(selected.id), tostring(selected.yieldName),
            tostring(selected.progressName), tostring(selected.sideDiagnostic), selected.sideX, selected.sideZ,
            selected.lateralTravel, selected.rearwardTravel, selected.totalTravel)
    else
        OuttaMyWay.Logger:warning("VAL",
            "PROTOTYPE19 CONTROL_SELECTION_WITHHELD epoch=%s stage=%s solved=%d unavailable=%d reason=no-geometry-solved-safe-refuge noFallback=true",
            epoch, tostring(stage or "admission"), solved, unavailable)
    end

    local summary = {
        id=epoch,
        pairKey=pairKey,
        stage=stage or "admission",
        candidates=candidates,
        solvedCount=solved,
        unavailableCount=unavailable,
        eligibleCount=#eligible,
        rejectedCount=rejected,
        unresolvedCount=unresolved,
        selected=selected,
        authority=selected ~= nil
    }
    self.lastEpoch = summary
    OuttaMyWay.Logger:val(
        "PROTOTYPE19 MATRIX_SUMMARY epoch=%s stage=%s candidates=%d solved=%d unavailable=%d controlEligible=%d unresolved=%d rejected=%d selected=%s authority=%s noFallback=true",
        epoch, tostring(stage or "admission"), #candidates, solved, unavailable, #eligible,
        unresolved, rejected, selected ~= nil and tostring(selected.id) or "none",
        tostring(selected ~= nil))
    return summary
end

function Comparison:selectForEncounter(participantA, participantB, nowMs, pairKey, admissionMetrics)
    if participantA == nil or participantB == nil then return nil end
    local epoch = self:buildEpoch({
        {yieldState=participantA, progressState=participantB},
        {yieldState=participantB, progressState=participantA}
    }, nowMs, pairKey, admissionMetrics, "admission-role-selection")
    return epoch ~= nil and epoch.selected or nil, epoch
end

function Comparison:selectForRole(yieldState, progressState, nowMs, pairKey, admissionMetrics, stage)
    if yieldState == nil or progressState == nil then return nil end
    local epoch = self:buildEpoch({
        {yieldState=yieldState, progressState=progressState}
    }, nowMs, pairKey, admissionMetrics, stage or "admission-fixed-runtime-role")
    return epoch ~= nil and epoch.selected or nil, epoch
end

function Comparison:recalculateForRole(yieldState, progressState, nowMs, pairKey)
    if yieldState == nil or progressState == nil then return nil end
    local epoch = self:buildEpoch({
        {yieldState=yieldState, progressState=progressState}
    }, nowMs, pairKey, nil, "confirmed-stop-side-and-distance")
    return epoch ~= nil and epoch.selected or nil, epoch
end

-- Compatibility entry point retained for status tooling. It now performs the
-- same four-candidate calculation but does not itself start Control.
function Comparison:observe(participantA, participantB, nowMs, pairKey, admissionMetrics)
    local _, epoch = self:selectForEncounter(participantA, participantB,
        nowMs, pairKey, admissionMetrics)
    return epoch
end

function Comparison:statusText()
    if self.enabled == nil then self:init() end
    local epoch = self.lastEpoch
    if epoch == nil then return "state=awaiting-assessment-epoch authority=false" end
    return string.format(
        "epoch=%s stage=%s solved=%d unavailable=%d eligible=%d selected=%s authority=%s",
        tostring(epoch.id), tostring(epoch.stage), tonumber(epoch.solvedCount) or 0,
        tonumber(epoch.unavailableCount) or 0, tonumber(epoch.eligibleCount) or 0,
        epoch.selected ~= nil and tostring(epoch.selected.id) or "none",
        tostring(epoch.authority == true))
end

function Comparison:clear()
    self.enabled = nil
    self.epochSequence = 0
    self.lastEpoch = nil
    self.inventoryByVehicle = {}
end
