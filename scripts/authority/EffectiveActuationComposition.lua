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

function Composition.create(values)
    values = values or {}
    local progressOwners,postJobOwners,obstructionRelocationOwners = {},{},{}
    local authorityClassByAssembly={}
    local held = {}
    for _, entry in OuttaMyWay.ValueRecord.ipairs(values.entries or {}) do
        if type(entry.assemblyId) ~= "string" or type(entry.commitmentId) ~= "string" or type(entry.capability) ~= "string" then
            error("composition entry requires assemblyId, commitmentId and capability", 2)
        end
        local authorityClassCount=(entry.progressActuation and 1 or 0)+(entry.postJobActuation and 1 or 0)+(entry.obstructionRelocationActuation and 1 or 0)
        if authorityClassCount>1 then error("composition entry cannot own multiple actuation authority classes",2) end
        local entryClass=nil
        if entry.progressActuation then entryClass="PROGRESS_ACTUATION"
        elseif entry.postJobActuation then entryClass="POST_JOB_ACTUATION"
        elseif entry.obstructionRelocationActuation then entryClass="OBSTRUCTION_RELOCATION_ACTUATION" end
        if entryClass~=nil then
            local existingClass=authorityClassByAssembly[entry.assemblyId]
            if existingClass~=nil and existingClass~=entryClass then
                error("composition cannot assign multiple actuation authority classes to one assembly",2)
            end
            authorityClassByAssembly[entry.assemblyId]=entryClass
        end
        if entry.progressActuation then
            local owner=progressOwners[entry.assemblyId]; if owner~=nil and owner~=entry.commitmentId then error("composition contains multiple progress owners for one assembly",2) end
            progressOwners[entry.assemblyId]=entry.commitmentId
        end
        if entry.postJobActuation then
            local owner=postJobOwners[entry.assemblyId]; if owner~=nil and owner~=entry.commitmentId then error("composition contains multiple post-job owners for one assembly",2) end
            postJobOwners[entry.assemblyId]=entry.commitmentId
        end
        if entry.obstructionRelocationActuation then
            local owner=obstructionRelocationOwners[entry.assemblyId]; if owner~=nil and owner~=entry.commitmentId then error("composition contains multiple obstruction-relocation owners for one assembly",2) end
            obstructionRelocationOwners[entry.assemblyId]=entry.commitmentId
        end
        if entry.effectClass == "HOLD" then held[entry.assemblyId] = true end
    end

    local relevant = values.relevantAssemblyIds or {}
    if OuttaMyWay.ValueRecord.length(relevant) > 0 then
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