-- Read-only GIANTS Farm Spatial Context witness for Issues #420/#476.
-- Specification Jurisdictions: `FARM_SPATIAL_CONTEXT_OBSERVATION`
-- Enumerates consecutive polygon-vertex pairs and samples outside them.
-- Does not nominate parking, hold, start jobs, alter costmaps or move anything.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.FarmSpatialContextProbe={}
local Probe=OuttaMyWay.FarmSpatialContextProbe
Probe.__index=Probe
local G=OuttaMyWay.FarmEdgeGeometry
local publication=OuttaMyWay.LogPublication.origin("FARM_SPATIAL_CONTEXT")

local DEFAULT_FIELD_ID=77  -- retained original fixture when no farmland selected
local OFFSET_METRES={2,6,12}
local SAMPLE_SPACING_M=6
local MAX_SAMPLES_PER_EDGE=96
local MAX_TOTAL_SAMPLES=6000
local MAX_FIELDS=600
local MAX_ROAD_SPLINES=300
local MAX_ROAD_POINTS=8000
local ROAD_LOOKUP_MARGIN_M=60

local function finite(x)
    return type(x)=="number" and x==x and x~=math.huge and x~=-math.huge
end

local function fmt(n)
    if not finite(n) then return "unknown" end
    return string.format("%.2f",n)
end

local function toValue(n)
    return n==nil and "unknown" or tostring(n)
end

local function publish(code,payload)
    publication:publish("DIAGNOSTIC","INFO",code,function()
        payload.version=OuttaMyWay.VERSION
        return payload
    end)
end

local function fieldId(field,index)
    if type(field)=="table" and type(field.fieldId)=="number" then
        return field.fieldId
    end
    if type(index)=="number" then return index end
    return tostring(index)
end

-- The screenshot gives us a Farmland number. It is not proof that the
-- registered field polygon shares the same ID. Resolve a *unique* source
-- field through sampled native farmland membership, or report ambiguity.
local function farmlandIdForField(field)
    local farm=g_farmlandManager
    if type(farm)~="table"
        or type(farm.getFarmlandIdAtWorldPosition)~="function" then
        return nil,"FARMLAND_LOOKUP_UNAVAILABLE"
    end
    local poly,err=G.polygonFor(field)
    if poly==nil then return nil,err end
    local x,z=field.posX,field.posZ
    if finite(x) and finite(z) and G.inside(poly,x,z) then
        local ok,id=pcall(farm.getFarmlandIdAtWorldPosition,farm,x,z)
        if ok and type(id)=="number" then return id,nil end
    end
    local edges=G.edges(poly)
    for i=1,#edges do
        local edge=edges[i]
        local mx,mz=(edge.ax+edge.bx)/2,(edge.az+edge.bz)/2
        local nx,nz=G.outwardAt(poly,edge,mx,mz)
        if nx~=nil then
            for _,depth in ipairs({2,0.5}) do
                local ix,iz=mx-nx*depth,mz-nz*depth
                if G.inside(poly,ix,iz) then
                    local ok,id=pcall(farm.getFarmlandIdAtWorldPosition,farm,ix,iz)
                    if ok and type(id)=="number" then return id,nil end
                end
            end
        end
    end
    return nil,"FARMLAND_ID_UNRESOLVED"
end

local function targetField(selectedFarmlandId)
    local manager=g_fieldManager
    if type(manager)~="table" then return nil,nil,"FIELD_MANAGER_UNAVAILABLE" end
    local fields=manager.fields
    if selectedFarmlandId~=nil then
        if type(fields)~="table" then return nil,nil,"FIELD_REGISTRY_UNAVAILABLE" end
        local selected,selectedId,matches,scanned=nil,nil,0,0
        for key,field in pairs(fields) do
            scanned=scanned+1
            if scanned>MAX_FIELDS then return nil,nil,"FIELD_REGISTRY_TRUNCATED" end
            if type(field)=="table" then
                local farmlandId=farmlandIdForField(field)
                if farmlandId==selectedFarmlandId then
                    selected,selectedId=field,fieldId(field,key)
                    matches=matches+1
                    if matches>1 then
                        return nil,nil,"FARMLAND_CONTAINS_MULTIPLE_FIELDS"
                    end
                end
            end
        end
        if selected==nil then return nil,nil,"NO_FIELD_FOR_SELECTED_FARMLAND" end
        return selected,selectedId,nil
    end
    if type(manager.getFieldById)=="function" then
        local ok,field=pcall(manager.getFieldById,manager,DEFAULT_FIELD_ID)
        if ok and type(field)=="table" then return field,DEFAULT_FIELD_ID,nil end
    end
    if type(fields)~="table" then return nil,nil,"FIELD_REGISTRY_UNAVAILABLE" end
    if type(fields[DEFAULT_FIELD_ID])=="table" then
        return fields[DEFAULT_FIELD_ID],DEFAULT_FIELD_ID,nil
    end
    for key,field in pairs(fields) do
        if type(field)=="table" and fieldId(field,key)==DEFAULT_FIELD_ID then
            return field,DEFAULT_FIELD_ID,nil
        end
    end
    return nil,nil,"DEFAULT_FIELD_77_NOT_REGISTERED"
end

local function fieldCatalogue(target)
    local manager=g_fieldManager
    local registered=manager and manager.fields
    local list,scanned={},0
    local truncated=false
    if type(registered)~="table" then return list,true end
    for key,field in pairs(registered) do
        if scanned>=MAX_FIELDS then truncated=true; break end
        scanned=scanned+1
        if field~=target then
            local poly=G.polygonFor(field)
            if poly~=nil then
                list[#list+1]={id=fieldId(field,key),polygon=poly}
            end
        end
    end
    return list,truncated
end

local function sourceFarmOwner(poly)
    local farmland=g_farmlandManager
    if type(farmland)~="table"
        or type(farmland.getOwnerIdAtWorldPosition)~="function" then return nil end
    -- Locate a point proven interior; polygon label/centroid can be outside a
    -- concave polygon. A 2m inward probe on any verified edge suffices.
    local edges=G.edges(poly)
    for i=1,#edges do
        local e=edges[i]
        local x,z=(e.ax+e.bx)/2,(e.az+e.bz)/2
        local nx,nz=G.outwardAt(poly,e,x,z)
        if nx~=nil then
            local px,pz=x-nx*2,z-nz*2
            if G.inside(poly,px,pz) then
                local ok,owner=pcall(farmland.getOwnerIdAtWorldPosition,farmland,px,pz)
                if ok and type(owner)=="number" and owner>0 then return owner end
            end
        end
    end
    return nil
end

local function roadSamples(poly)
    local ai=g_currentMission and g_currentMission.aiSystem
    local splines=ai and ai.roadSplines
    local points={}
    local count,valid,failures=0,0,0
    local truncated=false
    if type(splines)~="table" or type(getSplineLength)~="function"
        or type(getSplinePosition)~="function" then
        return points,{available=false,registered=0,sampled=0,failures=0,truncated=false}
    end
    for _,spline in pairs(splines) do
        count=count+1
        if count>MAX_ROAD_SPLINES or #points>=MAX_ROAD_POINTS then
            truncated=true
            break
        end
        local ok,length=pcall(getSplineLength,spline)
        if ok and finite(length) and length>0 then
            valid=valid+1
            if length/4>300 then truncated=true end
            local steps=math.max(1,math.min(300,math.ceil(length/4)))
            for i=0,steps do
                local got,x,_,z=pcall(getSplinePosition,spline,i/steps)
                if got and finite(x) and finite(z) then
                    if x>=poly.minX-ROAD_LOOKUP_MARGIN_M
                        and x<=poly.maxX+ROAD_LOOKUP_MARGIN_M
                        and z>=poly.minZ-ROAD_LOOKUP_MARGIN_M
                        and z<=poly.maxZ+ROAD_LOOKUP_MARGIN_M then
                        points[#points+1]={x=x,z=z}
                        if #points>=MAX_ROAD_POINTS then
                            truncated=true
                            break
                        end
                    end
                else
                    failures=failures+1
                end
            end
        else
            failures=failures+1
        end
    end
    return points,{available=true,registered=count,valid=valid,
        sampled=#points,failures=failures,truncated=truncated}
end

local function nearestRoadDistance(edge,points)
    if #points==0 then return nil end
    local closest=math.huge
    for i=1,#points do
        local p=points[i]
        local d=G.pointSegmentDistance(p.x,p.z,edge.ax,edge.az,edge.bx,edge.bz)
        if d<closest then closest=d end
    end
    return closest
end


local function nearestFieldGap(edge,neighbors)
    local closest,id=math.huge,nil
    local ax,bx=math.min(edge.ax,edge.bx),math.max(edge.ax,edge.bx)
    local az,bz=math.min(edge.az,edge.bz),math.max(edge.az,edge.bz)
    for i=1,#neighbors do
        local other=neighbors[i]
        local p=other.polygon
        local dx=math.max(0,p.minX-bx,ax-p.maxX)
        local dz=math.max(0,p.minZ-bz,az-p.maxZ)
        if dx*dx+dz*dz<=closest*closest then
            local gap=G.edgeToPolygonGap(edge,p)
            if gap~=nil and gap<closest then
                closest,id=gap,other.id
            end
        end
    end
    return closest<math.huge and closest or nil,id
end

local function nativeSample(x,z,sourceOwner)
    local result={farmlandId="unknown",ownerId="unknown",
        access="unknown",cost=nil,blocking=nil}
    local farm=g_farmlandManager
    if type(farm)=="table" then
        if type(farm.getFarmlandIdAtWorldPosition)=="function" then
            local ok,id=pcall(farm.getFarmlandIdAtWorldPosition,farm,x,z)
            if ok and id~=nil then result.farmlandId=tostring(id) end
        end
        if type(farm.getOwnerIdAtWorldPosition)=="function" then
            local ok,id=pcall(farm.getOwnerIdAtWorldPosition,farm,x,z)
            if ok and id~=nil then result.ownerId=tostring(id) end
        end
        if sourceOwner~=nil
            and type(farm.getCanAccessLandAtWorldPosition)=="function" then
            local ok,allowed=pcall(farm.getCanAccessLandAtWorldPosition,
                farm,sourceOwner,x,z)
            if ok and type(allowed)=="boolean" then
                result.access=allowed and "allowed" or "denied"
            end
        end
    end
    local ai=g_currentMission and g_currentMission.aiSystem
    local nav=ai and ai.navigationMap
    if nav==nil and type(ai)=="table"
        and type(ai.getNavigationMap)=="function" then
        local ok,value=pcall(ai.getNavigationMap,ai)
        if ok then nav=value end
    end
    if nav~=nil and g_terrainNode~=nil
        and type(getTerrainHeightAtWorldPos)=="function"
        and type(getVehicleNavigationMapCostAtWorldPos)=="function" then
        local ok,y=pcall(getTerrainHeightAtWorldPos,g_terrainNode,x,0,z)
        if ok and finite(y) then
            local read,cost,blocked=pcall(getVehicleNavigationMapCostAtWorldPos,
                nav,x,y,z)
            if read and finite(cost) and type(blocked)=="boolean" then
                result.cost=cost
                result.blocking=blocked
            end
        end
    end
    return result
end

local function updateKeyCount(counts,key)
    counts[tostring(key)]=(counts[tostring(key)] or 0)+1
end

local function compactCounts(counts)
    local keys={}
    for key in pairs(counts) do keys[#keys+1]=key end
    table.sort(keys)
    local list={}
    for i=1,#keys do
        local key=keys[i]
        list[#list+1]=key..":"..tostring(counts[key])
    end
    return #list==0 and "none" or table.concat(list,",")
end

local function recordOffset(edge,offset,sourceOwner,neighbors,totalSamples,fieldId)
    local count=math.max(1,math.min(MAX_SAMPLES_PER_EDGE,
        math.ceil(edge.length/SAMPLE_SPACING_M)))
    count=math.min(count,math.max(0,MAX_TOTAL_SAMPLES-totalSamples))
    if count==0 then return nil,0 end
    local summary={blocked=0,clear=0,unknown=0,
        allowed=0,denied=0,accessUnknown=0,
        farms={},owners={},neighborFields={},sourceReentry=0,
        blockedRanges={},minCost=nil,maxCost=nil}
    local runStart=nil
    for k=1,count do
        -- Sample interior of this one edge, never infer a corner normal.
        local t=(k-0.5)/count
        local x,z=edge.ax+edge.dx*t,edge.az+edge.dz*t
        local nx,nz=G.outwardAt(edge.polygon,edge,x,z)
        local blocked=false
        if nx==nil then
            summary.unknown=summary.unknown+1
            summary.accessUnknown=summary.accessUnknown+1
        else
            local sx,sz=x+nx*offset,z+nz*offset
            if G.inside(edge.polygon,sx,sz) then
                summary.sourceReentry=summary.sourceReentry+1
            end
            local r=nativeSample(sx,sz,sourceOwner)
            updateKeyCount(summary.farms,r.farmlandId)
            updateKeyCount(summary.owners,r.ownerId)
            if r.access=="allowed" then summary.allowed=summary.allowed+1
            elseif r.access=="denied" then summary.denied=summary.denied+1
            else summary.accessUnknown=summary.accessUnknown+1 end
            if r.blocking==true then
                summary.blocked=summary.blocked+1
                blocked=true
            elseif r.blocking==false then summary.clear=summary.clear+1
            else summary.unknown=summary.unknown+1 end
            if r.cost~=nil then
                summary.minCost=math.min(summary.minCost or r.cost,r.cost)
                summary.maxCost=math.max(summary.maxCost or r.cost,r.cost)
            end
            for i=1,#neighbors do
                local neighbor=neighbors[i]
                local p=neighbor.polygon
                if sx>=p.minX and sx<=p.maxX
                    and sz>=p.minZ and sz<=p.maxZ
                    and G.inside(p,sx,sz) then
                    summary.neighborFields[tostring(neighbor.id)]=true
                end
            end
        end
        if blocked and runStart==nil then runStart=(k-1)*edge.length/count end
        if not blocked and runStart~=nil then
            summary.blockedRanges[#summary.blockedRanges+1]=
                fmt(runStart).."-"..fmt((k-1)*edge.length/count)
            runStart=nil
        end
    end
    if runStart~=nil then
        summary.blockedRanges[#summary.blockedRanges+1]=
            fmt(runStart).."-"..fmt(edge.length)
    end
    local ids={}
    for id in pairs(summary.neighborFields) do ids[#ids+1]=id end
    table.sort(ids)
    publish("FIELD_EDGE_OUTSIDE_SAMPLE",{
        field=fieldId,edge=edge.index,offsetM=offset,
        samples=count,sampleSpacingM=fmt(edge.length/count),
        farmlandIds=compactCounts(summary.farms),
        ownerIds=compactCounts(summary.owners),
        accessAllowed=summary.allowed,accessDenied=summary.denied,
        accessUnknown=summary.accessUnknown,
        neighborFieldIds=#ids==0 and "none" or table.concat(ids,","),
        sourcePolygonReentry=summary.sourceReentry,
        navBlocked=summary.blocked,navUnblocked=summary.clear,
        navUnknown=summary.unknown,navCostMin=fmt(summary.minCost),
        navCostMax=fmt(summary.maxCost),
        navBlockedIntervalsM=#summary.blockedRanges==0 and "none"
            or table.concat(summary.blockedRanges,";")
    })
    return summary,count
end

function Probe.new(configuration,diagnosticSource)
    return setmetatable({
        configuration=configuration,diagnosticSource=diagnosticSource,
        elapsedMs=0,attempted=false,lastAttemptMs=0
    },Probe)
end

function Probe:diagnosticEligible()
    return g_server~=nil and self.configuration~=nil
        and self.configuration:isResolved()==true
        and self.configuration:isEnabled()==true
        and self.diagnosticSource~=nil
        and self.diagnosticSource:publicationPolicy()=="DIAGNOSTIC"
end

function Probe:loadMap()
    self.elapsedMs=0
    self.lastAttemptMs=0
    self.attempted=false
end

function Probe:deleteMap()
    self:loadMap()
end

function Probe:survey()
    local selectedFarmlandId,selectionError=nil,nil
    if type(self.diagnosticSource.spatialTargetFarmlandId)=="function" then
        selectedFarmlandId,selectionError=self.diagnosticSource:spatialTargetFarmlandId()
    end
    if selectionError~=nil then return false,selectionError end
    local field,fieldId,why=targetField(selectedFarmlandId)
    if field==nil then return false,why end
    local poly,reason=G.polygonFor(field)
    if poly==nil then return false,reason end
    local edges=G.edges(poly)
    if #edges==0 then return false,"FIELD_EDGE_UNAVAILABLE" end
    local neighbors,fieldsTruncated=fieldCatalogue(field)
    local roads,roadInfo=roadSamples(poly)
    local owner=sourceFarmOwner(poly)
    local nativeFarmlandId=farmlandIdForField(field)
    publish("FARM_CONTEXT_FIELD",{
        field=fieldId,selectedFarmlandId=toValue(selectedFarmlandId),
        resolvedFarmlandId=toValue(nativeFarmlandId),
        targetSelection=selectedFarmlandId~=nil and "FARMLAND" or "DEFAULT_FIELD",
        vertexCount=poly.vertexCount,edgeCount=#edges,
        bboxMinX=fmt(poly.minX),bboxMaxX=fmt(poly.maxX),
        bboxMinZ=fmt(poly.minZ),bboxMaxZ=fmt(poly.maxZ),
        sourceFarmOwner=toValue(owner),neighborFieldCount=#neighbors,
        neighborRegistryTruncated=fieldsTruncated,
        roadRegistered=roadInfo.registered,roadValid=toValue(roadInfo.valid),
        roadPointsNearField=roadInfo.sampled,
        roadReadAvailable=roadInfo.available,
        roadReadFailures=roadInfo.failures,roadTruncated=roadInfo.truncated,
        navMapAvailable=g_currentMission~=nil and g_currentMission.aiSystem~=nil
            and g_currentMission.aiSystem.navigationMap~=nil
    })
    local totalSamples=0
    local sideSummaries={}
    for i=1,#edges do
        local e=edges[i]
        e.polygon=poly
        local roadDistance=nearestRoadDistance(e,roads)
        local fieldGap,nearestField=nearestFieldGap(e,neighbors)
        publish("FARM_CONTEXT_EDGE",{
            field=fieldId,edge=e.index,nextVertex=e.nextIndex,
            side=e.side,
            ax=fmt(e.ax),az=fmt(e.az),bx=fmt(e.bx),bz=fmt(e.bz),
            lengthM=fmt(e.length),outwardX=fmt(e.nx),outwardZ=fmt(e.nz),
            nearestRoadSplineSampleM=fmt(roadDistance),
            nearestOtherFieldBoundaryM=fmt(fieldGap),
            nearestOtherFieldId=toValue(nearestField)
        })
        local side=sideSummaries[e.side] or {
            edges=0,roadMin=nil,blocked=0,unblocked=0,unknown=0,reentry=0}
        sideSummaries[e.side]=side
        side.edges=side.edges+1
        if roadDistance~=nil then
            side.roadMin=math.min(side.roadMin or roadDistance,roadDistance)
        end
        for j=1,#OFFSET_METRES do
            local sample,count=recordOffset(e,OFFSET_METRES[j],owner,neighbors,totalSamples,fieldId)
            totalSamples=totalSamples+count
            if j==1 and sample~=nil then
                side.blocked=side.blocked+sample.blocked
                side.unblocked=side.unblocked+sample.clear
                side.unknown=side.unknown+sample.unknown
                side.reentry=side.reentry+sample.sourceReentry
            end
        end
    end
    for sideName,summary in pairs(sideSummaries) do
        publish("FARM_CONTEXT_SIDE_SUMMARY",{
            field=fieldId,side=sideName,edges=summary.edges,
            nearestRoadSplineSampleM=fmt(summary.roadMin),
            offsetM=2,navBlocked=summary.blocked,
            navUnblocked=summary.unblocked,navUnknown=summary.unknown,
            sourcePolygonReentry=summary.reentry
        })
    end
    publish("FARM_CONTEXT_SURVEY_FINISHED",{
        field=fieldId,edges=#edges,offsetsM="2,6,12",
        totalEdgeSamples=totalSamples,sampleBudget=MAX_TOTAL_SAMPLES,
        sampleTruncated=totalSamples>=MAX_TOTAL_SAMPLES,
        note="PASSIVE_ONLY_NOT_SETTLEMENT_CLEARANCE"
    })
    return true
end

function Probe:update(dt)
    -- Absolutely no diagnostic geometry or native map reads when disabled.
    if self.attempted or not self:diagnosticEligible() then return end
    self.elapsedMs=self.elapsedMs+math.max(0,tonumber(dt) or 0)
    if self.elapsedMs<6000 or self.elapsedMs-self.lastAttemptMs<1000 then return end
    self.lastAttemptMs=self.elapsedMs
    local ok,success,reason=pcall(self.survey,self)
    if ok and success then self.attempted=true; return end
    if self.elapsedMs>=20000 then
        self.attempted=true
        publish("FARM_CONTEXT_SURVEY_UNAVAILABLE",{
            selectedFarmlandId=toValue(self.diagnosticSource.spatialFarmlandId),
            field=DEFAULT_FIELD_ID,reason=ok and tostring(reason) or "SURVEY_EXCEPTION",
            note="NO_INFERRED_PARKING_REGION"
        })
    end
end

return Probe
