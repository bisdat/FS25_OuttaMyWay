-- Passive, finite witness of GIANTS behaviour after an interrupted paired egress.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- This is observation only: no native drive wrapping, job requests, or Control.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativeContinuationWitness={}
local Witness=OuttaMyWay.NativeContinuationWitness
Witness.__index=Witness

local SAMPLE_OFFSETS_MS={0,500,2000,5000}

local function finite(n)
    return type(n)=="number" and n==n
        and n~=math.huge and n~=-math.huge
end

local function location(vehicle)
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(getWorldTranslation)~="function" then return nil,nil end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    if not ok or not finite(x) or not finite(z) then return nil,nil end
    return x,z
end

local function currentJob(vehicle)
    if type(vehicle)~="table" or type(vehicle.getJob)~="function" then
        return nil
    end
    local ok,job=pcall(vehicle.getJob,vehicle)
    return ok and job or nil
end

local function currentStrategy(vehicle,reference)
    local spec=type(vehicle)=="table" and vehicle.spec_aiFieldWorker or nil
    local strategies=type(spec)=="table" and spec.driveStrategies or nil
    if type(strategies)~="table" then return false end
    for _,strategy in pairs(strategies) do
        if strategy==reference then return true end
    end
    return false
end

-- Passive, native-populated immediate drive parameters. Their validity
-- does NOT certify a newly issued driveToPoint command or physical propulsion.
local function nativeDrive(vehicle)
    local spec=type(vehicle)=="table" and vehicle.spec_aiFieldWorker or nil
    local params=type(spec)=="table" and spec.aiDriveParams or nil
    return type(params)=="table" and params or nil
end

local function owned(control,mechanismName,fieldName,vehicle)
    local mechanism=type(control)=="table" and control[mechanismName] or nil
    local records=type(mechanism)=="table" and mechanism[fieldName] or nil
    if type(records)~="table" then return "UNKNOWN" end
    return records[vehicle]~=nil
end

local function candidateStatus(witness)
    local state=witness.active
    local observer=state.observer
    if type(observer)~="table"
        or type(observer.getCurrentPairCandidates)~="function" then
        return "UNAVAILABLE"
    end
    local ok,items=pcall(observer.getCurrentPairCandidates,observer)
    if not ok or type(items)~="table" then return "UNAVAILABLE" end
    local newIdentity=false
    for i=1,#items do
        local item=items[i]
        if item.candidateIdentity==state.candidateIdentity then
            return "SAME_NATIVE_OCCURRENCE"
        end
        if item.pairKey==state.pairKey then newIdentity=true end
    end
    return newIdentity and "NEW_NATIVE_OCCURRENCE" or "NO_PAIR_CANDIDATE"
end

local function publish(state,code,detail)
    -- A fixed maximum of four NORMAL observations per interruption provides
    -- evidence without enabling expensive DIAGNOSTIC trajectory probes.
    -- Publication failure is never allowed to affect GIANTS or OMW Control.
    if type(state.publisher)~="table"
        or type(state.publisher.publish)~="function" then return end
    pcall(state.publisher.publish,state.publisher,
        "NORMAL","INFO",code,function()
            return {detail=detail,version=OuttaMyWay.VERSION}
        end)
end

local function actorFields(state,participant,role)
    local vehicle=participant.vehicle
    local x,z=location(vehicle)
    local start=state.starts[role]
    local displacementM=nil
    if x~=nil and start.x~=nil then
        displacementM=math.sqrt((x-start.x)^2+(z-start.z)^2)
    end
    local spec=type(vehicle)=="table" and vehicle.spec_aiFieldWorker or nil
    local strategy=participant.sourceStrategyReference
    local strategyCurrent=strategy~=nil and currentStrategy(vehicle,strategy)
    local blockedText=strategyCurrent and tostring(strategy.isBlocked) or "UNAVAILABLE"
    local job=currentJob(vehicle)
    local params=nativeDrive(vehicle)
    local control=state.physicalControl
    return role.."Root="..tostring(participant.assemblyReferenceKey)
        .." "..role.."JobSame="..tostring(job~=nil
            and job==participant.sourceJobReference)
        .." "..role.."JobReadable="..tostring(job~=nil)
        .." "..role.."StrategySame="..tostring(strategyCurrent)
        .." "..role.."AiActive="..tostring(type(spec)=="table"
            and spec.isActive==true)
        .." "..role.."IsBlocked="..blockedText
        .." "..role.."RootDisplacementM="..tostring(displacementM)
        .." "..role.."DriveParamsValid="..tostring(params and params.valid)
        .." "..role.."DriveMaxSpeed="..tostring(params and params.maxSpeed)
        .." "..role.."ReverseLease="..tostring(owned(control,
            "reverseMechanism","states",vehicle))
        .." "..role.."TransitLease="..tostring(owned(control,
            "transitMechanism","requests",vehicle))
        .." "..role.."RegulationLease="..tostring(owned(control,
            "regulationMechanism","leases",vehicle))
        .." "..role.."HoldLease="..tostring(owned(control,
            "holdMechanism","holds",vehicle))
end

function Witness.new(publisher)
    return setmetatable({publisher=publisher,active=nil},Witness)
end

function Witness:isActive()
    return self.active~=nil
end

function Witness:finish(nowMs,reason)
    local state=self.active
    if state==nil then return end
    publish(state,"NATIVE_CONTINUATION_WITNESS_ENDED",
        "commitmentId="..tostring(state.commitmentId)
        .." elapsedMs="..tostring(finite(nowMs)
            and math.max(0,nowMs-state.startedMs) or "UNKNOWN")
        .." reason="..tostring(reason))
    self.active=nil
end

function Witness:advance(nowMs)
    local state=self.active
    if state==nil then return end
    if not finite(nowMs) or nowMs<state.startedMs then
        self:finish(nowMs,"CLOCK_INVALID")
        return
    end
    local offset=SAMPLE_OFFSETS_MS[state.nextIndex]
    if offset==nil then self.active=nil;return end
    if nowMs-state.startedMs<offset then return end
    local mover,peer=state.mover,state.peer
    local detail="commitmentId="..tostring(state.commitmentId)
        .." cause="..tostring(state.reason)
        .." scheduledOffsetMs="..tostring(offset)
        .." observedOffsetMs="..tostring(nowMs-state.startedMs)
        .." candidate="..candidateStatus(self)
        .." candidateAlreadyAttempted="..tostring(state.candidateAttempted)
        .." "..actorFields(state,mover,"mover")
        .." "..actorFields(state,peer,"peer")
    publish(state,"NATIVE_CONTINUATION_WITNESS",detail)
    state.nextIndex=state.nextIndex+1
    if state.nextIndex>#SAMPLE_OFFSETS_MS then
        self.active=nil
    end
end

function Witness:begin(nowMs,movement,outcome,observer,
    candidateIdentity,pairKey,isCandidateAttempted,physicalControl)
    if not finite(nowMs) or type(movement)~="table"
        or movement.isSingle or movement.isStatic
        or type(movement.relocator)~="table"
        or type(movement.blockers)~="table"
        or type(movement.blockers[1])~="table"
        or type(outcome)~="table" or outcome.status~="EGRESS_INTERRUPTED" then
        return false
    end
    if self.active~=nil then self:finish(nowMs,"REPLACED_BY_INTERRUPTION") end
    local mover,peer=movement.relocator,movement.blockers[1]
    local mx,mz=location(mover.vehicle)
    local px,pz=location(peer.vehicle)
    self.active={publisher=self.publisher,
        commitmentId=outcome.commitmentId,reason=outcome.reason,
        startedMs=nowMs,nextIndex=1,mover=mover,peer=peer,
        observer=observer,candidateIdentity=candidateIdentity,pairKey=pairKey,
        candidateAttempted=isCandidateAttempted==true,
        physicalControl=physicalControl,
        starts={mover={x=mx,z=mz},peer={x=px,z=pz}}}
    self:advance(nowMs)
    return true
end
