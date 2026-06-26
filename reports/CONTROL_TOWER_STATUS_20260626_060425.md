# CONTROL_TOWER_STATUS_20260626_060425

Generated: 2026-06-26 06:04:25 KST

## Control Tower Summary

- Active restore goal is not complete.
- This round performed reference-only analysis of `C:\Users\godho\Downloads\참고.mp4`.
- No package import, manifest edit, package-lock edit, scene save, runtime instrumentation, network request, Unity asset import/copy, xLua patch, gameplay handler patch, fake HUD patch, fake actor patch, or coordinate-only success claim was performed.
- New source/reference output:
  - `reports/video_reference/REFERENCE_MP4_VISUAL_CHECKPOINT_MATRIX_20260626_060212.md`
  - `reports/video_reference/REFERENCE_MP4_VISUAL_CHECKPOINT_MATRIX_20260626_060212.json`
  - `reports/video_reference/REFERENCE_MP4_VISUAL_CHECKPOINT_MATRIX_20260626_060212.csv`
- Temporary extracted reference frames/contact sheet:
  - `work/reference_video/frames_5s/sample_000.jpg` through `sample_024.jpg`
  - `work/reference_video/reference_5s_contact_sheet.jpg`

## New Reference Finding

`참고.mp4` and the attached MainInterface reference image share the same wide layout class:

- `참고.mp4`: `1280x570`, aspect `2.2456`
- Attached MainInterface image: `1180x526`, aspect `2.2433`
- Current BATTLE51/BATTLE57 candidate captures: `1920x1080`, aspect `1.7778`

Therefore raw coordinates from the reference cannot be compared against the current 16:9 captures. At `1920px` width, an aspect-correct reference view height is about `855px`, not `1080px`.

This does not explain everything by itself. Current BATTLE57 still has additional route/layout issues:

- Reference top battle HUD sits around normalized `y~0.03-0.14`.
- Current BATTLE57 top HUD appears much lower, around normalized `y~0.19-0.28`.
- Reference bottom cards occupy `y~0.80-1.00` with full frames/icons.
- Current BATTLE57 mostly shows detached `오의` / `스킬` labels and glows, not complete five-card visuals.
- Reference battle shows full friendly/enemy formations; current BATTLE57 proves only a source-backed local actor subset.

## Checkpoint Outputs

The new reference matrix contains 10 checkpoints:

1. Main home aspect/layout.
2. Formation screen slots.
3. Normal battle top HUD.
4. Right battle control rail.
5. Bottom hero cards.
6. Friendly actor formation.
7. Enemy actor formation.
8. Skill white/black mask overlay.
9. Skill cinematic overlay.
10. TMP/text visual state.

## Updated Root Cause Split

1. Aspect/view-rect mismatch is now a first-order blocker for coordinate comparison.
2. HUD route placement is still wrong after accounting for aspect.
3. Bottom hero card assembly is incomplete: labels/glows survive, but full frames/icons are not reference-complete.
4. Actor payload remains a local subset, not full reference formation.
5. Skill playback remains blocked by Timeline type/binding/runtime context, not merely by missing particles.
6. MainInterface visual density is confirmed by both `참고.mp4` and the attached reference image, but active events/redpoints/account text still require approved runtime snapshot.

## Existing Blockers Still Standing

### UI / MainInterface

- Latest baseline: `reports/maininterface/MAININTERFACE_146_RUNTIME_SNAPSHOT_PROBE_SPEC_AND_SOURCE_HOOK_POINTS_NO_EXECUTION_NO_PATCH_RESULT.md`
- Need approved real runtime snapshot/dump for `UI_Dock` / `UI_MainPage` parent/group/depth/CanvasHelper cascade and UI130-compatible dynamic activity/account/chat/currency values.
- `참고.mp4` cannot supply runtime event/redpoint/account state.

### Battle / Timeline

- Latest baseline: `reports/battle/BATTLE_65_LOCAL_TIMELINE_PACKAGE_AVAILABILITY_AND_REVERSIBLE_CANDIDATE_PLAN_NO_IMPORT_NO_PATCH_RESULT.md`
- Local candidate exists: `C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Data\Resources\PackageManager\Editor\com.unity.timeline-1.8.12.tgz`
- Import/test still requires explicit approval.
- Even if Timeline type compatibility improves, no playability claim is allowed without original/source-backed `TimelineEffect`/PlayableDirector binding and handler execution.

### Actor Payload

- Latest baseline: `reports/characters/CHARACTER_64_LOCAL_EXACT_1036_BUNDLE_WIDER_PC_SEARCH_NO_NETWORK_NO_COPY_NO_IMPORT_RESULT.md`
- Exact `download/roleprefabsandres/battleprefabandres/1036.assetbundle` remains missing locally.
- Same-name `1036.assetbundle` files remain other categories and must not be promoted.

### Gameplay Runtime

- Original xLua/GameEntry/LuaManager and source-backed handler binding remain required.
- No no-op/fake handler can satisfy the playability requirement.

## Next Safe Work

- Before any coordinate/layout patch, normalize comparison to the `~2.24:1` reference view rect.
- Use `sample_007`/`35s` and `sample_012`/`60s` for normal-battle layout checks.
- Use `sample_013`/`65s`, `sample_015`/`75s`, and `sample_018`/`90s` only for skill overlay, Timeline, mask/stencil behavior.
- Keep the approval gate matrix active:
  - UI runtime snapshot.
  - Reversible local Timeline import/test.
  - Exact `1036` actor bundle acquisition/extraction.
  - Original xLua/GameEntry/LuaManager and TimelineEffect binding recovery.

