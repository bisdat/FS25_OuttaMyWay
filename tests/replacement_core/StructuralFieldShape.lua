-- Production Structural Field Shape assessment challenges.
-- These tests assert conservative positive Corner Feature interpretation without
-- granting Candidate, Decision, Responsibility, Bounded Authority or Control authority.
return function(test,equal)
    local Assessment=OuttaMyWay.StructuralFieldShapeAssessment

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

    local function world(points,quantum)
        local canonical,reason=OuttaMyWay.FieldWorldSnapshotRegistry.canonicalizeBoundary(points,{},quantum or 0.1)
        if canonical==nil then error(reason or "canonicalization failed") end
        return {
            canonicalRootVertices=canonical.canonicalRootVertices,
            canonicalRootRing=canonical.canonicalRootRing,
            quantizationMetres=canonical.quantizationMetres,
            islands={},
            representativeSnapshotReferenceKey="fixture"
        }
    end

    local function representativeSet(result)
        local values={}
        for _,feature in OuttaMyWay.ValueRecord.ipairs(result.cornerFeatures or {}) do
            values[string.format("%.1f,%.1f",feature.representativePoint.x,feature.representativePoint.z)]=true
        end
        return values
    end

    local function keys(result)
        local values={}
        for _,feature in OuttaMyWay.ValueRecord.ipairs(result.cornerFeatures or {}) do values[#values+1]=feature.cornerKey end
        table.sort(values)
        return table.concat(values,"\n")
    end

    test("Structural Field Shape: Field 77 sampling variants establish the same four Corner Features",function()
        local ten=Assessment.new():assess(world(field10),"field-world:test-77")
        local eleven=Assessment.new():assess(world(field11),"field-world:test-77")
        equal(ten.status,"POSITIVE_STRUCTURAL_FIELD_SHAPE_SUPPORTED")
        equal(eleven.status,"POSITIVE_STRUCTURAL_FIELD_SHAPE_SUPPORTED")
        equal(OuttaMyWay.ValueRecord.length(ten.cornerFeatures),4)
        equal(OuttaMyWay.ValueRecord.length(eleven.cornerFeatures),4)
        equal(keys(ten),keys(eleven))
        local expected={
            ["-0.3,-206.8"]=true,["-40.8,-677.8"]=true,
            ["132.3,-701.3"]=true,["228.8,-242.8"]=true
        }
        local actual=representativeSet(ten)
        for key in OuttaMyWay.ValueRecord.pairs(expected) do equal(actual[key],true,"missing structural Field 77 Corner "..key) end
    end)

    test("Structural Field Shape: smooth regular circle does not manufacture positive Corner Features",function()
        local circle={}
        for index=0,31 do
            local angle=(math.pi*2*index)/32
            circle[#circle+1]={x=100*math.cos(angle),z=100*math.sin(angle)}
        end
        local result=Assessment.new():assess(world(circle),"field-world:circle")
        equal(result.status,"UNRESOLVED_NO_POSITIVE_CORNER_FEATURE")
        equal(OuttaMyWay.ValueRecord.length(result.cornerFeatures),0)
        equal(result.decisionAuthority,false)
        equal(result.controlAuthority,false)
    end)

    test("Structural Field Shape: rejoining local perturbation does not create an extra Corner Feature",function()
        local bump={
            {x=0,z=0},{x=100,z=0},{x=100,z=100},{x=60,z=100},
            {x=60,z=110},{x=50,z=110},{x=50,z=100},{x=0,z=100}
        }
        local result=Assessment.new():assess(world(bump),"field-world:bump")
        equal(OuttaMyWay.ValueRecord.length(result.cornerFeatures),4)
        local actual=representativeSet(result)
        equal(actual["0.0,0.0"],true)
        equal(actual["100.0,0.0"],true)
        equal(actual["100.0,100.0"],true)
        equal(actual["0.0,100.0"],true)
        equal(actual["60.0,110.0"],nil)
        equal(actual["50.0,110.0"],nil)
    end)

    test("Structural Field Shape: peninsula structure survives literal tip-sample removal",function()
        local peninsula={
            {x=0,z=0},{x=100,z=0},{x=100,z=100},{x=65,z=100},
            {x=65,z=145},{x=35,z=145},{x=35,z=100},{x=0,z=100}
        }
        local result=Assessment.new():assess(world(peninsula),"field-world:peninsula")
        local represented=false
        for _,feature in OuttaMyWay.ValueRecord.ipairs(result.cornerFeatures or {}) do
            if feature.representativePoint.z>=145 then represented=true break end
        end
        equal(represented,true,"peninsula structural transition should remain positively represented")
    end)

    test("Structural Field Shape: feature identity is Field World scoped rather than exact sampled-ring scoped",function()
        local assessment=Assessment.new()
        local first=assessment:assess(world(field10),"field-world:equivalent")
        local second=assessment:assess(world(field11),"field-world:equivalent")
        equal(first.status,"POSITIVE_STRUCTURAL_FIELD_SHAPE_SUPPORTED")
        equal(second.status,"POSITIVE_STRUCTURAL_FIELD_SHAPE_SUPPORTED")
        equal(keys(first),keys(second))
    end)
end
