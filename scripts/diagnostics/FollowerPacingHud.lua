OuttaMyWay.FollowerPacingHud={}
local Hud=OuttaMyWay.FollowerPacingHud
Hud.__index=Hud

function Hud.new(activeSource,shadowSource)
    return setmetatable({activeSource=activeSource,shadowSource=shadowSource},Hud)
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
    if OuttaMyWay.FOLLOWER_PACING_HUD_ENABLED~=true or g_currentMission==nil or renderText==nil then return end
    local lines={}
    local active=self.activeSource and self.activeSource.getFollowerBoundaryStatus and self.activeSource:getFollowerBoundaryStatus() or nil
    if type(active)=="table" and active.active==true then
        lines[#lines+1]=string.format("Follower regulation ALIGNED%s • %s for %s • cap %s / native %s km/h",
            active.transitionPreservation==true and " TRANSITION" or "",
            tostring(active.followerName or "Follower"),tostring(active.leaderName or "leader"),numberText(active.currentCapKmh),numberText(active.nativeUnrestrictedFollowerKmh))
    else
        local records=self.shadowSource and self.shadowSource.getActivePacingRecords and self.shadowSource:getActivePacingRecords() or {}
        for i=1,#records do
            local record=records[i]
            lines[#lines+1]=string.format("%s — legacy follower SHADOW for %s • would-cap %s km/h • no Control",
                tostring(record.followerName or "Follower"),tostring(record.leaderName or "leader"),numberText(record.hypotheticalCapKmh))
        end
    end
    if #lines==0 then return end
    local x=OuttaMyWay.FOLLOWER_PACING_HUD_X or 0.985
    local y=OuttaMyWay.FOLLOWER_PACING_HUD_Y or 0.697
    local size=OuttaMyWay.FOLLOWER_PACING_HUD_TEXT_SIZE or 0.013
    local maxRows=OuttaMyWay.FOLLOWER_PACING_HUD_MAX_ROWS or 3
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
