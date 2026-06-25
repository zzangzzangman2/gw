@echo off
setlocal
set ROOT=%~dp0..
set UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe
set PROJECT=%ROOT%\girlswar_maininterface_unity

"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod GirlsWarRestore.MainInterfaceNavigationPrototypeBuilder.BuildNavigationPrototypeScene -logFile "%PROJECT%\logs\unity_maininterface_navigation_target_visual_build.log"
if errorlevel 1 exit /b %errorlevel%

"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod GirlsWarRestore.MainInterfaceNavigationTargetCapture.CaptureNavigationTargetLayouts -logFile "%PROJECT%\logs\unity_maininterface_navigation_target_visual_capture.log"
if errorlevel 1 exit /b %errorlevel%

"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks -logFile "%PROJECT%\logs\unity_maininterface_button_navigation_click_validation.log"
if errorlevel 1 exit /b %errorlevel%

python "%~dp0scripts\summarize_maininterface_navigation_target_visual_capture.py"
exit /b %errorlevel%
