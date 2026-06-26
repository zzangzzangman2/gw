# MAININTERFACE_131 Source-Backed Static Patch Plan (No Scene Patch Applied)

## Allowed Candidate Lane

Only `text/TMP/font material` is classified as `source_backed_static_patch_possible`, and only for static labels whose original text node and material binding are already source-identified.

## Required Before Any Patch

- Build a node-level list of static text objects, excluding activity slots, chat/runtime names/messages, player/account/currency values, and any server-driven label.
- Join those nodes to `maininterface_tmp_shared_materials.csv` and DTLangCommon/static Lua evidence.
- Run a candidate-only scene after material binding, then capture/diff/click validate.

## Explicitly Not Allowed

- Activity slot hide/label/icon/spine changes before UI130 snapshot replay succeeds.
- `btn_discord` review hide.
- `UI_bg` raycast/interactable off.
- Fake chat/top currency/player/account text.
- Coordinate-only bottom nav/hero alignment.
- Screenshot or whole-atlas paste.

No UI131 scene patch was applied.
