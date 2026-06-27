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
- `1005` 맹획: battle bundle exists, but current restored Play Mode material output is magenta/broken
- `1029` 사이고 다카모리: battle bundle exists, but current restored Play Mode material output is magenta/broken
- `1037` 제갈공명: battle bundle exists, but current restored Play Mode material output is magenta/broken

## Next Extraction/Restore Targets

1. Find or import exact `battleprefabandres/1036.assetbundle`.
2. Fix material/atlas binding for `1005`, `1029`, and `1037` before re-adding them to the visible lineup.
3. Re-add `1025` and `1050` only through a payload-backed roster test, not through the removed visual-only insertion path.
4. Use the `battleActorBundleExists=true` rows in `NAVER_LOUNGE_CHARACTER_MATCHES.csv` as the next source-backed roster expansion queue.
