@echo off
setlocal
cd /d "%~dp0"

:menu
cls
echo GirlsWar Restore Tools
echo =======================
echo.
echo 1. Verify all MainInterface outputs
echo 2. Open MainInterface status MD
echo 3. Open detailed restore plan
echo 4. Rebuild restored MainInterface scene in background
echo 5. Capture restored MainInterface screen
echo 6. Validate MainInterface button clicks in background
echo 7. Analyze MainInterface click blockers
echo 8. Open click validation report
echo 9. Open click blocker analysis report
echo A. Open raycast override CSV
echo B. Verify source deletion readiness
echo C. Delete ready source originals
echo D. Open source deletion report
echo E. Analyze MainInterface visual gaps
echo F. Open visual gap report
echo G. Open visual override CSV
echo H. Analyze MainInterface coordinate system
echo I. Open coordinate system report
echo J. Analyze MainInterface hero 1001 Spine source
echo K. Open hero Spine restore plan
echo L. Analyze Spine runtime compatibility
echo M. Open Spine runtime compatibility report
echo N. Open Spine vendor folder
echo O. Run isolated Spine 4.0 Unity 6000 probe import
echo P. Analyze Spine 4.0 probe result
echo R. Open Spine 4.0 probe report
echo S. Import Hero 1001 Spine assets in probe
echo T. Analyze Hero 1001 Spine probe import
echo U. Open Hero 1001 Spine probe report
echo V. Extract Hero 1001 raw Spine TextAssets
echo W. Open Hero 1001 raw TextAssets report
echo X. Attach/capture Hero 1001 Spine in probe
echo Y. Open Hero 1001 Spine capture report
echo Z. Open Hero 1001 Spine capture images
echo Q. Quit
echo.
choice /c 123456789ABCDEFGHIJKLMNOPRSTUVWXYZQ /n /m "Select: "
if errorlevel 35 goto done
if errorlevel 34 call "%~dp065_OPEN_HERO1001_SPINE_PROBE_CAPTURE_IMAGES.cmd" & goto menu
if errorlevel 33 call "%~dp064_OPEN_HERO1001_SPINE_PROBE_CAPTURE_REPORT.cmd" & goto menu
if errorlevel 32 call "%~dp063_ATTACH_CAPTURE_HERO1001_SPINE_IN_PROBE.cmd" & goto menu
if errorlevel 31 call "%~dp062_OPEN_HERO1001_SPINE_RAW_TEXTASSETS_REPORT.cmd" & goto menu
if errorlevel 30 call "%~dp061_EXTRACT_HERO1001_SPINE_RAW_TEXTASSETS.cmd" & goto menu
if errorlevel 29 call "%~dp060_OPEN_HERO1001_SPINE_PROBE_IMPORT_REPORT.cmd" & goto menu
if errorlevel 28 call "%~dp059_ANALYZE_HERO1001_SPINE_PROBE_IMPORT.cmd" & goto menu
if errorlevel 27 call "%~dp058_IMPORT_HERO1001_SPINE_IN_PROBE.cmd" & goto menu
if errorlevel 26 call "%~dp057_OPEN_SPINE40_PROBE_REPORT.cmd" & goto menu
if errorlevel 25 call "%~dp056_ANALYZE_SPINE40_PROBE_RESULT.cmd" & goto menu
if errorlevel 24 call "%~dp055_RUN_SPINE40_PROBE_IMPORT.cmd" & goto menu
if errorlevel 23 call "%~dp054_OPEN_SPINE_VENDOR_FOLDER.cmd" & goto menu
if errorlevel 22 call "%~dp053_OPEN_SPINE_RUNTIME_COMPATIBILITY_REPORT.cmd" & goto menu
if errorlevel 21 call "%~dp052_ANALYZE_SPINE_RUNTIME_COMPATIBILITY.cmd" & goto menu
if errorlevel 20 call "%~dp051_OPEN_MAININTERFACE_HERO_SPINE_PLAN.cmd" & goto menu
if errorlevel 19 call "%~dp050_ANALYZE_MAININTERFACE_HERO_SPINE_1001.cmd" & goto menu
if errorlevel 18 call "%~dp049_OPEN_MAININTERFACE_COORDINATE_SYSTEM_REPORT.cmd" & goto menu
if errorlevel 17 call "%~dp048_ANALYZE_MAININTERFACE_COORDINATE_SYSTEM.cmd" & goto menu
if errorlevel 16 call "%~dp047_OPEN_MAININTERFACE_VISUAL_OVERRIDES.cmd" & goto menu
if errorlevel 15 call "%~dp046_OPEN_MAININTERFACE_VISUAL_GAP_ANALYSIS.cmd" & goto menu
if errorlevel 14 call "%~dp045_ANALYZE_MAININTERFACE_VISUAL_GAPS.cmd" & goto menu
if errorlevel 13 call "%~dp044_OPEN_SOURCE_DISPOSAL_READINESS_REPORT.cmd" & goto menu
if errorlevel 12 call "%~dp043_DELETE_READY_SOURCE_ORIGINALS_AFTER_VERIFY.cmd" & goto menu
if errorlevel 11 call "%~dp042_VERIFY_SOURCE_DISPOSAL_READINESS.cmd" & goto menu
if errorlevel 10 call "%~dp041_OPEN_MAININTERFACE_RAYCAST_OVERRIDES.cmd" & goto menu
if errorlevel 9 call "%~dp040_OPEN_MAININTERFACE_CLICK_BLOCKER_ANALYSIS.cmd" & goto menu
if errorlevel 8 call "%~dp038_OPEN_MAININTERFACE_CLICK_VALIDATION_REPORT.cmd" & goto menu
if errorlevel 7 call "%~dp039_ANALYZE_MAININTERFACE_CLICK_BLOCKERS.cmd" & goto menu
if errorlevel 6 call "%~dp037_VALIDATE_MAININTERFACE_BUTTON_CLICKS.cmd" & goto menu
if errorlevel 5 call "%~dp013_CAPTURE_MAININTERFACE_RESTORED_BACKGROUND.cmd" & goto menu
if errorlevel 4 call "%~dp011_BUILD_MAININTERFACE_RESTORED_BACKGROUND.cmd" & goto menu
if errorlevel 3 call "%~dp006_OPEN_RESTORE_PLAN.cmd" & goto menu
if errorlevel 2 call "%~dp012_OPEN_MAININTERFACE_STATUS_MD.cmd" & goto menu
if errorlevel 1 call "%~dp004_VERIFY_MAININTERFACE_OUTPUTS.cmd" & goto menu
goto menu

:done
exit /b 0


