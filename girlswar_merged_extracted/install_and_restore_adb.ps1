# GirlsWar install + restore helper
# Run from this output folder after enabling USB debugging and making adb available in PATH.
$ErrorActionPreference = "Stop"
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$ApkDir = Join-Path $Here "split_apks"

adb install-multiple `
  (Join-Path $ApkDir "com.girlwars.kr.apk") `
  (Join-Path $ApkDir "config.arm64_v8a.apk") `
  (Join-Path $ApkDir "abassets.apk")

adb shell am force-stop com.girlwars.kr
adb push (Join-Path $Here "restore_overlay\Android\data\com.girlwars.kr") "/sdcard/Android/data/"
adb shell am force-stop com.girlwars.kr
