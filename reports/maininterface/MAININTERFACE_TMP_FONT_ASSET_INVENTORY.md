# MainInterface TMP Font Asset Inventory

Generated: 2026-06-25 14:53:19

## Verdict

원본 TMP 폰트 에셋은 `download/ui/uifont/japanese/tmp` 번들 안에 실제로 존재한다. 따라서 MainInterface TMP-like 텍스트는 OS 폰트 fallback이 아니라 이 TMP FontAsset/Material/Texture 근거를 사용해 복원해야 한다.

## Counts

| item | value |
| --- | ---: |
| target font/shader bundles | 105 |
| TMP FontAsset structured rows | 54 |
| source Font objects in type counts | 8 |
| source Font structured rows | 0 |
| Material objects in type counts | 107 |
| Material structured rows | 0 |
| Texture2D objects in type counts | 81 |
| Texture2D structured rows | 0 |
| extracted PNG atlas/images | 73 |

## Extraction Gap

`type_counts.json` 기준으로 Font/Material/Texture2D 오브젝트는 존재하지만, 현재 `structure.jsonl.gz`에는 여러 폰트 번들의 Material/Texture 트리가 직렬화되어 있지 않다. 따라서 지금 단계에서는 TMP FontAsset의 glyph/metric/pathID와 추출 PNG atlas를 우선 근거로 쓰고, face/outline/shader property까지 필요하면 해당 uifont 번들을 Material/Texture 포함 모드로 재추출해야 한다.

## Bundle Classes

| class | count |
| --- | ---: |
| `font_material_preset` | 44 |
| `font_view_prefabs` | 2 |
| `source_font` | 4 |
| `tmp_font_asset` | 54 |
| `tmp_shaders` | 1 |

## Font Families

- `Arial Unicode MS`
- `DFMincho-SU`
- `DFPMincho-SU`
- `EPSON ?????S?V?b?N???a`
- `Impact`
- `KswKashin`
- `tway_sky`

## Atlas/Image Samples

| bundle | class | images | samples |
| --- | --- | ---: | --- |
| `download/ui/uifont/japanese/tmp/arial_wuxiaowu_dongtai.assetbundle` | `tmp_font_asset` | 4 | `images/T/-3883399435984298098_Arial_wuxiaowu_dongtai Atlas 3.png;images/T/1418836957207565824_Arial_wuxiaowu_dongtai Atlas 2.png;images/T/7346320041131784492_Arial_wuxiaowu_dongtai Atlas.png;images/T/8618507576646218733_Arial_wuxiaowu_dongtai Atlas 1.png` |
| `download/ui/uifont/japanese/tmp/epm.assetbundle` | `tmp_font_asset` | 1 | `images/T/5218067429375919017_EPM Atlas.png` |
| `download/ui/uifont/japanese/tmp/epm_bai_0.2_0.2.assetbundle` | `tmp_font_asset` | 1 | `images/T/-5547209632630771065_EPMGOBLD Atlas.png` |
| `download/ui/uifont/japanese/tmp/epm_bai_0.2_0.3.assetbundle` | `tmp_font_asset` | 2 | `images/T/3495044873600770675_EPMGOBLD Atlas 1.png;images/T/644230123919312507_EPMGOBLD Atlas.png` |
| `download/ui/uifont/japanese/tmp/epm_cheng_242_180_66.assetbundle` | `tmp_font_asset` | 1 | `images/T/-798840362229915418_EPMGOBLD Atlas.png` |
| `download/ui/uifont/japanese/tmp/epm_green_0.3_0.3.assetbundle` | `tmp_font_asset` | 1 | `images/T/-6987646035453437838_EPMGOBLD Atlas.png` |
| `download/ui/uifont/japanese/tmp/epm_hei_0.1_0.1.assetbundle` | `tmp_font_asset` | 4 | `images/T/-1995082518310267364_EPM Atlas 1.png;images/T/-3707492129657301745_EPM Atlas 2.png;images/T/-4505259139606566112_EPM Atlas 1.png;images/T/-7208747833858188485_EPM Atlas.png` |
| `download/ui/uifont/japanese/tmp/epm_hei_0.2_0.2.assetbundle` | `tmp_font_asset` | 1 | `images/T/-8889342051264772458_EPM Atlas.png` |
| `download/ui/uifont/japanese/tmp/epm_hong_0.3__0.3.assetbundle` | `tmp_font_asset` | 5 | `images/T/-1225124178154213929_EPMGOBLD Atlas 1.png;images/T/-6043900160149296681_EPMGOBLD Atlas 1.png;images/T/-6331989619101692129_EPMGOBLD Atlas.png;images/T/1224360952739250401_EPMGOBLD Atlas 3.png;images/T/4953380478263929470_EPMGOBLD Atlas 2.png` |
| `download/ui/uifont/japanese/tmp/epm_hui_0.2_0.2.assetbundle` | `tmp_font_asset` | 3 | `images/T/2055889654376476100_EPM Atlas.png;images/T/2239213950612371125_EPM Atlas 1.png;images/T/2452541240205506080_EPM Atlas 1.png` |
| `download/ui/uifont/japanese/tmp/epm_lan_53_135_220_0.2_0.2.assetbundle` | `tmp_font_asset` | 1 | `images/T/-4683204463025725205_EPM Atlas.png` |
| `download/ui/uifont/japanese/tmp/epm_lu_65_105_36_0.4_0.4.assetbundle` | `tmp_font_asset` | 1 | `images/T/1846144271120189792_EPM Atlas.png` |
| `download/ui/uifont/japanese/tmp/epm_shenzong_0.2_0.2.assetbundle` | `tmp_font_asset` | 1 | `images/T/6551403151277096646_EPM Atlas.png` |
| `download/ui/uifont/japanese/tmp/epm_wuxiaoguo_dongtai.assetbundle` | `tmp_font_asset` | 1 | `images/T/-3130024980044596905_EPM Atlas.png` |
| `download/ui/uifont/japanese/tmp/epm_zi_179_113_213_0.2_0.2.assetbundle` | `tmp_font_asset` | 1 | `images/T/8722480494409350947_EPM Atlas.png` |
| `download/ui/uifont/japanese/tmp/epm_zong.assetbundle` | `tmp_font_asset` | 1 | `images/T/-1357322107979240204_EPMGOBLD Atlas.png` |
| `download/ui/uifont/japanese/tmp/ksw.assetbundle` | `tmp_font_asset` | 1 | `images/T/1140217454483376603_Ksw Atlas.png` |
| `download/ui/uifont/japanese/tmp/ksw_bai_0.2_0.2.assetbundle` | `tmp_font_asset` | 1 | `images/T/-404422236397469705_Ksw Atlas.png` |
| `download/ui/uifont/japanese/tmp/ksw_fen_245_105_120_0.4_0.4.assetbundle` | `tmp_font_asset` | 1 | `images/T/-3912906508495224436_Ksw Atlas.png` |
| `download/ui/uifont/japanese/tmp/ksw_hei_0.2_0.2 1.assetbundle` | `tmp_font_asset` | 2 | `images/T/-6659528504576205313_Ksw Atlas 1.png;images/T/2369568226278569391_Ksw Atlas.png` |

## First TMP Font Assets

| bundle | name | family | style | atlas | glyphs | material pathID |
| --- | --- | --- | --- | --- | ---: | --- |
| `download/ui/uifont/japanese/tmp/arial_wuxiaowu_dongtai.assetbundle` | `Arial_wuxiaowu_dongtai` | `Arial Unicode MS` | `Regular` | `2048x1024` | 0 | `-6359624834505761383` |
| `download/ui/uifont/japanese/tmp/epm.assetbundle` | `EPM` | `EPSON ?????S?V?b?N???a` | `Regular` | `1024x2048` | 442 | `-161800820888374377` |
| `download/ui/uifont/japanese/tmp/epm_bai_0.2_0.2.assetbundle` | `EPM_bai_0.2_0.2` | `EPSON ?????S?V?b?N???a` | `Regular` | `2048x2048` | 588 | `4197552658687390998` |
| `download/ui/uifont/japanese/tmp/epm_bai_0.2_0.3.assetbundle` | `EPM_bai_0.2_0.3` | `EPSON ?????S?V?b?N???a` | `Regular` | `2048x2048` | 1421 | `8277179812870395897` |
| `download/ui/uifont/japanese/tmp/epm_cheng_242_180_66.assetbundle` | `EPM_cheng_242_180_66` | `EPSON ?????S?V?b?N???a` | `Regular` | `512x256` | 39 | `272450964545638752` |
| `download/ui/uifont/japanese/tmp/epm_green_0.3_0.3.assetbundle` | `EPM_green_0.3_0.3` | `EPSON ?????S?V?b?N???a` | `Regular` | `256x128` | 4 | `-8232031347988745852` |
| `download/ui/uifont/japanese/tmp/epm_hei_0.1_0.1.assetbundle` | `EPM_hei_0.1_0.1` | `EPSON ?????S?V?b?N???a` | `Regular` | `512x512` | 150 | `-5609114805978036083` |
| `download/ui/uifont/japanese/tmp/epm_hei_0.2_0.2.assetbundle` | `EPM_hei_0.2_0.2` | `EPSON ?????S?V?b?N???a` | `Regular` | `1024x512` | 155 | `813917202350245246` |
| `download/ui/uifont/japanese/tmp/epm_hong_0.3__0.3.assetbundle` | `EPM_hong_0.3__0.3` | `EPSON ?????S?V?b?N???a` | `Regular` | `256x128` | 29 | `3600456906408240635` |
| `download/ui/uifont/japanese/tmp/epm_hui_0.2_0.2.assetbundle` | `EPM_hui_0.2_0.2` | `EPSON ?????S?V?b?N???a` | `Regular` | `256x256` | 26 | `-8577203961182755366` |
| `download/ui/uifont/japanese/tmp/epm_lan_53_135_220_0.2_0.2.assetbundle` | `EPM_lan_53_135_220_0.2_0.2` | `EPSON ?????S?V?b?N???a` | `Regular` | `512x512` | 37 | `-1928148216991472211` |
| `download/ui/uifont/japanese/tmp/epm_lu_65_105_36_0.4_0.4.assetbundle` | `EPM_lu_65_105_36_0.4_0.4` | `EPSON ?????S?V?b?N???a` | `Regular` | `512x512` | 31 | `9184855946227235704` |
| `download/ui/uifont/japanese/tmp/epm_shenzong_0.2_0.2.assetbundle` | `EPM_shenzong_0.2_0.2` | `EPSON ?????S?V?b?N???a` | `Regular` | `1024x2048` | 191 | `3429674815646708715` |
| `download/ui/uifont/japanese/tmp/epm_wuxiaoguo_dongtai.assetbundle` | `EPM_wuxiaoguo_dongtai` | `EPSON ?????S?V?b?N???a` | `Regular` | `2048x1024` | 570 | `2055463726379497` |
| `download/ui/uifont/japanese/tmp/epm_zi_179_113_213_0.2_0.2.assetbundle` | `EPM_zi_179_113_213_0.2_0.2` | `EPSON ?????S?V?b?N???a` | `Regular` | `256x128` | 7 | `6984675777544903538` |
| `download/ui/uifont/japanese/tmp/epm_zong.assetbundle` | `EPM_zong` | `EPSON ?????S?V?b?N???a` | `Regular` | `256x256` | 6 | `-8687465925557858833` |
| `download/ui/uifont/japanese/tmp/ksw.assetbundle` | `Ksw` | `KswKashin` | `Regular` | `512x512` | 44 | `-8038778510421082569` |
| `download/ui/uifont/japanese/tmp/ksw_bai_0.2_0.2.assetbundle` | `Ksw_bai_0.2_0.2` | `KswKashin` | `Regular` | `512x512` | 47 | `-153377978356682218` |
| `download/ui/uifont/japanese/tmp/ksw_fen_245_105_120_0.4_0.4.assetbundle` | `Ksw_fen_245_105_120_0.4_0.4` | `KswKashin` | `Regular` | `256x256` | 6 | `141970416624356120` |
| `download/ui/uifont/japanese/tmp/ksw_hei_0.2_0.2 1.assetbundle` | `Ksw_hei_0.2_0.2 1` | `KswKashin` | `Regular` | `512x512` | 108 | `-6221867217541333873` |

## Restore Direction

1. Use Unity 6000 `com.unity.ugui` 2.0 TMP support; `TextMeshProUGUI` compile/create is validated by the isolated probe.
2. Convert TMP-like text rows to `TextMeshProUGUI`, preserving TMP serialized fields from source components.
3. Use `tmp/*.assetbundle` TMP FontAsset rows and their material/texture refs as the source of font family, atlas size, glyph metrics, and material presets.
4. Keep UGUI `m_FontData` rows on the old `UnityEngine.UI.Text` path.
5. Re-run graphics capture only after TMP and right route visibility state are restored.

## Generated Files

- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_font_assets_summary.json`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_font_bundle_inventory.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_font_assets.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_font_materials.csv`
- `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_font_textures.csv`
