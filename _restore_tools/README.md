# GirlsWar Restore Tools

이 폴더는 `C:\Users\godho\Downloads\girlswar` 복원 작업용 실행 CMD와 분석 스크립트를 모아둔 곳이다.

## 먼저 실행

`00_START_HERE_GIRLSWAR_RESTORE_MENU.cmd`

메뉴에서 검증, Unity 백그라운드 생성, 캡처, 클릭 검증, 리포트 열기를 고를 수 있다.

## 폴더 구조

- `*.cmd`: 바로 실행할 수 있는 확인/분석/빌드 런처
- `scripts\`: Python 분석 스크립트
- `..\reports\maininterface\`: MainInterface 관련 사람이 읽는 MD 보고서
- `..\reports\source_cleanup\`: 원본 삭제 가능 여부 및 삭제 결과 보고서

## 현재 MainInterface 핵심 CMD

- `04_VERIFY_MAININTERFACE_OUTPUTS.cmd`: 전체 요약 확인
- `11_BUILD_MAININTERFACE_RESTORED_BACKGROUND.cmd`: Scene 재생성
- `13_CAPTURE_MAININTERFACE_RESTORED_BACKGROUND.cmd`: 그래픽 모드 캡처
- `14_OPEN_MAININTERFACE_CAPTURE.cmd`: 최신 1680x720 캡처 PNG 열기
- `37_VALIDATE_MAININTERFACE_BUTTON_CLICKS.cmd`: Button hit-stack 클릭 검증
- `39_ANALYZE_MAININTERFACE_CLICK_BLOCKERS.cmd`: 남은 blocker 분석
- `41_OPEN_MAININTERFACE_RAYCAST_OVERRIDES.cmd`: 현재 화면 state/raycast override CSV 열기
- `42_VERIFY_SOURCE_DISPOSAL_READINESS.cmd`: `girl1.xapk` / `com.girlwars.kr` 삭제 가능 여부 검증
- `43_DELETE_READY_SOURCE_ORIGINALS_AFTER_VERIFY.cmd`: 검증 통과한 원본만 삭제
- `44_OPEN_SOURCE_DISPOSAL_READINESS_REPORT.cmd`: 원본 삭제 검증 보고서 열기
- `45_ANALYZE_MAININTERFACE_VISUAL_GAPS.cmd`: 배경/Spine/Live2D 시각 누락 근거 분석
- `46_OPEN_MAININTERFACE_VISUAL_GAP_ANALYSIS.cmd`: 시각 누락 분석 MD 열기
- `47_OPEN_MAININTERFACE_VISUAL_OVERRIDES.cmd`: 동적 배경 override CSV 열기
- `48_ANALYZE_MAININTERFACE_COORDINATE_SYSTEM.cmd`: MainInterface 좌표계/캡처 기준 재분석
- `49_OPEN_MAININTERFACE_COORDINATE_SYSTEM_REPORT.cmd`: 좌표계 재정렬 MD 열기
- `50_ANALYZE_MAININTERFACE_HERO_SPINE_1001.cmd`: `UI_heroSpine` 기본 1001번 Spine/DTmodel/bundle 근거 분석
- `51_OPEN_MAININTERFACE_HERO_SPINE_PLAN.cmd`: 캐릭터 Spine 복원 계획 MD 열기
- `52_ANALYZE_SPINE_RUNTIME_COMPATIBILITY.cmd`: 1001 skeleton 버전, Unity 버전, Spine 4.0 unitypackage 호환성 분석
- `53_OPEN_SPINE_RUNTIME_COMPATIBILITY_REPORT.cmd`: Spine runtime 호환성 MD 열기
- `54_OPEN_SPINE_VENDOR_FOLDER.cmd`: 다운로드한 Spine runtime vendor 폴더 열기
- `55_RUN_SPINE40_PROBE_IMPORT.cmd`: 메인 프로젝트를 건드리지 않고 `_restore_tools\work`에 격리 probe를 만들고 Spine 4.0 import 시험
- `56_ANALYZE_SPINE40_PROBE_RESULT.cmd`: probe Unity 로그/파일을 분석해 적용 가능 여부 MD 생성
- `57_OPEN_SPINE40_PROBE_REPORT.cmd`: Spine 4.0 probe 결과 MD 열기
- `58_IMPORT_HERO1001_SPINE_IN_PROBE.cmd`: probe 안에서 1001 atlas/skel을 Spine `SkeletonDataAsset`으로 강제 import
- `59_ANALYZE_HERO1001_SPINE_PROBE_IMPORT.cmd`: 1001 `SkeletonDataAsset` 생성/로드 결과 MD 생성
- `60_OPEN_HERO1001_SPINE_PROBE_IMPORT_REPORT.cmd`: 1001 Spine probe import 결과 MD 열기
- `61_EXTRACT_HERO1001_SPINE_RAW_TEXTASSETS.cmd`: 손상된 text export 대신 UnityPy raw `m_Script` bytes로 1001 `.skel.bytes` 재추출
- `62_OPEN_HERO1001_SPINE_RAW_TEXTASSETS_REPORT.cmd`: 1001 raw Spine TextAsset 비교 MD 열기
- `63_ATTACH_CAPTURE_HERO1001_SPINE_IN_PROBE.cmd`: probe 장면의 `UI_heroSpine` 아래에 1001 Spine `SkeletonGraphic` 레이어를 붙이고 full/hero-only/layer/variant 그래픽 모드 캡처
- `64_OPEN_HERO1001_SPINE_PROBE_CAPTURE_REPORT.cmd`: 1001 Spine attach/capture 결과 MD 열기
- `65_OPEN_HERO1001_SPINE_PROBE_CAPTURE_IMAGES.cmd`: full/hero-only/layer/variant 캡처 PNG 열기
- `66_ANALYZE_MAININTERFACE_TEXT_FONT_LAYOUT.cmd`: TMP-like 텍스트, OS fallback 폰트, right route 라벨 상태 분석
- `67_OPEN_MAININTERFACE_TEXT_FONT_LAYOUT_REPORT.cmd`: Text/TMP/font/right route layout 분석 MD 열기
- `68_ANALYZE_MAININTERFACE_TMP_FONT_ASSETS.cmd`: `download/ui/uifont/japanese` TMP FontAsset/atlas 근거 인벤토리 생성
- `69_OPEN_MAININTERFACE_TMP_FONT_ASSET_INVENTORY.cmd`: TMP FontAsset 인벤토리 MD 열기
- `70_OPEN_MAININTERFACE_VISUAL_MISMATCH_CAUSE.cmd`: 현재 캡처가 왜 틀렸는지와 수정된 복원 방향 MD 열기
- `71_RUN_TMP_COMPILE_PROBE.cmd`: 격리 Unity 6000 프로젝트에서 `TextMeshProUGUI` compile/create probe 실행
- `72_OPEN_TMP_COMPILE_PROBE_REPORT.cmd`: TMP compile probe 결과 MD 열기
- `73_EXPORT_MAININTERFACE_TMP_TEXT_DETAILS.cmd`: MainInterface TMP 원본 layout/font field CSV 생성
- `74_OPEN_MAININTERFACE_TMP_TEXT_DETAILS_REPORT.cmd`: TMP text detail export MD 열기
- `75_IMPORT_TMP_ESSENTIAL_RESOURCES.cmd`: Unity TMP Essential Resources를 `Assets/TextMesh Pro` 아래에 직접 풀기
- `76_OPEN_TMP_ESSENTIAL_RESOURCES_IMPORT_REPORT.cmd`: TMP Essential Resources import MD 열기
- `77_EXTRACT_ORIGINAL_TMP_SOURCE_FONTS.cmd`: 원본 `riyu`/`EPM`/`num` source font bytes 추출
- `78_OPEN_ORIGINAL_TMP_SOURCE_FONTS_REPORT.cmd`: 원본 TMP source font 추출 MD 열기
- `79_OPEN_ORIGINAL_TMP_FONT_APPLY_RESULT.cmd`: 원본 source font 기반 TMP 적용 결과 MD 열기
- `80_OPEN_MAININTERFACE_PROGRESS_REASON.cmd`: 현재 진행상황과 MainInterface 복원이 오래 걸리는 이유 MD 열기
- `81_ANALYZE_ORIGINAL_TMP_STATIC_FONT_ASSETS.cmd`: 원본 `riyu`/`EPM`/`num` TMP 정적 glyph/material/atlas와 현재 Unity TMP asset 차이 분석
- `82_OPEN_ORIGINAL_TMP_STATIC_FONT_ANALYSIS.cmd`: 원본 TMP 정적 FontAsset 분석 MD 열기
- `83_PROBE_TMP_STATIC_FONT_ASSETS.cmd`: 원본 정적 glyph/character table과 atlas PNG를 Unity TMP FontAsset에 주입 가능한지 probe
- `84_OPEN_TMP_STATIC_FONT_PROBE_RESULT.cmd`: TMP 정적 FontAsset probe 결과 MD 열기
- `85_OPEN_TMP_STATIC_FONT_APPLY_RESULT.cmd`: MainInterface active TMP 84개에 정적 TMP FontAsset을 적용한 결과 MD 열기
- `86_ANALYZE_TMP_SHARED_MATERIALS.cmd`: MainInterface TMP `shared_material_path_id` 원본 material preset 스캔
- `87_OPEN_TMP_SHARED_MATERIAL_ANALYSIS.cmd`: TMP shared material 분석 MD 열기
- `88_BUILD_TMP_SHARED_MATERIALS.cmd`: 원본 TMP shared material preset 19개를 Unity Material asset으로 재구성
- `89_OPEN_TMP_SHARED_MATERIAL_APPLY_RESULT.cmd`: TMP shared material 재구성/적용 결과 MD 열기
- `90_ANALYZE_ROUTE_TMP_STATE_AFTER_MATERIAL.cmd`: static TMP/shared material 적용 후 route TMP active/rect/font 상태 분석
- `91_OPEN_ROUTE_TMP_STATE_AFTER_MATERIAL.cmd`: route TMP 상태 분석 MD 열기
- `92_OPEN_ROUTE_RECT_OVERRIDE_PLAN.cmd`: zero-height route TMP rect override 계획 MD 열기
- `93_PUSH_TO_GITHUB_MAIN.cmd`: 현재 `girlswar` 루트를 GitHub `zzangzzangman2/gw` main으로 push
- `94_SHOW_GIT_PUSH_STATUS.cmd`: git status, remote, 마지막 push 로그 확인
- `95_PUSH_TO_GITHUB_MAIN_BACKGROUND.cmd`: GitHub main push를 hidden background 프로세스로 시작

메인 폴더에는 작업 루트 폴더만 남기고, 실행 도구와 보고서는 각각 `_restore_tools`, `reports` 아래에서 관리한다.
