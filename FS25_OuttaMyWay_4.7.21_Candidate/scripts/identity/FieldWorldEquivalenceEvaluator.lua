OuttaMyWay.FieldWorldEquivalenceEvaluator = {}
local Evaluator = OuttaMyWay.FieldWorldEquivalenceEvaluator
Evaluator.__index = Evaluator

local function threshold(name, fallback)
    local value = tonumber(OuttaMyWay[name])
    return value ~= nil and value or fallback
end

local function sameEnvelope(comparison)
    return comparison.sameIslandTopology == true
        and comparison.areaRelativeDelta <= threshold("FIELD_WORLD_EQUIVALENCE_SAME_MAX_AREA_RELATIVE_DELTA", 0.005)
        and comparison.perimeterRelativeDelta <= threshold("FIELD_WORLD_EQUIVALENCE_SAME_MAX_PERIMETER_RELATIVE_DELTA", 0.002)
        and comparison.centroidDistanceMetres <= threshold("FIELD_WORLD_EQUIVALENCE_SAME_MAX_CENTROID_DISTANCE_METRES", 0.5)
        and comparison.boundsMaxDeltaMetres <= threshold("FIELD_WORLD_EQUIVALENCE_SAME_MAX_BOUNDS_DELTA_METRES", 0.5)
        and comparison.symmetricBoundaryMeanDistanceMetres <= threshold("FIELD_WORLD_EQUIVALENCE_SAME_MAX_BOUNDARY_MEAN_DISTANCE_METRES", 0.5)
        and comparison.symmetricBoundaryMaxDistanceMetres <= threshold("FIELD_WORLD_EQUIVALENCE_SAME_MAX_BOUNDARY_MAX_DISTANCE_METRES", 2.0)
        and comparison.sampledJaccard >= threshold("FIELD_WORLD_EQUIVALENCE_SAME_MIN_SAMPLED_JACCARD", 0.995)
end

local function positivelyDifferent(comparison)
    return comparison.occupiedRegionsDisjoint == true
        and comparison.outerBoundariesIntersect == false
        and comparison.minimumBoundaryDistanceMetres > threshold("FIELD_WORLD_EQUIVALENCE_DIFFERENT_MIN_BOUNDARY_SEPARATION_METRES", 0.2)
        and comparison.sampledIntersection == 0
        and comparison.verticesAInsideBFraction == 0
        and comparison.verticesBInsideAFraction == 0
end

function Evaluator.new()
    return setmetatable({evaluationCount=0}, Evaluator)
end

function Evaluator:evaluate(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then error("Field World equivalence evaluation requires two Snapshots", 2) end
    if type(a.geometryMetrics) ~= "table" or type(b.geometryMetrics) ~= "table" then error("Field World equivalence evaluation requires geometry metrics", 2) end
    self.evaluationCount = self.evaluationCount + 1
    local exactCanonicalGeometry = type(a.canonicalGeometry) == "string"
        and type(b.canonicalGeometry) == "string"
        and a.canonicalGeometry == b.canonicalGeometry
    local comparison = OuttaMyWay.FieldWorldSnapshotRegistry.compareGeometry(
        a.geometryMetrics,
        b.geometryMetrics,
        OuttaMyWay.FIELD_WORLD_EQUIVALENCE_SAMPLE_SIDE or 31
    )
    local outcome, reason
    if exactCanonicalGeometry then
        outcome, reason = "SAME_FIELD_WORLD", "EXACT_CANONICAL_GEOMETRY"
    elseif sameEnvelope(comparison) then
        outcome, reason = "SAME_FIELD_WORLD", "COMPOUND_POSITIVE_SPATIAL_EQUIVALENCE"
    elseif positivelyDifferent(comparison) then
        outcome, reason = "DIFFERENT_FIELD_WORLD", "COMPOUND_POSITIVE_SPATIAL_SEPARATION"
    else
        outcome, reason = "UNRESOLVED", "EVIDENCE_OUTSIDE_POSITIVE_SAME_AND_DIFFERENT_CONTRACTS"
    end
    return {
        outcome=outcome,
        reason=reason,
        exactCanonicalGeometry=exactCanonicalGeometry,
        exactFingerprint=a.geometryFingerprint == b.geometryFingerprint,
        comparison=comparison,
        currentSnapshotReferenceKey=a.referenceKey,
        referenceSnapshotReferenceKey=b.referenceKey,
        controlAuthorityEnabled=false
    }
end

function Evaluator:getEvaluationCount() return self.evaluationCount end
