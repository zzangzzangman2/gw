# MainInterface Coordinate System Rebase

- Generated: `2026-06-25 13:20:40`
- Rule file: `C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt`
- Root: `UI_MainInterface` / `5568884429252053541`
- Current capture: `Assets/RestoreCaptures/maininterface_restored_1680x720.png` `1680x720`
- Current visible pixels: `1203057`

## Direction Correction

- The earlier `1280x720` direction is marked as `failed_visual_shape_check`.
- The reason is not missing sprites alone. The prefab root is zero-sized in the asset and must be mounted under the runtime UI root before child anchors mean anything.
- `UI_bg` is `1680x720`, and root children use left/right/center anchors around that width.
- Lua clamps runtime logical width with `Screen.width * GameEntry.Instance.StandardHeight / Screen.height`, then `MinWidth` / `MaxWidth`.
- Therefore the current MainInterface coordinate basis is re-centered on `1680x720`.
- This does **not** mean the screen is complete. The hero character is still a runtime Spine/Live2D mount task, and some visible text/state is still default extracted data.

## Lua Screen-Fit Evidence

- `3038`: `local t=CS.UnityEngine.Screen.width*GameEntry.Instance.StandardHeight/CS.UnityEngine.Screen.height`
- `3039`: `if(t<GameEntry.Instance.MinWidth)then`
- `3040`: `t=GameEntry.Instance.MinWidth`
- `3041`: `elseif(t>GameEntry.Instance.MaxWidth)then`
- `3042`: `t=GameEntry.Instance.MaxWidth`
- `3043`: `end`
- `3044`: `local t=t`
- `3045`: `local a=ScreenDesignHeight`

## Root Children

| Name | Active | Anchor Min | Anchor Max | Anchored Pos | Size |
|---|---|---|---|---|---|
| `mask` | `True` | `0.0,0.5` | `1.0,0.5` | `0.0,0.0` | `0.0x100.0` |
| `UI_bg` | `True` | `0.5,0.5` | `0.5,0.5` | `0.0,0.0` | `1680.0x720.0` |
| `left` | `True` | `0.0,0.5` | `0.0,0.5` | `-125.0,0.0` | `0.0x0.0` |
| `autoHelper_Root` | `True` | `0.5,0.5` | `0.5,0.5` | `-20.0,142.0` | `100.0x100.0` |
| `guide_mask` | `False` | `0.5,0.5` | `0.5,0.5` | `0.0,0.0` | `1680.0x720.0` |
| `UI_heroSpine` | `True` | `0.0,0.0` | `1.0,1.0` | `0.0,0.0` | `0.0x0.0` |
| `warn_grid` | `False` | `0.5,0.5` | `0.5,0.5` | `-142.0,-159.0` | `0.0x0.0` |
| `p_changeBgHero` | `False` | `0.5,0.5` | `0.5,0.5` | `0.0,0.0` | `100.0x100.0` |
| `but_mask` | `False` | `0.0,0.0` | `1.0,1.0` | `0.0,0.0` | `2336.0x405.0` |
| `UI_touchSpine` | `True` | `0.5,0.5` | `0.5,0.5` | `-61.0,-28.0` | `650.0x400.0` |
| `btn_show` | `False` | `0.0,0.0` | `1.0,1.0` | `0.0,0.0` | `0.0x0.0` |
| `right` | `True` | `1.0,0.5` | `1.0,0.5` | `0.0,0.0` | `0.0x0.0` |
| `middle` | `True` | `0.5,0.5` | `0.5,0.5` | `0.0,0.0` | `0.0x0.0` |
| `bg_dibu` | `False` | `0.5,0.5` | `0.5,0.5` | `0.0,-360.0` | `2500.0x48.0` |

## Current Verification

| Check | Result |
|---|---:|
| Build RectTransforms | `806` |
| Applied sprites | `214` |
| Visual overrides | `1` |
| Capture size | `1680x720` |
| Active buttons | `24` |
| Raycast-clickable buttons | `24` |
| Blocked active buttons | `0` |
| Invoked click logs | `24` |

## Next Restore Work

1. Keep `1680x720` as the MainInterface coordinate candidate until `GameEntry.StandardWidth/Height/MinWidth/MaxWidth` serialized values are recovered.
2. Do not call the screen complete from visible pixel count or button logs.
3. Restore `UI_heroSpine` / `UI_touchSpine` through runtime Spine/Live2D evidence, not by placing `Painting_*.png` atlas textures as UI.
4. Replace default extracted text/state with config/runtime values only when source evidence is mapped.
5. Re-run graphical capture and click validation after each visual step.

## Outputs

- Root children CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_coordinate_root_children.csv`
- Summary JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_coordinate_system_summary.json`
- Markdown: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_COORDINATE_SYSTEM_REBASE.md`
