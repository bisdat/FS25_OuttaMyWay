-- FS25_OuttaMyWay v4.6.21
-- Prototype 13A: explicit fixture route evaluation with candidate-preserving logs.
-- Passive only: no footprint, closure, conflict, Decision, Commitment or Control.

OuttaMyWay.DeclaredRouteEvaluationProbe = OuttaMyWay.DeclaredRouteEvaluationProbe or {}
local Probe = OuttaMyWay.DeclaredRouteEvaluationProbe

local function safeName(object)
    if object ~= nil and type(object.getName) == "function" then
        local ok, name = pcall(object.getName, object)
        if ok and name ~= nil and name ~= "" then return tostring(name) end
    end
    return "unnamed-member"
end

local function assetName(object)
    return OuttaMyWay.Prototype13Fixtures:assetName(object)
end

local function foldAnimTime(object)
    local spec = object and object.spec_foldable or nil
    local value = spec and tonumber(spec.foldAnimTime) or nil
    if value == nil and object ~= nil and type(object.getFoldAnimTime) == "function" then
        local ok, result = pcall(object.getFoldAnimTime, object)
        if ok then value = tonumber(result) end
    end
    return value
end

local function animationRegion(value)
    if value == nil then return "UNKNOWN" end
    if value <= 0.02 then return "LOW_ENDPOINT" end
    if value >= 0.98 then return "HIGH_ENDPOINT" end
    return "INTERIOR"
end

local function animationMotion(state, value, nowMs)
    if value == nil then return "UNKNOWN" end

    local previous = state.lastAnimationValue
    state.lastAnimationValue = value
    if previous == nil then
        state.lastAnimationChangeMs = nowMs
        return "UNOBSERVED"
    end

    local epsilon = OuttaMyWay.PROTOTYPE_13_ANIMATION_CHANGE_EPSILON or 0.0005
    if math.abs(value - previous) > epsilon then
        state.lastAnimationChangeMs = nowMs
        return "CHANGING"
    end

    local stableMs = OuttaMyWay.PROTOTYPE_13_ANIMATION_STABLE_MS or 500
    if nowMs - (state.lastAnimationChangeMs or nowMs) >= stableMs then
        return "STABLE"
    end
    return "SETTLING"
end

local function fmt(value, digits)
    if type(value) ~= "number" then return "unknown" end
    return string.format("%." .. tostring(digits or 4) .. "f", value)
end

local function text(value)
    if value == nil then return "none" end
    return tostring(value)
end

local function routeList(routes)
    if type(routes) ~= "table" or #routes == 0 then return "none" end
    return table.concat(routes, ",")
end

local function enumerateFixtureMembers()
    local result, seen = {}, {}
    local function inspect(source)
        if type(source) ~= "table" then return end
        for _, object in pairs(source) do
            if object ~= nil and object.isDeleted ~= true and not seen[object] then
                seen[object] = true
                local fixture = OuttaMyWay.Prototype13Fixtures:match(object)
                if fixture ~= nil then result[#result+1] = {object=object, fixture=fixture} end
            end
        end
    end
    inspect(g_currentMission and g_currentMission.vehicles or nil)
    inspect(g_currentMission and g_currentMission.vehicleSystem and g_currentMission.vehicleSystem.vehicles or nil)
    table.sort(result, function(a,b)
        local ak = a.fixture.id .. ":" .. tostring(a.object)
        local bk = b.fixture.id .. ":" .. tostring(b.object)
        return ak < bk
    end)
    return result
end

local function memberLocalPosition(member, node)
    if member == nil or node == nil or type(getWorldTranslation) ~= "function" or type(worldToLocal) ~= "function" then return nil end
    local okW, x, y, z = pcall(getWorldTranslation, node)
    if not okW then return nil end
    local root = member.rootNode
    if root == nil or root == 0 then return nil end
    local okL, lx, ly, lz = pcall(worldToLocal, root, x, y, z)
    if not okL then return nil end
    return {x=lx, y=ly, z=lz}
end

local function distance(a, b)
    if a == nil or b == nil then return nil end
    local dx, dy, dz = a.x-b.x, a.y-b.y, a.z-b.z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

function Probe:init()
    self.enabled = OuttaMyWay.PROTOTYPE_13_ENABLED == true
    self.elapsedMs = 0
    self.startedAtMs = g_time or 0
    self.states = {}
    OuttaMyWay.Prototype13Evaluator:init()
    if self.enabled then
        OuttaMyWay.Logger:info("PROTOTYPE13A ACTIVE: Declared Route Evaluation; explicit fixtures, candidate-preserving common evaluator, negative controls; passive; no footprint, closure or control")
    else
        OuttaMyWay.Logger:info("PROTOTYPE13A DISABLED")
    end
end

function Probe:logCandidate(nowSeconds, state, shape, candidate)
    OuttaMyWay.Logger:obs(
        "PROTOTYPE13A CANDIDATE t=%.1fs fixture=%s scenario=%s member=%s sourceShape=%s sourceNode=%s sourceShapeId=%s candidate=%s route=%s control=%s mappingKey=%s declaredComponent=%s expectedComponent=%s actualComponent=%s path=%s anchorNode=%s anchorSource=%s runtimeNode=%s runtimeName=%s nodeExists=%s ownership=%s componentCoherence=%s hierarchyNameCoherence=%s geometryAuthority=%s poseValidity=%s rootAlias=%s worldCentreError=%s worldRadiusError=%s geometryRadius=%s worldRadius=%s error=%s action=none",
        nowSeconds, state.fixture.id, state.fixture.scenario, state.name, shape.id, shape.sourceNode, text(shape.sourceShapeId),
        text(candidate.label), text(candidate.routeType), tostring(candidate.control == true), text(candidate.mappingKey),
        text(candidate.declaredComponentIndex), text(shape.expectedComponentIndex), text(candidate.actualComponentIndex), text(candidate.path),
        text(candidate.anchorNode), text(candidate.anchorSource), text(candidate.node), text(candidate.runtimeName), tostring(candidate.nodeExists),
        text(candidate.ownership), text(candidate.componentCoherence), text(candidate.nameCoherence), text(candidate.geometryAuthority),
        text(candidate.poseValidity), tostring(candidate.rootAlias == true), fmt(candidate.worldCentreError, 6), fmt(candidate.worldRadiusError, 6),
        fmt(candidate.geometry and candidate.geometry.radius, 6), fmt(candidate.world and candidate.world.radius, 6), text(candidate.error))
end

function Probe:logOutcome(nowSeconds, state, shape, outcome)
    OuttaMyWay.Logger:val(
        "PROTOTYPE13A RESOLUTION_OUTCOME t=%.1fs fixture=%s scenario=%s member=%s family=%s sourceShape=%s result=%s reason=%s selectedNode=%s selectedRoutes=%s coherentHandles=%d validRoutes=%d crossSourceAliases=%s physicalAuthority=%s inventoryClosure=not-assessed footprint=false coverageClosure=false action=none",
        nowSeconds, state.fixture.id, state.fixture.scenario, state.name, state.fixture.family, shape.id,
        outcome.result, outcome.reason, text(outcome.selectedNode), routeList(outcome.selectedRoutes),
        outcome.uniqueCoherentHandles or 0, outcome.validRoutes or 0, text(outcome.crossSourceAliases), state.fixture.sourceAuthority)
    for _, control in ipairs(outcome.controls or {}) do
        local observed = control.overallPass and "UNEXPECTED_PASS" or "REJECTED"
        OuttaMyWay.Logger:val(
            "PROTOTYPE13A CONTROL_RESULT t=%.1fs fixture=%s member=%s sourceShape=%s candidate=%s route=%s expected=%s observed=%s runtimeNode=%s runtimeName=%s rejectionEvidence=ownership:%s,component:%s,name:%s,geometry:%s,alias:%s,pose:%s action=none",
            nowSeconds, state.fixture.id, state.name, shape.id, text(control.label), text(control.routeType),
            text(control.expectedControl), observed, text(control.node), text(control.runtimeName), text(control.ownership),
            text(control.componentCoherence), text(control.nameCoherence), text(control.geometryAuthority), text(control.aliasCheck), text(control.poseValidity))
    end
end

function Probe:evaluateMember(object, fixture, nowSeconds)
    local state = {
        object=object,
        fixture=fixture,
        name=safeName(object),
        outcomes={},
        baselines={},
        motionSupported={},
        previousAnimationRegion=nil,
        previousAnimationMotion=nil,
        lastAnimationValue=nil,
        lastAnimationChangeMs=nil,
        lastSampleMs=0
    }
    self.states[tostring(object)] = state

    OuttaMyWay.Logger:obs(
        "PROTOTYPE13A FIXTURE_ATTACHED t=%.1fs fixture=%s scenario=%s member=%s asset=%s runtimeObject=%s runtimeRootNode=%s family=%s shapesDeclared=%d declarationScope=diagnostic-only automatedDiscovery=false footprint=false action=none",
        nowSeconds, fixture.id, fixture.scenario, state.name, assetName(object), tostring(object), tostring(object.rootNode), fixture.family, #fixture.shapes)

    for _, shape in ipairs(fixture.shapes) do
        OuttaMyWay.Logger:obs(
            "PROTOTYPE13A SOURCE_SHAPE t=%.1fs fixture=%s member=%s family=%s sourceShape=%s sourceNode=%s sourceShapeId=%s active=true physicalAuthority=%s routesDeclared=%d declarationIsHypothesis=true action=none",
            nowSeconds, fixture.id, state.name, fixture.family, shape.id, shape.sourceNode, text(shape.sourceShapeId), fixture.sourceAuthority, #shape.routes)
        local candidates = OuttaMyWay.Prototype13Resolver:resolveShape(object, shape)
        local outcome = OuttaMyWay.Prototype13Evaluator:evaluateShape(object, shape, candidates)
        state.outcomes[shape.id] = outcome
    end
    OuttaMyWay.Prototype13Evaluator:applyCrossShapeDistinctness(state.outcomes)

    local counts = {RESOLVED=0, AMBIGUOUS=0, ALIASED=0, NODE_RESOLVED_GEOMETRY_UNPROVEN=0, UNRESOLVED=0}
    for _, shape in ipairs(fixture.shapes) do
        local outcome = state.outcomes[shape.id]
        for _, candidate in ipairs(outcome.candidates or {}) do self:logCandidate(nowSeconds, state, shape, candidate) end
        for _, candidate in ipairs(outcome.controls or {}) do self:logCandidate(nowSeconds, state, shape, candidate) end
        self:logOutcome(nowSeconds, state, shape, outcome)
        counts[outcome.result] = (counts[outcome.result] or 0) + 1
        if outcome.selectedNode ~= nil then
            state.baselines[shape.id] = memberLocalPosition(object, outcome.selectedNode)
        end
    end

    OuttaMyWay.Logger:val(
        "PROTOTYPE13A FAMILY_SUMMARY t=%.1fs fixture=%s scenario=%s member=%s family=%s declaredShapes=%d resolved=%d ambiguous=%d aliased=%d nodeGeometryUnproven=%d unresolved=%d completePhysicalInventory=false routeDiscovery=false footprint=false outcome=EVIDENCE_PENDING action=none",
        nowSeconds, fixture.id, fixture.scenario, state.name, fixture.family, #fixture.shapes,
        counts.RESOLVED or 0, counts.AMBIGUOUS or 0, counts.ALIASED or 0,
        counts.NODE_RESOLVED_GEOMETRY_UNPROVEN or 0, counts.UNRESOLVED or 0)
    return state
end

function Probe:sample(state, nowSeconds, nowMs)
    local foldTime = foldAnimTime(state.object)
    local currentAnimationRegion = animationRegion(foldTime)
    local currentAnimationMotion = animationMotion(state, foldTime, nowMs)
    local stateChanged = state.previousAnimationRegion ~= currentAnimationRegion
        or state.previousAnimationMotion ~= currentAnimationMotion
    local interval = currentAnimationMotion == "CHANGING"
        and (OuttaMyWay.PROTOTYPE_13_CHANGING_LOG_MS or 250)
        or (OuttaMyWay.PROTOTYPE_13_STABLE_LOG_MS or 2000)
    if not stateChanged and nowMs - (state.lastSampleMs or 0) < interval then return end
    state.lastSampleMs = nowMs
    state.previousAnimationRegion = currentAnimationRegion
    state.previousAnimationMotion = currentAnimationMotion

    for _, shape in ipairs(state.fixture.shapes) do
        local outcome = state.outcomes[shape.id]
        if outcome ~= nil and outcome.selectedNode ~= nil then
            local current = memberLocalPosition(state.object, outcome.selectedNode)
            local movement = distance(state.baselines[shape.id], current)
            local threshold = OuttaMyWay.PROTOTYPE_13_MOTION_THRESHOLD_M or 0.02
            if movement ~= nil and movement >= threshold then state.motionSupported[shape.id] = true end
            OuttaMyWay.Logger:obs(
                "PROTOTYPE13A MOTION_SAMPLE t=%.1fs fixture=%s member=%s sourceShape=%s selectedNode=%s animationSource=foldAnimTime animationValue=%s animationRegion=%s animationMotion=%s localPosition=%s,%s,%s displacementFromAttachM=%s motionDerivedDistinctness=%s handlesStable=true semanticState=not-inferred action=none",
                nowSeconds, state.fixture.id, state.name, shape.id, text(outcome.selectedNode), fmt(foldTime, 4),
                currentAnimationRegion, currentAnimationMotion,
                fmt(current and current.x, 4), fmt(current and current.y, 4), fmt(current and current.z, 4), fmt(movement, 4),
                state.motionSupported[shape.id] and "SUPPORTED" or "NOT_YET_OBSERVED")
        end
    end
end

function Probe:update(dt)
    if self.states == nil then self:init() end
    if self.enabled ~= true then return end
    self.elapsedMs = self.elapsedMs + dt
    local interval = OuttaMyWay.PROTOTYPE_13_INTERVAL_MS or 100
    if self.elapsedMs < interval then return end
    self.elapsedMs = self.elapsedMs % interval

    local nowMs = g_time or 0
    local nowSeconds = (nowMs - (self.startedAtMs or 0)) / 1000
    local present = {}
    local matches = enumerateFixtureMembers()
    OuttaMyWay.Logger:rateLimited("p13-enumeration", OuttaMyWay.PROTOTYPE_13_ENUMERATION_LOG_MS or 3000, "OBS",
        "PROTOTYPE13A FIXTURE_ENUMERATION t=%.1fs matchedMembers=%d declaredFixtures=%d search=missionVehicles+vehicleSystemVehicles automatedRouteDiscovery=false action=none",
        nowSeconds, #matches, #OuttaMyWay.Prototype13Fixtures.list)

    for _, match in ipairs(matches) do
        local key = tostring(match.object)
        present[key] = true
        local state = self.states[key] or self:evaluateMember(match.object, match.fixture, nowSeconds)
        self:sample(state, nowSeconds, nowMs)
    end

    for key, state in pairs(self.states) do
        if not present[key] then
            OuttaMyWay.Logger:obs(
                "PROTOTYPE13A FIXTURE_REMOVED t=%.1fs fixture=%s member=%s reason=runtime-object-no-longer-present action=none",
                nowSeconds, state.fixture.id, state.name)
            self.states[key] = nil
        end
    end
end

function Probe:clear()
    self.elapsedMs = 0
    self.startedAtMs = g_time or 0
    self.states = {}
end
