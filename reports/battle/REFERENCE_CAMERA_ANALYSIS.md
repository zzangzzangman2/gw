# 참고.mp4 카메라/배치 정밀 분석 (vs 현재)

참고: `C:\Users\godho\Downloads\참고.mp4` = **1280×570, 30fps, 121s**. 전투 ~18~60s.
조밀 프레임: `reports/battle/reference_video/dense/r_*.png`, 콘택트 `REF_DENSE_CONTACT.png`,
비교 `REF_VS_OURS.png`.

## 일치 ✅
- 해상도 1280×570 동일.
- 카메라 각도: ortho 2.5D 정면. 원근감은 맵 아트 + 액터 깊이(뒷줄 위/작게)로. (카메라 회전 없음)
- 배치 구조: 우리팀 좌측 2열 사선, 적 우측. (실제 스테이션 좌표 사용)
- 기본 카메라: 정적.

## ★측정 정정 + 가짜 진단 수치 경고 (2026-06-28)
- **RESULT JSON의 `visualActorHeightSummary`/`visualActorScreenRects`/`overlap`은 가짜다.**
  `DiagnosticActorScreenRect`(BattlePlayModeBootstrap.cs:3272)가 실제 렌더 메시를 재지 않고
  **하드코딩 상수**(`DiagnosticActorHeightPixels`: 영웅 226 / 적 208px)를 발 위치에 박스로 그린 값.
  스케일을 바꿔도 226px 고정 → 이걸 믿고 헤매지 말 것. **검증은 캡처 PNG 픽셀을 자로 직접 측정.**
- **실제 액터 크기 제어 경로**(진짜): `BattleRuntimeSpineActorFactory`
  → `ApplyActorPose`(ActorVisualScale) → `NormalizeActorHeight`(실 bounds를 재서
  `TargetActorWorldHeight`(line 1828) 월드높이로 정규화). 1439·1523행에서 호출. **여기만 바꾸면 됨.**
  (bootstrap의 `StandingSnapshotTargetHeight`, `OurFormationSlotScales`는 이 런에서 비활성/상쇄됨.)
- **참고 실측(PNG 자):** 영웅 몸통 ~24%(머리 34%·발 58%, ortho5에서 ≈2.4유닛). 이전 "35~40%"는
  스킬 줌인 프레임을 잰 과대치. 기본 전투는 24%가 맞음.

## 불일치
1. **캐릭터 스케일 — ✅ 해결(2026-06-28).** 베이스 target(영웅 ~2.0u, 몸통 17%) × **1.4**
   (`ReferenceSizeScale`, factory)로 참고 24%에 맞춤. 발은 스테이션 좌표로 고정돼 머리만 41%→34%로 상승.
   검증: 검 영웅(1003) 머리 35%·발 58% = 참고 분홍영웅 34%·58%. (`REF_VS_OURS.png`)
2. **영웅 세로 위치 — ✅ 동반 해결.** 스케일이 발 피벗 기준이라 키우면 머리가 중앙대로 올라옴.
   카메라 Y/스테이션 Y는 원본값 유지(변경 없음).
3. **스킬 포커스 카메라 없음(후순위).** 참고는 스킬/궁극 시 **배경 디밍 + 시전자 줌인**(26·30·33·34·48·54s).
   현재 정적. → 스킬 트리거 시 카메라 줌/디밍 연출 추가.

## 검증 기준
참고 r_44.0(기본 전투)와 우리 캡처를 `REF_VS_OURS.png`처럼 나란히 비교해 영웅 크기/세로위치/배경이
눈으로 일치할 것. 카메라 ortho 5.0·위치(0,0)·실제 스테이션 좌표는 원본값이므로 변경 금지; 조정 대상은
**액터 스케일(원본값으로)** 과 **세로 정렬**, 그리고 스킬 카메라 연출.
