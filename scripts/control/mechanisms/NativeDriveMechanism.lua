--- Provides subordinate GIANTS-native movement and composable speed-ceiling actuation below Control without policy or Commitment authority.
-- Specification Jurisdictions: `CONTROL`

-- GIANTS-native drive mechanism below Control.
-- Speed ceilings preserve the underlying native or authorised movement objective; a zero
-- effective cap revokes drive permission without deleting that objective. The same
-- interception realises validated Cooperative Passage point-Reposition and captured-axis travel.

OuttaMyWay.NativeDriveMechanism = {}
local Mechanism = OuttaMyWay.NativeDriveMechanism
Mechanism.__index = Mechanism

local SUPPORTING_SPEED_CEILING="SUPPORTING_SPEED_CEILING"

local function weakKeys()
    return setmetatable({}, {__mode = "k"})
end

local function steeringNode(vehicle)
    if vehicle == nil then return nil end
    if type(vehicle.getAISteeringNode) == "function" then
        local ok,value=pcall(vehicle.getAISteeringNode,vehicle)
        if ok and value~=nil and value~=0 then return value,"AI_STEERING_NODE" end
    end
    local root=vehicle.rootNode
    if root~=nil and root~=0 then return root,"ROOT_NODE_FALLBACK" end
    return nil,"STEERING_REFERENCE_UNAVAILABLE"
end

local function reverseNode(vehicle)
    if vehicle == nil then return nil,"VEHICLE_UNAVAILABLE" end
    if type(vehicle.getAIReverserNode) ~= "function" then return nil,"AI_REVERSER_NODE_API_UNAVAILABLE" end
    local ok,value=pcall(vehicle.getAIReverserNode,vehicle)
    if not ok or value==nil or value==0 then return nil,"AI_REVERSER_NODE_UNAVAILABLE" end
    return value,"AI_REVERSER_NODE"
end

local function toolReverserNode(vehicle)
    if AIVehicleUtil==nil or type(AIVehicleUtil.getAIToolReverserDirectionNode)~="function" then
        return nil,"AI_TOOL_REVERSER_DIRECTION_NODE_API_UNAVAILABLE"
    end
    local ok,value=pcall(AIVehicleUtil.getAIToolReverserDirectionNode,vehicle)
    if not ok or value==nil or value==0 then return nil,"AI_TOOL_REVERSER_DIRECTION_NODE_UNAVAILABLE" end
    return value,"AI_TOOL_REVERSER_DIRECTION_NODE"
end

local function position(vehicle)
    local node=steeringNode(vehicle)
    if node == nil or type(getWorldTranslation) ~= "function" then return nil end
    local ok, x, y, z = pcall(getWorldTranslation, node)
    if not ok then return nil end
    return node, x, y, z
end

function Mechanism.new()
    return setmetatable({
        states = weakKeys(),
        installed = false,
        originalDriveToPoint = nil
    }, Mechanism)
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
    state.regulationSpeedKmh = effective
    state.ownerTags = owners
    state.ownerTag = #owners == 1 and owners[1] or (#owners > 1 and "COMPOSED_REGULATION" or nil)
    if state.mode == "REGULATE" then state.speedKmh = effective or 0 end
    return state
end

local function speedCeilingApplied(state,baseSpeedKmh)
    local base=math.max(0,tonumber(baseSpeedKmh) or 0)
    local ceiling=state and tonumber(state.regulationSpeedKmh) or nil
    if ceiling==nil then return base end
    return math.min(base,math.max(0,ceiling))
end

local function retainSupportingSpeedCeilings(previous,state)
    local retained={}
    for ownerTag,lease in pairs(previous and previous.regulationLeases or {}) do
        if lease and lease.authorityRole==SUPPORTING_SPEED_CEILING then
            retained[ownerTag]=lease
        end
    end
    if next(retained)~=nil then
        state.regulationLeases=retained
        recomputeRegulationState(state)
    end
    return state
end

function Mechanism:install()
    if self.installed then return true end
    if AIVehicleUtil == nil or type(AIVehicleUtil.driveToPoint) ~= "function" then
        return false, "AIVehicleUtil.driveToPoint-unavailable"
    end
    local mechanism = self
    local original = AIVehicleUtil.driveToPoint
    self.originalDriveToPoint = original
    AIVehicleUtil.driveToPoint = function(vehicle, dt, acceleration, isAllowedToDrive, moveForwards, lx, lz, maxSpeed)
        local state = mechanism.states[vehicle]
        if state == nil then
            return original(vehicle, dt, acceleration, isAllowedToDrive, moveForwards, lx, lz, maxSpeed)
        end

        state.driveCalls = (state.driveCalls or 0) + 1
        state.lastInputAllowed = isAllowedToDrive == true
        state.lastInputForward = moveForwards ~= false
        state.lastInputMaxSpeed = tonumber(maxSpeed)

        if state.mode == "REGULATE" then
            local cap = tonumber(state.regulationSpeedKmh) or tonumber(state.speedKmh) or 0
            local outputMax = cap
            if tonumber(maxSpeed) ~= nil then outputMax = math.min(tonumber(maxSpeed), cap) end
            -- Regulation–Hold Boundary: GIANTS derives drive permission
            -- from its native maxSpeed before this interception point. If a
            -- Regulation lease tightens that ceiling to exactly zero, preserve
            -- route/steering/direction but also revoke drive permission so we
            -- never emit the internally inconsistent pair allowed=true,max=0.
            local outputAllowedToDrive = isAllowedToDrive == true and outputMax > 0
            state.lastOutputMaxSpeed = outputMax
            state.lastOutputAllowed = outputAllowedToDrive
            return original(vehicle, dt, acceleration, outputAllowedToDrive, moveForwards, lx, lz, outputMax)
        end

        if state.mode == "AXIS_TRAVEL" then
            local node, x, _, z = position(vehicle)
            if node == nil then
                state.invalidReason = "axis-travel-pose-unavailable"
                return original(vehicle, dt, 0, false, state.moveForwards ~= false, 0, 1, 0)
            end
            local ox,oz=tonumber(state.originX),tonumber(state.originZ)
            local fx,fz=tonumber(state.axisForwardX),tonumber(state.axisForwardZ)
            local targetStation=tonumber(state.targetStationM)
            if ox==nil or oz==nil or fx==nil or fz==nil or targetStation==nil then
                state.invalidReason = "axis-travel-frame-unavailable"
                return original(vehicle, dt, 0, false, state.moveForwards ~= false, 0, 1, 0)
            end
            local axisLength=math.sqrt(fx*fx+fz*fz)
            if axisLength<=0.0001 then
                state.invalidReason = "axis-travel-axis-degenerate"
                return original(vehicle, dt, 0, false, state.moveForwards ~= false, 0, 1, 0)
            end
            fx,fz=fx/axisLength,fz/axisLength
            local progress=(x-ox)*fx+(z-oz)*fz
            state.lastStationProgressM=progress
            local tolerance=math.max(0,tonumber(state.stationToleranceM) or 0)
            local forwards=state.moveForwards~=false
            local reached=(forwards and progress+tolerance>=targetStation) or ((not forwards) and progress-tolerance<=targetStation)
            if reached then
                state.targetReached=true
                state.lastOutputMaxSpeed=0
                return original(vehicle, dt, 0, false, forwards, 0, 1, 0)
            end
            if type(worldDirectionToLocal) ~= "function" then
                state.invalidReason = "worldDirectionToLocal-unavailable"
                return original(vehicle, dt, 0, false, forwards, 0, 1, 0)
            end
            -- Axis Return is not point pursuit.  Steering always follows the
            -- captured original axis; reverse changes only the travel direction.
            local wx,wz=forwards and fx or -fx,forwards and fz or -fz
            local localX,_,localZ=worldDirectionToLocal(node,wx,0,wz)
            local localLength=math.sqrt(localX*localX+localZ*localZ)
            if localLength<=0.0001 then
                state.invalidReason = "axis-travel-direction-degenerate"
                return original(vehicle, dt, 0, false, forwards, 0, 1, 0)
            end
            localX,localZ=localX/localLength,localZ/localLength
            local cap=speedCeilingApplied(state,state.speedKmh)
            local allowed=cap>0
            state.lastOutputMaxSpeed=cap
            state.lastOutputAllowed=allowed
            return original(vehicle,dt,allowed and 1 or 0,allowed,forwards,localX,localZ,cap)
        end

        if state.mode == "REPOSITION" then
            local forwards=state.moveForwards~=false
            local node, x, _, z = position(vehicle)
            if node == nil or state.targetX == nil or state.targetZ == nil then
                state.invalidReason = "reposition-pose-unavailable"
                return original(vehicle, dt, 0, false, forwards, 0, 1, 0)
            end
            local dx, dz = state.targetX - x, state.targetZ - z
            local remaining = math.sqrt(dx * dx + dz * dz)
            state.lastRemainingM = remaining
            if remaining <= (tonumber(state.targetRadiusM) or 1.0) then
                state.targetReached = true
                state.lastOutputMaxSpeed = 0
                return original(vehicle, dt, 0, false, forwards, 0, 1, 0)
            end
            local localX,localZ
            if forwards then
                if type(worldDirectionToLocal) ~= "function" then
                    state.invalidReason = "worldDirectionToLocal-unavailable"
                    return original(vehicle, dt, 0, false, forwards, 0, 1, 0)
                end
                local lx,_,lz=worldDirectionToLocal(node,dx,0,dz)
                localX,localZ=lx,lz
                state.repositionReferenceNodeSource="AI_STEERING_NODE"
            else
                local refNode,refSource=reverseNode(vehicle)
                state.repositionReferenceNodeSource=refSource
                state.repositionReferenceNode=refNode
                local toolNode,toolSource=toolReverserNode(vehicle)
                state.toolReverserDirectionNode=toolNode
                state.toolReverserDirectionNodeSource=toolSource
                if refNode==nil then
                    state.invalidReason = "reposition-reverse-reference-unavailable:"..tostring(refSource)
                    return original(vehicle, dt, 0, false, forwards, 0, 1, 0)
                end
                if type(getWorldTranslation)~="function" or type(worldToLocal)~="function" then
                    state.invalidReason = "reposition-native-reverse-transform-unavailable"
                    return original(vehicle, dt, 0, false, forwards, 0, 1, 0)
                end
                local poseOk,_,refY,_=pcall(getWorldTranslation,refNode)
                if not poseOk then
                    state.invalidReason = "reposition-reverse-reference-pose-unavailable"
                    return original(vehicle, dt, 0, false, forwards, 0, 1, 0)
                end
                local transformOk,lx,_,lz=pcall(worldToLocal,refNode,state.targetX,refY,state.targetZ)
                if not transformOk then
                    state.invalidReason = "reposition-native-reverse-transform-failed"
                    return original(vehicle, dt, 0, false, forwards, 0, 1, 0)
                end
                localX,localZ=lx,lz
            end
            local length = math.sqrt(localX * localX + localZ * localZ)
            if length <= 0.0001 then
                state.invalidReason = "reposition-direction-degenerate"
                return original(vehicle, dt, 0, false, forwards, 0, 1, 0)
            end
            localX, localZ = localX / length, localZ / length
            local cap = speedCeilingApplied(state,state.speedKmh)
            local allowed=cap>0
            state.lastOutputMaxSpeed = cap
            state.lastOutputAllowed = allowed
            return original(vehicle, dt, allowed and 1 or 0, allowed, forwards, localX, localZ, cap)
        end

        return original(vehicle, dt, acceleration, isAllowedToDrive, moveForwards, lx, lz, maxSpeed)
    end
    self.installed = true
    return true
end

function Mechanism:setRegulation(vehicle, speedKmh, ownerTag)
    local ok, reason = self:install()
    if not ok then return false, reason end
    self.states[vehicle] = {mode = "REGULATE", speedKmh = speedKmh, driveCalls = 0, ownerTag = ownerTag}
    return true
end

-- Independently justified Regulation purposes
-- may coexist.  The physical actuation is the least permissive active cap;
-- each owner may release only its own lease. The mechanism realises bounded
-- actuation and does not create Commitment or speed policy.
function Mechanism:setRegulationLease(vehicle, speedKmh, ownerTag, authorityRole)
    if vehicle == nil or ownerTag == nil then return false, "regulation-lease-subject-or-owner-unavailable" end
    local ok, reason = self:install()
    if not ok then return false, reason end
    local state = self.states[vehicle]
    if state ~= nil and state.mode ~= "REGULATE" and authorityRole~=SUPPORTING_SPEED_CEILING then
        return false, "vehicle-has-non-regulation-drive-authority"
    end
    if state == nil then
        state = {mode="REGULATE", regulationLeases={}, driveCalls=0}
        self.states[vehicle] = state
    elseif state.regulationLeases == nil then
        if state.mode=="REGULATE" and state.ownerTag~=nil then
            -- Preserve an existing single-owner Regulation when converting the
            -- temporary test authority into composable leases.
            state.regulationLeases = {
                [tostring(state.ownerTag)] = {speedKmh=tonumber(state.speedKmh) or 0}
            }
        else
            -- Only an explicit Supporting Speed Ceiling may coexist with an
            -- independently authorised movement objective.
            state.regulationLeases = {}
        end
    end
    state.regulationLeases[tostring(ownerTag)] = {
        speedKmh=math.max(0, tonumber(speedKmh) or 0),
        authorityRole=authorityRole
    }
    recomputeRegulationState(state)
    return true
end

function Mechanism:hasRegulationLease(vehicle, ownerTag)
    local state = vehicle ~= nil and self.states[vehicle] or nil
    if state == nil then return false end
    if type(state.regulationLeases) == "table" then return state.regulationLeases[tostring(ownerTag)] ~= nil end
    return state.mode=="REGULATE" and state.ownerTag == ownerTag
end

function Mechanism:getRegulationLease(vehicle, ownerTag)
    local state = vehicle ~= nil and self.states[vehicle] or nil
    if state == nil then return nil end
    if type(state.regulationLeases) == "table" then return state.regulationLeases[tostring(ownerTag)] end
    if state.mode=="REGULATE" and state.ownerTag == ownerTag then return {speedKmh=state.speedKmh} end
    return nil
end

function Mechanism:clearRegulationLease(vehicle, ownerTag)
    local state = vehicle ~= nil and self.states[vehicle] or nil
    if state == nil then return false end
    if type(state.regulationLeases) ~= "table" then
        if state.mode~="REGULATE" or state.ownerTag ~= ownerTag then return false end
        self.states[vehicle] = nil
        return true
    end
    local key = tostring(ownerTag)
    if state.regulationLeases[key] == nil then return false end
    state.regulationLeases[key] = nil
    if next(state.regulationLeases) == nil then
        state.regulationLeases=nil
        state.regulationSpeedKmh=nil
        state.ownerTags=nil
        state.ownerTag=nil
        if state.mode=="REGULATE" then self.states[vehicle]=nil end
    else
        recomputeRegulationState(state)
    end
    return true
end

function Mechanism:setAxisTravel(vehicle, originX, originZ, axisForwardX, axisForwardZ, targetStationM, speedKmh, moveForwards, stationToleranceM)
    local ok, reason = self:install()
    if not ok then return false, reason end
    local previous=self.states[vehicle]
    self.states[vehicle] = retainSupportingSpeedCeilings(previous,{
        mode="AXIS_TRAVEL", originX=originX, originZ=originZ, axisForwardX=axisForwardX, axisForwardZ=axisForwardZ,
        targetStationM=targetStationM, speedKmh=speedKmh, moveForwards=moveForwards~=false,
        stationToleranceM=stationToleranceM, targetReached=false, driveCalls=0
    })
    return true
end

function Mechanism:setReposition(vehicle, targetX, targetZ, speedKmh, targetRadiusM, moveForwards)
    local ok, reason = self:install()
    if not ok then return false, reason end
    local previous=self.states[vehicle]
    local forwards=moveForwards~=false
    local reverseReferenceNode,reverseReferenceNodeSource=nil,nil
    local toolReverserDirectionNode,toolReverserDirectionNodeSource=nil,nil
    if not forwards then
        reverseReferenceNode,reverseReferenceNodeSource=reverseNode(vehicle)
        toolReverserDirectionNode,toolReverserDirectionNodeSource=toolReverserNode(vehicle)
    end
    self.states[vehicle] = retainSupportingSpeedCeilings(previous,{
        mode = "REPOSITION",
        targetX = targetX,
        targetZ = targetZ,
        speedKmh = speedKmh,
        targetRadiusM = targetRadiusM,
        moveForwards = forwards,
        targetReached = false,
        driveCalls = 0,
        repositionReferenceNode=reverseReferenceNode,
        repositionReferenceNodeSource=forwards and "AI_STEERING_NODE" or reverseReferenceNodeSource,
        toolReverserDirectionNode=toolReverserDirectionNode,
        toolReverserDirectionNodeSource=forwards and "NOT_APPLICABLE_FORWARD" or toolReverserDirectionNodeSource
    })
    return true
end

function Mechanism:getState(vehicle)
    return vehicle ~= nil and self.states[vehicle] or nil
end

function Mechanism:clearMovementObjective(vehicle)
    if vehicle == nil then return false end
    local state=self.states[vehicle]
    if state==nil or state.mode=="REGULATE" then return false end
    local retained=retainSupportingSpeedCeilings(state,{mode="REGULATE",driveCalls=state.driveCalls or 0})
    if type(retained.regulationLeases)=="table" and next(retained.regulationLeases)~=nil then
        self.states[vehicle]=retained
    else
        self.states[vehicle]=nil
    end
    return true
end

function Mechanism:clear(vehicle)
    if vehicle ~= nil then self.states[vehicle] = nil end
end

function Mechanism:clearAll()
    self.states = weakKeys()
end
