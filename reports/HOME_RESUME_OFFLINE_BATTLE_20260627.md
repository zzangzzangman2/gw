# Home Resume — Offline Battle Runtime (이어서 작업용)

작성: 2026-06-27 KST. 이 세션에서 한 일 + 정확한 현재 위치 + 이어가는 법.
작업 위치: `C:\Users\godho\Downloads\girlswar`  •  remote `github.com/zzangzzangman2/gw.git` (main)

## 먼저 Pull

```powershell
cd C:\Users\godho\Downloads\girlswar
git pull origin main
# 생성물(gitignore됨) 재생성:
python _restore_tools\scripts\decode_all_xlualogic.py   # decoded/xlua_all (17398 lua)
```

마지막 커밋: `424c1a4f7` (이 핸드오프 push 후 갱신됨).

## 이번 세션 큰 그림 (무엇을/왜)

사용자 목표가 "걸스워를 **실제로 플레이**"로 확정됨. 두 갈래 판정:
- **풀 온라인 게임 = 불가**: 네트워크 프로토콜/암호화가 네이티브 `libil2cpp.so`에 있고(Lua에 protobuf 0건, XXTEA/RSA 인증), 원본 서버가 죽어 "정답 응답"을 관찰 불가.
- **오프라인 전투 리플레이 = 가능**: 전투가 시뮬이 아니라 **데이터 기반 리플레이**(서버가 actionData+결과를 내려주고 클라는 재생). 완전한 샘플 전투가 `ProcedureNormalBattle` 589행에 임베드, 그리고 `BATTLE_TEST_PAYLOAD.json`에 battleInfo 구조 있음. → **데미지 공식/RNG 리버싱 불필요.**

그래서 **런타임 트랙**(xLua VM 세워서 전투 Lua 실제 구동)으로 전환. 기존 워커들이 정적 씬 화장만 반복하며 막혔던 진짜 이유 = 런타임을 안 세움.

(이전 작업 참고: 정적 snapshot resolver로 전투 패킷 7337중 5422(74%) 소스기반 충전 — `reports/battle/BATTLE_85_STATIC_SNAPSHOT_RESOLVER_RESULT.md`. 이건 화면 복원 트랙이고, 플레이 트랙과는 별개.)

## 런타임 트랙 현재 위치

- **M1 완료·검증**: xLua(Tencent MIT) vendored → Unity 6 컴파일 + LuaEnv 부팅 + 디코드 게임모듈 로드. (`BATTLE_86`)
- **M2 진행중 — 헤드리스 전투가 실제 로직 실행 중**:
  - xLua 부팅 → **329 모듈 전부 로드** → `BATTLE_TEST_PAYLOAD` JSON 디코드(pure-lua) →
    `ProcedureNormalBattle_OnEnter` 실행 → 이벤트등록/오디오 통과 →
    **`InitBattleInfo` 740행에서 실제 battleInfo 처리 중.**
  - **프레임워크 무력화(어렵고 일반적인 부분)는 사실상 완료.**

### 정지점 (다음 할 일) — 이제 no-op이 아니라 **데이터 와이어링**
`InitBattleInfo:740` `i.GetEntity(e.BattleType)`가 nil → 에러분기에서 `e.BattleType`(역시 nil) concat 크래시. 원인 2가지:
1. **`e.BattleType`가 우리 payload(`battleType=1`)에서 연결 안 됨.** OnEnter(a)가 받은 `a`(battleInfo)를 `FightPlayData`/`BattleType`로 저장하는 흐름을 추적해 셋업 필요. (PNB ~785행 OnEnter, ~700행대 InitBattleInfo. 589행 임베드 샘플이 `e.FightPlayData=...battleInfo` 패턴 보여줌.)
2. **`DTBattleDBModel.GetEntity(1)`이 오프라인에서 채워져야.** 데이터테이블은 `if GameInit.ServerLoadTable then 서버 else IO-load`. 오프라인 IO-load 경로가 실제로 테이블을 채우는지 확인/플래그 설정 필요. → **이건 Codex 핸드오프 T1과 정확히 겹침** (`reports/CODEX_HANDOFF_VIEW_LANE.md`).

그 다음: wave/round 리플레이를 끝까지 돌려 BattleResult 산출 → `battleEntered=true`.

## 이어가는 법 (반복 루프)

```powershell
# M2 헤드리스 전투 1회 실행 (컴파일 + 실행, 수 분)
& "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe" -quit -batchmode -nographics `
  -projectPath girlswar_battle_unity `
  -executeMethod GirlsWar.GirlsWarLuaBootstrapMilestone2.Run `
  -logFile reports\battle\BATTLE_88_M2_HEADLESS_BATTLE.log
# 결과: reports\battle\BATTLE_88_M2_HEADLESS_BATTLE_RESULT.json (failedStage/error 확인)
```
루프: 실행 → `error`/`failedStage` 확인 → 해당 Lua/스텁 수정 → 재실행. (집 = GUI 가능하니 Unity 에디터로 디버깅해도 됨.)

## 핵심 파일 (내가 만든 것)

런타임 코어 (Claude 레인):
- `girlswar_battle_unity/Assets/Editor/GirlsWarLuaBootstrapMilestone2.cs` — 하니스(단계별 pcall, 결과 JSON). **여기가 작업 중심.**
- `girlswar_battle_unity/Assets/Scripts/GirlsWar/GirlsWarLuaLoader.cs` — require→디코드파일 경로인식 로더.
- `girlswar_battle_unity/Assets/Scripts/GirlsWar/YouYouStubs/` — `YouYouCoreStubs.cs`(MacroDefine/ProcedureState/AsyncLoadManager), `GameEntryStub.cs`(C# GameEntry 서브시스템, 객체반환=Lua NOOP), `YouYouViewStubs.cs`(뷰 no-op; Codex가 M3 채움).
- `girlswar_battle_unity/Assets/XLua/` + `Plugins/x86_64/xlua.dll` — vendored xLua. **`Assets/XLua/Src/LuaDLL.cs`의 `lua_tostring`은 UTF-8 강제로 패치됨**(게임 Lua의 CJK 때문, 원복 금지).

도구/스크립트:
- `_restore_tools/scripts/decode_all_xlualogic.py` — xlualogic 593번들 디코드(raw vs XOR 중 lua다운 쪽 선택). 출력 `decoded/xlua_all`(gitignore).
- `_restore_tools/scripts/analyze_battle_lua_closure.py` — 전투 require 폐포 + CS.* 표면 분석.

문서:
- `reports/OFFLINE_BATTLE_RUNTIME_PLAN.md` — 전체 계획 + Claude/Codex 분담.
- `reports/battle/BATTLE_87_M2_SCOPE_AND_STUB_WORKLIST.md` — M2 스코프(폐포 329, CS.YouYou 8클래스).
- `reports/battle/BATTLE_88_M2_PROGRESS.md` — M2 진행/정지점 상세.
- `reports/CODEX_HANDOFF_VIEW_LANE.md` — Codex 뷰 레인(T1 데이터테이블 로드가 지금 코어와 맞물림).

## 이번 세션에 푼 블로커 (재발 시 참고)
strict-global 무한재귀→흡수형 NOOP permissive _G / `nil>=0`→NOOP 비교·산술 메타메서드 /
xLua `lua_tostring` CJK 크래시→UTF-8 강제 / decode_all 오분류→raw-vs-XOR 분류기 /
JsonUtil boolean 덮어쓰기→자기설정전역 보존 / rapidjson→BuildPatchMgr 스텁(pure-lua json) /
실제모듈 누락메서드→__index 체이닝 폴백 / CS.YouYou.GameEntry→C# 서브시스템 스텁 / 오디오→스킵.

## 가드레일
- 실제 전투 데이터를 리플레이; 전투 결과 날조 금지. 뷰콜은 로직에 영향 없을 때만 no-op.
- 원본/디코드 Lua/증거 삭제 금지. 배치 헤드리스 검증 우선. 매 동작 commit+push to main. 루트 CMD 1개 유지.

## 새 채팅용 프롬프트

```text
작업 위치는 반드시 C:\Users\godho\Downloads\girlswar 야.
reports\HOME_RESUME_OFFLINE_BATTLE_20260627.md 먼저 읽고 이어가.
목표: 오프라인 전투 리플레이를 실제로 구동(런타임 트랙). 풀 온라인은 불가 판정됨.
M2 진행중: 하니스(GirlsWarLuaBootstrapMilestone2)가 전투 Lua를 InitBattleInfo 740행까지 구동.
프레임워크 무력화는 끝났고, 남은 건 데이터 와이어링 2개:
(1) e.BattleType를 BATTLE_TEST_PAYLOAD(battleType=1)에서 OnEnter 데이터흐름으로 연결,
(2) DTBattleDBModel.GetEntity(1)이 오프라인 IO-load로 채워지게(=Codex T1과 겹침).
반복루프: Unity 배치로 GirlsWarLuaBootstrapMilestone2.Run 실행 → BATTLE_88..RESULT.json의
error/failedStage 확인 → 수정 → 재실행. battleEntered=true 까지.
Assets/XLua/Src/LuaDLL.cs lua_tostring UTF-8 패치는 원복 금지(CJK). decoded/xlua_all는
decode_all_xlualogic.py로 재생성. 매 동작 commit+push to main.
Codex는 뷰/비주얼 레인(reports\CODEX_HANDOFF_VIEW_LANE.md) 별도 진행.
```
