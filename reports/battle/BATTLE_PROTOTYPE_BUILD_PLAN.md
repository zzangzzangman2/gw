# Battle Prototype Build Plan

## Prototype Inputs Now Fixed
- Test payload: `reports/battle/BATTLE_TEST_PAYLOAD.json`
- Prototype manifest: `reports/battle/BATTLE_PROTOTYPE_MANIFEST.json`
- Actors CSV: `reports/battle/BATTLE_PROTOTYPE_ACTORS.csv`
- Skills CSV: `reports/battle/BATTLE_PROTOTYPE_SKILLS.csv`
- Bundles CSV: `reports/battle/BATTLE_PROTOTYPE_BUNDLES.csv`
- Lua/resource trace CSV: `reports/battle/BATTLE_RESOURCE_TRACE.csv`

## Minimum Original Files For First Prototype
- `girl1.xapk` / original extraction root remains preserved for provenance.
- `com.girlwars.kr` extraction and OBB/AssetBundle evidence remain preserved.
- Datatable bundles: `download/xlualogic/datanode/datatable/create/hero.assetbundle`, `model.assetbundle`, `monster.assetbundle`, `skillact.assetbundle`, `maps.assetbundle`.
- Decoded Lua evidence: `ProcedureNormalBattle`, `HeroCtrl`, `BattleResPreloadMgr`, `BattleTimelineResMap` decoded files listed in `BATTLE_RESOURCE_TRACE.csv`.

## Resource Load Chain
1. `ProcedureNormalBattle.BeginBattleWithServer_FightPlay` embeds the serverless JSON payload.
2. `HeroCtrl` resolves payload `heroDid` through `DTHero` or `DTMonster`, then `DTmodel.modelID -> DTmodel.prefabId`.
3. Actor Spine bundles resolve as `download/roleprefabsandres/battleprefabandres/{prefabId}.assetbundle`.
4. `BattleResPreloadMgr.GetHeroSkillIds` resolves skill ids through `DTSkillAct.prefabId` and `LuaUtils.GetSysprefabData`.
5. `BattleTimelineResMap[AssetPath]` expands each skill prefab to extra prefab/audio/video deps.

## Verification
- Actor joins: hero `3` ok / `0` missing, monster `0` ok / `9` missing.
- Model joins: `3` ok / `9` missing.
- Skill joins: `33` ok / `22` missing.
- Timeline prefab joins: `42` ok / `0` missing.
- Bundle references existing: `11` / `15`.

## Missing Or Open Resource IDs
- monster: `1100111, 1100112, 1100113, 1100121, 1100122, 1100123, 1100131, 1100132, 1100133`
- skillact: `1001401, 1001403, 1012401, 1012403, 1034401, 1034402, 1036401, 1036402`

## Next Unity Prototype Command
- Run `_restore_tools\BATTLE_06_PREPARE_BATTLE_UNITY_PROTOTYPE_FOLDER.cmd` to refresh the battle-only Unity prototype folder scaffold from this manifest.
- The first Unity scene should consume `reports/battle/BATTLE_PROTOTYPE_MANIFEST.json`, spawn placeholder lanes by formation, then replace placeholders with actor Spine prefabs when an importer is attached.

## First Scene Implementation Units
- `BattlePrototypeBootstrap`: load manifest JSON and payload JSON.
- `BattleFormationView`: map six formation positions per side and wave selector.
- `BattleActorView`: bind `heroDid`, `modelId`, `prefabId`, bundle path, and basic HP/MP values.
- `BattleSkillPreviewQueue`: list skill timeline prefab paths and dependency availability.
- `BattleEvidencePanel`: show source Lua line references and datatable join status.
