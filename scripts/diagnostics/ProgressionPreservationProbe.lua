OuttaMyWay.ProgressionPreservationProbe = {}
local Probe=OuttaMyWay.ProgressionPreservationProbe
Probe.__index=Probe

-- Instrument-private diagnostic controls; Situation/Decision/Control authority is unchanged.
local PROGRESSION_PRESERVATION_ENABLED=true
local PROGRESSION_PRESERVATION_HEARTBEAT_MS=1000

local function logInfo(message)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][PROGRESSION-PRESERVATION] %s",message)
    else
        print("[FS25_OuttaMyWay][PROGRESSION-PRESERVATION] "..message)
    end
end

local function finite(v) return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge end
local function norm(x,z)
    if not finite(x) or not finite(z) then return nil,nil end
    local l=math.sqrt(x*x+z*z); if l<=0.000001 then return nil,nil end
    return x/l,z/l
end
local function dot(ax,az,bx,bz) return ax*bx+az*bz end
local function positiveDiscs(physical)
    local out={}
    for _,p in OuttaMyWay.ValueRecord.ipairs(physical and physical.primitives or {}) do
        if p.kind=="DISC" and p.positiveConflictSupport==true and finite(p.x) and finite(p.z) and finite(p.radius) then out[#out+1]=p end
    end
    return out
end

local function firstAlternative(future)
    for _,a in OuttaMyWay.ValueRecord.ipairs(future and future.alternatives or {}) do return a end
    return nil
end

local function indexPicture(picture)
    local idx={motion={},current={},future={},physical={}}
    for _,m in OuttaMyWay.ValueRecord.ipairs(picture.motionEvidence or {}) do idx.motion[m.assemblyId]=m end
    for _,c in OuttaMyWay.ValueRecord.ipairs(picture.currentSpace or {}) do idx.current[c.assemblyId]=c end
    for _,f in OuttaMyWay.ValueRecord.ipairs(picture.futureSpace or {}) do idx.future[f.assemblyId]=f end
    for _,p in OuttaMyWay.ValueRecord.ipairs(picture.physicalSpaceEvidence or {}) do idx.physical[p.assemblyId]=p end
    return idx
end

local function subjectProjection(idx,assemblyId)
    local motion=idx.motion[assemblyId]; local future=idx.future[assemblyId]; local physical=idx.physical[assemblyId]
    if motion==nil then return nil,"MOTION_KNOWLEDGE_UNAVAILABLE" end
    if motion.intentValid~=true or motion.localIntentClassification~="SETTLED_CONTINUATION" then return nil,"POSITIVE_SETTLED_NATIVE_CONTINUATION_UNAVAILABLE" end
    local dx,dz=norm(motion.travelDirectionX,motion.travelDirectionZ)
    if dx==nil then return nil,"REALIZED_TRAVEL_DIRECTION_UNAVAILABLE" end
    local alt=firstAlternative(future)
    if alt==nil or not finite(alt.headingX) or not finite(alt.headingZ) or not finite(alt.boundaryDistance) then return nil,"FIELD_BOUNDED_LOCAL_INTENT_HORIZON_UNAVAILABLE" end
    local hx,hz=norm(alt.headingX,alt.headingZ); if hx==nil then return nil,"LOCAL_INTENT_HEADING_INVALID" end
    local alignment=dot(dx,dz,hx,hz)
    if alignment<0.5 then
        return nil,"REALIZED_TRAVEL_NOT_REPRESENTED_BY_CURRENT_FIELD_BOUNDED_INTENT_HORIZON"
    end
    local discs=positiveDiscs(physical)
    if #discs==0 then return nil,"SUBJECT_POSITIVE_PHYSICAL_PRIMITIVES_UNAVAILABLE" end
    return {
        assemblyId=assemblyId,referenceKey=motion.assemblyReferenceKey,name=motion.name or tostring(assemblyId),jobToken=motion.sourceJobToken,
        intentEpoch=motion.intentEpoch,dx=dx,dz=dz,speedMps=tonumber(motion.positionDerivedSpeedMps) or tonumber(motion.reportedSpeedMps) or 0,
        projectionLimitM=math.max(0,alt.boundaryDistance*alignment),discs=discs,alignment=alignment,
        representationNegativeClearanceAuthority=physical and physical.negativeClearanceAuthority==true or false
    },nil
end

local function currentRegions(idx,subjectId)
    local regions={}
    for targetId,physical in pairs(idx.physical) do
        if targetId~=subjectId then
            for _,p in ipairs(positiveDiscs(physical)) do
                regions[#regions+1]={
                    identity="CURRENT_SPACE|"..tostring(targetId).."|"..tostring(p.identity or #regions+1),groupIdentity="CURRENT_SPACE|"..tostring(targetId),class="CURRENT_SPACE",targetAssemblyId=targetId,
                    targetName=(idx.motion[targetId] and idx.motion[targetId].name) or tostring(targetId),kind="CAPSULE",ax=p.x,az=p.z,bx=p.x,bz=p.z,radius=p.radius,
                    validityKey="CURRENT|"..tostring(idx.motion[targetId] and idx.motion[targetId].intentEpoch or "na"),
                    authority="POSITIVE_REPRESENTED_OCCUPANCY_ONLY",negativeClearanceAuthority=false,purpose="AVOID_CONSUMING_REPRESENTED_CURRENT_SPACE"
                }
            end
        end
    end
    return regions
end

local function demandRegions(idx,picture,subjectId,className,bucket)
    local regions={}
    for _,demand in OuttaMyWay.ValueRecord.ipairs(bucket or {}) do
        local targetId=demand.assemblyId
        if targetId~=nil and targetId~=subjectId and type(demand.space)=="table" and demand.space.futureSpaceIdentity~=nil then
            local targetFuture=idx.future[targetId]; local targetPhysical=idx.physical[targetId]; local alt=firstAlternative(targetFuture)
            local targetCurrent=idx.current[targetId]
            if alt~=nil and targetPhysical~=nil and targetCurrent~=nil and targetCurrent.occupancy~=nil and finite(alt.headingX) and finite(alt.headingZ) and finite(alt.boundaryDistance) then
                local hx,hz=norm(alt.headingX,alt.headingZ)
                if hx~=nil then
                    for _,p in ipairs(positiveDiscs(targetPhysical)) do
                        regions[#regions+1]={
                            identity=className.."|"..tostring(demand.identity).."|"..tostring(p.identity or #regions+1),groupIdentity=className.."|"..tostring(demand.identity),class=className,targetAssemblyId=targetId,
                            targetName=(idx.motion[targetId] and idx.motion[targetId].name) or tostring(targetId),kind="CAPSULE",ax=p.x,az=p.z,
                            bx=p.x+hx*alt.boundaryDistance,bz=p.z+hz*alt.boundaryDistance,radius=p.radius,
                            validityKey=tostring(demand.identity).."|"..tostring(alt.intentEpoch or (idx.motion[targetId] and idx.motion[targetId].intentEpoch) or "na"),
                            authority="POSITIVE_FIELD_BOUNDED_DEMAND_SUPPORT_ONLY",negativeClearanceAuthority=false,
                            purpose=className=="COMMITTED_DEMAND" and "PRESERVE_COMMITTED_DEMAND" or "PRESERVE_POTENTIAL_DEMAND"
                        }
                    end
                end
            end
        end
    end
    return regions
end

function Probe.evaluateSubjectAgainstRegion(subject,region)
    if subject==nil or region==nil then return {status="UNRESOLVED",reason="SUBJECT_OR_REGION_UNAVAILABLE"} end
    local best=nil; local bestPrimitive=nil; local bestReason=nil
    for _,p in ipairs(subject.discs or {}) do
        local distance,reason=nil,nil
        if region.kind=="CAPSULE" then
            distance,reason=OuttaMyWay.ProgressionGeometry.rayCapsuleEntry(p.x,p.z,subject.dx,subject.dz,region.ax,region.az,region.bx,region.bz,(p.radius or 0)+(region.radius or 0))
        end
        if distance~=nil and (best==nil or distance<best) then best=distance; bestPrimitive=p.identity; bestReason=reason end
    end
    if best==nil then
        return {status="NO_POSITIVE_WITNESS",reason="NO_POSITIVE_REPRESENTED_INTERSECTION",withinLocalIntentHorizon=false,negativeClearanceAuthority=false}
    end
    local within=best<=subject.projectionLimitM
    return {
        status=within and "POSITIVE_WITNESS_WITHIN_LOCAL_INTENT" or "POSITIVE_WITNESS_BEYOND_LOCAL_INTENT",
        reason=bestReason,knownWitnessEntryM=best,projectionLimitM=subject.projectionLimitM,withinLocalIntentHorizon=within,
        subjectPrimitiveId=bestPrimitive,negativeClearanceAuthority=false,responseAdjustedSupportableProgression="UNRESOLVED"
    }
end

function Probe.new(runtime)
    return setmetatable({runtime=runtime,active={},lastLogAt={},lastSummaryAt={}},Probe)
end
function Probe:reset() self.active={}; self.lastLogAt={}; self.lastSummaryAt={} end

local function candidateCapabilitySummary(evaluated,assemblyId)
    local verdictByCandidate={}
    for _,v in OuttaMyWay.ValueRecord.ipairs(evaluated and evaluated.verdicts or {}) do
        local state=verdictByCandidate[v.candidateId] or "PASS"
        if v.result=="FAIL" then state="FAIL" elseif v.result=="UNRESOLVED" and state~="FAIL" then state="UNRESOLVED" end
        verdictByCandidate[v.candidateId]=state
    end
    local items={}
    for _,c in OuttaMyWay.ValueRecord.ipairs(evaluated and evaluated.candidates or {}) do
        local sid=c.subject and (c.subject.assemblyId or c.subject.yieldAssemblyId or c.subject.progressAssemblyId) or nil
        if sid==assemblyId then items[#items+1]=tostring(c.capability)..":"..tostring(verdictByCandidate[c.identity] or "PASS") end
    end
    table.sort(items); return #items>0 and table.concat(items,",") or "NONE_PUBLISHED"
end

function Probe:_logWitness(subject,region,result,picture,evaluated,timestampMs)
    local stableWitness=region.groupIdentity or region.identity
    local key=tostring(subject.referenceKey).."|"..tostring(subject.intentEpoch).."|"..stableWitness.."|"..tostring(region.validityKey)
    local record=self.active[key]
    if record==nil then
        record={key=key,subjectReferenceKey=subject.referenceKey,subjectName=subject.name,subjectIntentEpoch=subject.intentEpoch,regionIdentity=stableWitness,regionClass=region.class,
            targetAssemblyId=region.targetAssemblyId,targetName=region.targetName,validityKey=region.validityKey,baselineWitnessEntryM=result.knownWitnessEntryM,openedPictureId=picture.identity,openedAt=timestampMs}
        self.active[key]=record
        logInfo(string.format("WITNESS_OPEN subject=%s subjectRef=%s intentEpoch=%s target=%s class=%s witness=%s purpose=%s baselineKnownEntry=%.2fm projectionLimit=%.2fm authority=%s negativeClearanceAuthority=false responseAdjustedSupportableProgression=UNRESOLVED decisionAuthority=false speedAuthority=false controlAuthority=false",
            tostring(subject.name),tostring(subject.referenceKey),tostring(subject.intentEpoch),tostring(region.targetName),tostring(region.class),tostring(stableWitness),tostring(region.purpose),
            result.knownWitnessEntryM or -1,result.projectionLimitM or -1,tostring(region.authority)))
    end
    local heartbeat=PROGRESSION_PRESERVATION_HEARTBEAT_MS
    if timestampMs-(self.lastLogAt[key] or -math.huge)>=heartbeat then
        self.lastLogAt[key]=timestampMs
        local consumed=(record.baselineWitnessEntryM or 0)-(result.knownWitnessEntryM or 0)
        local eta=nil; if subject.speedMps and subject.speedMps>0.01 and result.knownWitnessEntryM then eta=result.knownWitnessEntryM/subject.speedMps end
        logInfo(string.format("SAMPLE subject=%s target=%s class=%s witness=%s purpose=%s knownEntry=%.2fm baselineKnownEntry=%.2fm consumedFromBaseline=%.2fm projectionLimit=%.2fm currentSpeed=%.2fkmh etaToKnownWitness=%s subjectIntentEpoch=%s targetValidity=%s candidateCapabilities=%s responseOpportunity=UNMODELED responseAdjustedSupportableProgression=UNRESOLVED negativeClearanceAuthority=false decisionAuthority=false speedAuthority=false controlAuthority=false",
            tostring(subject.name),tostring(region.targetName),tostring(region.class),tostring(stableWitness),tostring(region.purpose),result.knownWitnessEntryM or -1,
            record.baselineWitnessEntryM or -1,consumed,result.projectionLimitM or -1,(subject.speedMps or 0)*3.6,eta and string.format("%.3fs",eta) or "n/a",
            tostring(subject.intentEpoch),tostring(region.validityKey),candidateCapabilitySummary(evaluated,subject.assemblyId)))
    end
    return key
end

function Probe:observe(snapshot,picture,evaluated,timestampSeconds)
    if PROGRESSION_PRESERVATION_ENABLED~=true then return end
    if picture==nil then return end
    local timestampMs=(tonumber(timestampSeconds) or 0)*1000
    local idx=indexPicture(picture)
    local seen={}
    for assemblyId,_ in pairs(idx.motion) do
        local subject,reason=subjectProjection(idx,assemblyId)
        if subject~=nil then
            local regions=currentRegions(idx,assemblyId)
            local committed=demandRegions(idx,picture,assemblyId,"COMMITTED_DEMAND",picture.demand and picture.demand.committedDemand)
            local potential=demandRegions(idx,picture,assemblyId,"POTENTIAL_DEMAND",picture.demand and picture.demand.potentialDemand)
            for _,r in ipairs(committed) do regions[#regions+1]=r end
            for _,r in ipairs(potential) do regions[#regions+1]=r end
            local classBest={}
            for _,region in ipairs(regions) do
                local result=Probe.evaluateSubjectAgainstRegion(subject,region)
                if result.status=="POSITIVE_WITNESS_WITHIN_LOCAL_INTENT" then
                    local existing=classBest[region.class]
                    if existing==nil or result.knownWitnessEntryM<existing.result.knownWitnessEntryM then classBest[region.class]={region=region,result=result} end
                end
            end
            for _,item in pairs(classBest) do seen[self:_logWitness(subject,item.region,item.result,picture,evaluated,timestampMs)]=true end
            local summaryKey=tostring(subject.referenceKey).."|"..tostring(subject.intentEpoch)
            local heartbeat=PROGRESSION_PRESERVATION_HEARTBEAT_MS
            if timestampMs-(self.lastSummaryAt[summaryKey] or -math.huge)>=heartbeat then
                self.lastSummaryAt[summaryKey]=timestampMs
                local parts={}; for class,item in pairs(classBest) do parts[#parts+1]=class.."="..string.format("%.2fm",item.result.knownWitnessEntryM) end; table.sort(parts)
                logInfo(string.format("SUBJECT subject=%s subjectRef=%s intentEpoch=%s travel=(%.4f,%.4f) speed=%.2fkmh projectionLimit=%.2fm witnesses={%s} responseOpportunity=UNMODELED negativeClearanceAuthority=false decisionAuthority=false speedAuthority=false controlAuthority=false",
                    tostring(subject.name),tostring(subject.referenceKey),tostring(subject.intentEpoch),subject.dx,subject.dz,(subject.speedMps or 0)*3.6,subject.projectionLimitM,#parts>0 and table.concat(parts,",") or "NONE_POSITIVE_WITHIN_LOCAL_INTENT"))
            end
        else
            local motion=idx.motion[assemblyId]
            local summaryKey="UNRESOLVED|"..tostring(motion and motion.assemblyReferenceKey or assemblyId).."|"..tostring(motion and motion.intentEpoch or "na")
            local heartbeat=PROGRESSION_PRESERVATION_HEARTBEAT_MS
            if timestampMs-(self.lastSummaryAt[summaryKey] or -math.huge)>=heartbeat then
                self.lastSummaryAt[summaryKey]=timestampMs
                logInfo(string.format("SUBJECT_UNRESOLVED subject=%s subjectRef=%s intentEpoch=%s reason=%s decisionAuthority=false speedAuthority=false controlAuthority=false",
                    tostring(motion and motion.name or assemblyId),tostring(motion and motion.assemblyReferenceKey or "n/a"),tostring(motion and motion.intentEpoch or "n/a"),tostring(reason)))
            end
        end
    end
    for key,record in pairs(self.active) do
        if not seen[key] then
            logInfo(string.format("WITNESS_INVALIDATED subject=%s subjectRef=%s target=%s class=%s witness=%s baselineKnownEntry=%.2fm reason=EVIDENCE_BASIS_NOT_PRESENT_IN_CURRENT_SEALED_PICTURE_OR_LOCAL_INTENT_EPOCH_CHANGED decisionAuthority=false speedAuthority=false controlAuthority=false",
                tostring(record.subjectName),tostring(record.subjectReferenceKey),tostring(record.targetName),tostring(record.regionClass),tostring(record.regionIdentity),record.baselineWitnessEntryM or -1))
            self.active[key]=nil; self.lastLogAt[key]=nil
        end
    end
end
