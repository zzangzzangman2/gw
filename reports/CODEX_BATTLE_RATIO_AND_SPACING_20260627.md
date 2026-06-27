# Codex 전투 — 참고 vs 현재 비율/배치 대조 (2026-06-27 22:10)

사용자 제공: 참고(첫 이미지, 참고.mp4 본전투) vs 우리꺼(둘째 이미지 = BATTLE_92 reference roster run,
`reports/battle/BATTLE_92_ROSTER_EXPANSION_PLAYMODE_*` 22:00). 비율/배치 대조 결과.

## 0. 좋아진 것 (유지)
- **로스터 정확**: 우리편 = 1002(차차)/1003(란슬롯)/1001(츠루히메)/1010(세미라미스)/1005(링링). `skinVisualFallback=0`,
  `monsterBaseFallback=0`. ✅ (내 FORMATION_CHECK 문서 반영됨)
- **크기 비율 OK**: 액터 화면높이 33~38%(참고 ~30~38%와 일치). 공격 `runtimePreviewActionCount=72`,
  궁극 컷인 `=8`. ✅

## 1. ★비율 체크 결론
- **사이즈(개별 캐릭 크기): ✅ 잘 맞음** (≈35%). 더 키울 필요 없음.
- **배치/간격: ❌ 안 맞음 (지금 제일 어색)** — 우리 5명이 좌측에 **겹쳐 뭉침**.
  - `visualActorOverlappedPairCount=9`, `visualActorMaxOverlapRatio=0.45`.
  - 우리편 center-x: 1002=-102, 1005=-53, 1003=29, 1010=157, 1001=182 → **폭 ~284px 좁은 띠에 5명**
    (서로 겹침). 참고는 5~6명을 **넓은 2열 사선**으로 분명한 간격을 두고 배치.
  - 적도 일부 겹침: 1100111·1100113이 같은 cx=456(완전 중첩), 1100112만 603.

## 2. ★수정 1 — 포메이션 분산 (가장 시급)
참고 본전투/배치도처럼 **2열 사선 + 캐릭터별 독립 x레인**:
- 우리편(좌): 뒤열 3 + 앞열 2 (또는 참고 배치도대로). 뒤열은 화면상 **위+약간 작게(원근)**, 앞열은
  **아래+크게**. 각 캐릭의 cx를 **충분히 벌려**(겹침 0). 현재 -102~182(284px) → 예: -340~+40 정도로
  좌측 절반에 고르게 펴고, 뒤/앞 행을 y로 분리.
- 적(우): 3명을 **서로 다른 cx**로(현재 두 명 456 중복 → 분리). 참고처럼 우측에 사선 배치.
- 목표: `visualActorOverlappedPairCount=0`, `maxOverlapRatio<0.05`. 참고 첫 이미지와 1:1.

## 3. ★수정 2 — 데미지 숫자 안 뜸
- `visualHudDamageTextCount=0` (공격 72회는 일어나는데 **데미지 팝업 0**). 참고엔 피격 시 숫자가 뜸.
- 조치: 공격/스킬 히트 시 대상 위에 데미지 숫자 팝업 표시(actionData/heroStatistics의 dmg 또는
  최소한 히트 이벤트마다). `visualHudDamageTextCount>0` 확인.

## 4. 수정 3 (소) — 카메라 폭
- 크기는 맞으나 참고는 맵(불타는 마을)이 더 보이는 약간 더 넓은 프레이밍. 포메이션을 펴면 자연히
  더 넓게 보임 — 펴고도 좌측 캐릭이 화면 밖으로 안 나가게 카메라 중심/orthoSize(현 2.2) 미세조정.

## 5. 완료 판정
참고 첫 이미지와 나란히: 우리 5명이 **겹침 없이 2열 사선**으로 퍼지고, 적도 분산, 피격 시 **데미지
숫자** 표시. 카운터: overlapPairs=0, fallback 0(유지), attacks>0(유지), damageText>0, cutin>0(유지).

## 6. 새 챗(Codex)용 프롬프트
```text
작업 위치 C:\Users\godho\Downloads\girlswar. git pull origin main 먼저.
reports\CODEX_BATTLE_RATIO_AND_SPACING_20260627.md 읽고 시작.
크기/로스터는 OK(1002/1003/1001/1010/1005, 폴백0, 크기~35%). 남은 핵심:
(1) 포메이션 겹침 심함 overlapPairs=9/0.45 — 우리 5명을 2열 사선+독립 x레인으로 충분히 벌리고(현 cx
-102~182 좁음→넓게), 적 3명도 cx 중복(456 두명) 분리. 목표 overlapPairs=0.
(2) 데미지 숫자 안 뜸 visualHudDamageTextCount=0 — 히트 시 데미지 팝업 표시>0.
참고 첫 이미지(2열 사선, 간격 넓음)와 1:1 비교. 매 동작 commit+push.
```
