OuttaMyWay={}
OuttaMyWay.ValueRecord={ipairs=ipairs}

dofile("scripts/assessment/CurrentResponsibilityAssessment.lua")
dofile("scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua")

local function expect(condition,message)
    if not condition then error(message or "expectation failed",2) end
end

local function projection(id,a8,turning)
    return {assemblyId=id,a8ProductivePositive=a8==true,turningPositive=turning==true}
end

local function relation(values)
    values=values or {}
    return {
        identity="forward-intersection:OP-1:AS-CONDOR:AS-PATRIOT",
        relationshipStatus=values.relationshipStatus or "POSITIVE",
        classification=values.classification or "FORWARD_INTERSECTION",
        spatialOverlay=values.spatialOverlay,
        actionable=values.actionable~=false,
        temporalYielderAssemblyId=values.temporalYielderAssemblyId or "AS-PATRIOT",
        continuingAssemblyId=values.continuingAssemblyId or "AS-CONDOR",
        subjectProjection=values.subjectProjection or projection("AS-CONDOR",values.condorA8,values.condorTurning),
        otherProjection=values.otherProjection or projection("AS-PATRIOT",values.patriotA8,values.patriotTurning),
        reason=values.reason
    }
end

local current={identity="RS-1",provenance={admissionKind="FORWARD_INTERSECTION"}}
local bridge={conflictIdentity="forward-intersection:OP-1:AS-CONDOR:AS-PATRIOT",regulatedAssemblyId="AS-PATRIOT",protectedAssemblyId="AS-CONDOR"}
local assessment=OuttaMyWay.CurrentResponsibilityAssessment.new()

-- Admission while the protected worker is productively approaching records the
-- current A8 phase but does not itself activate evacuation protection.
local admitted=relation({spatialOverlay="CATEGORY_1_CORNER",condorA8=true})
assessment:registerActionSpaceRegulation(current,admitted,bridge)
expect(assessment:isCategory1EvacuationProtectionActive(current)==false,"Category-1 approach must remain prospective before TURNING")

-- A8 -> TURNING while the same Category-1 allocation is current establishes
-- Protected Manoeuvre Entry and persists the incumbent roles.
local turning=relation({relationshipStatus="UNRESOLVED",classification="UNRESOLVED",condorTurning=true,actionable=false,reason="FORWARD_CONTINUATION_UNRESOLVED"})
local entered=assessment:assessActionSpaceRegulation(current,turning)
expect(entered.disposition=="PERSIST","Protected Manoeuvre Entry must retain the incumbent Regulation")
expect(entered.category1EvacuationProtection==true,"Protected Manoeuvre Entry must activate Category-1 Evacuation Protection")
expect(entered.regulatedAssemblyId=="AS-PATRIOT" and entered.protectedAssemblyId=="AS-CONDOR","Protected/yielder identities must remain responsibility-local")
expect(assessment:isCategory1EvacuationProtectionActive(current)==true,"Evacuation protection must be current after TURNING entry")

-- Fresh FI topology may reverse timing roles, but the incumbent Category-1
-- allocation remains semantically authoritative until positive discharge.
local reversed=relation({
    spatialOverlay="OPEN_FIELD",condorTurning=true,
    temporalYielderAssemblyId="AS-CONDOR",continuingAssemblyId="AS-PATRIOT",
    subjectProjection=projection("AS-CONDOR",false,true),otherProjection=projection("AS-PATRIOT",true,false)
})
local protected=assessment:assessActionSpaceRegulation(current,reversed)
expect(protected.disposition=="PERSIST" and protected.category1EvacuationProtection==true,"Reversed FI must not dissolve active Category-1 protection")
expect(protected.regulatedAssemblyId=="AS-PATRIOT","Reversed FI must not change the incumbent yielder")

-- Responsibility Transition must reject a ROLE_MIGRATION before any new
-- Commitment/authority application is attempted.
local applyCount=0
OuttaMyWay.LiveTrafficCommitmentLifecycle={
    applyActionSpaceRegulationDecision=function()
        applyCount=applyCount+1
        return nil,"SHOULD_NOT_BE_CALLED"
    end
}
local runtime={
    currentResponsibilityAssessment=assessment,
    responsibilityTransitionAuthority={
        preflightActionSpaceRegulation=function()
            return {context="ROLE_MIGRATION",current=current,conflictIdentity=bridge.conflictIdentity,commitmentId="CM-1",admissionKind="FORWARD_INTERSECTION"},nil
        end
    }
}
local transition=OuttaMyWay.ActionSpaceRegulationResponsibilityTransition.new(runtime)
local evaluated={
    decision={identity="DEC-1",selectedCandidateId="CAND-1",commitmentAction="MAINTAIN"},
    candidates={{
        identity="CAND-1",capability="REGULATE_SPEED",
        evidenceBasis={actionSpaceRegulationBridge={
            conflictIdentity=bridge.conflictIdentity,regulatedAssemblyId="AS-CONDOR",protectedAssemblyId="AS-PATRIOT",admissionKind="FORWARD_INTERSECTION"
        }}
    }}
}
local migrated,migrationReason=transition:transition({},evaluated,{
    status="ACTION_SPACE_REGULATION_RESPONSIBILITY_TRANSITION_REQUIRED",applicationContext="ROLE_MIGRATION",
    candidateId="CAND-1",conflictIdentity=bridge.conflictIdentity,regulatedAssemblyId="AS-CONDOR",commitmentId="CM-1"
})
expect(migrated==nil and migrationReason=="CATEGORY_1_EVACUATION_PROTECTION_FREEZES_ROLES","Active Category-1 protection must block role migration")
expect(applyCount==0,"Role migration block must occur before Commitment/authority application")

-- Fresh A8 reacquisition by the same protected worker positively discharges
-- the Category-1 purpose. Existing FI terminal plumbing remains the release path.
local reacquired=relation({relationshipStatus="NEGATIVE",classification="NO_FORWARD_INTERSECTION",condorA8=true,reason="INTERSECTION_NOT_FORWARD_OF_BOTH_PARTICIPANTS"})
local discharged=assessment:assessActionSpaceRegulation(current,reacquired)
expect(discharged.disposition=="TERMINATE","Fresh protected-worker A8 must discharge Category-1 protection")
expect(discharged.terminationEvidenceKind=="FORWARD_INTERSECTION_POSITIVE_DISSOLUTION","Discharge must use the existing positive terminal-evidence path")
expect(discharged.reason=="CATEGORY_1_EVACUATION_POSITIVELY_DISCHARGED_BY_FRESH_A8","Discharge reason must identify the positive witness")
expect(assessment:isCategory1EvacuationProtectionActive(current)==false,"Discharge must clear responsibility-local protection state")

-- Before Protected Manoeuvre Entry, the existing prospective dissolution rule
-- remains unchanged.
local current2={identity="RS-2",provenance={admissionKind="FORWARD_INTERSECTION"}}
local assessment2=OuttaMyWay.CurrentResponsibilityAssessment.new()
assessment2:registerActionSpaceRegulation(current2,admitted,bridge)
local dissolved=assessment2:assessActionSpaceRegulation(current2,relation({relationshipStatus="NEGATIVE",classification="NO_FORWARD_INTERSECTION",condorA8=false,reason="INTERSECTION_NOT_FORWARD_OF_BOTH_PARTICIPANTS"}))
expect(dissolved.disposition=="TERMINATE","Prospective Category-1 allocation must still dissolve before manoeuvre entry")

print("category1 evacuation protection contract PASS")
