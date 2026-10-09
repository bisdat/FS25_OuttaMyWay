--- Acquires one current GIANTS player-control predicate for Observation and mechanical interlocks.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- Executable predicate unchanged from archive/0.4.11.0 terminal relocation;
-- jurisdiction header adapted to current live repository governance.

-- Current Player Control is transient Reality evidence. A positive result excludes
-- concurrent OuttaMyWay actuation over the same physical root; it does not create
-- historical Player Claim state or infer deliberate player intent.
OuttaMyWay.CurrentPlayerControlObservation={}
local Observation=OuttaMyWay.CurrentPlayerControlObservation

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
end

local function usableVehicle(object)
    return type(object)=="table"
        and object.isDeleted~=true
        and object.rootNode~=nil
        and object.rootNode~=0
end

local function rootVehicle(object)
    if not usableVehicle(object) then return nil end
    local ok,root=safeCall(object,"getRootVehicle")
    if ok and usableVehicle(root) then return root end
    if usableVehicle(object.rootVehicle) then return object.rootVehicle end
    return object
end

function Observation.isControlled(mission,object)
    if object==nil then return false end
    local target=rootVehicle(object) or object

    local ok,value=safeCall(target,"getIsControlled")
    if ok and value==true then return true end
    if target~=object then
        local objectOk,objectValue=safeCall(object,"getIsControlled")
        if objectOk and objectValue==true then return true end
    end

    local controlled=rootVehicle(mission and mission.controlledVehicle or nil)
    return controlled~=nil and target~=nil and controlled==target
end
