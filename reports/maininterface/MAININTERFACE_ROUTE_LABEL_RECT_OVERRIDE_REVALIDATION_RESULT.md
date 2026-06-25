# MainInterface Route Label Rect Override Revalidation Result

Generated: 2026-06-25 20:46:59 KST

## Verdict

화면 기준으로 MainInterface는 아직 정상 UI가 아니다. 오른쪽 route cluster는 여전히 원본처럼 보인다고 판정할 수 없다.

이번 변경은 좌표 보정이 아니라 기존 좌표성 보정 제거다. `UI_Main_wanfa_item_3/4/text_name`의 원본 `sizeDelta.y=0`은 active TMP + `Overflow` 조합으로 기록되어 있고, `200x35` override의 근거는 sibling 추정뿐이라 hard gate 기준을 통과하지 못했다. 따라서 두 text size override를 제거하고 원본 `200x0`을 보존한다.

`Entry` localScale override 2개는 원본 `0,0,0` evidence가 명확하므로 유지한다.

## Counts

| metric | value |
| --- | ---: |
| route audit rows | 160 |
| route label TMP rows | 6 |
| removed text size overrides | 2 |
| kept Entry zero-scale overrides | 2 |

## Override Decisions

| owner | node | rect pathID | original size/scale | current size/scale | layout evidence | decision |
| --- | --- | --- | --- | --- | --- | --- |
| `UI_Main_wanfa_item_3` | `text_name` | `-6275118336609310875` | `200.0x0.0 / 1.0,1.0,1.0` | `200,0 / 1,1,1` | `` | `remove_text_size_override_preserve_original_zero_height` |
| `UI_Main_wanfa_item_4` | `text_name` | `-3578904844754949875` | `200.0x0.0 / 1.0,1.0,1.0` | `200,0 / 1,1,1` | `` | `remove_text_size_override_preserve_original_zero_height` |
| `UI_Main_wanfa_item_3` | `Entry` | `-249494615586118723` | `100.0x100.0 / 0.0,0.0,0.0` | `100,100 / 0,0,0` | `` | `keep_entry_zero_scale_override_original_evidence` |
| `UI_Main_wanfa_item_4` | `Entry` | `-2663983105510939953` | `100.0x100.0 / 0.0,0.0,0.0` | `100,100 / 0,0,0` | `` | `keep_entry_zero_scale_override_original_evidence` |

## Route Labels

| owner | text | rect pathID | original size | current size | pivot | overflow | material | decision |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `wanfaWorldNode` | `전` | `5611221341508507661` | `70.0x60.0` | `70,60` | `0,0.5` | `Overflow` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material` | `preserve_original_tmp_rect` |
| `wanfaWorldNode` | `국` | `4226973974425312330` | `60.0x50.0` | `60,50` | `0,0.5` | `Overflow` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material` | `preserve_original_tmp_rect` |
| `UI_Main_wanfa_item_1` | `모험` | `-5982825750273040741` | `100.0x35.0` | `100,35` | `0,0.5` | `Overflow` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material` | `preserve_original_tmp_rect` |
| `UI_Main_wanfa_item_2` | `모험` | `7817983549160651324` | `100.0x35.0` | `100,35` | `0,0.5` | `Overflow` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material` | `preserve_original_tmp_rect` |
| `UI_Main_wanfa_item_3` | `모험` | `-6275118336609310875` | `200.0x0.0` | `200,0` | `0.5,1` | `Overflow` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material` | `remove_text_size_override_preserve_original_zero_height` |
| `UI_Main_wanfa_item_4` | `모험` | `-3578904844754949875` | `200.0x0.0` | `200,0` | `0.5,1` | `Overflow` | `GirlsWarStaticProbe_riyu_shenzong_0_2_0_2_Material` | `remove_text_size_override_preserve_original_zero_height` |

## Outputs

- `Assets/RestoreData/maininterface_route_label_rect_override_revalidation.json`
- `Assets/RestoreData/reports/maininterface_route_label_rect_override_revalidation.csv`
- `Assets/RestoreCaptures/maininterface_restored_1680x720.png` after tool 111

## Verification

| check | result |
| --- | --- |
| active tool | `_restore_tools\111_REVALIDATE_MAININTERFACE_ROUTE_LABEL_RECT_OVERRIDES.cmd` |
| graphics capture | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\maininterface_restored_1680x720.png` |
| capture generated | `2026-06-25 20:47:03 KST` |
| click validation generated | `2026-06-25 20:47:06 KST` |
| active/clickable/blocked/invoked | `24 / 24 / 0 / 24` |

## Remaining Blocker

The remaining right route cluster mismatch is not supported by another text RectTransform override. The next blocker is the non-Image renderer/effect layer and runtime state around `wanfaWorldNode`, `spine_xiaoren/8007`, and held-back `yun/yun2`/particle-style route effects.
