local root=arg[1] or "."
local function load(p) dofile(root.."/"..p) end
OuttaMyWay={MOD_NAME="FS25_OuttaMyWay"}
load("scripts/diagnostics/DiagnosticPublicationPolicySource.lua")
local passed,failed=0,0
local function equal(a,b) if a~=b then error(tostring(a).." != "..tostring(b)) end end
local function test(name,fn)
    local ok,reason=pcall(fn)
    if ok then passed=passed+1; print("PASS "..name)
    else failed=failed+1; print("FAIL "..name..": "..tostring(reason)) end
end
local snapshot={}
local function setup(args)
    args=args or {}
    snapshot={loads=0,deletes=0,keys={}}
    getUserProfileAppPath=function() return args.profile or "/profile/" end
    fileExists=function(path)
        snapshot.path=path
        if args.fileError then error("file failed") end
        return args.exists==true
    end
    XMLValueType={BOOL="BOOL"}
    XMLSchema={new=function()
        if args.schemaError then error("schema") end
        return {register=function(_,kind,key)
            assert(kind=="BOOL"); snapshot.keys[key]=kind
        end}
    end}
    XMLFile={loadIfExists=function()
        snapshot.loads=snapshot.loads+1
        if args.unreadable then return nil end
        return {getValue=function(_,key)
            equal(key,"outtaMyWayDiagnostics#enabled")
            if args.readError then error("read") end
            return args.enabled
        end,
        delete=function() snapshot.deletes=snapshot.deletes+1 end}
    end}
end
test("absent sidecar stays NORMAL",function()
    setup({exists=false})
    local s=OuttaMyWay.DiagnosticPublicationPolicySource.new()
    local value,reason=s:loadSidecar()
    equal(value,false);equal(reason,"ABSENT")
    equal(s:publicationPolicy(),"NORMAL")
    equal(snapshot.path,"/profile/modSettings/FS25_OuttaMyWay/diagnostics.xml")
    equal(snapshot.loads,0)
end)
test("enabled sidecar changes only log publication",function()
    setup({exists=true,enabled=true})
    local s=OuttaMyWay.DiagnosticPublicationPolicySource.new()
    equal(s:loadSidecar(),true)
    equal(s:publicationPolicy(),"DIAGNOSTIC")
    equal(snapshot.keys["outtaMyWayDiagnostics#enabled"],"BOOL")
    equal(next(snapshot.keys),"outtaMyWayDiagnostics#enabled")
    equal(snapshot.deletes,1)
    equal(s.isSettlementPrototypeEnabled,nil)
    equal(s.isSpatialSurveyEnabled,nil)
    equal(s.spatialTargetFarmlandId,nil)
end)
test("disabled sidecar stays NORMAL",function()
    setup({exists=true,enabled=false})
    local s=OuttaMyWay.DiagnosticPublicationPolicySource.new()
    local b,reason=s:loadSidecar()
    equal(b,false);equal(reason,"DISABLED")
    equal(s:publicationPolicy(),"NORMAL")
end)
test("invalid publication sidecar fails closed",function()
    for _,opts in ipairs({
        {exists=true},{exists=true,enabled="true"},
        {exists=true,unreadable=true},{exists=true,readError=true}
    }) do
        setup(opts)
        local s=OuttaMyWay.DiagnosticPublicationPolicySource.new()
        equal(s:loadSidecar(),false)
        equal(s:publicationPolicy(),"NORMAL")
    end
end)
test("profile path failure fails closed",function()
    setup({exists=true,enabled=true})
    getUserProfileAppPath=nil
    local s=OuttaMyWay.DiagnosticPublicationPolicySource.new()
    local b,reason=s:loadSidecar()
    equal(b,false);equal(reason,"PROFILE_PATH_UNAVAILABLE")
end)
print(string.format("RESULT %d passed / %d failed",passed,failed))
if failed>0 then os.exit(1) end
