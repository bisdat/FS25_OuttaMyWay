-- FS25_OuttaMyWay v0.1.3.3 TEST — D-0159 Passage Approach / execution-origin correction.
--
-- Situation/Candidate/Decision/Commitment establish the pair meaning and the
-- bounded Passage plan before this module is invoked. Passage Selection now
-- immediately owns the encounter, restoring the v0.1.3.0 authority handoff.
-- Control may remain in PASSAGE_APPROACH until the Candidate Entry Boundary is
-- reached, then settles/configures the pair and instantiates the participant
-- guide from actual execution origins before forward-only point pursuit.
-- Passage speed and configuration policy are intentionally unchanged in this
-- TEST. The second-whistle trace marks completion of the pair-dependent guide;
-- agronomic reverse restoration is explicitly not implemented here.

OuttaMyWay.CooperativePassageControl={}
local Control=OuttaMyWay.CooperativePassageControl
Control.__index=Control

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][COOPERATIVE-PASSAGE] %s",message) else print("[FS25_OuttaMyWay][COOPERATIVE-PASSAGE] "..message) end
end
local function logWarning(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][COOPERATIVE-PASSAGE] %s",message) else print("[FS25_OuttaMyWay][COOPERATIVE-PASSAGE][WARN] "..message) end
end

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
end
local function nameOf(vehicle)
    local ok,value=safeCall(vehicle,"getName")
    if ok and value~=nil and value~="" then return tostring(value) end
    return tostring(vehicle and (vehicle.name or vehicle.typeName or vehicle.rootNode) or "AI vehicle")
end
local function referenceKey(vehicle) return "vehicle-root:"..tostring(vehicle and (vehicle.rootNode or vehicle) or "nil") end
local function currentJobToken(vehicle)
    local job=OuttaMyWay.LiveAIJobEvidence.currentJob(vehicle)
    return OuttaMyWay.LiveAIJobEvidence.jobToken(job)
end
local function activeVehicles() return OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(g_currentMission) end
local function actualSpeedKmh(vehicle) return math.abs(tonumber(vehicle and vehicle.lastSpeedReal) or 0)*3600 end
local function dot(ax,az,bx,bz) return ax*bx+az*bz end
local function distance(ax,az,bx,bz) local dx,dz=bx-ax,bz-az; return math.sqrt(dx*dx+dz*dz) end
local function pointSegmentDistance(px,pz,ax,az,bx,bz)
    local vx,vz=bx-ax,bz-az
    local length2=vx*vx+vz*vz
    if length2<=0.000001 then return distance(px,pz,ax,az) end
    local t=((px-ax)*vx+(pz-az)*vz)/length2
    if t<0 then t=0 elseif t>1 then t=1 end
    return distance(px,pz,ax+vx*t,az+vz*t)
end

local function pose(vehicle)
    if vehicle==nil then return nil end
    local node=nil
    local ok,value=safeCall(vehicle,"getAISteeringNode")
    if ok and value~=nil and value~=0 then node=value end
    node=node or vehicle.rootNode
    if node==nil or node==0 or type(getWorldTranslation)~="function" or type(localDirectionToWorld)~="function" then return nil end
    local okPos,x,y,z=pcall(getWorldTranslation,node)
    local okDir,dx,_,dz=pcall(localDirectionToWorld,node,0,0,1)
    if not okPos or not okDir then return nil end
    local length=math.sqrt(dx*dx+dz*dz)
    if length<=0.0001 then return nil end
    return {node=node,x=x,y=y,z=z,dx=dx/length,dz=dz/length}
end

local function wakeNativeContinuation(vehicle)
    if vehicle==nil then return "vehicle-unavailable" end
    local strategy=nil
    local aiSpec=vehicle.spec_aiVehicle
    local fieldSpec=vehicle.spec_aiFieldWorker
    if aiSpec~=nil then strategy=aiSpec.driveStrategy or aiSpec.currentDriveStrategy end
    if strategy==nil and fieldSpec~=nil then strategy=fieldSpec.driveStrategy end
    local method="none"
    if strategy~=nil then
        local attempts={{"setIsPaused",false},{"setPaused",false},{"resume",nil},{"continue",nil},{"onAIFieldWorkerContinue",nil}}
        for _,attempt in OuttaMyWay.ValueRecord.ipairs(attempts) do
            local fn=strategy[attempt[1]]
            if type(fn)=="function" then
                local okCall
                if attempt[2]~=nil then okCall=pcall(fn,strategy,attempt[2]) else okCall=pcall(fn,strategy) end
                if okCall then method=attempt[1]; break end
            end
        end
    end
    if SpecializationUtil~=nil and type(SpecializationUtil.raiseEvent)=="function" then
        pcall(SpecializationUtil.raiseEvent,vehicle,"onAIFieldWorkerContinue")
        pcall(SpecializationUtil.raiseEvent,vehicle,"onAIImplementContinue")
    end
    if type(vehicle.aiContinue)=="function" then local okCall=pcall(vehicle.aiContinue,vehicle); if okCall then method=method.."+aiContinue" end end
    return method
end

local function fieldResolvedAt(x,z)
    if OuttaMyWay.LiveAIJobEvidence==nil or type(OuttaMyWay.LiveAIJobEvidence.fieldAtPosition)~="function" then return false,"FIELD_QUERY_UNAVAILABLE" end
    local field=OuttaMyWay.LiveAIJobEvidence.fieldAtPosition(g_currentMission,x,z)
    if field==nil or field.resolved~=true then return false,"TARGET_NOT_POSITIVELY_INSIDE_FIELD" end
    return true,field.sourceFieldId
end

local function foldText(evidence)
    if evidence==nil then return "fold=n/a" end
    return string.format("fold=%d deployed=%d transition=%d folded=%d unknown=%d range=%s..%s",
        evidence.foldableCount or 0,evidence.deployedCount or 0,evidence.transitionCount or 0,evidence.foldedCount or 0,evidence.unknownCount or 0,
        evidence.minimum~=nil and string.format("%.3f",evidence.minimum) or "n/a",evidence.maximum~=nil and string.format("%.3f",evidence.maximum) or "n/a")
end

local function targetReached(authority,vehicle)
    local state=authority:getState(vehicle)
    return state~=nil and state.targetReached==true
end

function Control.new(runtime,capabilityDonor)
    if capabilityDonor==nil then error("CooperativePassageControl requires the existing physical capability donor",2) end
    return setmetatable({
        runtime=runtime,donor=capabilityDonor,
        permissionGate=capabilityDonor.permissionGate,driveAuthority=capabilityDonor.driveAuthority,configurationAuthority=capabilityDonor.configurationAuthority,
        run=nil,completionHandler=nil,nextHeartbeatMs=0,completedCount=0,failedCount=0
    },Control)
end

function Control:setCompletionHandler(handler) self.completionHandler=handler end
function Control:isActive() return self.run~=nil end
function Control:getStatus()
    local run=self.run
    return {active=run~=nil,phase=run and run.phase or nil,commitmentId=run and run.commitmentId or nil,completedCount=self.completedCount,failedCount=self.failedCount}
end
function Control:keyEvent() end
function Control:mouseEvent() end

function Control:loadMap()
    local ok,reason=self.driveAuthority:install()
    logInfo("LOAD d0146Step2=%s mechanicalProfile=CONFIGURATION_FIRST_GUIDED_PASSAGE_V5 vehicleNameGate=false legacyD0143=%s driveHook=%s reason=%s king=false refuge=false cooldown=false generalVehicleAuthority=false",
        tostring(OuttaMyWay.D0146_STEP2_COOPERATIVE_PASSAGE_ENABLED==true),tostring(OuttaMyWay.COOPERATIVE_PASSAGE_TS015_ENABLED==true),tostring(ok),tostring(reason or "ready"))
end

function Control:deleteMap()
    local run=self.run
    if run~=nil then
        for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
            self.driveAuthority:clear(p.vehicle); self.permissionGate:release(p.vehicle)
            if self.configurationAuthority:getState(p.vehicle)~=nil then self.configurationAuthority:clear(p.vehicle) end
            self:_endRepresentationConfigurationAuthority(p)
        end
    end
    self.run=nil
end

local function renderLine(x,y,size,text)
    if renderText==nil or text==nil then return end
    if setTextAlignment~=nil then setTextAlignment((RenderText and RenderText.ALIGN_RIGHT) or 2) end
    if setTextColor~=nil then setTextColor(0,0,0,0.90) end
    renderText(x+0.001,y-0.001,size,text)
    if setTextColor~=nil then setTextColor(1,1,1,1) end
    renderText(x,y,size,text)
end
function Control:draw()
    local run=self.run
    if run==nil or g_currentMission==nil or renderText==nil then return end
    local x,y,size=0.985,0.650,0.015
    renderLine(x,y,size,run.failureReason and "OTM COOPERATIVE PASSAGE - HALTED" or "OTM COOPERATIVE PASSAGE - ACTIVE")
    renderLine(x,y-size*1.35,size*0.90,"phase: "..tostring(run.phase))
    if run.failureReason then renderLine(x,y-size*2.70,size*0.85,"player intervention required") end
end

function Control:_resolveReference(reference)
    for _,vehicle in OuttaMyWay.ValueRecord.ipairs(activeVehicles()) do if referenceKey(vehicle)==reference then return vehicle end end
    return nil
end

local function guideTargetForAssembly(gate,assemblyId)
    if type(gate)~="table" then return nil end
    if gate.subject and gate.subject.assemblyId==assemblyId then return gate.subject end
    if gate.other and gate.other.assemblyId==assemblyId then return gate.other end
    return nil
end

local function configurationPlanByAssembly(plan)
    if type(plan)~="table" or type(plan.participants)~="table" then return nil end
    local result={}
    for _,entry in OuttaMyWay.ValueRecord.ipairs(plan.participants) do
        if type(entry)=="table" and entry.assemblyId~=nil then result[entry.assemblyId]=entry end
    end
    return result
end

local function configurationModeText(run)
    local values={}
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
        values[#values+1]=string.format("%s=%s",participant.name,tostring(participant.configurationMode or "n/a"))
    end
    return table.concat(values,",")
end

local function thirdPartyParticipantReserve(constraint,assemblyId)
    for _,entry in OuttaMyWay.ValueRecord.ipairs(constraint and constraint.participantRepresentedRadialReserves or {}) do
        if entry.assemblyId==assemblyId then return tonumber(entry.reserveM) end
    end
    return nil
end

function Control:_thirdPartySupport(run,gate)
    for _,constraint in OuttaMyWay.ValueRecord.ipairs(run.thirdPartyConstraints or {}) do
        local vehicle=self:_resolveReference(constraint.assemblyReferenceKey)
        if vehicle==nil then return false,"PASSAGE_SUPPORT_LOSS_THIRD_PARTY_REFERENCE_UNRESOLVED:"..tostring(constraint.assemblyId) end
        local thirdPose=pose(vehicle)
        if thirdPose==nil then return false,"PASSAGE_SUPPORT_LOSS_THIRD_PARTY_POSE_UNRESOLVED:"..tostring(constraint.assemblyId) end
        local thirdReserve=tonumber(constraint.maxPositiveRadiusFromReferenceM)
        local nominalClearance=tonumber(constraint.nominalInterAssemblyClearanceM)
        if thirdReserve==nil or thirdReserve<=0 or nominalClearance==nil or nominalClearance<=0 then
            return false,"PASSAGE_SUPPORT_LOSS_THIRD_PARTY_RESERVE_UNRESOLVED:"..tostring(constraint.assemblyId)
        end
        for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
            local participantReserve=thirdPartyParticipantReserve(constraint,participant.assemblyId)
            if participantReserve==nil or participantReserve<=0 then
                return false,"PASSAGE_SUPPORT_LOSS_PARTICIPANT_RESERVE_UNRESOLVED:"..tostring(participant.assemblyId)
            end
            local required=thirdReserve+participantReserve+nominalClearance
            local pp=pose(participant.vehicle)
            if pp==nil then return false,"PASSAGE_SUPPORT_LOSS_PARTICIPANT_POSE_UNRESOLVED:"..tostring(participant.assemblyId) end
            if distance(pp.x,pp.z,thirdPose.x,thirdPose.z)<required then
                return false,"PASSAGE_SUPPORT_LOSS_THIRD_PARTY_CURRENT_OCCUPANCY:"..tostring(constraint.assemblyId)
            end
            -- During an active guide leg, the third party's *current positive*
            -- occupancy must not move into the remaining Candidate-supplied leg.
            -- This is Passage Support revalidation, not prediction of C's route.
            if type(participant.targetX)=="number" and type(participant.targetZ)=="number" and
               pointSegmentDistance(thirdPose.x,thirdPose.z,pp.x,pp.z,participant.targetX,participant.targetZ)<required then
                return false,"PASSAGE_SUPPORT_LOSS_THIRD_PARTY_ACTIVE_LEG:"..tostring(constraint.assemblyId)..":"..tostring(participant.assemblyId)
            end
            if gate~=nil then
                local target=guideTargetForAssembly(gate,participant.assemblyId)
                if target~=nil and distance(target.x,target.z,thirdPose.x,thirdPose.z)<required then
                    return false,"PASSAGE_SUPPORT_LOSS_THIRD_PARTY_GATE_TARGET:"..tostring(constraint.assemblyId)..":"..tostring(gate.index)
                end
            end
        end
    end
    return true,nil
end

function Control:_participant(vehicle,assemblyId,request,sideSign)
    local p=pose(vehicle)
    if p==nil then return nil,"POSE_UNAVAILABLE" end
    local token=currentJobToken(vehicle)
    if token==nil then return nil,"JOB_EPISODE_UNAVAILABLE" end
    return {
        vehicle=vehicle,assemblyId=assemblyId,request=request,name=nameOf(vehicle),referenceKey=referenceKey(vehicle),
        startJobToken=token,startX=p.x,startZ=p.z,startForwardX=p.dx,startForwardZ=p.dz,sideSign=sideSign,
        targetX=nil,targetZ=nil,targetRadiusM=nil,wakeMethod=nil
    }
end

function Control:_validAuthority(request)
    for _,token in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(request.commitmentId)) do
        if token.identity==request.authorityToken and token.assemblyId==request.assemblyId and self.runtime.authorities:validate(token)==true then return true end
    end
    return false
end

function Control:_allSameJob(run)
    for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do if currentJobToken(p.vehicle)~=p.startJobToken then return false,p end end
    return true,nil
end
function Control:_allStopped(run)
    local limit=OuttaMyWay.COOPERATIVE_PASSAGE_HOLD_EFFECT_SPEED_KMH or 0.25
    for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do
        -- Passage settling needs owned Hold authority plus physical settlement.
        -- Do not require proof that OuttaMyWay causally stopped the participant:
        -- GIANTS may already refuse native continuation before Passage Hold is
        -- applied, in which case the PermissionGate call count legitimately
        -- remains zero even though the required stationary state is present.
        if self.permissionGate:isHolding(p.vehicle)~=true or actualSpeedKmh(p.vehicle)>limit then return false end
    end
    return true
end

function Control:_d0146LongitudinalSeparation(run)
    local pa,pb=pose(run and run.a and run.a.vehicle),pose(run and run.b and run.b.vehicle)
    if pa==nil or pb==nil then return nil end
    local aAhead=(pb.x-pa.x)*run.a.startForwardX+(pb.z-pa.z)*run.a.startForwardZ
    local bAhead=(pa.x-pb.x)*run.b.startForwardX+(pa.z-pb.z)*run.b.startForwardZ
    if type(aAhead)~="number" or type(bAhead)~="number" then return nil end
    return math.max(0,(aAhead+bAhead)*0.5),pa,pb
end

function Control:_beginD0146Settling(run,reason)
    local holdA,holdReasonA=self.permissionGate:setHold(run.a.vehicle,"D0146-COOPERATIVE-PASSAGE")
    if not holdA then return false,"SUBJECT_HOLD_UNAVAILABLE:"..tostring(holdReasonA) end
    local holdB,holdReasonB=self.permissionGate:setHold(run.b.vehicle,"D0146-COOPERATIVE-PASSAGE")
    if not holdB then self.permissionGate:release(run.a.vehicle); return false,"OTHER_HOLD_UNAVAILABLE:"..tostring(holdReasonB) end
    self:_setPhase(run,"SETTLING",g_time or 0)
    local separation=self:_d0146LongitudinalSeparation(run)
    logInfo("D0146_PASSAGE_ENTRY_TRIGGER commitment=%s reason=%s longitudinalSeparation=%s entryBoundary=%.2fm action=HOLD_THEN_CONFIGURE",
        tostring(run.commitmentId),tostring(reason or "ENTRY_BOUNDARY"),separation and string.format("%.2fm",separation) or "n/a",tonumber(run.passageEntry and run.passageEntry.boundarySeparationM) or -1)
    return true,nil
end
function Control:_allFolded(run)
    for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do if self.configurationAuthority:getEvidence(p.vehicle).allFolded~=true then return false end end
    return true
end
function Control:_allDeployed(run)
    for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do if self.configurationAuthority:getEvidence(p.vehicle).allDeployed~=true then return false end end
    return true
end

function Control:_beginRepresentationConfigurationAuthority(participant)
    local cache=self.runtime and self.runtime.assemblyRepresentationCache or nil
    if participant==nil or participant.representationConfigurationAuthority==true or cache==nil or type(cache.beginOuttaMyWayConfigurationAuthority)~="function" then return end
    cache:beginOuttaMyWayConfigurationAuthority(participant.referenceKey,participant.startJobToken)
    participant.representationConfigurationAuthority=true
end
function Control:_endRepresentationConfigurationAuthority(participant)
    local cache=self.runtime and self.runtime.assemblyRepresentationCache or nil
    if participant==nil or participant.representationConfigurationAuthority~=true then return end
    if cache~=nil and type(cache.endOuttaMyWayConfigurationAuthority)=="function" then cache:endOuttaMyWayConfigurationAuthority(participant.referenceKey,participant.startJobToken) end
    participant.representationConfigurationAuthority=false
end
function Control:_currentRepresentationProfile(participant)
    local cache=self.runtime and self.runtime.assemblyRepresentationCache or nil
    if cache==nil or type(cache.getCurrentConfigurationProfileId)~="function" then return nil end
    return cache:getCurrentConfigurationProfileId(participant.referenceKey,participant.startJobToken)
end
function Control:_setPhase(run,phase,nowMs)
    run.phase=phase; run.phaseStartedAt=nowMs
end

function Control:_targetFor(run,p,forwardM,lateralM)
    return p.startX+p.startForwardX*forwardM+run.sharedRightX*lateralM*p.sideSign,
           p.startZ+p.startForwardZ*forwardM+run.sharedRightZ*lateralM*p.sideSign
end

function Control:_preflightTargets(run)
    local checks={
        {phase="SIDESTEP",forward=run.sidestepForwardM,lateral=run.lateralM},
        {phase="PASS",forward=run.passForwardM,lateral=run.lateralM},
        {phase="REJOIN",forward=run.rejoinForwardM,lateral=0}
    }
    for _,leg in OuttaMyWay.ValueRecord.ipairs(checks) do
        for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do
            local x,z=self:_targetFor(run,p,leg.forward,leg.lateral)
            local ok,field=fieldResolvedAt(x,z)
            if not ok then return false,string.format("%s_%s_%s",leg.phase,p.name,tostring(field)) end
        end
    end
    return true,nil
end

function Control:_startLeg(run,phase,forwardM,lateralM,radiusM)
    for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do
        local x,z=self:_targetFor(run,p,forwardM,lateralM)
        p.targetX,p.targetZ,p.targetRadiusM=x,z,radiusM
        local ok,reason=self.driveAuthority:setReposition(p.vehicle,x,z,run.speedKmh,radiusM)
        if not ok then
            for _,rollback in OuttaMyWay.ValueRecord.ipairs(run.participants) do self.driveAuthority:clear(rollback.vehicle) end
            return false,p.name..":"..tostring(reason)
        end
    end
    self:_setPhase(run,phase,g_time or 0)
    logInfo("LEG_START commitment=%s phase=%s forward=%.2fm lateral=%+.2fm/%+.2fm radius=%.2fm speed=%.1fkmh A=%s target=(%.2f,%.2f) B=%s target=(%.2f,%.2f)",
        tostring(run.commitmentId),phase,forwardM,lateralM,-lateralM,radiusM,run.speedKmh,
        run.a.name,run.a.targetX,run.a.targetZ,run.b.name,run.b.targetX,run.b.targetZ)
    return true
end
function Control:_bothReached(run) return targetReached(self.driveAuthority,run.a.vehicle) and targetReached(self.driveAuthority,run.b.vehicle) end
function Control:_stopLeg(run) self.driveAuthority:clear(run.a.vehicle); self.driveAuthority:clear(run.b.vehicle) end

local function validGuideTarget(target,assemblyId)
    return type(target)=="table" and target.assemblyId==assemblyId and type(target.x)=="number" and type(target.z)=="number" and type(target.radiusM)=="number"
end

function Control:_guideTargetFor(run,p,gate)
    if p.assemblyId==run.subjectAssemblyId then return gate.subject end
    if p.assemblyId==run.otherAssemblyId then return gate.other end
    return nil
end

function Control:_preflightD0146Guide(run)
    if type(run.guide)~="table" or type(run.guide.gates)~="table" or OuttaMyWay.ValueRecord.length(run.guide.gates)<1 then return false,"PASSAGE_GUIDE_UNAVAILABLE" end
    for index,gate in OuttaMyWay.ValueRecord.ipairs(run.guide.gates) do
        if tonumber(gate.index)~=index then return false,"PASSAGE_GUIDE_GATE_INDEX_INVALID:"..tostring(index) end
        for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do
            local target=self:_guideTargetFor(run,p,gate)
            if not validGuideTarget(target,p.assemblyId) then return false,"PASSAGE_GUIDE_TARGET_INVALID:"..tostring(index)..":"..tostring(p.assemblyId) end
            local ok,field=fieldResolvedAt(target.x,target.z)
            if not ok then return false,"PASSAGE_SUPPORT_LOSS_FIELD_TARGET:"..tostring(index)..":"..p.name..":"..tostring(field) end
        end
        local thirdOk,thirdReason=self:_thirdPartySupport(run,gate)
        if not thirdOk then return false,thirdReason end
    end
    return true,nil
end

function Control:_startGuideGate(run,index)
    local gate=run.guide and run.guide.gates and run.guide.gates[index] or nil
    if gate==nil then return false,"PASSAGE_GUIDE_GATE_UNAVAILABLE:"..tostring(index) end
    local thirdOk,thirdReason=self:_thirdPartySupport(run,gate)
    if not thirdOk then return false,thirdReason end
    -- Revalidate the Candidate-supplied support at each execution boundary.
    -- Control may reject; it may not invent a replacement target.
    for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do
        local target=self:_guideTargetFor(run,p,gate)
        if not validGuideTarget(target,p.assemblyId) then return false,"PASSAGE_GUIDE_TARGET_INVALID:"..tostring(index)..":"..tostring(p.assemblyId) end
        local fieldOk,fieldReason=fieldResolvedAt(target.x,target.z)
        if not fieldOk then return false,"PASSAGE_SUPPORT_LOSS_FIELD_TARGET:"..tostring(index)..":"..p.name..":"..tostring(fieldReason) end
        p.targetX,p.targetZ,p.targetRadiusM=target.x,target.z,target.radiusM
        local ok,reason=self.driveAuthority:setReposition(p.vehicle,target.x,target.z,run.speedKmh,target.radiusM)
        if not ok then
            for _,rollback in OuttaMyWay.ValueRecord.ipairs(run.participants) do self.driveAuthority:clear(rollback.vehicle) end
            return false,"PASSAGE_SUPPORT_LOSS_ACTUATION:"..tostring(index)..":"..p.name..":"..tostring(reason)
        end
    end
    run.guideIndex=index
    self:_setPhase(run,"GUIDE_"..tostring(gate.kind or index),g_time or 0)
    logInfo("GUIDE_START commitment=%s guide=%s gate=%d/%d kind=%s speed=%.1fkmh A=%s target=(%.2f,%.2f) r=%.2f B=%s target=(%.2f,%.2f) r=%.2f",
        tostring(run.commitmentId),tostring(run.guide.identity),index,OuttaMyWay.ValueRecord.length(run.guide.gates),tostring(gate.kind),run.speedKmh,
        run.a.name,run.a.targetX,run.a.targetZ,run.a.targetRadiusM,run.b.name,run.b.targetX,run.b.targetZ,run.b.targetRadiusM)
    return true,nil
end

function Control:_rebaseD0146Guide(run)
    local source=run and run.guide
    if type(source)~="table" then return false,"PASSAGE_GUIDE_UNAVAILABLE_FOR_EXECUTION_REBASE" end
    local function copyValue(value)
        if type(value)~="table" then return value end
        local result={}
        for key,item in OuttaMyWay.ValueRecord.pairs(value) do result[key]=copyValue(item) end
        return result
    end
    local guide=copyValue(source)
    local frame=guide.executionFrame or {}
    local rightX,rightZ=tonumber(frame.sharedRightX),tonumber(frame.sharedRightZ)
    local sfx,sfz=tonumber(frame.subjectForwardX),tonumber(frame.subjectForwardZ)
    local ofx,ofz=tonumber(frame.otherForwardX),tonumber(frame.otherForwardZ)
    if rightX==nil or rightZ==nil or sfx==nil or sfz==nil or ofx==nil or ofz==nil then return false,"PASSAGE_EXECUTION_FRAME_UNAVAILABLE" end
    local pa,pb=pose(run.a.vehicle),pose(run.b.vehicle)
    if pa==nil or pb==nil then return false,"PASSAGE_EXECUTION_ORIGIN_POSE_UNAVAILABLE" end
    local arrangement=run.passageArrangement or {}
    local subjectOffset=tonumber(arrangement.subjectLateralOffsetM) or 0
    local otherOffset=tonumber(arrangement.otherLateralOffsetM) or 0
    local subjectParticipant=(run.a.assemblyId==run.subjectAssemblyId) and run.a or run.b
    local otherParticipant=(run.a.assemblyId==run.otherAssemblyId) and run.a or run.b
    local poses={[run.a.assemblyId]=pa,[run.b.assemblyId]=pb}
    local subjectPose,otherPose=poses[run.subjectAssemblyId],poses[run.otherAssemblyId]
    if subjectPose==nil or otherPose==nil then return false,"PASSAGE_EXECUTION_ORIGIN_ASSEMBLY_BINDING_UNAVAILABLE" end
    local oldOrigins=guide.entryOrigins or {}
    guide.entryOrigins={subject={x=subjectPose.x,z=subjectPose.z},other={x=otherPose.x,z=otherPose.z}}
    for index,gate in ipairs(guide.gates or {}) do
        local forward=tonumber(gate.forwardM) or 0
        local fraction=tonumber(gate.lateralFraction) or 0
        local radius=tonumber(gate.radiusM) or 1
        gate.index=index
        gate.subject={assemblyId=run.subjectAssemblyId,x=subjectPose.x+sfx*forward+rightX*(fraction*subjectOffset),z=subjectPose.z+sfz*forward+rightZ*(fraction*subjectOffset),radiusM=radius}
        gate.other={assemblyId=run.otherAssemblyId,x=otherPose.x+ofx*forward+rightX*(fraction*otherOffset),z=otherPose.z+ofz*forward+rightZ*(fraction*otherOffset),radiusM=radius}
    end
    run.guide=guide
    local ok,reason=self:_preflightD0146Guide(run)
    if not ok then return false,"EXECUTION_REBASE_PREFLIGHT:"..tostring(reason) end
    local oldSubject=oldOrigins.subject or {}; local oldOther=oldOrigins.other or {}
    logInfo("D0146_EXECUTION_ORIGIN_CAPTURE commitment=%s subject=%s origin=(%.2f,%.2f) planned=(%s,%s) other=%s origin=(%.2f,%.2f) planned=(%s,%s) guideRebased=true geometryUnchanged=true",
        tostring(run.commitmentId),subjectParticipant and subjectParticipant.name or tostring(run.subjectAssemblyId),subjectPose.x,subjectPose.z,
        oldSubject.x and string.format("%.2f",oldSubject.x) or "n/a",oldSubject.z and string.format("%.2f",oldSubject.z) or "n/a",
        otherParticipant and otherParticipant.name or tostring(run.otherAssemblyId),otherPose.x,otherPose.z,
        oldOther.x and string.format("%.2f",oldOther.x) or "n/a",oldOther.z and string.format("%.2f",oldOther.z) or "n/a")
    return true,nil
end

function Control:_beginCompact(run)
    local okA,stateA=self.configurationAuthority:prepareCompact(run.a.vehicle)
    if not okA then return false,run.a.name..":"..tostring(stateA) end
    local okB,stateB=self.configurationAuthority:prepareCompact(run.b.vehicle)
    if not okB then self.configurationAuthority:requestRestore(run.a.vehicle); return false,run.b.name..":"..tostring(stateB) end
    self:_setPhase(run,"COMPACTING",g_time or 0)
    logInfo("COMPACT_START commitment=%s A=%s %s B=%s %s movementWaitsForFullFold=true",tostring(run.commitmentId),run.a.name,foldText(self.configurationAuthority:getEvidence(run.a.vehicle)),run.b.name,foldText(self.configurationAuthority:getEvidence(run.b.vehicle)))
    return true
end

function Control:_beginD0146Configuration(run)
    local owned={}
    local requested=0
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
        if participant.configurationMode=="COMPACT_REQUIRED" then
            self:_beginRepresentationConfigurationAuthority(participant)
            local ok,state=self.configurationAuthority:prepareCompact(participant.vehicle)
            if not ok then
                self:_endRepresentationConfigurationAuthority(participant)
                for _,rollback in OuttaMyWay.ValueRecord.ipairs(owned) do self.configurationAuthority:requestRestore(rollback.vehicle) end
                return false,participant.name..":"..tostring(state)
            end
            owned[#owned+1]=participant
            requested=requested+1
        elseif participant.configurationMode~="RETAIN_CURRENT" then
            for _,rollback in OuttaMyWay.ValueRecord.ipairs(owned) do self.configurationAuthority:requestRestore(rollback.vehicle) end
            return false,participant.name..":unsupported-configuration-mode:"..tostring(participant.configurationMode)
        end
    end
    if requested==0 then
        logInfo("CONFIGURATION_READY commitment=%s policy=OPTIONAL_PER_PARTICIPANT modes=%s changed=0 next=CAPTURE_EXECUTION_ORIGIN",tostring(run.commitmentId),configurationModeText(run))
        local rebased,rebaseReason=self:_rebaseD0146Guide(run)
        if not rebased then return false,rebaseReason end
        return self:_startGuideGate(run,1)
    end
    self:_setPhase(run,"CONFIGURING",g_time or 0)
    logInfo("CONFIGURATION_START commitment=%s policy=OPTIONAL_PER_PARTICIPANT modes=%s changed=%d movementWaitsOnlyForRequiredReduction=true",tostring(run.commitmentId),configurationModeText(run),requested)
    return true
end

function Control:_d0146ConfigurationReady(run)
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
        if participant.configurationMode=="COMPACT_REQUIRED" then
            if self.configurationAuthority:getEvidence(participant.vehicle).allFolded~=true then return false end
            local expected=participant.expectedCompactConfigurationProfileId
            local observed=self:_currentRepresentationProfile(participant)
            if expected~=nil and observed~=expected then return false end
        elseif participant.configurationMode~="RETAIN_CURRENT" then
            return false
        end
    end
    return true
end

function Control:_beginD0146Restore(run)
    self:_stopLeg(run)
    local requested=0
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
        if self.configurationAuthority:getState(participant.vehicle)~=nil then
            local ok,reason=self.configurationAuthority:requestRestore(participant.vehicle)
            if not ok then return false,participant.name..":"..tostring(reason) end
            requested=requested+1
        end
    end
    if requested==0 then
        logInfo("RESTORE_SKIPPED commitment=%s reason=NO_CONFIGURATION_CHANGED modes=%s",tostring(run.commitmentId),configurationModeText(run))
        self:_complete(run)
        return true,"COMPLETED_WITHOUT_CONFIGURATION_RESTORE"
    end
    self:_setPhase(run,"RESTORING",g_time or 0)
    logInfo("RESTORE_START commitment=%s selective=true changedParticipants=%d modes=%s",tostring(run.commitmentId),requested,configurationModeText(run))
    return true
end

function Control:_d0146RestoreReady(run)
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
        if self.configurationAuthority:getState(participant.vehicle)~=nil and self.configurationAuthority:getEvidence(participant.vehicle).allDeployed~=true then return false end
    end
    return true
end

function Control:_finishD0146Restore(run)
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
        if self.configurationAuthority:getState(participant.vehicle)~=nil then
            local ok,reason=self.configurationAuthority:finishRestore(participant.vehicle)
            if not ok then return false,participant.name..":"..tostring(reason) end
            self:_endRepresentationConfigurationAuthority(participant)
        end
    end
    self:_complete(run)
    return true
end

function Control:_beginRestore(run)
    self:_stopLeg(run)
    local okA,reasonA=self.configurationAuthority:requestRestore(run.a.vehicle)
    local okB,reasonB=self.configurationAuthority:requestRestore(run.b.vehicle)
    if not okA or not okB then return false,"A="..tostring(reasonA)..":B="..tostring(reasonB) end
    self:_setPhase(run,"RESTORING",g_time or 0)
    logInfo("RESTORE_START commitment=%s A=%s B=%s bothHeld=true",tostring(run.commitmentId),run.a.name,run.b.name)
    return true
end

function Control:_notify(result)
    if type(self.completionHandler)=="function" then
        local ok,reason=pcall(self.completionHandler,result)
        if not ok then logWarning("COMPLETION_HANDLER_ERROR commitment=%s detail=%s",tostring(result and result.commitmentId),tostring(reason)) end
    end
end

function Control:_complete(run)
    for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do
        self.driveAuthority:clear(p.vehicle)
        self.permissionGate:release(p.vehicle)
        p.wakeMethod=wakeNativeContinuation(p.vehicle)
    end
    local pa,pb=pose(run.a.vehicle),pose(run.b.vehicle)
    logInfo("HANDOFF commitment=%s A=%s job=%s wake=%s B=%s job=%s wake=%s separation=%s sameJobs=true authorityRelease=IMMEDIATE cooldown=false",
        tostring(run.commitmentId),run.a.name,tostring(run.a.startJobToken),tostring(run.a.wakeMethod),run.b.name,tostring(run.b.startJobToken),tostring(run.b.wakeMethod),
        pa and pb and string.format("%.2fm",distance(pa.x,pa.z,pb.x,pb.z)) or "n/a")
    self.run=nil; self.completedCount=self.completedCount+1
    local evidenceKind=run.mode=="D0146_GUIDE" and "D0146_COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK" or "D0143_COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK"
    self:_notify({status="SUCCEEDED",commitmentId=run.commitmentId,requestIds={run.a.request.identity,run.b.request.identity},assemblyIds={run.a.assemblyId,run.b.assemblyId},evidence={kind=evidenceKind,passageGuideId=run.guide and run.guide.identity or nil,sameJobs=true,bothRestored=true,cooldown=false,completedAt=g_time or 0}})
end

function Control:_failHeld(reason)
    local run=self.run
    if run==nil or run.failureReason~=nil then return end
    self:_stopLeg(run)
    self.permissionGate:setHold(run.a.vehicle,"COOPERATIVE-PASSAGE-FAIL-HELD")
    self.permissionGate:setHold(run.b.vehicle,"COOPERATIVE-PASSAGE-FAIL-HELD")
    run.failureReason=tostring(reason or "UNRESOLVED")

    -- D-0146 failure is still an unresolved spatial situation.  Preserve the
    -- current (possibly compact) configuration rather than enlarging an
    -- assembly inside that unresolved conflict.  The legacy D-0143 donor keeps
    -- its historical restoration behaviour.
    local requested=false
    if run.mode~="D0146_GUIDE" then
        for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do
            if self.configurationAuthority:getState(p.vehicle)~=nil then
                local ok,restoreReason=self.configurationAuthority:requestRestore(p.vehicle)
                if ok then requested=true else logWarning("FAIL_RESTORE_REQUEST participant=%s detail=%s",p.name,tostring(restoreReason)) end
            end
        end
    end
    self:_setPhase(run,requested and "FAILED_RESTORING" or "FAILED_HELD",g_time or 0)
    self.failedCount=self.failedCount+1
    if run.mode=="D0146_GUIDE" then
        logWarning("PASSAGE_REASSESSMENT commitment=%s guide=%s cause=%s outcome=SAFE_ABANDON_ESCALATE controlBroadening=false bothHeld=true configurationPreserved=true",tostring(run.commitmentId),tostring(run.guide and run.guide.identity),run.failureReason)
    end
    logWarning("HALT commitment=%s reason=%s phase=%s bothHeld=true noBlindRelease=true configurationPreserved=%s action=PLAYER_INTERVENTION_OR_JOB_CHANGE",tostring(run.commitmentId),run.failureReason,run.phase,tostring(run.mode=="D0146_GUIDE"))
end

function Control:_abandonAfterJobChange(run,changed)
    for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do self.driveAuthority:clear(p.vehicle); self.permissionGate:release(p.vehicle); self.configurationAuthority:clear(p.vehicle); self:_endRepresentationConfigurationAuthority(p) end
    self.run=nil
    logWarning("ABORT commitment=%s reason=JOB_EPISODE_CHANGED participant=%s physicalAuthorityCleared=true",tostring(run.commitmentId),changed and changed.name or "unknown")
    self:_notify({status="FAILED",commitmentId=run.commitmentId,requestIds={run.a.request.identity,run.b.request.identity},assemblyIds={run.a.assemblyId,run.b.assemblyId},evidence={kind="COOPERATIVE_PASSAGE_JOB_EPISODE_CHANGED",participant=changed and changed.name or nil}})
end

function Control:_executeD0146JointRequests(requestA,requestB,candidate,bridge)
    if OuttaMyWay.D0146_STEP2_COOPERATIVE_PASSAGE_ENABLED~=true then return false,"D0146_STEP2_COOPERATIVE_PASSAGE_DISABLED" end
    if self.run~=nil then return false,"COOPERATIVE_PASSAGE_CONTROL_ALREADY_ACTIVE" end
    if requestA==nil or requestB==nil or candidate==nil then return false,"MISSING_JOINT_CONTROL_CONTEXT" end
    OuttaMyWay.ValueRecord.assertType(requestA,"ControlRequest"); OuttaMyWay.ValueRecord.assertType(requestB,"ControlRequest")
    if requestA.commitmentId~=requestB.commitmentId then return false,"JOINT_REQUEST_COMMITMENT_MISMATCH" end
    if requestA.assemblyId==requestB.assemblyId then return false,"JOINT_REQUEST_REQUIRES_TWO_ASSEMBLIES" end
    if requestA.capability~="REPOSITION" or requestB.capability~="REPOSITION" then return false,"JOINT_REQUEST_REQUIRES_REPOSITION" end
    if requestA.effectiveActuationCompositionId~=requestB.effectiveActuationCompositionId then return false,"JOINT_REQUEST_COMPOSITION_MISMATCH" end
    if not self:_validAuthority(requestA) or not self:_validAuthority(requestB) then return false,"JOINT_REQUEST_AUTHORITY_INVALID" end
    if type(bridge)~="table" or bridge.architecture~="D0146_STEP2" or bridge.controlProfile~="D0146_PASSAGE_EXCURSION_V6" then return false,"D0146_PASSAGE_BRIDGE_INVALID" end

    local subjectVehicle=self:_resolveReference(bridge.subjectReferenceKey)
    local otherVehicle=self:_resolveReference(bridge.otherReferenceKey)
    if subjectVehicle==nil or otherVehicle==nil then return false,"SUPPORTED_D0146_PAIR_NOT_ACTIVE_AT_CONTROL" end
    local requestByAssembly={[requestA.assemblyId]=requestA,[requestB.assemblyId]=requestB}
    local a,reasonA=self:_participant(subjectVehicle,bridge.subjectAssemblyId,requestByAssembly[bridge.subjectAssemblyId],0)
    if a==nil then return false,"SUBJECT_"..tostring(reasonA) end
    local b,reasonB=self:_participant(otherVehicle,bridge.otherAssemblyId,requestByAssembly[bridge.otherAssemblyId],0)
    if b==nil then return false,"OTHER_"..tostring(reasonB) end
    if a.request==nil or b.request==nil then return false,"JOINT_REQUEST_ASSEMBLY_BINDING_UNAVAILABLE" end
    if a.startJobToken~=bridge.subjectJobToken or b.startJobToken~=bridge.otherJobToken then return false,"JOB_EPISODE_CHANGED_SINCE_PASSAGE_PLANNING" end

    local configurationPlan=bridge.passageConfiguration
    local configurationByAssembly=configurationPlanByAssembly(configurationPlan)
    if configurationByAssembly==nil then return false,"D0146_PASSAGE_CONFIGURATION_PLAN_UNAVAILABLE" end
    for _,participant in OuttaMyWay.ValueRecord.ipairs({a,b}) do
        local planned=configurationByAssembly[participant.assemblyId]
        if planned==nil then return false,"D0146_PASSAGE_CONFIGURATION_PARTICIPANT_MISSING:"..tostring(participant.assemblyId) end
        participant.configurationMode=planned.mode
        participant.currentFacingClearanceExtentM=tonumber(planned.currentFacingClearanceExtentM)
        participant.selectedFacingClearanceExtentM=tonumber(planned.selectedFacingClearanceExtentM)
        participant.configurationReleasedSpaceM=tonumber(planned.configurationReleasedSpaceM) or 0
        participant.expectedCompactConfigurationProfileId=planned.expectedCompactConfigurationProfileId
        participant.configurationAuthority=planned.configurationAuthority
        if participant.configurationMode=="COMPACT_REQUIRED" then
            local fold=self.configurationAuthority:getEvidence(participant.vehicle)
            if fold.foldableCount==0 then return false,"D0146_REQUIRED_CONFIGURATION_REDUCTION_UNAVAILABLE:"..participant.name end
            if fold.allDeployed~=true then return false,"D0146_REQUIRED_CONFIGURATION_NOT_STABLE_DEPLOYED:"..participant.name end
        elseif participant.configurationMode~="RETAIN_CURRENT" then
            return false,"D0146_PASSAGE_CONFIGURATION_MODE_INVALID:"..tostring(participant.configurationMode)
        end
    end

    local entryReady=bridge.passageEntry and bridge.passageEntry.ready==true
    local run={
        mode="D0146_GUIDE",commitmentId=requestA.commitmentId,candidateId=candidate.identity,a=a,b=b,participants={a,b},
        subjectAssemblyId=bridge.subjectAssemblyId,otherAssemblyId=bridge.otherAssemblyId,
        phase=entryReady and "SETTLING" or "PASSAGE_APPROACH",phaseStartedAt=g_time or 0,startedAt=g_time or 0,guide=bridge.passageGuide,guideIndex=0,
        passageArrangement=bridge.passageArrangement,passageConfiguration=configurationPlan,passageEntry=bridge.passageEntry,passageExcursion=bridge.passageExcursion,controlProfile=bridge.controlProfile,
        thirdPartyConstraints=bridge.localPassageSpace and bridge.localPassageSpace.thirdPartyConstraints or {},
        initialSeparationM=distance(a.startX,a.startZ,b.startX,b.startZ),headingDot=dot(a.startForwardX,a.startForwardZ,b.startForwardX,b.startForwardZ),
        speedKmh=OuttaMyWay.D0146_STEP2_MOVE_SPEED_KMH or 8.0
    }
    local guideOk,guideReason=self:_preflightD0146Guide(run)
    if not guideOk then return false,"D0146_GUIDE_PREFLIGHT:"..tostring(guideReason) end

    self.run=run
    if entryReady then
        local settleOk,settleReason=self:_beginD0146Settling(run,"ENTRY_READY_AT_SELECTION")
        if not settleOk then self.run=nil; return false,settleReason end
    else
        logInfo("D0146_PASSAGE_APPROACH_START commitment=%s resolutionSpaceSuperseded=true nativeProductiveApproach=true longitudinalSeparation=%.2fm entryBoundary=%.2fm",
            tostring(run.commitmentId),tonumber(bridge.passageEntry and bridge.passageEntry.selectionLongitudinalSeparationM) or -1,tonumber(bridge.passageEntry and bridge.passageEntry.boundarySeparationM) or -1)
    end
    local arrangement=bridge.passageArrangement or {}
    local excursion=run.passageExcursion or {}
    local entry=run.passageEntry or {}
    logInfo("START architecture=D0146_STEP2 commitment=%s candidate=%s conflict=%s A=%s job=%s B=%s job=%s separation=%.2fm entryBoundary=%.2fm headingDot=%.4f envelopeBasis=%s crossingBasis=%s arrangement=%s offsets=%+.2f/%+.2f deficit=%.2fm contact=%.2fm nominal=%.2fm required=%.2fm currentLateral=%.2fm reserve=%+.2fm guide=%s gates=%d development=%.2fm crossingForward=%.2fm recovery=%.2fm sequence=PASSAGE_APPROACH_THEN_HOLD_OPTIONAL_CONFIGURATION_CAPTURE_EXECUTION_ORIGIN_PASSAGE_EXCURSION_SELECTIVE_RESTORE_HANDOFF configuration=%s controlInventsGeometry=false vehicleNameGate=false thirdPartyConstraints=%d generalVehicleAuthority=false",
        tostring(run.commitmentId),tostring(run.candidateId),tostring(bridge.conflictIdentity),a.name,tostring(a.startJobToken),b.name,tostring(b.startJobToken),run.initialSeparationM,tonumber(entry.boundarySeparationM) or -1,run.headingDot,
        tostring(arrangement.directionalPassageEnvelopeBasis or "DISC_FALLBACK"),tostring(excursion.crossingWindowBasis or "n/a"),tostring(arrangement.identity),tonumber(arrangement.subjectLateralOffsetM) or 0,tonumber(arrangement.otherLateralOffsetM) or 0,tonumber(excursion.clearanceDeficitM) or 0,
        tonumber(arrangement.physicalContactThresholdM) or 0,tonumber(arrangement.nominalInterAssemblyClearanceM) or 0,tonumber(arrangement.policyRequiredSeparationM) or 0,tonumber(arrangement.currentLateralSeparationM) or 0,tonumber(arrangement.currentPolicyReserveM) or 0,
        tostring(run.guide and run.guide.identity),OuttaMyWay.ValueRecord.length(run.guide and run.guide.gates or {}),tonumber(excursion.developmentDistanceM) or 0,tonumber(excursion.crossingWindowForwardPerParticipantM) or 0,tonumber(excursion.recoveryDistanceM) or 0,configurationModeText(run),OuttaMyWay.ValueRecord.length(run.thirdPartyConstraints or {}))
    return true,"D0146_COOPERATIVE_PASSAGE_STARTED"
end

function Control:executeJointRequests(requestA,requestB,candidate)
    local bridge=candidate and candidate.evidenceBasis and candidate.evidenceBasis.cooperativePassageBridge or nil
    if type(bridge)=="table" and bridge.architecture=="D0146_STEP2" then return self:_executeD0146JointRequests(requestA,requestB,candidate,bridge) end
    return self:_executeLegacyJointRequests(requestA,requestB,candidate)
end

function Control:_executeLegacyJointRequests(requestA,requestB,candidate)
    if OuttaMyWay.COOPERATIVE_PASSAGE_TS015_ENABLED~=true then return false,"TS015_COOPERATIVE_PASSAGE_DISABLED" end
    if self.run~=nil then return false,"COOPERATIVE_PASSAGE_CONTROL_ALREADY_ACTIVE" end
    if requestA==nil or requestB==nil or candidate==nil then return false,"MISSING_JOINT_CONTROL_CONTEXT" end
    OuttaMyWay.ValueRecord.assertType(requestA,"ControlRequest"); OuttaMyWay.ValueRecord.assertType(requestB,"ControlRequest")
    if requestA.commitmentId~=requestB.commitmentId then return false,"JOINT_REQUEST_COMMITMENT_MISMATCH" end
    if requestA.assemblyId==requestB.assemblyId then return false,"JOINT_REQUEST_REQUIRES_TWO_ASSEMBLIES" end
    if requestA.capability~="REPOSITION" or requestB.capability~="REPOSITION" then return false,"JOINT_REQUEST_REQUIRES_REPOSITION" end
    if requestA.effectiveActuationCompositionId~=requestB.effectiveActuationCompositionId then return false,"JOINT_REQUEST_COMPOSITION_MISMATCH" end
    if not self:_validAuthority(requestA) or not self:_validAuthority(requestB) then return false,"JOINT_REQUEST_AUTHORITY_INVALID" end

    local bridge=candidate.evidenceBasis and candidate.evidenceBasis.cooperativePassageBridge or nil
    if type(bridge)~="table" then return false,"COOPERATIVE_PASSAGE_BRIDGE_UNAVAILABLE" end
    local condorVehicle=self:_resolveReference(bridge.condorReferenceKey)
    local patriotVehicle=self:_resolveReference(bridge.patriotReferenceKey)
    if condorVehicle==nil or patriotVehicle==nil then return false,"SUPPORTED_TS015_PAIR_NOT_ACTIVE_AT_CONTROL" end

    local requestByAssembly={[requestA.assemblyId]=requestA,[requestB.assemblyId]=requestB}
    local a,reasonA=self:_participant(condorVehicle,bridge.condorAssemblyId,requestByAssembly[bridge.condorAssemblyId],1)
    if a==nil then return false,"CONDOR_"..tostring(reasonA) end
    local b,reasonB=self:_participant(patriotVehicle,bridge.patriotAssemblyId,requestByAssembly[bridge.patriotAssemblyId],-1)
    if b==nil then return false,"PATRIOT_"..tostring(reasonB) end
    if a.request==nil or b.request==nil then return false,"JOINT_REQUEST_ASSEMBLY_BINDING_UNAVAILABLE" end
    if a.startJobToken~=bridge.condorJobToken or b.startJobToken~=bridge.patriotJobToken then return false,"JOB_EPISODE_CHANGED_SINCE_SITUATION_ASSESSMENT" end

    local headingDot=dot(a.startForwardX,a.startForwardZ,b.startForwardX,b.startForwardZ)
    local dx,dz=b.startX-a.startX,b.startZ-a.startZ
    local separationM=math.sqrt(dx*dx+dz*dz)
    local rightX,rightZ=tonumber(bridge.sharedRightX),tonumber(bridge.sharedRightZ)
    if rightX==nil or rightZ==nil then return false,"SITUATION_SHARED_PASSAGE_FRAME_UNAVAILABLE" end
    local lateral=math.abs(dot(dx,dz,rightX,rightZ))
    local maxDot=OuttaMyWay.COOPERATIVE_PASSAGE_TS015_MAX_HEADING_DOT or -0.99
    local maxLat=OuttaMyWay.COOPERATIVE_PASSAGE_TS015_MAX_INITIAL_LATERAL_OFFSET_M or 2.0
    local minSep=(OuttaMyWay.COOPERATIVE_PASSAGE_TS015_MIN_START_SEPARATION_M or 50.0)-2.0
    local maxSep=(OuttaMyWay.COOPERATIVE_PASSAGE_TS015_MAX_START_SEPARATION_M or 70.0)+1.0
    if headingDot>maxDot+0.005 then return false,"CONTROL_REVALIDATION_HEADINGS_EXITED_TS015_SCOPE" end
    if lateral>maxLat+0.5 then return false,"CONTROL_REVALIDATION_LATERAL_OFFSET_EXITED_TS015_SCOPE" end
    if separationM<minSep or separationM>maxSep then return false,"CONTROL_REVALIDATION_SEPARATION_EXITED_TS015_SCOPE" end
    if dot(dx,dz,a.startForwardX,a.startForwardZ)<=0 or dot(-dx,-dz,b.startForwardX,b.startForwardZ)<=0 then return false,"CONTROL_REVALIDATION_PAIR_NO_LONGER_MUTUALLY_FACING" end

    local foldA=self.configurationAuthority:getEvidence(condorVehicle)
    local foldB=self.configurationAuthority:getEvidence(patriotVehicle)
    if foldA.foldableCount==0 or foldB.foldableCount==0 then return false,"TS015_PAIR_NOT_FOLDABLE" end
    if foldA.allDeployed~=true or foldB.allDeployed~=true then return false,"TS015_PAIR_NOT_FULLY_DEPLOYED_AT_COMMITMENT" end

    local lateralM=OuttaMyWay.COOPERATIVE_PASSAGE_LATERAL_OFFSET_M or 6.0
    local sidestepForwardM=OuttaMyWay.COOPERATIVE_PASSAGE_SIDESTEP_FORWARD_M or 12.0
    local passForwardM=separationM*0.5+(OuttaMyWay.COOPERATIVE_PASSAGE_PASS_MARGIN_M or 8.0)
    local rejoinForwardM=passForwardM+(OuttaMyWay.COOPERATIVE_PASSAGE_POST_PASS_FORWARD_M or 12.0)
    local run={
        commitmentId=requestA.commitmentId,candidateId=candidate.identity,a=a,b=b,participants={a,b},phase="SETTLING",phaseStartedAt=g_time or 0,startedAt=g_time or 0,
        sharedAxisX=bridge.sharedAxisX,sharedAxisZ=bridge.sharedAxisZ,sharedRightX=rightX,sharedRightZ=rightZ,
        initialSeparationM=separationM,initialLateralOffsetM=lateral,headingDot=headingDot,
        lateralM=lateralM,sidestepForwardM=sidestepForwardM,passForwardM=passForwardM,rejoinForwardM=rejoinForwardM,
        speedKmh=OuttaMyWay.COOPERATIVE_PASSAGE_MOVE_SPEED_KMH or 8.0,
        sidestepRadiusM=OuttaMyWay.COOPERATIVE_PASSAGE_SIDESTEP_TARGET_RADIUS_M or 2.0,
        passRadiusM=OuttaMyWay.COOPERATIVE_PASSAGE_PASS_TARGET_RADIUS_M or 1.0,
        rejoinRadiusM=OuttaMyWay.COOPERATIVE_PASSAGE_REJOIN_TARGET_RADIUS_M or 2.0
    }
    local fieldOk,fieldReason=self:_preflightTargets(run)
    if not fieldOk then return false,"FIELD_CONTAINMENT_PREFLIGHT:"..tostring(fieldReason) end

    local holdA,holdReasonA=self.permissionGate:setHold(a.vehicle,"D0143-COOPERATIVE-PASSAGE")
    if not holdA then return false,"CONDOR_HOLD_UNAVAILABLE:"..tostring(holdReasonA) end
    local holdB,holdReasonB=self.permissionGate:setHold(b.vehicle,"D0143-COOPERATIVE-PASSAGE")
    if not holdB then self.permissionGate:release(a.vehicle); return false,"PATRIOT_HOLD_UNAVAILABLE:"..tostring(holdReasonB) end

    self.run=run
    logInfo("START commitment=%s candidate=%s A=%s job=%s B=%s job=%s separation=%.2fm lateral=%.2fm headingDot=%.4f sequence=HOLD_BOTH_COMPACT_BOTH_SIDESTEP_BOTH_PASS_FORWARD_BOTH_REJOIN_BOTH_RESTORE_BOTH_HANDOFF_BOTH king=false refuge=false generalVehicleAuthority=false",
        tostring(run.commitmentId),tostring(run.candidateId),a.name,tostring(a.startJobToken),b.name,tostring(b.startJobToken),separationM,lateral,headingDot)
    return true,"COOPERATIVE_PASSAGE_STARTED"
end

function Control:update(dt)
    local run=self.run
    if run==nil then return end
    if run.mode=="D0146_GUIDE" and OuttaMyWay.D0146_STEP2_COOPERATIVE_PASSAGE_ENABLED~=true then self:_failHeld("D0146_STEP2_DISABLED_DURING_ACTIVE_COMMITMENT"); return end
    if run.mode~="D0146_GUIDE" and OuttaMyWay.COOPERATIVE_PASSAGE_TS015_ENABLED~=true then return end
    local nowMs=g_time or 0
    local sameJob,changed=self:_allSameJob(run)
    if not sameJob then self:_abandonAfterJobChange(run,changed); return end
    if run.mode=="D0146_GUIDE" then
        local thirdOk,thirdReason=self:_thirdPartySupport(run,nil)
        if not thirdOk then self:_failHeld(thirdReason); return end
    end

    local timeout=(run.mode=="D0146_GUIDE" and OuttaMyWay.D0146_STEP2_PHASE_WATCHDOG_MS) or OuttaMyWay.COOPERATIVE_PASSAGE_PHASE_WATCHDOG_MS or 45000
    if run.failureReason==nil and nowMs-(run.phaseStartedAt or nowMs)>=timeout then self:_failHeld("PHASE_WATCHDOG:"..tostring(run.phase)); return end

    if run.phase=="PASSAGE_APPROACH" then
        local longitudinal=self:_d0146LongitudinalSeparation(run)
        if longitudinal==nil then self:_failHeld("PASSAGE_APPROACH_LONGITUDINAL_SEPARATION_UNAVAILABLE"); return end
        local boundary=tonumber(run.passageEntry and run.passageEntry.boundarySeparationM)
        if boundary==nil then self:_failHeld("PASSAGE_ENTRY_BOUNDARY_UNAVAILABLE"); return end
        if longitudinal<=boundary then
            local ok,reason=self:_beginD0146Settling(run,"ENTRY_BOUNDARY_REACHED")
            if not ok then self:_failHeld(reason) end
        end
    elseif run.phase=="SETTLING" then
        if self:_allStopped(run) then
            if run.mode=="D0146_GUIDE" then
                local ok,reason=self:_beginD0146Configuration(run); if not ok then self:_failHeld("CONFIGURATION_START:"..tostring(reason)) end
            else
                local ok,reason=self:_beginCompact(run); if not ok then self:_failHeld("COMPACT_START:"..tostring(reason)) end
            end
        end
    elseif run.phase=="CONFIGURING" then
        if self:_d0146ConfigurationReady(run) then
            logInfo("CONFIGURATION_CONFIRMED commitment=%s modes=%s next=CAPTURE_EXECUTION_ORIGIN",tostring(run.commitmentId),configurationModeText(run))
            local rebased,rebaseReason=self:_rebaseD0146Guide(run)
            if not rebased then self:_failHeld(tostring(rebaseReason)); return end
            local ok,reason=self:_startGuideGate(run,1)
            if not ok then self:_failHeld(tostring(reason)) end
        end
    elseif run.phase=="COMPACTING" then
        if self:_allFolded(run) then
            logInfo("COMPACT_CONFIRMED commitment=%s A=%s %s B=%s %s",tostring(run.commitmentId),run.a.name,foldText(self.configurationAuthority:getEvidence(run.a.vehicle)),run.b.name,foldText(self.configurationAuthority:getEvidence(run.b.vehicle)))
            if run.mode=="D0146_GUIDE" then
                local ok,reason=self:_startGuideGate(run,1)
                if not ok then self:_failHeld(tostring(reason)) end
            else
                local ok,reason=self:_startLeg(run,"SIDESTEPPING",run.sidestepForwardM,run.lateralM,run.sidestepRadiusM)
                if not ok then self:_failHeld("SIDESTEP_START:"..tostring(reason)) end
            end
        end
    elseif string.sub(tostring(run.phase),1,6)=="GUIDE_" then
        -- GIANTS native isBlocked remains observation evidence, but it is not
        -- standalone physical Passage Support Loss authority while OuttaMyWay
        -- executes a Candidate-proven guide.  TS015 v0.1.0.6 demonstrated that
        -- GIANTS can report blocked=true for a folded sprayer while represented
        -- pair occupancy is still safely separated.
        if self:_bothReached(run) then
            local completedIndex=run.guideIndex or 0
            local gate=run.guide and run.guide.gates and run.guide.gates[completedIndex] or nil
            self:_stopLeg(run)
            logInfo("GUIDE_REACHED commitment=%s guide=%s gate=%d/%d kind=%s",tostring(run.commitmentId),tostring(run.guide and run.guide.identity),completedIndex,OuttaMyWay.ValueRecord.length(run.guide and run.guide.gates or {}),tostring(gate and gate.kind or "n/a"))
            if completedIndex>=OuttaMyWay.ValueRecord.length(run.guide and run.guide.gates or {}) then
                logInfo("D0146_PASSAGE_SECOND_WHISTLE commitment=%s guide=%s pairDependentCrossingComplete=true nativeAxisRecoveryPlanned=true next=SELECTIVE_RESTORE_HANDOFF",tostring(run.commitmentId),tostring(run.guide and run.guide.identity))
                local ok,reason=self:_beginD0146Restore(run); if not ok then self:_failHeld("RESTORE_START:"..tostring(reason)) end
            else
                local ok,reason=self:_startGuideGate(run,completedIndex+1); if not ok then self:_failHeld(tostring(reason)) end
            end
        end
    elseif run.phase=="SIDESTEPPING" then
        if self:_bothReached(run) then
            self:_stopLeg(run)
            local ok,reason=self:_startLeg(run,"PASSING",run.passForwardM,run.lateralM,run.passRadiusM)
            if not ok then self:_failHeld("PASS_START:"..tostring(reason)) end
        end
    elseif run.phase=="PASSING" then
        if self:_bothReached(run) then
            self:_stopLeg(run)
            local pa,pb=pose(run.a.vehicle),pose(run.b.vehicle)
            logInfo("PASS_COMPLETE commitment=%s separation=%s next=REJOIN",tostring(run.commitmentId),pa and pb and string.format("%.2fm",distance(pa.x,pa.z,pb.x,pb.z)) or "n/a")
            local ok,reason=self:_startLeg(run,"REJOINING",run.rejoinForwardM,0.0,run.rejoinRadiusM)
            if not ok then self:_failHeld("REJOIN_START:"..tostring(reason)) end
        end
    elseif run.phase=="REJOINING" then
        if self:_bothReached(run) then local ok,reason=self:_beginRestore(run); if not ok then self:_failHeld("RESTORE_START:"..tostring(reason)) end end
    elseif run.phase=="RESTORING" then
        if run.mode=="D0146_GUIDE" then
            if self:_d0146RestoreReady(run) then
                local ok,reason=self:_finishD0146Restore(run); if not ok then self:_failHeld("RESTORE_FINISH:"..tostring(reason)) end
            end
        elseif self:_allDeployed(run) then
            local okA,reasonA=self.configurationAuthority:finishRestore(run.a.vehicle)
            local okB,reasonB=self.configurationAuthority:finishRestore(run.b.vehicle)
            if not okA or not okB then self:_failHeld("RESTORE_FINISH:A="..tostring(reasonA)..":B="..tostring(reasonB)) else self:_complete(run) end
        end
    elseif run.phase=="FAILED_RESTORING" then
        local restored=(run.mode=="D0146_GUIDE" and self:_d0146RestoreReady(run)) or (run.mode~="D0146_GUIDE" and self:_allDeployed(run))
        if restored then
            for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do
                if self.configurationAuthority:getState(p.vehicle)~=nil then self.configurationAuthority:finishRestore(p.vehicle) end
                self:_endRepresentationConfigurationAuthority(p)
            end
            self:_setPhase(run,"FAILED_HELD",nowMs)
            logWarning("FAIL_RESTORE_COMPLETE commitment=%s bothRemainHeld=true action=PLAYER_INTERVENTION_OR_JOB_CHANGE",tostring(run.commitmentId))
        end
    end

    if self.run~=nil and nowMs>=(self.nextHeartbeatMs or 0) then
        self.nextHeartbeatMs=nowMs+(OuttaMyWay.COOPERATIVE_PASSAGE_HEARTBEAT_MS or 1000)
        local pa,pb=pose(run.a.vehicle),pose(run.b.vehicle)
        logInfo("STATE commitment=%s phase=%s A=%s speed=%.2f B=%s speed=%.2f separation=%s failure=%s",
            tostring(run.commitmentId),tostring(run.phase),run.a.name,actualSpeedKmh(run.a.vehicle),run.b.name,actualSpeedKmh(run.b.vehicle),
            pa and pb and string.format("%.2fm",distance(pa.x,pa.z,pb.x,pb.z)) or "n/a",tostring(run.failureReason or "none"))
    end
end
