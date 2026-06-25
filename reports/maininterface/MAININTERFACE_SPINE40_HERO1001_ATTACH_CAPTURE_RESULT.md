# Spine 4.0 Hero 1001 Attach/Capture Result

Generated: 2026-06-25 14:33:01

## Verdict

The isolated probe attached Hero 1001 through real Spine SkeletonGraphic components and rendered nonblank hero-only pixels.

## Run

| item | value |
| --- | --- |
| status | `hero1001_spine_rendered_in_probe` |
| probe project | `C:\Users\godho\Downloads\girlswar\_restore_tools\work\spine40_unity6000_probe_20260625_134314` |
| Unity exit code | `0` |
| Unity process exit code | `0` |
| Unity log return code | `0` |
| log | `C:\Users\godho\Downloads\girlswar\reports\maininterface\spine40_hero1001_attach_capture_latest.log` |
| probe scene | `Assets/Scenes/MainInterface_Wireframe_Hero1001SpineProbe.unity` |
| homePara | `[1,0,0]` |

## Captures

| capture | copied path | visible pixels | unique colors | bounds |
| --- | --- | ---: | ---: | --- |
| full MainInterface | `C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_1680x720.png` | 1203061 | 364016 | `0,0 - 1679,719` |
| hero only | `C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_hero_only_1680x720.png` | 1166048 | 376643 | `4,0 - 1679,719` |

## Layers

| layer | animation | bones | slots | animations | main vertices | canvas renderers | layer visible pixels | matched bounds |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `Painting_1001_back` | `A` | 32 | 3 | 4 | 0 | 4 | 1165680 | True |
| `Painting_1001` | `A` | 326 | 146 | 4 | 0 | 44 | 402344 | True |
| `Painting_1001_front` | `A` | 39 | 4 | 4 | 0 | 3 | 140624 | True |
| `SP_heroname_1001` | `A1` | 5 | 6 | 2 | 0 | 3 | 16630 | True |

## Candidate Variants

| variant | suffix | non-hero UI enabled | visible pixels | unique colors | bounds | enabled Spine objects |
| --- | --- | --- | ---: | ---: | --- | --- |
| `main_only` | `full` | True | 1203057 | 199527 | `0,0 - 1679,719` | `Restore_Hero1001_Painting_1001` |
| `main_front` | `full` | True | 1203057 | 250590 | `0,0 - 1679,719` | `Restore_Hero1001_Painting_1001, Restore_Hero1001_Painting_1001_front` |
| `main_name` | `full` | True | 1203057 | 197083 | `0,0 - 1679,719` | `Restore_Hero1001_Painting_1001, Restore_Hero1001_SP_heroname_1001` |
| `main_front_name` | `full` | True | 1203057 | 247683 | `0,0 - 1679,719` | `Restore_Hero1001_Painting_1001, Restore_Hero1001_Painting_1001_front, Restore_Hero1001_SP_heroname_1001` |
| `all_layers_with_back` | `full` | True | 1203061 | 364016 | `0,0 - 1679,719` | `Restore_Hero1001_Painting_1001_back, Restore_Hero1001_Painting_1001, Restore_Hero1001_Painting_1001_front, Restore_Hero1001_SP_heroname_1001` |
| `main_only` | `hero_only` | False | 402344 | 127310 | `379,0 - 1451,719` | `Restore_Hero1001_Painting_1001` |
| `main_front` | `hero_only` | False | 427414 | 179400 | `4,0 - 1451,719` | `Restore_Hero1001_Painting_1001, Restore_Hero1001_Painting_1001_front` |
| `main_name` | `hero_only` | False | 404768 | 125051 | `379,0 - 1451,719` | `Restore_Hero1001_Painting_1001, Restore_Hero1001_SP_heroname_1001` |
| `main_front_name` | `hero_only` | False | 429721 | 176520 | `4,0 - 1451,719` | `Restore_Hero1001_Painting_1001, Restore_Hero1001_Painting_1001_front, Restore_Hero1001_SP_heroname_1001` |
| `all_layers_with_back` | `hero_only` | False | 1166048 | 376643 | `4,0 - 1679,719` | `Restore_Hero1001_Painting_1001_back, Restore_Hero1001_Painting_1001, Restore_Hero1001_Painting_1001_front, Restore_Hero1001_SP_heroname_1001` |

## Restore Meaning

- This remains probe-only evidence; it does not modify the main Unity restore project.
- The hero is attached as Spine `SkeletonGraphic` layers under `UI_heroSpine`, not as whole atlas PNG images.
- Do not port the same four-layer attach directly into the main restore project yet. `Painting_1001_back` is background-like evidence and can overpaint the home background that Lua loads separately.
- Visual QA result: `main_only` is the first apply candidate. `main_front_name` and `all_layers_with_back` overpaint the face, center UI, or separately loaded home background, so keep them conditional until the real home branch proves they are needed.

## Generated Files

- `C:\Users\godho\Downloads\girlswar\reports\maininterface\maininterface_spine40_hero1001_attach_capture_result.json`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_1680x720.png`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_hero_only_1680x720.png`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_layer_*_1680x720.png`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_variant_*_1680x720.png`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\spine40_hero1001_attach_capture_latest.log`
