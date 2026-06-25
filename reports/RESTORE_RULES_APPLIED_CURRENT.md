# Restore Rules Applied Current

Generated: 2026-06-25 18:55 KST

## Source Rule File Status

- Expected source file: `C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt`
- Current disk search result: not found under `C:\Users\godho\Downloads`.
- Until the original text file is restored, every UI/Battle task must still enforce the rules below. These rules are also repeated in delegated UI/Battle prompts.

## Hard Gates

- Do not restore by coordinates only.
- Preserve original hierarchy, RectTransform anchors, pivot, size, localScale, sibling order, Canvas, and CanvasScaler unless a report records exact evidence for a change.
- Do not place a whole atlas as an Image. Use only original Sprite/PPtr/slice/region evidence.
- Do not use fake HUD, fake icons, arbitrary panels, debug labels, evidence labels, asset-path text, or placeholder overlays in final captures.
- If a capture is black, white, placeholder-heavy, or debug-text-heavy, mark it failed.
- For buttons, validate raycast/clickability through logs/JSON, not just by visual placement.
- Use graphics capture for visual verification. Do not rely only on headless/non-graphics counts.
- Work one target/blocker at a time and record the next blocker explicitly.
- Do not delete or move original/evidence files such as XAPK, OBB, extracted bundles, decoded Lua, IL2CPP dumps, or raw TextAssets until coverage and usage are documented.

## Current Extra Visual Gates

- MainInterface/GuildMain: `UI_GuildMain` is not normal while whiteish visible ratio remains high or large white panels remain.
- Battle HUD: `Graphic count`, top/bottom/right screen-zone presence, or `camera_visible_hud=true` is not enough.
- Battle HUD must be compared against `C:\Users\godho\Downloads\플레이.mp4`, especially clip05 around 486s, using a sequence/contact sheet rather than a single screenshot.
- The top-center circular overlay in the play video is treated as a recording/touch artifact and is not restored unless the user later says otherwise.

## Current Blockers

- `UI_GuildMain`: runtime/custom component/type initialization remains unresolved for `YouYouImage`, `UIMask`, missing MonoBehaviour bindings, and Lua-driven active/color/mask state.
- Battle HUD: visible hierarchy exists, but original clip05 HUD is not visible; unresolved sprite/font PPtrs and runtime Lua binding remain the next blocker.
