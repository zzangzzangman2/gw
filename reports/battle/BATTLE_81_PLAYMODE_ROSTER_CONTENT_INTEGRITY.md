# BATTLE_81_PLAYMODE_ROSTER_CONTENT_INTEGRITY

- status: `battle81_playmode_roster_content_integrity_verified`
- scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\Battle76PlayableRosterCandidate.unity`
- expected actor/skill/character/total rows: `12 / 61 / 131 / 204`
- present actor/skill/character/content children: `12 / 61 / 131 / 204`
- text matched actor/skill/character: `12 / 61 / 131`
- catalog controller rows/name/head/battleBundle: `131 / 130 / 130 / 38`
- content height actual/expected: `5536.0 / 5536.0`
- viewport mask present/hidden: `True / True`
- roster UGUI text count/bestFit/wrap/truncate: `0 / 0 / 0 / 0`
- roster TMP text count/autosize/noWrap/ellipsisOrTruncate/raycastOff: `212 / 212 / 212 / 212 / 212`
- rowCountVerified: `True`
- rowTextVerified: `True`
- scrollLayoutVerified: `True`
- tmpTextLayoutVerified: `True`
- uguiTextLayoutFallbackVerified: `False`
- textLayoutVerified: `True`

## Notes
- This enters PlayMode and verifies every actor/skill payload row plus every full character catalog row label in the generated roster UI against the source CSV rows.
- It also checks scroll content height, mask presence, and TMP autosize/no-wrap/overflow/raycast state, with a UGUI fallback for older generated scenes.
