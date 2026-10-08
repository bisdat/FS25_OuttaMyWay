-- Pure, unwired evaluator: verified native blocked time plus current root positions.
-- Specification Jurisdictions: `SPATIAL_PAIR_INFERENCE`
-- This module has no GIANTS observation, lifecycle, collision, or Control effects.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.SpatialPairInference={}
local SpatialPairInference=OuttaMyWay.SpatialPairInference

local function finite(value)
    return type(value)=="number" and value==value
        and value~=math.huge and value~=-math.huge
end

local function positioned(value)
    return type(value)=="table" and value.rootId~=nil
        and finite(value.x) and finite(value.z)
end

-- confirmedBlockedMs is *already* accumulated over positively confirmed
-- blocked intervals in one unresolved encounter by a future source.
-- roots is a plain array of already eligible/current root records, not a proxy.
-- Result: candidate identity and planar root distance, or nil.
function SpatialPairInference.evaluate(confirmedBlockedMs,blocked,roots)
    if not finite(confirmedBlockedMs) or confirmedBlockedMs<1000
        or not positioned(blocked) or type(roots)~="table" then
        return nil
    end

    local nearest=nil
    local nearestSquared=900 -- 30 m radius, not collision extent
    for i=1,#roots do
        local other=roots[i]
        if positioned(other) and other.eligible==true
            and other.rootId~=blocked.rootId then
            local dx=other.x-blocked.x
            local dz=other.z-blocked.z
            local squared=dx*dx+dz*dz
            if finite(squared) and squared<=900
                and (nearest==nil or squared<nearestSquared) then
                nearest=other
                nearestSquared=squared
            end
        end
    end
    if nearest==nil then return nil end
    return {rootId=nearest.rootId,distanceMetres=math.sqrt(nearestSquared)}
end
