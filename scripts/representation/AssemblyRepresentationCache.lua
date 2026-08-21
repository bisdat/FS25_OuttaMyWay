OuttaMyWay.AssemblyRepresentationCache = {}
local Cache=OuttaMyWay.AssemblyRepresentationCache
Cache.__index=Cache

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
end
local function isDeleted(object) return object==nil or object.isDeleted==true or object.rootNode==nil or object.rootNode==0 end
local function normaliseAsset(value) return string.lower(string.gsub(tostring(value or ""),"\\","/")) end
local function endsWith(value,suffix) return suffix~="" and string.sub(value,-string.len(suffix))==suffix end
local function asObject(value)
    if type(value)~="table" then return nil end
    if value.rootNode~=nil then return value end
    for _,key in ipairs({"object","vehicle","implement","attachedVehicle","child","attacherVehicle"}) do
        local candidate=value[key]; if type(candidate)=="table" and candidate.rootNode~=nil then return candidate end
    end
    local indexed=value[1]; if type(indexed)=="table" and indexed.rootNode~=nil then return indexed end
    return nil
end
local function memberReference(object) return "member-root:"..tostring(object and object.rootNode or "nil") end
local function objectName(object)
    local ok,value=safeCall(object,"getName"); if ok and value~=nil and value~="" then return tostring(value) end
    return tostring(object and (object.name or object.typeName) or "assembly member")
end
local function assetName(object) return normaliseAsset(object and (object.configFileName or object.configFileNameClean or object.xmlFilename) or "") end
local function functionOrGlobal(overrides,name)
    if type(overrides)=="table" and type(overrides[name])=="function" then return overrides[name] end
    return type(_G)=="table" and type(_G[name])=="function" and _G[name] or nil
end
local function finite(value) return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge end
local function validSphere(x,y,z,r) return finite(x) and finite(y) and finite(z) and finite(r) and r>0.0001 and r<500 end
local function sphereDifference(a,b)
    if a==nil or b==nil or a.valid~=true or b.valid~=true then return nil,nil end
    local dx=a.x-b.x; local dy=a.y-b.y; local dz=a.z-b.z
    return math.sqrt(dx*dx+dy*dy+dz*dz),math.abs(a.radius-b.radius)
end
local function countKeys(value) local n=0; for _ in pairs(value or {}) do n=n+1 end; return n end

local function collectChildren(object)
    local children,seen={},{}
    local function add(value,source,relation)
        local child=asObject(value)
        if isDeleted(child) or seen[child] then return end
        seen[child]=true; children[#children+1]={object=child,source=source,relation=relation or "attached"}
    end
    for _,methodName in ipairs({"getAttachedImplements","getAttachedVehicles","getChildVehicles"}) do
        local ok,values=safeCall(object,methodName)
        if ok and type(values)=="table" then for key,value in pairs(values) do add(value,methodName,tostring(key)) end end
    end
    local spec=object and object.spec_attacherJoints or nil
    if type(spec)=="table" and type(spec.attachedImplements)=="table" then
        for key,value in pairs(spec.attachedImplements) do add(value,"spec_attacherJoints.attachedImplements",tostring(key)) end
    end
    return children
end

local function discoverAssembly(worker,budget)
    local members,edges,queue,seen={},{},{},{}
    local function add(object,parent,source,relation,depth)
        if isDeleted(object) or seen[object] or #members>=budget then return nil end
        seen[object]=true
        local member={object=object,referenceKey=memberReference(object),parent=parent,discoverySource=source or "operational-worker",relation=relation or "root",depth=depth or 0,name=objectName(object),asset=assetName(object)}
        members[#members+1]=member; queue[#queue+1]=member
        if parent~=nil then edges[#edges+1]={parentReferenceKey=parent.referenceKey,childReferenceKey=member.referenceKey,source=source,relation=relation} end
        return member
    end
    add(worker,nil,"operational-worker","root",0)
    local head=1
    while head<=#queue and #members<budget do
        local parent=queue[head]; head=head+1
        for _,child in ipairs(collectChildren(parent.object)) do add(child.object,parent,child.source,child.relation,parent.depth+1) end
    end
    table.sort(members,function(a,b) return a.referenceKey<b.referenceKey end)
    table.sort(edges,function(a,b) return a.parentReferenceKey.."|"..a.childReferenceKey<b.parentReferenceKey.."|"..b.childReferenceKey end)
    local values={}
    for _,member in ipairs(members) do values[#values+1]=member.referenceKey.."@"..member.asset.."@"..tostring(member.parent and member.parent.referenceKey or "root") end
    for _,edge in ipairs(edges) do values[#values+1]="edge:"..edge.parentReferenceKey..">"..edge.childReferenceKey..":"..tostring(edge.relation) end
    table.sort(values)
    return members,edges,table.concat(values,";"),#members>=budget and head<=#queue
end

local function asNode(value)
    if type(value)=="number" and value~=0 then return value end
    if type(value)=="table" then for _,key in ipairs({"node","nodeId","object","id","rootNode","componentNode"}) do local node=value[key]; if type(node)=="number" and node~=0 then return node end end end
    return nil
end
local function mappingNode(object,key)
    for _,field in ipairs({"i3dMappings","i3dMapping"}) do
        local mappings=object and object[field] or nil
        if type(mappings)=="table" then local node=asNode(mappings[key]); if node~=nil then return node,field end end
    end
    local ok,value=safeCall(object,"getI3DMapping",key); local node=ok and asNode(value) or nil
    return node,node and "getI3DMapping" or nil
end
local function donorFor(object)
    local asset=assetName(object)
    for _,catalogue in pairs(OuttaMyWay.RepresentationDonorCatalogues or {}) do if endsWith(asset,normaliseAsset(catalogue.assetSuffix)) then return catalogue end end
    return nil
end
local function donorPathNode(object,path)
    if path==nil or I3DUtil==nil or type(I3DUtil.indexToObject)~="function" then return nil,nil end
    local attempts={
        function() return I3DUtil.indexToObject(object.components,path,object.i3dMappings) end,
        function() return I3DUtil.indexToObject(object.components,path) end,
        function() return I3DUtil.indexToObject(object,path,object.i3dMappings) end
    }
    for index,attempt in ipairs(attempts) do
        local ok,value=pcall(attempt); local node=ok and asNode(value) or nil
        if node~=nil then return node,"I3DUtil.indexToObject#"..tostring(index) end
    end
    return nil,nil
end
local function collisionCandidateName(name)
    local lower=string.lower(tostring(name or ""))
    return string.find(lower,"collision",1,true)~=nil
        or string.find(lower,"colpart",1,true)~=nil
        or string.find(lower,"_col",1,true)~=nil
        or string.find(lower,"col%d")~=nil
        or string.sub(lower,-3)=="col"
end

local function foldState(object)
    local value=object and object.spec_foldable and tonumber(object.spec_foldable.foldAnimTime) or nil
    if value==nil then local ok,result=safeCall(object,"getFoldAnimTime"); if ok then value=tonumber(result) end end
    if value==nil then return "NOT_FOLDABLE_OR_UNKNOWN",nil end
    if value<=0.02 then return "DEPLOYED",value end
    if value>=0.98 then return "FOLDED",value end
    return "TRANSITION",value
end
local function loweredState(object)
    for _,methodName in ipairs({"getIsLowered","getIsLowering","getIsImplementLowered"}) do
        local ok,value=safeCall(object,methodName); if ok and type(value)=="boolean" then return value and "LOWERED" or "RAISED",methodName end
    end
    return "UNKNOWN","unavailable"
end
local function scalarConfigurations(object)
    local values={}
    for name,value in pairs(object and object.configurations or {}) do
        if type(value)=="number" or type(value)=="string" or type(value)=="boolean" then values[#values+1]=tostring(name).."="..tostring(value) end
    end
    table.sort(values)
    return values
end
local function configurationKey(members)
    local values={}
    for _,member in ipairs(members or {}) do
        local fold,foldTime=foldState(member.object); local lowered,loweredSource=loweredState(member.object)
        local selected=scalarConfigurations(member.object)
        values[#values+1]=member.referenceKey.."|fold="..fold.."|lowered="..lowered.."|selected="..table.concat(selected,",")
        member.currentConfiguration={foldState=fold,foldAnimTime=foldTime,loweredState=lowered,loweredSource=loweredSource,selectedConfigurations=selected}
    end
    table.sort(values); return table.concat(values,";")
end
local function foldConfigurationEvidence(members)
    local result={foldableCount=0,deployedCount=0,transitionCount=0,foldedCount=0,unknownCount=0}
    for _,member in ipairs(members or {}) do
        local state=member.currentConfiguration and member.currentConfiguration.foldState or "NOT_FOLDABLE_OR_UNKNOWN"
        local object=member.object
        local foldable=object~=nil and (object.spec_foldable~=nil or type(object.getFoldAnimTime)=="function")
        if foldable then
            result.foldableCount=result.foldableCount+1
            if state=="DEPLOYED" then result.deployedCount=result.deployedCount+1
            elseif state=="TRANSITION" then result.transitionCount=result.transitionCount+1
            elseif state=="FOLDED" then result.foldedCount=result.foldedCount+1
            else result.unknownCount=result.unknownCount+1 end
        end
    end
    result.allDeployed=result.foldableCount>0 and result.deployedCount==result.foldableCount
    result.allFolded=result.foldableCount>0 and result.foldedCount==result.foldableCount
    result.retainCurrent=result.foldableCount==0 or result.allFolded
    result.compactionSupported=result.retainCurrent or (result.unknownCount==0 and result.transitionCount==0 and result.allDeployed)
    return result
end
local function donorConfigurationEvidence(object,donor)
    if donor==nil then return {status="NOT_APPLICABLE",selector="n/a",selected=nil,expected=nil} end
    local name=donor.configurationName
    local selected=type(object and object.configurations)=="table" and object.configurations[name] or nil
    local expected=donor.configurationId
    local status
    if selected==nil then status="UNRESOLVED"
    elseif tonumber(selected)==tonumber(expected) then status="MATCHED"
    else status="MISMATCH" end
    return {status=status,selector=tostring(name or "n/a"),selected=selected,expected=expected,geometryFamily=donor.geometryFamily}
end

function Cache.new(options)
    return setmetatable({records={},seen={},options=options or {},retiredCount=0,configurationAuthorityWindows={}},Cache)
end
function Cache:reset() self.records={}; self.seen={}; self.retiredCount=0; self.configurationAuthorityWindows={} end

local function episodeKey(assemblyReferenceKey,sourceJobToken) return tostring(assemblyReferenceKey).."|"..tostring(sourceJobToken) end
function Cache:beginOuttaMyWayConfigurationAuthority(assemblyReferenceKey,sourceJobToken)
    local key=episodeKey(assemblyReferenceKey,sourceJobToken)
    self.configurationAuthorityWindows[key]=(self.configurationAuthorityWindows[key] or 0)+1
end
function Cache:endOuttaMyWayConfigurationAuthority(assemblyReferenceKey,sourceJobToken)
    local key=episodeKey(assemblyReferenceKey,sourceJobToken)
    local count=(self.configurationAuthorityWindows[key] or 0)-1
    if count>0 then self.configurationAuthorityWindows[key]=count else self.configurationAuthorityWindows[key]=nil end
end
function Cache:isOuttaMyWayConfigurationAuthorityActive(assemblyReferenceKey,sourceJobToken)
    return (self.configurationAuthorityWindows[episodeKey(assemblyReferenceKey,sourceJobToken)] or 0)>0
end
function Cache:beginObservationCycle() self.seen={} end
function Cache:endObservationCycle()
    for key in pairs(self.records) do if self.seen[key]~=true then self.records[key]=nil; self.retiredCount=self.retiredCount+1 end end
end

function Cache:_api(name) return functionOrGlobal(self.options.api,name) end
function Cache:_shapeClassEvidence(node)
    local fn=self:_api("getHasClassId")
    local classIds=(type(self.options.api)=="table" and self.options.api.ClassIds) or (type(_G)=="table" and _G.ClassIds) or nil
    local shapeClass=type(classIds)=="table" and classIds.SHAPE or nil
    if fn==nil or shapeClass==nil then return nil,"SHAPE_CLASS_API_UNAVAILABLE" end
    local ok,value=pcall(fn,node,shapeClass)
    if not ok then return nil,"SHAPE_CLASS_QUERY_FAILED:"..tostring(value) end
    if type(value)~="boolean" then return nil,"SHAPE_CLASS_QUERY_INVALID_RETURN" end
    return value,value and nil or "NOT_SHAPE"
end
function Cache:_callSphere(name,node,shapeVerified)
    if shapeVerified~=true then
        local isShape,shapeReason=self:_shapeClassEvidence(node)
        if isShape~=true then return {available=false,valid=false,error=shapeReason or "SHAPE_CLASS_UNRESOLVED",shapeClassVerified=isShape==false} end
    end
    local fn=self:_api(name); if fn==nil then return {available=false,valid=false,error="API_UNAVAILABLE",shapeClassVerified=true} end
    local ok,x,y,z,r,usesGeometry=pcall(fn,node,0)
    if not ok then return {available=true,valid=false,error=tostring(x),shapeClassVerified=true} end
    return {available=true,valid=validSphere(x,y,z,r),x=x,y=y,z=z,radius=r,usesGeometry=type(usesGeometry)=="boolean" and usesGeometry or nil,error=validSphere(x,y,z,r) and nil or "INVALID_RETURN",shapeClassVerified=true}
end
function Cache:_worldFromLocal(node,sphere)
    local fn=self:_api("localToWorld"); if fn==nil or sphere==nil or sphere.valid~=true then return nil end
    local ok,x,y,z=pcall(fn,node,sphere.x,sphere.y,sphere.z); if not ok or not finite(x) or not finite(y) or not finite(z) then return nil end
    return {valid=true,x=x,y=y,z=z,radius=sphere.radius}
end
function Cache:_runtimeName(node)
    local fn=self:_api("getName"); if fn==nil then return nil end
    local ok,value=pcall(fn,node); return ok and value~=nil and tostring(value) or nil
end
function Cache:_scanHierarchy(rootNode,budget,wanted,allowGeneric)
    local getCount=self:_api("getNumOfChildren"); local getChild=self:_api("getChildAt"); local getName=self:_api("getName")
    if rootNode==nil or getCount==nil or getChild==nil then return {},0,false end
    local found,queue,head,scanned={},{rootNode},1,0
    while head<=#queue and scanned<budget do
        local node=queue[head]; head=head+1; scanned=scanned+1
        local name=nil; if getName~=nil then local ok,value=pcall(getName,node); if ok and value~=nil then name=tostring(value) end end
        local donorEntry=wanted and wanted[name] or nil
        local candidate=donorEntry~=nil or (allowGeneric==true and collisionCandidateName(name))
        if candidate then found[#found+1]={node=node,name=name or "unnamed",source=donorEntry and "DONOR_NAME_SCAN" or "GENERIC_COLLISION_NAME_SCAN",entry=donorEntry} end
        local ok,count=pcall(getCount,node)
        if ok and type(count)=="number" then for index=0,count-1 do local okChild,child=pcall(getChild,node,index); if okChild and child~=nil and child~=0 then queue[#queue+1]=child end end end
    end
    return found,scanned,head<=#queue
end
function Cache:_measurePrimitive(member,node,name,source,class,rootWorld,donorEntry)
    local isShape,shapeReason=self:_shapeClassEvidence(node)
    if isShape~=true then
        return nil,{name=name,node=node,source=source,coherent=false,rootAlias=false,shapeReason=shapeReason or "SHAPE_CLASS_UNRESOLVED"},0
    end
    local geometry=self:_callSphere("getShapeGeometryBoundingSphere",node,true)
    local shape=self:_callSphere("getShapeBoundingSphere",node,true)
    local world=self:_callSphere("getShapeWorldBoundingSphere",node,true)
    local localSphere=geometry.valid and geometry or (shape.valid and shape or nil)
    local predicted=self:_worldFromLocal(node,localSphere)
    local centreError,radiusError=sphereDifference(predicted,world)
    local tolerance=OuttaMyWay.REPRESENTATION_GEOMETRY_COHERENCE_TOLERANCE_METRES or 0.05
    local coherent=localSphere~=nil and world.valid==true and centreError~=nil and centreError<=tolerance and radiusError~=nil and radiusError<=tolerance
    local aliasCentre,aliasRadius=sphereDifference(world,rootWorld)
    local aliasTolerance=OuttaMyWay.REPRESENTATION_ROOT_ALIAS_TOLERANCE_METRES or 0.0001
    local rootAlias=node~=member.object.rootNode and aliasCentre~=nil and aliasRadius~=nil and aliasCentre<=aliasTolerance and aliasRadius<=aliasTolerance
    if not coherent or rootAlias then
        return nil,{name=name,node=node,source=source,coherent=coherent,rootAlias=rootAlias,centreError=centreError,radiusError=radiusError,geometryError=geometry.error,shapeError=shape.error,worldError=world.error},3
    end
    return {
        identity=member.referenceKey..":sphere:"..tostring(node),kind="DISC",memberReferenceKey=member.referenceKey,node=node,nodeName=name,
        localCentre={x=localSphere.x,y=localSphere.y,z=localSphere.z},radius=localSphere.radius,
        source=source,class=class or "DISCOVERED_COLLISION_COMPONENT",positiveConflictSupport=false,negativeClearanceSupport=false,
        donorCurrentPhysical=donorEntry and donorEntry.donorCurrentPhysical or nil,
        provenance={geometryAPI=geometry.valid and "getShapeGeometryBoundingSphere" or "getShapeBoundingSphere",worldCoherence=true,rootAliasRejected=true,shapeClassVerified=true}
    },nil,3
end
function Cache:_discoverMemberGeometry(member)
    local stats={apiMeasurements=0,shapeClassChecks=1,hierarchyNodesScanned=0,scanTruncated=false,candidates=0,resolved=0,rejected=0,rejectedAliases=0,nonShapeRejected=0,shapeClassUnresolved=0,donorCandidates=0,genericCandidates=0}
    local primitives,rejections={},{}
    local rootWorld=self:_callSphere("getShapeWorldBoundingSphere",member.object.rootNode)
    if rootWorld.available==true then stats.apiMeasurements=stats.apiMeasurements+1 end
    local candidates,byNode={},{}
    local donor=donorFor(member.object)
    local wanted={}
    if donor~=nil then
        for _,entry in ipairs(donor.components or {}) do
            wanted[entry.name]=entry
            local node,source=mappingNode(member.object,entry.name)
            if node==nil then node,source=donorPathNode(member.object,entry.mappingPath); if node~=nil then source="DONOR_DECLARED_PATH:"..tostring(source) end end
            if node~=nil and byNode[node]==nil then byNode[node]=true; candidates[#candidates+1]={node=node,name=entry.name,source=(string.find(tostring(source),"DONOR_DECLARED_PATH",1,true) and tostring(source) or "DONOR_DIRECT_MAPPING:"..tostring(source)),class=entry.class,entry=entry}; stats.donorCandidates=stats.donorCandidates+1 end
        end
    end
    member.donorConfigurationEvidence=donorConfigurationEvidence(member.object,donor)
    local scanned,scannedCount,truncated=self:_scanHierarchy(member.object.rootNode,OuttaMyWay.REPRESENTATION_HIERARCHY_SCAN_BUDGET or 2200,wanted,donor==nil)
    stats.hierarchyNodesScanned=scannedCount; stats.scanTruncated=truncated
    for _,candidate in ipairs(scanned) do
        if byNode[candidate.node]==nil then
            byNode[candidate.node]=true
            local entry=candidate.entry or wanted[candidate.name]
            candidate.entry=entry
            candidate.class=entry and entry.class or "DISCOVERED_COLLISION_COMPONENT"
            candidates[#candidates+1]=candidate
            if entry then stats.donorCandidates=stats.donorCandidates+1 else stats.genericCandidates=stats.genericCandidates+1 end
        end
    end
    -- The member-root sphere is retained as partial physical evidence when coherent.
    if member.object.rootNode~=nil and byNode[member.object.rootNode]~=true then
        candidates[#candidates+1]={node=member.object.rootNode,name="MEMBER_ROOT",source="MEMBER_ROOT_GEOMETRY",class="MEMBER_ROOT_PARTIAL"}; byNode[member.object.rootNode]=true
    end
    table.sort(candidates,function(a,b) return tostring(a.node)<tostring(b.node) end)
    stats.candidates=#candidates
    for _,candidate in ipairs(candidates) do
        stats.shapeClassChecks=stats.shapeClassChecks+1
        local primitive,rejection,apiMeasurements=self:_measurePrimitive(member,candidate.node,candidate.name,candidate.source,candidate.class,rootWorld,candidate.entry)
        stats.apiMeasurements=stats.apiMeasurements+(apiMeasurements or 0)
        if primitive~=nil then primitives[#primitives+1]=primitive; stats.resolved=stats.resolved+1
        else rejections[#rejections+1]=rejection; stats.rejected=stats.rejected+1; if rejection.rootAlias then stats.rejectedAliases=stats.rejectedAliases+1 end; if rejection.shapeReason=="NOT_SHAPE" then stats.nonShapeRejected=stats.nonShapeRejected+1 elseif rejection.shapeReason~=nil then stats.shapeClassUnresolved=stats.shapeClassUnresolved+1 end end
    end
    local width=tonumber(member.object.sizeWidth); local length=tonumber(member.object.sizeLength)
    if width~=nil and width>0 and length~=nil and length>0 then
        primitives[#primitives+1]={identity=member.referenceKey..":metadata-rectangle",kind="LOCAL_RECTANGLE",memberReferenceKey=member.referenceKey,node=member.object.rootNode,halfWidth=width/2,halfLength=length/2,source="SIZE_METADATA_UNVERIFIED",positiveConflictSupport=false,negativeClearanceSupport=false}
    end
    return primitives,rejections,stats,donor
end
function Cache:_build(worker,assemblyReferenceKey,sourceJobToken,nowSeconds)
    local members,edges,fingerprint,truncated=discoverAssembly(worker,OuttaMyWay.REPRESENTATION_ASSEMBLY_MEMBER_BUDGET or 32)
    local record={
        episodeKey=assemblyReferenceKey.."|"..tostring(sourceJobToken),assemblyReferenceKey=assemblyReferenceKey,sourceJobToken=sourceJobToken,
        createdAt=nowSeconds,members=members,edges=edges,assemblyFingerprint=fingerprint,assemblyDiscoveryTruncated=truncated,
        localPrimitives={},primitiveById={},memberByReference={},rejections={},profiles={},geometryStats={apiMeasurements=0,shapeClassChecks=0,hierarchyNodesScanned=0,candidates=0,resolved=0,rejected=0,rejectedAliases=0,nonShapeRejected=0,shapeClassUnresolved=0,donorMembers=0,genericMembers=0,runtimeActivityChecks=0},
        structurallyValid=true,coverageComplete=false,conservativeForRepresentedComponents=true,negativeClearanceAuthority=false
    }
    for _,member in ipairs(members) do
        local primitives,rejections,stats,donor=self:_discoverMemberGeometry(member)
        member.localPrimitiveCount=#primitives; member.geometryStats=stats; member.donorCatalogue=donor and donor.sourceEvidence or nil
        record.memberByReference[member.referenceKey]=member
        if donor then record.geometryStats.donorMembers=record.geometryStats.donorMembers+1 else record.geometryStats.genericMembers=record.geometryStats.genericMembers+1 end
        for _,primitive in ipairs(primitives) do record.localPrimitives[#record.localPrimitives+1]=primitive; record.primitiveById[primitive.identity]=primitive end
        for _,rejection in ipairs(rejections) do record.rejections[#record.rejections+1]=rejection end
        for key,value in pairs(stats) do if type(value)=="number" and record.geometryStats[key]~=nil then record.geometryStats[key]=record.geometryStats[key]+value end end
    end
    record.structurallyValid=#record.localPrimitives>0
    return record
end
function Cache:_worldPrimitive(localPrimitive,participation)
    local localToWorldFn=self:_api("localToWorld")
    local positive=participation and participation.positiveConflictSupport==true or false
    if localPrimitive.kind=="DISC" then
        if localToWorldFn==nil then return nil,"LOCAL_TO_WORLD_UNAVAILABLE" end
        local c=localPrimitive.localCentre; local ok,x,y,z=pcall(localToWorldFn,localPrimitive.node,c.x,c.y,c.z)
        if not ok or not finite(x) or not finite(z) then return nil,"WORLD_TRANSFORM_FAILED" end
        return {identity=localPrimitive.identity,kind="DISC",x=x,y=y,z=z,radius=localPrimitive.radius,memberReferenceKey=localPrimitive.memberReferenceKey,nodeName=localPrimitive.nodeName,source=localPrimitive.source,class=localPrimitive.class,positiveConflictSupport=positive,negativeClearanceSupport=false,participationStatus=participation and participation.status or "UNRESOLVED",runtimeCompoundChild=participation and participation.runtimeCompoundChild or nil,donorCurrentPhysical=localPrimitive.donorCurrentPhysical},nil
    end
    if localPrimitive.kind=="LOCAL_RECTANGLE" then
        if localToWorldFn==nil then return nil,"LOCAL_TO_WORLD_UNAVAILABLE" end
        local corners={}
        for _,offset in ipairs({{-localPrimitive.halfWidth,-localPrimitive.halfLength},{localPrimitive.halfWidth,-localPrimitive.halfLength},{localPrimitive.halfWidth,localPrimitive.halfLength},{-localPrimitive.halfWidth,localPrimitive.halfLength}}) do
            local ok,x,y,z=pcall(localToWorldFn,localPrimitive.node,offset[1],0,offset[2]); if not ok then return nil,"WORLD_TRANSFORM_FAILED" end
            corners[#corners+1]={x=x,y=y,z=z}
        end
        return {identity=localPrimitive.identity,kind="ORIENTED_RECTANGLE",corners=corners,memberReferenceKey=localPrimitive.memberReferenceKey,source=localPrimitive.source,positiveConflictSupport=false,negativeClearanceSupport=false,participationStatus="DIAGNOSTIC_ONLY"},nil
    end
    return nil,"UNKNOWN_PRIMITIVE_KIND"
end
function Cache:_runtimeCompoundChild(node)
    local fn=self:_api("getIsCompoundChild")
    if fn==nil then return nil,"API_UNAVAILABLE" end
    local ok,value=pcall(fn,node)
    if not ok or type(value)~="boolean" then return nil,ok and "INVALID_RETURN" or tostring(value) end
    return value,nil
end
local function referenceFrameForWorker(worker)
    if worker==nil then return nil end
    local node=nil
    local okSteering,steering=safeCall(worker,"getAISteeringNode")
    if okSteering and steering~=nil and steering~=0 then node=steering else node=worker.rootNode end
    if node==nil or node==0 or type(getWorldTranslation)~="function" or type(localDirectionToWorld)~="function" then return nil end
    local okPos,x,_,z=pcall(getWorldTranslation,node)
    local okDir,dx,_,dz=pcall(localDirectionToWorld,node,0,0,1)
    if not okPos or not okDir or not finite(x) or not finite(z) or not finite(dx) or not finite(dz) then return nil end
    local length=math.sqrt(dx*dx+dz*dz)
    if length<=0.0001 then return nil end
    dx,dz=dx/length,dz/length
    return {x=x,z=z,forwardX=dx,forwardZ=dz,rightX=dz,rightZ=-dx}
end
local function relativeDiscSnapshot(worldPrimitives,frame)
    if type(frame)~="table" then return nil end
    local result={}
    for _,primitive in ipairs(worldPrimitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true and finite(tonumber(primitive.x)) and finite(tonumber(primitive.z)) and finite(tonumber(primitive.radius)) and tonumber(primitive.radius)>0 then
            local dx,dz=tonumber(primitive.x)-frame.x,tonumber(primitive.z)-frame.z
            result[#result+1]={localRightM=dx*frame.rightX+dz*frame.rightZ,localForwardM=dx*frame.forwardX+dz*frame.forwardZ,radius=tonumber(primitive.radius),identity=primitive.identity}
        end
    end
    if #result<1 then return nil end
    table.sort(result,function(a,b) return tostring(a.identity)<tostring(b.identity) end)
    return result
end

function Cache:_configurationAlternatives(record,currentProfileId)
    local result={}
    for _,profile in pairs(record and record.profiles or {}) do
        local evidence=profile.configurationEvidence or {}
        if profile.relativeDiscs~=nil and (profile.nativeObservationCount or 0)>0 and (evidence.allFolded==true or evidence.allDeployed==true) then
            local discs={}
            for _,disc in ipairs(profile.relativeDiscs) do discs[#discs+1]={localRightM=disc.localRightM,localForwardM=disc.localForwardM,radius=disc.radius,identity=disc.identity} end
            result[#result+1]={
                configurationProfileId=profile.identity,configurationKey=profile.configurationKey,configurationEvidence=evidence,relativeDiscs=discs,
                nativeObservationCount=profile.nativeObservationCount or 0,outtaMyWayObservationCount=profile.outtaMyWayObservationCount or 0,
                current=profile.identity==currentProfileId,authority="OBSERVED_WITHOUT_OUTTAMYWAY_CONFIGURATION_AUTHORITY"
            }
        end
    end
    table.sort(result,function(a,b) return tostring(a.configurationProfileId)<tostring(b.configurationProfileId) end)
    return result
end
function Cache:getCurrentConfigurationProfileId(assemblyReferenceKey,sourceJobToken)
    local record=self.records[episodeKey(assemblyReferenceKey,sourceJobToken)]
    return record and record.currentProfileId or nil
end

function Cache:_buildProfile(record,key,config,nowSeconds)
    local profile={identity=key..":configuration:"..tostring(countKeys(record.profiles)+1),configurationKey=config,firstObservedAt=nowSeconds,observations=0,nativeObservationCount=0,outtaMyWayObservationCount=0,configurationEvidence=foldConfigurationEvidence(record.members),relativeDiscs=nil,participationById={},includedPrimitiveIds={},participatingPrimitiveNames={},inactivePrimitiveNames={},unresolvedPrimitiveNames={},diagnosticPrimitiveNames={},runtimeConfirmedCount=0,donorFallbackCount=0}
    local selectors={}
    for _,member in ipairs(record.members or {}) do
        local evidence=member.donorConfigurationEvidence
        if evidence and evidence.status~="NOT_APPLICABLE" then selectors[#selectors+1]=member.referenceKey..":"..evidence.selector.."="..tostring(evidence.selected or "n/a").."/"..tostring(evidence.expected or "n/a")..":"..evidence.status end
    end
    table.sort(selectors); profile.configurationSelectorSummary=#selectors>0 and table.concat(selectors,",") or "NO_DONOR_SELECTOR"
    for _,primitive in ipairs(record.localPrimitives) do
        local participation={status="UNRESOLVED",positiveConflictSupport=false,runtimeCompoundChild=nil}
        local member=record.memberByReference[primitive.memberReferenceKey]
        local configEvidence=member and member.donorConfigurationEvidence or nil
        if primitive.kind=="LOCAL_RECTANGLE" then
            participation.status="DIAGNOSTIC_ONLY"; profile.includedPrimitiveIds[#profile.includedPrimitiveIds+1]=primitive.identity; profile.diagnosticPrimitiveNames[#profile.diagnosticPrimitiveNames+1]=primitive.nodeName or primitive.identity
        elseif primitive.class=="MEMBER_ROOT_PARTIAL" then
            participation.status="MEMBER_ROOT_PARTIAL"; participation.positiveConflictSupport=true; profile.includedPrimitiveIds[#profile.includedPrimitiveIds+1]=primitive.identity; profile.participatingPrimitiveNames[#profile.participatingPrimitiveNames+1]=primitive.nodeName or primitive.identity
        else
            local compoundChild=self:_runtimeCompoundChild(primitive.node); record.geometryStats.runtimeActivityChecks=record.geometryStats.runtimeActivityChecks+1
            participation.runtimeCompoundChild=compoundChild
            if compoundChild==true then
                participation.status="RUNTIME_COMPOUND_CHILD_CONFIRMED"; participation.positiveConflictSupport=true; profile.runtimeConfirmedCount=profile.runtimeConfirmedCount+1
                profile.includedPrimitiveIds[#profile.includedPrimitiveIds+1]=primitive.identity; profile.participatingPrimitiveNames[#profile.participatingPrimitiveNames+1]=primitive.nodeName or primitive.identity
            elseif compoundChild==false then
                participation.status="RUNTIME_COMPOUND_CHILD_INACTIVE"; profile.inactivePrimitiveNames[#profile.inactivePrimitiveNames+1]=primitive.nodeName or primitive.identity
            elseif primitive.donorCurrentPhysical==true and configEvidence and configEvidence.status=="MATCHED" then
                participation.status="MATCHED_DONOR_FALLBACK"; participation.positiveConflictSupport=true; profile.donorFallbackCount=profile.donorFallbackCount+1
                profile.includedPrimitiveIds[#profile.includedPrimitiveIds+1]=primitive.identity; profile.participatingPrimitiveNames[#profile.participatingPrimitiveNames+1]=primitive.nodeName or primitive.identity
            else
                profile.unresolvedPrimitiveNames[#profile.unresolvedPrimitiveNames+1]=primitive.nodeName or primitive.identity
            end
        end
        profile.participationById[primitive.identity]=participation
    end
    for _,values in ipairs({profile.participatingPrimitiveNames,profile.inactivePrimitiveNames,profile.unresolvedPrimitiveNames,profile.diagnosticPrimitiveNames}) do table.sort(values) end
    profile.inventoryPrimitiveCount=#record.localPrimitives
    profile.participatingPrimitiveCount=#profile.participatingPrimitiveNames
    profile.inactivePrimitiveCount=#profile.inactivePrimitiveNames
    profile.unresolvedPrimitiveCount=#profile.unresolvedPrimitiveNames
    profile.diagnosticPrimitiveCount=#profile.diagnosticPrimitiveNames
    return profile
end

function Cache:observe(worker,assemblyReferenceKey,sourceJobToken,nowSeconds)
    local key=episodeKey(assemblyReferenceKey,sourceJobToken)
    self.seen[key]=true
    local record=self.records[key]
    local cacheHit=record~=nil
    if record==nil then record=self:_build(worker,assemblyReferenceKey,sourceJobToken,nowSeconds); self.records[key]=record end
    local interval=OuttaMyWay.REPRESENTATION_ASSEMBLY_REVALIDATION_INTERVAL_SECONDS or 5
    if record.lastAssemblyValidationAt==nil or nowSeconds-record.lastAssemblyValidationAt>=interval then
        record.lastAssemblyValidationAt=nowSeconds
        local members,_,fingerprint=discoverAssembly(worker,OuttaMyWay.REPRESENTATION_ASSEMBLY_MEMBER_BUDGET or 32)
        record.lastObservedMemberCount=#members
        if fingerprint~=record.assemblyFingerprint then record.membershipChanged=true; record.structurallyValid=false; record.membershipChangeObservedAt=nowSeconds end
    end
    local config=configurationKey(record.members)
    local profile=record.profiles[config]
    local profileCacheHit=profile~=nil
    if profile==nil then
        profile=self:_buildProfile(record,key,config,nowSeconds)
        record.profiles[config]=profile
    end
    profile.observations=profile.observations+1; profile.lastObservedAt=nowSeconds
    local underOuttaMyWayAuthority=self:isOuttaMyWayConfigurationAuthorityActive(assemblyReferenceKey,sourceJobToken)
    if underOuttaMyWayAuthority then profile.outtaMyWayObservationCount=profile.outtaMyWayObservationCount+1 else profile.nativeObservationCount=profile.nativeObservationCount+1 end
    record.currentProfileId=profile.identity
    record.currentConfigurationKey=config
    local worldPrimitives,transformFailures={},{}
    if record.membershipChanged~=true then
        for _,primitiveId in ipairs(profile.includedPrimitiveIds or {}) do
            local primitive=record.primitiveById[primitiveId]
            local participation=profile.participationById[primitiveId]
            local world,errorReason=self:_worldPrimitive(primitive,participation)
            if world~=nil then worldPrimitives[#worldPrimitives+1]=world else transformFailures[#transformFailures+1]={primitiveId=primitive.identity,reason=errorReason} end
        end
    end
    local frame=referenceFrameForWorker(worker)
    local relativeDiscs=relativeDiscSnapshot(worldPrimitives,frame)
    if relativeDiscs~=nil then profile.relativeDiscs=relativeDiscs end
    local summary=OuttaMyWay.PlanViewFootprint.summarise(worldPrimitives)
    return {
        episodeKey=key,assemblyReferenceKey=assemblyReferenceKey,sourceJobToken=sourceJobToken,cacheHit=cacheHit,
        assemblyFingerprint=record.assemblyFingerprint,membershipChanged=record.membershipChanged==true,memberCount=#record.members,edgeCount=#record.edges,
        assemblyDiscoveryTruncated=record.assemblyDiscoveryTruncated,localPrimitiveCount=#record.localPrimitives,worldPrimitiveCount=#worldPrimitives,
        inventoryPrimitiveCount=profile.inventoryPrimitiveCount,participatingPrimitiveCount=profile.participatingPrimitiveCount,inactivePrimitiveCount=profile.inactivePrimitiveCount,unresolvedPrimitiveCount=profile.unresolvedPrimitiveCount,
        runtimeConfirmedPrimitiveCount=profile.runtimeConfirmedCount,donorFallbackPrimitiveCount=profile.donorFallbackCount,configurationSelectorSummary=profile.configurationSelectorSummary,
        participatingPrimitiveNames=profile.participatingPrimitiveNames,inactivePrimitiveNames=profile.inactivePrimitiveNames,unresolvedPrimitiveNames=profile.unresolvedPrimitiveNames,
        physicalPrimitiveCount=summary.physicalPrimitiveCount,diagnosticPrimitiveCount=summary.diagnosticPrimitiveCount,
        configurationKey=config,configurationEvidence=foldConfigurationEvidence(record.members),configurationProfileId=profile.identity,configurationProfileCacheHit=profileCacheHit,configurationProfileCount=countKeys(record.profiles),configurationAlternatives=self:_configurationAlternatives(record,profile.identity),outtaMyWayConfigurationAuthorityActive=underOuttaMyWayAuthority,
        structurallyValid=record.structurallyValid and profile.participatingPrimitiveCount>0,coverageComplete=false,conservativeForRepresentedComponents=record.conservativeForRepresentedComponents,
        negativeClearanceAuthority=false,claimPermissions={"POTENTIAL_INTERACTION_FROM_REPRESENTED_COMPONENTS"},
        worldPrimitives=worldPrimitives,planViewSummary=summary,geometryStats=record.geometryStats,transformFailureCount=#transformFailures,
        rejectionCount=#record.rejections,retiredCacheCount=self.retiredCount,
        provenance={source="AssemblyRepresentationCache",donors="v4.6.10-v4.6.21 prototypes",assemblyLifetime="JOB_EPISODE",worldFootprintLifetime="PASSIVE_SAMPLE"}
    }
end
