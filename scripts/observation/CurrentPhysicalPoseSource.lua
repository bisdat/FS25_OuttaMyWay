OuttaMyWay.CurrentPhysicalPoseSource={}
local Source=OuttaMyWay.CurrentPhysicalPoseSource
Source.__index=Source

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
end

local function referencePose(object)
    if object==nil or object.isDeleted==true then return nil,"CURRENT_PHYSICAL_OBJECT_UNAVAILABLE" end
    local node=object.rootNode
    local source="ROOT_NODE"
    local ok,steeringNode=safeCall(object,"getAISteeringNode")
    if ok and steeringNode~=nil and steeringNode~=0 then node=steeringNode; source="AI_STEERING_NODE" end
    if node==nil or node==0 then return nil,"REFERENCE_NODE_UNAVAILABLE" end
    if type(getWorldTranslation)~="function" then return nil,"WORLD_TRANSLATION_API_UNAVAILABLE" end
    local positioned,x,y,z=pcall(getWorldTranslation,node)
    if not positioned or not finite(x) or not finite(z) then return nil,"WORLD_TRANSLATION_UNRESOLVED" end
    return {x=x,y=y,z=z,node=node,nodeSource=source},nil
end

local function currentAssemblyReferences(raw)
    local result,seen={},{}
    for _,assembly in OuttaMyWay.ValueRecord.ipairs(raw and raw.assemblies or {}) do
        local referenceKey=assembly.referenceKey
        if type(referenceKey)=="string" and seen[referenceKey]~=true then
            seen[referenceKey]=true
            result[#result+1]=referenceKey
        end
    end
    table.sort(result)
    return result
end

function Source.new()
    return setmetatable({publishedCount=0},Source)
end

-- Observation-only augmentation performed before RuntimeObservationAdapter seals
-- the snapshot. The pose is a current physical reference for bounded relocation
-- planning; it grants no Situation relevance, negative clearance or actuation.
function Source:observe(raw,liveObservationSource)
    if type(raw)~="table" then return 0 end
    raw.geometry=raw.geometry or {}
    raw.geometry.currentPhysicalPoseEvidence=raw.geometry.currentPhysicalPoseEvidence or {}
    raw.physicalRepresentationEvidence=raw.physicalRepresentationEvidence or {}
    local published=0
    for _,referenceKey in OuttaMyWay.ValueRecord.ipairs(currentAssemblyReferences(raw)) do
        local object=liveObservationSource and liveObservationSource:getCurrentPhysicalObject(referenceKey) or nil
        local pose,reason=referencePose(object)
        local currentRepresentation=liveObservationSource
            and type(liveObservationSource.getCurrentPhysicalRelocationRepresentation)=="function"
            and liveObservationSource:getCurrentPhysicalRelocationRepresentation(referenceKey,raw.timestamp)
            or nil
        local primitiveCount=currentRepresentation and tonumber(currentRepresentation.positivePrimitiveCount) or 0
        if pose~=nil then
            raw.geometry.currentPhysicalPoseEvidence[#raw.geometry.currentPhysicalPoseEvidence+1]={
                assemblyReferenceKey=referenceKey,x=pose.x,y=pose.y,z=pose.z,
                nodeSource=pose.nodeSource,
                provenance={source="CurrentPhysicalPoseSource",authority="CURRENT_PHYSICAL_RELOCATION_REFERENCE_POSE",semanticAuthority=false,negativeClearanceAuthority=false}
            }
            raw.physicalRepresentationEvidence[#raw.physicalRepresentationEvidence+1]={
                assemblyReferenceKey=referenceKey,
                representationId="current-obstruction-relocation:"..referenceKey,
                question="CURRENT_CAUSAL_OBSTRUCTION_RELOCATION_REFERENCE",
                assessmentHorizon=0,
                structurallyValid=currentRepresentation~=nil and currentRepresentation.structurallyValid==true,
                refreshRequired=false,
                currentForQuestion=true,
                coversAssessmentHorizon=false,
                coverageComplete=false,
                conservative=false,
                permittedConclusions={"CURRENT_RELOCATION_REFERENCE_POSE","POSITIVE_CONFLICT_SUPPORT"},
                uncertaintyPresent=true,
                uncertainty={{kind="NO_NEGATIVE_CLEARANCE_AUTHORITY"}},
                refreshNeed={kind="NEXT_LIVE_OBSERVATION"},
                validityDependencies={"CURRENT_MISSION_PHYSICAL_ASSEMBLY","CURRENT_REFERENCE_POSE","CURRENT_POSITIVE_CONFLICT_REPRESENTATION"},
                provenance={source="CurrentPhysicalPoseSource",authority="PURPOSE_SCOPED_CURRENT_RELOCATION_REFERENCE",populationBasis="CURRENT_OBSERVATION_ASSEMBLY_PLUS_CURRENT_GIANTS_MISSION_OBJECT",positivePrimitiveCount=primitiveCount,historicalJobProvenanceRequired=false,observationSourceProvenanceRequired=false}
            }
            published=published+1
        elseif reason~=nil then
            raw.unavailableSources=raw.unavailableSources or {}
            raw.unavailableSources[#raw.unavailableSources+1]={source="CURRENT_PHYSICAL_RELOCATION_REFERENCE_POSE",assemblyReferenceKey=referenceKey,reason=reason}
        end
    end
    table.sort(raw.geometry.currentPhysicalPoseEvidence,function(a,b) return tostring(a.assemblyReferenceKey)<tostring(b.assemblyReferenceKey) end)
    self.publishedCount=self.publishedCount+published
    return published
end

function Source:getPublishedCount() return self.publishedCount end
