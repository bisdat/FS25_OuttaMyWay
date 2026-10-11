-- One-shot kinematic command preview for spatially admitted pair egress candidates.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- Does not issue GIANTS commands, own Control or certify physical stability.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.PairSteeringDemand={}
local Demand=OuttaMyWay.PairSteeringDemand
local function finite(x)
    return type(x)=="number" and x==x
        and x~=math.huge and x~=-math.huge
end
local function nodeOf(vehicle,name)
    if type(vehicle)~="table" or type(vehicle[name])~="function" then
        return nil,"STEERING_NODE_UNAVAILABLE"
    end
    local ok,node=pcall(vehicle[name],vehicle)
    if not ok or node==nil or node==0 then
        return nil,"STEERING_NODE_UNAVAILABLE"
    end
    return node
end
function Demand.assess(vehicle,targetX,targetZ,moveForwards)
    if not finite(targetX) or not finite(targetZ)
        or type(worldToLocal)~="function"
        or type(getWorldTranslation)~="function" then
        return nil,"STEERING_PREVIEW_GEOMETRY_UNAVAILABLE"
    end
    local node,reason=nodeOf(vehicle,moveForwards
        and "getAISteeringNode" or "getAIReverserNode")
    if node==nil then return nil,reason end
    local ok,_,y=pcall(getWorldTranslation,node)
    if not ok or not finite(y) then
        return nil,"STEERING_PREVIEW_NODE_POSE_UNAVAILABLE"
    end
    local wx,wz=targetX,targetZ
    if not moveForwards then
        if type(AIVehicleUtil)~="table"
            or type(AIVehicleUtil.getAIToolReverserDirectionNode)~="function"
            or type(OuttaMyWay.NativeReverseMechanism)~="table"
            or type(OuttaMyWay.NativeReverseMechanism.adjustToolTarget)~="function" then
            return nil,"STEERING_PREVIEW_NATIVE_API_UNAVAILABLE"
        end
        local toolOk,toolNode=pcall(
            AIVehicleUtil.getAIToolReverserDirectionNode,vehicle)
        if not toolOk then return nil,"STEERING_PREVIEW_TOOL_QUERY_FAILED" end
        if toolNode==0 then toolNode=nil end
        wx,wz,reason=OuttaMyWay.NativeReverseMechanism.adjustToolTarget(
            node,toolNode,targetX,targetZ)
        if not finite(wx) or not finite(wz) then
            return nil,reason or "STEERING_PREVIEW_TOOL_GEOMETRY_INVALID"
        end
    end
    local translated,lx,_,lz=pcall(worldToLocal,node,wx,y,wz)
    if not translated or not finite(lx) or not finite(lz) then
        return nil,"STEERING_PREVIEW_LOCAL_TARGET_UNAVAILABLE"
    end
    local magnitude=math.sqrt(lx*lx+lz*lz)
    if magnitude<=0.0001 then
        return nil,"STEERING_PREVIEW_LOCAL_TARGET_UNAVAILABLE"
    end
    local localX,localZ=lx/magnitude,lz/magnitude
    local straight=moveForwards and localZ or -localZ
    straight=math.max(-1,math.min(1,straight))
    return {deviationDeg=math.deg(math.acos(straight)),
        driveLocalX=localX,driveLocalZ=localZ,
        -- This is *effective local target direction*, not wheel/hitch angle.
        geometryBasis="NATIVE_TOOL_CORRECTED_LOCAL_DRIVE_DIRECTION"}
end
