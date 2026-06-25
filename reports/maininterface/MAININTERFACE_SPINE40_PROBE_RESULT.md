# Spine 4.0 Unity 6000 Probe Result

Generated: 2026-06-25 13:44:50

## Verdict

Spine 4.0 runtime files imported and compiled in the Unity 6000 probe, but the log contains a non-fatal import-time exception.

Next: Keep working inside the probe: create/bind the 1001 SkeletonDataAsset and capture before touching the main restore project.

## Probe

| 항목 | 값 |
| --- | --- |
| status | `probe_runtime_present_with_soft_import_exception` |
| source project | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity` |
| probe project | `C:\Users\godho\Downloads\girlswar\_restore_tools\work\spine40_unity6000_probe_20260625_134314` |
| unitypackage | `C:\Users\godho\Downloads\girlswar\_restore_tools\vendor\spine-unity-4.0-2024-08-21.unitypackage` |
| Unity exit code | `1` |
| Unity log return code | `0` |
| batchmode success marker | `True` |
| robocopy exit code | `1` |
| log | `C:\Users\godho\Downloads\girlswar\reports\maininterface\spine40_unity6000_probe_import_latest.log` |
| `Assets/Spine` exists | `True` |
| Spine file count | `567` |
| `SkeletonGraphic.cs` exists | `True` |
| `SkeletonDataAsset.cs` exists | `True` |
| hard log issue count | `0` |
| soft log issue count | `2` |

## Import Markers

- line 1245: `Import package from :C:\Users\godho\Downloads\girlswar\_restore_tools\vendor\spine-unity-4.0-2024-08-21.unitypackage !`

## Hard Issue Lines

- none

## Soft Issue Lines

- line 1609: `Start importing Assets/Spine Examples/Spine Skeletons/spineboy-unity/Equips/gun-normal.png using Guid(602e098a046fa6e42a109d3e45c590f2) (TextureImporter)UnityException: Calls to "AssetDatabase.CreateAsset" are restricted during asset importing. Please make sure this function is not called from ScriptedImporters or PostProcessors, as it is a source of non-determinism.`
- line 1617: `Rethrow as TargetInvocationException: Exception has been thrown by the target of an invocation.`

## Restore Meaning

- If status is not `probe_import_clean_on_unity6000`, do not bind this runtime into the main restore project.
- If status is clean, the next proof is still visual: build the 1001 `SkeletonDataAsset` in the probe, attach it under `UI_heroSpine`, and capture graphics mode output.
- MainInterface is not complete until the character renders as Spine, not as a whole atlas placeholder.

## Generated Files

- `Assets/RestoreData/reports/maininterface_spine40_probe_result.json`
- `reports/maininterface/spine40_unity6000_probe_import_latest.log`
