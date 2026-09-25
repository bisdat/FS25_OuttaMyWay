from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
MAIN=ROOT/"scripts/main.lua"
CONFIGURATION=ROOT/"scripts/configuration/Configuration.lua"
ROOT_CONFIG=ROOT/"scripts/config.lua"
SPEC=ROOT/"spec/CONFIGURATION.md"
PRODUCT_LIFECYCLE=ROOT/"scripts/lifecycle/ProductLifecycle.lua"
RUNTIME=ROOT/"scripts/runtime/Runtime.lua"
COORDINATOR=ROOT/"scripts/runtime/LiveRuntimeCoordinator.lua"
PASSAGE_CONTROL=ROOT/"scripts/control/CooperativePassageControl.lua"
RELOCATION_CONTROL=ROOT/"scripts/control/ObstructionRelocationControl.lua"
MOD_DESC=ROOT/"modDesc.xml"

def read(path):
    return path.read_text(encoding="utf-8")

def test_configuration_is_separate_from_root_identity_and_engineering_diagnostics():
    root_config=read(ROOT_CONFIG)
    source=read(CONFIGURATION)
    assert "OuttaMyWay.MOD_NAME" in root_config
    assert "OuttaMyWay.VERSION" in root_config
    assert "configuration.xml" not in root_config
    assert "DIAGNOSTIC" not in source
    assert "diagnostics.xml" not in source

def test_product_shell_resolves_configuration_before_runtime_bootstrap():
    main=read(MAIN)
    assert '"scripts/configuration/Configuration.lua"' in main
    assert main.index('"scripts/configuration/Configuration.lua"') < main.index('"scripts/publication/LogPublication.lua"')
    resolve=main.index("OuttaMyWay.configuration:resolvePersistedState()")
    publisher=main.index("OuttaMyWay.LogPublication.new(resolvedPublicationPolicy)")
    runtime=main.index("OuttaMyWay.runtime=OuttaMyWay.Runtime.new()")
    assert resolve < publisher < runtime
    assert "if configurationReady and OuttaMyWay.configuration:isEnabled()==true then" in main
    assert 'OuttaMyWay.configuration:isDebugEnabled()==true then return "DEBUG"' in main
    assert 'publicationPolicy()=="DIAGNOSTIC"' in main
    assert "CONFIGURATION_STORAGE_FAILED" in main
    lifecycle=read(PRODUCT_LIFECYCLE)
    assert '"scripts/lifecycle/ProductLifecycle.lua"' in main
    assert "OuttaMyWay.productLifecycle:subscribe()" in main
    assert "OuttaMyWay.productLifecycle:adoptRuntime(OuttaMyWay.runtime,runtimeListeners)" in main
    assert 'notification.name~="enabled"' in lifecycle
    assert 'notification.value==false' in lifecycle
    assert "runtime.relinquishAllControl" in lifecycle
    assert "removeModEventListener" in lifecycle

def test_configuration_uses_profile_modsettings_schema1_and_no_savegame_path():
    source=read(CONFIGURATION)
    assert '"modSettings/"..modName.."/"' in source
    assert 'local FILE_NAME="configuration.xml"' in source
    assert "local SCHEMA_VERSION=1" in source
    assert "getUserProfileAppPath" in source
    assert "createFolder" in source
    assert "fileExists" in source
    assert "XMLFile.loadIfExists" in source
    assert "XMLFile.create" in source
    assert "savegame" not in source.lower()

def test_configuration_spec_has_real_source_participants():
    spec=read(SPEC)
    source=read(CONFIGURATION)
    main=read(MAIN)
    marker="**Implementation Status:** "+chr(96)+"NOT_IMPLEMENTED"+chr(96)
    assert marker not in spec
    assert "[`scripts/configuration/Configuration.lua`](../scripts/configuration/Configuration.lua) | `REALISES`" in spec
    assert "[`scripts/main.lua`](../scripts/main.lua) | `SUPPORTS`" in spec
    assert "[`scripts/lifecycle/ProductLifecycle.lua`](../scripts/lifecycle/ProductLifecycle.lua) | `REALISES`" in spec
    assert "[`scripts/runtime/Runtime.lua`](../scripts/runtime/Runtime.lua) | `SUPPORTS`" in spec
    assert "-- Specification Jurisdictions: `CONFIGURATION`" in source
    assert "-- Specification Jurisdictions: `CONFIGURATION`" in main
    assert "-- Specification Jurisdictions: `CONFIGURATION`" in read(PRODUCT_LIFECYCLE)
    assert "`CONFIGURATION`" in read(RUNTIME).splitlines()[1]

def test_live_disable_has_localised_hand_back_without_hard_coded_control_text():
    lifecycle=read(PRODUCT_LIFECYCLE)
    mod_desc=read(MOD_DESC)
    assert 'HAND_BACK_TEXT_KEY="omw_disabledHandBack"' in lifecycle
    assert "showBlinkingWarning" in lifecycle
    assert "isHudVisible()" in lifecycle
    assert '<text name="omw_disabledHandBack">' in mod_desc
    assert "<en>OuttaMyWay disabled." in mod_desc
    assert "<de>OuttaMyWay deaktiviert." in mod_desc
    assert "<fr>OuttaMyWay désactivé." in mod_desc
    assert "<es>OuttaMyWay desactivado." in mod_desc
    assert "<it>OuttaMyWay disattivato." in mod_desc


def test_live_disable_stops_coordination_before_semantic_and_physical_relinquishment():
    runtime=read(RUNTIME)
    section=runtime.split("function Runtime:relinquishAllControl",1)[1].split("function Runtime:setRegulationControl",1)[0]
    assert section.index("ceaseCoordination") < section.index("terminateAll")
    assert section.index("terminateAll") < section.index("regulationBoundedAuthority:relinquishAll")
    assert "boundedAuthority:releaseAll" in section
    coordinator=read(COORDINATOR)
    assert "function Coordinator:ceaseCoordination()" in coordinator
    assert "if self.coordinationEnabled~=true then return end" in coordinator

def test_live_disable_relinquishment_does_not_finish_passage_or_relocation():
    passage=read(PASSAGE_CONTROL)
    passage_section=passage.split("function Control:relinquishAll",1)[1].split("-- Player-facing Passage",1)[0]
    assert "requestCachedTransitRestore" not in passage_section
    assert "finishCachedTransitRestore" not in passage_section
    assert "self.run=nil" in passage_section
    relocation=read(RELOCATION_CONTROL)
    relocation_section=relocation.split("function Control:relinquishAll",1)[1].split("function Control:loadMap",1)[0]
    assert "self:_complete" not in relocation_section
    assert "actuationMechanism:neutralize" in relocation_section
    assert "releaseVehicleActivityContext" in relocation_section
