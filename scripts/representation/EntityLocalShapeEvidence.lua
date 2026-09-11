OuttaMyWay.EntityLocalShapeEvidence = {}
local Evidence=OuttaMyWay.EntityLocalShapeEvidence

-- Resolution-evidence calibration. These values answer one shared question:
-- whether measured Entity-local geometry and current world pose are mutually
-- coherent, and whether a descendant merely aliases its Physical Assembly root.
local GEOMETRY_COHERENCE_TOLERANCE_METRES=0.05
local ROOT_ALIAS_TOLERANCE_METRES=0.0001

local function sphereDifference(a,b)
    if a==nil or b==nil or a.valid~=true or b.valid~=true then return nil,nil end
    local dx=a.x-b.x
    local dy=a.y-b.y
    local dz=a.z-b.z
    return math.sqrt(dx*dx+dy*dy+dz*dz),math.abs(a.radius-b.radius)
end

function Evidence.evaluate(memberRootNode,node,localSphere,predictedWorld,worldSphere,rootWorldSphere)
    local centreError,radiusError=sphereDifference(predictedWorld,worldSphere)
    local coherent=localSphere~=nil
        and worldSphere~=nil and worldSphere.valid==true
        and centreError~=nil and centreError<=GEOMETRY_COHERENCE_TOLERANCE_METRES
        and radiusError~=nil and radiusError<=GEOMETRY_COHERENCE_TOLERANCE_METRES

    local aliasCentreError,aliasRadiusError=sphereDifference(worldSphere,rootWorldSphere)
    local rootAlias=node~=memberRootNode
        and aliasCentreError~=nil and aliasRadiusError~=nil
        and aliasCentreError<=ROOT_ALIAS_TOLERANCE_METRES
        and aliasRadiusError<=ROOT_ALIAS_TOLERANCE_METRES

    return {
        accepted=coherent and not rootAlias,
        coherent=coherent,
        rootAlias=rootAlias,
        centreError=centreError,
        radiusError=radiusError,
        aliasCentreError=aliasCentreError,
        aliasRadiusError=aliasRadiusError
    }
end
