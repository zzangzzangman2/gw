# Codex Handoff — Watchable Battle in Unity Play Mode (decided 2026-06-27)

Self-contained. Goal **확정**: GirlsWar 전투를 **실제로 보면서 플레이** — Unity **Play Mode**에서
client 모드로 구동(코루틴/타이머/애니메이션이 프레임 단위로 자연히 진행) + Spine 비주얼.
헤드리스 배치(`-executeMethod`)는 프레임을 안 돌려 client 리플레이가 멈추므로 Play Mode가 정답.

Repo: `C:\Users\godho\Downloads\girlswar` • remote `github.com/zzangzzangman2/gw.git` (main)
Unity: `C:\Program Files\Unity\Hub\Editor\6000.4.9f1`. Battle project: `girlswar_battle_unity`.
최신 커밋: `c502e6c43` (이 핸드오프 push 후 갱신). 먼저 `git pull origin main`,
그리고 `python _restore_tools\scripts\decode_all_xlualogic.py` (decoded/xlua_all 재생성, gitignore됨).

## 핵심: 이번 세션이 만든 "데이터 배선 수정"은 Play Mode에도 100% 재사용

내가 헤드리스로 전투 Lua를 끝까지 구동하려다 푼 블로커들은 **프레임/뷰와 무관한 데이터·프레임워크
배선**이라 Play Mode bootstrap에도 그대로 적용해야 한다. **소스 = `girlswar_battle_unity/Assets/
Editor/GirlsWarLuaBootstrapMilestone2.cs`** 의 `RunServerReplay` (+ `SetupEnv`) 안에 전부 동작 검증된
형태로 들어있음. Play Mode용 MonoBehaviour bootstrap에서 이 순서로 똑같이 깔 것:

1. xLua `LuaEnv` + 커스텀 로더(`GirlsWarLuaLoader`).
2. **permissive `_G`(absorbing NOOP)** — `SetupEnv` 참고. 중요 패치: NOOP `__index`는 **숫자 키에
   nil** 반환(아니면 `ipairs(NOOp)`가 무한루프 — `HeroBattleInfo.SetHeroSkill`에서 실제로 터짐).
3. **`require('Common/Class')` 먼저** — 전역 `Class()`가 NOOP이면 `HeroCtrl=Class(...)`가 NOOP이 되어
   모든 영웅이 펫으로 오분류됨(=팀 ready 실패). (`BattleTeam`은 plain table이라 안 걸려서 헷갈림.)
   이어서 `Common/StringUtil`, `Common/TableUtil`(stdlib 확장: table.deepCopy/string.split 등).
4. 프레임워크 전역 require + 채택: `JsonUtil,GameTools,GameInit,CommonEventId,EventSystem,
   ModulesInit,PlayerMgr` (모듈이 자기 전역을 self-assign하면 그걸 우선).
5. 실제 모듈에 permissive `__index` 폴백(없는 native 메서드 → NOOP). `GameInit/EventSystem/
   ModulesInit/GameTools/PlayerMgr/...` 대상.
6. **C# `CS.YouYou.GameEntry` 스텁** = `Assets/Scripts/GirlsWar/YouYouStubs/GameEntryStub.cs`
   (UI/Time/Pool/Audio/Procedure/CameraCtrl/Effect/Resource/Instance/Video/**Scene/Lua**). Play
   Mode에선 여기서 **진짜 Spine 프리팹을 스폰**하도록 채우는 게 M3 핵심(아래 T3).
7. **`SaveMgr` 순수-lua 스텁**(저장된 prefs 없음 → 기본값) + **`PlayerMgr.PlayerInfo.uid =
   info.ourPlayerId`**(prefs 키 `string.format('%d_...',uid)`용).
8. **`HeroMgr` 스텁**: `GetHeroDataByHeroId(heroId)` → payload `ourHeros/enemyHeros`에서 heroId→
   {heroDid,...} 매핑(포메이션엔 heroId만 있고 heroDid 없음; OnOpen이 heroDid로 DTHeroRow 조회).
9. **데이터테이블 IO**: `GameTools.ClientIsSupportIOLoad = function() return false end` +
   로드된 모든 DB모델 `isLoadIO=false`로 flip → `.bigd` 대신 디코드된 inline Lua(`*EntityTableData`)
   사용. (이게 Codex 원래 핸드오프 **T1**과 동일.)
10. **`GameTools.GetLocalize`** → 문자열 반환 스텁(현지화 템플릿이 NOOP이라 gsub 터짐; 표시 전용).
11. `ModulesInit.ProcedureNormalBattle = <required PNB>` 바인딩 — 전투가 `ModulesInit.
    ProcedureNormalBattle.X`로 디스패치/상태참조하는데 폴백 NOOP이면 전부 no-op됨.

진입(데이터 와이어링의 본질): `OnEnter(a)`는 인자를 **저장하지 않음**. client 정식 진입은
`ProcedureNormalBattle.PlayFightClientReplay(battleInfo)` (battleType 최상위에 있는 객체 = payload의
`battleInfo`). 이게 `e.FightPlayData=t / e.BattleType=t.battleType / e.IsFightPlay=true /
e.curProcedureBattle=PNB:DefaultBattle()` 세팅 후 `GameEntry.Procedure:ChangeState(NormalBattle)`로
OnEnter를 부른다. Play Mode에선 Procedure 상태머신을 실제로 돌리거나, 최소로
`PNB.FightPlayData=info; PNB.IsFightPlay=true; PNB.curProcedureBattle=PNB:DefaultBattle();
PNB.ProcedureNormalBattle_OnEnter(info)` 호출. (헤드리스에선 `OnEnter` 완료=`battleEntered=true`까지
검증됨 — `RunServerReplay`/`Run` 참고.)

## Play Mode가 헤드리스보다 쉬운 점 (왜 이 방향)

- client 모드(`GameInit.IsClient=true`, 기본값) 그대로 두면 `cs_coroutine`→`GameEntry.Instance:
  StartCoroutine`이 **진짜 Unity 코루틴**으로 돈다 → wave/round 리플레이가 프레임 따라 자연 진행.
  (헤드리스 배치는 프레임이 없어 멈췄고, 그래서 내가 server 동기모드로 우회하다 `.bigd`/동기-루프
  벽을 만난 것. Play Mode에선 그 우회가 불필요.)
- 단, `GameEntry.Instance`가 **실제 MonoBehaviour**여야 StartCoroutine이 동작 → bootstrap은
  `-executeMethod`가 아니라 **씬에 올라간 MonoBehaviour**(`Awake/Start`에서 부팅)로 만들 것.

## Play Mode 작업 순서 (제안)

- **P1 부트스트랩 MonoBehaviour**: 위 1~11 + 진입을 `MonoBehaviour.Start()`에서 수행하는
  `BattlePlayModeBootstrap.cs` 작성. `GameEntry.Instance`를 이 컴포넌트(또는 실제 코루틴 가능한
  객체)로 연결해 StartCoroutine이 살아있게. 씬: `Assets/Scenes/`에 빈 씬 + 이 컴포넌트.
- **P2 데이터 완결**: 현재 프론티어 = 적 몬스터 데이터. enemy `heroDid` `1100111/1100112/1100113`가
  inline `DTMonsterEntityTableData`에 **없음**(그룹 base `1100110`만 있음; 끝자리 0). 두 갈래:
  (a) `1100110` 같은 그룹 base로 매핑(=`heroDid - heroDid%10`) — 원본이 그렇게 조회하는지
  `LoadEnemyPlayerHeros`/`HeroCtrl:OnOpen`(833~) 추적; (b) 완전판은 암호화 `.bigd`
  (`girlswar_merged_extracted/extracted/config_zips/.../monster/DTMonsterEntityTableData(.Header).bigd`,
  XXTEA key `lkjaljaaasrte`)에 있으니 IO 경로 provision + `isLoadIO=true` 유지. 권장: 먼저 (a) 확인.
- **P3 비주얼(M3 view lane)**: `GameEntry.Pool.GameObjectSpawn(prefabId, parent, cb)`가 실제 Spine
  액터 프리팹을 스폰하고 cb(transform)로 콜백하게 구현. heroDid→Spine skeleton/atlas/texture 매핑은
  `reports/characters/GIRLSWAR_CHARACTER_CATALOG.json` + `girlswar_merged_extracted/indexes/
  {assetbundles,unity_objects,unity_images}.csv`. `LuaHeroSprite/ScrollScene/TimelineEffect`
  (YouYouStubs)을 실제 Spine `SkeletonAnimation`+DOTween으로 채움(원 핸드오프 T3/T4와 동일).
  `actionType 1/2/3` 의미는 `decoded/xlua_battle/.../BattleManager`·state-machine Lua에서.
- **P4**: 한 판(샘플 전투, map 11001, our 1036/1002/1034 vs 1100111.. waves)이 끝까지 재생되고
  HP/라운드가 데이터와 일치하면 완료.

## 샘플 전투 데이터 (이미 확보)

`girlswar_battle_unity/Assets/RestoreData/battle/BATTLE_TEST_PAYLOAD.json` = `ProcedureNormalBattle`
589행 임베드 샘플과 동일. our heroDid 1036/1002/1034(heroId 51469/50870/50874), 3 waves of
1100111.., `battleType=1`(campaign), `mapId=11001`, `fightResult=1`, `randomSeed=445106`,
per-smallRound `actionData`(heroId/actionType/fireHeroId) + 최종 `heroStatistics`(검증용).

## 가드레일 / 주의

- 실제 전투 데이터를 재생; 결과 날조 금지. 뷰콜 no-op은 로직에 영향 없을 때만.
- 원본/디코드 Lua/증거(.bigd, XAPK, 번들) 삭제 금지. 매 동작 commit+push to main. 루트 CMD 1개 유지.
- `Assets/XLua/Src/LuaDLL.cs`의 `lua_tostring` **UTF-8 강제 패치 원복 금지**(게임 Lua의 CJK).
- 디코드 `DTMonsterEntityTableData`는 inline이라 일부 id 누락 가능 → 완전판은 `.bigd`.

## 새 챗(Codex)용 프롬프트

```text
작업 위치는 반드시 C:\Users\godho\Downloads\girlswar.
reports\CODEX_HANDOFF_PLAYMODE_BATTLE_20260627.md 먼저 읽고 이어가.
목표: GirlsWar 전투를 Unity Play Mode(client 모드, 실제 프레임)에서 보면서 플레이 + Spine 비주얼.
재사용: girlswar_battle_unity/Assets/Editor/GirlsWarLuaBootstrapMilestone2.cs 의 RunServerReplay/
SetupEnv 안에 검증된 데이터 배선 수정 11종이 다 있음(Class/ModulesInit바인딩/HeroMgr/SaveMgr/
GetLocalize/isLoadIO=false/IsClient/ipairs-NOOP/GameEntry스텁/FightPlayData진입). 이걸 Play Mode용
MonoBehaviour 부트스트랩(Start에서 부팅, GameEntry.Instance=실제 코루틴 가능 객체)으로 옮겨.
진입은 PlayFightClientReplay(battleInfo) 또는 동등 세팅 후 OnEnter. 프론티어=적 몬스터 데이터
(heroDid 1100111 vs 1100110, .bigd vs inline). 그 다음 Pool.GameObjectSpawn에 실제 Spine 프리팹
연결(P3). 매 동작 commit+push to main.
```
