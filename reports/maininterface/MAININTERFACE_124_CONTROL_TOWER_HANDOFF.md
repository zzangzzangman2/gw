# MainInterface 124 Control Tower Handoff

## Status

- Task: `MAININTERFACE_124_MOUNT_HERO1005_HOME_SPINE_SKELETON_GRAPHIC`
- Result: partial progress, restored claim remains `false`.
- Unity batch: succeeded with exit code `0`.
- Hero1005 now renders through real `SpineAtlasAsset + SkeletonDataAsset + SkeletonGraphic`.
- No fake PNG/screenshot paste/whole-atlas UI Image was used.
- `wanfaWorldNode/worldwanfaBtn` was not hidden.

## Evidence

- UI123 `Painting_1005.skel.bytes` was a text-path export and differed from raw TextAsset bytes.
- UI124 raw extraction produced 6 raw TextAssets from `download/roleprefabsandres/paintingprefabandres/1005.assetbundle`.
- Raw vs old export: all 6 differ; old export `?` byte count `256529`, raw `?` byte count `28668`.
- Spine load succeeded from raw source: `bones=430`, `slots=200`, `skins=1`, `animations=4`.
- Mounted animation: `A`, loop `true`.
- `homePara=[1,0,0]` recorded only as evidence; exact transform semantics remain unresolved.
- Sibling/order evidence: `UI_heroSpine` sibling index `1`, `right` sibling index `3`; route/right draws above hero.

## Captures And Validation

- Full capture: `girlswar_maininterface_unity/Assets/RestoreCaptures/maininterface_ui124_hero1005_spine_1680x720.png`
- Hero-only capture: `girlswar_maininterface_unity/Assets/RestoreCaptures/maininterface_ui124_hero1005_spine_hero_only_1680x720.png`
- Click validation: `77` total buttons, `24` active, `24` clickable, `0` blocked.
- Reference diff full mean abs diff: `0.265278`; changed pixel ratio >=30: `0.860502`; correlation: `0.188564`.

## Next Blocker

Reference still mismatches because the route/world cluster remains visible and draws above the hero. Next work should trace normal-home runtime active state/sibling order for `right/node_middle/wanfaWorldNode/worldwanfaBtn` and related home lobby UI groups from original Lua/prefab/runtime evidence before hiding or reordering anything.

## Changed Files From UI124 Work

- `_restore_tools/cmd_archive/124_EXTRACT_HERO1005_SPINE_RAW_TEXTASSETS.cmd`
- `_restore_tools/cmd_archive/124_MOUNT_HERO1005_HOME_SPINE_SKELETON_GRAPHIC.cmd`
- `_restore_tools/cmd_archive/124_REFERENCE_DIFF_CONTACT.cmd`
- `_restore_tools/scripts/maininterface124_extract_hero1005_spine_raw_textassets.py`
- `_restore_tools/scripts/maininterface124_reference_diff_contact.py`
- `girlswar_maininterface_unity/Assets/Editor/MainInterface124Hero1005HomeSpineMount.cs`
- `girlswar_maininterface_unity/Assets/RestoreData/hero1005_spine_source_raw/`
- `girlswar_maininterface_unity/Assets/RestoreData/maininterface_124_hero1005_home_spine_mount.json`
- `girlswar_maininterface_unity/Assets/RestoreData/reports/maininterface_124_*.csv`
- `girlswar_maininterface_unity/Assets/RestoreData/reports/maininterface_124_*.json`
- `girlswar_maininterface_unity/Assets/RestoreCaptures/maininterface_ui124_hero1005_spine_1680x720.png`
- `girlswar_maininterface_unity/Assets/RestoreCaptures/maininterface_ui124_hero1005_spine_hero_only_1680x720.png`
- `girlswar_maininterface_unity/Assets/Scenes/MainInterface_UI124_Hero1005HomeSpine.unity`
- `reports/maininterface/MAININTERFACE_124_*`

## Reports

- `reports/maininterface/MAININTERFACE_124_HERO1005_SPINE_RAW_TEXTASSETS.md`
- `reports/maininterface/MAININTERFACE_124_MOUNT_HERO1005_HOME_SPINE_SKELETON_GRAPHIC_RESULT.md`
- `reports/maininterface/MAININTERFACE_124_REFERENCE_DIFF_RESULT.md`
- `reports/maininterface/MAININTERFACE_124_REFERENCE_DIFF_CONTACT.png`
- `reports/maininterface/MAININTERFACE_124_SPINE_UNITY_API_EVIDENCE.md`
