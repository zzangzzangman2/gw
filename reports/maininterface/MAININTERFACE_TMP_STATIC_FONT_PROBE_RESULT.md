# MainInterface TMP Static Font Probe Result

Generated: 2026-06-25 15:41:24

## Result

| font | success | glyphs | chars | asset | atlas | message |
| --- | --- | ---: | ---: | --- | --- | --- |
| `riyu` | `True` | 383 | 384 | `Assets/RestoreData/TMP/static_probe/GirlsWarStaticProbe_riyu_TMP.asset` | `Assets/RestoreData/TMP/static_probe/atlas/riyu_static_atlas.png` | `saved` |
| `EPM` | `True` | 442 | 444 | `Assets/RestoreData/TMP/static_probe/GirlsWarStaticProbe_EPM_TMP.asset` | `Assets/RestoreData/TMP/static_probe/atlas/EPM_static_atlas.png` | `saved` |
| `num` | `True` | 24 | 24 | `Assets/RestoreData/TMP/static_probe/GirlsWarStaticProbe_num_TMP.asset` | `Assets/RestoreData/TMP/static_probe/atlas/num_static_atlas.png` | `saved` |

## Meaning

이 probe는 원본 TMP 정적 glyph/character table과 추출 atlas PNG를 Unity `TMP_FontAsset`에 주입할 수 있는지 확인한다. 성공하면 MainInterface 빌더에 같은 방식을 통합해 source font dynamic preload 대신 원본 정적 TMP asset을 사용할 수 있다.

## Generated Files

- `Assets/RestoreData/reports/maininterface_tmp_static_font_probe_result.json`
- `Assets/RestoreData/TMP/static_probe/GirlsWarStaticProbe_riyu_TMP.asset`
- `Assets/RestoreData/TMP/static_probe/atlas/riyu_static_atlas.png`
- `Assets/RestoreData/TMP/static_probe/GirlsWarStaticProbe_EPM_TMP.asset`
- `Assets/RestoreData/TMP/static_probe/atlas/EPM_static_atlas.png`
- `Assets/RestoreData/TMP/static_probe/GirlsWarStaticProbe_num_TMP.asset`
- `Assets/RestoreData/TMP/static_probe/atlas/num_static_atlas.png`
