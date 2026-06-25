# MainInterface Visual Gap Analysis

- Generated: `2026-06-25 13:07:06`
- Default hero candidate: `1001` from `DTHeroInitialEntityTableData.bigd`
- Root `UI_bg` component: `6259596902678607660`
- Root `UI_bg` prefab sprite: `noalphabg_BG_changjing_2` alpha `0.0`
- Runtime background source: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\bundles\b_4b5f2d65cb02985b\images\T\5510351950449616726_noalphabg_PaintingBG_1001.png`
- Runtime background Unity asset: `Assets/RestoredSprites/maininterface/runtime_dynamic/runtime_UI_bg_noalphabg_PaintingBG_1001.png`
- Visual overrides written: `1`

## Finding

- The current black capture is not caused by a missing full-screen RectTransform. The root `UI_bg` exists under the active MainInterface root, but its prefab Image alpha is `0.0`.
- `UI_MainPage` runtime logic loads the visible background with `UIUtil.GetPaintingBg(heroId)` and `GameTools:LoadSpriteWithFullPath(UI_bg, e, true)`.
- Character display is runtime Spine/Live2D loading, not a normal Image sprite. `Painting_*.png` files are atlas textures and must not be used as final UI pieces by themselves.
- The safe immediate visual restore is to apply only the runtime background texture to the existing `UI_bg` Image, leaving character/Spine as a separate renderer task.

## Lua Evidence

- `GetPaintingBg`: `1`
- `GetPlayerBigSpineAll`: `1`
- `GetPlayerUnderwearSpine`: `1`
- `UI_bg`: `2`
- `UI_heroSpine`: `10`
- `UI_touchSpine`: `5`
- `mainShowHeroList`: `21`
- `p_changeBgHero`: `3`
- `showHeroIndex`: `3`

## Output Files

- Evidence CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_visual_gap_evidence.csv`
- Summary JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_visual_gap_summary.json`
- Visual override CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_visual_overrides.csv`
- Markdown: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_VISUAL_GAP_ANALYSIS.md`
