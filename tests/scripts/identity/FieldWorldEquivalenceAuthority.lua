OuttaMyWay.FieldWorldEquivalenceAuthority = {}
local Authority = OuttaMyWay.FieldWorldEquivalenceAuthority
Authority.__index = Authority

local function logInfo(message)
    if Logging ~= nil and type(Logging.info) == "function" then
        Logging.info("[FS25_OuttaMyWay][FIELD-WORLD-AUTHORITY] %s", message)
    else
        print("[FS25_OuttaMyWay][FIELD-WORLD-AUTHORITY] " .. message)
    end
end

local function sortedClassKeys(classes)
    local result={}
    for key in OuttaMyWay.ValueRecord.pairs(classes) do result[#result+1]=key end
    table.sort(result)
    return result
end

local function copyArray(values)
    local result={}
    for index,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do result[index]=value end
    return result
end

local function sortedSnapshotReferenceKeys(snapshotReferenceKeys)
    local result={}
    for key in OuttaMyWay.ValueRecord.pairs(snapshotReferenceKeys or {}) do result[#result+1]=key end
    table.sort(result)
    return result
end

function Authority.new(identityRegistry, evaluator)
    return setmetatable({
        identities=identityRegistry,
        evaluator=evaluator,
        classes={},
        assignments={},
        comparisonRecords={},
        resolutionRecords={},
        retiredClasses={},
        cycleOpen=false
    }, Authority)
end

function Authority:reset()
    self.classes={}; self.assignments={}; self.comparisonRecords={}; self.resolutionRecords={}; self.retiredClasses={}; self.cycleOpen=false
end

function Authority:beginObservationCycle()
    self.cycleOpen=true
    for _,class in OuttaMyWay.ValueRecord.pairs(self.classes) do class.relevantThisCycle=false end
end

function Authority:_appendComparison(record)
    self.comparisonRecords[#self.comparisonRecords+1]=record
    local maximum=OuttaMyWay.FIELD_WORLD_EQUIVALENCE_MAX_COMPARISONS or 128
    while #self.comparisonRecords>maximum do table.remove(self.comparisonRecords,1) end
end

function Authority:_appendResolution(record)
    self.resolutionRecords[#self.resolutionRecords+1]=record
    local maximum=OuttaMyWay.FIELD_WORLD_EQUIVALENCE_MAX_RESOLUTIONS or 128
    while #self.resolutionRecords>maximum do table.remove(self.resolutionRecords,1) end
end

function Authority:_evaluateClass(snapshot, class)
    local evaluations={}
    local allSame=true
    local allDifferent=true
    for _,member in OuttaMyWay.ValueRecord.ipairs(class.snapshots) do
        local evaluation=self.evaluator:evaluate(snapshot,member)
        evaluation.fieldWorldReferenceKey=class.referenceKey
        self:_appendComparison(evaluation)
        evaluations[#evaluations+1]=evaluation
        if evaluation.outcome~="SAME_FIELD_WORLD" then allSame=false end
        if evaluation.outcome~="DIFFERENT_FIELD_WORLD" then allDifferent=false end
    end
    local outcome="UNRESOLVED"
    if #evaluations>0 and allSame then outcome="SAME_FIELD_WORLD"
    elseif #evaluations>0 and allDifferent then outcome="DIFFERENT_FIELD_WORLD" end
    return {fieldWorldReferenceKey=class.referenceKey,outcome=outcome,evaluations=evaluations}
end

function Authority:_mintClass(snapshot, outcome, reason, classComparisons)
    local identity=self.identities:issue("FIELD_WORLD")
    local referenceKey="field-world:equivalence:FWE1:"..identity
    local class={
        identity=identity,
        referenceKey=referenceKey,
        snapshots={snapshot},
        snapshotReferenceKeys={[snapshot.referenceKey]=true},
        relevantThisCycle=true,
        createdFromSnapshotReferenceKey=snapshot.referenceKey
    }
    self.classes[referenceKey]=class
    local result={
        outcome=outcome,
        reason=reason,
        fieldWorldReferenceKey=referenceKey,
        fieldWorldIdentity=identity,
        fieldWorldSnapshotReferenceKey=snapshot.referenceKey,
        classComparisons=classComparisons or {},
        classWideCoherence=true,
        establishedNewFieldWorld=true,
        controlAuthorityEnabled=false
    }
    self.assignments[snapshot.referenceKey]=result
    self:_appendResolution(result)
    logInfo(string.format("RESOLVED snapshot=%s outcome=%s world=%s reason=%s classSnapshots=1 control=false",tostring(snapshot.referenceKey),outcome,referenceKey,reason))
    return result
end

function Authority:_joinClass(snapshot, class, classComparisons)
    class.snapshots[#class.snapshots+1]=snapshot
    class.snapshotReferenceKeys[snapshot.referenceKey]=true
    class.relevantThisCycle=true
    local result={
        outcome="SAME_FIELD_WORLD",
        reason="CLASS_WIDE_POSITIVE_SPATIAL_EQUIVALENCE",
        fieldWorldReferenceKey=class.referenceKey,
        fieldWorldIdentity=class.identity,
        fieldWorldSnapshotReferenceKey=snapshot.referenceKey,
        classComparisons=classComparisons,
        classWideCoherence=true,
        establishedNewFieldWorld=false,
        controlAuthorityEnabled=false
    }
    self.assignments[snapshot.referenceKey]=result
    self:_appendResolution(result)
    logInfo(string.format("RESOLVED snapshot=%s outcome=SAME_FIELD_WORLD world=%s reason=%s classSnapshots=%d control=false",tostring(snapshot.referenceKey),class.referenceKey,result.reason,#class.snapshots))
    return result
end

function Authority:markRelevant(snapshotReferenceKey)
    local assignment=self.assignments[snapshotReferenceKey]
    if assignment==nil or assignment.fieldWorldReferenceKey==nil then return false end
    local class=self.classes[assignment.fieldWorldReferenceKey]
    if class==nil then return false end
    class.relevantThisCycle=true
    return true
end

function Authority:resolve(snapshot)
    if type(snapshot)~="table" or type(snapshot.referenceKey)~="string" then error("Field World equivalence resolution requires an immutable Snapshot reference",2) end
    local existing=self.assignments[snapshot.referenceKey]
    if existing~=nil then self:markRelevant(snapshot.referenceKey); return existing end

    local classKeys=sortedClassKeys(self.classes)
    if #classKeys==0 then
        return self:_mintClass(snapshot,"DIFFERENT_FIELD_WORLD","NO_EXISTING_FIELD_WORLD_EVIDENCE",{})
    end

    local classComparisons={}
    local sameClasses={}
    local differentCount=0
    for _,key in OuttaMyWay.ValueRecord.ipairs(classKeys) do
        local classResult=self:_evaluateClass(snapshot,self.classes[key])
        classComparisons[#classComparisons+1]=classResult
        if classResult.outcome=="SAME_FIELD_WORLD" then sameClasses[#sameClasses+1]=self.classes[key]
        elseif classResult.outcome=="DIFFERENT_FIELD_WORLD" then differentCount=differentCount+1 end
    end

    if #sameClasses==1 and differentCount==#classKeys-1 then
        return self:_joinClass(snapshot,sameClasses[1],classComparisons)
    end
    if differentCount==#classKeys then
        return self:_mintClass(snapshot,"DIFFERENT_FIELD_WORLD","DIFFERENT_FROM_ALL_RELEVANT_FIELD_WORLDS",classComparisons)
    end

    local result={
        outcome="UNRESOLVED",
        reason="NO_SINGLE_COHERENT_FIELD_WORLD_ASSIGNMENT",
        fieldWorldReferenceKey=nil,
        fieldWorldIdentity=nil,
        fieldWorldSnapshotReferenceKey=snapshot.referenceKey,
        classComparisons=classComparisons,
        classWideCoherence=false,
        establishedNewFieldWorld=false,
        controlAuthorityEnabled=false
    }
    self:_appendResolution(result)
    logInfo(string.format("UNRESOLVED snapshot=%s classes=%d reason=%s operationAuthority=false control=false",tostring(snapshot.referenceKey),#classKeys,result.reason))
    return result
end

function Authority:endObservationCycle()
    local retired={}
    for _,key in OuttaMyWay.ValueRecord.ipairs(sortedClassKeys(self.classes)) do
        local class=self.classes[key]
        if class.relevantThisCycle~=true then
            retired[#retired+1]=key
            self.retiredClasses[#self.retiredClasses+1]={referenceKey=key,snapshotReferenceKeys=sortedSnapshotReferenceKeys(class.snapshotReferenceKeys)}
            for snapshotReferenceKey in OuttaMyWay.ValueRecord.pairs(class.snapshotReferenceKeys) do self.assignments[snapshotReferenceKey]=nil end
            self.classes[key]=nil
            logInfo(string.format("RETIRED world=%s reason=NO_RELEVANT_JOB_EPISODE_EVIDENCE control=false",key))
        end
    end
    self.cycleOpen=false
    return retired
end

function Authority:getAssignment(snapshotReferenceKey) return self.assignments[snapshotReferenceKey] end
function Authority:getClass(fieldWorldReferenceKey) return self.classes[fieldWorldReferenceKey] end
function Authority:listActiveClasses()
    local result={}
    for _,key in OuttaMyWay.ValueRecord.ipairs(sortedClassKeys(self.classes)) do result[#result+1]=self.classes[key] end
    return result
end
function Authority:getComparisonRecords() return copyArray(self.comparisonRecords) end
function Authority:getResolutionRecords() return copyArray(self.resolutionRecords) end
function Authority:getComparisonRecordCount() return #self.comparisonRecords end
function Authority:getResolutionRecordCount() return #self.resolutionRecords end
function Authority:getActiveClassCount() return #self:listActiveClasses() end
function Authority:getRetiredClassCount() return #self.retiredClasses end
