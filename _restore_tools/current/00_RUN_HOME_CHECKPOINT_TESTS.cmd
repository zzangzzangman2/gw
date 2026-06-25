@echo off
setlocal
chcp 65001 >nul

set "CURRENT=%~dp0"

echo GirlsWar home checkpoint tests
echo =============================
echo.
echo 1/2 MainInterface UI121 validation
call "%CURRENT%01_RUN_LATEST_MAININTERFACE_UI_VALIDATION.cmd"
set "UI_EXIT=%errorlevel%"
echo.
echo 2/2 Battle BATTLE40 validation
call "%CURRENT%02_RUN_LATEST_BATTLE_VALIDATION.cmd"
set "BATTLE_EXIT=%errorlevel%"
echo.
echo Reports:
echo   reports\maininterface\MAININTERFACE_121_VERIFY_ROUTE_SKELETONGRAPHIC_CANVASRENDERER_TEXTURE_HANDOFF_AND_CLIPPING_TRIANGULATION_ZONG1_RESULT.md
echo   reports\battle\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT_RESULT.md
echo.
echo Exit codes: UI=%UI_EXIT% Battle=%BATTLE_EXIT%
echo.
pause

if not "%UI_EXIT%"=="0" exit /b %UI_EXIT%
exit /b %BATTLE_EXIT%
