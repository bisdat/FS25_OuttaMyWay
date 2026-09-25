from pathlib import Path
import xml.etree.ElementTree as ET

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
GUI_ARCH=ROOT/"architecture/GUI.md"
CONFIG_SETTINGS_EXTENSION=ROOT/"scripts/gui/ConfigurationSettingsExtension.lua"
DISABLED_STARTUP_REMINDER=ROOT/"scripts/gui/DisabledStartupReminder.lua"

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
    startup=main.index('OuttaMyWay.productLifecycle:enable("STARTUP",false)')
    assert resolve < publisher < startup
    assert "if configurationReady and OuttaMyWay.configuration:isEnabled()==true then" in main
    assert 'OuttaMyWay.configuration:isDebugEnabled()==true then return "DEBUG"' in main
    assert 'publicationPolicy()=="DIAGNOSTIC"' in main
    assert "CONFIGURATION_STORAGE_FAILED" in main
    lifecycle=read(PRODUCT_LIFECYCLE)
    assert '"scripts/lifecycle/ProductLifecycle.lua"' in main
    assert "OuttaMyWay.productLifecycle:subscribe()" in main
    assert "OuttaMyWay.ProductLifecycle.new(OuttaMyWay.configuration,createRuntimeBundle)" in main
    assert "registerListeners=registerRuntimeBundleListeners" in main
    assert 'notification.name~="enabled"' in lifecycle
    assert 'notification.value==false' in lifecycle
    assert "runtime.relinquishAllControl" in lifecycle
    assert "removeModEventListener" in lifecycle
    assert 'notification.value==true and notification.durable==true' in lifecycle
    assert 'self:enable("PLAYER_CONFIGURATION_ENABLED",true)' in lifecycle
    assert '"scripts/gui/ConfigurationSettingsExtension.lua"' in main
    assert "ConfigurationPage.lua" not in main
    assert "ConfigurationMenuIntegration.lua" not in main

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
    assert "[`scripts/gui/ConfigurationSettingsExtension.lua`](../scripts/gui/ConfigurationSettingsExtension.lua) | `REALISES`" in spec
    assert "[`scripts/gui/DisabledStartupReminder.lua`](../scripts/gui/DisabledStartupReminder.lua) | `REALISES`" in spec
    assert "-- Specification Jurisdictions: `CONFIGURATION`" in source
    assert "-- Specification Jurisdictions: `CONFIGURATION`" in main
    assert "-- Specification Jurisdictions: `CONFIGURATION`" in read(PRODUCT_LIFECYCLE)
    assert "`CONFIGURATION`" in read(RUNTIME).splitlines()[1]
    assert "-- Specification Jurisdictions: `CONFIGURATION`" in read(CONFIG_SETTINGS_EXTENSION)
    assert "-- Specification Jurisdictions: `CONFIGURATION`" in read(DISABLED_STARTUP_REMINDER)

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


def test_configuration_section_extends_giants_general_settings_without_menu_ownership():
    extension=read(CONFIG_SETTINGS_EXTENSION)
    arch=read(GUI_ARCH)
    main=read(MAIN)

    for forbidden in (
        "configuration.xml","modSettings","XMLFile","registerPage","addPageTab",
        "rebuildTabList","unregisterPage","g_gui.loadGui","addModEventListener",
        "deleteMap","gameSettingsLayout",
    ):
        assert forbidden not in extension

    assert "InGameMenuSettingsFrame.onFrameOpen=Utils.appendedFunction" in extension
    assert "InGameMenuSettingsFrame.updateGeneralSettings=Utils.appendedFunction" in extension
    assert "frame.generalSettingsLayout" in extension
    assert extension.count("addBinaryOption(") == 4  # helper definition + exactly three rows
    assert "BinaryOptionElement.new()" in extension
    assert "option.useYesNoTexts=false" in extension
    assert 'self:_apply("enabled",state==BinaryOptionElement.STATE_RIGHT)' in extension
    assert 'self:_apply("hudVisible",state==BinaryOptionElement.STATE_RIGHT)' in extension
    assert 'self:_apply("debug",state==BinaryOptionElement.STATE_RIGHT)' in extension

    assert "Configuration Section != Configuration Authority" in arch
    assert "Configuration Integration != Menu Ownership" in arch
    assert "Settings Extension != Map Lifecycle Participant" in arch
    assert "General Settings" in arch
    assert '"scripts/gui/ConfigurationSettingsExtension.lua"' in main
    assert "configurationMenuIntegration" not in main


def test_configuration_section_localisation_has_all_required_languages():
    root=ET.parse(MOD_DESC).getroot()
    required_keys=(
        "omw_configSection_title","omw_configSection_enabled","omw_configSection_enabledTooltip",
        "omw_configSection_operationalMessages","omw_configSection_operationalMessagesTooltip",
        "omw_configSection_debug","omw_configSection_debugTooltip","omw_configSection_saveFailed",
    )
    for key in required_keys:
        node=root.find(f"./l10n/text[@name='{key}']")
        assert node is not None, key
        for language in ("en","de","fr","es","it"):
            value=node.find(language)
            assert value is not None and value.text and value.text.strip(), f"{key}:{language}"


def test_fresh_runtime_reenable_reuses_mechanical_interceptors_but_not_semantic_runtime():
    main=read(MAIN)
    lifecycle=read(PRODUCT_LIFECYCLE)
    factory=main[main.index("local function createRuntimeBundle()"):main.index("OuttaMyWay.productLifecycle=")]
    assert "local sharedPhysicalControlMechanisms=" in main
    assert "sharedPhysicalControlMechanisms.holdMechanism:clear()" in factory
    assert "sharedPhysicalControlMechanisms.driveMechanism:clearAll()" in factory
    assert "OuttaMyWay.Runtime.new()" in factory
    assert "OuttaMyWay.FieldWorkHoldMechanism.new()" not in factory
    assert "OuttaMyWay.NativeDriveMechanism.new()" not in factory
    assert "initializeCurrentMap==true" in lifecycle
    assert "pcall(listener.loadMap,listener)" in lifecycle
    assert "Listener Registration != Map Initialization" in read(ROOT/"docs/engine/GIANTS_API_SURFACES.md")


def test_disabled_startup_reminder_is_product_status_not_operational_message():
    reminder=read(DISABLED_STARTUP_REMINDER)
    main=read(MAIN)
    arch=read(GUI_ARCH)
    spec=read(SPEC)

    assert '"scripts/gui/DisabledStartupReminder.lua"' in main
    assert "OuttaMyWay.DisabledStartupReminder.new(OuttaMyWay.configuration)" in main
    assert "addModEventListener(OuttaMyWay.disabledStartupReminder)" in main
    assert "function Reminder:loadMap()" in reminder
    assert "function Reminder:update()" in reminder
    assert "function Reminder:deleteMap()" in reminder
    assert "WARNING_DURATION_MS=5000" in reminder
    assert "showBlinkingWarning" in reminder
    assert 'TEXT_KEY="omw_disabledStartupReminder"' in reminder
    assert "isResolved()" in reminder
    assert "isEnabled()" in reminder
    assert "isHudVisible" not in reminder
    assert "OuttaMyWay.runtime" not in reminder
    assert "Disabled Startup Reminder != Operational Player Message" in arch
    assert "Disabled Startup Reminder != Operational Player Message" in spec


def test_disabled_startup_reminder_localisation_has_all_required_languages():
    root=ET.parse(MOD_DESC).getroot()
    node=root.find("./l10n/text[@name='omw_disabledStartupReminder']")
    assert node is not None
    for language in ("en","de","fr","es","it"):
        value=node.find(language)
        assert value is not None and value.text and value.text.strip()
