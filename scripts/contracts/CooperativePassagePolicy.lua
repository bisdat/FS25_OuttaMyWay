--- Fixed Cooperative Passage policy values shared by Situation and Candidate layers.
-- Specification Jurisdictions: `COOPERATIVE_PASSAGE`

OuttaMyWay.CooperativePassagePolicy={}
local Policy=OuttaMyWay.CooperativePassagePolicy

-- Accepted nominal non-contact margin. This is a Passage policy calibration,
-- not a universal collision-model tolerance.
Policy.NOMINAL_INTER_ASSEMBLY_CLEARANCE_M=1.0
