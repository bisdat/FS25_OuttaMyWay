-- Bounded six-stage Hold & Relocate sequencing; physical actuation is supplied by a separate GIANTS adapter.
-- Specification Jurisdictions: `HOLD_RELOCATE_SEQUENCE`
-- This is not a pair admission authority and is not wired to passive Observation.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.HoldRelocateSequence={}
local Sequence=OuttaMyWay.HoldRelocateSequence
Sequence.__index=Sequence

local function finite(n)
    return type(n)=="number" and n==n and n~=math.huge and n~=-math.huge
end

local function positioned(p)
    return type(p)=="table" and p.rootId~=nil and p.vehicle~=nil
        and finite(p.x) and finite(p.z)
end

local function call(port,method,...)
    local f=port and port[method]
    if type(f)~="function" then return false,"ADAPTER_METHOD_MISSING:"..method end
    local ok,answer,reason=pcall(f,port,...)
    if not ok then return false,"ADAPTER_EXCEPTION:"..method end
    if answer~=true then return false,reason or ("ADAPTER_REFUSED:"..method) end
    return true
end

local function sample(port,method,...)
    local f=port and port[method]
    if type(f)~="function" then return nil,"ADAPTER_METHOD_MISSING:"..method end
    local ok,answer=pcall(f,port,...)
    if not ok then return nil,"ADAPTER_EXCEPTION:"..method end
    return answer
end

local function selectRelocator(a,b,centroid)
    local ax,az=a.x-centroid.x,a.z-centroid.z
    local bx,bz=b.x-centroid.x,b.z-centroid.z
    local ad,bd=ax*ax+az*az,bx*bx+bz*bz
    if ad<bd or (ad==bd and tostring(a.rootId)<tostring(b.rootId)) then
        return a,b
    end
    return b,a
end

function Sequence.new(adapter)
    return setmetatable({adapter=adapter,active=nil,lastOutcome=nil},Sequence)
end

function Sequence:isActive()
    return self.active~=nil
end

function Sequence:getStatus()
    local s=self.active
    if s==nil then return {active=false,lastOutcome=self.lastOutcome} end
    return {
        active=true,phase=s.phase,commitmentId=s.commitmentId,
        relocatingRootId=s.relocator.rootId,reverseLimitM=s.limitM,
        blockerHoldUntilMs=s.egressEndsMs,relocatedHoldUntilMs=s.relHoldEndsMs
    }
end

function Sequence:_releaseHolds(s)
    if s.relocatorHeld then
        call(self.adapter,"setHold",s.relocator.vehicle,false,"RELOCATED_WORKER")
        s.relocatorHeld=false
    end
    for i=1,#s.blockers do
        if s.held[i] then
            call(self.adapter,"setHold",s.blockers[i].vehicle,false,"EGRESS")
            s.held[i]=false
        end
    end
end

function Sequence:_retire(status,reason)
    local s=self.active
    if s==nil then return end
    if status~="COMPLETED" then
        call(self.adapter,"cancelReverse",s.relocator.vehicle)
        call(self.adapter,"cancelTransit",s.relocator.vehicle)
    end
    self:_releaseHolds(s)
    self.lastOutcome={status=status,reason=reason,commitmentId=s.commitmentId,
        relocatingRootId=s.relocator.rootId}
    self.active=nil
end

function Sequence:abort(reason)
    if self.active==nil then return false,"NOT_ACTIVE" end
    self:_retire("RELINQUISHED",reason or "EXTERNAL_ABORT")
    return true
end

-- Begin consumes a separately authorised commitment and a resolved physical
-- snapshot. It must never be invoked automatically from a DEBUG candidate.
function Sequence:begin(request,nowMs)
    if self.active~=nil then return false,"SEQUENCE_ALREADY_ACTIVE" end
    if type(request)~="table" or request.authorized~=true
        or request.commitmentId==nil or not finite(nowMs)
        or type(request.participants)~="table" or #request.participants~=2
        or type(request.centroid)~="table"
        or not finite(request.centroid.x) or not finite(request.centroid.z)
        or not finite(request.offsetM) or request.offsetM<0
        or type(request.blockers)~="table" or #request.blockers==0 then
        return false,"COMMITMENT_EVIDENCE_UNAVAILABLE"
    end
    local a,b=request.participants[1],request.participants[2]
    if not positioned(a) or not positioned(b) or a.rootId==b.rootId
        or a.vehicle==b.vehicle then return false,"PAIR_SNAPSHOT_INVALID" end
    local relocator,other=selectRelocator(a,b,request.centroid)
    local held,seen={},{}
    local includesOther=false
    for i=1,#request.blockers do
        local p=request.blockers[i]
        if not positioned(p) or p.rootId==relocator.rootId
            or seen[p.rootId] then return false,"BLOCKER_MEMBERSHIP_INVALID" end
        seen[p.rootId]=true
        held[#held+1]=p
        if p.rootId==other.rootId and p.vehicle==other.vehicle then includesOther=true end
    end
    if not includesOther then return false,"PAIR_BLOCKER_NOT_INCLUDED" end

    local dx=request.centroid.x-relocator.x
    local dz=request.centroid.z-relocator.z
    local distance=math.sqrt(dx*dx+dz*dz)
    if not finite(distance) or distance<=0 then return false,"CENTROID_REVERSE_DIRECTION_UNAVAILABLE" end
    local limit=30+request.offsetM
    if not finite(limit) or limit<=0 then return false,"REVERSE_BOUND_INVALID" end
    local travel=math.min(distance,limit)
    local objective={x=relocator.x+dx/distance*travel,
        z=relocator.z+dz/distance*travel,maxTravelM=limit,
        steeringHorizonM=40,reverse=true}
    local state={commitmentId=request.commitmentId,relocator=relocator,
        other=other,blockers=held,held={},relocatorHeld=false,
        phase="PREPARING_TRANSIT",egressEndsMs=nowMs+5000,
        relHoldEndsMs=nil,objective=objective,limitM=limit}
    if not finite(state.egressEndsMs) then return false,"CLOCK_INVALID" end

    local ok,reason=call(self.adapter,"preflight",state)
    if not ok then return false,reason end
    self.active=state
    -- Egress protection and TRANSIT start in the same call: no 5 s idle gate.
    for i=1,#held do
        ok,reason=call(self.adapter,"setHold",held[i].vehicle,true,"EGRESS")
        if not ok then
            self:_retire("FAILED",reason)
            return false,reason
        end
        state.held[i]=true
    end
    ok,reason=call(self.adapter,"requestTransit",relocator.vehicle)
    if not ok then
        self:_retire("FAILED",reason)
        return false,reason
    end
    return true,{relocatingRootId=relocator.rootId,objective=objective}
end

function Sequence:update(nowMs)
    local s=self.active
    if s==nil then return end
    if not finite(nowMs) then self:_retire("FAILED","CLOCK_INVALID"); return end
    local valid,reason=call(self.adapter,"stillAuthorized",s)
    if not valid then self:_retire("RELINQUISHED",reason); return end

    -- Sole egress-Hold release criterion is its 5 s clock.
    if nowMs>=s.egressEndsMs then
        for i=1,#s.blockers do
            if s.held[i] then
                local released,why=call(self.adapter,"setHold",s.blockers[i].vehicle,false,"EGRESS")
                if not released then self:_retire("FAILED",why); return end
                s.held[i]=false
            end
        end
    end
    if s.phase=="PREPARING_TRANSIT" then
        local status,why=sample(self.adapter,"transitStatus",s.relocator.vehicle)
        if status=="WAITING" then return end
        if status~="READY" then self:_retire("FAILED",why or "TRANSIT_NOT_READY"); return end
        local started,reasonStart=call(self.adapter,"startReverse",s.relocator.vehicle,s.objective)
        if not started then self:_retire("FAILED",reasonStart); return end
        s.phase="REVERSING"
        return
    end
    if s.phase=="REVERSING" then
        local status,why=sample(self.adapter,"reverseStatus",s.relocator.vehicle,s.objective)
        if type(status)~="table" then self:_retire("FAILED",why or "REVERSE_STATUS_UNAVAILABLE"); return end
        if status.failed==true then self:_retire("FAILED",status.reason or "REVERSE_FAILED"); return end
        if not finite(status.travelledM) or status.travelledM<0
            or status.travelledM>s.limitM then
            self:_retire("FAILED","REVERSE_DISTANCE_EVIDENCE_INVALID")
            return
        end
        if status.completed~=true then return end
        local stopped,whyStop=call(self.adapter,"stopReverse",s.relocator.vehicle)
        if not stopped then self:_retire("FAILED",whyStop); return end
        local held,whyHold=call(self.adapter,"setHold",s.relocator.vehicle,true,"RELOCATED_WORKER")
        if not held then self:_retire("FAILED",whyHold); return end
        s.relocatorHeld=true
        s.relHoldEndsMs=nowMs+10000
        if not finite(s.relHoldEndsMs) then self:_retire("FAILED","CLOCK_INVALID"); return end
        s.phase="HOLD_RELOCATED"
        return
    end
    if s.phase=="HOLD_RELOCATED" and nowMs>=s.relHoldEndsMs then
        local released,whyRelease=call(self.adapter,"setHold",s.relocator.vehicle,false,"RELOCATED_WORKER")
        if not released then self:_retire("FAILED",whyRelease); return end
        s.relocatorHeld=false
        -- Adapter must perform GIANTS stop and immediate start in one invocation.
        local restarted,whyRestart=call(self.adapter,"restartNativeJob",s.relocator.vehicle)
        if not restarted then self:_retire("FAILED",whyRestart); return end
        self:_retire("COMPLETED","NATIVE_JOB_RESTARTED")
    end
end
