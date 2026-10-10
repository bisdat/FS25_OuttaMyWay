-- Positive immediate non-active obstruction nomination from a native blocked worker.
-- Specification Jurisdictions: `OBSTRUCTION_RELOCATION`
-- No historical Job Episode table, path prediction or actuation authority.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NonActiveObstructionAssessment={}
local A=OuttaMyWay.NonActiveObstructionAssessment

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
    local node=vehicle and vehicle.rootNode
    if node==nil or node==0 or type(getWorldTranslation)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,node)
    if not ok or not finite(x) or not finite(z) then return nil end
    return {x=x,z=z}
end

local function footprint(vehicle)
    local size=vehicle and vehicle.size
    local width=type(size)=="table" and tonumber(size.width) or nil
    local length=type(size)=="table" and tonumber(size.length) or nil
    if not finite(width) or not finite(length)
        or width<=0 or length<=0 then return nil end
    return {halfWidth=width*0.5,halfLength=length*0.5}
end

local function forward(vehicle)
    if type(vehicle.getAISteeringNode)~="function"
        or type(localDirectionToWorld)~="function" then return nil end
    local ok,node=pcall(vehicle.getAISteeringNode,vehicle)
    if not ok or node==nil or node==0 then return nil end
    local good,x,_,z=pcall(localDirectionToWorld,node,0,0,1)
    if not good or not finite(x) or not finite(z) then return nil end
    local length=math.sqrt(x*x+z*z)
    if length<=0.0001 then return nil end
    return {x=x/length,z=z/length}
end

local function currentAI(vehicle,registry)
    if type(vehicle)~="table" then return nil end
    if type(registry)~="table" then return nil end
    for k,v in pairs(registry) do
        if rootOf(k)==vehicle or rootOf(v)==vehicle
            or (type(v)=="table" and (rootOf(v.vehicle)==vehicle
                or rootOf(v.object)==vehicle or rootOf(v.rootVehicle)==vehicle)) then
            return true
        end
    end
    if type(vehicle.getIsAIActive)~="function" then return nil end
    local ok,value=pcall(vehicle.getIsAIActive,vehicle)
    if not ok or type(value)~="boolean" then return nil end
    return value
end

local function inImmediateCorridor(beneficiary,blocker)
    local first,second=pose(beneficiary),pose(blocker)
    local fa,fb=footprint(beneficiary),footprint(blocker)
    local heading=forward(beneficiary)
    if first==nil or second==nil or fa==nil or fb==nil
        or heading==nil then return nil end
    local dx,dz=second.x-first.x,second.z-first.z
    local ahead=dx*heading.x+dz*heading.z
    local lateral=math.abs(dx*heading.z-dz*heading.x)
    -- Existing current physical extents, not a speculative turn horizon.
    -- A blocked-state pulse supplies positive GIANTS failure evidence.
    local longitudinalLimit=fa.halfLength+fb.halfLength
    local lateralLimit=fa.halfWidth+fb.halfWidth
    if ahead>=0 and ahead<=longitudinalLimit
        and lateral<=lateralLimit then
        return {forwardM=ahead,lateralM=lateral,
            longitudinalLimitM=longitudinalLimit,
            lateralLimitM=lateralLimit}
    end
    return nil
end

function A.find(beneficiary)
    local mission=g_currentMission
    local registry=mission and mission.aiSystem and mission.aiSystem.activeJobVehicles
    local population=mission and mission.vehicleSystem and mission.vehicleSystem.vehicles
    if type(beneficiary)~="table" or type(population)~="table"
        or type(registry)~="table" then return nil end
    local candidate=nil
    local seen={}
    local activeRoot=rootOf(beneficiary)
    local function consider(value)
        local vehicle=rootOf(value)
        if vehicle==nil or vehicle==activeRoot or seen[vehicle]
            or vehicle.rootNode==nil or vehicle.isDeleted==true then return end
        seen[vehicle]=true
        if currentAI(vehicle,registry)~=false
            or OuttaMyWay.CurrentPlayerControlObservation.isControlled(mission,vehicle)
            then return end
        local relation=inImmediateCorridor(beneficiary,vehicle)
        if relation~=nil then
            if candidate~=nil then
                candidate=false -- ambiguous: do not choose a neighbour arbitrarily
            elseif candidate~=false then
                candidate={beneficiary=beneficiary,blocker=vehicle,
                    relation=relation,positive=true,
                    evidenceSource="NATIVE_BLOCKED_AND_CURRENT_PHYSICAL_CORRIDOR"}
            end
        end
    end
    for k,v in pairs(population) do
        consider(k)
        consider(v)
    end
    return type(candidate)=="table" and candidate or nil
end

function A.isStillCurrent(evidence)
    if type(evidence)~="table" or type(evidence.beneficiary)~="table"
        or type(evidence.blocker)~="table" then return false end
    local mission=g_currentMission
    local registry=mission and mission.aiSystem and mission.aiSystem.activeJobVehicles
    local active=false
    if type(registry)=="table" then
        for k,v in pairs(registry) do
            if rootOf(k)==rootOf(evidence.beneficiary)
                or rootOf(v)==rootOf(evidence.beneficiary) then
                active=true;break
            end
        end
    end
    return active and currentAI(evidence.blocker,registry)==false
        and not OuttaMyWay.CurrentPlayerControlObservation.isControlled(
            mission,evidence.blocker)
end
