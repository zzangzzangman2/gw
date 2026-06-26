# MAININTERFACE 135 Apply Source-Backed Hero1005 HomePara And Back/Front Layer Candidate Capture Result

Generated: 2026-06-26T03:36:26

## Verdict

- restoredClaim: `false`
- sceneSaved: `True`
- candidatePatchApplied: `true`
- productionPatchApplied: `false`
- patchDecision: `candidate_patch_homepara_noop_and_back_layer_probe_no_dock_patch`

UI135 applies only the decoded UIUtil Hero1005 lane. It does not touch bottom nav/UI_Dock, activity stack, chat/account/currency text, btn_discord, UI_bg raycast/interactable, or route/world nodes.

## Hero HomePara

- Existing UI128 candidate already had the Hero1005 child at local position `0,0,0` and scale `1,1,1`.
- UI135 rebuilt the old-root candidate with actual child name `Painting_1005` and applied decoded `homePara=[1,0,0]` to that child, not the `UI_heroSpine` parent.
- Result: no coordinate adjustment was introduced; this is a source-backed semantic no-op for Hero1005.

## Back/Front Probe

- `Painting_1005_back`: source atlas/skel/png exists, animation `A` exists, mounted as real `SkeletonGraphic` behind main.
- `Painting_1005`: source atlas/skel/png exists, animation `A` exists, mounted as real `SkeletonGraphic` main layer.
- `Painting_1005_front`: complete source triplet not found, so no front layer was created.
- No whole atlas Image, flat sprite substitute, fake spine, or screenshot paste was used.
- Visual verdict: the back layer probe renders, but it overpaints/worsens the reference metrics; do not promote this mount without original prefab transform/order evidence.

## Diff

| comparison | full corr | full meanAbsDiff | hero corr | hero meanAbsDiff |
| --- | ---: | ---: | ---: | ---: |
| UI128 vs reference | 0.424216 | 0.209078 | 0.475187 | 0.184641 |
| UI135 vs reference | 0.153161 | 0.313657 | 0.034676 | 0.330950 |

## Click Validation

- total/active/clickable/blocked: `55 / 45 / 43 / 2`
- click CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_135_click_validation.csv`
- click JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_135_click_validation_summary.json`

## Outputs

- capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui135_hero1005_homepara_backfront_candidate_1680x720.png`
- contact PNG: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_135_REFERENCE_DIFF_CONTACT.png`
- region diff CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_135_reference_diff_regions.csv`
- hero transform CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_135_hero_transform_before_after.csv`
- back/front layer CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_135_back_front_layer_evidence_probe.csv`
- JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_135_APPLY_SOURCE_BACKED_HERO1005_HOMEPARA_AND_BACK_FRONT_LAYER_CANDIDATE_CAPTURE_NO_DOCK_PATCH_RESULT.json`

## Command Policy

- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- policyOk: `True`

## Next Blocker

- UI_Dock/bottom nav open-stack remains separate and was not patched here.
- Activity/account runtime snapshot is still required before activity/text/icon/spine changes.
- Back layer is now a source-backed candidate, but final restored claim remains false until full reference match and click validation converge.
