# CONTROL_TOWER_STATUS_20260626_015652

## Scope

- Project: `C:\Users\godho\Downloads\girlswar`
- Control tower thread remains active.
- Worker threads:
  - UI: `019eff6c-a02a-7f73-9ffb-74456322d1ce`
  - Battle: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`
  - Character/data: `019eff6d-307b-7532-8b1d-7105b18cd6b7`
- Main reference image: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- `C:\Users\godho\Downloads\참고.mp4` is auxiliary reference only.
- `C:\Users\godho\Downloads\플레이.mp4` is still missing.

## Current Verdict

- Main interface restored claim: `false`
- Battle playable/restored claim: `false`
- No final restored claim should be made from current artifacts.
- No fake HUD/card/icon, screenshot paste, whole-atlas placement, fake overlay, fake onClick, or coordinate-only success is allowed.

## UI State

Latest completed UI report:

- `reports\maininterface\MAININTERFACE_127_OLDROOT_BACKGROUND_RUNTIME_RESOURCE_AND_LAYER_STATE_RECONSTRUCTION_RESULT.md`

Confirmed:

- Old-root `UI_MainInterface_old` is the stronger candidate than the previous new-root layout.
- UI127 applied a candidate-only old-root background reconstruction:
  - activated `UI_MainInterface_old/UI_bg`
  - bound `runtime_UI_bg_noalphabg_PaintingBG_1005.png`
  - preserved real Hero1005 `SkeletonGraphic`
  - did not use whole `Painting_1005.png` as an Image
- UI127 improved visual state but is still not a reference match.
- UI127 click validation: `55 total / 45 active / 43 clickable / 2 blocked`
- Blocked active clicks:
  - `btn_discord` topped by `right/node_act_btn/btn_act_12/btn_act`
  - `UI_bg` topped by `UI_touchSpine`

Main UI blockers:

- `ActMgr:GetActInMain` runtime activity list/server/account snapshot is not reconstructed.
- Activity icons/text/spines remain placeholder or wrong.
- Text/font/TMP material/autosize/scale state is not fully restored.
- `btn_discord` cannot be hidden by review-branch evidence because the reference still shows normal non-review lobby/task elements.
- `UI_bg` has an original empty Button/no Lua listener state, but no source-backed raycast/interactable decision yet.

Dispatched follow-up:

- `MAININTERFACE_128_OLDROOT_RUNTIME_ACTIVITY_TEXT_TMP_AND_CLICK_LAYER_RECONSTRUCTION`
- Target thread: `019eff6c-a02a-7f73-9ffb-74456322d1ce`

Guardrails remain active:

- No arbitrary hide of `zhuye_di1`, `zhuye_bian`, `right/node_middle`, `wanfaWorldNode`, `worldwanfaBtn`, route/world nodes, or `node_act_btn/btn_act_*` without source-backed runtime evidence.

## Battle State

Latest completed battle report:

- `reports\battle\BATTLE_49_VALIDATE_REAL_CLICK_INPUT_AND_HANDLER_BINDING_RESULT.md`

Confirmed:

- BATTLE49 validates direct `GraphicRaycaster.Raycast` and `ExecuteEvents` receiver path for five original buttons.
- Ready buttons:
  - `btnAuto`
  - `btnBuff`
  - `btnTwoSpeed`
  - `btnFastSkill`
  - `btn_box`
- `GraphicRaycaster` target included: `5/5`
- `ExecuteEvents` click receiver/path validated: `5/5`
- `EventSystem.RaycastAll` target inclusion: `0/5`
- Known `onClick` listener rows: `0`
- Gameplay handler bound rows: `0`
- Total parent missing MonoBehaviours across rows: `34`
- Current visual status: `real_click_path_reaches_buttons_but_gameplay_handlers_missing`

Battle blockers:

- Direct raycast/click receiver path reaches the original Button objects, but original gameplay handlers are still missing.
- `EventSystem.RaycastAll` still returns no target inclusion, despite direct `GraphicRaycaster` success.
- Missing MonoBehaviour/Lua/IL2CPP handler chain for the five battle buttons must be traced before any playable claim.

Dispatched follow-up:

- `BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS`
- Target thread: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`

## Character/Data State

Latest manifest:

- `reports\battle\BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.md`

Confirmed:

- Local playable subset only, not full payload.
- Loadable actors: `3/12`
  - our `1002`
  - our `1034`
  - enemy `1100111 -> prefab 3001`
- `1036` actor bundle is missing/not locally fetchable.
- Several enemy ids remain unresolved.
- Use the manifest only after handler binding is restored, as local runtime validation support.

## Command Policy

- Root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- Policy currently OK.

## Next Control Actions

1. Wait for UI128 and BATTLE50 reports.
2. Read only generated report/json/csv outputs, not broad thread logs.
3. If BATTLE50 finds source-backed handler chain, proceed to handler binding/runtime validation.
4. If UI128 finds source-backed activity/text state, apply candidate-only UI fixes and revalidate visual diff/clicks.
5. Keep restored claims false until visual match and real interaction paths are proven.
