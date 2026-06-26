# MAIN UI Worker Status 20260626_1000

## Summary

- 작업 루트: `C:\Users\godho\Downloads\girlswar`
- 기준 이미지: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- 기준 이미지 크기/aspect: `1180x526`, `2.243346`
- 이번 작업 결론: 실제 기준 화면은 route/world 화면이 아니라 home/lobby 화면이다. 현재 default root는 route/world active state를 보존하고 있어 근본적으로 다르다.
- production restored claim: `false`
- production scene promotion: `false`
- candidate patch: `true` (`UI149` 별도 감사/캡처 후보 생성)

## Changed / Added

- 추가: `girlswar_maininterface_unity/Assets/Editor/MainInterface149ReferenceAuditAndAspectCapture.cs`
- 추가: `_restore_tools/cmd_archive/149_MAIN_UI_WORKER_REFERENCE_ASPECT_AUDIT_AND_SAFE_CAPTURE.cmd`
- 추가 후보 씬:
  - `girlswar_maininterface_unity/Assets/Scenes/MainInterface_UI149_DefaultRootReferenceAudit.unity`
  - `girlswar_maininterface_unity/Assets/Scenes/MainInterface_UI149_OldRootReferenceAudit.unity`
- 추가 캡처:
  - `girlswar_maininterface_unity/Assets/RestoreCaptures/maininterface_ui149_default_root_reference_aspect_1180x526.png`
  - `girlswar_maininterface_unity/Assets/RestoreCaptures/maininterface_ui149_oldroot_home_reference_aspect_1180x526.png`
- 추가 감사 산출물:
  - `girlswar_maininterface_unity/Assets/RestoreData/maininterface_149_reference_aspect_audit_result.json`
  - `girlswar_maininterface_unity/Assets/RestoreData/reports/maininterface_149_reference_audit_nodes.csv`
  - `girlswar_maininterface_unity/Assets/RestoreData/reports/maininterface_149_reference_audit_tmp.csv`
  - `girlswar_maininterface_unity/Assets/RestoreData/reports/maininterface_149_reference_audit_mask_stencil.csv`
  - `girlswar_maininterface_unity/Assets/RestoreData/reports/maininterface_149_reference_audit_skeletongraphic.csv`
  - `girlswar_maininterface_unity/Assets/RestoreData/reports/maininterface_149_reference_audit_decision_matrix.csv`
  - `reports/maininterface/MAININTERFACE_149_REFERENCE_ASPECT_RUNTIME_STATE_AUDIT_AND_SAFE_CAPTURE_RESULT.md`

`girlswar_battle_unity` 전투 구현 파일은 이번 작업에서 직접 수정하지 않았다.

## Verification

실행 명령:

```bat
C:\Users\godho\Downloads\girlswar\_restore_tools\cmd_archive\149_MAIN_UI_WORKER_REFERENCE_ASPECT_AUDIT_AND_SAFE_CAPTURE.cmd
```

결과:

- Unity exit code: `0`
- 로그: `girlswar_maininterface_unity/logs/unity_149_reference_aspect_audit_and_safe_capture.log`
- 공용 `Assets/RestoreData/maininterface_build_result.json`은 UI149 실행 후에도 기존 UI144 상태로 보존됨을 확인했다.

UI149 기준 aspect 캡처 비교:

| variant | corr | meanAbsDiff | changed30 | routeActive | homeActive | SkeletonGraphic |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| default root / route state | `0.195456` | `0.261570` | `0.751714` | `12` | `25` | `0` |
| old-root home safe candidate | `0.431487` | `0.206433` | `0.571246` | `0` | `178` | `1` |

## Root Cause

- 좌표/CanvasScaler만의 문제가 아니다. 기존 후보 캡처는 `1680x720` aspect `2.333333`이고 기준은 `1180x526` aspect `2.243346`이라 비교 프레이밍 문제가 있었지만, 기준 aspect로 다시 찍어도 default root는 route/world 상태다.
- default root `5568884429252053541`에는 `node_middle`, `wanfaWorldNode`, `worldwanfaBtn`, `spine_diqiu`, `route_fallback_zhuye_di1`, `route_fallback_zhuye_bian` 등이 active다. 이는 sibling-order 오류가 아니라 CSV active state와 route fallback 적용 결과다.
- old root `2475216337245998118`가 실제 home/lobby 기준 화면에 더 가까운 static prefab/open-stack 후보다.
- Hero1005는 old-root 후보에서 실제 `SkeletonGraphic` 1건으로 장착됨:
  - `Painting_1005_SkeletonData`
  - material `Painting_1005_Material`
  - shader `Spine/SkeletonGraphic`
  - texture `Painting_1005`
  - animation `A`
- CanvasScaler는 두 후보 모두 `ScaleWithScreenSize`, reference resolution `1680,720`, match `0.5`다. UI149는 씬 좌표를 눈대중으로 바꾸지 않고 validation render target만 `1180x526`으로 맞췄다.
- TMP autosize는 감사 대상에서 `0`건, non-zero stencil material도 `0`건이었다. Mask는 RectMask2D만 확인됐다.

## Remaining Mismatches

- 우측 activity/button stack은 `ActMgr:GetActInMain` 계정/서버 runtime 결과가 없어서 placeholder 활동 슬롯이 다수 active로 남는다.
- 채팅 텍스트는 `dadfadsfadsf` 같은 복원/샘플 문자열이 남아 있고, 실제 기준의 채팅 내용/유저명은 runtime snapshot 없이는 확정할 수 없다.
- 프로필, 전투력, 재화, 뱃지, 우편/친구/순위 redpoint 값도 runtime/account state 의존이다.
- 하단 메뉴/UI_Dock은 source-backed 후보(UI136/UI144)가 있었지만 기준 metric이 UI128보다 나빠 promotion 금지다. 필요한 것은 `UI_Dock`/`UI_MainPage` parent, depth, mask, open-stack, `YouYouCanvasHelper` effective depth runtime 값이다.
- TMP 로그에 일부 glyph 누락 경고가 남았다: `U+AD00`, `U+7D04`, `U+675F`. 치명 compile 오류는 아니지만 font/material lane의 잔여 리스크다.

## Control Tower Requests

- 원본 runtime snapshot/dump 승인 또는 사용자 제공 snapshot 필요:
  - `UI_Dock` / `UI_MainPage` parent, form group, canvas sorting/depth, mask/open-stack
  - `YouYouCanvasHelper` effective depth cascade
  - UI130 호환 activity/account/chat/currency/localization 값
- 전투 전담 연동 요청 없음. 이번 메인/UI 작업은 전투 프로젝트 파일을 직접 수정하지 않았다.
