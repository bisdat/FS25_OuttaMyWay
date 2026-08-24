-- FS25_OuttaMyWay v0.1.11.0 CANONICAL CANDIDATE — D-0186 Regulation–Hold Boundary.
-- GIANTS-native drive-call authority for bounded Regulation.
-- Positive Regulation preserves native permission; a zero effective cap is a Hold and revokes drive permission.
-- Historical Reposition helpers remain non-production residue pending later naming/ownership normalisation.

OuttaMyWay.Prototype22DriveAuthority = {}
local Authority = OuttaMyWay.Prototype22DriveAuthority
Authority.__index = Authority

local function weakKeys()
    return setmetatable({}, {__mode = "k"})
end

local function position(vehicle)
    if vehicle == nil then return nil end
    local node = nil
    if type(vehicle.getAISteeringNode) == "function" then
        local ok, value = pcall(vehicle.getAISteeringNode, vehicle)
        if ok and value ~= nil and value ~= 0 then node = value end
    end
    node = node or vehicle.rootNode
    if node == nil or node == 0 or type(getWorldTranslation) ~= "function" then return nil end
    local ok, x, y, z = pcall(getWorldTranslation, node)
    if not ok then return nil end
    return node, x, y, z
end

function Authority.new()
    return setmetatable({
        states = weakKeys(),
        installed = false,
        originalDriveToPoint = nil
    }, Authority)
end

local function sortedLeaseOwners(leases)
    local owners = {}
    for ownerTag in pairs(leases or {}) do owners[#owners + 1] = tostring(ownerTag) end
    table.sort(owners)
    return owners
end

local function recomputeRegulationState(state)
    local leases = state and state.regulationLeases or nil
    if type(leases) ~= "table" then return state end
    local owners = sortedLeaseOwners(leases)
    local effective = nil
    for _, ownerTag in ipairs(owners) do
        local lease = leases[ownerTag]
        local cap = lease and tonumber(lease.speedKmh) or nil
        if cap ~= nil then effective = effective == nil and cap or math.min(effective, cap) end
    end
    state.speedKmh = effective or 0
    state.ownerTags = owners
    state.ownerTag = #owners == 1 and owners[1] or (#owners > 1 and "COMPOSED_REGULATION" or nil)
    return state
end

function Authority:install()
    if self.installed then return true end
    if AIVehicleUtil == nil or type(AIVehicleUtil.driveToPoint) ~= "function" then
        return false, "AIVehicleUtil.driveToPoint-unavailable"
    end
    local authority = self
    local original = AIVehicleUtil.driveToPoint
    self.originalDriveToPoint = original
    AIVehicleUtil.driveToPoint = function(vehicle, dt, acceleration, isAllowedToDrive, moveForwards, lx, lz, maxSpeed)
        local state = authority.states[vehicle]
        if state == nil then
            return original(vehicle, dt, acceleration, isAllowedToDrive, moveForwards, lx, lz, maxSpeed)
        end

        state.driveCalls = (state.driveCalls or 0) + 1
        state.lastInputAllowed = isAllowedToDrive == true
        state.lastInputForward = moveForwards ~= false
        state.lastInputMaxSpeed = tonumber(maxSpeed)

        if state.mode == "REGULATE" then
            local cap = tonumber(state.speedKmh) or 0
            local outputMax = cap
            if tonumber(maxSpeed) ~= nil then outputMax = math.min(tonumber(maxSpeed), cap) end
            -- D-0186 Regulation–Hold Boundary: GIANTS derives drive permission
            -- from its native maxSpeed before this interception point. If a
            -- Regulation lease tightens that ceiling to exactly zero, preserve
            -- route/steering/direction but also revoke drive permission so we
            -- never emit the internally inconsistent pair allowed=true,max=0.
            local outputAllowedToDrive = isAllowedToDrive == true and outputMax > 0
            state.lastOutputMaxSpeed = outputMax
            state.lastOutputAllowed = outputAllowedToDrive
            return original(vehicle, dt, acceleration, outputAllowedToDrive, moveForwards, lx, lz, outputMax)
        end

        if state.mode == "REPOSITION_ORIENT" then
            local steerX = tonumber(state.steerX) or 1
            local steerZ = tonumber(state.steerZ) or 0.30
            local length = math.sqrt(steerX * steerX + steerZ * steerZ)
            if length <= 0.0001 then
                state.invalidReason = "reposition-orientation-direction-degenerate"
                return original(vehicle, dt, 0, false, true, 0, 1, 0)
            end
            steerX, steerZ = steerX / length, steerZ / length
            local cap = tonumber(state.speedKmh) or 0
            state.lastOutputMaxSpeed = cap
            -- Temporary P22/TS015 evidence authority only. This reuses the
            -- archived empirically successful forward-only rejoin orientation
            -- mechanism; it creates no production routing or speed policy.
            return original(vehicle, dt, 1, true, true, steerX, steerZ, cap)
        end

        if state.mode == "REPOSITION" then
            local node, x, _, z = position(vehicle)
            if node == nil or state.targetX == nil or state.targetZ == nil then
                state.invalidReason = "reposition-pose-unavailable"
                return original(vehicle, dt, 0, false, true, 0, 1, 0)
            end
            local dx, dz = state.targetX - x, state.targetZ - z
            local remaining = math.sqrt(dx * dx + dz * dz)
            state.lastRemainingM = remaining
            if remaining <= (tonumber(state.targetRadiusM) or 1.0) then
                state.targetReached = true
                state.lastOutputMaxSpeed = 0
                return original(vehicle, dt, 0, false, true, 0, 1, 0)
            end
            if type(worldDirectionToLocal) ~= "function" then
                state.invalidReason = "worldDirectionToLocal-unavailable"
                return original(vehicle, dt, 0, false, true, 0, 1, 0)
            end
            local localX, _, localZ = worldDirectionToLocal(node, dx, 0, dz)
            local length = math.sqrt(localX * localX + localZ * localZ)
            if length <= 0.0001 then
                state.invalidReason = "reposition-direction-degenerate"
                return original(vehicle, dt, 0, false, true, 0, 1, 0)
            end
            localX, localZ = localX / length, localZ / length
            local cap = tonumber(state.speedKmh) or 0
            state.lastOutputMaxSpeed = cap
            -- Prototype 22 validates forward Reposition only. Reverse remains
            -- architecturally valid but UNRESOLVED until dedicated discovery.
            return original(vehicle, dt, 1, true, true, localX, localZ, cap)
        end

        return original(vehicle, dt, acceleration, isAllowedToDrive, moveForwards, lx, lz, maxSpeed)
    end
    self.installed = true
    return true
end

function Authority:setRegulation(vehicle, speedKmh, ownerTag)
    local ok, reason = self:install()
    if not ok then return false, reason end
    self.states[vehicle] = {mode = "REGULATE", speedKmh = speedKmh, driveCalls = 0, ownerTag = ownerTag}
    return true
end

-- D-0130 implementation catch-up: independently justified Regulation purposes
-- may coexist.  The physical actuation is the least permissive active cap;
-- each owner may release only its own lease.  This remains Prototype-22 test
-- authority and does not create production Commitment or speed policy.
function Authority:setRegulationLease(vehicle, speedKmh, ownerTag)
    if vehicle == nil or ownerTag == nil then return false, "regulation-lease-subject-or-owner-unavailable" end
    local ok, reason = self:install()
    if not ok then return false, reason end
    local state = self.states[vehicle]
    if state ~= nil and state.mode ~= "REGULATE" then return false, "vehicle-has-non-regulation-drive-authority" end
    if state == nil then
        state = {mode="REGULATE", regulationLeases={}, driveCalls=0}
        self.states[vehicle] = state
    elseif state.regulationLeases == nil then
        -- Preserve an existing single-owner Regulation when converting the
        -- temporary test authority into composable leases.
        if state.ownerTag == nil then return false, "existing-regulation-owner-unavailable" end
        state.regulationLeases = {
            [tostring(state.ownerTag)] = {speedKmh=tonumber(state.speedKmh) or 0}
        }
    end
    state.regulationLeases[tostring(ownerTag)] = {speedKmh=math.max(0, tonumber(speedKmh) or 0)}
    recomputeRegulationState(state)
    return true
end

function Authority:hasRegulationLease(vehicle, ownerTag)
    local state = vehicle ~= nil and self.states[vehicle] or nil
    if state == nil or state.mode ~= "REGULATE" then return false end
    if type(state.regulationLeases) == "table" then return state.regulationLeases[tostring(ownerTag)] ~= nil end
    return state.ownerTag == ownerTag
end

function Authority:getRegulationLease(vehicle, ownerTag)
    local state = vehicle ~= nil and self.states[vehicle] or nil
    if state == nil or state.mode ~= "REGULATE" then return nil end
    if type(state.regulationLeases) == "table" then return state.regulationLeases[tostring(ownerTag)] end
    if state.ownerTag == ownerTag then return {speedKmh=state.speedKmh} end
    return nil
end

function Authority:clearRegulationLease(vehicle, ownerTag)
    local state = vehicle ~= nil and self.states[vehicle] or nil
    if state == nil or state.mode ~= "REGULATE" then return false end
    if type(state.regulationLeases) ~= "table" then
        if state.ownerTag ~= ownerTag then return false end
        self.states[vehicle] = nil
        return true
    end
    local key = tostring(ownerTag)
    if state.regulationLeases[key] == nil then return false end
    state.regulationLeases[key] = nil
    if next(state.regulationLeases) == nil then
        self.states[vehicle] = nil
    else
        recomputeRegulationState(state)
    end
    return true
end

function Authority:setRepositionOrientation(vehicle, steerX, steerZ, speedKmh)
    local ok, reason = self:install()
    if not ok then return false, reason end
    self.states[vehicle] = {
        mode = "REPOSITION_ORIENT",
        steerX = steerX,
        steerZ = steerZ,
        speedKmh = speedKmh,
        driveCalls = 0
    }
    return true
end

function Authority:setReposition(vehicle, targetX, targetZ, speedKmh, targetRadiusM)
    local ok, reason = self:install()
    if not ok then return false, reason end
    self.states[vehicle] = {
        mode = "REPOSITION",
        targetX = targetX,
        targetZ = targetZ,
        speedKmh = speedKmh,
        targetRadiusM = targetRadiusM,
        targetReached = false,
        driveCalls = 0
    }
    return true
end

function Authority:getState(vehicle)
    return vehicle ~= nil and self.states[vehicle] or nil
end

function Authority:clear(vehicle)
    if vehicle ~= nil then self.states[vehicle] = nil end
end

function Authority:clearAll()
    self.states = weakKeys()
end
