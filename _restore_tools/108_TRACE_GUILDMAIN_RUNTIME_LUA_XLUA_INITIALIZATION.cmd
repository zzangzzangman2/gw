@echo off
setlocal
set ROOT=%~dp0..
set UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe
set PROJECT=%ROOT%\girlswar_maininterface_unity

python "%~dp0scripts\trace_guildmain_runtime_lua_xlua_initialization.py"
if errorlevel 1 exit /b %errorlevel%

"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks -logFile "%PROJECT%\logs\unity_maininterface_108_guildmain_runtime_click_validation.log"
if errorlevel 1 exit /b %errorlevel%

python "%~dp0scripts\trace_guildmain_runtime_lua_xlua_initialization.py" --report-only
exit /b %errorlevel%
