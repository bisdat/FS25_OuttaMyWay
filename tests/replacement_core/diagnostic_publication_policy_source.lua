local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay={MOD_NAME="FS25_OuttaMyWay"}
load("scripts/diagnostics/DiagnosticPublicationPolicySource.lua")

local passed,failed=0,0
local function test(name,fn)
    local ok,err=pcall(fn)
    if ok then passed=passed+1; print("PASS "..name)
    else failed=failed+1; print("FAIL "..name..": "..tostring(err)) end
end
local function equal(a,b,message)
    if a~=b then error(message or (tostring(a).." ~= "..tostring(b))) end
end

local state={}
local function installApi(options)
    options=options or {}
    state={loadCalls=0,deleteCalls=0,lastPath=nil,registeredKey=nil}
    getUserProfileAppPath=function() return options.profilePath or "/profile/" end
    fileExists=function(path)
        state.lastPath=path
        if options.fileCheckError then error("file check failed") end
        return options.exists==true
    end
    XMLValueType={BOOL="BOOL"}
    XMLSchema={
        new=function(name)
            if options.schemaError then error("schema failed") end
            return {
                register=function(self,valueType,key)
                    if options.registerError then error("register failed") end
                    equal(valueType,XMLValueType.BOOL)
                    state.registeredKey=key
                end
            }
        end
    }
    XMLFile={
        loadIfExists=function(id,path,schema)
            state.loadCalls=state.loadCalls+1
            if options.loadError then error("load failed") end
            if options.loadNil then return nil end
            return {
                getValue=function(self,key)
                    if options.valueError then error("value failed") end
                    return options.value
                end,
                delete=function(self) state.deleteCalls=state.deleteCalls+1 end
            }
        end
    }
end

test("absent sidecar resolves NORMAL without creating or loading XML",function()
    installApi({exists=false,value=true})
    local source=OuttaMyWay.DiagnosticPublicationPolicySource.new("FS25_OuttaMyWay")
    local enabled,reason=source:loadSidecar()
    equal(enabled,false); equal(reason,"ABSENT")
    equal(source:publicationPolicy(),"NORMAL")
    equal(state.lastPath,"/profile/modSettings/FS25_OuttaMyWay/diagnostics.xml")
    equal(state.loadCalls,0)
end)

test("valid enabled sidecar resolves DIAGNOSTIC",function()
    installApi({exists=true,value=true})
    local source=OuttaMyWay.DiagnosticPublicationPolicySource.new("FS25_OuttaMyWay")
    local enabled,reason=source:loadSidecar()
    equal(enabled,true); equal(reason,"ENABLED")
    equal(source:publicationPolicy(),"DIAGNOSTIC")
    equal(state.registeredKey,"outtaMyWayDiagnostics#enabled")
    equal(state.loadCalls,1); equal(state.deleteCalls,1)
end)

test("valid disabled sidecar resolves NORMAL",function()
    installApi({exists=true,value=false})
    local source=OuttaMyWay.DiagnosticPublicationPolicySource.new("FS25_OuttaMyWay")
    local enabled,reason=source:loadSidecar()
    equal(enabled,false); equal(reason,"DISABLED")
    equal(source:publicationPolicy(),"NORMAL")
    equal(state.deleteCalls,1)
end)

test("missing or invalid enabled value fails safe to NORMAL",function()
    installApi({exists=true,value=nil})
    local source=OuttaMyWay.DiagnosticPublicationPolicySource.new("FS25_OuttaMyWay")
    local enabled,reason=source:loadSidecar()
    equal(enabled,false); equal(reason,"INVALID_OR_UNREADABLE")
    equal(source:publicationPolicy(),"NORMAL")
    equal(state.deleteCalls,1)
end)

test("unreadable XML fails safe to NORMAL",function()
    installApi({exists=true,loadNil=true})
    local source=OuttaMyWay.DiagnosticPublicationPolicySource.new("FS25_OuttaMyWay")
    local enabled,reason=source:loadSidecar()
    equal(enabled,false); equal(reason,"INVALID_OR_UNREADABLE")
    equal(source:publicationPolicy(),"NORMAL")
end)

test("profile path failure fails safe to NORMAL",function()
    installApi({exists=true,value=true})
    getUserProfileAppPath=nil
    local source=OuttaMyWay.DiagnosticPublicationPolicySource.new("FS25_OuttaMyWay")
    local enabled,reason=source:loadSidecar()
    equal(enabled,false); equal(reason,"PROFILE_PATH_UNAVAILABLE")
    equal(source:publicationPolicy(),"NORMAL")
end)

print(string.format("RESULT %d passed / %d failed",passed,failed))
if failed>0 then os.exit(1) end
