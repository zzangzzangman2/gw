# Control Tower Status 2026-06-26 00:59 KST

## Threads
- control tower: current thread
- UI worker: `019eff6c-a02a-7f73-9ffb-74456322d1ce`
- battle worker: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`
- character roster worker: `019eff6d-307b-7532-8b1d-7105b18cd6b7`

## MainInterface
Status: improved, not restored.

Current confirmed control-tower changes remain:
- `MainInterfaceSceneBuilder.ApplyRectRow` preserves `row.localScale`, including zero scale.
- `CaptureMainInterfaceScene()` rebuilds before capture.
- `UI_bg` visual override now uses reference-matching `PaintingBG_1005`.
- Latest confirmed capture `girlswar_maininterface_unity/Assets/RestoreCaptures/maininterface_restored_1680x720.png` shows 1005 night/moon background.

Still failing:
- `UI_heroSpine` is still empty; the home hero character is not rendered.
- `right/node_middle/wanfaWorldNode/worldwanfaBtn` route/world cluster remains active.
- UI122 evidence says arbitrary hide is not allowed: normal-home Lua hide evidence has not been found, and UI121 route attachments remain original pre-clipping evidence.

Worker status:
- UI worker is active on UI123.
- New file observed: `_restore_tools/scripts/maininterface123_trace_hero1005_home_spine_and_route_active.py`.
- Current UI123 evidence direction: normal home uses `GetPlayerBigSpineAll(heroDid, UI_heroSpine, "homePara")`; Live2D is tied to marry/self-marry branch. `paintingprefabandres/1005` has `Painting_1005.skel/atlas` and is the leading home hero candidate.

Next UI blocker:
- Evidence-backed import/render path for hero 1005 home painting Spine into `UI_heroSpine`.
- Runtime home active-state model for route/world node without arbitrary hide.

## Battle
Status: improved, not restored/playable.

BATTLE43 latest confirmed results:
- Unity exit code: `0`
- final screen claim: `false`
- BATTLE42 to BATTLE43 capture similarity: meanAbsDiff `0.0`, pixelCorrelation `1.0`
- GraphicRaycaster before/reopen: `0 / 9`
- Button before/reopen: `0 / 10`
- raycast-ready Button after/reopen: `0 / 0`
- Mask/RectMask2D reopen: `0 / 0`
- TMP/Text reopen: `0 / 0`
- missing scripts reopen: `1208`
- EventSystem count after reopen: `1`

Interpretation:
- BATTLE43 fixed the earlier compile/batch issue and produced a persistent interaction-plumbing candidate.
- It did not make the screen playable: buttons survive as components, but target/raycast readiness is still zero.
- Mask and text reconstruction remain absent.
- No fake click handlers were attached.

Primary reports:
- `reports/battle/BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_RESULT.md`
- `reports/battle/BATTLE_43_MINIMAL_PLAYABLE_CONTEXT_PATCH_PLAN.md`

Next battle blocker:
- `BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION`
- Need original Button MonoScript serialized fields and exact targetGraphic/raycastTarget mapping before enabling click flow.

## Character Roster
Status: stronger evidence roster generated, not complete.

Latest confirmed results:
- `DTSysPrefab` direct raw decode succeeded from `clean_unityfs_slices/download/datatable/sys.assetbundle`.
- Extracted `.txt` copy is lossy (`UnityPy read().script` replacement), but raw serialized data preserves a gzip stream.
- Gzip offset: `20`
- Decompressed FlatBuffer bytes: `1720248`
- Decoded rows: `10302`
- Battle relevant ids checked: `20`; found: `20`; missing: `0`

Battle relevant DTSysPrefab ids confirmed include:
- actor prefabs: `1002`, `1034`, `1036`, `3001`
- skill prefabs: `1002101`, `1002201`, `1002301`, `1002351`, `1012101`, `1012201`, `1012301`, `1012351`, `1034101`, `1034201`, `1034301`, `1034351`, `1036101`, `1036201`, `1036301`, `1036351`

Remaining gaps:
- Loadable actor bundles remain `3 / 12`.
- Enemy `1100112/1100113/1100121/1100122/1100123/1100131/1100132/1100133` are still unresolved in extracted DTMonster variant tables.
- Our hero `1036` maps through DTSysPrefab and DTmodel, but `download/roleprefabsandres/battleprefabandres/1036.assetbundle` is not in the extracted assetbundle index.
- Passive skill ids remain separated from active timeline prefab mapping.

Primary reports:
- `reports/characters/GIRLSWAR_CHARACTER_ROSTER.md`
- `reports/characters/GIRLSWAR_CHARACTER_GAP_REPORT.md`
- `reports/characters/DTSYSPREFAB_DIRECT_DECODE_REPORT.md`
- `reports/characters/DTSYSPREFAB_BATTLE_RELEVANT_ROWS.csv`

## Command Policy
- Root CMD count remains `1`: `00_COMMAND_CENTER.cmd`.
- `_restore_tools` direct CMD count remains `0`.
- New command wrappers remain under `_restore_tools/cmd_archive`.

## Control Tower Next
- Wait for UI123 final report before patching MainInterface hero rendering.
- Let battle worker finish BATTLE43 raycast diagnosis, then dispatch or perform BATTLE44.
- Let character worker finish monster field/table check, then use DTSysPrefab paths to harden battle manifest/resource loading.
- Do not claim final restored state yet.
