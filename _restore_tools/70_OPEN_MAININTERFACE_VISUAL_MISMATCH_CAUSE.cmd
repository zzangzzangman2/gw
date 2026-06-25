@echo off
setlocal

set "REPORT=C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_VISUAL_MISMATCH_CAUSE_AND_REVISED_DIRECTION.md"

if exist "%REPORT%" (
  start "" "%REPORT%"
) else (
  echo Missing report: %REPORT%
  pause
)
