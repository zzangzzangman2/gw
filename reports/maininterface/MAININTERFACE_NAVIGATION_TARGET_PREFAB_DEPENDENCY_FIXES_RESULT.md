# MainInterface Navigation Target Prefab Dependency Fixes Result

Generated: 2026-06-25 17:58:09 KST

## Verdict

Prefab만 단독 로드하던 navigation target loader에 원본 clean UnityFS sibling dependency bundle preload를 추가했다. 이는 atlas를 통째로 화면에 얹는 방식이 아니라, 원본 prefab의 Image/Sprite/Material 참조가 AssetBundle dependency를 통해 해소되도록 하는 수정이다.

## Counts

| Metric | Count |
| --- | ---: |
| Targets captured after fix | `5` |
| Fixed target count | `2` |
| Loaded dependency bundle instances | `161` |
| Resolved missing sprite count | `2` |
| Resolved white no-sprite Image count | `2` |
| Resolved material count | `0` |
| Resolved font count | `0` |
| Resolved missing script object count | `0` |
| Before white placeholder suspicion | `5` |
| After white placeholder suspicion | `5` |
| Blank suspicion after fix | `0` |

## Before / After By Target

| Target | Dep bundles | Missing sprite before -> after | White no-sprite before -> after | Missing script before -> after | Visible px | Capture |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| `UI_AdventureInterface` | `4` | `61` -> `60` | `61` -> `60` | `131` -> `131` | `1201679` | `Assets/RestoreCaptures/navigation_targets_after_fix/UI_AdventureInterface_1680x720.png` |
| `UI_GuildMain` | `3` | `815` -> `814` | `732` -> `731` | `881` -> `881` | `1209600` | `Assets/RestoreCaptures/navigation_targets_after_fix/UI_GuildMain_1680x720.png` |
| `UI_JingjiFrame` | `1` | `24` -> `24` | `21` -> `21` | `45` -> `45` | `1201679` | `Assets/RestoreCaptures/navigation_targets_after_fix/UI_JingjiFrame_1680x720.png` |
| `UI_SystemSettings` | `153` | `47` -> `47` | `41` -> `41` | `15` -> `15` | `1201679` | `Assets/RestoreCaptures/navigation_targets_after_fix/UI_SystemSettings_1680x720.png` |
| `UI_PlayBgDownload` | `0` | `11` -> `11` | `8` -> `8` | `8` -> `8` | `1201679` | `Assets/RestoreCaptures/navigation_targets_after_fix/UI_PlayBgDownload_1680x720.png` |

## Evidence And Blockers

- Dependency source: `girlswar_merged_extracted\extracted\unity\clean_unityfs_slices\download\ui\uiprefabandres`, because prior probe proved `merged_content`/`restore_overlay` headers fail while clean UnityFS loads correctly.
- Dependency selection rule: for each target prefab bundle, load same-prefix sibling bundles such as `guild.assetbundle`, `guild_ext_1.assetbundle`, `guild_ext_2.assetbundle` before loading `guild_ext_prefabs.assetbundle`.
- Remaining white/no-sprite counts mean the prefab references still depend on unavailable script-driven binding, inactive state initialization, or additional non-sibling resource bundles. These are not coordinate issues.
- Missing script object counts are expected to remain until original MonoBehaviour type mapping or compatible script stubs are restored.

## Verification

| Check | Result | Evidence |
| --- | --- | --- |
| After-fix JSON | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_prefab_dependency_fixes.json (6257 bytes)` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_navigation_target_dependency_fixes_capture.log` |
| After-fix CSV | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_navigation_target_prefab_dependency_fixes.csv (1712 bytes)` | rows=`5` |
| Click validation generatedAt | `2026-06-25 17:58:12` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_click_validation_summary.json` |
| Active / clickable / blocked / invoked | `24` / `24` / `0` / `24` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_button_navigation_click_validation.log` |
| Tool | `C:\Users\godho\Downloads\girlswar\_restore_tools\104_FIX_MAININTERFACE_NAVIGATION_TARGET_PREFAB_DEPENDENCIES.cmd` | no debug overlay or synthetic page |

## Recommendation

Next: `target dependency fixes deeper pass`

## Generated Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_prefab_dependency_fixes.json`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_navigation_target_prefab_dependency_fixes.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_NAVIGATION_TARGET_PREFAB_DEPENDENCY_FIXES_RESULT.md`