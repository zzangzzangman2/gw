# MainInterface Route Renderer Asset Trace
Generated: 2026-06-25 KST
## Verdict
`wanfaWorldNode`의 누락 비주얼은 원본 `SkeletonGraphic`/particle-style renderer 계층이다. `spine_diqiu`는 `maininterface_ext_8.assetbundle`의 `Spine_shijieanniu_SkeletonData`, `spine_xiaoren`은 `npcprefabandres/8007.assetbundle`의 `8007_SkeletonData`를 참조한다.
Fallback은 실제 Spine runtime 재생이 아니라 원본 atlas region을 개별 crop해 `worldwanfaBtn` 아래 비차단 child Image layer로 붙이는 복원이다. route owner active/sibling/anchor와 button raycast는 바꾸지 않는다.
## Skeleton References
| Node | SkeletonData ref | Bundle | Atlas/TextAsset | Texture | Animation | CanvasRenderers |
| --- | --- | --- | --- | --- | --- | ---: |
| `spine_diqiu` | file `59` path `1138517909137294754` | `download/ui/uiprefabandres/maininterface_ext_8.assetbundle` | `extracted/unity/bundles/b_35f69f1e4224c83e/textassets/4125696125331628132_Spine_shijieanniu.atlas.txt` | `extracted/unity/bundles/b_35f69f1e4224c83e/images/T/-1569618029946744867_Spine_shijieanniu.png` | `A` | `15` |
| `spine_xiaoren` | file `60` path `5595588015970333467` | `download/roleprefabsandres/npcprefabandres/8007.assetbundle` | `extracted/unity/bundles/b_df52239564024098/textassets/-5959284149285428779_8007.atlas.txt` | `extracted/unity/bundles/b_df52239564024098/images/T/1969165562093376026_8007.png` | `run` | `15` |

## Displayable Resources
- Displayable Texture2D resources traced: `2`
- `extracted/unity/bundles/b_35f69f1e4224c83e/images/T/-1569618029946744867_Spine_shijieanniu.png`
- `extracted/unity/bundles/b_df52239564024098/images/T/1969165562093376026_8007.png`

## Fallback
- Applied: `True`
- Applied layers:
  - `route_fallback_zhuye_di1` -> `Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_zhuye_di1.png`, size `253x253`, raycast `0`
  - `route_fallback_diqiu` -> `Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_diqiu.png`, size `253x253`, raycast `0`
  - `route_fallback_zhuye_bian` -> `Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_zhuye_bian.png`, size `238x238`, raycast `0`
- Cropped regions:
  - `zhuye_di1` bounds `[2, 2, 253, 253]` -> `Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_zhuye_di1.png`
  - `diqiu` bounds `[2, 257, 704, 706]` -> `Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_diqiu.png`
  - `zhuye_bian` bounds `[257, 17, 238, 238]` -> `Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_zhuye_bian.png`
  - `yun` bounds `[497, 152, 83, 36]` -> `Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_yun.png`
  - `yun2` bounds `[497, 190, 108, 65]` -> `Assets/RestoreData/route_renderer_fallbacks/Spine_shijieanniu_yun2.png`
- Note: cropped 5 Spine_shijieanniu regions from girlswar_merged_extracted\extracted\unity\bundles\b_35f69f1e4224c83e\images\T\-1569618029946744867_Spine_shijieanniu.png; applied evidence-safe worldwanfaBtn child layers: route_fallback_zhuye_di1, route_fallback_diqiu, route_fallback_zhuye_bian; yun/yun2 are cropped but not displayed because exact Spine slot transforms are not available
- Deferred display: `yun`, `yun2`, and `spine_xiaoren`/`8007` need original Spine bone/slot transforms before they can be placed without coordinate guessing.

## Particle / Effect Evidence
- Particle-style owner rows: `12`
- `un_MainInterface_fire` and `Entry` use script id `-7396295067816475631`; these are not forced visible without original active-chain and localScale evidence.

## Generated Files
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_renderer_asset_trace.json`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_renderer_asset_trace.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_renderer_resources.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_route_renderer_particles.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\route_renderer_fallbacks\Spine_shijieanniu_zhuye_di1.png`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\route_renderer_fallbacks\Spine_shijieanniu_diqiu.png`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\route_renderer_fallbacks\Spine_shijieanniu_zhuye_bian.png`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\route_renderer_fallbacks\Spine_shijieanniu_yun.png`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\route_renderer_fallbacks\Spine_shijieanniu_yun2.png`

## Latest Verification
- Capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png`
- Capture exists: `True`
- Click validation generated: `2026-06-25 17:23:16`
- Active buttons: `24`
- Raycast-clickable active buttons: `24/24`
- Raycast-blocked active buttons: `0`
- Click logs invoked: `24`
