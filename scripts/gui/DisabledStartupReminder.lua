--- Presents the bounded Product Status reminder when a mission starts with OuttaMyWay disabled.
-- Specification Jurisdictions: `CONFIGURATION`

OuttaMyWay.DisabledStartupReminder={}
local Reminder=OuttaMyWay.DisabledStartupReminder
Reminder.__index=Reminder

local TEXT_KEY="omw_disabledStartupReminder"
local WARNING_DURATION_MS=2000

function Reminder.new(configuration)
    return setmetatable({
        configuration=configuration,
        isPending=false,
        hasShown=false
    },Reminder)
end

function Reminder:loadMap()
    self.isPending=false
    self.hasShown=false

    local configuration=self.configuration
    if configuration==nil or type(configuration.isResolved)~="function"
        or configuration:isResolved()~=true then
        return
    end

    self.isPending=configuration:isEnabled()==false
end

function Reminder:deleteMap()
    self.isPending=false
    self.hasShown=false
end

function Reminder:update()
    if self.isPending~=true or self.hasShown==true then return end

    local configuration=self.configuration
    if configuration==nil or type(configuration.isEnabled)~="function"
        or configuration:isEnabled()~=false then
        self.isPending=false
        return
    end

    if g_currentMission==nil or type(g_currentMission.showBlinkingWarning)~="function"
        or g_i18n==nil or type(g_i18n.getText)~="function" then
        return
    end

    local textOk,message=pcall(g_i18n.getText,g_i18n,TEXT_KEY)
    if not textOk or type(message)~="string" or message=="" then return end

    local shown=pcall(
        g_currentMission.showBlinkingWarning,
        g_currentMission,
        message,
        WARNING_DURATION_MS)
    if shown then
        self.hasShown=true
        self.isPending=false
    end
end
