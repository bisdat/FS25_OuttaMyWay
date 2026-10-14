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
    state={loadCalls=0,deleteCalls=0,lastPath=nil,registeredKeys={}}
    getUserProfileAppPath=function() return options.profilePath or "/profile/" end
    fileExists=function(path)
        state.lastPath=path
        if options.fileCheckError then error("file check failed") end
        return options.exists==true
    end
    XMLValueType={BOOL="BOOL",INT="INT"}
    XMLSchema={
        new=function(name)
            if options.schemaError then error("schema failed") end
            return {
                register=function(self,valueType,key)
                    if options.registerError then error("register failed") end
                    assert(valueType==XMLValueType.BOOL or valueType==XMLValueType.INT)
                    state.registeredKeys[key]=valueType
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
                    if key=="outtaMyWayDiagnostics#settlementPrototype" then
                        return options.prototypeValue
                    end
                    if key=="outtaMyWayDiagnostics#spatialFarmlandId" then
                        return options.spatialValue
                    end
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
    equal(state.registeredKeys["outtaMyWayDiagnostics#enabled"],"BOOL")
    equal(state.registeredKeys["outtaMyWayDiagnostics#spatialFarmlandId"],"INT")
    equal(state.registeredKeys["outtaMyWayDiagnostics#settlementPrototype"],"BOOL")
    equal(source:isSettlementPrototypeEnabled(),false)
    local target,err=source:spatialTargetFarmlandId()
    equal(target,nil); equal(err,nil)
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

test("optional engineering spatial farmland target loads without changing diagnostic policy",function()
    installApi({exists=true,value=true,spatialValue=2})
    local source=OuttaMyWay.DiagnosticPublicationPolicySource.new("FS25_OuttaMyWay")
    equal(source:loadSidecar(),true)
    equal(source:publicationPolicy(),"DIAGNOSTIC")
    local target,err=source:spatialTargetFarmlandId()
    equal(target,2); equal(err,nil)
end)

test("invalid engineering spatial target does not silently select another field",function()
    installApi({exists=true,value=true,spatialValue=-7})
    local source=OuttaMyWay.DiagnosticPublicationPolicySource.new("FS25_OuttaMyWay")
    equal(source:loadSidecar(),true)
    equal(source:publicationPolicy(),"DIAGNOSTIC")
    local target,err=source:spatialTargetFarmlandId()
    equal(target,nil); equal(err,"SPATIAL_FARMLAND_ID_INVALID")
end)

test("physical TEST Control requires a second explicit true flag",function()
    installApi({exists=true,value=true,prototypeValue=true})
    local source=OuttaMyWay.DiagnosticPublicationPolicySource.new("FS25_OuttaMyWay")
    equal(source:loadSidecar(),true)
    equal(source:isSettlementPrototypeEnabled(),true)
    installApi({exists=true,value=false,prototypeValue=true})
    local other=OuttaMyWay.DiagnosticPublicationPolicySource.new("FS25_OuttaMyWay")
    equal(other:loadSidecar(),false)
    equal(other:isSettlementPrototypeEnabled(),false)
    installApi({exists=true,value=true,prototypeValue="true"})
    local invalid=OuttaMyWay.DiagnosticPublicationPolicySource.new("FS25_OuttaMyWay")
    local enabled,reason=invalid:loadSidecar()
    equal(enabled,false)
    equal(reason,"SETTLEMENT_PROTOTYPE_FLAG_INVALID")
    equal(invalid:isSettlementPrototypeEnabled(),false)
end)

print(string.format("RESULT %d passed / %d failed",passed,failed))
if failed>0 then os.exit(1) end
