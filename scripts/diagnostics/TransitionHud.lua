OuttaMyWay.TransitionHud = {}
local Hud=OuttaMyWay.TransitionHud
Hud.__index=Hud

local PHASE={
    WAITING="WAITING_FOR_ENCOUNTER",
    ACTIVE="ENCOUNTER_ACTIVE",
    TERMINATED="ENCOUNTER_TERMINATED",
    RESTARTED="NEW_JOB_EPISODE",
    COMPLETE="TEST_COMPLETE"
}

local function gateLog(message)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][OTM TEST GATE] %s",message)
    else
        print("[FS25_OuttaMyWay][OTM TEST GATE] "..message)
    end
end

local function textFor(phase)
    if phase==PHASE.ACTIVE then return "OTM TEST — FUTURE SPACE ENCOUNTER","Stop either AI worker now" end
    if phase==PHASE.TERMINATED then return "OTM TEST — ENCOUNTER TERMINATED","Restart the stopped worker" end
    if phase==PHASE.RESTARTED then return "OTM TEST — NEW JOB EPISODE","Re-establish the head-on approach" end
    if phase==PHASE.COMPLETE then return "OTM TEST — NEW FUTURE SPACE ENCOUNTER","Test complete" end
    return "OTM TEST — WAITING FOR FUTURE SPACE","No action yet" 
end

function Hud.new()
    return setmetatable({
        phase=PHASE.WAITING,
        firstEncounterIdentity=nil,
        terminalEncounterIdentity=nil,
        newEpisodeObserved=false,
        lastGateSignature=nil
    },Hud)
end

function Hud:reset()
    self.phase=PHASE.WAITING
    self.firstEncounterIdentity=nil
    self.terminalEncounterIdentity=nil
    self.newEpisodeObserved=false
    self.lastGateSignature=nil
end

function Hud:_transition(phase,details)
    if self.phase==phase then return false end
    self.phase=phase
    local title,instruction=textFor(phase)
    local signature=phase.."|"..tostring(details or "")
    if self.lastGateSignature~=signature then
        self.lastGateSignature=signature
        gateLog(string.format("state=%s detail=%s message=%s | %s",phase,tostring(details or "n/a"),title,instruction))
    end
    return true
end

function Hud:observeEncounterTransition(transition)
    if transition==nil then return end
    local lifecycle=transition.lifecycle
    local identity=transition.encounterIdentity
    if lifecycle=="CREATED" then
        if self.phase==PHASE.WAITING then
            self.firstEncounterIdentity=identity
            self:_transition(PHASE.ACTIVE,"encounter="..tostring(identity).." relationship="..tostring(transition.relationship))
        elseif self.phase==PHASE.RESTARTED and identity~=self.firstEncounterIdentity then
            self:_transition(PHASE.COMPLETE,"encounter="..tostring(identity).." previous="..tostring(self.firstEncounterIdentity).." relationship="..tostring(transition.relationship))
        end
    elseif lifecycle=="TERMINATED" and self.firstEncounterIdentity~=nil and identity==self.firstEncounterIdentity then
        self.terminalEncounterIdentity=identity
        self:_transition(PHASE.TERMINATED,"encounter="..tostring(identity).." reason="..tostring(transition.terminalReason))
    end
end

function Hud:observeAdmittedEpisodes(admittedEpisodeIds)
    if self.phase~=PHASE.TERMINATED then return end
    local first=nil
    for _,episodeId in OuttaMyWay.ValueRecord.ipairs(admittedEpisodeIds or {}) do first=episodeId; break end
    if first~=nil then
        self.newEpisodeObserved=true
        self:_transition(PHASE.RESTARTED,"episode="..tostring(first))
    end
end

function Hud:getState()
    local title,instruction=textFor(self.phase)
    return {phase=self.phase,title=title,instruction=instruction,firstEncounterIdentity=self.firstEncounterIdentity,terminalEncounterIdentity=self.terminalEncounterIdentity,newEpisodeObserved=self.newEpisodeObserved}
end

local function renderLine(x,y,size,text,r,g,b,a)
    if renderText==nil then return end
    if setTextAlignment~=nil then setTextAlignment((RenderText and RenderText.ALIGN_RIGHT) or 2) end
    if setTextColor~=nil then setTextColor(0,0,0,0.9) end
    renderText(x+0.0012,y-0.0012,size,text)
    if setTextColor~=nil then setTextColor(r,g,b,a) end
    renderText(x,y,size,text)
end

function Hud:draw()
    if OuttaMyWay.LIFECYCLE_TEST_HUD_ENABLED~=true or g_currentMission==nil or renderText==nil then return end
    local title,instruction=textFor(self.phase)
    local x=OuttaMyWay.TRANSITION_HUD_X or 0.985
    local y=OuttaMyWay.TRANSITION_HUD_Y or 0.720
    renderLine(x,y,OuttaMyWay.TRANSITION_HUD_TITLE_SIZE or 0.016,title,1,1,1,1)
    renderLine(x,y-(OuttaMyWay.TRANSITION_HUD_LINE_HEIGHT or 0.022),OuttaMyWay.TRANSITION_HUD_TEXT_SIZE or 0.014,instruction,1,1,1,1)
    if setTextColor~=nil then setTextColor(1,1,1,1) end
end

Hud.PHASE=PHASE
