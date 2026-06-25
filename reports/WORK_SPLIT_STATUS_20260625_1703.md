# Work Split Status - 2026-06-25 17:03

## UI thread

- Thread id: `019efdb6-503d-7373-be2b-6dcd1a247b1a`
- Last completed work: MainInterface route cluster restore pass.
- New report: `reports\maininterface\MAININTERFACE_ROUTE_CLUSTER_RESTORE_RESULT.md`
- Result: `UI_Main_wanfa_item_1..4` and `wanfaWorldNode` are all active in original evidence, so disabling route owners is not correct.
- Applied fix: `UI_Main_wanfa_item_3/4 Entry` original `localScale=0,0,0` is preserved through route override CSV and SceneBuilder.
- Verification: Unity build success, route rect/scale overrides `4/4`, graphics capture visible pixels `1201679`, click validation active `24/24`, blocked `0`, invoked `24`.
- Remaining UI issue: `spine_diqiu`, `spine_xiaoren`, `Entry`, `un_MainInterface_fire` are Spine/particle-style MonoBehaviour renderer paths not yet rendered by the Image/TMP SceneBuilder.
- Next work sent: trace route renderer assets and create `MAININTERFACE_ROUTE_RENDERER_ASSET_TRACE.md`, with possible bitmap fallback.

## Battle thread

- Thread id: `019efdb6-9db2-7e52-bbef-c959eb4d619e`
- Completed `BATTLE_05` minimum prototype manifest.
- New files include:
  - `_restore_tools\BATTLE_05_BUILD_PROTOTYPE_MANIFEST.cmd`
  - `reports\battle\BATTLE_TEST_PAYLOAD.json`
  - `reports\battle\BATTLE_PROTOTYPE_MANIFEST.json`
  - `reports\battle\BATTLE_PROTOTYPE_BUILD_PLAN.md`
- BATTLE_05 verification: payload `mapId=11001`, `battleType=1`, `randomSeed=445106`; referenced bundles `11/15` exist, `4` missing.
- Completed `BATTLE_06` prototype folder setup.
- Prototype folder: `girlswar_battle_unity`
- Prototype data copied/generated: `Assets\RestoreData\battle` has `7` files.
- BATTLE_07 skeleton exists: `_restore_tools\BATTLE_07_BUILD_MINIMAL_BATTLE_SCENE.cmd` and `girlswar_battle_unity\Assets\Editor\BattlePrototypeSceneBuilder.cs`.
- Next work sent: make BATTLE_07 create an actual minimal battle scene with map/actor/skill placeholders and write `reports\battle\BATTLE_MINIMAL_SCENE_BUILD_RESULT.md`.

## GitHub push

- First `git push -u origin main` is still running through `git-lfs.exe`.
- Remote `refs/heads/main` is not created yet as of `2026-06-25 17:03`.
- Follow-up watcher is still waiting for the existing `git-lfs.exe`; it should commit/push the new UI/Battle outputs after the first push exits.
