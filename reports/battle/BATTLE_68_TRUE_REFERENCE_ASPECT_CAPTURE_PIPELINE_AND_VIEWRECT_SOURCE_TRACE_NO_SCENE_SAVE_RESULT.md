# BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE Result

## Verdict
- `restoredClaim=false`, `playableClaim=false`.
- `trueReferenceAspectCaptureGenerated=true`.
- No scene, package, manifest, xLua, handler, layout, HUD/card/actor/effect, APK/emulator, or runtime instrumentation mutation was performed.
- BATTLE67 crop remains analysis-only and was not used as final capture.

## Aspect Target
- Reference aspect: `2.2456`.
- Candidate true capture sizes: `1280x570` or `1920x855`.

## Capture Pipeline Finding
- BATTLE57 actor-rehydration path is source-backed but CaptureWidth=1920/CaptureHeight=1080 and output filenames are 1920x1080.
- BATTLE57 public Build saves scene to Assets/Scenes/Battle57RuntimeRehydratedAssetBundleActorsCandidate.unity.
- BATTLE51 contains an internal RenderCamera(camera,width,height,path), but the public Build calls it with 1920x1080 and also saves the scene.
- Earlier raycast/depth probes include 640x480 camera render passes for registry/depth, not reference-aspect visual capture.
- No existing public no-scene-save executeMethod was found that opens the BATTLE57/BATTLE51 context and writes 1280x570 or 1920x855.

## Source-Backed Candidate
- A safe candidate exists as a capture-only Editor executeMethod that opens the existing BATTLE57/BATTLE51 candidate scene, renders the capture camera to a reference-aspect RenderTexture, restores `camera.targetTexture`, writes only capture/report outputs, and does not call `SaveScene`.
- True capture path: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle68TrueReferenceAspectNoSceneSave_1920x855.png`.
- True capture size/aspect: `{'width': 1920, 'height': 855, 'aspect': 2.245614}`.

## Blockers Kept Separate
- True viewrect/capture pipeline: generated; route/card/actor validation remains next.
- Route active/sibling/layout patch: pending true capture.
- Card/icon payload: still pending; no fake cards/icons.
- Full actor payload: still pending beyond BATTLE57 local subset.
- Timeline/xLua: still pending and outside this no-patch task.

## Outputs
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE_CAPTURE_PIPELINE_CONSTANTS_EVIDENCE_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE_CAMERA_CANVAS_VIEWRECT_CANDIDATE_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE_TRUE_CAPTURE_OUTPUT_VALIDATION_OR_BLOCKER_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE_DECISION_NEXT_ACTION_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE_RESULT.json`

## Command Policy
- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- policy ok: `True`
