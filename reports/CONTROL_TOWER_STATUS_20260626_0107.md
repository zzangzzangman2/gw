# Control Tower Status 2026-06-26 01:07 KST

## Scope
- Root: `C:\Users\godho\Downloads\girlswar`
- Reference image: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- Auxiliary battle video: `C:\Users\godho\Downloads\참고.mp4`
- Missing video remains missing: `C:\Users\godho\Downloads\플레이.mp4`
- Final restored/playable claim: `false`

## Worker Threads
- UI worker: `019eff6c-a02a-7f73-9ffb-74456322d1ce`
- Battle worker: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`
- Character worker: `019eff6d-307b-7532-8b1d-7105b18cd6b7`

## MainInterface
Status: improved, not restored.

Confirmed changes already in the main worktree:
- `MainInterfaceSceneBuilder.ApplyRectRow` now preserves source `localScale`.
- `CaptureMainInterfaceScene()` rebuilds the scene before capture.
- `UI_bg` override now points to the evidence-backed 1005 background: `PaintingBG_1005`.
- Latest capture `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png` uses the night/moon 1005 background.

Latest UI123 result:
- `maininterface_restored_1680x720.png` still mismatches the reference: meanAbsDiff `65.733`.
- `UI_heroSpine` is active but effectively empty: `empty_sprite_ref`, alpha `0.0`, size/children missing.
- Normal home Lua path is `UIUtil.GetPlayerBigSpineAll(i, UI_heroSpine, "homePara")` plus `GetPaintingBg(i)`.
- Evidence-backed home hero source is `download/roleprefabsandres/paintingprefabandres/1005.assetbundle`.
- UI123 exported original 1005 home Spine source under `girlswar_maininterface_unity\Assets\RestoreData\hero1005_spine_source`.
- `Painting_1005.png` is a Spine atlas page and must not be used as a whole UI Image.

Key UI123 reports:
- `reports/maininterface/MAININTERFACE_123_HERO1005_HOME_SPINE_ROUTE_ACTIVE_TRACE_RESULT.md`
- `reports/maininterface/MAININTERFACE_123_HERO1005_HOME_SPINE_SOURCE_EXPORT_RESULT.md`
- `reports/maininterface/MAININTERFACE_123_hero1005_spine_source_export.csv`

Route/world state:
- `right`, `node_middle`, `wanfaWorldNode`, and `worldwanfaBtn` remain active in prefab/runtime evidence.
- Decoded Lua only gives dynamic hide/show evidence for `mian_wanfa_item_3/4`, not for hiding the whole route/world cluster.
- Arbitrary route hide remains disallowed.

UI124 dispatch:
- Sent to UI worker at 01:07 KST.
- Task: `MAININTERFACE_124_MOUNT_HERO1005_HOME_SPINE_SKELETON_GRAPHIC`.
- Goal: build/import `SpineAtlasAsset + SkeletonDataAsset + SkeletonGraphic` from `Painting_1005.atlas.txt`, `Painting_1005.skel.bytes`, and `Painting_1005.png`, then mount under `UI_heroSpine`.
- Must keep restored claim false unless capture and diff prove the result.

## Battle
Status: improved, not restored/playable.

Latest completed battle result remains BATTLE43:
- BATTLE42 HUD persistence succeeded earlier: reopen `Image/Graphic` stayed `232/232`.
- BATTLE43 preserved HUD visuals and added persistent interaction plumbing.
- BATTLE42 -> BATTLE43 capture similarity: meanAbsDiff `0.0`, pixelCorrelation `1.0`.
- `GraphicRaycaster` reopen: `9`.
- `Button` reopen: `10`.
- `raycast-ready Button`: `0`.
- Failure reason: `no_graphic_hits_at_button_center` for all sampled button centers.
- Mask/RectMask2D: `0/0`.
- TMP/Text: `0/0`.
- missing scripts: `1208`.
- actor runtime root: `0`.

Battle worker is actively running BATTLE44:
- Task: `BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION`.
- Current worker finding: original key buttons such as `btnAuto`, `btnTwoSpeed`, `btnFastSkill`, and `btnBuff` target `UnityEngine.UI.Empty4Raycast`.
- Interpretation: BATTLE43 put Button components on visible child Images, but original input geometry uses empty raycast Graphics.
- Intended patch: restore original Button root plus Empty4Raycast targetGraphic mapping, without fake onClick handlers or fake visuals.
- No `BATTLE_44_*` report was visible on disk yet at this timestamp.

Key completed battle reports:
- `reports/battle/BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_RESULT.md`
- `reports/battle/BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING_RESULT.md`
- `reports/battle/BATTLE_43_MINIMAL_PLAYABLE_CONTEXT_PATCH_PLAN.md`

## Character/Data
Status: stronger evidence generated; gaps remain.

Completed base data results:
- DTSysPrefab direct raw decode succeeded from `clean_unityfs_slices/download/datatable/sys.assetbundle`.
- Decoded DTSysPrefab rows: `10302`.
- Battle-relevant DTSysPrefab ids: `20/20` found.
- Extracted `6885155417360981632_DTSysPrefab.txt` is lossy and must not be used as decode input.
- DTMonster search covers 12 candidate tables: 6 Attr tables skipped, 6 non-Attr `modelID` tables searched.
- Enemy `1100111` resolves through `DTMonster_KEntity -> modelID/prefabId 3001`.
- Enemy `1100112/1100113/1100121/1100122/1100123/1100131/1100132/1100133` remain unresolved in decoded non-Attr monster tables.

Character deep trace result:
- `1036` actor bundle classification: `present_in_versionfile_but_not_extracted`.
- Desired exact bundle: `download/roleprefabsandres/battleprefabandres/1036.assetbundle`.
- CDNVersionFile exact rows: `1`.
- Extracted assetbundle index exact rows: `0`.
- Exact local files: `0`.
- Same filename bundles exist in other categories such as `rolebigsetpainting/1036` and `skillprefabsandres/1036`, but they are not the battle actor bundle.
- Enemy payload alias classification: `still_unresolved`.
- Payload enemy ids look formula-like (`mapId + wave + slot`), but no authoritative code path was found that aliases them to `DTMapsWave.monsterLists`.

Key character reports:
- `reports/characters/DTSYSPREFAB_DIRECT_DECODE_REPORT.md`
- `reports/characters/GIRLSWAR_CHARACTER_ROSTER.md`
- `reports/characters/GIRLSWAR_CHARACTER_GAP_REPORT.md`
- `reports/characters/CHARACTER_RESOURCE_GAP_DEEP_TRACE.md`
- `reports/characters/CHARACTER_RESOURCE_GAP_DEEP_TRACE.json`

## Command Policy
- Root CMD count: `1` (`00_COMMAND_CENTER.cmd`)
- `_restore_tools` direct CMD count: `0`
- New command wrappers stay under `_restore_tools\cmd_archive`

## Next Control Actions
- Wait for UI124 result, then verify whether a real `SkeletonGraphic` character appears in the capture.
- Wait for BATTLE44 result, then check whether Empty4Raycast targetGraphic mapping increases raycast-ready buttons.
- Use character deep trace as the current authoritative resource-gap status for 1036 actor and unresolved enemy payload ids.
- Keep all success language guarded until fresh captures/contact sheets and input checks prove the screen.
