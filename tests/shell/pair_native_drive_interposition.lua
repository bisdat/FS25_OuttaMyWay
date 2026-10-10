-- TS001 0.5.2.9 regression: the two real native-drive wrappers must compose
-- across a fast paired egress (2 m region reached before 5 s Regulation).
-- This is a shell contract, not a GIANTS physical clearance claim.
OuttaMyWay={ProjectedEgressRegion={}}
local events={}
local native=function(vehicle,dt,accel,allowed,forward,x,z,speed,doNotSteer)
    events[#events+1]={vehicle=vehicle,accel=accel,allowed=allowed,
        speed=speed,doNotSteer=doNotSteer}
    return "GIANTS_NATIVE"
end
AIVehicleUtil={driveToPoint=native}
g_server={}
local poses={[1]={x=20,z=20},[2]={x=25,z=20}}
getWorldTranslation=function(node)
    local p=assert(poses[node]);return p.x,0,p.z
end
local a={name="A",rootNode=1,job={}}
local b={name="B",rootNode=2,job={}}
a.getJob=function(self)return self.job end
b.getJob=function(self)return self.job end
dofile("scripts/control/mechanisms/NativeTranslationHoldMechanism.lua")
dofile("scripts/control/mechanisms/NativeSpeedRegulationMechanism.lua")
dofile("scripts/coordination/HoldRelocateCoordinator.lua")
local Hold=OuttaMyWay.NativeTranslationHoldMechanism
local Regulation=OuttaMyWay.NativeSpeedRegulationMechanism
local Coordinator=OuttaMyWay.HoldRelocateCoordinator

-- Document the previous failure without modifying any production mechanism:
-- installing Regulation above active Holds leaves the retired Hold wrapper
-- buried; a relocated Hold request then fails wrapper verification.
local oldHold,oldReg=Hold.new(),Regulation.new()
assert(oldHold:hold(a,"TRANSIT_PREPARATION"))
assert(oldHold:hold(b,"TRANSIT_PREPARATION"))
assert(oldReg:regulate(a,"EGRESS"))
assert(oldHold:releaseHold(a,"TRANSIT_PREPARATION"))
assert(oldHold:releaseHold(b,"TRANSIT_PREPARATION"))
local rejected,reason=oldHold:hold(b,"RELOCATED_WORKER")
assert(not rejected and reason=="NATIVE_DRIVE_WRAPPER_UNVERIFIED",
    "fixture must reproduce .9 observed wrapper-chain rejection")
AIVehicleUtil.driveToPoint=native

local hold,reg=Hold.new(),Regulation.new()
local reverseOriginal,reverseWrapper,regionReached
local originalFace="TRANSIT_PREPARATION"
local physical={
    preflightPair=function()return true end,
    hold=function(_,vehicle,purpose)return hold:hold(vehicle,purpose)end,
    releaseHold=function(_,vehicle,purpose)
        local ok,evidence=hold:releaseHold(vehicle,purpose)
        if ok then reg:refreshInstallation() end
        return ok,evidence
    end,
    requestTransit=function()return true end,
    cancelTransit=function()return true end,
    transitStatus=function()
        return {isSettled=false,requiredFoldCount=1,settledFoldCount=0}
    end,
    pairTransitFootprint=function(_,vehicle)
        local x=poses[vehicle.rootNode].x
        return {rootX=x,rootZ=20,memberCount=1,
            corners={{x=-1,z=-1},{x=1,z=1}},basis="TEST_TRANSIT"}
    end,
    regulate=function(_,vehicle,purpose)
        return reg:regulate(vehicle,purpose)
    end,
    releaseRegulation=function(_,vehicle,purpose)
        return reg:releaseRegulation(vehicle,purpose)
    end,
    startReverse=function()
        reverseOriginal=AIVehicleUtil.driveToPoint
        reverseWrapper=function(...)return reverseOriginal(...)end
        AIVehicleUtil.driveToPoint=reverseWrapper
        regionReached=false
        return true,{requestedReverseSpeedKmh=20}
    end,
    reverseStatus=function()
        return {isComplete=regionReached,isFailed=false,
            travelledM=regionReached and 2 or 0}
    end,
    stopReverse=function()
        assert(AIVehicleUtil.driveToPoint==reverseWrapper)
        AIVehicleUtil.driveToPoint=reverseOriginal
        reverseWrapper=nil
        reg:refreshInstallation()
        return true
    end,
    cancelReverse=function()
        if reverseWrapper~=nil
            and AIVehicleUtil.driveToPoint==reverseWrapper then
            AIVehicleUtil.driveToPoint=reverseOriginal
        end
        reverseWrapper=nil
        reg:refreshInstallation()
        return true
    end,
    restartNativeFieldwork=function()return true,{isNewJobStarted=true}end
}
local authority={
    validateCommitment=function(_,commitment)
        return commitment.token=="issued","COMMITMENT_INVALID"
    end,
    isCommitmentCurrent=function()return true end
}
OuttaMyWay.ProjectedEgressRegion.planPairCascade=function(_,preferred,other)
    return {
        isReverse=true,targetX=other.x-50,targetZ=other.z,
        directionSource="OBLIQUE_REVERSE",cascadeAttempts=8,
        regionTravelM=2,
        returnRegion={source="SIGNED_CROSS_TRACK_REGION",
            directionX=-1,directionZ=0,requiredProgressM=2},
        transitGeometryBasis="TEST_TRANSIT"
    },other,preferred
end
local participantA={vehicle=a,assemblyReferenceKey="A",x=20,z=20}
local participantB={vehicle=b,assemblyReferenceKey="B",x=25,z=20}
local committed={token="issued",commitmentId="PAIR",
    participants={participantA,participantB},
    nearbyBlockers={participantA},
    fieldCentroid={x=0,z=0},
    fieldPolygon={xs={0,100,100,0},zs={0,0,100,100}}}
local coordinator=Coordinator.new(authority,physical)
assert(coordinator:begin(committed,1000))
assert(hold:isHolding(a) and hold:isHolding(b))
assert(AIVehicleUtil.driveToPoint==hold.wrapper)
coordinator:advance(16000)
assert(coordinator:getStatus().phase=="REVERSING")
assert(not hold:isHolding(a) and not hold:isHolding(b)
    and not hold.isInstalled and hold.heldCount==0,
    "preparation Hold wrapper must be uninstalled before Regulation")
assert(reg.count==1 and reverseWrapper~=nil)
-- During commanded reverse, the current blocker remains regulated.
AIVehicleUtil.driveToPoint(a,16,1,true,false,0,1,20,false)
assert(events[#events].vehicle==a and events[#events].speed==1
    and events[#events].allowed==true)
-- The Return Region is reached in less than five seconds, as in TS001.
regionReached=true
coordinator:advance(17781)
assert(coordinator:getStatus().phase=="HOLD_RELOCATED"
    and hold:isHolding(b) and reg.count==1,
    "fast region entry must reacquire the 7-second relocated Hold")
AIVehicleUtil.driveToPoint(b,16,1,true,false,0,1,20,false)
assert(events[#events].allowed==false and events[#events].speed==0)
-- The counterpart speed restriction still has its independent 5 s timer.
coordinator:advance(20999)
assert(reg.count==1)
coordinator:advance(21000)
assert(reg.count==0 and hold:isHolding(b))
AIVehicleUtil.driveToPoint(a,16,1,true,true,0,1,20,false)
assert(events[#events].vehicle==a and events[#events].speed==20)
-- When 7 s Hold finishes the last transparent native wrapper unwinds.
coordinator:advance(24780)
assert(coordinator:getStatus().phase=="HOLD_RELOCATED")
coordinator:advance(24781)
assert(not coordinator:isActive()
    and coordinator:getStatus().lastOutcome.status=="NATIVE_RESTART_ACCEPTED")
assert(AIVehicleUtil.driveToPoint==native
    and hold.heldCount==0 and reg.count==0,
    "native drive must be restored after final Hold and Regulation release")
print("TS001 fast paired egress / native wrapper composition and cleanup: PASS")
