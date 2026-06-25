# MainInterface Route Renderer Fallback Result

Generated: 2026-06-25 KST

## Summary

MainInterface 오른쪽 route cluster의 `wanfaWorldNode`는 원본에서 active 유지가 맞다. 이번 작업은 owner/parent/sibling/active state를 바꾸지 않고, 원본 `worldwanfaBtn` 아래 누락된 `spine_diqiu` SkeletonGraphic 비주얼을 atlas region 단위 fallback layer로 보강했다.

기존 단일 `diqiu` fallback은 큰 globe bitmap 하나만 `worldwanfaBtn`에 직접 붙이는 형태라 화면상 경계/베이스가 부족했다. 현재 fallback은 `Spine_shijieanniu.atlas`에서 개별 region을 crop하고, evidence가 있는 layer만 `worldwanfaBtn` 자식 Image로 생성한다. 생성한 Image는 모두 `raycast_target=0`이다.

## Evidence Basis

| Evidence | Value |
| --- | --- |
| Parent GameObject | `worldwanfaBtn` / gameObject `2331390164297400090` |
| Parent hierarchy | `UI_MainInterface/right/node_middle/wanfaWorldNode/worldwanfaBtn` |
| Parent RectTransform | anchored `-101,1`, size `253x253`, sibling `0` |
| Active renderer child | `spine_diqiu` under `worldwanfaBtn`, active, `SkeletonGraphic` |
| SkeletonData | file `59`, path `1138517909137294754`, `Spine_shijieanniu_SkeletonData` |
| Bundle | `download/ui/uiprefabandres/maininterface_ext_8.assetbundle` |
| Atlas | `girlswar_merged_extracted\extracted\unity\bundles\b_35f69f1e4224c83e\textassets\4125696125331628132_Spine_shijieanniu.atlas.txt` |
| Texture | `girlswar_merged_extracted\extracted\unity\bundles\b_35f69f1e4224c83e\images\T\-1569618029946744867_Spine_shijieanniu.png` |

## Applied Regions

| Region | Atlas bounds | Scene fallback | Size | Reason |
| --- | ---: | --- | ---: | --- |
| `zhuye_di1` | `[2,2,253,253]` | `route_fallback_zhuye_di1` | `253x253` | Region size exactly matches original `worldwanfaBtn` rect, so it is a safe base layer. |
| `diqiu` | `[2,257,704,706]` | `route_fallback_diqiu` | `253x253` | Active `spine_diqiu` attachment source. Scaled into the parent rect as a runtime-Spine fallback. |
| `zhuye_bian` | `[257,17,238,238]` | `route_fallback_zhuye_bian` | `238x238` | Same skeleton's border/rim region; centered under parent and kept behind route text siblings. |

Applied CSV:

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_visual_overrides.csv`

Generated crop assets:

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\route_renderer_fallbacks\Spine_shijieanniu_zhuye_di1.png`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\route_renderer_fallbacks\Spine_shijieanniu_diqiu.png`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\route_renderer_fallbacks\Spine_shijieanniu_zhuye_bian.png`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\route_renderer_fallbacks\Spine_shijieanniu_yun.png`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\route_renderer_fallbacks\Spine_shijieanniu_yun2.png`

## Deferred Regions / Renderers

| Item | Status | Reason |
| --- | --- | --- |
| `yun` | cropped only | Atlas bounds are known, but exact Spine bone/slot transform is not available from current binary `.skel` evidence. |
| `yun2` | cropped only | Same as `yun`; placing it manually would be coordinate guessing. |
| `spine_xiaoren` / `8007` | not applied | Texture and SkeletonData are traced, but the character pose depends on Spine slot/bone transforms and animation `run`. A full texture overlay would be wrong. |
| `un_MainInterface_fire` / route particle-style renderers | not applied | Renderer/MonoBehaviour evidence exists, but no safe material/particle runtime reconstruction path has been proven yet. |

## Verification

| Step | Result |
| --- | --- |
| Scene build | Success, `Applied visual overrides: 4/4` |
| Graphics capture | Success, visiblePixels `1201679` |
| Capture path | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png` |
| Click validation | active `24`, raycast-clickable `24/24`, blocked `0`, invoked `24` |

Logs:

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_route_renderer_fallback_build.log`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_route_renderer_fallback_capture.log`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_route_renderer_fallback_click_validation.log`

Related trace:

- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_ROUTE_RENDERER_ASSET_TRACE.md`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_renderer_asset_trace.json`
