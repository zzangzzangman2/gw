# CONTROL_TOWER_STATUS_20260626_020035

## Scope

- Project: `C:\Users\godho\Downloads\girlswar`
- Control tower remains active.
- UI worker: `019eff6c-a02a-7f73-9ffb-74456322d1ce`
- Battle worker: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`
- Character/data worker: `019eff6d-307b-7532-8b1d-7105b18cd6b7`

## Current Status

- `BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS` is still in progress.
- `MAININTERFACE_128_OLDROOT_RUNTIME_ACTIVITY_TEXT_TMP_AND_CLICK_LAYER_RECONSTRUCTION` is still in progress.
- No `reports\battle\BATTLE_50*` files exist yet.
- No `reports\maininterface\MAININTERFACE_128*` files exist yet.
- Do not treat current mid-run observations as final report verdicts.

## Restored Claims

- Main interface restored claim: `false`
- Battle playable/restored claim: `false`
- Character payload: local playable subset only, not a full restore claim.

## Battle In-Progress Evidence

Observed from the active battle worker turn:

- BATTLE50 is decoding original UI Lua TextAssets from the clean `download/xlualogic/modules/maincity.assetbundle` source path after extracted `.txt` payloads appeared damaged.
- Original handler direction is now visible:
  - `UI_NormalBattle` binds `btnAuto`, `btnTwoSpeed`, `btnFastSkill`, and `btnBuff` through `onClick:AddListener(function...)`.
  - `UI_BattleBoxPage` binds `btn_box` through `CS.YouYou.UIEventListener` AddComponent/Init and `onClick`.
- The next expected BATTLE50 evidence is an Editor probe over the BATTLE49 scene for:
  - missing MonoBehaviour chain
  - `RaycasterManager`/`BaseRaycaster` registration state
  - direct `GraphicRaycaster` vs `EventSystem.RaycastAll` cause split

Do not convert these into fake Unity `onClick` bindings. Candidate binding must follow the source-backed Lua/IL2CPP bridge path or remain `blocked_no_patch`.

## UI In-Progress Evidence

Observed from the active UI worker turn:

- `UI_MainPageActItem` does not trust prefab placeholder labels; activity labels are runtime-populated.
- `txt_act_name` is populated via `GameTools.GetLocalize(...)` and `ActCfgData.mainPageName/getActNewName` or server activity name.
- Main activity slots are source-backed as `btn_act_1..8` through the Lua `le={...}` array plus `ActMgr:GetActInMain()`.
- `btn_face_item_1..7` are a separate face activity group.
- `btn_discord` still only has hide evidence in the review branch. It should not be hidden as a normal-home fix without non-review runtime evidence.
- `ActMgr` and `ActCfgData` raw TextAssets appear to decode with the same 22-byte `SecurityUtil.xorScale` rule used for MainInterface Lua; the worker is checking whether `GetActInMain` is static-table-deterministic or server/account-snapshot dependent.

No activity-slot hide, placeholder replacement, or text patch should be accepted until the worker emits source-backed UI128 evidence.

## Character/Data State

Latest completed data manifest:

- `reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.md`
- `reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.json`
- `reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.csv`

Confirmed:

- Actor loadable: `3/12`
  - our `1002`
  - our `1034`
  - enemy `1100111 -> prefab 3001`
- `1036`: `not_fetchable_local`
- unresolved enemy payload instances remain unresolved.
- Use this manifest only after battle input/handler binding is restored; it is runtime validation support, not full payload evidence.

## Command Policy

- Root `.cmd` count remains `1`.
- `_restore_tools` direct `.cmd` count remains `0`.

## Next Control Actions

1. Continue polling for `BATTLE_50*` and `MAININTERFACE_128*` reports.
2. When BATTLE50 lands, verify whether source-backed handler chain is actionable or still missing bridge components.
3. When UI128 lands, verify whether `ActMgr:GetActInMain` can be reconstructed from local evidence or must remain server-snapshot-blocked.
4. Dispatch the next worker task only after reading completed report/json/csv outputs.
