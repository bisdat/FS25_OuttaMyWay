-- FS25_OuttaMyWay independent right-side HUD.
-- Uses direct screen rendering; never writes into the F1 help-text stack.

local function safeSetTextColor(r, g, b, a)
    if setTextColor ~= nil then setTextColor(r, g, b, a) end
end

local function safeSetTextAlignment(alignment)
    if setTextAlignment ~= nil then setTextAlignment(alignment) end
end

local function safeRenderText(x, y, size, text)
    if renderText ~= nil then renderText(x, y, size, tostring(text or "")) end
end

local function hudVehicleName(vehicle)
    if vehicle == nil then return "Unknown worker" end

    if vehicle.getName ~= nil then
        local ok, name = pcall(vehicle.getName, vehicle)
        if ok and name ~= nil and tostring(name) ~= "" then return tostring(name) end
    end

    if vehicle.getFullName ~= nil then
        local ok, name = pcall(vehicle.getFullName, vehicle)
        if ok and name ~= nil and tostring(name) ~= "" then return tostring(name) end
    end

    if vehicle.configFileName ~= nil then
        local name = tostring(vehicle.configFileName):match("([^/\\]+)%.xml$")
        if name ~= nil and name ~= "" then return name end
    end

    return "AI worker"
end

local function ensureHudBackground(self)
    if self.hudBackgroundOverlay ~= nil then return self.hudBackgroundOverlay end
    if Overlay == nil or Overlay.new == nil or self.modDirectory == nil then return nil end

    local ok, overlay = pcall(Overlay.new, self.modDirectory .. "gui/images/hudBackground.png", 0, 0, 0.1, 0.1)
    if ok and overlay ~= nil then
        self.hudBackgroundOverlay = overlay
        return overlay
    end
    return nil
end

local function renderHudLayer(self, x, y, width, height, r, g, b, a)
    local overlay = ensureHudBackground(self)
    if overlay == nil then return end
    if overlay.setPosition ~= nil then overlay:setPosition(x, y) end
    if overlay.setDimension ~= nil then overlay:setDimension(width, height) end
    if overlay.setColor ~= nil then overlay:setColor(r, g, b, a) end
    if overlay.render ~= nil then overlay:render() end
end

local function renderHudBackground(self, x, y, width, height)
    local opacity = 0.42
    if self.settings ~= nil and self.settings.hud ~= nil and self.settings.hud.backgroundOpacity ~= nil then
        opacity = math.max(0.15, math.min(0.85, self.settings.hud.backgroundOpacity))
    end
    -- A subtle outer rim and charcoal inner panel approximate GIANTS' Help box.
    local border = 0.0015
    renderHudLayer(self, x-border, y-border, width+border*2, height+border*2, 0.20, 0.20, 0.20, math.min(0.75, opacity+0.12))
    renderHudLayer(self, x, y, width, height, 0.035, 0.035, 0.035, opacity)
end

local function severityColour(severity)
    if severity == "CRITICAL" then return 1.0, 0.25, 0.20 end
    if severity == "CONFLICT" then return 1.0, 0.60, 0.15 end
    if severity == "WATCH" then return 1.0, 0.90, 0.20 end
    return 0.55, 1.0, 0.55
end

function OuttaMyWay:getHudWarningText()
    local now = g_time or 0
    if self.transientText ~= "" and now < (self.transientUntil or 0) then
        return self.transientText
    end

    if next(self.laneReservations or {}) ~= nil then
        for _, state in pairs(self.laneReservations) do
            if state.phase == "REVERSING" then
                return string.format("%s backing out - lane owned by %s", self:getVehicleDisplayName(state.vacater), self:getVehicleDisplayName(state.owner))
            elseif state.phase == "REENTERING" or state.phase == "REENTRY_COMPLETE" or state.phase == "PROTECTED_REENTRY" then
                return string.format("Protected priority: %s - %s held", self:getVehicleDisplayName(state.vacater), self:getVehicleDisplayName(state.owner))
            end
            return string.format("%s parked clear - %s owns lane", self:getVehicleDisplayName(state.vacater), self:getVehicleDisplayName(state.owner))
        end
    end

    if self.recoveryVehicle ~= nil then
        local state = self.recovery and self.recovery[self.recoveryVehicle] or nil
        if state ~= nil and state.phase == "ESCAPE" then
            return string.format("%s moving out of the lane", self:getVehicleDisplayName(self.recoveryVehicle))
        elseif state ~= nil then
            return string.format("%s parked clear - letting %s pass", self:getVehicleDisplayName(self.recoveryVehicle), self:getVehicleDisplayName(state.other))
        end
    end

    if (self.activeWaitCount or 0) > 0 then
        return string.format("%d AI waiting - right of way: %s", self.activeWaitCount, self.priorityName or "unknown")
    end
    return nil
end

function OuttaMyWay:getVehicleDisplayName(vehicle)
    if vehicle == nil then return "unknown" end
    if vehicle.getName ~= nil then
        local ok, name = pcall(vehicle.getName, vehicle)
        if ok and name ~= nil and name ~= "" then return name end
    end
    return vehicle.name or "vehicle"
end

function OuttaMyWay:drawHud()
    if self.settings == nil or self.settings.hud == nil or not self.settings.hud.enabled then return false end
    -- g_client may be nil in some single-player render contexts; the mission and
    -- render API are the reliable checks for whether HUD drawing is available.
    if g_currentMission == nil or renderText == nil then return false end

    if not self.hudFirstDrawLogged then
        self.hudFirstDrawLogged = true
        Logging.info("[%s] HUD draw callback active (mode=%s opacity=%.2f)", self.MOD_NAME,
            self.settings.developerMode and "full" or "compact",
            self.settings.hud.backgroundOpacity or 0.42)
    end

    local compact = self.settings.hud.compact == true and self.settings.developerMode ~= true
    local decision = self.getPrimaryDecision ~= nil and self:getPrimaryDecision() or nil
    local reservation = self.getPrimaryReservation ~= nil and self:getPrimaryReservation() or nil
    local status = self.settings.enabled and "ON" or "OFF"
    local mode = self.settings.simulationMode and "SIM" or "LIVE"

    local right = 0.985
    -- Leave room for the base-game weather/time panel and AI blocked notices.
    local top = 0.855
    local lineHeight = 0.019
    local textSize = 0.014
    local lines = {}
    local planningName = nil
    local planningRemaining = nil
    local strandedName = nil
    local now = g_time or 0
    for vehicle,state in pairs(self.aiRestartGrace or {}) do
        if state ~= nil and now < (state.untilTime or 0) then
            planningName = hudVehicleName(vehicle)
            planningRemaining = math.max(0, ((state.untilTime or now)-now)/1000)
            break
        end
    end
    for vehicle,_ in pairs(self.strandedWorkers or {}) do
        strandedName = hudVehicleName(vehicle)
        break
    end

    if compact then
        local suffix = ""
        if decision ~= nil then
            suffix = string.format(" | D#%d %s", decision.id or 0, decision.prediction and decision.prediction.severity or "SAFE")
            if reservation ~= nil then suffix = suffix .. string.format(" | R#%d", reservation.id or 0) end
        end
        table.insert(lines, string.format("OTM %s | %s | W:%d | Q:%d%s", status, mode, self.lastActiveCount or 0, self.activeWaitCount or 0, suffix))
        if planningName ~= nil then
            table.insert(lines, string.format("%s restarting fieldwork — AI planning %.0fs", planningName, planningRemaining or 0))
        elseif strandedName ~= nil then
            table.insert(lines, string.format("%s AI restart failed — parked folded", strandedName))
        end
    else
        table.insert(lines, string.format("OUTTA MY WAY  v%s", self.VERSION or "?"))
        table.insert(lines, string.format("Mod: %s    Mode: %s", status, mode))
        table.insert(lines, string.format("Workers: %d    Waiting: %d", self.lastActiveCount or 0, self.activeWaitCount or 0))
        if planningName ~= nil then
            table.insert(lines, string.format("%s restarting fieldwork — AI planning %.0fs", planningName, planningRemaining or 0))
        elseif strandedName ~= nil then
            table.insert(lines, string.format("%s AI restart failed — parked folded", strandedName))
        end
        if decision ~= nil then
            local p = decision.prediction or {}
            local selected = decision.selected or {}
            table.insert(lines, string.format("Decision #%d: %s", decision.id or 0, p.severity or "SAFE"))
            local workerName = selected.worker and selected.worker.name or "none"
            table.insert(lines, string.format("Action: %s %s", selected.action or "CONTINUE", workerName))
            if p.tcpa ~= nil and p.cpa ~= nil then
                table.insert(lines, string.format("TCPA %.1fs   CPA %.1fm", p.tcpa, p.cpa))
            end
        else
            table.insert(lines, "Decision: none")
        end
        if reservation ~= nil then
            local eta = reservation.prediction and reservation.prediction.tcpa or 0
            table.insert(lines, string.format("Reservation #%d: %s  ETA %.1fs", reservation.id or 0, reservation.state or "PROVISIONAL", eta))
        else
            table.insert(lines, "Reservation: none")
        end
    end

    local warning = nil
    if self.settings.hud.warnings and self.settings.warnings then
        warning = self:getHudWarningText()
    end

    local panelWidth = compact and 0.255 or 0.285
    local panelPaddingX = 0.010
    local panelPaddingY = 0.010
    local warningRows = warning ~= nil and 1 or 0
    local panelHeight = (#lines * lineHeight) + (warningRows * lineHeight) + panelPaddingY * 2
    if warning ~= nil then panelHeight = panelHeight + 0.010 end
    local panelLeft = right - panelWidth
    local panelBottom = top - panelHeight + textSize + panelPaddingY
    renderHudBackground(self, panelLeft, panelBottom, panelWidth, panelHeight)

    safeSetTextAlignment((RenderText and RenderText.ALIGN_RIGHT) or 2)
    for index, line in ipairs(lines) do
        local y = top - ((index - 1) * lineHeight)
        if index == 1 then safeSetTextColor(0.85, 0.95, 1.0, 1.0)
        elseif decision ~= nil and string.find(line, "Decision #", 1, true) ~= nil then
            local r, g, b = severityColour(decision.prediction and decision.prediction.severity)
            safeSetTextColor(r, g, b, 1.0)
        else safeSetTextColor(1.0, 1.0, 1.0, 0.95) end
        safeRenderText(right, y, textSize, line)
    end

    if warning ~= nil then
        local warningY = top - (#lines * lineHeight) - 0.010
        safeSetTextColor(1.0, 0.75, 0.20, 1.0)
        safeRenderText(right, warningY, textSize, "WARNING: " .. warning)
    end

    safeSetTextColor(1.0, 1.0, 1.0, 1.0)
    safeSetTextAlignment((RenderText and RenderText.ALIGN_LEFT) or 0)
    return true
end
