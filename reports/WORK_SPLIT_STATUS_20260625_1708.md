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
