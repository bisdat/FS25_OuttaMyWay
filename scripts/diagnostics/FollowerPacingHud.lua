OuttaMyWay.FollowerPacingHud={}
local Hud=OuttaMyWay.FollowerPacingHud
Hud.__index=Hud

-- Diagnostic implementation values owned by this instrument, not player Configuration.
local FOLLOWER_PACING_HUD_ENABLED=true
local FOLLOWER_PACING_HUD_X=0.985
local FOLLOWER_PACING_HUD_Y=0.697
local FOLLOWER_PACING_HUD_TEXT_SIZE=0.013
local FOLLOWER_PACING_HUD_MAX_ROWS=3


function Hud.new(activeSource)
    return setmetatable({activeSource=activeSource},Hud)
end
function Hud:loadMap() end
function Hud:deleteMap() end
function Hud:update() end
function Hud:keyEvent() end
function Hud:mouseEvent() end

local function numberText(v)
    if type(v)~="number" then return "n/a" end
    return string.format("%.1f",v)
end

function Hud:draw()
    if FOLLOWER_PACING_HUD_ENABLED~=true or g_currentMission==nil or renderText==nil then return end
    local lines={}
    local active=self.activeSource and self.activeSource.getFollowerBoundaryStatus and self.activeSource:getFollowerBoundaryStatus() or nil
    if type(active)=="table" and active.active==true then
        lines[#lines+1]=string.format("Follower regulation ALIGNED%s | %s for %s | cap %s / native %s km/h",
            active.transitionPreservation==true and " TRANSITION" or "",
            tostring(active.followerName or "Follower"),tostring(active.leaderName or "leader"),numberText(active.currentCapKmh),numberText(active.nativeUnrestrictedFollowerKmh))
    end
    if #lines==0 then return end
    local x=FOLLOWER_PACING_HUD_X
    local y=FOLLOWER_PACING_HUD_Y
    local size=FOLLOWER_PACING_HUD_TEXT_SIZE
    local maxRows=FOLLOWER_PACING_HUD_MAX_ROWS
    if setTextAlignment~=nil then setTextAlignment((RenderText and RenderText.ALIGN_RIGHT) or 2) end
    for i=1,math.min(#lines,maxRows) do
        local line=lines[i]
        local yy=y-(i-1)*(size*1.35)
        if setTextColor~=nil then setTextColor(0,0,0,0.85) end
        renderText(x+0.001,yy-0.001,size,line)
        if setTextColor~=nil then setTextColor(1,1,1,0.95) end
        renderText(x,yy,size,line)
    end
    if setTextColor~=nil then setTextColor(1,1,1,1) end
end
