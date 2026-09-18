-- Diagnostic-only Boundary Feature Lineage probe challenges.
-- These fixtures verify simplification provenance without granting Corner semantic authority.
return function(test,equal)
    local Probe=OuttaMyWay.BoundaryFeatureLineageProbe

    local field10={
        {x=-0.3,z=-206.8},{x=-40.8,z=-677.8},{x=132.3,z=-701.3},{x=144.3,z=-656.3},
        {x=155.3,z=-605.3},{x=165.8,z=-543.8},{x=166.3,z=-528.3},{x=174.3,z=-488.3},
        {x=182.8,z=-468.8},{x=228.8,z=-242.8}
    }

    local function lineageForRemoved(analysis,originalIndex)
        for _,lineage in OuttaMyWay.ValueRecord.ipairs(analysis.lineages or {}) do
            if lineage.removedOriginalIndex==originalIndex then return lineage end
        end
    end

    local function hasValue(values,expected)
        for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do
            if value==expected then return true end
        end
        return false
    end

    local function indexText(values)
        local result={}
        for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do result[#result+1]=tostring(value) end
        return table.concat(result,",")
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

    test("Boundary feature lineage probe: peninsula tip removal remains inherited by successor interval",function()
        local peninsula={
            {x=0,z=0},{x=100,z=0},{x=100,z=100},{x=65,z=100},
            {x=65,z=145},{x=35,z=145},{x=35,z=100},{x=0,z=100}
        }
        local analysis=Probe.analyzeBoundary(peninsula)
        equal(analysis.status,"SUPPORTED_DIAGNOSTIC_ANALYSIS")
        local tip=lineageForRemoved(analysis,5)
        local shoulder=lineageForRemoved(analysis,4)
        if tip==nil or shoulder==nil then error("expected peninsula tip and shoulder lineages") end
        equal(tip.parentLineageId,shoulder.lineageId)
        equal(hasValue(shoulder.childLineageIds,tip.lineageId),true)
        equal(shoulder.startOriginalIndex,3)
        equal(shoulder.endOriginalIndex,6)
        equal(indexText(shoulder.collapsedOriginalIndices),"4,5")
        equal(string.format("%.3f",math.abs(shoulder.netSignedTurnDegrees)),"0.000")
        equal(string.format("%.3f",shoulder.absoluteTurnDegrees),"180.000")
        if not (shoulder.maxDeviationM>0) then
            error("collapsed peninsula region must retain geometric deviation evidence")
        end
    end)

    test("Boundary feature lineage probe: rejoining bump preserves absolute turn while full excursion cancels",function()
        local bump={
            {x=0,z=0},{x=100,z=0},{x=100,z=100},{x=60,z=100},
            {x=60,z=110},{x=50,z=110},{x=50,z=100},{x=0,z=100}
        }
        local analysis=Probe.analyzeBoundary(bump)
        local excursion=lineageForRemoved(analysis,6)
        if excursion==nil then error("expected full bump collapse lineage") end
        equal(excursion.startOriginalIndex,3)
        equal(excursion.endOriginalIndex,8)
        equal(indexText(excursion.collapsedOriginalIndices),"4,5,6,7")
        equal(string.format("%.3f",math.abs(excursion.netSignedTurnDegrees)),"0.000")
        equal(string.format("%.3f",excursion.absoluteTurnDegrees),"360.000")
        equal(string.format("%.3f",excursion.netToAbsoluteTurnRatio),"0.000")
        if not (excursion.lineageDepth>1) then
            error("full excursion should inherit earlier collapse lineage")
        end
    end)

    test("Boundary feature lineage probe: Field 77 right-side detail converges into one bounded cancellation lineage",function()
        local analysis=Probe.analyzeBoundary(field10)
        local rightSide=lineageForRemoved(analysis,8)
        if rightSide==nil then error("expected Field 77 right-side collapse lineage") end
        equal(rightSide.startOriginalIndex,3)
        equal(rightSide.endOriginalIndex,10)
        equal(indexText(rightSide.collapsedOriginalIndices),"4,5,6,7,8,9")
        equal(string.format("%.3f",math.abs(rightSide.netSignedTurnDegrees)),"3.427")
        equal(string.format("%.3f",rightSide.absoluteTurnDegrees),"46.836")
        equal(string.format("%.3f",rightSide.netToAbsoluteTurnRatio),"0.073")
        if not (rightSide.lineageDepth>1) then
            error("right-side structural interval should inherit subordinate removals")
        end
    end)

    test("Boundary feature lineage probe: every persistence removal creates lineage without privileging circle feature",function()
        local circle={}
        for index=0,31 do
            local angle=(math.pi*2*index)/32
            circle[#circle+1]={x=100*math.cos(angle),z=100*math.sin(angle)}
        end
        local analysis=Probe.analyzeBoundary(circle)
        equal(analysis.status,"SUPPORTED_DIAGNOSTIC_ANALYSIS")
        equal(OuttaMyWay.ValueRecord.length(analysis.lineages),29)
        equal(OuttaMyWay.ValueRecord.length(analysis.terminalSurvivorIndices),3)
        if not (OuttaMyWay.ValueRecord.length(analysis.rootLineageIds)>=1) then
            error("circle simplification should retain lineage provenance without semantic feature selection")
        end
    end)

    test("Boundary feature lineage probe: live snapshot consumes validated canonical metric persistence input",function()
        local analysis=Probe.analyzeSnapshot(canonicalSnapshot(field10,0.1))
        equal(analysis.status,"SUPPORTED_DIAGNOSTIC_ANALYSIS")
        equal(analysis.inputSource,"FIELD_WORLD_CANONICAL_ROOT_VERTICES_DEQUANTIZED")
        equal(analysis.coordinateUnits,"WORLD_METRES")
        equal(analysis.quantizationMetres,0.1)
        equal(analysis.originalPointCount,10)
        equal(OuttaMyWay.ValueRecord.length(analysis.lineages),7)
    end)

    test("Boundary feature lineage probe: no Corner classification is manufactured",function()
        local analysis=Probe.analyzeBoundary(field10)
        equal(analysis.cornerFeatures,nil)
        equal(analysis.headlandRegimes,nil)
        equal(analysis.classification,nil)
        equal(analysis.provenance.authority,"DIAGNOSTIC_ONLY")
        equal(analysis.semanticAuthority,false)
        equal(analysis.controlAuthority,false)
    end)
end
