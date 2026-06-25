@echo off
setlocal
set ROOT=%~dp0..
set UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe
set PROJECT=%ROOT%\girlswar_maininterface_unity

python "%~dp0scripts\join_maininterface_navigation_target_sprite_atlas_slices.py" --prepare
if errorlevel 1 exit /b %errorlevel%

"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod GirlsWarRestore.MainInterfaceNavigationPrototypeBuilder.BuildNavigationPrototypeScene -logFile "%PROJECT%\logs\unity_maininterface_navigation_target_sprite_join_build.log"
if errorlevel 1 exit /b %errorlevel%

"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod GirlsWarRestore.MainInterfaceNavigationTargetSpriteAtlasJoin.CaptureAfterSpriteAtlasSliceJoin -logFile "%PROJECT%\logs\unity_maininterface_navigation_target_sprite_join_capture.log"
if errorlevel 1 exit /b %errorlevel%

"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks -logFile "%PROJECT%\logs\unity_maininterface_button_navigation_click_validation.log"
if errorlevel 1 exit /b %errorlevel%

python "%~dp0scripts\join_maininterface_navigation_target_sprite_atlas_slices.py" --report
exit /b %errorlevel%
