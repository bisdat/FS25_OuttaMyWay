-- FS25_OuttaMyWay v4.2.0.1
-- Normalised, map/vehicle/mod-independent worker state.
OuttaMyWay.WorkerState = OuttaMyWay.WorkerState or {}
local WorkerState = OuttaMyWay.WorkerState

local function nameOf(vehicle)
    if vehicle ~= nil and type(vehicle.getName) == "function" then
        local ok,name = pcall(vehicle.getName,vehicle)
        if ok and name ~= nil and name ~= "" then return name end
    end
    return "AI vehicle"
end

local function getPos(vehicle)
    local node = vehicle.rootNode
    if type(vehicle.getAISteeringNode) == "function" then
        local ok,n = pcall(vehicle.getAISteeringNode,vehicle)
        if ok and n ~= nil and n ~= 0 then node=n end
    end
    if node == nil or node == 0 then return nil,nil,nil,nil end
    local x,y,z = getWorldTranslation(node)
    local dx,_,dz = localDirectionToWorld(node,0,0,1)
    local heading = math.deg(math.atan2(dx,dz))
    return x,y,z,heading
end

local function activeFlag(vehicle)
    local fieldActive = vehicle.spec_aiFieldWorker ~= nil and vehicle.spec_aiFieldWorker.isActive == true
    if type(vehicle.getIsFieldWorkActive) == "function" then
        local ok,v = pcall(vehicle.getIsFieldWorkActive,vehicle)
        if ok and v == true then fieldActive = true end
    end
    local aiActive = false
    if type(vehicle.getIsAIActive) == "function" then
        local ok,v = pcall(vehicle.getIsAIActive,vehicle)
        aiActive = ok and v == true
    end
    return fieldActive or aiActive,fieldActive,aiActive
end

function WorkerState.fromNative(vehicle,native,nowSeconds)
    local active,fieldActive,aiActive = activeFlag(vehicle)
    local x,y,z,heading = getPos(vehicle)
    local speed = math.abs((vehicle.lastSpeedReal or 0)*3600)
    local av = native.active and native.active.values or {}
    local progress = tonumber(av[3])
    local length = tonumber(av[4])
    local isTurn = av[1] == true
    local requested = tonumber(native.requestedSpeed)
    local ratio = nil
    if requested ~= nil and requested > 0.1 then ratio = speed/requested end
    local phase = isTurn and "MANOEUVRING" or "WORKING"
    if speed < 0.25 and requested ~= nil and requested > 0.5 then phase = "STALLED" end
    if native.isBlocked then phase = "BLOCKED" end
    return {
        vehicle=vehicle,name=nameOf(vehicle),timestamp=nowSeconds,
        active=active,fieldActive=fieldActive,aiActive=aiActive,
        x=x,y=y,z=z,heading=heading,
        actualSpeed=speed,requestedSpeed=requested,speedRatio=ratio,
        phase=phase,isTurn=isTurn,progress=progress,segmentLength=length,
        blocked=native.isBlocked,staticCollision=native.hasStaticCollision,
        target=native.lastTargetPosition,native=native
    }
end

function WorkerState.signature(state)
    return table.concat({
        tostring(state.active),state.phase,tostring(state.isTurn),tostring(state.blocked),
        string.format("%.1f",state.requestedSpeed or -1),
        string.format("%.0f",(state.progress or -1)*10)
    },"|")
end
