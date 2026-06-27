# BATTLE92 Roster Expansion PlayMode

- date: `2026-06-27`
- purpose: restore several Naver Lounge matched characters into the battle field as SD/Spine actors, alongside enemies, without placing large illustration art on the field.
- payload: `girlswar_battle_unity/Assets/RestoreData/battle/BATTLE_TEST_PAYLOAD_ROSTER_EXPANSION.json`
- result: `reports/battle/BATTLE_92_ROSTER_EXPANSION_PLAYMODE_RESULT.json`
- capture: `reports/battle/BATTLE_92_ROSTER_EXPANSION_PLAYMODE_CAPTURE.png`

## Active Roster

| heroDid | character | Naver detail rows | local proof |
| --- | --- | --- | --- |
| 1025 | 다테 마사무네 | 6968110, 4527904, 2274359 | battle bundle, head, art, skill |
| 1050 | 사카모토 료마 | 2292045 | battle bundle, head, art, skill |
| 1029 | 사이토 기쵸 | 5765288, 2274393 | battle bundle, head, art, skill |
| 1034 | 비스마르크 | 2024959 | battle bundle, head, art, skill |
| 1002 | 차차 | 2024949 | battle bundle, head, art, skill |

Enemies:

| monsterDid | resolved actor | note |
| --- | --- | --- |
| 1100111 | 3001 | exact monster model row |
| 1100112 | 3006 | base fallback through 1100110 |
| 1100113 | 3006 | base fallback through 1100110 |

## Latest Verification

- `status=playmode_bootstrap_entered_battle`
- `battleEntered=true`
- `runtimeActorAttachCount=8`
- `runtimeActorSpineCount=8`
- `runtimeActorMissingAssetCount=0`
- `runtimePreviewActionCount=0`
- `runtimeUltimateCutinOverlayShownCount=0`
- `visualHudDamageTextCount=0`
- `visualActorMaxOverlapRatio=0.098122254`
- `errorLogCount=0`

## Notes

- BATTLE92 uses `standingSnapshotOnly=true`; it suppresses attack previews, damage text, and ultimate cutins so the capture verifies field readability.
- Large Naver art is used for matching/HUD references only. It is not placed as a battlefield actor.
- `1005` 링링 and `1037` 제갈공명 remain matched candidates, but they are not in the current BATTLE92 readability lineup.
