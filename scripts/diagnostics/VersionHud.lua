OuttaMyWay.VersionHud={}
local Hud=OuttaMyWay.VersionHud
Hud.__index=Hud
function Hud.new() return setmetatable({},Hud) end
function Hud:loadMap() end
function Hud:deleteMap() end
function Hud:update() end
function Hud:keyEvent() end
function Hud:mouseEvent() end
function Hud:draw()
    if OuttaMyWay.VERSION_HUD_ENABLED~=true or g_currentMission==nil or renderText==nil then return end
    local x=OuttaMyWay.VERSION_HUD_X or 0.985; local y=OuttaMyWay.VERSION_HUD_Y or 0.720; local size=OuttaMyWay.VERSION_HUD_TEXT_SIZE or 0.014
    local text=string.format("OuttaMyWay %s • %s",tostring(OuttaMyWay.VERSION or "?"),tostring(OuttaMyWay.BUILD_LABEL or "BUILD"))
    if setTextAlignment~=nil then setTextAlignment((RenderText and RenderText.ALIGN_RIGHT) or 2) end
    if setTextColor~=nil then setTextColor(0,0,0,0.85) end
    renderText(x+0.001,y-0.001,size,text)
    if setTextColor~=nil then setTextColor(1,1,1,0.95) end
    renderText(x,y,size,text)
    if setTextColor~=nil then setTextColor(1,1,1,1) end
end
