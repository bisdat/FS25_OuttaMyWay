--- Derives the cached non-underestimating productive-A8 lateral envelope used only to exclude unnecessary Passage.
-- Specification Jurisdictions: `ASSESSMENT_REPRESENTATION`, `COOPERATIVE_PASSAGE`

OuttaMyWay.MaximumProductiveA8Representation={}
local Representation=OuttaMyWay.MaximumProductiveA8Representation

local EPSILON=0.0001

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
end

local function vectorChanged(startValue,endValue,indexes)
    if type(startValue)~="table" or type(endValue)~="table" then return false,false end
    local inspected=false
    for _,index in ipairs(indexes) do
        local a,b=tonumber(startValue[index]),tonumber(endValue[index])
        if finite(a) and finite(b) then
            inspected=true
            if math.abs(a-b)>EPSILON then return true,true end
        end
    end
    return false,inspected
end

local function animationValueLateralPotential(value)
    if type(value)~="table" then return false,false end
    local name=value.name
    if name=="translation" then
        -- GIANTS vehicle-local X is lateral. Y/Z-only translation does not
        -- establish a wider lateral envelope.
        return vectorChanged(value.startValue,value.endValue,{1})
    elseif name=="rotation" then
        -- Rotation about local Y or Z can change plan-view lateral projection.
        -- X-only pitch (for example a rear door) is not lateral-width evidence.
        return vectorChanged(value.startValue,value.endValue,{2,3})
    elseif name=="scale" then
        return vectorChanged(value.startValue,value.endValue,{1})
    end
    return false,false
end

local function animationPartLateralPotential(part)
    if type(part)~="table" then return false,false end

    -- Dynamic AnimatedVehicle parts store loaded start/end values in
    -- part.animationValues rather than as raw XML-shaped fields on the part.
    local values=part.animationValues
    if type(values)=="table" then
        local inspected=false
        for _,value in pairs(values) do
            local changed,valueInspected=animationValueLateralPotential(value)
            if changed then return true,true end
            inspected=inspected or valueInspected
        end
        if inspected then return false,true end
    end

    -- Defensive fallback for any source retaining XML-shaped values.
    local changed,inspected=vectorChanged(part.startTrans,part.endTrans,{1})
    if changed then return true,true end
    local rotationChanged,rotationInspected=vectorChanged(part.startRot,part.endRot,{2,3})
    if rotationChanged then return true,true end
    inspected=inspected or rotationInspected
    local scaleChanged,scaleInspected=vectorChanged(part.startScale,part.endScale,{1})
    if scaleChanged then return true,true end
    inspected=inspected or scaleInspected
    return false,inspected
end

-- Foldability != Lateral Articulation. A selected fold animation must itself
-- show that physical lateral span can change. Pure vertical translation (for
-- example a back door) is deliberately not lateral-articulation evidence.
function Representation.inspectLateralArticulation(object)
    if type(object)~="table" then
        return {status="UNRESOLVED",reason="MEMBER_OBJECT_UNAVAILABLE",foldingPartCount=0}
    end
    local spec=object.spec_foldable
    local foldingParts=type(spec)=="table" and spec.foldingParts or nil
    if type(foldingParts)~="table" then
        return {status="NOT_PRESENT",reason="SELECTED_FOLDING_PARTS_NOT_PRESENT",foldingPartCount=0}
    end

    local foldingPartCount,inspectedAnimationCount,unresolvedAnimationCount=0,0,0
    local animationNames={}
    for _,foldingPart in pairs(foldingParts) do
        if type(foldingPart)=="table" then
            foldingPartCount=foldingPartCount+1
            local animationName=foldingPart.animationName
            local animation=nil
            if type(animationName)=="string" and animationName~="" then
                local ok,value=safeCall(object,"getAnimationByName",animationName)
                if ok and type(value)=="table" then
                    animation=value
                elseif type(object.spec_animatedVehicle)=="table" and type(object.spec_animatedVehicle.animations)=="table" then
                    animation=object.spec_animatedVehicle.animations[animationName]
                end
                animationNames[#animationNames+1]=animationName
            end

            if type(animation)=="table" and type(animation.parts)=="table" then
                local inspectedAny=false
                local unresolvedPart=false
                for _,part in pairs(animation.parts) do
                    local lateral,inspected=animationPartLateralPotential(part)
                    if lateral then
                        table.sort(animationNames)
                        return {
                            status="SUPPORTED",
                            reason="SELECTED_FOLDING_ANIMATION_CAN_CHANGE_PLAN_VIEW_LATERAL_SPAN",
                            foldingPartCount=foldingPartCount,
                            inspectedAnimationCount=inspectedAnimationCount+1,
                            unresolvedAnimationCount=unresolvedAnimationCount,
                            animationNames=animationNames
                        }
                    end
                    if inspected then inspectedAny=true else unresolvedPart=true end
                end
                if inspectedAny and not unresolvedPart then
                    inspectedAnimationCount=inspectedAnimationCount+1
                else
                    unresolvedAnimationCount=unresolvedAnimationCount+1
                end
            else
                unresolvedAnimationCount=unresolvedAnimationCount+1
            end
        end
    end

    table.sort(animationNames)
    if foldingPartCount==0 then
        return {status="NOT_PRESENT",reason="SELECTED_FOLDING_PARTS_EMPTY",foldingPartCount=0,animationNames=animationNames}
    end
    if unresolvedAnimationCount>0 then
        return {
            status="UNRESOLVED",
            reason="SELECTED_FOLDING_ANIMATION_LATERAL_EFFECT_UNRESOLVED",
            foldingPartCount=foldingPartCount,
            inspectedAnimationCount=inspectedAnimationCount,
            unresolvedAnimationCount=unresolvedAnimationCount,
            animationNames=animationNames
        }
    end
    return {
        status="NOT_SUPPORTED",
        reason="SELECTED_FOLDING_ANIMATIONS_DO_NOT_CHANGE_LATERAL_SPAN",
        foldingPartCount=foldingPartCount,
        inspectedAnimationCount=inspectedAnimationCount,
        unresolvedAnimationCount=0,
        animationNames=animationNames
    }
end

-- AI lowering requirement is retained as one orthogonal configuration fact.
-- It neither proves nor disproves lateral physical widening. XML is a fallback
-- only when the runtime accessor/spec is unavailable.
function Representation.inspectNeedsLowering(object)
    if type(object)~="table" then
        return {available=false,value=nil,source="MEMBER_OBJECT_UNAVAILABLE"}
    end

    local ok,value=safeCall(object,"getAINeedsLowering")
    if ok and type(value)=="boolean" then
        return {available=true,value=value,source="GIANTS_GET_AI_NEEDS_LOWERING"}
    end

    local spec=object.spec_aiImplement
    if type(spec)=="table" and type(spec.needsLowering)=="boolean" then
        return {available=true,value=spec.needsLowering,source="GIANTS_AI_IMPLEMENT_SPEC"}
    end

    local xml=object.xmlFile
    if type(xml)=="table" and type(xml.getValue)=="function" then
        local xmlOk,xmlValue=pcall(xml.getValue,xml,"vehicle.ai.needsLowering#value")
        if xmlOk and type(xmlValue)=="boolean" then
            return {available=true,value=xmlValue,source="GIANTS_VEHICLE_XML_AI_NEEDS_LOWERING"}
        end
    end

    return {available=false,value=nil,source="AI_NEEDS_LOWERING_UNAVAILABLE"}
end

local function foldCapabilityPresent(object,articulation)
    if type(articulation)=="table" and tonumber(articulation.foldingPartCount or 0)>0 then return true end
    local spec=type(object)=="table" and object.spec_foldable or nil
    return type(spec)=="table"
end

local function include(bounds,right,forward)
    bounds.minRightM=bounds.minRightM==nil and right or math.min(bounds.minRightM,right)
    bounds.maxRightM=bounds.maxRightM==nil and right or math.max(bounds.maxRightM,right)
    bounds.minForwardM=bounds.minForwardM==nil and forward or math.min(bounds.minForwardM,forward)
    bounds.maxForwardM=bounds.maxForwardM==nil and forward or math.max(bounds.maxForwardM,forward)
end

-- Conservative DISC evidence is used here only to challenge an authored-only
-- maximum. It never becomes Maximum Productive A8 geometry or negative-clearance
-- authority. A DISC span wider than the authored members' own diagonal bounds
-- proves only that authored base dimensions have not explained all current
-- physical possibility.
local function positiveDiscLateralSpan(worldPrimitives,frame)
    local minimum,maximum=nil,nil
    if type(frame)~="table" then return nil end
    for _,primitive in ipairs(worldPrimitives or {}) do
        local x,z,radius=tonumber(primitive.x),tonumber(primitive.z),tonumber(primitive.radius)
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(x) and finite(z) and finite(radius) and radius>0 then
            local dx,dz=x-frame.x,z-frame.z
            local right=dx*frame.rightX+dz*frame.rightZ
            minimum=minimum==nil and right-radius or math.min(minimum,right-radius)
            maximum=maximum==nil and right+radius or math.max(maximum,right+radius)
        end
    end
    if minimum==nil or maximum==nil or maximum<=minimum then return nil end
    return maximum-minimum
end

function Representation.build(record,frame,worker,localToWorldFn,worldPrimitives)
    if type(record)~="table" or type(frame)~="table" then
        return nil,"MAXIMUM_PRODUCTIVE_A8_REFERENCE_FRAME_UNAVAILABLE"
    end
    if record.assemblyDiscoveryTruncated==true then
        return nil,"MAXIMUM_PRODUCTIVE_A8_ASSEMBLY_MEMBERSHIP_TRUNCATED"
    end
    if type(localToWorldFn)~="function" then
        return nil,"MAXIMUM_PRODUCTIVE_A8_LOCAL_TO_WORLD_UNAVAILABLE"
    end
    local members=record.members or {}
    if #members<1 then return nil,"MAXIMUM_PRODUCTIVE_A8_ASSEMBLY_MEMBERS_UNAVAILABLE" end

    local observation=OuttaMyWay.NativeFieldWorkObservation
    local workingWidthObservation=nil
    if observation~=nil and type(observation.workingWidth)=="function" then
        workingWidthObservation=observation.workingWidth(worker)
    end
    local widthEvidenceByRootNode={}
    for _,memberEvidence in ipairs(workingWidthObservation and workingWidthObservation.members or {}) do
        if type(memberEvidence)=="table" and memberEvidence.rootNode~=nil then
            widthEvidenceByRootNode[memberEvidence.rootNode]=memberEvidence
        end
    end

    local bounds={}
    local authoredRadialBounds={}
    local productiveLateralWidening=false
    local unresolvedProductiveLateralRisk=false
    local articulationEvidence={}
    local metadataSources={}

    for _,member in ipairs(members) do
        local metadata=member.directionalSizeMetadata
        local object=member.object
        local width=metadata and tonumber(metadata.widthM) or nil
        local length=metadata and tonumber(metadata.lengthM) or nil
        if not finite(width) or width<=0 or not finite(length) or length<=0
            or type(object)~="table" or object.rootNode==nil or object.rootNode==0 then
            return nil,"MAXIMUM_PRODUCTIVE_A8_BASE_SIZE_UNAVAILABLE:"..tostring(member.referenceKey)
        end

        local articulation=Representation.inspectLateralArticulation(object)
        local lowering=Representation.inspectNeedsLowering(object)
        local foldable=foldCapabilityPresent(object,articulation)
        local widthEvidence=widthEvidenceByRootNode[object.rootNode]
        local intrinsicWidthM=widthEvidence and tonumber(widthEvidence.widthMetres) or nil
        local collisionWidthM=widthEvidence and tonumber(widthEvidence.aiCollisionWidthM) or nil

        -- AI collision width is corroboration, not Maximum Productive A8 geometry.
        -- A configured collision envelope on the same scale as intrinsic productive
        -- width can establish that the latter is not merely agronomic effect reach.
        -- Allow one authored body-width of difference because the GIANTS trigger may
        -- deliberately omit or overhang the central body while still describing the
        -- same configured lateral scale.
        local collisionCorroboratesProductiveSpan=
            finite(intrinsicWidthM) and finite(collisionWidthM)
            and collisionWidthM>width+EPSILON
            and intrinsicWidthM<=collisionWidthM+width+EPSILON

        local memberUsesProductiveSpan=false
        local inferenceReason="AUTHORED_PHYSICAL_SPAN_ONLY"
        if articulation.status=="SUPPORTED" then
            memberUsesProductiveSpan=true
            inferenceReason=collisionCorroboratesProductiveSpan
                and "LATERAL_ANIMATION_AND_AI_COLLISION_CORROBORATION"
                or "LATERAL_ANIMATION_EVIDENCE"
        elseif collisionCorroboratesProductiveSpan then
            memberUsesProductiveSpan=true
            inferenceReason="AI_COLLISION_WIDTH_CORROBORATES_PRODUCTIVE_SPAN"
        elseif articulation.status=="UNRESOLVED" and foldable
            and (not finite(intrinsicWidthM) or intrinsicWidthM>width+EPSILON) then
            unresolvedProductiveLateralRisk=true
            inferenceReason="PRODUCTIVE_LATERAL_EXTENT_UNRESOLVED"
        end

        articulationEvidence[#articulationEvidence+1]={
            memberReferenceKey=member.referenceKey,
            animationStatus=articulation.status,
            animationReason=articulation.reason,
            foldingPartCount=articulation.foldingPartCount or 0,
            animationNames=articulation.animationNames or {},
            foldCapabilityPresent=foldable,
            needsLoweringAvailable=lowering.available==true,
            needsLowering=lowering.value,
            needsLoweringSource=lowering.source,
            intrinsicProductiveWidthM=intrinsicWidthM,
            intrinsicProductiveWidthSource=widthEvidence and widthEvidence.source or nil,
            currentMarkerSpanM=widthEvidence and widthEvidence.currentMarkerSpanM or nil,
            aiMarkerWidthM=widthEvidence and widthEvidence.intrinsicAIMarkerWidthM or nil,
            aiWorkAreaWidthM=widthEvidence and widthEvidence.aiWorkAreaWidthM or nil,
            variableWorkWidthSpanM=widthEvidence and widthEvidence.variableWorkWidthSpanM or nil,
            aiCollisionWidthM=collisionWidthM,
            collisionCorroboratesProductiveSpan=collisionCorroboratesProductiveSpan,
            usesProductiveSpan=memberUsesProductiveSpan,
            inferenceReason=inferenceReason
        }
        if memberUsesProductiveSpan then productiveLateralWidening=true end

        local centreRight=tonumber(metadata.widthOffsetM) or 0
        local centreForward=tonumber(metadata.lengthOffsetM) or 0
        local centreOk,centreX,_,centreZ=pcall(localToWorldFn,object.rootNode,centreRight,0,centreForward)
        if not centreOk or not finite(centreX) or not finite(centreZ) then
            return nil,"MAXIMUM_PRODUCTIVE_A8_MEMBER_CENTRE_TRANSFORM_FAILED:"..tostring(member.referenceKey)
        end
        local centreDx,centreDz=centreX-frame.x,centreZ-frame.z
        local centreLateral=centreDx*frame.rightX+centreDz*frame.rightZ
        local authoredRadius=math.sqrt(width*width+length*length)*0.5
        authoredRadialBounds.minRightM=authoredRadialBounds.minRightM==nil
            and centreLateral-authoredRadius
            or math.min(authoredRadialBounds.minRightM,centreLateral-authoredRadius)
        authoredRadialBounds.maxRightM=authoredRadialBounds.maxRightM==nil
            and centreLateral+authoredRadius
            or math.max(authoredRadialBounds.maxRightM,centreLateral+authoredRadius)

        for _,offset in ipairs({
            {-width*0.5,-length*0.5},{width*0.5,-length*0.5},
            {width*0.5,length*0.5},{-width*0.5,length*0.5}
        }) do
            local ok,x,_,z=pcall(localToWorldFn,object.rootNode,centreRight+offset[1],0,centreForward+offset[2])
            if not ok or not finite(x) or not finite(z) then
                return nil,"MAXIMUM_PRODUCTIVE_A8_MEMBER_TRANSFORM_FAILED:"..tostring(member.referenceKey)
            end
            local dx,dz=x-frame.x,z-frame.z
            include(bounds,dx*frame.rightX+dz*frame.rightZ,dx*frame.forwardX+dz*frame.forwardZ)
        end
        metadataSources[tostring(metadata.source or "UNRESOLVED")]=true
    end

    local authoredBaseRadialSpanM=nil
    if authoredRadialBounds.minRightM~=nil and authoredRadialBounds.maxRightM~=nil then
        authoredBaseRadialSpanM=authoredRadialBounds.maxRightM-authoredRadialBounds.minRightM
    end
    local currentDiscLateralSpanM=positiveDiscLateralSpan(worldPrimitives,frame)
    local physicalSpanContradiction=finite(currentDiscLateralSpanM)
        and finite(authoredBaseRadialSpanM)
        and currentDiscLateralSpanM>authoredBaseRadialSpanM+EPSILON

    local observedWorkingWidthM=workingWidthObservation and tonumber(workingWidthObservation.widthMetres) or nil
    local useWorkingSpan=productiveLateralWidening or physicalSpanContradiction

    if unresolvedProductiveLateralRisk and not useWorkingSpan then
        return nil,"MAXIMUM_PRODUCTIVE_A8_PRODUCTIVE_LATERAL_EXTENT_UNRESOLVED"
    end

    local workingSpanAdmissionReason=productiveLateralWidening
        and "CONFIGURATION_EVIDENCE_REQUIRES_PRODUCTIVE_WORKING_SPAN"
        or (physicalSpanContradiction
            and "CURRENT_PHYSICAL_SPAN_CONTRADICTS_AUTHORED_MAXIMUM"
            or "AUTHORED_PHYSICAL_SPAN_SUFFICIENT")

    local workingWidth=nil
    if useWorkingSpan then
        if observation==nil or type(observation.workingWidth)~="function" then
            return nil,"MAXIMUM_PRODUCTIVE_A8_WORKING_SPAN_OBSERVATION_UNAVAILABLE"
        end
        if workingWidthObservation==nil or workingWidthObservation.available~=true
            or not finite(observedWorkingWidthM) or observedWorkingWidthM<=0 then
            if physicalSpanContradiction then
                return nil,"MAXIMUM_PRODUCTIVE_A8_PHYSICAL_SPAN_CONTRADICTS_AUTHORED_WITHOUT_WORKING_SPAN"
            end
            return nil,"MAXIMUM_PRODUCTIVE_A8_WORKING_SPAN_UNAVAILABLE"
        end
        if physicalSpanContradiction and finite(authoredBaseRadialSpanM)
            and observedWorkingWidthM<=authoredBaseRadialSpanM+EPSILON then
            return nil,"MAXIMUM_PRODUCTIVE_A8_WORKING_SPAN_DOES_NOT_RESOLVE_PHYSICAL_CONTRADICTION"
        end

        local left=workingWidthObservation.leftPoint
        local right=workingWidthObservation.rightPoint
        if type(left)~="table" or type(right)~="table"
            or not finite(tonumber(left.x)) or not finite(tonumber(left.z))
            or not finite(tonumber(right.x)) or not finite(tonumber(right.z)) then
            return nil,"MAXIMUM_PRODUCTIVE_A8_WORKING_SPAN_OFFSETS_UNAVAILABLE"
        end

        local function project(point)
            local dx,dz=tonumber(point.x)-frame.x,tonumber(point.z)-frame.z
            return dx*frame.rightX+dz*frame.rightZ,dx*frame.forwardX+dz*frame.forwardZ
        end
        local leftRight,leftForward=project(left)
        local rightRight,rightForward=project(right)
        local midpoint=(leftRight+rightRight)*0.5
        local halfWidth=observedWorkingWidthM*0.5
        include(bounds,midpoint-halfWidth,leftForward)
        include(bounds,midpoint-halfWidth,rightForward)
        include(bounds,midpoint+halfWidth,leftForward)
        include(bounds,midpoint+halfWidth,rightForward)
        workingWidth=workingWidthObservation
    end

    local width=bounds.maxRightM-bounds.minRightM
    local length=bounds.maxForwardM-bounds.minForwardM
    if not finite(width) or width<=0 or not finite(length) or length<=0 then
        return nil,"MAXIMUM_PRODUCTIVE_A8_ENVELOPE_INVALID"
    end
    local sources={}
    for source in pairs(metadataSources) do sources[#sources+1]=source end
    table.sort(sources)
    return {
        minRightM=bounds.minRightM,maxRightM=bounds.maxRightM,
        minForwardM=bounds.minForwardM,maxForwardM=bounds.maxForwardM,
        leftExtentM=math.max(0,-bounds.minRightM),rightExtentM=math.max(0,bounds.maxRightM),
        frontExtentM=math.max(0,bounds.maxForwardM),rearExtentM=math.max(0,-bounds.minForwardM),
        widthM=width,lengthM=length,halfWidthM=width*0.5,halfLengthM=length*0.5,
        widthOffsetM=(bounds.minRightM+bounds.maxRightM)*0.5,
        lengthOffsetM=(bounds.minForwardM+bounds.maxForwardM)*0.5,
        memberCount=#members,
        metadataSources=table.concat(sources,"|"),
        memberBaseSizeComplete=true,
        lateralArticulation=productiveLateralWidening,
        productiveLateralWidening=productiveLateralWidening,
        lateralArticulationEvidence=articulationEvidence,
        observedWorkingWidthM=observedWorkingWidthM,
        observedWorkingWidthSource=workingWidthObservation and workingWidthObservation.source or nil,
        observedCurrentMarkerSpanM=workingWidthObservation and workingWidthObservation.currentMarkerSpanM or nil,
        observedAIMarkerWidthM=workingWidthObservation and workingWidthObservation.intrinsicAIMarkerWidthM or nil,
        observedAIWorkAreaWidthM=workingWidthObservation and workingWidthObservation.aiWorkAreaWidthM or nil,
        observedVariableWorkWidthSpanM=workingWidthObservation and workingWidthObservation.variableWorkWidthSpanM or nil,
        observedAICollisionWidthM=workingWidthObservation and workingWidthObservation.aiCollisionWidthM or nil,
        workingWidthM=workingWidth and workingWidth.widthMetres or nil,
        workingWidthSource=workingWidth and workingWidth.source or nil,
        workingSpanMarkerBacked=workingWidth and workingWidth.markerBacked==true or false,
        currentDiscLateralSpanM=currentDiscLateralSpanM,
        authoredBaseRadialSpanM=authoredBaseRadialSpanM,
        physicalSpanContradiction=physicalSpanContradiction,
        workingSpanAdmissionReason=workingSpanAdmissionReason,
        authority="PASSAGE_NATIVE_A8_CLEARANCE_EXCLUSION",
        claimPermissions={"PASSAGE_NATIVE_A8_CLEARANCE_EXCLUSION"},
        configurationBasis=workingWidth~=nil
            and "EVIDENCE_FUSED_AUTHORED_PHYSICAL_PLUS_PRODUCTIVE_WORKING_SPAN"
            or "EVIDENCE_FUSED_AUTHORED_PHYSICAL_SPAN",
        provenance={source="MaximumProductiveA8Representation",scope="JOB_EPISODE_STABLE_PRODUCTIVE_A8_MAXIMUM"}
    },"SUPPORTED"
end
