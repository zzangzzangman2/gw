# Control Tower Status 2026-06-26 01:01 KST

## Threads
- control tower: current thread
- UI worker: `019eff6c-a02a-7f73-9ffb-74456322d1ce`
- battle worker: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`
- character roster worker: `019eff6d-307b-7532-8b1d-7105b18cd6b7`

## MainInterface
Status: improved, not restored.

Latest UI123 evidence:
- `maininterface_restored_1680x720.png` uses the reference-matching 1005 night/moon background.
- Mean absolute diff vs reference is now `65.733`, still classified as mismatch.
- `UI_heroSpine` is active but effectively empty: `sizeDelta=0,0`, no children, empty sprite refs, alpha `0.0`.
- Normal home Lua evidence calls `UIUtil.GetPlayerBigSpineAll(heroDid, UI_heroSpine, "homePara")` and `UIUtil.GetPaintingBg(heroDid)`.
- Best evidence-backed home hero candidate is `download/roleprefabsandres/paintingprefabandres/1005.assetbundle`.
- This bundle contains `Painting_1005.skel`, `Painting_1005.atlas`, `Painting_1005_back.skel`, `Painting_1005_back.atlas`, `Painting_1005.png`, and `Painting_1005_back.png`.
- `battleprefabandres/1005.assetbundle` exists but is a battle actor bundle, not the first-choice home lobby path.
- Live2D is not the normal home path: `live2d/1005` appears in CDN versionfile but is not in the current extracted assetbundle index; local `live2d/1043` and `UI_heroLive2d_1005` evidence belongs to marry/self-marry branch.

Route state:
- `right`, `node_middle`, `wanfaWorldNode`, `worldwanfaBtn`, and `mian_wanfa_item_1..4` remain active in prefab/runtime evidence.
- Lua evidence only gates `mian_wanfa_item_3/4`; no normal-home evidence hides `wanfaWorldNode/worldwanfaBtn`.
- Arbitrary route hide remains disallowed.

Primary reports:
- `reports/maininterface/MAININTERFACE_123_HERO1005_HOME_SPINE_ROUTE_ACTIVE_TRACE_RESULT.md`
- `reports/maininterface/MAININTERFACE_123_hero1005_bundle_assets.csv`
- `reports/maininterface/MAININTERFACE_123_route_active_evidence.csv`

Next UI blocker:
- Implement an evidence-backed home `Painting_1005` Spine mount path for `UI_heroSpine`, with `homePara` semantics.

## Battle
Status: improved, not restored/playable.

Latest BATTLE43 evidence:
- Unity exit code: `0`
- final screen claim: `false`
- BATTLE42 to BATTLE43 capture similarity: meanAbsDiff `0.0`, pixelCorrelation `1.0`
- GraphicRaycaster before/reopen: `0 / 9`
- Button before/reopen: `0 / 10`
- raycast-ready Button after/reopen: `0 / 0`
- raycast failure reasons: `{'no_graphic_hits_at_button_center': 20}`
- all sampled button centers have zero graphic hits.
- Mask/RectMask2D reopen: `0 / 0`
- TMP/Text reopen: `0 / 0`
- missing scripts reopen: `1208`

Interpretation:
- BATTLE43 successfully persists GraphicRaycaster and Button components without fake handlers.
- The child-Image heuristic does not recreate original raycast geometry; candidate button centers do not hit any Graphic.
- Mask/TMP/text reconstruction remains absent.

Primary reports:
- `reports/battle/BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_RESULT.md`
- `reports/battle/BATTLE_43_MINIMAL_PLAYABLE_CONTEXT_PATCH_PLAN.md`

Next battle blocker:
- `BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION`
- Need original Button MonoScript locations and serialized `targetGraphic` references before enabling input.

## Character Roster
Status: stronger data evidence generated; resource gaps remain.

Completed character results:
- DTSysPrefab direct raw decode succeeded from `clean_unityfs_slices/download/datatable/sys.assetbundle`.
- Decoded rows: `10302`
- Battle relevant ids: `20 / 20` found, missing `[]`
- `DTSysPrefab.txt` extracted via UnityPy high-level script is confirmed lossy and must not be used as decode source.
- Whole DTMonster candidate search checked 12 tables: Attr 6 skipped, non-Attr 6 searched.
- Search tables: `DTMonsterEntity`, `DTMonster_FEntity`, `DTMonster_GEntity`, `DTMonster_HEntity`, `DTMonster_KEntity`, `DTMonster_OEntity`.
- Enemy `1100111` resolves through `DTMonster_KEntity -> modelID/prefabId 3001`.
- Enemy `1100112/1100113/1100121/1100122/1100123/1100131/1100132/1100133` remain unresolved in all decoded non-Attr monster tables.

Current summary:
- actor loadable: `3 / 12`
- skill timeline resolved: `39 / 61`

Primary reports:
- `reports/characters/DTSYSPREFAB_DIRECT_DECODE_REPORT.md`
- `reports/characters/DTSYSPREFAB_BATTLE_RELEVANT_ROWS.csv`
- `reports/characters/GIRLSWAR_CHARACTER_ROSTER.md`
- `reports/characters/GIRLSWAR_CHARACTER_GAP_REPORT.md`

New character dispatch:
- Character worker was sent a follow-up to trace 1036 actor bundle presence in versionfile/CDN/raw/clean slices and search stage/wave/group alias evidence for unresolved enemy ids.

## Command Policy
- Root CMD count remains `1`: `00_COMMAND_CENTER.cmd`.
- `_restore_tools` direct CMD count remains `0`.
- New command wrappers remain under `_restore_tools/cmd_archive`.

## Control Tower Next
- Wait for UI worker final, then dispatch/perform UI124 home `Painting_1005` Spine mount.
- Wait for battle worker final, then dispatch/perform BATTLE44 original Button/targetGraphic serialization trace.
- Use character deep trace results to decide whether 1036/enemy resources can be loaded locally or must remain explicit gaps.
- Do not claim final restored state yet.
