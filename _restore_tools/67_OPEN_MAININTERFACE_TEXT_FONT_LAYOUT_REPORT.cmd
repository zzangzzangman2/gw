@echo off
setlocal

set "REPORT=C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TEXT_FONT_LAYOUT_ANALYSIS.md"

if exist "%REPORT%" (
  start "" "%REPORT%"
) else (
  echo Missing report: %REPORT%
  echo Run 66_ANALYZE_MAININTERFACE_TEXT_FONT_LAYOUT.cmd first.
  pause
)
