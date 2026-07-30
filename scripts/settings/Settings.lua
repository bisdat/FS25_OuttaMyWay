-- FS25_OuttaMyWay settings foundation.
-- Runtime-adjustable settings are centralised here for future GUI persistence.

OuttaMyWay.settings = OuttaMyWay.settings or {
    enabled = true,
    simulationMode = false,
    developerMode = true,
    warnings = true,
    maxRecommendedWorkers = OuttaMyWay.MAX_RECOMMENDED_WORKERS_PER_FIELD or 4,
    hud = {
        enabled = true,
        compact = true,
        warnings = true,
        backgroundOpacity = 0.42
    },
    debug = {
        general = true,
        vector = true,
        geometry = true,
        decisions = true,
        reservations = true,
        recovery = true
    }
}

local function boolText(value)
    return value and "ON" or "OFF"
end

function OuttaMyWay:getSettingStatusText()
    local s = self.settings
    return string.format("enabled=%s simulation=%s HUD=%s warnings=%s developer=%s debug(vector=%s geometry=%s decisions=%s reservations=%s recovery=%s)",
        boolText(s.enabled), boolText(s.simulationMode), boolText(s.hud.enabled),
        boolText(s.warnings), boolText(s.developerMode), boolText(s.debug.vector),
        boolText(s.debug.geometry), boolText(s.debug.decisions), boolText(s.debug.reservations), boolText(s.debug.recovery))
end

function OuttaMyWay:setEnabled(enabled)
    self.settings.enabled = enabled == true
    if not self.settings.enabled then
        local releases = {}
        for vehicle in pairs(self.waiting or {}) do table.insert(releases, vehicle) end
        for _, vehicle in ipairs(releases) do
            if self.release ~= nil then self:release(vehicle, "mod disabled") end
        end
    end
    Logging.info("[%s] Mod %s", self.MOD_NAME, boolText(self.settings.enabled))
end

function OuttaMyWay:setDebugChannel(channel, enabled)
    if channel == "all" then
        for key in pairs(self.settings.debug) do self.settings.debug[key] = enabled end
        return true
    end
    if self.settings.debug[channel] == nil then return false end
    self.settings.debug[channel] = enabled
    return true
end

function OuttaMyWay:isDebugEnabled(channel)
    return self.settings ~= nil
        and self.settings.developerMode == true
        and self.settings.debug ~= nil
        and self.settings.debug[channel] == true
end
