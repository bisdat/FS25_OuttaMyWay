-- D-0147 Terminal Occupancy knowledge.
-- Situation owns only the positive obstruction relationship between a genuinely
-- completed Job Episode and continuing active Field World demand. It does not
-- choose an egress direction or command any vehicle.

OuttaMyWay.TerminalOccupancyAssessment={}
local Assessment=OuttaMyWay.TerminalOccupancyAssessment
Assessment.__index=Assessment

local function logInfo(fmt,...)
    local msg=string.format(fmt,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][D0147] %s",msg) else print("[FS25_OuttaMyWay][D0147] "..msg) end
end
local function copy(value,seen)
    if type(value)~="table" then return value end
    seen=seen or {}; if seen[value] then return nil end; seen[value]=true
    local result={}; for key,item in OuttaMyWay.ValueRecord.pairs(value) do result[key]=copy(item,seen) end
    seen[value]=nil; return result
end
local function finite(v) return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge end
local function physicalByAssembly(values)
    local result={}; for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do result[item.assemblyId]=item end; return result
end
local function futureByAssembly(values)
    local result={}; for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do result[item.assemblyId]=item end; return result
end
local function currentByAssembly(values)
    local result={}; for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do result[item.assemblyId]=item end; return result
end
local function referenceByAssembly(snapshot)
    local result={}; for _,item in OuttaMyWay.ValueRecord.ipairs(snapshot.assemblies or {}) do result[item.assemblyId]=item.referenceKey end; return result
end
local function motionByReference(snapshot)
    local result={}
    local motion=snapshot and snapshot.motion and snapshot.motion.progressionEvidence or {}
    for _,item in OuttaMyWay.ValueRecord.ipairs(motion) do
        if type(item.assemblyReferenceKey)=="string" then result[item.assemblyReferenceKey]=item end
    end
    return result
end
local function aiStateByReference(snapshot)
    local result={}
    for referenceKey,item in OuttaMyWay.ValueRecord.pairs(snapshot and snapshot.aiStates or {}) do result[referenceKey]=item end
    return result
end
local function positivePhysicalProgress(motion,aiState)
    if type(motion)~="table" or type(aiState)~="table" or aiState.observedActive~=true or aiState.blocked==true then return false end
    local class=motion.motionClassification
    return class=="STABLE_FORWARD" or class=="TURNING" or class=="REVERSING_OR_OPPOSED_TRAVEL"
end
local function pointSegmentDistance(px,pz,ax,az,bx,bz)
    local vx,vz=bx-ax,bz-az; local denom=vx*vx+vz*vz
    local t=denom>0 and (((px-ax)*vx+(pz-az)*vz)/denom) or 0
    t=math.max(0,math.min(1,t)); local qx,qz=ax+t*vx,az+t*vz
    local dx,dz=px-qx,pz-qz; return math.sqrt(dx*dx+dz*dz),t,qx,qz
end
local function futureSweepConflict(completedPhysical,activePhysical,activeFuture)
    local alternative=activeFuture and activeFuture.alternatives and activeFuture.alternatives[1] or nil
    if alternative==nil or not finite(alternative.startX) or not finite(alternative.startZ) or not finite(alternative.endX) or not finite(alternative.endZ) then return nil end
    local best=nil
    for _,terminalPrimitive in OuttaMyWay.ValueRecord.ipairs(completedPhysical and completedPhysical.primitives or {}) do
        if terminalPrimitive.kind=="DISC" and terminalPrimitive.positiveConflictSupport==true and finite(terminalPrimitive.x) and finite(terminalPrimitive.z) and finite(terminalPrimitive.radius) then
            for _,activePrimitive in OuttaMyWay.ValueRecord.ipairs(activePhysical and activePhysical.primitives or {}) do
                if activePrimitive.kind=="DISC" and activePrimitive.positiveConflictSupport==true and finite(activePrimitive.x) and finite(activePrimitive.z) and finite(activePrimitive.radius) then
                    local offsetX=activePrimitive.x-alternative.startX
                    local offsetZ=activePrimitive.z-alternative.startZ
                    local ax,az=alternative.startX+offsetX,alternative.startZ+offsetZ
                    local bx,bz=alternative.endX+offsetX,alternative.endZ+offsetZ
                    local distance,t,qx,qz=pointSegmentDistance(terminalPrimitive.x,terminalPrimitive.z,ax,az,bx,bz)
                    local required=terminalPrimitive.radius+activePrimitive.radius
                    local item={distance=distance,required=required,terminalPrimitiveId=terminalPrimitive.identity,activePrimitiveId=activePrimitive.identity,segmentFraction=t,closestX=qx,closestZ=qz}
                    if best==nil or distance<best.distance then best=item end
                    if distance<=required then item.positive=true; return item end
                end
            end
        end
    end
    return best
end
local function positiveObstruction(completedPhysical,activePhysical,activeFuture)
    if completedPhysical==nil or activePhysical==nil then return nil end
    local current=OuttaMyWay.PlanViewFootprint.evaluateCurrentOverlap({worldPrimitives=completedPhysical.primitives},{worldPrimitives=activePhysical.primitives})
    if current and current.current==true then
        return {kind="CURRENT_PHYSICAL_OCCUPANCY",distance=current.distance,required=current.required,terminalPrimitiveId=current.subjectPrimitiveId,activePrimitiveId=current.otherPrimitiveId,authority="POSITIVE_CONFLICT_SUPPORT_ONLY"}
    end
    local future=futureSweepConflict(completedPhysical,activePhysical,activeFuture)
    if future and future.positive==true then
        future.kind="CONTINUING_ACTIVE_FUTURE_SPACE"; future.authority="POSITIVE_CONFLICT_SUPPORT_ONLY"; return future
    end
    return nil
end

function Assessment.new(jobEpisodes)
    return setmetatable({jobEpisodes=jobEpisodes,playerClaimed={},yieldRenewalState={},exhausted={}},Assessment)
end
function Assessment:reset()
    self.playerClaimed={}; self.yieldRenewalState={}; self.exhausted={}
end
function Assessment:markPlayerClaimed(terminalEpisodeId) if type(terminalEpisodeId)=="string" then self.playerClaimed[terminalEpisodeId]=true end end
function Assessment:markExhausted(terminalEpisodeId) if type(terminalEpisodeId)=="string" then self.exhausted[terminalEpisodeId]=true end end
function Assessment:markRetreatCompleted(terminalEpisodeId,authorizingDemandAssemblyIds)
    if type(terminalEpisodeId)~="string" then return end
    local ids={}
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(authorizingDemandAssemblyIds or {}) do if type(assemblyId)=="string" then ids[#ids+1]=assemblyId end end
    table.sort(ids)
    self.yieldRenewalState[terminalEpisodeId]={authorizingDemandAssemblyIds=ids,continuationObserved=false}
end
function Assessment:_consumeControlOutcomes(snapshot)
    for _,outcome in OuttaMyWay.ValueRecord.ipairs(snapshot.controlOutcomes or {}) do
        if outcome.kind=="D0147_TERMINAL_EGRESS_CONTROL_OBSERVATION" and type(outcome.terminalEpisodeId)=="string" then
            if outcome.playerClaimed==true then self.playerClaimed[outcome.terminalEpisodeId]=true end
            if outcome.exhausted==true then self.exhausted[outcome.terminalEpisodeId]=true end
        end
    end
end
function Assessment:assess(snapshot,currentSpace,futureSpace,physicalSpaceEvidence,commitmentContext)
    self:_consumeControlOutcomes(snapshot)
    local physical=physicalByAssembly(physicalSpaceEvidence); local future=futureByAssembly(futureSpace); local current=currentByAssembly(currentSpace); local refs=referenceByAssembly(snapshot); local motion=motionByReference(snapshot); local aiStates=aiStateByReference(snapshot)
    local activeSet={}; for _,episode in OuttaMyWay.ValueRecord.ipairs(self.jobEpisodes:list()) do if episode.status=="ACTIVE" then activeSet[episode.assemblyId]=episode end end
    local liveTerminalCommitmentByEpisode={}
    for _,context in OuttaMyWay.ValueRecord.ipairs(commitmentContext or {}) do
        local basis=context.governingBasis or {}; if basis.kind=="TERMINAL_OCCUPANCY" and type(basis.terminalEpisodeId)=="string" then liveTerminalCommitmentByEpisode[basis.terminalEpisodeId]=context.commitmentId end
    end
    -- Player Claim is sticky for the completed Job Episode, even if the player
    -- later exits. The direct GIANTS getIsEntered witness is placed in playerControl.
    for assemblyReferenceKey,control in OuttaMyWay.ValueRecord.pairs(snapshot.playerControl or {}) do
        if type(control)=="table" and control.playerEntered==true then
            local assemblyId=nil
            for _,assembly in OuttaMyWay.ValueRecord.ipairs(snapshot.assemblies or {}) do if assembly.referenceKey==assemblyReferenceKey then assemblyId=assembly.assemblyId break end end
            if assemblyId~=nil then
                for _,episode in OuttaMyWay.ValueRecord.ipairs(self.jobEpisodes:list()) do
                    if episode.status=="ENDED" and episode.assemblyId==assemblyId and episode.terminalCause=="SOURCE_INTENT_TERMINATION" then self.playerClaimed[episode.identity]=true end
                end
            end
        end
    end
    local records,fitness={},{}
    for _,episode in OuttaMyWay.ValueRecord.ipairs(self.jobEpisodes:list()) do
        if episode.status=="ENDED" and episode.terminalCause=="SOURCE_INTENT_TERMINATION" and activeSet[episode.assemblyId]==nil then
            local terminalPhysical=physical[episode.assemblyId]
            local terminalCurrent=current[episode.assemblyId]
            local claimed=self.playerClaimed[episode.identity]==true
            local existingCommitmentId=liveTerminalCommitmentByEpisode[episode.identity]
            local obstructionEvidence,obstructed={},{ }
            if not claimed and terminalPhysical~=nil and terminalCurrent~=nil then
                for activeAssemblyId,_ in OuttaMyWay.ValueRecord.pairs(activeSet) do
                    if activeAssemblyId~=episode.assemblyId then
                        local evidence=positiveObstruction(terminalPhysical,physical[activeAssemblyId],future[activeAssemblyId])
                        if evidence~=nil then obstructionEvidence[#obstructionEvidence+1]={activeAssemblyId=activeAssemblyId,evidence=evidence}; obstructed[#obstructed+1]=activeAssemblyId end
                    end
                end
            end
            table.sort(obstructed); table.sort(obstructionEvidence,function(a,b) return tostring(a.activeAssemblyId)<tostring(b.activeAssemblyId) end)
            local obstructionPositive=#obstructed>0
            -- Continuation Renewal: a completed retreat does not re-arm merely because
            -- conservative conflict geometry flickers or remains positive. The authorising
            -- productive assembly/assemblies must first demonstrate GIANTS-owned physical
            -- progression after release. A repeated courtesy retreat is then admitted only
            -- on a later blocked=true state that is still positively attributed to this
            -- terminal assembly. This prevents immediate chained retreats while allowing
            -- a later real encounter even when Future Space never became fully negative.
            local renewal=self.yieldRenewalState[episode.identity]
            local awaitingContinuation=renewal~=nil
            local continuationRenewed=renewal~=nil and renewal.continuationObserved==true
            if renewal~=nil and renewal.continuationObserved~=true then
                local required=renewal.authorizingDemandAssemblyIds or {}
                local allProgressed=OuttaMyWay.ValueRecord.length(required)>0
                for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(required) do
                    local ref=refs[assemblyId]
                    if ref==nil or not positivePhysicalProgress(motion[ref],aiStates[ref]) then allProgressed=false break end
                end
                if allProgressed then
                    renewal.continuationObserved=true; continuationRenewed=true
                    logInfo("CONTINUATION_RENEWED episode=%s authorisingAssemblies=%s physicalProgress=true",tostring(episode.identity),table.concat(required,","))
                end
            end
            local repeatBlockedPositive=false
            if renewal~=nil and renewal.continuationObserved==true and obstructionPositive then
                local authorizing={}
                for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(renewal.authorizingDemandAssemblyIds or {}) do authorizing[assemblyId]=true end
                for _,assemblyId in ipairs(obstructed) do
                    local ref=refs[assemblyId]; local aiState=ref and aiStates[ref] or nil
                    if authorizing[assemblyId] and type(aiState)=="table" and aiState.observedActive==true and aiState.blocked==true then repeatBlockedPositive=true break end
                end
            end
            if repeatBlockedPositive then
                logInfo("CONTINUATION_RENEWAL_REPEAT_BLOCK episode=%s blockedAttributed=true freshCourtesyAuthority=true",tostring(episode.identity))
                self.yieldRenewalState[episode.identity]=nil
                renewal=nil; awaitingContinuation=false
            end
            local representationId="d0147-terminal-occupancy:"..episode.identity
            local primitiveCount=0
            for _,primitive in OuttaMyWay.ValueRecord.ipairs(terminalPhysical and terminalPhysical.primitives or {}) do if primitive.kind=="DISC" and primitive.positiveConflictSupport==true then primitiveCount=primitiveCount+1 end end
            local fit=primitiveCount>0 and terminalCurrent~=nil and "FIT_FOR_LIMITED_HORIZON" or "REFRESH_REQUIRED"
            fitness[#fitness+1]={representationId=representationId,assemblyId=episode.assemblyId,question="D0147_TERMINAL_OCCUPANCY_AND_REACTIVE_INFIELD_YIELD",assessmentHorizon="CURRENT_PICTURE_ONLY",state=fit,claimPermissions=fit=="FIT_FOR_LIMITED_HORIZON" and {"POSITIVE_TERMINAL_OBSTRUCTION","REACTIVE_BOUNDED_INFIELD_YIELD_AUTHORITY"} or {},coverage={complete=false,conservative=false,underApproximationRisk=true},uncertainty=fit=="FIT_FOR_LIMITED_HORIZON" and {"NO_NEGATIVE_EXTERNAL_MARGIN_TRAVERSABILITY_AUTHORITY"} or {"TERMINAL_PHYSICAL_REPRESENTATION_UNAVAILABLE"},validityDependencies={"ENDED_JOB_EPISODE","CURRENT_TERMINAL_POSE","CURRENT_ACTIVE_DEMAND","JOB_SEEDED_FIELD_WORLD"},provenance={source="TerminalOccupancyAssessment",authority="POSITIVE_CONFLICT_SUPPORT_ONLY"}}
            records[#records+1]={
                identity="terminal-occupancy:"..episode.identity,terminalEpisodeId=episode.identity,assemblyId=episode.assemblyId,assemblyReferenceKey=refs[episode.assemblyId],fieldWorldReferenceKey=episode.fieldWorldReferenceKey,
                existingCommitmentId=existingCommitmentId,obstructionPositive=obstructionPositive,obstructedDemandAssemblyIds=obstructed,obstructionEvidence=obstructionEvidence,
                playerClaimed=claimed,yieldAwaitingContinuation=awaitingContinuation,continuationRenewed=continuationRenewed,repeatBlockedPositive=repeatBlockedPositive,exhausted=self.exhausted[episode.identity]==true,
                configurationEvidence=copy(terminalPhysical and terminalPhysical.configurationEvidence or {}),representationId=representationId,
                currentSpace=copy(terminalCurrent),physicalSpace=copy(terminalPhysical),
                provenance={source="TerminalOccupancyAssessment",jobEpisodeTerminalCause=episode.terminalCause,authority="D0147_POSITIVE_TERMINAL_OCCUPANCY"}
            }
        end
    end
    table.sort(records,function(a,b) return tostring(a.terminalEpisodeId)<tostring(b.terminalEpisodeId) end)
    table.sort(fitness,function(a,b) return tostring(a.representationId)<tostring(b.representationId) end)
    return records,fitness
end
