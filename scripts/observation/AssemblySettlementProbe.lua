-- TEST-only actual-assembly nominal geometry witness for Field 77 edge 9.
-- Specification Jurisdictions: `SETTLEMENT_CORRIDOR_ASSESSMENT`
-- No virtual projection is a parking target, route, or physical clearance.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.AssemblySettlementProbe={}
local Probe=OuttaMyWay.AssemblySettlementProbe
local G=OuttaMyWay.FarmEdgeGeometry
local Assessment=OuttaMyWay.SettlementCorridorAssessment
local publication=OuttaMyWay.LogPublication.origin("ASSEMBLY_SETTLEMENT")
local EXPECTED_EDGE={index=9,length=230.97,
    ax=228.15,az=-243.04,bx=-0.06,bz=-207.44}
local ENDPOINT_TOLERANCE_M=3
local MAX_SCENE_OBJECTS=400
local MAX_SUBJECTS=3
local MAX_OUTSIDE_EDGE_DISTANCE_M=20
local function finite(x)
    return type(x)=="number" and x==x
        and x~=math.huge and x~=-math.huge
end
local function fmt(x)
    return finite(x) and string.format("%.2f",x) or "unknown"
end
local function publish(code,fields)
    publication:publish("DIAGNOSTIC","INFO",code,function()
        fields.version=OuttaMyWay.VERSION
        return fields
    end)
end
local function matchingFixture(fieldId,edges,selectedFarmlandId)
    if fieldId~=77 or selectedFarmlandId~=nil then return nil end
    local e=type(edges)=="table" and edges[9] or nil
    if e==nil or e.index~=EXPECTED_EDGE.index
        or not finite(e.length) or math.abs(e.length-EXPECTED_EDGE.length)>3 then
        return nil
    end
    for _,key in ipairs({"ax","az","bx","bz"}) do
        if not finite(e[key]) or math.abs(e[key]-EXPECTED_EDGE[key])
            >ENDPOINT_TOLERANCE_M then return nil end
    end
    return e
end
local function rootOf(vehicle)
    if type(vehicle)~="table" or vehicle.isDeleted==true
        or vehicle.rootNode==nil then return false end
    if type(vehicle.getRootVehicle)=="function" then
        local ok,root=pcall(vehicle.getRootVehicle,vehicle)
        if not ok or root~=vehicle then return false end
    elseif type(vehicle.getAttacherVehicle)=="function" then
        local ok,attached=pcall(vehicle.getAttacherVehicle,vehicle)
        if not ok or attached~=nil then return false end
    end
    return true
end
local function pose(vehicle)
    if type(getWorldTranslation)~="function"
        or type(localDirectionToWorld)~="function" then
        return nil,nil,nil,nil,"WORLD_POSE_API_UNAVAILABLE"
    end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    if not ok or not finite(x) or not finite(z) then
        return nil,nil,nil,nil,"ROOT_TRANSLATION_UNAVAILABLE"
    end
    local got,fx,_,fz=pcall(localDirectionToWorld,vehicle.rootNode,0,0,1)
    if not got or not finite(fx) or not finite(fz) then
        return x,z,nil,nil,"ROOT_DIRECTION_UNAVAILABLE"
    end
    local mag=math.sqrt(fx*fx+fz*fz)
    if mag<0.0001 then return x,z,nil,nil,"ROOT_DIRECTION_INVALID" end
    return x,z,fx/mag,fz/mag,nil
end

-- Run ONLY under FarmSpatialContextProbe's accepted server-side DIAGNOSTIC
-- gate, immediately after its spatial + physics survey. This module does
-- not create a new timer, listener or independent publication policy.
function Probe.run(fieldId,poly,edges,neighbors,registryTruncated,selectedFarmlandId)
    local edge=matchingFixture(fieldId,edges,selectedFarmlandId)
    if edge==nil then return false,"ASSEMBLY_FIXTURE_MISMATCH" end
    -- GIANTS FS25 VehicleSystem owns the live savegame vehicle population.
    -- Mission.vehicles is not the native catalogue (observed 0.5.5.4).
    local system=g_currentMission and g_currentMission.vehicleSystem
    local world=system and system.vehicles
    if type(world)~="table" then
        publish("ASSEMBLY_SETTLEMENT_UNAVAILABLE",{
            field=fieldId,edge=edge.index,reason="VEHICLE_CATALOGUE_UNAVAILABLE"
        })
        return false,"VEHICLE_CATALOGUE_UNAVAILABLE"
    end
    local subjects,scanned,truncated={},0,false
    for _,vehicle in pairs(world) do
        scanned=scanned+1
        if scanned>MAX_SCENE_OBJECTS then truncated=true;break end
        if rootOf(vehicle) then
            local x,z,fx,fz,reason=pose(vehicle)
            if x~=nil then
                local inField=G.inside(poly,x,z)
                local dist=G.pointSegmentDistance(x,z,
                    edge.ax,edge.az,edge.bx,edge.bz)
                if inField or dist<=MAX_OUTSIDE_EDGE_DISTANCE_M then
                    subjects[#subjects+1]={vehicle=vehicle,
                        x=x,z=z,fx=fx,fz=fz,reason=reason,
                        distance=dist,inField=inField}
                end
            end
        end
    end
    table.sort(subjects,function(a,b)
        if a.distance~=b.distance then return a.distance<b.distance end
        return tostring(a.vehicle.rootNode)<tostring(b.vehicle.rootNode)
    end)
    local selected=math.min(MAX_SUBJECTS,#subjects)
    publish("ASSEMBLY_SETTLEMENT_SCAN",{
        field=fieldId,edge=edge.index,sceneScanned=scanned,
        sceneTruncated=truncated,
        candidatesNearField=#subjects,selectedSubjects=selected,
        neighborCatalogueTruncated=registryTruncated,
        note="NOMINAL_GEOMETRY_ONLY_NO_VEHICLE_MOVEMENT"
    })
    for i=1,selected do
        local subject=subjects[i]
        local vehicle=subject.vehicle
        local record={field=fieldId,edge=edge.index,
            rootNode=tostring(vehicle.rootNode),
            rootX=fmt(subject.x),rootZ=fmt(subject.z),
            distanceToEdgeM=fmt(subject.distance),
            rootInsideSourceField=subject.inField,
            approach="WAITING_FOR_EVIDENCE",
            runOut="WAITING_FOR_EVIDENCE",
            terminal="WAITING_FOR_EVIDENCE",
            configuration="UNVERIFIED_TRANSIT",
            note="CANDIDATE_ONLY_NEVER_MOVEMENT_AUTHORITY"}
        if subject.reason~=nil then
            record.reason=subject.reason
            record.nominalCandidateCount=0
        else
            local source=OuttaMyWay.PairTransitRegion
            local foot,reason=nil,"CAPTURE_API_UNAVAILABLE"
            if type(source)=="table" and type(source.capture)=="function" then
                local ok,value,why=pcall(source.capture,vehicle)
                if ok then foot,reason=value,why
                else reason="CAPTURE_EXCEPTION" end
            end
            if foot==nil then
                record.reason=reason or "MEMBER_FOOTPRINT_UNAVAILABLE"
                record.nominalCandidateCount=0
            else
                record.memberCount=foot.memberCount
                record.nominalBasis=foot.basis
                local ok,assessed=pcall(Assessment.assess,
                    foot,subject.fx,subject.fz,poly,edge,neighbors,
                    registryTruncated or truncated)
                if not ok or type(assessed)~="table" then
                    record.reason="ASSESSMENT_EXCEPTION"
                else
                    record.reason=assessed.reason
                    record.nominalScreened=assessed.assessed
                    record.nominalCandidateCount=assessed.nominalNoPolygonConflict
                    record.sourceConflicts=assessed.sourceConflicts
                    record.neighborConflicts=assessed.neighborConflicts
                    record.edgeSpill=assessed.edgeSpill
                    record.unknown=assessed.unknown
                    if assessed.best then
                        record.exampleStationM=fmt(assessed.best.stationM)
                        record.exampleRootDepthM=fmt(assessed.best.depthM)
                        record.exampleAlongEdgeDirection=assessed.best.direction
                        record.nominalProjectedWidthM=fmt(assessed.best.nominalWidthM)
                        record.nominalProjectedLengthM=fmt(assessed.best.nominalLengthM)
                    end
                end
            end
        end
        publish("ASSEMBLY_SETTLEMENT_NOMINAL_SCREENED",record)
    end
    if #subjects==0 then
        publish("ASSEMBLY_SETTLEMENT_UNAVAILABLE",{
            field=fieldId,edge=edge.index,
            reason="NO_ASSEMBLY_IN_FIELD_OR_NEAR_EDGE"
        })
    end
    publish("ASSEMBLY_SETTLEMENT_FINISHED",{
        field=fieldId,edge=edge.index,
        observedSubjects=selected,sceneTruncated=truncated,
        note="NOMINAL_POLYGON_ONLY_APPROACH_RUNOUT_TERMINAL_UNRESOLVED"
    })
    return true
end

return Probe
