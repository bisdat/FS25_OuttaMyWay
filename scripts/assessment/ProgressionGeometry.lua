-- Neutral geometry used by Situation/shadow progression reasoning.
-- Pure maths only; no semantic, Decision or Control authority.
OuttaMyWay.ProgressionGeometry={}
local G=OuttaMyWay.ProgressionGeometry
local function finite(v) return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge end
local function norm(x,z) if not finite(x) or not finite(z) then return nil,nil end; local l=math.sqrt(x*x+z*z); if l<=0.000001 then return nil,nil end; return x/l,z/l end
local function dot(ax,az,bx,bz) return ax*bx+az*bz end
local function clamp(v,a,b) if v<a then return a elseif v>b then return b else return v end end
local function pointSegmentDistance(px,pz,ax,az,bx,bz)
    local vx,vz=bx-ax,bz-az; local l2=vx*vx+vz*vz
    if l2<=0.000000000001 then local dx,dz=px-ax,pz-az; return math.sqrt(dx*dx+dz*dz) end
    local t=clamp(((px-ax)*vx+(pz-az)*vz)/l2,0,1); local qx,qz=ax+t*vx,az+t*vz; local dx,dz=px-qx,pz-qz; return math.sqrt(dx*dx+dz*dz)
end
local function rayCircleEntry(px,pz,dx,dz,cx,cz,r)
    local qx,qz=px-cx,pz-cz; local c=qx*qx+qz*qz-r*r; if c<=0 then return 0 end
    local b=qx*dx+qz*dz; local disc=b*b-c; if disc<0 then return nil end
    local t=-b-math.sqrt(disc); if t>=0 then return t end; local t2=-b+math.sqrt(disc); if t2>=0 then return t2 end; return nil
end
function G.rayCapsuleEntry(px,pz,dx,dz,ax,az,bx,bz,radius)
    if not (finite(px) and finite(pz) and finite(dx) and finite(dz) and finite(ax) and finite(az) and finite(bx) and finite(bz) and finite(radius)) then return nil,"INVALID_GEOMETRY" end
    dx,dz=norm(dx,dz); if dx==nil then return nil,"INVALID_RAY_DIRECTION" end; radius=math.max(0,radius)
    if pointSegmentDistance(px,pz,ax,az,bx,bz)<=radius then return 0,"ALREADY_INTERSECTING_REPRESENTED_CAPSULE" end
    local sx,sz=bx-ax,bz-az; local length=math.sqrt(sx*sx+sz*sz)
    if length<=0.000001 then return rayCircleEntry(px,pz,dx,dz,ax,az,radius),"ENDPOINT_DISC" end
    local ux,uz=sx/length,sz/length; local nx,nz=-uz,ux; local qx,qz=px-ax,pz-az; local qu=dot(qx,qz,ux,uz); local qn=dot(qx,qz,nx,nz); local du=dot(dx,dz,ux,uz); local dn=dot(dx,dz,nx,nz); local best=nil
    local function accept(t) if t~=nil and t>=0 and (best==nil or t<best) then best=t end end
    accept(rayCircleEntry(px,pz,dx,dz,ax,az,radius)); accept(rayCircleEntry(px,pz,dx,dz,bx,bz,radius))
    if math.abs(dn)>0.0000001 then for _,side in ipairs({-radius,radius}) do local t=(side-qn)/dn; if t>=0 then local u=qu+du*t; if u>=0 and u<=length then accept(t) end end end end
    return best,best~=nil and "RAY_CAPSULE_ENTRY" or "NO_POSITIVE_REPRESENTED_INTERSECTION"
end
