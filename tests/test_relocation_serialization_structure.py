from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_relocation_serialization_belongs_to_current_obstruction_relocation_only():
    authority = (ROOT / "scripts" / "authority" / "RegulationBoundedAuthority.lua").read_text(encoding="utf-8")
    runtime = (ROOT / "scripts" / "runtime" / "Runtime.lua").read_text(encoding="utf-8")
    control = (ROOT / "scripts" / "control" / "RegulationControl.lua").read_text(encoding="utf-8")
    obstruction = (ROOT / "scripts" / "candidates" / "ObstructionRelocationCandidateSupport.lua").read_text(encoding="utf-8")

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
    assert runtime.count("_applyRelocationSerialization") == 1
    assert "OBSTRUCTION_RELOCATION_SERIALIZATION_START_FAILED" in runtime
    assert "relocationSerializationBeneficiaries" in obstruction
    assert 'architecture="CAUSAL_OBSTRUCTION_RELOCATION"' in obstruction
    assert "historicalJobProvenanceRequired=false" in obstruction

    for relative in (
        "scripts/candidates/TerminalEgressCandidateSupport.lua",
        "scripts/responsibility/CompletedObstructionResponsibilityTransition.lua",
    ):
        assert not (ROOT / relative).exists()

    for current in (authority, runtime, control, obstruction):
        assert "D0147_PROTECTED_YIELD" not in current
        assert "d0147ProtectedYield" not in current
        assert "protectedDemandAssemblies" not in current


def test_relocation_serialization_preserves_hold_mechanics_and_bounded_authority_contract():
    authority = (ROOT / "scripts" / "authority" / "RegulationBoundedAuthority.lua").read_text(encoding="utf-8")
    control = (ROOT / "scripts" / "control" / "RegulationControl.lua").read_text(encoding="utf-8")

    assert '"PROGRESS_ACTUATION"' in authority
    assert 'capability="REGULATE_SPEED"' in authority
    assert '"APPLY",RELOCATION_SERIALIZATION_OWNER_TAG,0.0' in authority
    assert 'RELOCATION_SERIALIZATION=true' in control
    assert 'return false,"BOUNDED_AUTHORITY_GRANT_REQUIRED"' in control
