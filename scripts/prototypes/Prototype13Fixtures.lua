-- FS25_OuttaMyWay v4.6.21
-- Prototype 13A fixture declarations. These tables declare diagnostic lookup
-- hypotheses only; the resolver/evaluator must establish what each result proves.

OuttaMyWay.Prototype13Fixtures = OuttaMyWay.Prototype13Fixtures or {}
local Fixtures = OuttaMyWay.Prototype13Fixtures

local function route(label, routeType, values)
    local result = values or {}
    result.label = label
    result.routeType = routeType
    return result
end

Fixtures.list = {
    {
        id="CONDOR_36M",
        scenario="TS001_POSITIVE_CONTROL",
        assetSuffix="data/vehicles/agrifac/condorEndurance2/condorEndurance2.xml",
        family="CONDOR_BOOM",
        sourceAuthority="compoundChild+foldingConfiguration1",
        shapes={
            {
                id="CONDOR_LEFT_INNER", sourceNode="boom01ArmLeftCol01", sourceShapeId=88,
                expectedRuntimeName="boom01ArmLeftCol01", expectedComponentIndex=1,
                routes={
                    route("A", "DIRECT_MAPPING", {mappingKey="boom01ArmLeftCol01"}),
                    route("B", "COMPONENT_DESCENDANT", {componentIndex=1, path="0|4|2|0|0|0|0|0|0|0|0|0|0|0|0|0|7"}),
                    route("C", "COMPONENT_DESCENDANT", {componentIndex=1, path="0|4|2|0|0|0|0|0|0|0|0|1|0|0|0|0|7", control=true, expectedControl="REJECT_WRONG_SIBLING"})
                }
            },
            {
                id="CONDOR_RIGHT_INNER", sourceNode="boom01ArmRightCol01", sourceShapeId=150,
                expectedRuntimeName="boom01ArmRightCol01", expectedComponentIndex=1,
                routes={
                    route("A", "DIRECT_MAPPING", {mappingKey="boom01ArmRightCol01"}),
                    route("B", "COMPONENT_DESCENDANT", {componentIndex=1, path="0|4|2|0|0|0|0|0|0|0|0|1|0|0|0|0|7"}),
                    route("C", "COMPONENT_DESCENDANT", {componentIndex=1, path="0|4|2|0|0|0|0|0|0|0|0|0|0|0|0|0|7", control=true, expectedControl="REJECT_WRONG_SIBLING"})
                }
            },
            {
                id="CONDOR_LEFT_OUTER", sourceNode="boom01ArmLeftCol03", sourceShapeId=76,
                expectedRuntimeName="boom01ArmLeftCol03", expectedComponentIndex=1,
                routes={
                    route("A", "DIRECT_MAPPING", {mappingKey="boom01ArmLeftCol03"}),
                    route("B", "COMPONENT_DESCENDANT", {componentIndex=1, path="0|4|2|0|0|0|0|0|0|0|0|0|0|0|0|0|1|1|5"}),
                    route("C", "COMPONENT_DESCENDANT", {componentIndex=1, path="0|4|2|0|0|0|0|0|0|0|0|1|0|0|0|0|1|1|5", control=true, expectedControl="REJECT_WRONG_SIBLING"})
                }
            },
            {
                id="CONDOR_RIGHT_OUTER", sourceNode="boom01ArmRightCol03", sourceShapeId=138,
                expectedRuntimeName="boom01ArmRightCol03", expectedComponentIndex=1,
                routes={
                    route("A", "DIRECT_MAPPING", {mappingKey="boom01ArmRightCol03"}),
                    route("B", "COMPONENT_DESCENDANT", {componentIndex=1, path="0|4|2|0|0|0|0|0|0|0|0|1|0|0|0|0|1|1|5"}),
                    route("C", "COMPONENT_DESCENDANT", {componentIndex=1, path="0|4|2|0|0|0|0|0|0|0|0|0|0|0|0|0|1|1|5", control=true, expectedControl="REJECT_WRONG_SIBLING"})
                }
            }
        }
    },
    {
        id="TS004_TIGER8MT",
        scenario="TS004_UNIT1",
        assetSuffix="data/vehicles/horsch/tiger8MT/tiger8MT.xml",
        family="TIGER_WING_COLPART",
        sourceAuthority="compoundChild+vehicleType2+design1",
        shapes={
            {
                id="TIGER_LEFT_WING", sourceNode="component4/colPart", sourceShapeId=101,
                expectedRuntimeName="colPart", expectedComponentIndex=4,
                routes={
                    route("A", "COMPONENT_DESCENDANT", {componentIndex=4, path="1|2"}),
                    route("B", "MAPPED_ANCHOR_DESCENDANT", {mappingKey="tiger8MT_armRight_component4", path="1|2", expectedAnchorComponentIndex=4}),
                    route("C", "COMPONENT_DESCENDANT", {componentIndex=5, path="1|2", control=true, expectedControl="REJECT_WRONG_COMPONENT"})
                }
            },
            {
                id="TIGER_RIGHT_WING", sourceNode="component5/colPart", sourceShapeId=104,
                expectedRuntimeName="colPart", expectedComponentIndex=5,
                routes={
                    route("A", "COMPONENT_DESCENDANT", {componentIndex=5, path="1|2"}),
                    route("B", "MAPPED_ANCHOR_DESCENDANT", {mappingKey="tiger8MT_armRight_component5", path="1|2", expectedAnchorComponentIndex=5}),
                    route("C", "COMPONENT_DESCENDANT", {componentIndex=4, path="1|2", control=true, expectedControl="REJECT_WRONG_COMPONENT"})
                }
            }
        }
    },
    {
        id="TS004_TOPDOWN600",
        scenario="TS004_UNIT2",
        assetSuffix="data/vehicles/vaderstad/topDown600/topDown600.xml",
        family="TOPDOWN_FOLDING_ARM_COLPART",
        sourceAuthority="compoundChild+vehicleType1",
        shapes={
            {
                id="TOPDOWN_LEFT_ARM", sourceNode="leftArm_colPart", sourceShapeId=16,
                expectedRuntimeName="leftArm_colPart", expectedComponentIndex=1,
                routes={
                    route("A", "MAPPED_ANCHOR_DESCENDANT", {mappingKey="leftArm", path="12", expectedAnchorComponentIndex=1}),
                    route("B", "COMPONENT_DESCENDANT", {componentIndex=1, path="0|1|4|0|0|12"}),
                    route("C", "MAPPED_ANCHOR_DESCENDANT", {mappingKey="rightArm", path="12", control=true, expectedControl="REJECT_WRONG_SIBLING"})
                }
            },
            {
                id="TOPDOWN_RIGHT_ARM", sourceNode="rightArm_colPart", sourceShapeId=24,
                expectedRuntimeName="rightArm_colPart", expectedComponentIndex=1,
                routes={
                    route("A", "MAPPED_ANCHOR_DESCENDANT", {mappingKey="rightArm", path="12", expectedAnchorComponentIndex=1}),
                    route("B", "COMPONENT_DESCENDANT", {componentIndex=1, path="0|1|6|0|0|12"}),
                    route("C", "MAPPED_ANCHOR_DESCENDANT", {mappingKey="leftArm", path="12", control=true, expectedControl="REJECT_WRONG_SIBLING"})
                }
            }
        }
    }
}

local function normaliseAsset(value)
    return string.lower(string.gsub(tostring(value or ""), "\\", "/"))
end

local function endsWith(value, suffix)
    value, suffix = normaliseAsset(value), normaliseAsset(suffix)
    return suffix ~= "" and string.sub(value, -string.len(suffix)) == suffix
end

function Fixtures:assetName(object)
    return normaliseAsset(object and (object.configFileName or object.configFileNameClean or object.xmlFilename) or "")
end

function Fixtures:match(object)
    local asset = self:assetName(object)
    for _, fixture in ipairs(self.list) do
        if endsWith(asset, fixture.assetSuffix) then return fixture, asset end
    end
    return nil, asset
end
