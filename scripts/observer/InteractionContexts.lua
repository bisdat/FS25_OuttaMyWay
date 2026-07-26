-- FS25_OuttaMyWay v4.2.3.0
-- Diagnostic-only consumer that preserves long-lived interaction contexts.
-- Contexts become ACTIVE when candidate pairs are promoted and DORMANT when
-- movement evidence fades. They never control vehicles.
OuttaMyWay.InteractionContexts = OuttaMyWay.InteractionContexts or {}
local Contexts = OuttaMyWay.InteractionContexts

local function distance(a, b)
    if a.x == nil or a.z == nil or b.x == nil or b.z == nil then return math.huge end
    local dx, dz = b.x-a.x, b.z-a.z
    return math.sqrt(dx*dx + dz*dz)
end

local function velocity(state)
    local speedMps = (state.actualSpeed or 0) / 3.6
    local heading = math.rad(state.heading or 0)
    return math.sin(heading)*speedMps, math.cos(heading)*speedMps
end

local function closingRate(a, b)
    if a.x == nil or a.z == nil or b.x == nil or b.z == nil then return nil end
    local rx, rz = b.x-a.x, b.z-a.z
    local d = math.sqrt(rx*rx + rz*rz)
    if d < 0.01 then return 0 end
    local avx, avz = velocity(a)
    local bvx, bvz = velocity(b)
    local rvx, rvz = bvx-avx, bvz-avz
    return -((rx*rvx + rz*rvz) / d)
end

local function pairKey(a, b)
    local av = tostring(a.vehicle)
    local bv = tostring(b.vehicle)
    if av < bv then return av .. "|" .. bv end
    return bv .. "|" .. av
end

local function memberKey(members)
    local keys = {}
    for _, state in ipairs(members) do keys[#keys+1] = tostring(state.vehicle) end
    table.sort(keys)
    return table.concat(keys, "|")
end

local function namesOf(members)
    local names = {}
    for _, state in ipairs(members) do names[#names+1] = state.name or "AI vehicle" end
    table.sort(names)
    return table.concat(names, ", ")
end

local function pairNames(a, b)
    return namesOf({a,b})
end

local function stateTime(a, b)
    return math.max(a.timestamp or 0, b.timestamp or 0)
end

local function isFieldAt(x, z)
    local mission = g_currentMission
    if mission == nil then return nil end
    local systems = {mission.fieldGroundSystem, mission.fieldManager, g_fieldManager}
    for _, system in ipairs(systems) do
        if system ~= nil then
            for _, methodName in ipairs({"getIsFieldAtWorldPosition", "getIsOnField", "isFieldAtWorldPosition"}) do
                local method = system[methodName]
                if type(method) == "function" then
                    local ok, value = pcall(method, system, x, z)
                    if ok and type(value) == "boolean" then return value end
                end
            end
        end
    end
    return nil
end

function Contexts:sampleLineContinuity(a, b)
    local samples = OuttaMyWay.INTERACTION_CONTINUITY_SAMPLES or 12
    local known, onField = 0, 0
    for i=0,samples do
        local t = i / samples
        local x = a.x + (b.x-a.x)*t
        local z = a.z + (b.z-a.z)*t
        local value = isFieldAt(x,z)
        if value ~= nil then
            known = known + 1
            if value then onField = onField + 1 end
        end
    end
    if known < math.max(3, math.floor((samples+1)*0.5)) then return "UNKNOWN", nil end
    local ratio = onField / known
    if ratio >= (OuttaMyWay.INTERACTION_CONTINUITY_PASS_RATIO or 0.85) then return "PASS", ratio end
    if ratio <= (OuttaMyWay.INTERACTION_CONTINUITY_FAIL_RATIO or 0.50) then return "FAIL", ratio end
    return "UNKNOWN", ratio
end

function Contexts:init()
    self.contexts = {}
    self.contextIdByKey = {}
    self.candidates = {}
    self.lastHeartbeat = 0
    self.nextId = 1
    self.lastStates = {}
    if OuttaMyWay.EventBus ~= nil then
        OuttaMyWay.EventBus:subscribe("workerObserved", function(payload)
            if payload ~= nil and payload.vehicle ~= nil then self.lastStates[payload.vehicle] = payload end
        end, self)
        OuttaMyWay.EventBus:subscribe("workerDetached", function(payload)
            local previous = payload ~= nil and payload.previous or nil
            if previous ~= nil and previous.vehicle ~= nil then self.lastStates[previous.vehicle] = nil end
        end, self)
    end
    print("Info: [FS25_OuttaMyWay] INTERACTION CONTEXTS ACTIVE: persistent diagnostic contexts, no vehicle control")
end

function Contexts:getActiveStates()
    local list = {}
    for vehicle,state in pairs(self.lastStates) do
        if vehicle ~= nil and state ~= nil and state.active == true and state.x ~= nil and state.z ~= nil then
            list[#list+1] = state
        end
    end
    return list
end

function Contexts:isCandidatePair(a, b)
    return distance(a,b) <= (OuttaMyWay.INTERACTION_CANDIDATE_RADIUS or 180.0)
end

function Contexts:isPromotionEvidence(a, b, d, closing, continuity)
    if d <= (OuttaMyWay.INTERACTION_GROUP_ALWAYS_LINK_RADIUS or 45.0) then return true, "close-range" end
    if d > (OuttaMyWay.INTERACTION_GROUP_RADIUS or 120.0) then return false, "outside-group-radius" end
    if closing ~= nil and closing >= (OuttaMyWay.INTERACTION_GROUP_PROMOTE_CLOSING_RATE or 0.10) then return true, "converging" end
    local slow = OuttaMyWay.INTERACTION_GROUP_SLOW_SPEED_KMH or 1.0
    local eitherSlow = (a.actualSpeed or 0) <= slow or (b.actualSpeed or 0) <= slow
    if continuity == "PASS" and eitherSlow and (closing == nil or closing >= -0.25) then
        return true, "same-area-slow-worker"
    end
    return false, "insufficient-motion-evidence"
end

function Contexts:updateCandidates(states)
    local seen, promotedEdges = {}, {}
    local now = 0
    for i=1,#states-1 do
        for j=i+1,#states do
            local a,b = states[i],states[j]
            now = math.max(now, stateTime(a,b))
            if self:isCandidatePair(a,b) then
                local key = pairKey(a,b)
                seen[key] = true
                local d = distance(a,b)
                local closing = closingRate(a,b)
                local candidate = self.candidates[key]
                if candidate == nil then
                    local continuity, ratio = self:sampleLineContinuity(a,b)
                    candidate = {key=key,a=a,b=b,firstSeen=stateTime(a,b),lastSeen=stateTime(a,b),continuity=continuity,continuityRatio=ratio,promoted=false}
                    self.candidates[key] = candidate
                    print(string.format("Info: [FS25_OuttaMyWay] INTERACTION CANDIDATE CREATE t=%.1fs members=%s distance=%.1fm closing=%s continuity=%s ratio=%s",
                        candidate.firstSeen,pairNames(a,b),d,closing ~= nil and string.format("%.2fm/s",closing) or "unknown",continuity,ratio ~= nil and string.format("%.2f",ratio) or "unknown"))
                    if OuttaMyWay.EventBus ~= nil then OuttaMyWay.EventBus:emit("interactionCandidateCreated",candidate) end
                end
                candidate.a,candidate.b = a,b
                candidate.lastSeen,candidate.distance,candidate.closing = stateTime(a,b),d,closing
                local promote,reason = self:isPromotionEvidence(a,b,d,closing,candidate.continuity)
                if promote then
                    candidate.lastPromotionEvidenceAt = candidate.lastSeen
                    if not candidate.promoted then
                        candidate.promoted = true
                        candidate.promotedAt = candidate.lastSeen
                        candidate.promoteReason = reason
                        print(string.format("Info: [FS25_OuttaMyWay] INTERACTION CANDIDATE PROMOTE t=%.1fs members=%s distance=%.1fm closing=%s reason=%s continuity=%s",
                            candidate.lastSeen,pairNames(a,b),d,closing ~= nil and string.format("%.2fm/s",closing) or "unknown",reason,candidate.continuity))
                        if OuttaMyWay.EventBus ~= nil then OuttaMyWay.EventBus:emit("interactionCandidatePromoted",candidate) end
                    end
                    promotedEdges[key] = candidate
                elseif candidate.promoted then
                    local grace = OuttaMyWay.INTERACTION_GROUP_DISSOLVE_GRACE_S or 8.0
                    if candidate.lastPromotionEvidenceAt ~= nil and candidate.lastSeen-candidate.lastPromotionEvidenceAt <= grace then
                        promotedEdges[key] = candidate
                    else
                        candidate.promoted = false
                    end
                end
            end
        end
    end

    local dropGrace = OuttaMyWay.INTERACTION_CANDIDATE_DROP_GRACE_S or 10.0
    for key,candidate in pairs(self.candidates) do
        if not seen[key] and now-(candidate.lastSeen or now) > dropGrace then
            print(string.format("Info: [FS25_OuttaMyWay] INTERACTION CANDIDATE DROP t=%.1fs members=%s lastDistance=%s continuity=%s",
                now,pairNames(candidate.a,candidate.b),candidate.distance ~= nil and string.format("%.1fm",candidate.distance) or "unknown",candidate.continuity or "UNKNOWN"))
            if OuttaMyWay.EventBus ~= nil then OuttaMyWay.EventBus:emit("interactionCandidateDropped",candidate) end
            self.candidates[key] = nil
        elseif candidate.promoted then
            promotedEdges[key] = candidate
        end
    end
    return promotedEdges,now
end

function Contexts:buildComponents(states, promotedEdges)
    local indexByVehicle,adjacency = {},{}
    for i,state in ipairs(states) do indexByVehicle[state.vehicle]=i; adjacency[i]={} end
    for _,candidate in pairs(promotedEdges) do
        local ai=indexByVehicle[candidate.a.vehicle]
        local bi=indexByVehicle[candidate.b.vehicle]
        if ai ~= nil and bi ~= nil then adjacency[ai][bi]=true; adjacency[bi][ai]=true end
    end
    local components,visited = {},{}
    for i=1,#states do
        if not visited[i] then
            local queue,members={i},{}
            visited[i]=true
            while #queue>0 do
                local current=table.remove(queue,1)
                members[#members+1]=states[current]
                for neighbour,_ in pairs(adjacency[current]) do
                    if not visited[neighbour] then visited[neighbour]=true; queue[#queue+1]=neighbour end
                end
            end
            if #members>=2 then components[#components+1]=members end
        end
    end
    return components
end

function Contexts:getOrCreateContext(key,members,now)
    local id = self.contextIdByKey[key]
    local context = id ~= nil and self.contexts[id] or nil
    if context == nil then
        id = self.nextId
        self.nextId = self.nextId + 1
        context = {id=id,key=key,members=members,status="DORMANT",firstSeen=now,lastSeen=now,lastActive=nil,activeSince=nil,cumulativeActive=0,encounterCount=0}
        self.contexts[id]=context
        self.contextIdByKey[key]=id
        print(string.format("Info: [FS25_OuttaMyWay] INTERACTION CONTEXT CREATE t=%.1fs id=%d members=%s",now,id,namesOf(members)))
        if OuttaMyWay.EventBus ~= nil then OuttaMyWay.EventBus:emit("interactionContextCreated",context) end
    end
    context.members=members
    context.lastSeen=now
    return context
end

function Contexts:activateContext(context,now)
    if context.status ~= "ACTIVE" then
        context.status="ACTIVE"
        context.activeSince=now
        context.lastActive=now
        context.encounterCount=(context.encounterCount or 0)+1
        print(string.format("Info: [FS25_OuttaMyWay] INTERACTION CONTEXT ACTIVE t=%.1fs id=%d encounter=%d members=%s",
            now,context.id,context.encounterCount,namesOf(context.members)))
        if OuttaMyWay.EventBus ~= nil then OuttaMyWay.EventBus:emit("interactionContextActivated",context) end
    else
        context.lastActive=now
    end
end

function Contexts:dormantContext(context,now)
    if context.status == "ACTIVE" then
        local activeFor = math.max(0,now-(context.activeSince or now))
        context.cumulativeActive=(context.cumulativeActive or 0)+activeFor
        context.activeSince=nil
        context.lastActive=now
        context.status="DORMANT"
        print(string.format("Info: [FS25_OuttaMyWay] INTERACTION CONTEXT DORMANT t=%.1fs id=%d activeFor=%.1fs cumulative=%.1fs encounters=%d members=%s",
            now,context.id,activeFor,context.cumulativeActive,context.encounterCount or 0,namesOf(context.members)))
        if OuttaMyWay.EventBus ~= nil then OuttaMyWay.EventBus:emit("interactionContextDormant",context) end
    end
end

function Contexts:update(dt)
    if self.contexts == nil then self:init() end
    self.elapsed=(self.elapsed or 0)+dt
    local interval=OuttaMyWay.INTERACTION_CONTEXT_INTERVAL_MS or OuttaMyWay.INTERACTION_GROUP_INTERVAL_MS or 500
    if self.elapsed<interval then return end
    self.elapsed=self.elapsed%interval

    local states=self:getActiveStates()
    local promotedEdges,now=self:updateCandidates(states)
    local components=self:buildComponents(states,promotedEdges)
    local activeContextIds={}

    for _,members in ipairs(components) do
        local key=memberKey(members)
        local context=self:getOrCreateContext(key,members,now)
        activeContextIds[context.id]=true
        self:activateContext(context,now)
    end

    for id,context in pairs(self.contexts) do
        if not activeContextIds[id] then self:dormantContext(context,now) end
    end

    local retention=OuttaMyWay.INTERACTION_CONTEXT_RETENTION_S or 60.0
    for id,context in pairs(self.contexts) do
        local reference=context.lastSeen or context.lastActive or context.firstSeen or now
        if context.status=="DORMANT" and now-reference>retention then
            print(string.format("Info: [FS25_OuttaMyWay] INTERACTION CONTEXT RETIRE t=%.1fs id=%d lifetime=%.1fs cumulative=%.1fs encounters=%d members=%s",
                now,id,now-(context.firstSeen or now),context.cumulativeActive or 0,context.encounterCount or 0,namesOf(context.members)))
            if OuttaMyWay.EventBus ~= nil then OuttaMyWay.EventBus:emit("interactionContextRetired",context) end
            self.contextIdByKey[context.key]=nil
            self.contexts[id]=nil
        end
    end

    local heartbeatMs=OuttaMyWay.INTERACTION_CONTEXT_HEARTBEAT_MS or OuttaMyWay.INTERACTION_GROUP_HEARTBEAT_MS or 15000
    if (g_time or 0)-(self.lastHeartbeat or 0)>=heartbeatMs then
        self.lastHeartbeat=g_time or 0
        local active,dormant,candidates,promoted=0,0,0,0
        for _,context in pairs(self.contexts) do if context.status=="ACTIVE" then active=active+1 else dormant=dormant+1 end end
        for _,candidate in pairs(self.candidates) do candidates=candidates+1; if candidate.promoted then promoted=promoted+1 end end
        print(string.format("Info: [FS25_OuttaMyWay] INTERACTION CONTEXT HEARTBEAT t=%.1fs observedWorkers=%d candidates=%d promotedPairs=%d activeContexts=%d dormantContexts=%d totalContexts=%d",
            now,#states,candidates,promoted,active,dormant,active+dormant))
    end
end
