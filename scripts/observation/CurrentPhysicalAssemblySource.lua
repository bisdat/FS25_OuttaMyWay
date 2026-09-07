OuttaMyWay.CurrentPhysicalAssemblySource = {}
local Source = OuttaMyWay.CurrentPhysicalAssemblySource
Source.__index = Source

local function logInfo(formatText, ...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][CURRENT-PHYSICAL-ASSEMBLY] %s",message)
    else
        print("[FS25_OuttaMyWay][CURRENT-PHYSICAL-ASSEMBLY] "..message)
    end
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

local function rootVehicle(object)
    if not usableVehicle(object) then return nil end
    local ok,root=safeCall(object,"getRootVehicle")
    if ok and usableVehicle(root) then return root end
    if usableVehicle(object.rootVehicle) then return object.rootVehicle end
    return object
end

local function assemblyReferenceKey(root)
    return "vehicle-root:"..tostring(root.rootNode)
end

local function memberReferenceKey(member)
    return "component-root:"..tostring(member.rootNode)
end

local function objectName(object)
    local ok,value=safeCall(object,"getName")
    if ok and value~=nil and value~="" then return tostring(value) end
    return tostring(object.name or object.typeName or "vehicle")
end

local function memberPosition(member)
    local node=member and member.rootNode or nil
    if node==nil or node==0 then return nil,"ROOT_NODE_UNAVAILABLE" end
    if type(getWorldTranslation)~="function" then return nil,"WORLD_TRANSLATION_API_UNAVAILABLE" end
    local ok,x,y,z=pcall(getWorldTranslation,node)
    if not ok then return nil,"WORLD_TRANSLATION_FAILED" end
    if type(x)~="number" or type(z)~="number" then return nil,"WORLD_POSITION_INVALID" end
    return {
        x=x,y=y,z=z,
        memberReferenceKey=memberReferenceKey(member),
        provenance="MEMBER_ROOT_NODE_WORLD_POSITION"
    },nil
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
    local source="ROOT_ONLY"
    if ok and type(children)=="table" then
        source="GIANTS_GET_CHILD_VEHICLES"
        for _,child in OuttaMyWay.ValueRecord.pairs(children) do add(child) end
    end
    table.sort(result,function(a,b) return tostring(a.rootNode)<tostring(b.rootNode) end)
    return result,source
end

local function observeCurrentState(root,mission)
    local okAI,aiActive=safeCall(root,"getIsAIActive")
    local okField,fieldActive=safeCall(root,"getIsFieldWorkActive")
    local okEntered,entered=safeCall(root,"getIsEntered")
    local specFieldActive=root.spec_aiFieldWorker~=nil and root.spec_aiFieldWorker.isActive==true
    local blocked=root.spec_aiFieldWorker~=nil and root.spec_aiFieldWorker.isBlocked==true
    local controlledRoot=rootVehicle(mission and mission.controlledVehicle or nil)
    return {
        aiActive=okAI and aiActive==true or false,
        aiActiveObserved=okAI==true,
        fieldActive=(okField and fieldActive==true) or specFieldActive,
        playerEntered=okEntered and entered==true or false,
        playerEnteredObserved=okEntered==true,
        playerControlled=controlledRoot==root,
        blocked=blocked,
        speedMps=math.abs(tonumber(root.lastSpeedReal) or 0)*1000
    }
end

local function recordSignature(records)
    local values={}
    for _,record in OuttaMyWay.ValueRecord.ipairs(records or {}) do
        values[#values+1]=tostring(record.name).."="..tostring(record.referenceKey)
    end
    table.sort(values)
    return table.concat(values,",")
end

function Source.new()
    return setmetatable({
        records={},objectsByReferenceKey={},lastMissionSignature=nil,lastFieldSignatures={},diagnostics={}
    },Source)
end

function Source:reset()
    self.records={}
    self.objectsByReferenceKey={}
    self.lastMissionSignature=nil
    self.lastFieldSignatures={}
    self.diagnostics={}
end

function Source:observe(mission)
    self.records={}
    self.objectsByReferenceKey={}
    local vehicleSystem=mission and mission.vehicleSystem or nil
    local vehicles=vehicleSystem and vehicleSystem.vehicles or nil
    if type(vehicles)~="table" then
        self.diagnostics={available=false,reason="MISSION_VEHICLE_SYSTEM_UNAVAILABLE",missionVehicleEntryCount=0,rootAssemblyCount=0}
        return self.records,self.diagnostics
    end

    local roots,seenRoots={},{}
    local missionVehicleEntryCount=0
    local function addRoot(object)
        local root=rootVehicle(object)
        if root~=nil and not seenRoots[root] then
            seenRoots[root]=true
            roots[#roots+1]=root
        end
    end

    for key,value in OuttaMyWay.ValueRecord.pairs(vehicles) do
        missionVehicleEntryCount=missionVehicleEntryCount+1
        addRoot(value)
        if type(key)=="table" then addRoot(key) end
    end
    table.sort(roots,function(a,b) return tostring(a.rootNode)<tostring(b.rootNode) end)

    local unresolvedMemberPositionCount=0
    for _,root in OuttaMyWay.ValueRecord.ipairs(roots) do
        local members,memberSource=currentMembers(root)
        local memberReferenceKeys,memberPositions={},{}
        for _,member in OuttaMyWay.ValueRecord.ipairs(members) do
            memberReferenceKeys[#memberReferenceKeys+1]=memberReferenceKey(member)
            local position=memberPosition(member)
            if position~=nil then
                memberPositions[#memberPositions+1]=position
            else
                unresolvedMemberPositionCount=unresolvedMemberPositionCount+1
            end
        end
        table.sort(memberReferenceKeys)
        table.sort(memberPositions,function(a,b) return a.memberReferenceKey<b.memberReferenceKey end)

        local state=observeCurrentState(root,mission)
        local ref=assemblyReferenceKey(root)
        local record={
            referenceKey=ref,name=objectName(root),
            memberReferenceKeys=memberReferenceKeys,memberPositions=memberPositions,
            memberCount=#members,memberPositionCount=#memberPositions,memberSource=memberSource,
            aiActive=state.aiActive,aiActiveObserved=state.aiActiveObserved,fieldActive=state.fieldActive,
            playerEntered=state.playerEntered,playerEnteredObserved=state.playerEnteredObserved,playerControlled=state.playerControlled,
            blocked=state.blocked,speedMps=state.speedMps,
            provenance={
                populationSource="mission.vehicleSystem.vehicles",
                assemblyRootSource="getRootVehicle",
                assemblyMemberSource=memberSource,
                semanticAuthority=false,
                negativeExclusionAuthority=false
            }
        }
        self.records[#self.records+1]=record
        self.objectsByReferenceKey[ref]=root
    end

    self.diagnostics={
        available=true,
        reason="CURRENT_GIANTS_MISSION_VEHICLE_POPULATION_OBSERVED",
        missionVehicleEntryCount=missionVehicleEntryCount,
        rootAssemblyCount=#self.records,
        unresolvedMemberPositionCount=unresolvedMemberPositionCount
    }

    local signature=recordSignature(self.records)
    if signature~=self.lastMissionSignature then
        self.lastMissionSignature=signature
        logInfo("MISSION populationEntries=%d rootAssemblies=%d assemblies=%s",missionVehicleEntryCount,#self.records,signature)
    end
    return self.records,self.diagnostics
end

function Source:observeFieldWorldPresence(records,snapshots,fieldWorldReferenceKey)
    local snapshotList={}
    for _,snapshot in OuttaMyWay.ValueRecord.pairs(snapshots or {}) do snapshotList[#snapshotList+1]=snapshot end
    table.sort(snapshotList,function(a,b) return tostring(a.referenceKey)<tostring(b.referenceKey) end)

    local result={}
    for _,record in OuttaMyWay.ValueRecord.ipairs(records or {}) do
        local witnesses={}
        local evaluatedPositionCount,unresolvedPositionCount=0,0
        for _,snapshot in OuttaMyWay.ValueRecord.ipairs(snapshotList) do
            for _,position in OuttaMyWay.ValueRecord.ipairs(record.memberPositions or {}) do
                local verdict=OuttaMyWay.FieldWorldSnapshotRegistry.evaluatePositionContainment(snapshot,position.x,position.z)
                if verdict.resolved==true then evaluatedPositionCount=evaluatedPositionCount+1 else unresolvedPositionCount=unresolvedPositionCount+1 end
                if verdict.resolved==true and verdict.inside==true then
                    witnesses[#witnesses+1]={
                        snapshotReferenceKey=snapshot.referenceKey,
                        memberReferenceKey=position.memberReferenceKey,
                        x=position.x,z=position.z,
                        kind="CURRENT_MEMBER_POSITION_INSIDE_FIELD_WORLD_SNAPSHOT"
                    }
                end
            end
        end
        if #witnesses>0 then
            result[#result+1]={
                assembly=record,
                fieldWorldPresenceEvidence={
                    positive=true,
                    kind="CURRENT_MEMBER_POSITION_WITNESS",
                    fieldWorldReferenceKey=fieldWorldReferenceKey,
                    snapshotCount=#snapshotList,
                    evaluatedPositionCount=evaluatedPositionCount,
                    unresolvedPositionCount=unresolvedPositionCount,
                    witnesses=witnesses,
                    coverageComplete=false,
                    negativeExclusionAuthority=false,
                    semanticAuthority=false
                }
            }
        end
    end
    table.sort(result,function(a,b) return a.assembly.referenceKey<b.assembly.referenceKey end)

    local names={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(result) do
        names[#names+1]=tostring(item.assembly.name).."="..tostring(item.assembly.referenceKey)
    end
    table.sort(names)
    local signature=table.concat(names,",")
    local fieldKey=tostring(fieldWorldReferenceKey)
    if self.lastFieldSignatures[fieldKey]~=signature then
        self.lastFieldSignatures[fieldKey]=signature
        logInfo("FIELD-WITNESS world=%s assemblies=%d witnessed=%s coverageComplete=false negativeExclusionAuthority=false",fieldKey,#result,signature)
    end
    return result
end

function Source:getObject(referenceKey)
    local object=self.objectsByReferenceKey and self.objectsByReferenceKey[referenceKey] or nil
    if not usableVehicle(object) then return nil end
    return object
end
