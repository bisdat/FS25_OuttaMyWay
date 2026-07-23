-- GIANTS field-boundary detection and ray/polygon geometry.
-- Behaviour extracted from the v2.7/v3.0 runtime without changing decisions.

local FieldBoundary = {}
OuttaMyWay.FieldBoundary = FieldBoundary

local function vehicleName(vehicle)
    if vehicle == nil then return "unknown" end
    if vehicle.getName ~= nil then
        local ok, name = pcall(vehicle.getName, vehicle)
        if ok and name ~= nil then return tostring(name) end
    end
    return tostring(vehicle)
end

local function info(fmt, ...)
    print(string.format("Info: [FS25_OuttaMyWay] " .. fmt, ...))
end

local function deleted(vehicle)
    return vehicle == nil or vehicle.isDeleted == true or vehicle.rootNode == nil
end

local function raySegmentDistance(ox, oz, dx, dz, ax, az, bx, bz)
    local sx, sz = bx-ax, bz-az
    local den = dx*sz - dz*sx
    if math.abs(den) < 0.000001 then return nil end
    local qx, qz = ax-ox, az-oz
    local t = (qx*sz - qz*sx) / den
    local u = (qx*dz - qz*dx) / den
    if t >= 0 and u >= 0 and u <= 1 then return t end
    return nil
end

function OuttaMyWay.boundaryRayDistance(boundary, ox, oz, dx, dz)
    if boundary == nil or #boundary < 2 then return nil end
    local best = nil
    for i=1,#boundary do
        local a = boundary[i]
        local b = boundary[(i % #boundary)+1]
        local ax, az = a[1] or a.x, a[2] or a.z
        local bx, bz = b[1] or b.x, b[2] or b.z
        if ax ~= nil and az ~= nil and bx ~= nil and bz ~= nil then
            local t = raySegmentDistance(ox, oz, dx, dz, ax, az, bx, bz)
            if t ~= nil and (best == nil or t < best) then best = t end
        end
    end
    return best
end

function FieldBoundary.pointInPolygon(boundary, x, z)
    if boundary == nil or #boundary < 3 then return nil end
    local inside = false
    local j = #boundary
    for i=1,#boundary do
        local pi, pj = boundary[i], boundary[j]
        local xi = pi.x or pi[1]
        local zi = pi.z or pi[2] or pi[3]
        local xj = pj.x or pj[1]
        local zj = pj.z or pj[2] or pj[3]
        if xi == nil or zi == nil or xj == nil or zj == nil then return nil end
        if ((zi > z) ~= (zj > z)) then
            local crossX = (xj-xi) * (z-zi) / ((zj-zi) ~= 0 and (zj-zi) or 0.000001) + xi
            if x < crossX then inside = not inside end
        end
        j = i
    end
    return inside
end

function OuttaMyWay:getFieldBoundaryDistances(data)
    local state = self.giantsFieldBoundary[data.vehicle]
    if state == nil or state.boundary == nil then return nil end
    local inside = FieldBoundary.pointInPolygon(state.boundary, data.x, data.z)
    if inside == false then
        return {inside=false, forward=0.0, rear=0.0, nearest=0.0}
    end
    local forward = self.boundaryRayDistance(state.boundary, data.x, data.z, data.dx, data.dz)
    local rear = self.boundaryRayDistance(state.boundary, data.x, data.z, -data.dx, -data.dz)
    local nearest = forward ~= nil and rear ~= nil and math.min(forward, rear) or forward or rear
    return {inside=true, forward=forward, rear=rear, nearest=nearest}
end

function OuttaMyWay:getBoundaryBackoutDistance(data, vehicleLength)
    local edges = self:getFieldBoundaryDistances(data)
    if edges == nil or edges.rear == nil then return nil, edges end
    if edges.inside == false then return 0.0, edges end
    return edges.rear + (vehicleLength or 0) * 0.5 + self.FIELD_EDGE_OVERSHOOT, edges
end

function OuttaMyWay:startGiantsBoundaryProbe(d)
    local vehicle = d.vehicle
    local state = self.giantsFieldBoundary[vehicle]
    local now = g_time or 0
    if state ~= nil and (state.pending or state.boundary ~= nil or now < (state.retryAt or 0)) then return end

    state = state or {}
    self.giantsFieldBoundary[vehicle] = state
    state.pending, state.startedAt, state.updates, state.error = true, now, 0, nil

    if FieldCourseSettings == nil or FieldCourseSettings.generate == nil
        or FieldCourseField == nil or FieldCourseField.generateAtPosition == nil then
        state.pending = false
        state.retryAt = now + self.GIANTS_BOUNDARY_RETRY_MS
        state.error = "GIANTS FieldCourse API unavailable"
        info("GIANTS FIELD BOUNDARY POC: %s failed (%s)", vehicleName(vehicle), state.error)
        return
    end

    local okSettings, settings = pcall(FieldCourseSettings.generate, vehicle)
    if not okSettings or settings == nil then
        state.pending = false
        state.retryAt = now + self.GIANTS_BOUNDARY_RETRY_MS
        state.error = "FieldCourseSettings.generate failed"
        info("GIANTS FIELD BOUNDARY POC: %s failed (%s)", vehicleName(vehicle), state.error)
        return
    end

    local okCreate, courseField = pcall(function()
        return FieldCourseField.generateAtPosition(d.x, d.z, settings, function(result, success)
            state.pending = false
            state.finishedAt = g_time or 0
            if success and result ~= nil and result.fieldRootBoundary ~= nil
                and result.fieldRootBoundary.boundaryLine ~= nil then
                state.boundary = result.fieldRootBoundary.boundaryLine
                state.islandCount = result.islands ~= nil and #result.islands or 0
                state.error = nil
                info("GIANTS FIELD BOUNDARY POC: %s success after %d updates; points=%d islands=%d",
                    vehicleName(vehicle), state.updates or 0, #state.boundary, state.islandCount)
            else
                state.boundary = nil
                state.error = "generateAtPosition callback returned failure"
                state.retryAt = (g_time or 0) + self.GIANTS_BOUNDARY_RETRY_MS
                info("GIANTS FIELD BOUNDARY POC: %s failed after %d updates (%s)",
                    vehicleName(vehicle), state.updates or 0, state.error)
            end
        end)
    end)
    if not okCreate or courseField == nil then
        state.pending = false
        state.retryAt = now + self.GIANTS_BOUNDARY_RETRY_MS
        state.error = "FieldCourseField.generateAtPosition failed"
        info("GIANTS FIELD BOUNDARY POC: %s failed (%s)", vehicleName(vehicle), state.error)
        return
    end
    state.courseField = courseField
    info("GIANTS FIELD BOUNDARY POC: %s started at %.1f, %.1f", vehicleName(vehicle), d.x, d.z)
end

function OuttaMyWay:updateGiantsBoundaryProbes(dt)
    for vehicle,state in pairs(self.giantsFieldBoundary) do
        if deleted(vehicle) then
            self.giantsFieldBoundary[vehicle] = nil
        elseif state.pending and state.courseField ~= nil and state.courseField.update ~= nil then
            local ok, stillRunning = pcall(state.courseField.update, state.courseField, dt, 0.00025)
            state.updates = (state.updates or 0) + 1
            if not ok then
                state.pending = false
                state.error = "courseField:update failed"
                state.retryAt = (g_time or 0) + self.GIANTS_BOUNDARY_RETRY_MS
                info("GIANTS FIELD BOUNDARY POC: %s failed (%s)", vehicleName(vehicle), state.error)
            elseif stillRunning == false and state.pending and (g_time or 0) - (state.startedAt or 0) > 5000 then
                state.pending = false
                state.error = "detector finished without callback"
                state.retryAt = (g_time or 0) + self.GIANTS_BOUNDARY_RETRY_MS
                info("GIANTS FIELD BOUNDARY POC: %s failed (%s)", vehicleName(vehicle), state.error)
            end
        end
    end
end

function OuttaMyWay:logGiantsBoundaryDistance(d)
    local state = self.giantsFieldBoundary[d.vehicle]
    if state == nil or state.boundary == nil then return end
    local now = g_time or 0
    if now - (state.lastDistanceLog or -self.GIANTS_BOUNDARY_LOG_INTERVAL_MS) < self.GIANTS_BOUNDARY_LOG_INTERVAL_MS then return end
    state.lastDistanceLog = now

    local fx, fz = d.fx, d.fz
    if fx == nil or fz == nil then
        local node = d.vehicle ~= nil and d.vehicle.rootNode or nil
        if node ~= nil then
            local okDir, wx, _, wz = pcall(localDirectionToWorld, node, 0, 0, 1)
            if okDir then fx, fz = wx, wz end
        end
    end
    if fx == nil or fz == nil then
        info("GIANTS FIELD EDGE POC: %s boundary loaded but vehicle heading unavailable", vehicleName(d.vehicle))
        return
    end
    local len = math.sqrt(fx*fx + fz*fz)
    if len < 0.0001 then
        info("GIANTS FIELD EDGE POC: %s boundary loaded but vehicle heading invalid", vehicleName(d.vehicle))
        return
    end
    fx, fz = fx/len, fz/len
    local forward = self.boundaryRayDistance(state.boundary, d.x, d.z, fx, fz)
    local backward = self.boundaryRayDistance(state.boundary, d.x, d.z, -fx, -fz)
    local nearest = forward ~= nil and backward ~= nil and math.min(forward, backward) or forward or backward
    if nearest == nil then
        info("GIANTS FIELD EDGE POC: %s boundary loaded but no trajectory intersection found", vehicleName(d.vehicle))
    else
        info("GIANTS FIELD EDGE POC: %s nearest=%.1fm forward=%s backward=%s",
            vehicleName(d.vehicle), nearest,
            forward ~= nil and string.format("%.1fm", forward) or "not found",
            backward ~= nil and string.format("%.1fm", backward) or "not found")
    end
end
