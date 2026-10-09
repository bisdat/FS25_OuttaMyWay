-- Admits one evidenced native worker pair independently of candidate publication.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- Uses current GIANTS Job Episode, field polygon and root evidence, not a
-- candidate's claimed authority or a second native blockage detector.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativePairCommitmentAuthority={}
local Authority=OuttaMyWay.NativePairCommitmentAuthority
Authority.__index=Authority

local function finite(n)
    return type(n)=="number" and n==n and n~=math.huge and n~=-math.huge
end

local function pose(vehicle)
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(getWorldTranslation)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    if not ok or not finite(x) or not finite(z) then return nil end
    return {x=x,z=z}
end

local function currentJob(vehicle)
    if type(vehicle)~="table" or type(vehicle.getJob)~="function" then return nil end
    local ok,job=pcall(vehicle.getJob,vehicle)
    return ok and type(job)=="table" and job or nil
end

local function currentStrategy(vehicle)
    local spec=vehicle and vehicle.spec_aiFieldWorker
    if type(spec)~="table" or spec.isActive~=true
        or type(spec.driveStrategies)~="table" then return nil end
    for _,strategy in pairs(spec.driveStrategies) do
        if type(strategy)=="table" and type(strategy.isBlocked)=="boolean"
            and (strategy.aiFieldCourse~=nil
                or (type(strategy.className)=="string"
                    and string.find(strategy.className,"FieldCourse",1,true))) then
            return strategy
        end
    end
    return nil
end

-- At pair admission, capture the OTHER (regulated) assembly's productive
-- working span while still in its native FIELDWORK configuration. This is a
-- corridor-planning scale, not a claim about physical folded collision shape.
local function blockerWorkingWidth(vehicle)
    local seen,count,maxWidth={},0,0
    local function visit(object)
        if type(object)~="table" or object.isDeleted==true then
            return false,"BLOCKER_ASSEMBLY_UNAVAILABLE"
        end
        if seen[object] then return true end
        seen[object]=true
        count=count+1
        if count>16 then return false,"BLOCKER_ASSEMBLY_BUDGET_EXCEEDED" end
        if type(object.getAIWorkAreaWidth)=="function" then
            local ok,w=pcall(object.getAIWorkAreaWidth,object)
            if not ok or not finite(w) or w<0 then
                return false,"BLOCKER_WORK_WIDTH_INVALID"
            end
            maxWidth=math.max(maxWidth,w)
        end
        if type(object.getAttachedImplements)=="function" then
            local ok,attached=pcall(object.getAttachedImplements,object)
            if not ok or type(attached)~="table" then
                return false,"BLOCKER_ATTACHMENTS_UNAVAILABLE"
            end
            for _,descriptor in pairs(attached) do
                local child=type(descriptor)=="table"
                    and (descriptor.object or descriptor) or nil
                local allowed,reason=visit(child)
                if not allowed then return false,reason end
            end
        end
        return true
    end
    local ok,reason=visit(vehicle)
    if not ok then return nil,reason end
    if maxWidth<=0 then return nil,"BLOCKER_WORK_WIDTH_UNAVAILABLE" end
    return maxWidth
end

local function inside(poly,x,z)
    local result=false
    local xs,zs=poly.xs,poly.zs
    local n=#xs
    for i=1,n do
        local j=i==1 and n or i-1
        local xi,zi,xj,zj=xs[i],zs[i],xs[j],zs[j]
        if (zi>z)~=(zj>z) then
            local crossing=xj+(xi-xj)*(zj-z)/(zj-zi)
            if x<crossing then result=not result end
        end
    end
    return result
end

local function polygonFor(field)
    local polygon=field and field.densityMapPolygon
    local xs=polygon and polygon.pointsX
    local zs=polygon and polygon.pointsZ
    if type(xs)~="table" or type(zs)~="table"
        or #xs<3 or #xs~=#zs then return nil end
    local record={xs={},zs={}}
    local twiceArea,cx,cz=0,0,0
    for i=1,#xs do
        local x,z=xs[i],zs[i]
        if not finite(x) or not finite(z) then return nil end
        record.xs[i],record.zs[i]=x,z
    end
    for i=1,#xs do
        local j=i==#xs and 1 or i+1
        local cross=record.xs[i]*record.zs[j]-record.xs[j]*record.zs[i]
        twiceArea=twiceArea+cross
        cx=cx+(record.xs[i]+record.xs[j])*cross
        cz=cz+(record.zs[i]+record.zs[j])*cross
    end
    if not finite(twiceArea) or math.abs(twiceArea)<0.000001 then return nil end
    cx,cz=cx/(3*twiceArea),cz/(3*twiceArea)
    if not finite(cx) or not finite(cz) then return nil end
    record.centroid={x=cx,z=cz}
    return record
end

local function commonField(a,b)
    local manager=g_fieldManager
    local fields=manager and manager.fields
    if type(fields)~="table" then return nil,nil,"FIELD_REGISTRY_UNAVAILABLE" end
    local validPolygons=0
    local firstWithin=false
    local secondWithin=false
    for _,field in pairs(fields) do
        local poly=polygonFor(field)
        if poly~=nil then
            validPolygons=validPolygons+1
            local firstInside=inside(poly,a.x,a.z)
            local secondInside=inside(poly,b.x,b.z)
            if firstInside then firstWithin=true end
            if secondInside then secondWithin=true end
            if firstInside and secondInside then return poly,field end
        end
    end
    if validPolygons==0 then return nil,nil,"FIELD_POLYGON_EVIDENCE_UNAVAILABLE" end
    if firstWithin and secondWithin then
        return nil,nil,"PAIR_NOT_IN_COMMON_FIELD_POLYGON"
    end
    return nil,nil,"PAIR_OUTSIDE_KNOWN_FIELD_POLYGONS"
end

function Authority.new(configuration)
    return setmetatable({configuration=configuration,active=nil,sequence=0},Authority)
end

function Authority:enabled()
    return g_server~=nil and self.configuration~=nil
        and self.configuration:isResolved()==true
        and self.configuration:isEnabled()==true
end

local function participant(vehicle,strategy,job,point)
    return {vehicle=vehicle,assemblyReferenceKey=tostring(vehicle.rootNode),
        x=point.x,z=point.z,sourceJobReference=job,
        sourceStrategyReference=strategy}
end

-- The candidate is mere nomination; admission re-reads both native jobs,
-- strategies, current positions, common polygon and duration.
-- The blocker working width is a vector scale, not a collision envelope or
-- physical observation of the TRANSIT assembly.
function Authority:admitCandidate(first,second,blockedWorker,confirmedBlockedMs)
    if self.active~=nil or not self:enabled()
        or type(first)~="table" or type(second)~="table"
        or first==second or not finite(confirmedBlockedMs)
        or confirmedBlockedMs<1000 then return nil,"PAIR_ADMISSION_UNAVAILABLE" end
    local as,bs=currentStrategy(first),currentStrategy(second)
    local aj,bj=currentJob(first),currentJob(second)
    local ap,bp=pose(first),pose(second)
    if as==nil or bs==nil then return nil,"NATIVE_FIELD_COURSE_STRATEGY_UNAVAILABLE" end
    if aj==nil or bj==nil then return nil,"NATIVE_JOB_REFERENCE_UNAVAILABLE" end
    if ap==nil or bp==nil then return nil,"ASSEMBLY_ROOT_POSE_UNAVAILABLE" end
    if first.rootNode==second.rootNode then return nil,"ROOT_IDENTITIES_NOT_DISTINCT" end
    if blockedWorker~=first and blockedWorker~=second then
        return nil,"BLOCKED_SUBJECT_UNVERIFIED"
    end
    local blockedStrategy=blockedWorker==first and as or bs
    if blockedStrategy.isBlocked~=true then
        return nil,"NATIVE_BLOCKAGE_NO_LONGER_POSITIVE"
    end
    local dx,dz=ap.x-bp.x,ap.z-bp.z
    if dx*dx+dz*dz>900 then return nil,"PAIR_OUTSIDE_LOCALITY" end
    local poly,field,fieldReason=commonField(ap,bp)
    if poly==nil then return nil,fieldReason or "FIELD_CENTROID_UNAVAILABLE" end
    if not inside(poly,poly.centroid.x,poly.centroid.z) then
        return nil,"FIELD_CENTROID_OUTSIDE_FIELD_POLYGON"
    end
    self.sequence=self.sequence+1
    local commitment={
        commitmentId="native-pair-"..tostring(self.sequence),
        participants={participant(first,as,aj,ap),participant(second,bs,bj,bp)},
        fieldCentroid=poly.centroid,fieldPolygon=poly,
        offsetM=0,
        nearbyBlockers={},nativeFieldReference=field,
        wasIndependentlyAdmitted=true
    }
    local a,b=commitment.participants[1],commitment.participants[2]
    local da=(a.x-poly.centroid.x)^2+(a.z-poly.centroid.z)^2
    local db=(b.x-poly.centroid.x)^2+(b.z-poly.centroid.z)^2
    local relocator=(da<db or (da==db
        and a.assemblyReferenceKey<b.assemblyReferenceKey)) and a or b
    commitment.nearbyBlockers[1]=relocator==a and b or a
    local width,widthReason=blockerWorkingWidth(commitment.nearbyBlockers[1].vehicle)
    if width==nil then return nil,widthReason end
    commitment.blockerWorkingWidthM=width
    self.active=commitment
    return commitment
end

function Authority:validateCommitment(commitment)
    if self.active~=commitment or commitment==nil then
        return false,"COMMITMENT_NOT_ISSUED"
    end
    return self:isCommitmentCurrent(commitment)
end

function Authority:isCommitmentCurrent(commitment)
    if not self:enabled() or self.active~=commitment then
        return false,"COMMITMENT_REVOKED"
    end
    for i=1,#commitment.participants do
        local p=commitment.participants[i]
        if currentJob(p.vehicle)~=p.sourceJobReference
            or currentStrategy(p.vehicle)~=p.sourceStrategyReference
            or pose(p.vehicle)==nil then
            return false,"GIANTS_JOB_EPISODE_CHANGED"
        end
    end
    return true
end

function Authority:getExpectedNativeJob(vehicle)
    local commitment=self.active
    if commitment==nil then return nil end
    for i=1,#commitment.participants do
        local p=commitment.participants[i]
        if p.vehicle==vehicle then return p.sourceJobReference end
    end
    return nil
end

function Authority:release(commitment)
    if self.active~=commitment then return false end
    self.active=nil
    return true
end
