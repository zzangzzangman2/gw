@echo off
setlocal
set ROOT=%~dp0..
set UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe
set PROJECT=%ROOT%\girlswar_maininterface_unity

"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod GirlsWarRestore.MainInterfaceGuildMainCustomComponentTypeReconstruction.TraceGuildMainCustomComponentTypeReconstruction -logFile "%PROJECT%\logs\unity_maininterface_109_guildmain_custom_component_type_reconstruction.log"
if errorlevel 1 exit /b %errorlevel%

"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks -logFile "%PROJECT%\logs\unity_maininterface_109_guildmain_custom_component_click_validation.log"
if errorlevel 1 exit /b %errorlevel%

python "%~dp0scripts\summarize_guildmain_custom_component_type_reconstruction.py"
exit /b %errorlevel%
