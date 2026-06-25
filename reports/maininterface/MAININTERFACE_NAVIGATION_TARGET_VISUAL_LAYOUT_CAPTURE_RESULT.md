# MainInterface Navigation Target Visual Layout Capture Result

Generated: 2026-06-25 17:52:53 KST

## Verdict

Prototype scene에서 loadable target prefab 5개를 하나씩 실제 instantiate한 뒤 1680x720 그래픽 캡처를 생성했다. 좌표 보정이나 synthetic page 없이 원본 prefab hierarchy/RectTransform/anchor/localScale을 그대로 사용했다.

## Counts

| Metric | Count |
| --- | ---: |
| Target captures | `5` |
| Capture success | `5` |
| Blank suspicion | `0` |
| White placeholder suspicion | `5` |
| Unity log missing-script warnings | `0` |
| Unity log missing-material warnings | `0` |

## Capture Table

| Target | PNG | Visible px | Objects | Rects | Missing sprite | White no-sprite | RawImage no texture | Missing script objs | Blank? | White? |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |
| `UI_AdventureInterface` | `Assets/RestoreCaptures/navigation_targets/UI_AdventureInterface_1680x720.png` | `1201679` | `239` | `239` | `61` | `61` | `0` | `131` | `False` | `True` |
| `UI_GuildMain` | `Assets/RestoreCaptures/navigation_targets/UI_GuildMain_1680x720.png` | `1209600` | `2481` | `2481` | `815` | `732` | `0` | `881` | `False` | `True` |
| `UI_JingjiFrame` | `Assets/RestoreCaptures/navigation_targets/UI_JingjiFrame_1680x720.png` | `1201679` | `96` | `96` | `24` | `21` | `0` | `45` | `False` | `True` |
| `UI_SystemSettings` | `Assets/RestoreCaptures/navigation_targets/UI_SystemSettings_1680x720.png` | `1201679` | `91` | `88` | `47` | `41` | `0` | `15` | `False` | `True` |
| `UI_PlayBgDownload` | `Assets/RestoreCaptures/navigation_targets/UI_PlayBgDownload_1680x720.png` | `1201679` | `32` | `32` | `11` | `8` | `0` | `8` | `False` | `True` |

## Worst Targets / Issues

- Worst target candidates by automatic checks: `UI_GuildMain, UI_AdventureInterface`
- Direct visual spot-check: `UI_GuildMain` renders as an almost full white screen, matching its `0.9983` white-ish visible ratio and hundreds of white no-sprite Images.
- Direct visual spot-check: `UI_SystemSettings` capture still shows the MainInterface background more than a completed settings panel, so the next problem is target prefab dependency/script/sprite restoration, not manual screen-coordinate nudging.
- A white placeholder suspicion means either a white no-sprite Image exists inside the instantiated prefab or a large share of visible pixels are white-ish. This is a triage signal, not a coordinate fix.
- Missing sprite/material/script issues must be fixed from original prefab, sprite slice, material, font, shader, and dependency evidence rather than screen-coordinate adjustment.

## Verification

| Check | Result | Evidence |
| --- | --- | --- |
| Prototype scene | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\Scenes\MainInterface_NavigationPrototype.unity (1840675 bytes)` | source scene remains separate |
| Visual capture JSON | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_visual_capture_result.json (6113 bytes)` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_navigation_target_visual_capture.log` |
| Visual capture CSV | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_navigation_target_visual_capture_result.csv (1573 bytes)` | rows=`5` |
| Click validation generatedAt | `2026-06-25 17:52:57` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_click_validation_summary.json` |
| Active / clickable / blocked / invoked | `24` / `24` / `0` / `24` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_button_navigation_click_validation.log` |

## Unity Log Notes

- `Launched and connected shader compiler UnityShaderCompiler.exe after 0.01 seconds`
- `[GirlsWarRestore] Navigation target capture: UI_AdventureInterface visiblePixels=1201679 whiteNoSpriteImages=61 missingScripts=131 -> Assets/RestoreCaptures/navigation_targets/UI_AdventureInterface_1680x720.png`
- `[GirlsWarRestore] Navigation target capture: UI_GuildMain visiblePixels=1209600 whiteNoSpriteImages=732 missingScripts=881 -> Assets/RestoreCaptures/navigation_targets/UI_GuildMain_1680x720.png`
- `[GirlsWarRestore] Navigation target capture: UI_JingjiFrame visiblePixels=1201679 whiteNoSpriteImages=21 missingScripts=45 -> Assets/RestoreCaptures/navigation_targets/UI_JingjiFrame_1680x720.png`
- `[GirlsWarRestore] Navigation target capture: UI_SystemSettings visiblePixels=1201679 whiteNoSpriteImages=41 missingScripts=15 -> Assets/RestoreCaptures/navigation_targets/UI_SystemSettings_1680x720.png`
- `[GirlsWarRestore] Navigation target capture: UI_PlayBgDownload visiblePixels=1201679 whiteNoSpriteImages=8 missingScripts=8 -> Assets/RestoreCaptures/navigation_targets/UI_PlayBgDownload_1680x720.png`

## Recommendation

Next: `target prefab visual/layout fixes`

## Generated Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_visual_capture_result.json`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_navigation_target_visual_capture_result.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_NAVIGATION_TARGET_VISUAL_LAYOUT_CAPTURE_RESULT.md`