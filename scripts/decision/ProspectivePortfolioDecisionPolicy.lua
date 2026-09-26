--- Chooses the governing support scope for one prospective portfolio using Decision-owned compatibility and precedence policy over mandatory-admissible alternatives.
-- Specification Jurisdictions: `DECISION`

OuttaMyWay.ProspectivePortfolioDecisionPolicy={}
local Policy=OuttaMyWay.ProspectivePortfolioDecisionPolicy
Policy.KIND="PROSPECTIVE_DECISION_PORTFOLIO_COMPATIBILITY"

local function candidateGroupKey(candidate)
    local group=candidate and candidate.evidenceBasis and candidate.evidenceBasis.candidateSupportGroup or nil
    return type(group)=="table" and group.groupKey or nil
end

local function admissibleGroupKeys(candidates)
    local result={}
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(candidates or {}) do
        local groupKey=candidateGroupKey(candidate)
        if type(groupKey)=="string" then result[groupKey]=true end
    end
    return result
end

local function groupsFor(inventory,admissibleCandidates)
    local boundary=inventory and inventory.supportBoundary or nil
    if type(boundary)~="table" or boundary.mode~="PROSPECTIVE_DECISION_PORTFOLIO" then return {} end
    local admissible=admissibleGroupKeys(admissibleCandidates)
    local result={}
    for _,group in OuttaMyWay.ValueRecord.ipairs(boundary.groups or {}) do
        if admissible[group.groupKey]==true then result[#result+1]=group end
    end
    return result
end

local function family(groups,name)
    local result={}
    for _,group in ipairs(groups) do if group.family==name then result[#result+1]=group end end
    table.sort(result,function(a,b)
        local ao,bo=tonumber(a.enumerationOrdinal) or math.huge,tonumber(b.enumerationOrdinal) or math.huge
        if ao~=bo then return ao<bo end
        return tostring(a.groupKey)<tostring(b.groupKey)
    end)
    return result
end

local function families(groups,names)
    local result={}
    for _,name in ipairs(names) do
        for _,group in ipairs(family(groups,name)) do result[#result+1]=group end
    end
    return result
end

local function choose(group,rule,detail)
    if group==nil then return nil end
    return {groupKey=group.groupKey,rule=rule,detail=detail,family=group.family}
end

local function retainedCurrentGroups(groups)
    local result={}
    for _,group in ipairs(groups) do
        if type(group.existingCommitmentId)=="string" then result[#result+1]=group end
    end
    table.sort(result,function(a,b) return tostring(a.groupKey)<tostring(b.groupKey) end)
    return result
end

function Policy:selectGroup(inventory,admissibleCandidates)
    local groups=groupsFor(inventory,admissibleCandidates)
    if #groups==0 then return nil,"NO_MANDATORY_ADMISSIBLE_SUPPORT_GROUP" end

    local recoveries=family(groups,"RECOVERY")
    if #recoveries>1 then return nil,"MULTIPLE_SUPPORTED_RECOVERIES_REQUIRE_COMPARATOR" end
    if #recoveries==1 then
        local recovery=recoveries[1]
        local others={}
        for _,group in ipairs(groups) do if group.groupKey~=recovery.groupKey then others[#others+1]=group end end
        local onlyRetained=true
        for _,group in ipairs(others) do
            if type(group.existingCommitmentId)~="string" then onlyRetained=false break end
        end
        if #others==0 or onlyRetained then
            return choose(recovery,"BLOCKED_WORKER_RECOVERY_ESTABLISHMENT","SUPPORTED_RECOVERY_WITH_NO_FRESH_CROSS_PURPOSE_COMPETITOR")
        end
        return nil,"RECOVERY_WITH_FRESH_CROSS_PURPOSE_REQUIRES_COMPARATOR"
    end

    local obstruction=family(groups,"OBSTRUCTION_RELOCATION")[1]
    if obstruction~=nil then
        return choose(obstruction,"OUTER_PURPOSE_PRECEDENCE","CURRENT_CAUSAL_OBSTRUCTION_BEFORE_LIVE_TRAFFIC")
    end

    -- Spatial Negotiation is a stage transition, not a peer-purpose ordering:
    -- once one Cooperative Passage is supported and mandatory-admissible,
    -- tactical Regulation has completed its job and must not pre-empt Passage.
    local passages=family(groups,"PASSAGE")
    if #passages==1 then
        return choose(passages[1],"SPATIAL_NEGOTIATION_STAGE_TRANSITION","SUPPORTED_ADMISSIBLE_PASSAGE_ENDS_TACTICAL_REGULATION")
    end
    if #passages>1 then
        return nil,"MULTIPLE_SUPPORTED_ADMISSIBLE_PASSAGES_REQUIRE_COMPARATOR"
    end

    -- A live tactical Regulation remains the governing stage-2 purpose when no
    -- Passage is yet viable. Portfolio enumeration must not manufacture a new
    -- cross-purpose switch merely because fresh alternatives coexist.
    local retained=retainedCurrentGroups(groups)
    if #retained==1 then
        return choose(retained[1],"RETAIN_CURRENT_TACTICAL_REGULATION","NO_SUPPORTED_ADMISSIBLE_PASSAGE_AND_CURRENT_REGULATION_REMAINS_ADMISSIBLE")
    end
    if #retained>1 then
        return nil,"MULTIPLE_RETAINED_TACTICAL_REGULATION_GROUPS"
    end

    -- Corner allocation remains an explicitly architected tactical Regulation
    -- decision domain while no viable Passage has yet been reached.
    local cornerFail=family(groups,"CORNER_FAIL_CLOSED")[1]
    if cornerFail~=nil then
        return choose(cornerFail,"CORNER_DECISION_DOMAIN_FAIL_CLOSED","SHARED_CORNER_ALLOCATION_AMBIGUITY_PRECEDES_NON_CORNER_LIVE_TRAFFIC")
    end

    local corner=family(groups,"CORNER_RIGHT_OF_WAY")[1]
    if corner~=nil then
        return choose(corner,"CORNER_DECISION_DOMAIN_PRECEDENCE","ADMITTED_SHARED_CORNER_COMPETING_DEMAND_OWNS_DECISION_DOMAIN")
    end

    -- Same-class ambiguity is fail-closed support meaning, not a preference
    -- among otherwise supportable tactical purposes.
    local failClosed=families(groups,{
        "FOLLOWER_FAIL_CLOSED",
        "FORWARD_INTERSECTION_FAIL_CLOSED",
        "ACTION_SPACE_FAIL_CLOSED"
    })
    if #failClosed==1 then
        return choose(failClosed[1],"TACTICAL_SUPPORT_FAIL_CLOSED",failClosed[1].failClosedReason or "TACTICAL_SUPPORT_AMBIGUITY")
    end
    if #failClosed>1 then
        return nil,"MULTIPLE_TACTICAL_SUPPORT_AMBIGUITIES"
    end

    -- Without Passage or a Corner-owned allocation, current Architecture does
    -- not define a cross-family preference among independent tactical
    -- Regulation purposes. One unambiguous purpose may proceed; several must
    -- remain explicit non-selection rather than recreate legacy ordering.
    local tactical=families(groups,{
        "FOLLOWER_RETIRE",
        "FOLLOWER",
        "FORWARD_INTERSECTION",
        "ACTION_SPACE"
    })
    if #tactical==1 then
        return choose(tactical[1],"TACTICAL_REGULATION_SINGLE_PURPOSE","ONLY_SUPPORTED_ADMISSIBLE_TACTICAL_REGULATION_PURPOSE")
    end
    if #tactical>1 then
        return nil,"MULTIPLE_TACTICAL_REGULATION_PURPOSES_REQUIRE_COMPARATOR"
    end

    local fallback=family(groups,"PASSIVE_FALLBACK")[1]
    if fallback~=nil then
        return choose(fallback,"PROSPECTIVE_PORTFOLIO_PASSIVE_FALLBACK","NO_FRESH_PHYSICAL_PURPOSE")
    end
    return nil,"NO_COMPATIBLE_GOVERNING_SUPPORT_GROUP"
end
