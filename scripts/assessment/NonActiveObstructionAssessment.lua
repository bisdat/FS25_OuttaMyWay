-- Source adapter for archived Causal Obstruction, not a new collision model.
-- Specification Jurisdictions: `OBSTRUCTION_RELOCATION`
-- Archive donors: CurrentPhysicalConflictRepresentation, PlanViewFootprint,
-- CausalObstructionAssessment, RealisedMotionDemandAssessment,
-- TrajectoryConflictAssessment (coherent aligned progression only).
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NonActiveObstructionAssessment={}
local A=OuttaMyWay.NonActiveObstructionAssessment
A.__index=A
local FORMATION_M=3.0          -- archive TrajectoryConflictAssessment
local COHERENCE_DOT=0.94      -- archive TrajectoryConflictAssessment
local PERSISTENCE_DOT=0.85    -- archive TrajectoryConflictAssessment
local MAX_REACH_M=100         -- archive RealisedMotionDemandAssessment (#385)
local MIN_SPEED_MPS=0.05      -- archive RealisedMotionDemandAssessment

local function finite(n)
    return type(n)=="number" and n==n and n~=math.huge and n~=-math.huge
end
local function rootOf(vehicle)
    if type(vehicle)~="table" then return nil end
    if type(vehicle.getRootVehicle)=="function" then
        local ok,root=pcall(vehicle.getRootVehicle,vehicle)
        if ok and type(root)=="table" then return root end
    end
    return type(vehicle.rootVehicle)=="table" and vehicle.rootVehicle or vehicle
end
local function pose(vehicle)
    if type(vehicle)~="table" or vehicle.isDeleted==true then return nil end
    local node=vehicle.rootNode
    if node==nil or node==0 or type(getWorldTranslation)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,node)
    if not ok or not finite(x) or not finite(z) then return nil end
    return {x=x,z=z}
end
local function direction(dx,dz)
    local length=math.sqrt(dx*dx+dz*dz)
    if not finite(length) or length<=0.000001 then return nil end
    return dx/length,dz/length,length
end
local function heading(worker)
    if type(worker.getAISteeringNode)~="function"
        or type(localDirectionToWorld)~="function" then return nil end
    local ok,node=pcall(worker.getAISteeringNode,worker)
    if not ok or node==nil or node==0 then return nil end
    local good,x,_,z=pcall(localDirectionToWorld,node,0,0,1)
    if not good or not finite(x) or not finite(z) then return nil end
    return direction(x,z)
end
local function strategyOf(worker)
    local spec=worker and worker.spec_aiFieldWorker
    local strategies=spec and spec.driveStrategies
    if type(strategies)~="table" then return nil end
    for _,strategy in pairs(strategies) do
        if type(strategy)=="table" and strategy.aiFieldCourse~=nil
            and type(strategy.isBlocked)=="boolean" then return strategy end
    end
    return nil
end
local function activeWorkers()
    local mission=g_currentMission
    local registry=mission and mission.aiSystem and mission.aiSystem.activeJobVehicles
    if type(registry)~="table" then return {},nil end
    local list,seen={},{}
    for key,value in pairs(registry) do
        for _,entry in ipairs({key,value}) do
            local worker=rootOf(entry)
            if worker~=nil and worker.rootNode~=nil and not seen[worker]
                and worker.isDeleted~=true and strategyOf(worker)~=nil then
                seen[worker]=true
                list[#list+1]=worker
            end
        end
    end
    table.sort(list,function(a,b)return tostring(a.rootNode)<tostring(b.rootNode) end)
    return list,registry
end
local function activeMember(vehicle,registry)
    if type(registry)~="table" then return nil end
    for key,value in pairs(registry) do
        if rootOf(key)==vehicle or rootOf(value)==vehicle then return true end
    end
    return false
end
local function inactiveAndUnclaimed(vehicle,registry)
    if type(vehicle)~="table" or vehicle.isDeleted==true
        or activeMember(vehicle,registry)~=false
        or type(vehicle.getIsAIActive)~="function" then return false end
    local ok,active=pcall(vehicle.getIsAIActive,vehicle)
    return ok and active==false
        and not OuttaMyWay.CurrentPlayerControlObservation.isControlled(
            g_currentMission,vehicle)
end
local function physicalVehicles()
    local mission=g_currentMission
    local all=mission and mission.vehicleSystem and mission.vehicleSystem.vehicles
    if type(all)~="table" then return nil end
    local result,seen={},{}
    for key,value in pairs(all) do
        for _,item in ipairs({key,value}) do
            local vehicle=rootOf(item)
            if vehicle~=nil and vehicle.rootNode~=nil and not seen[vehicle] then
                seen[vehicle]=true
                result[#result+1]=vehicle
            end
        end
    end
    table.sort(result,function(a,b)return tostring(a.rootNode)<tostring(b.rootNode) end)
    return result
end

function A.new()
    return setmetatable({
        representations=OuttaMyWay.CurrentPhysicalConflictRepresentation.new(),
        tracks=setmetatable({},{__mode="k"})
    },A)
end
function A:reset()
    self.tracks=setmetatable({},{__mode="k"})
    self.representations:reset()
end
-- Lift the archive's coherent displacement / aligned-reach contract rather
-- than inventing a 1-second blocked trigger or forward body rectangle.
function A:sample(worker,dt)
    local current=pose(worker)
    local course=strategyOf(worker)
    if current==nil or course==nil then self.tracks[worker]=nil;return end
    local track=self.tracks[worker]
    if track==nil or track.strategy~=course then
        self.tracks[worker]={strategy=course,x=current.x,z=current.z,
            forming=0,aligned=0,established=false}
        return
    end
    local dx,dz=current.x-track.x,current.z-track.z
    track.x,track.z=current.x,current.z
    local ux,uz,distance=direction(dx,dz)
    if ux==nil or distance<0.10 then return end
    local hx,hz=heading(worker)
    if hx==nil or ux*hx+uz*hz<PERSISTENCE_DOT then
        track.forming=0;track.aligned=0;track.established=false
        track.directionX=nil;track.directionZ=nil
        return
    end
    if not track.established then
        if track.directionX~=nil
            and track.directionX*ux+track.directionZ*uz<COHERENCE_DOT then
            track.forming=0
        end
        track.directionX,track.directionZ=ux,uz
        track.forming=track.forming+distance
        if track.forming>=FORMATION_M then
            track.established=true
            track.aligned=track.forming
        end
    else
        if track.directionX*ux+track.directionZ*uz<PERSISTENCE_DOT then
            track.established=false;track.forming=0;track.aligned=0
            track.directionX,track.directionZ=ux,uz
        else
            track.aligned=track.aligned+distance
            -- Preserve the established direction against brief steering jitter.
            track.directionX,track.directionZ=ux,uz
        end
    end
    local dtSeconds=tonumber(dt) and tonumber(dt)*0.001 or nil
    track.speedMps=dtSeconds and dtSeconds>0 and distance/dtSeconds or nil
end
function A:advance(dt)
    local workers=activeWorkers()
    for _,worker in ipairs(workers) do self:sample(worker,dt) end
end
local function evidenceFor(self,worker,blocker)
    local now=(tonumber(g_time) or 0)*0.001
    local activeShape=self.representations:observe(worker,
        "active:"..tostring(worker.rootNode),now)
    local parkedShape=self.representations:observe(blocker,
        "non-active:"..tostring(blocker.rootNode),now)
    if activeShape==nil or parkedShape==nil
        or activeShape.structurallyValid~=true
        or parkedShape.structurallyValid~=true then return nil end
    local track=self.tracks[worker]
    local demand=nil
    if track~=nil and track.established==true
        and finite(track.speedMps) and track.speedMps>=MIN_SPEED_MPS
        and finite(track.aligned) and track.aligned>0 then
        local reach=math.min(track.aligned,MAX_REACH_M)
        local sweeps={}
        for _,primitive in ipairs(activeShape.worldPrimitives) do
            if primitive.kind=="DISC" and primitive.positiveConflictSupport==true then
                sweeps[#sweeps+1]={
                    kind="DISC_SWEEP",beneficiaryPrimitiveId=primitive.identity,
                    startX=primitive.x,startZ=primitive.z,
                    endX=primitive.x+track.directionX*reach,
                    endZ=primitive.z+track.directionZ*reach,
                    radius=primitive.radius
                }
            end
        end
        demand={positive=#sweeps>0,
            horizonM=reach,
            directionX=track.directionX,directionZ=track.directionZ,
            physicalDemandSweeps=sweeps,
            provenance="ARCHIVED_REALIZED_MOTION_DEMAND_ALIGNED_REACH"}
    end
    local relation=OuttaMyWay.CausalObstructionAssessment.positiveObstruction(
        {primitives=parkedShape.worldPrimitives},
        {primitives=activeShape.worldPrimitives},nil,demand)
    if relation==nil then return nil end
    return {positive=true,beneficiary=worker,blocker=blocker,
        relation=relation,evidenceSource=relation.kind,
        nativeBlockedRequired=false,
        realisedMotionReachM=demand and demand.horizonM or nil,
        physicalSource="CURRENT_GIANTS_SHAPE_WORLD_SPHERES"}
end
function A:find(worker)
    local vehicles=physicalVehicles()
    local _,registry=activeWorkers()
    if vehicles==nil or registry==nil then return nil end
    local unique,ambiguous=nil,false
    local workerRoot=rootOf(worker)
    for _,vehicle in ipairs(vehicles) do
        if vehicle~=workerRoot and inactiveAndUnclaimed(vehicle,registry) then
            local candidate=evidenceFor(self,worker,vehicle)
            if candidate~=nil then
                if unique~=nil then ambiguous=true;break end
                unique=candidate
            end
        end
    end
    return not ambiguous and unique or nil
end
function A:findProspective()
    local workers=activeWorkers()
    for _,worker in ipairs(workers) do
        local strategy=strategyOf(worker)
        if strategy~=nil then
            local evidence=self:find(worker)
            if evidence~=nil then return evidence end
        end
    end
    return nil
end
function A.isStillCurrent(evidence)
    if type(evidence)~="table" or type(evidence.beneficiary)~="table"
        or type(evidence.blocker)~="table" then return false end
    local _,registry=activeWorkers()
    return activeMember(rootOf(evidence.beneficiary),registry)==true
        and inactiveAndUnclaimed(rootOf(evidence.blocker),registry)
end
