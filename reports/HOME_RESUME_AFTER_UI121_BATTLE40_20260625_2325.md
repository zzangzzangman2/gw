# Home Resume After UI121 + BATTLE40

Generated: 2026-06-25 23:25 KST

## Pull

```powershell
cd C:\Users\godho\Downloads\girlswar
git pull origin main
```

Then start:
- `00_COMMAND_CENTER.cmd`
- Press `B` for the checkpoint test.

Direct test CMD:
- `_restore_tools\current\00_RUN_HOME_CHECKPOINT_TESTS.cmd`

## Current Truth

This project is still not visually restored.

- MainInterface is still wrong. UI121 only proved `zhuye_di1/zhuye_bian` are pre-clipping attachments and must not be hidden without original evidence.
- Battle screen is still wrong. BATTLE40 proved the canvas/camera binding is not the main blocker; reopened scenes have zero resolved active Graphic/Image rows for the HUD/card render substance.

Do not accept object counts, component counts, or scene-object presence as success. Only actual capture/contact-sheet match counts.

## Latest Runnable Commands

- MainInterface latest:
  - `_restore_tools\cmd_archive\121_VERIFY_ROUTE_SKELETONGRAPHIC_CANVASRENDERER_TEXTURE_HANDOFF_AND_CLIPPING_TRIANGULATION_ZONG1.cmd`
- Battle latest stable:
  - `_restore_tools\cmd_archive\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT.cmd`
- Battle next experimental, not default:
  - `_restore_tools\cmd_archive\BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE.cmd`

The quick wrappers point to the stable checkpoint:
- `_restore_tools\current\01_RUN_LATEST_MAININTERFACE_UI_VALIDATION.cmd`
- `_restore_tools\current\02_RUN_LATEST_BATTLE_VALIDATION.cmd`

Root command policy:
- root CMD count: `1`
- only root CMD: `00_COMMAND_CENTER.cmd`
- `_restore_tools` direct CMD count: `0`

## UI Checkpoint

Task:
- `MAININTERFACE_121_VERIFY_ROUTE_SKELETONGRAPHIC_CANVASRENDERER_TEXTURE_HANDOFF_AND_CLIPPING_TRIANGULATION_ZONG1`

Start from:
- `reports\maininterface\MAININTERFACE_121_VERIFY_ROUTE_SKELETONGRAPHIC_CANVASRENDERER_TEXTURE_HANDOFF_AND_CLIPPING_TRIANGULATION_ZONG1_RESULT.md`
- `girlswar_maininterface_unity\Assets\RestoreData\maininterface_121_route_skeletongraphic_canvasrenderer_texture_handoff_clipping_zong1.json`
- `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_121_route_skeletongraphic_canvasrenderer_texture_handoff_clipping_zong1.csv`

Key interpretation:
- `zhuye_di1/zhuye_bian` are before `zong1` clipping in draw order.
- `zong1` clips later attachments such as `diqiu/yun/yun2`.
- The route frame mismatch is not solved by hiding `zhuye`.

UI key numbers:
- visual fix: `0`
- click validation: `2026-06-25 23:22:51`, `24 / 24 / 0 / 24`
- clip rows / clipped rows: `9 / 6`

## Battle Checkpoint

Task:
- `BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT`

Start from:
- `reports\battle\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_RESULT.md`
- `reports\battle\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_RESULT.json`
- `reports\battle\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_CONTACT_SHEET.jpg`
- `girlswar_battle_unity\Assets\Scenes\Battle40HudCameraRenderBindingRuntimeContext.unity`

Why:
- HUD canvases are already `ScreenSpaceCamera/worldCamera` bound.
- Reopened runtime context has active Graphic/Image rows `0 / 0`.
- The next fix must persist original HUD/card Image/Sprite components from original prefab/PPtr/sprite evidence, not paste a captured HUD.

Battle key numbers:
- visual status: `failed_hud_graphic_components_missing_after_scene_reload`
- camera-visible HUD/cards: `False`
- resolved active Graphic rows: `0`
- resolved Image rows: `0`
- reference/runtime actor boxes: `181 / 0`

## Prompt For New Chat

```text
작업 위치는 반드시 C:\Users\godho\Downloads\girlswar 야.
reports\NEXT_RESTORE_HANDOFF.md 와 reports\HOME_RESUME_AFTER_UI121_BATTLE40_20260625_2325.md 먼저 읽고 이어가.

원래 규칙 파일 C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt 는 아직 없으니 reports\RESTORE_RULES_APPLIED_CURRENT.md 를 authoritative fallback으로 지켜.

화면이 실제로 안 맞으면 성공이라고 하지 마.
debug/path/evidence text, fake HUD, whole-atlas, crop guessing, coordinate-only fix 금지.

집 테스트는 00_COMMAND_CENTER.cmd 에서 B를 눌러라.
UI는 UI121 결과부터 이어가고, zhuye_di1/zhuye_bian은 pre-clipping original attachment라 임의 hide 금지.
전투는 BATTLE40 결과부터 이어가고, BATTLE41은 runtime HUD Image/Sprite persistence probe로만 다뤄라.
루트에는 새 CMD 만들지 말고 새 CMD는 _restore_tools\cmd_archive 에만 둬. _restore_tools 직속 CMD count는 0 유지.
```
