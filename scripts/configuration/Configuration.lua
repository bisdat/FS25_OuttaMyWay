--- Owns supported local-profile player Configuration state and its durable modSettings representation.
-- Specification Jurisdictions: `CONFIGURATION`

OuttaMyWay.Configuration = {}
local Configuration=OuttaMyWay.Configuration
Configuration.__index=Configuration

local SCHEMA_VERSION=1
local ROOT_KEY="outtaMyWayConfiguration"
local SETTINGS_KEY=ROOT_KEY..".settings"
local VERSION_KEY=ROOT_KEY.."#schemaVersion"
local ENABLED_KEY=SETTINGS_KEY.."#enabled"
local HUD_VISIBLE_KEY=SETTINGS_KEY.."#hudVisible"
local DEBUG_KEY=SETTINGS_KEY.."#debug"
local FILE_NAME="configuration.xml"
local XML_FILE_ID="outtaMyWayConfiguration"

local DEFAULTS={
    enabled=true,
    hudVisible=true,
    debug=false
}

local function copyState(state)
    return {
        enabled=state.enabled==true,
        hudVisible=state.hudVisible==true,
        debug=state.debug==true
    }
end

local function resolvePaths(modName)
    if type(getUserProfileAppPath)~="function" then return nil,nil,"PROFILE_PATH_UNAVAILABLE" end
    local ok,profilePath=pcall(getUserProfileAppPath)
    if not ok or type(profilePath)~="string" or profilePath=="" then
        return nil,nil,"PROFILE_PATH_UNAVAILABLE"
    end
    local last=string.sub(profilePath,-1)
    local separator=(last=="/" or last=="\\") and "" or "/"
    local directory=profilePath..separator.."modSettings/"..modName.."/"
    return directory,directory..FILE_NAME,nil
end

local function createSchema()
    if type(XMLValueType)~="table"
        or XMLValueType.INT==nil
        or XMLValueType.BOOL==nil
        or type(XMLSchema)~="table"
        or type(XMLSchema.new)~="function" then
        return nil,"XML_SCHEMA_API_UNAVAILABLE"
    end

    local ok,schema=pcall(XMLSchema.new,"OuttaMyWayConfiguration")
    if not ok or schema==nil or type(schema.register)~="function" then
        return nil,"XML_SCHEMA_UNAVAILABLE"
    end

    local registrations={
        {XMLValueType.INT,VERSION_KEY},
        {XMLValueType.BOOL,ENABLED_KEY},
        {XMLValueType.BOOL,HUD_VISIBLE_KEY},
        {XMLValueType.BOOL,DEBUG_KEY}
    }
    for _,registration in ipairs(registrations) do
        local registered=pcall(schema.register,schema,registration[1],registration[2])
        if not registered then return nil,"XML_SCHEMA_REGISTRATION_FAILED" end
    end
    return schema,nil
end

local function releaseXml(xmlFile)
    if xmlFile~=nil and type(xmlFile.delete)=="function" then pcall(xmlFile.delete,xmlFile) end
end

function Configuration.new(modName)
    local resolvedModName=modName or OuttaMyWay.MOD_NAME or g_currentModName or "FS25_OuttaMyWay"
    return setmetatable({
        modName=resolvedModName,
        directoryPath=nil,
        filePath=nil,
        state=copyState(DEFAULTS),
        resolved=false,
        durable=false,
        lastStorageReason="NOT_RESOLVED",
        listeners={}
    },Configuration)
end

function Configuration:_ensurePersistenceLocation()
    local directory,filePath,pathReason=resolvePaths(self.modName)
    self.directoryPath=directory
    self.filePath=filePath
    if directory==nil then return false,pathReason end
    if type(createFolder)~="function" then return false,"CREATE_FOLDER_API_UNAVAILABLE" end
    local ok=pcall(createFolder,directory)
    if not ok then return false,"CREATE_FOLDER_FAILED" end
    return true,nil
end

function Configuration:_writeState(state)
    if self.filePath==nil then return false,"PERSISTENCE_PATH_UNAVAILABLE" end
    if type(XMLFile)~="table" or type(XMLFile.create)~="function" then
        return false,"XML_CREATE_API_UNAVAILABLE"
    end
    local schema,schemaReason=createSchema()
    if schema==nil then return false,schemaReason end

    local createOk,xmlFile=pcall(XMLFile.create,XML_FILE_ID,self.filePath,ROOT_KEY,schema)
    if not createOk or xmlFile==nil then return false,"XML_CREATE_FAILED" end

    local function setValue(key,value)
        if type(xmlFile.setValue)~="function" then return false end
        return pcall(xmlFile.setValue,xmlFile,key,value)
    end

    local valuesWritten=
        setValue(VERSION_KEY,SCHEMA_VERSION)
        and setValue(ENABLED_KEY,state.enabled)
        and setValue(HUD_VISIBLE_KEY,state.hudVisible)
        and setValue(DEBUG_KEY,state.debug)
    if not valuesWritten then
        releaseXml(xmlFile)
        return false,"XML_WRITE_FAILED"
    end

    if type(xmlFile.save)~="function" then
        releaseXml(xmlFile)
        return false,"XML_SAVE_API_UNAVAILABLE"
    end
    local saveOk,saveResult=pcall(xmlFile.save,xmlFile)
    releaseXml(xmlFile)
    if not saveOk or saveResult==false then return false,"XML_SAVE_FAILED" end
    return true,"PERSISTED"
end

function Configuration:_readState()
    if type(XMLFile)~="table" or type(XMLFile.loadIfExists)~="function" then
        return nil,"XML_LOAD_API_UNAVAILABLE",false
    end
    local schema,schemaReason=createSchema()
    if schema==nil then return nil,schemaReason,false end

    local loadOk,xmlFile=pcall(XMLFile.loadIfExists,XML_FILE_ID,self.filePath,schema)
    if not loadOk then return nil,"XML_LOAD_FAILED",false end
    if xmlFile==nil then return nil,"INVALID_OR_UNREADABLE",true end
    if type(xmlFile.getValue)~="function" then
        releaseXml(xmlFile)
        return nil,"XML_READ_API_UNAVAILABLE",false
    end

    local function readValue(key)
        local ok,value=pcall(xmlFile.getValue,xmlFile,key)
        if not ok then return nil,false end
        return value,true
    end

    local version,versionOk=readValue(VERSION_KEY)
    local enabled,enabledOk=readValue(ENABLED_KEY)
    local hudVisible,hudOk=readValue(HUD_VISIBLE_KEY)
    local debug,debugOk=readValue(DEBUG_KEY)
    releaseXml(xmlFile)

    if not versionOk or not enabledOk or not hudOk or not debugOk then
        return nil,"XML_READ_FAILED",false
    end
    if type(version)~="number" then return nil,"INVALID_SCHEMA_VERSION",true end
    if version~=SCHEMA_VERSION then return nil,"UNSUPPORTED_SCHEMA",true end
    if type(enabled)~="boolean" or type(hudVisible)~="boolean" or type(debug)~="boolean" then
        return nil,"INVALID_CONFIGURATION_VALUES",true
    end

    return {enabled=enabled,hudVisible=hudVisible,debug=debug},"LOADED",false
end

function Configuration:_acceptResolvedState(state,reason)
    self.state=copyState(state)
    self.resolved=true
    self.durable=true
    self.lastStorageReason=reason
end

function Configuration:resolvePersistedState()
    self.resolved=false
    self.durable=false

    local locationOk,locationReason=self:_ensurePersistenceLocation()
    if not locationOk then
        self.lastStorageReason=locationReason
        return false,locationReason
    end
    if type(fileExists)~="function" then
        self.lastStorageReason="FILE_EXISTS_API_UNAVAILABLE"
        return false,self.lastStorageReason
    end

    local existsOk,exists=pcall(fileExists,self.filePath)
    if not existsOk then
        self.lastStorageReason="FILE_CHECK_FAILED"
        return false,self.lastStorageReason
    end

    if exists~=true then
        local defaults=copyState(DEFAULTS)
        local persisted,persistReason=self:_writeState(defaults)
        if not persisted then
            self.lastStorageReason=persistReason
            return false,persistReason
        end
        self:_acceptResolvedState(defaults,"DEFAULTS_CREATED")
        return true,"DEFAULTS_CREATED"
    end

    local state,readReason,recoverable=self:_readState()
    if state~=nil then
        self:_acceptResolvedState(state,readReason)
        return true,readReason
    end
    if not recoverable then
        self.lastStorageReason=readReason
        return false,readReason
    end

    local defaults=copyState(DEFAULTS)
    local persisted,persistReason=self:_writeState(defaults)
    if not persisted then
        self.lastStorageReason=persistReason
        return false,persistReason
    end
    self:_acceptResolvedState(defaults,"DEFAULTS_RECOVERED")
    return true,"DEFAULTS_RECOVERED"
end

function Configuration:isResolved()
    return self.resolved==true
end

function Configuration:isEnabled()
    if not self.resolved then return nil end
    return self.state.enabled
end

function Configuration:isHudVisible()
    if not self.resolved then return nil end
    return self.state.hudVisible
end

function Configuration:isDebugEnabled()
    if not self.resolved then return nil end
    return self.state.debug
end

function Configuration:addChangeListener(listener)
    if type(listener)~="function" then return false,"LISTENER_INVALID" end
    self.listeners[#self.listeners+1]=listener
    return true,"LISTENER_ADDED"
end

function Configuration:_notify(name,value,durable,storageReason)
    local notification={
        name=name,
        value=value,
        durable=durable==true,
        storageReason=storageReason
    }
    for _,listener in ipairs(self.listeners) do pcall(listener,notification) end
end

function Configuration:_setImmediateValue(name,value)
    if not self.resolved then return false,"CONFIGURATION_UNRESOLVED" end
    if type(value)~="boolean" then return false,"INVALID_VALUE" end
    if self.state[name]==value then return true,"UNCHANGED" end

    self.state[name]=value
    local persisted,persistReason=self:_writeState(self.state)
    self.durable=persisted==true
    self.lastStorageReason=persistReason
    self:_notify(name,value,persisted,persistReason)
    if not persisted then return false,persistReason end
    return true,"PERSISTED"
end

function Configuration:setEnabled(value)
    if not self.resolved then return false,"CONFIGURATION_UNRESOLVED" end
    if type(value)~="boolean" then return false,"INVALID_VALUE" end
    if self.state.enabled==value then return true,"UNCHANGED" end

    if value==false then
        self.state.enabled=false
        local persisted,persistReason=self:_writeState(self.state)
        self.durable=persisted==true
        self.lastStorageReason=persistReason
        self:_notify("enabled",false,persisted,persistReason)
        if not persisted then return false,persistReason end
        return true,"PERSISTED"
    end

    local candidate=copyState(self.state)
    candidate.enabled=true
    local persisted,persistReason=self:_writeState(candidate)
    self.durable=persisted==true
    self.lastStorageReason=persistReason
    if not persisted then return false,persistReason end
    self.state=candidate
    self:_notify("enabled",true,true,persistReason)
    return true,"PERSISTED"
end

function Configuration:setHudVisible(value)
    return self:_setImmediateValue("hudVisible",value)
end

function Configuration:setDebugEnabled(value)
    return self:_setImmediateValue("debug",value)
end
