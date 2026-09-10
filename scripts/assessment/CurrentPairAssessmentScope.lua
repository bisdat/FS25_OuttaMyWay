-- Ephemeral Situation scope rebuilt from current Operation membership and exact
-- active Job Episodes for every Operational Picture.
-- Absence Is Not Separation.
-- Unresolved Evidence Is Non-Authority, Not Universal Prohibition.

OuttaMyWay.CurrentPairAssessmentScope={}
local Scope=OuttaMyWay.CurrentPairAssessmentScope

local function sorted(values)
    local result={}
    for _,v in OuttaMyWay.ValueRecord.ipairs(values or {}) do result[#result+1]=v end
    table.sort(result,function(a,b) return tostring(a)<tostring(b) end)
    return result
end

local function episodeSignature(a,b)
    if tostring(a)<tostring(b) then return tostring(a).."|"..tostring(b) end
    return tostring(b).."|"..tostring(a)
end

local function assemblyById(snapshot)
    local result={}
    for _,assembly in OuttaMyWay.ValueRecord.ipairs(snapshot.assemblies or {}) do
        result[assembly.assemblyId]={assemblyId=assembly.assemblyId,referenceKey=assembly.referenceKey}
    end
    return result
end

local function evidenceByPair(snapshot)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(snapshot.geometry.interactionEvidence or {}) do
        if item.subjectAssemblyReferenceKey~=nil and item.otherAssemblyReferenceKey~=nil then
            local key=OuttaMyWay.LiveInteractionObservation.pairReferenceKey(
                item.subjectAssemblyReferenceKey,item.otherAssemblyReferenceKey)
            local e=result[key]
            if e==nil then
                e={current=false,future=false,sourceInteractionReferenceKeys={}}
                result[key]=e
            end
            e.sourceInteractionReferenceKeys[#e.sourceInteractionReferenceKeys+1]=item.interactionReferenceKey
            if item.currentSpaceIntersects==true then
                e.current=true; e.currentProvenance=item.provenance
            end
            if item.futureSpaceConverges==true then
                e.future=true; e.futureProvenance=item.provenance
                e.futureRelationship=item.relationship or e.futureRelationship
                e.horizon=item.horizon or e.horizon
            end
        end
    end
    for _,e in OuttaMyWay.ValueRecord.pairs(result) do
        table.sort(e.sourceInteractionReferenceKeys,function(a,b) return tostring(a)<tostring(b) end)
    end
    return result
end

function Scope.build(snapshot,activeOperationIds,operations,jobEpisodes)
    local assemblies=assemblyById(snapshot)
    local observed=evidenceByPair(snapshot)
    local result={}
    for _,operationId in OuttaMyWay.ValueRecord.ipairs(activeOperationIds or {}) do
        local operation=operations:get(operationId)
        if operation~=nil and operation.status=="ACTIVE" then
            local members=sorted(operation.memberAssemblyIds)
            for i=1,#members-1 do
                for j=i+1,#members do
                    local aId,bId=members[i],members[j]
                    local a,b=assemblies[aId],assemblies[bId]
                    local aEpisode=jobEpisodes:getActiveForAssembly(aId)
                    local bEpisode=jobEpisodes:getActiveForAssembly(bId)
                    if a~=nil and b~=nil and a.referenceKey~=nil and b.referenceKey~=nil
                        and aEpisode~=nil and bEpisode~=nil then
                        local key=OuttaMyWay.LiveInteractionObservation.pairReferenceKey(a.referenceKey,b.referenceKey)
                        local e=observed[key]
                        local current=e~=nil and e.current==true
                        local future=e~=nil and e.future==true
                        local relationship="UNRESOLVED"
                        if current then relationship="CURRENT_SPACE_INTERACTION"
                        elseif future then relationship=e.futureRelationship or "FUTURE_SPACE_CONVERGENCE" end
                        result[#result+1]={
                            pairReferenceKey=key,operationId=operationId,
                            subjectAssemblyId=aId,otherAssemblyId=bId,
                            subjectReferenceKey=a.referenceKey,otherReferenceKey=b.referenceKey,
                            subjectJobEpisodeId=aEpisode.identity,otherJobEpisodeId=bEpisode.identity,
                            episodeSignature=episodeSignature(aEpisode.identity,bEpisode.identity),
                            relationshipStatus=(current or future) and "POSITIVE" or "UNRESOLVED",
                            relationship=relationship,
                            currentSpaceStatus=current and "POSITIVE" or "UNRESOLVED",
                            futureSpaceStatus=future and "POSITIVE" or "UNRESOLVED",
                            currentInteractionEvidencePresent=e~=nil,
                            evidence={
                                sourceInteractionReferenceKeys=e and e.sourceInteractionReferenceKeys or {},
                                horizon=e and e.horizon or nil,
                                currentPositiveProvenance=e and e.currentProvenance or nil,
                                futurePositiveProvenance=e and e.futureProvenance or nil,
                                observationSnapshotId=snapshot.identity,negativeClearanceAuthority=false
                            },
                            provenance={
                                source="CurrentPairAssessmentScope",layer="SITUATION_ASSESSMENT_SCOPE",
                                observationSnapshotId=snapshot.identity,operationRevision=operation.revision,
                                ephemeral=true,persistentPairHistory=false,
                                decisionAuthority=false,controlAuthority=false
                            }
                        }
                    end
                end
            end
        end
    end
    table.sort(result,function(a,b)
        if tostring(a.operationId)~=tostring(b.operationId) then return tostring(a.operationId)<tostring(b.operationId) end
        return tostring(a.pairReferenceKey)<tostring(b.pairReferenceKey)
    end)
    return result
end
