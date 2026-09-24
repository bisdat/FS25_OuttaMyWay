--- Central GIANTS-log publication boundary.
-- LOG_PUBLICATION remains NOT_IMPLEMENTED until all production publication is migrated
-- and the Specification/source conformance edge is accepted.

OuttaMyWay.LogPublication = {}
local Publication = OuttaMyWay.LogPublication
Publication.__index = Publication

local CLASS_RANK = { NORMAL=1, DEBUG=2, DIAGNOSTIC=3 }
local SEVERITY_METHOD = { INFO="info", WARNING="warning", ERROR="error" }

local function validEventCode(value)
    return type(value)=="string"
        and value:match("^[A-Z][A-Z0-9_]*$")~=nil
        and value:sub(-1)~="_"
        and value:find("__",1,true)==nil
end

local function descriptorReason(descriptor)
    if type(descriptor)~="table" then return "DESCRIPTOR_REQUIRED" end
    if not validEventCode(descriptor.code) then return "EVENT_CODE_INVALID" end
    if CLASS_RANK[descriptor.publicationClass]==nil then return "PUBLICATION_CLASS_INVALID" end
    if SEVERITY_METHOD[descriptor.severity]==nil then return "SEVERITY_INVALID" end
    if type(descriptor.origin)~="string" or descriptor.origin=="" then return "ORIGIN_INVALID" end
    return nil
end

local function resolvedDefaultClass()
    if OuttaMyWay.LOG_DIAGNOSTIC==true then return "DIAGNOSTIC" end
    return "NORMAL"
end

local function oneLine(value)
    local text=tostring(value or "")
    text=text:gsub("[\r\n]+"," ")
    return text
end

function Publication.new(resolvedClass)
    local self=setmetatable({},Publication)
    self.resolvedClass=resolvedClass or resolvedDefaultClass()
    if CLASS_RANK[self.resolvedClass]==nil then
        self.resolvedClass="NORMAL"
    end
    return self
end

function Publication:setResolvedClass(resolvedClass)
    if CLASS_RANK[resolvedClass]==nil then return false,"PUBLICATION_POLICY_INVALID" end
    self.resolvedClass=resolvedClass
    return true,nil
end

function Publication:getResolvedClass()
    return self.resolvedClass
end

function Publication:classify(descriptor)
    local reason=descriptorReason(descriptor)
    if reason~=nil then return false,reason end
    return CLASS_RANK[descriptor.publicationClass]<=CLASS_RANK[self.resolvedClass],nil
end

local function fallbackLine(severity,line)
    local prefix=severity=="INFO" and "" or ("["..tostring(severity).."] ")
    if type(print)=="function" then
        pcall(print,prefix..line)
    end
end

function Publication:publish(descriptor,payloadBuilder,...)
    local eligible,reason=self:classify(descriptor)
    if reason~=nil then return false,reason end
    if eligible~=true then return false,"SUPPRESSED" end

    local detail=""
    if payloadBuilder~=nil then
        if type(payloadBuilder)~="function" then return false,"PAYLOAD_BUILDER_INVALID" end
        local ok,payload=pcall(payloadBuilder,...)
        if not ok then return false,"PAYLOAD_CONSTRUCTION_FAILED:"..tostring(payload) end
        detail=oneLine(payload)
    end

    local line=string.format("[FS25_OuttaMyWay][%s][%s] %s origin=%s",
        descriptor.publicationClass,descriptor.severity,descriptor.code,descriptor.origin)
    if detail~="" then line=line.." "..detail end

    local methodName=SEVERITY_METHOD[descriptor.severity]
    local method=Logging and Logging[methodName] or nil
    if type(method)=="function" then
        local ok,loggingError=pcall(method,"%s",line)
        if not ok then
            fallbackLine(descriptor.severity,line)
            return false,"LOG_DESTINATION_FAILED:"..tostring(loggingError)
        end
        return true,"PUBLISHED"
    end

    fallbackLine(descriptor.severity,line)
    return true,"PUBLISHED_FALLBACK"
end
