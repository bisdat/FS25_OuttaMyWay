-- FS25_OuttaMyWay v4.6.50 architecture recovery candidate.
-- Prototype 17 / TS017-B: observer-only shadow clearance calculation with a fixture-bounded Facing Extent Provider.
--
-- This module derives a candidate lateral separation from current runtime evidence.
-- It remains an observer-only clearance reporter. Calculated refuge selection and
-- confirmed-stop recalculation own current role, side and movement authority.

OuttaMyWay.ShadowClearanceCalculator = OuttaMyWay.ShadowClearanceCalculator or {}
local Calculator = OuttaMyWay.ShadowClearanceCalculator

local function safeNumber(value)
    value = tonumber(value)
    if value == nil or value ~= value or value == math.huge or value == -math.huge then return nil end
    return value
end

local function vehicleNode(vehicle)
    if vehicle == nil or vehicle.isDeleted == true then return nil end
    if type(vehicle.getAISteeringNode) == "function" then
        local ok, node = pcall(vehicle.getAISteeringNode, vehicle)
        if ok and node ~= nil and node ~= 0 then return node end
    end
    local node = vehicle.rootNode
    return node ~= nil and node ~= 0 and node or nil
end

local function positionOf(vehicle)
    local node = vehicleNode(vehicle)
    if node == nil then return nil, nil end
    local ok, x, _, z = pcall(getWorldTranslation, node)
    if not ok then return nil, nil end
    return x, z
end

local function directionOf(vehicle)
    local node = vehicleNode(vehicle)
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
    if width ~= nil and (width < 0.25 or width > 80) then width = nil end
    if length ~= nil and (length < 0.25 or length > 80) then length = nil end
    return width, length
end

local function rectangleExtent(width, length, forwardX, forwardZ, axisX, axisZ)
    if width == nil or length == nil or forwardX == nil or forwardZ == nil then return nil end
    local fx, fz = normalized(forwardX, forwardZ)
    if fx == nil then return nil end
    -- With GIANTS local +Z as forward, the matching planar local +X direction is (fz,-fx).
    local rightX, rightZ = fz, -fx
    return (width * 0.5) * math.abs(dot(rightX, rightZ, axisX, axisZ))
        + (length * 0.5) * math.abs(dot(fx, fz, axisX, axisZ))
end

local function hasCompleteDiscoveredEnvelope(geometry)
    return geometry ~= nil
        and geometry.confidence == "HIGH_DISCOVERED"
        and geometry.coverage == "ALL_OBJECTS_DISCOVERED"
        and geometry.truncated ~= true
end

local function progressFacingExtent(run, geometry, sideX, sideZ)
    local px, pz = positionOf(run.progressVehicle)
    local corners = hasCompleteDiscoveredEnvelope(geometry) and cornersFor(geometry) or nil
    local physical = projectedOneSidedExtent(corners, px, pz, sideX, sideZ)
    if physical ~= nil then
        return physical, "LIVE_COMPLETE_DISCOVERED_ENVELOPE", "HIGH_DISCOVERED"
    end

    local markerWidth = geometry ~= nil and safeNumber(geometry.workingMarkerWidth) or nil
    if markerWidth ~= nil and markerWidth >= 0.25 and markerWidth <= 150 then
        return markerWidth * 0.5, "LIVE_AI_MARKER_WORKING_WIDTH_HALF", "MEDIUM_WORKING_EXTENT"
    end

    local fallbackWidth = safeNumber(OuttaMyWay.TS017_PROGRESS_WORKING_WIDTH_FALLBACK_M)
    if fallbackWidth ~= nil then
        return fallbackWidth * 0.5, "FIXTURE_WORKING_WIDTH_HALF_FALLBACK", "LOW_FIXTURE_FALLBACK"
    end

    local width = metadataDimensions(run.progressVehicle, geometry)
    if width ~= nil then
        return width * 0.5, "SIZE_METADATA_WIDTH_HALF", "LOW_METADATA"
    end
    return nil, "UNAVAILABLE", "UNKNOWN"
end

local function predictedRefugeDirection(run)
    local lateral = safeNumber(run ~= nil and run.controlLateralM or nil)
    local rearward = safeNumber(run ~= nil and run.controlRearwardM or nil)
    local sideX = run ~= nil and safeNumber(run.refugeSideX) or nil
    local sideZ = run ~= nil and safeNumber(run.refugeSideZ) or nil
    if lateral == nil or rearward == nil or sideX == nil or sideZ == nil then return nil, nil end
    return normalized(sideX * lateral - run.forwardX * rearward,
        sideZ * lateral - run.forwardZ * rearward)
end

local function yieldFacingExtent(run, geometry, sideX, sideZ, mode, predictedForwardX, predictedForwardZ)
    local provider = OuttaMyWay.FacingExtentProvider
    if provider ~= nil and type(provider.compactYieldExtent) == "function" then
        local ok, result = pcall(provider.compactYieldExtent, provider, run.vehicle,
            -sideX, -sideZ, mode, predictedForwardX, predictedForwardZ)
        if ok and result ~= nil and safeNumber(result.extent) ~= nil then
            return result.extent, result.source or "FACING_EXTENT_PROVIDER",
                result.confidence or "UNKNOWN", result
        end
    end

    if mode == "LIVE" then
        local yx, yz = positionOf(run.vehicle)
        local corners = hasCompleteDiscoveredEnvelope(geometry) and cornersFor(geometry) or nil
        local physical = projectedOneSidedExtent(corners, yx, yz, -sideX, -sideZ)
        if physical ~= nil then
            return physical, "LIVE_COMPLETE_DISCOVERED_ENVELOPE", "HIGH_DISCOVERED", nil
        end
    end

    local width, length = metadataDimensions(run.vehicle, geometry)
    local forwardX, forwardZ
    local poseSource
    if mode == "PRE" then
        forwardX, forwardZ = predictedRefugeDirection(run)
        poseSource = "PREDICTED_EGRESS_BEARING"
    else
        forwardX, forwardZ = directionOf(run.vehicle)
        poseSource = "LIVE_VEHICLE_HEADING"
    end
    local extent = rectangleExtent(width, length, forwardX, forwardZ, sideX, sideZ)
    if extent ~= nil then
        return extent, "SIZE_METADATA_RECTANGLE_" .. poseSource, "LOW_POSE_MODEL", nil
    end
    return nil, "UNAVAILABLE", "UNKNOWN", nil
end

local function policyMargins()
    local geometry = safeNumber(OuttaMyWay.TS017_GEOMETRY_UNCERTAINTY_M) or 0.75
    local tracking = safeNumber(OuttaMyWay.TS017_TRACKING_TOLERANCE_M) or 1.00
    local motion = safeNumber(OuttaMyWay.TS017_MOTION_ALLOWANCE_M) or 0.50
    local policy = safeNumber(OuttaMyWay.TS017_POLICY_MARGIN_M) or 1.50
    return {
        geometry = geometry,
        tracking = tracking,
        motion = motion,
        policy = policy,
        budget = geometry + tracking + motion + policy
    }
end

local function combinedConfidence(progressConfidence, yieldConfidence)
    if progressConfidence == "HIGH_DISCOVERED" and yieldConfidence == "HIGH_DISCOVERED" then
        return "HIGH_DISCOVERED"
    end
    if progressConfidence == "UNKNOWN" or yieldConfidence == "UNKNOWN" then return "UNKNOWN" end
    if string.find(progressConfidence, "LOW", 1, true) or string.find(yieldConfidence, "LOW", 1, true) then
        return "LOW_MODELLED"
    end
    return "MEDIUM_MIXED"
end

function Calculator:sample(run, nowMs, mode)
    if run == nil or run.vehicle == nil or run.progressVehicle == nil then return nil end
    mode = mode == "PRE" and "PRE" or "LIVE"
    local sideX, sideZ = normalized(run.refugeSideX, run.refugeSideZ)
    if sideX == nil then return nil end

    local budget = OuttaMyWay.TS015_PAIR_GEOMETRY_SCAN_BUDGET or 1000
    local yieldGeometry, yieldInventory = geometryFor(run.vehicle, budget, run.yieldGeometryInventory, nowMs)
    local progressGeometry, progressInventory = geometryFor(run.progressVehicle, budget, run.progressGeometryInventory, nowMs)
    run.yieldGeometryInventory = yieldInventory
    run.progressGeometryInventory = progressInventory

    local predictedForwardX, predictedForwardZ = predictedRefugeDirection(run)
    local progressExtent, progressSource, progressConfidence = progressFacingExtent(
        run, progressGeometry, sideX, sideZ)
    local yieldExtent, yieldSource, yieldConfidence, yieldProvider = yieldFacingExtent(
        run, yieldGeometry, sideX, sideZ, mode, predictedForwardX, predictedForwardZ)
    local margin = policyMargins()
    local physicalContactThreshold = progressExtent ~= nil and yieldExtent ~= nil
        and progressExtent + yieldExtent or nil
    local policyMarginBudget = margin.budget
    local policyRequiredSeparation = physicalContactThreshold ~= nil
        and physicalContactThreshold + policyMarginBudget or nil

    local yieldX, yieldZ = positionOf(run.vehicle)
    local progressX, progressZ = positionOf(run.progressVehicle)
    local referenceSeparation = nil
    if yieldX ~= nil and progressX ~= nil then
        referenceSeparation = (yieldX - progressX) * sideX + (yieldZ - progressZ) * sideZ
    end
    local physicalClearanceReserve = physicalContactThreshold ~= nil and referenceSeparation ~= nil
        and referenceSeparation - physicalContactThreshold or nil
    local policyReserve = policyRequiredSeparation ~= nil and referenceSeparation ~= nil
        and referenceSeparation - policyRequiredSeparation or nil

    local diagnosticClearance, diagnosticIntersected = nil, false
    local evidence = OuttaMyWay.PhysicalEnvelopeEvidence
    local yieldCorners, progressCorners = cornersFor(yieldGeometry), cornersFor(progressGeometry)
    if evidence ~= nil and type(evidence.polygonClearance) == "function"
        and yieldCorners ~= nil and progressCorners ~= nil then
        local ok, clearance, intersected = pcall(evidence.polygonClearance, yieldCorners, progressCorners)
        if ok then
            diagnosticClearance = clearance
            diagnosticIntersected = intersected == true
        end
    end

    local yieldWidth, yieldLength = metadataDimensions(run.vehicle, yieldGeometry)
    local progressWidth, progressLength = metadataDimensions(run.progressVehicle, progressGeometry)
    local actualForwardX, actualForwardZ = directionOf(run.vehicle)

    return {
        mode = mode,
        authority = false,
        sideX = sideX,
        sideZ = sideZ,
        controlTarget = safeNumber(run.controlLateralM),
        progressExtent = progressExtent,
        progressExtentSource = progressSource,
        progressExtentConfidence = progressConfidence,
        yieldExtent = yieldExtent,
        yieldExtentSource = yieldSource,
        yieldExtentConfidence = yieldConfidence,
        yieldProviderCoverage = yieldProvider ~= nil and yieldProvider.coverage or "none",
        yieldProviderExpected = yieldProvider ~= nil and yieldProvider.expectedCount or nil,
        yieldProviderResolved = yieldProvider ~= nil and yieldProvider.resolvedCount or nil,
        yieldProviderBounded = yieldProvider ~= nil and yieldProvider.boundedCount or nil,
        yieldProviderOrigins = yieldProvider ~= nil and yieldProvider.originCount or nil,
        yieldProviderOriginExtent = yieldProvider ~= nil and yieldProvider.originExtent or nil,
        yieldProviderPhysicalAllowance = yieldProvider ~= nil and yieldProvider.physicalAllowance or nil,
        yieldProviderApiSummary = yieldProvider ~= nil and yieldProvider.apiSummary or "none",
        yieldProviderScanTruncated = yieldProvider ~= nil and yieldProvider.scanTruncated == true or false,
        yieldProviderPoseSource = yieldProvider ~= nil and yieldProvider.poseSource or "none",
        combinedConfidence = combinedConfidence(progressConfidence, yieldConfidence),
        margins = margin,
        physicalContactThreshold = physicalContactThreshold,
        physicalClearanceReserve = physicalClearanceReserve,
        policyMarginBudget = policyMarginBudget,
        policyRequiredSeparation = policyRequiredSeparation,
        policyReserve = policyReserve,
        referenceSeparation = referenceSeparation,
        yieldMetadataWidth = yieldWidth,
        yieldMetadataLength = yieldLength,
        progressMetadataWidth = progressWidth,
        progressMetadataLength = progressLength,
        progressWorkingMarkerWidth = progressGeometry ~= nil and safeNumber(progressGeometry.workingMarkerWidth) or nil,
        yieldGeometryConfidence = yieldGeometry ~= nil and yieldGeometry.confidence or "UNKNOWN",
        progressGeometryConfidence = progressGeometry ~= nil and progressGeometry.confidence or "UNKNOWN",
        diagnosticClearance = diagnosticClearance,
        diagnosticIntersected = diagnosticIntersected,
        predictedForwardX = predictedForwardX,
        predictedForwardZ = predictedForwardZ,
        actualForwardX = actualForwardX,
        actualForwardZ = actualForwardZ,
        referenceSource = "AI_STEERING_NODE",
        corridorAssumption = "SHARED_CENTRELINE_AT_CONFIRMED_STOP",
        predictedPoseAssumption = mode == "PRE" and "FORWARD_ALIGNS_WITH_DIRECT_EGRESS_BEARING" or "LIVE_HEADING"
    }
end
