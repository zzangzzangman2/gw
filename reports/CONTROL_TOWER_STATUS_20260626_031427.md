# CONTROL_TOWER_STATUS_20260626_031427

## Overall
- Project: `C:\Users\godho\Downloads\girlswar`
- Final main UI restored claim: `false`
- Final playable battle screen claim: `false`
- Reference image: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- `참고.mp4`: available, auxiliary visual reference only.
- `플레이.mp4`: missing.

## Active Threads
- Control tower: current thread.
- UI worker: `019eff6c-a02a-7f73-9ffb-74456322d1ce`
- Battle worker: `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`
- Character/data worker: `019eff6d-307b-7532-8b1d-7105b18cd6b7`

## MainInterface State
Latest completed UI result:
- `MAININTERFACE_132_SOURCE_BACKED_STATIC_TMP_FONT_MATERIAL_BINDING_AUDIT_AND_CANDIDATE_PATCH_NO_DYNAMIC_TEXT`
- Result: `blocked_no_patch`
- Scene patch applied: `false`
- Static TMP/font/material lane has no new safe target.
- Text node audit: total `80`, visible `27`.
- Classification: `static_source_identified=7`, `dynamic_runtime_snapshot_required=62`, `unknown_needs_probe=11`, `guardrail_blocked=0`.
- Static TMP evidence rows: `7`; all are already bound to source-backed `Assets/RestoreData/TMP/static_probe` materials.
- Dynamic activity/chat/account/currency/top values remain excluded until runtime snapshot.

Current UI worker task:
- `MAININTERFACE_133_HOME_HEROSPINE_BG_BOTTOM_NAV_RUNTIME_LAYOUT_PROBE_NO_COORDINATE_PATCH`
- Status: in progress.
- Current finding before Unity probe: `hero1005` has `homePara={1,0,0}` and Lua call evidence, but `UIUtil.GetPlayerBigSpineAll` transform semantics are not yet source-confirmed.
- Current direction: no coordinate patch; probe hero/BG/bottom nav rect, canvas, sibling, mask, material, click/raycast state.

MainInterface guardrails still active:
- Do not arbitrarily hide `zhuye_di1`, `zhuye_bian`, `right/node_middle`, `wanfaWorldNode`, `worldwanfaBtn`, route/world nodes, `node_act_btn/btn_act_*`, or `btn_discord`.
- Do not disable `UI_bg` raycast/interactable without source evidence.
- No fake text/icon/spine, screenshot paste, whole atlas, coordinate-only alignment, or debug/evidence labels.

## Battle State
Latest completed battle result:
- `BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH`
- Result: `blocked_no_patch`
- Scene patch applied: `false`
- Unity exit code: `0`
- Source bundle audit:
  - actor prefab rows `3`
  - bundle/prefab load `3/3`
  - live prefab mesh-ready `3/3`
  - SkeletonAnimation/SkeletonData rows `3/3`
  - project-imported prefab rows `0`
  - live prefab total mesh vertices `2626`
- Current saved scene gap:
  - scene actor rows `3`
  - scene mesh-ready `0`
  - scene material-ready `0`
  - import gap `assetbundle_runtime_references_not_persisted_in_saved_scene=3`
- Interpretation: BATTLE39/BATTLE51 saved scene retained Transform/MeshRenderer shell components, but live AssetBundle Spine mesh/material/SkeletonData/atlas references did not persist as project PPtrs after reopen.

Current battle worker task:
- `BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH`
- Status: in progress.
- Goal: reuse/source-back BATTLE37 live AssetBundle actor render path in BATTLE51 candidate builder/capture path, or prove persistent import/runtime rehydration is not possible.
- Required validation: actor mapping CSV, renderer/material/shader CSV, bounds/frustum/pixel evidence, candidate capture/contact if actors render.
- Keep `playable=false` unless HUD/card/button interaction and actor rendering are both source-backed and working.

Battle guardrails still active:
- No fake actor/card/icon/text/onClick/gameplay handler.
- No screenshot paste, whole-atlas actor, dummy mesh, coordinate-only success, external xLua/package import/download, or non-source sprite substitution.
- Local actor subset remains validation-only, not full restore claim.

## Character/Data Manifest
- `BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST` completed.
- Local loadable actor subset: `3/12`.
- Loadable actors: our `1002`, our `1034`, enemy `1100111 -> 3001`.
- `1036`: `not_fetchable_local`.
- Enemy `1100112`, `1100113`, `1100121`, `1100122`, `1100123`, `1100131`, `1100132`, `1100133`: unresolved locally.
- Skill rows `61`: loadable `4`, loadable with unresolved common deps `8`, data-only missing actor `27`, passive/no timeline `22`.

## Command Policy
- Root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- New command wrappers should remain under `_restore_tools\cmd_archive`.

## Immediate Next Checks
- Read UI133 outputs once generated under `reports\maininterface\MAININTERFACE_133*`.
- Read BATTLE57 outputs once generated under `reports\battle\BATTLE_57*`.
- Do not mark restore complete until real capture/reference match and battle interaction/render evidence both pass.
