OuttaMyWay.EpochSequence = {}
local EpochSequence = OuttaMyWay.EpochSequence
EpochSequence.__index = EpochSequence

function EpochSequence.new(initialValue)
    local self = setmetatable({}, EpochSequence)
    self.value = initialValue or 0
    if type(self.value) ~= "number" or self.value < 0 or self.value % 1 ~= 0 then
        error("EpochSequence initial value must be a non-negative integer", 2)
    end
    return self
end

function EpochSequence:current()
    return self.value
end

function EpochSequence:next()
    self.value = self.value + 1
    return self.value
end
