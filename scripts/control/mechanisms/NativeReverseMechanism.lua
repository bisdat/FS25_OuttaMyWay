-- Subordinate GIANTS reverse actuator for an independently admitted Hold & Relocate movement.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- No pair admission, TRANSIT assessment, clearance, or native job continuation authority.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativeReverseMechanism={}
local Mechanism=OuttaMyWay.NativeReverseMechanism
Mechanism.__index=Mechanism

local REVERSE_SPEED_KMH=8 -- archived BWR mechanical calibration
local TARGET_RADIUS_M=1 -- local point approach, not traffic clearance
local MIN_DIRECTION_M=0.0001

local function finite(n)
    return type(n)=="number" and n==n and n~=math.huge and n~=-math.huge
end

local function pose(node)
    if node==nil or node==0 or type(getWorldTranslation)~="function" then
        return nil,"POSE_UNAVAILABLE"
    end
    local ok,x,y,z=pcall(getWorldTranslation,node)
    if not ok or not finite(x) or not finite(y) or not finite(z) then
        return nil,"POSE_UNAVAILABLE"
    end
    return {x=x,y=y,z=z}
end

local function reverserNode(vehicle)
    if type(vehicle)~="table" or type(vehicle.getAIReverserNode)~="function" then
        return nil,"AI_REVERSER_NODE_UNAVAILABLE"
    end
    local ok,node=pcall(vehicle.getAIReverserNode,vehicle)
    if not ok or node==nil or node==0 then return nil,"AI_REVERSER_NODE_UNAVAILABLE" end
    return node
end

local function toolNodeFor(vehicle)
    if type(AIVehicleUtil)~="table"
        or type(AIVehicleUtil.getAIToolReverserDirectionNode)~="function" then
        return nil,"TOOL_REVERSE_API_UNAVAILABLE"
    end
    local ok,node=pcall(AIVehicleUtil.getAIToolReverserDirectionNode,vehicle)
    if not ok then return nil,"TOOL_REVERSE_QUERY_FAILED" end
    if node==nil or node==0 then return nil end
    return node
end

local function toolGeometryReady()
    return type(MathUtil)=="table"
        and type(MathUtil.vector2Length)=="function"
        and type(MathUtil.getProjectOnLineParameter)=="function"
        and type(MathUtil.vector2Normalize)=="function"
        and type(MathUtil.dotProduct)=="function"
        and type(MathUtil.getSignedAngleBetweenVectors2D)=="function"
        and type(MathUtil.isNan)=="function"
        and type(localDirectionToWorld)=="function"
        and type(localToWorld)=="function"
end

-- Preserve archived BWR's GIANTS-equivalent tool-relative rotation. If a tool
-- reverser is present but this geometry is missing, do not silently revert to
-- vehicle-only steering and claim native reversing equivalence.
local function adjustToolTarget(reverseNode,toolNode,targetX,targetZ)
    if toolNode==nil then return targetX,targetZ end
    if not toolGeometryReady() then return nil,nil,"TOOL_GEOMETRY_UNAVAILABLE" end
    local ok,x,z=pcall(function()
        local tx,_,tz=getWorldTranslation(toolNode)
        local dx1,_,dz1=localDirectionToWorld(reverseNode,0,0,1)
        local dx2,_,dz2=localDirectionToWorld(toolNode,0,0,1)
        local length1=MathUtil.vector2Length(dx1,dz1)
        local length2=MathUtil.vector2Length(dx2,dz2)
        if length1<=0 or length2<=0 then return nil,nil end
        dx1,dz1=dx1/length1,dz1/length1
        dx2,dz2=dx2/length2,dz2/length2
        local distance=MathUtil.vector2Length(targetX-tx,targetZ-tz)
        local longitudinal=MathUtil.getProjectOnLineParameter(
            targetX,targetZ,tx,tz,dx2,dz2)
        local lateral=math.sqrt(math.max(0,distance*distance-longitudinal*longitudinal))
        local sideX,sideZ=MathUtil.vector2Normalize(tx-targetX,tz-targetZ)
        local side=MathUtil.dotProduct(-dz2,0,dx2,sideX,0,sideZ)
        lateral=lateral*(side<0 and -1 or (side>0 and 1 or 0))
        local angle=MathUtil.getSignedAngleBetweenVectors2D(dx1,dz1,dx2,dz2)
        local localX=math.cos(angle)*lateral-math.sin(angle)*longitudinal
        local localZ=math.sin(angle)*lateral+math.cos(angle)*longitudinal
        if MathUtil.isNan(localX) or MathUtil.isNan(localZ) then return nil,nil end
        local worldX,_,worldZ=localToWorld(reverseNode,-localX,0,localZ)
        return worldX,worldZ
    end)
    if not ok or not finite(x) or not finite(z) then
        return nil,nil,"TOOL_GEOMETRY_INVALID"
    end
    return x,z
end

function Mechanism.new()
    return setmetatable({states=setmetatable({},{__mode="k"}),
        activeVehicle=nil,originalDrive=nil,wrapper=nil},Mechanism)
end

-- A positive command does not establish actual movement. Each sampling point
-- accumulates horizontal physical distance to challenge the movement bound.
function Mechanism:observeDisplacement(state)
    if state.isFailed then return end
    local current,reason=pose(state.vehicle.rootNode)
    if current==nil then state.isFailed=true;state.reason=reason;return end
    local dx,dz=current.x-state.lastX,current.z-state.lastZ
    local stepM=math.sqrt(dx*dx+dz*dz)
    state.lastX,state.lastZ=current.x,current.z
    state.travelledM=state.travelledM+stepM
    if not finite(state.travelledM) then
        state.isFailed=true;state.reason="DISPLACEMENT_UNAVAILABLE";return
    end
    if state.travelledM>state.maxTravelM then
        state.isFailed=true;state.reason="REVERSE_BOUND_EXCEEDED";return
    end
    local tx,tz=current.x-state.targetX,current.z-state.targetZ
    local remainingM=math.sqrt(tx*tx+tz*tz)
    if state.commandedDriveCount>0 and remainingM<=TARGET_RADIUS_M then
        state.isComplete=true
    elseif state.travelledM>=state.maxTravelM then
        state.isFailed=true;state.reason="BOUND_REACHED_WITHOUT_TARGET"
    end
end

-- Global wrapper is installed only after an explicit startReverse, and only
-- one commanded vehicle is altered. All other calls forward the ninth
-- doNotSteer argument unchanged to GIANTS' original driveToPoint.
function Mechanism:install()
    if self.wrapper~=nil then
        if type(AIVehicleUtil)=="table" and AIVehicleUtil.driveToPoint==self.wrapper then return true end
        return false,"DRIVE_WRAPPER_CHANGED"
    end
    if type(AIVehicleUtil)~="table"
        or type(AIVehicleUtil.driveToPoint)~="function" then
        return false,"DRIVE_API_UNAVAILABLE"
    end
    local original=AIVehicleUtil.driveToPoint
    local mechanism=self
    local function wrapper(vehicle,dt,accel,allowed,moveForwards,lx,lz,maxSpeed,doNotSteer)
        local state=mechanism.states[vehicle]
        if state==nil then
            return original(vehicle,dt,accel,allowed,moveForwards,lx,lz,maxSpeed,doNotSteer)
        end
        mechanism:observeDisplacement(state)
        if state.isComplete or state.isFailed then
            return original(vehicle,dt,0,false,false,0,1,0,false)
        end
        local node,reason=reverserNode(vehicle)
        local reference=node and pose(node) or nil
        if node==nil or reference==nil or type(worldToLocal)~="function" then
            state.isFailed=true;state.reason=reason or "REVERSE_FRAME_UNAVAILABLE"
            return original(vehicle,dt,0,false,false,0,1,0,false)
        end
        local worldX,worldZ,why=adjustToolTarget(node,state.toolNode,
            state.steeringTargetX,state.steeringTargetZ)
        if worldX==nil then
            state.isFailed=true;state.reason=why
            return original(vehicle,dt,0,false,false,0,1,0,false)
        end
        local ok,targetX,_,targetZ=pcall(worldToLocal,node,worldX,reference.y,worldZ)
        local length=ok and finite(targetX) and finite(targetZ)
            and math.sqrt(targetX*targetX+targetZ*targetZ) or nil
        if not finite(length) or length<=MIN_DIRECTION_M then
            state.isFailed=true;state.reason="REVERSE_LOCAL_TARGET_UNAVAILABLE"
            return original(vehicle,dt,0,false,false,0,1,0,false)
        end
        state.commandedDriveCount=state.commandedDriveCount+1
        -- Native reverse uses the reverser frame, tool correction and
        -- moveForwards=false. An active objective needs doNotSteer=false.
        return original(vehicle,dt,1,true,false,
            targetX/length,targetZ/length,REVERSE_SPEED_KMH,false)
    end
    self.originalDrive=original
    self.wrapper=wrapper
    AIVehicleUtil.driveToPoint=wrapper
    return true
end

-- Requires the caller's separately validated commitment/TRANSIT authority.
-- The 40 m steering point is not a destination or an extension of maxTravelM.
function Mechanism:startReverse(vehicle,objective)
    if g_server==nil then return false,"SERVER_REQUIRED" end
    if self.activeVehicle~=nil then return false,"REVERSE_ALREADY_ACTIVE" end
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(objective)~="table" or objective.isReverse~=true
        or not finite(objective.targetX) or not finite(objective.targetZ)
        or not finite(objective.maxTravelM) or objective.maxTravelM<=0
        or not finite(objective.steeringHorizonM) or objective.steeringHorizonM<=0 then
        return false,"REVERSE_REQUEST_INVALID"
    end
    local origin,why=pose(vehicle.rootNode)
    if origin==nil then return false,why end
    local reference,frameReason=reverserNode(vehicle)
    if reference==nil then return false,frameReason end
    if pose(reference)==nil or type(worldToLocal)~="function" then
        return false,"REVERSE_FRAME_UNAVAILABLE"
    end
    local toolNode,toolReason=toolNodeFor(vehicle)
    if toolReason=="TOOL_REVERSE_QUERY_FAILED" then return false,toolReason end
    if toolNode~=nil and not toolGeometryReady() then
        return false,"TOOL_GEOMETRY_UNAVAILABLE"
    end
    local dx,dz=objective.targetX-origin.x,objective.targetZ-origin.z
    local distanceM=math.sqrt(dx*dx+dz*dz)
    if not finite(distanceM) or distanceM<=MIN_DIRECTION_M
        or distanceM>objective.maxTravelM then
        return false,"TARGET_OUTSIDE_MOVEMENT_BOUND"
    end
    local steeringX=origin.x+dx/distanceM*objective.steeringHorizonM
    local steeringZ=origin.z+dz/distanceM*objective.steeringHorizonM
    if not finite(steeringX) or not finite(steeringZ) then
        return false,"STEERING_REFERENCE_UNAVAILABLE"
    end
    local installed,installReason=self:install()
    if not installed then return false,installReason end
    self.activeVehicle=vehicle
    self.states[vehicle]={vehicle=vehicle,originX=origin.x,originZ=origin.z,
        lastX=origin.x,lastZ=origin.z,targetX=objective.targetX,targetZ=objective.targetZ,
        steeringTargetX=steeringX,steeringTargetZ=steeringZ,
        maxTravelM=objective.maxTravelM,toolNode=toolNode,travelledM=0,
        commandedDriveCount=0,isComplete=false,isFailed=false}
    return true,{kind="REVERSE_ARMED",hasToolReverser=toolNode~=nil,
        isPhysicalMotionConfirmed=false}
end

function Mechanism:reverseStatus(vehicle)
    local state=self.states[vehicle]
    if state==nil then return {travelledM=0,isFailed=true,reason="REVERSE_NOT_ACTIVE"} end
    if AIVehicleUtil==nil or AIVehicleUtil.driveToPoint~=self.wrapper then
        state.isFailed=true;state.reason="DRIVE_PATH_CHANGED"
    else
        self:observeDisplacement(state)
    end
    return {travelledM=state.travelledM,isComplete=state.isComplete,
        isFailed=state.isFailed,reason=state.reason,
        commandedDriveCount=state.commandedDriveCount}
end

function Mechanism:uninstall()
    if self.activeVehicle~=nil then return false,"REVERSE_STILL_ACTIVE" end
    if self.wrapper~=nil and type(AIVehicleUtil)=="table"
        and AIVehicleUtil.driveToPoint==self.wrapper then
        AIVehicleUtil.driveToPoint=self.originalDrive
    end
    self.originalDrive=nil
    self.wrapper=nil
    return true
end

function Mechanism:stopReverse(vehicle)
    local state=self.states[vehicle]
    if state==nil or not state.isComplete then
        return false,"REVERSE_NOT_COMPLETE"
    end
    self.states[vehicle]=nil
    self.activeVehicle=nil
    self:uninstall()
    return true
end

function Mechanism:cancelReverse(vehicle)
    if self.activeVehicle~=nil and self.activeVehicle~=vehicle then
        return false,"OTHER_REVERSE_ACTIVE"
    end
    if vehicle~=nil then self.states[vehicle]=nil end
    self.activeVehicle=nil
    self:uninstall()
    return true
end
