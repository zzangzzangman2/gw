# MainInterface Click Blocker Analysis

- Generated: 2026-06-25 13:18:58
- Source click validation: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_click_validation.csv`
- Source restore rules: `C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt`
- Output CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_click_blocker_analysis.csv`

## Summary

- Total Button components: 77
- Active Buttons: 24
- Inactive/source-state Buttons: 53
- Raycast-clickable Buttons: 24
- Active but blocked Buttons: 0
- Invoked click logs available: 24

## Blocker Categories

No active blocked buttons remain in the current click-validation pass.

| Category | Count | Restore decision |
|---|---:|---|

## Top Blocking Objects

No top blocking objects remain for active buttons.

| Raycast top object | Count |
|---|---:|

## Active Blocked Buttons

No active blocked buttons remain. Active buttons are all raycast-clickable in this pass.

| Button | Screen | Top blocker | Lua handler | Category |
|---|---:|---|---|---|

## Restore Order

1. Exclude `UI_bg`/touch-layer background hits from required gameplay button coverage, while keeping their source evidence.
2. Resolve transparent `btn_act` duplicates first, because they cause most blockers and can hide real side-menu controls.
3. Convert same-slot state stacks (`btnToggle*`, top menu alternatives) into explicit active/inactive screen states.
4. Disable raycast on decorative Image blockers after verifying they have no Lua handler, or bind their parent Button to the visible graphic.
5. Re-run `_restore_tools\37_VALIDATE_MAININTERFACE_BUTTON_CLICKS.cmd`, then `_restore_tools\39_ANALYZE_MAININTERFACE_CLICK_BLOCKERS.cmd` and `_restore_tools\04_VERIFY_MAININTERFACE_OUTPUTS.cmd`.

## Rule Check

- This report does not replace button logging; it uses the generated click-validation log and CSV as evidence.
- It avoids coordinate-only restoration by keeping Button component ids, Lua handler matches, and hierarchy paths where available.
- No source evidence is deleted or overwritten; this is a derived analysis file.
