-- FS25_OuttaMyWay Prototype 22.
-- Temporary drive-call capability probe for bounded GIANTS-native Regulation
-- and manually requested forward Reposition / rejoin-orientation actuation.
--
-- REGULATE modifies only the speed ceiling passed through GIANTS' existing
-- driveToPoint request.  REPOSITION deliberately replaces steering/direction
-- only for the explicitly scoped probe subject. v4.7.47 additionally allows the
-- bounded D-0123 Guarded-Recovery test bridge to populate REGULATE for the
-- fixture Progress worker; this remains test authority, not production Control.

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
            state.lastOutputMaxSpeed = outputMax
            -- Preserve GIANTS route, steering, acceleration, permission and
            -- forward/reverse choice. Only the speed ceiling is bounded.
            return original(vehicle, dt, acceleration, isAllowedToDrive, moveForwards, lx, lz, outputMax)
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
