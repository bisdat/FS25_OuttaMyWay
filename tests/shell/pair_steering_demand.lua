-- Initial GIANTS local command preview is a bounded assessment, never Control.
OuttaMyWay={NativeReverseMechanism={
    adjustToolTarget=function(_,tool,x,z)
        -- No attached tool: identical world target; with tool: correction
        -- demonstrably changes the preview, not the actual drive call.
        if tool~=nil then return 0,-40,nil end
        return x,z,nil
    end
}}
local observedCalls=0
AIVehicleUtil={getAIToolReverserDirectionNode=function(vehicle)
    return vehicle.toolNode
end}
getWorldTranslation=function(node)
    return node.x or 0,0,node.z or 0
end
worldToLocal=function(node,x,y,z)
    return x-(node.x or 0),y,z-(node.z or 0)
end
dofile("scripts/coordination/PairSteeringDemand.lua")
local assess=OuttaMyWay.PairSteeringDemand.assess
local node={x=0,z=0}
local vehicle={rootNode=node,toolNode=nil,
    getAIReverserNode=function(self)return self.rootNode end,
    getAISteeringNode=function(self)return self.rootNode end}
local aligned=assert(assess(vehicle,0,-40,false))
local sideways=assert(assess(vehicle,40,0,false))
local forwards=assert(assess(vehicle,0,40,true))
assert(aligned.deviationDeg<0.001 and sideways.deviationDeg>89.9
    and forwards.deviationDeg<0.001)
assert(aligned.driveLocalZ<0 and sideways.driveLocalX>0)
vehicle.toolNode={}
local corrected=assert(assess(vehicle,40,0,false))
assert(corrected.deviationDeg<0.001 and corrected.driveLocalZ<0,
    "assessment must use the same tool-corrected world target as Control")
vehicle.toolNode=nil
AIVehicleUtil.getAIToolReverserDirectionNode=nil
local missing,reason=assess(vehicle,0,-40,false)
assert(missing==nil and reason=="STEERING_PREVIEW_NATIVE_API_UNAVAILABLE",
    "missing reverse evidence cannot be a positive steering assessment")
assert(assess(vehicle,0,40,true),
    "forward assessment does not depend on reverse-tool API")
print("Pair steering demand: reverse/forward, tool correction, absent native API PASS")
