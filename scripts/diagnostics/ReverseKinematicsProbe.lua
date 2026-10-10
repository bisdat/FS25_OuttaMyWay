-- Read-only, explicitly DIAGNOSTIC reverse steering and articulation witness.
-- One module owns the finite sensor sample; no Control or admission decisions.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.ReverseKinematicsProbe={}
local Probe=OuttaMyWay.ReverseKinematicsProbe
local INTERVAL_MS=500
local WINDOW_MS=5000
-- Counterfactual look-throughs measured BEYOND the same Return Region.
-- They are observations, never forwarded to GIANTS for actual Control.
local SHADOW_LOOKTHROUGH_M={0,10,20,40}
local function finite(x)
    return type(x)=="number" and x==x and x~=math.huge and x~=-math.huge
end
local function unit(x,z)
    if not finite(x) or not finite(z) then return nil,nil end
    local len=math.sqrt(x*x+z*z)
    if len<0.00001 then return nil,nil end
    return x/len,z/len
end
local function signedAngle(ax,az,bx,bz)
    ax,az=unit(ax,az)
    bx,bz=unit(bx,bz)
    if ax==nil or bx==nil then return nil end
    local cross=ax*bz-az*bx
    local dot=ax*bx+az*bz
    local angle
    if type(math.atan2)=="function" then
        angle=math.atan2(cross,dot)
    elseif math.abs(dot)<0.0000001 then
        angle=cross>=0 and math.pi/2 or -math.pi/2
    else
        angle=math.atan(cross/dot)
        if dot<0 then angle=angle+(cross>=0 and math.pi or -math.pi) end
    end
    return math.deg(angle)
end
local function heading(node)
    if node==nil or node==0 or type(localDirectionToWorld)~="function" then
        return nil,nil
    end
    local ok,x,_,z=pcall(localDirectionToWorld,node,0,0,1)
    if not ok then return nil,nil end
    return unit(x,z)
end
local function position(node)
    if node==nil or node==0 or type(getWorldTranslation)~="function" then
        return nil,nil
    end
    local ok,x,_,z=pcall(getWorldTranslation,node)
    if not ok or not finite(x) or not finite(z) then return nil,nil end
    return x,z
end
local function nodeOrigin(node)
    if node==nil or node==0 or type(getWorldTranslation)~="function" then
        return nil,nil,nil
    end
    local ok,x,y,z=pcall(getWorldTranslation,node)
    if not ok or not finite(x) or not finite(y) or not finite(z) then
        return nil,nil,nil
    end
    return x,y,z
end
local function publish(state,code,fields)
    -- Publication is informational: even a failed logger cannot revoke movement.
    local publisher=state and state.publisher
    if publisher==nil then return end
    pcall(publisher.publish,publisher,"DIAGNOSTIC","INFO",code,function()
        fields.version=OuttaMyWay.VERSION
        return fields
    end)
end
function Probe.begin(vehicle,reverseNode,toolNode,objective,requestedKmh)
    -- No diagnostic sensor work on ordinary NORMAL/DEBUG runs.
    if objective==nil or objective.isReverse~=true
        or type(OuttaMyWay.LogPublication)~="table"
        or type(OuttaMyWay.LogPublication.origin)~="function" then return nil end
    local publisher=OuttaMyWay.LogPublication.origin("REVERSE_KINEMATICS")
    local ok,eligible=pcall(publisher.isEligible,publisher,
        "DIAGNOSTIC","INFO","REVERSE_KINEMATICS_START")
    if not ok or eligible~=true then return nil end
    local rx,rz=heading(reverseNode)
    local tx,tz=heading(toolNode)
    local ox,oz=position(vehicle.rootNode)
    local reverseOriginX,_,reverseOriginZ=nodeOrigin(reverseNode)
    local toolOriginX,_,toolOriginZ=nodeOrigin(toolNode)
    local region=objective.returnRegion
    local clock=finite(g_time) and g_time or nil
    local state={publisher=publisher,vehicle=vehicle,reverseNode=reverseNode,
        toolNode=toolNode,region=region,clock=clock,elapsedMs=0,
        nextSampleMs=0,sampleCount=0,lastSampleX=ox,lastSampleZ=oz,
        lastSampleElapsedMs=0,requestedKmh=requestedKmh,
        originalSteeringTargetX=objective.targetX,
        originalSteeringTargetZ=objective.targetZ}
    publish(state,"REVERSE_KINEMATICS_START",{
        rootId=vehicle.rootNode,
        originX=region.originX,originZ=region.originZ,
        directionX=region.directionX,directionZ=region.directionZ,
        regionRequiredProgressM=region.requiredProgressM,
        steeringTargetX=objective.targetX,steeringTargetZ=objective.targetZ,
        steeringHorizonM=objective.steeringHorizonM,
        requestedReverseKmh=requestedKmh,
        hasToolReverser=toolNode~=nil,
        signedRegionFromReverseDeg=rx and signedAngle(-rx,-rz,
            region.directionX,region.directionZ) or nil,
        -- This is an engine directional-node frame angle, NOT a verified hitch angle.
        initialToolVsReverserNodeDeg=rx and tx and signedAngle(rx,rz,tx,tz) or nil,
        initialRootX=ox,initialRootZ=oz,
        reverseNodeX=reverseOriginX,reverseNodeZ=reverseOriginZ,
        toolNodeX=toolOriginX,toolNodeZ=toolOriginZ,
        additionalSteeringLookthroughM=objective.steeringHorizonM-
            region.requiredProgressM})
    return state
end
-- Sampled only after eligibility and the half-second clock gate.
-- A shadow objective runs the EXACT transform but NEVER calls driveToPoint.
local function hypothetical(state,transform,rawX,rawZ)
    if type(transform)~="function" or type(worldToLocal)~="function" then
        return nil
    end
    local ok,adjustedX,adjustedZ,reason,operands=pcall(transform,
        state.reverseNode,state.toolNode,rawX,rawZ,true)
    if not ok or not finite(adjustedX) or not finite(adjustedZ) then
        return nil
    end
    local _,ry,_=nodeOrigin(state.reverseNode)
    if ry==nil then return nil end
    local good,lx,_,lz=pcall(worldToLocal,state.reverseNode,
        adjustedX,ry,adjustedZ)
    local dx,dz
    if good then dx,dz=unit(lx,lz) end
    if dx==nil then return nil end
    return {adjustedX=adjustedX,adjustedZ=adjustedZ,
        bearing=signedAngle(0,1,dx,dz),
        localX=dx,localZ=dz,operands=operands}
end
function Probe.sample(state,localX,localZ,adjustedX,adjustedZ,dt,
    regionProgressM,regionLateralOffsetM,transform)
    if state==nil or state.sampleCount>=11 then return end
    local elapsed
    if state.clock~=nil and finite(g_time) then
        elapsed=math.max(0,g_time-state.clock)
    else
        state.elapsedMs=state.elapsedMs+(finite(dt) and math.max(dt,0) or 0)
        elapsed=state.elapsedMs
    end
    if elapsed+0.0001<state.nextSampleMs or elapsed>WINDOW_MS then return end
    state.sampleCount=state.sampleCount+1
    state.nextSampleMs=state.nextSampleMs+INTERVAL_MS
    local rx,rz=heading(state.reverseNode)
    local tx,tz=heading(state.toolNode)
    local x,z=position(state.vehicle.rootNode)
    local rnx,_,rnz=nodeOrigin(state.reverseNode)
    local tnx,_,tnz=nodeOrigin(state.toolNode)
    local rootSpeedKmh,motionBearing
    if x~=nil and state.lastSampleX~=nil then
        local dtMs=elapsed-state.lastSampleElapsedMs
        local dx,dz=x-state.lastSampleX,z-state.lastSampleZ
        local length=math.sqrt(dx*dx+dz*dz)
        if dtMs>0 then rootSpeedKmh=length*3600/dtMs end
        if length>0.05 then
            motionBearing=signedAngle(state.region.directionX,
                state.region.directionZ,dx,dz)
        end
    end
    if x~=nil then
        state.lastSampleX,state.lastSampleZ=x,z
        state.lastSampleElapsedMs=elapsed
    end
    local fields={
        rootId=state.vehicle.rootNode,elapsedMs=elapsed,
        rootX=x,rootZ=z,
        sampledRootSpeedKmh=rootSpeedKmh,
        signedActualMotionFromRegionDeg=motionBearing,
        signedRegionFromReverseDeg=rx and signedAngle(-rx,-rz,
            state.region.directionX,state.region.directionZ) or nil,
        toolVsReverserNodeDeg=rx and tx and signedAngle(rx,rz,tx,tz) or nil,
        toolNodePresent=state.toolNode~=nil,
        -- These are the ACTUAL normalised local parameters passed to GIANTS.
        driveLocalX=localX,driveLocalZ=localZ,
        driveLocalSignedBearingDeg=signedAngle(0,1,localX,localZ),
        adjustedWorldTargetX=adjustedX,adjustedWorldTargetZ=adjustedZ,
        regionProgressM=regionProgressM,
        regionLateralOffsetM=regionLateralOffsetM,
        requestedReverseKmh=state.requestedKmh,
        reverseNodeX=rnx,reverseNodeZ=rnz,
        toolNodeX=tnx,toolNodeZ=tnz}
    -- Re-evaluate the actual fixed target once, on this same frame, to
    -- expose its unlogged intermediate GIANTS-equivalent math operands.
    local actual=hypothetical(state,transform,
        state.originalSteeringTargetX,state.originalSteeringTargetZ)
    if actual~=nil then
        fields.recomputedActualDriveBearingDeg=actual.bearing
        fields.recomputedActualAdjustedX=actual.adjustedX
        fields.recomputedActualAdjustedZ=actual.adjustedZ
        fields.actualReconstructionDifferenceDeg=signedAngle(
            localX,localZ,actual.localX,actual.localZ)
        local operands=actual.operands
        if operands~=nil then
            fields.transformToolLongitudinalM=operands.toolLongitudinalM
            fields.transformToolSignedLateralM=operands.toolSignedLateralM
            fields.transformToolDistanceToTargetM=operands.toolDistanceToTargetM
            fields.transformSignedRotationDeg=operands.signedToolFrameRotationDeg
            fields.transformRotatedLateralM=operands.rotatedLateralM
            fields.transformRotatedLongitudinalM=operands.rotatedLongitudinalM
        end
    end
    -- Evaluate 0/10/20/40 m *beyond* the identical 11 m (or relevant)
    -- Return Region. These alternative steering instructions are NEVER sent.
    local region=state.region
    for i=1,#SHADOW_LOOKTHROUGH_M do
        local extra=SHADOW_LOOKTHROUGH_M[i]
        local scale=region.requiredProgressM+extra
        local sx=region.originX+scale*region.directionX
        local sz=region.originZ+scale*region.directionZ
        local shadow=hypothetical(state,transform,sx,sz)
        if shadow~=nil then
            local key="shadowLookthrough"..tostring(extra)
            fields[key.."BearingDeg"]=shadow.bearing
            fields[key.."AdjustedWorldX"]=shadow.adjustedX
            fields[key.."AdjustedWorldZ"]=shadow.adjustedZ
        end
    end
    publish(state,"REVERSE_KINEMATICS_SAMPLE",fields)
end
function Probe.finish(state,reason,progressM,lateralM)
    if state==nil then return end
    local elapsed=state.clock and finite(g_time) and math.max(0,g_time-state.clock)
        or state.elapsedMs
    publish(state,"REVERSE_KINEMATICS_END",{
        rootId=state.vehicle.rootNode,reason=reason,
        elapsedMs=elapsed,samplesPublished=state.sampleCount,
        regionProgressM=progressM,regionLateralOffsetM=lateralM})
end
-- Testable bearing convention: positive = counterclockwise in horizontal x/z.
Probe.signedAngle=signedAngle
