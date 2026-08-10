-- FS25_OuttaMyWay v4.7.63 TEST BUILD.
-- D-0134 passive Demonstrated Productive Coverage probe.
--
-- Builds a Job-Episode-scoped coarse grid from work that OuttaMyWay positively
-- witnesses. A cell is painted only while ProductiveContinuationProbe supplies
-- positive Productive Continuation evidence and a live AI-marker/work-area
-- segment can be resolved. Consecutive marker segments form the observed swept
-- Working-Footprint quadrilateral. This is historical evidence only: an
-- unpainted cell is UNKNOWN, not evidence of future productive demand, and a
-- painted cell is not Safe Release / Refuge / Control authority.

OuttaMyWay.DemonstratedProductiveCoverageProbe = {}
local Probe=OuttaMyWay.DemonstratedProductiveCoverageProbe
Probe.__index=Probe

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][PRODUCTIVE-COVERAGE] %s",message)
    else
        print("[FS25_OuttaMyWay][PRODUCTIVE-COVERAGE] "..message)
    end
end

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
end

local function referenceKey(vehicle)
    return "vehicle-root:"..tostring(vehicle and (vehicle.rootNode or vehicle) or "nil")
end

local function nameOf(vehicle)
    local ok,value=safeCall(vehicle,"getName")
    if ok and value~=nil and value~="" then return tostring(value) end
    return tostring(vehicle and (vehicle.name or vehicle.typeName or vehicle.rootNode) or "AI vehicle")
end

local function currentJobToken(vehicle)
    local job=OuttaMyWay.LiveAIJobEvidence.currentJob(vehicle)
    return OuttaMyWay.LiveAIJobEvidence.jobToken(job)
end

local function pose(vehicle)
    if vehicle==nil then return nil end
    local node=nil
    local ok,value=safeCall(vehicle,"getAISteeringNode")
    if ok and value~=nil and value~=0 then node=value end
    node=node or vehicle.rootNode
    if node==nil or node==0 or type(getWorldTranslation)~="function" then return nil end
    local pOk,x,_,z=pcall(getWorldTranslation,node)
    if not pOk then return nil end
    return {x=x,z=z}
end

local function nodePoint(node)
    if node==nil or node==0 or type(getWorldTranslation)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,node)
    if not ok then return nil end
    return {x=x,z=z}
end

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function distance(a,b)
    if a==nil or b==nil then return nil end
    local dx,dz=b.x-a.x,b.z-a.z
    return math.sqrt(dx*dx+dz*dz)
end

local function segmentFromNodes(leftNode,rightNode,source)
    local left=nodePoint(leftNode); local right=nodePoint(rightNode)
    if left==nil or right==nil then return nil end
    local width=distance(left,right)
    if not finite(width) or width<0.5 or width>100 then return nil end
    return {left=left,right=right,width=width,source=source}
end

local function collectObjects(root)
    local out,seen={},{}
    local function scan(object)
        if object==nil or seen[object] or object.isDeleted==true then return end
        seen[object]=true; out[#out+1]=object
        if type(object.getAttachedImplements)=="function" then
            local ok,attached=pcall(object.getAttachedImplements,object)
            if ok and type(attached)=="table" then
                for _,entry in pairs(attached) do scan(entry.object or entry) end
            end
        end
    end
    scan(root)
    return out
end

local function bestWorkingSegment(vehicle)
    local best=nil
    local function consider(candidate)
        if candidate~=nil and (best==nil or candidate.width>best.width) then best=candidate end
    end
    for _,object in ipairs(collectObjects(vehicle)) do
        if type(object.getAIMarkers)=="function" then
            local ok,left,right=pcall(object.getAIMarkers,object)
            if ok then consider(segmentFromNodes(left,right,"GIANTS_AI_MARKERS")) end
        end
        local spec=object.spec_workArea
        if type(spec)=="table" and type(spec.workAreas)=="table" then
            for _,area in pairs(spec.workAreas) do
                if type(area)=="table" then
                    consider(segmentFromNodes(area.start or area.startNode,area.width or area.widthNode,"GIANTS_WORK_AREA_MARKERS"))
                end
            end
        end
    end
    return best
end

local function sourceFieldAt(x,z)
    if OuttaMyWay.LiveAIJobEvidence==nil or type(OuttaMyWay.LiveAIJobEvidence.fieldAtPosition)~="function" then return nil end
    local field=OuttaMyWay.LiveAIJobEvidence.fieldAtPosition(g_currentMission,x,z)
    if field~=nil and field.resolved==true then return field.sourceFieldId end
    return nil
end

local function cellKey(ix,iz) return tostring(ix)..":"..tostring(iz) end

local function pointInPolygon(x,z,polygon)
    local inside=false
    local j=#polygon
    for i=1,#polygon do
        local a,b=polygon[i],polygon[j]
        local zi,zj=a.z,b.z
        local crosses=((zi>z)~=(zj>z))
        if crosses then
            local denom=(zj-zi)
            if math.abs(denom)>1e-9 then
                local xCross=(b.x-a.x)*(z-zi)/denom+a.x
                if x<xCross then inside=not inside end
            end
        end
        j=i
    end
    return inside
end

local function alignedCurrent(previous,current)
    if previous==nil or current==nil then return current end
    local same=(distance(previous.left,current.left) or math.huge)+(distance(previous.right,current.right) or math.huge)
    local swapped=(distance(previous.left,current.right) or math.huge)+(distance(previous.right,current.left) or math.huge)
    if swapped<same then
        return {left=current.right,right=current.left,width=current.width,source=current.source}
    end
    return current
end

function Probe.rasterizeQuadCells(previous,current,cellSize)
    if previous==nil or current==nil or not finite(cellSize) or cellSize<=0 then return {} end
    current=alignedCurrent(previous,current)
    local polygon={previous.left,previous.right,current.right,current.left}
    local minX,maxX,minZ,maxZ=math.huge,-math.huge,math.huge,-math.huge
    for _,p in ipairs(polygon) do
        minX=math.min(minX,p.x); maxX=math.max(maxX,p.x); minZ=math.min(minZ,p.z); maxZ=math.max(maxZ,p.z)
    end
    local out={}
    local minIx,maxIx=math.floor(minX/cellSize),math.floor(maxX/cellSize)
    local minIz,maxIz=math.floor(minZ/cellSize),math.floor(maxZ/cellSize)
    for ix=minIx,maxIx do
        for iz=minIz,maxIz do
            local cx=(ix+0.5)*cellSize; local cz=(iz+0.5)*cellSize
            if pointInPolygon(cx,cz,polygon) then
                out[#out+1]={ix=ix,iz=iz,x=cx,z=cz,key=cellKey(ix,iz)}
            end
        end
    end
    return out
end

function Probe.coverageClassFromSamples(demonstrated,total)
    total=tonumber(total) or 0; demonstrated=tonumber(demonstrated) or 0
    if total<=0 then return "UNRESOLVED" end
    if demonstrated>=total then return "FULL_DEMONSTRATED_PRODUCTIVE_COVERAGE" end
    if demonstrated>0 then return "PARTIAL_DEMONSTRATED_PRODUCTIVE_COVERAGE" end
    return "NO_DEMONSTRATED_PRODUCTIVE_COVERAGE" -- absence is not negative authority
end

function Probe.new(productiveProbe)
    return setmetatable({productiveProbe=productiveProbe,elapsed=0,states={},maps={},nextSummaryAt={}},Probe)
end

function Probe:reset()
    self.elapsed=0; self.states={}; self.maps={}; self.nextSummaryAt={}
end

function Probe:loadMap()
    self:reset()
    logInfo("active=true mode=PASSIVE_SHADOW_ONLY gridCell=%.2fm evidence=POSITIVE_PRODUCTIVE_PLUS_LIVE_WORK_MARKER noAppliedStateAPI=true unknownCellsRemainUnknown=true decisionAuthority=false controlAuthority=false",
        OuttaMyWay.DEMONSTRATED_PRODUCTIVE_COVERAGE_CELL_SIZE_M or 5.0)
end
function Probe:deleteMap() self:reset() end
function Probe:keyEvent() end
function Probe:mouseEvent() end
function Probe:draw() end

local function mapKey(ref,jobToken) return tostring(ref).."|"..tostring(jobToken) end

function Probe:_map(ref,jobToken,fieldId,name)
    local key=mapKey(ref,jobToken)
    local map=self.maps[key]
    if map==nil then
        map={referenceKey=ref,jobToken=jobToken,fieldId=fieldId,name=name,cells={},cellCount=0,sweepCount=0,firstAt=g_time or 0,lastAt=g_time or 0}
        self.maps[key]=map
    elseif map.fieldId==nil and fieldId~=nil then map.fieldId=fieldId end
    return map
end

function Probe:_paint(vehicle,ref,jobToken,evidence,nowMs)
    local current=bestWorkingSegment(vehicle)
    local currentPose=pose(vehicle)
    if current==nil or currentPose==nil then
        self.states[ref]=nil
        return false,"WORKING_FOOTPRINT_MARKERS_UNRESOLVED"
    end
    local fieldId=sourceFieldAt(currentPose.x,currentPose.z)
    if fieldId==nil then
        self.states[ref]=nil
        return false,"SOURCE_FIELD_UNRESOLVED"
    end
    local state=self.states[ref]
    if state==nil or state.jobToken~=jobToken or state.fieldId~=fieldId then
        self.states[ref]={jobToken=jobToken,fieldId=fieldId,segment=current,pose=currentPose,source=current.source}
        return false,"BASELINE_OPENED"
    end
    local gap=distance(state.pose,currentPose) or math.huge
    local maxGap=OuttaMyWay.DEMONSTRATED_PRODUCTIVE_COVERAGE_MAX_SAMPLE_GAP_M or 12.0
    if gap>maxGap then
        self.states[ref]={jobToken=jobToken,fieldId=fieldId,segment=current,pose=currentPose,source=current.source}
        return false,"SAMPLE_GAP_TOO_LARGE_BASELINE_RESET"
    end
    local cellSize=OuttaMyWay.DEMONSTRATED_PRODUCTIVE_COVERAGE_CELL_SIZE_M or 5.0
    local cells=Probe.rasterizeQuadCells(state.segment,current,cellSize)
    local map=self:_map(ref,jobToken,fieldId,nameOf(vehicle))
    local added=0
    for _,cell in ipairs(cells) do
        local cellField=sourceFieldAt(cell.x,cell.z)
        if cellField==fieldId then
            local existing=map.cells[cell.key]
            if existing==nil then
                map.cells[cell.key]={ix=cell.ix,iz=cell.iz,x=cell.x,z=cell.z,firstAt=nowMs,lastAt=nowMs,samples=1}
                map.cellCount=map.cellCount+1; added=added+1
            else
                existing.lastAt=nowMs; existing.samples=(existing.samples or 0)+1
            end
        end
    end
    map.sweepCount=map.sweepCount+1; map.lastAt=nowMs
    self.states[ref]={jobToken=jobToken,fieldId=fieldId,segment=current,pose=currentPose,source=current.source}
    if added>0 then
        logInfo("PAINT worker=%s ref=%s job=%s field=%s source=%s markerWidth=%.2fm moved=%.2fm cellsAdded=%d totalCells=%d sweeps=%d cellSize=%.2fm authority=PASSIVE_HISTORY_ONLY",
            nameOf(vehicle),ref,tostring(jobToken),tostring(fieldId),tostring(current.source),current.width,gap,added,map.cellCount,map.sweepCount,cellSize)
    end
    return true,"PAINTED"
end

function Probe:update(dt)
    if OuttaMyWay.DEMONSTRATED_PRODUCTIVE_COVERAGE_PROBE_ENABLED~=true or g_currentMission==nil then return end
    if g_client~=nil and g_server==nil then return end
    self.elapsed=self.elapsed+(dt or 0)
    local interval=OuttaMyWay.DEMONSTRATED_PRODUCTIVE_COVERAGE_PROBE_INTERVAL_MS or 250
    if self.elapsed<interval then return end
    self.elapsed=self.elapsed%interval
    local nowMs=tonumber(g_time) or 0
    local seen={}
    for _,vehicle in OuttaMyWay.ValueRecord.ipairs(OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(g_currentMission)) do
        local ref=referenceKey(vehicle); seen[ref]=true
        local jobToken=currentJobToken(vehicle)
        local evidence=self.productiveProbe and self.productiveProbe:getEvidence(ref,jobToken) or nil
        if jobToken~=nil and evidence~=nil and evidence.productivePositive==true then
            self:_paint(vehicle,ref,jobToken,evidence,nowMs)
        else
            -- Break the sweep so a transition/unresolved interval can never be
            -- bridged and falsely painted as productive history.
            self.states[ref]=nil
        end
    end
    for ref in pairs(self.states) do if not seen[ref] then self.states[ref]=nil end end
end

function Probe:evaluateCircle(referenceKeyValue,jobToken,x,z,radius)
    local map=self.maps[mapKey(referenceKeyValue,jobToken)]
    local cellSize=OuttaMyWay.DEMONSTRATED_PRODUCTIVE_COVERAGE_CELL_SIZE_M or 5.0
    local sampleCount=math.max(4,math.floor(OuttaMyWay.REFUGE_QUALIFICATION_SHADOW_COVERAGE_SAMPLE_COUNT or 12))
    radius=math.max(0,tonumber(radius) or 0)
    local samples={{x=x,z=z}}
    if radius>0 then
        for index=1,sampleCount do
            local angle=(index-1)*(math.pi*2/sampleCount)
            samples[#samples+1]={x=x+math.cos(angle)*radius,z=z+math.sin(angle)*radius}
        end
    end
    local demonstrated=0
    for _,sample in ipairs(samples) do
        local ix=math.floor(sample.x/cellSize); local iz=math.floor(sample.z/cellSize)
        if map~=nil and map.cells[cellKey(ix,iz)]~=nil then demonstrated=demonstrated+1 end
    end
    return {
        status=Probe.coverageClassFromSamples(demonstrated,#samples),demonstrated=demonstrated,total=#samples,
        ratio=#samples>0 and demonstrated/#samples or 0,cellSizeM=cellSize,mapCellCount=map and map.cellCount or 0,
        fieldId=map and map.fieldId or nil,negativeAuthority=false
    }
end

function Probe:getMapSummary(referenceKeyValue,jobToken)
    local map=self.maps[mapKey(referenceKeyValue,jobToken)]
    if map==nil then return {cellCount=0,sweepCount=0,status="NO_DEMONSTRATED_PRODUCTIVE_COVERAGE"} end
    return {cellCount=map.cellCount,sweepCount=map.sweepCount,fieldId=map.fieldId,status=map.cellCount>0 and "POSITIVE_HISTORY_AVAILABLE" or "NO_DEMONSTRATED_PRODUCTIVE_COVERAGE"}
end

-- D-0135/D-0136 passive consumers: expose copied live marker evidence and positive
-- demonstrated-cell membership without granting write/Decision authority.
function Probe:getWorkingSegment(vehicle)
    local segment=bestWorkingSegment(vehicle)
    if segment==nil then return nil end
    return {left={x=segment.left.x,z=segment.left.z},right={x=segment.right.x,z=segment.right.z},width=segment.width,source=segment.source}
end

function Probe:isCellDemonstrated(referenceKeyValue,jobToken,ix,iz)
    local map=self.maps[mapKey(referenceKeyValue,jobToken)]
    return map~=nil and map.cells[cellKey(ix,iz)]~=nil
end
