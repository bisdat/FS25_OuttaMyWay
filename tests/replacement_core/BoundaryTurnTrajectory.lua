-- Diagnostic-only Boundary Turn Trajectory probe challenges.
-- These fixtures test support-evolution evidence and grant no Corner semantic authority.
return function(test,equal)
    local Probe=OuttaMyWay.BoundaryTurnTrajectoryProbe

    local field10={
        {x=-0.3,z=-206.8},{x=-40.8,z=-677.8},{x=132.3,z=-701.3},{x=144.3,z=-656.3},
        {x=155.3,z=-605.3},{x=165.8,z=-543.8},{x=166.3,z=-528.3},{x=174.3,z=-488.3},
        {x=182.8,z=-468.8},{x=228.8,z=-242.8}
    }

    local function trajectoryAt(analysis,originalIndex)
        for _,trajectory in OuttaMyWay.ValueRecord.ipairs(analysis.trajectories or {}) do
            if trajectory.originalIndex==originalIndex then return trajectory end
        end
    end

    local function stateAt(trajectory,remainingPointCount)
        for _,state in OuttaMyWay.ValueRecord.ipairs(trajectory and trajectory.states or {}) do
            if state.remainingPointCount==remainingPointCount then return state end
        end
    end

    local function canonicalSnapshot(points,quantum)
        local canonical,reason=OuttaMyWay.FieldWorldSnapshotRegistry.canonicalizeBoundary(points,{},quantum)
        if canonical==nil then error(reason or "canonicalization failed") end
        local closed={}
        for _,vertex in OuttaMyWay.ValueRecord.ipairs(points) do
            closed[#closed+1]={x=vertex.x,z=vertex.z}
        end
        closed[#closed+1]={x=points[1].x,z=points[1].z}
        return {
            boundary=closed,
            canonicalRootVertices=canonical.canonicalRootVertices,
            quantizationMetres=quantum,
            boundaryPointCount=canonical.boundaryPointCount
        }
    end

    test("Boundary turn trajectory probe: Field 77 structural corner retains turn as persistence support expands",function()
        local analysis=Probe.analyzeBoundary(field10)
        equal(analysis.status,"SUPPORTED_DIAGNOSTIC_ANALYSIS")
        equal(analysis.semanticAuthority,false)
        equal(analysis.controlAuthority,false)
        local trajectory=trajectoryAt(analysis,1)
        local fine=stateAt(trajectory,10)
        local late=stateAt(trajectory,4)
        if fine==nil or late==nil then error("expected Field 77 corner trajectory through four-survivor support") end
        equal(string.format("%.3f",fine.chordTurnMagnitudeDegrees),string.format("%.3f",late.chordTurnMagnitudeDegrees))
        if not (late.supportArcTotalM>fine.supportArcTotalM) then
            error("support should expand while persistent corner turn remains stable")
        end
    end)

    test("Boundary turn trajectory probe: smooth circle turn evolves with expanding persistence support",function()
        local circle={}
        for index=0,31 do
            local angle=(math.pi*2*index)/32
            circle[#circle+1]={x=100*math.cos(angle),z=100*math.sin(angle)}
        end
        local analysis=Probe.analyzeBoundary(circle)
        local trajectory=trajectoryAt(analysis,2)
        local fine=stateAt(trajectory,32)
        local late=stateAt(trajectory,4)
        if fine==nil or late==nil then error("expected selected circle survivor through four-survivor support") end
        if not (late.chordTurnMagnitudeDegrees>fine.chordTurnMagnitudeDegrees) then
            error(string.format("expected circle support turn to evolve fine=%.3f late=%.3f",
                fine.chordTurnMagnitudeDegrees,late.chordTurnMagnitudeDegrees))
        end
        if not (late.supportArcTotalM>fine.supportArcTotalM) then
            error("circle support should expand across persistence stages")
        end
    end)

    test("Boundary turn trajectory probe: rejoining perturbation exposes signed-turn cancellation",function()
        local bump={
            {x=0,z=0},{x=100,z=0},{x=100,z=100},{x=60,z=100},
            {x=60,z=110},{x=50,z=110},{x=50,z=100},{x=0,z=100}
        }
        local analysis=Probe.analyzeBoundary(bump)
        local trajectory=trajectoryAt(analysis,6)
        local wide=stateAt(trajectory,5)
        if wide==nil then error("expected bump trajectory at five-survivor support") end
        equal(string.format("%.3f",wide.supportNetSignedTurnDegrees),"0.000")
        if not (wide.supportAbsoluteTurnDegrees>0) then
            error("rejoining perturbation should retain absolute turning while net turn cancels")
        end
        equal(string.format("%.3f",wide.netToAbsoluteTurnRatio),"0.000")
        if not (wide.chordTurnMagnitudeDegrees<stateAt(trajectory,8).chordTurnMagnitudeDegrees) then
            error("rejoining perturbation chord turn should collapse as support expands")
        end
    end)

    test("Boundary turn trajectory probe: live snapshot consumes the exact metric persistence input",function()
        local snapshot=canonicalSnapshot(field10,0.1)
        local analysis=Probe.analyzeSnapshot(snapshot)
        equal(analysis.status,"SUPPORTED_DIAGNOSTIC_ANALYSIS")
        equal(analysis.inputSource,"FIELD_WORLD_CANONICAL_ROOT_VERTICES_DEQUANTIZED")
        equal(analysis.coordinateUnits,"WORLD_METRES")
        equal(analysis.quantizationMetres,0.1)
        local trajectory=trajectoryAt(analysis,1)
        local fine=stateAt(trajectory,10)
        equal(string.format("%.3f",fine.chordTurnMagnitudeDegrees),"94.016")
    end)

    test("Boundary turn trajectory probe: no Corner classification is manufactured",function()
        local analysis=Probe.analyzeBoundary(field10)
        equal(analysis.cornerFeatures,nil)
        equal(analysis.headlandRegimes,nil)
        equal(analysis.classification,nil)
        equal(analysis.provenance.authority,"DIAGNOSTIC_ONLY")
    end)
end
