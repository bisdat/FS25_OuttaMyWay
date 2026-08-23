-- FS25_OuttaMyWay v0.1.3.7 TEST — D-0165 Crossing-Window Clearance alignment; D-0163/D-0164 directional envelope and rejection telemetry retained.
-- Candidate-owned Local Passage planning remains vehicle-name independent: Local Passage Space, Progressive Passage Search, Passage Arrangement and Passage Guide remain the governing Candidate concepts.
--
-- Passage Selection may precede physical Passage Entry.  Selection immediately
-- commits Cooperative Passage and supersedes D-0155, restoring the proven
-- v0.1.3.0 authority handoff.  The derived Entry Boundary is consumed later by
-- Cooperative Passage Control's PASSAGE_APPROACH phase; Candidate does not
-- retain uncertainty regulation after the resolution is known.
-- Candidate configuration policy is intentionally inherited unchanged.  From
-- the selected Passage-configured represented geometry the planner derives a
-- non-negative Clearance Deficit, participant excursion, physical Crossing
-- Window from longitudinal extents, and Recovery toward the native lateral
-- axis.  The old P23 12/8/12 guide distances are donor evidence, not geometry.
--
-- Current represented discs remain bounded evidence: translated-disc sweep
-- does not claim exact articulated swept-envelope closure.  Third parties and
-- Field World remain constraints on the pair plan, not hidden participants.

OuttaMyWay.LocalPassagePlanner={}
local Planner=OuttaMyWay.LocalPassagePlanner

local function byAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if item.assemblyId~=nil then result[item.assemblyId]=item end
    end
    return result
end
local function finite(v) return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge end
local function dot(ax,az,bx,bz) return ax*bx+az*bz end
local function distance(ax,az,bx,bz) local dx,dz=bx-ax,bz-az; return math.sqrt(dx*dx+dz*dz) end

local function pointInRing(x,z,ring)
    if type(ring)~="table" or OuttaMyWay.ValueRecord.length(ring)<3 then return false end
    local inside=false
    local j=OuttaMyWay.ValueRecord.length(ring)
    for i=1,OuttaMyWay.ValueRecord.length(ring) do
        local xi,zi=tonumber(ring[i].x),tonumber(ring[i].z)
        local xj,zj=tonumber(ring[j].x),tonumber(ring[j].z)
        if xi~=nil and zi~=nil and xj~=nil and zj~=nil then
            local intersects=((zi>z)~=(zj>z)) and (x < (xj-xi)*(z-zi)/((zj-zi)==0 and 1e-12 or (zj-zi))+xi)
            if intersects then inside=not inside end
        end
        j=i
    end
    return inside
end
local function islandRing(island)
    if type(island)~="table" then return nil end
    if type(island.boundary)=="table" then return island.boundary end
    return island
end
local function pointInField(x,z,fieldWorld)
    if type(fieldWorld)~="table" or not pointInRing(x,z,fieldWorld.boundary) then return false end
    for _,island in OuttaMyWay.ValueRecord.ipairs(fieldWorld.islands or {}) do
        local ring=islandRing(island)
        if ring~=nil and pointInRing(x,z,ring) then return false end
    end
    return true
end

local function segmentInsideField(ax,az,bx,bz,fieldWorld,stepM)
    local length=distance(ax,az,bx,bz)
    local count=math.max(1,math.ceil(length/math.max(0.5,stepM or 2.0)))
    for i=0,count do
        local t=i/count
        local x=ax+(bx-ax)*t; local z=az+(bz-az)*t
        if not pointInField(x,z,fieldWorld) then return false,{x=x,z=z,t=t} end
    end
    return true,nil
end

local function fitnessForConflict(picture,conflict)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(picture.representationFitness or {}) do
        local evidence=item.evidence or {}
        if evidence.conflictIdentity==conflict.identity and evidence.controlProfile=="D0146_PASSAGE_EXCURSION_V6" then result[#result+1]=item end
    end
    table.sort(result,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
    if #result~=2 then return nil,"PURPOSE_SPECIFIC_MECHANICAL_FITNESS_UNAVAILABLE" end
    for _,item in ipairs(result) do
        if item.state~="FIT_FOR_LIMITED_HORIZON" and item.state~="CURRENTLY_FIT" then return nil,"PURPOSE_SPECIFIC_MECHANICAL_FITNESS_NOT_CURRENT" end
    end
    return result,nil
end

local function conflictSeparation(conflict)
    return tonumber(conflict and conflict.currentClosing and conflict.currentClosing.separationM) or math.huge
end
local function longitudinalPairSeparation(aSpace,bSpace,aTrajectory,bTrajectory)
    local ax,az=tonumber(aSpace and aSpace.occupancy and aSpace.occupancy.x),tonumber(aSpace and aSpace.occupancy and aSpace.occupancy.z)
    local bx,bz=tonumber(bSpace and bSpace.occupancy and bSpace.occupancy.x),tonumber(bSpace and bSpace.occupancy and bSpace.occupancy.z)
    local afx,afz=tonumber(aTrajectory and aTrajectory.establishedDirectionX),tonumber(aTrajectory and aTrajectory.establishedDirectionZ)
    local bfx,bfz=tonumber(bTrajectory and bTrajectory.establishedDirectionX),tonumber(bTrajectory and bTrajectory.establishedDirectionZ)
    if not finite(ax) or not finite(az) or not finite(bx) or not finite(bz) or not finite(afx) or not finite(afz) or not finite(bfx) or not finite(bfz) then return nil end
    local aAhead=(bx-ax)*afx+(bz-az)*afz
    local bAhead=(ax-bx)*bfx+(az-bz)*bfz
    if not finite(aAhead) or not finite(bAhead) then return nil end
    return math.max(0,(aAhead+bAhead)*0.5)
end
local function establishedConflicts(picture)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(picture.opposedCorridorKnowledge or {}) do
        if item.classification=="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT" and item.cooperativePassageEligible~=false then result[#result+1]=item end
    end
    table.sort(result,function(a,b)
        local sa,sb=conflictSeparation(a),conflictSeparation(b)
        if math.abs(sa-sb)>0.001 then return sa<sb end
        return tostring(a.identity)<tostring(b.identity)
    end)
    return result
end

local function currentInteraction(picture,aId,bId)
    for _,encounter in OuttaMyWay.ValueRecord.ipairs(picture.encounters or {}) do
        local same=(encounter.subjectAssemblyId==aId and encounter.otherAssemblyId==bId) or (encounter.subjectAssemblyId==bId and encounter.otherAssemblyId==aId)
        if same and encounter.evidence and encounter.evidence.currentSpaceIntersects==true then return true,encounter.identity end
    end
    return false,nil
end

local function operationMembers(picture,operationId)
    for _,situation in OuttaMyWay.ValueRecord.ipairs(picture.situations or {}) do
        if situation.operationId==operationId then
            local ids={}
            for _,id in OuttaMyWay.ValueRecord.ipairs(situation.memberAssemblyIds or {}) do ids[#ids+1]=id end
            table.sort(ids,function(a,b) return tostring(a)<tostring(b) end)
            return ids
        end
    end
    return {}
end

local function directionalEnvelopeBounds(envelope)
    if type(envelope)~="table" then return nil end
    local minRight,maxRight,minForward,maxForward=tonumber(envelope.minRightM),tonumber(envelope.maxRightM),tonumber(envelope.minForwardM),tonumber(envelope.maxForwardM)
    if not finite(minRight) or not finite(maxRight) then
        local half,offset=tonumber(envelope.halfWidthM),tonumber(envelope.widthOffsetM) or 0
        if not finite(half) or half<=0 then return nil end
        minRight,maxRight=offset-half,offset+half
    end
    if not finite(minForward) or not finite(maxForward) then
        local half,offset=tonumber(envelope.halfLengthM),tonumber(envelope.lengthOffsetM) or 0
        if not finite(half) or half<=0 then return nil end
        minForward,maxForward=offset-half,offset+half
    end
    if maxRight<=minRight or maxForward<=minForward then return nil end
    return {minRightM=minRight,maxRightM=maxRight,minForwardM=minForward,maxForwardM=maxForward}
end

local function directionalEnvelopeValid(envelope)
    return directionalEnvelopeBounds(envelope)~=nil
end

local function spaceFrame(space)
    local headingX,headingZ=tonumber(space and space.occupancy and space.occupancy.headingX),tonumber(space and space.occupancy and space.occupancy.headingZ)
    if not finite(headingX) or not finite(headingZ) then return nil end
    local length=math.sqrt(headingX*headingX+headingZ*headingZ); if length<=0.0001 then return nil end
    headingX,headingZ=headingX/length,headingZ/length
    return {forwardX=headingX,forwardZ=headingZ,rightX=headingZ,rightZ=-headingX}
end

local function directionalSupport(envelope,space,axisX,axisZ)
    local bounds=directionalEnvelopeBounds(envelope); local frame=spaceFrame(space)
    if bounds==nil or frame==nil or not finite(axisX) or not finite(axisZ) then return nil end
    local length=math.sqrt(axisX*axisX+axisZ*axisZ); if length<=0.0001 then return nil end
    axisX,axisZ=axisX/length,axisZ/length
    local minimum,maximum=nil,nil
    for _,corner in ipairs({
        {bounds.minRightM,bounds.minForwardM},{bounds.maxRightM,bounds.minForwardM},
        {bounds.maxRightM,bounds.maxForwardM},{bounds.minRightM,bounds.maxForwardM}
    }) do
        local wx=frame.rightX*corner[1]+frame.forwardX*corner[2]
        local wz=frame.rightZ*corner[1]+frame.forwardZ*corner[2]
        local projection=wx*axisX+wz*axisZ
        minimum=minimum==nil and projection or math.min(minimum,projection)
        maximum=maximum==nil and projection or math.max(maximum,projection)
    end
    return {minOffsetM=minimum,maxOffsetM=maximum}
end

local function directionalFacingExtent(envelope,space,rightX,rightZ,sideSign)
    local support=directionalSupport(envelope,space,rightX,rightZ); if support==nil then return nil end
    if sideSign>0 then return math.max(0,support.maxOffsetM) end
    return math.max(0,-support.minOffsetM)
end

local function directionalBasis(envelope)
    if type(envelope)~="table" then return nil end
    if envelope.authority=="GIANTS_BASE_SIZE_TRANSIT_PASSAGE_GEOMETRY" then return "GIANTS_BASE_SIZE_TRANSIT_PASSAGE_GEOMETRY" end
    if envelope.authority=="GIANTS_BASE_SIZE_DIRECTIONAL_PASSAGE_TEST" then return "GIANTS_BASE_SIZE_DIRECTIONAL_ENVELOPE" end
    return "GIANTS_DIRECTIONAL_ASSEMBLY_ENVELOPE"
end

local function longitudinalSupport(discs,directionalEnvelope,space,trajectory,role)
    if directionalEnvelopeValid(directionalEnvelope) then
        local support=directionalSupport(directionalEnvelope,space,tonumber(trajectory and trajectory.establishedDirectionX),tonumber(trajectory and trajectory.establishedDirectionZ))
        if support~=nil then
            return {minOffsetM=support.minOffsetM,maxOffsetM=support.maxOffsetM,frontExtentM=math.max(0,support.maxOffsetM),rearExtentM=math.max(0,-support.minOffsetM),physicalPrimitiveCount=0,basis=directionalBasis(directionalEnvelope)},nil
        end
    end
    local support,reason=OuttaMyWay.PairSpecificPassageClearance.longitudinalSupportFromRelativeDiscs(
        discs,tonumber(trajectory and trajectory.establishedDirectionX),tonumber(trajectory and trajectory.establishedDirectionZ))
    if support==nil then return nil,tostring(role).."_PASSAGE_LONGITUDINAL_SUPPORT:"..tostring(reason) end
    support.basis="CONFIGURATION_CONDITIONED_REPRESENTED_DISCS"
    return support,nil
end

local function excursionGeometry(arrangement,aTrajectory,bTrajectory,aSpace,bSpace,longitudinalSeparationM)
    local aLong,aReason=longitudinalSupport(arrangement.subjectPassageDiscs,arrangement.subjectDirectionalPassageEnvelope,aSpace,aTrajectory,"SUBJECT")
    if aLong==nil then return nil,aReason end
    local bLong,bReason=longitudinalSupport(arrangement.otherPassageDiscs,arrangement.otherDirectionalPassageEnvelope,bSpace,bTrajectory,"OTHER")
    if bLong==nil then return nil,bReason end

    local maximumOffset=math.max(math.abs(tonumber(arrangement.subjectLateralOffsetM) or 0),math.abs(tonumber(arrangement.otherLateralOffsetM) or 0))
    local development=0
    if maximumOffset>0.001 then
        local minimumDevelopment=tonumber(OuttaMyWay.D0146_STEP2_MIN_DEVELOPMENT_DISTANCE_M) or 4.0
        local forwardPerLateral=tonumber(OuttaMyWay.D0146_STEP2_DEVELOPMENT_FORWARD_PER_LATERAL_M) or 2.0
        development=math.max(minimumDevelopment,maximumOffset*forwardPerLateral)
    end
    local recovery=development
    local frontOverlap=aLong.frontExtentM+bLong.frontExtentM
    local rearClear=aLong.rearExtentM+bLong.rearExtentM
    local entryAllowance=tonumber(OuttaMyWay.D0146_STEP2_PASSAGE_ENTRY_CONTROL_ALLOWANCE_M) or 3.0
    local entryBoundary=frontOverlap+2*development+entryAllowance
    local currentSeparation=tonumber(longitudinalSeparationM)
    if not finite(currentSeparation) or currentSeparation<0 then return nil,"CURRENT_PAIR_LONGITUDINAL_SEPARATION_UNRESOLVED" end
    local entryReady=currentSeparation<=entryBoundary
    local approachPerParticipant=entryReady and 0 or math.max(0,(currentSeparation-entryBoundary)*0.5)
    local plannedEntrySeparation=entryReady and currentSeparation or entryBoundary
    local postDevelopmentSeparation=math.max(0,plannedEntrySeparation-2*development)
    local crossingForward=math.max(0,(postDevelopmentSeparation+rearClear)*0.5)
    return {
        maximumParticipantLateralExcursionM=maximumOffset,
        developmentDistanceM=development,recoveryDistanceM=recovery,
        subjectFrontExtentM=aLong.frontExtentM,subjectRearExtentM=aLong.rearExtentM,
        otherFrontExtentM=bLong.frontExtentM,otherRearExtentM=bLong.rearExtentM,
        crossingWindowEntrySeparationM=frontOverlap,crossingWindowRearClearSeparationM=rearClear,
        crossingWindowBasis=(aLong.basis~="CONFIGURATION_CONDITIONED_REPRESENTED_DISCS" and bLong.basis~="CONFIGURATION_CONDITIONED_REPRESENTED_DISCS") and ((aLong.basis=="GIANTS_BASE_SIZE_DIRECTIONAL_ENVELOPE" and bLong.basis=="GIANTS_BASE_SIZE_DIRECTIONAL_ENVELOPE") and "GIANTS_BASE_SIZE_DIRECTIONAL_ENVELOPES" or "GIANTS_DIRECTIONAL_ASSEMBLY_ENVELOPES") or "CONFIGURATION_CONDITIONED_REPRESENTED_LONGITUDINAL_EXTENTS",
        crossingWindowForwardPerParticipantM=crossingForward,
        passageEntryControlAllowanceM=entryAllowance,passageEntryBoundarySeparationM=entryBoundary,
        passageEntryReady=entryReady,approachDistancePerParticipantM=approachPerParticipant,
        plannedEntrySeparationM=plannedEntrySeparation,
        totalForwardDistanceM=development+crossingForward+recovery,
        model="DEVELOPMENT_CROSSING_WINDOW_RECOVERY_EXCURSION",
        clearanceDeficitM=math.max(0,tonumber(arrangement.combinedLateralBurdenM) or 0)
    },nil
end

local function makeGuide(conflict,aTrajectory,bTrajectory,aSpace,bSpace,aOffset,bOffset,geometry)
    if type(geometry)~="table" then return nil,"PASSAGE_EXCURSION_GEOMETRY_UNAVAILABLE" end
    local development=tonumber(geometry.developmentDistanceM) or 0
    local traversal=tonumber(geometry.crossingWindowForwardPerParticipantM) or 0
    local recovery=tonumber(geometry.recoveryDistanceM) or 0
    local traversalRadius=tonumber(OuttaMyWay.D0146_STEP2_TRAVERSAL_GATE_RADIUS_M) or 1.0
    local developmentRadius=math.min(tonumber(OuttaMyWay.D0146_STEP2_DEVELOPMENT_GATE_RADIUS_M) or 2.0,math.max(traversalRadius,development*0.25))
    local recoveryRadius=math.min(tonumber(OuttaMyWay.D0146_STEP2_REACQUISITION_GATE_RADIUS_M) or 2.0,math.max(traversalRadius,recovery*0.25))
    local gates={}
    if development>0.001 then
        gates[#gates+1]={kind="DEVELOPMENT_ENTRY",forwardM=development*0.5,lateralFraction=0.5,radiusM=developmentRadius}
    end
    gates[#gates+1]={kind="CROSSING_WINDOW_ENTRY",forwardM=development,lateralFraction=1.0,radiusM=traversalRadius}
    gates[#gates+1]={kind="CROSSING_WINDOW_EXIT",forwardM=development+traversal,lateralFraction=1.0,radiusM=traversalRadius}
    if recovery>0.001 then
        gates[#gates+1]={kind="RECOVERY_EXIT",forwardM=development+traversal+recovery*0.5,lateralFraction=0.5,radiusM=recoveryRadius}
    end
    gates[#gates+1]={kind="NATIVE_REACQUISITION",forwardM=development+traversal+recovery,lateralFraction=0.0,radiusM=recoveryRadius}

    local overlap=conflict.supportedCorridorOverlap or {}
    local rightX,rightZ=tonumber(overlap.sharedRightX),tonumber(overlap.sharedRightZ)
    if rightX==nil or rightZ==nil then return nil,"SHARED_PASSAGE_FRAME_UNAVAILABLE" end
    local a0x,a0z=tonumber(aSpace.occupancy and aSpace.occupancy.x),tonumber(aSpace.occupancy and aSpace.occupancy.z)
    local b0x,b0z=tonumber(bSpace.occupancy and bSpace.occupancy.x),tonumber(bSpace.occupancy and bSpace.occupancy.z)
    if not finite(a0x) or not finite(a0z) or not finite(b0x) or not finite(b0z) then return nil,"CURRENT_SPACE_POSE_UNAVAILABLE" end
    local approach=tonumber(geometry.approachDistancePerParticipantM) or 0
    a0x=a0x+aTrajectory.establishedDirectionX*approach; a0z=a0z+aTrajectory.establishedDirectionZ*approach
    b0x=b0x+bTrajectory.establishedDirectionX*approach; b0z=b0z+bTrajectory.establishedDirectionZ*approach

    for index,gate in ipairs(gates) do
        local af=gate.lateralFraction*aOffset; local bf=gate.lateralFraction*bOffset
        gate.index=index
        gate.subject={assemblyId=conflict.subjectAssemblyId,x=a0x+aTrajectory.establishedDirectionX*gate.forwardM+rightX*af,z=a0z+aTrajectory.establishedDirectionZ*gate.forwardM+rightZ*af,radiusM=gate.radiusM}
        gate.other={assemblyId=conflict.otherAssemblyId,x=b0x+bTrajectory.establishedDirectionX*gate.forwardM+rightX*bf,z=b0z+bTrajectory.establishedDirectionZ*gate.forwardM+rightZ*bf,radiusM=gate.radiusM}
    end
    return {
        gates=gates,entryOrigins={subject={x=a0x,z=a0z},other={x=b0x,z=b0z}},
        executionFrame={
            sharedRightX=rightX,sharedRightZ=rightZ,
            subjectForwardX=aTrajectory.establishedDirectionX,subjectForwardZ=aTrajectory.establishedDirectionZ,
            otherForwardX=bTrajectory.establishedDirectionX,otherForwardZ=bTrajectory.establishedDirectionZ
        },
        developmentDistanceM=development,traversalDistanceM=traversal,reacquisitionDistanceM=recovery,
        crossingWindow={
            entrySeparationM=geometry.crossingWindowEntrySeparationM,rearClearSeparationM=geometry.crossingWindowRearClearSeparationM,
            forwardPerParticipantM=traversal,reference=geometry.crossingWindowBasis or "PASSAGE_CONFIGURED_REPRESENTED_LONGITUDINAL_EXTENTS"
        },
        passageEntry={ready=geometry.passageEntryReady,boundarySeparationM=geometry.passageEntryBoundarySeparationM,controlAllowanceM=geometry.passageEntryControlAllowanceM,approachDistancePerParticipantM=approach},
        excursionModel=geometry.model,totalForwardDistanceM=geometry.totalForwardDistanceM,clearanceDeficitM=geometry.clearanceDeficitM
    },nil
end

local function guideFieldSupport(guide,aSpace,bSpace,fieldWorld)
    if type(fieldWorld)~="table" or type(fieldWorld.boundary)~="table" or OuttaMyWay.ValueRecord.length(fieldWorld.boundary)<3 then return false,"FIELD_WORLD_GEOMETRY_UNAVAILABLE" end
    local stepM=OuttaMyWay.D0146_STEP2_FIELD_SWEEP_SAMPLE_M or 2.0
    local entryOrigins=guide.entryOrigins or {}
    local previous={
        subject={x=tonumber(entryOrigins.subject and entryOrigins.subject.x) or tonumber(aSpace.occupancy and aSpace.occupancy.x),z=tonumber(entryOrigins.subject and entryOrigins.subject.z) or tonumber(aSpace.occupancy and aSpace.occupancy.z)},
        other={x=tonumber(entryOrigins.other and entryOrigins.other.x) or tonumber(bSpace.occupancy and bSpace.occupancy.x),z=tonumber(entryOrigins.other and entryOrigins.other.z) or tonumber(bSpace.occupancy and bSpace.occupancy.z)}
    }
    for _,gate in ipairs(guide.gates or {}) do
        for _,role in ipairs({"subject","other"}) do
            local p0=previous[role]; local p1=gate[role]
            if not p0 or not finite(p0.x) or not finite(p0.z) or not p1 or not finite(p1.x) or not finite(p1.z) then return false,"PASSAGE_GUIDE_TARGET_UNRESOLVED" end
            local ok,witness=segmentInsideField(p0.x,p0.z,p1.x,p1.z,fieldWorld,stepM)
            if not ok then return false,"LOCAL_SPATIAL_CONSTRAINT_FIELD_BOUNDARY",{role=role,gateIndex=gate.index,witness=witness} end
            previous[role]={x=p1.x,z=p1.z}
        end
    end
    return true,nil,{centrelineFieldSupported=true,boundaryEncroachmentUsed=false,sampleStepM=stepM}
end

local function rectangleCorners(x,z,forwardX,forwardZ,envelope)
    local bounds=directionalEnvelopeBounds(envelope); if bounds==nil then return nil end
    local length=math.sqrt(forwardX*forwardX+forwardZ*forwardZ); if length<=0.0001 then return nil end
    forwardX,forwardZ=forwardX/length,forwardZ/length; local rightX,rightZ=forwardZ,-forwardX
    local result={}
    for _,corner in ipairs({
        {bounds.minRightM,bounds.minForwardM},{bounds.maxRightM,bounds.minForwardM},
        {bounds.maxRightM,bounds.maxForwardM},{bounds.minRightM,bounds.maxForwardM}
    }) do result[#result+1]={x=x+rightX*corner[1]+forwardX*corner[2],z=z+rightZ*corner[1]+forwardZ*corner[2]} end
    return result
end
local function pointSegmentDistance(px,pz,ax,az,bx,bz)
    local vx,vz=bx-ax,bz-az; local denom=vx*vx+vz*vz
    if denom<=1e-12 then return distance(px,pz,ax,az) end
    local t=((px-ax)*vx+(pz-az)*vz)/denom; t=math.max(0,math.min(1,t))
    return distance(px,pz,ax+vx*t,az+vz*t)
end
local function projection(corners,axisX,axisZ)
    local minimum,maximum=nil,nil
    for _,p in ipairs(corners) do local v=p.x*axisX+p.z*axisZ; minimum=minimum==nil and v or math.min(minimum,v); maximum=maximum==nil and v or math.max(maximum,v) end
    return minimum,maximum
end
local function polygonSeparation(a,b)
    local minPenetration=math.huge; local separated=false
    local axes={}
    for _,poly in ipairs({a,b}) do
        for i=1,2 do local p,q=poly[i],poly[i+1]; local ex,ez=q.x-p.x,q.z-p.z; local len=math.sqrt(ex*ex+ez*ez); if len>0.0001 then axes[#axes+1]={x=-ez/len,z=ex/len} end end
    end
    for _,axis in ipairs(axes) do
        local amin,amax=projection(a,axis.x,axis.z); local bmin,bmax=projection(b,axis.x,axis.z)
        local gap=math.max(bmin-amax,amin-bmax)
        if gap>0 then separated=true else minPenetration=math.min(minPenetration,math.min(amax,bmax)-math.max(amin,bmin)) end
    end
    if not separated then return -minPenetration end
    local minimum=math.huge
    for _,pair in ipairs({{a,b},{b,a}}) do
        for _,p in ipairs(pair[1]) do
            for i=1,4 do local q=pair[2][i]; local r=pair[2][i%4+1]; minimum=math.min(minimum,pointSegmentDistance(p.x,p.z,q.x,q.z,r.x,r.z)) end
        end
    end
    return minimum
end
local function directionalRectangleClearance(ax,az,bx,bz,guide,aEnvelope,bEnvelope)
    if not directionalEnvelopeValid(aEnvelope) or not directionalEnvelopeValid(bEnvelope) then return nil end
    local frame=guide.executionFrame or {}
    local afx,afz=tonumber(frame.subjectForwardX),tonumber(frame.subjectForwardZ)
    local bfx,bfz=tonumber(frame.otherForwardX),tonumber(frame.otherForwardZ)
    if not finite(afx) or not finite(afz) or not finite(bfx) or not finite(bfz) then return nil end
    local a=rectangleCorners(ax,az,afx,afz,aEnvelope); local b=rectangleCorners(bx,bz,bfx,bfz,bEnvelope)
    if a==nil or b==nil then return nil end
    return polygonSeparation(a,b)
end

local function pairSweepSupport(guide,aSpace,bSpace,aDiscs,bDiscs,nominalClearanceM,aEnvelope,bEnvelope)
    if type(aDiscs)~="table" or type(bDiscs)~="table" then return false,"CONFIGURATION_CONDITIONED_PAIR_SWEEP_PHYSICAL_UNAVAILABLE" end
    local minimum=math.huge
    local minimumCrossing=math.huge
    local minimumOutsideCrossing=math.huge
    local samples=OuttaMyWay.D0146_STEP2_PAIR_SWEEP_SAMPLES_PER_LEG or 20
    local directional=directionalEnvelopeValid(aEnvelope) and directionalEnvelopeValid(bEnvelope)
    local entryOrigins=guide.entryOrigins or {}
    local previous={
        subject={x=tonumber(entryOrigins.subject and entryOrigins.subject.x) or tonumber(aSpace.occupancy and aSpace.occupancy.x),z=tonumber(entryOrigins.subject and entryOrigins.subject.z) or tonumber(aSpace.occupancy and aSpace.occupancy.z)},
        other={x=tonumber(entryOrigins.other and entryOrigins.other.x) or tonumber(bSpace.occupancy and bSpace.occupancy.x),z=tonumber(entryOrigins.other and entryOrigins.other.z) or tonumber(bSpace.occupancy and bSpace.occupancy.z)}
    }
    local crossingActive=false
    for _,gate in ipairs(guide.gates or {}) do
        local segmentIsCrossing=crossingActive and gate.kind=="CROSSING_WINDOW_EXIT"
        for i=0,samples do
            local t=i/samples
            local ax=previous.subject.x+(gate.subject.x-previous.subject.x)*t
            local az=previous.subject.z+(gate.subject.z-previous.subject.z)*t
            local bx=previous.other.x+(gate.other.x-previous.other.x)*t
            local bz=previous.other.z+(gate.other.z-previous.other.z)*t
            local clearance=directional and directionalRectangleClearance(ax,az,bx,bz,guide,aEnvelope,bEnvelope) or OuttaMyWay.PairSpecificPassageClearance.minimumTranslatedDiscClearance(aDiscs,ax,az,bDiscs,bx,bz)
            if clearance==nil then return false,"PAIR_SWEEP_CLEARANCE_UNRESOLVED" end
            minimum=math.min(minimum,clearance)
            local atCrossingEntry=(gate.kind=="CROSSING_WINDOW_ENTRY" and i==samples)
            local inCrossing=segmentIsCrossing or atCrossingEntry
            if inCrossing then minimumCrossing=math.min(minimumCrossing,clearance) else minimumOutsideCrossing=math.min(minimumOutsideCrossing,clearance) end
        end
        if gate.kind=="CROSSING_WINDOW_ENTRY" then crossingActive=true elseif gate.kind=="CROSSING_WINDOW_EXIT" then crossingActive=false end
        previous.subject={x=gate.subject.x,z=gate.subject.z}; previous.other={x=gate.other.x,z=gate.other.z}
    end
    local required=tonumber(nominalClearanceM) or 1.0
    local acceptanceRatio=tonumber(OuttaMyWay.D0146_PASSAGE_CLEARANCE_ACCEPTANCE_RATIO) or 1.0
    acceptanceRatio=math.max(0,acceptanceRatio)
    local acceptedFloor=required*acceptanceRatio
    -- D-0165 + v0.1.4.7 TEST: Nominal Passage Clearance remains the Crossing-Window construction target, not an exact Boolean equality. The policy floor admits a bounded undershoot while represented non-contact remains hard. Development may build toward the target and Recovery may relinquish it once the physical crossing is positively complete, but represented overlap is never authorised outside the window.
    local function evidence()
        return {minimumRepresentedClearanceM=minimum,minimumOutsideCrossingClearanceM=minimumOutsideCrossing,minimumCrossingWindowClearanceM=minimumCrossing,requiredNominalClearanceM=required,acceptedNominalClearanceFloorM=acceptedFloor,clearanceAcceptanceRatio=acceptanceRatio}
    end
    if minimumOutsideCrossing<-0.001 then
        return false,"PAIR_SPECIFIC_NON_CONTACT_NOT_SUPPORTED_OUTSIDE_CROSSING_WINDOW",evidence()
    end
    if minimumCrossing==math.huge or minimumCrossing+0.001<acceptedFloor then
        return false,"PAIR_SPECIFIC_NOMINAL_CLEARANCE_FLOOR_NOT_SUPPORTED_IN_CROSSING_WINDOW",evidence()
    end
    local supported=evidence()
    supported.clearanceContract="NON_CONTACT_OUTSIDE_CROSSING_WINDOW_NOMINAL_TARGET_WITH_POLICY_FLOOR_INSIDE_CROSSING_WINDOW"
    supported.supportBasis=directional and (((aEnvelope.authority=="GIANTS_BASE_SIZE_TRANSIT_PASSAGE_GEOMETRY") and (bEnvelope.authority=="GIANTS_BASE_SIZE_TRANSIT_PASSAGE_GEOMETRY")) and "TRANSLATED_GIANTS_BASE_SIZE_TRANSIT_PASSAGE_GEOMETRY" or (((aEnvelope.authority=="GIANTS_BASE_SIZE_DIRECTIONAL_PASSAGE_TEST") and (bEnvelope.authority=="GIANTS_BASE_SIZE_DIRECTIONAL_PASSAGE_TEST")) and "TRANSLATED_GIANTS_BASE_SIZE_DIRECTIONAL_ENVELOPES" or "TRANSLATED_GIANTS_DIRECTIONAL_ASSEMBLY_ENVELOPES")) or "TRANSLATED_CONFIGURATION_CONDITIONED_REPRESENTED_DISCS"
    supported.negativeClearanceAuthority=false
    return true,nil,supported
end

local function thirdPartyPrimitiveRecords(physical,current,motion,memberIds,aId,bId)
    local records={}
    for _,assemblyId in ipairs(memberIds or {}) do
        if assemblyId~=aId and assemblyId~=bId then
            local p=physical[assemblyId]
            local c=current[assemblyId]
            local m=motion[assemblyId]
            if type(p)~="table" or type(c)~="table" or type(c.occupancy)~="table" then
                return nil,"THIRD_PARTY_CURRENT_PHYSICAL_SPACE_UNAVAILABLE:"..tostring(assemblyId)
            end
            local cx,cz=tonumber(c.occupancy.x),tonumber(c.occupancy.z)
            if not finite(cx) or not finite(cz) then return nil,"THIRD_PARTY_CURRENT_POSE_UNAVAILABLE:"..tostring(assemblyId) end
            local primitives={}; local maxRadius=0
            for _,primitive in OuttaMyWay.ValueRecord.ipairs(p.primitives or {}) do
                if primitive.kind=="DISC" and primitive.positiveConflictSupport==true and finite(tonumber(primitive.x)) and finite(tonumber(primitive.z)) and finite(tonumber(primitive.radius)) and tonumber(primitive.radius)>0 then
                    local px,pz,r=tonumber(primitive.x),tonumber(primitive.z),tonumber(primitive.radius)
                    primitives[#primitives+1]={x=px,z=pz,radius=r}
                    maxRadius=math.max(maxRadius,distance(cx,cz,px,pz)+r)
                end
            end
            if #primitives==0 then return nil,"THIRD_PARTY_POSITIVE_PHYSICAL_PRIMITIVES_UNAVAILABLE:"..tostring(assemblyId) end
            records[#records+1]={
                assemblyId=assemblyId,assemblyReferenceKey=m and m.assemblyReferenceKey or p.assemblyReferenceKey,
                name=m and m.name or nil,currentX=cx,currentZ=cz,primitives=primitives,
                physicalPrimitiveCount=#primitives,maxPositiveRadiusFromReferenceM=maxRadius,
                configurationProfileId=p.configurationProfileId,negativeClearanceAuthority=false
            }
        end
    end
    return records,nil
end

local function segmentAgainstThirdParty(ax,az,bx,bz,participantDiscs,third,nominalClearanceM,samplesPerLeg)
    local length=distance(ax,az,bx,bz)
    local count=math.max(samplesPerLeg or 20,math.ceil(length/2.0))
    local minimum=math.huge
    for i=0,count do
        local t=i/count
        local x=ax+(bx-ax)*t; local z=az+(bz-az)*t
        local clearance=OuttaMyWay.PairSpecificPassageClearance.minimumTranslatedDiscToWorldClearance(participantDiscs,x,z,third.primitives)
        if clearance==nil then return false,{reason="THIRD_PARTY_CLEARANCE_UNRESOLVED"} end
        minimum=math.min(minimum,clearance)
        if clearance<=nominalClearanceM then return false,{x=x,z=z,t=t,clearanceM=clearance} end
    end
    return true,{minimumRepresentedClearanceM=minimum}
end

local function thirdPartyGuideSupport(guide,aSpace,bSpace,aDiscs,bDiscs,picture,conflict,nominalClearanceM)
    local members=operationMembers(picture,conflict.operationId)
    if #members<=2 then return true,nil,{thirdPartyConstraintCount=0,constraints={}} end
    local current=byAssembly(picture.currentSpace)
    local physical=byAssembly(picture.physicalSpaceEvidence)
    local motion=byAssembly(picture.motionEvidence)
    local thirds,reason=thirdPartyPrimitiveRecords(physical,current,motion,members,conflict.subjectAssemblyId,conflict.otherAssemblyId)
    if thirds==nil then return false,reason end
    local aRadius=OuttaMyWay.PairSpecificPassageClearance.radialReserveFromRelativeDiscs(aDiscs)
    local bRadius=OuttaMyWay.PairSpecificPassageClearance.radialReserveFromRelativeDiscs(bDiscs)
    if aRadius==nil or bRadius==nil then return false,"PARTICIPANT_CONFIGURATION_CONDITIONED_RADIAL_RESERVE_UNAVAILABLE" end
    local participantDiscs={subject=aDiscs,other=bDiscs}
    local samples=OuttaMyWay.D0146_STEP2_PAIR_SWEEP_SAMPLES_PER_LEG or 20
    local support={}
    for _,third in ipairs(thirds) do
        local entryOrigins=guide.entryOrigins or {}
        local previous={
            subject={x=tonumber(entryOrigins.subject and entryOrigins.subject.x) or tonumber(aSpace.occupancy.x),z=tonumber(entryOrigins.subject and entryOrigins.subject.z) or tonumber(aSpace.occupancy.z)},
            other={x=tonumber(entryOrigins.other and entryOrigins.other.x) or tonumber(bSpace.occupancy.x),z=tonumber(entryOrigins.other and entryOrigins.other.z) or tonumber(bSpace.occupancy.z)}
        }
        local minimum=math.huge
        for _,gate in ipairs(guide.gates or {}) do
            for _,role in ipairs({"subject","other"}) do
                local ok,evidence=segmentAgainstThirdParty(previous[role].x,previous[role].z,gate[role].x,gate[role].z,participantDiscs[role],third,nominalClearanceM,samples)
                if not ok then
                    return false,"LOCAL_SPATIAL_CONSTRAINT_THIRD_PARTY_CURRENT_OCCUPANCY",{assemblyId=third.assemblyId,name=third.name,role=role,gateIndex=gate.index,witness=evidence}
                end
                minimum=math.min(minimum,tonumber(evidence.minimumRepresentedClearanceM) or math.huge)
            end
            previous.subject={x=gate.subject.x,z=gate.subject.z}; previous.other={x=gate.other.x,z=gate.other.z}
        end
        support[#support+1]={
            assemblyId=third.assemblyId,assemblyReferenceKey=third.assemblyReferenceKey,name=third.name,
            configurationProfileId=third.configurationProfileId,physicalPrimitiveCount=third.physicalPrimitiveCount,
            currentX=third.currentX,currentZ=third.currentZ,maxPositiveRadiusFromReferenceM=third.maxPositiveRadiusFromReferenceM,
            participantRepresentedRadialReserves={
                {assemblyId=conflict.subjectAssemblyId,reserveM=aRadius},
                {assemblyId=conflict.otherAssemblyId,reserveM=bRadius}
            },
            nominalInterAssemblyClearanceM=nominalClearanceM,minimumRepresentedClearanceM=minimum,
            constraintBasis="CURRENT_POSITIVE_THIRD_PARTY_PHYSICAL_OCCUPANCY",
            supportBasis="CONFIGURATION_CONDITIONED_PARTICIPANT_DISCS_AGAINST_CURRENT_THIRD_PARTY_OCCUPANCY",negativeClearanceAuthority=false
        }
    end
    return true,nil,{thirdPartyConstraintCount=#support,constraints=support,nominalInterAssemblyClearanceM=nominalClearanceM,dynamicRevalidation="CONTROL_GATE_AND_CURRENT_POSITION"}
end

local function facingExtent(support,sideSign)
    if sideSign>0 then return math.max(0,tonumber(support.maxOffsetM) or 0) end
    return math.max(0,-(tonumber(support.minOffsetM) or 0))
end

local function currentParticipantGeometry(physical,space,rightX,rightZ)
    local discs,discReason=OuttaMyWay.PairSpecificPassageClearance.relativeDiscs(physical,space)
    if discs==nil then return nil,discReason end
    local support,supportReason=OuttaMyWay.PairSpecificPassageClearance.lateralSupportFromRelativeDiscs(discs,rightX,rightZ)
    if support==nil then return nil,supportReason end
    local directional=directionalEnvelopeValid(physical.directionalPassageEnvelope) and physical.directionalPassageEnvelope or nil
    return {discs=discs,support=support,directionalEnvelope=directional,configurationProfileId=physical.configurationProfileId,mode="RETAIN_CURRENT"},nil
end

local function compactParticipantGeometry(physical,space,rightX,rightZ,conflictSideSign,currentGeometry)
    local currentEvidence=physical.configurationEvidence or {}
    if currentEvidence.allDeployed~=true then return nil,"CURRENT_CONFIGURATION_NOT_STABLY_DEPLOYED" end
    local currentFacing=currentGeometry.directionalEnvelope and directionalFacingExtent(currentGeometry.directionalEnvelope,space,rightX,rightZ,conflictSideSign) or facingExtent(currentGeometry.support,conflictSideSign)
    local best=nil
    for _,profile in OuttaMyWay.ValueRecord.ipairs(physical.configurationAlternatives or {}) do
        local evidence=profile.configurationEvidence or {}
        if profile.current~=true and evidence.allFolded==true and (tonumber(profile.nativeObservationCount) or 0)>0 then
            local discs=OuttaMyWay.PairSpecificPassageClearance.relativeDiscsFromObservedProfile(profile,space)
            if discs~=nil then
                local support=OuttaMyWay.PairSpecificPassageClearance.lateralSupportFromRelativeDiscs(discs,rightX,rightZ)
                if support~=nil then
                    local directional=directionalEnvelopeValid(profile.directionalPassageEnvelope) and profile.directionalPassageEnvelope or nil
                    local facing=directional and directionalFacingExtent(directional,space,rightX,rightZ,conflictSideSign) or facingExtent(support,conflictSideSign)
                    local release=currentFacing-facing
                    if release>0.001 and (best==nil or release>best.releaseM+0.001 or (math.abs(release-best.releaseM)<=0.001 and tostring(profile.configurationProfileId)<tostring(best.configurationProfileId))) then
                        best={
                            mode="COMPACT_REQUIRED",discs=discs,support=support,directionalEnvelope=directional,configurationProfileId=profile.configurationProfileId,
                            configurationKey=profile.configurationKey,releaseM=release,currentFacingM=currentFacing,selectedFacingM=facing,
                            authority=directional and "GIANTS_BASE_SIZE_DIRECTIONAL_PASSAGE_TEST" or "AI_REACHABLE_PRODUCTIVE_CONFIGURATION_OBSERVED_WITHOUT_OUTTAMYWAY_AUTHORITY"
                        }
                    end
                end
            end
        end
    end
    if best==nil then return nil,"NO_AI_REACHABLE_COMPACT_PROFILE_RELEASES_CONFLICT_SIDE_SPACE" end
    return best,nil
end

local function participantSelection(physical,space,rightX,rightZ,conflictSideSign)
    local current,currentReason=currentParticipantGeometry(physical,space,rightX,rightZ)
    if current==nil then return nil,currentReason end
    local currentFacing=current.directionalEnvelope and directionalFacingExtent(current.directionalEnvelope,space,rightX,rightZ,conflictSideSign) or facingExtent(current.support,conflictSideSign)
    local compact,compactReason=compactParticipantGeometry(physical,space,rightX,rightZ,conflictSideSign,current)
    if compact~=nil then return compact,nil end
    return {
        mode="RETAIN_CURRENT",discs=current.discs,support=current.support,directionalEnvelope=current.directionalEnvelope,configurationProfileId=current.configurationProfileId,
        releaseM=0,currentFacingM=currentFacing,selectedFacingM=currentFacing,authority=current.directionalEnvelope and "GIANTS_BASE_SIZE_DIRECTIONAL_PASSAGE_TEST" or "CURRENT_CONFIGURATION_RETAINED",reason=compactReason
    },nil
end

local function configurationConditionedPair(pairClearance,aPhysical,aSpace,bPhysical,bSpace,rightX,rightZ,nominalClearanceM)
    local function relation(sign)
        local aSelection,aReason=participantSelection(aPhysical,aSpace,rightX,rightZ,sign)
        if aSelection==nil then return nil,"SUBJECT_CONFIGURATION_SELECTION:"..tostring(aReason) end
        local bSelection,bReason=participantSelection(bPhysical,bSpace,rightX,rightZ,-sign)
        if bSelection==nil then return nil,"OTHER_CONFIGURATION_SELECTION:"..tostring(bReason) end
        local contact=aSelection.selectedFacingM+bSelection.selectedFacingM
        return {
            relationSign=sign,subjectFacingExtentM=aSelection.selectedFacingM,otherFacingExtentM=bSelection.selectedFacingM,
            physicalContactThresholdM=contact,nominalInterAssemblyClearanceM=nominalClearanceM,policyRequiredSeparationM=contact+nominalClearanceM,
            subjectConfiguration=aSelection,otherConfiguration=bSelection,
            subjectDirectionalPassageEnvelope=aSelection.directionalEnvelope,otherDirectionalPassageEnvelope=bSelection.directionalEnvelope,
            representationBasis=(aSelection.directionalEnvelope and bSelection.directionalEnvelope) and ((aSelection.directionalEnvelope.authority=="GIANTS_BASE_SIZE_DIRECTIONAL_PASSAGE_TEST" and bSelection.directionalEnvelope.authority=="GIANTS_BASE_SIZE_DIRECTIONAL_PASSAGE_TEST") and "GIANTS_BASE_SIZE_DIRECTIONAL_ENVELOPES" or "GIANTS_DIRECTIONAL_ASSEMBLY_ENVELOPES") or "CONFIGURATION_CONDITIONED_FROM_NATIVE_OBSERVED_PROFILES",
            configurationReleasedSpaceM=(aSelection.releaseM or 0)+(bSelection.releaseM or 0)
        },nil
    end
    local positive,pReason=relation(1); if positive==nil then return nil,pReason end
    local negative,nReason=relation(-1); if negative==nil then return nil,nReason end
    local current=pairClearance.currentSignedSeparationM>=0 and positive or negative
    return {
        currentSignedSeparationM=pairClearance.currentSignedSeparationM,currentLateralSeparationM=pairClearance.currentLateralSeparationM,currentRelationSign=current.relationSign,
        subjectFacingExtentM=current.subjectFacingExtentM,otherFacingExtentM=current.otherFacingExtentM,physicalContactThresholdM=current.physicalContactThresholdM,
        nominalInterAssemblyClearanceM=nominalClearanceM,policyRequiredSeparationM=current.policyRequiredSeparationM,policyReserveM=pairClearance.currentLateralSeparationM-current.policyRequiredSeparationM,
        positiveRelation=positive,negativeRelation=negative,baselineCurrentConfiguration=pairClearance,
        representationBasis=current.representationBasis or "CONFIGURATION_CONDITIONED_FROM_NATIVE_OBSERVED_PROFILES",coverageComplete=false,negativeClearanceAuthority=false
    },nil
end

local function transitConditionedPair(pairClearance,legacyPair,aPhysical,aSpace,bPhysical,bSpace,rightX,rightZ,nominalClearanceM)
    local aEnvelope=type(aPhysical)=="table" and aPhysical.transitPassageEnvelope or nil
    local bEnvelope=type(bPhysical)=="table" and bPhysical.transitPassageEnvelope or nil
    if not directionalEnvelopeValid(aEnvelope) then return nil,"SUBJECT_TRANSIT_BASE_GEOMETRY_UNAVAILABLE:"..tostring(aPhysical and aPhysical.transitPassageReason or "UNRESOLVED") end
    if not directionalEnvelopeValid(bEnvelope) then return nil,"OTHER_TRANSIT_BASE_GEOMETRY_UNAVAILABLE:"..tostring(bPhysical and bPhysical.transitPassageReason or "UNRESOLVED") end
    if type(legacyPair)~="table" then return nil,"LEGACY_CONFIGURATION_CONTROL_PLAN_UNAVAILABLE" end

    local function relation(sign)
        local aFacing=directionalFacingExtent(aEnvelope,aSpace,rightX,rightZ,sign)
        local bFacing=directionalFacingExtent(bEnvelope,bSpace,rightX,rightZ,-sign)
        if not finite(aFacing) then return nil,"SUBJECT_TRANSIT_FACING_EXTENT_UNAVAILABLE" end
        if not finite(bFacing) then return nil,"OTHER_TRANSIT_FACING_EXTENT_UNAVAILABLE" end
        local legacyRelation=sign>0 and legacyPair.positiveRelation or legacyPair.negativeRelation
        if type(legacyRelation)~="table" then return nil,"LEGACY_CONFIGURATION_RELATION_UNAVAILABLE" end
        local contact=aFacing+bFacing
        return {
            relationSign=sign,subjectFacingExtentM=aFacing,otherFacingExtentM=bFacing,physicalContactThresholdM=contact,
            nominalInterAssemblyClearanceM=nominalClearanceM,policyRequiredSeparationM=contact+nominalClearanceM,
            subjectConfiguration=legacyRelation.subjectConfiguration,otherConfiguration=legacyRelation.otherConfiguration,
            subjectDirectionalPassageEnvelope=aEnvelope,otherDirectionalPassageEnvelope=bEnvelope,
            representationBasis="GIANTS_BASE_SIZE_TRANSIT_PASSAGE_GEOMETRY",configurationReleasedSpaceM=legacyRelation.configurationReleasedSpaceM or 0
        },nil
    end

    local positive,pReason=relation(1); if positive==nil then return nil,pReason end
    local negative,nReason=relation(-1); if negative==nil then return nil,nReason end
    local current=pairClearance.currentSignedSeparationM>=0 and positive or negative
    return {
        currentSignedSeparationM=pairClearance.currentSignedSeparationM,currentLateralSeparationM=pairClearance.currentLateralSeparationM,currentRelationSign=current.relationSign,
        subjectFacingExtentM=current.subjectFacingExtentM,otherFacingExtentM=current.otherFacingExtentM,physicalContactThresholdM=current.physicalContactThresholdM,
        nominalInterAssemblyClearanceM=nominalClearanceM,policyRequiredSeparationM=current.policyRequiredSeparationM,policyReserveM=pairClearance.currentLateralSeparationM-current.policyRequiredSeparationM,
        positiveRelation=positive,negativeRelation=negative,baselineCurrentConfiguration=pairClearance,legacyConfigurationControlPair=legacyPair,
        representationBasis="GIANTS_BASE_SIZE_TRANSIT_PASSAGE_GEOMETRY",planningGeometrySource="TRANSIT_BASE",coverageComplete=false,negativeClearanceAuthority=false
    },nil
end

local function passageConfigurationPlan(conflict,arrangement)
    local function participant(assemblyId,selection)
        return {
            assemblyId=assemblyId,mode=selection.mode,currentFacingClearanceExtentM=selection.currentFacingM,selectedFacingClearanceExtentM=selection.selectedFacingM,
            configurationReleasedSpaceM=selection.releaseM or 0,currentConfigurationProfileId=selection.mode=="RETAIN_CURRENT" and selection.configurationProfileId or nil,
            expectedCompactConfigurationProfileId=selection.mode=="COMPACT_REQUIRED" and selection.configurationProfileId or nil,
            configurationAuthority=selection.authority,reason=selection.reason
        }
    end
    return {
        policy="CONFIGURATION_RELEASED_SPACE_PRECEDES_LATERAL_DISPLACEMENT",selection="AI_REACHABLE_PRODUCTIVE_CONFIGURATION_WHEN_CONFLICT_SIDE_RELEASE_POSITIVE",
        participants={participant(conflict.subjectAssemblyId,arrangement.subjectConfiguration),participant(conflict.otherAssemblyId,arrangement.otherConfiguration)},
        selectedRelationSign=arrangement.relationSign,configurationReleasedSpaceEvaluated=true,
        totalConfigurationReleasedSpaceM=(arrangement.subjectConfiguration.releaseM or 0)+(arrangement.otherConfiguration.releaseM or 0),
        negativeClearanceAuthority=false,authority="D0146_CONFIGURATION_FIRST_PAIR_SPECIFIC_CLEARANCE_TEST"
    },nil
end

local function arrangementCandidates(currentSigned,pairClearance)
    local fractions={0.5,0.25,0.75,0.0,1.0}
    local result={}
    local currentRelation=currentSigned>=0 and pairClearance.positiveRelation or pairClearance.negativeRelation
    local function append(relation,aOffset,bOffset,alreadySufficient)
        result[#result+1]={
            relationSign=relation.relationSign,desiredSignedSeparationM=alreadySufficient and currentSigned or relation.relationSign*relation.policyRequiredSeparationM,
            subjectLateralOffsetM=aOffset,otherLateralOffsetM=bOffset,combinedLateralBurdenM=math.abs(aOffset)+math.abs(bOffset),maximumParticipantLateralBurdenM=math.max(math.abs(aOffset),math.abs(bOffset)),
            currentSeparationAlreadySufficient=alreadySufficient==true,subjectFacingExtentM=relation.subjectFacingExtentM,otherFacingExtentM=relation.otherFacingExtentM,
            physicalContactThresholdM=relation.physicalContactThresholdM,nominalInterAssemblyClearanceM=relation.nominalInterAssemblyClearanceM,policyRequiredSeparationM=relation.policyRequiredSeparationM,
            subjectConfiguration=relation.subjectConfiguration,otherConfiguration=relation.otherConfiguration,configurationReleasedSpaceM=relation.configurationReleasedSpaceM,
            subjectPassageDiscs=relation.subjectConfiguration.discs,otherPassageDiscs=relation.otherConfiguration.discs,
            subjectDirectionalPassageEnvelope=relation.subjectDirectionalPassageEnvelope,otherDirectionalPassageEnvelope=relation.otherDirectionalPassageEnvelope
        }
    end
    if math.abs(currentSigned)+0.001>=currentRelation.policyRequiredSeparationM then
        append(currentRelation,0,0,true)
    else
        for _,relation in ipairs({pairClearance.positiveRelation,pairClearance.negativeRelation}) do
            local desired=relation.relationSign*relation.policyRequiredSeparationM
            local correction=desired-currentSigned
            for _,fraction in ipairs(fractions) do append(relation,-fraction*correction,(1-fraction)*correction,false) end
        end
    end
    table.sort(result,function(a,b)
        if math.abs(a.combinedLateralBurdenM-b.combinedLateralBurdenM)>0.001 then return a.combinedLateralBurdenM<b.combinedLateralBurdenM end
        if math.abs(a.maximumParticipantLateralBurdenM-b.maximumParticipantLateralBurdenM)>0.001 then return a.maximumParticipantLateralBurdenM<b.maximumParticipantLateralBurdenM end
        if a.desiredSignedSeparationM~=b.desiredSignedSeparationM then return a.desiredSignedSeparationM>b.desiredSignedSeparationM end
        return a.subjectLateralOffsetM<b.subjectLateralOffsetM
    end)
    return result
end

local function planConflict(picture,snapshot,conflict)
    local fitness,fitnessReason=fitnessForConflict(picture,conflict)
    if fitness==nil then return nil,fitnessReason end
    local trajectories=byAssembly(picture.trajectoryKnowledge)
    local spaces=byAssembly(picture.currentSpace)
    local motion=byAssembly(picture.motionEvidence)
    local physical=byAssembly(picture.physicalSpaceEvidence)
    local aTrajectory,bTrajectory=trajectories[conflict.subjectAssemblyId],trajectories[conflict.otherAssemblyId]
    local aSpace,bSpace=spaces[conflict.subjectAssemblyId],spaces[conflict.otherAssemblyId]
    local aMotion,bMotion=motion[conflict.subjectAssemblyId],motion[conflict.otherAssemblyId]
    local aPhysical,bPhysical=physical[conflict.subjectAssemblyId],physical[conflict.otherAssemblyId]
    if not aTrajectory or not bTrajectory or not aSpace or not bSpace or not aMotion or not bMotion or not aPhysical or not bPhysical then return nil,"PASSAGE_INPUT_KNOWLEDGE_INCOMPLETE" end
    local closing=conflict.currentClosing or {}
    local separation=tonumber(closing.separationM)
    local maxSeparation=OuttaMyWay.D0146_STEP2_LOCAL_PASSAGE_MAX_ENTRY_SEPARATION_M or 80.0
    if separation==nil then return nil,"CURRENT_PAIR_SEPARATION_UNRESOLVED" end
    if separation>maxSeparation then return nil,"ESTABLISHED_CONFLICT_NOT_YET_LOCAL" end
    local interacting,encounterIdentity=currentInteraction(picture,conflict.subjectAssemblyId,conflict.otherAssemblyId)
    if interacting then return nil,"CURRENT_PHYSICAL_INTERACTION_ALREADY_BEGUN" end
    local overlap=conflict.supportedCorridorOverlap or {}
    local rightX,rightZ=tonumber(overlap.sharedRightX),tonumber(overlap.sharedRightZ)
    if rightX==nil or rightZ==nil then return nil,"SHARED_PASSAGE_FRAME_UNAVAILABLE" end
    local ax,az=tonumber(aSpace.occupancy and aSpace.occupancy.x),tonumber(aSpace.occupancy and aSpace.occupancy.z)
    local bx,bz=tonumber(bSpace.occupancy and bSpace.occupancy.x),tonumber(bSpace.occupancy and bSpace.occupancy.z)
    if not finite(ax) or not finite(az) or not finite(bx) or not finite(bz) then return nil,"CURRENT_SPACE_POSE_UNAVAILABLE" end
    local longitudinalSeparation=longitudinalPairSeparation(aSpace,bSpace,aTrajectory,bTrajectory)
    if not finite(longitudinalSeparation) then return nil,"CURRENT_PAIR_LONGITUDINAL_SEPARATION_UNRESOLVED" end
    local nominalClearance=tonumber(OuttaMyWay.D0146_NOMINAL_INTER_ASSEMBLY_CLEARANCE_M) or 1.0
    local baselinePairClearance,clearanceReason=OuttaMyWay.PairSpecificPassageClearance.currentPair(aPhysical,aSpace,bPhysical,bSpace,rightX,rightZ,nominalClearance)
    if baselinePairClearance==nil then return nil,"PAIR_SPECIFIC_PASSAGE_CLEARANCE_UNAVAILABLE:"..tostring(clearanceReason) end
    local legacyPairClearance,conditionReason=configurationConditionedPair(baselinePairClearance,aPhysical,aSpace,bPhysical,bSpace,rightX,rightZ,nominalClearance)
    if legacyPairClearance==nil then return nil,"CONFIGURATION_CONDITIONED_PAIR_CLEARANCE_UNAVAILABLE:"..tostring(conditionReason) end
    local transitPairClearance,transitReason=transitConditionedPair(baselinePairClearance,legacyPairClearance,aPhysical,aSpace,bPhysical,bSpace,rightX,rightZ,nominalClearance)
    local pairClearance=transitPairClearance or legacyPairClearance
    pairClearance.planningGeometrySource=transitPairClearance~=nil and "TRANSIT_BASE" or "LEGACY_CONFIGURATION_CONDITIONED"
    pairClearance.transitGeometryFallbackReason=transitPairClearance==nil and transitReason or nil
    local currentSigned=pairClearance.currentSignedSeparationM
    local fieldWorld=snapshot and snapshot.fieldWorld or nil
    local rejected={}
    local arrangements=arrangementCandidates(currentSigned,pairClearance)
    for index,arrangement in ipairs(arrangements) do
        local geometry,geometryReason=excursionGeometry(arrangement,aTrajectory,bTrajectory,aSpace,bSpace,longitudinalSeparation)
        local guide,guideReason=nil,nil
        if geometry~=nil then
            guide,guideReason=makeGuide(conflict,aTrajectory,bTrajectory,aSpace,bSpace,arrangement.subjectLateralOffsetM,arrangement.otherLateralOffsetM,geometry)
        else
            guideReason=geometryReason
        end
        if guide~=nil then
            local fieldOk,fieldReason,fieldEvidence=guideFieldSupport(guide,aSpace,bSpace,fieldWorld)
            local sweepOk,sweepReason,sweepEvidence=pairSweepSupport(guide,aSpace,bSpace,arrangement.subjectPassageDiscs,arrangement.otherPassageDiscs,nominalClearance,arrangement.subjectDirectionalPassageEnvelope,arrangement.otherDirectionalPassageEnvelope)
            local thirdOk,thirdReason,thirdEvidence=thirdPartyGuideSupport(guide,aSpace,bSpace,arrangement.subjectPassageDiscs,arrangement.otherPassageDiscs,picture,conflict,nominalClearance)
            if fieldOk and sweepOk and thirdOk then
                arrangement.identity="d0146-arrangement:"..tostring(conflict.identity)..":"..tostring(index)
                arrangement.currentSignedSeparationM=currentSigned
                arrangement.targetCentrelineSeparationM=arrangement.policyRequiredSeparationM
                arrangement.currentLateralSeparationM=pairClearance.currentLateralSeparationM
                arrangement.currentRelationPolicyReserveM=pairClearance.policyReserveM
                arrangement.currentPolicyReserveM=pairClearance.policyReserveM
                arrangement.boundaryEncroachment=false
                arrangement.configurationReduction="OPTIONAL_PER_PARTICIPANT"
                arrangement.directionalPassageEnvelopeBasis=pairClearance.representationBasis
                arrangement.passageGeometrySource=pairClearance.planningGeometrySource
                arrangement.transitGeometryFallbackReason=pairClearance.transitGeometryFallbackReason
                arrangement.pairwisePassageEconomy={combinedNecessaryInterventionM=arrangement.combinedLateralBurdenM,tieBreak="MINIMUM_MAX_PARTICIPANT_BURDEN_THEN_STABLE_ORDER"}
                local passageConfiguration,configurationReason=passageConfigurationPlan(conflict,arrangement)
                if passageConfiguration==nil then return nil,configurationReason end
                guide.identity="d0146-guide:"..tostring(conflict.identity)..":"..tostring(index)
                guide.fieldSupport=fieldEvidence
                guide.pairSweepSupport=sweepEvidence
                guide.thirdPartySupport=thirdEvidence
                return {
                    status="SUPPORTED",reason="D0146_SUFFICIENT_LOCAL_PASSAGE_ARRANGEMENT_FOUND",
                    authority="D0146_STEP2_ACTIVE_TEST",
                    conflictIdentity=conflict.identity,operationId=conflict.operationId,encounterIdentity=encounterIdentity,
                    assemblyIds={conflict.subjectAssemblyId,conflict.otherAssemblyId},
                    subjectAssemblyId=conflict.subjectAssemblyId,otherAssemblyId=conflict.otherAssemblyId,
                    subjectReferenceKey=aTrajectory.assemblyReferenceKey,otherReferenceKey=bTrajectory.assemblyReferenceKey,
                    subjectJobToken=aTrajectory.jobToken,otherJobToken=bTrajectory.jobToken,
                    subjectName=aMotion.name,otherName=bMotion.name,
                    subjectStartX=ax,subjectStartZ=az,otherStartX=bx,otherStartZ=bz,
                    separationM=separation,longitudinalSeparationM=longitudinalSeparation,trajectoryDot=conflict.trajectoryDot,
                    representationFitnessIds={fitness[1].representationId,fitness[2].representationId},
                    localPassageSpace={
                        fieldWorldReferenceKey=fieldWorld and fieldWorld.referenceKey or nil,passagePresumption=true,
                        fieldCentrelineSweepSupported=true,boundaryEncroachmentEvaluated=false,boundaryEncroachmentReason="CURRENT_EXPRESSION_DOES_NOT_REQUIRE_MARGIN_USE",
                        thirdPartyConstraints=thirdEvidence and thirdEvidence.constraints or {},
                        thirdPartyConstraintCount=thirdEvidence and thirdEvidence.thirdPartyConstraintCount or 0,
                        thirdPartySupportBasis="CURRENT_POSITIVE_OPERATION_ASSEMBLY_OCCUPANCY"
                    },
                    passageArrangement=arrangement,passageGuide=guide,passageConfiguration=passageConfiguration,pairSpecificPassageClearance=pairClearance,
                    passageEntry={
                        ready=geometry.passageEntryReady,boundarySeparationM=geometry.passageEntryBoundarySeparationM,
                        controlAllowanceM=geometry.passageEntryControlAllowanceM,approachDistancePerParticipantM=geometry.approachDistancePerParticipantM,
                        selectionSeparationM=separation,selectionLongitudinalSeparationM=longitudinalSeparation,plannedEntrySeparationM=geometry.plannedEntrySeparationM
                    },
                    passageExcursion={
                        model=geometry.model,clearanceDeficitM=geometry.clearanceDeficitM,maximumParticipantLateralExcursionM=geometry.maximumParticipantLateralExcursionM,
                        developmentDistanceM=geometry.developmentDistanceM,recoveryDistanceM=geometry.recoveryDistanceM,totalForwardDistanceM=geometry.totalForwardDistanceM,
                        crossingWindowEntrySeparationM=geometry.crossingWindowEntrySeparationM,crossingWindowRearClearSeparationM=geometry.crossingWindowRearClearSeparationM,
                        crossingWindowForwardPerParticipantM=geometry.crossingWindowForwardPerParticipantM,
                        subjectFrontExtentM=geometry.subjectFrontExtentM,subjectRearExtentM=geometry.subjectRearExtentM,
                        otherFrontExtentM=geometry.otherFrontExtentM,otherRearExtentM=geometry.otherRearExtentM,crossingWindowBasis=geometry.crossingWindowBasis
                    },
                    progressiveSearch={candidateCount=#arrangements,selectedIndex=index,rejectedBeforeSelection=rejected,satisficed=true,conflictSelection="NEAREST_LOCAL_ESTABLISHED_CONFLICT_FIRST"},
                    controlProfile="D0146_PASSAGE_EXCURSION_V6",
                    provenance={source="LocalPassagePlanner",layer="CANDIDATE_SUPPORT",decisionAuthority=false,controlAuthority=false,generalVehicleAuthority=false,globalOptimisation=false,vehicleNameAdmissionGate=false}
                },nil
            end
            -- v0.1.4.6 telemetry retained: evidence already computed by the
            -- normal Candidate pass so diagnostics can expose NO -> YES -> NO
            -- clearance behaviour without repeating any geometric work.
            rejected[#rejected+1]={
                index=index,fieldReason=fieldReason,sweepReason=sweepReason,thirdPartyReason=thirdReason,thirdPartyEvidence=thirdEvidence,
                sweepEvidence=sweepEvidence,separationM=separation,longitudinalSeparationM=longitudinalSeparation,
                currentLateralSeparationM=pairClearance.currentLateralSeparationM,relationSign=arrangement.relationSign,
                subjectLateralOffsetM=arrangement.subjectLateralOffsetM,otherLateralOffsetM=arrangement.otherLateralOffsetM,
                physicalContactThresholdM=arrangement.physicalContactThresholdM,policyRequiredSeparationM=arrangement.policyRequiredSeparationM,
                subjectConfigurationMode=arrangement.subjectConfiguration and arrangement.subjectConfiguration.mode or nil,
                otherConfigurationMode=arrangement.otherConfiguration and arrangement.otherConfiguration.mode or nil,
                passageGeometrySource=pairClearance.planningGeometrySource,transitGeometryFallbackReason=pairClearance.transitGeometryFallbackReason
            }
        else
            rejected[#rejected+1]={
                index=index,guideReason=guideReason,separationM=separation,longitudinalSeparationM=longitudinalSeparation,
                currentLateralSeparationM=pairClearance.currentLateralSeparationM,relationSign=arrangement.relationSign,
                subjectLateralOffsetM=arrangement.subjectLateralOffsetM,otherLateralOffsetM=arrangement.otherLateralOffsetM,
                physicalContactThresholdM=arrangement.physicalContactThresholdM,policyRequiredSeparationM=arrangement.policyRequiredSeparationM,
                subjectConfigurationMode=arrangement.subjectConfiguration and arrangement.subjectConfiguration.mode or nil,
                otherConfigurationMode=arrangement.otherConfiguration and arrangement.otherConfiguration.mode or nil,
                passageGeometrySource=pairClearance.planningGeometrySource,transitGeometryFallbackReason=pairClearance.transitGeometryFallbackReason
            }
        end
    end
    return nil,"LOCAL_PASSAGE_SPACE_EXHAUSTED_WITHIN_SUPPORTED_PROFILE",rejected
end

function Planner.plan(picture,snapshot)
    if OuttaMyWay.D0146_STEP2_COOPERATIVE_PASSAGE_ENABLED~=true then return nil,"D0146_STEP2_DISABLED" end
    local conflicts=establishedConflicts(picture)
    if #conflicts==0 then return nil,"NO_ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT" end
    local firstReason=nil
    local allRejected={}
    for _,conflict in ipairs(conflicts) do
        local plan,reason,rejected=planConflict(picture,snapshot,conflict)
        if plan~=nil then return plan,nil end
        if firstReason==nil then firstReason=reason end
        allRejected[#allRejected+1]={conflictIdentity=conflict.identity,reason=reason,rejected=rejected}
    end
    return nil,firstReason or "NO_SUPPORTED_LOCAL_PASSAGE_FOR_ESTABLISHED_CONFLICTS",allRejected
end
