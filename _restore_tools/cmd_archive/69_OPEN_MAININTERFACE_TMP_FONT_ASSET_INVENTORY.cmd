@echo off
setlocal

set "REPORT=C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TMP_FONT_ASSET_INVENTORY.md"

if exist "%REPORT%" (
  start "" "%REPORT%"
) else (
  echo Missing report: %REPORT%
  echo Run 68_ANALYZE_MAININTERFACE_TMP_FONT_ASSETS.cmd first.
  pause
)
