# MainInterface 124 Mount Hero1005 Home Spine SkeletonGraphic Result

Generated: 2026-06-26 01:16:13 KST

## Verdict

Restored claim remains `false`. UI124 mounts the 1005 home character through real Spine `SkeletonGraphic` assets and writes a new capture for review; it does not hide the route/world cluster.

- status: `ui124_hero1005_spine_mounted_capture_generated`
- visual verdict: `not_restored_claim_false_manual_reference_review_required`
- next blocker: `Compare UI124 capture against the 1005 reference. Route/world cluster remains active by evidence and may still overlap the hero because right sibling index is above UI_heroSpine.`
- scene: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\Scenes\MainInterface_UI124_Hero1005HomeSpine.unity`

## Spine Mount

| key | decision | animation | bones | slots | rect | route above hero | detail |
| --- | --- | --- | ---: | ---: | --- | --- | --- |
| `source_import` | `prepared` | `` | 0 | 0 | `0x0` | `False` | `Imported Painting_1005.png, Painting_1005.atlas.txt, and Painting_1005.skel.bytes as source assets.` |
| `raw_source_evidence` | `use_raw_textasset_export` | `` | 0 | 0 | `0x0` | `False` | `UI124 uses the raw TextAsset export folder so Spine reads original .skel bytes; UI123 source files remain untouched as evidence.` |
| `skeletondata_asset` | `created_spine_runtime_assets` | `` | 0 | 0 | `0x0` | `False` | `bones=430; slots=200; skins=1; animations=4` |
| `hero_mount` | `attached_skeletongraphic_main_only` | `A` | 430 | 200 | `1507.335x1162.439` | `True` | `Mounted Painting_1005 as SkeletonGraphic under UI_heroSpine using animation A loop=true; whole atlas UI Image was not used.` |

## Capture

| capture | exists | visible pixels | unique colors | bounds | path |
| --- | ---: | ---: | ---: | --- | --- |
| `full` | `True` | 1201239 | 209615 | `0,0 - 1679,719` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui124_hero1005_spine_1680x720.png` |
| `hero_only` | `True` | 244615 | 126220 | `138,0 - 1434,498` | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui124_hero1005_spine_hero_only_1680x720.png` |

## Click Validation

- total buttons: `77`
- raycast clickable: `24`
- raycast blocked: `0`
- hero SkeletonGraphic raycastTarget: `false`

## Files

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_124_hero1005_home_spine_mount.json`
- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_124_hero1005_home_spine_mount.csv`
- click CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_124_click_validation.csv`
- click JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_124_click_validation_summary.json`
- capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui124_hero1005_spine_1680x720.png`
- hero-only capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_ui124_hero1005_spine_hero_only_1680x720.png`
