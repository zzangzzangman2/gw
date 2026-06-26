# CONTROL_TOWER_STATUS_20260626_020916

## Scope

- Project: `C:\Users\godho\Downloads\girlswar`
- Control tower remains active.
- UI worker: `019eff6c-a02a-7f73-9ffb-74456322d1ce`
- Battle worker: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`
- Character/data worker: `019eff6d-307b-7532-8b1d-7105b18cd6b7`
- Main reference image: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- `참고.mp4` remains auxiliary only.
- `플레이.mp4` remains missing.

## Current Restored Claims

- Main interface restored claim: `false`
- Battle playable/restored claim: `false`
- Character payload: local playable subset only, not full restore evidence.

## Battle Latest Completed

Latest report:

- `reports\battle\BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_RESULT.md`

Confirmed:

- Original handler paths are now source-backed:
  - `btnAuto`: `UI_NormalBattle` lines `86-110`, `btnAuto.onClick:AddListener`, calls `ChangeToAuto(true)` / `ChangeToManual()`.
  - `btnBuff`: `UI_NormalBattle` lines `180-184`, calls `ShowBuffView(f==false)`.
  - `btnTwoSpeed`: `UI_NormalBattle` lines `111-131`, calls `ModulesInit.ProcedureNormalBattle.SetGameSpeed()`.
  - `btnFastSkill`: `UI_NormalBattle` lines `132-146`, calls `ChangeGameFastSkill()` and `CheckFastSkill()`.
  - `btn_box`: `UI_BattleBoxPage` lines `162-178`, requires `CS.YouYou.UIEventListener.onClick`.
  - `UI_Battle3DUI` lines `3-20` require `CS.YouYou.LuaUnit`: `Init` / `Open`.
- Direct `GraphicRaycaster` target included: `5/5`.
- `EventSystem.RaycastAll` target included: `0/5`.
- `RaycasterManager` registered raycasters: `0`, including after toggle probe.
- Known restored UnityEvent/EventTrigger rows: `0`.
- Missing MonoBehaviours on buttons/parents total: `34`.
- Patch decision remains `blocked_no_patch`.

Battle next blocker:

- `BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION`

Dispatched to battle worker.

BATTLE51 must not add fake `onClick`/fake gameplay handlers. It must restore or prove the source-backed `LuaUnit`/`LuaComBinder`/`UIEventListener` bridge and resolve `RaycasterManager` registration with runtime/PlayMode evidence.

## UI Latest Completed

Latest report:

- `reports\maininterface\MAININTERFACE_128_OLDROOT_RUNTIME_ACTIVITY_TEXT_TMP_AND_CLICK_LAYER_RECONSTRUCTION_RESULT.md`

Confirmed:

- UI128 regenerated old-root + BG1005 + Hero1005 candidate capture.
- No new visual patch was applied.
- Restored claim remains `false`.
- UI126/UI127/UI128 full diff:
  - UI126 correlation `0.394045`, meanAbsDiff `0.317361`
  - UI127 correlation `0.424216`, meanAbsDiff `0.209078`
  - UI128 correlation `0.424216`, meanAbsDiff `0.209078`
- UI128 click validation: `55 total / 45 active / 43 clickable / 2 blocked`
- Blocked clicks:
  - `UI_bg` topped by `UI_touchSpine`
  - `btn_discord` topped by `right/node_act_btn/btn_act_12/btn_act`

Runtime activity evidence:

- Main activity wrappers are `btn_act_1..btn_act_8`.
- Face activity wrappers are `btn_face_item_1..btn_face_item_7`.
- `refreshMainAct()` first disables all wrapped activity items, then enables only `ActMgr:GetActInMain()` results.
- `GetActInMain()` chooses up to five dynamic groups: charge `1004`, recruit `1005`, welfare `1006`, activity `1007`, rally `1008`.
- `IsActShowInMain()` depends on `ActMgr.activitys`, server `show`, `IsOpen`, `PlayerMgr.PlayerInfo.vip/level`, redpoint/client callbacks, and review state.
- `UI_MainPageActItem:Refresh()` replaces prefab labels/icons with `GameTools.GetLocalize`, `ActCfgData.mainPageName/getActNewName`, and `mainPageSpineId/tbSpine`.
- Static prefab activity labels are not authoritative.

UI next blocker:

- Need real runtime/server/account snapshot or replay evidence for `ActMgr.activitys`, `PlayerMgr.PlayerInfo`, redpoint state, localization/font material binding.

Dispatched:

- `MAININTERFACE_129_TRACE_RUNTIME_ACCOUNT_ACTIVITY_SNAPSHOT_LOCALIZATION_FONT_BINDING`

UI129 must search for local snapshot evidence and produce a required snapshot schema if no authoritative snapshot exists. It must not guess/hide activity slots or patch text/icons by eye.

## Character/Data State

Latest completed manifest:

- `reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.md`
- `reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.json`
- `reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.csv`

Confirmed:

- Loadable actors: `3/12`
  - our `1002`
  - our `1034`
  - enemy `1100111 -> prefab 3001`
- `1036`: `not_fetchable_local`
- unresolved enemy payload instances remain unresolved.
- Use only after handler binding is restored, as local runtime validation support.

## Command Policy

- Root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- `_restore_tools\cmd_archive` wrappers are allowed and currently used for BATTLE50/UI128.

## Guardrails

- No fake HUD/card/icon/text/spine.
- No screenshot paste or whole-atlas placement.
- No fake transparent overlay or fake `onClick`.
- No coordinate-only success.
- No arbitrary hide of `zhuye_di1`, `zhuye_bian`, `right/node_middle`, `wanfaWorldNode`, `worldwanfaBtn`, route/world nodes, or `node_act_btn/btn_act_*`.
- No `btn_discord` review-branch hide as a normal-home fix.
- No `UI_bg` raycast/interactable edit without runtime source evidence.

## Next Control Actions

1. Read BATTLE51 outputs when generated.
2. Read UI129 outputs when generated.
3. If BATTLE51 proves source-backed bridge + EventSystem input, proceed to local playable subset runtime validation.
4. If UI129 finds an account/activity snapshot, dispatch reconstruction of active activity slots/text/icons.
5. Keep both restored claims false until visual and interaction evidence prove the requested end state.
