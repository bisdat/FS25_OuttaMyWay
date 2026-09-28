--- Builds mechanically steerable forward-diagonal targets for Passage lateral excursion.
-- Specification Jurisdictions: `COOPERATIVE_PASSAGE`

OuttaMyWay.ForwardDiagonalSteeringHelper={}
local Helper=OuttaMyWay.ForwardDiagonalSteeringHelper

-- Mechanical calibration only. This value MUST NOT contribute to Passage Entry
-- Boundary or Capture Reserve. It defines the steering target shape used after
-- the realised Transit execution origin is captured.
local FORWARD_PER_LATERAL_M=2.0

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

function Helper.profile(lateralOffsetM)
    local offset=tonumber(lateralOffsetM)
    if not finite(offset) then return nil,"FORWARD_DIAGONAL_LATERAL_OFFSET_INVALID" end
    local burden=math.abs(offset)
    local required=burden>0.001
    return {
        kind="FORWARD_DIAGONAL_2_TO_1",
        lateralOffsetM=offset,
        lateralBurdenM=burden,
        required=required,
        forwardPerLateralM=FORWARD_PER_LATERAL_M,
        forwardDistanceM=required and burden*FORWARD_PER_LATERAL_M or 0
    },nil
end

function Helper.forwardPerLateralM()
    return FORWARD_PER_LATERAL_M
end
