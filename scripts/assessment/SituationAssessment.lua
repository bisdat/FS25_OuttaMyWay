OuttaMyWay.SituationAssessment = {}
local Assessment = OuttaMyWay.SituationAssessment
Assessment.__index = Assessment

local function sortedUnique(values)
    local seen, result = {}, {}
    for _, value in OuttaMyWay.ValueRecord.ipairs(values or {}) do if not seen[value] then seen[value]=true; result[#result+1]=value end end
    table.sort(result); return result
end

local function assemblyMap(snapshot)
    local map = {}
    for _, assembly in OuttaMyWay.ValueRecord.ipairs(snapshot.assemblies) do
        map[type(assembly.referenceKey) .. ":" .. tostring(assembly.referenceKey)] = assembly.assemblyId
        map[assembly.assemblyId] = assembly.assemblyId
    end
    return map
end

local function resolveAssembly(map, item, field)
    local direct = item.assemblyId or item[field or "assemblyReferenceKey"]
    local key = map[direct] and direct or (type(direct) .. ":" .. tostring(direct))
    local identity = map[key]
    if identity == nil then error("Situation Assessment cannot resolve assembly reference " .. tostring(direct), 3) end
    return identity
end

local function normalizeSpaces(values, map, kind)
    local result = {}
    for _, item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        result[#result + 1] = {
            identity = item.identity,
            assemblyId = resolveAssembly(map, item),
            kind = kind,
            occupancy = item.occupancy,
            alternatives = item.alternatives or {},
            horizon = item.horizon,
            validityDependencies = item.validityDependencies or {},
            uncertainty = item.uncertainty or {},
            provenance = item.provenance
        }
    end
    table.sort(result, function(a,b)
        if a.assemblyId ~= b.assemblyId then return a.assemblyId < b.assemblyId end
        return tostring(a.identity or "") < tostring(b.identity or "")
    end)
    return result
end

local demandMap = {
    COMMITTED_DEMAND = "committedDemand",
    POTENTIAL_DEMAND = "potentialDemand",
    TEMPORARY_SLACK = "temporarySlack"
}

local function normalizeDemand(values, map)
    local result = { committedDemand={}, potentialDemand={}, temporarySlack={} }
    for _, item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        local bucket = demandMap[item.class]
        if bucket == nil then error("unsupported demand class " .. tostring(item.class), 3) end
        local entry = {
            identity = item.identity,
            assemblyId = item.assemblyReferenceKey and resolveAssembly(map,item) or item.assemblyId,
            operationId = item.operationId,
            space = item.space,
            horizon = item.horizon,
            basis = item.basis,
            uncertainty = item.uncertainty or {},
            provenance = item.provenance
        }
        result[bucket][#result[bucket]+1] = entry
    end
    for _, bucket in OuttaMyWay.ValueRecord.pairs(result) do table.sort(bucket,function(a,b) return tostring(a.identity or a.assemblyId or "") < tostring(b.identity or b.assemblyId or "") end) end
    return result
end

function Assessment.new(identityRegistry, epochSequence, jobEpisodes, operations, commitments)
    local self = setmetatable({}, Assessment)
    self.identities = identityRegistry
    self.epochs = epochSequence
    self.jobEpisodes = jobEpisodes
    self.operations = operations
    self.commitments = commitments
    self.publishedCount = 0
    return self
end

function Assessment:assess(snapshot, episodeResult, operationResult)
    OuttaMyWay.ValueRecord.assertType(snapshot, "ObservationSnapshot")
    OuttaMyWay.ValueRecord.assertType(episodeResult, "JobEpisodeAdmissionResult")
    OuttaMyWay.ValueRecord.assertType(operationResult, "OperationAdmissionResult")
    local map = assemblyMap(snapshot)
    local activeOperationIds = {}; for _, id in OuttaMyWay.ValueRecord.ipairs(operationResult.activeOperationIds) do activeOperationIds[#activeOperationIds+1]=id end
    local currentSpace = normalizeSpaces(snapshot.geometry.currentSpaceEvidence or {}, map, "CURRENT_SPACE")
    local futureSpace = normalizeSpaces(snapshot.geometry.futureSpaceEvidence or {}, map, "FUTURE_SPACE")
    local demand = normalizeDemand(snapshot.geometry.demandEvidence or {}, map)

    local relevant = {}
    for _, item in OuttaMyWay.ValueRecord.ipairs(currentSpace) do relevant[#relevant+1]=item.assemblyId end
    for _, item in OuttaMyWay.ValueRecord.ipairs(futureSpace) do relevant[#relevant+1]=item.assemblyId end
    for _, bucket in OuttaMyWay.ValueRecord.pairs(demand) do for _, item in OuttaMyWay.ValueRecord.ipairs(bucket) do if item.assemblyId then relevant[#relevant+1]=item.assemblyId end end end

    local situations = {}
    for _, operationId in OuttaMyWay.ValueRecord.ipairs(activeOperationIds) do
        local operation = self.operations:get(operationId)
        for _, id in OuttaMyWay.ValueRecord.ipairs(operation.memberAssemblyIds) do relevant[#relevant+1]=id end
        situations[#situations+1] = {
            identity = self.identities:resolve("SITUATION", operationId),
            operationId = operationId,
            memberAssemblyIds = operation.memberAssemblyIds,
            relevantAssemblyIds = {},
            provenance = { observationSnapshotId=snapshot.identity, operationRevision=operation.revision }
        }
    end

    local encounters = {}
    for _, item in OuttaMyWay.ValueRecord.ipairs(snapshot.geometry.interactionEvidence or {}) do
        local subject = resolveAssembly(map,item,"subjectAssemblyReferenceKey")
        local other = resolveAssembly(map,item,"otherAssemblyReferenceKey")
        relevant[#relevant+1]=subject; relevant[#relevant+1]=other
        if item.currentSpaceIntersects == true or item.futureSpaceConverges == true then
            if item.interactionReferenceKey == nil then error("interaction evidence requires interactionReferenceKey",2) end
            local operationId = activeOperationIds[1]
            if operationId == nil then error("encounter evidence requires an active Operation",2) end
            encounters[#encounters+1] = {
                identity = self.identities:resolve("ENCOUNTER", operationId .. "|" .. tostring(item.interactionReferenceKey)),
                operationId = operationId,
                subjectAssemblyId = subject,
                otherAssemblyId = other,
                relationship = item.currentSpaceIntersects == true and "CURRENT_SPACE_INTERACTION" or "FUTURE_SPACE_CONVERGENCE",
                evidence = {
                    currentSpaceIntersects=item.currentSpaceIntersects == true,
                    futureSpaceConverges=item.futureSpaceConverges == true,
                    horizon=item.horizon,
                    provenance=item.provenance
                }
            }
        end
    end
    table.sort(encounters,function(a,b) return a.identity < b.identity end)

    local responsibilityRelations = {}
    for _, item in OuttaMyWay.ValueRecord.ipairs(snapshot.motion.closureEvidence or {}) do
        if item.closingObserved == true then
            responsibilityRelations[#responsibilityRelations+1] = {
                relation = "FOLLOWER_OWNS_CLOSURE",
                followerAssemblyId = resolveAssembly(map,item,"followerAssemblyReferenceKey"),
                leaderAssemblyId = resolveAssembly(map,item,"leaderAssemblyReferenceKey"),
                closingRate = item.closingRate,
                horizon = item.horizon,
                provenance = item.provenance
            }
        end
    end
    table.sort(responsibilityRelations,function(a,b) return a.followerAssemblyId < b.followerAssemblyId end)

    local representationFitness, uncertainty = {}, {}
    for _, evidence in OuttaMyWay.ValueRecord.ipairs(snapshot.physicalRepresentationEvidence) do
        local fitness = OuttaMyWay.RepresentationFitness.evaluate(evidence,snapshot)
        representationFitness[#representationFitness+1] = fitness
        relevant[#relevant+1] = fitness.assemblyId
        if fitness.state ~= "CURRENTLY_FIT" then
            uncertainty[#uncertainty+1] = { class="REPRESENTATION_FITNESS", subjectId=fitness.representationId, state=fitness.state, provenance=fitness.provenance }
        end
    end
    table.sort(representationFitness,function(a,b) return tostring(a.representationId) < tostring(b.representationId) end)
    for _, source in OuttaMyWay.ValueRecord.ipairs(snapshot.unavailableSources) do
        uncertainty[#uncertainty+1] = { class="UNAVAILABLE_SOURCE", source=source, provenance={observationSnapshotId=snapshot.identity} }
    end
    if operationResult.membershipEvidenceComplete ~= true then
        uncertainty[#uncertainty+1] = { class="OPERATION_MEMBERSHIP_INCOMPLETE", provenance={observationSnapshotId=snapshot.identity} }
    end

    relevant = sortedUnique(relevant)
    for _, situation in OuttaMyWay.ValueRecord.ipairs(situations) do situation.relevantAssemblyIds = relevant end

    local componentIds = {}
    local assemblyIds = {}
    for _, assembly in OuttaMyWay.ValueRecord.ipairs(snapshot.assemblies) do
        assemblyIds[#assemblyIds+1]=assembly.assemblyId
        for _, id in OuttaMyWay.ValueRecord.ipairs(assembly.componentIds) do componentIds[#componentIds+1]=id end
    end

    local commitmentContext = {}
    for _, commitment in OuttaMyWay.ValueRecord.ipairs(self.commitments:list()) do
        commitmentContext[#commitmentContext+1] = {
            identity=commitment.identity,
            lifecycleState=commitment.lifecycleState,
            governingBasis=commitment.governingBasis,
            situationDependencies=commitment.situationDependencies,
            obligationSet=commitment.obligationSet,
            progressActuationOwnership=commitment.progressActuationOwnership,
            capabilityReservations=commitment.capabilityReservations,
            validatedEffectiveActuationComposition=commitment.validatedEffectiveActuationComposition,
            evidenceContracts=commitment.evidenceContracts
        }
    end

    local candidateSupportEvidence = {
        currentSpaceEvidenceCount=#currentSpace,
        futureSpaceEvidenceCount=#futureSpace,
        demandEvidenceCount=#demand.committedDemand + #demand.potentialDemand + #demand.temporarySlack,
        representationEvidenceCount=#representationFitness,
        interactionEvidenceCount=#encounters,
        provenance={observationSnapshotId=snapshot.identity}
    }

    local picture = OuttaMyWay.OperationalPicture.new({
        identity=self.identities:issue("PICTURE"),
        epoch=self.epochs:next(),
        observationSnapshotId=snapshot.identity,
        situations=situations,
        encounters=encounters,
        identities={
            assemblies=sortedUnique(assemblyIds),
            components=sortedUnique(componentIds),
            jobEpisodes={active=episodeResult.activeEpisodeIds, admitted=episodeResult.admittedEpisodeIds, ended=episodeResult.endedEpisodeIds},
            operations={active=operationResult.activeOperationIds, ended=operationResult.endedOperationIds}
        },
        currentSpace=currentSpace,
        futureSpace=futureSpace,
        demand=demand,
        responsibilityRelations=responsibilityRelations,
        uncertainty=uncertainty,
        representationFitness=representationFitness,
        provenance={source="SituationAssessment", observationSnapshotId=snapshot.identity, observationEpoch=snapshot.epoch},
        controlOutcomeEvidence={sourceObservationSnapshotId=snapshot.identity,outcomes=snapshot.controlOutcomes},
        candidateSupportEvidence=candidateSupportEvidence,
        commitmentContext=commitmentContext
    })
    self.publishedCount = self.publishedCount + 1
    return picture
end

function Assessment:getPublishedCount() return self.publishedCount end
