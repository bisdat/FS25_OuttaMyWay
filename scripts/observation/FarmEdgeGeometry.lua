-- Read-only polygon/edge mathematics for the Farm Spatial Context investigation.
-- Specification Jurisdictions: `FARM_SPATIAL_CONTEXT_OBSERVATION`
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.FarmEdgeGeometry={}
local G=OuttaMyWay.FarmEdgeGeometry

local function finite(x)
    return type(x)=="number" and x==x and x~=math.huge and x~=-math.huge
end

function G.polygonFor(field)
    local p=type(field)=="table" and field.densityMapPolygon
    local xs=p and p.pointsX
    local zs=p and p.pointsZ
    if type(xs)~="table" or type(zs)~="table"
        or #xs<3 or #xs~=#zs or #xs>256 then return nil,"FIELD_POLYGON_UNAVAILABLE" end
    local result={xs={},zs={},minX=math.huge,maxX=-math.huge,
        minZ=math.huge,maxZ=-math.huge}
    for i=1,#xs do
        local x,z=xs[i],zs[i]
        if not finite(x) or not finite(z) then return nil,"FIELD_VERTEX_INVALID" end
        result.xs[i],result.zs[i]=x,z
        result.minX=math.min(result.minX,x)
        result.maxX=math.max(result.maxX,x)
        result.minZ=math.min(result.minZ,z)
        result.maxZ=math.max(result.maxZ,z)
    end
    local n=#result.xs
    if n>3 and result.xs[1]==result.xs[n]
        and result.zs[1]==result.zs[n] then
        result.xs[n],result.zs[n]=nil,nil
        n=n-1
    end
    if n<3 then return nil,"FIELD_POLYGON_DEGENERATE" end
    local twiceArea=0
    for i=1,n do
        local j=i==n and 1 or i+1
        twiceArea=twiceArea+result.xs[i]*result.zs[j]-result.xs[j]*result.zs[i]
    end
    if math.abs(twiceArea)<0.000001 then return nil,"FIELD_POLYGON_ZERO_AREA" end
    result.twiceArea=twiceArea
    result.vertexCount=n
    return result
end

function G.inside(p,x,z)
    if p==nil or not finite(x) or not finite(z) then return false end
    local n=p.vertexCount
    local inside=false
    for i=1,n do
        local j=i==1 and n or i-1
        local xi,zi,xj,zj=p.xs[i],p.zs[i],p.xs[j],p.zs[j]
        if (zi>z)~=(zj>z) then
            local crossing=xj+(xi-xj)*(z-zj)/(zi-zj)
            if x<crossing then inside=not inside end
        end
    end
    return inside
end

function G.pointSegmentDistance(x,z,ax,az,bx,bz)
    local dx,dz=bx-ax,bz-az
    local squared=dx*dx+dz*dz
    if squared<0.000001 then
        return math.sqrt((x-ax)^2+(z-az)^2)
    end
    local t=math.max(0,math.min(1,((x-ax)*dx+(z-az)*dz)/squared))
    return math.sqrt((x-ax-dx*t)^2+(z-az-dz*t)^2)
end

function G.distanceToBoundary(p,x,z)
    if p==nil then return nil end
    local closest=math.huge
    for i=1,p.vertexCount do
        local j=i==p.vertexCount and 1 or i+1
        closest=math.min(closest,G.pointSegmentDistance(
            x,z,p.xs[i],p.zs[i],p.xs[j],p.zs[j]))
    end
    return closest
end


local function cross(ax,az,bx,bz,cx,cz)
    return (bx-ax)*(cz-az)-(bz-az)*(cx-ax)
end

local function onSegment(ax,az,bx,bz,x,z)
    return x>=math.min(ax,bx)-0.000001 and x<=math.max(ax,bx)+0.000001
        and z>=math.min(az,bz)-0.000001 and z<=math.max(az,bz)+0.000001
end

function G.segmentDistance(ax,az,bx,bz,cx,cz,dx,dz)
    local o1=cross(ax,az,bx,bz,cx,cz)
    local o2=cross(ax,az,bx,bz,dx,dz)
    local o3=cross(cx,cz,dx,dz,ax,az)
    local o4=cross(cx,cz,dx,dz,bx,bz)
    if (o1*o2<0 and o3*o4<0)
        or (math.abs(o1)<0.000001 and onSegment(ax,az,bx,bz,cx,cz))
        or (math.abs(o2)<0.000001 and onSegment(ax,az,bx,bz,dx,dz))
        or (math.abs(o3)<0.000001 and onSegment(cx,cz,dx,dz,ax,az))
        or (math.abs(o4)<0.000001 and onSegment(cx,cz,dx,dz,bx,bz)) then
        return 0
    end
    return math.min(
        G.pointSegmentDistance(ax,az,cx,cz,dx,dz),
        G.pointSegmentDistance(bx,bz,cx,cz,dx,dz),
        G.pointSegmentDistance(cx,cz,ax,az,bx,bz),
        G.pointSegmentDistance(dx,dz,ax,az,bx,bz))
end

-- Exact X/Z segment-to-polygon-boundary gap for native straight-edge polygons.
-- A positive result is geometry only, not free-space or route evidence.
function G.edgeToPolygonGap(edge,p)
    if p==nil then return nil end
    local mx,mz=(edge.ax+edge.bx)/2,(edge.az+edge.bz)/2
    if G.inside(p,mx,mz) then return 0 end
    local nearest=math.huge
    for i=1,p.vertexCount do
        local j=i==p.vertexCount and 1 or i+1
        nearest=math.min(nearest,G.segmentDistance(
            edge.ax,edge.az,edge.bx,edge.bz,
            p.xs[i],p.zs[i],p.xs[j],p.zs[j]))
        if nearest==0 then break end
    end
    return nearest
end

local function sideOf(p,x,z)
    local dx=math.max(p.maxX-p.minX,0.001)
    local dz=math.max(p.maxZ-p.minZ,0.001)
    local candidates={
        {name="X_MIN",value=(x-p.minX)/dx},
        {name="X_MAX",value=(p.maxX-x)/dx},
        {name="Z_MIN",value=(z-p.minZ)/dz},
        {name="Z_MAX",value=(p.maxZ-z)/dz}
    }
    local best=candidates[1]
    for i=2,#candidates do
        if candidates[i].value<best.value then best=candidates[i] end
    end
    return best.name
end

function G.edges(p)
    local result={}
    for i=1,p.vertexCount do
        local j=i==p.vertexCount and 1 or i+1
        local ax,az,bx,bz=p.xs[i],p.zs[i],p.xs[j],p.zs[j]
        local dx,dz=bx-ax,bz-az
        local length=math.sqrt(dx*dx+dz*dz)
        if length>=0.01 then
            -- Positive signed area => polygon interior is left of each
            -- directed edge. Outward is therefore its right-hand normal.
            local sign=p.twiceArea>0 and 1 or -1
            local nx,nz=sign*dz/length,-sign*dx/length
            local mx,mz=(ax+bx)/2,(az+bz)/2
            result[#result+1]={index=i,nextIndex=j,ax=ax,az=az,
                bx=bx,bz=bz,dx=dx,dz=dz,length=length,
                nx=nx,nz=nz,side=sideOf(p,mx,mz)}
        end
    end
    return result
end

-- Establish local outside orientation from geometry rather than assuming
-- winding or image orientation. Ambiguous concavities are reported unknown.
function G.outwardAt(p,e,x,z)
    local nx,nz=e.nx,e.nz
    local plus=G.inside(p,x+nx*0.25,z+nz*0.25)
    local minus=G.inside(p,x-nx*0.25,z-nz*0.25)
    if plus==minus then return nil,nil,"OUTWARD_AMBIGUOUS" end
    if plus then return -nx,-nz,nil end
    return nx,nz,nil
end

return G
