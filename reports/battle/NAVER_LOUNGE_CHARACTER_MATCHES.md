# Naver Lounge Girl Art Character Matches

- source: `https://game.naver.com/lounge/girlwars/board/34?page=1&order=new`
- fetched: `2026-06-27T04:43:57Z`
- source rows: `reports/battle/NAVER_LOUNGE_GIRL_ART_BOARD34_TITLES.json`
- matched table: `reports/battle/NAVER_LOUNGE_CHARACTER_MATCHES.csv`
- matched JSON: `reports/battle/NAVER_LOUNGE_CHARACTER_MATCHES.json`

## Summary

- Public board-list rows matched to local DTLangBattle names: `114 / 114`
- Rows with local `battleprefabandres` actor bundles: `41`
- Rows with local name/head/art but no battle actor bundle: `73`
- Detail pages were lounge-gated in the browser, so this pass did not bypass the gate and used only public list titles plus local extracted data.
- Local art cache for manual visual reference: `work/naver_lounge_art_images/` (`114` JPG files, not committed as source data).

## BATTLE92 Current Verified Lineup

2026-06-27 update: BATTLE92 now uses a payload-backed standing snapshot roster, not visual-only injection. Field actors are SD/Spine only; large art remains HUD/cutin material and is not placed on the battlefield.

Active BATTLE92 payload roster:

- `1025` 다테 마사무네: Naver rows `6968110`, `4527904`, `2274359`; local battle bundle/head/art/skill all present.
- `1050` 사카모토 료마: Naver row `2292045`; local battle bundle/head/art/skill all present.
- `1029` 사이토 기쵸: Naver rows `5765288`, `2274393`; local battle bundle/head/art/skill all present.
- `1034` 비스마르크: Naver row `2024959`; local battle bundle/head/art/skill all present.
- `1002` 차차: Naver row `2024949`; local battle bundle/head/art/skill all present.

Enemy actors in the same BATTLE92 capture:

- `1100111 -> 3001`: exact monster model row.
- `1100112 -> 3006`, `1100113 -> 3006`: base monster row fallback through `1100110`.

BATTLE92 proof:

- payload: `girlswar_battle_unity/Assets/RestoreData/battle/BATTLE_TEST_PAYLOAD_ROSTER_EXPANSION.json`
- result: `reports/battle/BATTLE_92_ROSTER_EXPANSION_PLAYMODE_RESULT.json`
- capture: `reports/battle/BATTLE_92_ROSTER_EXPANSION_PLAYMODE_CAPTURE.png`
- latest result summary: `status=playmode_bootstrap_entered_battle`, `runtimeActorSpineCount=8`, `runtimeActorMissingAssetCount=0`, `runtimePreviewActionCount=0`, `runtimeUltimateCutinOverlayShownCount=0`, `visualHudDamageTextCount=0`, `visualActorMaxOverlapRatio=0.098122254`

Matched but not kept in the current BATTLE92 readability lineup:

- `1005` 링링: battle bundle exists and BATTLE91 material probe renders it, but current field readability is better with `1002`.
- `1037` 제갈공명: battle bundle exists and BATTLE91 material probe renders it, but this actor reads too small in the current battle composition.

## Current PlayMode Lineup Result

The active BATTLE90 Play Mode lane is now the test payload 3v3 only. No Naver-matched visual-only extras are injected.

Clean/current actors:

- `1002` 초선: payload actor, exact SD bundle
- `1034` 비스마르크: payload actor, exact SD bundle
- `3001` 장비: enemy model for monster row `1100111`
- `3006`: enemy model for `1100112/1100113` through base monster row `1100110`

Current missing actor:

- `1036` 프리드리히: local skill/large art exists and `DTHero`/`DTmodel` point to model/prefab `1036`, but exact local battle SD bundle is absent. It is now counted as missing and is not visually faked with `1034`.

Matched but not currently active in the live lineup:

- `1025` 다테 마사무네: local battle bundle/head/art exist; removed from active lineup because U0-B requires payload 3v3 only
- `1050` 사카모토 료마: local battle bundle/head/art exist; removed from active lineup because U0-B requires payload 3v3 only
- `1005` 맹획: battle bundle exists; BATTLE91 material probe renders it with `Spine/Skeleton` and `errorShaderMaterialCount=0`
- `1029` 사이고 다카모리: battle bundle exists; BATTLE91 material probe renders it with `Spine/Skeleton` and `errorShaderMaterialCount=0`
- `1037` 제갈공명: battle bundle exists; BATTLE91 material probe renders it with `Spine/Skeleton`, `errorShaderMaterialCount=0`, and normalized height `1.38`

2026-06-27 update: these material/scale fixes are proven by `reports/battle/BATTLE_91_ROSTER_EXPANSION_MATERIAL_PROBE_RESULT.json`. They are still not active in the live 3v3 replay and must be added only through a payload-backed roster expansion test.

## Next Extraction/Restore Targets

1. Find or import exact `battleprefabandres/1036.assetbundle`.
2. Re-add `1025`, `1050`, `1005`, `1029`, and `1037` only through a payload-backed roster test, not through the removed visual-only insertion path.
3. Use the `battleActorBundleExists=true` rows in `NAVER_LOUNGE_CHARACTER_MATCHES.csv` as the next source-backed roster expansion queue.
4. Keep BATTLE91 (`reports/battle/BATTLE_91_ROSTER_EXPANSION_MATERIAL_PROBE_RESULT.json`) as the material/scale gate for candidate actors before they enter a live replay payload.
