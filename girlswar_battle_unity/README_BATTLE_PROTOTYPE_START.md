# GirlsWar Battle Prototype Start

This folder is reserved for battle-only prototype work. It must not modify MainInterface restore outputs.

Start data:
- Manifest: `reports/battle/BATTLE_PROTOTYPE_MANIFEST.json`
- Payload: `reports/battle/BATTLE_TEST_PAYLOAD.json`
- Build plan: `reports/battle/BATTLE_PROTOTYPE_BUILD_PLAN.md`

Suggested first Unity pass:
1. Create a battle-only Unity project or scene here.
2. Copy or reference the manifest JSON under an `Assets/RestoreData/Battle` folder.
3. Render map 11001 as a placeholder background until the map prefab importer is attached.
4. Render our/enemy formations from payload and attach actor bundle paths from the manifest.
5. Render skill dependency tables from `skills` and `bundles` in the manifest.

Do not delete source XAPK, APK extraction, OBB, AssetBundle, decoded Lua, or datatable evidence.
