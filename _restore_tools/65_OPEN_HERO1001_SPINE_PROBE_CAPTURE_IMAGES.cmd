@echo off
setlocal

set "FULL=C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_1680x720.png"
set "HERO=C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_hero_only_1680x720.png"

if exist "%FULL%" start "" "%FULL%"
if exist "%HERO%" start "" "%HERO%"
for %%F in ("C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_layer_*_1680x720.png") do if exist "%%~fF" start "" "%%~fF"
for %%F in ("C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_variant_*_1680x720.png") do if exist "%%~fF" start "" "%%~fF"
if not exist "%FULL%" echo Missing: %FULL%
if not exist "%HERO%" echo Missing: %HERO%
if not exist "%FULL%" pause
