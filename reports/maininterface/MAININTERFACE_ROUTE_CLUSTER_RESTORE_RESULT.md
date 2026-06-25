# MainInterface Route Cluster Restore Result

Generated: 2026-06-25 17:05 KST

## Scope

- Target workspace: `C:\Users\godho\Downloads\girlswar`
- Unity project: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity`
- Scene: `Assets\Scenes\MainInterface_Wireframe.unity`
- Rule source: `C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt`
- No Git commit or push was performed.

## Verdict

The remaining right route cluster issue is not caused by duplicate route owners being active at the same time. Original RectTransform evidence says `wanfaWorldNode` and `UI_Main_wanfa_item_1..4` are all active children of `node_middle`, with fixed sibling order.

One real SceneBuilder mismatch was fixed: route card `Entry` nodes under `UI_Main_wanfa_item_3` and `UI_Main_wanfa_item_4` had original `localScale = 0,0,0`, but the generic RectTransform loader converted zero scale to one. Those two nodes are now restored with original zero scale through an evidence CSV override.

The right cluster still looks visually incomplete/odd after that fix because the central world route card depends on active Spine/particle-style MonoBehaviour renderer hierarchies (`spine_diqiu`, `spine_xiaoren`, `Entry`, `un_MainInterface_fire`) that are not yet rendered by the current Image/TMP-oriented scene builder.

## Before Cause

After TMP variant font assets were restored, `모험`, `전/국`, and some right-side route elements still looked overlapped or floating. The first suspicion was that duplicate route cards or inactive runtime states might be alive.

Original hierarchy analysis disproved that:

| Parent | Sibling | Child | Original active | Current active | Original pos | Original size |
| --- | ---: | --- | --- | --- | --- | --- |
| `node_middle` | 0 | `wanfaWorldNode` | `True` | `True` | `-12.0,87.0` | `100.0x100.0` |
| `node_middle` | 1 | `UI_Main_wanfa_item_1` | `True` | `True` | `-246.0,192.0` | `100.0x100.0` |
| `node_middle` | 2 | `UI_Main_wanfa_item_2` | `True` | `True` | `18.0,192.0` | `100.0x100.0` |
| `node_middle` | 3 | `UI_Main_wanfa_item_3` | `True` | `True` | `-246.0,-14.0` | `100.0x100.0` |
| `node_middle` | 4 | `UI_Main_wanfa_item_4` | `True` | `True` | `18.0,-14.0` | `100.0x100.0` |

Also:

- Active override count under `node_middle`: `0`
- Active duplicate text groups under route cluster: `0`
- CanvasGroup evidence: no route cluster CanvasGroup override source was found in the extracted CSV.
- Raycast/click evidence: route buttons remain active and clickable; no route owner was disabled.

## Applied Fix

`Assets\RestoreData\maininterface_route_rect_overrides.csv` now supports localScale overrides in addition to size overrides. Two original zero-scale route `Entry` nodes are preserved:

| Owner | Node | Original localScale | Current localScale | Reason |
| --- | --- | --- | --- | --- |
| `UI_Main_wanfa_item_3` | `Entry` | `0.0,0.0,0.0` | `0.0,0.0,0.0` | Original route card `Entry` is a hidden runtime/effect state; builder zero-scale fallback was wrong. |
| `UI_Main_wanfa_item_4` | `Entry` | `0.0,0.0,0.0` | `0.0,0.0,0.0` | Same original state as item 3. |

Changed builder behavior:

- `MainInterfaceSceneBuilder.cs` loads `set_local_scale,local_scale_x,local_scale_y,local_scale_z`.
- `ApplyRectOverrides` applies `RectTransform.localScale` only when the CSV row explicitly requests it.
- Base RectTransform loading still keeps the previous zero-scale fallback, so this is a narrow route evidence override rather than a global behavior change.

Build log confirms:

- `Applied route rect overrides: 4/4`

## Remaining Renderer Gap

These active route/world descendants are present in original hierarchy but are not currently reconstructed as visible Unity UI graphics by the builder:

| Path area | Evidence | Script/component evidence | Impact |
| --- | --- | --- | --- |
| `wanfaWorldNode/worldwanfaBtn/spine_diqiu` | Active `True`, includes `Renderer0..Renderer14` children | Spine-like MonoBehaviour script ids `-6938409698251234290` and `-8877758280253173385`; renderer children use script id `5804373309048859138` | Missing world-card art behind/around `전/국`, so label composition looks floating. |
| `wanfaWorldNode/spine_xiaoren` | Active `True`, includes `Renderer0..Renderer14` children | Same Spine-like/renderer pattern | Missing animated character/decorator layer in the world route cluster. |
| `UI_Main_wanfa_item_* / Entry` | Active nodes with particle/effect style fields; item 3/4 are zero scale in original | script id `-7396295067816475631`, fields include particle/trail/scale-related keys | Correctly hidden where original scale is zero; future visible items need real particle/effect handling. |
| `UI_Main_wanfa_item_* / un_MainInterface_fire` | Effect hierarchy exists, often inactive or zero-scale in original branch | script id `-7396295067816475631` | Do not force-visible; restore only from active-chain and scale evidence. |

Conclusion: do not disable `UI_Main_wanfa_item_1..4` or `wanfaWorldNode` as a workaround. The next visual restoration step should export/probe the route Spine/effect assets and either render them with a supported runtime path or document faithful static placeholders from original atlas/material evidence.

## Verification

Unity batchmode build:

- Method: `GirlsWarRestore.MainInterfaceSceneBuilder.BuildMainInterfaceScene`
- Log: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_route_cluster_build.log`
- Result: success
- Route rect overrides: `4/4`

Graphics capture:

- Method: `GirlsWarRestore.MainInterfaceSceneBuilder.CaptureMainInterfaceScene`
- Capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`
- Visible pixels: `1201679`
- Image was opened and checked after build. The zero-scale fix is structurally correct, but the route cluster remains visually incomplete because the Spine/effect renderer layer is still missing.

Click validation:

- Method: `GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks`
- Total button loggers: `77`
- Active buttons: `24`
- Raycast-clickable active buttons: `24/24`
- Raycast-blocked active buttons: `0`
- Click logs invoked: `24`
- Report: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_CLICK_VALIDATION.md`

## Generated/Updated Evidence

- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_ROUTE_CLUSTER_HIERARCHY_ANALYSIS.md`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_ROUTE_CLUSTER_RESTORE_RESULT.md`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_cluster_hierarchy_analysis.json`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_cluster_nodes.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_cluster_components.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_cluster_duplicate_texts.csv`

## Tools

- Root shortcut: `C:\Users\godho\Downloads\girlswar\ANALYZE_MAININTERFACE_ROUTE_CLUSTER_HIERARCHY.cmd`
- Tool implementation: `C:\Users\godho\Downloads\girlswar\_restore_tools\98_ANALYZE_MAININTERFACE_ROUTE_CLUSTER_HIERARCHY.cmd`
- Analyzer script: `C:\Users\godho\Downloads\girlswar\_restore_tools\scripts\analyze_maininterface_route_cluster_hierarchy.py`

## Next Work

1. Trace/export route Spine/effect assets for `spine_diqiu`, `spine_xiaoren`, and visible route-card effect branches from original bundle evidence.
2. Add renderer support or documented static substitutes for those non-Image renderer layers.
3. Re-run build, capture, pixel/image inspection, and click validation while keeping `24/24`, `blocked 0`.
