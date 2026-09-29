--- Traffic Policeman sequential Decision policy.
-- Implements the settled sequential Decision ordering only. It does not derive traffic evidence,
-- assign roles, construct Vulnerable Space/Convergent Projection or actuate Control.
-- Specification Jurisdictions: `DECISION`

OuttaMyWay.TrafficPolicemanDecisionPolicy = {}
local Policy = OuttaMyWay.TrafficPolicemanDecisionPolicy

Policy.KIND = "TRAFFIC_POLICEMAN_SEQUENTIAL_PRIMARY"

local orderedCapabilities = {
    "CONTINUE_OBSERVATION",
    "REGULATE_SPEED",
    "HOLD",
    "REPOSITION",
    "ESCALATE"
}

local rankByCapability = {}
for index, capability in ipairs(orderedCapabilities) do rankByCapability[capability] = index end

local function policyBoundary(candidateInventory)
    local boundary = candidateInventory and candidateInventory.supportBoundary or nil
    local policy = type(boundary) == "table" and boundary.decisionPolicy or nil
    if type(policy) ~= "table" or policy.kind ~= Policy.KIND then return nil end
    if type(policy.governingRequirementKey) ~= "string" or policy.governingRequirementKey == "" then
        error("Traffic Policeman Decision policy requires governingRequirementKey", 3)
    end
    return policy
end

local function candidateMetadata(candidate, governingRequirementKey)
    local basis = candidate.evidenceBasis or {}
    local metadata = basis.trafficPolicemanPreference
    if type(metadata) ~= "table" then
        error("Traffic Policeman primary candidate lacks trafficPolicemanPreference evidence", 3)
    end
    if metadata.governingRequirementKey ~= governingRequirementKey then
        error("Traffic Policeman candidate governing requirement does not match Candidate support boundary", 3)
    end
    if metadata.primaryResolution ~= true then
        error("Traffic Policeman sequential primary policy received a non-primary candidate", 3)
    end
    local rank = rankByCapability[candidate.capability]
    if rank == nil then
        error("Traffic Policeman primary candidate uses unsupported capability " .. tostring(candidate.capability), 3)
    end
    return metadata, rank
end

local function exhaustionPass(record, picture, governingRequirementKey, capability)
    if type(record) ~= "table" then return false, "MISSING" end
    if record.result ~= "PASS" then return false, tostring(record.result or "UNRESOLVED") end
    if record.operationalPictureId ~= picture.identity then return false, "STALE_OPERATIONAL_PICTURE" end
    if record.governingRequirementKey ~= governingRequirementKey then return false, "WRONG_GOVERNING_REQUIREMENT" end
    if record.capability ~= capability then return false, "WRONG_PREFERENCE_BAND" end
    return true, "PASS"
end

local function autonomousExhaustionPass(record, picture, governingRequirementKey)
    if type(record) ~= "table" then return false, "MISSING" end
    if record.result ~= "PASS" then return false, tostring(record.result or "UNRESOLVED") end
    if record.operationalPictureId ~= picture.identity then return false, "STALE_OPERATIONAL_PICTURE" end
    if record.governingRequirementKey ~= governingRequirementKey then return false, "WRONG_GOVERNING_REQUIREMENT" end
    if record.completeSupportableAutonomousSpace ~= true then return false, "INCOMPLETE_AUTONOMOUS_SPACE" end
    if record.participantComplete ~= true then return false, "PARTICIPANT_INCOMPLETE" end
    return true, "PASS"
end

local function finiteNumber(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function cornerRightOfWayChoice(entries)
    if #entries==0 then return nil,false,nil end
    local cornerCount=0
    local identity=nil
    for _,entry in OuttaMyWay.ValueRecord.ipairs(entries) do
        local evidence=entry.metadata and entry.metadata.cornerRightOfWay or nil
        if type(evidence)=="table" then
            cornerCount=cornerCount+1
            if identity==nil then identity=evidence.sharedCornerIdentity
            elseif identity~=evidence.sharedCornerIdentity then
                return nil,true,"MULTIPLE_SHARED_CORNER_IDENTITIES_IN_ONE_DECISION_SCOPE"
            end
        end
    end
    if cornerCount==0 then return nil,false,nil end
    if cornerCount~=#entries or #entries~=2 then
        return nil,true,"SHARED_CORNER_ALLOCATION_REQUIRES_EXACTLY_TWO_ALTERNATIVES"
    end

    local function protected(entry)
        local evidence=entry.metadata.cornerRightOfWay
        return evidence and evidence.protectedParticipant or nil
    end
    local function regulated(entry)
        local evidence=entry.metadata.cornerRightOfWay
        return evidence and evidence.regulatedParticipant or nil
    end
    local function requiresCornerEvacuation(participant)
        return type(participant)=="table"
            and (participant.cornerIncumbent==true or participant.currentConstrainedCornerOccupancy==true)
    end
    local a,b=entries[1],entries[2]
    local ap,bp=protected(a),protected(b)
    local ar,br=regulated(a),regulated(b)
    if type(ap)~="table" or type(bp)~="table" or type(ar)~="table" or type(br)~="table" then
        return nil,true,"SHARED_CORNER_PARTICIPANT_EVIDENCE_UNAVAILABLE"
    end

    local aIneligible=requiresCornerEvacuation(ar)
    local bIneligible=requiresCornerEvacuation(br)
    if aIneligible and bIneligible then
        return nil,true,"BOTH_REGULATED_PARTICIPANTS_REQUIRE_CATEGORY_1_CORNER_EVACUATION"
    end
    if aIneligible~=bIneligible then
        return aIneligible and b or a,true,"REGULATE_ONLY_NON_CORNER_OCCUPANT"
    end

    local ai=ap.cornerIncumbent==true
    local bi=bp.cornerIncumbent==true
    if ai~=bi then
        return ai and a or b,true,"PROTECT_CORNER_INCUMBENT"
    end

    local at,bt=tonumber(ap.timeToCornerSec),tonumber(bp.timeToCornerSec)
    if finiteNumber(at) and finiteNumber(bt) and at~=bt then
        return at<bt and a or b,true,"PROTECT_EARLIER_CURRENT_CORNER_ARRIVAL"
    end
    if finiteNumber(at)~=(finiteNumber(bt)) then
        return finiteNumber(at) and a or b,true,"PROTECT_ONLY_CURRENT_SUPPORTED_CORNER_ARRIVAL"
    end

    return nil,true,"SHARED_CORNER_ARRIVAL_PRIORITY_UNRESOLVED"
end

local function compareCandidates(a, b)
    if a.rank ~= b.rank then return a.rank < b.rank end
    if a.candidate.comparisonCost ~= b.candidate.comparisonCost then
        return a.candidate.comparisonCost < b.candidate.comparisonCost
    end
    if a.candidate.capability ~= b.candidate.capability then
        return a.candidate.capability < b.candidate.capability
    end
    return a.candidate.identity < b.candidate.identity
end

local function sharedCategory2Choice(entries)
    if #entries==0 then return nil,false,nil end
    local categoryCount=0
    local identity=nil
    for _,entry in OuttaMyWay.ValueRecord.ipairs(entries) do
        local evidence=entry.metadata and entry.metadata.sharedCategory2Allocation or nil
        if type(evidence)=="table" then
            categoryCount=categoryCount+1
            if identity==nil then identity=evidence.sharedCategory2Identity
            elseif identity~=evidence.sharedCategory2Identity then
                return nil,true,"MULTIPLE_SHARED_CATEGORY_2_IDENTITIES_IN_ONE_DECISION_SCOPE"
            end
        end
    end
    if categoryCount==0 then return nil,false,nil end
    if categoryCount~=#entries then return nil,true,"MIXED_SHARED_CATEGORY_2_AND_OTHER_ALTERNATIVES" end

    -- An incumbent purpose is already allocated. Candidate Support deliberately
    -- projects only that fixed direction; Decision does not re-arbitrate it.
    if #entries==1 then
        return entries[1],true,"PRESERVE_INCUMBENT_SHARED_CATEGORY_2_ALLOCATION"
    end
    if #entries~=2 then return nil,true,"SHARED_CATEGORY_2_ALLOCATION_REQUIRES_TWO_FRESH_ALTERNATIVES" end

    local function protected(entry)
        local evidence=entry.metadata.sharedCategory2Allocation
        return evidence and evidence.protectedParticipant or nil
    end

    local a,b=entries[1],entries[2]
    local ap,bp=protected(a),protected(b)
    if type(ap)~="table" or type(bp)~="table" then
        return nil,true,"SHARED_CATEGORY_2_PARTICIPANT_EVIDENCE_UNAVAILABLE"
    end

    -- 1. A participant already consuming the constrained locality must be able
    -- to create/vacate space rather than being immobilised by the other party.
    local ao=ap.currentBoundaryDemandOccupancy==true
    local bo=bp.currentBoundaryDemandOccupancy==true
    if ao~=bo then
        return ao and a or b,true,"PROTECT_CURRENT_CATEGORY_2_OCCUPANT"
    end

    -- 2. Normalised Field-World option space is scale-independent across
    -- differently-sized assemblies. Numerical noise is not traffic meaning.
    local ar,br=tonumber(ap.boundaryOptionSpaceRatio),tonumber(bp.boundaryOptionSpaceRatio)
    if finiteNumber(ar) and finiteNumber(br) then
        local at=tonumber(ap.boundaryOptionSpaceRatioTolerance) or 0
        local bt=tonumber(bp.boundaryOptionSpaceRatioTolerance) or 0
        local tolerance=math.max(at,bt,0.000001)
        if math.abs(ar-br)>tolerance then
            return ar<br and a or b,true,"PROTECT_LOWER_BOUNDARY_OPTION_SPACE"
        end
    end

    -- 3. When spatial scarcity does not decide the pair, preserve the native
    -- party currently revealing constrained intent over settled A8 that can wait.
    local ai=ap.intentClassification
    local bi=bp.intentClassification
    local aTurning=ai=="TURNING"
    local bTurning=bi=="TURNING"
    if aTurning~=bTurning then
        return aTurning and a or b,true,"PROTECT_CATEGORY_2_INTENT_REVELATION"
    end

    -- Resolution-Margin / cheaper-waiting evidence is intentionally not
    -- reconstructed here. Until Situation publishes a directly comparable pair
    -- signal, Decision must not invent one from speed or distance proxies.

    -- 5. Architecture permits a stable tie-break only after semantic evidence
    -- remains genuinely equivalent. Candidate identity is stability, not priority.
    table.sort(entries,compareCandidates)
    return entries[1],true,"STABLE_NON_SEMANTIC_CATEGORY_2_TIE_BREAK"
end


function Policy:select(picture, candidateInventory, viableCandidates)
    OuttaMyWay.ValueRecord.assertType(picture, "OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(candidateInventory, "CandidateInventory")
    local boundary = policyBoundary(candidateInventory)
    if boundary == nil then return nil end

    local governingRequirementKey = boundary.governingRequirementKey
    local ranked = {}
    for _, candidate in OuttaMyWay.ValueRecord.ipairs(viableCandidates or {}) do
        local metadata, rank = candidateMetadata(candidate, governingRequirementKey)
        ranked[#ranked + 1] = {candidate=candidate, metadata=metadata, rank=rank}
    end
    table.sort(ranked, compareCandidates)

    if #ranked == 0 then
        return {
            selected=nil,
            waitForPreferenceEvidence=false,
            governingRequirementKey=governingRequirementKey,
            rule=Policy.KIND,
            ranked={}
        }
    end

    local bestRank = ranked[1].rank
    local selectable = {}
    local blocked = {}
    for _, entry in OuttaMyWay.ValueRecord.ipairs(ranked) do
        if entry.rank == bestRank then
            local complete = true
            local missing = {}
            local exhaustion = entry.metadata.exhaustionEvidence or {}
            for earlierRank = 1, entry.rank - 1 do
                local capability = orderedCapabilities[earlierRank]
                local pass, reason = exhaustionPass(exhaustion[capability], picture, governingRequirementKey, capability)
                if not pass then
                    complete = false
                    missing[#missing + 1] = {capability=capability, reason=reason}
                end
            end
            if entry.candidate.capability == "ESCALATE" then
                local pass, reason = autonomousExhaustionPass(entry.metadata.autonomousSpaceExhaustion, picture, governingRequirementKey)
                if not pass then
                    complete = false
                    missing[#missing + 1] = {capability="COMPLETE_AUTONOMOUS_SPACE", reason=reason}
                end
            end
            if complete then
                selectable[#selectable + 1] = entry
            else
                blocked[#blocked + 1] = {candidateId=entry.candidate.identity, capability=entry.candidate.capability, missing=missing}
            end
        end
    end

    table.sort(selectable, compareCandidates)
    local selectedEntry=nil
    local cornerScoped=false
    local cornerRule=nil
    selectedEntry,cornerScoped,cornerRule=cornerRightOfWayChoice(selectable)

    local category2Scoped=false
    local category2Rule=nil
    if not cornerScoped then
        selectedEntry,category2Scoped,category2Rule=sharedCategory2Choice(selectable)
    end

    local selected=nil
    if cornerScoped then
        selected=selectedEntry and selectedEntry.candidate or nil
        if selected==nil then
            blocked[#blocked+1]={
                candidateId="SHARED_CORNER_ALLOCATION",
                capability="REGULATE_SPEED",
                missing={{capability="TEMPORARY_RIGHT_OF_WAY_ALLOCATION",reason=cornerRule}}
            }
        end
    elseif category2Scoped then
        selected=selectedEntry and selectedEntry.candidate or nil
        if selected==nil then
            blocked[#blocked+1]={
                candidateId="SHARED_CATEGORY_2_ALLOCATION",
                capability="REGULATE_SPEED",
                missing={{capability="TEMPORARY_BOUNDARY_DEMAND_ALLOCATION",reason=category2Rule}}
            }
        end
    else
        selected=selectable[1] and selectable[1].candidate or nil
    end
    local rankedSummary = {}
    for _, entry in OuttaMyWay.ValueRecord.ipairs(ranked) do
        rankedSummary[#rankedSummary + 1] = {
            candidateId=entry.candidate.identity,
            capability=entry.candidate.capability,
            preferenceRank=entry.rank,
            comparisonCost=entry.candidate.comparisonCost
        }
    end

    return {
        selected=selected,
        waitForPreferenceEvidence=selected==nil and #blocked>0,
        governingRequirementKey=governingRequirementKey,
        rule=cornerScoped and ("CORNER_RIGHT_OF_WAY:"..tostring(cornerRule))
            or (category2Scoped and ("SHARED_CATEGORY_2:"..tostring(category2Rule)) or Policy.KIND),
        ranked=rankedSummary,
        blocked=blocked
    }
end
