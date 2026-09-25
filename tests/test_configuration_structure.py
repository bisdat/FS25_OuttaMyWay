from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
MAIN=ROOT/"scripts/main.lua"
CONFIGURATION=ROOT/"scripts/configuration/Configuration.lua"
ROOT_CONFIG=ROOT/"scripts/config.lua"
SPEC=ROOT/"spec/CONFIGURATION.md"

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
    assert "-- Specification Jurisdictions: `CONFIGURATION`" in source
    assert "-- Specification Jurisdictions: `CONFIGURATION`" in main
