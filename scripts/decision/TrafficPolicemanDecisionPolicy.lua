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
        rule=cornerScoped and ("CORNER_RIGHT_OF_WAY:"..tostring(cornerRule)) or Policy.KIND,
        ranked=rankedSummary,
        blocked=blocked
    }
end
