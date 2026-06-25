$ErrorActionPreference = "Stop"
$Unity = "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
$Project = "C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity"
$Log = Join-Path $Project "logs\unity_maininterface_build.log"
if (!(Test-Path -LiteralPath $Unity)) { throw "Unity.exe not found: $Unity" }
Start-Process -FilePath $Unity -ArgumentList @(
  "-batchmode",
  "-quit",
  "-projectPath", $Project,
  "-executeMethod", "GirlsWarRestore.MainInterfaceSceneBuilder.BuildMainInterfaceScene",
  "-logFile", $Log
) -WindowStyle Hidden
"Started Unity background build. Log: $Log"
