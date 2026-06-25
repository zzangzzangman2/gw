@echo off
setlocal

set "REPORT=C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TMP_TEXT_DETAILS.md"

if exist "%REPORT%" (
  start "" "%REPORT%"
) else (
  echo Missing report: %REPORT%
  echo Run 73_EXPORT_MAININTERFACE_TMP_TEXT_DETAILS.cmd first.
  pause
)
