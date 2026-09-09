-- Authority-owned Follower Boundary magnitude materialisation.
--
-- Situation Assessment owns the current admissible magnitude envelope.
-- Bounded Authority owns the final physical permission derived from it.
--
-- Admissible Envelope != Authorised Target.

OuttaMyWay.FollowerBoundaryMagnitudePolicy = {}
local Policy=OuttaMyWay.FollowerBoundaryMagnitudePolicy

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

function Policy.materialize(evidence)
    if type(evidence)~="table" or evidence.status~="SUPPORTED" then
        return nil,"FOLLOWER_BOUNDARY_MAGNITUDE_EVIDENCE_UNSUPPORTED"
    end

    local native=tonumber(evidence.nativeUnrestrictedFollowerKmh)
    if not finite(native) or native<0 then
        return nil,"FOLLOWER_BOUNDARY_NATIVE_RATE_UNAVAILABLE"
    end

    local admissible=tonumber(evidence.maxAdmissibleFollowerKmh)
    if not finite(admissible) or admissible<0 then
        return nil,"FOLLOWER_BOUNDARY_ADMISSIBLE_RATE_UNAVAILABLE"
    end

    return {
        permittedFollowerCapKmh=math.min(native,admissible),
        nativeUnrestrictedFollowerKmh=native,
        maxAdmissibleFollowerKmh=admissible,
        unscaledMaxAdmissibleFollowerKmh=tonumber(evidence.unscaledMaxAdmissibleFollowerKmh),
        clearanceFactor=tonumber(evidence.clearanceFactor),
        clearanceFactorApplied=evidence.clearanceFactorApplied==true,
        leaderObservedProgressKmh=tonumber(evidence.leaderObservedProgressKmh),
        leaderNativeCommandKmh=tonumber(evidence.leaderNativeCommandKmh),
        leaderRateUsedKmh=tonumber(evidence.leaderRateUsedKmh),
        transitionPreservation=evidence.transitionPreservation==true,
        provenance={source="FollowerBoundaryMagnitudePolicy",authority="FOLLOWER_BOUNDARY_PERMISSIBLE_MAGNITUDE"}
    },nil
end
