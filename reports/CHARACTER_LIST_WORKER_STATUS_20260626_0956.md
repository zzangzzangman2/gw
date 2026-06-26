# Character List Worker Status 20260626_0956

## Summary
- 전체 캐릭터 카탈로그를 `DTHeroEntity -> DTmodelEntity -> DTLangBattle/DTLangCommon -> unity_images/unity_textassets/assetbundles` 근거로 재생성했다.
- `DTHeroEntity` 기준 캐릭터 131행을 추출했고, 한국어 이름/헤드 이미지가 130행에서 해결됐다.
- 전투 HUD 카드 UI가 직접 소비하는 `GIRLSWAR_CHARACTER_BATTLE_UI_LIST.json` 3행을 생성하고, `BattleHeroListSkillCardBindClip05Editor`가 이 JSON을 읽도록 연결했다.
- MainInterface 쪽은 현재 CSV 기반 복원 빌더라 코드 수정은 하지 않고, 재사용용 전체 카탈로그 사본만 `Assets/RestoreData`에 배치했다.

## Generated / Modified Files
- `_restore_tools/scripts/build_character_catalog_for_battle_ui.py`
- `reports/characters/GIRLSWAR_CHARACTER_CATALOG.json`
- `reports/characters/GIRLSWAR_CHARACTER_CATALOG.csv`
- `reports/characters/GIRLSWAR_CHARACTER_CATALOG.md`
- `reports/characters/GIRLSWAR_CHARACTER_BATTLE_UI_LIST.json`
- `reports/characters/GIRLSWAR_CHARACTER_BATTLE_UI_LIST.csv`
- `girlswar_battle_unity/Assets/RestoreData/battle/GIRLSWAR_CHARACTER_BATTLE_UI_LIST.json`
- `girlswar_battle_unity/Assets/RestoreData/battle/GIRLSWAR_CHARACTER_BATTLE_UI_LIST.csv`
- `girlswar_maininterface_unity/Assets/RestoreData/GIRLSWAR_CHARACTER_CATALOG.json`
- `girlswar_maininterface_unity/Assets/RestoreData/GIRLSWAR_CHARACTER_CATALOG.csv`
- `girlswar_battle_unity/Assets/Editor/BattleHeroListSkillCardBindClip05Editor.cs`
- Unity 검증 재생성: `girlswar_battle_unity/Assets/RestoreData/battle/BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05.json`, `reports/battle/BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05_RESULT.md`, 관련 BATTLE_29 캡처/씬 파일

## Extraction Results
- Character rows: `131`
- Korean names resolved: `130`
- Head sprites resolved: `130`
- Existing local battle actor bundles: `38`
- Existing battle skeleton TextAssets: `38`
- Rarity distribution: 4성 `13`, 5성 `55`, 6성 `34`, 7성 `29`
- Static catalog `level`은 공란으로 유지했다. `DTHeroEntity`에는 캐릭터별 런타임 레벨이 없고, 전투 카드 데이터는 `BATTLE_TEST_PAYLOAD.ourHeros.lockLevel`을 `level`로 별도 기록한다.

## Battle UI Link
- `BattleHeroListSkillCardBindClip05Editor`의 하드코딩 카드 배열을 `Assets/RestoreData/battle/GIRLSWAR_CHARACTER_BATTLE_UI_LIST.json` 로더로 교체했다.
- JSON 파싱 실패/파일 없음 시 기존 3명 하드코딩 배열로 fallback한다.
- 검증 결과 `BATTLE_HERO_LIST_SKILLCARD_BIND_CLIP05.json` 카드 행에 `nameKo`, `rarity`, `level`, `roleKo`, `actorBundle`가 실제 반영됐다.

## Verification
- `python _restore_tools\scripts\build_character_catalog_for_battle_ui.py`
  - `characters=131`, `battleCards=3`, `headResolved=130`, `battleBundles=38`
- `python -m json.tool girlswar_battle_unity\Assets\RestoreData\battle\GIRLSWAR_CHARACTER_BATTLE_UI_LIST.json`
  - JSON parse OK
- `cmd /c _restore_tools\cmd_archive\BATTLE_29_BIND_HERO_LIST_SKILLCARDS_AND_VALIDATE_CLIP05.cmd`
  - exit code `0`
  - `visual_status=improved_hero_list_cards_bound_not_final`
  - `boundHeroCardCount=3`
  - `headSpriteBindCount=3`
  - `extractedSpriteBindCount=57`
  - `visibleWhiteLikeCardImageCount=0`

## Residual Risks
- `heroId=21102` is present in `DTHeroEntity` but has no resolved Korean name, head sprite output, or local battle actor bundle in the current indexes.
- `1036` battle actor bundle is still missing locally, although its card/head/painting data are available and the CDN/versionfile evidence exists in prior character reports.
- Battle card positions are still BATTLE_29 inferred template/container placement, not final original Lua runtime layout.
- Unity log emitted existing scene GUID extraction warnings while saving `BattleHeroListSkillCardBindClip05.unity`, but batchmode completed with return code `0`.
