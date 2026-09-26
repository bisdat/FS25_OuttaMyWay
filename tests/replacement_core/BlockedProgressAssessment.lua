return function(test,equal)
    local function approximately(value,expected,tolerance,message)
        if type(value)~="number" or math.abs(value-expected)>(tolerance or 0.0001) then
            error(message or (tostring(value).." not approximately "..tostring(expected)))
        end
    end

    local function fixture()
        local episode={identity="JE-RECOVERY-1",assemblyId="AS-RECOVERY",sourceJobToken="JOB-RECOVERY-1",status="ACTIVE"}
        local jobs={}
        function jobs:list() return {episode} end

        local assessment=OuttaMyWay.BlockedProgressAssessment.new(jobs)
        local timestamp=0
        local sequence=0
        local poseX=0
        local configurationProfileId="CFG-WORKING"
        local movementOwner=nil

        local function setEpisode(identity,sourceJobToken)
            episode={identity=identity,assemblyId="AS-RECOVERY",sourceJobToken=sourceJobToken,status="ACTIVE"}
        end

        local function setConfiguration(value)
            configurationProfileId=value
        end

        local function setMovementOwner(value)
            movementOwner=value
        end

        local function step(options)
            options=options or {}
            local interval=tonumber(options.intervalSeconds) or 0.25
            timestamp=timestamp+interval
            sequence=sequence+1
            if options.poseX~=nil then poseX=options.poseX
            elseif options.deltaX~=nil then poseX=poseX+options.deltaX end

            local speed=options.speedMps
            if speed==nil then speed=0 end
            local classification=options.motionClassification
            local directionX=options.travelDirectionX
            local directionZ=options.travelDirectionZ
            local headingToTravelDot=options.headingToTravelDot
            if classification==nil then
                if speed<0.05 then
                    classification="STATIONARY"
                elseif options.reverse==true then
                    classification="REVERSING_OR_OPPOSED_TRAVEL"
                else
                    classification="STABLE_FORWARD"
                end
            end
            if speed>=0.05 then
                directionX=directionX or (options.reverse==true and -1 or 1)
                directionZ=directionZ or 0
                headingToTravelDot=headingToTravelDot or (options.reverse==true and -1 or 1)
            end

            local commitmentContext={}
            if movementOwner~=nil then
                commitmentContext={{
                    commitmentId=movementOwner,
                    progressActuationOwnership={{assemblyId="AS-RECOVERY",authorityTokenId="AU-RECOVERY"}}
                }}
            end

            local physicalSpaceEvidence={}
            if configurationProfileId~=nil then
                physicalSpaceEvidence={{
                    assemblyId="AS-RECOVERY",
                    assemblyReferenceKey="vehicle-root:recovery",
                    configurationProfileId=configurationProfileId
                }}
            end

            return assessment:assess({
                observationSnapshotId=string.format("OS-RECOVERY-%03d",sequence),
                timestamp=timestamp,
                motionEvidence={{
                    assemblyId="AS-RECOVERY",
                    assemblyReferenceKey="vehicle-root:recovery",
                    sourceJobToken=episode.sourceJobToken,
                    positionDerivedSpeedMps=speed,
                    reportedSpeedMps=speed,
                    poseX=poseX,poseZ=0,
                    travelDirectionX=directionX,travelDirectionZ=directionZ,
                    headingToTravelDot=headingToTravelDot,
                    motionClassification=classification,
                    sampleIntervalSeconds=interval,
                    blocked=options.blocked==true
                }},
                physicalSpaceEvidence=physicalSpaceEvidence,
                operationByAssembly={["AS-RECOVERY"]="OR-RECOVERY"},
                commitmentContext=commitmentContext
            })
        end

        return {
            assessment=assessment,
            step=step,
            setEpisode=setEpisode,
            setConfiguration=setConfiguration,
            setMovementOwner=setMovementOwner
        }
    end

    local function progress(f,count,blocked)
        local knowledge=nil
        for _=1,count do
            knowledge=f.step({deltaX=0.5,speedMps=2,blocked=blocked==true})
        end
        return knowledge
    end

    local function stall(f)
        f.step({deltaX=0.5,speedMps=2,blocked=true})
        local knowledge=nil
        for _=1,4 do knowledge=f.step({speedMps=0,blocked=true}) end
        return knowledge
    end

    test("Blocked Progress Trail retains at most forty semi-continuous witnesses",function()
        local f=fixture()
        local knowledge=progress(f,50,false)
        equal(#knowledge,1)
        equal(knowledge[1].status,"RECOVERY_APPROACH_TRAIL_ACTIVE")
        equal(knowledge[1].recoveryApproachTrail.witnessCount,40)
        equal(knowledge[1].recoveryApproachTrail.capacityCount,40)
        approximately(knowledge[1].recoveryApproachTrail.retainedObservationSeconds,9.75,0.0001)
    end)

    test("Native blocked assertion while physical progress continues cannot establish a Stall",function()
        local f=fixture()
        progress(f,20,false)
        local knowledge=progress(f,8,true)
        equal(#knowledge,1)
        equal(knowledge[1].blockedProgressStall,false)
        equal(knowledge[1].status,"BLOCKED_ASSERTION_WITNESSED")
        approximately(knowledge[1].collapseObservation.observedSeconds,0,0.0001)
    end)

    test("Blocked assertion while TURNING remains positive progress until later physical collapse",function()
        local f=fixture()
        progress(f,20,false)
        local knowledge=f.step({
            deltaX=0.4,speedMps=1.6,blocked=true,
            motionClassification="TURNING",travelDirectionX=0.8,travelDirectionZ=0.6,headingToTravelDot=0.8
        })
        equal(knowledge[1].blockedProgressStall,false)
        equal(knowledge[1].status,"BLOCKED_ASSERTION_WITNESSED")
        approximately(knowledge[1].collapseObservation.observedSeconds,0,0.0001)

        for _=1,4 do knowledge=f.step({speedMps=0,blocked=true}) end
        equal(knowledge[1].blockedProgressStall,true)
        if knowledge[1].recoveryAnchor==nil then error("expected Recovery Anchor after turning approach") end
    end)

    test("Three collapsed quarter-second observations are insufficient but four establish Stall",function()
        local f=fixture()
        progress(f,20,false)
        f.step({deltaX=0.5,speedMps=2,blocked=true})
        local knowledge=nil
        for _=1,3 do knowledge=f.step({speedMps=0,blocked=true}) end
        equal(knowledge[1].blockedProgressStall,false)
        approximately(knowledge[1].collapseObservation.observedSeconds,0.75,0.0001)

        knowledge=f.step({speedMps=0,blocked=true})
        equal(knowledge[1].blockedProgressStall,true)
        equal(knowledge[1].status,"BLOCKED_PROGRESS_STALL")
        approximately(knowledge[1].collapseObservation.observedSeconds,1.0,0.0001)
        equal(knowledge[1].collapseObservation.sufficient,true)
    end)

    test("Five metres qualifies the Trail but Recovery Anchor is the oldest retained compatible witness",function()
        local f=fixture()
        progress(f,30,false)
        local knowledge=stall(f)
        local anchor=knowledge[1].recoveryAnchor
        if anchor==nil then error("expected Recovery Anchor") end
        equal(anchor.observationSnapshotId,"OS-RECOVERY-001")
        approximately(anchor.poseX,0.5,0.0001)
        approximately(anchor.usefulSpanM,15.0,0.0001)
        approximately(anchor.minimumUsefulSpanM,5.0,0.0001)
        equal(anchor.travelPolarity,"FORWARD")
    end)

    test("Blocked Progress Stall remains valid when raw blocked flickers false",function()
        local f=fixture()
        progress(f,30,false)
        local knowledge=stall(f)
        equal(knowledge[1].blockedProgressStall,true)
        knowledge=f.step({speedMps=0,blocked=false})
        equal(knowledge[1].blockedProgressStall,true)
        equal(knowledge[1].status,"BLOCKED_PROGRESS_STALL")
    end)

    test("Positive native progression clears established Stall and begins fresh evidence",function()
        local f=fixture()
        progress(f,30,false)
        local knowledge=stall(f)
        equal(knowledge[1].blockedProgressStall,true)
        knowledge=f.step({deltaX=0.5,speedMps=2,blocked=false})
        equal(knowledge[1].blockedProgressStall,false)
        equal(knowledge[1].status,"RECOVERY_APPROACH_TRAIL_ACTIVE")
        equal(knowledge[1].recoveryAnchor,nil)
    end)

    test("Blocked assertion without prior positively realised progress cannot establish Stall",function()
        local f=fixture()
        local knowledge=nil
        for _=1,8 do knowledge=f.step({speedMps=0,blocked=true}) end
        equal(#knowledge,0)
    end)

    test("Stall without five metres retained span publishes no Recovery Anchor",function()
        local f=fixture()
        progress(f,4,false)
        local knowledge=stall(f)
        equal(knowledge[1].blockedProgressStall,true)
        equal(knowledge[1].recoveryAnchor,nil)
        equal(knowledge[1].reason,"BLOCKED_PROGRESS_CONTRADICTION_WITHOUT_USEFUL_RECOVERY_ANCHOR")
    end)

    test("Native forward-reverse transition starts a new Recovery Approach Trail",function()
        local f=fixture()
        progress(f,12,false)
        local knowledge=f.step({deltaX=-0.5,speedMps=2,reverse=true})
        equal(knowledge[1].recoveryApproachTrail.witnessCount,1)
        equal(knowledge[1].status,"RECOVERY_APPROACH_TRAIL_ACTIVE")
    end)

    test("Material configuration profile change invalidates the prior Recovery Approach Trail",function()
        local f=fixture()
        progress(f,12,false)
        f.setConfiguration("CFG-TRANSIT")
        local knowledge=f.step({deltaX=0.5,speedMps=2})
        equal(knowledge[1].recoveryApproachTrail.witnessCount,1)
        equal(knowledge[1].recoveryAnchor,nil)
    end)

    test("Job Episode succession invalidates the prior Recovery Approach Trail",function()
        local f=fixture()
        progress(f,12,false)
        f.setEpisode("JE-RECOVERY-2","JOB-RECOVERY-2")
        local knowledge=f.step({deltaX=0.5,speedMps=2})
        equal(knowledge[1].jobEpisodeId,"JE-RECOVERY-2")
        equal(knowledge[1].recoveryApproachTrail.witnessCount,1)
    end)

    test("Current OMW progress ownership invalidates native Recovery Approach evidence",function()
        local f=fixture()
        progress(f,12,false)
        f.setMovementOwner("CM-OTHER")
        local knowledge=f.step({speedMps=0,blocked=true})
        equal(#knowledge,0)

        f.setMovementOwner(nil)
        knowledge=f.step({deltaX=0.5,speedMps=2})
        equal(#knowledge,1)
        equal(knowledge[1].recoveryApproachTrail.witnessCount,1)
    end)

    test("Unresolved configuration continuity cannot accumulate collapsed-motion evidence",function()
        local f=fixture()
        progress(f,20,false)
        f.step({deltaX=0.5,speedMps=2,blocked=true})
        f.setConfiguration(nil)
        local knowledge=nil
        for _=1,6 do knowledge=f.step({speedMps=0,blocked=true}) end
        equal(knowledge[1].blockedProgressStall,false)
        approximately(knowledge[1].collapseObservation.observedSeconds,0,0.0001)

        f.setConfiguration("CFG-WORKING")
        for _=1,4 do knowledge=f.step({speedMps=0,blocked=true}) end
        equal(knowledge[1].blockedProgressStall,true)
    end)
end
