-- Diagnostic-only Boundary Feature Persistence probe challenges.
-- These fixtures test the investigative scale analysis, not Corner semantic authority.
return function(test,equal)
    local Probe=OuttaMyWay.BoundaryFeaturePersistenceProbe

    local field10={
        {x=-0.3,z=-206.8},{x=-40.8,z=-677.8},{x=132.3,z=-701.3},{x=144.3,z=-656.3},
        {x=155.3,z=-605.3},{x=165.8,z=-543.8},{x=166.3,z=-528.3},{x=174.3,z=-488.3},
        {x=182.8,z=-468.8},{x=228.8,z=-242.8}
    }
    local field11={
        {x=-0.3,z=-206.8},{x=-11.3,z=-343.8},{x=-40.8,z=-677.8},{x=132.3,z=-701.3},
        {x=144.3,z=-656.3},{x=155.3,z=-605.3},{x=165.8,z=-543.8},{x=166.3,z=-528.3},
        {x=174.3,z=-488.3},{x=182.8,z=-468.8},{x=228.8,z=-242.8}
    }

    local function quantized(points,quantum)
        local result={}
        for _,vertex in OuttaMyWay.ValueRecord.ipairs(points) do
            result[#result+1]={
                x=vertex.x>=0 and math.floor(vertex.x/quantum+0.5) or math.ceil(vertex.x/quantum-0.5),
                z=vertex.z>=0 and math.floor(vertex.z/quantum+0.5) or math.ceil(vertex.z/quantum-0.5)
            }
        end
        return result
    end

    local function stageAt(analysis,count)
        for _,stage in OuttaMyWay.ValueRecord.ipairs(analysis.stages or {}) do
            if stage.remainingPointCount==count then return stage end
        end
    end

    local function coordinateKey(vertex)
        return string.format("%.1f,%.1f",vertex.x,vertex.z)
    end

    local function coordinateSet(stage)
        local result={}
        for _,vertex in OuttaMyWay.ValueRecord.ipairs(stage and stage.survivors or {}) do
            result[coordinateKey(vertex)]=true
        end
        return result
    end

    test("Boundary persistence probe: Field 77 10/11-point samplings converge on the same four-survivor structure",function()
        local ten=Probe.analyzeBoundary(field10)
        local eleven=Probe.analyzeBoundary(field11)
        equal(ten.status,"SUPPORTED_DIAGNOSTIC_ANALYSIS")
        equal(eleven.status,"SUPPORTED_DIAGNOSTIC_ANALYSIS")
        equal(ten.semanticAuthority,false)
        equal(ten.controlAuthority,false)
        local tenFour=coordinateSet(stageAt(ten,4))
        local elevenFour=coordinateSet(stageAt(eleven,4))
        local expected={
            ["-0.3,-206.8"]=true,
            ["-40.8,-677.8"]=true,
            ["132.3,-701.3"]=true,
            ["228.8,-242.8"]=true
        }
        for key in OuttaMyWay.ValueRecord.pairs(expected) do
            equal(tenFour[key],true,"10-point four-survivor stage missing "..key)
            equal(elevenFour[key],true,"11-point four-survivor stage missing "..key)
        end
        equal(OuttaMyWay.ValueRecord.length(stageAt(ten,4).survivors),4)
        equal(OuttaMyWay.ValueRecord.length(stageAt(eleven,4).survivors),4)
    end)

    test("Boundary persistence probe: equivalent extra left-boundary sample disappears before structural Field 77 samples",function()
        local analysis=Probe.analyzeBoundary(field11)
        equal(analysis.removals[1].originalIndex,2)
        equal(string.format("%.1f,%.1f",analysis.removals[1].x,analysis.removals[1].z),"-11.3,-343.8")
        if not (analysis.removals[1].removalScaleM<1) then
            error("equivalent extra boundary sample should be low-scale diagnostic detail")
        end
    end)

    test("Boundary persistence probe: Field 77 late scale separation is larger than a smooth regular circle",function()
        local circle={}
        for index=0,31 do
            local angle=(math.pi*2*index)/32
            circle[#circle+1]={x=100*math.cos(angle),z=100*math.sin(angle)}
        end
        local field=Probe.analyzeBoundary(field10)
        local round=Probe.analyzeBoundary(circle)
        if not (field.largestScaleGapRatio~=nil and round.largestScaleGapRatio~=nil
            and field.largestScaleGapRatio>round.largestScaleGapRatio) then
            error(string.format("expected Field 77 diagnostic gap to exceed circle gap field=%s circle=%s",
                tostring(field.largestScaleGapRatio),tostring(round.largestScaleGapRatio)))
        end
        equal(round.semanticAuthority,false)
    end)

    test("Boundary persistence probe: peninsula protrusion remains represented at the late four-survivor stage",function()
        local peninsula={
            {x=0,z=0},{x=100,z=0},{x=100,z=100},{x=65,z=100},
            {x=65,z=145},{x=35,z=145},{x=35,z=100},{x=0,z=100}
        }
        local analysis=Probe.analyzeBoundary(peninsula)
        local four=stageAt(analysis,4)
        local maxZ=-math.huge
        for _,vertex in OuttaMyWay.ValueRecord.ipairs(four.survivors) do
            if vertex.z>maxZ then maxZ=vertex.z end
        end
        equal(maxZ,145)
        equal(analysis.semanticAuthority,false)
    end)

    test("Boundary persistence probe: live snapshot ignores repeated source-ring closure encoding",function()
        local closed={}
        for _,vertex in OuttaMyWay.ValueRecord.ipairs(field10) do
            closed[#closed+1]={x=vertex.x,z=vertex.z}
        end
        closed[#closed+1]={x=field10[1].x,z=field10[1].z}
        local direct=Probe.analyzeBoundary(field10)
        local analysis=Probe.analyzeSnapshot({
            boundary=closed,
            canonicalRootVertices=quantized(field10,0.1),
            quantizationMetres=0.1,
            boundaryPointCount=10
        })
        equal(analysis.status,"SUPPORTED_DIAGNOSTIC_ANALYSIS")
        equal(analysis.inputSource,"FIELD_WORLD_CANONICAL_ROOT_VERTICES_DEQUANTIZED")
        equal(analysis.coordinateUnits,"WORLD_METRES")
        equal(analysis.quantizationMetres,0.1)
        equal(analysis.sourceBoundaryPointCount,11)
        equal(analysis.canonicalBoundaryPointCount,10)
        equal(analysis.registryBoundaryPointCount,10)
        equal(analysis.originalPointCount,10)
        equal(string.format("%.3f",analysis.largestScaleGapBeforeM),string.format("%.3f",direct.largestScaleGapBeforeM))
        equal(string.format("%.3f",analysis.largestScaleGapAfterM),string.format("%.3f",direct.largestScaleGapAfterM))
        equal(string.format("%.3f",analysis.largestScaleGapRatio),string.format("%.3f",direct.largestScaleGapRatio))
        local four=stageAt(analysis,4)
        local expected=coordinateSet(stageAt(direct,4))
        for key in OuttaMyWay.ValueRecord.pairs(expected) do
            equal(coordinateSet(four)[key],true,"de-quantized four-survivor stage missing "..key)
        end
        if not (analysis.removals[1].removalScaleM>0) then
            error("canonical ring must not manufacture zero-scale closing-duplicate removal")
        end
    end)

    test("Boundary persistence probe: live snapshot fails closed when canonical root ring is unavailable",function()
        local closed={}
        for _,vertex in OuttaMyWay.ValueRecord.ipairs(field10) do
            closed[#closed+1]={x=vertex.x,z=vertex.z}
        end
        closed[#closed+1]={x=field10[1].x,z=field10[1].z}
        local analysis=Probe.analyzeSnapshot({boundary=closed,quantizationMetres=0.1,boundaryPointCount=10})
        equal(analysis.status,"UNRESOLVED")
        equal(analysis.reason,"CANONICAL_ROOT_VERTICES_UNAVAILABLE")
        equal(analysis.sourceBoundaryPointCount,11)
        equal(analysis.canonicalBoundaryPointCount,0)
        equal(analysis.semanticAuthority,false)
    end)

    test("Boundary persistence probe: canonical metric analysis fails closed without quantization scale",function()
        local analysis=Probe.analyzeSnapshot({
            boundary=field10,
            canonicalRootVertices=quantized(field10,0.1),
            boundaryPointCount=10
        })
        equal(analysis.status,"UNRESOLVED")
        equal(analysis.reason,"CANONICAL_QUANTIZATION_UNAVAILABLE")
        equal(analysis.semanticAuthority,false)
    end)

    test("Boundary persistence probe: no Corner classification is manufactured",function()
        local analysis=Probe.analyzeBoundary(field10)
        equal(analysis.cornerFeatures,nil)
        equal(analysis.headlandRegimes,nil)
        equal(analysis.classification,nil)
        equal(analysis.provenance.authority,"DIAGNOSTIC_ONLY")
    end)
end
