-- Contract provenance: archive/0.4.11.0 terminal/obstruction relocation.
-- The production helper is an exact copy of the archived predicate.
OuttaMyWay={}
dofile("scripts/observation/CurrentPlayerControlObservation.lua")
local Observation=OuttaMyWay.CurrentPlayerControlObservation
local mission={controlledVehicle=nil}
local root={rootNode=9901,controlled=false}
function root:getRootVehicle() return self end
function root:getIsControlled() return self.controlled end
local implement={rootNode=9902,controlled=false}
function implement:getRootVehicle() return root end
function implement:getIsControlled() return self.controlled end
local secondRoot={rootNode=9903}
function secondRoot:getRootVehicle() return self end
function secondRoot:getIsControlled() return false end
local playerSeat={rootNode=9904}
function playerSeat:getRootVehicle() return root end
function playerSeat:getIsControlled() return false end
local function controlled(object)
    return Observation.isControlled(mission,object)
end

assert(not controlled(root) and not controlled(implement))
root.controlled=true
assert(controlled(root) and controlled(implement),"root getter is positive witness")
root.controlled=false
implement.controlled=true
assert(controlled(implement),"child getter independently vetoes player control")
assert(not controlled(root),"child-only flag does not label unrelated queried root")
implement.controlled=false
mission.controlledVehicle=playerSeat
assert(controlled(root) and controlled(implement),
    "mission controlled child must normalise to physical root")
mission.controlledVehicle=secondRoot
assert(not controlled(implement),"different current root is not player takeover")
mission.controlledVehicle=nil

-- Archived semantics do not promote missing or failed native control getters
-- to a synthetic positive claim.
root.getIsControlled=nil
implement.getIsControlled=nil
assert(not controlled(implement))
root.getIsControlled=function() error("GIANTS_ROOT_QUERY_EXCEPTION") end
implement.getIsControlled=function() error("GIANTS_OBJECT_QUERY_EXCEPTION") end
assert(not controlled(implement))
mission.controlledVehicle=playerSeat
assert(controlled(implement),"mission-root witness independently survives getter errors")
mission.controlledVehicle=nil

root.getRootVehicle=function() error("ROOT_LOOKUP_UNAVAILABLE") end
implement.getRootVehicle=function() error("ROOT_LOOKUP_UNAVAILABLE") end
implement.rootVehicle=root
root.isDeleted=false
root.getIsControlled=function() return true end
assert(controlled(implement),"archived rootVehicle fallback retains control witness")
root.getRootVehicle=function(self)return self end
implement.getRootVehicle=function(self)return root end
root.getIsControlled=function()return false end
implement.getIsControlled=function()return false end
implement.rootVehicle=nil

assert(not controlled(nil),"nil object is not a positive player witness")
assert(not controlled({rootNode=0}),"invalid root cannot create a positive claim")
print("Archived root-aware transient Player Control Interlock: PASS")
