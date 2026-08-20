-- FS25_OuttaMyWay v4.7.105 TEST BUILD — D-0146 Step-2 Candidate-owned
-- Local Passage Space / Progressive Passage Search / Passage Arrangement / Passage Guide implementation.
--
-- Established conflict admission is vehicle-name independent.  The planner
-- consumes Situation-owned trajectory/current-positive-physical knowledge and
-- discovers Local Spatial Constraint from the Field World plus every other
-- active Operation assembly.  Passage remains pairwise: third parties constrain
-- which pair arrangement is supportable; they do not become hidden participants
-- in the pair Commitment.
--
-- The passage reserve remains an implementation calibration. Configuration
-- reduction is optional per participant: current represented lateral envelope
-- inside that reserve is retained; only an envelope exceeding it requests
-- compacting. Control revalidates any requested reduction from current Reality.
-- This is not universal architecture and does not manufacture generic
-- negative-clearance authority.

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
        if evidence.conflictIdentity==conflict.identity and evidence.controlProfile=="D0146_OPTIONAL_CONFIGURATION_GUIDED_PASSAGE_V3" then result[#result+1]=item end
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
local function establishedConflicts(picture)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(picture.opposedCorridorKnowledge or {}) do
        if item.classification=="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT" then result[#result+1]=item end
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

local function makeGuide(conflict,aTrajectory,bTrajectory,aSpace,bSpace,aOffset,bOffset,separationM)
    local development=OuttaMyWay.D0146_STEP2_DEVELOPMENT_DISTANCE_M or 12.0
    local traversalMargin=OuttaMyWay.D0146_STEP2_TRAVERSAL_MARGIN_M or 8.0
    local reacquisition=OuttaMyWay.D0146_STEP2_REACQUISITION_DISTANCE_M or 12.0
    local traversal=math.max(development+4.0,separationM*0.5+traversalMargin)
    local gates={
        {kind="DEVELOPMENT_ENTRY",forwardM=development*0.5,lateralFraction=0.5,radiusM=OuttaMyWay.D0146_STEP2_DEVELOPMENT_GATE_RADIUS_M or 2.0},
        {kind="PASSAGE_ARRANGEMENT",forwardM=development,lateralFraction=1.0,radiusM=OuttaMyWay.D0146_STEP2_DEVELOPMENT_GATE_RADIUS_M or 2.0},
        {kind="TRAVERSAL",forwardM=traversal,lateralFraction=1.0,radiusM=OuttaMyWay.D0146_STEP2_TRAVERSAL_GATE_RADIUS_M or 1.0},
        {kind="REACQUISITION_EXIT",forwardM=traversal+reacquisition*0.5,lateralFraction=0.5,radiusM=OuttaMyWay.D0146_STEP2_REACQUISITION_GATE_RADIUS_M or 2.0},
        {kind="NATIVE_REACQUISITION",forwardM=traversal+reacquisition,lateralFraction=0.0,radiusM=OuttaMyWay.D0146_STEP2_REACQUISITION_GATE_RADIUS_M or 2.0}
    }
    local overlap=conflict.supportedCorridorOverlap or {}
    local rightX,rightZ=tonumber(overlap.sharedRightX),tonumber(overlap.sharedRightZ)
    if rightX==nil or rightZ==nil then return nil,"SHARED_PASSAGE_FRAME_UNAVAILABLE" end
    local a0x,a0z=tonumber(aSpace.occupancy and aSpace.occupancy.x),tonumber(aSpace.occupancy and aSpace.occupancy.z)
    local b0x,b0z=tonumber(bSpace.occupancy and bSpace.occupancy.x),tonumber(bSpace.occupancy and bSpace.occupancy.z)
    if not finite(a0x) or not finite(a0z) or not finite(b0x) or not finite(b0z) then return nil,"CURRENT_SPACE_POSE_UNAVAILABLE" end
    for index,gate in ipairs(gates) do
        local af=gate.lateralFraction*aOffset; local bf=gate.lateralFraction*bOffset
        gate.index=index
        gate.subject={assemblyId=conflict.subjectAssemblyId,x=a0x+aTrajectory.establishedDirectionX*gate.forwardM+rightX*af,z=a0z+aTrajectory.establishedDirectionZ*gate.forwardM+rightZ*af,radiusM=gate.radiusM}
        gate.other={assemblyId=conflict.otherAssemblyId,x=b0x+bTrajectory.establishedDirectionX*gate.forwardM+rightX*bf,z=b0z+bTrajectory.establishedDirectionZ*gate.forwardM+rightZ*bf,radiusM=gate.radiusM}
    end
    return {gates=gates,developmentDistanceM=development,traversalDistanceM=traversal,reacquisitionDistanceM=reacquisition},nil
end

local function guideFieldSupport(guide,aSpace,bSpace,fieldWorld)
    if type(fieldWorld)~="table" or type(fieldWorld.boundary)~="table" or OuttaMyWay.ValueRecord.length(fieldWorld.boundary)<3 then return false,"FIELD_WORLD_GEOMETRY_UNAVAILABLE" end
    local stepM=OuttaMyWay.D0146_STEP2_FIELD_SWEEP_SAMPLE_M or 2.0
    local previous={
        subject={x=tonumber(aSpace.occupancy and aSpace.occupancy.x),z=tonumber(aSpace.occupancy and aSpace.occupancy.z)},
        other={x=tonumber(bSpace.occupancy and bSpace.occupancy.x),z=tonumber(bSpace.occupancy and bSpace.occupancy.z)}
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

local function pairSweepSupport(guide,aSpace,bSpace)
    local minimum=math.huge
    local samples=OuttaMyWay.D0146_STEP2_PAIR_SWEEP_SAMPLES_PER_LEG or 20
    local previous={
        subject={x=tonumber(aSpace.occupancy and aSpace.occupancy.x),z=tonumber(aSpace.occupancy and aSpace.occupancy.z)},
        other={x=tonumber(bSpace.occupancy and bSpace.occupancy.x),z=tonumber(bSpace.occupancy and bSpace.occupancy.z)}
    }
    for _,gate in ipairs(guide.gates or {}) do
        for i=0,samples do
            local t=i/samples
            local ax=previous.subject.x+(gate.subject.x-previous.subject.x)*t
            local az=previous.subject.z+(gate.subject.z-previous.subject.z)*t
            local bx=previous.other.x+(gate.other.x-previous.other.x)*t
            local bz=previous.other.z+(gate.other.z-previous.other.z)*t
            minimum=math.min(minimum,distance(ax,az,bx,bz))
        end
        previous.subject={x=gate.subject.x,z=gate.subject.z}; previous.other={x=gate.other.x,z=gate.other.z}
    end
    local required=OuttaMyWay.D0146_STEP2_COMPACT_MIN_CENTRE_SEPARATION_M or 12.0
    if minimum+0.001<required then return false,"COMPACT_PAIR_CENTRE_RESERVE_NOT_SUPPORTED",{minimumCentreSeparationM=minimum,requiredCentreSeparationM=required} end
    return true,nil,{minimumCentreSeparationM=minimum,requiredCentreSeparationM=required,nominalClearanceAuthority="COMPACT_PASSAGE_IMPLEMENTATION_CALIBRATION_CONTROL_REVALIDATED"}
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

local function segmentAgainstThirdParty(ax,az,bx,bz,third,participantReserveM,samplesPerLeg)
    local length=distance(ax,az,bx,bz)
    local count=math.max(samplesPerLeg or 20,math.ceil(length/2.0))
    local minimum=math.huge
    for i=0,count do
        local t=i/count
        local x=ax+(bx-ax)*t; local z=az+(bz-az)*t
        for _,primitive in ipairs(third.primitives) do
            local clearance=distance(x,z,primitive.x,primitive.z)-primitive.radius-participantReserveM
            minimum=math.min(minimum,clearance)
            if clearance<=0 then return false,{x=x,z=z,t=t,clearanceM=clearance,primitive=primitive} end
        end
    end
    return true,{minimumPositivePrimitiveClearanceM=minimum}
end

local function thirdPartyGuideSupport(guide,aSpace,bSpace,picture,conflict)
    local members=operationMembers(picture,conflict.operationId)
    if #members<=2 then return true,nil,{thirdPartyConstraintCount=0,constraints={}} end
    local current=byAssembly(picture.currentSpace)
    local physical=byAssembly(picture.physicalSpaceEvidence)
    local motion=byAssembly(picture.motionEvidence)
    local thirds,reason=thirdPartyPrimitiveRecords(physical,current,motion,members,conflict.subjectAssemblyId,conflict.otherAssemblyId)
    if thirds==nil then return false,reason end
    local pairReserve=OuttaMyWay.D0146_STEP2_COMPACT_MIN_CENTRE_SEPARATION_M or 12.0
    local participantReserve=0.5*pairReserve
    local samples=OuttaMyWay.D0146_STEP2_PAIR_SWEEP_SAMPLES_PER_LEG or 20
    local support={}
    for _,third in ipairs(thirds) do
        local previous={
            subject={x=tonumber(aSpace.occupancy.x),z=tonumber(aSpace.occupancy.z)},
            other={x=tonumber(bSpace.occupancy.x),z=tonumber(bSpace.occupancy.z)}
        }
        local minimum=math.huge
        for _,gate in ipairs(guide.gates or {}) do
            for _,role in ipairs({"subject","other"}) do
                local ok,evidence=segmentAgainstThirdParty(previous[role].x,previous[role].z,gate[role].x,gate[role].z,third,participantReserve,samples)
                if not ok then
                    return false,"LOCAL_SPATIAL_CONSTRAINT_THIRD_PARTY_CURRENT_OCCUPANCY",{assemblyId=third.assemblyId,name=third.name,role=role,gateIndex=gate.index,witness=evidence}
                end
                minimum=math.min(minimum,tonumber(evidence.minimumPositivePrimitiveClearanceM) or math.huge)
            end
            previous.subject={x=gate.subject.x,z=gate.subject.z}; previous.other={x=gate.other.x,z=gate.other.z}
        end
        support[#support+1]={
            assemblyId=third.assemblyId,assemblyReferenceKey=third.assemblyReferenceKey,name=third.name,
            configurationProfileId=third.configurationProfileId,physicalPrimitiveCount=third.physicalPrimitiveCount,
            currentX=third.currentX,currentZ=third.currentZ,maxPositiveRadiusFromReferenceM=third.maxPositiveRadiusFromReferenceM,
            participantCompactReserveM=participantReserve,minimumPositivePrimitiveClearanceM=minimum,
            supportBasis="CURRENT_POSITIVE_THIRD_PARTY_PHYSICAL_OCCUPANCY",negativeClearanceAuthority=false
        }
    end
    return true,nil,{thirdPartyConstraintCount=#support,constraints=support,participantCompactReserveM=participantReserve,dynamicRevalidation="CONTROL_GATE_AND_CURRENT_POSITION"}
end


local function representedLateralReserve(physical,space,rightX,rightZ)
    if type(physical)~="table" or type(space)~="table" or type(space.occupancy)~="table" then return nil,0 end
    local cx,cz=tonumber(space.occupancy.x),tonumber(space.occupancy.z)
    if not finite(cx) or not finite(cz) then return nil,0 end
    local reserve=nil
    local count=0
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical.primitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(tonumber(primitive.x)) and finite(tonumber(primitive.z))
            and finite(tonumber(primitive.radius)) and tonumber(primitive.radius)>0 then
            local px,pz,r=tonumber(primitive.x),tonumber(primitive.z),tonumber(primitive.radius)
            local lateral=math.abs(dot(px-cx,pz-cz,rightX,rightZ))+r
            reserve=reserve==nil and lateral or math.max(reserve,lateral)
            count=count+1
        end
    end
    return reserve,count
end

local function passageConfigurationPlan(conflict,aSpace,bSpace,aPhysical,bPhysical,rightX,rightZ,targetSeparation)
    local compactReserve=0.5*targetSeparation
    local aReserve,aCount=representedLateralReserve(aPhysical,aSpace,rightX,rightZ)
    local bReserve,bCount=representedLateralReserve(bPhysical,bSpace,rightX,rightZ)
    if aReserve==nil or aCount<1 then return nil,"SUBJECT_CURRENT_REPRESENTED_LATERAL_ENVELOPE_UNAVAILABLE" end
    if bReserve==nil or bCount<1 then return nil,"OTHER_CURRENT_REPRESENTED_LATERAL_ENVELOPE_UNAVAILABLE" end
    local function participant(assemblyId,reserve,count)
        local compactRequired=reserve>compactReserve+0.001
        return {
            assemblyId=assemblyId,
            mode=compactRequired and "COMPACT_REQUIRED" or "RETAIN_CURRENT",
            currentRepresentedLateralReserveM=reserve,
            representedPrimitiveCount=count,
            passageReserveM=compactReserve,
            reason=compactRequired and "CURRENT_REPRESENTED_LATERAL_ENVELOPE_EXCEEDS_PASSAGE_RESERVE"
                or "CURRENT_REPRESENTED_LATERAL_ENVELOPE_ALREADY_WITHIN_PASSAGE_RESERVE"
        }
    end
    return {
        policy="OPTIONAL_PER_PARTICIPANT_CONFIGURATION_REDUCTION",
        compactParticipantReserveM=compactReserve,
        participants={
            participant(conflict.subjectAssemblyId,aReserve,aCount),
            participant(conflict.otherAssemblyId,bReserve,bCount)
        },
        negativeClearanceAuthority=false,
        authority="D0146_STEP2_BOUNDED_REPRESENTED_ENVELOPE_CALIBRATION"
    },nil
end

local function arrangementCandidates(currentSigned,targetSeparation)
    local fractions={0.5,0.25,0.75,0.0,1.0}
    local result={}
    for _,desired in ipairs({targetSeparation,-targetSeparation}) do
        local correction=desired-currentSigned
        for _,fraction in ipairs(fractions) do
            local aOffset=-fraction*correction
            local bOffset=(1-fraction)*correction
            result[#result+1]={
                desiredSignedSeparationM=desired,subjectLateralOffsetM=aOffset,otherLateralOffsetM=bOffset,
                combinedLateralBurdenM=math.abs(aOffset)+math.abs(bOffset),maximumParticipantLateralBurdenM=math.max(math.abs(aOffset),math.abs(bOffset))
            }
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
    local minSeparation=OuttaMyWay.D0146_STEP2_LOCAL_PASSAGE_MIN_ENTRY_SEPARATION_M or 50.0
    local maxSeparation=OuttaMyWay.D0146_STEP2_LOCAL_PASSAGE_MAX_ENTRY_SEPARATION_M or 80.0
    if separation==nil then return nil,"CURRENT_PAIR_SEPARATION_UNRESOLVED" end
    if separation>maxSeparation then return nil,"ESTABLISHED_CONFLICT_NOT_YET_LOCAL" end
    if separation<minSeparation then return nil,"LOCAL_PASSAGE_DEVELOPMENT_DISTANCE_INSUFFICIENT" end
    local interacting,encounterIdentity=currentInteraction(picture,conflict.subjectAssemblyId,conflict.otherAssemblyId)
    if interacting then return nil,"CURRENT_PHYSICAL_INTERACTION_ALREADY_BEGUN" end
    local overlap=conflict.supportedCorridorOverlap or {}
    local rightX,rightZ=tonumber(overlap.sharedRightX),tonumber(overlap.sharedRightZ)
    if rightX==nil or rightZ==nil then return nil,"SHARED_PASSAGE_FRAME_UNAVAILABLE" end
    local ax,az=tonumber(aSpace.occupancy and aSpace.occupancy.x),tonumber(aSpace.occupancy and aSpace.occupancy.z)
    local bx,bz=tonumber(bSpace.occupancy and bSpace.occupancy.x),tonumber(bSpace.occupancy and bSpace.occupancy.z)
    if not finite(ax) or not finite(az) or not finite(bx) or not finite(bz) then return nil,"CURRENT_SPACE_POSE_UNAVAILABLE" end
    local currentSigned=dot(bx-ax,bz-az,rightX,rightZ)
    local targetSeparation=OuttaMyWay.D0146_STEP2_COMPACT_PASSAGE_CENTRELINE_SEPARATION_M or 12.0
    local passageConfiguration,configurationReason=passageConfigurationPlan(conflict,aSpace,bSpace,aPhysical,bPhysical,rightX,rightZ,targetSeparation)
    if passageConfiguration==nil then return nil,configurationReason end
    local fieldWorld=snapshot and snapshot.fieldWorld or nil
    local rejected={}
    local arrangements=arrangementCandidates(currentSigned,targetSeparation)
    for index,arrangement in ipairs(arrangements) do
        local guide,guideReason=makeGuide(conflict,aTrajectory,bTrajectory,aSpace,bSpace,arrangement.subjectLateralOffsetM,arrangement.otherLateralOffsetM,separation)
        if guide~=nil then
            local fieldOk,fieldReason,fieldEvidence=guideFieldSupport(guide,aSpace,bSpace,fieldWorld)
            local sweepOk,sweepReason,sweepEvidence=pairSweepSupport(guide,aSpace,bSpace)
            local thirdOk,thirdReason,thirdEvidence=thirdPartyGuideSupport(guide,aSpace,bSpace,picture,conflict)
            if fieldOk and sweepOk and thirdOk then
                arrangement.identity="d0146-arrangement:"..tostring(conflict.identity)..":"..tostring(index)
                arrangement.currentSignedSeparationM=currentSigned
                arrangement.targetCentrelineSeparationM=targetSeparation
                arrangement.boundaryEncroachment=false
                arrangement.configurationReduction="OPTIONAL_PER_PARTICIPANT"
                arrangement.pairwisePassageEconomy={combinedNecessaryInterventionM=arrangement.combinedLateralBurdenM,tieBreak="MINIMUM_MAX_PARTICIPANT_BURDEN_THEN_STABLE_ORDER"}
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
                    separationM=separation,trajectoryDot=conflict.trajectoryDot,
                    representationFitnessIds={fitness[1].representationId,fitness[2].representationId},
                    localPassageSpace={
                        fieldWorldReferenceKey=fieldWorld and fieldWorld.referenceKey or nil,passagePresumption=true,
                        fieldCentrelineSweepSupported=true,boundaryEncroachmentEvaluated=false,boundaryEncroachmentReason="CURRENT_EXPRESSION_DOES_NOT_REQUIRE_MARGIN_USE",
                        thirdPartyConstraints=thirdEvidence and thirdEvidence.constraints or {},
                        thirdPartyConstraintCount=thirdEvidence and thirdEvidence.thirdPartyConstraintCount or 0,
                        thirdPartySupportBasis="CURRENT_POSITIVE_OPERATION_ASSEMBLY_OCCUPANCY"
                    },
                    passageArrangement=arrangement,passageGuide=guide,passageConfiguration=passageConfiguration,
                    progressiveSearch={candidateCount=#arrangements,selectedIndex=index,rejectedBeforeSelection=rejected,satisficed=true,conflictSelection="NEAREST_LOCAL_ESTABLISHED_CONFLICT_FIRST"},
                    controlProfile="D0146_OPTIONAL_CONFIGURATION_GUIDED_PASSAGE_V3",
                    provenance={source="LocalPassagePlanner",layer="CANDIDATE_SUPPORT",decisionAuthority=false,controlAuthority=false,generalVehicleAuthority=false,globalOptimisation=false,vehicleNameAdmissionGate=false}
                },nil
            end
            rejected[#rejected+1]={index=index,fieldReason=fieldReason,sweepReason=sweepReason,thirdPartyReason=thirdReason,thirdPartyEvidence=thirdEvidence}
        else
            rejected[#rejected+1]={index=index,guideReason=guideReason}
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
