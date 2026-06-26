# MAININTERFACE_130_RUNTIME_ACTIVITY_SNAPSHOT_IMPORT_REPLAY_PIPELINE_NO_FAKE_PATCH_RESULT

## Verdict

`restoredClaim=false`. UI130 added a runtime snapshot import/replay pipeline only. No scene visual patch was applied.

Default replay status is `blocked_missing_runtime_snapshot_fields` because the generated template intentionally contains no real runtime activity/account/server state.

## Pipeline

- script: `C:\Users\godho\Downloads\girlswar\_restore_tools\scripts\maininterface130_runtime_activity_snapshot_replay.py`
- default snapshot template: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_130_runtime_activity_snapshot_template.json`
- replay result JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_130_runtime_activity_snapshot_replay_result.json`
- replay result MD: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_130_runtime_activity_snapshot_replay_result.md`
- replayable fields CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_130_replayable_fields.csv`

The script accepts an optional snapshot path:

```powershell
python .\_restore_tools\scripts\maininterface130_runtime_activity_snapshot_replay.py --snapshot .\reports\maininterface\MAININTERFACE_130_runtime_activity_snapshot_template.json
```

## Missing Runtime Fields

- `activitys`
- `faceActivitys`
- `playerInfo.level`
- `playerInfo.vip`
- `redPointState.serverRedPointIds`
- `reviewState.GameTools_IsReview`
- `reviewState.GameEntry_IsReview`
- `reviewState.GameEntry_IsCommittee`
- `guideState.ModulesInit_GuideMgr_isGuide`
- `timeState.serverTimeStep`
- `timeState.serverMillTimeStamp`
- `clientCallbackOutputs.showInMainFunc`
- `clientCallbackOutputs.clientCheckIsOpen`
- `clientCallbackOutputs.getActNewName`
- `clientCallbackOutputs.mainPageTouchJumpId`

## Source-Backed Replay Rules

- Uses decoded `ActMgr`/`ActCfgData` from `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\clean_unityfs_slices\download\xlualogic\datanode\datamanager\datamgr.assetbundle`.
- Requires `activitys` instead of fabricating active activity ids.
- Requires `PlayerMgr.PlayerInfo` level/vip fields for `IsActShowInMain` filtering.
- Requires redpoint/review/guide/time/client callback fields before producing a candidate patch plan.
- Uses `DTLangCommon` from `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\bundles\b_7e5552edea2c10f4\textassets\-2670652165716608051_DTLangCommon.txt` for labels only after an active activity id/key is source-backed.
- Uses TMP/font material evidence from `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_shared_materials.csv` as binding evidence, not as a reason to invent visible labels.

## Guardrails

- Did not hide `node_act_btn/btn_act_*`.
- Did not hide `btn_discord` using review branch evidence.
- Did not set `UI_bg` raycast/interactable off.
- Did not fake icons/text/spines or paste screenshots/whole atlases.
- No candidate patch is allowed until a real snapshot passes validation.

## Command Policy

- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`

## Outputs

- result JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_130_RUNTIME_ACTIVITY_SNAPSHOT_IMPORT_REPLAY_PIPELINE_NO_FAKE_PATCH_RESULT.json`
- template JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_130_runtime_activity_snapshot_template.json`
- replay result JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_130_runtime_activity_snapshot_replay_result.json`
- replay result MD: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_130_runtime_activity_snapshot_replay_result.md`
- replayable fields CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_130_replayable_fields.csv`
