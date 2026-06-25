# Home Resume After UI119 + BATTLE39

Generated: 2026-06-25 23:03 KST

## Pull

```powershell
cd C:\Users\godho\Downloads\girlswar
git pull origin main
```

Then start:
- `00_COMMAND_CENTER.cmd`
- `reports\NEXT_RESTORE_HANDOFF.md`

## Current Truth

This project is not visually restored yet.

- MainInterface is still wrong. UI119 only traced the remaining white route diamond/panel source.
- Battle screen is still wrong. BATTLE39 only attached runtime actors to a map/HUD candidate scene and proved the HUD/card objects are not camera-visible like clip05.

Do not accept object counts, component counts, or scene-object presence as success. Only actual capture/contact-sheet match counts.

## Latest Runnable Commands

- MainInterface latest:
  - `_restore_tools\cmd_archive\119_VALIDATE_ROUTE_SKELETONGRAPHIC_MESH_BOUNDS_CANVASRENDERER_SUBMESH_MATERIAL.cmd`
- Battle latest:
  - `_restore_tools\cmd_archive\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE.cmd`

The quick wrappers already point to those:
- `_restore_tools\current\01_RUN_LATEST_MAININTERFACE_UI_VALIDATION.cmd`
- `_restore_tools\current\02_RUN_LATEST_BATTLE_VALIDATION.cmd`

Root command policy:
- root CMD count: `1`
- only root CMD: `00_COMMAND_CENTER.cmd`
- `_restore_tools` direct CMD count: `0`

## Next UI Work

Task:
- `MAININTERFACE_120_TRACE_ROUTE_SKELETONGRAPHIC_ORIGINAL_RUNTIME_MASK_STENCIL_ATTACHMENT_VISIBILITY`

Start from:
- `reports\maininterface\MAININTERFACE_119_VALIDATE_ROUTE_SKELETONGRAPHIC_MESH_BOUNDS_CANVASRENDERER_SUBMESH_MATERIAL_RESULT.md`
- `girlswar_maininterface_unity\Assets\RestoreData\maininterface_119_route_skeletongraphic_mesh_bounds_canvasrenderer_submesh_material.json`
- `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_119_route_skeletongraphic_mesh_bounds_canvasrenderer_submesh_material.csv`

Why:
- `Spine_shijieanniu` route frame candidates are `zhuye_di1`, `zhuye_bian`, `diqiu`.
- `zhuye_di1` likely belongs to the big route frame, but hiding it without original runtime mask/stencil/attachment visibility evidence is invalid.
- Next pass must trace original runtime mask/stencil/CanvasRenderer texture handoff/attachment visibility.

UI key numbers:
- visual fix: `0`
- click validation: `2026-06-25 22:55:08`, `24 / 24 / 0 / 24`
- large route shape candidates: `3`

## Next Battle Work

Task:
- `BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT`

Start from:
- `reports\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_RESULT.md`
- `reports\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_RESULT.json`
- `reports\battle\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE_CONTACT_SHEET.jpg`
- `girlswar_battle_unity\Assets\Scenes\Battle39RuntimeActorsMap11003HudContextCandidate.unity`

Why:
- BATTLE39 scene has map/HUD/card objects: `True / True / True`
- But final capture camera-visible HUD/cards is `False`.
- Actor placement remains candidate and not original runtime verified.
- The next fix must make the real BATTLE29/clip05 top HP, bottom cards, and right controls render through the actual camera/runtime context before treating actor placement as final.

Battle key numbers:
- visual status: `failed_hud_context_not_camera_visible_in_candidate_capture`
- reference/runtime actor boxes: `181 / 18`
- actor center gap norm: `0.499238`
- runtime/reference actor area ratio: `0.042839`
- mesh hash changed actors: `3 / 3`

## Prompt For New Chat

```text
작업 위치는 반드시 C:\Users\godho\Downloads\girlswar 야. reports\NEXT_RESTORE_HANDOFF.md 와 reports\HOME_RESUME_AFTER_UI119_BATTLE39_20260625_2303.md 먼저 읽고 이어가.

원래 규칙 파일 C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt 는 아직 없으니 reports\RESTORE_RULES_APPLIED_CURRENT.md 를 authoritative fallback으로 지켜.

화면이 실제로 안 맞으면 성공이라고 하지 마. debug/path/evidence text, fake HUD, whole-atlas, crop guessing, coordinate-only fix 금지.

UI는 MAININTERFACE_120_TRACE_ROUTE_SKELETONGRAPHIC_ORIGINAL_RUNTIME_MASK_STENCIL_ATTACHMENT_VISIBILITY 부터.
전투는 BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT 부터.
루트에는 새 CMD 만들지 말고 새 CMD는 _restore_tools\cmd_archive 에만 둬. _restore_tools 직속 CMD count는 0 유지.
```
