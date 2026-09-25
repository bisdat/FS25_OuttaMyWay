--- Centralizes publication eligibility, deferred payload construction, rendering and GIANTS-log delivery without owning event meaning.
-- Specification Jurisdictions: `LOG_PUBLICATION`

OuttaMyWay.LogPublication = {}
local LogPublication = OuttaMyWay.LogPublication
LogPublication.__index = LogPublication

local CLASS_RANK={NORMAL=1,DEBUG=2,DIAGNOSTIC=3}
local SEVERITY_METHOD={INFO="info",WARNING="warning",ERROR="error"}
local EVENT_CODE_PATTERN="^[A-Z][A-Z0-9_]*$"
local ORIGIN_PATTERN="^[A-Z][A-Z0-9_]*$"

local Origin={}
Origin.__index=Origin

local function oneLine(value)
    local text=value==nil and "" or tostring(value)
    return (string.gsub(text,"[\r\n]+","\\n"))
end

local function fallback(stage,code,detail)
    local line=string.format("[FS25_OuttaMyWay][LOG_PUBLICATION_FAILURE] stage=%s code=%s detail=%s",
        oneLine(stage),oneLine(code or "UNAVAILABLE"),oneLine(detail or "n/a"))
    if type(print)=="function" then pcall(print,line) end
end

local function descriptorReason(descriptor)
    if type(descriptor)~="table" then return "DESCRIPTOR_NOT_TABLE" end
    if type(descriptor.code)~="string" or not string.match(descriptor.code,EVENT_CODE_PATTERN) then return "INVALID_EVENT_CODE" end
    if CLASS_RANK[descriptor.publicationClass]==nil then return "INVALID_PUBLICATION_CLASS" end
    if SEVERITY_METHOD[descriptor.severity]==nil then return "INVALID_SEVERITY" end
    if type(descriptor.origin)~="string" or not string.match(descriptor.origin,ORIGIN_PATTERN) then return "INVALID_ORIGIN" end
    return nil
end

function LogPublication.event(code,publicationClass,severity,origin)
    local descriptor={code=code,publicationClass=publicationClass,severity=severity,origin=origin}
    local reason=descriptorReason(descriptor)
    if reason~=nil then error("invalid Publication Descriptor: "..reason,2) end
    return descriptor
end

function LogPublication.origin(origin)
    if type(origin)~="string" or not string.match(origin,ORIGIN_PATTERN) then
        error("invalid Log Publication origin",2)
    end
    return setmetatable({origin=origin,events={}},Origin)
end

function LogPublication.new(policyProvider)
    if type(policyProvider)~="function" then error("LogPublication requires policy provider",2) end
    return setmetatable({policyProvider=policyProvider},LogPublication)
end

function LogPublication:_resolvedPolicy()
    local ok,value=pcall(self.policyProvider)
    if not ok then
        fallback("POLICY_PROVIDER","POLICY_RESOLUTION",value)
        return nil,"POLICY_PROVIDER_FAILED"
    end
    if CLASS_RANK[value]==nil then
        fallback("POLICY_INVALID","POLICY_RESOLUTION",value)
        return nil,"INVALID_PUBLICATION_POLICY"
    end
    return value,nil
end

function LogPublication:_eligible(descriptor)
    local reason=descriptorReason(descriptor)
    if reason~=nil then
        fallback("DESCRIPTOR_INVALID",descriptor and descriptor.code or nil,reason)
        return false,reason
    end
    local policy,policyReason=self:_resolvedPolicy()
    if policy==nil then return false,policyReason end
    if CLASS_RANK[descriptor.publicationClass]>CLASS_RANK[policy] then return false,"SUPPRESSED" end
    return true,nil
end

local function appendField(parts,key,value)
    if value==nil then return end
    parts[#parts+1]=oneLine(key).."="..oneLine(value)
end

local function renderPayload(payload)
    if payload==nil then return "" end
    if type(payload)=="string" or type(payload)=="number" or type(payload)=="boolean" then return oneLine(payload) end
    if type(payload)~="table" then error("Publication Payload must be scalar, table or nil") end

    local parts={}
    appendField(parts,"operation",payload.operation)
    appendField(parts,"field",payload.field)

    local keys={}
    for key,value in next,payload do
        if key~="operation" and key~="field" and key~="detail" and value~=nil then keys[#keys+1]=key end
    end
    table.sort(keys,function(a,b) return tostring(a)<tostring(b) end)
    for _,key in ipairs(keys) do appendField(parts,key,payload[key]) end
    if payload.detail~=nil and tostring(payload.detail)~="" then parts[#parts+1]=oneLine(payload.detail) end
    return table.concat(parts," ")
end

local function formatPayload(formatText,...)
    return {detail=string.format(formatText,...)}
end

function LogPublication:_render(descriptor,payload)
    local body=renderPayload(payload)
    local envelope
    if descriptor.publicationClass=="NORMAL" then
        envelope=string.format("[FS25_OuttaMyWay][%s][%s]",descriptor.origin,descriptor.code)
    else
        envelope=string.format("[FS25_OuttaMyWay][%s][%s][%s]",
            descriptor.publicationClass,descriptor.origin,descriptor.code)
    end
    if body=="" then return envelope end
    return envelope.." "..body
end

function LogPublication:_deliver(descriptor,line)
    local method=SEVERITY_METHOD[descriptor.severity]
    local destination=Logging and Logging[method] or nil
    if type(destination)=="function" then
        local ok,err=pcall(destination,"%s",line)
        if ok then return true,"PUBLISHED" end
        fallback("DESTINATION_FAILED",descriptor.code,err)
        return false,"DESTINATION_FAILED"
    end
    if type(print)=="function" then
        local ok,err=pcall(print,line)
        if ok then return true,"PUBLISHED_FALLBACK" end
        fallback("PRINT_FAILED",descriptor.code,err)
    end
    return false,"DESTINATION_UNAVAILABLE"
end

function LogPublication:isEligible(descriptor)
    return self:_eligible(descriptor)
end

function LogPublication:publish(descriptor,payloadBuilder,...)
    local eligible,reason=self:_eligible(descriptor)
    if not eligible then return false,reason end
    if type(payloadBuilder)~="function" then
        fallback("PAYLOAD_BUILDER_INVALID",descriptor.code,type(payloadBuilder))
        return false,"PAYLOAD_BUILDER_INVALID"
    end
    local ok,payload=pcall(payloadBuilder,...)
    if not ok then
        fallback("PAYLOAD_BUILD_FAILED",descriptor.code,payload)
        return false,"PAYLOAD_BUILD_FAILED"
    end
    local rendered,line=pcall(self._render,self,descriptor,payload)
    if not rendered then
        fallback("RENDER_FAILED",descriptor.code,line)
        return false,"RENDER_FAILED"
    end
    return self:_deliver(descriptor,line)
end

function LogPublication:publishFormat(descriptor,formatText,...)
    return self:publish(descriptor,formatPayload,formatText,...)
end

function Origin:_event(publicationClass,severity,code)
    local key=publicationClass.."|"..severity.."|"..code
    local descriptor=self.events[key]
    if descriptor==nil then
        descriptor=LogPublication.event(code,publicationClass,severity,self.origin)
        self.events[key]=descriptor
    end
    return descriptor
end

function Origin:isEligible(publicationClass,severity,code)
    local publisher=OuttaMyWay.logPublication
    if publisher==nil then return false,"PUBLISHER_UNAVAILABLE" end
    return publisher:isEligible(self:_event(publicationClass,severity,code))
end

function Origin:publish(publicationClass,severity,code,payloadBuilder,...)
    local publisher=OuttaMyWay.logPublication
    if publisher==nil then
        fallback("PUBLISHER_UNAVAILABLE",code,self.origin)
        return false,"PUBLISHER_UNAVAILABLE"
    end
    return publisher:publish(self:_event(publicationClass,severity,code),payloadBuilder,...)
end

function Origin:format(publicationClass,severity,code,formatText,...)
    local publisher=OuttaMyWay.logPublication
    if publisher==nil then
        fallback("PUBLISHER_UNAVAILABLE",code,self.origin)
        return false,"PUBLISHER_UNAVAILABLE"
    end
    return publisher:publishFormat(self:_event(publicationClass,severity,code),formatText,...)
end

function Origin:info(publicationClass,code,formatText,...)
    return self:format(publicationClass,"INFO",code,formatText,...)
end

function Origin:warning(publicationClass,code,formatText,...)
    return self:format(publicationClass,"WARNING",code,formatText,...)
end

function Origin:error(publicationClass,code,formatText,...)
    return self:format(publicationClass,"ERROR",code,formatText,...)
end
