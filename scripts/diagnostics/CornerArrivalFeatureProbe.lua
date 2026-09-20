--- Diagnostic-only probe for feature-relative Corner Arrival evidence.
-- It asks whether the current positive Physical Assembly, translated only along
-- its already-supported Field-World-bounded continuation to the terminating
-- boundary contact, would consume both structural support segments incident to
-- a known Corner Feature.
--
-- This module owns no Situation, Candidate, Decision, Responsibility, Bounded
-- Authority or Control meaning.  Structural support segments are a bounded
-- diagnostic proxy for the architecturally named incident Headland Regimes;
-- positive Reality here is evidence for or against that representation
-- hypothesis, not production Corner authority.

OuttaMyWay.CornerArrivalFeatureProbe={}
local Probe=OuttaMyWay.CornerArrivalFeatureProbe
Probe.__index=Probe

local EPSILON_M=0.00001

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function pointSegmentDistance(pointValue,a,b)
    local dx,dz=b.x-a.x,b.z-a.z
    local squared=dx*dx+dz*dz
    if squared<=EPSILON_M*EPSILON_M then
        local x,z=pointValue.x-a.x,pointValue.z-a.z
        return math.sqrt(x*x+z*z)
    end
    local t=((pointValue.x-a.x)*dx+(pointValue.z-a.z)*dz)/squared
    if t<0 then t=0 elseif t>1 then t=1 end
    local x=pointValue.x-(a.x+t*dx)
    local z=pointValue.z-(a.z+t*dz)
    return math.sqrt(x*x+z*z)
end

local function distance(a,b)
    local x,z=a.x-b.x,a.z-b.z
    return math.sqrt(x*x+z*z)
end

local function byAssembly(values)
    local result={}
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if value.assemblyId~=nil then result[value.assemblyId]=value end
    end
    return result
end

local function numberText(value)
    return finite(value) and string.format("%.3f",value) or "UNRESOLVED"
end

local function logInfo(message)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][CORNER-ARRIVAL-PROBE] %s",message)
    else
        print("[FS25_OuttaMyWay][CORNER-ARRIVAL-PROBE] "..message)
    end
end

local function evaluateOne(feature,projection,physical,operationId)
    if type(feature)~="table" or type(feature.representativePoint)~="table"
        or type(feature.supportBefore)~="table" or type(feature.supportAfter)~="table"
        or type(projection)~="table" or projection.status~="SUPPORTED"
        or type(physical)~="table"
        or feature.ringKind~=projection.boundaryRingKind
        or tonumber(feature.ringIndex)~=tonumber(projection.boundaryRingIndex)
        or not finite(projection.currentX) or not finite(projection.currentZ)
        or not finite(projection.contactX) or not finite(projection.contactZ)
        or not finite(projection.headingX) or not finite(projection.headingZ) then
        return nil
    end

    local representative=feature.representativePoint
    local along=(representative.x-projection.currentX)*projection.headingX
        +(representative.z-projection.currentZ)*projection.headingZ
    if along<-EPSILON_M then return nil end

    local deltaX=projection.contactX-projection.currentX
    local deltaZ=projection.contactZ-projection.currentZ
    local beforeBest,afterBest=nil,nil
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical.primitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(primitive.x) and finite(primitive.z)
            and finite(primitive.radius) and primitive.radius>=0 then
            local terminal={x=primitive.x+deltaX,z=primitive.z+deltaZ}
            local beforeDistance=pointSegmentDistance(terminal,representative,feature.supportBefore)
            local afterDistance=pointSegmentDistance(terminal,representative,feature.supportAfter)
            local beforeClearance=beforeDistance-primitive.radius
            local afterClearance=afterDistance-primitive.radius
            if beforeBest==nil or beforeClearance<beforeBest.clearanceM then
                beforeBest={
                    clearanceM=beforeClearance,distanceM=beforeDistance,
                    primitiveId=primitive.identity,primitiveRadiusM=primitive.radius,
                    terminalX=terminal.x,terminalZ=terminal.z
                }
            end
            if afterBest==nil or afterClearance<afterBest.clearanceM then
                afterBest={
                    clearanceM=afterClearance,distanceM=afterDistance,
                    primitiveId=primitive.identity,primitiveRadiusM=primitive.radius,
                    terminalX=terminal.x,terminalZ=terminal.z
                }
            end
        end
    end
    if beforeBest==nil or afterBest==nil then return nil end

    local consumesBefore=beforeBest.clearanceM<=EPSILON_M
    local consumesAfter=afterBest.clearanceM<=EPSILON_M
    if not consumesBefore and not consumesAfter then return nil end

    local outcome=consumesBefore and consumesAfter
        and "TERMINAL_PHYSICAL_ASSEMBLY_CONSUMES_BOTH_STRUCTURAL_SUPPORTS"
        or "TERMINAL_PHYSICAL_ASSEMBLY_CONSUMES_ONE_STRUCTURAL_SUPPORT"

    return {
        operationId=operationId,
        assemblyId=projection.assemblyId,
        assemblyReferenceKey=projection.assemblyReferenceKey,
        cornerKey=feature.cornerKey,
        outcome=outcome,
        consumesSupportBefore=consumesBefore,
        consumesSupportAfter=consumesAfter,
        boundaryDistanceM=projection.boundaryDistanceM,
        representativeAheadM=along,
        boundaryContact={x=projection.contactX,z=projection.contactZ},
        boundaryContactDistanceToRepresentativeM=distance(
            representative,{x=projection.contactX,z=projection.contactZ}),
        supportBefore=beforeBest,
        supportAfter=afterBest,
        diagnosticBasis="TRANSLATED_CURRENT_PHYSICAL_DISCS_AT_SUPPORTED_FIELD_BOUNDARY_CONTACT_VS_STRUCTURAL_SUPPORT_SEGMENTS",
        semanticAuthority=false,decisionAuthority=false,controlAuthority=false,
        negativeClearanceAuthority=false,
        provenance={source="CornerArrivalFeatureProbe",diagnosticOnly=true}
    }
end

function Probe.evaluate(picture)
    local result={}
    if type(picture)~="table" then return result end
    local physicalByAssembly=byAssembly(picture.physicalSpaceEvidence)
    for _,knowledge in OuttaMyWay.ValueRecord.ipairs(picture.spatialConstraintKnowledge or {}) do
        local cornerKnowledge=knowledge.cornerKnowledge or {}
        for _,feature in OuttaMyWay.ValueRecord.ipairs(cornerKnowledge.atlasEntries or {}) do
            for _,projection in OuttaMyWay.ValueRecord.ipairs(knowledge.boundaryTransitionProjections or {}) do
                local item=evaluateOne(
                    feature,projection,physicalByAssembly[projection.assemblyId],knowledge.operationId)
                if item~=nil then result[#result+1]=item end
            end
        end
    end
    table.sort(result,function(a,b)
        local left=tostring(a.cornerKey).."|"..tostring(a.assemblyId)
        local right=tostring(b.cornerKey).."|"..tostring(b.assemblyId)
        return left<right
    end)
    return result
end

function Probe.new()
    return setmetatable({signatures={}},Probe)
end

function Probe:reset()
    self.signatures={}
end

function Probe:observe(picture)
    for _,item in OuttaMyWay.ValueRecord.ipairs(Probe.evaluate(picture)) do
        local key=tostring(item.cornerKey).."|"..tostring(item.assemblyId)
        local signature=table.concat({
            tostring(item.outcome),
            tostring(item.supportBefore and item.supportBefore.primitiveId),
            tostring(item.supportAfter and item.supportAfter.primitiveId)
        },"|")
        if self.signatures[key]~=signature then
            self.signatures[key]=signature
            logInfo(string.format(
                "operation=%s assembly=%s ref=%s corner=%s outcome=%s boundaryDistanceM=%s contact=(%s,%s) contactToRepresentativeM=%s supportBefore=%s clearanceBeforeM=%s supportAfter=%s clearanceAfterM=%s basis=%s semanticAuthority=false decisionAuthority=false controlAuthority=false",
                tostring(item.operationId),tostring(item.assemblyId),tostring(item.assemblyReferenceKey),
                tostring(item.cornerKey),tostring(item.outcome),numberText(item.boundaryDistanceM),
                numberText(item.boundaryContact and item.boundaryContact.x),
                numberText(item.boundaryContact and item.boundaryContact.z),
                numberText(item.boundaryContactDistanceToRepresentativeM),
                tostring(item.supportBefore and item.supportBefore.primitiveId or "UNRESOLVED"),
                numberText(item.supportBefore and item.supportBefore.clearanceM),
                tostring(item.supportAfter and item.supportAfter.primitiveId or "UNRESOLVED"),
                numberText(item.supportAfter and item.supportAfter.clearanceM),
                tostring(item.diagnosticBasis)))
        end
    end
end
