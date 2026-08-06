local function validate(values)
    if type(values.identity) ~= "string" or values.identity == "" then error("ReplayFixture identity required",3) end
    if type(values.title) ~= "string" or values.title == "" then error("ReplayFixture title required",3) end
    if type(values.sourceEvidence) ~= "table" or #values.sourceEvidence == 0 then error("ReplayFixture source evidence required",3) end
    if type(values.steps) ~= "table" then error("ReplayFixture steps must be a table",3) end
    local aliases = {}
    for index, step in ipairs(values.steps) do
        if type(step) ~= "table" or type(step.kind) ~= "string" or step.kind == "" then
            error("ReplayFixture step " .. tostring(index) .. " requires kind",3)
        end
        if step.alias ~= nil then
            if type(step.alias) ~= "string" or step.alias == "" then error("ReplayFixture alias must be non-empty",3) end
            if aliases[step.alias] then error("ReplayFixture duplicate alias " .. step.alias,3) end
            aliases[step.alias] = true
        end
    end
end

OuttaMyWay.ReplayFixture = OuttaMyWay.ValueRecord.register(
    "ReplayFixture",
    OuttaMyWay.ValueRecord.define(
        "ReplayFixture",
        {"identity","title","sourceEvidence","steps","expected","provenance"},
        {},
        validate
    )
)
