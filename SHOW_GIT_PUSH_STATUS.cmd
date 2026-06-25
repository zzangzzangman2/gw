@echo off
setlocal
cd /d "%~dp0"
echo === git status ===
git status --short --branch
echo.
echo === git remote ===
git remote -v
echo.
echo === last push log ===
if exist "_restore_tools\logs\github_push_main.log" (
  type "_restore_tools\logs\github_push_main.log"
) else (
  echo No push log yet.
)
