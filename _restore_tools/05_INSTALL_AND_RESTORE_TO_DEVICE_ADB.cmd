@echo off
setlocal
if not exist "C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\install_and_restore_adb.ps1" (
  echo Restore script not found:
  echo C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\install_and_restore_adb.ps1
  pause
  exit /b 1
)
echo This will run adb install-multiple and push Android/data/com.girlwars.kr.
echo Make sure USB debugging is enabled and adb devices shows your device.
echo.
pause
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\install_and_restore_adb.ps1"
pause


