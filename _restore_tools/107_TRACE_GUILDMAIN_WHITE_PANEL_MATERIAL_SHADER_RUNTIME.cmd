@echo off
setlocal
set ROOT=%~dp0..
set UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe
set PROJECT=%ROOT%\girlswar_maininterface_unity

"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod GirlsWarRestore.MainInterfaceNavigationPrototypeBuilder.BuildNavigationPrototypeScene -logFile "%PROJECT%\logs\unity_maininterface_107_guildmain_white_panel_build.log"
if errorlevel 1 exit /b %errorlevel%

"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod GirlsWarRestore.MainInterfaceGuildMainWhitePanelTrace.TraceGuildMainWhitePanelMaterialShaderRuntime -logFile "%PROJECT%\logs\unity_maininterface_107_guildmain_white_panel_trace.log"
if errorlevel 1 exit /b %errorlevel%

"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks -logFile "%PROJECT%\logs\unity_maininterface_button_navigation_click_validation.log"
if errorlevel 1 exit /b %errorlevel%

python "%~dp0scripts\summarize_guildmain_white_panel_material_shader_runtime_trace.py"
exit /b %errorlevel%
