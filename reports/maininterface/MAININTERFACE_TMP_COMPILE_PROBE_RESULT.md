# MainInterface TMP Compile Probe Result

Generated: 2026-06-25 14:54:00

## Verdict

Unity 6000 probe compiled using TMPro and created a TextMeshProUGUI component successfully. The MainInterface builder can split TMP-like rows into a TextMeshProUGUI path.

## Result

| item | value |
| --- | --- |
| status | `tmp_compile_ok` |
| Unity exit code | `not_reported_by_powershell` |
| probe project | `C:\Users\godho\Downloads\girlswar\_restore_tools\work\tmp_unity6000_probe_20260625_145349` |
| Unity log | `C:\Users\godho\Downloads\girlswar\_restore_tools\logs\tmp_compile_probe_20260625_145349.log` |
| probe result json | `C:\Users\godho\Downloads\girlswar\_restore_tools\work\tmp_unity6000_probe_20260625_145349\Assets\RestoreData\reports\tmp_compile_probe_result.json` |
| compile errors | `0` |

## Package Note

In Unity 6000, `com.unity.textmeshpro` is a shim package and TMP functionality is included through `com.unity.ugui` 2.0. The restore project already has `com.unity.ugui`, so the builder should be changed only after this compile/create probe passes.

## Next

1. Split `maininterface_text_components.csv` rows into UGUI and TMP-like groups by script_id/component fields.
2. Add a `TextMeshProUGUI` creation path for TMP-like rows.
3. Map original TMP fields to `maininterface_tmp_font_assets.csv` FontAsset/atlas evidence.
4. Validate the right-route TMP labels first with a fresh graphics capture.