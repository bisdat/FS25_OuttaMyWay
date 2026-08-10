-- Diagnostic facade over Situation-owned Guarded Recovery Knowledge.
-- No runtime object, Candidate or Control authority is owned here.
OuttaMyWay.GuardedRecoveryConvergenceProbe={}
local Probe=OuttaMyWay.GuardedRecoveryConvergenceProbe
Probe.__index=Probe
function Probe.new(situationAssessment) return setmetatable({situationAssessment=situationAssessment},Probe) end
function Probe.evaluateGeometry(input) return OuttaMyWay.GuardedRecoveryThreatAssessment.evaluateGeometry(input) end
function Probe.evaluateCurrentHeadingSignal(sample) return OuttaMyWay.GuardedRecoveryThreatAssessment.evaluateCurrentHeadingSignal(sample) end
function Probe:reset() end
function Probe:loadMap() end
function Probe:deleteMap() end
function Probe:keyEvent() end
function Probe:mouseEvent() end
function Probe:draw() end
function Probe:update(dt) end
function Probe:getLatestSample()
    local values=self.situationAssessment and self.situationAssessment:getGuardedRecoveryKnowledge() or {}
    return values[#values]
end
function Probe:getStatus()
    local values=self.situationAssessment and self.situationAssessment:getGuardedRecoveryKnowledge() or {}
    local latest=values[#values]
    return {active=latest~=nil and latest.activeRecovery==true,nativeReacquired=latest and latest.nativeReacquired==true or false,signalStatus=latest and latest.signalStatus or "INACTIVE",sampleCount=#values}
end
