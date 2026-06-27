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

## PlayMode Lineup Result

Cleanly rendered in the current BATTLE90 Play Mode lane:

- `1002` 차차: payload actor, exact SD bundle
- `1034` 비스마르크: payload actor, exact SD bundle
- `1025` 다테 마사무네: added visual-only SD proof actor
- `1050` 사카모토 료마: added visual-only SD proof actor
- `3001` 창병: enemy model from monster row `1100111`
- `3006`: enemy model fallback for `1100112/1100113` via base row `1100110`

Mapped but not currently safe for live visual lineup:

- `1036` 프리드리히: local skill/large art exists, but exact battle SD bundle is absent; currently visual-falls back to `1034`
- `1005` 링링: battle bundle exists, but current restored Play Mode material output is magenta/broken
- `1029` 사이토 기쵸: battle bundle exists, but current restored Play Mode material output is magenta/broken
- `1037` 제갈공명: battle bundle exists, but current restored Play Mode material output is magenta/broken

## Next Extraction/Restore Targets

1. Find or import exact `battleprefabandres/1036.assetbundle`.
2. Fix material/atlas binding for `1005`, `1029`, and `1037` before re-adding them to the visible lineup.
3. Use the `battleActorBundleExists=true` rows in `NAVER_LOUNGE_CHARACTER_MATCHES.csv` as the next source-backed roster expansion queue.
