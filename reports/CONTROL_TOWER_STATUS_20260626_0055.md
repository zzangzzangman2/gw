# Control Tower Status 2026-06-26 00:55 KST

## Threads
- control tower: current thread
- UI worker: `019eff6c-a02a-7f73-9ffb-74456322d1ce`
- battle worker: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`
- character roster worker: `019eff6d-307b-7532-8b1d-7105b18cd6b7`

## MainInterface
Status: improved, not restored.

Applied in control tower:
- `girlswar_maininterface_unity/Assets/Editor/MainInterfaceSceneBuilder.cs`
  - `ApplyRectRow` now preserves original `row.localScale`, including zero scale. This removes the global zero-scale revival bug.
  - `CaptureMainInterfaceScene()` now always calls `BuildMainInterfaceScene()` before capture, so CSV/code changes do not silently reuse a stale scene.
- `girlswar_maininterface_unity/Assets/RestoreData/maininterface_visual_overrides.csv`
  - `UI_bg` override changed from hardcoded `PaintingBG_1001` to reference-matching `PaintingBG_1005`.
- Added `girlswar_maininterface_unity/Assets/RestoredSprites/maininterface/runtime_dynamic/runtime_UI_bg_noalphabg_PaintingBG_1005.png`.

Verified:
- Rebuilt and captured `girlswar_maininterface_unity/Assets/RestoreCaptures/maininterface_restored_1680x720.png`.
- New capture now shows the 1005 moon/night background instead of the daylight castle background.
- Latest build result generated at `2026-06-26 00:50:51`.
- Latest click validation generated at `2026-06-26 00:53:17`.
- Click validation remains `24/77` raycast-clickable, `blocked=0`, `invoked=24`.

Still failing:
- `UI_heroSpine` / Live2D / Spine runtime character is still not restored.
- `right/node_middle/wanfaWorldNode/worldwanfaBtn` route/world cluster is still active in the capture.
- The screen still does not match the reference lobby image, so final restored claim remains false.

Next UI blocker:
- Evidence-backed hero 1005 home Spine/Live2D reconstruction.
- Evidence-backed normal-home active-state decision for `right/node_middle/wanfaWorldNode`, without arbitrary hide of UI121 pre-clipping route attachments.

## Battle
Status: improved, not restored/playable.

Battle worker completed:
- BATTLE41 confirmed the BATTLE29 fresh HUD had visible `Image` rows, but reopen dropped `Image/Graphic` to `0/0`.
- BATTLE42 rebuilt persistent HUD `UnityEngine.UI.Image` components from original `BattleHudExtractedSpriteBindingMarker25` evidence.

Verified BATTLE42:
- marker rows: `232`
- reconstructed Image components: `232`
- reopen Image/Graphic/active Graphic: `232 / 232 / 56`
- imported persistent Sprite assets: `76`
- final playable claim remains false.

Primary report:
- `reports/battle/BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES_RESULT.md`

Next battle blocker:
- `BATTLE_43_VALIDATE_MASK_STENCIL_TMP_BUTTON_AND_RUNTIME_FORMATION_SKILL_BINDING`

## Character Roster
Status: first evidence roster generated.

Character worker completed:
- `reports/characters/GIRLSWAR_CHARACTER_ROSTER.json`
- `reports/characters/GIRLSWAR_CHARACTER_ROSTER_ACTORS.csv`
- `reports/characters/GIRLSWAR_CHARACTER_ROSTER_SKILLS.csv`
- `reports/characters/GIRLSWAR_CHARACTER_GAP_REPORT.md`

Current roster summary:
- loadable actor bundles: `3/12`
  - our `1002`
  - our `1034`
  - enemy `1100111 -> DTMonster_KEntity -> model/prefab 3001`
- skill timeline-resolved rows: `39/61`
- passive gaps are separated from active timeline gaps.

Next character blocker:
- Decode or safely map `DTSysPrefab` direct `GetSysprefabData` table.
- Expand all `DTMonster_*` variants to resolve `1100112/1100113/1100121...` enemy gaps.

## Command Policy
- Root CMD count remains `1`: `00_COMMAND_CENTER.cmd`.
- `_restore_tools` direct CMD count remains `0`.
- New command wrappers are under `_restore_tools/cmd_archive`.

## Control Tower Dispatch
Follow-up prompts were sent to all three worker threads after the above updates:
- UI: continue hero 1005 and route active-state evidence.
- Battle: proceed with BATTLE43.
- Character: decode DTSysPrefab and expand monster variants.
