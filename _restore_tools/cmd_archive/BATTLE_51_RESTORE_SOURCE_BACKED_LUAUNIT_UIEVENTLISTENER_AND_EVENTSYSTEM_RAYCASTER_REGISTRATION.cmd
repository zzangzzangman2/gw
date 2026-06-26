@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle51RestoreLuaBridgeAndRaycasterRegistrationEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle51_restore_lua_bridge_raycaster_registration.py" verify --unity-exit %UNITY_EXIT%
exit /b %UNITY_EXIT%
