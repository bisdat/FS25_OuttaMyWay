OuttaMyWay.CurrentPhysicalConflictRepresentation = {}
local Representation = OuttaMyWay.CurrentPhysicalConflictRepresentation
Representation.__index = Representation

-- Positive current-conflict candidate discovery scans one current Physical
-- Assembly under one aggregate hierarchy budget.
local CURRENT_ASSEMBLY_CANDIDATE_HIERARCHY_SCAN_BUDGET=2200
-- Cached candidate-node discovery is refreshed on this horizon. Current member
-- participation is still rechecked every observation independently of this cache.
local CANDIDATE_DISCOVERY_REFRESH_INTERVAL_SECONDS=5

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
end

local function usableVehicle(object)
    return type(object)=="table"
        and object.isDeleted~=true
        and object.rootNode~=nil
        and object.rootNode~=0
end

local function memberReferenceKey(member)
    return "component-root:"..tostring(member.rootNode)
end

local function currentMembers(root)
    local result,seen={},{}
    local function add(object)
        if not usableVehicle(object) or seen[object] then return end
        seen[object]=true
        result[#result+1]=object
    end
    add(root)
    local ok,children=safeCall(root,"getChildVehicles")
    if ok and type(children)=="table" then
        for _,child in OuttaMyWay.ValueRecord.pairs(children) do add(child) end
    end
    table.sort(result,function(a,b) return tostring(a.rootNode)<tostring(b.rootNode) end)
    return result
end

local function api(name)
    return type(_G)=="table" and type(_G[name])=="function" and _G[name] or nil
end

local function shapeClassEvidence(node)
    local fn=api("getHasClassId")
    local shapeClass=type(ClassIds)=="table" and ClassIds.SHAPE or nil
    if fn==nil or shapeClass==nil then return nil,"SHAPE_CLASS_API_UNAVAILABLE" end
    local ok,value=pcall(fn,node,shapeClass)
    if not ok then return nil,"SHAPE_CLASS_QUERY_FAILED:"..tostring(value) end
    if type(value)~="boolean" then return nil,"SHAPE_CLASS_QUERY_INVALID_RETURN" end
    return value,value and nil or "NOT_SHAPE"
end

local function sphere(name,node)
    local fn=api(name)
    if fn==nil then return {available=false,valid=false,error="API_UNAVAILABLE"} end
    local ok,x,y,z,r=pcall(fn,node,0)
    if not ok then return {available=true,valid=false,error=tostring(x)} end
    local valid=finite(x) and finite(y) and finite(z) and finite(r) and r>0.0001 and r<500
    return {available=true,valid=valid,x=x,y=y,z=z,radius=r,error=valid and nil or "INVALID_RETURN"}
end

local function sphereDifference(a,b)
    if a==nil or b==nil or a.valid~=true or b.valid~=true then return nil,nil end
    local dx,dy,dz=a.x-b.x,a.y-b.y,a.z-b.z
    return math.sqrt(dx*dx+dy*dy+dz*dz),math.abs(a.radius-b.radius)
end

local function predictedWorld(node,localSphere)
    local fn=api("localToWorld")
    if fn==nil or localSphere==nil or localSphere.valid~=true then return nil end
    local ok,x,y,z=pcall(fn,node,localSphere.x,localSphere.y,localSphere.z)
    if not ok or not finite(x) or not finite(y) or not finite(z) then return nil end
    return {valid=true,x=x,y=y,z=z,radius=localSphere.radius}
end

local function compoundChild(node)
    local fn=api("getIsCompoundChild")
    if fn==nil then return nil,"API_UNAVAILABLE" end
    local ok,value=pcall(fn,node)
    if not ok or type(value)~="boolean" then return nil,ok and "INVALID_RETURN" or tostring(value) end
    return value,nil
end

local function measure(member,node,rootWorld)
    local isShape,shapeReason=shapeClassEvidence(node)
    if isShape~=true then return nil,shapeReason or "SHAPE_CLASS_UNRESOLVED" end

    local geometry=sphere("getShapeGeometryBoundingSphere",node)
    local fallback=sphere("getShapeBoundingSphere",node)
    local world=sphere("getShapeWorldBoundingSphere",node)
    local localSphere=geometry.valid and geometry or (fallback.valid and fallback or nil)
    local predicted=predictedWorld(node,localSphere)
    local centreError,radiusError=sphereDifference(predicted,world)
    local tolerance=OuttaMyWay.REPRESENTATION_GEOMETRY_COHERENCE_TOLERANCE_METRES or 0.05
    local coherent=localSphere~=nil
        and world.valid==true
        and centreError~=nil and centreError<=tolerance
        and radiusError~=nil and radiusError<=tolerance
    if not coherent then return nil,"GEOMETRY_WORLD_COHERENCE_UNRESOLVED" end

    local aliasCentre,aliasRadius=sphereDifference(world,rootWorld)
    local aliasTolerance=OuttaMyWay.REPRESENTATION_ROOT_ALIAS_TOLERANCE_METRES or 0.0001
    local rootAlias=node~=member.rootNode
        and aliasCentre~=nil and aliasRadius~=nil
        and aliasCentre<=aliasTolerance and aliasRadius<=aliasTolerance
    if rootAlias then return nil,"DESCENDANT_ROOT_ALIAS_REJECTED" end

    return {
        x=world.x,y=world.y,z=world.z,radius=world.radius,
        geometryAPI=geometry.valid and "getShapeGeometryBoundingSphere" or "getShapeBoundingSphere"
    },nil
end

local function discoverCandidates(root)
    local candidates={}
    local seenNodes={}
    local scanned=0
    local truncated=false
    local budget=CURRENT_ASSEMBLY_CANDIDATE_HIERARCHY_SCAN_BUDGET
    local getCount=api("getNumOfChildren")
    local getChild=api("getChildAt")

    for _,member in OuttaMyWay.ValueRecord.ipairs(currentMembers(root)) do
        local rootNode=member.rootNode
        local queue={rootNode}
        local head=1
        while head<=#queue do
            if scanned>=budget then truncated=true break end
            local node=queue[head]
            head=head+1
            scanned=scanned+1

            if not seenNodes[node] then
                seenNodes[node]=true
                local isShape=shapeClassEvidence(node)
                if isShape==true then
                    local rootPartial=node==rootNode
                    local compound=rootPartial and nil or select(1,compoundChild(node))
                    if rootPartial or compound==true then
                        candidates[#candidates+1]={
                            node=node,
                            member=member,
                            memberReferenceKey=memberReferenceKey(member),
                            rootPartial=rootPartial,
                            discoveryClass=rootPartial and "CURRENT_MEMBER_ROOT_PARTIAL" or "CURRENT_RUNTIME_COMPOUND_CHILD"
                        }
                    end
                end
            end

            if getCount~=nil and getChild~=nil then
                local okCount,count=pcall(getCount,node)
                if okCount and type(count)=="number" then
                    for index=0,count-1 do
                        local okChild,child=pcall(getChild,node,index)
                        if okChild and child~=nil and child~=0 then queue[#queue+1]=child end
                    end
                end
            end
        end
        if truncated then break end
    end

    table.sort(candidates,function(a,b)
        if a.memberReferenceKey~=b.memberReferenceKey then return a.memberReferenceKey<b.memberReferenceKey end
        return tostring(a.node)<tostring(b.node)
    end)
    return candidates,scanned,truncated
end

function Representation.new()
    return setmetatable({records={}},Representation)
end

function Representation:reset()
    self.records={}
end

function Representation:observe(root,assemblyReferenceKey,nowSeconds)
    if not usableVehicle(root) then return nil end
    local now=tonumber(nowSeconds) or 0
    local interval=CANDIDATE_DISCOVERY_REFRESH_INTERVAL_SECONDS
    local record=self.records[assemblyReferenceKey]

    if record==nil
        or record.root~=root
        or record.discoveredAt==nil
        or now-record.discoveredAt>=interval then
        local candidates,scanned,truncated=discoverCandidates(root)
        record={
            root=root,
            discoveredAt=now,
            candidates=candidates,
            hierarchyNodesScanned=scanned,
            scanTruncated=truncated
        }
        self.records[assemblyReferenceKey]=record
    end

    -- Candidate discovery may be cached, but positive CURRENT evidence may not
    -- preserve stale Physical Assembly membership. Recheck current root/child
    -- membership on every observation before materialising any cached candidate.
    local currentMemberSet={}
    local currentMemberCount=0
    for _,member in OuttaMyWay.ValueRecord.ipairs(currentMembers(root)) do
        currentMemberSet[member]=true
        currentMemberCount=currentMemberCount+1
    end

    local primitives={}
    local unresolved=0
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(record.candidates or {}) do
        local memberCurrent=currentMemberSet[candidate.member]==true
        local stillParticipating=memberCurrent and candidate.rootPartial==true
        if memberCurrent and not stillParticipating then
            stillParticipating=select(1,compoundChild(candidate.node))==true
        end
        if stillParticipating then
            local rootWorld=sphere("getShapeWorldBoundingSphere",candidate.member.rootNode)
            local measured=measure(candidate.member,candidate.node,rootWorld)
            if measured~=nil then
                primitives[#primitives+1]={
                    identity="current-physical:"..tostring(assemblyReferenceKey)..":"..tostring(candidate.node),
                    kind="DISC",
                    x=measured.x,y=measured.y,z=measured.z,radius=measured.radius,
                    memberReferenceKey=candidate.memberReferenceKey,
                    node=candidate.node,
                    class=candidate.discoveryClass,
                    positiveConflictSupport=true,
                    negativeClearanceSupport=false,
                    provenance={
                        source="CurrentPhysicalConflictRepresentation",
                        geometryAPI=measured.geometryAPI,
                        shapeClassVerified=true,
                        worldCoherence=true,
                        authority="POSITIVE_CONFLICT_SUPPORT_ONLY"
                    }
                }
            else
                unresolved=unresolved+1
            end
        end
    end
    table.sort(primitives,function(a,b) return tostring(a.identity)<tostring(b.identity) end)

    return {
        assemblyReferenceKey=assemblyReferenceKey,
        worldPrimitives=primitives,
        summary=OuttaMyWay.PlanViewFootprint.summarise(primitives),
        structurallyValid=#primitives>0,
        coverageComplete=false,
        negativeClearanceAuthority=false,
        hierarchyNodesScanned=record.hierarchyNodesScanned or 0,
        currentMemberCount=currentMemberCount,
        candidateNodeCount=OuttaMyWay.ValueRecord.length(record.candidates or {}),
        positivePrimitiveCount=#primitives,
        unresolvedPrimitiveCount=unresolved,
        scanTruncated=record.scanTruncated==true,
        provenance={
            source="CurrentPhysicalConflictRepresentation",
            populationBasis="CURRENT_GIANTS_PHYSICAL_ASSEMBLY",
            geometryBasis="CURRENT_SHAPE_WORLD_SPHERES",
            participationBasis="MEMBER_ROOT_PARTIAL_OR_CURRENT_RUNTIME_COMPOUND_CHILD",
            membershipBasis="CURRENT_GET_CHILD_VEHICLES_RECHECK",
            semanticAuthority=false,
            authority="POSITIVE_CONFLICT_SUPPORT_ONLY",
            coverageComplete=false,
            negativeClearanceAuthority=false
        }
    }
end
