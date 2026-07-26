-- FS25_OuttaMyWay predictive DecisionEngine.
-- SIM mode observes recommendations. LIVE mode executes conservative SLOW/YIELD
-- actions through a commitment layer so minor vector jitter cannot repeatedly
-- change or release the selected manoeuvre.

local function decisionLog(text, ...)
    if OuttaMyWay.isDebugEnabled ~= nil and not OuttaMyWay:isDebugEnabled("decisions") then return end
    OuttaMyWay.Logger:dec(text, ...)
end

local function validEdge(value)
    return value ~= nil and value < math.huge and value >= 0
end

local function scoreActions(self, prediction)
    local a, b = prediction.workerA, prediction.workerB
    local dataA = {vehicle=a.vehicle, x=a.x, z=a.z, dx=a.headingX, dz=a.headingZ}
    local dataB = {vehicle=b.vehicle, x=b.x, z=b.z, dx=b.headingX, dz=b.headingZ}
    local edgeA = self:getBoundaryBackoutDistance(dataA, a.vehicleLength)
    local edgeB = self:getBoundaryBackoutDistance(dataB, b.vehicleLength)
    local confidence = prediction.confidence or 0
    local confidencePenalty = (1-confidence)*25
    local tcpa = prediction.tcpa or 20
    local urgency = math.max(0, 12-tcpa)
    local headOn = (prediction.headingDot or 1) < -0.75
    local crossing = math.abs(prediction.headingDot or 1) <= 0.70
    local reservation = self.getReservationForPrediction ~= nil and self:getReservationForPrediction(prediction) or nil
    local reservationPenalty = reservation ~= nil and reservation.state == "CONFLICT" and 0 or 10

    local options = {
        {action="CONTINUE", worker=nil, cost=95 + math.max(0,prediction.overlap or 0)*2.5 + urgency*3},
        {action="SLOW", worker=a, cost=(crossing and 18 or 30) + urgency*1.5 + confidencePenalty + reservationPenalty},
        {action="SLOW", worker=b, cost=(crossing and 20 or 32) + urgency*1.5 + confidencePenalty + reservationPenalty},
        {action="YIELD", worker=a, cost=34 + urgency + confidencePenalty*0.7},
        {action="YIELD", worker=b, cost=36 + urgency + confidencePenalty*0.7}
    }

    if headOn and confidence >= 0.60 then
        if validEdge(edgeA) then table.insert(options,{action="BACKOUT",worker=a,cost=edgeA+8+confidencePenalty*0.2,distance=edgeA}) end
        if validEdge(edgeB) then table.insert(options,{action="BACKOUT",worker=b,cost=edgeB+8+confidencePenalty*0.2,distance=edgeB}) end
    end

    table.sort(options,function(x,y) return x.cost<y.cost end)
    return options, reservation
end

local function sameVehicle(a, b)
    return a ~= nil and b ~= nil and a.vehicle == b.vehicle
end

local function profileForVehicle(prediction, vehicle)
    if prediction == nil or vehicle == nil then return nil end
    if prediction.workerA ~= nil and prediction.workerA.vehicle == vehicle then return prediction.workerA end
    if prediction.workerB ~= nil and prediction.workerB.vehicle == vehicle then return prediction.workerB end
    return nil
end

local function otherProfile(prediction, vehicle)
    if prediction == nil or vehicle == nil then return nil end
    if prediction.workerA ~= nil and prediction.workerA.vehicle == vehicle then return prediction.workerB end
    if prediction.workerB ~= nil and prediction.workerB.vehicle == vehicle then return prediction.workerA end
    return nil
end

local function speedCapFor(profile, prediction)
    local currentSpeed = profile and profile.speedKmh or 10
    local severityFactor = prediction and prediction.severity == "CRITICAL" and 0.45
        or (prediction and prediction.severity == "CONFLICT" and 0.60 or 0.75)
    return math.max(3.5, math.min(14.0, currentSpeed * severityFactor))
end

local function reactiveControlForPrediction(self, prediction)
    if prediction == nil then return nil end
    local va = prediction.workerA and prediction.workerA.vehicle or nil
    local vb = prediction.workerB and prediction.workerB.vehicle or nil
    if va == nil or vb == nil then return nil end
    if self.getEncounterForPair ~= nil then
        local encounter = self:getEncounterForPair(va, vb)
        if encounter ~= nil then
            return {phase="ENCOUNTER_" .. tostring(encounter.phase or "ACTIVE"), owner=encounter.owner, encounter=encounter}
        end
    end
    for _,state in pairs(self.laneReservations or {}) do
        if state ~= nil and ((state.owner == va and state.vacater == vb) or (state.owner == vb and state.vacater == va)) then
            return state
        end
    end
    if self.recoveryVehicle == va or self.recoveryVehicle == vb then
        return {phase="BLOCKED_RECOVERY", owner=self.recoveryVehicle}
    end
    return nil
end

function OuttaMyWay:cancelPredictiveActionsForVehicles(vehicleA, vehicleB, reason)
    for key,action in pairs(self.predictiveActions or {}) do
        if action ~= nil and (action.vehicle == vehicleA or action.vehicle == vehicleB
            or action.priorityVehicle == vehicleA or action.priorityVehicle == vehicleB) then
            self:clearPredictiveAction(key, reason or "superseded by reactive control")
        end
    end
end

local function emergencyEscalationNeeded(action, prediction)
    if action == nil or action.type ~= "SLOW" or prediction == nil then return false end
    local required = math.max(1, prediction.requiredClearance or 1)
    local deeplyOverlapping = (prediction.cpa or required) < required * 0.35
    return prediction.severity == "CRITICAL"
        and (prediction.confidence or 0) >= 0.80
        and (prediction.tcpa or math.huge) <= 4.5
        and deeplyOverlapping
end

function OuttaMyWay:clearPredictiveAction(key, reason)
    self.predictiveActions = self.predictiveActions or {}
    local action = self.predictiveActions[key]
    if action == nil then return end

    if action.type == "SLOW" and self.predictiveSpeedCaps ~= nil and action.vehicle ~= nil then
        self.predictiveSpeedCaps[action.vehicle] = nil
    elseif action.type == "YIELD" and action.vehicle ~= nil and self.waiting ~= nil then
        local waitState = self.waiting[action.vehicle]
        if waitState ~= nil and waitState.predictiveDecisionId == action.decisionId then
            self:release(action.vehicle, reason or "predictive conflict clear")
        end
    end

    decisionLog("DECISION #%d COMMIT CLEAR: %s after %.1fs (%s)",
        action.decisionId or 0, action.type or "?",
        ((g_time or 0) - (action.committedAt or g_time or 0))/1000,
        reason or "clear")
    self.predictiveActions[key] = nil
end

function OuttaMyWay:maintainPredictiveCommitment(key, decision, prediction)
    self.predictiveActions = self.predictiveActions or {}
    self.predictiveSpeedCaps = self.predictiveSpeedCaps or {}
    local action = self.predictiveActions[key]
    if action == nil then return false end

    local now = g_time or 0
    action.updatedAt = now
    action.lastPrediction = prediction or action.lastPrediction
    action.clearCandidateAt = nil

    if now - (action.committedAt or now) >= (self.PREDICTIVE_COMMIT_TIMEOUT_MS or 30000) then
        self:clearPredictiveAction(key, "commit timeout")
        return false
    end

    if emergencyEscalationNeeded(action, prediction) then
        local priorityProfile = otherProfile(prediction, action.vehicle)
        local priorityVehicle = priorityProfile and priorityProfile.vehicle or action.priorityVehicle
        if priorityVehicle ~= nil then
            self.predictiveSpeedCaps[action.vehicle] = nil
            self:setWaiting(action.vehicle, priorityVehicle)
            if self.waiting[action.vehicle] ~= nil then
                self.waiting[action.vehicle].predictiveDecisionId = action.decisionId
            end
            action.type = "YIELD"
            action.priorityVehicle = priorityVehicle
            action.escalatedAt = now
            decisionLog("DECISION #%d COMMIT ESCALATE: SLOW -> YIELD %s -> %s severity=%s TCPA=%.1fs CPA=%.1fm",
                action.decisionId or 0,
                profileForVehicle(prediction, action.vehicle) and profileForVehicle(prediction, action.vehicle).name or "worker",
                priorityProfile and priorityProfile.name or "priority worker",
                prediction.severity or "?", prediction.tcpa or -1, prediction.cpa or -1)
        end
    end

    if action.type == "SLOW" then
        local profile = profileForVehicle(prediction, action.vehicle)
        local cap = speedCapFor(profile, prediction or action.lastPrediction)
        self.predictiveSpeedCaps[action.vehicle] = {
            speedKmh=cap,
            untilTime=now+1000,
            decisionId=action.decisionId
        }
        action.speedKmh = cap
    elseif action.type == "YIELD" then
        local priorityVehicle = action.priorityVehicle
        if priorityVehicle ~= nil then
            local waitState = self.waiting and self.waiting[action.vehicle] or nil
            if waitState == nil then
                self:setWaiting(action.vehicle, priorityVehicle)
                if self.waiting[action.vehicle] ~= nil then
                    self.waiting[action.vehicle].predictiveDecisionId = action.decisionId
                end
            else
                waitState.predictiveDecisionId = action.decisionId
            end
        end
    end

    if decision ~= nil then
        decision.committedAction = action.type
        decision.committedVehicle = action.vehicle
        decision.commitStartedAt = action.committedAt
    end
    return true
end

function OuttaMyWay:executePredictiveDecision(key, decision)
    local reactiveState = reactiveControlForPrediction(self, decision and decision.prediction or nil)
    if reactiveState ~= nil then
        self:clearPredictiveAction(key, "superseded by reactive " .. tostring(reactiveState.phase or reactiveState.mode or "control"))
        if decision ~= nil then
            decision.reactiveLock = reactiveState.phase or reactiveState.mode or "REACTIVE"
        end
        return
    end
    if self.settings == nil or self.settings.simulationMode == true then
        self:clearPredictiveAction(key, "simulation mode")
        return
    end

    self.predictiveActions = self.predictiveActions or {}
    self.predictiveSpeedCaps = self.predictiveSpeedCaps or {}

    -- Once a live action has started, ignore ordinary re-scoring. The action is
    -- maintained until confirmed clear, timeout, or emergency SLOW->YIELD escalation.
    if self:maintainPredictiveCommitment(key, decision, decision.prediction) then return end

    local selected = decision.selected
    local prediction = decision.prediction
    if selected == nil or selected.worker == nil or selected.worker.vehicle == nil then return end

    local vehicle = selected.worker.vehicle
    local priorityProfile = sameVehicle(selected.worker, prediction.workerA) and prediction.workerB or prediction.workerA
    local priorityCandidate = priorityProfile and priorityProfile.vehicle or nil
    local workerPlanning = self.isAIPlanningGrace ~= nil and self:isAIPlanningGrace(vehicle)
    local priorityPlanning = self.isAIPlanningGrace ~= nil and priorityCandidate ~= nil and self:isAIPlanningGrace(priorityCandidate)
    local emergencyPrediction = prediction.severity == "CRITICAL"
        and (prediction.tcpa or 999) <= 2.0
        and (prediction.cpa or 999) <= math.max(8.0, (prediction.requiredClearance or 0) * 0.30)
    if (workerPlanning or priorityPlanning) and not emergencyPrediction then
        return
    end
    local priorityVehicle = priorityProfile and priorityProfile.vehicle or nil
    local now = g_time or 0

    if selected.action == "SLOW" then
        local cap = speedCapFor(selected.worker, prediction)
        self.predictiveSpeedCaps[vehicle] = {speedKmh=cap, untilTime=now+1000, decisionId=decision.id}
        self.predictiveActions[key] = {
            type="SLOW", vehicle=vehicle, priorityVehicle=priorityVehicle,
            decisionId=decision.id, committedAt=now, updatedAt=now,
            lastPrediction=prediction, speedKmh=cap
        }
        decisionLog("DECISION #%d COMMIT SLOW: %s cap=%.1fkm/h severity=%s TCPA=%.1fs",
            decision.id, selected.worker.name, cap, prediction.severity, prediction.tcpa or -1)
    elseif selected.action == "YIELD" and priorityVehicle ~= nil then
        self:setWaiting(vehicle, priorityVehicle)
        if self.waiting[vehicle] ~= nil then self.waiting[vehicle].predictiveDecisionId = decision.id end
        self.predictiveActions[key] = {
            type="YIELD", vehicle=vehicle, priorityVehicle=priorityVehicle,
            decisionId=decision.id, committedAt=now, updatedAt=now,
            lastPrediction=prediction
        }
        decisionLog("DECISION #%d COMMIT YIELD: %s -> %s severity=%s TCPA=%.1fs",
            decision.id, selected.worker.name, priorityProfile.name, prediction.severity, prediction.tcpa or -1)
    end
    -- BACKOUT remains advisory until early live control is proven stable.
end

function OuttaMyWay:updateDecisionEngine()
    self.decisions = self.decisions or {}
    self.predictiveActions = self.predictiveActions or {}
    self.nextDecisionId = self.nextDecisionId or 1
    local now = g_time or 0
    local seen = {}

    for key,prediction in pairs(self.vectorPredictions or {}) do
        local actionable = prediction.severity=="WATCH" or prediction.severity=="CONFLICT" or prediction.severity=="CRITICAL"
        if actionable then
            seen[key]=true
            local decision=self.decisions[key]
            if decision==nil then
                decision={id=self.nextDecisionId,createdAt=now,nextLogAt=0}
                self.nextDecisionId=self.nextDecisionId+1
                self.decisions[key]=decision
            end

            decision.prediction=prediction
            decision.options,decision.reservation=scoreActions(self,prediction)
            decision.selected=decision.options[1]
            decision.updatedAt=now
            decision.clearCandidateAt=nil

            local commitment=self.predictiveActions[key]
            local displayedAction=commitment and commitment.type or decision.selected.action
            local displayedVehicle=commitment and commitment.vehicle or (decision.selected.worker and decision.selected.worker.vehicle or nil)
            local changed=decision.lastSeverity~=prediction.severity
                or decision.lastAction~=displayedAction
                or decision.lastWorkerVehicle~=displayedVehicle

            if changed or now>=(decision.nextLogAt or 0) then
                local committedProfile=commitment and profileForVehicle(prediction, commitment.vehicle) or nil
                local selectedName=committedProfile and committedProfile.name
                    or (decision.selected.worker and decision.selected.worker.name or "none")
                local reservationText=decision.reservation and string.format("R#%d/%s",decision.reservation.id or 0,decision.reservation.state or "?") or "none"
                local reactiveState=reactiveControlForPrediction(self,prediction)
                local lockText=reactiveState and string.format("REACTIVE/%s", reactiveState.phase or reactiveState.mode or "LOCK")
                    or (commitment and string.format("LOCKED/%s/%.1fs",commitment.type,(now-(commitment.committedAt or now))/1000) or "unlocked")
                decisionLog("DECISION #%d: %s / %s severity=%s confidence=%.2f TCPA=%.1fs CPA=%.1fm required=%.1fm reservation=%s selected=%s worker=%s lock=%s simulation=%s",
                    decision.id,prediction.workerA.name,prediction.workerB.name,prediction.severity,
                    prediction.confidence or 0,prediction.tcpa or -1,prediction.cpa or -1,
                    prediction.requiredClearance or 0,reservationText,
                    displayedAction or "CONTINUE",selectedName,lockText,
                    tostring(self.settings and self.settings.simulationMode==true))
                decision.nextLogAt=now+2000
            end

            decision.lastSeverity=prediction.severity
            decision.lastAction=displayedAction
            decision.lastWorkerVehicle=displayedVehicle
            self:executePredictiveDecision(key, decision)
        end
    end

    -- A missing vector sample is not an immediate release. Require a continuous
    -- clear period so SAFE/CONFLICT jitter cannot pulse AI control on and off.
    for key,decision in pairs(self.decisions) do
        if not seen[key] then
            local action=self.predictiveActions[key]
            if action~=nil then
                action.clearCandidateAt=action.clearCandidateAt or now
                local clearFor=now-action.clearCandidateAt
                if clearFor >= (self.PREDICTIVE_CLEAR_CONFIRM_MS or 1500) then
                    self:clearPredictiveAction(key, "confirmed prediction clear")
                    decision.clearCandidateAt=now
                else
                    -- Maintain the committed action during the confirmation gap.
                    self:maintainPredictiveCommitment(key, decision, nil)
                end
            else
                decision.clearCandidateAt=decision.clearCandidateAt or now
            end

            if self.predictiveActions[key]==nil and now-(decision.updatedAt or now)>5000 then
                self.decisions[key]=nil
            end
        end
    end
end

function OuttaMyWay:getPrimaryDecision()
    local best=nil
    local rank={WATCH=1,CONFLICT=2,CRITICAL=3}
    for _,decision in pairs(self.decisions or {}) do
        if decision.prediction~=nil and decision.selected~=nil then
            if best==nil or (rank[decision.prediction.severity] or 0)>(rank[best.prediction.severity] or 0) then best=decision end
        end
    end
    return best
end