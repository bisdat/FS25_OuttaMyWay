OuttaMyWay.ProspectivePortfolioDecisionPolicy={}
local Policy=OuttaMyWay.ProspectivePortfolioDecisionPolicy
Policy.KIND="PROSPECTIVE_DECISION_PORTFOLIO_COMPATIBILITY"

local function groupsFor(inventory)
    local boundary=inventory and inventory.supportBoundary or nil
    if type(boundary)~="table" or boundary.mode~="PROSPECTIVE_DECISION_PORTFOLIO" then return {} end
    local result={}
    for _,group in OuttaMyWay.ValueRecord.ipairs(boundary.groups or {}) do result[#result+1]=group end
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

local function nearestPassage(groups)
    local passages=family(groups,"PASSAGE")
    table.sort(passages,function(a,b)
        local sa,sb=tonumber(a.initialSeparationM) or math.huge,tonumber(b.initialSeparationM) or math.huge
        if math.abs(sa-sb)>0.001 then return sa<sb end
        return tostring(a.conflictIdentity or a.groupKey)<tostring(b.conflictIdentity or b.groupKey)
    end)
    return passages[1]
end

local function samePair(follower,passage)
    if type(follower)~="table" or type(passage)~="table" then return false end
    local ids={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(passage.assemblyIds or {}) do ids[id]=true end
    return ids[follower.leaderAssemblyId]==true and ids[follower.followerAssemblyId]==true
end

local function choose(group,rule,detail)
    if group==nil then return nil end
    return {groupKey=group.groupKey,rule=rule,detail=detail,family=group.family}
end

function Policy:selectGroup(inventory)
    local groups=groupsFor(inventory)
    if #groups==0 then return nil end

    local obstruction=family(groups,"OBSTRUCTION_RELOCATION")[1]
    if obstruction~=nil then return choose(obstruction,"OUTER_PURPOSE_PRECEDENCE","CURRENT_CAUSAL_OBSTRUCTION_BEFORE_LIVE_TRAFFIC") end

    local followerFail=family(groups,"FOLLOWER_FAIL_CLOSED")[1]
    if followerFail~=nil then return choose(followerFail,"LEGACY_LIVE_TRAFFIC_FAIL_CLOSED","FOLLOWER_SAME_CLASS_AMBIGUITY_PRECEDES_OTHER_LIVE_TRAFFIC") end

    local followerRetire=family(groups,"FOLLOWER_RETIRE")[1]
    if followerRetire~=nil then return choose(followerRetire,"LEGACY_LIVE_TRAFFIC_PRECEDENCE","FOLLOWER_RETIREMENT_BEFORE_OTHER_LIVE_TRAFFIC") end

    local follower=family(groups,"FOLLOWER")[1]
    local passage=nearestPassage(groups)
    local actionFail=family(groups,"ACTION_SPACE_FAIL_CLOSED")[1]
    local actions=family(groups,"ACTION_SPACE")

    if follower~=nil then
        if passage~=nil then
            if samePair(follower,passage) then
                return choose(passage,"LEGACY_LIVE_TRAFFIC_COMPATIBILITY","SAME_PAIR_SUPPORTED_PASSAGE_SUCCEEDS_FRESH_FOLLOWER_PURPOSE")
            end
            return choose(follower,"LEGACY_LIVE_TRAFFIC_COMPATIBILITY","UNRELATED_SUPPORTED_PASSAGE_DOES_NOT_SUPERSEDE_FRESH_FOLLOWER_PURPOSE")
        end
        if actionFail~=nil then return choose(actionFail,"LEGACY_LIVE_TRAFFIC_FAIL_CLOSED","MULTIPLE_ACTION_SPACE_CONTEXTS_BEFORE_FOLLOWER_FALLBACK") end
        if #actions==1 then return choose(actions[1],"LEGACY_LIVE_TRAFFIC_COMPATIBILITY","ACTION_SPACE_REGULATION_BEFORE_FRESH_FOLLOWER_FALLBACK_WHEN_NO_PASSAGE") end
        return choose(follower,"LEGACY_LIVE_TRAFFIC_COMPATIBILITY","FRESH_FOLLOWER_FALLBACK")
    end

    local forwardFail=family(groups,"FORWARD_INTERSECTION_FAIL_CLOSED")[1]
    if forwardFail~=nil then return choose(forwardFail,"LEGACY_LIVE_TRAFFIC_FAIL_CLOSED","MULTIPLE_FORWARD_INTERSECTION_CONTEXTS") end
    local forward=family(groups,"FORWARD_INTERSECTION")[1]
    if forward~=nil then return choose(forward,"LEGACY_LIVE_TRAFFIC_COMPATIBILITY","FORWARD_INTERSECTION_BEFORE_PASSAGE_WITHOUT_FOLLOWER_PURPOSE") end

    if passage~=nil then return choose(passage,"LEGACY_LIVE_TRAFFIC_COMPATIBILITY","NEAREST_SUPPORTED_PASSAGE_BEFORE_ACTION_SPACE_REGULATION") end
    if actionFail~=nil then return choose(actionFail,"LEGACY_LIVE_TRAFFIC_FAIL_CLOSED","MULTIPLE_ACTION_SPACE_CONTEXTS") end
    if #actions==1 then return choose(actions[1],"LEGACY_LIVE_TRAFFIC_COMPATIBILITY","SINGLE_ACTION_SPACE_REGULATION") end

    local fallback=family(groups,"PASSIVE_FALLBACK")[1]
    if fallback~=nil then return choose(fallback,"PROSPECTIVE_PORTFOLIO_PASSIVE_FALLBACK","NO_FRESH_PHYSICAL_PURPOSE") end
    return nil
end
