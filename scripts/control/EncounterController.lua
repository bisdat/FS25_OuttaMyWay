-- FS25_OuttaMyWay authoritative encounter controller.
-- One pair-level authority translates the existing proven lane/backout state
-- machine into unambiguous GO, WAIT and DIRECT_CONTROL commands.

local function encounterLog(text, ...)
    if OuttaMyWay.isDebugEnabled ~= nil and not OuttaMyWay:isDebugEnabled("recovery") then return end
    Logging.info("[%s] %s", OuttaMyWay.MOD_NAME, string.format(text, ...))
end

local function vehicleName(vehicle)
    if vehicle == nil then return "unknown" end
    if vehicle.getName ~= nil then
        local ok, name = pcall(vehicle.getName, vehicle)
        if ok and name ~= nil and name ~= "" then return name end
    end
    return tostring(vehicle)
end

local function commandFor(state, vehicle)
    if state == nil or vehicle == nil then return nil end
    local phase = state.phase or "UNKNOWN"
    if vehicle == state.vacater then
        if phase == "REVERSING" or phase == "REENTERING" then return "DIRECT_CONTROL" end
        if phase == "REENTRY_COMPLETE" or phase == "PROTECTED_REENTRY" then return "GO" end
        return "WAIT"
    elseif vehicle == state.owner then
        if phase == "REENTRY_COMPLETE" or phase == "PROTECTED_REENTRY" then return "WAIT" end
        -- While the vacater reverses, the owner's protected-gap controller may
        -- temporarily ask it to wait. Return CONDITIONAL so Runtime preserves
        -- that distance-based decision instead of forcing either state.
        if phase == "REVERSING" then return "CONDITIONAL" end
        return "GO"
    end
    return nil
end

function OuttaMyWay:initialiseEncounterController()
    self.encounters = self.encounters or {}
    self.encounterByVehicle = self.encounterByVehicle or {}
    self.nextEncounterId = self.nextEncounterId or 1
end

function OuttaMyWay:syncEncounterController()
    self:initialiseEncounterController()
    local seen = {}
    self.encounterByVehicle = {}

    for key, state in pairs(self.laneReservations or {}) do
        if state ~= nil and state.owner ~= nil and state.vacater ~= nil then
            seen[key] = true
            local encounter = self.encounters[key]
            if encounter == nil then
                encounter = {
                    id = self.nextEncounterId,
                    key = key,
                    createdAt = g_time or 0,
                    lastPhase = nil
                }
                self.nextEncounterId = self.nextEncounterId + 1
                self.encounters[key] = encounter
                encounterLog("ENCOUNTER #%d CREATED: owner=%s yielding=%s mode=%s",
                    encounter.id, vehicleName(state.owner), vehicleName(state.vacater), tostring(state.mode))
            end
            encounter.owner = state.owner
            encounter.yielding = state.vacater
            encounter.mode = state.mode
            encounter.phase = state.phase
            encounter.state = state
            encounter.updatedAt = g_time or 0
            self.encounterByVehicle[state.owner] = encounter
            self.encounterByVehicle[state.vacater] = encounter

            if encounter.lastPhase ~= encounter.phase then
                if encounter.phase == "REENTRY_COMPLETE" or encounter.phase == "PROTECTED_REENTRY" then
                    encounterLog("ENCOUNTER #%d PHASE: %s -> %s (protected priority=%s held=%s; original lane owner=%s)",
                        encounter.id, tostring(encounter.lastPhase or "DETECT"), tostring(encounter.phase),
                        vehicleName(encounter.yielding), vehicleName(encounter.owner), vehicleName(encounter.owner))
                else
                    encounterLog("ENCOUNTER #%d PHASE: %s -> %s (lane owner=%s yielding=%s)",
                        encounter.id, tostring(encounter.lastPhase or "DETECT"), tostring(encounter.phase),
                        vehicleName(encounter.owner), vehicleName(encounter.yielding))
                end
                encounter.lastPhase = encounter.phase
            end
        end
    end

    for key, encounter in pairs(self.encounters) do
        if not seen[key] then
            if encounter.lastPhase == "REENTRY_COMPLETE" or encounter.lastPhase == "PROTECTED_REENTRY" then
                encounterLog("ENCOUNTER #%d COMPLETE: protected priority=%s held=%s; original lane owner=%s",
                    encounter.id or 0, vehicleName(encounter.yielding), vehicleName(encounter.owner), vehicleName(encounter.owner))
            else
                encounterLog("ENCOUNTER #%d COMPLETE: owner=%s yielding=%s",
                    encounter.id or 0, vehicleName(encounter.owner), vehicleName(encounter.yielding))
            end
            self.recentEncounterPairs = self.recentEncounterPairs or {}
            self.recentEncounterPairs[key] = (g_time or 0) + (self.PASSAGE_ASSIST_WINDOW_MS or 20000)

            -- A worker may already be waiting when the primary encounter ends.
            -- In that case no fresh setWaiting() call occurs, so passage assist
            -- must be started directly from this handoff rather than waiting for
            -- another yield event.
            local waitingWorker = nil
            local priorityWorker = nil
            if self.waiting ~= nil and self.waiting[encounter.yielding] ~= nil then
                waitingWorker = encounter.yielding
                priorityWorker = encounter.owner
            elseif self.waiting ~= nil and self.waiting[encounter.owner] ~= nil then
                waitingWorker = encounter.owner
                priorityWorker = encounter.yielding
            end

            if waitingWorker ~= nil and priorityWorker ~= nil and self.startPassageAssist ~= nil then
                local started = self:startPassageAssist(waitingWorker, priorityWorker)
                encounterLog("ENCOUNTER #%d PASSAGE ASSIST HANDOFF: waiting=%s priority=%s result=%s",
                    encounter.id or 0, vehicleName(waitingWorker), vehicleName(priorityWorker), started and "STARTED" or "NOT ELIGIBLE")
            else
                encounterLog("ENCOUNTER #%d PASSAGE ASSIST HANDOFF: no worker remained waiting", encounter.id or 0)
            end

            self.encounters[key] = nil
        end
    end
end

function OuttaMyWay:getEncounterForVehicle(vehicle)
    self:initialiseEncounterController()
    return self.encounterByVehicle[vehicle]
end

function OuttaMyWay:getEncounterForPair(vehicleA, vehicleB)
    if vehicleA == nil or vehicleB == nil then return nil end
    local encounter = self:getEncounterForVehicle(vehicleA)
    if encounter ~= nil and (encounter.owner == vehicleB or encounter.yielding == vehicleB) then return encounter end
    return nil
end

function OuttaMyWay:getEncounterCommand(vehicle)
    local encounter = self:getEncounterForVehicle(vehicle)
    if encounter == nil then return nil, nil end
    return commandFor(encounter.state, vehicle), encounter
end

function OuttaMyWay:applyEncounterAuthority(shouldWait)
    self:syncEncounterController()
    for _, encounter in pairs(self.encounters or {}) do
        local owner = encounter.owner
        local yielding = encounter.yielding
        local ownerCommand = commandFor(encounter.state, owner)
        local yieldingCommand = commandFor(encounter.state, yielding)

        if ownerCommand == "GO" then
            shouldWait[owner] = nil
            if self.waiting ~= nil and self.waiting[owner] ~= nil then
                self:release(owner, string.format("encounter #%d right of way", encounter.id or 0))
            end
        elseif ownerCommand == "WAIT" then
            shouldWait[owner] = yielding
        end

        if yieldingCommand == "GO" then
            shouldWait[yielding] = nil
            if self.waiting ~= nil and self.waiting[yielding] ~= nil then
                self:release(yielding, string.format("encounter #%d protected movement", encounter.id or 0))
            end
        elseif yieldingCommand == "WAIT" then
            shouldWait[yielding] = owner
        elseif yieldingCommand == "DIRECT_CONTROL" then
            shouldWait[yielding] = nil
            -- A stale ordinary wait prevents the dedicated reverse/re-entry
            -- drive hook from moving the machine.
            if self.waiting ~= nil and self.waiting[yielding] ~= nil then
                self:release(yielding, string.format("encounter #%d direct control", encounter.id or 0))
            end
        end
    end
end

function OuttaMyWay:clearEncounterController()
    self.encounters = {}
    self.encounterByVehicle = {}
    self.nextEncounterId = 1
end
