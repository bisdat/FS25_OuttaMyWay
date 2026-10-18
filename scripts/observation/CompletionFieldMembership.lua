-- Read-only registered-field membership and Job Episode-scoped retained witness.
-- A positive active-work sample remains valid after the assembly reaches a margin.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionFieldMembership={}
local Membership=OuttaMyWay.CompletionFieldMembership
local G=OuttaMyWay.FarmEdgeGeometry
local MAX_FIELDS=512

local function finite(v)
    return type(v)=="number" and v==v
        and v~=math.huge and v~=-math.huge
end

function Membership.identify(vehicle)
    if type(vehicle)~="table" then
        return nil,"COMPLETED_ASSEMBLY_UNAVAILABLE"
    end
    local root=vehicle
    if type(vehicle.getRootVehicle)=="function" then
        local ok,result=pcall(vehicle.getRootVehicle,vehicle)
        if not ok or type(result)~="table" then
            return nil,"COMPLETED_ASSEMBLY_ROOT_UNAVAILABLE"
        end
        root=result
    end
    if root.rootNode==nil or root.rootNode==0
        or type(getWorldTranslation)~="function" then
        return nil,"COMPLETED_ASSEMBLY_POSE_UNAVAILABLE"
    end
    local ok,x,_,z=pcall(getWorldTranslation,root.rootNode)
    if not ok or not finite(x) or not finite(z) then
        return nil,"COMPLETED_ASSEMBLY_POSE_UNAVAILABLE"
    end
    local manager=g_fieldManager
    local fields=manager and manager.fields
    if type(fields)~="table" then
        return nil,"REGISTERED_FIELD_CATALOGUE_UNAVAILABLE"
    end
    if type(G)~="table" or type(G.polygonFor)~="function"
        or type(G.inside)~="function" then
        return nil,"FIELD_GEOMETRY_UNAVAILABLE"
    end
    local selected,examined=nil,0
    local seen={}
    for key,field in pairs(fields) do
        examined=examined+1
        if examined>MAX_FIELDS then
            return nil,"REGISTERED_FIELD_CATALOGUE_LIMIT"
        end
        if type(field)=="table" and not seen[field] then
            seen[field]=true
            local poly=G.polygonFor(field)
            if poly==nil then
                -- Cannot positively establish a unique match if another
                -- registered polygon's membership is unreadable.
                return nil,"REGISTERED_FIELD_POLYGON_UNAVAILABLE"
            end
            if G.inside(poly,x,z) then
                if selected~=nil then
                    return nil,"ASSEMBLY_FIELD_MEMBERSHIP_AMBIGUOUS"
                end
                local id=field.fieldId or key
                if type(id)~="number" or not finite(id)
                    or id<1 or id%1~=0 then
                    return nil,"REGISTERED_FIELD_ID_UNAVAILABLE"
                end
                selected={fieldId=id,field=field,polygon=poly,
                    rootX=x,rootZ=z,rootNode=root.rootNode,
                    provenance="ASSEMBLY_ROOT_REGISTERED_POLYGON_MEMBERSHIP"}
            end
        end
    end
    if selected==nil then
        return nil,"ASSEMBLY_OUTSIDE_REGISTERED_FIELDS"
    end
    return selected
end

-- Active FIELDWORK establishes a job-scoped Source Field independently of
-- the assembly's final position. A later job never inherits this witness.
local SAMPLE_MS=1000
local MAX_ACTIVE_WORKERS=16
local function nativeFieldwork(job)
    if type(job)~="table" or type(AIJobFieldWork)~="table"
        or type(job.isa)~="function" then return false end
    local ok,match=pcall(job.isa,job,AIJobFieldWork)
    return ok and match==true
end
local function assemblyRoot(vehicle)
    if type(vehicle)~="table" then return nil end
    if type(vehicle.getRootVehicle)=="function" then
        local ok,root=pcall(vehicle.getRootVehicle,vehicle)
        if not ok or type(root)~="table" then return nil end
        return root
    end
    return vehicle
end
function Membership.new(configuration)
    return setmetatable({configuration=configuration,elapsedMs=0,cursor=1,
        byJob=setmetatable({},{__mode="k"})},{__index=Membership})
end
function Membership:reset()
    self.elapsedMs=0
    self.cursor=1
    self.byJob=setmetatable({},{__mode="k"})
end
function Membership:update(dt)
    if g_server==nil or self.configuration==nil
        or self.configuration:isResolved()~=true
        or self.configuration:isEnabled()~=true then
        self:reset()
        return
    end
    if not finite(dt) or dt<0 then return end
    self.elapsedMs=self.elapsedMs+dt
    if self.elapsedMs<SAMPLE_MS then return end
    self.elapsedMs=0
    local mission=g_currentMission
    local registry=mission and mission.aiSystem
        and mission.aiSystem.activeJobVehicles
    if type(registry)~="table" then return end
    local workers,seen={},{}
    local function include(worker)
        if type(worker)~="table" or seen[worker] then return end
        seen[worker]=true
        local spec=worker.spec_aiFieldWorker
        if type(spec)=="table" and spec.isActive==true
            and #workers<MAX_ACTIVE_WORKERS then
            workers[#workers+1]=worker
        end
    end
    for key,value in pairs(registry) do
        include(key)
        include(value)
        if type(value)=="table" then
            include(value.vehicle)
            include(value.object)
            include(value.rootVehicle)
            include(value[1])
        end
    end
    -- One expensive field-registry observation at most per update.
    -- Rotate among active workers so one unresolved margin sample cannot
    -- starve the last worker's field witness.
    local count=#workers
    if count==0 then return end
    local start=(self.cursor-1)%count+1
    self.cursor=start%count+1
    for offset=0,count-1 do
        local worker=workers[(start+offset-1)%count+1]
        local spec=worker.spec_aiJobVehicle
        local job=(spec and spec.job)
            or (worker.spec_aiFieldWorker and worker.spec_aiFieldWorker.fieldJob)
        if nativeFieldwork(job) then
            local root=assemblyRoot(worker)
            local recorded=self.byJob[job]
            if recorded~=nil and recorded.root~=root then
                self.byJob[job]=nil
                recorded=nil
            end
            if recorded==nil and root~=nil then
                local source=Membership.identify(worker)
                if source~=nil then
                    source.provenance="ACTIVE_FIELDWORK_REGISTERED_POLYGON_MEMBERSHIP"
                    self.byJob[job]={root=root,sourceField=source}
                end
                break
            end
        end
    end
end
function Membership:take(job,vehicle,successful)
    local recorded=type(job)=="table" and self.byJob[job] or nil
    if type(job)=="table" then self.byJob[job]=nil end
    if successful~=true then return nil end
    local root=assemblyRoot(vehicle)
    if recorded~=nil and root~=nil and recorded.root==root then
        return recorded.sourceField
    end
    -- Short jobs may end before the active-work sample. Only unique
    -- current registered-polygon containment can then establish identity.
    local source,why=Membership.identify(vehicle)
    if source~=nil then
        source.provenance="COMPLETION_ROOT_REGISTERED_POLYGON_FALLBACK"
    end
    return source,why
end
return Membership
