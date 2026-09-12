OuttaMyWay.VersionHud={}
local Hud=OuttaMyWay.VersionHud
Hud.__index=Hud

-- Diagnostic implementation values owned by this instrument, not player Configuration.
local VERSION_HUD_ENABLED=true
local VERSION_HUD_X=0.985
local VERSION_HUD_Y=0.720
local VERSION_HUD_TEXT_SIZE=0.014

function Hud.new() return setmetatable({},Hud) end
function Hud:loadMap() end
function Hud:deleteMap() end
function Hud:update() end
function Hud:keyEvent() end
function Hud:mouseEvent() end
function Hud:draw()
    if VERSION_HUD_ENABLED~=true or g_currentMission==nil or renderText==nil then return end
    local x=VERSION_HUD_X; local y=VERSION_HUD_Y; local size=VERSION_HUD_TEXT_SIZE
    local text=string.format("OuttaMyWay %s",tostring(OuttaMyWay.VERSION or "?"))
    if setTextAlignment~=nil then setTextAlignment((RenderText and RenderText.ALIGN_RIGHT) or 2) end
    if setTextColor~=nil then setTextColor(0,0,0,0.85) end
    renderText(x+0.001,y-0.001,size,text)
    if setTextColor~=nil then setTextColor(1,1,1,0.95) end
    renderText(x,y,size,text)
    if setTextColor~=nil then setTextColor(1,1,1,1) end
end
