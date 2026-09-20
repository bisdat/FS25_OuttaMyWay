-- Production Corner Situation and temporary right-of-way contracts.
-- Replaces the retired pairwise Category-1 / Corner Envelope fixture semantics.
return function(test,equal)
    local Value=OuttaMyWay.ValueRecord
    local Packet=Value.define("CornerSituationFixture",{"value"},{})
    local function sealed(value) return Packet.new({value=value}).value end
    local function count(values) return Value.length(values or {}) end

    local function world()
        local result,reason=OuttaMyWay.FieldWorldSnapshotRegistry.canonicalizeBoundary({
            {x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}
        },{},0.1)
        assert(result,reason)
        result.geometryFingerprint=result.fingerprint
        result.fieldPolygonReferenceKey="field-world-polygon:"..result.canonicalizationVersion..":"..result.fingerprint
        return result
    end

    local function future(id,x,z,ex,ez,epoch)
        local lengthM=math.sqrt((ex-x)^2+(ez-z)^2)
        return {assemblyId=id,identity="future:"..id,alternatives={{kind="FIELD_WORLD_BOUNDED_LOCAL_CONTINUATION",
            startX=x,startZ=z,endX=ex,endZ=ez,headingX=(ex-x)/lengthM,headingZ=(ez-z)/lengthM,
            boundaryDistance=lengthM,boundarySource="FIELD_WORLD_OUTER_BOUNDARY",intentEpoch=epoch or 1}}}
    end

    local function motion(id,options)
        options=options or {}
        return {
            assemblyId=id,assemblyReferenceKey="ref:"..id,sourceJobToken=options.jobToken or ("job:"..id),
            intentEpoch=options.intentEpoch or 1,reportedSpeedMps=options.speedMps or 4,
            poseX=options.poseX,poseZ=options.poseZ,
            localIntentClassification=options.intent or "SETTLED_CONTINUATION",
            nativeFieldWork={
                workingWidth={available=true,widthMetres=options.widthM or 10,source="GIANTS_WORKING_WIDTH_ACCESSOR",
                    authority="PROVISIONAL_DEMAND_SEED_INPUT_ONLY"},
                nativeDriveCommand={
                    valid=options.moveForwards~=nil,
                    moveForwards=options.moveForwards,
                    maxSpeedKmh=options.nativeMaxSpeedKmh
                }
            }
        }
    end

    local function productive(id,options)
        options=options or {}
        return {
            assemblyId=id,jobToken=options.jobToken or ("job:"..id),
            productivePositive=options.positive~=false,
            isTurn=options.isTurn==true
        }
    end

    local function physical(id,x,z,radius)
        return {assemblyId=id,primitives={{
            identity="DISC-"..id,kind="DISC",positiveConflictSupport=true,
            x=x,z=z,radius=radius or 1
        }},negativeClearanceAuthority=false}
    end

    local function oneWorkerInput()
        return {
            operationId="OR-1",fieldWorldReferenceKey="FW-1",fieldWorld=world(),
            assemblyIds={"AS-A"},observationSnapshotId="OBS-1",observationEpoch=1,
            futureSpace={future("AS-A",95,5,95,0)},
            motionEvidence={motion("AS-A",{moveForwards=true,poseX=95,poseZ=5})},
            productiveContinuationKnowledge={productive("AS-A")},
            physicalSpaceEvidence={physical("AS-A",100,5,1)},
            followerBoundaryKnowledge={}
        }
    end

    local function twoWorkerInput()
        local values=oneWorkerInput()
        values.assemblyIds={"AS-A","AS-B"}
        values.futureSpace={
            future("AS-A",95,5,95,0),
            future("AS-B",95,5,100,5)
        }
        values.motionEvidence={
            motion("AS-A",{moveForwards=true,poseX=95,poseZ=5,speedMps=5}),
            motion("AS-B",{moveForwards=true,poseX=95,poseZ=5,speedMps=4})
        }
        values.productiveContinuationKnowledge={productive("AS-A"),productive("AS-B")}
        values.physicalSpaceEvidence={
            physical("AS-A",100,5,1),
            physical("AS-B",95,0,1)
        }
        return values
    end

    local function assess(assessment,values)
        return assessment:assess(sealed(values))
    end

    local function cornerAt(result,x,z)
        for _,entry in Value.ipairs(result.cornerKnowledge.atlasEntries or {}) do
            if math.abs(entry.representativePoint.x-x)<0.001 and math.abs(entry.representativePoint.z-z)<0.001 then
                return entry
            end
        end
    end

    local function eventOfKind(events,kind)
        for _,event in Value.ipairs(events or {}) do
            if event.kind==kind then return event end
        end
    end

    test("Corner Structure: exact Field World features exist independently of pairwise FI",function()
        local result=assess(OuttaMyWay.SpatialConstraintAssessment.new(),oneWorkerInput())
        equal(count(result.pairRelationships),0)
        equal(count(result.cornerKnowledge.atlasEntries),4)
        assert(cornerAt(result,100,0)~=nil)
        equal(result.cornerKnowledge.decisionAuthority,false)
        equal(result.cornerKnowledge.controlAuthority,false)
    end)

    test("Corner Arrival Evidence: distant bounded A8 preserves prospective timing without local demand",function()
        local values=oneWorkerInput()
        values.futureSpace={future("AS-A",90,50,90,0)}
        values.motionEvidence={motion("AS-A",{moveForwards=true,poseX=90,poseZ=50,nativeMaxSpeedKmh=18})}
        values.physicalSpaceEvidence={{
            assemblyId="AS-A",
            primitives={{
                identity="DISC-AS-A-REAR",kind="DISC",positiveConflictSupport=true,
                x=90,z=40,radius=1
            }},
            negativeClearanceAuthority=false
        }}
        local result=assess(OuttaMyWay.SpatialConstraintAssessment.new(),values).cornerKnowledge
        equal(count(result.arrivalEvidence),1)
        equal(count(result.approachDemands),0)
        equal(count(result.engagements),0)
        equal(result.arrivalEvidence[1].arrivalDistanceM,50)
        equal(result.arrivalEvidence[1].timeToCornerSec,10)
        equal(result.arrivalEvidence[1].arrivalRateSource,"GIANTS_IMMEDIATE_NATIVE_MAX_SPEED")
    end)

    test("Corner Approach Demand: local arrival within physical reach admits without representative-point sweep",function()
        local values=oneWorkerInput()
        values.futureSpace={future("AS-A",90,10,90,0)}
        values.motionEvidence={motion("AS-A",{moveForwards=true,poseX=90,poseZ=10,nativeMaxSpeedKmh=18})}
        values.physicalSpaceEvidence={{
            assemblyId="AS-A",
            primitives={{
                identity="DISC-AS-A-REAR",kind="DISC",positiveConflictSupport=true,
                x=90,z=0,radius=1
            }},
            negativeClearanceAuthority=false
        }}
        local result=assess(OuttaMyWay.SpatialConstraintAssessment.new(),values).cornerKnowledge
        equal(count(result.arrivalEvidence),1)
        equal(count(result.approachDemands),1)
        equal(count(result.engagements),1)
        equal(result.approachDemands[1].witness,
            "CURRENT_PRODUCTIVE_A8_CORNER_ARRIVAL_WITHIN_CURRENT_PHYSICAL_REACH")
        equal(result.approachDemands[1].physicalDemandEvidence.mode,"ARRIVAL_WITHIN_CURRENT_PHYSICAL_REACH")
        equal(result.approachDemands[1].physicalDemandEvidence.currentPhysicalReach.reachM,11)
        equal(result.approachDemands[1].physicalDemandEvidence.localDemandHorizonM,11)
        equal(result.approachDemands[1].arrivalDistanceM,10)
        equal(result.approachDemands[1].timeToCornerSec,2)
        equal(result.approachDemands[1].arrivalRateSource,"GIANTS_IMMEDIATE_NATIVE_MAX_SPEED")
    end)

    test("Corner Occupancy: positive current physical overlap admits a turning assembly without A8",function()
        local values=oneWorkerInput()
        values.futureSpace={}
        values.motionEvidence={motion("AS-A",{intent="TURNING",moveForwards=false,poseX=100,poseZ=0,nativeMaxSpeedKmh=4})}
        values.productiveContinuationKnowledge={productive("AS-A",{positive=false,isTurn=true})}
        values.physicalSpaceEvidence={physical("AS-A",100,0,1)}
        local result=assess(OuttaMyWay.SpatialConstraintAssessment.new(),values).cornerKnowledge
        equal(count(result.approachDemands),0)
        equal(count(result.occupancies),1)
        equal(count(result.engagements),1)
        equal(result.engagements[1].relevanceEvidenceState,"POSITIVE_CURRENT_CORNER_OCCUPANCY")
        equal(result.engagements[1].cornerIncumbent,true)
        equal(result.engagements[1].incumbencyEvidenceState,"POSITIVE_CURRENT_CORNER_OCCUPANCY")
        local incumbentEvent=eventOfKind(result.events,"CORNER_INCUMBENCY_ESTABLISHED")
        assert(incumbentEvent~=nil)
        local event=eventOfKind(result.events,"CORNER_ENGAGEMENT_ESTABLISHED")
        assert(event~=nil)
        equal(event.reason,"UNILATERAL_CORNER_OCCUPANCY_ADMISSION")
    end)

    test("Corner Admission: physical reach keeps same-edge demand bounded to the structural Corner region",function()
        local values=oneWorkerInput()
        values.futureSpace={future("AS-A",80,50,80,0)}
        values.motionEvidence={motion("AS-A",{moveForwards=true,poseX=80,poseZ=50})}
        values.physicalSpaceEvidence={{
            assemblyId="AS-A",
            primitives={{
                identity="DISC-AS-A-REAR",kind="DISC",positiveConflictSupport=true,
                x=80,z=40,radius=1
            }},
            negativeClearanceAuthority=false
        }}
        local result=assess(OuttaMyWay.SpatialConstraintAssessment.new(),values).cornerKnowledge
        equal(count(result.approachDemands),0)
        equal(count(result.engagements),0)
    end)

    test("Corner Admission: one assembly independently establishes approach demand and Engagement",function()
        local result=assess(OuttaMyWay.SpatialConstraintAssessment.new(),oneWorkerInput()).cornerKnowledge
        equal(count(result.approachDemands),1)
        equal(count(result.engagements),1)
        equal(result.engagements[1].assemblyId,"AS-A")
        equal(result.engagements[1].sourceJobToken,"job:AS-A")
        equal(result.engagements[1].currentEvidenceState,"CORNER_ENGAGEMENT_RETAINED")
        equal(count(result.sharedCornerSituations),0)
        local event=eventOfKind(result.events,"CORNER_ENGAGEMENT_ESTABLISHED")
        assert(event~=nil)
        equal(event.reason,"UNILATERAL_CORNER_ADMISSION")
    end)

    test("Shared Corner Situation: independent participants publish competing demand without choosing priority",function()
        local result=assess(OuttaMyWay.SpatialConstraintAssessment.new(),twoWorkerInput()).cornerKnowledge
        equal(count(result.approachDemands),2)
        equal(count(result.engagements),2)
        equal(count(result.sharedCornerSituations),1)
        local shared=result.sharedCornerSituations[1]
        equal(shared.competingDemand,true)
        equal(shared.regulationSpeedKmh,1)
        equal(shared.allocationStatus,"UNALLOCATED_SITUATION_MEANING")
        equal(shared.decisionAuthority,false)
        equal(shared.controlAuthority,false)
        equal(count(shared.participants),2)
    end)

    test("Corner Engagement: TURNING retains admitted state after approach evidence disappears",function()
        local assessment=OuttaMyWay.SpatialConstraintAssessment.new()
        local values=oneWorkerInput()
        assess(assessment,values)
        values.observationSnapshotId="OBS-2"; values.observationEpoch=2
        values.futureSpace={}; values.physicalSpaceEvidence={}
        values.productiveContinuationKnowledge={productive("AS-A",{positive=false,isTurn=true})}
        values.motionEvidence={motion("AS-A",{intent="TURNING",moveForwards=false,poseX=95,poseZ=2})}
        local result=assess(assessment,values).cornerKnowledge
        equal(count(result.approachDemands),0)
        equal(count(result.engagements),1)
        equal(result.engagements[1].hasObservedManoeuvring,true)
        equal(result.engagements[1].cornerIncumbent,true)
        equal(result.engagements[1].incumbencyEvidenceState,"CORNER_MANOEUVRING_OBSERVED_AFTER_LOCAL_ENGAGEMENT")
        equal(result.engagements[1].currentEvidenceState,"CORNER_MANOEUVRING")
        equal(count(result.positiveDepartures),0)
    end)

    test("Shared Corner Situation: incumbent survives manoeuvring while remote arrival remains prospective",function()
        local assessment=OuttaMyWay.SpatialConstraintAssessment.new()
        local values=oneWorkerInput()
        assess(assessment,values)

        values.observationSnapshotId="OBS-2"; values.observationEpoch=2
        values.assemblyIds={"AS-A","AS-B"}
        values.futureSpace={future("AS-B",50,5,100,5)}
        values.motionEvidence={
            motion("AS-A",{intent="TURNING",moveForwards=false,poseX=95,poseZ=2,nativeMaxSpeedKmh=4}),
            motion("AS-B",{moveForwards=true,poseX=50,poseZ=5,nativeMaxSpeedKmh=25})
        }
        values.productiveContinuationKnowledge={
            productive("AS-A",{positive=false,isTurn=true}),
            productive("AS-B")
        }
        values.physicalSpaceEvidence={physical("AS-B",50,0,1)}

        local result=assess(assessment,values).cornerKnowledge
        equal(count(result.approachDemands),0)
        equal(count(result.arrivalEvidence),1)
        equal(count(result.engagements),1)
        equal(count(result.sharedCornerSituations),1)
        local shared=result.sharedCornerSituations[1]
        local byId={}
        for _,participant in Value.ipairs(shared.participants) do byId[participant.assemblyId]=participant end
        equal(byId["AS-A"].cornerIncumbent,true)
        equal(byId["AS-A"].timeToCornerSec,nil)
        equal(byId["AS-B"].cornerIncumbent,false)
        equal(byId["AS-B"].cornerArrivalEvidence,true)
        equal(byId["AS-B"].approachDemand,false)
        assert(type(byId["AS-B"].timeToCornerSec)=="number")
    end)

    test("Corner Departure: continuous productive A8 crossing positively discharges no-reversal traversal",function()
        local assessment=OuttaMyWay.SpatialConstraintAssessment.new()
        local values=oneWorkerInput()
        assess(assessment,values)
        values.observationSnapshotId="OBS-2"; values.observationEpoch=2
        values.futureSpace={future("AS-A",90,10,0,10)}
        values.motionEvidence={motion("AS-A",{moveForwards=true,poseX=90,poseZ=10})}
        values.productiveContinuationKnowledge={productive("AS-A")}
        values.physicalSpaceEvidence={}
        local result=assess(assessment,values).cornerKnowledge
        equal(count(result.engagements),0)
        equal(count(result.positiveDepartures),1)
        equal(result.positiveDepartures[1].departureReason,"CONTINUOUS_A8_CROSSED_FIELD_SCOPED_CORNER_BOUNDARY")
    end)

    test("Corner Departure: final native direction transition becomes the stronger crossing anchor",function()
        local assessment=OuttaMyWay.SpatialConstraintAssessment.new()
        local values=oneWorkerInput()
        assess(assessment,values)

        values.observationSnapshotId="OBS-2"; values.observationEpoch=2
        values.futureSpace={}; values.physicalSpaceEvidence={}
        values.productiveContinuationKnowledge={productive("AS-A",{positive=false,isTurn=true})}
        values.motionEvidence={motion("AS-A",{intent="TURNING",moveForwards=false,poseX=95,poseZ=2})}
        assess(assessment,values)

        values.observationSnapshotId="OBS-3"; values.observationEpoch=3
        values.motionEvidence={motion("AS-A",{intent="TURNING",moveForwards=true,poseX=85,poseZ=2})}
        local turning=assess(assessment,values).cornerKnowledge
        equal(count(turning.engagements),1)
        equal(turning.engagements[1].finalDirectionTransition.x,85)
        equal(turning.engagements[1].finalDirectionTransition.toMoveForwards,true)

        values.observationSnapshotId="OBS-4"; values.observationEpoch=4
        values.futureSpace={future("AS-A",80,10,0,10)}
        values.motionEvidence={motion("AS-A",{moveForwards=true,poseX=80,poseZ=10})}
        values.productiveContinuationKnowledge={productive("AS-A")}
        local result=assess(assessment,values).cornerKnowledge
        equal(count(result.engagements),0)
        equal(count(result.positiveDepartures),1)
        equal(result.positiveDepartures[1].departureReason,"A8_CROSSED_FINAL_MANOEUVRE_DIRECTION_TRANSITION_BOUNDARY")
    end)

    test("Corner Engagement: source Job replacement cannot inherit retained Corner state",function()
        local assessment=OuttaMyWay.SpatialConstraintAssessment.new()
        local values=oneWorkerInput()
        assess(assessment,values)
        values.observationSnapshotId="OBS-2"; values.observationEpoch=2
        values.futureSpace={future("AS-A",90,10,0,10)}
        values.motionEvidence={motion("AS-A",{jobToken="job:new",moveForwards=true,poseX=90,poseZ=10})}
        values.productiveContinuationKnowledge={productive("AS-A",{jobToken="job:new"})}
        values.physicalSpaceEvidence={}
        local result=assess(assessment,values).cornerKnowledge
        equal(count(result.engagements),0)
        equal(count(result.positiveDepartures),0)
    end)

    local function picture()
        return OuttaMyWay.OperationalPicture.new({
            identity="OP-CORNER",epoch=1,observationSnapshotId="OBS-CORNER",
            situations={},currentPairAssessmentScope={},
            identities={assemblies={"AS-A","AS-B"},components={},jobEpisodes={active={},admitted={},ended={}},operations={active={"OR-1"},ended={}}},
            currentSpace={},futureSpace={},demand={committedDemand={},potentialDemand={},temporarySlack={}},
            responsibilityRelations={},uncertainty={},representationFitness={},
            provenance={source="CornerSituationKnowledge"},controlOutcomeEvidence={},
            candidateSupportEvidence={complete=true,supportBoundary={},candidateSpecifications={},provenance={}},
            commitmentContext={}
        })
    end

    local function inventory(requirement,candidateIds)
        return OuttaMyWay.CandidateInventory.new({
            identity="CI-CORNER",epoch=1,operationalPictureId="OP-CORNER",
            candidateIds=candidateIds,complete=true,
            supportBoundary={decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=requirement}},
            provenance={source="CornerSituationKnowledge"}
        })
    end

    local function regulationCandidate(id,requirement,protected)
        return {
            identity=id,capability="REGULATE_SPEED",comparisonCost=0,
            evidenceBasis={trafficPolicemanPreference={
                primaryResolution=true,governingRequirementKey=requirement,
                exhaustionEvidence={CONTINUE_OBSERVATION={
                    result="PASS",operationalPictureId="OP-CORNER",
                    governingRequirementKey=requirement,capability="CONTINUE_OBSERVATION"
                }},
                cornerRightOfWay={
                    sharedCornerIdentity="shared-corner:OR-1:C1",
                    protectedParticipant=protected
                }
            }}
        }
    end

    test("Corner Decision: incumbent arrival outranks a remote prospective arrival",function()
        local requirement="corner-right-of-way:shared-corner:OR-1:C1"
        local protectA=regulationCandidate("CA-PROTECT-A",requirement,{
            assemblyId="AS-A",engagement=true,cornerIncumbent=true,approachDemand=false
        })
        local protectB=regulationCandidate("CA-PROTECT-B",requirement,{
            assemblyId="AS-B",engagement=false,cornerArrivalEvidence=true,approachDemand=false,timeToCornerSec=5
        })
        local decision=OuttaMyWay.TrafficPolicemanDecisionPolicy:select(
            picture(),inventory(requirement,{protectA.identity,protectB.identity}),{protectA,protectB})
        equal(decision.selected.identity,"CA-PROTECT-A")
        equal(decision.rule,"CORNER_RIGHT_OF_WAY:PROTECT_CORNER_INCUMBENT")
    end)

    test("Corner Decision: retained Engagement age cannot outrank the only current supported arrival",function()
        local requirement="corner-right-of-way:shared-corner:OR-1:C1"
        local protectA=regulationCandidate("CA-PROTECT-A",requirement,{
            assemblyId="AS-A",engagement=true,approachDemand=false,establishedObservationEpoch=1
        })
        local protectB=regulationCandidate("CA-PROTECT-B",requirement,{
            assemblyId="AS-B",engagement=false,approachDemand=true,timeToCornerSec=5
        })
        local decision=OuttaMyWay.TrafficPolicemanDecisionPolicy:select(
            picture(),inventory(requirement,{protectA.identity,protectB.identity}),{protectA,protectB})
        equal(decision.selected.identity,"CA-PROTECT-B")
        equal(decision.rule,"CORNER_RIGHT_OF_WAY:PROTECT_ONLY_CURRENT_SUPPORTED_CORNER_ARRIVAL")
    end)

    test("Corner Decision: current arrival time outranks Engagement establishment age",function()
        local requirement="corner-right-of-way:shared-corner:OR-1:C1"
        local protectA=regulationCandidate("CA-PROTECT-A",requirement,{
            assemblyId="AS-A",engagement=true,approachDemand=true,establishedObservationEpoch=1,timeToCornerSec=8
        })
        local protectB=regulationCandidate("CA-PROTECT-B",requirement,{
            assemblyId="AS-B",engagement=true,approachDemand=true,establishedObservationEpoch=2,timeToCornerSec=3
        })
        local decision=OuttaMyWay.TrafficPolicemanDecisionPolicy:select(
            picture(),inventory(requirement,{protectA.identity,protectB.identity}),{protectA,protectB})
        equal(decision.selected.identity,"CA-PROTECT-B")
        equal(decision.rule,"CORNER_RIGHT_OF_WAY:PROTECT_EARLIER_CURRENT_CORNER_ARRIVAL")
    end)

    test("Corner Decision: unresolved symmetric arrival evidence waits rather than inventing priority",function()
        local requirement="corner-right-of-way:shared-corner:OR-1:C1"
        local protectA=regulationCandidate("CA-PROTECT-A",requirement,{
            assemblyId="AS-A",engagement=false,approachDemand=true,timeToCornerSec=5
        })
        local protectB=regulationCandidate("CA-PROTECT-B",requirement,{
            assemblyId="AS-B",engagement=false,approachDemand=true,timeToCornerSec=5
        })
        local decision=OuttaMyWay.TrafficPolicemanDecisionPolicy:select(
            picture(),inventory(requirement,{protectA.identity,protectB.identity}),{protectA,protectB})
        equal(decision.selected,nil)
        equal(decision.waitForPreferenceEvidence,true)
        equal(decision.rule,"CORNER_RIGHT_OF_WAY:SHARED_CORNER_ARRIVAL_PRIORITY_UNRESOLVED")
    end)
end
