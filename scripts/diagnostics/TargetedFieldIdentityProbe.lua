OuttaMyWay.TargetedFieldIdentityProbe = {}
local Probe = OuttaMyWay.TargetedFieldIdentityProbe
Probe.__index = Probe

local function logInfo(message)
    if Logging ~= nil and type(Logging.info) == "function" then
        Logging.info("[FS25_OuttaMyWay][FIELD-PROBE] %s", message)
    else
        print("[FS25_OuttaMyWay][FIELD-PROBE] " .. message)
    end
end

local function safeCall(object, methodName, ...)
    if object == nil or type(object[methodName]) ~= "function" then return false, nil end
    return pcall(object[methodName], object, ...)
end

local function referenceKey(vehicle)
    return "vehicle-root:" .. tostring(vehicle and (vehicle.rootNode or vehicle) or "nil")
end

local function vehicleName(vehicle)
    local ok, value = safeCall(vehicle, "getName")
    if ok and value ~= nil then return tostring(value) end
    return tostring(vehicle and (vehicle.name or vehicle.typeName) or "AI vehicle")
end

local function boolMethod(vehicle, methodName)
    local ok, value = safeCall(vehicle, methodName)
    if not ok then return "ABSENT" end
    return tostring(value)
end

local function fieldResultText(result)
    if result == nil then return "nil" end
    local current = result.current or {}
    local target = result.target or {}
    return string.format(
        "resolved=%s sourceFieldId=%s source=%s conflict=%s currentSourceField=%s currentFarmland=%s targetSourceField=%s targetFarmland=%s reason=%s",
        tostring(result.resolved == true), tostring(result.sourceFieldId or result.fieldId or 0), tostring(result.source), tostring(result.conflict == true),
        tostring(current.sourceFieldId or current.fieldId or 0), tostring(current.farmlandId), tostring(target.sourceFieldId or target.fieldId or 0), tostring(target.farmlandId), tostring(result.reason)
    )
end

local function jobText(jobProbe)
    if jobProbe == nil or not jobProbe.available then return "available=false" end
    local fields = {}
    for _, key in OuttaMyWay.ValueRecord.ipairs(jobProbe.fieldNames or {}) do fields[#fields + 1] = key .. "=" .. tostring(jobProbe.fields[key]) end
    return string.format(
        "available=true identity=%s token=%s jobId=%s task=%s helper=%s farm=%s direct=%s position=%s fields={%s}",
        tostring(jobProbe.identity), tostring(jobProbe.token), tostring(jobProbe.jobId), tostring(jobProbe.currentTaskIndex),
        tostring(jobProbe.helperIndex), tostring(jobProbe.farmId), tostring(jobProbe.isDirectStart),
        jobProbe.position and string.format("(%.3f,%.3f):%s", jobProbe.position.x, jobProbe.position.z, tostring(jobProbe.position.source)) or "nil",
        table.concat(fields, ",")
    )
end

local function signature(record)
    return table.concat({
        record.referenceKey, tostring(record.jobToken), tostring(record.active), tostring(record.blocked),
        tostring(record.field and record.field.fieldId), tostring(record.field and record.field.resolved),
        tostring(record.jobProbe and record.jobProbe.currentTaskIndex), tostring(record.jobProbe and record.jobProbe.position and record.jobProbe.position.x),
        tostring(record.jobProbe and record.jobProbe.position and record.jobProbe.position.z)
    }, "|")
end

function Probe.new()
    return setmetatable({last = {}, samples = 0, records = {}, lastHeartbeatMs = -math.huge}, Probe)
end

function Probe:reset()
    self.last = {}; self.samples = 0; self.records = {}; self.lastHeartbeatMs = -math.huge
end

function Probe:capture(mission, nowSeconds)
    local result = {timestamp = nowSeconds, records = {}}
    local activeVehicles = OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(mission)
    for _, vehicle in OuttaMyWay.ValueRecord.ipairs(activeVehicles) do
        local job, jobSource = OuttaMyWay.LiveAIJobEvidence.currentJob(vehicle)
        local pose = nil
        local ok, node = safeCall(vehicle, "getAISteeringNode")
        node = ok and node or vehicle.rootNode
        if node ~= nil and node ~= 0 and type(getWorldTranslation) == "function" then
            local positionOk, x, y, z = pcall(getWorldTranslation, node)
            if positionOk then pose = {x = x, y = y, z = z} end
        end
        local field = OuttaMyWay.LiveAIJobEvidence.resolveField(mission, pose, job)
        local record = {
            referenceKey = referenceKey(vehicle), name = vehicleName(vehicle), vehicle = vehicle,
            job = job, jobSource = jobSource, jobToken = OuttaMyWay.LiveAIJobEvidence.jobToken(job),
            jobProbe = OuttaMyWay.LiveAIJobEvidence.jobProbe(job), field = field,
            active = boolMethod(vehicle, "getIsAIActive"), fieldWorkActive = boolMethod(vehicle, "getIsFieldWorkActive"),
            blocked = vehicle.spec_aiFieldWorker and vehicle.spec_aiFieldWorker.isBlocked == true or false
        }
        result.records[#result.records + 1] = record
    end
    table.sort(result.records, function(a, b) return a.referenceKey < b.referenceKey end)
    return result
end

function Probe:update(mission, nowSeconds, nowMs)
    local captured = self:capture(mission, nowSeconds)
    self.samples = self.samples + 1
    local due = (nowMs or 0) - self.lastHeartbeatMs >= (OuttaMyWay.FIELD_IDENTITY_PROBE_HEARTBEAT_INTERVAL_MS or 10000)
    local emitted = false
    for _, record in OuttaMyWay.ValueRecord.ipairs(captured.records) do
        local current = signature(record)
        if self.last[record.referenceKey] ~= current or due then
            self.last[record.referenceKey] = current
            emitted = true
            logInfo(string.format(
                "VEHICLE ref=%s name=%s aiActive=%s fieldWorkActive=%s blocked=%s jobSource=%s jobToken=%s %s control=false",
                record.referenceKey, record.name, record.active, record.fieldWorkActive, tostring(record.blocked),
                tostring(record.jobSource), tostring(record.jobToken), fieldResultText(record.field)
            ))
            logInfo(string.format("JOB ref=%s %s control=false", record.referenceKey, jobText(record.jobProbe)))
        end
        self.records[#self.records + 1] = record
    end
    if due and not emitted then
        logInfo(string.format("HEARTBEAT activeJobVehicles=%d control=false", #captured.records))
    end
    if due then self.lastHeartbeatMs = nowMs or 0 end
    return captured
end

function Probe:getSampleCount() return self.samples end
function Probe:getRecords() local copy = {}; for i, value in OuttaMyWay.ValueRecord.ipairs(self.records) do copy[i] = value end; return copy end
