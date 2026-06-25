@echo off
setlocal
set ROOT=%~dp0..
set UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe
set PROJECT=%ROOT%\girlswar_maininterface_unity
set LOG=%PROJECT%\logs\unity_maininterface_navigation_target_load_probe.log

"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod GirlsWarRestore.MainInterfaceNavigationTargetLoadProbe.ProbeTargetLoads -logFile "%LOG%"
if errorlevel 1 exit /b %errorlevel%

python "%~dp0scripts\summarize_maininterface_navigation_target_load_probe.py"
exit /b %errorlevel%
