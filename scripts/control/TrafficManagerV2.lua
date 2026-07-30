-- FS25_OuttaMyWay v4.2.5.5
-- Coordinator only. Decision and execution are deliberately separate.
OuttaMyWay.TrafficManagerV2 = OuttaMyWay.TrafficManagerV2 or {}
local Manager = OuttaMyWay.TrafficManagerV2

function Manager:init()
    self.initialized = true
    if OuttaMyWay.TrafficDecisionEngineV2 ~= nil and OuttaMyWay.TrafficDecisionEngineV2.init ~= nil then
        OuttaMyWay.TrafficDecisionEngineV2:init()
    end
    if OuttaMyWay.TrafficExecutorV2 ~= nil and OuttaMyWay.TrafficExecutorV2.init ~= nil then
        OuttaMyWay.TrafficExecutorV2:init()
    end
    print("Info: [FS25_OuttaMyWay] TRAFFIC MANAGER V2 ACTIVE: native permission-gate HOLD prototype")
end

function Manager:update(dt)
    if self.initialized ~= true then self:init() end
    if OuttaMyWay.TrafficDecisionEngineV2 ~= nil and OuttaMyWay.TrafficDecisionEngineV2.update ~= nil then
        OuttaMyWay.TrafficDecisionEngineV2:update(dt)
    end
    if OuttaMyWay.TrafficExecutorV2 ~= nil and OuttaMyWay.TrafficExecutorV2.update ~= nil then
        OuttaMyWay.TrafficExecutorV2:update(dt)
    end
    if OuttaMyWay.RecoveryHandoff ~= nil and OuttaMyWay.RecoveryHandoff.update ~= nil then
        OuttaMyWay.RecoveryHandoff:update(dt)
    end
end
