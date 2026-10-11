-- Bounded, strictly read-only cross-section experiment for #476.
-- Specification Jurisdictions: `FARM_SPATIAL_CONTEXT_OBSERVATION`
-- Physics hits are positive witnesses, NOT a clearance or parking verdict.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.PhysicalMarginConstraintProbe={}
local Probe=OuttaMyWay.PhysicalMarginConstraintProbe
Probe.__index=Probe
local G=OuttaMyWay.FarmEdgeGeometry
local publication=OuttaMyWay.LogPublication.origin("PHYSICAL_MARGIN")

-- Named GIANTS Reality fixtures only. No field/edge below becomes a
-- production preference, route, or destination. Reject geometry mismatch.
local FIXTURES={
    default={
        name="MINDENERWALD_FIELD77",field=77,
        edge=9,length=230.97,
        endpoints={228.15,-243.04,-0.06,-207.44},
        depths={-2,1,2,3,4,6,8,12},
        controlEdge=2,controlLength=48.26,
        controlEndpoints={143.52,-656.06,153.81,-608.91},
        controls={{station=8,depths={2,6,12}},
                  {station=40,depths={2,6,12}}}
    },
    farmland2={
        name="RIVERBEND_FARMLAND2_FIELD29",field=29,
        edge=1,length=141.99,
        endpoints={-898.15,304.13,-849.01,170.91},
        depths={-2,2,6,12,18,24,30},
        controlEdge=7,controlLength=59.99,
        controlEndpoints={-910.16,123.27,-969.82,117.04},
        controls={{fraction=0.5,depths={2,6,12,18,24,30}}}
    }
}
local EDGE_LENGTH_TOLERANCE_M=3
local ENDPOINT_TOLERANCE_M=3
local MAX_QUERY_POINTS=24
local MAX_PHYSICS_CALLS=22
local MAX_RECORDED_HITS=8
local BOX_HALF_X,BOX_HALF_Y,BOX_HALF_Z=0.45,1.0,0.45
local BOX_BOTTOM_ABOVE_TERRAIN_M=0.10
local MASK_NAMES={"STATIC_OBJECT","BUILDING","TREE","ROAD","AI_BLOCKING"}

local function finite(x)
    return type(x)=="number" and x==x and x~=math.huge and x~=-math.huge
end
local function fmt(x)
    if not finite(x) then return "unknown" end
    return string.format("%.2f",x)
end
local function publish(code,fields)
    publication:publish("DIAGNOSTIC","INFO",code,function()
        fields.version=OuttaMyWay.VERSION
        return fields
    end)
end
local function maskForPhysics()
    if type(CollisionFlag)~="table" then return nil,"COLLISION_FLAGS_UNAVAILABLE" end
    local mask=0
    local available=0
    for i=1,#MASK_NAMES do
        local flag=CollisionFlag[MASK_NAMES[i]]
        if finite(flag) and flag>0 then
            mask=mask+flag
            available=available+1
        end
    end
    if available==0 then return nil,"COLLISION_MASK_UNAVAILABLE" end
    return mask,nil
end
local function groupHit(node,group)
    local flag=type(CollisionFlag)=="table" and CollisionFlag[group]
    local classifier=type(CollisionFlag)=="table" and CollisionFlag.getHasGroupFlagSet
    if not finite(flag) or type(classifier)~="function" then return nil end
    local ok,hit=pcall(classifier,node,flag)
    if ok and type(hit)=="boolean" then return hit end
    return nil
end

-- GIANTS overlapBox calls "onOverlapHit" synchronously with hit node ID
-- on the specified callback target. No scene mutation is performed.
function Probe:onOverlapHit(node)
    if node==nil or node==0 or self.hitState==nil then return end
    local state=self.hitState
    state.hits=state.hits+1
    if state.hits>MAX_RECORDED_HITS then
        state.truncated=true
        return
    end
    local road=groupHit(node,"ROAD")
    local tree=groupHit(node,"TREE")
    local static=groupHit(node,"STATIC_OBJECT")
    if road==true then state.road=state.road+1 end
    if tree==true then state.tree=state.tree+1 end
    if static==true then state.static=state.static+1 end
    if road==nil or tree==nil or static==nil then
        state.classificationUnknown=state.classificationUnknown+1
    end
    -- Names are diagnostic hints only. Avoid arbitrary node hierarchy walks.
    local name="unknown"
    if type(getName)=="function" then
        local ok,n=pcall(getName,node)
        if ok and type(n)=="string" then
            name=string.sub(string.gsub(n,"[^%w_%-]","_"),1,48)
        end
    end
    state.nodes[#state.nodes+1]=tostring(node)..":"..name
end

local function terrainAt(x,z)
    if g_terrainNode==nil or type(getTerrainHeightAtWorldPos)~="function" then
        return nil,nil,nil,nil,"TERRAIN_HEIGHT_API_UNAVAILABLE"
    end
    local ok,y=pcall(getTerrainHeightAtWorldPos,g_terrainNode,x,0,z)
    if not ok or not finite(y) then
        return nil,nil,nil,nil,"TERRAIN_HEIGHT_READ_FAILED"
    end
    if type(getTerrainNormalAtWorldPos)~="function" then
        return y,nil,nil,nil,"TERRAIN_NORMAL_API_UNAVAILABLE"
    end
    local read,nx,ny,nz=pcall(getTerrainNormalAtWorldPos,g_terrainNode,x,y,z)
    if not read or not finite(nx) or not finite(ny) or not finite(nz) then
        return y,nil,nil,nil,"TERRAIN_NORMAL_READ_FAILED"
    end
    return y,nx,ny,nz,"AVAILABLE"
end

local function navAt(x,y,z)
    local ai=g_currentMission and g_currentMission.aiSystem
    local nav=ai and ai.navigationMap
    if nav==nil or y==nil
        or type(getVehicleNavigationMapCostAtWorldPos)~="function" then
        return "unknown"
    end
    local ok,_,blocked=pcall(getVehicleNavigationMapCostAtWorldPos,nav,x,y,z)
    if ok and type(blocked)=="boolean" then
        return blocked and "blocked" or "unblocked"
    end
    return "unknown"
end

local function farmlandAt(x,z)
    local manager=g_farmlandManager
    if type(manager)~="table" or type(manager.getFarmlandIdAtWorldPosition)~="function" then
        return "unknown"
    end
    local ok,id=pcall(manager.getFarmlandIdAtWorldPosition,manager,x,z)
    if not ok or id==nil then return "unknown" end
    return tostring(id)
end

local function fixtureEdge(edges,index,expectedLength,endpoints)
    local edge=edges and edges[index]
    if edge==nil or edge.index~=index or not finite(edge.length)
        or math.abs(edge.length-expectedLength)>EDGE_LENGTH_TOLERANCE_M
        or type(endpoints)~="table" then
        return nil
    end
    -- Identical numeric field IDs and edge lengths can occur on other maps.
    -- Tie the experimental fixture to the observed native world geometry.
    local actual={edge.ax,edge.az,edge.bx,edge.bz}
    for i=1,4 do
        if not finite(actual[i])
            or math.abs(actual[i]-endpoints[i])>ENDPOINT_TOLERANCE_M then
            return nil
        end
    end
    return edge
end

function Probe:sample(fieldId,poly,edge,station,depth,role)
    if self.points>=MAX_QUERY_POINTS then
        self.pointsTruncated=true
        return
    end
    self.points=self.points+1
    local t=station/edge.length
    local bx,bz=edge.ax+edge.dx*t,edge.az+edge.dz*t
    local nx,nz=G.outwardAt(poly,edge,bx,bz)
    if nx==nil then
        publish("PHYSICAL_MARGIN_POINT",{
            field=fieldId,fixture=self.fixture.name,role=role,edge=edge.index,
            stationM=fmt(station),depthM=depth,status="OUTWARD_UNRESOLVED",
            physics="NOT_QUERIED",terrain="unknown",navBlocking="unknown"
        })
        return
    end
    local x,z=bx+nx*depth,bz+nz*depth
    local y,tx,ty,tz,terrainStatus=terrainAt(x,z)
    local physicsStatus="NOT_QUERIED"
    local hits,road,tree,stat,unknown=0,0,0,0,0
    local hitIds="none"
    local truncated=false
    if depth>0 then
        if type(overlapBox)~="function" or self.collisionMask==nil then
            physicsStatus="API_UNAVAILABLE"
        elseif y==nil then
            physicsStatus="TERRAIN_UNAVAILABLE"
        elseif self.physicsCalls>=MAX_PHYSICS_CALLS then
            physicsStatus="BUDGET_EXCEEDED"
            self.physicsTruncated=true
        else
            self.physicsCalls=self.physicsCalls+1
            self.hitState={hits=0,road=0,tree=0,static=0,
                classificationUnknown=0,nodes={},truncated=false}
            local ok=pcall(overlapBox,
                x,y+BOX_HALF_Y+BOX_BOTTOM_ABOVE_TERRAIN_M,z,
                0,0,0,BOX_HALF_X,BOX_HALF_Y,BOX_HALF_Z,
                "onOverlapHit",self,self.collisionMask,
                false,true,true,true)
            local result=self.hitState
            self.hitState=nil
            if not ok then
                physicsStatus="QUERY_FAILED"
                self.physicsErrors=self.physicsErrors+1
            else
                physicsStatus=result.hits>0 and "HIT" or "NO_REPRESENTED_HIT"
                hits=result.hits
                road,tree,stat,unknown=
                    result.road,result.tree,result.static,result.classificationUnknown
                hitIds=#result.nodes>0 and table.concat(result.nodes,";") or "none"
                truncated=result.truncated
                self.totalHits=self.totalHits+result.hits
                self.roadHits=self.roadHits+result.road
                if truncated then self.hitListsTruncated=self.hitListsTruncated+1 end
            end
        end
    else
        physicsStatus="INFIELD_REFERENCE"
    end
    publish("PHYSICAL_MARGIN_POINT",{
        field=fieldId,fixture=self.fixture.name,role=role,edge=edge.index,
        stationM=fmt(station),depthM=depth,
        x=fmt(x),z=fmt(z),groundHeightM=fmt(y),
        terrainStatus=terrainStatus,
        terrainNormalX=fmt(tx),terrainNormalY=fmt(ty),terrainNormalZ=fmt(tz),
        sourcePolygonMembership=G.inside(poly,x,z) and "INSIDE" or "OUTSIDE",
        farmlandId=farmlandAt(x,z),navBlocking=navAt(x,y,z),
        physics=physicsStatus,physicsHits=hits,roadGroupHits=road,
        treeGroupHits=tree,staticGroupHits=stat,
        groupClassificationUnknown=unknown,
        hitNodes=hitIds,hitNodesTruncated=truncated,
        note="OBSERVATION_NOT_CLEARANCE"
    })
end

function Probe.run(fieldId,poly,edges,selectedFarmlandId)
    local fixture
    if selectedFarmlandId==nil then fixture=FIXTURES.default
    elseif selectedFarmlandId==2 then fixture=FIXTURES.farmland2 end
    if fixture==nil or fieldId~=fixture.field then
        publish("PHYSICAL_MARGIN_UNAVAILABLE",{
            field=fieldId,reason="UNSUPPORTED_EXPERIMENT_FIXTURE",
            note="NO_GENERIC_PARKING_ASSESSMENT"
        })
        return false
    end
    local edge=fixtureEdge(edges,fixture.edge,fixture.length,fixture.endpoints)
    local control=fixtureEdge(edges,fixture.controlEdge,fixture.controlLength,
        fixture.controlEndpoints)
    if edge==nil or control==nil then
        publish("PHYSICAL_MARGIN_UNAVAILABLE",{
            field=fieldId,fixture=fixture.name,
            reason="FIXTURE_EDGE_GEOMETRY_MISMATCH",
            note="NO_INFERRED_PHYSICAL_STRIP"
        })
        return false
    end
    local self=setmetatable({
        fixture=fixture,points=0,physicsCalls=0,physicsErrors=0,
        totalHits=0,roadHits=0,physicsTruncated=false,
        pointsTruncated=false,hitListsTruncated=0
    },Probe)
    self.collisionMask,self.maskReason=maskForPhysics()
    publish("PHYSICAL_MARGIN_CAPABILITY",{
        field=fieldId,fixture=fixture.name,
        terrainHeightApi=type(getTerrainHeightAtWorldPos)=="function",
        terrainNormalApi=type(getTerrainNormalAtWorldPos)=="function",
        overlapBoxApi=type(overlapBox)=="function",
        raycastApi=type(raycastAll)=="function",
        sweepBoxApi=type(sweepBoxVector)=="function",
        roadFlagApi=type(CollisionFlag)=="table"
            and type(CollisionFlag.ROAD)=="number",
        groupClassifierApi=type(CollisionFlag)=="table"
            and type(CollisionFlag.getHasGroupFlagSet)=="function",
        collisionMask=type(self.collisionMask)=="number"
            and tostring(self.collisionMask) or "unknown",
        maskReason=self.maskReason or "available",
        maxPoints=MAX_QUERY_POINTS,maxPhysicsCalls=MAX_PHYSICS_CALLS,
        boxHalfExtentsM="0.45,1.00,0.45",
        note="READ_ONLY_STATIC_PHYSICS_NOT_PARKING_CLEARANCE"
    })
    for _,fraction in ipairs({0.25,0.75}) do
        local s=edge.length*fraction
        for _,depth in ipairs(fixture.depths) do
            self:sample(fieldId,poly,edge,s,depth,"PREFERRED_MARGIN")
        end
    end
    for _,c in ipairs(fixture.controls) do
        local s=c.station or control.length*c.fraction
        for _,depth in ipairs(c.depths) do
            self:sample(fieldId,poly,control,s,depth,"VISIBLE_CONTROL")
        end
    end
    publish("PHYSICAL_MARGIN_SURVEY_FINISHED",{
        field=fieldId,fixture=fixture.name,
        points=self.points,physicsCalls=self.physicsCalls,
        physicsErrors=self.physicsErrors,
        representedHits=self.totalHits,roadGroupHits=self.roadHits,
        sampleTruncated=self.pointsTruncated,
        physicsTruncated=self.physicsTruncated,
        hitListsTruncated=self.hitListsTruncated,
        note="NO_CLEARANCE_OR_ROAD_BOUNDARY_CERTIFICATE"
    })
    return true
end

return Probe
