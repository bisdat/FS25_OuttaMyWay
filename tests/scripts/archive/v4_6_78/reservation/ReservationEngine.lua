-- FS25_OuttaMyWay observer-only trajectory reservation engine.
-- Converts vector predictions into time-bounded corridor reservations.
-- This module never changes vehicle controls.

local function reservationLog(text, ...)
    if OuttaMyWay.isDebugEnabled ~= nil and not OuttaMyWay:isDebugEnabled("reservations") then return end
    Logging.info("[%s] %s", OuttaMyWay.MOD_NAME, string.format(text, ...))
end

local function isActionable(prediction)
    return prediction ~= nil
        and (prediction.severity == "WATCH" or prediction.severity == "CONFLICT" or prediction.severity == "CRITICAL")
        and prediction.tcpa ~= nil
        and prediction.tcpa >= 0
end

function OuttaMyWay:updateReservationEngine()
    self.trajectoryReservations = self.trajectoryReservations or {}
    self.nextReservationId = self.nextReservationId or 1

    local now = g_time or 0
    local seen = {}
    local lead = self.RESERVATION_TIME_PADDING_SECONDS or 2.5
    local tail = self.RESERVATION_CLEARANCE_SECONDS or 4.0

    for key, prediction in pairs(self.vectorPredictions or {}) do
        if isActionable(prediction) then
            seen[key] = true
            local reservation = self.trajectoryReservations[key]
            if reservation == nil then
                reservation = { id=self.nextReservationId, createdAt=now, nextLogAt=0 }
                self.nextReservationId = self.nextReservationId + 1
                self.trajectoryReservations[key] = reservation
            end

            local tcpa = math.max(0, prediction.tcpa or 0)
            reservation.prediction = prediction
            reservation.workerA = prediction.workerA
            reservation.workerB = prediction.workerB
            reservation.pointX = prediction.pointX
            reservation.pointZ = prediction.pointZ
            reservation.corridorWidth = prediction.requiredClearance or 0
            reservation.startAt = now + math.max(0, tcpa-lead)*1000
            reservation.endAt = now + (tcpa+tail)*1000
            reservation.confidence = prediction.confidence or 0
            reservation.state = reservation.confidence >= (self.RESERVATION_MIN_CONFIDENCE or 0.60) and "CONFLICT" or "PROVISIONAL"
            reservation.updatedAt = now

            local changed = reservation.lastState ~= reservation.state or reservation.lastSeverity ~= prediction.severity
            if changed or now >= (reservation.nextLogAt or 0) then
                reservationLog("RESERVATION #%d: %s / %s state=%s severity=%s window=%.1f..%.1fs point=(%.1f, %.1f) corridor=%.1fm confidence=%.2f",
                    reservation.id,
                    reservation.workerA and reservation.workerA.name or "worker A",
                    reservation.workerB and reservation.workerB.name or "worker B",
                    reservation.state, prediction.severity or "SAFE",
                    math.max(0,(reservation.startAt-now)/1000), math.max(0,(reservation.endAt-now)/1000),
                    reservation.pointX or 0, reservation.pointZ or 0,
                    reservation.corridorWidth or 0, reservation.confidence or 0)
                reservation.nextLogAt = now + (self.RESERVATION_LOG_INTERVAL_MS or 3000)
            end
            reservation.lastState = reservation.state
            reservation.lastSeverity = prediction.severity
        end
    end

    for key, reservation in pairs(self.trajectoryReservations) do
        if not seen[key] then
            if reservation.clearedAt == nil then
                reservation.clearedAt = now
                reservationLog("RESERVATION #%d CLEAR: %s / %s", reservation.id or 0,
                    reservation.workerA and reservation.workerA.name or "worker A",
                    reservation.workerB and reservation.workerB.name or "worker B")
            elseif now-reservation.clearedAt > (self.RESERVATION_RETENTION_MS or 5000) then
                self.trajectoryReservations[key] = nil
            end
        else
            reservation.clearedAt = nil
        end
    end
end

function OuttaMyWay:getReservationForPrediction(prediction)
    if prediction == nil then return nil end
    for _, reservation in pairs(self.trajectoryReservations or {}) do
        if reservation.prediction == prediction then return reservation end
    end
    return nil
end

function OuttaMyWay:getPrimaryReservation()
    local best = nil
    local rank = {PROVISIONAL=1, CONFLICT=2}
    for _, reservation in pairs(self.trajectoryReservations or {}) do
        if reservation.clearedAt == nil then
            if best == nil
                or (rank[reservation.state] or 0) > (rank[best.state] or 0)
                or ((rank[reservation.state] or 0) == (rank[best.state] or 0)
                    and (reservation.prediction and reservation.prediction.tcpa or math.huge)
                        < (best.prediction and best.prediction.tcpa or math.huge)) then
                best = reservation
            end
        end
    end
    return best
end
