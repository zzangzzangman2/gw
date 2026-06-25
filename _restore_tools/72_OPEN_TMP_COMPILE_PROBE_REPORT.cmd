@echo off
setlocal

set "REPORT=C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TMP_COMPILE_PROBE_RESULT.md"

if exist "%REPORT%" (
  start "" "%REPORT%"
) else (
  echo Missing report: %REPORT%
  echo Run 71_RUN_TMP_COMPILE_PROBE.cmd first.
  pause
)
