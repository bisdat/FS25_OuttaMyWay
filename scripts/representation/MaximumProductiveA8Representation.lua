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

local function animationPartLateralPotential(part)
    if type(part)~="table" then return false,false end
    local changed,inspected=vectorChanged(part.startTrans,part.endTrans,{1,3})
    if changed then return true,true end

    local _,verticalInspected=vectorChanged(part.startTrans,part.endTrans,{2})
    inspected=inspected or verticalInspected

    local rotationChanged,rotationInspected=vectorChanged(part.startRot,part.endRot,{1,2,3})
    if rotationChanged then return true,true end
    inspected=inspected or rotationInspected

    local scaleChanged,scaleInspected=vectorChanged(part.startScale,part.endScale,{1,2,3})
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
                            reason="SELECTED_FOLDING_ANIMATION_CAN_CHANGE_LATERAL_SPAN",
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

-- Productive-configuration evidence is deliberately independent from fold
-- animation introspection. GIANTS exposes the AI lowering requirement directly
-- on AI implements; XML is a fallback only when the runtime accessor/spec is
-- unavailable.
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

function Representation.build(record,frame,worker,localToWorldFn)
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

    local bounds={}
    local lateralArticulation=false
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

        -- Evidence fusion, not single-flag classification:
        --  * explicit lateral animation evidence is strongest;
        --  * fold/deploy capability + AI needsLowering=true is sufficient
        --    conservative evidence that productive physical configuration may
        --    widen, even when runtime animation internals are opaque;
        --  * needsLowering=false is evidence against a distinct lowered
        --    physical work configuration (TS004 Variofex control);
        --  * unresolved fold semantics with no lowering evidence use the
        --    productive span conservatively rather than suppressing the whole
        --    envelope, provided that span can be observed.
        local memberUsesProductiveSpan=false
        local inferenceReason=nil
        if articulation.status=="SUPPORTED" then
            memberUsesProductiveSpan=true
            inferenceReason="LATERAL_ANIMATION_EVIDENCE"
        elseif foldable and lowering.available==true and lowering.value==true then
            memberUsesProductiveSpan=true
            inferenceReason="FOLD_CAPABILITY_AND_AI_NEEDS_LOWERING"
        elseif lowering.available==true and lowering.value==false then
            memberUsesProductiveSpan=false
            inferenceReason="AI_DOES_NOT_REQUIRE_LOWERED_PRODUCTIVE_CONFIGURATION"
        elseif articulation.status=="NOT_SUPPORTED" or articulation.status=="NOT_PRESENT" then
            memberUsesProductiveSpan=false
            inferenceReason="NO_SUPPORTED_LATERAL_CONFIGURATION_CHANGE"
        elseif foldable then
            memberUsesProductiveSpan=true
            inferenceReason="AMBIGUOUS_FOLD_CONFIGURATION_CONSERVATIVE_WORKING_SPAN"
        else
            memberUsesProductiveSpan=false
            inferenceReason="AUTHORED_PHYSICAL_SPAN_ONLY"
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
            usesProductiveSpan=memberUsesProductiveSpan,
            inferenceReason=inferenceReason
        }
        if memberUsesProductiveSpan then lateralArticulation=true end

        local centreRight=tonumber(metadata.widthOffsetM) or 0
        local centreForward=tonumber(metadata.lengthOffsetM) or 0
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

    local workingWidth=nil
    if lateralArticulation then
        local observation=OuttaMyWay.NativeFieldWorkObservation
        if observation==nil or type(observation.workingWidth)~="function" then
            return nil,"MAXIMUM_PRODUCTIVE_A8_WORKING_SPAN_OBSERVATION_UNAVAILABLE"
        end
        workingWidth=observation.workingWidth(worker)
        local width=workingWidth and tonumber(workingWidth.widthMetres) or nil
        local left=workingWidth and workingWidth.leftPoint or nil
        local right=workingWidth and workingWidth.rightPoint or nil
        if workingWidth==nil or workingWidth.available~=true or not finite(width) or width<=0 then
            return nil,"MAXIMUM_PRODUCTIVE_A8_WORKING_SPAN_UNAVAILABLE"
        end
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
        local halfWidth=width*0.5
        include(bounds,midpoint-halfWidth,leftForward)
        include(bounds,midpoint-halfWidth,rightForward)
        include(bounds,midpoint+halfWidth,leftForward)
        include(bounds,midpoint+halfWidth,rightForward)
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
        lateralArticulation=lateralArticulation,
        lateralArticulationEvidence=articulationEvidence,
        workingWidthM=workingWidth and workingWidth.widthMetres or nil,
        workingWidthSource=workingWidth and workingWidth.source or nil,
        workingSpanMarkerBacked=workingWidth and workingWidth.markerBacked==true or false,
        authority="PASSAGE_NATIVE_A8_CLEARANCE_EXCLUSION",
        claimPermissions={"PASSAGE_NATIVE_A8_CLEARANCE_EXCLUSION"},
        configurationBasis=lateralArticulation
            and "EVIDENCE_FUSED_AUTHORED_PHYSICAL_PLUS_PRODUCTIVE_WORKING_SPAN"
            or "EVIDENCE_FUSED_AUTHORED_PHYSICAL_SPAN",
        geometryPurpose="NATIVE_A8_CLEARANCE_EXCLUSION",
        coverageComplete=false,
        negativeClearanceAuthority=false
    },nil
end
