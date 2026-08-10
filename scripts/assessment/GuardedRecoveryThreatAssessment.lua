-- Architecture-aligned D-0123 Guarded Recovery threat representation.
--
-- Pure Situation-Assessment helper only. It consumes sealed Observation/Knowledge
-- values supplied by SituationAssessment and returns representation results. It
-- has no GIANTS runtime-object access, no event-listener lifecycle and no Control
-- authority.

OuttaMyWay.GuardedRecoveryThreatAssessment = {}
local Probe = OuttaMyWay.GuardedRecoveryThreatAssessment

local function cross(ax, az, bx, bz)
    return ax * bz - az * bx
end

local function pointDistance(px, pz, qx, qz)
    local dx, dz = px - qx, pz - qz
    return math.sqrt(dx * dx + dz * dz)
end

local function pointToSegmentDistance(px, pz, ax, az, bx, bz)
    local abx, abz = bx - ax, bz - az
    local denom = abx * abx + abz * abz
    if denom <= 1e-9 then return pointDistance(px, pz, ax, az) end
    local t = ((px - ax) * abx + (pz - az) * abz) / denom
    t = math.max(0, math.min(1, t))
    return pointDistance(px, pz, ax + abx * t, az + abz * t)
end

local function pointToRayDistance(px, pz, rx, rz, dx, dz)
    local projection = (px - rx) * dx + (pz - rz) * dz
    if projection <= 0 then return pointDistance(px, pz, rx, rz) end
    return pointDistance(px, pz, rx + dx * projection, rz + dz * projection)
end

local function raySegmentIntersects(rx, rz, dx, dz, ax, az, bx, bz)
    local sx, sz = bx - ax, bz - az
    local denominator = cross(dx, dz, sx, sz)
    if math.abs(denominator) <= 1e-9 then return false end
    local arx, arz = ax - rx, az - rz
    local t = cross(arx, arz, sx, sz) / denominator
    local u = cross(arx, arz, dx, dz) / denominator
    return t >= 0 and u >= 0 and u <= 1
end

local function raySegmentDistance(rx, rz, dx, dz, ax, az, bx, bz)
    if raySegmentIntersects(rx, rz, dx, dz, ax, az, bx, bz) then return 0 end
    return math.min(
        pointToRayDistance(ax, az, rx, rz, dx, dz),
        pointToRayDistance(bx, bz, rx, rz, dx, dz),
        pointToSegmentDistance(rx, rz, ax, az, bx, bz)
    )
end

local function directionFromTravel(previousPose, currentPose)
    if previousPose == nil or currentPose == nil then return nil end
    local dx, dz = currentPose.x - previousPose.x, currentPose.z - previousPose.z
    local length = math.sqrt(dx * dx + dz * dz)
    -- Numeric stability only; this carries no speed/policy authority.
    if length <= 0.01 then return nil end
    return {dx=dx/length,dz=dz/length,distance=length}
end

local function vulnerableHypotheses(context, recoveryPose, currentRadius)
    local target={x=context.rejoinTargetX,z=context.rejoinTargetZ}
    local anchor={x=context.rejoinAnchorX,z=context.rejoinAnchorZ}
    local deployedRadius=math.max(currentRadius or 0, (context.recoveryInitialSpanM or context.initialSpanM or 0) * 0.5)
    return {
        CURRENT_TO_REJOIN={
            id="VS_CURRENT_TO_REJOIN",
            segments={{ax=recoveryPose.x,az=recoveryPose.z,bx=target.x,bz=target.z,radius=currentRadius}},
            basis="CURRENT_RECOVERY_POSE_TO_KNOWN_REJOIN_TARGET_CURRENT_REALIZED_SPAN"
        },
        CURRENT_TO_ANCHOR={
            id="VS_CURRENT_TO_ANCHOR",
            segments={{ax=recoveryPose.x,az=recoveryPose.z,bx=anchor.x,bz=anchor.z,radius=currentRadius}},
            basis="CURRENT_RECOVERY_POSE_TO_RETAINED_REJOIN_ANCHOR_CURRENT_REALIZED_SPAN"
        },
        COMMITTED_RECOVERY_UNION={
            id="VS_COMMITTED_RECOVERY_UNION",
            segments={
                {ax=recoveryPose.x,az=recoveryPose.z,bx=target.x,bz=target.z,radius=currentRadius},
                {ax=target.x,az=target.z,bx=anchor.x,bz=anchor.z,radius=deployedRadius}
            },
            basis="KNOWN_REMAINING_P22_RECOVERY_LEGS_WITH_CURRENT_AND_PRE_INTERVENTION_REALIZED_SPAN"
        }
    }
end

local function rayAgainstVulnerable(ray, vulnerable, progressRadius)
    if ray == nil then return {resolved=false,positive=false,clearance=nil} end
    local minimumClearance=math.huge
    for _,segment in ipairs(vulnerable.segments or {}) do
        local distance=raySegmentDistance(ray.x,ray.z,ray.dx,ray.dz,segment.ax,segment.az,segment.bx,segment.bz)
        local clearance=distance - ((segment.radius or 0) + (progressRadius or 0))
        minimumClearance=math.min(minimumClearance,clearance)
    end
    return {resolved=minimumClearance<math.huge,positive=minimumClearance<=0,clearance=minimumClearance}
end

function Probe.evaluateGeometry(input)
    local recovery=input and input.recoveryPose or nil
    local progress=input and input.progressPose or nil
    if recovery==nil or progress==nil or input.rejoinTargetX==nil or input.rejoinTargetZ==nil or input.rejoinAnchorX==nil or input.rejoinAnchorZ==nil then
        return {resolved=false,reason="GEOMETRY_INPUT_INCOMPLETE"}
    end
    if input.recoveryCurrentSpanM==nil or input.progressSpanM==nil then
        return {resolved=false,reason="POSITIVE_REPRESENTED_SPAN_UNAVAILABLE"}
    end
    local currentRadius=math.max(0,tonumber(input.recoveryCurrentSpanM) * 0.5)
    local progressRadius=math.max(0,tonumber(input.progressSpanM) * 0.5)
    local vulnerable=vulnerableHypotheses(input,recovery,currentRadius)
    local travel=directionFromTravel(input.previousProgressPose,progress)
    local rays={
        HEADING={id="CP_CURRENT_HEADING",x=progress.x,z=progress.z,dx=progress.dx,dz=progress.dz,basis="CURRENT_REVEALED_HEADING"},
        TRAVEL=travel and {id="CP_OBSERVED_TRAVEL",x=progress.x,z=progress.z,dx=travel.dx,dz=travel.dz,basis="OBSERVED_DISPLACEMENT_DIRECTION"} or nil,
        PREVIOUS_HEADING=input.previousProgressPose and {id="CP_PREVIOUS_HEADING",x=progress.x,z=progress.z,dx=input.previousProgressPose.dx,dz=input.previousProgressPose.dz,basis="PREVIOUSLY_REVEALED_HEADING"} or nil
    }
    local projections={
        CURRENT_HEADING={id="CP_CURRENT_HEADING",rays={rays.HEADING}},
        OBSERVED_TRAVEL={id="CP_OBSERVED_TRAVEL",rays={rays.TRAVEL}},
        REVEALED_TURN_SWEEP={id="CP_REVEALED_TURN_SWEEP",rays={rays.PREVIOUS_HEADING,rays.HEADING}}
    }
    local combinations={}
    for vulnerableKey,v in pairs(vulnerable) do
        for projectionKey,p in pairs(projections) do
            local resolved=false
            local positive=false
            local clearance=math.huge
            for _,ray in ipairs(p.rays or {}) do
                local result=rayAgainstVulnerable(ray,v,progressRadius)
                if result.resolved then
                    resolved=true
                    positive=positive or result.positive
                    clearance=math.min(clearance,result.clearance or math.huge)
                end
            end
            local key=vulnerableKey.."__"..projectionKey
            combinations[key]={
                vulnerableId=v.id,projectionId=p.id,resolved=resolved,positive=positive,
                clearance=resolved and clearance or nil,vulnerableBasis=v.basis
            }
        end
    end
    return {
        resolved=true,
        recoveryRadius=currentRadius,
        progressRadius=progressRadius,
        travel=travel,
        combinations=combinations
    }
end


local function positiveContinuingEvidence(classification)
    return classification == "NON_TURN_LINE_ACTIVE" or classification == "TURN_SEGMENT"
end

function Probe.evaluateCurrentHeadingSignal(sample)
    if type(sample) ~= "table" then
        return {status="UNRESOLVED", reason="NO_RECOVERY_SAMPLE"}
    end
    if sample.geometryResolved ~= true or type(sample.combinations) ~= "table" then
        return {status="UNRESOLVED", reason=tostring(sample.geometryReason or "GEOMETRY_UNRESOLVED")}
    end
    local combination = sample.combinations.COMMITTED_RECOVERY_UNION__CURRENT_HEADING
    if type(combination) ~= "table" or combination.resolved ~= true then
        return {status="UNRESOLVED", reason="D0123_COMBINATION_UNRESOLVED"}
    end
    local expectedJob = sample.progressExpectedJobToken
    local evidenceJob = sample.progressEvidenceJobToken
    if expectedJob ~= nil and evidenceJob ~= nil and tostring(expectedJob) ~= tostring(evidenceJob) then
        return {status="INVALIDATED", reason="PROGRESS_JOB_EPISODE_CHANGED", combination=combination}
    end
    if expectedJob == nil or evidenceJob == nil then
        return {status="UNRESOLVED", reason="PROGRESS_JOB_EVIDENCE_UNAVAILABLE", combination=combination}
    end
    if sample.progressMovingDirection ~= 1 then
        return {status="UNRESOLVED", reason=sample.progressMovingDirection == -1 and "REVERSE_REVEALED_DIRECTION_NOT_REPRESENTED_BY_CURRENT_HEADING_TEST" or "CURRENT_NATIVE_MOVEMENT_DIRECTION_UNRESOLVED", combination=combination}
    end
    if not positiveContinuingEvidence(sample.progressEvidenceClass) then
        return {status="UNRESOLVED", reason="POSITIVE_CONTINUING_NATIVE_INTENT_UNRESOLVED", combination=combination}
    end
    if combination.positive == true then
        return {status="POSITIVE", reason="REVEALED_NATIVE_CONTINUATION_INTERSECTS_VULNERABLE_SPACE", combination=combination}
    end
    return {status="NEGATIVE", reason="POSITIVE_CURRENT_HEADING_CLEAR_OF_VULNERABLE_SPACE", combination=combination}
end

