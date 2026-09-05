-- FS25_OuttaMyWay v0.1.14.0 CANONICAL CANDIDATE — D-0192 Passage + validated D-0195 Assembly Axis Settlement.
--
-- Situation/Candidate/Decision/Commitment establish the pair meaning and the
-- bounded Passage plan before this module is invoked. Passage Selection now
-- immediately owns the encounter, restoring the v0.1.3.0 authority handoff.
-- Control may remain in PASSAGE_APPROACH until the Candidate Entry Boundary is
-- reached, then settles/configures the pair and instantiates the participant
-- guide from actual execution origins before forward-only point pursuit.
-- Passage geometry, Entry timing and guide semantics remain unchanged. For
-- TRANSIT_BASE plans every participant carries one TRANSIT_REQUIRED obligation:
-- always request Transit, then wait only while GIANTS reports native fold actuation
-- still moving. D-0178 Transit Motion Settlement does not interpret allFolded,
-- allDeployed, configuration profiles, current-vs-Transit geometry, or command return
-- as execution authority. Inert/unsupported requests are non-veto; real folding stays
-- held until native foldMoveDirection settles to zero. D-0192 leaves Phases 1-7
-- unchanged, strengthens final Recovery into whole-assembly axis alignment, then
-- adds one-at-a-time straight Axis Return before participant-specific restore/handoff.
-- D-0195 corrects one D-0192 evidence error exposed by the extended TS010
-- run: the Phase-5 member pose is a Passage origin, not a target articulation
-- shape.  Recovery Alignment now requires the vehicle to regain the captured
-- axis and all observed member headings to settle parallel/anti-parallel to
-- that axis; fixed side offsets are not treated as unsettled translation.
-- Positive current occupancy transfers the return token; unsupported return falls
-- back to safe restore/handoff rather than soft-locking or point-seeking in reverse.

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
    logInfo("LOAD architecture=D0146_TRANSIT_ONLY_FAIL_CLOSED mechanicalProfile=JOB_START_CAPABILITY_GUIDED_PASSAGE vehicleNameGate=false legacyD0143=false driveHook=%s reason=%s king=false refuge=false cooldown=false generalVehicleAuthority=false",
        tostring(ok),tostring(reason or "ready"))
end

function Control:deleteMap()
    local run=self.run
    if run~=nil then
        for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
            self.driveAuthority:clear(p.vehicle); if p.released~=true then self.permissionGate:release(p.vehicle) end
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
            if participant.released~=true then
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
    local grantOk=self.runtime.boundedAuthority:validateRequest(request)
    if grantOk~=true then return false end
    for _,token in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(request.commitmentId)) do
        if token.identity==request.authorityToken and token.assemblyId==request.assemblyId and self.runtime.authorities:validate(token)==true then return true end
    end
    return false
end

function Control:_allSameJob(run)
    for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do
        if p.released~=true and currentJobToken(p.vehicle)~=p.startJobToken then return false,p end
    end
    return true,nil
end
function Control:_allStopped(run)
    local limit=OuttaMyWay.D0146_COOPERATIVE_PASSAGE_HOLD_EFFECT_SPEED_KMH or 0.25
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
    subjectParticipant.executionOriginX,subjectParticipant.executionOriginZ=subjectPose.x,subjectPose.z
    subjectParticipant.axisForwardX,subjectParticipant.axisForwardZ=sfx,sfz
    otherParticipant.executionOriginX,otherParticipant.executionOriginZ=otherPose.x,otherPose.z
    otherParticipant.axisForwardX,otherParticipant.axisForwardZ=ofx,ofz
    local cache=self.runtime and self.runtime.assemblyRepresentationCache or nil
    if cache==nil or type(cache.getAssemblyAlignmentSnapshot)~="function" then return false,"ASSEMBLY_ALIGNMENT_CACHE_UNAVAILABLE" end
    -- D-0195: Phase-5 pose is the Axis Return reference frame, not an
    -- articulation pose which Recovery must reproduce.  Alignment is observed
    -- later against this captured axis; do not freeze member lateral offsets or
    -- member headings here as an execution target.
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

local function envelopeLength(envelope)
    if type(envelope)~="table" then return nil end
    local length=tonumber(envelope.lengthM)
    if length~=nil and length>0 then return length end
    local minF,maxF=tonumber(envelope.minForwardM),tonumber(envelope.maxForwardM)
    if minF~=nil and maxF~=nil and maxF>minF then return maxF-minF end
    return nil
end

local function maximumEnvelopeProjectionAlongAxis(envelope,envelopeForwardX,envelopeForwardZ,axisForwardX,axisForwardZ)
    if type(envelope)~="table" then return nil end
    local minR,maxR=tonumber(envelope.minRightM),tonumber(envelope.maxRightM)
    local minF,maxF=tonumber(envelope.minForwardM),tonumber(envelope.maxForwardM)
    if minR==nil or maxR==nil or minF==nil or maxF==nil then return nil end
    local rightX,rightZ=envelopeForwardZ,-envelopeForwardX
    local maximum=nil
    for _,corner in ipairs({{minR,minF},{maxR,minF},{maxR,maxF},{minR,maxF}}) do
        local wx=rightX*corner[1]+envelopeForwardX*corner[2]
        local wz=rightZ*corner[1]+envelopeForwardZ*corner[2]
        local projection=wx*axisForwardX+wz*axisForwardZ
        maximum=maximum==nil and projection or math.max(maximum,projection)
    end
    return maximum
end

function Control:_alignmentSnapshot(participant)
    local cache=self.runtime and self.runtime.assemblyRepresentationCache or nil
    if cache==nil or type(cache.getAssemblyAlignmentSnapshot)~="function" then return nil,"ASSEMBLY_ALIGNMENT_CACHE_UNAVAILABLE" end
    return cache:getAssemblyAlignmentSnapshot(participant.referenceKey,participant.startJobToken,participant.executionOriginX,participant.executionOriginZ,participant.axisForwardX,participant.axisForwardZ)
end

function Control:_assemblyAxisSettled(participant)
    if participant==nil then return false,"ASSEMBLY_AXIS_PARTICIPANT_UNAVAILABLE" end
    local current,reason=self:_alignmentSnapshot(participant)
    if current==nil then return false,reason end
    local pp=pose(participant.vehicle)
    if pp==nil then return false,"ASSEMBLY_AXIS_VEHICLE_POSE_UNAVAILABLE" end
    local fx,fz=tonumber(participant.axisForwardX),tonumber(participant.axisForwardZ)
    local ox,oz=tonumber(participant.executionOriginX),tonumber(participant.executionOriginZ)
    if fx==nil or fz==nil or ox==nil or oz==nil then return false,"ASSEMBLY_AXIS_FRAME_UNAVAILABLE" end
    local rightX,rightZ=fz,-fx
    local lateralTolerance=tonumber(OuttaMyWay.D0146_ASSEMBLY_ALIGNMENT_LATERAL_TOLERANCE_M) or 0.50
    local headingMinDot=tonumber(OuttaMyWay.D0146_ASSEMBLY_ALIGNMENT_HEADING_MIN_DOT) or 0.995
    local vehicleLateral=(pp.x-ox)*rightX+(pp.z-oz)*rightZ
    if math.abs(vehicleLateral)>lateralTolerance then
        return false,string.format("ASSEMBLY_VEHICLE_AXIS_LATERAL_NOT_SETTLED:%.3f",vehicleLateral)
    end
    local vehicleHeadingDot=dot(pp.dx,pp.dz,fx,fz)
    if vehicleHeadingDot<headingMinDot then
        return false,string.format("ASSEMBLY_VEHICLE_AXIS_HEADING_NOT_SETTLED:%.5f",vehicleHeadingDot)
    end
    local memberCount=OuttaMyWay.ValueRecord.length(current.members or {})
    if memberCount<1 then return false,"ASSEMBLY_AXIS_MEMBER_EVIDENCE_UNAVAILABLE" end
    -- Member root-node +Z conventions may be reversed, so parallel or
    -- anti-parallel is acceptable.  What matters for straight reverse is that
    -- an articulated member is no longer materially angled across the captured
    -- working axis.  Fixed side offsets are deliberately ignored.
    for _,m in OuttaMyWay.ValueRecord.ipairs(current.members or {}) do
        local memberHeadingDot=math.abs(dot(tonumber(m.headingX) or 0,tonumber(m.headingZ) or 0,fx,fz))
        if memberHeadingDot<headingMinDot then
            return false,string.format("ASSEMBLY_MEMBER_AXIS_HEADING_NOT_SETTLED:%s:%.5f",tostring(m.memberReferenceKey),memberHeadingDot)
        end
    end
    return true,nil,current
end

function Control:_stagedBeyondOtherTransitReturn(participant,other)
    local pp=pose(participant.vehicle)
    if pp==nil then return false,"RETURN_STAGING_POSE_UNAVAILABLE" end
    local envelope=participant.transitPassageEnvelope
    local minForward=type(envelope)=="table" and tonumber(envelope.minForwardM) or nil
    if minForward==nil then return false,"RETURN_STAGING_TRANSIT_REAR_EXTENT_UNAVAILABLE" end
    local otherProjection=maximumEnvelopeProjectionAlongAxis(other.transitPassageEnvelope,other.axisForwardX,other.axisForwardZ,participant.axisForwardX,participant.axisForwardZ)
    if otherProjection==nil then return false,"RETURN_STAGING_OTHER_TRANSIT_ENVELOPE_UNAVAILABLE" end
    local progress=(pp.x-participant.executionOriginX)*participant.axisForwardX+(pp.z-participant.executionOriginZ)*participant.axisForwardZ
    local otherOriginProgress=(other.executionOriginX-participant.executionOriginX)*participant.axisForwardX+(other.executionOriginZ-participant.executionOriginZ)*participant.axisForwardZ
    local limit=otherOriginProgress+otherProjection
    return progress+minForward>=limit,nil,{progressM=progress,rearStationM=progress+minForward,otherReturnLimitM=limit}
end

function Control:_participantRunoutReady(participant,other)
    local aligned,alignmentReason=self:_assemblyAxisSettled(participant)
    if not aligned then return false,alignmentReason end
    local staged,stagingReason,evidence=self:_stagedBeyondOtherTransitReturn(participant,other)
    if not staged then return false,stagingReason end
    return true,nil,evidence
end

function Control:_startRunoutChunk(run,participant)
    local pp=pose(participant.vehicle)
    if pp==nil then return false,"ALIGNMENT_RUNOUT_POSE_UNAVAILABLE" end
    local length=envelopeLength(participant.transitPassageEnvelope)
    if length==nil or length<=0 then return false,"ALIGNMENT_RUNOUT_TRANSIT_LENGTH_UNAVAILABLE" end
    local tx,tz=pp.x+participant.axisForwardX*length,pp.z+participant.axisForwardZ*length
    local inside,fieldReason=fieldResolvedAt(tx,tz)
    if not inside then return false,"ALIGNMENT_RUNOUT_FIELD_TARGET:"..tostring(fieldReason) end
    local progress=(pp.x-participant.executionOriginX)*participant.axisForwardX+(pp.z-participant.executionOriginZ)*participant.axisForwardZ
    local tolerance=tonumber(OuttaMyWay.D0146_STEP2_TRAVERSAL_GATE_RADIUS_M) or 1.0
    local ok,reason=self.driveAuthority:setAxisTravel(participant.vehicle,participant.executionOriginX,participant.executionOriginZ,participant.axisForwardX,participant.axisForwardZ,progress+length,run.speedKmh,true,tolerance)
    if not ok then return false,"ALIGNMENT_RUNOUT_ACTUATION:"..tostring(reason) end
    participant.runoutActive=true
    logInfo("ALIGNMENT_RUNOUT_START commitment=%s participant=%s chunk=%.2fm targetStation=%.2fm derivedFrom=TRANSIT_ASSEMBLY_LENGTH",tostring(run.commitmentId),participant.name,length,progress+length)
    return true,nil
end

function Control:_beginAlignmentRunout(run)
    self:_stopLeg(run)
    self:_setPhase(run,"ALIGNMENT_RUNOUT",g_time or 0)
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
        participant.runoutActive=false; participant.runoutReady=false; participant.targetX=nil; participant.targetZ=nil
    end
    logInfo("RECOVERY_ALIGNMENT_START commitment=%s wholeAssemblyAxisSettlementRequired=true returnStaging=TRANSIT_ENVELOPE_DERIVED",tostring(run.commitmentId))
    return true,nil
end

function Control:_updateAlignmentRunout(run)
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
        if participant.runoutReady~=true then
            if participant.runoutActive==true and targetReached(self.driveAuthority,participant.vehicle) then
                self.driveAuthority:clear(participant.vehicle); participant.runoutActive=false
            end
            if participant.runoutActive~=true then
                local other=participant==run.a and run.b or run.a
                local ready,reason,evidence=self:_participantRunoutReady(participant,other)
                if ready then
                    participant.runoutReady=true
                    self.permissionGate:setHold(participant.vehicle,"D0146-RETURN-STAGED")
                    logInfo("RETURN_STAGING_READY commitment=%s participant=%s wholeAssemblyAligned=true transitReturnSpaceClear=true rearStation=%.2fm requiredStation=%.2fm",tostring(run.commitmentId),participant.name,tonumber(evidence and evidence.rearStationM) or -1,tonumber(evidence and evidence.otherReturnLimitM) or -1)
                else
                    local ok,startReason=self:_startRunoutChunk(run,participant)
                    if not ok then return false,startReason..":"..tostring(reason) end
                end
            end
        end
    end
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do if participant.runoutReady~=true then return false,nil end end
    return true,"ALL_RETURN_STAGING_READY"
end

function Control:_chooseReturnOrder(run)
    local list={run.a,run.b}
    table.sort(list,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
    run.returnOrder=list
    return list
end

function Control:_beginAxisReturn(run,participant,other,requiresReleasedClearance)
    local aligned,alignmentReason=self:_assemblyAxisSettled(participant)
    if not aligned then return false,"AXIS_RETURN_ALIGNMENT_REQUIRED:"..tostring(alignmentReason) end
    local pp=pose(participant.vehicle)
    if pp==nil then return false,"AXIS_RETURN_POSE_UNAVAILABLE" end
    local progress=(pp.x-participant.executionOriginX)*participant.axisForwardX+(pp.z-participant.executionOriginZ)*participant.axisForwardZ
    local tolerance=tonumber(OuttaMyWay.D0146_STEP2_TRAVERSAL_GATE_RADIUS_M) or 1.0
    local ok,reason=self.driveAuthority:setAxisTravel(participant.vehicle,participant.executionOriginX,participant.executionOriginZ,participant.axisForwardX,participant.axisForwardZ,0,run.speedKmh,false,tolerance)
    if not ok then return false,"AXIS_RETURN_ACTUATION:"..tostring(reason) end
    run.activeReturnParticipant=participant; run.waitingParticipant=other; run.returnRequiresReleasedClearance=requiresReleasedClearance==true
    self:_setPhase(run,"AXIS_RETURN",g_time or 0)
    logInfo("AXIS_RETURN_START commitment=%s participant=%s startStation=%.2fm targetStation=0.00m reverse=true steering=CAPTURED_AXIS_ONLY pointSeeking=false",tostring(run.commitmentId),participant.name,progress)
    return true,nil
end

function Control:_beginParticipantRestore(run,participant)
    self.driveAuthority:clear(participant.vehicle)
    participant.passageRestoreFoldWaitingLogged=false; participant.passageRestoreFoldSettledLogged=false; participant.passageRestoreFoldExhaustedLogged=false
    if self.configurationAuthority:getState(participant.vehicle)==nil then
        run.activeRestoreParticipant=participant
        self:_setPhase(run,"RESTORING_PARTICIPANT",g_time or 0)
        return true,"NO_CONFIGURATION_CHANGED"
    end
    local ok,state=self.configurationAuthority:requestCachedTransitRestore(participant.vehicle)
    if not ok then return false,participant.name..":"..tostring(state) end
    participant.restoreRequested=true
    run.activeRestoreParticipant=participant
    self:_setPhase(run,"RESTORING_PARTICIPANT",g_time or 0)
    logInfo("PARTICIPANT_RESTORE_START commitment=%s participant=%s cachedActuators=%d",tostring(run.commitmentId),participant.name,#(state.restoreActuatorStates or {}))
    return true,nil
end

function Control:_participantRestoreReady(participant)
    if self.configurationAuthority:getState(participant.vehicle)==nil then return true end
    local settlement=self.configurationAuthority:getCachedRestoreSettlement(participant.vehicle)
    if settlement.settled~=true then return false end
    participant.restoreSettlementExhausted=settlement.exhausted==true
    return true
end

function Control:_releaseParticipant(run,participant)
    if self.configurationAuthority:getState(participant.vehicle)~=nil then
        local ok,result=self.configurationAuthority:finishCachedTransitRestore(participant.vehicle)
        if not ok then return false,participant.name..":"..tostring(result) end
        self:_endRepresentationConfigurationAuthority(participant)
    end
    self.driveAuthority:clear(participant.vehicle); self.permissionGate:release(participant.vehicle)
    participant.wakeMethod=wakeNativeContinuation(participant.vehicle); participant.released=true; participant.releasedAt=g_time or 0
    logInfo("PARTICIPANT_WAVE_ON commitment=%s participant=%s job=%s wake=%s axisReturn=%s restorationExhausted=%s",tostring(run.commitmentId),participant.name,tostring(participant.startJobToken),tostring(participant.wakeMethod),tostring(participant.axisReturnCompleted==true),tostring(participant.restoreSettlementExhausted==true))
    return true,nil
end

function Control:_releasedParticipantClearedReturnSpace(released,waiting)
    local source=self.runtime and self.runtime.liveObservationSource or nil
    local representation=source and type(source.getTrackedRepresentation)=="function" and source:getTrackedRepresentation(released.referenceKey) or nil
    if representation==nil then return false,"RETURN_CLEARANCE_REPRESENTATION_UNAVAILABLE",nil end
    local waitingProjection=maximumEnvelopeProjectionAlongAxis(waiting.transitPassageEnvelope,waiting.axisForwardX,waiting.axisForwardZ,released.axisForwardX,released.axisForwardZ)
    if waitingProjection==nil then return false,"RETURN_CLEARANCE_WAITING_TRANSIT_ENVELOPE_UNAVAILABLE",nil end
    local waitingOriginStation=(waiting.executionOriginX-released.executionOriginX)*released.axisForwardX+(waiting.executionOriginZ-released.executionOriginZ)*released.axisForwardZ
    local requiredStation=waitingOriginStation+waitingProjection
    local rearStation=nil; local count=0
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(representation.worldPrimitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true then
            local x,z,radius=tonumber(primitive.x),tonumber(primitive.z),tonumber(primitive.radius)
            if x~=nil and z~=nil and radius~=nil and radius>0 then
                local station=(x-released.executionOriginX)*released.axisForwardX+(z-released.executionOriginZ)*released.axisForwardZ-radius
                rearStation=rearStation==nil and station or math.min(rearStation,station); count=count+1
            end
        end
    end
    if rearStation==nil then return false,"RETURN_CLEARANCE_CURRENT_PHYSICAL_PRIMITIVES_UNAVAILABLE",{physicalPrimitiveCount=count,requiredStationM=requiredStation} end
    local evidence={physicalPrimitiveCount=count,rearStationM=rearStation,requiredStationM=requiredStation,clearanceM=rearStation-requiredStation}
    if rearStation<requiredStation then return false,"RELEASED_PARTICIPANT_NOT_YET_CLEAR_OF_RETURN_SPACE",evidence end
    return true,nil,evidence
end

function Control:_completePairContext(run)
    local exhausted=run.a.restoreSettlementExhausted==true or run.b.restoreSettlementExhausted==true
    self.run=nil; self.completedCount=self.completedCount+1
    logInfo("PAIR_CONTEXT_DISSOLVED commitment=%s reason=NO_REMAINING_PASSAGE_AUTHORITY participantSpecificRelease=true",tostring(run.commitmentId))
    local evidenceKind=exhausted and "D0146_COOPERATIVE_PASSAGE_RESTORE_EXHAUSTED_AND_HANDED_BACK" or "D0146_COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK"
    self:_notify({status="SUCCEEDED",commitmentId=run.commitmentId,requestIds={run.a.request.identity,run.b.request.identity},boundedAuthorityIds={run.a.request.boundedAuthorityId,run.b.request.boundedAuthorityId},assemblyIds={run.a.assemblyId,run.b.assemblyId},evidence={kind=evidenceKind,passageGuideId=run.guide and run.guide.identity or nil,sameJobs=true,bothRestored=not exhausted,restorationExhausted=exhausted,participantSpecificRelease=true,completedAt=g_time or 0}})
end

function Control:_beginD0146Configuration(run)
    local owned={}
    local requested=0
    local ignored=0
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
        if participant.configurationMode~="TRANSIT_REQUIRED" then
            for _,rollback in OuttaMyWay.ValueRecord.ipairs(owned) do self.configurationAuthority:requestCachedTransitRestore(rollback.vehicle) end
            return false,participant.name..":unsupported-configuration-mode:"..tostring(participant.configurationMode)
        end
        participant.passageTransitFoldWaitingLogged=false
        participant.passageTransitFoldSettledLogged=false
        participant.passageTransitFoldExhaustedLogged=false
        participant.passageTransitFoldExpected=false
        local capability=nil
        local cache=self.runtime and self.runtime.assemblyRepresentationCache or nil
        if cache~=nil and type(cache.getTransitFoldCapability)=="function" then capability=cache:getTransitFoldCapability(participant.referenceKey,participant.startJobToken) end
        participant.passageTransitFoldExpected=type(capability)=="table" and capability.isFoldable==true
        logInfo("TRANSIT_CAPABILITY_CACHE commitment=%s participant=%s available=%s isFoldable=%s actuators=%d expectedDurationMs=%.0f timeoutMs=%.0f source=%s",
            tostring(run.commitmentId),participant.name,tostring(type(capability)=="table"),tostring(participant.passageTransitFoldExpected),type(capability)=="table" and tonumber(capability.actuatorCount) or 0,type(capability)=="table" and tonumber(capability.expectedFoldDurationMs) or 0,type(capability)=="table" and tonumber(capability.settlementTimeoutMs) or 0,type(capability)=="table" and tostring(capability.source) or "UNAVAILABLE")
        local ok,state
        if participant.passageTransitFoldExpected then ok,state=self.configurationAuthority:prepareCachedTransit(participant.vehicle,capability) else ok,state=false,"bootstrap-non-foldable" end
        if ok then
            self:_beginRepresentationConfigurationAuthority(participant)
            participant.passageTransitCompactionActive=true
            participant.passageTransitCompactionReason=nil
            owned[#owned+1]=participant
            requested=requested+1
        else
            participant.passageTransitCompactionActive=false
            participant.passageTransitCompactionReason=tostring(state)
            ignored=ignored+1
            logInfo("TRANSIT_REQUEST_IGNORED commitment=%s participant=%s plannedMode=%s reason=%s cachedFoldable=%s configurationVeto=false",
                tostring(run.commitmentId),participant.name,tostring(participant.configurationMode),tostring(state),tostring(participant.passageTransitFoldExpected==true))
        end
    end
    if requested==0 then
        if self:_d0146ConfigurationReady(run) then
            logInfo("CONFIGURATION_READY commitment=%s policy=ALWAYS_ATTEMPT_TRANSIT modes=%s changed=0 ignored=%d next=CAPTURE_EXECUTION_ORIGIN guideGeometryUnchanged=true",tostring(run.commitmentId),configurationModeText(run),ignored)
            local rebased,rebaseReason=self:_rebaseD0146Guide(run)
            if not rebased then return false,rebaseReason end
            return self:_startGuideGate(run,1)
        end
        self:_setPhase(run,"CONFIGURING",g_time or 0)
        logInfo("CONFIGURATION_START commitment=%s policy=ALWAYS_ATTEMPT_TRANSIT modes=%s changed=0 ignored=%d movementWaitsForTransitRealisation=true guideGeometryUnchanged=true",tostring(run.commitmentId),configurationModeText(run),ignored)
        return true
    end
    self:_setPhase(run,"CONFIGURING",g_time or 0)
    logInfo("CONFIGURATION_START commitment=%s policy=ALWAYS_ATTEMPT_TRANSIT modes=%s changed=%d ignored=%d movementWaitsForTransitRealisation=true guideGeometryUnchanged=true",tostring(run.commitmentId),configurationModeText(run),requested,ignored)
    return true
end

function Control:_d0146ConfigurationReady(run)
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
        if participant.configurationMode~="TRANSIT_REQUIRED" then return false end
        -- D-0179 + D-0181: only Job-Episode cached Transit actuator settlement
        -- owns configuration waiting on the single production Passage path.
        if participant.passageTransitFoldExpected==true and participant.passageTransitCompactionActive==true then
            local settlement=self.configurationAuthority:getCachedTransitSettlement(participant.vehicle)
            if settlement.settled~=true then
                if participant.passageTransitFoldWaitingLogged~=true then
                    participant.passageTransitFoldWaitingLogged=true
                    logInfo("TRANSIT_FOLD_WAIT commitment=%s participant=%s settled=%d/%d elapsedMs=%.0f timeoutMs=%.0f",tostring(run.commitmentId),participant.name,tonumber(settlement.settledCount) or 0,tonumber(settlement.actuatorCount) or 0,tonumber(settlement.elapsedMs) or 0,tonumber(settlement.timeoutMs) or 0)
                end
                return false
            end
            if settlement.exhausted==true then
                if participant.passageTransitFoldExhaustedLogged~=true then
                    participant.passageTransitFoldExhaustedLogged=true
                    logWarning("TRANSIT_FOLD_SETTLEMENT_EXHAUSTED commitment=%s participant=%s settled=%d/%d elapsedMs=%.0f timeoutMs=%.0f action=REMOVE_CONFIGURATION_VETO compactionAsserted=false",tostring(run.commitmentId),participant.name,tonumber(settlement.settledCount) or 0,tonumber(settlement.actuatorCount) or 0,tonumber(settlement.elapsedMs) or 0,tonumber(settlement.timeoutMs) or 0)
                end
            elseif participant.passageTransitFoldSettledLogged~=true then
                participant.passageTransitFoldSettledLogged=true
                logInfo("TRANSIT_FOLD_SETTLED commitment=%s participant=%s settled=%d/%d elapsedMs=%.0f timeoutMs=%.0f",tostring(run.commitmentId),participant.name,tonumber(settlement.settledCount) or 0,tonumber(settlement.actuatorCount) or 0,tonumber(settlement.elapsedMs) or 0,tonumber(settlement.timeoutMs) or 0)
            end
        end
    end
    return true
end

function Control:_beginD0146Restore(run)
    self:_stopLeg(run)
    local owned=0
    local restoreActuators=0
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
        participant.passageRestoreFoldWaitingLogged=false
        participant.passageRestoreFoldSettledLogged=false
        participant.passageRestoreFoldExhaustedLogged=false
        if self.configurationAuthority:getState(participant.vehicle)~=nil then
            local ok,state=self.configurationAuthority:requestCachedTransitRestore(participant.vehicle)
            if not ok then return false,participant.name..":"..tostring(state) end
            owned=owned+1
            restoreActuators=restoreActuators+#(state.restoreActuatorStates or {})
            logInfo("RESTORE_CAPABILITY commitment=%s participant=%s cachedOnly=true physicallyChangedActuators=%d genericFoldDiscovery=false",
                tostring(run.commitmentId),participant.name,#(state.restoreActuatorStates or {}))
        end
    end
    if owned==0 then
        logInfo("RESTORE_SKIPPED commitment=%s reason=NO_CONFIGURATION_CHANGED modes=%s",tostring(run.commitmentId),configurationModeText(run))
        self:_complete(run)
        return true,"COMPLETED_WITHOUT_CONFIGURATION_RESTORE"
    end
    self:_setPhase(run,"RESTORING",g_time or 0)
    logInfo("RESTORE_START commitment=%s selective=true ownedParticipants=%d cachedActuators=%d restoreOnlyPhysicalTransitChanges=true modes=%s",tostring(run.commitmentId),owned,restoreActuators,configurationModeText(run))
    return true
end

function Control:_d0146RestoreReady(run)
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
        if self.configurationAuthority:getState(participant.vehicle)~=nil then
            local settlement=self.configurationAuthority:getCachedRestoreSettlement(participant.vehicle)
            if settlement.settled~=true then
                if participant.passageRestoreFoldWaitingLogged~=true then
                    participant.passageRestoreFoldWaitingLogged=true
                    logInfo("RESTORE_FOLD_WAIT commitment=%s participant=%s settled=%d/%d elapsedMs=%.0f timeoutMs=%.0f",tostring(run.commitmentId),participant.name,tonumber(settlement.settledCount) or 0,tonumber(settlement.actuatorCount) or 0,tonumber(settlement.elapsedMs) or 0,tonumber(settlement.timeoutMs) or 0)
                end
                return false
            end
            if settlement.exhausted==true then
                if participant.passageRestoreFoldExhaustedLogged~=true then
                    participant.passageRestoreFoldExhaustedLogged=true
                    logWarning("RESTORE_FOLD_SETTLEMENT_EXHAUSTED commitment=%s participant=%s settled=%d/%d elapsedMs=%.0f timeoutMs=%.0f action=REMOVE_RESTORATION_VETO restoredAsserted=false",tostring(run.commitmentId),participant.name,tonumber(settlement.settledCount) or 0,tonumber(settlement.actuatorCount) or 0,tonumber(settlement.elapsedMs) or 0,tonumber(settlement.timeoutMs) or 0)
                end
            elseif participant.passageRestoreFoldSettledLogged~=true then
                participant.passageRestoreFoldSettledLogged=true
                logInfo("RESTORE_FOLD_SETTLED commitment=%s participant=%s settled=%d/%d elapsedMs=%.0f timeoutMs=%.0f",tostring(run.commitmentId),participant.name,tonumber(settlement.settledCount) or 0,tonumber(settlement.actuatorCount) or 0,tonumber(settlement.elapsedMs) or 0,tonumber(settlement.timeoutMs) or 0)
            end
        end
    end
    return true
end

function Control:_finishD0146Restore(run)
    local exhausted=false
    for _,participant in OuttaMyWay.ValueRecord.ipairs(run.participants or {}) do
        if self.configurationAuthority:getState(participant.vehicle)~=nil then
            local settlement=self.configurationAuthority:getCachedRestoreSettlement(participant.vehicle)
            exhausted=exhausted or settlement.exhausted==true
            local ok,result=self.configurationAuthority:finishCachedTransitRestore(participant.vehicle)
            if not ok then return false,participant.name..":"..tostring(result) end
            self:_endRepresentationConfigurationAuthority(participant)
        end
    end
    run.restorationExhausted=exhausted
    self:_complete(run)
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
    local evidenceKind=run.restorationExhausted==true and "D0146_COOPERATIVE_PASSAGE_RESTORE_EXHAUSTED_AND_HANDED_BACK" or "D0146_COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK"
    self:_notify({status="SUCCEEDED",commitmentId=run.commitmentId,requestIds={run.a.request.identity,run.b.request.identity},boundedAuthorityIds={run.a.request.boundedAuthorityId,run.b.request.boundedAuthorityId},assemblyIds={run.a.assemblyId,run.b.assemblyId},evidence={kind=evidenceKind,passageGuideId=run.guide and run.guide.identity or nil,sameJobs=true,bothRestored=run.restorationExhausted~=true,restorationExhausted=run.restorationExhausted==true,cooldown=false,completedAt=g_time or 0}})
end

function Control:_failHeld(reason)
    local run=self.run
    if run==nil or run.failureReason~=nil then return end
    self:_stopLeg(run)
    self.permissionGate:setHold(run.a.vehicle,"COOPERATIVE-PASSAGE-FAIL-HELD")
    self.permissionGate:setHold(run.b.vehicle,"COOPERATIVE-PASSAGE-FAIL-HELD")
    run.failureReason=tostring(reason or "UNRESOLVED")

    -- D-0146 failure is still an unresolved spatial situation. Preserve the
    -- current (possibly compact) configuration rather than enlarging an assembly
    -- inside that unresolved conflict.
    self:_setPhase(run,"FAILED_HELD",g_time or 0)
    self.failedCount=self.failedCount+1
    logWarning("PASSAGE_REASSESSMENT commitment=%s guide=%s cause=%s outcome=SAFE_ABANDON_ESCALATE controlBroadening=false bothHeld=true configurationPreserved=true",tostring(run.commitmentId),tostring(run.guide and run.guide.identity),run.failureReason)
    logWarning("HALT commitment=%s reason=%s phase=%s bothHeld=true noBlindRelease=true configurationPreserved=true action=PLAYER_INTERVENTION_OR_JOB_CHANGE",tostring(run.commitmentId),run.failureReason,run.phase)
end

function Control:_abandonAfterJobChange(run,changed)
    for _,p in OuttaMyWay.ValueRecord.ipairs(run.participants) do self.driveAuthority:clear(p.vehicle); self.permissionGate:release(p.vehicle); self.configurationAuthority:clear(p.vehicle); self:_endRepresentationConfigurationAuthority(p) end
    self.run=nil
    logWarning("ABORT commitment=%s reason=JOB_EPISODE_CHANGED participant=%s physicalAuthorityCleared=true",tostring(run.commitmentId),changed and changed.name or "unknown")
    self:_notify({status="FAILED",commitmentId=run.commitmentId,requestIds={run.a.request.identity,run.b.request.identity},boundedAuthorityIds={run.a.request.boundedAuthorityId,run.b.request.boundedAuthorityId},assemblyIds={run.a.assemblyId,run.b.assemblyId},evidence={kind="COOPERATIVE_PASSAGE_JOB_EPISODE_CHANGED",participant=changed and changed.name or nil}})
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
        participant.transitPassageEnvelope=planned.transitPassageEnvelope
        if participant.configurationMode~="TRANSIT_REQUIRED" then return false,"D0146_PASSAGE_CONFIGURATION_MODE_INVALID:"..tostring(participant.configurationMode) end
        if type(participant.transitPassageEnvelope)~="table" then return false,"D0146_TRANSIT_PASSAGE_ENVELOPE_MISSING:"..participant.name end
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
    logInfo("START architecture=D0146_STEP2 commitment=%s candidate=%s conflict=%s A=%s job=%s B=%s job=%s separation=%.2fm entryBoundary=%.2fm headingDot=%.4f envelopeBasis=%s crossingBasis=%s arrangement=%s offsets=%+.2f/%+.2f deficit=%.2fm contact=%.2fm nominal=%.2fm required=%.2fm currentLateral=%.2fm reserve=%+.2fm guide=%s gates=%d development=%.2fm crossingForward=%.2fm recovery=%.2fm sequence=PASSAGE_APPROACH_THEN_HOLD_ALWAYS_ATTEMPT_TRANSIT_CAPTURE_EXECUTION_ORIGIN_PASSAGE_EXCURSION_SELECTIVE_RESTORE_HANDOFF configuration=%s controlInventsGeometry=false vehicleNameGate=false thirdPartyConstraints=%d generalVehicleAuthority=false",
        tostring(run.commitmentId),tostring(run.candidateId),tostring(bridge.conflictIdentity),a.name,tostring(a.startJobToken),b.name,tostring(b.startJobToken),run.initialSeparationM,tonumber(entry.boundarySeparationM) or -1,run.headingDot,
        tostring(arrangement.directionalPassageEnvelopeBasis or "DISC_FALLBACK"),tostring(excursion.crossingWindowBasis or "n/a"),tostring(arrangement.identity),tonumber(arrangement.subjectLateralOffsetM) or 0,tonumber(arrangement.otherLateralOffsetM) or 0,tonumber(excursion.clearanceDeficitM) or 0,
        tonumber(arrangement.physicalContactThresholdM) or 0,tonumber(arrangement.nominalInterAssemblyClearanceM) or 0,tonumber(arrangement.policyRequiredSeparationM) or 0,tonumber(arrangement.currentLateralSeparationM) or 0,tonumber(arrangement.currentPolicyReserveM) or 0,
        tostring(run.guide and run.guide.identity),OuttaMyWay.ValueRecord.length(run.guide and run.guide.gates or {}),tonumber(excursion.developmentDistanceM) or 0,tonumber(excursion.crossingWindowForwardPerParticipantM) or 0,tonumber(excursion.recoveryDistanceM) or 0,configurationModeText(run),OuttaMyWay.ValueRecord.length(run.thirdPartyConstraints or {}))
    return true,"D0146_COOPERATIVE_PASSAGE_STARTED"
end

function Control:executeJointRequests(requestA,requestB,candidate)
    local bridge=candidate and candidate.evidenceBasis and candidate.evidenceBasis.cooperativePassageBridge or nil
    if type(bridge)~="table" or bridge.architecture~="D0146_STEP2" then return false,"D0146_COOPERATIVE_PASSAGE_BRIDGE_REQUIRED" end
    return self:_executeD0146JointRequests(requestA,requestB,candidate,bridge)
end

function Control:update(dt)
    local run=self.run
    if run==nil then return end
    if run.mode~="D0146_GUIDE" then self:_failHeld("NON_D0146_RUNTIME_MODE_REJECTED"); return end
    local boundedAuthority=self.runtime and self.runtime.boundedAuthority or nil
    if boundedAuthority~=nil and run.a.request~=nil and run.b.request~=nil
        and (boundedAuthority:isCurrent(run.a.request.boundedAuthorityId)~=true or boundedAuthority:isCurrent(run.b.request.boundedAuthorityId)~=true) then self:_failHeld("BOUNDED_AUTHORITY_LOST"); return end
    if OuttaMyWay.D0146_STEP2_COOPERATIVE_PASSAGE_ENABLED~=true then self:_failHeld("D0146_STEP2_DISABLED_DURING_ACTIVE_COMMITMENT"); return end
    local nowMs=g_time or 0
    local sameJob,changed=self:_allSameJob(run)
    if not sameJob then self:_abandonAfterJobChange(run,changed); return end
    local thirdOk,thirdReason=self:_thirdPartySupport(run,nil)
    if not thirdOk then self:_failHeld(thirdReason); return end

    local timeout=OuttaMyWay.D0146_STEP2_PHASE_WATCHDOG_MS or 45000
    if run.failureReason==nil and nowMs-(run.phaseStartedAt or nowMs)>=timeout then
        if run.phase=="WAIT_NATIVE_CLEARANCE" and run.waitingParticipant~=nil then
            local waiting=run.waitingParticipant; waiting.axisReturnSkipped=true
            logWarning("RETURN_CLEARANCE_EXHAUSTED commitment=%s waiting=%s action=SKIP_AXIS_RETURN_AND_RESTORE",tostring(run.commitmentId),waiting.name)
            local ok,reason=self:_beginParticipantRestore(run,waiting); if not ok then self:_failHeld("PARTICIPANT_RESTORE_START:"..tostring(reason)) end
        else
            self:_failHeld("PHASE_WATCHDOG:"..tostring(run.phase)); return
        end
    end

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
            local ok,reason=self:_beginD0146Configuration(run); if not ok then self:_failHeld("CONFIGURATION_START:"..tostring(reason)) end
        end
    elseif run.phase=="CONFIGURING" then
        if self:_d0146ConfigurationReady(run) then
            logInfo("CONFIGURATION_CONFIRMED commitment=%s modes=%s next=CAPTURE_EXECUTION_ORIGIN",tostring(run.commitmentId),configurationModeText(run))
            local rebased,rebaseReason=self:_rebaseD0146Guide(run)
            if not rebased then self:_failHeld(tostring(rebaseReason)); return end
            local ok,reason=self:_startGuideGate(run,1)
            if not ok then self:_failHeld(tostring(reason)) end
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
                logInfo("D0146_PASSAGE_GUIDE_COMPLETE commitment=%s guide=%s next=RECOVERY_ALIGNMENT_THEN_AXIS_RETURN secondWhistle=false",tostring(run.commitmentId),tostring(run.guide and run.guide.identity))
                local ok,reason=self:_beginAlignmentRunout(run); if not ok then self:_failHeld("ALIGNMENT_RUNOUT_START:"..tostring(reason)) end
            else
                local ok,reason=self:_startGuideGate(run,completedIndex+1); if not ok then self:_failHeld(tostring(reason)) end
            end
        end
    elseif run.phase=="ALIGNMENT_RUNOUT" then
        local ready,runoutReason=self:_updateAlignmentRunout(run)
        if not ready and runoutReason~=nil then self:_failHeld(runoutReason); return end
        if ready then
            local order=self:_chooseReturnOrder(run); local first,second=order[1],order[2]
            local ok,reason=self:_beginAxisReturn(run,first,second,false)
            if not ok then
                first.axisReturnSkipped=true
                logWarning("AXIS_RETURN_SKIPPED commitment=%s participant=%s reason=%s fallback=RESTORE_AND_HAND_BACK",tostring(run.commitmentId),first.name,tostring(reason))
                local restoreOk,restoreReason=self:_beginParticipantRestore(run,first); if not restoreOk then self:_failHeld("PARTICIPANT_RESTORE_START:"..tostring(restoreReason)) end
            end
        end
    elseif run.phase=="AXIS_RETURN" then
        local participant=run.activeReturnParticipant
        if participant==nil then self:_failHeld("AXIS_RETURN_PARTICIPANT_UNAVAILABLE"); return end
        if run.returnRequiresReleasedClearance==true and run.releasedLeader~=nil then
            local clear,clearReason,evidence=self:_releasedParticipantClearedReturnSpace(run.releasedLeader,participant)
            if not clear then
                self.driveAuthority:clear(participant.vehicle); participant.axisReturnSkipped=true
                logWarning("AXIS_RETURN_CLEARANCE_LOST commitment=%s participant=%s released=%s reason=%s fallback=RESTORE_AND_HAND_BACK",tostring(run.commitmentId),participant.name,run.releasedLeader.name,tostring(clearReason))
                local ok,reason=self:_beginParticipantRestore(run,participant); if not ok then self:_failHeld("PARTICIPANT_RESTORE_START:"..tostring(reason)) end
                return
            end
        end
        if targetReached(self.driveAuthority,participant.vehicle) then
            self.driveAuthority:clear(participant.vehicle); participant.axisReturnCompleted=true
            logInfo("AXIS_RETURN_COMPLETE commitment=%s participant=%s executionOriginStation=true",tostring(run.commitmentId),participant.name)
            local ok,reason=self:_beginParticipantRestore(run,participant); if not ok then self:_failHeld("PARTICIPANT_RESTORE_START:"..tostring(reason)) end
        else
            local aligned,alignmentReason=self:_assemblyAxisSettled(participant)
            if not aligned then
                self.driveAuthority:clear(participant.vehicle); participant.axisReturnSkipped=true
                logWarning("AXIS_RETURN_ALIGNMENT_LOST commitment=%s participant=%s reason=%s fallback=RESTORE_AND_HAND_BACK",tostring(run.commitmentId),participant.name,tostring(alignmentReason))
                local ok,reason=self:_beginParticipantRestore(run,participant); if not ok then self:_failHeld("PARTICIPANT_RESTORE_START:"..tostring(reason)) end
            end
        end
    elseif run.phase=="RESTORING_PARTICIPANT" then
        local participant=run.activeRestoreParticipant
        if participant==nil then self:_failHeld("RESTORE_PARTICIPANT_UNAVAILABLE"); return end
        if self:_participantRestoreReady(participant) then
            local ok,reason=self:_releaseParticipant(run,participant); if not ok then self:_failHeld("PARTICIPANT_RELEASE:"..tostring(reason)); return end
            if run.a.released==true and run.b.released==true then self:_completePairContext(run); return end
            local waiting=run.a.released==true and run.b or run.a
            run.releasedLeader=participant; run.waitingParticipant=waiting; run.activeRestoreParticipant=nil; run.activeReturnParticipant=nil; run.returnRequiresReleasedClearance=false
            self:_setPhase(run,"WAIT_NATIVE_CLEARANCE",g_time or 0)
            logInfo("RETURN_CLEARANCE_WAIT commitment=%s released=%s waiting=%s positiveCurrentOccupancyRequired=true",tostring(run.commitmentId),participant.name,waiting.name)
        end
    elseif run.phase=="WAIT_NATIVE_CLEARANCE" then
        local released,waiting=run.releasedLeader,run.waitingParticipant
        if released==nil or waiting==nil then self:_failHeld("RETURN_CLEARANCE_CONTEXT_UNAVAILABLE"); return end
        local clear,clearReason,evidence=self:_releasedParticipantClearedReturnSpace(released,waiting)
        if clear then
            logInfo("RETURN_CLEARANCE commitment=%s released=%s waiting=%s rearStation=%.2fm requiredStation=%.2fm clearance=%.2fm authority=POSITIVE_CURRENT_PHYSICAL_OCCUPANCY",tostring(run.commitmentId),released.name,waiting.name,tonumber(evidence and evidence.rearStationM) or -1,tonumber(evidence and evidence.requiredStationM) or -1,tonumber(evidence and evidence.clearanceM) or -1)
            local ok,reason=self:_beginAxisReturn(run,waiting,released,true)
            if not ok then
                waiting.axisReturnSkipped=true
                logWarning("AXIS_RETURN_SKIPPED commitment=%s participant=%s reason=%s fallback=RESTORE_AND_HAND_BACK",tostring(run.commitmentId),waiting.name,tostring(reason))
                local restoreOk,restoreReason=self:_beginParticipantRestore(run,waiting); if not restoreOk then self:_failHeld("PARTICIPANT_RESTORE_START:"..tostring(restoreReason)) end
            end
        elseif nowMs>=(run.nextReturnClearDiagnosticMs or 0) then
            run.nextReturnClearDiagnosticMs=nowMs+(OuttaMyWay.D0146_COOPERATIVE_PASSAGE_HEARTBEAT_MS or 1000)
            logInfo("RETURN_CLEARANCE_WAIT_DETAIL commitment=%s released=%s waiting=%s reason=%s rearStation=%s requiredStation=%s",tostring(run.commitmentId),released.name,waiting.name,tostring(clearReason),evidence and evidence.rearStationM and string.format("%.2f",evidence.rearStationM) or "n/a",evidence and evidence.requiredStationM and string.format("%.2f",evidence.requiredStationM) or "n/a")
        end
    elseif run.phase=="RESTORING" then
        if self:_d0146RestoreReady(run) then
            local ok,reason=self:_finishD0146Restore(run); if not ok then self:_failHeld("RESTORE_FINISH:"..tostring(reason)) end
        end
    end

    if self.run~=nil and nowMs>=(self.nextHeartbeatMs or 0) then
        self.nextHeartbeatMs=nowMs+(OuttaMyWay.D0146_COOPERATIVE_PASSAGE_HEARTBEAT_MS or 1000)
        local pa,pb=pose(run.a.vehicle),pose(run.b.vehicle)
        logInfo("STATE commitment=%s phase=%s A=%s speed=%.2f B=%s speed=%.2f separation=%s failure=%s",
            tostring(run.commitmentId),tostring(run.phase),run.a.name,actualSpeedKmh(run.a.vehicle),run.b.name,actualSpeedKmh(run.b.vehicle),
            pa and pb and string.format("%.2fm",distance(pa.x,pa.z,pb.x,pb.z)) or "n/a",tostring(run.failureReason or "none"))
    end
end
