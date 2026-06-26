# Control Tower Status 2026-06-26 01:20 KST

Final restored/playable claim: `false`.

## Reference Video

- `C:\Users\godho\Downloads\참고.mp4` analysis is complete.
- Analysis report: `C:\Users\godho\Documents\Codex\2026-06-25\c-users-godho-downloads-girlswar-2\outputs\reference_video_analysis\REFERENCE_VIDEO_RESTORE_ANALYSIS.md`
- Key battle HUD window: `19.0s-100.2s`.
- Best normal battle HUD frames: `20.0s`, `29.0s`, `50.1s`, `58.4s`.
- Skill/cut-in window: `62.6s-84.0s`.
- `참고.mp4` is auxiliary reference only. `플레이.mp4` remains missing.

## MainInterface

- UI124 completed.
- Hero1005 now renders through real Spine:
  - `SpineAtlasAsset + SkeletonDataAsset + SkeletonGraphic`
  - animation `A`, loop `true`
  - skeleton loaded: `bones=430`, `slots=200`, `skins=1`, `animations=4`
  - `Painting_1005.png` is atlas texture only, not whole UI Image.
- UI124 fixed the previous source issue by using raw TextAsset exports:
  - report: `reports\maininterface\MAININTERFACE_124_HERO1005_SPINE_RAW_TEXTASSETS.md`
  - old text export had `256529` replacement `?` bytes; raw export has `28668`.
- UI124 capture exists:
  - `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui124_hero1005_spine_1680x720.png`
  - `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui124_hero1005_spine_hero_only_1680x720.png`
- UI124 still fails reference match:
  - route/world cluster remains visible.
  - `rightSiblingIndex=3` > `UI_heroSpine=1`, so route draws above hero.
  - full pixel correlation with reference: `0.188564`.
- UI124 handoff:
  - `reports\maininterface\MAININTERFACE_124_CONTROL_TOWER_HANDOFF.md`
- UI125 dispatched:
  - task: `MAININTERFACE_125_NORMAL_HOME_STATE_AND_LAYER_RECONSTRUCTION`
  - focus: preserve Hero1005 mount, reconstruct normal-home active state/layering from Lua/prefab/runtime evidence only.
  - `zhuye_di1/zhuye_bian` remain protected from arbitrary hide.

## Battle

- BATTLE45 is active.
- BATTLE45 early finding:
  - BATTLE44 `Empty4Raycast` stored as `m_EditorClassIdentifier: Assembly-CSharp::UnityEngine.UI.Empty4Raycast`.
  - This points to unstable MonoScript persistence from multi-class `BattleUIComponentTypeStubs.cs`.
  - Battle worker split `Empty4Raycast` into dedicated `girlswar_battle_unity\Assets\Scripts\Empty4Raycast.cs`.
- Awaiting BATTLE45 save/reopen/GraphicRegistry/raycast report.

## Character/Data

- CHARACTER_1036_CDN_ACQUISITION_TRACE is active.
- Worker is converting broad search into bounded script output.
- No download authorized.
- Awaiting `CHARACTER_1036_CDN_ACQUISITION_TRACE` report.

## Command Policy

- Root CMD count: `1`
- `_restore_tools` direct CMD count: `0`

## Next

1. Poll UI125 for normal-home state evidence and capture.
2. Poll BATTLE45 for Empty4Raycast persistence and raycast-ready count.
3. Poll character worker for 1036 CDN fetchability classification.
