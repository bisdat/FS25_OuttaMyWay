local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay={MOD_NAME="FS25_OuttaMyWay"}
load("scripts/configuration/Configuration.lua")

local passed,failed=0,0
local function test(name,fn)
    local ok,err=pcall(fn)
    if ok then passed=passed+1; print("PASS "..name)
    else failed=failed+1; print("FAIL "..name..": "..tostring(err)) end
end
local function equal(a,b,message)
    if a~=b then error(message or (tostring(a).." ~= "..tostring(b))) end
end

local fs={}
local function installApi(options)
    options=options or {}
    fs={exists=options.exists==true,writes={},saveCalls=0,deleteCalls=0,createCalls=0,loadCalls=0}
    getUserProfileAppPath=function() return options.profilePath or "/profile/" end
    createFolder=function(path)
        if options.folderError then error("folder failure") end
        fs.createdFolder=path
    end
    fileExists=function(path)
        if options.fileCheckError then error("file check failure") end
        fs.checkedPath=path
        return fs.exists
    end
    XMLValueType={INT="INT",BOOL="BOOL"}
    XMLSchema={new=function(name)
        return {register=function(self,valueType,key)
            if options.schemaError then error("schema failure") end
        end}
    end}
    local function xmlObject(values)
        return {
            getValue=function(self,key)
                if options.readError then error("read failure") end
                return values and values[key] or nil
            end,
            setValue=function(self,key,value)
                if options.writeError then error("write failure") end
                fs.writes[key]=value
            end,
            save=function(self)
                fs.saveCalls=fs.saveCalls+1
                if options.saveError then error("save failure") end
                if options.saveFalse then return false end
                return true
            end,
            delete=function(self) fs.deleteCalls=fs.deleteCalls+1 end
        }
    end
    XMLFile={
        loadIfExists=function(id,path,schema)
            fs.loadCalls=fs.loadCalls+1
            if options.loadError then error("load failure") end
            if options.loadNil then return nil end
            return xmlObject(options.values)
        end,
        create=function(id,path,rootKey,schema)
            fs.createCalls=fs.createCalls+1
            if options.createNil then return nil end
            return xmlObject({})
        end
    }
end

local VALID_DISABLED={
    ["outtaMyWayConfiguration#schemaVersion"]=1,
    ["outtaMyWayConfiguration.settings#enabled"]=false,
    ["outtaMyWayConfiguration.settings#hudVisible"]=true,
    ["outtaMyWayConfiguration.settings#debug"]=true
}
local VALID_ENABLED={
    ["outtaMyWayConfiguration#schemaVersion"]=1,
    ["outtaMyWayConfiguration.settings#enabled"]=true,
    ["outtaMyWayConfiguration.settings#hudVisible"]=true,
    ["outtaMyWayConfiguration.settings#debug"]=false
}

test("first use creates and persists accepted defaults",function()
    installApi({exists=false})
    local c=OuttaMyWay.Configuration.new("FS25_OuttaMyWay")
    local ok,reason=c:resolvePersistedState()
    equal(ok,true); equal(reason,"DEFAULTS_CREATED")
    equal(c:isEnabled(),true); equal(c:isHudVisible(),true); equal(c:isDebugEnabled(),false)
    equal(fs.checkedPath,"/profile/modSettings/FS25_OuttaMyWay/configuration.xml")
    equal(fs.writes["outtaMyWayConfiguration#schemaVersion"],1)
    equal(fs.writes["outtaMyWayConfiguration.settings#enabled"],true)
    equal(fs.writes["outtaMyWayConfiguration.settings#hudVisible"],true)
    equal(fs.writes["outtaMyWayConfiguration.settings#debug"],false)
    equal(fs.saveCalls,1)
end)

test("valid current representation becomes semantic state",function()
    installApi({exists=true,values=VALID_DISABLED})
    local c=OuttaMyWay.Configuration.new("FS25_OuttaMyWay")
    local ok,reason=c:resolvePersistedState()
    equal(ok,true); equal(reason,"LOADED")
    equal(c:isEnabled(),false); equal(c:isHudVisible(),true); equal(c:isDebugEnabled(),true)
    equal(fs.createCalls,0)
end)

test("unsupported schema resets all values to defaults and overwrites",function()
    local values={}
    for k,v in pairs(VALID_DISABLED) do values[k]=v end
    values["outtaMyWayConfiguration#schemaVersion"]=2
    installApi({exists=true,values=values})
    local c=OuttaMyWay.Configuration.new("FS25_OuttaMyWay")
    local ok,reason=c:resolvePersistedState()
    equal(ok,true); equal(reason,"DEFAULTS_RECOVERED")
    equal(c:isEnabled(),true); equal(c:isHudVisible(),true); equal(c:isDebugEnabled(),false)
    equal(fs.createCalls,1); equal(fs.saveCalls,1)
end)

test("malformed existing representation recovers by overwrite",function()
    installApi({exists=true,loadNil=true})
    local c=OuttaMyWay.Configuration.new("FS25_OuttaMyWay")
    local ok,reason=c:resolvePersistedState()
    equal(ok,true); equal(reason,"DEFAULTS_RECOVERED")
    equal(c:isEnabled(),true); equal(fs.createCalls,1)
end)

test("unreadable existing representation still attempts default overwrite",function()
    installApi({exists=true,loadError=true})
    local c=OuttaMyWay.Configuration.new("FS25_OuttaMyWay")
    local ok,reason=c:resolvePersistedState()
    equal(ok,true); equal(reason,"DEFAULTS_RECOVERED")
    equal(c:isEnabled(),true); equal(fs.createCalls,1)
end)

test("storage failure leaves Configuration unresolved",function()
    installApi({exists=false,createNil=true})
    local c=OuttaMyWay.Configuration.new("FS25_OuttaMyWay")
    local ok,reason=c:resolvePersistedState()
    equal(ok,false); equal(reason,"XML_CREATE_FAILED")
    equal(c:isResolved(),false); equal(c:isEnabled(),nil)
end)

test("disablement remains effective when persistence fails",function()
    installApi({exists=true,values=VALID_ENABLED})
    local c=OuttaMyWay.Configuration.new("FS25_OuttaMyWay")
    equal(c:resolvePersistedState(),true)
    local notification=nil
    c:addChangeListener(function(n) notification=n end)
    XMLFile.create=function() return {
        setValue=function() end,
        save=function() return false end,
        delete=function() end
    } end
    local ok,reason=c:setEnabled(false)
    equal(ok,false); equal(reason,"XML_SAVE_FAILED")
    equal(c:isEnabled(),false)
    equal(notification.name,"enabled"); equal(notification.value,false); equal(notification.durable,false)
end)

test("failed re-enable does not become effective",function()
    installApi({exists=true,values=VALID_DISABLED})
    local c=OuttaMyWay.Configuration.new("FS25_OuttaMyWay")
    equal(c:resolvePersistedState(),true)
    XMLFile.create=function() return {
        setValue=function() end,
        save=function() return false end,
        delete=function() end
    } end
    local ok,reason=c:setEnabled(true)
    equal(ok,false); equal(reason,"XML_SAVE_FAILED")
    equal(c:isEnabled(),false)
end)

test("debug changes current session and reports non-durable failure",function()
    installApi({exists=true,values=VALID_ENABLED})
    local c=OuttaMyWay.Configuration.new("FS25_OuttaMyWay")
    equal(c:resolvePersistedState(),true)
    local notification=nil
    c:addChangeListener(function(n) notification=n end)
    XMLFile.create=function() return {
        setValue=function() end,
        save=function() return false end,
        delete=function() end
    } end
    local ok,reason=c:setDebugEnabled(true)
    equal(ok,false); equal(reason,"XML_SAVE_FAILED")
    equal(c:isDebugEnabled(),true)
    equal(notification.name,"debug"); equal(notification.value,true); equal(notification.durable,false)
end)

print(string.format("RESULT %d passed / %d failed",passed,failed))
if failed>0 then os.exit(1) end
