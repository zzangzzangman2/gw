# Codex 전투 — 중앙 침범 확정 수정 (그대로 붙여넣기)

## 진짜 원인 (코드 한 곳)
`girlswar_battle_unity/Assets/Scripts/GirlsWar/PlayMode/BattlePlayModeBootstrap.cs`
의 `OurFormationSlotPositions` 배열에 **우리팀 슬롯이 화면 중앙/오른쪽 x로 박혀 있음**:
`(0.32, ...)`=화면 중앙오른쪽, `(-0.48, ...)`=거의 중앙. 위치는 이 배열이 유일 출처
(`PreviewFormationPosition` → 1330행, 3454행 모두 사용). 그래서 그 슬롯에 배정된 영웅이
중앙으로 감. (카메라 pos x=−0.65, ortho 2.2 → **화면 중앙 = world x ≈ −0.65**. 우리팀은
x가 −1.7보다 작아야 확실히 좌측, 적은 +0.55보다 커야 확실히 우측.)

## 수정 1 — 두 배열을 아래로 교체 (정확값, copy-paste)
우리팀 전 슬롯 x ∈ [−4.55, −1.95](좌측), 적 전 슬롯 x ∈ [+0.65, +3.25](우측). 앞줄(1·2·3)=중앙쪽·아래,
뒷줄(4·5·6)=바깥쪽·위. 카메라 중앙(−0.65) 기준 좌우 대칭.

```csharp
private static readonly Vector3[] OurFormationSlotPositions =
{
    new Vector3(-1.95f, -2.20f, -0.20f), // pos1 front (center-ward, low)
    new Vector3(-3.05f, -2.30f, -0.22f), // pos2 front mid
    new Vector3(-4.15f, -2.12f, -0.24f), // pos3 front far
    new Vector3(-2.45f, -1.15f, -0.08f), // pos4 back (near, high)
    new Vector3(-3.55f, -1.32f, -0.10f), // pos5 back mid
    new Vector3(-4.55f, -1.50f, -0.14f), // pos6 back far
};
private static readonly Vector3[] EnemyFormationSlotPositions =
{
    new Vector3(0.65f, -2.20f, -0.20f),  // pos1 front (center-ward, low)
    new Vector3(1.75f, -2.30f, -0.22f),  // pos2 front mid
    new Vector3(2.85f, -2.12f, -0.24f),  // pos3 front far
    new Vector3(1.15f, -1.15f, -0.08f),  // pos4 back (near, high)
    new Vector3(2.25f, -1.32f, -0.10f),  // pos5 back mid
    new Vector3(3.25f, -1.50f, -0.14f),  // pos6 back far
};
```

## 수정 2 — 하드 클램프 (중앙 침범 물리적 차단, 무조건 적용)
`PreviewFormationPosition`의 `return positions[index];` 를 아래로 교체. **어떤 경로로 위치가
와도** 우리팀은 x≤−1.7, 적은 x≥+0.55로 강제 → 중앙 침범 불가능. (이게 핵심 안전장치.)

```csharp
var pos = positions[index];
// HARD GUARD: 절대 중앙을 넘지 않게. 우리팀=좌측, 적=우측 고정.
if (isOurHero) pos.x = Mathf.Min(pos.x, -1.7f);
else           pos.x = Mathf.Max(pos.x,  0.55f);
return pos;
```

## 수정 3 — 다른 위치 오버라이드 금지 확인
위치를 세팅하는 곳은 1330행·3454행 둘 다 `PreviewFormationPosition`만 거치게(이미 그러함).
혹시 `ReferenceLineupExtras`·per-character `case 100x: return Vector3(...)`·payload 좌표 직접대입
등 **다른 위치 소스가 있으면 제거**하고 전부 PreviewFormationPosition+클램프 한 경로로.

## 검증 (이번엔 수치로 확정)
- RESULT의 `visualActorWorldPositions`에서 **우리팀 전원 x ≤ −1.7**, **적 전원 x ≥ +0.55**.
- `visualActorScreenRects`에서 우리팀 cx 전부 화면중앙(640px) 왼쪽, 적 전부 오른쪽. 중앙 침범 0.
- 겹침 0 유지. 참고 첫 이미지처럼 좌(우리)·우(적) 두 덩어리 + 중앙 빈 띠.

## Codex 프롬프트
```text
git pull origin main. reports\CODEX_BATTLE_FORMATION_EXACT_FIX.md 그대로 적용:
BattlePlayModeBootstrap.cs의 OurFormationSlotPositions/EnemyFormationSlotPositions 배열을 문서값으로
교체(우리팀 x≤-1.95, 적 x≥+0.65), PreviewFormationPosition에 하드클램프(our x<=-1.7, enemy x>=0.55) 추가,
다른 위치 오버라이드 있으면 제거. 실행 후 RESULT의 visualActorWorldPositions로 우리팀 x≤-1.7/적 x≥+0.55
확정. commit+push.
```
