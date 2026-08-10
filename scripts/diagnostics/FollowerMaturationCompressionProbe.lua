OuttaMyWay.FollowerMaturationCompressionProbe = {}
local Probe=OuttaMyWay.FollowerMaturationCompressionProbe
Probe.__index=Probe

local function logInfo(message)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][FOLLOWER-COMPRESSION] %s",message)
    else
        print("[FS25_OuttaMyWay][FOLLOWER-COMPRESSION] "..message)
    end
end

local function finite(v) return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge end
local function refKey(vehicle) return "vehicle-root:"..tostring(vehicle and (vehicle.rootNode or vehicle) or "nil") end
local function nameOf(vehicle)
    if vehicle and type(vehicle.getName)=="function" then local ok,v=pcall(vehicle.getName,vehicle); if ok and v and v~="" then return tostring(v) end end
    return tostring(vehicle and (vehicle.name or vehicle.typeName) or "AI vehicle")
end
local function speedKmh(vehicle) return math.abs(tonumber(vehicle and vehicle.lastSpeedReal) or 0)*3600 end
local function pose(vehicle)
    local node=vehicle and (vehicle.rootNode or vehicle.components and vehicle.components[1] and vehicle.components[1].node) or nil
    if node==nil or node==0 or type(getWorldTranslation)~="function" or type(localDirectionToWorld)~="function" then return nil end
    local okP,x,_,z=pcall(getWorldTranslation,node); local okD,dx,_,dz=pcall(localDirectionToWorld,node,0,0,1)
    if not okP or not okD or not finite(x) or not finite(z) or not finite(dx) or not finite(dz) then return nil end
    local l=math.sqrt(dx*dx+dz*dz); if l<=0.000001 then return nil end
    return {x=x,z=z,dx=dx/l,dz=dz/l}
end
local function physicalDiscs(representation)
    local out={}
    for _,p in OuttaMyWay.ValueRecord.ipairs(representation and representation.worldPrimitives or {}) do
        if p.kind=="DISC" and p.positiveConflictSupport==true and finite(p.x) and finite(p.z) and finite(p.radius) then out[#out+1]=p end
    end
    return out
end
local function envelopeInFrame(origin,representation)
    local result=nil; local lx,lz=-origin.dz,origin.dx
    for _,disc in ipairs(physicalDiscs(representation)) do
        local rx,rz=disc.x-origin.x,disc.z-origin.z
        local f=rx*origin.dx+rz*origin.dz; local l=rx*lx+rz*lz; local r=disc.radius
        local item={minForward=f-r,maxForward=f+r,minLateral=l-r,maxLateral=l+r}
        if result==nil then result=item else
            result.minForward=math.min(result.minForward,item.minForward); result.maxForward=math.max(result.maxForward,item.maxForward)
            result.minLateral=math.min(result.minLateral,item.minLateral); result.maxLateral=math.max(result.maxLateral,item.maxLateral)
        end
    end
    return result
end
local function overlaps(a0,a1,b0,b1) return a0<=b1 and b0<=a1 end

-- Pure shadow calculation. It deliberately uses the demonstrated complete sweep
-- until manoeuvre completion; reaction margin and finer time-indexed occupancy
-- are left unresolved and are reported as such rather than hidden in literals.
function Probe.evaluateShadow(leaderPose,leaderBoundaryDistanceM,leaderSpeedKmh,followerPose,followerRepresentation,followerSpeedKmh,demand)
    if leaderPose==nil or followerPose==nil or demand==nil or demand.sweep==nil then return {status="UNRESOLVED",reason="INCOMPLETE_EVIDENCE"} end
    if not finite(leaderBoundaryDistanceM) or not finite(leaderSpeedKmh) or leaderSpeedKmh<=0 then return {status="UNRESOLVED",reason="LEADER_PROGRESSION_UNRESOLVED"} end
    local approachM=math.max(0,leaderBoundaryDistanceM-demand.entryBoundaryDistanceM)
    local entryPose={x=leaderPose.x+leaderPose.dx*approachM,z=leaderPose.z+leaderPose.dz*approachM,dx=leaderPose.dx,dz=leaderPose.dz}
    local followerEnvelope=envelopeInFrame(entryPose,followerRepresentation)
    if followerEnvelope==nil then return {status="UNRESOLVED",reason="FOLLOWER_REPRESENTATION_UNAVAILABLE"} end
    local headingDot=leaderPose.dx*followerPose.dx+leaderPose.dz*followerPose.dz
    local leaderToFollowerForward=(followerPose.x-leaderPose.x)*leaderPose.dx+(followerPose.z-leaderPose.z)*leaderPose.dz
    if headingDot<=0 then return {status="NOT_APPLICABLE",reason="CONTINUATIONS_NOT_POSITIVELY_ALIGNED",headingDot=headingDot} end
    if leaderToFollowerForward>=0 then return {status="NOT_APPLICABLE",reason="NO_TRAILING_RELATIONSHIP",headingDot=headingDot,leaderToFollowerForwardM=leaderToFollowerForward} end
    local lateralOverlap=overlaps(followerEnvelope.minLateral,followerEnvelope.maxLateral,demand.sweep.minLateral,demand.sweep.maxLateral)
    local timeToEntrySec=approachM/(leaderSpeedKmh/3.6)
    local requiredSec=timeToEntrySec+(demand.durationMs/1000)
    local travelToSweepM=demand.sweep.minForward-followerEnvelope.maxForward
    local followerKmh=tonumber(followerSpeedKmh) or 0
    local currentFollowerMps=followerKmh/3.6
    local etaSec=(currentFollowerMps>0 and travelToSweepM>0) and travelToSweepM/currentFollowerMps or (travelToSweepM<=0 and 0 or nil)
    local maxAdmissibleKmh=nil
    if requiredSec>0 then maxAdmissibleKmh=math.max(0,travelToSweepM)/requiredSec*3.6 end
    local compression=lateralOverlap and (travelToSweepM<=0 or (etaSec~=nil and etaSec<requiredSec))
    return {
        status=compression and "REGULATE_SUPPORTED" or "OBSERVE_SUPPORTED",
        reason=compression and "UNRESTRICTED_FOLLOWER_PROGRESSION_CONSUMES_DEMONSTRATED_MANOEUVRE_DEMAND" or (lateralOverlap and "DEMONSTRATED_MANOEUVRE_DEMAND_REMAINS_PRESERVED" or "FOLLOWER_PROGRESSION_LATERALLY_DECOUPLED_FROM_DEMONSTRATED_SWEEP"),
        headingDot=headingDot,leaderToFollowerForwardM=leaderToFollowerForward,lateralOverlap=lateralOverlap,
        approachToTurnEntryM=approachM,timeToTurnEntrySec=timeToEntrySec,demonstratedTurnDurationSec=demand.durationMs/1000,
        requiredPreservationSec=requiredSec,travelToSweepM=travelToSweepM,followerEtaToSweepSec=etaSec,
        currentFollowerKmh=followerKmh,maxAdmissibleFollowerKmh=maxAdmissibleKmh,followerEnvelope=followerEnvelope,entryPose=entryPose
    }
end

function Probe.new(runtime,nativeManoeuvreSource,productiveKnowledgeSource)
    return setmetatable({runtime=runtime,nativeManoeuvreSource=nativeManoeuvreSource,productiveKnowledgeSource=productiveKnowledgeSource,elapsed=0,lastLogAt={},signatures={},shadowByFollower={}},Probe)
end
function Probe:reset() self.elapsed=0; self.lastLogAt={}; self.signatures={}; self.shadowByFollower={} end
function Probe:loadMap() self:reset(); logInfo("follower-maturation shadow active; Native Manoeuvre observations have boundary-demand Representation Fitness UNRESOLVED; hypothetical caps are forensic only; no Regulation lease or Control authority") end
function Probe:deleteMap() self:reset() end
function Probe:keyEvent() end; function Probe:mouseEvent() end; function Probe:draw() end
function Probe:_representation(vehicle,ref,jobToken,nowMs)
    local cache=self.runtime and self.runtime.assemblyRepresentationCache or nil
    return cache and jobToken and cache:observe(vehicle,ref,jobToken,(nowMs or 0)/1000) or nil
end
function Probe:_track(ref) local source=self.runtime and self.runtime.liveObservationSource; return source and source.tracks and source.tracks[ref] or nil end
function Probe:_sameFieldWorld(a,b)
    local at,bt=self:_track(a),self:_track(b)
    return at~=nil and bt~=nil and at.fieldWorldResolution~=nil and bt.fieldWorldResolution~=nil and at.fieldWorldResolution.fieldWorldReferenceKey~=nil and at.fieldWorldResolution.fieldWorldReferenceKey==bt.fieldWorldResolution.fieldWorldReferenceKey
end
function Probe:_productive(ref,jobToken)
    local source=self.productiveKnowledgeSource
    local evidence=source and type(source.getEvidence)=="function" and source:getEvidence(ref,jobToken) or nil
    return evidence~=nil and evidence.productivePositive==true,evidence
end
function Probe:_settled(ref)
    local track=self:_track(ref); local localIntent=track and track.localIntent or nil
    return localIntent~=nil and localIntent.classification=="SETTLED_CONTINUATION" and localIntent.intentValid==true,localIntent
end
function Probe:_log(key,message,nowMs)
    local signature=message; local heartbeat=OuttaMyWay.FOLLOWER_MATURATION_COMPRESSION_PROBE_HEARTBEAT_MS or 1000
    local previous=self.signatures[key]; local last=self.lastLogAt[key]
    if previous~=signature or last==nil or nowMs-last>=heartbeat then self.signatures[key]=signature; self.lastLogAt[key]=nowMs; logInfo(message) end
end
function Probe:getActivePacingRecords()
    local result={}
    for _,record in pairs(self.shadowByFollower) do
        local copy={}; for k,v in pairs(record) do copy[k]=v end; result[#result+1]=copy
    end
    table.sort(result,function(a,b) return tostring(a.followerRef)<tostring(b.followerRef) end)
    return result
end
function Probe:update(dt)
    if OuttaMyWay.FOLLOWER_MATURATION_COMPRESSION_PROBE_ENABLED~=true or g_currentMission==nil then return end
    if g_client~=nil and g_server==nil then return end
    self.elapsed=self.elapsed+(dt or 0); local interval=OuttaMyWay.FOLLOWER_MATURATION_COMPRESSION_PROBE_INTERVAL_MS or 100
    if self.elapsed<interval then return end; self.elapsed=self.elapsed%interval
    local nowMs=tonumber(g_time) or 0; local vehicles=OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(g_currentMission); local newShadow={}
    for _,leader in OuttaMyWay.ValueRecord.ipairs(vehicles) do
        local lref=refKey(leader); local ljob=OuttaMyWay.LiveAIJobEvidence.jobToken(OuttaMyWay.LiveAIJobEvidence.currentJob(leader))
        local productive=self:_productive(lref,ljob); local settled=self:_settled(lref)
        local observations=self.nativeManoeuvreSource and self.nativeManoeuvreSource:getObservations(lref,ljob) or {}
        local demand=OuttaMyWay.NativeManoeuvreObservationSource and OuttaMyWay.NativeManoeuvreObservationSource.forensicDemandEnvelope(observations) or nil
        if productive and settled and demand~=nil then
            local lp=pose(leader); local track=self:_track(lref); local field=track and track.fieldWorldSnapshot or nil
            local boundaryDistance,boundarySource=nil,"FIELD_WORLD_SNAPSHOT_UNAVAILABLE"
            if lp~=nil and field~=nil then boundaryDistance,boundarySource=OuttaMyWay.FieldBoundedFutureSpace.forwardBoundaryDistance(field,lp) end
            for _,follower in OuttaMyWay.ValueRecord.ipairs(vehicles) do
                if follower~=leader then
                    local fref=refKey(follower); local fjob=OuttaMyWay.LiveAIJobEvidence.jobToken(OuttaMyWay.LiveAIJobEvidence.currentJob(follower))
                    local fProductive=self:_productive(fref,fjob); local fSettled=self:_settled(fref)
                    if fProductive and fSettled and self:_sameFieldWorld(lref,fref) then
                        local fp=pose(follower); local frep=self:_representation(follower,fref,fjob,nowMs)
                        local result=Probe.evaluateShadow(lp,boundaryDistance,speedKmh(leader),fp,frep,speedKmh(follower),demand)
                        local key=lref.."|"..fref
                        local hypothetical=result.maxAdmissibleFollowerKmh and math.max(0,result.maxAdmissibleFollowerKmh*(OuttaMyWay.FOLLOWER_MATURATION_TRANSITION_CLEARANCE_FACTOR or 0.90)) or nil
                        local record={leaderName=nameOf(leader),followerName=nameOf(follower),leaderRef=lref,followerRef=fref,status=result.status,reason=result.reason,hypotheticalCapKmh=hypothetical,boundaryDemandFitness="UNRESOLVED",shadow=true,ownerTag="NONE",purpose="PRESERVE_BOUNDARY_TRANSITION_CLEARANCE_SHADOW"}
                        newShadow[fref]=record
                        self:_log(key,string.format("PAIR leader=%s follower=%s leaderRef=%s followerRef=%s profileCount=%d boundary=%s boundarySource=%s status=%s reason=%s headingDot=%s trailingForward=%s derivedMaxFollowerSpeed=%s hypotheticalAfterTestFactor=%s boundaryDemandFitness=UNRESOLVED boundaryDemandAuthority=false control=false authority=PASSIVE_SHADOW_ONLY",
                            record.leaderName,record.followerName,lref,fref,demand.count or 0,boundaryDistance and string.format("%.2fm",boundaryDistance) or "n/a",tostring(boundarySource),tostring(result.status),tostring(result.reason),
                            result.headingDot and string.format("%.4f",result.headingDot) or "n/a",result.leaderToFollowerForwardM and string.format("%.2fm",result.leaderToFollowerForwardM) or "n/a",
                            result.maxAdmissibleFollowerKmh and string.format("%.2fkmh",result.maxAdmissibleFollowerKmh) or "n/a",hypothetical and string.format("%.2fkmh",hypothetical) or "n/a"),nowMs)
                    end
                end
            end
        end
    end
    self.shadowByFollower=newShadow
end
