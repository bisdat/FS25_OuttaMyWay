--- Executes already-authorised Regulation lease application/release and physical Control observation.
-- Specification Jurisdictions: `CONTROL`

-- Regulation Control boundary.
-- Production boundary for already-authorised REGULATE_SPEED requests.
-- Physical drive mechanics are supplied by the production NativeDriveMechanism;
-- this module owns request validation, lease execution/cleanup and raw execution
-- observation only. It owns no Decision, Regulation magnitude or GIANTS routing.

OuttaMyWay.RegulationControl = {}
local Control = OuttaMyWay.RegulationControl
Control.__index = Control

local function referenceKey(vehicle)
    return "vehicle-root:" .. tostring(vehicle and (vehicle.rootNode or vehicle) or "nil")
end

local function activeVehicles()
    return OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(g_currentMission)
end

local function actualSpeedKmh(vehicle)
    return math.abs(tonumber(vehicle and vehicle.lastSpeedReal) or 0) * 3600
end

local REGULATION_CONTROL_UNAVAILABLE={
    code="REGULATION_CONTROL_UNAVAILABLE",
    publicationClass="NORMAL",
    severity="WARNING",
    origin="CONTROL"
}

function Control.new(runtime,driveMechanism)
    if runtime==nil then error("RegulationControl requires Runtime",2) end
    if driveMechanism==nil then error("RegulationControl requires the existing Regulation drive mechanism",2) end
    return setmetatable({runtime=runtime,driveMechanism=driveMechanism},Control)
end

function Control:_vehicleForReferenceKey(referenceKeyValue)
    if type(referenceKeyValue)~="string" then return nil end
    for _,vehicle in OuttaMyWay.ValueRecord.ipairs(activeVehicles()) do
        if referenceKey(vehicle)==referenceKeyValue then return vehicle end
    end
    return nil
end

-- Raw physical execution Observation only. Situation Assessment remains the
-- semantic owner of whether observed Control state has traffic meaning.
function Control:getVehicleControlObservation(vehicle)
    local state=self.driveMechanism and self.driveMechanism:getState(vehicle) or nil
    return {
        mode=state and state.mode or nil,
        ownerTag=state and state.ownerTag or nil,
        regulationSpeedKmh=state and state.regulationSpeedKmh or nil,
        actualSpeedKmh=vehicle and actualSpeedKmh(vehicle) or nil,
        driveCalls=state and state.driveCalls or 0,
        lastInputMaxSpeed=state and state.lastInputMaxSpeed or nil,
        lastOutputMaxSpeed=state and state.lastOutputMaxSpeed or nil,
        lastInputForward=state and state.lastInputForward or nil,
        provenance={source="RegulationControl",layer="CONTROL_EXECUTION_OBSERVATION",semanticAuthority=false}
    }
end

function Control:getVehicleControlObservationByReference(referenceKeyValue)
    local vehicle=self:_vehicleForReferenceKey(referenceKeyValue)
    if vehicle==nil then return nil end
    return self:getVehicleControlObservation(vehicle)
end

function Control:executeControlRequest(request,candidate)
    OuttaMyWay.ValueRecord.assertType(request,"ControlRequest")
    if self.runtime==nil then return false,"RUNTIME_UNAVAILABLE" end
    if request.capability~="REGULATE_SPEED" then return false,"REGULATION_CONTROL_CAPABILITY_UNSUPPORTED" end

    local commitment=self.runtime.commitments:get(request.commitmentId)
    if commitment==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) then
        return false,"CONTROL_REQUEST_COMMITMENT_NOT_LIVE"
    end
    if commitment.effectiveActuationCompositionId~=request.effectiveActuationCompositionId then
        return false,"CONTROL_REQUEST_COMPOSITION_STALE"
    end

    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(request.commitmentId)) do
        if candidateToken.identity==request.authorityToken and candidateToken.assemblyId==request.assemblyId then
            token=candidateToken
            break
        end
    end
    if token==nil or self.runtime.authorities:validate(token)~=true then
        return false,"CONTROL_REQUEST_AUTHORITY_TOKEN_STALE"
    end

    local target=request.target or {}
    if target.kind~="REGULATION_LEASE" or type(target.vehicleReferenceKey)~="string" or type(target.ownerTag)~="string" then
        return false,"CONTROL_REQUEST_TARGET_UNSUPPORTED"
    end

    -- Positive actuation is defined by the requested operation, not by a vocabulary
    -- whitelist. Unknown/future owner tags therefore fail closed instead of becoming
    -- an implicit Bounded Authority exemption. RELEASE remains authority-narrowing
    -- cleanup and does not require acquisition of a new positive grant.
    if target.operation=="APPLY" and request.boundedAuthorityId==nil then
        return false,"BOUNDED_AUTHORITY_GRANT_REQUIRED"
    end
    if request.boundedAuthorityId~=nil then
        local ok,reason=self.runtime.boundedAuthority:validateRequest(request)
        if ok~=true then return false,reason end
    end

    local vehicle=self:_vehicleForReferenceKey(target.vehicleReferenceKey)
    if vehicle==nil then return false,"CONTROL_REQUEST_VEHICLE_UNAVAILABLE" end

    if target.operation=="APPLY" then
        if commitment.state~="ACTIVE" then return false,"CONTROL_REQUEST_COMMITMENT_NOT_ACTIVE" end
        local speed=tonumber(target.maxSpeedKmh)
        if speed==nil or speed<0 then return false,"CONTROL_REQUEST_REGULATION_SPEED_INVALID" end
        local ok,reason=self.driveMechanism:setRegulationLease(vehicle,speed,target.ownerTag)
        if not ok then return false,reason end
        return true,"REGULATION_LEASE_APPLIED"
    elseif target.operation=="RELEASE" then
        self.driveMechanism:clearRegulationLease(vehicle,target.ownerTag)
        return true,"REGULATION_LEASE_RELEASED"
    end

    return false,"CONTROL_REQUEST_REGULATION_OPERATION_UNSUPPORTED"
end

-- Fail-safe cleanup only relaxes an already-owned lease. It cannot grant or
-- tighten physical authority.
function Control:clearRegulationLeaseByReference(vehicleReferenceKey,ownerTag)
    local vehicle=self:_vehicleForReferenceKey(vehicleReferenceKey)
    if vehicle==nil then return false,"CONTROL_CLEANUP_VEHICLE_UNAVAILABLE" end
    self.driveMechanism:clearRegulationLease(vehicle,ownerTag)
    return true,"CONTROL_CLEANUP_RELEASED"
end

function Control:loadMap()
    local ok,reason=self.driveMechanism:install()
    if not ok then
        local publisher=OuttaMyWay.logPublication
        if publisher~=nil then
            publisher:publish(REGULATION_CONTROL_UNAVAILABLE,function()
                return string.format("physicalMechanism=NativeDriveMechanism reason=%s",tostring(reason))
            end)
        end
    end
end

function Control:deleteMap() end
function Control:update() end
function Control:keyEvent() end
function Control:mouseEvent() end
function Control:draw() end
