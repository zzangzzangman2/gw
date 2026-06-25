@echo off
setlocal
chcp 65001 >nul

set "ROOT=%~dp0"
set "TOOLS=%ROOT%_restore_tools"
set "CURRENT=%TOOLS%\current"
set "ROOT_CMD_ARCHIVE=%TOOLS%\root_cmd_archive"
set "CMD_ARCHIVE=%TOOLS%\cmd_archive"
set "STATUS=%ROOT%reports\WORK_SPLIT_STATUS_20260625_1708.md"
set "UI114=%CMD_ARCHIVE%\114_ROUTE_SPINEGRAPHIC_RUNTIME_REPLAY_RAW_SKELETON_DECODE_RECOVERY.cmd"
set "UI113=%CMD_ARCHIVE%\113_RESTORE_MAININTERFACE_ROUTE_SPINE_SLOT_BONE_ANIMATION_TRANSFORM.cmd"
set "UI112=%CMD_ARCHIVE%\112_TRACE_MAININTERFACE_ROUTE_NON_IMAGE_RENDERER_EFFECT_RUNTIME_STATE.cmd"
set "UI111=%CMD_ARCHIVE%\111_REVALIDATE_MAININTERFACE_ROUTE_LABEL_RECT_OVERRIDES.cmd"
set "UI110=%CMD_ARCHIVE%\110_FIX_MAININTERFACE_ROUTE_TMP_VARIANT_MATERIAL_TEXTURE_PTRS.cmd"
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
echo Q. Quit
echo.
choice /c 123456789AQ /n /m "Select: "
if errorlevel 11 goto done
if errorlevel 10 call "%ROOT_CMD_ARCHIVE%\PUSH_TO_GITHUB_MAIN.cmd" & pause & goto menu
if errorlevel 9 git -C "%ROOT%" status --short & pause & goto menu
if errorlevel 8 start "" "%CMD_ARCHIVE%" & goto menu
if errorlevel 7 start "" "%ROOT%reports\battle" & goto menu
if errorlevel 6 start "" "%ROOT%reports\maininterface" & goto menu
if errorlevel 5 start "" "%STATUS%" & goto menu
if errorlevel 4 (
  if exist "%BATTLE34%" (
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
  if exist "%UI114%" (
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
