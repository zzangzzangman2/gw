# GirlsWar Battle Restore Plan

## Scope

- 작업 대상은 `C:\Users\godho\Downloads\girlswar` 아래 전투 구현/복원 산출물만이다.
- `girlswar_maininterface_unity`, `reports\maininterface`, MainInterface scene/builder는 수정하지 않는다.
- 원본 evidence와 추출물은 삭제하지 않는다. 이 문서는 현재 확인된 전투 관련 evidence의 사용 지도를 만든다.

## Fastest Starting Point

1. `download/xlualogic/modules/battle.assetbundle`의 `HeroCtrl`, `BattleTeam`, `BattleUtil`, `HeroBattleInfo`를 raw bytes로 다시 추출하고 `SecurityUtil.xorScale`로 decode한다.
2. `download/xlualogic/modules/procedure.assetbundle`의 `ProcedureNormalBattle`에서 전투 진입/종료/씬 전환 흐름을 확정한다.
3. 평문 datatable `skillact.assetbundle`과 `monster.assetbundle`에서 스킬, 버프, 몬스터, hurt number schema를 모델링한다.
4. `roleprefabsandres/battleprefabandres/*.assetbundle`의 Spine actor와 `artsources/map/battlemap/*` 배경 sprite를 조합해 battle 전용 Unity prototype을 만든다.

## Current Evidence Counts

- Battle AssetBundle candidates: `149`
- Battle TextAsset candidates: `5787`
- Battle image candidates: `3057`
- XLua decode targets: `4382`
- Battle map bundles: `13`
- Battle actor Spine bundles: `59`

### AssetBundle Categories

| Category | Count |
|---|---:|
| `battle_audio_preserved` | `10` |
| `battle_ui_prefab_or_ext` | `31` |
| `battle_ui_sprite` | `4` |
| `battlemap_prefab_scene` | `6` |
| `battlemap_sprite_art` | `7` |
| `common_battle_runtime_asset` | `15` |
| `datatable_battle` | `5` |
| `proto_battle` | `6` |
| `spine_battle_actor` | `59` |
| `xlua_battle_preview` | `1` |
| `xlua_battle_script_library` | `3` |
| `xlua_core_battle` | `1` |
| `xlua_procedure` | `1` |

### Largest Battle TextAssets

| Category | Bundle | Name | Size |
|---|---|---|---:|
| `datatable_battle` | `download/xlualogic/datanode/datatable/create/monster.assetbundle` | `DTMonsterEntityTableData` | `10932632` |
| `datatable_battle` | `download/xlualogic/datanode/datatable/create/monster.assetbundle` | `DTMonster_OEntityTableData` | `7194119` |
| `datatable_battle` | `download/xlualogic/datanode/datatable/create/monster.assetbundle` | `DTMonster_KEntityTableData` | `7166614` |
| `datatable_battle` | `download/xlualogic/datanode/datatable/create/monster.assetbundle` | `DTMonsterAttrEntityTableData` | `4584781` |
| `spine_battle_actor` | `download/roleprefabsandres/battleprefabandres/1062.assetbundle` | `1062.skel` | `3227221` |
| `datatable_battle` | `download/xlualogic/datanode/datatable/create/monster.assetbundle` | `DTMonsterAttr_OEntityTableData` | `3219350` |
| `datatable_battle` | `download/xlualogic/datanode/datatable/create/monster.assetbundle` | `DTMonsterAttr_KEntityTableData` | `3198221` |
| `keyword_textasset` | `download/xlualogic/datanode/datatable/create/syslocalization.assetbundle` | `DTLangBattle` | `3197973` |
| `xlua_core_battle` | `download/xlualogic/modules/battle.assetbundle` | `BattleTimelineResMap` | `2772010` |
| `battle_ui_prefab_or_ext` | `download/ui/uiprefabandres/earth_ext_7.assetbundle` | `spine_idle_battle.skel` | `2695757` |
| `spine_battle_actor` | `download/roleprefabsandres/battleprefabandres/1056.assetbundle` | `1056.skel` | `2649816` |
| `spine_battle_actor` | `download/roleprefabsandres/battleprefabandres/21073.assetbundle` | `21073.skel` | `2545615` |
| `spine_battle_actor` | `download/roleprefabsandres/battleprefabandres/1054.assetbundle` | `1054.skel` | `2505937` |
| `spine_battle_actor` | `download/roleprefabsandres/battleprefabandres/1058.assetbundle` | `1058.skel` | `2464603` |
| `spine_battle_actor` | `download/roleprefabsandres/battleprefabandres/1067.assetbundle` | `1067.skel` | `1894663` |
| `spine_battle_actor` | `download/roleprefabsandres/battleprefabandres/22073.assetbundle` | `22073.skel` | `1618353` |
| `spine_battle_actor` | `download/roleprefabsandres/battleprefabandres/1066.assetbundle` | `1066.skel` | `1592154` |
| `spine_battle_actor` | `download/roleprefabsandres/battleprefabandres/1060.assetbundle` | `1060.skel` | `1555191` |
| `spine_battle_actor` | `download/roleprefabsandres/battleprefabandres/22041.assetbundle` | `2204199.skel` | `1468882` |
| `spine_battle_actor` | `download/roleprefabsandres/battleprefabandres/21074.assetbundle` | `21074.skel` | `1458773` |

## Core Original Files

| Purpose | Original bundle/path | Notes |
|---|---|---|
| Battle runtime Lua | `download/xlualogic/modules/battle.assetbundle` | `HeroCtrl` is the largest core controller; encrypted XLua TextAsset. |
| Battle procedure | `download/xlualogic/modules/procedure.assetbundle` | `ProcedureNormalBattle` links procedure state to battle scene lifecycle. |
| Skill scripts | `download/xlualogic/modules/battleskillscript.assetbundle` | 1,728 TextAssets; decode after core flow. |
| Buff scripts | `download/xlualogic/modules/battlebuffscript.assetbundle` | 2,540 TextAssets; decode/index after core flow. |
| Battle data | `download/xlualogic/datanode/datatable/create/skillact.assetbundle` | Plain Lua-like tables for skills, buffs, hurt numbers, battle preview. |
| Monster data | `download/xlualogic/datanode/datatable/create/monster.assetbundle` | Plain Lua-like tables for monster entities and attrs. |
| Network proto | `download/xlualogic/datanode/proto/fight.assetbundle`, `formation.assetbundle`, `battleserver.assetbundle` | Protocol schema/handlers; mostly protobuf text/binary descriptors. |
| Actor Spine | `download/roleprefabsandres/battleprefabandres/*.assetbundle` | Battle character/monster skeleton, atlas, material references. |
| Battle maps | `download/artsources/map/battlemap/*`, `download/map/battlemap/*` | Sprite art and prefab/scene map roots. |
| Battle UI sprites | `download/artsources/uispriteres/uibattle.assetbundle`, `uiheroheadbattle.assetbundle`, `uiskill_*` | HUD, head icons, skill icons. |

## Implementation Units

1. Data model: parse `DTSkillActEntity`, `DTBuffEntity`, `DTMonsterEntity`, fight/formation proto into JSON indexes for Unity editor import.
2. Runtime shell: create `girlswar_battle_unity` with a 1680x720 battle scene, battle map layer stack, actor slots, HUD canvas, and deterministic test data.
3. Spine import: reuse verified Spine 4.0 import path, but source from `battleprefabandres` instead of MainInterface painting prefabs.
4. XLua bridge map: decode `BattleManager`, `HeroCtrl`, `BattleTeam`, `BattleUtil`, `ProcedureNormalBattle`, then document C#/IL2CPP calls used by Lua.
5. Prototype battle loop: reproduce idle, attack, hurt, death, skill effect trigger, damage numbers, result transition with placeholder server data.
6. Verification: capture desktop/mobile aspect screenshots, validate nonblank actor/map pixels, and log all battle entry/exit/pause/auto/skill buttons.

## Unknowns To Close

- Exact battle prefab roots under `download/map/battlemap/*` need structure.jsonl inspection before building the Unity scene.
- `HeroCtrl` animation state names and event timeline must be pulled from decoded Lua plus Spine skeleton animation names.
- Skill/buff script libraries are large; core flow should be decoded first, then scripts should be grouped by id and referenced prefab id.
- Battle result UI may live in `winlose_ext_prefabs`, `jiesuan.assetbundle`, or mode-specific result modules; map after core `ProcedureNormalBattle` decode.

## Generated Indexes

- AssetBundle candidates: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_ASSETBUNDLE_CANDIDATES.csv`
- TextAsset candidates: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_TEXTASSET_CANDIDATES.csv`
- Image candidates: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_IMAGE_CANDIDATES.csv`
- XLua decode targets: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_XLUA_DECODE_TARGETS.csv`
- Summary JSON: `C:\Users\godho\Downloads\girlswar\reports\battle\battle_restore_index_summary.json`
