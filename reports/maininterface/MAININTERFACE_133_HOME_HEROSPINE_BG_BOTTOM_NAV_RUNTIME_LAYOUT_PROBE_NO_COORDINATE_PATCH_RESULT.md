# MAININTERFACE 133 Home HeroSpine BG Bottom Nav Runtime Layout Probe Result

Generated: 2026-06-26T03:19:01

## Verdict

- restoredClaim: false
- scenePatchApplied: false
- candidatePatchApplied: false
- patchDecision: no_scene_patch

UI133 did not apply a coordinate/layout patch. The candidate already has the source-backed Hero1005 SkeletonGraphic and BG1005 binding, but the missing evidence is still runtime layout semantics: `UIUtil.GetPlayerBigSpineAll(..., "homePara")` transform handling and old-root bottom navigation Animator/canvas/layer state.

## Region Diff

| region | corr | meanAbsDiff | changed30 |
| --- | ---: | ---: | ---: |
| full | 0.424216 | 0.209078 | 0.701510 |
| center_hero_background | 0.475187 | 0.184641 | 0.613330 |
| bottom_nav | 0.395621 | 0.190902 | 0.683050 |
| right_icon_chat | 0.414567 | 0.218707 | 0.715093 |
| click_blocker_ui_bg_touch | 0.424216 | 0.209078 | 0.701510 |
| click_blocker_btn_discord | 0.493905 | 0.208914 | 0.716693 |

## Hero/BG Probe

- Probe rows: 422
- Hero SkeletonGraphic rows: 1
- UI_bg raycast targets: 1
- UI_touchSpine active rows: 1

Key observations:
- `UI_bg` is active, sibling index 0, uses `runtime_UI_bg_noalphabg_PaintingBG_1005`, and remains a raycast target. No source-backed raycast-off evidence was found, so it was not changed.
- `UI_heroSpine` is active at sibling index 1, with `Restore_Hero1005_Painting_1005_UI126` below it as a real `SkeletonGraphic`; the SkeletonGraphic itself has raycast disabled.
- `UI_touchSpine` is active at sibling index 2 and raycast-enabled, matching the known default home branch evidence that activates `UI_touchSpine`.
- `homePara=[1,0,0]` remains source-backed from DTmodelEntity, but its scale/x/y application could not be proven from decoded UIUtil, so no hero transform patch was applied.

## Bottom Nav Probe

- Probe rows: 20
- Active rows: 20
- Active interactable buttons: 3

Key observations:
- The old-root candidate does not expose the new-root `node_bottom/toogles/btnToggle*` stack as an active bottom strip in this candidate scene.
- The lower/right navigation candidates currently visible are old-root buttons such as shop/mail/friends/ranking and left banner/download entries; they are not enough to justify a static bottom-strip layer patch.
- Activity slot, face activity, and dynamic text/icon/spine edits remain blocked by the missing runtime snapshot pipeline from UI130.

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_133_HOME_HEROSPINE_BG_BOTTOM_NAV_RUNTIME_LAYOUT_PROBE_NO_COORDINATE_PATCH_RESULT.json`
- Hero/BG probe CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_133_hero_bg_probe.csv`
- Bottom nav probe CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_133_bottom_nav_probe.csv`
- Region diff CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_133_reference_diff_regions.csv`
- Contact PNG: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_133_REFERENCE_DIFF_CONTACT.png`

## Changed Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\Editor\MainInterface133HeroBgBottomNavLayoutProbe.cs`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\Editor\MainInterface133HeroBgBottomNavLayoutProbe.cs.meta`
- `C:\Users\godho\Downloads\girlswar\_restore_tools\scripts\maininterface133_hero_bg_bottom_nav_diff_report.py`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_133_unity_probe_summary.json`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_133_hero_bg_probe.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_133_bottom_nav_probe.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_133_reference_diff_regions.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_133_REFERENCE_DIFF_CONTACT.png`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_133_HOME_HEROSPINE_BG_BOTTOM_NAV_RUNTIME_LAYOUT_PROBE_NO_COORDINATE_PATCH_RESULT.json`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_133_HOME_HEROSPINE_BG_BOTTOM_NAV_RUNTIME_LAYOUT_PROBE_NO_COORDINATE_PATCH_RESULT.md`

## Command Policy

- root `.cmd` count: 1
- `_restore_tools` direct `.cmd` count: 0
- policyOk: true

## Next Blocker

- Decode or recover UIUtil.GetPlayerBigSpineAll transform semantics for homePara before moving/scaling Hero1005.
- Recover old-root bottom navigation runtime/Animator state or original open-stack layer proof before applying bottom strip/order patches.
- Runtime activity/account snapshot remains required before activity slot/icon/text visibility changes.
