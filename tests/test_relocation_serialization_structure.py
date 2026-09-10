from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_relocation_serialization_is_shared_execution_vocabulary_not_d0147_provenance():
    authority = (ROOT / "scripts" / "authority" / "RegulationBoundedAuthority.lua").read_text(encoding="utf-8")
    runtime = (ROOT / "scripts" / "runtime" / "Runtime.lua").read_text(encoding="utf-8")
    control = (ROOT / "scripts" / "control" / "RegulationControl.lua").read_text(encoding="utf-8")
    terminal = (ROOT / "scripts" / "candidates" / "TerminalEgressCandidateSupport.lua").read_text(encoding="utf-8")
    obstruction = (ROOT / "scripts" / "candidates" / "ObstructionRelocationCandidateSupport.lua").read_text(encoding="utf-8")
    completed_transition = (ROOT / "scripts" / "responsibility" / "CompletedObstructionResponsibilityTransition.lua").read_text(encoding="utf-8")

    for token in (
        'RELOCATION_SERIALIZATION_OWNER_TAG="RELOCATION_SERIALIZATION"',
        "relocationSerializationLeases",
        "_applyRelocationSerialization",
        "_releaseRelocationSerialization",
        "relocationSerializationAssemblyIds",
        'governingPurpose="RELOCATION_SERIALIZATION_INTERVAL"',
        '"APPLY",RELOCATION_SERIALIZATION_OWNER_TAG,0.0',
        '"RELOCATION_SERIALIZATION_APPLIED"',
    ):
        assert token in authority

    assert "RELOCATION_SERIALIZATION=true" in control
    assert "D0147_PROTECTED_YIELD" not in control

    assert runtime.count("_applyRelocationSerialization") == 1
    assert "COMPLETED_OBSTRUCTION_RELOCATION_SERIALIZATION_START_FAILED" not in runtime
    assert "OBSTRUCTION_RELOCATION_SERIALIZATION_START_FAILED" in runtime
    assert "serializedBeneficiaryAssemblyIds" not in runtime
    assert "RELOCATION_SERIALIZATION_START_FAILED" in runtime
    assert "PROTECTED_YIELD_START_FAILED" not in runtime
    assert "CompletedObstructionResponsibilityTransition.new(runtime)" not in runtime
    # Retained donor source remains directly testable until the later retirement increment.
    assert "beforeRelocationSerialization=true beforePhysicalDispatch=true" in completed_transition
    assert "beforeProtectedYield" not in completed_transition

    assert "relocationSerializationBeneficiaries" in terminal
    assert "relocationSerializationBeneficiaries" in obstruction
    assert 'architecture="D0147"' in terminal
    assert 'architecture="CAUSAL_OBSTRUCTION_RELOCATION"' in obstruction

    for text in (authority, runtime, control, terminal, obstruction):
        assert "D0147_PROTECTED_YIELD" not in text
        assert "d0147ProtectedYield" not in text
        assert "protectedDemandAssemblies" not in text


def test_relocation_serialization_preserves_hold_mechanics_and_bounded_authority_contract():
    authority = (ROOT / "scripts" / "authority" / "RegulationBoundedAuthority.lua").read_text(encoding="utf-8")
    control = (ROOT / "scripts" / "control" / "RegulationControl.lua").read_text(encoding="utf-8")

    assert '"PROGRESS_ACTUATION"' in authority
    assert 'capability="REGULATE_SPEED"' in authority
    assert '"APPLY",RELOCATION_SERIALIZATION_OWNER_TAG,0.0' in authority
    assert 'RELOCATION_SERIALIZATION=true' in control
    assert 'return false,"BOUNDED_AUTHORITY_GRANT_REQUIRED"' in control
