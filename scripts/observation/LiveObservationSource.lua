OuttaMyWay.LiveObservationSource = {}
local Source = OuttaMyWay.LiveObservationSource
Source.__index = Source

local function safeCall(object, methodName, ...)
    if object == nil or type(object[methodName]) ~= "function" then return false, nil end
    return pcall(object[methodName], object, ...)
end

local function isDeleted(object)
    return object == nil or object.isDeleted == true or object.rootNode == nil or object.rootNode == 0
end

local function referenceKey(object)
    return "vehicle-root:" .. tostring(object and (object.rootNode or object) or "nil")
end

local function objectName(object)
    local ok, value = safeCall(object, "getName")
    if ok and value ~= nil and value ~= "" then return tostring(value) end
    return tostring(object and (object.name or object.typeName) or "AI vehicle")
end

local function nodeFor(object)
    local ok, node = safeCall(object, "getAISteeringNode")
    if ok and node ~= nil and node ~= 0 then return node, "AI_STEERING_NODE" end
    local rootNode = object and object.rootNode or nil
    if rootNode ~= nil and rootNode ~= 0 then return rootNode, "ROOT_NODE_FALLBACK" end
    return nil, "NO_REFERENCE_NODE"
end

local function positionAndHeading(object)
    local node, nodeSource = nodeFor(object)
    local diagnostic = {node = node, nodeSource = nodeSource, success = false}
    if node == nil or node == 0 then diagnostic.reason = "NO_REFERENCE_NODE"; return nil, diagnostic end
    if type(getWorldTranslation) ~= "function" then diagnostic.reason = "WORLD_TRANSLATION_API_UNAVAILABLE"; return nil, diagnostic end
    if type(localDirectionToWorld) ~= "function" then diagnostic.reason = "WORLD_DIRECTION_API_UNAVAILABLE"; return nil, diagnostic end
    local ok, x, y, z = pcall(getWorldTranslation, node)
    if not ok then diagnostic.reason = "WORLD_TRANSLATION_FAILED"; return nil, diagnostic end
    local okDir, dx, _, dz = pcall(localDirectionToWorld, node, 0, 0, 1)
    if not okDir then diagnostic.reason = "WORLD_DIRECTION_FAILED"; return nil, diagnostic end
    local length = math.sqrt(dx * dx + dz * dz)
    if length <= 0.0001 then diagnostic.reason = "HEADING_VECTOR_DEGENERATE"; return nil, diagnostic end
    diagnostic.success = true
    diagnostic.reason = "POSE_RESOLVED"
    diagnostic.x, diagnostic.y, diagnostic.z = x, y, z
    diagnostic.headingX, diagnostic.headingZ = dx / length, dz / length
    return {node = node, nodeSource = nodeSource, x = x, y = y, z = z, dx = dx / length, dz = dz / length}, diagnostic
end

local function activityCorroboration(object)
    local hasFieldWorker = object ~= nil and object.spec_aiFieldWorker ~= nil
    local fieldActive = hasFieldWorker and object.spec_aiFieldWorker.isActive == true
    local ok, value = safeCall(object, "getIsFieldWorkActive")
    if ok and value == true then fieldActive = true end
    local aiActive = false
    ok, value = safeCall(object, "getIsAIActive")
    if ok and value == true then aiActive = true end
    return fieldActive, aiActive, hasFieldWorker
end

local function blockedState(object)
    return object ~= nil and object.spec_aiFieldWorker ~= nil and object.spec_aiFieldWorker.isBlocked == true
end

local function appendComponent(result, seen, object)
    if isDeleted(object) then return end
    local key = "component-root:" .. tostring(object.rootNode)
    if seen[key] then return end
    seen[key] = true
    result[#result + 1] = key
end

local function componentKeys(root)
    local result, seen = {}, {}
    appendComponent(result, seen, root)
    local queue, index = {root}, 1
    while index <= #queue do
        local object = queue[index]
        index = index + 1
        local candidates = {}
        local ok, attached = safeCall(object, "getAttachedImplements")
        if ok and type(attached) == "table" then
            for _, entry in OuttaMyWay.ValueRecord.pairs(attached) do
                candidates[#candidates + 1] = type(entry) == "table" and (entry.object or entry.implement or entry.vehicle or entry[1]) or nil
            end
        end
        local spec = object.spec_attacherJoints
        if type(spec) == "table" and type(spec.attachedImplements) == "table" then
            for _, entry in OuttaMyWay.ValueRecord.pairs(spec.attachedImplements) do
                candidates[#candidates + 1] = type(entry) == "table" and (entry.object or entry.implement or entry.vehicle or entry[1]) or nil
            end
        end
        for _, child in OuttaMyWay.ValueRecord.ipairs(candidates) do
            if child ~= nil and not isDeleted(child) then
                local key = "component-root:" .. tostring(child.rootNode)
                if not seen[key] then
                    appendComponent(result, seen, child)
                    queue[#queue + 1] = child
                end
            end
        end
    end
    table.sort(result)
    return result
end

local function radiusFor(object)
    local width = tonumber(object and object.sizeWidth)
    local length = tonumber(object and object.sizeLength)
    if width == nil or width <= 0 or length == nil or length <= 0 then return nil, width, length end
    return 0.5 * math.sqrt(width * width + length * length), width, length
end

local function pairPrediction(a, b, horizon)
    return OuttaMyWay.LiveInteractionDiagnostics.predictPair(a, b, horizon)
end

local function copyPose(pose)
    if pose == nil then return nil end
    return {x=pose.x,y=pose.y,z=pose.z,dx=pose.dx,dz=pose.dz,node=pose.node,nodeSource=pose.nodeSource}
end

local function appendDiagnosticContradiction(target, code, details)
    local item = {code=code}
    for key,value in pairs(details or {}) do item[key]=value end
    target[#target+1]=item
end

local function activeVehicleSet(mission)
    local list = OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(mission)
    local set = {}
    for _, object in OuttaMyWay.ValueRecord.ipairs(list) do set[object] = true end
    return list, set
end

local function relevantVehicles(activeList, tracks)
    local result, seen = {}, {}
    for _, object in OuttaMyWay.ValueRecord.ipairs(activeList) do
        if not isDeleted(object) and not seen[object] then seen[object] = true; result[#result + 1] = object end
    end
    for _, track in OuttaMyWay.ValueRecord.pairs(tracks) do
        local object = track.object
        if not isDeleted(object) and not seen[object] then seen[object] = true; result[#result + 1] = object end
    end
    table.sort(result, function(a, b) return referenceKey(a) < referenceKey(b) end)
    return result
end

function Source.new(fieldWorldSnapshots, fieldWorldEquivalenceAuthority)
    return setmetatable({knownWorlds = {}, tracks = {}, nextObservedEpisode = 0, nextFieldWorldCapture = 0, fieldWorldSnapshots = fieldWorldSnapshots, fieldWorldEquivalenceAuthority = fieldWorldEquivalenceAuthority, lastCycleDiagnostics={}}, Source)
end

function Source:reset()
    self.knownWorlds = {}; self.tracks = {}; self.nextObservedEpisode = 0; self.nextFieldWorldCapture = 0; self.lastCycleDiagnostics={}
    if self.fieldWorldEquivalenceAuthority ~= nil then self.fieldWorldEquivalenceAuthority:reset() end
end

function Source:getLastDiagnostics()
    return self.lastCycleDiagnostics or {}
end

function Source:_mintEpisodeToken(reference)
    self.nextObservedEpisode = self.nextObservedEpisode + 1
    return string.format("observed-ai-episode:%s:%06d", reference, self.nextObservedEpisode)
end


function Source:_mintFieldWorldCaptureToken(reference, sourceJobToken)
    self.nextFieldWorldCapture=self.nextFieldWorldCapture+1
    return string.format("field-world-capture:%s:%s:%06d",tostring(reference),tostring(sourceJobToken),self.nextFieldWorldCapture)
end

local function playerFacingLocator(fieldEvidence)
    if fieldEvidence == nil then return nil, "UNAVAILABLE" end
    if fieldEvidence.resolved == true and tonumber(fieldEvidence.sourceFieldId or fieldEvidence.fieldId) ~= nil and tonumber(fieldEvidence.sourceFieldId or fieldEvidence.fieldId) ~= 0 then
        return tonumber(fieldEvidence.sourceFieldId or fieldEvidence.fieldId), "SOURCE_FIELD_POLYGON"
    end
    local current = fieldEvidence.current or {}
    local target = fieldEvidence.target or {}
    local farmlandId = tonumber(current.farmlandId or target.farmlandId)
    if farmlandId ~= nil and farmlandId ~= 0 then return farmlandId, "FARMLAND_LABEL_CORRELATION" end
    return nil, "UNAVAILABLE"
end

local function addToGroup(groups, worker)
    local snapshot=worker.fieldWorldSnapshot
    local resolution=worker.fieldWorldResolution
    local fieldWorldReferenceKey=resolution and resolution.fieldWorldReferenceKey or nil
    local resolved=fieldWorldReferenceKey~=nil
    local groupKey=resolved and fieldWorldReferenceKey or ("field-world:unresolved:"..worker.referenceKey..":"..tostring(worker.sourceJobToken))
    groups[groupKey]=groups[groupKey] or {
        groupKey=groupKey,fieldWorldReferenceKey=fieldWorldReferenceKey,workers={},locators={},snapshots={},membershipEvidenceComplete=resolved
    }
    local group=groups[groupKey]
    group.workers[#group.workers+1]=worker
    if snapshot~=nil then group.snapshots[snapshot.referenceKey]=snapshot end
    if worker.playerFacingFieldId~=nil then group.locators[worker.playerFacingFieldId]=true end
    if worker.unresolvedTermination or not resolved then group.membershipEvidenceComplete=false end
end

function Source:capture(mission, nowSeconds)
    if mission == nil then return {} end
    local horizon = OuttaMyWay.PASSIVE_FUTURE_HORIZON_SECONDS or 10
    local groups, present, removeAfterCapture = {}, {}, {}
    local activeList, activeSet = activeVehicleSet(mission)
    local relevantList = relevantVehicles(activeList, self.tracks)
    local cycleDiagnostics = {
        timestamp=nowSeconds,
        activeJobVehicleCount=#activeList,
        relevantVehicleCount=#relevantList,
        assemblyAcquisition={},
        contradictions={}
    }
    self.lastCycleDiagnostics=cycleDiagnostics
    if self.fieldWorldEquivalenceAuthority ~= nil then self.fieldWorldEquivalenceAuthority:beginObservationCycle() end
    if self.fieldWorldSnapshots ~= nil then self.fieldWorldSnapshots:update(0, mission) end

    for _, object in OuttaMyWay.ValueRecord.ipairs(relevantList) do
        local ref = referenceKey(object)
        present[ref] = true
        local activeObserved = activeSet[object] == true
        local pose, poseDiagnostic = positionAndHeading(object)
        cycleDiagnostics.assemblyAcquisition[#cycleDiagnostics.assemblyAcquisition+1]={
            assemblyReferenceKey=ref,
            name=objectName(object),
            activeJobVehicleMembership=activeObserved,
            poseResolved=pose~=nil,
            node=poseDiagnostic.node,
            nodeSource=poseDiagnostic.nodeSource,
            poseReason=poseDiagnostic.reason,
            x=poseDiagnostic.x,
            y=poseDiagnostic.y,
            z=poseDiagnostic.z,
            headingX=poseDiagnostic.headingX,
            headingZ=poseDiagnostic.headingZ
        }
        if activeObserved and pose == nil then
            appendDiagnosticContradiction(cycleDiagnostics.contradictions,"ACTIVE_JOB_VEHICLE_WITHOUT_POSE",{
                assemblyReferenceKey=ref,
                name=objectName(object),
                reason=poseDiagnostic.reason,
                nodeSource=poseDiagnostic.nodeSource
            })
        end
        local fieldActive, aiActive, hasFieldWorker = activityCorroboration(object)
        local track = self.tracks[ref]
        local job, jobSource = OuttaMyWay.LiveAIJobEvidence.currentJob(object)
        local nativeToken = OuttaMyWay.LiveAIJobEvidence.jobToken(job)
        local field = OuttaMyWay.LiveAIJobEvidence.resolveField(mission, pose, job)

        if activeObserved and pose ~= nil then
            if track == nil then track = {referenceKey = ref, everActive = false, active = false, activationGeneration = 1}; self.tracks[ref] = track end
            local previousToken = track.sourceJobToken
            local replacementObserved = previousToken ~= nil and nativeToken ~= nil and previousToken ~= nativeToken
            local reactivated = track.everActive == true and track.active ~= true
            local sourceToken = nativeToken
            if sourceToken == nil then
                if track.fallbackEpisodeToken == nil or reactivated then track.fallbackEpisodeToken = self:_mintEpisodeToken(ref) end
                sourceToken = track.fallbackEpisodeToken
            end
            if track.fieldWorldCaptureToken==nil or replacementObserved or reactivated then
                track.fieldWorldSnapshot=nil; track.fieldWorldError=nil
                track.playerFacingFieldId=nil; track.playerFacingLocatorSource=nil
                track.fieldWorldCaptureToken=self:_mintFieldWorldCaptureToken(ref,sourceToken)
            end
            local captureToken=track.fieldWorldCaptureToken
            local capturedWorld, worldError = nil, nil
            if self.fieldWorldSnapshots ~= nil then
                self.fieldWorldSnapshots:ensure(object,pose,sourceToken,captureToken)
                self.fieldWorldSnapshots:update(0,mission)
                capturedWorld, worldError = self.fieldWorldSnapshots:get(ref,captureToken)
            end
            if track.fieldWorldSnapshot == nil and capturedWorld ~= nil then track.fieldWorldSnapshot = capturedWorld end
            if track.fieldWorldSnapshot ~= nil and self.fieldWorldEquivalenceAuthority ~= nil then
                track.fieldWorldResolution = self.fieldWorldEquivalenceAuthority:resolve(track.fieldWorldSnapshot)
            end
            local locatorId, locatorSource = playerFacingLocator(field)
            if track.playerFacingFieldId == nil and locatorId ~= nil then
                track.playerFacingFieldId = locatorId; track.playerFacingLocatorSource = locatorSource
            end
            track.fieldWorldError = worldError
            local radius, width, length = radiusFor(object)
            local speedMps = math.abs(tonumber(object.lastSpeedReal) or 0) * 1000
            local motionDiagnostic = OuttaMyWay.LiveInteractionDiagnostics.deriveMotion(track.diagnosticPose,pose,track.diagnosticTimestamp,nowSeconds,speedMps)
            local components = componentKeys(object)
            track.everActive = true; track.active = true; track.object = object; track.pose = pose
            track.diagnosticPose=copyPose(pose); track.diagnosticTimestamp=nowSeconds; track.poseDiagnostic=poseDiagnostic; track.motionDiagnostic=motionDiagnostic
            track.fieldId = field.fieldId or 0; track.fieldResolved = field.resolved == true; track.fieldEvidence = field
            track.name = objectName(object); track.components = components; track.radius = radius; track.width = width; track.length = length
            track.fieldActive = fieldActive; track.aiActive = aiActive; track.hasFieldWorker = hasFieldWorker
            track.nativeJob = job; track.nativeJobSource = jobSource; track.nativeJobToken = nativeToken; track.sourceJobToken = sourceToken
            addToGroup(groups, {
                object = object, referenceKey = ref, name = track.name, pose = pose, poseDiagnostic=poseDiagnostic, motionDiagnostic=motionDiagnostic,
                fieldId = track.fieldId, fieldResolved = track.fieldResolved, fieldEvidence = field,
                fieldActive = fieldActive, aiActive = aiActive, hasFieldWorker = hasFieldWorker, activeObserved = true,
                restartObserved = reactivated and not replacementObserved, replacementObserved = replacementObserved,
                playerPresent = mission.controlledVehicle == object, playerControlled = false, blocked = blockedState(object),
                speedMps = speedMps, radius = radius, width = width, length = length,
                sourceJobToken = sourceToken, nativeJobToken = nativeToken, nativeJobTokenSource = jobSource, components = track.components,
                fieldWorldSnapshot = track.fieldWorldSnapshot, fieldWorldResolution=track.fieldWorldResolution, fieldWorldError = track.fieldWorldError, fieldWorldCaptureToken=track.fieldWorldCaptureToken,
                playerFacingFieldId = track.playerFacingFieldId, playerFacingLocatorSource = track.playerFacingLocatorSource
            })
        elseif track ~= nil and track.everActive == true then
            local playerControlled = mission.controlledVehicle == object
            local termination = OuttaMyWay.LiveAIJobEvidence.sourceIntentTermination(mission, object, track.sourceJobToken)
            local sourceIntentTerminationObserved = termination.observed == true
            if pose ~= nil then
                track.motionDiagnostic=OuttaMyWay.LiveInteractionDiagnostics.deriveMotion(track.diagnosticPose,pose,track.diagnosticTimestamp,nowSeconds,math.abs(tonumber(object.lastSpeedReal) or 0) * 1000)
                track.pose = pose; track.diagnosticPose=copyPose(pose); track.diagnosticTimestamp=nowSeconds; track.poseDiagnostic=poseDiagnostic
            elseif poseDiagnostic~=nil then
                track.poseDiagnostic=poseDiagnostic
            end
            if field.resolved then track.fieldId = field.fieldId; track.fieldResolved = true; track.fieldEvidence = field end
            track.active = false; track.object = object; track.fieldActive = fieldActive; track.aiActive = aiActive
            if track.fieldWorldSnapshot ~= nil and self.fieldWorldEquivalenceAuthority ~= nil then
                track.fieldWorldResolution = self.fieldWorldEquivalenceAuthority:resolve(track.fieldWorldSnapshot)
            end
            addToGroup(groups, {
                object = object, referenceKey = ref, name = track.name or objectName(object), pose = track.pose, poseDiagnostic=track.poseDiagnostic, motionDiagnostic=track.motionDiagnostic,
                fieldId = track.fieldId or 0, fieldResolved = track.fieldResolved == true, fieldEvidence = track.fieldEvidence,
                fieldActive = fieldActive, aiActive = aiActive, hasFieldWorker = hasFieldWorker, activeObserved = false,
                playerControlled = playerControlled, playerTakeoverObserved = playerControlled,
                sourceIntentTerminationObserved = sourceIntentTerminationObserved, terminationEvidence = termination,
                unresolvedTermination = not playerControlled and not sourceIntentTerminationObserved,
                blocked = blockedState(object), speedMps = math.abs(tonumber(object.lastSpeedReal) or 0) * 1000,
                radius = track.radius, width = track.width, length = track.length, sourceJobToken = track.sourceJobToken,
                nativeJobToken = nil, nativeJobTokenSource = nil, components = track.components or componentKeys(object),
                fieldWorldSnapshot = track.fieldWorldSnapshot, fieldWorldResolution=track.fieldWorldResolution, fieldWorldError = track.fieldWorldError, fieldWorldCaptureToken=track.fieldWorldCaptureToken,
                playerFacingFieldId = track.playerFacingFieldId, playerFacingLocatorSource = track.playerFacingLocatorSource
            })
            if playerControlled or sourceIntentTerminationObserved then removeAfterCapture[ref] = true end
        end
    end

    for ref, track in OuttaMyWay.ValueRecord.pairs(self.tracks) do
        if not present[ref] and track.everActive == true then
            track.active = false
            if track.fieldWorldSnapshot ~= nil and self.fieldWorldEquivalenceAuthority ~= nil then
                track.fieldWorldResolution = self.fieldWorldEquivalenceAuthority:resolve(track.fieldWorldSnapshot)
            end
            addToGroup(groups, {
                object = nil, referenceKey = ref, name = track.name or "AI vehicle", pose = track.pose, poseDiagnostic=track.poseDiagnostic, motionDiagnostic=track.motionDiagnostic, fieldId = track.fieldId or 0,
                fieldResolved = track.fieldResolved == true, fieldEvidence = track.fieldEvidence, fieldActive = false, aiActive = false,
                hasFieldWorker = true, activeObserved = false, playerControlled = false, unresolvedTermination = true, objectUnavailable = true,
                blocked = false, speedMps = 0, radius = track.radius, width = track.width, length = track.length,
                sourceJobToken = track.sourceJobToken, components = track.components or {},
                fieldWorldSnapshot = track.fieldWorldSnapshot, fieldWorldResolution=track.fieldWorldResolution, fieldWorldError = track.fieldWorldError, fieldWorldCaptureToken=track.fieldWorldCaptureToken,
                playerFacingFieldId = track.playerFacingFieldId, playerFacingLocatorSource = track.playerFacingLocatorSource
            })
        end
    end

    for key, known in OuttaMyWay.ValueRecord.pairs(self.knownWorlds) do
        if groups[key] == nil then
            groups[key] = {groupKey=key,fieldWorldReferenceKey=key,workers={},locators={},snapshots=known.snapshots or {},membershipEvidenceComplete=true,stale=true}
        end
    end

    local keys = {}
    for key in OuttaMyWay.ValueRecord.pairs(groups) do keys[#keys + 1] = key end
    table.sort(keys)
    local observations = {}

    for _, key in OuttaMyWay.ValueRecord.ipairs(keys) do
        local group = groups[key]
        table.sort(group.workers, function(a, b) return a.referenceKey < b.referenceKey end)
        local resolved=group.fieldWorldReferenceKey~=nil
        local fieldReference=resolved and group.fieldWorldReferenceKey or key
        local snapshotKeys,polygonKeys,fingerprints,snapshotList={},{},{},{}
        local polygonSeen,fingerprintSeen={},{}
        for snapshotReferenceKey,snapshot in OuttaMyWay.ValueRecord.pairs(group.snapshots or {}) do
            snapshotKeys[#snapshotKeys+1]=snapshotReferenceKey
            snapshotList[#snapshotList+1]=snapshot
            if snapshot.fieldPolygonReferenceKey~=nil and not polygonSeen[snapshot.fieldPolygonReferenceKey] then
                polygonSeen[snapshot.fieldPolygonReferenceKey]=true; polygonKeys[#polygonKeys+1]=snapshot.fieldPolygonReferenceKey
            end
            if snapshot.geometryFingerprint~=nil and not fingerprintSeen[snapshot.geometryFingerprint] then
                fingerprintSeen[snapshot.geometryFingerprint]=true; fingerprints[#fingerprints+1]=snapshot.geometryFingerprint
            end
        end
        table.sort(snapshotKeys); table.sort(polygonKeys); table.sort(fingerprints)
        table.sort(snapshotList,function(a,b) return tostring(a.referenceKey)<tostring(b.referenceKey) end)
        local representative=snapshotList[1]
        local polygonReference=#polygonKeys==1 and polygonKeys[1] or nil
        local locatorIds={}
        for id in OuttaMyWay.ValueRecord.pairs(group.locators or {}) do locatorIds[#locatorIds+1]=id end
        table.sort(locatorIds)
        local raw = {
            timestamp = nowSeconds,
            provenance = {source = "LiveObservationSource", mode = "JOB_SEEDED_FIELD_WORLD_EQUIVALENCE_AUTHORITY", geometryFingerprints = fingerprints},
            fieldWorld = {
                referenceKey=fieldReference,fieldPolygonReferenceKey=polygonReference,
                fieldPolygonReferenceKeys=polygonKeys,fieldWorldSnapshotReferenceKeys=snapshotKeys,
                operationMembershipEvidenceComplete=group.membershipEvidenceComplete==true,
                identityStatus=resolved and "FIELD_WORLD_EQUIVALENCE_RESOLVED" or "UNRESOLVED",
                equivalenceOutcome=resolved and "SAME_OR_DIFFERENT_FIELD_WORLD_RESOLVED" or "UNRESOLVED",
                geometryFingerprint=#fingerprints==1 and fingerprints[1] or nil,geometryFingerprints=fingerprints,
                canonicalizationVersion=representative and representative.canonicalizationVersion or nil,
                quantizationMetres=representative and representative.quantizationMetres or nil,
                boundary=representative and representative.boundary or {},islands=representative and representative.islands or {},
                boundaryPointCount=representative and representative.boundaryPointCount or 0,islandCount=representative and representative.islandCount or 0,
                representativeSnapshotReferenceKey=representative and representative.referenceKey or nil,
                representativeGeometryOnly=representative~=nil,
                playerFacingFieldLocators=locatorIds,immutableSnapshots=#snapshotKeys>0
            },
            assemblies = {}, geometry = {currentSpaceEvidence = {}, futureSpaceEvidence = {}, demandEvidence = {}, interactionEvidence = {}},
            motion = {closureEvidence = {}}, aiStates = {}, playerControl = {}, jobEpisodeEvidence = {}, operationMembershipEvidence = {},
            physicalRepresentationEvidence = {}, controlOutcomes = {}, unavailableSources = {},
            diagnostics = {
                sourceCounters={
                    cycleActiveJobVehicleCount=cycleDiagnostics.activeJobVehicleCount,
                    cycleRelevantVehicleCount=cycleDiagnostics.relevantVehicleCount,
                    groupWorkerCount=#group.workers,
                    activeGroupWorkerCount=0,
                    poseResolvedWorkerCount=0,
                    mathematicallyPossiblePairCount=(#group.workers * (#group.workers - 1)) / 2,
                    relevantPairCount=0,
                    eligiblePairCount=0,
                    evaluatedPairCount=0,
                    excludedPairCount=0,
                    qualifyingPairCount=0,
                    interactionEvidenceEmittedCount=0
                },
                assemblyDiagnostics={},
                pairDiagnostics={},
                contradictions={}
            }
        }
        for _, worker in OuttaMyWay.ValueRecord.ipairs(group.workers) do
            raw.assemblies[#raw.assemblies + 1] = {
                referenceKey = worker.referenceKey, componentReferenceKeys = worker.components,
                source = {kind = worker.activeObserved and "LIVE_AI_ACTIVE_JOB_VEHICLE" or "RETAINED_AI_ASSEMBLY", name = worker.name}
            }
            raw.aiStates[worker.referenceKey] = {
                fieldActive = worker.fieldActive, aiActive = worker.aiActive, observedActive = worker.activeObserved,
                blocked = worker.blocked == true, speedMps = worker.speedMps, name = worker.name
            }
            raw.playerControl[worker.referenceKey] = {playerControlled = worker.playerControlled, playerPresent = worker.playerPresent == true}
            raw.jobEpisodeEvidence[#raw.jobEpisodeEvidence + 1] = {
                assemblyReferenceKey = worker.referenceKey, sourceJobToken = worker.sourceJobToken,
                jobPresent = worker.activeObserved == true, aiControlled = worker.activeObserved == true,
                aiActive = worker.aiActive == true, blocked = worker.blocked == true, outtaMyWayHold = false,
                temporarilyInactive = worker.activeObserved ~= true, playerControlled = worker.playerControlled == true,
                playerTakeoverObserved = worker.playerTakeoverObserved == true, sourceIntentTerminationObserved = worker.sourceIntentTerminationObserved == true, restartObserved = worker.restartObserved == true,
                replacementObserved = worker.replacementObserved == true,
                provenance = {
                    source = worker.nativeJobToken and "GIANTS_ACTIVE_JOB_IDENTITY" or "OBSERVED_NATIVE_AI_ACTIVITY_EPISODE",
                    nativeJobToken = worker.nativeJobToken, nativeJobTokenSource = worker.nativeJobTokenSource,
                    activeJobVehicleMembership = worker.activeObserved == true, activeObserved = worker.activeObserved, terminationEvidence = worker.terminationEvidence
                },
                fieldWorldReferenceKey = worker.fieldWorldResolution and worker.fieldWorldResolution.fieldWorldReferenceKey or nil,
                fieldWorldSnapshotReferenceKey = worker.fieldWorldSnapshot and worker.fieldWorldSnapshot.referenceKey or nil,
                fieldPolygonReferenceKey = worker.fieldWorldSnapshot and worker.fieldWorldSnapshot.fieldPolygonReferenceKey or nil,
                fieldWorldFingerprint = worker.fieldWorldSnapshot and worker.fieldWorldSnapshot.geometryFingerprint or nil,
                fieldWorldEquivalenceStatus = worker.fieldWorldResolution and worker.fieldWorldResolution.outcome or (worker.fieldWorldSnapshot and "UNRESOLVED" or nil),
                playerFacingFieldId = worker.playerFacingFieldId,
                playerFacingLocatorSource = worker.playerFacingLocatorSource
            }
            if worker.nativeJobToken == nil and worker.activeObserved then
                raw.unavailableSources[#raw.unavailableSources + 1] = {
                    source = "CURRENT_AI_JOB_OBJECT", assemblyReferenceKey = worker.referenceKey,
                    reason = "activeJobVehicles membership is positive but the current GIANTS job object is unavailable; fallback episode identity is observational"
                }
            end
            if worker.unresolvedTermination then
                raw.unavailableSources[#raw.unavailableSources + 1] = {
                    source = "JOB_EPISODE_TERMINATION_CAUSE", assemblyReferenceKey = worker.referenceKey,
                    reason = "previously active job vehicle is no longer in activeJobVehicles; player stop, GIANTS abort/fault and transient loss are not yet distinguished"
                }
            end
            if worker.objectUnavailable then
                raw.unavailableSources[#raw.unavailableSources + 1] = {
                    source = "ASSEMBLY_RUNTIME_OBJECT", assemblyReferenceKey = worker.referenceKey,
                    reason = "previously active assembly runtime object is unavailable"
                }
            end
            local snapshotResolved=worker.fieldWorldSnapshot~=nil
            local worldResolved=worker.fieldWorldResolution~=nil and worker.fieldWorldResolution.fieldWorldReferenceKey~=nil
            local recognised=worker.activeObserved and worldResolved and worker.hasFieldWorker
            raw.diagnostics.sourceCounters.activeGroupWorkerCount=raw.diagnostics.sourceCounters.activeGroupWorkerCount+(worker.activeObserved and 1 or 0)
            raw.diagnostics.sourceCounters.poseResolvedWorkerCount=raw.diagnostics.sourceCounters.poseResolvedWorkerCount+(worker.pose~=nil and 1 or 0)
            raw.diagnostics.assemblyDiagnostics[#raw.diagnostics.assemblyDiagnostics+1]={
                assemblyReferenceKey=worker.referenceKey,
                name=worker.name,
                sourceJobToken=worker.sourceJobToken,
                activeJobVehicleMembership=worker.activeObserved==true,
                fieldWorkerSpecializationPresent=worker.hasFieldWorker==true,
                fieldActive=worker.fieldActive==true,
                aiActive=worker.aiActive==true,
                blocked=worker.blocked==true,
                poseResolved=worker.pose~=nil,
                node=worker.poseDiagnostic and worker.poseDiagnostic.node or (worker.pose and worker.pose.node or nil),
                nodeSource=worker.poseDiagnostic and worker.poseDiagnostic.nodeSource or (worker.pose and worker.pose.nodeSource or nil),
                poseReason=worker.poseDiagnostic and worker.poseDiagnostic.reason or (worker.pose and "RETAINED_LAST_POSE" or "POSE_UNAVAILABLE"),
                x=worker.pose and worker.pose.x or nil,
                y=worker.pose and worker.pose.y or nil,
                z=worker.pose and worker.pose.z or nil,
                headingX=worker.pose and worker.pose.dx or nil,
                headingZ=worker.pose and worker.pose.dz or nil,
                width=worker.width,
                length=worker.length,
                radius=worker.radius,
                componentCount=#(worker.components or {}),
                structurallyValid=worker.radius~=nil,
                coverageComplete=false,
                conservative=false,
                underApproximationRisk=true,
                motion=worker.motionDiagnostic or {classification=worker.activeObserved and "MOTION_EVIDENCE_UNRESOLVED" or "INACTIVE_OR_RETAINED",reason=worker.activeObserved and "NO_DIAGNOSTIC_MOTION_SAMPLE" or "NOT_ACTIVE_FOR_MOTION_PREDICTION"},
                fieldWorldReferenceKey=worldResolved and worker.fieldWorldResolution.fieldWorldReferenceKey or nil,
                fieldWorldSnapshotReferenceKey=snapshotResolved and worker.fieldWorldSnapshot.referenceKey or nil
            }
            raw.operationMembershipEvidence[#raw.operationMembershipEvidence + 1] = {
                assemblyReferenceKey=worker.referenceKey,
                fieldWorldReferenceKey=worldResolved and worker.fieldWorldResolution.fieldWorldReferenceKey or nil,
                fieldWorldSnapshotReferenceKey=snapshotResolved and worker.fieldWorldSnapshot.referenceKey or nil,
                fieldPolygonReferenceKey=snapshotResolved and worker.fieldWorldSnapshot.fieldPolygonReferenceKey or nil,
                performingRecognisedFieldWork=recognised,
                evidence={
                    geometryFingerprint=snapshotResolved and worker.fieldWorldSnapshot.geometryFingerprint or nil,
                    fieldWorldSnapshotCaptured=snapshotResolved,fieldWorldIdentityResolved=worldResolved,
                    fieldWorldEquivalenceStatus=worker.fieldWorldResolution and worker.fieldWorldResolution.outcome or (snapshotResolved and "UNRESOLVED" or nil),
                    fieldActive=worker.fieldActive,aiActive=worker.aiActive,
                    activeJobVehicleMembership=worker.activeObserved,blocked=worker.blocked==true,
                    playerFacingFieldId=worker.playerFacingFieldId,playerFacingLocatorSource=worker.playerFacingLocatorSource
                },
                provenance={source="AISystem.activeJobVehicles+JobSeededFieldWorldSnapshot+FieldWorldEquivalenceAuthority",fieldWorldIdentityStatus=worldResolved and "AUTHORITATIVE_SPATIAL_EQUIVALENCE" or "UNRESOLVED"}
            }
            if not snapshotResolved then
                raw.unavailableSources[#raw.unavailableSources + 1] = {
                    source="FIELD_WORLD_SNAPSHOT",assemblyReferenceKey=worker.referenceKey,
                    reason=worker.fieldWorldError or "GIANTS-generated Job-seeded Field World polygon is not yet available"
                }
            elseif not worldResolved then
                raw.unavailableSources[#raw.unavailableSources + 1] = {
                    source="FIELD_WORLD_EQUIVALENCE_AUTHORITY",assemblyReferenceKey=worker.referenceKey,
                    reason=worker.fieldWorldResolution and worker.fieldWorldResolution.reason or "Field World equivalence remains unresolved"
                }
            end
            if worker.pose ~= nil then
                raw.geometry.currentSpaceEvidence[#raw.geometry.currentSpaceEvidence + 1] = {
                    identity = "live-current:" .. worker.referenceKey, assemblyReferenceKey = worker.referenceKey,
                    occupancy = {x = worker.pose.x, z = worker.pose.z, headingX = worker.pose.dx, headingZ = worker.pose.dz, width = worker.width, length = worker.length},
                    provenance = {source = worker.activeObserved and "steering-node+size-metadata" or "retained-last-observed-pose"}
                }
                raw.geometry.futureSpaceEvidence[#raw.geometry.futureSpaceEvidence + 1] = {
                    identity = "live-future:" .. worker.referenceKey, assemblyReferenceKey = worker.referenceKey,
                    alternatives = worker.activeObserved and {{
                        kind = "CONSTANT_VELOCITY_CORRIDOR", startX = worker.pose.x, startZ = worker.pose.z,
                        endX = worker.pose.x + worker.pose.dx * worker.speedMps * horizon,
                        endZ = worker.pose.z + worker.pose.dz * worker.speedMps * horizon, width = worker.width
                    }} or {}, horizon = horizon,
                    provenance = {source = worker.activeObserved and "bounded-live-motion-extrapolation" or "inactive-no-future-motion-assertion"}
                }
                if worker.activeObserved then
                    raw.geometry.demandEvidence[#raw.geometry.demandEvidence + 1] = {
                        identity = "live-demand:" .. worker.referenceKey, class = "COMMITTED_DEMAND", assemblyReferenceKey = worker.referenceKey,
                        space = {kind = "BOUNDED_CONTINUATION", horizon = horizon},
                        basis = {jobEpisodeObserved = true, fieldWorkActive = recognised}, provenance = {source = "GIANTS-active-job-membership"}
                    }
                end
                raw.physicalRepresentationEvidence[#raw.physicalRepresentationEvidence + 1] = {
                    assemblyReferenceKey = worker.referenceKey, representationId = "live-representation:" .. worker.referenceKey,
                    question = "PASSIVE_CONFLICT_SUPPORT", assessmentHorizon = horizon, structurallyValid = worker.radius ~= nil,
                    refreshRequired = not worker.activeObserved, currentForQuestion = true, coversAssessmentHorizon = false,
                    coverageComplete = false, conservative = false, permittedConclusions = {"CONFLICT_SUPPORT"},
                    uncertainty = {{kind = worker.activeObserved and "METADATA_ENVELOPE_INCOMPLETE" or "RETAINED_POSE_REQUIRES_REFRESH"}},
                    refreshNeed = {kind = "NEXT_PASSIVE_SAMPLE"}, validityDependencies = {"vehicle pose", "size metadata"},
                    provenance = {source = "LiveObservationSource"}
                }
            end
        end

        for i = 1, #group.workers - 1 do
            for j = i + 1, #group.workers do
                local a, b = group.workers[i], group.workers[j]
                local pairReferenceKey = OuttaMyWay.LiveInteractionDiagnostics.pairReferenceKey(a.referenceKey,b.referenceKey)
                local eligible = a.activeObserved==true and b.activeObserved==true and a.pose~=nil and b.pose~=nil
                local exclusionReason = nil
                if not eligible then
                    if a.activeObserved~=true then exclusionReason="SUBJECT_NOT_ACTIVE_JOB_MEMBER"
                    elseif b.activeObserved~=true then exclusionReason="OTHER_NOT_ACTIVE_JOB_MEMBER"
                    elseif a.pose==nil then exclusionReason="SUBJECT_POSE_UNAVAILABLE"
                    elseif b.pose==nil then exclusionReason="OTHER_POSE_UNAVAILABLE"
                    else exclusionReason="PAIR_ELIGIBILITY_UNRESOLVED" end
                end
                local pairDiagnostic={
                    pairReferenceKey=pairReferenceKey,
                    subjectAssemblyReferenceKey=a.referenceKey,
                    otherAssemblyReferenceKey=b.referenceKey,
                    subjectSourceJobToken=a.sourceJobToken,
                    otherSourceJobToken=b.sourceJobToken,
                    fieldWorldReferenceKey=resolved and group.fieldWorldReferenceKey or nil,
                    sameFieldWorld=resolved,
                    subjectActive=a.activeObserved==true,
                    otherActive=b.activeObserved==true,
                    subjectPoseAvailable=a.pose~=nil,
                    otherPoseAvailable=b.pose~=nil,
                    subjectBlocked=a.blocked==true,
                    otherBlocked=b.blocked==true,
                    eligible=eligible,
                    evaluated=false,
                    excluded=not eligible,
                    exclusionReason=exclusionReason,
                    qualifying=false,
                    interactionEvidenceEmitted=false,
                    subjectRepresentation={radius=a.radius,width=a.width,length=a.length,coverageComplete=false,conservative=false,underApproximationRisk=true},
                    otherRepresentation={radius=b.radius,width=b.width,length=b.length,coverageComplete=false,conservative=false,underApproximationRisk=true}
                }
                raw.diagnostics.sourceCounters.relevantPairCount=raw.diagnostics.sourceCounters.relevantPairCount+1
                if eligible then
                    raw.diagnostics.sourceCounters.eligiblePairCount=raw.diagnostics.sourceCounters.eligiblePairCount+1
                    raw.diagnostics.sourceCounters.evaluatedPairCount=raw.diagnostics.sourceCounters.evaluatedPairCount+1
                    local prediction = pairPrediction(a, b, horizon)
                    pairDiagnostic.evaluated=true
                    pairDiagnostic.distance=prediction.distance
                    pairDiagnostic.required=prediction.required
                    pairDiagnostic.currentSpaceIntersects=prediction.current
                    pairDiagnostic.futureSpaceConverges=prediction.converges
                    pairDiagnostic.tcpa=prediction.tcpa
                    pairDiagnostic.cpa=prediction.cpa
                    pairDiagnostic.closingRate=prediction.closingRate
                    pairDiagnostic.headingDot=prediction.headingDot
                    pairDiagnostic.relativeVelocityX=prediction.relativeVelocityX
                    pairDiagnostic.relativeVelocityZ=prediction.relativeVelocityZ
                    pairDiagnostic.relativeSpeedMps=prediction.relativeSpeedMps
                    pairDiagnostic.subjectVelocityX=prediction.subjectVelocityX
                    pairDiagnostic.subjectVelocityZ=prediction.subjectVelocityZ
                    pairDiagnostic.otherVelocityX=prediction.otherVelocityX
                    pairDiagnostic.otherVelocityZ=prediction.otherVelocityZ
                    pairDiagnostic.principalOutcome=prediction.principalOutcome
                    pairDiagnostic.currentSuppressionReason=prediction.currentSuppressionReason
                    pairDiagnostic.qualifying=prediction.current or prediction.converges
                    pairDiagnostic.interactionEvidenceEmitted=prediction.interactionEvidenceEmitted
                    pairDiagnostic.representationFitForNegativeConclusion=false
                    if prediction.current or prediction.converges then
                        raw.diagnostics.sourceCounters.qualifyingPairCount=raw.diagnostics.sourceCounters.qualifyingPairCount+1
                        raw.diagnostics.sourceCounters.interactionEvidenceEmittedCount=raw.diagnostics.sourceCounters.interactionEvidenceEmittedCount+1
                        raw.geometry.interactionEvidence[#raw.geometry.interactionEvidence + 1] = {
                            interactionReferenceKey = pairReferenceKey,
                            subjectAssemblyReferenceKey = a.referenceKey, otherAssemblyReferenceKey = b.referenceKey,
                            currentSpaceIntersects = prediction.current, futureSpaceConverges = prediction.converges, horizon = horizon,
                            provenance = {source = "bounded-current-motion", distance = prediction.distance, required = prediction.required, tcpa = prediction.tcpa, cpa = prediction.cpa, principalOutcome=prediction.principalOutcome}
                        }
                    elseif prediction.closingRate > 0.05 then
                        appendDiagnosticContradiction(raw.diagnostics.contradictions,"REPRESENTATION_UNFIT_BUT_NEGATIVE_RESULT_USED",{
                            pairReferenceKey=pairReferenceKey,
                            principalOutcome=prediction.principalOutcome,
                            closingRate=prediction.closingRate,
                            subjectUnderApproximationRisk=true,
                            otherUnderApproximationRisk=true
                        })
                    end
                    if prediction.headingDot > 0.5 and prediction.closingRate > 0.05 then
                        local aToB = (b.pose.x - a.pose.x) * a.pose.dx + (b.pose.z - a.pose.z) * a.pose.dz
                        local follower, leader = a, b
                        if aToB < 0 then follower, leader = b, a end
                        raw.motion.closureEvidence[#raw.motion.closureEvidence + 1] = {
                            followerAssemblyReferenceKey = follower.referenceKey, leaderAssemblyReferenceKey = leader.referenceKey,
                            closingObserved = true, closingRate = prediction.closingRate, horizon = horizon,
                            provenance = {source = "relative-live-motion"}
                        }
                    end
                else
                    raw.diagnostics.sourceCounters.excludedPairCount=raw.diagnostics.sourceCounters.excludedPairCount+1
                end
                raw.diagnostics.pairDiagnostics[#raw.diagnostics.pairDiagnostics+1]=pairDiagnostic
            end
        end

        observations[#observations + 1] = raw
        local hasRetained, hasActive = false, false
        for _, worker in OuttaMyWay.ValueRecord.ipairs(group.workers) do
            hasRetained = hasRetained or worker.unresolvedTermination == true
            hasActive = hasActive or worker.activeObserved == true
        end
        if resolved and (hasActive or hasRetained) then
            self.knownWorlds[key]={snapshots=group.snapshots}
        else
            self.knownWorlds[key]=nil
        end
    end

    for ref in OuttaMyWay.ValueRecord.pairs(removeAfterCapture) do self.tracks[ref] = nil end
    if self.fieldWorldEquivalenceAuthority ~= nil then self.fieldWorldEquivalenceAuthority:endObservationCycle() end

    if #observations == 0 then
        observations[1] = {
            timestamp = nowSeconds,
            provenance = {source = "LiveObservationSource", mode = "JOB_SEEDED_FIELD_WORLD_EQUIVALENCE_AUTHORITY", noActivity = true},
            fieldWorld = {referenceKey = "field-world:none", fieldPolygonReferenceKey = nil, fieldPolygonReferenceKeys = {}, fieldWorldSnapshotReferenceKeys = {}, operationMembershipEvidenceComplete = true, identityStatus="NO_ACTIVITY"},
            assemblies = {}, geometry = {currentSpaceEvidence = {}, futureSpaceEvidence = {}, demandEvidence = {}, interactionEvidence = {}},
            motion = {closureEvidence = {}}, aiStates = {}, playerControl = {}, jobEpisodeEvidence = {}, operationMembershipEvidence = {},
            physicalRepresentationEvidence = {}, controlOutcomes = {}, unavailableSources = {},
            diagnostics={sourceCounters={cycleActiveJobVehicleCount=cycleDiagnostics.activeJobVehicleCount,cycleRelevantVehicleCount=cycleDiagnostics.relevantVehicleCount,groupWorkerCount=0,activeGroupWorkerCount=0,poseResolvedWorkerCount=0,mathematicallyPossiblePairCount=0,relevantPairCount=0,eligiblePairCount=0,evaluatedPairCount=0,excludedPairCount=0,qualifyingPairCount=0,interactionEvidenceEmittedCount=0},assemblyDiagnostics={},pairDiagnostics={},contradictions={}}
        }
    end
    return observations
end
