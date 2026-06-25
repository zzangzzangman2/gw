# GirlsWar Work Split Status - 2026-06-25 17:48 KST

## Coordinator

- Main workspace: `C:\Users\godho\Downloads\girlswar`
- Git branch: `main`
- Remote: `https://github.com/zzangzzangman2/gw.git`
- Originals/evidence are still preserved. Do not delete `girl1.xapk`, `com.girlwars.kr`, OBB, or extracted evidence until coverage and usage are documented.

## Latest Correction - 2026-06-25 18:40 KST

- User visual review was correct: recent UI/Battle captures must not be treated as restored just because component/sprite counts improved.
- UI `MAININTERFACE_107_GUILDMAIN_WHITE_PANEL_MATERIAL_SHADER_RUNTIME_TRACE` completed:
  - Verdict: `UI_GuildMain` is still **not normal**.
  - whiteish visible ratio stayed `0.8171147704`.
  - large white visible Images: `19`.
  - white no-sprite / missing Image sprite / missing script objects: `78 / 152 / 881`.
  - click validation stayed healthy: `24 / 24 / 0 / 24`.
  - no material/shader/color/type fix was applied because evidence was not strong enough.
  - Main blocker: `target runtime Lua/XLua initialization trace`.
  - Root shortcut added: `107_TRACE_GUILDMAIN_WHITE_PANEL_MATERIAL_SHADER_RUNTIME.cmd`.
- Battle `BATTLE_20_BATTLE_HUD_VISUAL_SANITY_REBASE_TO_PLAY_VIDEO_NORMAL_BATTLE` completed/reclassified:
  - It now uses live AssetBundle instantiate instead of trusting a saved scene whose UI scripts can fall to `m_Script: 0`.
  - `activeGraphicCount` recovered to `268`, and top/bottom/right screen zones are camera-visible.
  - Visual verdict is still **failed**, not acceptable: `visual_status=failed_missing_runtime_binding`.
  - `matches_clip05_static_hud_layout=false`.
  - `default_white_ui_blocks_visible=true`, `nearWhiteRatio=0.65896`.
  - The top/bottom/right zone hit was a false positive from placeholder/white UI blocks, not original HP/VS, actor/skill cards, or right controls from `플레이.mp4`.
  - Next blocker: `BATTLE_21_BATTLE_HUD_RUNTIME_BINDING_AND_SPRITE_PPTR_VISUAL_TRACE`.
- Current rule going forward:
  - A capture only passes when it visually matches the reference layout, not merely when Unity `Graphic` or screen-zone counts are nonzero.
  - Debug/evidence overlays, white/default placeholder panels, whole atlas images, and coordinate-only fixes remain invalid.

## Latest Update - 2026-06-25 18:10 KST

- New play reference video received: `C:\Users\godho\Downloads\플레이.mp4`.
- Video metadata: `600.82s`, `1920x896`, about `55.344 fps`.
- Video motion analysis tool:
  - `VIDEO_01_ANALYZE_PLAY_REFERENCE_MOTION.cmd`
  - `_restore_tools\VIDEO_01_ANALYZE_PLAY_REFERENCE_MOTION.cmd`
  - `_restore_tools\scripts\analyze_play_reference_video_motion.py`
- Video reference outputs:
  - `reports\video_reference\PLAY_REFERENCE_VIDEO_MOTION_ANALYSIS.md`
  - `reports\video_reference\PLAY_REFERENCE_VIDEO_MOTION_ANALYSIS.json`
  - `reports\video_reference\PLAY_REFERENCE_RESTORE_NOTES.md`
  - `reports\video_reference\play_motion_metrics_0p5s.csv`
  - `reports\video_reference\play_overview_10s_contact.jpg`
  - `reports\video_reference\clips\battle_motion_clip_*.mp4`
- Video restore rule:
  - Use motion clips for battle HUD/effect/cut-in validation, not still screenshots only.
  - Treat the top-center circular overlay as recording/touch artifact unless the user confirms it is in-game UI.
  - Do not reproduce recorder/debug overlays in final restored UI.
- UI current task:
  - `MAININTERFACE_NAVIGATION_TARGET_MISSING_SCRIPT_AND_SPRITE_REFERENCE_TRACE` is active.
  - Recent completed outputs include navigation target load/instantiate/capture and dependency preload passes.
  - `MAININTERFACE_NAVIGATION_TARGET_PREFAB_DEPENDENCY_FIXES` resolved only `2` missing sprites/white no-sprite Images; remaining blocker is missing script/type or deeper sprite reference/runtime binding, especially `UI_GuildMain`.
  - Video reference has been sent to the UI thread as priority/transition validation guidance.
- Battle current task:
  - `BATTLE_18_RECONSTRUCT_BATTLE_UI_COMPONENT_TYPES` is active.
  - `BATTLE_17_ATTACH_LOADABLE_BATTLE_HUD_PREFABS_TO_FLOW_SCENE` completed.
  - Attached HUD roots: `10`.
  - Battle HUD counts after attach: Canvas/RectTransform/Image/Text+TMP/Button = `12 / 814 / 0 / 0 / 0`.
  - Missing script/component count: `889`.
  - Next blocker: original UI component type reconstruction before sprite/region/font join.
  - Video reference has been sent to the battle thread for motion validation after type reconstruction.
- Git status:
  - Local work contains many new useful reports/tools/scenes plus Unity-generated cache churn.
  - `.gitignore` has battle Unity cache rules, but previously tracked `girlswar_battle_unity\Library`, `Logs`, and `UserSettings` still need `git rm --cached` after active Unity tasks settle.
  - Do not push until current UI/Battle background tasks pause.

## UI Thread

- Thread: `GirlsWar UI 복원 전용`
- Current status: active
- Current task: `MAININTERFACE_BUTTON_NAVIGATION_TRACE`.
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
- Route renderer fallback refinement completed:
  - Report: `reports\maininterface\MAININTERFACE_ROUTE_RENDERER_FALLBACK_RESULT.md`
  - Trace updated: `reports\maininterface\MAININTERFACE_ROUTE_RENDERER_ASSET_TRACE.md`
  - Applied `Spine_shijieanniu.atlas` layers: `zhuye_di1`, `diqiu`, `zhuye_bian`
  - Cropped but not displayed yet: `yun`, `yun2`
  - Still held back because of weak slot/bone evidence: `spine_xiaoren/8007`, particle-style renderer
  - Build success: visual overrides `4/4`
  - Click validation stayed healthy: active `24`, raycast-clickable `24/24`, blocked `0`, invoked `24`
- New UI prompt sent at about 17:31 KST:
  - Build `reports\maininterface\MAININTERFACE_BUTTON_NAVIGATION_TRACE.md`.
  - Generate `girlswar_maininterface_unity\Assets\RestoreData\maininterface_button_navigation_map.json`.
  - Trace all active clickable `24` buttons to original hierarchy, Button component/pathID, Lua/xLua handler, IL2CPP/string clues, and target prefab/bundle evidence.
  - Add a non-overlay navigation harness: only evidence-backed targets should be connected; unknown buttons stay unknown with reasons.
  - Rebuild, capture, and keep click validation at `24/24`, blocked `0`.
- Current UI progress at about 17:47 KST:
  - `maininterface_button_navigation_map.json`, navigation CSV, and `MAININTERFACE_BUTTON_NAVIGATION_TRACE.md` have been generated in draft form.
  - Active buttons: `24`.
  - Initial evidence-resolved count: `22/24`.
  - Initial target prefab resolved count was low (`2`) and is being improved with evidence aliases such as `UI_JingjiFrame_View -> UI_JingjiFrame`, `UI_GuildMainView -> UI_GuildMain`, `UI_SystemSet -> UI_SystemSettings`.
  - Important correction: the four active `wanfaBtn` objects share a name but must be resolved by hierarchy path, not by button name. Their handlers differ by parent item: Adventure, Jinji, Limit, ActJump.

## Battle Thread

- Thread: `GirlsWar 전투 구현 전용`
- Current status: active
- Current task: `BATTLE_13` skill/effect bundle streaming trace and preview.
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
- BATTLE_10 completed:
  - Report: `reports\battle\BATTLE_ASSETBUNDLE_STREAMING_PROBE_RESULT.md`
  - JSON: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_ASSETBUNDLE_STREAMING_PROBE.json`
  - Scene: `girlswar_battle_unity\Assets\Scenes\BattleAssetBundleStreamingProbe.unity`
  - Probe success: `4`
  - Fail: `0`
  - Prefab instantiate: `3` (`Hero_1002`, `Hero_1034`, `Hero_3001`)
  - BATTLE_09 extracted texture fallback assets remain available: `3`
- BATTLE_11 completed:
  - Runtime scene: `girlswar_battle_unity\Assets\Scenes\BattleRuntimeStreamingReconstruction.unity`
  - Runtime manifest: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_RUNTIME_STREAMING_MANIFEST.json`
  - Hierarchy dump: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_PREFAB_HIERARCHY_DUMP.json/.csv`
  - Report: `reports\battle\BATTLE_PREFAB_RECONSTRUCTION_RESULT.md`
  - Instantiated prefab: `3` (`Hero_1002`, `Hero_1034`, `Hero_3001`)
  - Missing placeholder: `9`
  - Hierarchy objects dumped: `3`
  - Components dumped: `12`
  - Renderers: `3`
  - Skeleton evidence assets: `9`
  - Unity batchmode: `True`
- BATTLE_12 completed:
  - Flow manifest: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_RUNTIME_FLOW_MANIFEST.json`
  - Scene: `girlswar_battle_unity\Assets\Scenes\BattleRuntimeFlowPrototype.unity`
  - Report: `reports\battle\BATTLE_RUNTIME_FLOW_LINK_RESULT.md`
  - Actor slots: `12`
  - Loadable / missing: `3 / 9`
  - Procedure evidence: decoded `ProcedureNormalBattle`, evidence `11`
  - Skill ids: `20`
  - Unity batchmode: `True`
  - Scene generated: `True`
  - `mapId=11001`, `battleType=1`, `randomSeed=445106`
- BATTLE_13 prompt sent at about 17:48 KST:
  - Add `_restore_tools\BATTLE_13_PROBE_SKILL_EFFECT_STREAMING.cmd`.
  - Probe skill/effect bundle candidates for the `20` skill ids in `BATTLE_RUNTIME_FLOW_MANIFEST.json`.
  - Use decoded skill Lua, resource trace, timeline/effect/prefab/material/texture/TextAsset candidates.
  - Unity `AssetBundle.LoadFromFile` probe for candidate skill/effect bundles.
  - Optional scene: `girlswar_battle_unity\Assets\Scenes\BattleSkillEffectStreamingProbe.unity`.
  - Outputs: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_SKILL_EFFECT_STREAMING_PROBE.json` and `reports\battle\BATTLE_SKILL_EFFECT_STREAMING_PROBE_RESULT.md`.

## GitHub Push

- First push started: 2026-06-25 16:23:46 KST
- First push completed: 2026-06-25 17:18:34 KST
- Remote `main` now exists:
  - `3f505aa7457d0a2f917b68a846979857f145a1b1 refs/heads/main`
- Current status at about 17:18:50 KST:
  - Initial LFS upload completed: `33399/33399`, about `7.9 GB`.
  - GitHub warning: push referenced at least `20000` LFS objects, GitHub sampled `10000`; this is a validation warning, not a failed push.
  - Follow-up push watcher is now running and adding newer UI/Battle/generated files.
  - Follow-up log is currently dominated by LF/CRLF working-copy warnings for decoded Lua files; no follow-up failure observed yet.
- Current status at about 17:22 KST:
  - Local branch shows `ahead 1`; the follow-up commit was created locally.
  - Follow-up `git push -u origin main` is still running in `git-lfs pre-push`.
  - Newer post-follow-up work is not included yet: BATTLE_10/BATTLE_11, the UI multi-layer fallback changes, and this status update.
- Follow-up push completed at 17:23:41 KST:
  - Remote `main`: `ad31b7636e0006973fbef77646da3232b23824ed`
  - LFS upload completed: `2658/2658`, about `9.0 MB`
  - Pushed commit range: `3f505aa74..ad31b7636`
- Current local-only work after that push:
  - BATTLE_10 AssetBundle streaming probe
  - BATTLE_11 runtime prefab reconstruction
  - BATTLE_12 runtime flow connection
  - BATTLE_13 skill/effect streaming probe in progress
  - UI route renderer multi-layer fallback result
  - UI button navigation trace in progress
  - This status update
- Do not kill the upload unless explicitly requested.
- Next Git action should happen after the currently active UI/Battle tasks finish: commit and push only the latest useful outputs, while avoiding unnecessary Unity cache churn where practical.

## Update 2026-06-25 18:55 KST

### Rule Gate

- `C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt` is not currently present on disk under `C:\Users\godho\Downloads`.
- The active rule gate was copied into `reports\RESTORE_RULES_APPLIED_CURRENT.md` so UI/Battle work keeps enforcing the same restore constraints:
  - no coordinate-only restore
  - preserve original hierarchy/anchors/pivot/scale/sibling order/CanvasScaler
  - no whole-atlas Image placement
  - no fake HUD, debug/evidence text, asset-path text, or placeholder overlays as final output
  - visual captures must be judged by the user-visible result, not only counts
  - original/evidence files must not be deleted until coverage is documented

### Battle Latest

- BATTLE_21 was corrected and rerun after an initial Unity compile/empty-trace failure.
- Tool:
  - `_restore_tools\BATTLE_21_BATTLE_HUD_RUNTIME_BINDING_AND_SPRITE_PPTR_VISUAL_TRACE.cmd`
  - root shortcut `BATTLE_21_BATTLE_HUD_RUNTIME_BINDING_AND_SPRITE_PPTR_VISUAL_TRACE.cmd`
- Report:
  - `reports\battle\BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_RESULT.md`
  - `reports\battle\BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_RESULT.json`
  - `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE.json`
  - `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_COMPONENTS.csv`
  - `reports\battle\BATTLE_21_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_CONTACT_SHEET.jpg`
- Current visual verdict: still not original battle HUD.
- Key values:
  - `visual_status=failed_missing_runtime_binding`
  - `matches_clip05_static_hud_layout=false`
  - `camera_visible_hud=true`
  - `camera_visible_original_hud=false`
  - `placeholder_block_visible=true`
  - `componentRowCount=505`
  - `activeGraphicCount=275`
  - `pptrJoinMatchedCount=445`
  - `visible_placeholder_block_count=16`
  - `sprite_pptr_unresolved=188`
  - `font_pptr_unresolved=68`
- The BATTLE_21 contact sheet now compares play.mp4 clip05 sequence with the current runtime capture and clearly shows the capture is placeholder-style, not the real HP/VS/skill-card/right-control HUD.
- BATTLE_22 prompt was sent to the battle thread:
  - `BATTLE_22_BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_AND_RUNTIME_LUA_BINDING`

### UI Latest

- UI108 report exists:
  - `reports\maininterface\MAININTERFACE_GUILDMAIN_RUNTIME_LUA_XLUA_INITIALIZATION_TRACE_RESULT.md`
  - `girlswar_maininterface_unity\Assets\RestoreData\maininterface_guildmain_runtime_lua_xlua_initialization_trace.json`
  - CSV reports under `girlswar_maininterface_unity\Assets\RestoreData\reports\`
- Current visual verdict: `UI_GuildMain` still not normal.
- Key values:
  - whiteish visible ratio unchanged: `0.8171147704124451`
  - large white visible Images: `19`
  - white no-sprite Images: `78`
  - missing Image sprites: `152`
  - missing script objects: `881`
  - raw guild TextAssets extracted: `75`
  - decoded guild Lua-like TextAssets: `75`
  - blocker-to-runtime candidate rows: `56`
  - high-confidence blocker rows: `23`
  - evidence-based visual fix applied: `0`
  - click validation: `24 / 24 / 0 / 24`
- Important evidence:
  - `UI_GuildMainView` is confirmed as UIForm id `219`, module `Guild`, prefab `UI_GuildMain`, sprite resource `UIGuild`.
  - Runtime API evidence exists for `YouYouImage`, `UIMask`, `LuaUtils.SetImageSprite`, `SetImageColor`, `SetCanvasAlpha`, `LoadSpriteWithFullPath`, and `LoadMaterialAsset`.
- Next UI blocker:
  - `GuildMain custom component/type reconstruction for YouYouImage and missing MonoBehaviour bindings`.

## Update 2026-06-25 19:15 KST

### Battle Correction

- User-visible battle HUD capture was rejected as invalid:
  - it shows placeholder/debug/path-style text and large white/dark fallback blocks
  - it does not match `C:\Users\godho\Downloads\플레이.mp4` normal battle sequence around 486s
  - it is not the original HP/VS, bottom actor/skill-card, or right-control HUD
- BATTLE_22 is trace-only and must not be treated as a visual success:
  - report: `reports\battle\BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_RUNTIME_LUA_BINDING_RESULT.md`
  - verdict: `아직 원본 전투 HUD 아님`
  - `visual_status=failed_missing_runtime_binding`
  - `matches_clip05_static_hud_layout=false`
  - `camera_visible_original_hud=false`
  - `placeholder_block_visible=true`
  - `visible_original_sprite_count=0`
  - `visible_placeholder_block_count=16`
  - `fixApplied=false`
- Main cause from BATTLE_22:
  - `resolved_external_candidate_not_loaded_runtime=207`
  - `external_bundle_not_loaded=79`
  - `font_bundle_missing=62`
  - `custom_youyouimage_binding=59`
  - `runtime_lua_set_image_sprite=16`
- High-priority missing external dependency:
  - `im_bg_left` / `im_bg_right`
  - PPtr `6:-8109585734443225392`
  - external bundle `download/artsources/uispriteres/uicommonother.assetbundle`
- BATTLE_23 was sent to the battle thread:
  - `BATTLE_23_LOAD_MISSING_HUD_EXTERNAL_DEPENDENCIES_AND_VALIDATE_CLIP05_VISUAL`
  - final capture must fail if any debug/evidence/path/placeholder label is visible
  - video gate must use the play.mp4 486s normal battle sequence, not a single screenshot only

### UI Latest

- UI109 completed and was visually checked:
  - report: `reports\maininterface\MAININTERFACE_GUILDMAIN_CUSTOM_COMPONENT_TYPE_RECONSTRUCTION_RESULT.md`
  - capture: `girlswar_maininterface_unity\Assets\RestoreCaptures\guildmain_custom_component_type_reconstruction\UI_GuildMain_1680x720.png`
  - tool: `_restore_tools\109_RECONSTRUCT_GUILDMAIN_CUSTOM_COMPONENT_TYPES_YOUYOUIMAGE_UIMASK.cmd`
  - root shortcut: `109_RECONSTRUCT_GUILDMAIN_CUSTOM_COMPONENT_TYPES_YOUYOUIMAGE_UIMASK.cmd`
- Verdict: not normal.
- The capture still shows a very large white panel and Korean text fallback boxes.
- Important numbers:
  - missing script objects: `881 -> 170`
  - missing script reduction: `711`
  - `YouYou.YouYouImage` instantiated: `640`
  - `LuaComponentBinder.LuaComBinder` instantiated: `58`
  - whiteish visible ratio: `0.8171147704124451 -> 0.8221056461334229`
  - large white visible Images: `19 -> 21`
  - white no-sprite Images: `78 -> 444`
  - missing Image sprites: `152 -> 518`
  - click validation: `24 / 24 / 0 / 24`
- Interpretation:
  - custom component type names are now largely resolved
  - top white blockers have `missing scripts=0`
  - the remaining blocker is not simply missing C# type names
  - next UI blocker is `GuildMain Lua runtime harness for UI_GuildMainView.OnOpen data/layout initialization`

## Update 2026-06-25 19:05 KST

### Battle BATTLE_23 Result

- BATTLE_23 completed and was visually checked against `C:\Users\godho\Downloads\플레이.mp4` around 486s.
- Verdict: `아직 원본 전투 HUD 아님`.
- Outputs:
  - report: `reports\battle\BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_CLIP05_VISUAL_RESULT.md`
  - JSON: `reports\battle\BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_CLIP05_VISUAL_RESULT.json`
  - capture: `girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleHudExternalDependencyLoadClip05_1680x720.png`
  - contact sheet: `reports\battle\BATTLE_23_EXTERNAL_DEPENDENCY_LOAD_CLIP05_CONTACT_SHEET.jpg`
  - reference sequence: `reports\battle\BATTLE_23_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S_SEQUENCE.jpg`
- Important numbers:
  - external dependency bundles loaded: `8 / 8`
  - visible original sprite candidates: `174`
  - visible placeholder block count: `0`
  - active graphic count: `275`
  - capture nearWhiteRatio: `0.6486904761904762`
  - `matches_clip05_static_hud_layout=false`
  - `camera_visible_original_hud=false`
- Visual reason:
  - the top reference sequence shows the real moving battle screen, background, characters, bottom skill cards, and right-side controls
  - the BATTLE_23 capture still shows large white HUD blocks and a dark temporary-looking panel
  - this is not a usable final battle HUD capture
- Refined diagnosis:
  - inactive/template roots are already being kept inactive by the BATTLE_23 Editor probe
  - the large active offenders are inside `ui_normalbattle`, especially `root_opra/root_buff/im_bg_left`, `im_bg_right`, and `root_buff_left/right/im_bg`
  - `btn_preivew_touch` is full-screen but alpha `0`, so it is not the white visual cause
  - sprite names are resolving, but texture/atlas/canvas rendering is still not visually correct

### Battle BATTLE_24 Sent

- Next battle task sent to the battle thread:
  - `BATTLE_24_RESTORE_BATTLE_HUD_CANVAS_SCALER_SPRITE_TEXTURE_AND_LUA_ACTIVE_STATE_CLIP05`
- Required focus:
  - original Canvas / CanvasScaler / render mode / resolution basis
  - actual `Sprite.texture`, sprite rect, atlas texture, and visible sprite sheet
  - `ProcedureNormalBattle.OnBattleUILoadComplete`, `SetLeftInfo`, `SetRightInfo`, `OnShowHeadBar` Lua active-state and runtime image assignment
  - no debug/path/evidence/placeholder text in final capture
- Required BATTLE_24 outputs:
  - root CMD: `BATTLE_24_RESTORE_BATTLE_HUD_CANVAS_SCALER_SPRITE_TEXTURE_AND_LUA_ACTIVE_STATE_CLIP05.cmd`
  - tool CMD: `_restore_tools\BATTLE_24_RESTORE_BATTLE_HUD_CANVAS_SCALER_SPRITE_TEXTURE_AND_LUA_ACTIVE_STATE_CLIP05.cmd`
  - report: `reports\battle\BATTLE_HUD_CANVAS_SCALER_SPRITE_TEXTURE_LUA_ACTIVE_STATE_CLIP05_RESULT.md`
  - capture: `girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleHudCanvasScalerSpriteTextureLuaStateClip05_1680x720.png`
  - contact sheet: `reports\battle\BATTLE_24_CANVAS_SCALER_SPRITE_TEXTURE_LUA_STATE_CLIP05_CONTACT_SHEET.jpg`
  - visible sprite sheet: `reports\battle\BATTLE_24_VISIBLE_HUD_SPRITE_TEXTURE_SHEET.jpg`

## Update 2026-06-25 19:19 KST

### Battle BATTLE_25 Result

- User rejected the previous battle capture as invalid; confirmed: it was not a normal battle UI.
- BATTLE_25 rebounded extracted original PNG sprite slices from `girlswar_merged_extracted\indexes\unity_images.csv` back onto matching HUD `Image.sprite` names.
- Verdict: `아직 원본 전투 HUD 아님`.
- Important improvement:
  - extracted sprite texture bind count: `290`
  - active visible extracted sprite bindings: `46`
  - visible sprite texture blank count: `46 -> 0`
  - large active blank-texture rows: `6 -> 0`
  - nearWhiteRatio: `0.1421164021164021 -> 0.0002777777777777778`
- Still failing against `C:\Users\godho\Downloads\플레이.mp4` clip05 around 486s:
  - top/right HUD pieces are now partially original
  - battle background is missing
  - moving actors are missing
  - bottom actor/skill-card UI is missing
  - center dark grid/panel is not accepted as real battle gameplay
- Outputs:
  - root CMD: `BATTLE_25_REBIND_BATTLE_HUD_EXTRACTED_SPRITE_ATLAS_TEXTURES_AND_VALIDATE_CLIP05.cmd`
  - tool CMD: `_restore_tools\BATTLE_25_REBIND_BATTLE_HUD_EXTRACTED_SPRITE_ATLAS_TEXTURES_AND_VALIDATE_CLIP05.cmd`
  - report: `reports\battle\BATTLE_HUD_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05_RESULT.md`
  - JSON: `reports\battle\BATTLE_HUD_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05_RESULT.json`
  - capture: `girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleHudSpriteAtlasTextureRuntimeBindingClip05_1680x720.png`
  - contact sheet: `reports\battle\BATTLE_25_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05_CONTACT_SHEET.jpg`
  - visible sprite sheet: `reports\battle\BATTLE_25_VISIBLE_HUD_SPRITE_TEXTURE_SHEET.jpg`
- Next battle blocker:
  - `BATTLE_26_RESTORE_BATTLE_SCENE_ACTORS_SKILL_CARDS_AND_RUNTIME_CAMERA`

## Update 2026-06-25 19:40 KST

### Battle BATTLE_26/BATTLE_27 Result

- User rejected the text-heavy/debug-looking battle capture; confirmed: that capture was diagnostic output, not a valid battle UI.
- BATTLE_26 extracted `C:\Users\godho\Downloads\플레이.mp4` clip05 around 486s and compared the stage crop against extracted battlemap sprites.
- Important BATTLE_26 finding:
  - runtime flow manifest says `mapId=11001`
  - video similarity strongly prefers `map_11003`
  - top candidates are `Map_11003_2`, `Map_11003_5`, `Map_11003_4_2`, `Map_11003_3`
- BATTLE_27 rebuilt a non-final preview with:
  - BATTLE_25 original HUD sprite/texture rebinding carried over
  - non-HUD diagnostic roots removed
  - `map_11003` original sprite layers behind the HUD
  - loadable runtime actor prefabs instantiated for models `1002`, `1034`, `3001`
  - magenta missing-shader fallback repaired
  - actor atlas textures connected well enough for visible textured actors
- Current BATTLE_27 verdict:
  - `improved_correct_map_and_hud_preview_not_final`
  - no large white blocks
  - no visible debug/path/evidence text
  - actors are now visible with original atlas texture, but still not video-matched in position/scale/motion
  - bottom skill-card runtime UI is still missing
- Outputs:
  - root CMD: `BATTLE_27_REBUILD_CORRECT_MAP_SCENE_HUD_PREVIEW_AND_VALIDATE_CLIP05.cmd`
  - tool CMD: `_restore_tools\BATTLE_27_REBUILD_CORRECT_MAP_SCENE_HUD_PREVIEW_AND_VALIDATE_CLIP05.cmd`
  - BATTLE_26 report: `reports\battle\BATTLE_26_MAP_VIDEO_MATCH_RUNTIME_SCENE_EVIDENCE_RESULT.md`
  - BATTLE_27 report: `reports\battle\BATTLE_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05_RESULT.md`
  - BATTLE_27 capture: `girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleCorrectMapSceneHudPreviewClip05_1680x720.png`
  - BATTLE_27 contact sheet: `reports\battle\BATTLE_27_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05_CONTACT_SHEET.jpg`
- Next battle blocker:
  - `BATTLE_28_RESTORE_BATTLE_ACTOR_SPINE_RUNTIME_MOTION_AND_BOTTOM_SKILL_CARDS`

## Update 2026-06-25 19:50 KST

### Battle BATTLE_28 Result

- BATTLE_28 used `C:\Users\godho\Downloads\플레이.mp4` clip05 around 486s as a motion gate, not a single screenshot.
- Verdict: `battle28_evidence_collected_not_final`.
- Motion evidence:
  - frame pairs checked: `5`
  - total motion components: `54`
  - actor motion components: `26`
  - bottom-card/skill-region motion components: `14`
- Bottom skill-card evidence:
  - HUD bottom candidate rows: `56`
  - active visible bottom candidate rows: `7`
  - meaningful bottom-center rows: `0`
  - the color/chroma ratio is not treated as decisive by itself because the floor is also high-chroma; the stronger evidence is video motion plus `0` meaningful bottom-center HUD rows.
- Actor/runtime evidence:
  - runtime actor slots: `12`
  - runtime prefab slots: `3`
  - missing actor slots: `9`
  - BATTLE_27 textured actors: `3`
- Skill/effect evidence:
  - skill ids checked: `20`
  - skill found count: `12`
  - timeline found count: `12`
  - unique loadable effect bundles: `4`
  - unique loadable effect prefabs: `68`
  - unique missing effect bundle candidates: `3`
- Outputs:
  - root CMD: `BATTLE_28_PROBE_ACTOR_MOTION_AND_SKILLCARD_EVIDENCE.cmd`
  - tool CMD: `_restore_tools\BATTLE_28_PROBE_ACTOR_MOTION_AND_SKILLCARD_EVIDENCE.cmd`
  - report: `reports\battle\BATTLE_28_ACTOR_MOTION_SKILLCARD_EVIDENCE_RESULT.md`
  - JSON: `reports\battle\BATTLE_28_ACTOR_MOTION_SKILLCARD_EVIDENCE_RESULT.json`
  - contact sheet: `reports\battle\BATTLE_28_ACTOR_MOTION_SKILLCARD_EVIDENCE_CONTACT_SHEET.jpg`
  - reference sequence: `reports\battle\BATTLE_28_PLAY_VIDEO_CLIP05_486S_SEQUENCE.jpg`
- Next battle blocker:
  - `BATTLE_29_BIND_UI_NORMALBATTLE_HERO_LIST_SKILL_CARDS_AND_TRACE_ACTOR_ANIMATION_RUNTIME`

## Update 2026-06-25 20:27 KST

### Battle BATTLE_29 Result After User Rejection

- User rejected the battle UI as invalid; confirmed: the previous capture still did not match `C:\Users\godho\Downloads\플레이.mp4` clip05 motion/layout.
- Root causes found and corrected in this pass:
  - battle capture was using `1680x720` while the reference video is `1920x1080`; BATTLE_27/BATTLE_29 captures now use `1920x1080`.
  - `ui_normalbattle_heroitem` existed only as a detached template; BATTLE_29 now clones the original template into `root_battle/BottomCenter/HeroListContainer`.
  - white placeholder card blocks came from unresolved data icons `im_frame`, `im_quality`, `im_zhiye`; these are now hidden and counted as unresolved, not presented as restored UI.
  - `download/map/battlemap/11003.assetbundle` loads from `clean_unityfs_slices`; its renderer names (`bg1_1`, `bg4_2`, etc.) are traced and matched to extracted `Map_11003_*` sprites.
  - visual map output now uses `1920x1080` pixel-space `Map_11003_*` layers to remove the invalid black band while preserving original sprite-piece evidence.
- Current BATTLE_29 verdict:
  - `improved_hero_list_cards_bound_not_final`
  - `visibleWhiteLikeCardImageCount=0`
  - `hiddenUnresolvedWhiteDataIconCount=9`
  - `boundHeroCardCount=3`
  - `headSpriteBindCount=3`
  - `extractedSpriteBindCount=57`
  - battle map original bundle loaded: `true`
  - pixel-matched map layer count: `9`
- Still not final:
  - hero card positions are video/pixel matched enough for preview, but not yet proven through the original runtime Lua layout pass.
  - actor positions/scale are still not matched to the video sequence.
  - actor animation/motion is not replayed; only static prefab instances are visible.
  - 9 actor slots remain missing/unresolved.
- Outputs:
  - root CMD: `BATTLE_29_BIND_HERO_LIST_SKILLCARDS_AND_VALIDATE_CLIP05.cmd`
  - tool CMD: `_restore_tools\BATTLE_29_BIND_HERO_LIST_SKILLCARDS_AND_VALIDATE_CLIP05.cmd`
  - report: `reports\battle\BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05_RESULT.md`
  - JSON: `reports\battle\BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05_RESULT.json`
  - capture: `girlswar_battle_unity\Assets\RestoreCaptures\battle_hud\BattleHeroListSkillCardBindClip05_1920x1080.png`
  - contact sheet: `reports\battle\BATTLE_29_HERO_LIST_SKILLCARD_BIND_CLIP05_CONTACT_SHEET.jpg`
  - map sprite sheet: `reports\battle\BATTLE_29_MAP_11003_SPRITE_CONTACT_SHEET.jpg`
- Next battle blocker:
  - `BATTLE_30_VERIFY_HERO_CARD_RUNTIME_LAYOUT_AND_ATTACH_ACTOR_ANIMATION_TRACE`

## Update 2026-06-25 20:32 KST

### Root CMD Cleanup

- Root command shortcuts were moved, not deleted: `33` files from root to `_restore_tools\root_cmd_archive\`.
- Root now keeps one entry point: `00_COMMAND_CENTER.cmd`.
- Active tool scripts remain under `_restore_tools\`; old root one-click launchers remain available in `_restore_tools\root_cmd_archive\` for checking.
- Root guidance was added in `README_COMMANDS.md`.
- This cleanup intentionally did not stage or change battle Unity scene/log modifications from the battle work area.

## Update 2026-06-25 20:36 KST

### Battle BATTLE_30 Result

- BATTLE_30 used `C:\Users\godho\Downloads\플레이.mp4` clip05 `485.0-487.0s` as a frame sequence, not a single screenshot.
- Verdict: `failed_actor_motion_runtime_replay_missing`.
- This is not a final restored battle screen.
- Layout gap summary:
  - reference actor boxes: `145`
  - capture actor boxes: `20`
  - actor center gap norm: `0.13673`
  - actor area scale ratio: `0.36319`
  - reference card boxes: `13`
  - capture card boxes: `20`
  - card center gap norm: `0.09079`
  - card area scale ratio: `3.12097`
- Runtime evidence:
  - runtime actor slots: `12`
  - loadable actor prefabs: `3`
  - missing actor slots: `9`
  - skeleton evidence assets: `9`
  - Lua animation/timeline evidence lines: `80`
- Root-level BATTLE_30 shortcut was moved into `_restore_tools\root_cmd_archive\` to keep the root folder clean.
- Outputs:
  - tool CMD: `_restore_tools\BATTLE_30_VERIFY_HERO_CARD_RUNTIME_LAYOUT_AND_ATTACH_ACTOR_ANIMATION_TRACE.cmd`
  - archived root CMD: `_restore_tools\root_cmd_archive\BATTLE_30_VERIFY_HERO_CARD_RUNTIME_LAYOUT_AND_ATTACH_ACTOR_ANIMATION_TRACE.cmd`
  - report: `reports\battle\BATTLE_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE_RESULT.md`
  - JSON: `reports\battle\BATTLE_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE_RESULT.json`
  - Unity data: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE.json`
  - gap CSV: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE_GAPS.csv`
  - contact sheet: `reports\battle\BATTLE_30_HERO_CARD_RUNTIME_LAYOUT_ACTOR_ANIMATION_TRACE_CONTACT_SHEET.jpg`
  - reference sequence: `reports\battle\BATTLE_30_PLAY_VIDEO_CLIP05_485_487_SEQUENCE.jpg`
- Next battle blocker:
  - `BATTLE_31_ATTACH_LOADABLE_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE`

## Update 2026-06-25 20:40 KST

### MainInterface UI 110 Result

- UI 110 did not claim the current MainInterface capture is final or normal.
- Visual status by manual capture review: still not a normal/original MainInterface; right route cluster text/layout remains suspicious.
- Fixed evidence-backed issue:
  - TMP material reconstruction was incorrectly filling non-main texture slots with the atlas.
  - Original material property value `0` is now preserved as an empty texture reference for `_BumpMap`, `_Cube`, `_FaceTex`, and `_OutlineTex`.
  - `_MainTex` remains assigned to the atlas.
- Route label audit:
  - route label rows checked: `6`
  - active evidence-matched rows: `9`
  - route labels use `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP` and matching material.
  - non-main texture slot mismatch rows: `0`
- Verification:
  - active tool: `_restore_tools\110_FIX_MAININTERFACE_ROUTE_TMP_VARIANT_MATERIAL_TEXTURE_PTRS.cmd`
  - archived root shortcut: `_restore_tools\root_cmd_archive\110_FIX_MAININTERFACE_ROUTE_TMP_VARIANT_MATERIAL_TEXTURE_PTRS.cmd`
  - report: `reports\maininterface\MAININTERFACE_ROUTE_TMP_VARIANT_MATERIAL_AUDIT_RESULT.md`
  - capture: `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`
  - click validation: `24 / 24 / 0 / 24`
- Next UI blocker:
  - `MAININTERFACE_111_ROUTE_LABEL_RECT_OVERRIDE_REVALIDATION`

## Update 2026-06-25 20:52 KST

### Root Command Policy

- Root folder was verified clean after latest work.
- Root CMD count: `1`.
- Only root launcher: `00_COMMAND_CENTER.cmd`.
- Active executable tools are under `_restore_tools\`.
- Archived old root shortcuts: `_restore_tools\root_cmd_archive\`.
- `00_COMMAND_CENTER.cmd` now directly exposes:
  - latest MainInterface UI validation: `_restore_tools\111_REVALIDATE_MAININTERFACE_ROUTE_LABEL_RECT_OVERRIDES.cmd`
  - latest battle validation: `_restore_tools\BATTLE_31_ATTACH_LOADABLE_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE.cmd`

### MainInterface UI 111 Result

- UI 111 did not claim the MainInterface capture is final or normal.
- Visual status by manual capture review: still not a normal/original MainInterface; right route cluster remains visibly wrong.
- Evidence-backed rect decision:
  - removed two weak `text_name` size overrides for `UI_Main_wanfa_item_3/4`.
  - original `text_name` size is preserved as `200x0`.
  - kept two `Entry` zero-scale overrides because original `localScale=0,0,0` evidence is explicit.
- Verification:
  - active tool: `_restore_tools\111_REVALIDATE_MAININTERFACE_ROUTE_LABEL_RECT_OVERRIDES.cmd`
  - report: `reports\maininterface\MAININTERFACE_ROUTE_LABEL_RECT_OVERRIDE_REVALIDATION_RESULT.md`
  - JSON: `girlswar_maininterface_unity\Assets\RestoreData\maininterface_route_label_rect_override_revalidation.json`
  - CSV: `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_label_rect_override_revalidation.csv`
  - capture: `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`
  - click validation: `24 / 24 / 0 / 24`
- Next UI blocker:
  - `MAININTERFACE_112_ROUTE_NON_IMAGE_RENDERER_EFFECT_RUNTIME_STATE_TRACE`

### Battle BATTLE_31 Result

- BATTLE_31 used `C:\Users\godho\Downloads\플레이.mp4` clip05 `485.0-487.0s` as the video motion gate.
- Verdict: `failed_missing_spine_animation_runtime_class`.
- This is not a final restored battle screen.
- Runtime probe:
  - bundle load success: `3`
  - prefab instantiate success: `3`
  - missing scripts: `3`
  - skeleton-like assets: `12`
  - animation candidate assets: `0`
  - timeline candidate assets: `0`
  - actor motion replayed: `False`
- Manual capture review:
  - static probe capture shows magenta actor meshes/silhouettes.
  - this is shader/runtime class failure evidence, not an acceptable visual match.
- Outputs:
  - active tool: `_restore_tools\BATTLE_31_ATTACH_LOADABLE_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE.cmd`
  - report: `reports\battle\BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_RESULT.md`
  - JSON: `reports\battle\BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_RESULT.json`
  - Unity data: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE.json`
  - component CSV: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_COMPONENTS.csv`
  - probe scene: `girlswar_battle_unity\Assets\Scenes\Battle31ActorSpineAnimationRuntimeProbe.unity`
  - static capture: `girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle31ActorSpineAnimationRuntimeProbe_1920x1080.png`
  - contact sheet: `reports\battle\BATTLE_31_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE_CONTACT_SHEET.jpg`
- Next battle blocker:
  - `BATTLE_32_RESOLVE_BATTLE_ACTOR_SPINE_RUNTIME_CLASS_AND_IDLE_MOTION_REPLAY`

## Update 2026-06-25 21:10 KST

### Command Folder Cleanup

- Root folder was re-verified clean.
- Root CMD count: `1`.
- Only root launcher: `00_COMMAND_CENTER.cmd`.
- `00_COMMAND_CENTER.cmd` now opens a clean current command folder instead of dumping the full `_restore_tools` folder in Explorer:
  - `_restore_tools\current\01_RUN_LATEST_MAININTERFACE_UI_VALIDATION.cmd`
  - `_restore_tools\current\02_RUN_LATEST_BATTLE_VALIDATION.cmd`
  - `_restore_tools\current\03_OPEN_MAININTERFACE_REPORTS.cmd`
  - `_restore_tools\current\04_OPEN_BATTLE_REPORTS.cmd`
  - `_restore_tools\current\05_SHOW_GIT_STATUS.cmd`
- Full legacy tools remain preserved under `_restore_tools\` and old root shortcuts remain archived under `_restore_tools\root_cmd_archive\`.

### MainInterface UI 112 Result

- UI 112 did not claim the current MainInterface capture is final or normal.
- Visual status by manual capture review: still not a normal/original MainInterface; the right route cluster remains visibly wrong.
- New visual fixes applied: `0`.
- Trace classification:
  - trace rows: `24`
  - applyable_already_applied: `4`
  - blocked: `5`
  - trace-only: `15`
- Kept existing evidence-backed `Spine_shijieanniu` fallback layers:
  - `zhuye_di1`
  - `diqiu`
  - `zhuye_bian`
- Held back because applying them now would be coordinate-only / whole-texture / runtime-state guessing:
  - `yun`
  - `yun2`
  - `spine_xiaoren/8007`
  - `un_MainInterface_fire`
- Verification:
  - active tool: `_restore_tools\112_TRACE_MAININTERFACE_ROUTE_NON_IMAGE_RENDERER_EFFECT_RUNTIME_STATE.cmd`
  - report: `reports\maininterface\MAININTERFACE_ROUTE_NON_IMAGE_RENDERER_EFFECT_RUNTIME_STATE_TRACE_RESULT.md`
  - JSON: `girlswar_maininterface_unity\Assets\RestoreData\maininterface_route_non_image_renderer_effect_runtime_state_trace.json`
  - CSV: `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_non_image_renderer_effect_runtime_state_trace.csv`
  - capture: `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`
  - click validation: `24 / 24 / 0 / 24`
- Next UI blocker:
  - `MAININTERFACE_113_RESTORE_SPINE_SLOT_BONE_ANIMATION_TRANSFORM_FOR_ROUTE_CLUSTER`

### Battle BATTLE_32 Result

- BATTLE_32 used `C:\Users\godho\Downloads\플레이.mp4` clip05 `485.0-487.0s` as the video motion gate.
- Verdict: `failed_spine_shader_or_runtime_mesh_still_magenta`.
- This is not a final restored battle screen.
- Manual contact sheet review:
  - reference sequence shows moving actors and battle layout
  - current capture still shows static magenta meshes
  - no clip05 actor motion replay is present
- Runtime probe:
  - MissingScript before/after: `3 / 3`
  - MissingScript reduction: `0`
  - `SkeletonAnimation` components resolved: `0`
  - idle replay call success: `0`
  - shader fallback applied: `0`
  - magenta pixel ratio: `0.073207`
  - shader dependency loaded: `True`
- Outputs:
  - active tool: `_restore_tools\BATTLE_32_RESOLVE_BATTLE_ACTOR_SPINE_RUNTIME_CLASS_AND_IDLE_MOTION_REPLAY.cmd`
  - report: `reports\battle\BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_RESULT.md`
  - JSON: `reports\battle\BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_RESULT.json`
  - Unity data: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY.json`
  - component CSV: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_COMPONENTS.csv`
  - probe scene: `girlswar_battle_unity\Assets\Scenes\Battle32ActorSpineRuntimeClassIdleMotionReplay.unity`
  - static capture: `girlswar_battle_unity\Assets\RestoreCaptures\battle_actor\Battle32ActorSpineRuntimeClassIdleMotionReplay_1920x1080.png`
  - contact sheet: `reports\battle\BATTLE_32_ACTOR_SPINE_RUNTIME_CLASS_IDLE_MOTION_REPLAY_CONTACT_SHEET.jpg`
- Next battle blocker:
  - `BATTLE_33_DEEP_TRACE_MONOSCRIPT_ASSEMBLY_GUID_FOR_ACTOR_PREFABS`

## Update 2026-06-25 21:18 KST

### Battle BATTLE_33 Result

- BATTLE_33 used `C:\Users\godho\Downloads\플레이.mp4` clip05 `485.0-487.0s` as the video motion gate.
- Verdict: `failed_actor_render_still_magenta_after_monoscript_binding_fixed`.
- This is not a final restored battle screen.
- Important fixed blocker:
  - actor prefab `m_Script` PPtr was traced to `Spine.Unity.SkeletonAnimation` in assembly `spine-unity.dll`.
  - the previous actor runtime proxy lived outside the existing `spine-unity` assembly.
  - moving the actor Spine stub into `girlswar_battle_unity\Assets\Scripts\BattleUIExternalStubs\SpineUnity\` allowed AssetBundle MonoScript binding to resolve.
- Runtime probe after the shim:
  - MissingScript before/after: `3 / 0`
  - MissingScript reduction: `3`
  - `SkeletonAnimation` components resolved: `3`
  - idle replay call success: `3`
  - actor motion replayed: `False`
  - magenta pixel ratio: `0.073207`
- Actor serialized evidence:
  - `1002` uses `Spine.Unity.SkeletonAnimation`, animation `ult`, loop `0`
  - `1034` uses `Spine.Unity.SkeletonAnimation`, animation `skill1`, loop `0`
  - `3001` uses `Spine.Unity.SkeletonAnimation`, animation `attack`, loop `0`
- Manual contact sheet review:
  - reference sequence shows moving actors and normal battle scene
  - current capture still shows static magenta actor meshes
  - no final-screen claim is allowed
- Outputs:
  - active tool: `_restore_tools\BATTLE_33_DEEP_TRACE_MONOSCRIPT_ASSEMBLY_GUID_FOR_ACTOR_PREFABS.cmd`
  - report: `reports\battle\BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS_RESULT.md`
  - JSON: `reports\battle\BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS_RESULT.json`
  - Unity data: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS.json`
  - component CSV: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS_COMPONENTS.csv`
  - contact sheet: `reports\battle\BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS_CONTACT_SHEET.jpg`
- Note:
  - BATTLE_33 reran the BATTLE_32 probe after the assembly shim, so BATTLE_32 JSON/CSV/report/capture now also show the post-shim `MissingScript 3 / 0` state.
  - This is evidence of the BATTLE_33 fix, not a final actor motion/render success.
- Next battle blocker:
  - `BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS`

### UI 113 In Progress

- UI113 has added a route-cluster Spine 4.0 probe tool under `_restore_tools`.
- It is not committed yet because the first runs hit script/probe handling issues:
  - a PowerShell markdown-string escape issue was fixed
  - `8007.skel.bytes` currently throws `IndexOutOfRangeException` in Spine 4.0 `SkeletonBinary`
- Current intended classification:
  - `Spine_shijieanniu` continues toward slot/bone pose trace
  - `8007` should be recorded as `blocked_8007_skeletonbinary_decode_failed` unless a stronger decode path is found
- No UI113 final report has been accepted yet.

## Update 2026-06-25 21:25 KST

### UI MAININTERFACE_113 Result

- Visual verdict: MainInterface is still not a normal/restored UI.
- UI113 is trace-only and applied no visual fix to the MainInterface scene.
- Rule gate preserved:
  - no coordinate-only placement
  - no whole atlas placement
  - no guessed `yun/yun2` cloud placement
  - no guessed `spine_xiaoren/8007` person placement
  - no debug/path/evidence overlay added to final capture
- Runtime Spine probe result:
  - probe status: `spine_runtime_transform_evidence_collected_partial`
  - visual fixes applied: `0`
  - total attachment rows: `0`
  - target route attachment rows: `0`
  - cloud rows (`yun/yun2`): `0`
  - `8007` run pose rows: `0`
- Skeleton classifications:
  - `Spine_shijieanniu` / node `spine_diqiu` / animation `A`: `blocked_empty_or_unreadable_runtime_skeleton_data`
  - `8007` / node `spine_xiaoren` / animation `run`: `blocked_8007_skeletonbinary_decode_failed`
- Verification:
  - graphics capture: `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`
  - click validation: `24 / 24 / 0 / 24`, generated `2026-06-25 21:25:07`
- Outputs:
  - active tool: `_restore_tools\113_RESTORE_MAININTERFACE_ROUTE_SPINE_SLOT_BONE_ANIMATION_TRANSFORM.cmd`
  - report: `reports\maininterface\MAININTERFACE_ROUTE_SPINE_SLOT_BONE_ANIMATION_TRANSFORM_RESULT.md`
  - JSON: `girlswar_maininterface_unity\Assets\RestoreData\maininterface_route_spine_slot_bone_animation_transform.json`
  - CSV: `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_spine_slot_bone_animation_transform.csv`
  - probe log: `reports\maininterface\unity_113_spine_route_cluster_transform_probe.log`
- Next UI blocker:
  - `route SpineGraphic runtime replay / raw skeleton decode recovery`

## Update 2026-06-25 21:38 KST

### BATTLE_34 Result

- Visual verdict: original clip05 actor motion is still not reproduced.
- BATTLE_34 used `C:\Users\godho\Downloads\플레이.mp4` clip05 `485.0-487.0s` as the motion gate.
- Verdict: `failed_spine_animationstate_mesh_generator_missing`.
- This is not a final restored battle screen.
- Runtime probe:
  - `SkeletonAnimation` components: `3`
  - `AnimationState.SetAnimation` proxy success: `3 / 3`
  - real mesh updated count: `0 / 3`
  - mesh vertices after probe: `3712`
  - runtime bridge kind: `proxy_stub_no_mesh_generator_or_skeletonbinary`
  - magenta pixel ratio: `0.073207`
- Skel/atlas/material/texture evidence:
  - traced actors: `3`
  - expected animation exact match in `.skel`: `2 / 3`
  - `1002`: expected `ult`, present `True`
  - `1034`: expected `skill1`, present `True`
  - `3001`: serialized `attack`, exact present `False`, `attackR`-style candidates exist
- Important blocker:
  - the project still has a proxy `spine-unity` bridge without real `SkeletonBinary` / `MeshGenerator`
  - AnimationState calls can succeed at proxy level, but `LateUpdate` cannot produce real updated Spine actor mesh
  - magenta/static rendering was not hidden with arbitrary material
- Outputs:
  - active tool: `_restore_tools\cmd_archive\BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS.cmd`
  - report: `reports\battle\BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_RESULT.md`
  - JSON: `reports\battle\BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_RESULT.json`
  - Unity data: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS.json`
  - component CSV: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_COMPONENTS.csv`
  - Unity probe JSON: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_UNITY.json`
  - contact sheet: `reports\battle\BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS_CONTACT_SHEET.jpg`
- Next battle blocker:
  - `BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS`

### UI MAININTERFACE_114 Result

- Visual verdict: MainInterface is still not a normal/restored UI.
- UI114 applied no visual fix to the MainInterface scene.
- Important fixed blocker:
  - previous extracted `.skel.txt` path was not enough for runtime decode
  - clean UnityFS `AssetBundle.LoadFromFile` + direct `TextAsset.bytes` export recovered the raw skeleton decode
- Decode recovery:
  - `Spine_shijieanniu` / `spine_diqiu`: bones `8`, slots `9`, animations `1`, animation `A` confirmed
  - `8007` / `spine_xiaoren`: bones `108`, slots `37`, animations `15`, animation `run` confirmed
  - runtime attachment bounds rows: `140`
  - blocked/exception rows: `0`
- Rule gate preserved:
  - no fake icon
  - no whole atlas placement
  - no guessed crop/cloud/person placement
  - no debug/path/evidence overlay in final capture
- Verification:
  - graphics capture: `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`
  - click validation: `24 / 24 / 0 / 24`, generated `2026-06-25 21:34:37`
- Outputs:
  - active tool: `_restore_tools\cmd_archive\114_ROUTE_SPINEGRAPHIC_RUNTIME_REPLAY_RAW_SKELETON_DECODE_RECOVERY.cmd`
  - report: `reports\maininterface\MAININTERFACE_ROUTE_SPINEGRAPHIC_RUNTIME_REPLAY_RAW_SKELETON_DECODE_RECOVERY_RESULT.md`
  - JSON: `girlswar_maininterface_unity\Assets\RestoreData\maininterface_route_spinegraphic_runtime_replay_raw_skeleton_decode_recovery.json`
  - CSV: `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_spinegraphic_runtime_replay_raw_skeleton_decode_recovery.csv`
  - probe log: `reports\maininterface\unity_114_route_raw_decode_recovery_probe.log`
- Next UI blocker:
  - `route SkeletonGraphic replay integration in MainInterface`

### Command Folder Cleanup

- Root command policy is preserved:
  - root has only `00_COMMAND_CENTER.cmd`
  - no new root CMD was created
- `_restore_tools` direct CMD cleanup:
  - historical direct tool CMD files moved to `_restore_tools\cmd_archive`
  - `_restore_tools\current` now contains only the small current launchers
  - `_restore_tools\current\01_RUN_LATEST_MAININTERFACE_UI_VALIDATION.cmd` now calls UI114 from the archive
  - `_restore_tools\current\02_RUN_LATEST_BATTLE_VALIDATION.cmd` now calls BATTLE_34 from the archive
- Final state:
  - `_restore_tools` direct `.cmd` count is `0`
  - all direct tool launchers are either under `_restore_tools\current` or `_restore_tools\cmd_archive`

## Update 2026-06-25 21:53 KST

### UI MAININTERFACE_115 Result

- Visual verdict: MainInterface is still not a normal/restored UI.
- UI115 applied no visual fix.
- Decision: `route_skeletongraphic_replay_integration_trace_complete`.
- Blocked targets: `2`
  - `Spine_shijieanniu` / `spine_diqiu`
  - `8007` / `spine_xiaoren`
- Main blocker:
  - `girlswar_maininterface_unity` does not yet have real `Spine.Unity.SkeletonGraphic`, `SkeletonDataAsset`, or `AtlasAsset` runtime types.
  - The clean raw skeleton decode from UI114 exists, but it cannot yet be attached as evidence-backed `SkeletonGraphic` replay inside the MainInterface scene.
- Rule gate preserved:
  - no coordinate-only placement
  - no whole atlas placement
  - no crop guessing
  - no fake icon
  - no debug/path/evidence overlay in the final capture
- Verification:
  - capture: `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`
  - click validation: `24 / 24 / 0 / 24`, generated `2026-06-25 21:50:00`
- Outputs:
  - active tool: `_restore_tools\cmd_archive\115_ROUTE_SKELETONGRAPHIC_REPLAY_INTEGRATION_IN_MAININTERFACE.cmd`
  - report: `reports\maininterface\MAININTERFACE_ROUTE_SKELETONGRAPHIC_REPLAY_INTEGRATION_RESULT.md`
  - JSON: `girlswar_maininterface_unity\Assets\RestoreData\maininterface_route_skeletongraphic_replay_integration.json`
  - CSV: `girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_skeletongraphic_replay_integration.csv`
- Next UI blocker:
  - `import real Spine 4 runtime into girlswar_maininterface_unity or build MainInterface replay scene inside the Spine probe project`

### BATTLE_35 Result

- Visual verdict: original clip05 actor motion is still not reproduced.
- BATTLE_35 used `C:\Users\godho\Downloads\플레이.mp4` clip05 `485.0-487.0s` as the motion gate.
- Verdict: `failed_spine_shader_or_runtime_mesh_still_magenta`.
- This is not a final restored battle screen.
- Runtime import/probe:
  - imported vendor Spine runtime files: `174`
  - imported runtime bytes: `1318977`
  - Unity exit code after rerun: `0`
  - real Spine runtime present: `True`
  - `SkeletonAnimation` components: `3`
  - `AnimationState.SetAnimation` success: `3 / 3`
  - real mesh updated count: `0 / 3`
  - magenta pixel ratio: `0.068621`
- Skel/atlas/material/texture evidence:
  - traced actors: `3`
  - expected animation exact match in `.skel`: `2 / 3`
  - `1002`: expected `ult`, present `True`
  - `1034`: expected `skill1`, present `True`
  - `3001`: serialized `attack`, exact present `False`
- Important blocker:
  - real Spine runtime types now compile and load, but the original AssetBundle actor instances still do not show a changed mesh after AnimationState/LateUpdate probe
  - magenta/static rendering was not hidden with arbitrary material
  - no fake actor motion was generated
- Outputs:
  - active tool: `_restore_tools\cmd_archive\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS.cmd`
  - report: `reports\battle\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_RESULT.md`
  - JSON: `reports\battle\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_RESULT.json`
  - Unity data: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS.json`
  - Unity probe JSON: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_UNITY.json`
  - contact sheet: `reports\battle\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS_CONTACT_SHEET.jpg`
- Next battle blocker:
  - `BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING`

### Command Folder Cleanup

- Root command policy is preserved:
  - root has only `00_COMMAND_CENTER.cmd`
  - root also has `README_COMMANDS.md` as documentation
  - no new root CMD was created
- `_restore_tools` direct CMD policy is preserved:
  - `_restore_tools` direct `.cmd` count is `0`
  - `_restore_tools\current\01_RUN_LATEST_MAININTERFACE_UI_VALIDATION.cmd` now calls UI115 from the archive
  - `_restore_tools\current\02_RUN_LATEST_BATTLE_VALIDATION.cmd` now calls BATTLE_35 from the archive

## Update 2026-06-25 22:12 KST

### Command Folder Cleanup

- Root command policy is still preserved.
- Root CMD count: `1`.
- Only root launcher: `00_COMMAND_CENTER.cmd`.
- `_restore_tools` direct `.cmd` count: `0`.
- Latest current wrappers now point at the newest accepted probe tools:
  - `_restore_tools\current\01_RUN_LATEST_MAININTERFACE_UI_VALIDATION.cmd` -> `_restore_tools\cmd_archive\116_IMPORT_REAL_SPINE4_RUNTIME_BRIDGE_FOR_ROUTE_SKELETONGRAPHIC_REPLAY.cmd`
  - `_restore_tools\current\02_RUN_LATEST_BATTLE_VALIDATION.cmd` -> `_restore_tools\cmd_archive\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING.cmd`

### UI MAININTERFACE_116 Result

- Visual verdict: MainInterface is still not a normal/restored UI.
- UI116 imported real Spine 4 runtime into `girlswar_maininterface_unity` and generated a separate replay candidate scene, not a final visual fix.
- Runtime bridge result:
  - imported runtime package rows: `174`
  - copied route raw assets: `26`
  - main project Spine runtime ready: `True`
  - `spine_diqiu / Spine_shijieanniu`: `SkeletonGraphic` attach/init success
  - `spine_xiaoren / 8007`: `SkeletonGraphic` attach/init success
  - visual fixes applied in replay candidate: `2`
- Manual capture review:
  - right route cluster now shows real Spine replay candidates
  - layout/text/overlap/layering are still wrong enough that this must not be called normal UI
- Verification:
  - click validation: `24 / 24 / 0 / 24`, generated `2026-06-25 22:05:48`
  - capture: `girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_route_spine_runtime_bridge_1680x720.png`
- Outputs:
  - active tool: `_restore_tools\cmd_archive\116_IMPORT_REAL_SPINE4_RUNTIME_BRIDGE_FOR_ROUTE_SKELETONGRAPHIC_REPLAY.cmd`
  - report: `reports\maininterface\MAININTERFACE_116_IMPORT_REAL_SPINE4_RUNTIME_BRIDGE_FOR_ROUTE_SKELETONGRAPHIC_REPLAY_RESULT.md`
  - JSON: `girlswar_maininterface_unity\Assets\RestoreData\maininterface_116_import_real_spine4_runtime_bridge_for_route_skeletongraphic_replay.json`
  - replay scene: `girlswar_maininterface_unity\Assets\Scenes\MainInterface_RouteSpineRuntimeReplay.unity`
- Next UI blocker:
  - `route SkeletonGraphic visual/layout validation against original/video evidence`

### Battle BATTLE_36 Result

- Visual verdict: original clip05 actor motion is still not reproduced.
- BATTLE_36 used `C:\Users\godho\Downloads\플레이.mp4` clip05 `485.0-487.0s` as the motion gate.
- Verdict: `failed_mesh_updates_but_shader_material_render_still_magenta`.
- This is not a final restored battle screen.
- Runtime trace:
  - `SkeletonAnimation`: `3 / 3`
  - Initialize valid: `3 / 3`
  - `AnimationState.SetAnimation`: `3 / 3`
  - `Update(float)`: `3 / 3`
  - `MeshGenerator` non-null: `3`
  - mesh hash changed actors: `3 / 3`
  - unsupported shader/material evidence: `17`
  - capture magenta ratio: `0.071884`
- Manual contact sheet review:
  - reference video frames show normal moving battle actors
  - current runtime capture is still magenta and not user-visible success
  - no arbitrary material, fake animation, or debug overlay was accepted as final
- Outputs:
  - active tool: `_restore_tools\cmd_archive\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING.cmd`
  - report: `reports\battle\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_RESULT.md`
  - JSON: `reports\battle\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_RESULT.json`
  - Unity data: `girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING.json`
  - contact sheet: `reports\battle\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING_CONTACT_SHEET.jpg`
- Next battle blocker:
  - `BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES`

## Update 2026-06-25 22:18 KST

### Delegated Next Work

- UI thread `019efdb6-503d-7373-be2b-6dcd1a247b1a` was assigned:
  - `MAININTERFACE_117_VALIDATE_AND_FIX_ROUTE_SKELETONGRAPHIC_LAYOUT_AGAINST_ORIGINAL_EVIDENCE`
  - target blocker: `route SkeletonGraphic visual/layout validation against original/video evidence`
- Battle thread `019efdb6-9db2-7e52-bbef-c959eb4d619e` was assigned:
  - `BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES`
  - target blocker: `unsupported original Spine shader/material/pass binding`
- Main thread remains responsible for:
  - root command layout
  - `_restore_tools\current` wrapper updates
  - final commit/push to `origin/main`
  - sanity-checking that UI/Battle reports do not claim success unless captures and validation prove it

### Command Policy Snapshot

- Root CMD count: `1`
- Only root launcher: `00_COMMAND_CENTER.cmd`
- `_restore_tools` direct `.cmd` count: `0`

## Update 2026-06-25 22:30 KST

### Home Handoff

- Stable handoff document:
  - `reports\NEXT_RESTORE_HANDOFF.md`
- Latest command wrappers now point at:
  - MainInterface: `_restore_tools\cmd_archive\117_VALIDATE_AND_FIX_ROUTE_SKELETONGRAPHIC_LAYOUT_AGAINST_ORIGINAL_EVIDENCE.cmd`
  - Battle: `_restore_tools\cmd_archive\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES.cmd`

### UI MAININTERFACE_117 Result

- Visual verdict: MainInterface is still not a normal/restored UI.
- UI117 suppressed only the interim bitmap fallback layers after real `SkeletonGraphic` evidence existed.
- Validated capture still shows a large white route diamond/panel around the route cluster.
- Verification:
  - click validation: `2026-06-25 22:25:37`, `24 / 24 / 0 / 24`
  - interim fallback suppressed: `3`
  - route TMP variant rows OK: `6 / 6`
- Next UI blocker:
  - `MAININTERFACE_118_BIND_ROUTE_SKELETONGRAPHIC_UI_MATERIAL_SHADER_PASS_FROM_ORIGINAL_FIELDS`

### Battle BATTLE_37 Result

- Visual verdict: original clip05 actor motion is still not reproduced.
- BATTLE37 reduced the shader/material magenta blocker:
  - unsupported shader/material before/after: `5 -> 0`
  - evidence-backed same-name Spine shader rebinds: `5`
  - magenta ratio: `0.071884 -> 0.000387`
  - mesh hash changed actors: `3 / 3`
- This is still not a final battle screen because actor scale/camera/timing/context does not match the video.
- Next battle blocker:
  - `BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05`
