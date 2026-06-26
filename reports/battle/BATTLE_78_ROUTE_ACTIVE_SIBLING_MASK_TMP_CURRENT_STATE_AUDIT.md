# BATTLE_78_ROUTE_ACTIVE_SIBLING_MASK_TMP_CURRENT_STATE_AUDIT

- status: `battle78_current_state_audited_playable_overlay_verified_runtime_gap_remaining`
- scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\Battle76PlayableRosterCandidate.unity`
- coordinateAspectVerified: `True` (`1920x855`, aspect `2.2456`)
- playableClickVerificationCarried: `True`
- rosterSiblingAndMaskVerified: `True`
- rosterCanvasSortingOrder: `5000`
- rosterScrollMaskPresent / hidden: `True / True`
- rectTransform active/inactive: `628 / 726`
- active zero lossy-scale rects: `3`
- active zero-size rects: `47`
- components canvas/raycaster/mask/rectMask/scroll/button: `19 / 10 / 1 / 0 / 1 / 29`
- text UGUI/TMP-like/bestFit/contentFit/aspectFit: `0 / 212 / 0 / 0 / 0`
- TMP text count/autosize/noWrap/ellipsisOrTruncate/raycastOff: `212 / 212 / 212 / 212 / 212`
- expected roster data rows for TMP layout: `204`
- rosterTmpAutosizeVerified: `True`
- originalRuntimeRouteStateStillRequiresSnapshot: `True`
- originalRuntimeTmpMaskStillRequiresSnapshot: `True`

## Notes
- The B76 playable overlay preserves B72 as the true-aspect coordinate basis and uses its own high sorting-order roster canvas.
- This verifies the local playable overlay route/sibling/mask state. It deliberately does not convert B73/B74 runtime-owned original UI_NormalBattle TMP/mask state into a false static claim.
