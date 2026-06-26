# CONTROL_TOWER_DISPATCH_20260626_060745

Generated: 2026-06-26 06:07:45 KST

## Summary

The active restore goal is not complete. This dispatch only assigns the next no-patch/source-only work based on the newly established `~2.24:1` reference aspect evidence from `참고.mp4` and the attached MainInterface image.

No package import, manifest edit, scene save, runtime instrumentation, network request, file copy/import/move/delete, xLua patch, gameplay handler patch, MainInterface patch, fake HUD/card/icon/text/spine/actor/effect, screenshot/atlas paste, or coordinate-only success claim was performed by this control dispatch.

## Newly Dispatched Worker Tasks

### Battle Worker

- Thread: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`
- Task: `BATTLE_66_ASPECT_CORRECT_VIEWRECT_ROUTE_HUD_CARD_ACTOR_LAYOUT_VALIDATION_NO_PATCH`
- Purpose: Validate current battle candidate layout against the `~2.24:1` reference view class before any coordinate/layout patch is allowed.
- Required source inputs:
  - `reports/CONTROL_TOWER_STATUS_20260626_060425.md`
  - `reports/video_reference/REFERENCE_MP4_VISUAL_CHECKPOINT_MATRIX_20260626_060212.md/json/csv`
  - `reports/battle/BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_*`
  - `reports/battle/BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_RESULT.md/json`
  - `girlswar_battle_unity/Assets/RestoreCaptures/battle_actor/Battle57RuntimeRehydratedAssetBundleActorsCandidate_1920x1080.png`
- Expected outputs:
  - `reports/battle/BATTLE_66_ASPECT_CORRECT_VIEWRECT_ROUTE_HUD_CARD_ACTOR_LAYOUT_VALIDATION_NO_PATCH_RESULT.md`
  - `reports/battle/BATTLE_66_ASPECT_CORRECT_VIEWRECT_ROUTE_HUD_CARD_ACTOR_LAYOUT_VALIDATION_NO_PATCH_RESULT.json`
  - CSVs for reference-vs-current normalized layout, camera/canvas scaler/render aspect evidence, blocker separation, and next action.
- Guardrail: no scene save, no package import, no fake HUD/card/actor/effect, no xLua/handler patch, no playability claim.

### UI Worker

- Thread: `019eff6c-a02a-7f73-9ffb-74456322d1ce`
- Task: `MAININTERFACE_147_REFERENCE_ASPECT_CAPTURE_ROOTCAUSE_CONSOLIDATION_NO_PATCH`
- Purpose: Determine how much of the MainInterface visual mismatch is aspect/capture framing versus source-root/form-stack/runtime-state issues.
- Required source inputs:
  - `reports/CONTROL_TOWER_STATUS_20260626_060425.md`
  - `reports/video_reference/REFERENCE_MP4_VISUAL_CHECKPOINT_MATRIX_20260626_060212.md/json/csv`
  - `reports/maininterface/MAININTERFACE_146_RUNTIME_SNAPSHOT_PROBE_SPEC_AND_SOURCE_HOOK_POINTS_NO_EXECUTION_NO_PATCH_RESULT.md/json`
  - `reports/maininterface/MAININTERFACE_146_runtime_snapshot_template.json`
  - latest MainInterface comparison reports/captures under `reports/maininterface` and `girlswar_maininterface_unity/Assets/RestoreCaptures`
  - attached reference image `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- Expected outputs:
  - `reports/maininterface/MAININTERFACE_147_REFERENCE_ASPECT_CAPTURE_ROOTCAUSE_CONSOLIDATION_NO_PATCH_RESULT.md`
  - `reports/maininterface/MAININTERFACE_147_REFERENCE_ASPECT_CAPTURE_ROOTCAUSE_CONSOLIDATION_NO_PATCH_RESULT.json`
  - CSVs for candidate capture aspect, visible mismatch vs runtime snapshot requirement, and root-cause/next-action decision.
- Guardrail: no scene patch, no runtime/APK/emulator execution, no fake snapshot values, no guarded node hide, no `UI_bg` raycast/interactable edit.

## Control Rationale

The latest control evidence says:

- Reference video: `1280x570`, aspect `2.2456`.
- Attached MainInterface reference image: `1180x526`, aspect `2.2433`.
- Current BATTLE51/BATTLE57 captures: `1920x1080`, aspect `1.7778`.
- At `1920px` width, a reference-equivalent content height is about `855px`, not `1080px`.

This makes aspect/view-rect normalization a prerequisite for any coordinate comparison. It does not remove the existing blockers:

- UI still requires approved original-runtime snapshot/dump for form stack, depth, CanvasHelper cascade, active guarded nodes, `UI_bg`, dynamic activity/account/chat/currency values.
- Battle still requires approved Timeline package import/test or original TimelineEffect binding context.
- Actor payload still lacks exact local `download/roleprefabsandres/battleprefabandres/1036.assetbundle`.
- Gameplay still requires original/source-backed xLua/GameEntry/LuaManager handlers.

## Next Control Action

Wait for BATTLE66 and UI147 worker outputs, then reconcile:

1. Whether the reference/candidate aspect mismatch is enough to explain any visible drift.
2. Which mismatch rows remain after aspect normalization.
3. Whether any future patch proposal is source-backed, runtime-gated, or forbidden-to-guess.
4. Whether the approval gate matrix needs to be amended.

