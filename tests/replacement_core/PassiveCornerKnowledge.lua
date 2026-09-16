-- Focused Situation contracts, registered by the replacement-core harness.
-- Synthetic geometry challenges the measurement hypothesis, not GIANTS Reality.
return function(test,equal,fixtures)
    local Value=OuttaMyWay.ValueRecord
    local Packet=Value.define("PassiveCornerFixture",{"value"},{})
    local function sealed(value) return Packet.new({value=value}).value end
    local function canonical(value) return Value.canonical(Packet.new({value=value})) end
    local function world(boundary,islands)
        local result,reason=OuttaMyWay.FieldWorldSnapshotRegistry.canonicalizeBoundary(boundary or {
            {x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}
        },islands or {},0.1)
        assert(result,reason)
        result.geometryFingerprint=result.fingerprint
        result.fieldPolygonReferenceKey="field-world-polygon:"..result.canonicalizationVersion..":"..result.fingerprint
        return result
    end
    local function future(id,x,z,ex,ez)
        local lengthM=math.sqrt((ex-x)^2+(ez-z)^2)
        return {assemblyId=id,identity="future:"..id,alternatives={{kind="FIELD_WORLD_BOUNDED_LOCAL_CONTINUATION",
            startX=x,startZ=z,endX=ex,endZ=ez,headingX=(ex-x)/lengthM,headingZ=(ez-z)/lengthM,
            boundaryDistance=lengthM,boundarySource="FIELD_WORLD_OUTER_BOUNDARY",intentEpoch=1}}}
    end
    local function motion(id,widthM)
        return {assemblyId=id,assemblyReferenceKey="ref:"..id,sourceJobToken="job:"..id,intentEpoch=1,
            reportedSpeedMps=id=="AS-A" and 5 or 4,localIntentClassification="SETTLED_CONTINUATION",
            nativeFieldWork={workingWidth={available=true,widthMetres=widthM,source="GIANTS_WORKING_WIDTH_ACCESSOR",
                authority="PROVISIONAL_DEMAND_SEED_INPUT_ONLY"}}}
    end
    local function input()
        return {operationId="OR-1",fieldWorldReferenceKey="FW-1",fieldWorld=world(),assemblyIds={"AS-A","AS-B"},
            observationSnapshotId="OBS-1",observationEpoch=1,futureSpace={future("AS-A",95,50,95,0),future("AS-B",50,5,100,5)},
            motionEvidence={motion("AS-A",10),motion("AS-B",36)},
            productiveContinuationKnowledge={{assemblyId="AS-A",jobToken="job:AS-A",productivePositive=true,isTurn=false},
                {assemblyId="AS-B",jobToken="job:AS-B",productivePositive=true,isTurn=false}},physicalSpaceEvidence={}}
    end
    local function physical(x,z,radius)
        return {{assemblyId="AS-A",primitives={{identity="DISC-A",kind="DISC",positiveConflictSupport=true,
            x=x or 95,z=z or 5,radius=radius or 1}},negativeClearanceAuthority=false}}
    end
    local function assess(assessment,values)
        return assessment:assess(sealed(values))
    end
    local function count(values) return Value.length(values) end
    local function edgeExtent(entry,isHorizontal)
        for _,edge in Value.ipairs(entry.incidentEdges) do
            if (math.abs(edge.directionZ)<0.001)==isHorizontal then return edge.extentM end
        end
    end
    local function engaged()
        local assessment=OuttaMyWay.SpatialConstraintAssessment.new()
        local values=input(); values.physicalSpaceEvidence=physical()
        local knowledge=assess(assessment,values)
        equal(count(knowledge.cornerKnowledge.engagements),1)
        return assessment,values,knowledge
    end
    local function turn(assessment,values)
        values.observationSnapshotId="OBS-TURN"
        values.observationEpoch=2
        values.productiveContinuationKnowledge[1].productivePositive=false
        values.productiveContinuationKnowledge[1].isTurn=true
        values.motionEvidence[1].localIntentClassification="TURNING"
        values.futureSpace={}; values.physicalSpaceEvidence={}
        return assess(assessment,values)
    end
    local function reacquire(values,path)
        values.observationSnapshotId="OBS-A8"
        values.observationEpoch=3
        values.productiveContinuationKnowledge[1].productivePositive=true
        values.productiveContinuationKnowledge[1].isTurn=false
        values.motionEvidence[1].localIntentClassification="SETTLED_CONTINUATION"
        values.futureSpace={path or future("AS-A",90,10,0,10)}
    end

    test("Corner Atlas: Category-1 discovery learns cross-corridor 36 m and 10 m extents",function()
        local result=assess(OuttaMyWay.SpatialConstraintAssessment.new(),input()).cornerKnowledge
        equal(count(result.atlasEntries),1)
        local entry=result.atlasEntries[1]
        equal(entry.vertex.x,100); equal(entry.vertex.z,0)
        equal(edgeExtent(entry,true),36); equal(edgeExtent(entry,false),10)
        equal(entry.envelope.authority,"PROVISIONAL_DEMAND_SEED_INPUT_ONLY")
        equal(result.decisionAuthority,false); equal(result.controlAuthority,false)
    end)

    test("Corner Atlas: open-field intersection on nonincident edges discovers nothing",function()
        local values=input()
        values.futureSpace={future("AS-A",10,60,100,60),future("AS-B",90,90,0,45)}
        local result=assess(OuttaMyWay.SpatialConstraintAssessment.new(),values)
        equal(result.pairRelationships[1].spatialOverlay,"OPEN_FIELD")
        equal(count(result.cornerKnowledge.atlasEntries),0)
    end)

    test("Corner Atlas: nonintersecting bounded axes and Category-2 do not discover corners",function()
        local values=input()
        values.futureSpace={future("AS-A",90,50,90,0),future("AS-B",95,5,100,5)}
        local assessment=OuttaMyWay.SpatialConstraintAssessment.new()
        equal(count(assess(assessment,values).cornerKnowledge.atlasEntries),0)
        values.futureSpace={future("AS-A",50,50,50,0),future("AS-B",20,30,50,0)}
        local result=assess(assessment,values)
        equal(result.pairRelationships[1].spatialOverlay,"CATEGORY_2_HEADLAND_BOUNDARY")
        equal(count(result.cornerKnowledge.atlasEntries),0)
    end)

    test("Corner Atlas: representative ring rotation and reversal retain exact spatial identity",function()
        local assessment=OuttaMyWay.SpatialConstraintAssessment.new(); local values=input()
        local original=assess(assessment,values).cornerKnowledge.atlasEntries[1]
        local ring=values.fieldWorld.boundary
        for _,order in Value.ipairs({{3,4,1,2},{2,1,4,3}}) do
            values.fieldWorld=world({ring[order[1]],ring[order[2]],ring[order[3]],ring[order[4]]})
            local result=assess(assessment,values).cornerKnowledge
            equal(count(result.atlasEntries),1)
            equal(result.atlasEntries[1].cornerKey,original.cornerKey)
            equal(count(result.events),0)
        end
    end)

    test("Corner Envelope: positive enlargement is monotonic, attributed and detached from old publication",function()
        local assessment=OuttaMyWay.SpatialConstraintAssessment.new(); local values=input()
        local original=assess(assessment,values).cornerKnowledge.atlasEntries[1]
        values.motionEvidence[2].nativeFieldWork.workingWidth.widthMetres=42
        values.observationSnapshotId="OBS-WIDER"
        local result=assess(assessment,values).cornerKnowledge
        equal(edgeExtent(result.atlasEntries[1],true),42)
        equal(edgeExtent(original,true),36)
        equal(count(result.events),1); equal(result.events[1].kind,"CORNER_ENVELOPE_ENLARGED")
        equal(result.events[1].assemblyId,"AS-B"); equal(result.events[1].observationSnapshotId,"OBS-WIDER")
        values.motionEvidence[1].nativeFieldWork.workingWidth.widthMetres=2
        values.motionEvidence[2].nativeFieldWork.workingWidth.widthMetres=3
        result=assess(assessment,values).cornerKnowledge
        equal(edgeExtent(result.atlasEntries[1],true),42); equal(edgeExtent(result.atlasEntries[1],false),10)
        equal(count(result.events),0)
    end)

    test("Corner Envelope: missing positive width leaves only its cross dimension unresolved",function()
        local values=input(); values.motionEvidence[1].nativeFieldWork.workingWidth.available=false
        values.physicalSpaceEvidence=physical()
        local result=assess(OuttaMyWay.SpatialConstraintAssessment.new(),values).cornerKnowledge
        equal(count(result.atlasEntries),1)
        equal(edgeExtent(result.atlasEntries[1],true),36); equal(edgeExtent(result.atlasEntries[1],false),nil)
        equal(count(result.engagements),0)
    end)

    test("Corner Engagement: positive represented overlap establishes worker/job-scoped engagement",function()
        local _,_,result=engaged()
        local record=result.cornerKnowledge.engagements[1]
        equal(record.assemblyId,"AS-A"); equal(record.sourceJobToken,"job:AS-A")
        equal(record.entryEvidence.primitiveId,"DISC-A")
        equal(record.hasObservedManoeuvring,false); equal(record.isDepartureGateOpen,false)
    end)

    test("Corner Engagement: missing overlap and FI negative or unresolved cannot clear engagement",function()
        local assessment,values=engaged()
        values.physicalSpaceEvidence={}
        values.futureSpace={future("AS-A",90,50,90,0),future("AS-B",95,5,100,5)}
        local result=assess(assessment,values)
        equal(result.pairRelationships[1].relationshipStatus,"NEGATIVE")
        equal(count(result.cornerKnowledge.engagements),1)
        values.futureSpace={}
        result=assess(assessment,values)
        equal(result.pairRelationships[1].relationshipStatus,"UNRESOLVED")
        equal(count(result.cornerKnowledge.engagements),1)
        equal(count(result.cornerKnowledge.positiveDepartures),0)
    end)

    test("Corner Engagement: TURNING and reverse preserve engagement without repeated event noise",function()
        local assessment,values=engaged()
        local result=turn(assessment,values).cornerKnowledge
        equal(count(result.engagements),1); equal(result.engagements[1].hasObservedManoeuvring,true)
        equal(result.engagements[1].isDepartureGateOpen,false)
        equal(result.events[1].kind,"CORNER_MANOEUVRING_OBSERVED")
        values.motionEvidence[1].motionClassification="REVERSE"
        values.motionEvidence[1].headingX=-1; values.motionEvidence[1].headingZ=0
        result=assess(assessment,values).cornerKnowledge
        equal(count(result.engagements),1); equal(count(result.events),0)
    end)

    test("Corner Departure: A8 before manoeuvring cannot discharge even with exit topology",function()
        local assessment,values=engaged(); reacquire(values)
        local result=assess(assessment,values).cornerKnowledge
        equal(count(result.engagements),1); equal(count(result.positiveDepartures),0)
        equal(result.engagements[1].departureReason,"MANOEUVRING_NOT_OBSERVED")
    end)

    test("Corner Departure: fresh A8 on either stored incident edge does not discharge",function()
        for _,path in Value.ipairs({future("AS-A",95,10,95,0),future("AS-A",90,5,100,5)}) do
            local assessment,values=engaged(); turn(assessment,values); reacquire(values,path)
            local result=assess(assessment,values).cornerKnowledge
            equal(count(result.engagements),1); equal(count(result.positiveDepartures),0)
            equal(result.engagements[1].isDepartureGateOpen,true)
            equal(result.engagements[1].departureReason,"CONTINUATION_TERMINATES_ON_INCIDENT_EDGE")
        end
    end)

    test("Corner Departure: corner still ahead on a nonincident terminating axis does not discharge",function()
        local assessment,values=engaged(); turn(assessment,values)
        -- A diagonal top-edge exit can leave the corner ahead of the fresh axis.
        reacquire(values,future("AS-A",10,1,99,100))
        local result=assess(assessment,values).cornerKnowledge
        equal(count(result.engagements),1); equal(count(result.positiveDepartures),0)
        equal(result.engagements[1].departureReason,"CORNER_NOT_POSITIVELY_BEHIND_AXIS")
    end)

    test("Corner Departure: post-TURNING fresh A8 plus both spatial witnesses retires engagement only",function()
        local assessment,values=engaged(); turn(assessment,values); reacquire(values)
        local result=assess(assessment,values).cornerKnowledge
        equal(count(result.engagements),0); equal(count(result.atlasEntries),1)
        equal(count(result.positiveDepartures),1)
        local departure=result.positiveDepartures[1]
        equal(departure.isDepartureGateOpen,true)
        equal(departure.cornerAlongAxisM,-10)
        equal(departure.departureReason,"CORNER_BEHIND_AXIS_AND_NON_INCIDENT_TERMINATION")
        equal(result.events[2].kind,"POSITIVE_CORNER_DEPARTURE")
        values.physicalSpaceEvidence=physical()
        result=assess(assessment,values).cornerKnowledge
        equal(count(result.engagements),0); equal(count(result.events),0)
    end)

    test("Corner Departure: old observation, wrong job and mismatched continuation cannot supply fresh A8",function()
        for _,kind in Value.ipairs({"OLD_OBSERVATION","OLD_EPOCH","WRONG_JOB","WRONG_INTENT","NO_A8","NO_TOPOLOGY"}) do
            local assessment,values=engaged(); turn(assessment,values); reacquire(values)
            if kind=="OLD_OBSERVATION" then values.observationSnapshotId="OBS-TURN"
            elseif kind=="OLD_EPOCH" then values.observationEpoch=1
            elseif kind=="WRONG_JOB" then values.productiveContinuationKnowledge[1].jobToken="old-job"
            elseif kind=="WRONG_INTENT" then values.futureSpace[1].alternatives[1].intentEpoch=2
            elseif kind=="NO_A8" then values.productiveContinuationKnowledge={}
            else values.futureSpace={} end
            local result=assess(assessment,values).cornerKnowledge
            equal(count(result.engagements),1,kind); equal(count(result.positiveDepartures),0,kind)
        end
    end)

    test("Corner Engagement: new source job cannot inherit engagement or manoeuvring history",function()
        local assessment,values=engaged(); turn(assessment,values)
        values.motionEvidence[1].sourceJobToken="new-job"
        values.productiveContinuationKnowledge[1].jobToken="new-job"
        reacquire(values)
        local result=assess(assessment,values).cornerKnowledge
        equal(count(result.engagements),0); equal(count(result.positiveDepartures),0)
        values.physicalSpaceEvidence=physical()
        result=assess(assessment,values).cornerKnowledge
        equal(count(result.engagements),1)
        equal(result.engagements[1].sourceJobToken,"new-job")
        equal(result.engagements[1].hasObservedManoeuvring,false)
    end)

    test("Corner Atlas: Operation turnover and pair disappearance retain the exact polygon knowledge",function()
        local assessment,values,original=engaged()
        values.assemblyIds={}; values.futureSpace={}
        equal(count(assess(assessment,values).cornerKnowledge.atlasEntries),1)
        values.operationId="OR-NEW"; values.fieldWorldReferenceKey="FW-NEW"; values.assemblyIds={"AS-A"}
        local result=assess(assessment,values).cornerKnowledge
        equal(count(result.atlasEntries),1)
        equal(result.atlasEntries[1].cornerKey,original.cornerKnowledge.atlasEntries[1].cornerKey)
        equal(count(result.engagements),1)
    end)

    test("Corner Atlas: different or unresolved polygon identity cannot inherit retained knowledge",function()
        local assessment,values=engaged()
        values.futureSpace={}
        values.fieldWorld=world({{x=0,z=0},{x=101,z=0},{x=101,z=100},{x=0,z=100}})
        local result=assess(assessment,values).cornerKnowledge
        equal(count(result.atlasEntries),0); equal(count(result.engagements),0)
        values.fieldWorld.fieldPolygonReferenceKey=nil
        result=assess(assessment,values).cornerKnowledge
        equal(result.status,"POLYGON_IDENTITY_UNRESOLVED")
        equal(count(result.atlasEntries),0)
        values.fieldWorld=world()
        equal(count(assess(assessment,values).cornerKnowledge.atlasEntries),1)
        assessment:reset()
        equal(count(assess(assessment,values).cornerKnowledge.atlasEntries),0)
    end)

    test("Corner Envelope: represented disc requires positive support and Field World containment",function()
        for _,kind in Value.ipairs({"OUTSIDE_FIELD","IN_ISLAND","NO_PERMISSION","EDGE_OVERLAP"}) do
            local values=input()
            values.physicalSpaceEvidence=physical(95,5)
            if kind=="OUTSIDE_FIELD" then values.physicalSpaceEvidence=physical(101,5,0.5)
            elseif kind=="IN_ISLAND" then values.fieldWorld=world(nil,{{points={{x=90,z=2},{x=98,z=2},{x=98,z=8},{x=90,z=8}}}})
            elseif kind=="NO_PERMISSION" then values.physicalSpaceEvidence[1].primitives[1].positiveConflictSupport=false
            else values.physicalSpaceEvidence=physical(95,11,2) end
            local result=assess(OuttaMyWay.SpatialConstraintAssessment.new(),values).cornerKnowledge
            equal(count(result.atlasEntries),1)
            equal(count(result.engagements),kind=="EDGE_OVERLAP" and 1 or 0,kind)
        end
    end)

    test("Corner Envelope: oblique incident edges supply local geometry without a world-axis box",function()
        local values=input()
        values.fieldWorld=world({{x=0,z=0},{x=100,z=0},{x=120,z=100},{x=0,z=100}})
        values.futureSpace[2]=future("AS-B",50,5,101,5)
        values.physicalSpaceEvidence=physical(100.5,5,0.1)
        local result=assess(OuttaMyWay.SpatialConstraintAssessment.new(),values).cornerKnowledge
        equal(count(result.atlasEntries),1); equal(count(result.engagements),1)
        equal(edgeExtent(result.atlasEntries[1],true),36)
        equal(edgeExtent(result.atlasEntries[1],false),10)
    end)

    test("Corner Envelope: demand larger than the field never establishes outside-field occupancy",function()
        local values=input()
        values.motionEvidence[1].nativeFieldWork.workingWidth.widthMetres=150
        values.motionEvidence[2].nativeFieldWork.workingWidth.widthMetres=160
        values.physicalSpaceEvidence=physical(-10,5,1)
        local result=assess(OuttaMyWay.SpatialConstraintAssessment.new(),values).cornerKnowledge
        equal(edgeExtent(result.atlasEntries[1],true),160)
        equal(edgeExtent(result.atlasEntries[1],false),150)
        equal(count(result.engagements),0)
    end)

    test("Passive Corner knowledge leaves FI geometry and temporal allocation unchanged",function()
        local assessment,values=engaged()
        local expected=canonical(assess(assessment,values).pairRelationships)
        turn(assessment,values)
        values=input(); values.motionEvidence[2].nativeFieldWork.workingWidth.widthMetres=60
        local result=assess(assessment,values)
        -- Width metadata changes, so compare the complete record at equal input.
        local fresh=assess(OuttaMyWay.SpatialConstraintAssessment.new(),values)
        equal(canonical(result.pairRelationships),canonical(fresh.pairRelationships))
        values=input()
        equal(canonical(assess(assessment,values).pairRelationships),expected)
    end)

    test("Passive Corner knowledge cannot preserve Regulation after accepted FI dissolution",function()
        local assessment,values=engaged(); turn(assessment,values)
        local corners=assess(assessment,values).cornerKnowledge
        local runtime=fixtures.newRuntime(); local requests={}
        local control={executeControlRequest=function(_,request) requests[#requests+1]=request; return true,"ACCEPTED" end,
            clearRegulationLeaseByReference=function() return true end,getControlExecutionObservation=function() return nil end}
        runtime:setRegulationControl(control)
        for _,positive in Value.ipairs({true,false}) do
            local pictureValues=Value.toTable(fixtures.picture(positive))
            pictureValues.spatialConstraintKnowledge[1].cornerKnowledge=corners
            local picture=OuttaMyWay.OperationalPicture.new(pictureValues)
            local supported=runtime.liveTrafficCandidateSupport:attach(picture,fixtures.snapshot())
            local evaluated=runtime:evaluateSealedOperationalPicture(supported)
            local result=runtime:dispatchEvaluatedOperationalPicture(supported,evaluated)
            equal(result.status,positive and "ACCEPTED" or "RELEASED")
            if positive then equal(requests[#requests].target.maxSpeedKmh,1) end
        end
        equal(runtime.responsibilityTransitionAuthority:getCurrentActionSpaceRegulation(),nil)
    end)
end
