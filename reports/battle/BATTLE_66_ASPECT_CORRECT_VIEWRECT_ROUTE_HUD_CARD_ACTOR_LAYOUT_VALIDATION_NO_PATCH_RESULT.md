# BATTLE_66_ASPECT_CORRECT_VIEWRECT_ROUTE_HUD_CARD_ACTOR_LAYOUT_VALIDATION_NO_PATCH Result

## Verdict
- `restoredClaim=false`, `playableClaim=false`.
- No scene, package, manifest, xLua, handler, HUD/card/actor/effect, or coordinate patch was applied.
- Reference aspect is `2.2456`; current candidate capture aspect is `1.777778`. Aspect mismatch is confirmed.
- For a 1920-wide comparison, the reference-aspect content rect is `x=0, y=112.5, w=1920, h=855`; this is analysis-only, not a patch.

## Layout Findings
- Route/HUD mismatch rows: `3`.
- Bottom card mismatch rows: `1`.
- Actor formation mismatch rows: `2`.
- TMP/mask rows reviewed: `81` (`TMP/Text=65`, `Mask=16`).
- BATTLE57 actor visibility remains source-backed for the local subset only; it is not full formation or final playability proof.
- Bottom card/card-icon state remains incomplete: active cards with sprites exist for the local subset, but the reference five-card assembly and 1036/full payload are not complete.

## Root Cause Separation
- `wrong_render_aspect_view_rect`: referenceAspect=2.2456; candidateCaptureAspect=1.777778; aspectDelta=0.467822
- `wrong_route_active_state_sibling_order`: routeRows=1046; activeRouteZeroScale=7; inactiveCritical=19
- `incomplete_card_icon_payload`: activeCardRows=3; activeCardsWithSprite=3; expected reference region is five cards
- `incomplete_actor_payload`: activeLoadableActorRows=3; actorRows=6; BATTLE_LOCAL_PLAYABLE_PAYLOAD remains local subset only
- `timeline_package_and_binding_blocker`: BATTLE64/65: Timeline package absent in project; local candidate requires approval; BATTLE63 TimelineAsset assignability mismatch
- `xlua_gameentry_handler_blocker`: BATTLE58/59: original xLua/GameEntry/LuaManager runtime unavailable; listener/lifecycle rows remain 0
- `tmp_mask_source_validation_pending`: TMP rows reviewed=65; mask rows reviewed=16; negativeSpacing=15; maskNameOnly=8

## Recommended Decision
- `safe_no_patch_report_only_then_aspect_correct_capture_validation`.
- Next blocker: `ASPECT_CORRECT_CAPTURE_VALIDATION_REQUIRED_BEFORE_ROUTE_HUD_CARD_ACTOR_LAYOUT_PATCH`.
- Timeline package import, xLua/GameEntry handler runtime, and full actor payload gaps remain separate blockers.

## Outputs
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_66_ASPECT_CORRECT_VIEWRECT_ROUTE_HUD_CARD_ACTOR_LAYOUT_VALIDATION_NO_PATCH_REFERENCE_VS_CURRENT_NORMALIZED_LAYOUT_CHECKPOINT_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_66_ASPECT_CORRECT_VIEWRECT_ROUTE_HUD_CARD_ACTOR_LAYOUT_VALIDATION_NO_PATCH_CAMERA_CANVAS_SCALER_RENDER_ASPECT_EVIDENCE_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_66_ASPECT_CORRECT_VIEWRECT_ROUTE_HUD_CARD_ACTOR_LAYOUT_VALIDATION_NO_PATCH_ROUTE_CARD_ACTOR_TMP_MASK_BLOCKER_SEPARATION_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_66_ASPECT_CORRECT_VIEWRECT_ROUTE_HUD_CARD_ACTOR_LAYOUT_VALIDATION_NO_PATCH_DECISION_AND_NEXT_ACTION_MATRIX.csv`
- `C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_66_ASPECT_CORRECT_VIEWRECT_ROUTE_HUD_CARD_ACTOR_LAYOUT_VALIDATION_NO_PATCH_RESULT.json`

## Command Policy
- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`
- policy ok: `True`
