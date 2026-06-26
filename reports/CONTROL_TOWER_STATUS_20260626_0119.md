# Control Tower Status 2026-06-26 01:19 KST

Final restored/playable claim: `false`.

## Reference Video

- `C:\Users\godho\Downloads\참고.mp4` analysis is complete and remains auxiliary reference only.
- Analysis report: `C:\Users\godho\Documents\Codex\2026-06-25\c-users-godho-downloads-girlswar-2\outputs\reference_video_analysis\REFERENCE_VIDEO_RESTORE_ANALYSIS.md`
- Video facts: `1280x570`, `30fps`, about `121s`.
- Best battle HUD reference frames: `20.0s`, `29.0s`, `50.1s`, `58.4s`.
- Skill/cut-in reference window: `62.6s-84.0s`.
- `플레이.mp4` is still missing and must not be implied as available.

## MainInterface / UI124

- UI124 now has a real Hero1005 `SkeletonGraphic` mount.
- Restored claim remains `false`.
- Reports:
  - `reports\maininterface\MAININTERFACE_124_HERO1005_SPINE_RAW_TEXTASSETS.md`
  - `reports\maininterface\MAININTERFACE_124_MOUNT_HERO1005_HOME_SPINE_SKELETON_GRAPHIC_RESULT.md`
  - `reports\maininterface\MAININTERFACE_124_REFERENCE_DIFF_RESULT.md`
  - `reports\maininterface\MAININTERFACE_124_SPINE_UNITY_API_EVIDENCE.md`
- Raw TextAsset fix:
  - old UI123 export differed from raw bytes for all 6 TextAssets.
  - old export had `256529` replacement `?` bytes; raw export has `28668`.
  - raw folder: `girlswar_maininterface_unity\Assets\RestoreData\hero1005_spine_source_raw\paintingprefabandres_1005`
- Mount evidence:
  - Spine runtime: `spine-unity` / `spine-csharp` present.
  - API path used: `SpineAtlasAsset.CreateRuntimeInstance`, `SkeletonDataAsset.CreateRuntimeInstance`, `SkeletonGraphic.NewSkeletonGraphicGameObject`.
  - `Painting_1005.png` is used only as atlas texture, not as a whole UI Image.
  - animation: `A`, loop `true`.
  - skeleton loaded: `bones=430`, `slots=200`, `animations=4`.
- Capture:
  - `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui124_hero1005_spine_1680x720.png`
  - hero-only capture visible pixels: `244615`.
- Remaining UI blocker:
  - normal-home state reconstruction is still wrong.
  - route/world cluster remains active.
  - `rightSiblingIndex=3` and `heroParentSiblingIndex=1`, so route draws above the hero by sibling-order evidence.
  - reference diff remains poor; full pixel correlation `0.188564`.
- UI worker is still active, preparing final UI124 handoff.

## Battle / BATTLE45

- BATTLE44 completed with final/playable claim `false`.
- BATTLE45 is active.
- New BATTLE45 finding:
  - BATTLE44 scene stored `Empty4Raycast` blocks with `m_EditorClassIdentifier: Assembly-CSharp::UnityEngine.UI.Empty4Raycast`.
  - This appears to be unstable MonoScript persistence from `BattleUIComponentTypeStubs.cs` multi-class storage.
  - Battle worker split `UnityEngine.UI.Empty4Raycast` into dedicated `girlswar_battle_unity\Assets\Scripts\Empty4Raycast.cs`.
- BATTLE45 is now building the save/reopen/GraphicRegistry/raycast verification pipeline.
- No BATTLE45 final report yet.

## Character / 1036 CDN Trace

- CHARACTER_1036_CDN_ACQUISITION_TRACE is active.
- Character worker is building a bounded analysis script after broad file search proved noisy.
- Current target remains:
  - exact missing actor path: `download/roleprefabsandres/battleprefabandres/1036.assetbundle`
  - versionfile evidence: md5 `570c8238257cd8ca00a0856427d8c0ae`, size `1666251`, encrypted, version `1.0.578`, ResOffset `224`.
- No download is authorized.
- No final CDN trace report yet.

## Command Policy

- Root CMD count: `1`
- `_restore_tools` direct CMD count: `0`
- Command policy remains clean.

## Next Watch Points

1. Wait for UI124 final handoff; likely next UI task is evidence-backed normal-home active/sibling reconstruction, not hero mount.
2. Wait for BATTLE45 final report; if Empty4Raycast persistence succeeds, next blocker should move to actual GraphicRaycaster hits or onClick/runtime binding.
3. Wait for CHARACTER_1036_CDN_ACQUISITION_TRACE; classify fetchability strictly from local evidence.
