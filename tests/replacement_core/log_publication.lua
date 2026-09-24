local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay={}
load("scripts/config.lua")
load("scripts/publication/LogPublication.lua")

local calls={}
Logging={
    info=function(formatText,message) calls[#calls+1]={method="info",message=string.format(formatText,message)} end,
    warning=function(formatText,message) calls[#calls+1]={method="warning",message=string.format(formatText,message)} end,
    error=function(formatText,message) calls[#calls+1]={method="error",message=string.format(formatText,message)} end
}

local policy="NORMAL"
local publisher=OuttaMyWay.LogPublication.new(function() return policy end)
OuttaMyWay.logPublication=publisher
local origin=OuttaMyWay.LogPublication.origin("LOG_PUBLICATION_TEST")

local passed,failed=0,0
local function test(name,fn)
    local ok,err=pcall(fn)
    if ok then passed=passed+1; print("PASS "..name)
    else failed=failed+1; print("FAIL "..name..": "..tostring(err)) end
end
local function equal(a,b,message)
    if a~=b then error(message or (tostring(a).." ~= "..tostring(b))) end
end
local function contains(text,needle)
    if string.find(text,needle,1,true)==nil then error("missing "..needle.." in "..tostring(text)) end
end

test("NORMAL publishes NORMAL and suppresses higher classes before payload construction",function()
    calls={}
    policy="NORMAL"
    local built=0
    local ok,reason=origin:publish("DEBUG","INFO","DEBUG_EVENT",function() built=built+1; return {detail="hidden"} end)
    equal(ok,false); equal(reason,"SUPPRESSED"); equal(built,0); equal(#calls,0)
    ok,reason=origin:publish("NORMAL","INFO","NORMAL_EVENT",function() built=built+1; return {operation="OP-1",field=77,detail="visible"} end)
    equal(ok,true); equal(reason,"PUBLISHED"); equal(built,1); equal(#calls,1)
    contains(calls[1].message,"[NORMAL][INFO][LOG_PUBLICATION_TEST][NORMAL_EVENT]")
    contains(calls[1].message,"operation=OP-1 field=77 visible")
end)

test("DEBUG is cumulative but does not admit DIAGNOSTIC warning",function()
    calls={}
    policy="DEBUG"
    origin:info("NORMAL","NORMAL_EVENT","normal=%s","yes")
    origin:info("DEBUG","DEBUG_EVENT","debug=%s","yes")
    local built=0
    local ok,reason=origin:publish("DIAGNOSTIC","WARNING","DIAGNOSTIC_WARNING",function() built=built+1; return "no" end)
    equal(ok,false); equal(reason,"SUPPRESSED"); equal(built,0); equal(#calls,2)
end)

test("DIAGNOSTIC admits all classes and severity selects destination",function()
    calls={}
    policy="DIAGNOSTIC"
    origin:info("NORMAL","NORMAL_EVENT","n=1")
    origin:warning("DEBUG","DEBUG_WARNING","d=1")
    origin:error("DIAGNOSTIC","DIAGNOSTIC_ERROR","x=1")
    equal(#calls,3)
    equal(calls[1].method,"info"); equal(calls[2].method,"warning"); equal(calls[3].method,"error")
end)

test("payload context rendering is deterministic and one-line",function()
    calls={}
    policy="NORMAL"
    origin:publish("NORMAL","INFO","CONTEXT_EVENT",function()
        return {zeta="z",field=12,operation="OP-4",alpha="a",detail="first\nsecond"}
    end)
    equal(#calls,1)
    contains(calls[1].message,"operation=OP-4 field=12 alpha=a zeta=z first\\nsecond")
    if string.find(calls[1].message,"\n",1,true)~=nil then error("publication emitted literal newline") end
end)

test("payload failure is isolated from semantic caller",function()
    calls={}
    policy="NORMAL"
    local ok,reason=origin:publish("NORMAL","INFO","PAYLOAD_FAILURE",function() error("boom") end)
    equal(ok,false); equal(reason,"PAYLOAD_BUILD_FAILED"); equal(#calls,0)
end)

test("policy is resolved dynamically",function()
    calls={}
    policy="NORMAL"
    local ok=origin:info("DEBUG","DEBUG_EVENT","hidden")
    equal(ok,false); equal(#calls,0)
    policy="DEBUG"
    ok=origin:info("DEBUG","DEBUG_EVENT","visible")
    equal(ok,true); equal(#calls,1)
end)

test("eligibility can gate publication-only work before construction",function()
    calls={}
    policy="NORMAL"
    local eligible,reason=origin:isEligible("DIAGNOSTIC","INFO","EXPENSIVE_DIAGNOSTIC")
    equal(eligible,false); equal(reason,"SUPPRESSED")
    policy="DIAGNOSTIC"
    eligible,reason=origin:isEligible("DIAGNOSTIC","INFO","EXPENSIVE_DIAGNOSTIC")
    equal(eligible,true); equal(reason,nil)
end)

test("event codes are readable semantic identifiers",function()
    local event=OuttaMyWay.LogPublication.event("REGULATION_STARTED","NORMAL","INFO","RESPONSIBILITY_TRANSITION")
    equal(event.code,"REGULATION_STARTED")
    local ok=pcall(function() OuttaMyWay.LogPublication.event("L-001","NORMAL","INFO","RESPONSIBILITY_TRANSITION") end)
    equal(ok,false)
end)

print(string.format("RESULT %d passed / %d failed",passed,failed))
if failed>0 then os.exit(1) end
