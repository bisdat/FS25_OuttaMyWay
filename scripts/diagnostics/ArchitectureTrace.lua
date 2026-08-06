OuttaMyWay.ArchitectureTrace = {}
local Trace = OuttaMyWay.ArchitectureTrace
Trace.__index = Trace

function Trace.new()
    return setmetatable({ events = {} }, Trace)
end

function Trace:append(kind, epoch, evidence)
    if type(kind) ~= "string" or kind == "" then error("trace event requires kind", 2) end
    self.events[#self.events + 1] = {
        kind = kind,
        epoch = epoch,
        evidence = evidence
    }
end

function Trace:count() return #self.events end
function Trace:lines()
    local result = {}
    for index, event in OuttaMyWay.ValueRecord.ipairs(self.events) do
        result[index] = string.format("%s|%s|%s", tostring(event.epoch), event.kind, tostring(event.evidence))
    end
    return result
end
