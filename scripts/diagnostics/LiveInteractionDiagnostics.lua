OuttaMyWay.LiveInteractionDiagnostics = {}
local Diagnostics = OuttaMyWay.LiveInteractionDiagnostics

local function clamp(value, minimum, maximum)
    if value < minimum then return minimum end
    if value > maximum then return maximum end
    return value
end

function Diagnostics.pairReferenceKey(firstReferenceKey, secondReferenceKey)
    local first = tostring(firstReferenceKey)
    local second = tostring(secondReferenceKey)
    if second < first then first, second = second, first end
    return "live-pair:" .. first .. ":" .. second
end

function Diagnostics.deriveMotion(previousPose, currentPose, previousTimestamp, currentTimestamp, reportedSpeedMps)
    local result = {
        classification = "MOTION_EVIDENCE_UNRESOLVED",
        reportedSpeedMps = tonumber(reportedSpeedMps) or 0,
        sampleIntervalSeconds = nil,
        positionDerivedSpeedMps = nil,
        travelDirectionX = nil,
        travelDirectionZ = nil,
        headingToTravelDot = nil,
        headingChangeDegrees = nil,
        yawRateDegreesPerSecond = nil,
        speedDeltaMps = nil
    }
    if previousPose == nil or currentPose == nil or previousTimestamp == nil or currentTimestamp == nil then
        result.reason = "NO_PREVIOUS_POSE_SAMPLE"
        return result
    end
    local interval = tonumber(currentTimestamp) - tonumber(previousTimestamp)
    result.sampleIntervalSeconds = interval
    if interval <= 0.0001 then
        result.reason = "NON_POSITIVE_SAMPLE_INTERVAL"
        return result
    end

    local deltaX = currentPose.x - previousPose.x
    local deltaZ = currentPose.z - previousPose.z
    local distance = math.sqrt(deltaX * deltaX + deltaZ * deltaZ)
    local derivedSpeed = distance / interval
    result.positionDerivedSpeedMps = derivedSpeed
    result.speedDeltaMps = derivedSpeed - result.reportedSpeedMps

    local headingDot = clamp((previousPose.dx or 0) * (currentPose.dx or 0) + (previousPose.dz or 0) * (currentPose.dz or 0), -1, 1)
    local headingChangeDegrees = math.deg(math.acos(headingDot))
    result.headingChangeDegrees = headingChangeDegrees
    result.yawRateDegreesPerSecond = headingChangeDegrees / interval

    if distance > 0.01 then
        result.travelDirectionX = deltaX / distance
        result.travelDirectionZ = deltaZ / distance
        result.headingToTravelDot = currentPose.dx * result.travelDirectionX + currentPose.dz * result.travelDirectionZ
    end

    if derivedSpeed < 0.05 and result.reportedSpeedMps < 0.05 then
        result.classification = "STATIONARY"
        result.reason = "POSITION_AND_REPORTED_SPEED_NEAR_ZERO"
    elseif result.headingToTravelDot == nil then
        result.classification = "MOTION_EVIDENCE_UNRESOLVED"
        result.reason = "DISPLACEMENT_TOO_SMALL_FOR_TRAVEL_DIRECTION"
    elseif result.headingToTravelDot < -0.5 then
        result.classification = "REVERSING_OR_OPPOSED_TRAVEL"
        result.reason = "TRAVEL_DIRECTION_OPPOSES_HEADING"
    elseif result.yawRateDegreesPerSecond > 5 then
        result.classification = "TURNING"
        result.reason = "HEADING_CHANGE_EXCEEDS_DIAGNOSTIC_THRESHOLD"
    else
        result.classification = "STABLE_FORWARD"
        result.reason = "TRAVEL_DIRECTION_ALIGNS_WITH_HEADING"
    end
    return result
end

function Diagnostics.observePairState(subject, other)
    local rx = other.pose.x - subject.pose.x
    local rz = other.pose.z - subject.pose.z
    local distance = math.sqrt(rx * rx + rz * rz)
    local subjectVelocityX = subject.pose.dx * subject.speedMps
    local subjectVelocityZ = subject.pose.dz * subject.speedMps
    local otherVelocityX = other.pose.dx * other.speedMps
    local otherVelocityZ = other.pose.dz * other.speedMps
    local relativeVelocityX = otherVelocityX - subjectVelocityX
    local relativeVelocityZ = otherVelocityZ - subjectVelocityZ
    local relativeSpeedSquared = relativeVelocityX * relativeVelocityX + relativeVelocityZ * relativeVelocityZ
    local relativeSpeed = math.sqrt(relativeSpeedSquared)
    local required = (subject.radius or 0) + (other.radius or 0)
    local bothRadiiAvailable = subject.radius ~= nil and other.radius ~= nil
    local current = bothRadiiAvailable and distance <= required

    local outcome
    if current then
        outcome = "CURRENT_INTERACTION_QUALIFIED"
    elseif subject.radius == nil then
        outcome = "MISSING_SUBJECT_RADIUS"
    elseif other.radius == nil then
        outcome = "MISSING_OTHER_RADIUS"
    else
        outcome = "CURRENT_INTERACTION_UNRESOLVED"
    end

    return {
        distance = distance,
        required = required,
        current = current,
        closingRate = distance > 0.001 and -((rx * relativeVelocityX + rz * relativeVelocityZ) / distance) or 0,
        headingDot = subject.pose.dx * other.pose.dx + subject.pose.dz * other.pose.dz,
        subjectVelocityX = subjectVelocityX,
        subjectVelocityZ = subjectVelocityZ,
        otherVelocityX = otherVelocityX,
        otherVelocityZ = otherVelocityZ,
        relativeVelocityX = relativeVelocityX,
        relativeVelocityZ = relativeVelocityZ,
        relativeSpeedMps = relativeSpeed,
        principalOutcome = outcome,
        currentSuppressionReason = current and nil or (bothRadiiAvailable and "CURRENT_DISTANCE_EXCEEDS_REPRESENTED_ENVELOPE" or outcome),
        interactionEvidenceEmitted = current
    }
end
