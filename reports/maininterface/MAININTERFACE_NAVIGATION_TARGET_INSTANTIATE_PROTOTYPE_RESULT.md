# MainInterface Navigation Target Instantiate Prototype Result

Generated: 2026-06-25 17:48:40 KST

## Verdict

원본 handler/prefab evidence와 `maininterface_navigation_target_load_probe.json`에서 loadable로 확인된 target만 prototype scene에서 instantiate하도록 연결했다. runtime/unknown/log-only 버튼은 여전히 화면을 만들지 않고 로그만 남긴다.

## Counts

| Metric | Count |
| --- | ---: |
| Active clickable buttons | `24` |
| Target-prefab-resolved button rows | `6` |
| Loadable unique targets from probe | `5` |
| Instantiate success | `5` |
| Instantiate fail | `0` |
| Unknown/runtime/log-only rows | `18` |

## Instantiate Smoke Test

| Target key | UIForm | Root | Instantiated | Objects | Root children | Status | Reason |
| --- | --- | --- | --- | ---: | ---: | --- | --- |
| `jump.OnGameJumpUIAdventure` | `UI_AdventureInterface` | `UI_AdventureInterface` | `UI_AdventureInterface_NavigationPrototype` | `239` | `1` | `success` | `` |
| `jump.OnGameJumpUIGuild` | `UI_GuildMainView` | `UI_GuildMain` | `UI_GuildMain_NavigationPrototype` | `2481` | `1` | `success` | `` |
| `jump.OnGameJumpUIJingjiRoot` | `UI_JingjiFrame_View` | `UI_JingjiFrame` | `UI_JingjiFrame_NavigationPrototype` | `96` | `1` | `success` | `` |
| `ui.UI_SystemSet` | `UI_SystemSet` | `UI_SystemSettings` | `UI_SystemSettings_NavigationPrototype` | `91` | `1` | `success` | `` |
| `event.CommonEventId.OnShowBgDownload` | `UI_PlayBgDownload` | `UI_PlayBgDownload` | `UI_PlayBgDownload_NavigationPrototype` | `32` | `1` | `success` | `` |

## Scene And Loader

- Prototype scene: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\Scenes\MainInterface_NavigationPrototype.unity`
- Source scene preserved: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\Scenes\MainInterface_Wireframe.unity`
- Loader root: `NavigationTargetRoot` under the restored MainInterface Canvas
- Loader behavior: one loadable target is shown at a time; previous target is cleared before the next target is instantiated
- No debug overlay or synthetic page was added

## Verification

| Check | Result | Evidence |
| --- | --- | --- |
| Prototype scene build | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\Scenes\MainInterface_NavigationPrototype.unity (1840669 bytes)` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_navigation_target_instantiate_build.log` |
| Instantiate smoke test JSON | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_instantiate_result.json (4386 bytes)` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_navigation_target_instantiate_smoke.log` |
| Instantiate smoke test CSV | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_navigation_target_instantiate_result.csv (2186 bytes)` | rows=`5` |
| Click validation generatedAt | `2026-06-25 17:48:43` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_click_validation_summary.json` |
| Active / clickable / blocked / invoked | `24` / `24` / `0` / `24` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_button_navigation_click_validation.log` |

## Deferred Targets

다음 target들은 원본 runtime activity id, event subscriber, 또는 target prefab evidence가 아직 부족해서 log-only로 유지했다:

- runtime activity: `onBtnLimit`, `onBtnActJump`, `UI_MainPageActItem` activity buttons, `onBtnAddHoly`, `faceGiftNode`
- local state: background arrows, activity banner description toggle, watch animation
- unresolved event/unknown: `UI_bg`, `p_chat_private_head`, chat event target, `worldwanfaBtn` idle target

## Generated Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_navigation_target_instantiate_result.json`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_navigation_target_instantiate_result.csv`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_NAVIGATION_TARGET_INSTANTIATE_PROTOTYPE_RESULT.md`