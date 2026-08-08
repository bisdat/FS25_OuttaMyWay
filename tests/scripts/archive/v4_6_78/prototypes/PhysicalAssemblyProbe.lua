-- FS25_OuttaMyWay v4.6.15
-- Prototype 12: passive Physical Assembly Discovery.
-- Discovers the operational worker and its currently attached vehicle/implement
-- objects as separate runtime members. It does not infer collision membership,
-- physical extents, occupancy, containment, projected sweep, or control.

OuttaMyWay.PhysicalAssemblyProbe = OuttaMyWay.PhysicalAssemblyProbe or {}
local Probe = OuttaMyWay.PhysicalAssemblyProbe

local function isDeleted(object)
    return object == nil or object.isDeleted == true or object.rootNode == nil or object.rootNode == 0
end

local function safeName(object)
    if object ~= nil and type(object.getName) == "function" then
        local ok, value = pcall(object.getName, object)
        if ok and value ~= nil and value ~= "" then return tostring(value) end
    end
    return tostring(object and (object.name or object.typeName) or "unknown")
end

local function assetName(object)
    return tostring(object and (object.configFileName or object.configFileNameClean or object.xmlFilename) or "")
end

local function activeFieldWorker(object)
    if isDeleted(object) then return false end
    local spec = object.spec_aiFieldWorker
    if spec ~= nil and spec.isActive == true then return true end
    if type(object.getIsFieldWorkActive) == "function" then
        local ok, value = pcall(object.getIsFieldWorkActive, object)
        if ok and value == true then return true end
    end
    if type(object.getIsAIActive) == "function" then
        local ok, value = pcall(object.getIsAIActive, object)
        if ok and value == true and spec ~= nil then return true end
    end
    return false
end

local function rootVehicle(object)
    if object ~= nil and type(object.getRootVehicle) == "function" then
        local ok, value = pcall(object.getRootVehicle, object)
        if ok and value ~= nil and value.isDeleted ~= true then return value end
    end
    return object
end

local function countEntries(value)
    if type(value) ~= "table" then return 0 end
    local count = 0
    for _ in pairs(value) do count = count + 1 end
    return count
end

local function asObject(value)
    if type(value) ~= "table" then return nil end
    if value.rootNode ~= nil then return value end
    for _, key in ipairs({"object", "vehicle", "implement", "attachedVehicle", "child", "attacherVehicle"}) do
        local candidate = value[key]
        if type(candidate) == "table" and candidate.rootNode ~= nil then return candidate end
    end
    local indexed = value[1]
    if type(indexed) == "table" and indexed.rootNode ~= nil then return indexed end
    return nil
end

local function addChild(children, seen, candidate, source, relation)
    local object = asObject(candidate)
    if object == nil or isDeleted(object) or seen[object] then return end
    seen[object] = true
    children[#children + 1] = {
        object = object,
        source = source,
        relation = relation or "attached"
    }
end

local function collectChildren(object)
    local children, seen = {}, {}

    for _, methodName in ipairs({"getAttachedImplements", "getAttachedVehicles", "getChildVehicles"}) do
        local fn = object and object[methodName] or nil
        if type(fn) == "function" then
            local ok, values = pcall(fn, object)
            if ok and type(values) == "table" then
                for key, value in pairs(values) do
                    addChild(children, seen, value, methodName, tostring(key))
                end
            end
        end
    end

    local spec = object and object.spec_attacherJoints or nil
    if type(spec) == "table" and type(spec.attachedImplements) == "table" then
        for key, value in pairs(spec.attachedImplements) do
            addChild(children, seen, value, "spec_attacherJoints.attachedImplements", tostring(key))
        end
    end

    return children
end

local function componentNode(component)
    if type(component) == "number" and component ~= 0 then return component end
    if type(component) ~= "table" then return nil end
    for _, key in ipairs({"node", "nodeId", "rootNode", "componentNode"}) do
        local node = component[key]
        if type(node) == "number" and node ~= 0 then return node end
    end
    return nil
end

local function hierarchySummary(rootNode, budget)
    if rootNode == nil or rootNode == 0 or type(getNumOfChildren) ~= "function" or type(getChildAt) ~= "function" then
        return {available=false, nodes=0, named=0, maxDepth=0, truncated=false}
    end
    local queue = {{node=rootNode, depth=0}}
    local head, nodes, named, maxDepth = 1, 0, 0, 0
    while head <= #queue and nodes < budget do
        local current = queue[head]
        head = head + 1
        nodes = nodes + 1
        if current.depth > maxDepth then maxDepth = current.depth end
        if type(getName) == "function" then
            local okName, name = pcall(getName, current.node)
            if okName and name ~= nil and tostring(name) ~= "" then named = named + 1 end
        end
        local okCount, count = pcall(getNumOfChildren, current.node)
        if okCount and type(count) == "number" then
            for index = 0, count - 1 do
                local okChild, child = pcall(getChildAt, current.node, index)
                if okChild and child ~= nil and child ~= 0 then
                    queue[#queue + 1] = {node=child, depth=current.depth + 1}
                end
            end
        end
    end
    return {
        available=true,
        nodes=nodes,
        named=named,
        maxDepth=maxDepth,
        truncated=head <= #queue
    }
end

local function foldAnimTime(object)
    local spec = object and object.spec_foldable or nil
    local value = spec and tonumber(spec.foldAnimTime) or nil
    if value == nil and object ~= nil and type(object.getFoldAnimTime) == "function" then
        local ok, result = pcall(object.getFoldAnimTime, object)
        if ok then value = tonumber(result) end
    end
    return value
end

local function foldState(value)
    if value == nil then return "NOT_FOLDABLE_OR_UNKNOWN" end
    if value <= 0.02 then return "DEPLOYED" end
    if value >= 0.98 then return "FOLDED" end
    return "TRANSITION"
end

local function objectPosition(object)
    if isDeleted(object) or type(getWorldTranslation) ~= "function" then return nil, nil, nil end
    local ok, x, y, z = pcall(getWorldTranslation, object.rootNode)
    if not ok then return nil, nil, nil end
    return x, y, z
end

local function speedKmh(object)
    return math.abs(tonumber(object and object.lastSpeedReal) or 0) * 3600
end

local function memberSignature(member)
    return table.concat({
        tostring(member.object),
        assetName(member.object),
        tostring(member.object.rootNode),
        tostring(member.parent and member.parent.object or "root")
    }, "|")
end

local function assemblySignature(members)
    local values = {}
    for _, member in ipairs(members) do values[#values + 1] = memberSignature(member) end
    table.sort(values)
    return table.concat(values, ";")
end

local function discoverAssembly(worker, budget)
    local members, edges, queue = {}, {}, {}
    local seen = {}

    local function add(object, parent, source, relation, depth)
        if isDeleted(object) or seen[object] or #members >= budget then return nil end
        seen[object] = true
        local member = {
            object=object,
            parent=parent,
            discoverySource=source or "operational-worker",
            relation=relation or "root",
            depth=depth or 0
        }
        members[#members + 1] = member
        queue[#queue + 1] = member
        if parent ~= nil then
            edges[#edges + 1] = {parent=parent, child=member, source=source, relation=relation}
        end
        return member
    end

    add(worker, nil, "operational-worker", "root", 0)
    local head = 1
    while head <= #queue and #members < budget do
        local parent = queue[head]
        head = head + 1
        for _, child in ipairs(collectChildren(parent.object)) do
            add(child.object, parent, child.source, child.relation, parent.depth + 1)
        end
    end

    return members, edges, #members >= budget and head <= #queue
end

local function enumerateActiveWorkers()
    local result, seen = {}, {}
    local missionVehicles = g_currentMission and g_currentMission.vehicles or nil
    local systemVehicles = g_currentMission and g_currentMission.vehicleSystem and g_currentMission.vehicleSystem.vehicles or nil
    local stats = {
        missionVehicles=countEntries(missionVehicles),
        vehicleSystemVehicles=countEntries(systemVehicles),
        activeCandidates=0,
        uniqueWorkers=0
    }

    local function inspect(source, sourceName)
        if type(source) ~= "table" then return end
        for _, candidate in pairs(source) do
            if activeFieldWorker(candidate) then
                stats.activeCandidates = stats.activeCandidates + 1
                local worker = rootVehicle(candidate)
                if not isDeleted(worker) and not seen[worker] then
                    seen[worker] = true
                    stats.uniqueWorkers = stats.uniqueWorkers + 1
                    result[#result + 1] = {worker=worker, source=sourceName}
                end
            end
        end
    end

    inspect(missionVehicles, "mission.vehicles")
    inspect(systemVehicles, "mission.vehicleSystem.vehicles")
    return result, stats
end

local function fmt(value)
    return value == nil and "unknown" or string.format("%.3f", value)
end

function Probe:init()
    self.enabled = OuttaMyWay.PROTOTYPE_12_ENABLED == true
    self.elapsedMs = 0
    self.startedAtMs = g_time or 0
    self.states = {}
    if self.enabled then
        OuttaMyWay.Logger:info("PROTOTYPE12 ACTIVE: Physical Assembly Discovery; operational worker separated from attached physical members; passive; no collision inference, occupancy or control")
    else
        OuttaMyWay.Logger:info("PROTOTYPE12 DISABLED")
    end
end

function Probe:describeMember(state, member, index, nowSeconds)
    local object = member.object
    local components = type(object.components) == "table" and #object.components or 0
    local componentRoots = 0
    if type(object.components) == "table" then
        for _, component in pairs(object.components) do
            if componentNode(component) ~= nil then componentRoots = componentRoots + 1 end
        end
    end
    local mappings = math.max(countEntries(object.i3dMappings), countEntries(object.i3dMapping))
    local hierarchy = hierarchySummary(object.rootNode, OuttaMyWay.PROTOTYPE_12_NODE_SCAN_BUDGET or 3000)
    local rootOwner = rootVehicle(object)
    local rootOwnerIsWorker = rootOwner == state.worker
    local foldTime = foldAnimTime(object)

    OuttaMyWay.Logger:obs(
        "PROTOTYPE12 ASSEMBLY_MEMBER t=%.1fs worker=%s memberIndex=%d member=%s asset=%s runtimeObject=%s runtimeRootNode=%s parentIndex=%s depth=%d discoverySource=%s relation=%s components=%d componentRoots=%d mappings=%d hierarchyAvailable=%s hierarchyNodes=%d hierarchyNamed=%d hierarchyMaxDepth=%d hierarchyTruncated=%s rootVehicleIsOperationalWorker=%s foldState=%s foldAnimTime=%s physicalMembership=not-inferred collisionNodes=not-resolved action=none",
        nowSeconds, state.name, index, safeName(object), assetName(object), tostring(object), tostring(object.rootNode),
        member.parent and tostring(member.parent.index) or "none", member.depth or 0, tostring(member.discoverySource), tostring(member.relation),
        components, componentRoots, mappings, tostring(hierarchy.available), hierarchy.nodes, hierarchy.named, hierarchy.maxDepth,
        tostring(hierarchy.truncated), tostring(rootOwnerIsWorker), foldState(foldTime), fmt(foldTime))
end

function Probe:attach(workerRecord, nowSeconds)
    local worker = workerRecord.worker
    local members, edges, truncated = discoverAssembly(worker, OuttaMyWay.PROTOTYPE_12_MEMBER_BUDGET or 16)
    for index, member in ipairs(members) do member.index = index end
    local x, _, z = objectPosition(worker)
    local state = {
        worker=worker,
        name=safeName(worker),
        source=workerRecord.source,
        members=members,
        edges=edges,
        signature=assemblySignature(members),
        startedX=x,
        startedZ=z,
        lastX=x,
        lastZ=z,
        maxDisplacement=0,
        previousSpeed=nil,
        lastDetailedMs=0
    }
    self.states[tostring(worker)] = state

    OuttaMyWay.Logger:obs(
        "PROTOTYPE12 OPERATIONAL_WORKER t=%.1fs worker=%s asset=%s source=%s runtimeObject=%s runtimeRootNode=%s assemblySearchBoundary=worker-plus-attached-members action=none",
        nowSeconds, state.name, assetName(worker), state.source, tostring(worker), tostring(worker.rootNode))

    for _, edge in ipairs(edges) do
        OuttaMyWay.Logger:obs(
            "PROTOTYPE12 ATTACHMENT_EDGE t=%.1fs worker=%s parentIndex=%d parent=%s childIndex=%d child=%s discoverySource=%s relation=%s action=none",
            nowSeconds, state.name, edge.parent.index, safeName(edge.parent.object), edge.child.index, safeName(edge.child.object),
            tostring(edge.source), tostring(edge.relation))
    end
    for index, member in ipairs(members) do self:describeMember(state, member, index, nowSeconds) end

    self:logSummary(state, nowSeconds, "ATTACHED", truncated)
    return state
end

function Probe:logSummary(state, nowSeconds, event, truncated)
    local uniqueRoots, assetKnown, hierarchyAvailable, foldableMembers = {}, 0, 0, 0
    for _, member in ipairs(state.members) do
        uniqueRoots[tostring(member.object.rootNode)] = true
        if assetName(member.object) ~= "" then assetKnown = assetKnown + 1 end
        local hierarchy = hierarchySummary(member.object.rootNode, OuttaMyWay.PROTOTYPE_12_SUMMARY_NODE_SCAN_BUDGET or 1)
        if hierarchy.available then hierarchyAvailable = hierarchyAvailable + 1 end
        if foldAnimTime(member.object) ~= nil then foldableMembers = foldableMembers + 1 end
    end
    local uniqueRootCount = countEntries(uniqueRoots)
    local memberCount = #state.members
    local classification = memberCount > 1 and "ATTACHED_MULTI_MEMBER" or "INTEGRATED_SINGLE_MEMBER"
    local identityComplete = assetKnown == memberCount and uniqueRootCount == memberCount and hierarchyAvailable == memberCount
    local relationCoherent = memberCount == 1 or #state.edges >= memberCount - 1
    local result = identityComplete and relationCoherent and "SUPPORTED_FOR_OBSERVED_ASSEMBLY" or "PARTIAL"

    OuttaMyWay.Logger:val(
        "PROTOTYPE12 ASSEMBLY_SUMMARY t=%.1fs event=%s worker=%s classification=%s members=%d attachmentEdges=%d uniqueRuntimeRoots=%d assetsKnown=%d hierarchyAvailable=%d foldableMembers=%d memberBudgetTruncated=%s identityComplete=%s relationCoherent=%s result=%s collisionMembership=unknown physicalExtent=unknown physicalEnvelope=false action=none",
        nowSeconds, event, state.name, classification, memberCount, #state.edges, uniqueRootCount, assetKnown,
        hierarchyAvailable, foldableMembers, tostring(truncated == true), tostring(identityComplete), tostring(relationCoherent), result)
end

function Probe:refreshState(state, nowSeconds)
    local members, edges, truncated = discoverAssembly(state.worker, OuttaMyWay.PROTOTYPE_12_MEMBER_BUDGET or 16)
    for index, member in ipairs(members) do member.index = index end
    local signature = assemblySignature(members)
    if signature ~= state.signature then
        local oldCount = #state.members
        state.members, state.edges, state.signature = members, edges, signature
        OuttaMyWay.Logger:obs(
            "PROTOTYPE12 ASSEMBLY_CHANGED t=%.1fs worker=%s previousMembers=%d currentMembers=%d attachmentEdges=%d reason=runtime-attachment-graph-changed action=none",
            nowSeconds, state.name, oldCount, #members, #edges)
        for _, edge in ipairs(edges) do
            OuttaMyWay.Logger:obs(
                "PROTOTYPE12 ATTACHMENT_EDGE t=%.1fs worker=%s parentIndex=%d parent=%s childIndex=%d child=%s discoverySource=%s relation=%s action=none",
                nowSeconds, state.name, edge.parent.index, safeName(edge.parent.object), edge.child.index, safeName(edge.child.object),
                tostring(edge.source), tostring(edge.relation))
        end
        for index, member in ipairs(members) do self:describeMember(state, member, index, nowSeconds) end
        self:logSummary(state, nowSeconds, "CHANGED", truncated)
    end
end

function Probe:sampleMotion(state, nowSeconds)
    local x, _, z = objectPosition(state.worker)
    if x == nil then return end
    local displacement = 0
    if state.startedX ~= nil then
        displacement = math.sqrt((x - state.startedX)^2 + (z - state.startedZ)^2)
        if displacement > state.maxDisplacement then state.maxDisplacement = displacement end
    end
    local intervalMove = 0
    if state.lastX ~= nil then intervalMove = math.sqrt((x - state.lastX)^2 + (z - state.lastZ)^2) end
    state.lastX, state.lastZ = x, z
    local speed = speedKmh(state.worker)
    local active = activeFieldWorker(state.worker)

    OuttaMyWay.Logger:rateLimited("p12-motion-" .. tostring(state.worker), OuttaMyWay.PROTOTYPE_12_MOTION_LOG_MS or 2000, "VAL",
        "PROTOTYPE12 WORKER_MOTION_SAMPLE t=%.1fs worker=%s aiFieldWorkerActive=%s speedKmh=%.2f intervalMoveM=%.3f displacementFromAttachM=%.3f maxDisplacementM=%.3f members=%d assemblyControl=false action=none",
        nowSeconds, state.name, tostring(active), speed, intervalMove, displacement, state.maxDisplacement, #state.members)
end

function Probe:update(dt)
    if self.states == nil then self:init() end
    if self.enabled ~= true then return end
    self.elapsedMs = self.elapsedMs + dt
    local interval = OuttaMyWay.PROTOTYPE_12_INTERVAL_MS or 250
    if self.elapsedMs < interval then return end
    self.elapsedMs = self.elapsedMs % interval

    local nowSeconds = ((g_time or 0) - (self.startedAtMs or 0)) / 1000
    local workers, enumeration = enumerateActiveWorkers()
    OuttaMyWay.Logger:rateLimited("p12-enumeration", OuttaMyWay.PROTOTYPE_12_ENUMERATION_LOG_MS or 3000, "OBS",
        "PROTOTYPE12 WORKER_ENUMERATION t=%.1fs missionVehicles=%d vehicleSystemVehicles=%d activeCandidates=%d uniqueOperationalWorkers=%d authoritativeWorkerState=spec_aiFieldWorker.isActive-with-protected-fallbacks action=none",
        nowSeconds, enumeration.missionVehicles, enumeration.vehicleSystemVehicles, enumeration.activeCandidates, enumeration.uniqueWorkers)

    local present = {}
    for _, workerRecord in ipairs(workers) do
        local key = tostring(workerRecord.worker)
        present[key] = true
        local state = self.states[key] or self:attach(workerRecord, nowSeconds)
        self:refreshState(state, nowSeconds)
        self:sampleMotion(state, nowSeconds)
    end

    for key, state in pairs(self.states) do
        if not present[key] then
            OuttaMyWay.Logger:obs(
                "PROTOTYPE12 OPERATIONAL_WORKER_REMOVED t=%.1fs worker=%s members=%d reason=no-longer-active-field-worker assemblyIdentityRetained=false action=none",
                nowSeconds, state.name, #state.members)
            self.states[key] = nil
        end
    end
end

function Probe:clear()
    self.elapsedMs = 0
    self.startedAtMs = g_time or 0
    self.states = {}
end
