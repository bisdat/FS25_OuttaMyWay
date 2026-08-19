OuttaMyWay.EffectiveActuationComposition = {}
local Composition = OuttaMyWay.EffectiveActuationComposition

local Record = OuttaMyWay.ValueRecord.register(
    "EffectiveActuationCompositionRecord",
    OuttaMyWay.ValueRecord.define(
        "EffectiveActuationCompositionRecord",
        {"identity","epoch","entries","relevantAssemblyIds"},
        {}
    )
)

local function contains(list, value)
    for _, item in OuttaMyWay.ValueRecord.ipairs(list) do if item == value then return true end end
    return false
end

function Composition.create(values)
    values = values or {}
    local progressOwners,postJobOwners = {},{}
    local held = {}
    for _, entry in OuttaMyWay.ValueRecord.ipairs(values.entries or {}) do
        if type(entry.assemblyId) ~= "string" or type(entry.commitmentId) ~= "string" or type(entry.capability) ~= "string" then
            error("composition entry requires assemblyId, commitmentId and capability", 2)
        end
        if entry.progressActuation then
            local owner=progressOwners[entry.assemblyId]; if owner~=nil and owner~=entry.commitmentId then error("composition contains multiple progress owners for one assembly",2) end
            progressOwners[entry.assemblyId]=entry.commitmentId
        end
        if entry.postJobActuation then
            local owner=postJobOwners[entry.assemblyId]; if owner~=nil and owner~=entry.commitmentId then error("composition contains multiple post-job owners for one assembly",2) end
            postJobOwners[entry.assemblyId]=entry.commitmentId
        end
        if entry.progressActuation and entry.postJobActuation then error("composition entry cannot be both progress and post-job actuation",2) end
        if entry.effectClass == "HOLD" then held[entry.assemblyId] = true end
    end

    local relevant = values.relevantAssemblyIds or {}
    if #relevant > 0 then
        local allHeld = true
        for _, assemblyId in OuttaMyWay.ValueRecord.ipairs(relevant) do
            if not held[assemblyId] then allHeld = false break end
        end
        if allHeld then error("Effective Actuation Composition violates never hold all", 2) end
    end

    return Record.new({
        identity = values.identity,
        epoch = values.epoch,
        entries = values.entries or {},
        relevantAssemblyIds = relevant
    })
end
