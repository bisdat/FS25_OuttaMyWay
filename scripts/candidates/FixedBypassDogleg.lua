--- Builds and checks the four-leg Bypass reference guide; makes no assembly sweep or clearance claim.
-- Specification Jurisdictions: `BOUNDED_BYPASS`
OuttaMyWay.FixedBypassDogleg={}
local Guide=OuttaMyWay.FixedBypassDogleg
local V=OuttaMyWay.ValueRecord
local LATERAL_OUTCOME_M=10
local ADVANCE_M=10
local REFERENCE_SAMPLE_M=1
local function finite(v) return type(v)=="number" and v==v and math.abs(v)<math.huge end
local function cross(x,z,u,v) return x*v-z*u end
local function rings(field)
    local result={field.boundary}
    for _,island in V.ipairs(field.islands or {}) do result[#result+1]=island.boundary or island end
    return result
end
local function insideRing(x,z,ring)
    local n=V.length(ring or {})
    if n<3 then return false end
    local inside=false
    local b=ring[n]
    for _,a in V.ipairs(ring) do
        if not finite(a.x) or not finite(a.z) or not finite(b.x) or not finite(b.z) then return false end
        if (a.z>z)~=(b.z>z) and x<(b.x-a.x)*(z-a.z)/(b.z-a.z)+a.x then inside=not inside end
        b=a
    end
    return inside
end
function Guide.contains(field,x,z)
    if not finite(x) or not finite(z) or type(field)~="table" or not insideRing(x,z,field.boundary) then return false end
    for _,island in V.ipairs(field.islands or {}) do
        if insideRing(x,z,island.boundary or island) then return false end
    end
    return true
end
local function edgeDistance(x,z,a,b)
    local dx,dz=b.x-a.x,b.z-a.z
    local length=dx*dx+dz*dz
    local t=length>0 and math.max(0,math.min(1,((x-a.x)*dx+(z-a.z)*dz)/length)) or 0
    return math.sqrt((x-a.x-t*dx)^2+(z-a.z-t*dz)^2)
end
-- Reject boundary intersections as well as exterior samples, so narrow islands
-- cannot disappear between samples. Reserve is a side preference, not clearance.
function Guide.support(field,guide)
    local previous=guide.origin
    local reserveSum,count=0,0
    if not Guide.contains(field,previous.x,previous.z) then return false end
    for _,target in V.ipairs(guide.targets) do
        if not Guide.contains(field,target.x,target.z) then return false end
        for _,ring in ipairs(rings(field)) do
            local b=ring[V.length(ring)]
            for _,a in V.ipairs(ring) do
                local dx,dz=target.x-previous.x,target.z-previous.z
                local ex,ez=b.x-a.x,b.z-a.z
                local denominator=cross(dx,dz,ex,ez)
                if math.abs(denominator)>1e-9 then
                    local t=cross(a.x-previous.x,a.z-previous.z,ex,ez)/denominator
                    local u=cross(a.x-previous.x,a.z-previous.z,dx,dz)/denominator
                    if t>=0 and t<=1 and u>=0 and u<=1 then return false end
                end
                b=a
            end
        end
        local length=math.sqrt((target.x-previous.x)^2+(target.z-previous.z)^2)
        local samples=math.max(1,math.ceil(length/REFERENCE_SAMPLE_M))
        for i=0,samples do
            local t=i/samples
            local x,z=previous.x+(target.x-previous.x)*t,previous.z+(target.z-previous.z)*t
            if not Guide.contains(field,x,z) then return false end
            local reserve=math.huge
            for _,ring in ipairs(rings(field)) do
                local b=ring[V.length(ring)]
                for _,a in V.ipairs(ring) do reserve=math.min(reserve,edgeDistance(x,z,a,b)); b=a end
            end
            if reserve<=0.001 then return false end
            reserveSum=reserveSum+reserve; count=count+1
        end
        previous=target
    end
    return true,reserveSum/count
end
function Guide.requiredLaunchSeparationM()
    local profile=OuttaMyWay.ForwardDiagonalSteeringHelper.profile(LATERAL_OUTCOME_M)
    return profile and profile.forwardDistanceM or nil
end
function Guide.build(frame,side,launchSteeringHorizonM)
    if side~=1 and side~=-1 then return nil end
    local profile=OuttaMyWay.ForwardDiagonalSteeringHelper.profile(side*LATERAL_OUTCOME_M)
    local diagonal=profile.forwardDistanceM
    local horizon=tonumber(launchSteeringHorizonM)
    if not finite(horizon) or horizon<=diagonal then return nil end
    local function target(kind,forward,lateral,moveForwards)
        return {kind=kind,x=frame.x+frame.forwardX*forward+frame.rightX*lateral,
            z=frame.z+frame.forwardZ*forward+frame.rightZ*lateral,forwardM=forward,lateralM=lateral,
            moveForwards=moveForwards}
    end
    return {origin={x=frame.x,z=frame.z},frame=frame,side=side,launchSeparationM=diagonal,
        launchSteeringHorizonM=horizon,
        launchSteeringTarget={
            x=frame.x-frame.forwardX*horizon,
            z=frame.z-frame.forwardZ*horizon
        },
        targets={
            target("BYPASS_LAUNCH_SEPARATION",-diagonal,0,false),
            target("LATERAL_DEPARTURE",0,side*LATERAL_OUTCOME_M,true),
            target("BYPASS_ADVANCE",ADVANCE_M,side*LATERAL_OUTCOME_M,true),
            target("POST_BLOCKAGE_AXIS_REJOIN",diagonal+ADVANCE_M,0,true)}}
end
