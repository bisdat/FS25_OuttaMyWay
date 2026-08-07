OuttaMyWay.FutureSpaceHud = {}
local Hud=OuttaMyWay.FutureSpaceHud
Hud.__index=Hud

local function gateLog(message)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][FUTURE-SPACE HUD] %s",message)
    else
        print("[FS25_OuttaMyWay][FUTURE-SPACE HUD] "..message)
    end
end

local function shortName(value)
    local text=tostring(value or "AI worker")
    if #text<=22 then return text end
    return string.sub(text,1,21).."…"
end

local function distanceText(value)
    if type(value)~="number" then return "unbounded" end
    return string.format("%.0fm",value)
end

local function workerLine(item)
    local intent=item.localIntent or {}
    local future=item.futureSpace or {}
    local state=intent.classification or "UNRESOLVED"
    if state=="SETTLED_CONTINUATION" then
        return string.format("%s: STRAIGHT → %s",shortName(item.name),distanceText(future.boundaryDistance))
    elseif state=="TURNING" then
        return string.format("%s: TURNING",shortName(item.name))
    end
    return string.format("%s: UNRESOLVED",shortName(item.name))
end

local function pairLine(pair)
    if pair==nil then return "Pair: waiting for two active workers" end
    local outcome=pair.futureSpaceOutcome
    if outcome=="FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION_POSITIVE" then return "Pair: FUTURE SPACES INTERSECT" end
    if outcome=="FUTURE_SPACE_INTERACTION_UNRESOLVED" then return "Pair: UNRESOLVED WHILE MANOEUVRING" end
    if outcome=="NO_POSITIVE_FUTURE_SPACE_INTERSECTION_OBSERVED" then return "Pair: no positive intersection yet" end
    return "Pair: Future Space unavailable"
end

function Hud.new()
    return setmetatable({lines={"OTM FUTURE SPACE","Waiting for active workers","","Pair: waiting"},lastSignature=nil},Hud)
end

function Hud:reset()
    self.lines={"OTM FUTURE SPACE","Waiting for active workers","","Pair: waiting"}
    self.lastSignature=nil
end

function Hud:observeRecord(record)
    local workers={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(record and record.assemblyDiagnostics or {}) do
        if item.activeJobVehicleMembership==true then workers[#workers+1]=item end
    end
    table.sort(workers,function(a,b) return tostring(a.assemblyReferenceKey)<tostring(b.assemblyReferenceKey) end)
    local pair=nil
    for _,item in OuttaMyWay.ValueRecord.ipairs(record and record.pairDiagnostics or {}) do
        if item.futureSpaceOutcome~=nil and item.eligible==true then pair=item; break end
    end
    local line2=workers[1] and workerLine(workers[1]) or "Waiting for active workers"
    local line3=workers[2] and workerLine(workers[2]) or ""
    local line4=pairLine(pair)
    self.lines={"OTM FUTURE SPACE",line2,line3,line4}
    local signature=table.concat(self.lines,"|")
    if signature~=self.lastSignature then
        self.lastSignature=signature
        gateLog(string.format("%s | %s | %s",line2,line3,line4))
    end
end

local function renderLine(x,y,size,text)
    if renderText==nil or text==nil or text=="" then return end
    if setTextAlignment~=nil then setTextAlignment((RenderText and RenderText.ALIGN_RIGHT) or 2) end
    if setTextColor~=nil then setTextColor(0,0,0,0.9) end
    renderText(x+0.0012,y-0.0012,size,text)
    if setTextColor~=nil then setTextColor(1,1,1,1) end
    renderText(x,y,size,text)
end

function Hud:draw()
    if OuttaMyWay.FUTURE_SPACE_HUD_ENABLED~=true or g_currentMission==nil or renderText==nil then return end
    local x=OuttaMyWay.TRANSITION_HUD_X or 0.985
    local y=OuttaMyWay.TRANSITION_HUD_Y or 0.720
    local lineHeight=OuttaMyWay.TRANSITION_HUD_LINE_HEIGHT or 0.022
    renderLine(x,y,OuttaMyWay.TRANSITION_HUD_TITLE_SIZE or 0.016,self.lines[1])
    renderLine(x,y-lineHeight,OuttaMyWay.TRANSITION_HUD_TEXT_SIZE or 0.014,self.lines[2])
    renderLine(x,y-lineHeight*2,OuttaMyWay.TRANSITION_HUD_TEXT_SIZE or 0.014,self.lines[3])
    renderLine(x,y-lineHeight*3,OuttaMyWay.TRANSITION_HUD_TEXT_SIZE or 0.014,self.lines[4])
    if setTextColor~=nil then setTextColor(1,1,1,1) end
end
