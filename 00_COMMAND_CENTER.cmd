@echo off
setlocal
chcp 65001 >nul

set "ROOT=%~dp0"
set "TOOLS=%ROOT%_restore_tools"
set "CURRENT=%TOOLS%\current"
set "ROOT_CMD_ARCHIVE=%TOOLS%\root_cmd_archive"
set "CMD_ARCHIVE=%TOOLS%\cmd_archive"
set "STATUS=%ROOT%reports\WORK_SPLIT_STATUS_20260625_1708.md"
set "HOME_TEST=%CURRENT%\00_RUN_HOME_CHECKPOINT_TESTS.cmd"
set "UI121=%CMD_ARCHIVE%\121_VERIFY_ROUTE_SKELETONGRAPHIC_CANVASRENDERER_TEXTURE_HANDOFF_AND_CLIPPING_TRIANGULATION_ZONG1.cmd"
set "UI120=%CMD_ARCHIVE%\120_TRACE_ROUTE_SKELETONGRAPHIC_ORIGINAL_RUNTIME_MASK_STENCIL_ATTACHMENT_VISIBILITY.cmd"
set "UI119=%CMD_ARCHIVE%\119_VALIDATE_ROUTE_SKELETONGRAPHIC_MESH_BOUNDS_CANVASRENDERER_SUBMESH_MATERIAL.cmd"
set "UI118=%CMD_ARCHIVE%\118_BIND_ROUTE_SKELETONGRAPHIC_UI_MATERIAL_SHADER_PASS_FROM_ORIGINAL_FIELDS.cmd"
set "UI117=%CMD_ARCHIVE%\117_VALIDATE_AND_FIX_ROUTE_SKELETONGRAPHIC_LAYOUT_AGAINST_ORIGINAL_EVIDENCE.cmd"
set "UI116=%CMD_ARCHIVE%\116_IMPORT_REAL_SPINE4_RUNTIME_BRIDGE_FOR_ROUTE_SKELETONGRAPHIC_REPLAY.cmd"
set "UI115=%CMD_ARCHIVE%\115_ROUTE_SKELETONGRAPHIC_REPLAY_INTEGRATION_IN_MAININTERFACE.cmd"
set "UI114=%CMD_ARCHIVE%\114_ROUTE_SPINEGRAPHIC_RUNTIME_REPLAY_RAW_SKELETON_DECODE_RECOVERY.cmd"
set "UI113=%CMD_ARCHIVE%\113_RESTORE_MAININTERFACE_ROUTE_SPINE_SLOT_BONE_ANIMATION_TRANSFORM.cmd"
set "UI112=%CMD_ARCHIVE%\112_TRACE_MAININTERFACE_ROUTE_NON_IMAGE_RENDERER_EFFECT_RUNTIME_STATE.cmd"
set "UI111=%CMD_ARCHIVE%\111_REVALIDATE_MAININTERFACE_ROUTE_LABEL_RECT_OVERRIDES.cmd"
set "UI110=%CMD_ARCHIVE%\110_FIX_MAININTERFACE_ROUTE_TMP_VARIANT_MATERIAL_TEXTURE_PTRS.cmd"
set "BATTLE41=%CMD_ARCHIVE%\BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE.cmd"
set "BATTLE40=%CMD_ARCHIVE%\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT.cmd"
set "BATTLE39=%CMD_ARCHIVE%\BATTLE_39_ATTACH_RUNTIME_ACTORS_TO_MAP11003_HUD_CONTEXT_WITH_EVIDENCE.cmd"
set "BATTLE38=%CMD_ARCHIVE%\BATTLE_38_MATCH_ACTOR_SCALE_CAMERA_TIMING_AND_BATTLE_SCENE_CONTEXT_TO_CLIP05.cmd"
set "BATTLE37=%CMD_ARCHIVE%\BATTLE_37_BIND_ORIGINAL_SPINE_SHADER_VARIANTS_AND_MATERIAL_PASSES.cmd"
set "BATTLE36=%CMD_ARCHIVE%\BATTLE_36_TRACE_REAL_SPINE_INITIALIZE_SKELETONDATA_MATERIAL_SHADER_BINDING.cmd"
set "BATTLE35=%CMD_ARCHIVE%\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS.cmd"
set "BATTLE34=%CMD_ARCHIVE%\BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS.cmd"
set "BATTLE33=%CMD_ARCHIVE%\BATTLE_33_DEEP_TRACE_MONOSCRIPT_ASSEMBLY_GUID_FOR_ACTOR_PREFABS.cmd"
set "BATTLE32=%CMD_ARCHIVE%\BATTLE_32_RESOLVE_BATTLE_ACTOR_SPINE_RUNTIME_CLASS_AND_IDLE_MOTION_REPLAY.cmd"
set "BATTLE31=%CMD_ARCHIVE%\BATTLE_31_ATTACH_LOADABLE_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE.cmd"
set "BATTLE30=%CMD_ARCHIVE%\BATTLE_30_VERIFY_HERO_CARD_RUNTIME_LAYOUT_AND_ATTACH_ACTOR_ANIMATION_TRACE.cmd"
set "BATTLE29=%CMD_ARCHIVE%\BATTLE_29_BIND_HERO_LIST_SKILLCARDS_AND_VALIDATE_CLIP05.cmd"

if not exist "%TOOLS%\" (
  echo Missing tools folder:
  echo %TOOLS%
  pause
  exit /b 1
)

:menu
cls
echo GirlsWar Command Center
echo =======================
echo.
echo 1. Open clean current command folder
echo 2. Run MainInterface restore menu
echo 3. Run latest MainInterface UI validation
echo 4. Run latest battle validation
echo 5. Open work split status report
echo 6. Open MainInterface reports folder
echo 7. Open battle reports folder
echo 8. Open legacy command archive
echo 9. Show git status
echo A. Run GitHub push helper from archive
echo B. Run home checkpoint tests (UI121 + BATTLE40)
echo Q. Quit
echo.
choice /c 123456789ABQ /n /m "Select: "
if errorlevel 12 goto done
if errorlevel 11 call "%HOME_TEST%" & goto menu
if errorlevel 10 call "%ROOT_CMD_ARCHIVE%\PUSH_TO_GITHUB_MAIN.cmd" & pause & goto menu
if errorlevel 9 git -C "%ROOT%" status --short & pause & goto menu
if errorlevel 8 start "" "%CMD_ARCHIVE%" & goto menu
if errorlevel 7 start "" "%ROOT%reports\battle" & goto menu
if errorlevel 6 start "" "%ROOT%reports\maininterface" & goto menu
if errorlevel 5 start "" "%STATUS%" & goto menu
if errorlevel 4 (
  if exist "%BATTLE40%" (
    call "%BATTLE40%"
  ) else if exist "%BATTLE39%" (
    call "%BATTLE39%"
  ) else if exist "%BATTLE38%" (
    call "%BATTLE38%"
  ) else if exist "%BATTLE37%" (
    call "%BATTLE37%"
  ) else if exist "%BATTLE36%" (
    call "%BATTLE36%"
  ) else if exist "%BATTLE35%" (
    call "%BATTLE35%"
  ) else if exist "%BATTLE34%" (
    call "%BATTLE34%"
  ) else if exist "%BATTLE33%" (
    call "%BATTLE33%"
  ) else if exist "%BATTLE32%" (
    call "%BATTLE32%"
  ) else if exist "%BATTLE31%" (
    call "%BATTLE31%"
  ) else if exist "%BATTLE30%" (
    call "%BATTLE30%"
  ) else (
    call "%BATTLE29%"
  )
  goto menu
)
if errorlevel 3 (
  if exist "%UI121%" (
    call "%UI121%"
  ) else if exist "%UI120%" (
    call "%UI120%"
  ) else if exist "%UI119%" (
    call "%UI119%"
  ) else if exist "%UI118%" (
    call "%UI118%"
  ) else if exist "%UI117%" (
    call "%UI117%"
  ) else if exist "%UI116%" (
    call "%UI116%"
  ) else if exist "%UI115%" (
    call "%UI115%"
  ) else if exist "%UI114%" (
    call "%UI114%"
  ) else if exist "%UI113%" (
    call "%UI113%"
  ) else if exist "%UI112%" (
    call "%UI112%"
  ) else if exist "%UI111%" (
    call "%UI111%"
  ) else (
    call "%UI110%"
  )
  goto menu
)
if errorlevel 2 call "%CMD_ARCHIVE%\00_START_HERE_GIRLSWAR_RESTORE_MENU.cmd" & goto menu
if errorlevel 1 start "" "%CURRENT%" & goto menu
goto menu

:done
exit /b 0
