# Control Tower Status 2026-06-26 01:17 KST

Final restored/playable claim: `false`.

## Reference Video

- `C:\Users\godho\Downloads\참고.mp4` was analyzed as auxiliary restore reference.
- Metadata: `1280x570`, `30fps`, about `121s`.
- Existing analysis package: `C:\Users\godho\Documents\Codex\2026-06-25\c-users-godho-downloads-girlswar-2\outputs\reference_video_analysis\REFERENCE_VIDEO_RESTORE_ANALYSIS.md`.
- Key battle comparison window: `19.0s-100.2s`.
- Best normal battle HUD references: `20.0s`, `29.0s`, `50.1s`, `58.4s`.
- Skill/cut-in reference window: `62.6s-84.0s`.
- `참고.mp4` is not a replacement for `플레이.mp4`; `플레이.mp4` remains missing when battle reports reference it.

## MainInterface

- Current reference target remains the 1005 home/lobby screen: night/moon background plus large 1005 character.
- Control tower patch already changed `UI_bg` to `PaintingBG_1005` and preserved row localScale, but restored claim remains `false` because hero character is still not mounted in the control-tower capture and route/world cluster remains visible.
- UI123 exported 1005 painting source, but the first UI124 mount failed:
  - report: `reports\maininterface\MAININTERFACE_124_MOUNT_HERO1005_HOME_SPINE_SKELETON_GRAPHIC_RESULT.md`
  - blocker: `Created Painting_1005_SkeletonData.asset, but SkeletonData did not load.`
- UI worker is currently continuing UI124 by extracting raw TextAssets:
  - report now present: `reports\maininterface\MAININTERFACE_124_HERO1005_SPINE_RAW_TEXTASSETS.md`
  - raw output: `girlswar_maininterface_unity\Assets\RestoreData\hero1005_spine_source_raw\paintingprefabandres_1005`
  - important finding: all 6 old UI123 TextAsset exports differ from raw bytes; old export had `256529` `?` bytes vs raw `28668`.
- Awaiting worker rerun of Unity mount using raw `.skel/.atlas` bytes.

## Battle

- BATTLE44 completed, restored/playable claim remains `false`.
- report: `reports\battle\BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION_RESULT.md`
- Original Button trace:
  - original Button MonoBehaviour count: `33`
  - patch-eligible battle Buttons: `20`
  - Empty4Raycast targetGraphic count: `7`
  - Image/YouYouImage targetGraphic count: `26`
- BATTLE44 patch result:
  - matched/applied Button mappings: `20 / 14`
  - reopen Button count: `14`
  - raycast-ready Button count: `0 / 0`
  - failure reason: `no_graphic_hits_at_target_center`
  - Empty4Raycast after/reopen: `7 / 2`
  - missing scripts before/reopen: `1208 / 1213`
- BATTLE45 dispatched to battle worker:
  - task: `BATTLE_45_TRACE_CANVAS_GRAPHIC_REGISTRY_CAMERA_AND_EMPTY4RAYCAST_RUNTIME_ENABLE`
  - focus: Empty4Raycast MonoScript persistence, Canvas/GraphicRaycaster/eventCamera, GraphicRegistry inclusion, and reopen-safe raycast-ready validation.

## Character/Data

- Deep trace completed:
  - `reports\characters\CHARACTER_RESOURCE_GAP_DEEP_TRACE.md`
  - `reports\characters\CHARACTER_RESOURCE_GAP_DEEP_TRACE.json`
- 1036 actor bundle state:
  - desired path: `download/roleprefabsandres/battleprefabandres/1036.assetbundle`
  - classification: `present_in_versionfile_but_not_extracted`
  - CDNVersionFile row: md5 `570c8238257cd8ca00a0856427d8c0ae`, size `1666251`, encrypted, version `1.0.578`, ResOffset `224`.
- Enemy payload alias remains unresolved:
  - classification: `still_unresolved_payload_instance_id`
  - no authoritative alias from `1100112/1100113/1100121...` to DTMonster rows was found.
- CHARACTER_1036_CDN_ACQUISITION_TRACE dispatched to character worker:
  - focus: determine whether an asset CDN base URL/download rule is locally evidenced.
  - no download is authorized without strong URL/path/md5/size/encryption evidence.

## Command Policy

- Root CMD count: `1`
- `_restore_tools` direct CMD count: `0`
- New wrappers must stay under `_restore_tools\cmd_archive`.

## Next Watch Points

1. Poll UI worker for raw-byte UI124 Unity rerun result.
2. Poll battle worker for BATTLE45 Empty4Raycast/GraphicRegistry results.
3. Poll character worker for 1036 CDN acquisition trace result.
4. Do not declare restored/playable until capture/contact sheet/input validation matches the reference and original evidence.
