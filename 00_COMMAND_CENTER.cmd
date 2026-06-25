@echo off
setlocal
chcp 65001 >nul

set "ROOT=%~dp0"
set "TOOLS=%ROOT%_restore_tools"
set "ARCHIVE=%TOOLS%\root_cmd_archive"
set "STATUS=%ROOT%reports\WORK_SPLIT_STATUS_20260625_1708.md"
set "BATTLE30=%TOOLS%\BATTLE_30_VERIFY_HERO_CARD_RUNTIME_LAYOUT_AND_ATTACH_ACTOR_ANIMATION_TRACE.cmd"
set "BATTLE29=%TOOLS%\BATTLE_29_BIND_HERO_LIST_SKILLCARDS_AND_VALIDATE_CLIP05.cmd"

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
echo 1. Open active tools folder
echo 2. Run MainInterface restore menu
echo 3. Run latest battle validation
echo 4. Open work split status report
echo 5. Open battle reports folder
echo 6. Open archived old root CMD shortcuts
echo 7. Show git status
echo 8. Run GitHub push helper from archive
echo Q. Quit
echo.
choice /c 12345678Q /n /m "Select: "
if errorlevel 9 goto done
if errorlevel 8 call "%ARCHIVE%\PUSH_TO_GITHUB_MAIN.cmd" & pause & goto menu
if errorlevel 7 git -C "%ROOT%" status --short & pause & goto menu
if errorlevel 6 start "" "%ARCHIVE%" & goto menu
if errorlevel 5 start "" "%ROOT%reports\battle" & goto menu
if errorlevel 4 start "" "%STATUS%" & goto menu
if errorlevel 3 (
  if exist "%BATTLE30%" (
    call "%BATTLE30%"
  ) else (
    call "%BATTLE29%"
  )
  goto menu
)
if errorlevel 2 call "%TOOLS%\00_START_HERE_GIRLSWAR_RESTORE_MENU.cmd" & goto menu
if errorlevel 1 start "" "%TOOLS%" & goto menu
goto menu

:done
exit /b 0
