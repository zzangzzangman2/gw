# GirlsWar Work Split Status - 2026-06-25 17:17 KST

## Coordinator

- Main workspace: `C:\Users\godho\Downloads\girlswar`
- Git branch: `main`
- Remote: `https://github.com/zzangzzangman2/gw.git`
- Originals/evidence are still preserved. Do not delete `girl1.xapk`, `com.girlwars.kr`, OBB, or extracted evidence until coverage and usage are documented.

## UI Thread

- Thread: `GirlsWar UI 복원 전용`
- Current status: active
- Current task: MainInterface right route cluster multi-layer fallback refinement from original atlas/renderer evidence.
- New tools created:
  - `ANALYZE_MAININTERFACE_ROUTE_RENDERERS.cmd`
  - `_restore_tools\99_ANALYZE_MAININTERFACE_ROUTE_RENDERERS.cmd`
  - `_restore_tools\scripts\analyze_maininterface_route_renderers.py`
- Current evidence:
  - `spine_diqiu` maps to `Spine_shijieanniu` in `maininterface_ext_8.assetbundle`.
  - `Spine_shijieanniu.png` contains `diqiu`, `zhuye_di1`, `zhuye_bian`, `yun`, `yun2`.
  - `spine_xiaoren` maps to `download/roleprefabsandres/npcprefabandres/8007.assetbundle`, `8007_SkeletonData`, `8007.png`.
- Completed before current prompt:
  - `reports\maininterface\MAININTERFACE_ROUTE_RENDERER_ASSET_TRACE.md`
  - Evidence-based bitmap fallback was generated for `Spine_shijieanniu_diqiu`.
  - Unity build/capture/click validation passed with active clickable `24/24`, blocked `0`, invoked `24`.
- Prompt sent at about 17:16 KST:
  - Inspect latest capture and evaluate whether single `diqiu` fallback is visually correct.
  - Split `Spine_shijieanniu.atlas` regions `diqiu`, `zhuye_di1`, `zhuye_bian`, `yun`, `yun2` into evidence-based multi-layer fallback candidates.
  - Apply to `wanfaWorldNode` only when original hierarchy/region/rect evidence supports it.
  - Try `8007` fallback for `spine_xiaoren` only if rect/scale evidence is solid.
  - Rebuild, graphics capture, click validation, then write `reports\maininterface\MAININTERFACE_ROUTE_RENDERER_FALLBACK_RESULT.md`.

## Battle Thread

- Thread: `GirlsWar 전투 구현 전용`
- Current status: active
- Current task: `BATTLE_10` AssetBundle streaming/load probe.
- Current progress:
  - `BATTLE_07` minimal scene is generated and verified.
  - Scene: `girlswar_battle_unity\Assets\Scenes\BattlePrototype.unity`
  - Actor placeholders: 12 (`our=3`, `enemy=9`)
  - Missing referenced bundles from BATTLE_07 manifest: 4
- Current BATTLE_08 findings:
  - Enemy monster IDs such as `1100111` are in `DTMonster_KEntity` / `DTMonster_OEntity`, not just base `DTMonsterEntity`.
  - 3 of 4 missing bundle refs likely come from path normalization from asset path to `.assetbundle`.
- Current BATTLE_08 outputs as of 17:10 KST:
  - `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_ASSETBUNDLE_LOAD_MAP.json`
  - `reports\battle\BATTLE_ASSETBUNDLE_SPINE_LOADING_PLAN.md`
- BATTLE_08 final verified summary:
  - Actor loadable: `3/12`
  - Loadable actors: our `1002`, our `1034`, enemy `1100111 -> 3001`
  - Map candidates: `10`
  - Skill candidates: `24`
  - Remaining missing: `1` CDN-listed not extracted, `3` path-normalize issues
- BATTLE_09 completed:
  - Scene: `girlswar_battle_unity\Assets\Scenes\BattleAssetBackedPreview.unity`
  - Report: `reports\battle\BATTLE_ASSET_BACKED_PREVIEW_RESULT.md`
  - Visual manifest: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_ASSET_BACKED_PREVIEW_VISUALS.json`
  - Visual assets copied: `12`
  - Map layers: `3`
  - Actor texture fallback: `3` (`1002`, `1034`, `1100111/3001`)
  - Missing actor placeholders: `9`
- BATTLE_10 prompt sent at about 17:17 KST:
  - Add `_restore_tools\BATTLE_10_PROBE_ASSETBUNDLE_STREAMING.cmd`.
  - Probe loadable actor bundles `1002`, `1034`, `3001` plus representative map 11001 bundles using Unity `AssetBundle.LoadFromFile`.
  - Record load success/fail, asset names, asset type counts, prefab instantiate status, dependency issues.
  - Optional scene: `girlswar_battle_unity\Assets\Scenes\BattleAssetBundleStreamingProbe.unity`.
  - Output JSON: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_ASSETBUNDLE_STREAMING_PROBE.json`.
  - Report: `reports\battle\BATTLE_ASSETBUNDLE_STREAMING_PROBE_RESULT.md`.

## GitHub Push

- First push started: 2026-06-25 16:23:46 KST
- Current status at 17:16:09 KST:
  - `git-lfs.exe` is still running in pre-push.
  - `remote refs/heads/main` is not created yet.
  - Follow-up push watcher is waiting for the existing `git-lfs.exe`.
- Do not kill the upload unless explicitly requested.
- After first push exits, the follow-up watcher should commit and push the newer UI/Battle files.
