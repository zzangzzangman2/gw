# MainInterface XLua Loader Analysis

작성 시각: 2026-06-25 12:51 KST

## 결론

`maininterface.assetbundle` 안에는 Lua 바인딩 MonoBehaviour가 직접 직렬화되어 있다. 공통 script id는 `8347263561838679580`이고, 각 컴포넌트는 `LuaScriptPath`, `luaScript`, `m_LuaComGroups`를 가진다. 따라서 버튼 복원은 좌표 추정이 아니라 원본 `LuaComGroups`의 `Name`/`Type`/`ComObj`를 따라가면 된다.

`download/xlualogic/modules/maininterface.assetbundle`의 TextAsset은 저장 상태에서는 평문 Lua가 아니다. prefix 분포는 `A-EV`=32, `K7HT`=4이고, IL2CPP dump 기준 로드 축은 `LuaManager.MyLoader` / `LuaManager.GetLuaBuff` / `LuaManager.LoadUIScript`, `XXTEAUtil.DecryptByteArray`, `YouYouUtil.SecurityUtil.Xor`이다.

추가 native 추적 결과, `XXTEAUtil..cctor`의 정적 배열은 회수했다. `SoketKey`는 `66 78 16 18 58 06 77 58`, private `ass`는 64바이트이며, `DecryptByteArray`의 magic은 `0C 07 08 0D 0B 09`이다. MainInterface xLua TextAsset 36개는 이 magic branch에 직접 들어가지 않는다. 대신 `LuaManager.GetLuaBuff`가 `TextAsset.bytes`를 읽은 뒤 `/DataTable/`, `/Proto/`가 아니면 `SecurityUtil.Xor`를 적용한다. `SecurityUtil.xorScale` 22바이트를 metadata offset `0x5829D1`에서 회수했고, raw TextAsset을 `surrogateescape`로 재추출한 뒤 36개 모두 Lua 평문으로 복원했다.

복원된 Lua와 Unity Button/LuaCom 보고서를 조인한 결과, Button 77개 중 module+target 정확 매칭은 39개, 후보 module+target 매칭은 21개, target-name-only 매칭은 1개, 미매칭은 16개다. `UI_MainPage`의 핵심 route 버튼은 `onBtnShop`, `OnQuestBtnClick`, `onBtnGuild`, `onBtnBag`, `onBtnCity`, `onBtnWorld`, `onBtnLeft`, `onBtnRight`처럼 함수명까지 확인됐다.

Unity hit-stack 클릭 검증도 추가했다. `maininterface_raycast_overrides.csv`로 현재 화면 state를 분리한 뒤 active 버튼 24개 중 24개가 `[GirlsWarRestore][Click]` 로그까지 호출됐고, active blocker는 0개다.

## 수치

| 항목 | 값 |
|---|---:|
| Lua binding components | 20 |
| Binding components in `UI_MainInterface` root | 1 |
| LuaCom entries | 590 |
| LuaCom entries in root | 152 |
| Root Type 4 Button LuaCom entries | 47 |
| MainInterface XLua TextAssets | 36 |
| Encrypted/packed-like TextAssets | 36 |
| Recovered `SoketKey` | 8 bytes |
| Recovered `ass` | 64 bytes |
| Recovered `SecurityUtil.xorScale` | 22 bytes |
| Raw TextAssets recovered | 36 |
| Decode attempts | 720 |
| Lua-like outputs | 36 |
| Saved decoded `.lua` files | 36 |
| Decoded Lua UI listener rows | 206 |
| Decoded Lua EventSystem rows | 126 |
| Decoded Lua unique UI targets | 131 |
| Button/Lua module+target matches | 39 |
| Button/Lua candidate module+target matches | 21 |
| Button/Lua target-name-only matches | 1 |
| Button/Lua missing matches | 16 |
| Click validation active buttons | 24 |
| Click validation clickable buttons | 24 |
| Click validation blocked active buttons | 0 |
| Click validation emitted click logs | 24 |

## IL2CPP Evidence

- `XXTEAUtil.DecryptByteArray` line 437391 RVA `0x1C79B00`: `public static string DecryptByteArray(byte[] source) { }`
- `XXTEAUtil.DecryptGetString` line 437398 RVA `0x1C79EF8`: `public static string DecryptGetString(byte[] bytes, string key) { }`
- `XXTEAUtil.DecryptGetArray` line 437401 RVA `0x1C7A04C`: `public static string[] DecryptGetArray(byte[][] arr, string key) { }`
- `LuaManager.Init` line 502822 RVA `0xD29558`: `public override void Init() { }`
- `LuaManager.InitLuaFunction` line 502825 RVA `0xD29BA0`: `private void InitLuaFunction() { }`
- `LuaManager.LoadLuaAssetBundle` line 502828 RVA `0xD2A1E4`: `private void LoadLuaAssetBundle() { }`
- `LuaManager.MyLoader` line 502831 RVA `0xD2A5A0`: `private byte[] MyLoader(ref string filePath) { }`
- `LuaManager.GetLuaBuff` line 502834 RVA `0xD2A664`: `private byte[] GetLuaBuff(string filePath, bool isLuaUIFile) { }`
- `LuaManager.LoadUIScript` line 502840 RVA `0xD2ADCC`: `public object[] LoadUIScript(string fileName, string chunkName = "chunk", LuaTable env) { }`
- `SecurityUtil.Xor` line 443222 RVA `0xF84ED4`: `public static byte[] Xor(byte[] buffer) { }`
- `SecurityUtil..cctor` line 443225 RVA `0xF85030`: `private static void .cctor() { }`
- `LuaForm.LuaScriptPath` line 502196 RVA ``: `public string LuaScriptPath; // 0x110`
- `LuaPage.LuaScriptPath` line 514276 RVA ``: `public string LuaScriptPath; // 0x78`
- `LuaUnit.LuaScriptPath` line 514497 RVA ``: `public string LuaScriptPath; // 0x58`

## Native IL2CPP Files

- `global-metadata.dat` size 9513836 SHA-256 `caaf94218f49a4ce296cede9d87ac43d7993ce2432d452537e405322cebe252b`
- `libil2cpp.so` size 52321120 SHA-256 `8bb3e249a9cf03d309170a4fdeb9af81e4649107d50a6f3d72b1321b8d5916f1`

## Disassembly Evidence

- targets: 17
- successful targets: 17
- asm: `C:\Users\godho\Downloads\girlswar\il2cpp_native\il2cpp_xlua_target_disassembly.asm`
- csv: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_il2cpp_xlua_disassembly.csv`
- `XXTEAUtil.DecryptByteArray` disassembly에서 `0c 07 08 0d 0b 09` 매직 검사 흐름이 보인다.
- `XXTEAUtil..cctor`에서 `SoketKey` static field offset `0x0`, `ass` static field offset `0x8` 초기화를 확인했다.
- `SoketKey`: metadata offset `0x582889`, bytes `66 78 16 18 58 06 77 58`
- `ass`: metadata offset `0x582B67`, bytes `24 FA 49 9B 10 8D 62 59 29 26 81 67 4B F7 91 EB 36 1F 78 07 49 CA 35 A2 37 D7 B0 A6 49 D3 31 D5 9A 5B 46 86 14 FF 21 CB BC 63 BA 1C 49 FC 94 2F F8 35 D9 46 1F 15 2B 2F 37 54 9D CC 44 D9 77 C4`
- `LuaManager.GetLuaBuff`는 `Assets/Download/xLuaLogic/` + filePath + `.bytes`로 TextAsset을 찾고, `/DataTable/`, `/Proto/`가 아니면 `SecurityUtil.Xor`를 적용한다.
- `SecurityUtil.Xor`는 `buffer[i] ^= xorScale[i % xorScale.Length]` 형태다.
- `SecurityUtil.xorScale`: metadata offset `0x5829D1`, bytes `2D 42 26 37 17 FE 09 A5 5A 13 29 2D C9 3A 37 25 FE B9 A5 A9 13 AB`

## 산출 파일

- `Assets\RestoreData\reports\maininterface_lua_bindings.csv`
- `Assets\RestoreData\reports\maininterface_lua_com_bindings.csv`
- `Assets\RestoreData\reports\maininterface_xlua_asset_format.csv`
- `Assets\RestoreData\reports\maininterface_xlua_loader_methods.csv`
- `Assets\RestoreData\reports\maininterface_xlua_loader_string_hits.csv`
- `Assets\RestoreData\reports\maininterface_xlua_loader_summary.json`
- `Assets\RestoreData\reports\maininterface_il2cpp_xlua_disassembly.csv`
- `Assets\RestoreData\reports\maininterface_xxtea_static_arrays.csv`
- `Assets\RestoreData\reports\maininterface_xxtea_static_arrays_summary.json`
- `Assets\RestoreData\reports\maininterface_xlua_textasset_raw.csv`
- `Assets\RestoreData\reports\maininterface_xlua_textasset_raw_summary.json`
- `Assets\RestoreData\reports\maininterface_xlua_decode_attempts.csv`
- `Assets\RestoreData\reports\maininterface_xlua_decode_summary.json`
- `Assets\RestoreData\reports\maininterface_decoded_lua_handlers.csv`
- `Assets\RestoreData\reports\maininterface_decoded_lua_handler_summary.json`
- `Assets\RestoreData\reports\maininterface_button_lua_handler_join.csv`
- `Assets\RestoreData\reports\maininterface_button_lua_handler_join_summary.json`
- `Assets\RestoreData\reports\maininterface_click_validation.csv`
- `Assets\RestoreData\reports\maininterface_click_validation_summary.json`
- `Assets\RestoreData\maininterface_raycast_overrides.csv`
- `C:\Users\godho\Downloads\girlswar\il2cpp_native\il2cpp_xlua_target_disassembly.asm`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_XXTEA_STATIC_ARRAYS.md`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_XLUA_RAW_TEXTASSETS.md`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_XLUA_DECODE_ATTEMPTS.md`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_LUA_HANDLER_SCAN.md`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_BUTTON_LUA_HANDLER_JOIN.md`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_CLICK_VALIDATION.md`
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua`

## 다음 작업

1. `maininterface_lua_com_bindings.csv`에서 `owner_in_main_root=true` 및 `com_type=4`를 우선 클릭 후보로 사용한다.
2. 버튼 이름이 같은 경우 `com_obj_path_id`와 `com_game_object_id`로 Unity Button 컴포넌트와 정확히 매칭한다.
3. decoded Lua handler scan 결과의 UI listener 206개와 EventSystem listener 126개를 우선 사용한다.
4. `maininterface_click_validation.csv`의 clickable 24개는 현재 Scene에서 실제 클릭 로그가 확인된 항목으로 유지한다.
5. `maininterface_button_lua_handler_join.csv`의 `module_and_target` 39개 중 inactive/source-state 항목은 별도 상태 전환 복원 대상으로 분리한다.
6. `candidate_module_and_target` 21개는 리스트 아이템/반복 prefab 후보이므로 같은 target 이름의 Lua module과 함께 클릭 캡처로 확정한다.
7. `missing` 16개는 시각 버튼, 동적 생성 항목, 또는 다른 module/runtime 등록 경로 가능성이 있으므로 Lua 사용처 검색과 그래픽 클릭 로그로 분리한다.

