-- FS25_OuttaMyWay v4.7.99 CANONICAL CANDIDATE — existing bounded D-0143 TS015 Cooperative Passage Control preserved under D-0146 architecture.
--
-- Central-Control implementation of the mechanically proven P23 sequence for
-- the first narrow Condor/Patriot production slice.  Situation/Candidate/
-- Decision/Commitment have already established meaning before this module is
-- invoked.  This module only executes the bounded physical sequence and
-- reports completion.  It performs no King/Refuge search and owns no post-
-- handoff observation window.

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
        for _,attempt in ipairs(attempts) do
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
    logInfo("LOAD enabled=%s scope=TS015_CONDOR_PATRIOT_NEAR_COLLINEAR driveHook=%s reason=%s king=false refuge=false cooldown=false",
        tostring(OuttaMyWay.COOPERATIVE_PASSAGE_TS015_ENABLED==true),tostring(ok),tostring(reason or "ready"))
end

function Control:deleteMap()
    local run=self.run
    if run~=nil then
        for _,p in ipairs(run.participants or {}) do
            self.driveAuthority:clear(p.vehicle); self.permissionGate:release(p.vehicle)
            if self.configurationAuthority:getState(p.vehicle)~=nil then self.configurationAuthority:clear(p.vehicle) end
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
    for _,vehicle in ipairs(activeVehicles()) do if referenceKey(vehicle)==reference then return vehicle end end
    return nil
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
    for _,p in ipairs(run.participants) do if currentJobToken(p.vehicle)~=p.startJobToken then return false,p end end
    return true,nil
end
function Control:_allStopped(run)
    local limit=OuttaMyWay.COOPERATIVE_PASSAGE_HOLD_EFFECT_SPEED_KMH or 0.25
    for _,p in ipairs(run.participants) do
        if self.permissionGate:getCallCount(p.vehicle)<=0 or actualSpeedKmh(p.vehicle)>limit then return false end
    end
    return true
end
function Control:_allFolded(run)
    for _,p in ipairs(run.participants) do if self.configurationAuthority:getEvidence(p.vehicle).allFolded~=true then return false end end
    return true
end
function Control:_allDeployed(run)
    for _,p in ipairs(run.participants) do if self.configurationAuthority:getEvidence(p.vehicle).allDeployed~=true then return false end end
    return true
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
    for _,leg in ipairs(checks) do
        for _,p in ipairs(run.participants) do
            local x,z=self:_targetFor(run,p,leg.forward,leg.lateral)
            local ok,field=fieldResolvedAt(x,z)
            if not ok then return false,string.format("%s_%s_%s",leg.phase,p.name,tostring(field)) end
        end
    end
    return true,nil
end

function Control:_startLeg(run,phase,forwardM,lateralM,radiusM)
    for _,p in ipairs(run.participants) do
        local x,z=self:_targetFor(run,p,forwardM,lateralM)
        p.targetX,p.targetZ,p.targetRadiusM=x,z,radiusM
        local ok,reason=self.driveAuthority:setReposition(p.vehicle,x,z,run.speedKmh,radiusM)
        if not ok then
            for _,rollback in ipairs(run.participants) do self.driveAuthority:clear(rollback.vehicle) end
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

function Control:_beginCompact(run)
    local okA,stateA=self.configurationAuthority:prepareCompact(run.a.vehicle)
    if not okA then return false,run.a.name..":"..tostring(stateA) end
    local okB,stateB=self.configurationAuthority:prepareCompact(run.b.vehicle)
    if not okB then self.configurationAuthority:requestRestore(run.a.vehicle); return false,run.b.name..":"..tostring(stateB) end
    self:_setPhase(run,"COMPACTING",g_time or 0)
    logInfo("COMPACT_START commitment=%s A=%s %s B=%s %s movementWaitsForFullFold=true",tostring(run.commitmentId),run.a.name,foldText(self.configurationAuthority:getEvidence(run.a.vehicle)),run.b.name,foldText(self.configurationAuthority:getEvidence(run.b.vehicle)))
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
    for _,p in ipairs(run.participants) do
        self.driveAuthority:clear(p.vehicle)
        self.permissionGate:release(p.vehicle)
        p.wakeMethod=wakeNativeContinuation(p.vehicle)
    end
    local pa,pb=pose(run.a.vehicle),pose(run.b.vehicle)
    logInfo("HANDOFF commitment=%s A=%s job=%s wake=%s B=%s job=%s wake=%s separation=%s sameJobs=true authorityRelease=IMMEDIATE cooldown=false",
        tostring(run.commitmentId),run.a.name,tostring(run.a.startJobToken),tostring(run.a.wakeMethod),run.b.name,tostring(run.b.startJobToken),tostring(run.b.wakeMethod),
        pa and pb and string.format("%.2fm",distance(pa.x,pa.z,pb.x,pb.z)) or "n/a")
    self.run=nil; self.completedCount=self.completedCount+1
    self:_notify({status="SUCCEEDED",commitmentId=run.commitmentId,requestIds={run.a.request.identity,run.b.request.identity},assemblyIds={run.a.assemblyId,run.b.assemblyId},evidence={kind="D0143_COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK",sameJobs=true,bothRestored=true,cooldown=false,completedAt=g_time or 0}})
end

function Control:_failHeld(reason)
    local run=self.run
    if run==nil or run.failureReason~=nil then return end
    self:_stopLeg(run)
    self.permissionGate:setHold(run.a.vehicle,"COOPERATIVE-PASSAGE-FAIL-HELD")
    self.permissionGate:setHold(run.b.vehicle,"COOPERATIVE-PASSAGE-FAIL-HELD")
    run.failureReason=tostring(reason or "UNRESOLVED")
    local requested=false
    for _,p in ipairs(run.participants) do
        if self.configurationAuthority:getState(p.vehicle)~=nil then
            local ok,restoreReason=self.configurationAuthority:requestRestore(p.vehicle)
            if ok then requested=true else logWarning("FAIL_RESTORE_REQUEST participant=%s detail=%s",p.name,tostring(restoreReason)) end
        end
    end
    self:_setPhase(run,requested and "FAILED_RESTORING" or "FAILED_HELD",g_time or 0)
    self.failedCount=self.failedCount+1
    logWarning("HALT commitment=%s reason=%s phase=%s bothHeld=true noBlindRelease=true action=PLAYER_INTERVENTION_OR_JOB_CHANGE",tostring(run.commitmentId),run.failureReason,run.phase)
end

function Control:_abandonAfterJobChange(run,changed)
    for _,p in ipairs(run.participants) do self.driveAuthority:clear(p.vehicle); self.permissionGate:release(p.vehicle); self.configurationAuthority:clear(p.vehicle) end
    self.run=nil
    logWarning("ABORT commitment=%s reason=JOB_EPISODE_CHANGED participant=%s physicalAuthorityCleared=true",tostring(run.commitmentId),changed and changed.name or "unknown")
    self:_notify({status="FAILED",commitmentId=run.commitmentId,requestIds={run.a.request.identity,run.b.request.identity},assemblyIds={run.a.assemblyId,run.b.assemblyId},evidence={kind="COOPERATIVE_PASSAGE_JOB_EPISODE_CHANGED",participant=changed and changed.name or nil}})
end

function Control:executeJointRequests(requestA,requestB,candidate)
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
    if OuttaMyWay.COOPERATIVE_PASSAGE_TS015_ENABLED~=true then return end
    local run=self.run
    if run==nil then return end
    local nowMs=g_time or 0
    local sameJob,changed=self:_allSameJob(run)
    if not sameJob then self:_abandonAfterJobChange(run,changed); return end

    local timeout=OuttaMyWay.COOPERATIVE_PASSAGE_PHASE_WATCHDOG_MS or 45000
    if run.failureReason==nil and nowMs-(run.phaseStartedAt or nowMs)>=timeout then self:_failHeld("PHASE_WATCHDOG:"..tostring(run.phase)); return end

    if run.phase=="SETTLING" then
        if self:_allStopped(run) then local ok,reason=self:_beginCompact(run); if not ok then self:_failHeld("COMPACT_START:"..tostring(reason)) end end
    elseif run.phase=="COMPACTING" then
        if self:_allFolded(run) then
            logInfo("COMPACT_CONFIRMED commitment=%s A=%s %s B=%s %s",tostring(run.commitmentId),run.a.name,foldText(self.configurationAuthority:getEvidence(run.a.vehicle)),run.b.name,foldText(self.configurationAuthority:getEvidence(run.b.vehicle)))
            local ok,reason=self:_startLeg(run,"SIDESTEPPING",run.sidestepForwardM,run.lateralM,run.sidestepRadiusM)
            if not ok then self:_failHeld("SIDESTEP_START:"..tostring(reason)) end
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
        if self:_allDeployed(run) then
            local okA,reasonA=self.configurationAuthority:finishRestore(run.a.vehicle)
            local okB,reasonB=self.configurationAuthority:finishRestore(run.b.vehicle)
            if not okA or not okB then self:_failHeld("RESTORE_FINISH:A="..tostring(reasonA)..":B="..tostring(reasonB)) else self:_complete(run) end
        end
    elseif run.phase=="FAILED_RESTORING" then
        if self:_allDeployed(run) then
            for _,p in ipairs(run.participants) do if self.configurationAuthority:getState(p.vehicle)~=nil then self.configurationAuthority:finishRestore(p.vehicle) end end
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
