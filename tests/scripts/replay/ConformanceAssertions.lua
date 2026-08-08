OuttaMyWay.ConformanceAssertions = {}
local Assertions = OuttaMyWay.ConformanceAssertions

local function plain(value,seen)
    local kind=type(value)
    if kind~="table" then return value end
    seen=seen or {}; if seen[value] then error("cyclic replay value",3) end; seen[value]=true
    local recordType=OuttaMyWay.ValueRecord.typeOf(value)
    if recordType~=nil and recordType~="ValueTable" then value=OuttaMyWay.ValueRecord.toTable(value) end
    local result={}; for key,item in OuttaMyWay.ValueRecord.pairs(value) do result[key]=plain(item,seen) end
    seen[value]=nil; return result
end

local function pathValue(value,path)
    local current=value
    for segment in string.gmatch(path,"[^%.]+") do
        if type(current)~="table" then return nil end
        local numeric=tonumber(segment)
        current=current[numeric or segment]
    end
    return current
end

local function equivalent(actual,expected)
    if type(expected)~="table" then return actual==expected end
    if type(actual)~="table" then return false end
    for key,value in OuttaMyWay.ValueRecord.pairs(expected) do if not equivalent(actual[key],value) then return false end end
    return true
end

function Assertions.check(actual,expectations)
    actual=plain(actual)
    local paths={}; for path,_ in OuttaMyWay.ValueRecord.pairs(expectations or {}) do paths[#paths+1]=path end; table.sort(paths)
    for _,path in OuttaMyWay.ValueRecord.ipairs(paths) do
        local observed=pathValue(actual,path); local expected=expectations[path]
        if not equivalent(observed,expected) then
            return false,string.format("%s expected %s observed %s",path,tostring(expected),tostring(observed))
        end
    end
    return true,nil
end
function Assertions.plain(value) return plain(value) end
