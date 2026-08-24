OuttaMyWay.LiveAIJobEvidence = {}
local Evidence = OuttaMyWay.LiveAIJobEvidence

local function safeCall(object, methodName, ...)
    if object == nil or type(object[methodName]) ~= "function" then return false, nil end
    return pcall(object[methodName], object, ...)
end

local function usableVehicle(value)
    return type(value) == "table" and value.rootNode ~= nil and value.rootNode ~= 0 and value.isDeleted ~= true
end

local function rootVehicle(value)
    if not usableVehicle(value) then return nil end
    local ok, root = safeCall(value, "getRootVehicle")
    if ok and usableVehicle(root) then return root end
    return value
end

local function addVehicle(result, seen, value)
    local vehicle = rootVehicle(value)
    if vehicle ~= nil and not seen[vehicle] then
        seen[vehicle] = true
        result[#result + 1] = vehicle
    end
end

local function inspectActiveJobVehicleEntry(result, seen, key, value)
    addVehicle(result, seen, key)
    addVehicle(result, seen, value)
    if type(value) == "table" then
        addVehicle(result, seen, value.object)
        addVehicle(result, seen, value.vehicle)
        addVehicle(result, seen, value.rootVehicle)
        addVehicle(result, seen, value[1])
    end
end

function Evidence.activeJobVehicles(mission)
    local result, seen = {}, {}
    local values = mission and mission.aiSystem and mission.aiSystem.activeJobVehicles
    if type(values) == "table" then
        for key, value in OuttaMyWay.ValueRecord.pairs(values) do inspectActiveJobVehicleEntry(result, seen, key, value) end
    end
    table.sort(result, function(a, b)
        return tostring(a.rootNode or a) < tostring(b.rootNode or b)
    end)
    return result
end

function Evidence.currentJob(vehicle)
    if not usableVehicle(vehicle) then return nil, nil end
    local ok, value = safeCall(vehicle, "getCurrentAIJob")
    if ok and value ~= nil then return value, "vehicle.getCurrentAIJob" end
    local candidates = {
        {name = "spec_aiJobVehicle.job", value = vehicle.spec_aiJobVehicle and vehicle.spec_aiJobVehicle.job},
        {name = "spec_aiFieldWorker.fieldJob", value = vehicle.spec_aiFieldWorker and vehicle.spec_aiFieldWorker.fieldJob},
        {name = "spec_aiJobVehicle.currentAIJob", value = vehicle.spec_aiJobVehicle and vehicle.spec_aiJobVehicle.currentAIJob},
        {name = "spec_aiVehicle.currentAIJob", value = vehicle.spec_aiVehicle and vehicle.spec_aiVehicle.currentAIJob}
    }
    for _, candidate in OuttaMyWay.ValueRecord.ipairs(candidates) do
        if candidate.value ~= nil then return candidate.value, candidate.name end
    end
    return nil, nil
end

function Evidence.lastJob(vehicle)
    if not usableVehicle(vehicle) then return nil, nil end
    local spec = vehicle.spec_aiJobVehicle
    if type(spec) == "table" and spec.lastJob ~= nil then
        return spec.lastJob, "spec_aiJobVehicle.lastJob"
    end
    return nil, nil
end

local function jobEntryMatches(entry, job, token)
    if entry == nil then return false end
    if entry == job then return true end
    if type(entry) == "table" then
        if entry.job == job or entry.aiJob == job or entry.currentJob == job then return true end
        local entryToken = Evidence.jobToken(entry)
        if token ~= nil and entryToken == token then return true end
        for _, value in OuttaMyWay.ValueRecord.pairs(entry) do
            if value == job then return true end
        end
    end
    return false
end

function Evidence.jobActiveInMission(mission, job, token)
    local activeJobs = mission and mission.aiSystem and mission.aiSystem.activeJobs
    if type(activeJobs) ~= "table" then return false, "activeJobs-unavailable" end
    for key, value in OuttaMyWay.ValueRecord.pairs(activeJobs) do
        if jobEntryMatches(key, job, token) or jobEntryMatches(value, job, token) then
            return true, "mission.aiSystem.activeJobs"
        end
    end
    return false, "mission.aiSystem.activeJobs"
end

function Evidence.sourceJobEndEvidence(mission, vehicle, previousToken)
    if not usableVehicle(vehicle) or previousToken == nil then
        return {observed = false, reason = "PREVIOUS_JOB_IDENTITY_UNAVAILABLE"}
    end
    local okCurrent, exposedCurrentJob = safeCall(vehicle, "getCurrentAIJob")
    local activeSlotJob = vehicle.spec_aiJobVehicle and vehicle.spec_aiJobVehicle.job or nil
    local lastJob, lastJobSource = Evidence.lastJob(vehicle)
    local lastToken = Evidence.jobToken(lastJob)
    local activeInMission, activeJobsSource = Evidence.jobActiveInMission(mission, lastJob, previousToken)
    local okAI, aiActive = safeCall(vehicle, "getIsAIActive")
    local okField, fieldActive = safeCall(vehicle, "getIsFieldWorkActive")
    local specActive = vehicle.spec_aiFieldWorker and vehicle.spec_aiFieldWorker.isActive == true or false
    local tokenMatches = lastToken ~= nil and lastToken == previousToken
    local activeSlotAbsent = activeSlotJob == nil and (not okCurrent or exposedCurrentJob == nil)
    local inactive = (not okAI or aiActive ~= true) and (not okField or fieldActive ~= true) and not specActive
    local observed = activeSlotAbsent and tokenMatches and not activeInMission and inactive
    return {
        observed = observed, previousToken = previousToken, lastJobToken = lastToken,
        lastJobSource = lastJobSource, activeJobsSource = activeJobsSource,
        currentJobAbsent = activeSlotAbsent, activeSlotJobToken = Evidence.jobToken(activeSlotJob),
        staleFieldJobToken = Evidence.jobToken(vehicle.spec_aiFieldWorker and vehicle.spec_aiFieldWorker.fieldJob or nil), activeInMission = activeInMission,
        aiActive = okAI and aiActive == true or false,
        fieldWorkActive = okField and fieldActive == true or false,
        specFieldWorkerActive = specActive,
        reason = observed and "PREVIOUS_JOB_RETAINED_AS_LAST_JOB_AND_NO_LONGER_ACTIVE" or "SOURCE_JOB_END_NOT_ESTABLISHED"
    }
end

function Evidence.jobToken(job)
    if job == nil then return nil end
    local id = rawget(job, "jobId")
    if id == nil then
        local ok, value = safeCall(job, "getId")
        if ok then id = value end
    end
    if id ~= nil then return "giants-ai-job-id:" .. tostring(id) end
    return "giants-ai-job-ref:" .. tostring(job)
end

function Evidence.jobPosition(job)
    if type(job) ~= "table" then return nil end
    local parameter = rawget(job, "positionAngleParameter") or rawget(job, "positionParameter")
    if type(parameter) == "table" then
        local ok, x, z = safeCall(parameter, "getPosition")
        if ok and type(x) == "number" and type(z) == "number" then
            return {x = x, z = z, source = "job.positionAngleParameter.getPosition"}
        end
    end
    local ok, x, z = safeCall(job, "getTarget")
    if ok and type(x) == "number" and type(z) == "number" then
        return {x = x, z = z, source = "job.getTarget"}
    end
    return nil
end

local function farmlandIdAt(manager, x, z)
    if manager == nil then return nil, nil end
    local ok, farmland = safeCall(manager, "getFarmlandAtWorldPosition", x, z)
    if ok and farmland ~= nil then
        local id = type(farmland) == "table" and (farmland.id or farmland.farmlandId) or farmland
        if id ~= nil then return tonumber(id), "getFarmlandAtWorldPosition" end
    end
    local methods = {"getFarmlandIdAtWorldPosition", "getFarmlandIdAtPosition"}
    for _, methodName in OuttaMyWay.ValueRecord.ipairs(methods) do
        local called, id = safeCall(manager, methodName, x, z)
        if called and tonumber(id) ~= nil and tonumber(id) ~= 0 then return tonumber(id), methodName end
    end
    return nil, nil
end

local function fieldId(field)
    if field == nil then return nil end
    local ok, id = safeCall(field, "getId")
    if ok and tonumber(id) ~= nil then return tonumber(id) end
    if type(field) == "table" then return tonumber(field.id or field.fieldId) end
    return nil
end

local function polygonPoints(field)
    local ok, points = safeCall(field, "getPolygonPoints")
    if ok and type(points) == "table" then return points, "field.getPolygonPoints" end
    if type(field) == "table" and type(field.fieldDimensions) == "table" then
        return field.fieldDimensions, "field.fieldDimensions"
    end
    return nil, nil
end

local function pointXZ(point)
    if type(point) ~= "table" and type(point) ~= "number" then return nil end
    if type(point) == "table" then
        local x = tonumber(point.x or point.worldX or point.posX or point[1])
        local z = tonumber(point.z or point.worldZ or point.posZ or point[3] or point[2])
        if x ~= nil and z ~= nil then return x, z end
        point = point.node or point.rootNode
    end
    if point ~= nil and point ~= 0 and type(getWorldTranslation) == "function" then
        local ok, x, _, z = pcall(getWorldTranslation, point)
        if ok then return x, z end
    end
    return nil
end

local function containsPoint(field, x, z)
    local points, source = polygonPoints(field)
    if points == nil then return nil, source end
    local vertices = {}
    for _, point in OuttaMyWay.ValueRecord.ipairs(points) do
        local px, pz = pointXZ(point)
        if px ~= nil and pz ~= nil then vertices[#vertices + 1] = {x = px, z = pz} end
    end
    if #vertices < 3 then return nil, source end
    local inside = false
    local j = #vertices
    for i = 1, #vertices do
        local a, b = vertices[i], vertices[j]
        local crosses = ((a.z > z) ~= (b.z > z))
        if crosses then
            local denominator = b.z - a.z
            if math.abs(denominator) > 0.0000001 then
                local crossingX = (b.x - a.x) * (z - a.z) / denominator + a.x
                if x < crossingX then inside = not inside end
            end
        end
        j = i
    end
    return inside, source
end

local function fieldByPolygon(fieldManager, x, z)
    local fields = fieldManager and fieldManager.fields
    if type(fields) ~= "table" then return nil, "FIELD_COLLECTION_UNAVAILABLE", 0 end
    local matches = {}
    for _, field in OuttaMyWay.ValueRecord.pairs(fields) do
        local inside = containsPoint(field, x, z)
        if inside == true then matches[#matches + 1] = field end
    end
    if #matches == 1 then return matches[1], "fieldManager.fields+field.getPolygonPoints", 1 end
    if #matches > 1 then return nil, "MULTIPLE_FIELD_POLYGONS_MATCH", #matches end
    return nil, "NO_FIELD_POLYGON_MATCH", 0
end

function Evidence.fieldAtPosition(mission, x, z)
    if type(x) ~= "number" or type(z) ~= "number" then
        return {fieldId = 0, sourceFieldId = 0, resolved = false, reason = "POSITION_UNAVAILABLE"}
    end
    local fieldManager = mission and mission.fieldManager or nil
    if fieldManager == nil then fieldManager = g_fieldManager end
    local farmlandManager = mission and mission.farmlandManager or nil
    if farmlandManager == nil then farmlandManager = g_farmlandManager end

    -- Farmland is contextual containment only. It may narrow later discovery,
    -- but it never establishes agronomic field identity.
    local farmlandId, farmlandSource = farmlandIdAt(farmlandManager, x, z)
    local contextualMappedFieldId = nil
    if farmlandId ~= nil and fieldManager ~= nil then
        local mapping = fieldManager.farmlandIdFieldMapping
        contextualMappedFieldId = fieldId(type(mapping) == "table" and mapping[farmlandId] or nil)
    end

    local field, polygonSource, matchCount = fieldByPolygon(fieldManager, x, z)
    local id = fieldId(field)
    if id ~= nil and id ~= 0 then
        return {
            fieldId = id, sourceFieldId = id, resolved = true, field = field, x = x, z = z,
            source = polygonSource, polygonMatchCount = matchCount,
            farmlandId = farmlandId, farmlandSource = farmlandSource,
            contextualMappedFieldId = contextualMappedFieldId,
            farmlandCorroborates = contextualMappedFieldId == nil or contextualMappedFieldId == id
        }
    end
    return {
        fieldId = 0, sourceFieldId = 0, resolved = false, x = x, z = z,
        reason = polygonSource or (fieldManager == nil and "FIELD_MANAGER_UNAVAILABLE" or "SOURCE_FIELD_IDENTITY_UNRESOLVED"),
        polygonMatchCount = matchCount or 0, fieldManagerAvailable = fieldManager ~= nil,
        farmlandId = farmlandId, farmlandSource = farmlandSource,
        contextualMappedFieldId = contextualMappedFieldId, farmlandManagerAvailable = farmlandManager ~= nil
    }
end

function Evidence.resolveField(mission, pose, job)
    local current = pose and Evidence.fieldAtPosition(mission, pose.x, pose.z) or {fieldId = 0, sourceFieldId = 0, resolved = false, reason = "CURRENT_POSITION_UNAVAILABLE"}
    local jobPosition = Evidence.jobPosition(job)
    local target = jobPosition and Evidence.fieldAtPosition(mission, jobPosition.x, jobPosition.z) or {fieldId = 0, sourceFieldId = 0, resolved = false, reason = "JOB_POSITION_UNAVAILABLE"}
    if current.resolved and target.resolved and current.sourceFieldId ~= target.sourceFieldId then
        return {
            fieldId = 0, sourceFieldId = 0, resolved = false, conflict = true, current = current, target = target,
            sourceFieldIds = {current.sourceFieldId, target.sourceFieldId},
            derivedFieldWorldRequired = true,
            reason = "SOURCE_FIELD_LABELS_DIFFER_DERIVED_FIELD_WORLD_REQUIRED"
        }
    end
    local selected = current.resolved and current or (target.resolved and target or nil)
    if selected ~= nil then
        return {
            fieldId = selected.sourceFieldId, sourceFieldId = selected.sourceFieldId, resolved = true, current = current, target = target,
            source = selected == current and "CURRENT_POSITION_SOURCE_FIELD_POLYGON" or "JOB_POSITION_SOURCE_FIELD_POLYGON",
            fieldWorldStatus = "PROVISIONAL_SOURCE_FIELD_SCOPE",
            derivedFieldWorldRequired = false
        }
    end
    return {
        fieldId = 0, sourceFieldId = 0, resolved = false, current = current, target = target,
        fieldWorldStatus = "DERIVED_FIELD_WORLD_UNRESOLVED",
        reason = "SOURCE_FIELD_IDENTITY_UNRESOLVED"
    }
end

function Evidence.jobProbe(job)
    if type(job) ~= "table" then return {available = false} end
    local result = {
        available = true,
        identity = tostring(job),
        token = Evidence.jobToken(job),
        jobId = rawget(job, "jobId"),
        currentTaskIndex = rawget(job, "currentTaskIndex"),
        helperIndex = rawget(job, "helperIndex"),
        farmId = rawget(job, "farmId"),
        isDirectStart = rawget(job, "isDirectStart"),
        position = Evidence.jobPosition(job),
        fields = {}
    }
    local names = {}
    for key, value in OuttaMyWay.ValueRecord.pairs(job) do
        if type(key) == "string" and (string.find(string.lower(key), "field", 1, true) or string.find(string.lower(key), "position", 1, true) or string.find(string.lower(key), "task", 1, true) or string.find(string.lower(key), "parameter", 1, true)) then
            names[#names + 1] = key
            result.fields[key] = type(value) == "table" and ("table:" .. tostring(value)) or tostring(value)
        end
    end
    table.sort(names)
    result.fieldNames = names
    return result
end
