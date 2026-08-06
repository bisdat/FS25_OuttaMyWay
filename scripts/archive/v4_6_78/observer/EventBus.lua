-- FS25_OuttaMyWay v4.2.1.0
-- Small synchronous event bus for read-only Observer facts.
OuttaMyWay.EventBus = OuttaMyWay.EventBus or {}
local EventBus = OuttaMyWay.EventBus

function EventBus:init()
    self.listeners = self.listeners or {}
end

function EventBus:subscribe(eventName, callback, owner)
    if type(eventName) ~= "string" or type(callback) ~= "function" then return false end
    self:init()
    self.listeners[eventName] = self.listeners[eventName] or {}
    table.insert(self.listeners[eventName], {callback=callback, owner=owner})
    return true
end

function EventBus:unsubscribeOwner(owner)
    if owner == nil or self.listeners == nil then return end
    for eventName, list in pairs(self.listeners) do
        local retained = {}
        for _, entry in ipairs(list) do
            if entry.owner ~= owner then retained[#retained+1] = entry end
        end
        self.listeners[eventName] = retained
    end
end

function EventBus:emit(eventName, payload)
    if self.listeners == nil then return end
    local list = self.listeners[eventName]
    if list == nil then return end
    for _, entry in ipairs(list) do
        local ok, err = pcall(entry.callback, payload)
        if not ok then
            Logging.warning("[FS25_OuttaMyWay] EventBus listener failed for %s: %s", tostring(eventName), tostring(err))
        end
    end
end
