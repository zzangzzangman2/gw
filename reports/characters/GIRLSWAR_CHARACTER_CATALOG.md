# GirlsWar Character Catalog

Original-table and extracted-asset backed catalog for character/battle UI consumers.

## Summary
- Character rows: `131`
- Korean names resolved: `130`
- Head sprites resolved: `130`
- Existing battle actor bundles: `38`
- Existing battle skeleton TextAssets: `38`
- Battle UI card rows: `3`

## Data Products
- Full catalog JSON: `reports/characters/GIRLSWAR_CHARACTER_CATALOG.json`
- Full catalog CSV: `reports/characters/GIRLSWAR_CHARACTER_CATALOG.csv`
- Battle UI JSON: `reports/characters/GIRLSWAR_CHARACTER_BATTLE_UI_LIST.json`
- Battle UI CSV: `reports/characters/GIRLSWAR_CHARACTER_BATTLE_UI_LIST.csv`
- Unity battle copy: `girlswar_battle_unity/Assets/RestoreData/battle/GIRLSWAR_CHARACTER_BATTLE_UI_LIST.json`
- Unity maininterface copy: `girlswar_maininterface_unity/Assets/RestoreData/GIRLSWAR_CHARACTER_CATALOG.json`

## Field Notes
- `level` is intentionally blank in the static catalog because no per-character runtime level exists in `DTHeroEntity`; battle UI rows use payload `lockLevel` and keep `rankLevel` separately.
- `roleKo` is the localized `DTHero.location` text, paired with raw `profession`/`expert` numbers instead of guessed role names.
- Asset paths are extracted-index outputs relative to `girlswar_merged_extracted`, with absolute head PNG paths included only for Unity runtime image loading.

## Battle UI Cards
| slot | heroDid | name | rarity | level | role | head | actor bundle |
| ---: | ---: | --- | ---: | ---: | --- | --- | --- |
| 1 | 1036 | 프리드리히 | 5 | 1 | 로마의 황제・ 전군 돌격 | `head1036` | `download/roleprefabsandres/battleprefabandres/1036.assetbundle` |
| 2 | 1002 | 차차 | 4 | 1 | 전체 치유・ 방어 금지 | `head1002` | `download/roleprefabsandres/battleprefabandres/1002.assetbundle` |
| 3 | 1034 | 비스마르크 | 5 | 1 | 스플래시 피해・ 철혈 재상 | `head1034` | `download/roleprefabsandres/battleprefabandres/1034.assetbundle` |
