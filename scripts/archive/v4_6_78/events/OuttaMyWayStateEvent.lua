-- FS25_OuttaMyWay multiplayer HUD synchronization event.

OuttaMyWayStateEvent = {}
local OuttaMyWayStateEvent_mt = Class(OuttaMyWayStateEvent, Event)
InitEventClass(OuttaMyWayStateEvent, "OuttaMyWayStateEvent")

function OuttaMyWayStateEvent.emptyNew()
    return Event.new(OuttaMyWayStateEvent_mt)
end

function OuttaMyWayStateEvent.new(waitCount, priorityName, transientText)
    local self = OuttaMyWayStateEvent.emptyNew()
    self.waitCount = math.min(waitCount or 0, 255)
    self.priorityName = priorityName or ""
    self.transientText = transientText or ""
    return self
end

function OuttaMyWayStateEvent:readStream(streamId, connection)
    self.waitCount = streamReadUInt8(streamId)
    self.priorityName = streamReadString(streamId)
    self.transientText = streamReadString(streamId)
    self:run(connection)
end

function OuttaMyWayStateEvent:writeStream(streamId, connection)
    streamWriteUInt8(streamId, self.waitCount)
    streamWriteString(streamId, self.priorityName)
    streamWriteString(streamId, self.transientText)
end

function OuttaMyWayStateEvent:run(connection)
    if OuttaMyWay ~= nil then
        OuttaMyWay:receiveNetworkState(self.waitCount, self.priorityName, self.transientText)
    end
end
