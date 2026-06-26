# MainInterface 150 Promoted Home State Audit

- Status: `maininterface150_promoted_home_state_verified`
- Root cause: Default MainInterface root and old-root runtime activity placeholders were being promoted without the original runtime activity payload. The production builder now uses the old home root, attaches BG1005/Hero1005, and hides the unpopulated old-root node_act_btn grid.
- Promoted home runtime state applied: `True`
- BG1005 verified: `True`
- Hero1005 SkeletonGraphic verified: `True` (`Painting_1005_SkeletonData`, anim `A`)
- Runtime activity placeholder grid hidden: `True`
- Numbered activity slots active in hierarchy: `0/19`
- Sibling order BG < Hero < Right: `True`
- Canvas/input verified: `True`
- Coordinate raycast probes verified: `True`
- Capture verified: `True` (`1680x720`, visible pixels `1202887`)

## TMP / Mask

- TMP active/total: `21/45`, autosize `0`, wrapping `45`
- UGUI Text active/total: `5/35`
- Mask active/total: `0/0`, hidden mask graphic `0`, RectMask2D active/total `2/2`

## Raycast Probes

| key | button | screen | top hit | top within | contains | target graphic |
|---|---|---:|---|---:|---:|---:|
| mail | btn_youjian__-1189460423525129158 | 1368.4,522.9 | btn_youjian__-1189460423525129158 | True | True | True |
| friend | btn_haoyou__-675339169157432991 | 1409.4,522.9 | btn_haoyou__-675339169157432991 | True | True | True |
| shop | btn_shangdian__-2638148383004042968 | 1327.8,522.9 | btn_shangdian__-2638148383004042968 | True | True | True |
