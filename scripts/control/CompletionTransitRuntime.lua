-- Completion-triggered TRANSIT only. No navigation, relocation or parking.
-- Specification Jurisdictions: `COMPLETION_TRANSIT`
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionTransitRuntime={}
local Runtime=OuttaMyWay.CompletionTransitRuntime
Runtime.__index=Runtime
local publication=OuttaMyWay.LogPublication.origin("COMPLETION_TRANSIT")

local function planSource()
    return {
        getTransitRequests=function(_,vehicle)
            -- Reuse the validated solo/static native command selection, but
            -- NEVER the live Hold & Relocate instance or its request state.
            local plan,reason=OuttaMyWay.HoldRelocatePhysicalControl.buildTransitPlan(vehicle,false)
            if plan==nil then error(reason or "TRANSIT_PLAN_UNAVAILABLE") end
            return plan
        end
    }
end

function Runtime.new(configuration)
    return setmetatable({
        configuration=configuration,
        transitMechanism=OuttaMyWay.NativeTransitRequestMechanism.new(planSource()),
        attempted=setmetatable({},{__mode="k"})
    },Runtime)
end

function Runtime:onNativeCompletion(job,vehicle)
    if g_server==nil or self.configuration==nil
        or self.configuration:isResolved()~=true
        or self.configuration:isEnabled()~=true then return end
    if type(vehicle)~="table" or vehicle.isDeleted==true or self.attempted[vehicle] then return end
    -- A newer AI job or intervening player action supersedes post-job Control.
    if type(vehicle.getCurrentAIJob)=="function" then
        local ok,current=pcall(vehicle.getCurrentAIJob,vehicle)
        if not ok or current~=nil then return end
    end
    self.attempted[vehicle]=true
    local accepted,reason=self.transitMechanism:requestTransit(vehicle)
    publication:publish("NORMAL",accepted and "INFO" or "WARNING",
        accepted and "COMPLETED_WORKER_TRANSIT_REQUESTED" or "COMPLETED_WORKER_TRANSIT_UNAVAILABLE",
        function()
            return {
                rootNode=vehicle.rootNode or "unavailable",
                jobId=job.jobId or "unavailable",
                reason=accepted and "REQUEST_ONLY_NOT_VERIFIED" or tostring(reason),
                version=OuttaMyWay.VERSION
            }
        end)
end

function Runtime:relinquish()
    -- Request-only commands are already handed to GIANTS. Do not issue
    -- WORKING restoration to a completed worker. Stop retaining authority.
    for vehicle in pairs(self.attempted) do
        self.transitMechanism:relinquishTransit(vehicle)
    end
    self.attempted=setmetatable({},{__mode="k"})
end

function Runtime:deleteMap()
    self:relinquish()
end
