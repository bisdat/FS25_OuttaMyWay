-- One-time current physical pose/facing evidence at the first OBSERVED native blocked edge.
-- Specification Jurisdictions: `NATIVE_BLOCKAGE_OBSERVATION`
-- This is NOT an exact impact callback, a causal blocker identification or Control.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.StaticBlockageEncounterObservation={}
local M=OuttaMyWay.StaticBlockageEncounterObservation
local MAX_EXAMPLES=3 -- Limit retained evidence, not candidate admission.

local function finite(n)
    return type(n)=="number" and n==n and n~=math.huge and n~=-math.huge
end
local function rootOf(v)
    if type(v)~="table" then return nil end
    if type(v.getRootVehicle)=="function" then
        local ok,r=pcall(v.getRootVehicle,v)
        if ok and type(r)=="table" then return r end
    end
    return type(v.rootVehicle)=="table" and v.rootVehicle or v
end
local function position(v)
    if type(v)~="table" or v.rootNode==nil or v.rootNode==0
        or type(getWorldTranslation)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,v.rootNode)
    if not ok or not finite(x) or not finite(z) then return nil end
    return {x=x,z=z}
end
local function heading(v)
    if type(v)~="table" or type(localDirectionToWorld)~="function" then return nil end
    local node=v.rootNode
    local source="ROOT_NODE"
    if type(v.getAISteeringNode)=="function" then
        local ok,n=pcall(v.getAISteeringNode,v)
        if ok and n~=nil and n~=0 then node=n;source="NATIVE_STEERING_NODE" end
    end
    if node==nil or node==0 then return nil end
    local ok,x,_,z=pcall(localDirectionToWorld,node,0,0,1)
    if not ok or not finite(x) or not finite(z) then return nil end
    local length=math.sqrt(x*x+z*z)
    if length<=0.000001 then return nil end
    return {x=x/length,z=z/length,source=source}
end
local function booleanMethod(v,name)
    if type(v)~="table" or type(v[name])~="function" then return nil end
    local ok,result=pcall(v[name],v)
    if ok and type(result)=="boolean" then return result end
    return nil
end

function M.capture(worker,mission,nowMs)
    local root=rootOf(worker)
    local p=position(root)
    local h=heading(worker)
    local result={
        kind="FIRST_OBSERVED_NATIVE_BLOCKED_EDGE",
        observedAtMs=nowMs,beneficiaryRootId=root and root.rootNode or nil,
        beneficiaryPose=p,beneficiaryFacing=h,
        populationAvailable=false,physicalAssemblyCount=0,
        nearestPhysicalAssemblies={},
        authority="OBSERVATION_ONLY_NOT_CONTACT_OR_CAUSALITY"
    }
    local vehicles=mission and mission.vehicleSystem and mission.vehicleSystem.vehicles
    if p==nil or type(vehicles)~="table" then return result end
    result.populationAvailable=true
    local seen,list={},{}
    local function consider(v)
        local other=rootOf(v)
        if other==nil or other==root or other.isDeleted==true
            or other.rootNode==nil or seen[other] then return end
        seen[other]=true
        local op=position(other)
        if op==nil then return end
        local oh=heading(other)
        local dx,dz=op.x-p.x,op.z-p.z
        local player=mission and rootOf(mission.controlledVehicle)==other
        local observedPlayer=booleanMethod(other,"getIsControlled")
        result.physicalAssemblyCount=result.physicalAssemblyCount+1
        list[#list+1]={
            rootId=other.rootNode,x=op.x,z=op.z,
            forwardX=oh and oh.x or nil,
            forwardZ=oh and oh.z or nil,
            facingSource=oh and oh.source or "UNAVAILABLE",
            distanceM=math.sqrt(dx*dx+dz*dz),
            relativeForwardM=h and dx*h.x+dz*h.z or nil,
            relativeCrossTrackM=h and dx*h.z-dz*h.x or nil,
            facingAlignmentDot=h and oh and h.x*oh.x+h.z*oh.z or nil,
            aiActive=booleanMethod(other,"getIsAIActive"),
            playerControlled=player and true or observedPlayer,
            reportedSpeedMps=finite(other.lastSpeedReal)
                and math.abs(other.lastSpeedReal)*1000 or nil
        }
    end
    -- Ordinary native mission vehicle table; one pass per first blocked edge.
    -- No hierarchy scan, shape API, polygon scan or ongoing physical prediction.
    for key,value in pairs(vehicles) do consider(key);consider(value) end
    table.sort(list,function(a,b)
        if a.distanceM==b.distanceM then
            return tostring(a.rootId)<tostring(b.rootId)
        end
        return a.distanceM<b.distanceM
    end)
    for i=1,math.min(MAX_EXAMPLES,#list) do
        result.nearestPhysicalAssemblies[i]=list[i]
    end
    return result
end

function M.describe(e)
    if type(e)~="table" then return "ENCOUNTER_UNAVAILABLE" end
    local function n(x)
        return finite(x) and string.format("%.2f",x) or "unknown"
    end
    local p,h=e.beneficiaryPose,e.beneficiaryFacing
    local result={
        "edgeMs="..tostring(e.observedAtMs),
        "blockedRootId="..tostring(e.beneficiaryRootId),
        "x="..n(p and p.x),"z="..n(p and p.z),
        "forwardX="..n(h and h.x),"forwardZ="..n(h and h.z),
        "facingSource="..tostring(h and h.source or "UNAVAILABLE"),
        "physicalAssemblyCount="..tostring(e.physicalAssemblyCount)
    }
    for i,c in ipairs(e.nearestPhysicalAssemblies or {}) do
        result[#result+1]="near"..i.."="..tostring(c.rootId)
            .." x="..n(c.x).." z="..n(c.z)
            .." forwardX="..n(c.forwardX).." forwardZ="..n(c.forwardZ)
            .." facingSource="..tostring(c.facingSource or "UNAVAILABLE")
            .." reportedSpeedMps="..n(c.reportedSpeedMps)
            .." distanceM="..n(c.distanceM)
            .." alongM="..n(c.relativeForwardM)
            .." crossM="..n(c.relativeCrossTrackM)
            .." facingDot="..n(c.facingAlignmentDot)
            .." aiActive="..tostring(c.aiActive)
            .." playerControlled="..tostring(c.playerControlled)
    end
    return table.concat(result," ")
end
