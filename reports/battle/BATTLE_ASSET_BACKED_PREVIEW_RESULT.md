# Battle Asset-Backed Preview Result

## Outputs
- Scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\BattleAssetBackedPreview.unity`
- Visual manifest: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\RestoreData\battle\BATTLE_ASSET_BACKED_PREVIEW_VISUALS.json`
- Unity log: `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_09_UNITY_ASSET_BACKED_PREVIEW.log`
- Unity batchmode success: `True`

## Counts
- Visual assets copied: `12`
- Map layers: `3`
- Actor texture fallbacks: `3`
- Missing placeholders: `9`
- Scene pattern counts: `{'TextureActor': 3, 'MissingActor': 9, 'MapLayer': 3}`

## Map Layers
| name | type | size | unity asset |
| --- | --- | --- | --- |
| Map_11001_2 | Sprite | 1920x669 | Assets/RestoreData/battle/VisualAssets/map/Map_11001_2.png |
| Map_11001_3 | Sprite | 1920x304 | Assets/RestoreData/battle/VisualAssets/map/Map_11001_3.png |
| sactx-0-2048x2048-ETC2-Map_11001_1-2ccb5b85 | Texture2D | 2048x2048 | Assets/RestoreData/battle/VisualAssets/map/sactx-0-2048x2048-ETC2-Map_11001_1-2ccb5b85.png |

## Actor Visuals
| side | heroDid | visual | texture | missing reason |
| --- | --- | --- | --- | --- |
| our | 1036 | placeholder_missing |  | listed_in_cdn_versionfile_not_extracted |
| our | 1002 | texture_billboard | Assets/RestoreData/battle/VisualAssets/actors/1002/1002_texture.png | loadable_spine_bundle |
| our | 1034 | texture_billboard | Assets/RestoreData/battle/VisualAssets/actors/1034/1034_texture.png | loadable_spine_bundle |
| enemy | 1100111 | texture_billboard | Assets/RestoreData/battle/VisualAssets/actors/1100111/1100111_texture.png | loadable_spine_bundle |
| enemy | 1100112 | placeholder_missing |  | not_loadable_yet |
| enemy | 1100113 | placeholder_missing |  | not_loadable_yet |
| enemy | 1100121 | placeholder_missing |  | not_loadable_yet |
| enemy | 1100122 | placeholder_missing |  | not_loadable_yet |
| enemy | 1100123 | placeholder_missing |  | not_loadable_yet |
| enemy | 1100131 | placeholder_missing |  | not_loadable_yet |
| enemy | 1100132 | placeholder_missing |  | not_loadable_yet |
| enemy | 1100133 | placeholder_missing |  | not_loadable_yet |

## Next Step
- AssetBundle streaming is faster next than full Spine runtime import: texture/evidence paths are already staged, while Spine runtime needs package/API compatibility work.
