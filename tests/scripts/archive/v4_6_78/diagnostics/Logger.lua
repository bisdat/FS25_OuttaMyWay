-- FS25_OuttaMyWay v4.2.6.3
-- Architectural diagnostics framework. Categories mirror handbook responsibilities.
OuttaMyWay.Logger = OuttaMyWay.Logger or {}
local Logger = OuttaMyWay.Logger

Logger.LEVELS = { INFO=1, REC=1, DEC=2, VAL=2, OBS=3, CTL=3, PERF=4 }
Logger.lastByKey = Logger.lastByKey or {}

local function safeFormat(text, ...)
    if select("#", ...) == 0 then return tostring(text) end
    local ok, value = pcall(string.format, tostring(text), ...)
    return ok and value or (tostring(text) .. " [format-error: " .. tostring(value) .. "]")
end

function Logger:isEnabled(category)
    local required = self.LEVELS[category] or 1
    return (tonumber(OuttaMyWay.DEBUG_LEVEL) or 0) >= required
end

function Logger:write(category, text, ...)
    if not self:isEnabled(category) then return end
    Logging.info("[OuttaMyWay][%s] %s", tostring(category), safeFormat(text, ...))
end

function Logger:warning(category, text, ...)
    category = category or "REC"
    if category ~= "REC" and not self:isEnabled(category) then return end
    Logging.warning("[OuttaMyWay][%s] %s", tostring(category), safeFormat(text, ...))
end

function Logger:error(category, text, ...)
    Logging.error("[OuttaMyWay][%s] %s", tostring(category or "INFO"), safeFormat(text, ...))
end

function Logger:rateLimited(key, intervalMs, category, text, ...)
    local now = g_time or 0
    local previous = self.lastByKey[key]
    if previous ~= nil and now - previous < (intervalMs or 1000) then return end
    self.lastByKey[key] = now
    self:write(category, text, ...)
end

for _, category in ipairs({"INFO","OBS","DEC","CTL","VAL","REC","PERF"}) do
    local lower = string.lower(category)
    Logger[lower] = function(self, text, ...)
        self:write(category, text, ...)
    end
end
