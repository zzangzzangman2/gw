# MainInterface TMP Variant Restore Result

Generated: 2026-06-25 16:46 KST

## Verdict

이번 문제의 1차 원인은 단순 좌표가 아니라 TMP font/material 복원 단계가 원본의 variant FontAsset 근거를 쓰지 못하던 것이다. active route TMP는 prefab component 기준으로는 base `riyu`/`EPM` FontAsset을 참조하지만, 실제 화면에서 쓰는 shared material 이름과 동일한 TMP FontAsset bundle도 원본에 존재한다.

확인된 active variant TMP FontAsset:

| variant | active refs | base font | glyphs | chars | note |
| --- | ---: | --- | ---: | ---: | --- |
| `riyu_baibian_0.2_0.2_1` | 14 | `riyu` | 599 | 601 | bottom/menu/activity labels |
| `riyu_shenzong_0.2_0.2` | 6 | `riyu` | 424 | 426 | `모험`, `전`, `국` route labels |
| `EPM_bai_0.2_0.2` | 1 | `EPM` | 588 | 591 | `개최 중` route tip |

특히 `riyu_shenzong_0.2_0.2`는 original family가 `DFPMincho-SU`이고 base `riyu`는 `DFMincho-SU`라 route 대형 글자 위치/크기 차이를 만들 수 있는 강한 원인이다.

## Changed

- Added active TMP variant exporter:
  - `_restore_tools\scripts\export_maininterface_active_tmp_variant_font_assets.py`
  - `_restore_tools\96_EXPORT_ACTIVE_TMP_VARIANT_FONT_ASSETS.cmd`
  - root shortcut `EXPORT_ACTIVE_TMP_VARIANT_FONT_ASSETS.cmd`
- Added Unity variant static TMP probe:
  - `TmpStaticFontAssetProbe.RunActiveVariants`
  - `_restore_tools\97_PROBE_ACTIVE_TMP_VARIANT_FONT_ASSETS.cmd`
  - root shortcut `PROBE_ACTIVE_TMP_VARIANT_FONT_ASSETS.cmd`
- Updated `MainInterfaceSceneBuilder.cs`:
  - loads `maininterface_tmp_shared_materials.csv`
  - maps `shared_material_path_id -> material_name`
  - maps `material_name -> active variant static TMP FontAsset`
  - uses variant TMP FontAsset if generated; otherwise falls back to base `riyu`/`EPM`/`num`
  - skips separate shared material override when variant FontAsset is selected to avoid atlas/material mismatch

## Generated Evidence

- `reports\maininterface\MAININTERFACE_ACTIVE_TMP_VARIANT_FONT_ASSETS.md`
- `reports\maininterface\MAININTERFACE_ACTIVE_TMP_VARIANT_STATIC_FONT_PROBE_RESULT.md`
- `Assets\RestoreData\reports\maininterface_active_tmp_variant_font_summary.csv`
- `Assets\RestoreData\reports\maininterface_active_tmp_variant_glyphs.csv`
- `Assets\RestoreData\reports\maininterface_active_tmp_variant_characters.csv`
- `Assets\RestoreData\reports\maininterface_active_tmp_variant_material_properties.csv`
- `Assets\RestoreData\TMP\static_probe\variants\GirlsWarStaticProbe_riyu_baibian_0_2_0_2_1_TMP.asset`
- `Assets\RestoreData\TMP\static_probe\variants\GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_TMP.asset`
- `Assets\RestoreData\TMP\static_probe\variants\GirlsWarStaticProbe_EPM_bai_0_2_0_2_TMP.asset`

## Verification

| check | result |
| --- | --- |
| active variant exporter | `riyu_baibian_0.2_0.2_1`, `riyu_shenzong_0.2_0.2`, `EPM_bai_0.2_0.2` exported |
| variant static TMP probe | 3 / 3 success |
| scene build | success |
| RectTransforms | 806 |
| sprite PNG applied | 214 |
| text applied | 138 / 495 |
| TMP applied | 84 / 271 |
| route rect overrides | 2 / 2 |
| capture | `Assets\RestoreCaptures\maininterface_restored_1680x720.png` |
| capture size | 1680x720 |
| visible pixels | 1,201,679 |
| active click validation | 24 / 24 clickable |
| blocked active buttons | 0 |
| invoked click logs | 24 |

## Remaining Issue

Variant TMP assets are now available and selected, but the current capture still shows the right route cluster with overlapping/odd state composition. That means the remaining issue is likely not the `riyu_shenzong` glyph table alone. Next target should be route item active state, sibling order, parent layout, and which duplicated `UI_Main_wanfa_item_*` states should be visible at the same time.

The route rect override for the two zero-height `text_name` rows remains valid and is still applied, but it does not solve the state overlap by itself.

## Next Step

Analyze `node_middle` / `wanfaWorldNode` children as a state group:

1. Compare active `UI_Main_wanfa_item_1..4` and `wanfaWorldNode` siblings against original prefab active flags.
2. Detect duplicated active route labels occupying the same visual group.
3. Add a tracked active-state override CSV only for route state objects proven to be mutually exclusive.
4. Rebuild, capture, and rerun click validation.
