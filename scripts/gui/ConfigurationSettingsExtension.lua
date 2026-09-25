--- Extends the existing GIANTS General Settings frame with supported OuttaMyWay Configuration.
-- Specification Jurisdictions: `CONFIGURATION`

OuttaMyWay.ConfigurationSettingsExtension={}
local Extension=OuttaMyWay.ConfigurationSettingsExtension

local publication=OuttaMyWay.LogPublication.origin("CONFIGURATION")
local INITIALIZED_FLAG="outtaMyWayConfigurationInitialized"

local function localised(key)
    if g_i18n~=nil and type(g_i18n.getText)=="function" then
        local ok,value=pcall(g_i18n.getText,g_i18n,key)
        if ok and type(value)=="string" and value~="" then return value end
    end
    return key
end

local function addSectionHeader(layout)
    local header=TextElement.new()
    header.name="sectionHeader"
    header:loadProfile(g_gui:getProfile("fs25_settingsSectionHeader"),true)
    header:setText(localised("omw_configSection_title"))
    layout:addElement(header)
    header:onGuiSetupFinished()
    return header
end

local function addBinaryOption(layout,callbackName,titleKey,tooltipKey)
    local container=BitmapElement.new()
    container:loadProfile(g_gui:getProfile("fs25_multiTextOptionContainer"),true)

    local option=BinaryOptionElement.new()
    option:loadProfile(g_gui:getProfile("fs25_settingsBinaryOption"),true)
    option.useYesNoTexts=false
    option.target=Extension
    option:setCallback("onClickCallback",callbackName)

    local title=TextElement.new()
    title:loadProfile(g_gui:getProfile("fs25_settingsMultiTextOptionTitle"),true)
    title:setText(localised(titleKey))

    local tooltip=TextElement.new()
    tooltip.name="ignore"
    tooltip:loadProfile(g_gui:getProfile("fs25_multiTextOptionTooltip"),true)
    tooltip:setText(localised(tooltipKey))

    option:addElement(tooltip)
    container:addElement(option)
    container:addElement(title)

    option:onGuiSetupFinished()
    title:onGuiSetupFinished()
    tooltip:onGuiSetupFinished()

    layout:addElement(container)
    container:onGuiSetupFinished()
    return option
end

local function configuration()
    return OuttaMyWay.configuration
end

function Extension:syncFrame(frame)
    if frame==nil or frame[INITIALIZED_FLAG]~=true then return end
    local current=configuration()
    local resolved=current~=nil and type(current.isResolved)=="function" and current:isResolved()==true

    if frame.outtaMyWayEnabledOption~=nil then
        frame.outtaMyWayEnabledOption:setDisabled(not resolved)
        if resolved then frame.outtaMyWayEnabledOption:setIsChecked(current:isEnabled(),true,false) end
    end
    if frame.outtaMyWayOperationalMessagesOption~=nil then
        frame.outtaMyWayOperationalMessagesOption:setDisabled(not resolved)
        if resolved then frame.outtaMyWayOperationalMessagesOption:setIsChecked(current:isHudVisible(),true,false) end
    end
    if frame.outtaMyWayDebugOption~=nil then
        frame.outtaMyWayDebugOption:setDisabled(not resolved)
        if resolved then frame.outtaMyWayDebugOption:setIsChecked(current:isDebugEnabled(),true,false) end
    end
end

function Extension:_showPersistenceWarning(settingName,reason)
    publication:warning("NORMAL","CONFIGURATION_CHANGE_PERSISTENCE_FAILED","setting=%s reason=%s",
        tostring(settingName),tostring(reason))
    if g_currentMission~=nil and type(g_currentMission.showBlinkingWarning)=="function" then
        pcall(g_currentMission.showBlinkingWarning,g_currentMission,localised("omw_configSection_saveFailed"))
    end
end

function Extension:_apply(settingName,value)
    local current=configuration()
    if current==nil then return end

    local ok,reason=false,"CONFIGURATION_SETTER_UNAVAILABLE"
    if settingName=="enabled" and type(current.setEnabled)=="function" then
        ok,reason=current:setEnabled(value)
    elseif settingName=="hudVisible" and type(current.setHudVisible)=="function" then
        ok,reason=current:setHudVisible(value)
    elseif settingName=="debug" and type(current.setDebugEnabled)=="function" then
        ok,reason=current:setDebugEnabled(value)
    end

    if g_inGameMenu~=nil and g_inGameMenu.pageSettings~=nil then
        self:syncFrame(g_inGameMenu.pageSettings)
    end
    if ok~=true and reason~="UNCHANGED" then self:_showPersistenceWarning(settingName,reason) end
end

function Extension:onEnabledChanged(state)
    self:_apply("enabled",state==BinaryOptionElement.STATE_RIGHT)
end

function Extension:onOperationalMessagesChanged(state)
    self:_apply("hudVisible",state==BinaryOptionElement.STATE_RIGHT)
end

function Extension:onDebugChanged(state)
    self:_apply("debug",state==BinaryOptionElement.STATE_RIGHT)
end

function Extension:onFrameOpen(frame)
    if frame==nil then return end

    if frame[INITIALIZED_FLAG]~=true then
        local layout=frame.generalSettingsLayout
        if layout==nil or g_gui==nil or type(g_gui.getProfile)~="function" then
            publication:warning("NORMAL","CONFIGURATION_SECTION_UNAVAILABLE","reason=GENERAL_SETTINGS_LAYOUT_UNAVAILABLE")
            return
        end

        frame.outtaMyWayConfigurationHeader=addSectionHeader(layout)
        frame.outtaMyWayEnabledOption=addBinaryOption(
            layout,"onEnabledChanged","omw_configSection_enabled","omw_configSection_enabledTooltip")
        frame.outtaMyWayOperationalMessagesOption=addBinaryOption(
            layout,"onOperationalMessagesChanged","omw_configSection_operationalMessages",
            "omw_configSection_operationalMessagesTooltip")
        frame.outtaMyWayDebugOption=addBinaryOption(
            layout,"onDebugChanged","omw_configSection_debug","omw_configSection_debugTooltip")

        frame[INITIALIZED_FLAG]=true
        layout:invalidateLayout()
        if type(frame.updateAlternatingElements)=="function" then frame:updateAlternatingElements(layout) end
    end

    self:syncFrame(frame)
end

function Extension:updateGeneralSettings(frame)
    self:syncFrame(frame)
end

local function install()
    if InGameMenuSettingsFrame==nil or Utils==nil or type(Utils.appendedFunction)~="function" then
        publication:warning("NORMAL","CONFIGURATION_SECTION_UNAVAILABLE","reason=SETTINGS_FRAME_HOOK_UNAVAILABLE")
        return
    end

    InGameMenuSettingsFrame.onFrameOpen=Utils.appendedFunction(
        InGameMenuSettingsFrame.onFrameOpen,
        function(frame) Extension:onFrameOpen(frame) end)

    InGameMenuSettingsFrame.updateGeneralSettings=Utils.appendedFunction(
        InGameMenuSettingsFrame.updateGeneralSettings,
        function(frame) Extension:updateGeneralSettings(frame) end)
end

install()
