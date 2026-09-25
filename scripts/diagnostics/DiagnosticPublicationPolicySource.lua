--- Resolves engineering-only DIAGNOSTIC log-publication policy from an optional modSettings sidecar.
-- This source is not supported player Configuration and owns no Runtime semantic or Control authority.

OuttaMyWay.DiagnosticPublicationPolicySource = {}
local Source=OuttaMyWay.DiagnosticPublicationPolicySource
Source.__index=Source

local ROOT_KEY="outtaMyWayDiagnostics"
local ENABLED_KEY=ROOT_KEY.."#enabled"
local FILE_NAME="diagnostics.xml"
local XML_FILE_ID="outtaMyWayDiagnostics"

local function diagnosticsPath(modName)
    if type(getUserProfileAppPath)~="function" then return nil,"PROFILE_PATH_UNAVAILABLE" end
    local ok,profilePath=pcall(getUserProfileAppPath)
    if not ok or type(profilePath)~="string" or profilePath=="" then return nil,"PROFILE_PATH_UNAVAILABLE" end
    local last=string.sub(profilePath,-1)
    local separator=(last=="/" or last=="\\") and "" or "/"
    return profilePath..separator.."modSettings/"..modName.."/"..FILE_NAME,nil
end

local function xmlApiAvailable()
    return type(XMLValueType)=="table"
        and XMLValueType.BOOL~=nil
        and type(XMLSchema)=="table"
        and type(XMLSchema.new)=="function"
        and type(XMLFile)=="table"
        and type(XMLFile.loadIfExists)=="function"
end

local function deleteXmlFile(xmlFile)
    if xmlFile~=nil and type(xmlFile.delete)=="function" then pcall(xmlFile.delete,xmlFile) end
end

function Source.new(modName)
    local resolvedModName=modName or OuttaMyWay.MOD_NAME or g_currentModName or "FS25_OuttaMyWay"
    return setmetatable({
        modName=resolvedModName,
        filePath=nil,
        isDiagnosticEnabled=false,
        loadReason="NOT_LOADED"
    },Source)
end

function Source:loadSidecar()
    self.isDiagnosticEnabled=false
    local path,pathReason=diagnosticsPath(self.modName)
    self.filePath=path
    if path==nil then
        self.loadReason=pathReason
        return false,self.loadReason
    end

    if type(fileExists)~="function" then
        self.loadReason="FILE_API_UNAVAILABLE"
        return false,self.loadReason
    end
    local existsOk,exists=pcall(fileExists,path)
    if not existsOk then
        self.loadReason="FILE_CHECK_FAILED"
        return false,self.loadReason
    end
    if exists~=true then
        self.loadReason="ABSENT"
        return false,self.loadReason
    end

    if not xmlApiAvailable() then
        self.loadReason="XML_API_UNAVAILABLE"
        return false,self.loadReason
    end

    local schemaOk,schema=pcall(XMLSchema.new,"OuttaMyWayDiagnostics")
    if not schemaOk or schema==nil or type(schema.register)~="function" then
        self.loadReason="SCHEMA_UNAVAILABLE"
        return false,self.loadReason
    end
    local registered=pcall(schema.register,schema,XMLValueType.BOOL,ENABLED_KEY)
    if not registered then
        self.loadReason="SCHEMA_REGISTRATION_FAILED"
        return false,self.loadReason
    end

    local loadOk,xmlFile=pcall(XMLFile.loadIfExists,XML_FILE_ID,path,schema)
    if not loadOk or xmlFile==nil then
        self.loadReason="INVALID_OR_UNREADABLE"
        return false,self.loadReason
    end

    local valueOk,value=false,nil
    if type(xmlFile.getValue)=="function" then valueOk,value=pcall(xmlFile.getValue,xmlFile,ENABLED_KEY) end
    deleteXmlFile(xmlFile)
    if not valueOk or type(value)~="boolean" then
        self.loadReason="INVALID_OR_UNREADABLE"
        return false,self.loadReason
    end

    self.isDiagnosticEnabled=value
    self.loadReason=value and "ENABLED" or "DISABLED"
    return self.isDiagnosticEnabled,self.loadReason
end

function Source:publicationPolicy()
    return self.isDiagnosticEnabled and "DIAGNOSTIC" or "NORMAL"
end
