-- FS25_OuttaMyWay console controls.

local function parseBool(value, current)
    if value == nil or value == "" or value == "toggle" then return not current end
    value = string.lower(tostring(value))
    if value == "on" or value == "true" or value == "1" then return true end
    if value == "off" or value == "false" or value == "0" then return false end
    return nil
end

function OuttaMyWay:consoleStatus()
    local text = self:getSettingStatusText()
    print("[OuttaMyWay] " .. text)
    return text
end

function OuttaMyWay:consoleEnable(value)
    local enabled = parseBool(value, self.settings.enabled)
    if enabled == nil then return "Usage: otmEnable [on|off|toggle]" end
    self:setEnabled(enabled)
    return self:consoleStatus()
end

function OuttaMyWay:consoleSimulation(value)
    local enabled = parseBool(value, self.settings.simulationMode)
    if enabled == nil then return "Usage: otmSimulation [on|off|toggle]" end
    self.settings.simulationMode = enabled
    return self:consoleStatus()
end

function OuttaMyWay:consoleHud(value)
    local enabled = parseBool(value, self.settings.hud.enabled)
    if enabled == nil then return "Usage: otmHud [on|off|toggle]" end
    self.settings.hud.enabled = enabled
    return self:consoleStatus()
end

function OuttaMyWay:consoleHudMode(value)
    value = value and string.lower(tostring(value)) or "toggle"
    if value == "compact" then
        self.settings.hud.compact = true
        self.settings.developerMode = false
    elseif value == "full" or value == "developer" then
        self.settings.hud.compact = false
        self.settings.developerMode = true
    elseif value == "toggle" then
        local full = self.settings.developerMode == true
        self.settings.developerMode = not full
        self.settings.hud.compact = full
    else
        return "Usage: otmHudMode [compact|full|toggle]"
    end
    return self:consoleStatus()
end


function OuttaMyWay:consoleHudOpacity(value)
    local opacity = tonumber(value)
    if opacity == nil then
        return string.format("HUD opacity %.2f. Usage: otmHudOpacity 0.15..0.85", self.settings.hud.backgroundOpacity or 0.42)
    end
    self.settings.hud.backgroundOpacity = math.max(0.15, math.min(0.85, opacity))
    return string.format("OuttaMyWay HUD opacity set to %.2f", self.settings.hud.backgroundOpacity)
end

function OuttaMyWay:consoleWarnings(value)
    local enabled = parseBool(value, self.settings.warnings)
    if enabled == nil then return "Usage: otmWarnings [on|off|toggle]" end
    self.settings.warnings = enabled
    self.settings.hud.warnings = enabled
    return self:consoleStatus()
end

function OuttaMyWay:consoleDebug(channel, value)
    channel = channel or "all"
    local current = channel == "all" and self.settings.developerMode or self.settings.debug[channel]
    if current == nil then return "Unknown channel. Use: general vector geometry decisions reservations recovery all" end
    local enabled = parseBool(value, current)
    if enabled == nil then return "Usage: otmDebug <channel> [on|off|toggle]" end
    if channel == "all" then self.settings.developerMode = enabled end
    if not self:setDebugChannel(channel, enabled) then return "Unknown debug channel: " .. tostring(channel) end
    return self:consoleStatus()
end


function OuttaMyWay:consoleTS015Arm(side)
    local controller = self.UnilateralSidestepController
    if controller == nil or controller.arm == nil then return "TS015 controller unavailable" end
    if controller.enabled == nil and controller.init ~= nil then controller:init() end
    local _, message = controller:arm(side)
    print("[OuttaMyWay] " .. tostring(message))
    return message
end

function OuttaMyWay:consoleTS015Cancel()
    local controller = self.UnilateralSidestepController
    if controller == nil or controller.cancel == nil then return "TS015 controller unavailable" end
    if controller.enabled == nil and controller.init ~= nil then controller:init() end
    local _, message = controller:cancel()
    print("[OuttaMyWay] " .. tostring(message))
    return message
end

function OuttaMyWay:consoleTS015Status()
    local controller = self.UnilateralSidestepController
    local message = controller ~= nil and controller.statusText ~= nil and controller:statusText() or "TS015 controller unavailable"
    print("[OuttaMyWay] " .. tostring(message))
    return message
end

function OuttaMyWay:registerConsoleCommands()
    if addConsoleCommand == nil or self.consoleCommandsRegistered then return end
    addConsoleCommand("otmStatus", "Show OuttaMyWay settings and state", "consoleStatus", self)
    addConsoleCommand("otmEnable", "Enable/disable OuttaMyWay: otmEnable on|off", "consoleEnable", self)
    addConsoleCommand("otmSimulation", "Toggle observer-only predictive simulation", "consoleSimulation", self)
    addConsoleCommand("otmHud", "Toggle OuttaMyWay HUD", "consoleHud", self)
    addConsoleCommand("otmHudMode", "Switch HUD layout: compact|full|toggle", "consoleHudMode", self)
    addConsoleCommand("otmHudOpacity", "Set HUD background opacity: 0.15..0.85", "consoleHudOpacity", self)
    addConsoleCommand("otmWarnings", "Toggle OuttaMyWay warnings", "consoleWarnings", self)
    addConsoleCommand("otmDebug", "Toggle debug channel: otmDebug vector on", "consoleDebug", self)
    addConsoleCommand("otmTS015Arm", "Arm TS017-B facing-extent run using unchanged 28 m Condor sidestep: otmTS015Arm left|right", "consoleTS015Arm", self)
    addConsoleCommand("otmTS015Cancel", "Safely cancel TS015 and restore the worker", "consoleTS015Cancel", self)
    addConsoleCommand("otmTS015Status", "Show TS017-B actuator and facing-extent shadow state", "consoleTS015Status", self)
    self.consoleCommandsRegistered = true
end
