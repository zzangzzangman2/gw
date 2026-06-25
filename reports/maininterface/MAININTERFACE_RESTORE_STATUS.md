# GirlsWar MainInterface Restore Status

작성 시각: 2026-06-25 15:56 KST

## 현재 위치

메인 작업 폴더:

`C:\Users\godho\Downloads\girlswar`

병합/추출 산출물:

`C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted`

Unity 복원 프로젝트:

`C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity`

실행/분석 도구 폴더:

`C:\Users\godho\Downloads\girlswar\_restore_tools`

현재 1차 대상 화면:

`download/ui/uiprefabandres/maininterface.assetbundle`

## 적용 완료

| 항목 | 결과 |
|---|---:|
| 현재 Scene root | `UI_MainInterface` |
| RectTransform 복원 | 806 |
| Sprite PNG 실제 적용 | 214 |
| Text 컴포넌트 적용 | 138 |
| Text/font/layout audit | 완료 |
| 원본 TMP-like Text rows | 271 / 495 |
| 원본 UGUI Text rows | 218 / 495 |
| InputField rows | 6 / 495 |
| right route TMP-like Text rows | 49 / 70 |
| 현재 SceneBuilder 폰트 상태 | TMP/UGUI 분리 적용, TMP는 원본 정적 glyph/character table + atlas PNG 기반 static TMP FontAsset 우선 사용 |
| `com.unity.textmeshpro` manifest | 없음 |
| UI font assetbundle 근거 | 104개 (`download/ui/uifont/japanese/...`) |
| TMP/shader target bundle inventory | 105개 (`uifont` 104 + `tmpshaders` 1) |
| TMP FontAsset structured rows | 54 |
| uifont Material / Texture2D type count | 107 / 81 |
| 추출된 TMP atlas/image PNG | 73 |
| Unity 6000 TMP compile/create probe | `tmp_compile_ok`, `TextMeshProUGUI`, compile errors 0 |
| TMP Essential Resources 직접 추출 | 33 assets / 38 meta |
| TMP fallback FontAsset atlas/material sub-asset | 적용 완료 |
| 원본 source TMP FontAsset 생성 | `riyu`/`EPM`/`num` 3개 |
| 원본 source TMP FontAsset glyph preload | 3개 asset 모두 `m_GlyphTable`/`m_CharacterTable` 저장, `m_ClearDynamicDataOnBuild: 0` |
| TMP preload/cache build 검증 | 2026-06-25 15:27, compile errors 0, missing character warning 폰트별 1회 |
| 원본 TMP 정적 FontAsset 분석 | `riyu` 383/384, `EPM` 442/444, `num` 24/24 glyph/character 확인 |
| TMP 정적 FontAsset probe | 성공: `GirlsWarStaticProbe_riyu/EPM/num_TMP.asset` 생성 |
| active scene static TMP FontAsset 적용 | `riyu` 40, `EPM` 40, `num` 4, Malgun fallback 0 |
| TMP shared material 원본 스캔 | referenced 19 / found 19 / missing 0 |
| TMP shared material asset 생성 | 19 / 19 성공 |
| active scene TMP shared material 적용 | 84 / 84 refs |
| route TMP state after material | active 21, suspicious active 7, zero-height active 2, font-larger-than-rect active 5 |
| 최신 MainInterface capture | 1680x720, visible pixel 1,201,680, generated 2026-06-25 15:54:18 |
| 최신 TMP 캡처 예외 | 0 (`m_AtlasTextures`/FontAsset missing 없음) |
| 최신 active Button click validation | 24 / 24 clickable, blocked 0, generated 2026-06-25 15:54:58 |
| ScrollRect 적용 | 3 / 12 |
| Button 클릭 로그 적용 | 77 |
| 고유 Button 이름 | 56 |
| Raycast target | 154 |
| 투명 Raycast 후보 | 27 |
| 큰 non-button blocker 후보 | 0 |
| invisible blocker 후보 | 0 |
| 직접 텍스트/가이드 증거가 있는 Button 이름 | 13 |
| 가이드 이벤트 증거가 있는 Button 이름 | 6 |
| Lua binding component | 20 |
| `UI_MainInterface` root Lua binding component | 1 |
| root LuaCom entry | 152 |
| root LuaCom Type 4 Button binding | 47 |
| LuaCom 정확 매칭 Button 인스턴스 | 47 |
| LuaCom 정확 매칭 고유 Button 이름 | 46 |
| MainInterface XLua 모듈 | 36 |
| 암호화/패킹된 XLua 모듈 | 36 |
| 추출된 `global-metadata.dat` | 9,513,836 bytes |
| 추출된 `libil2cpp.so` | 52,321,120 bytes |
| xLua/XXTEA/Security disassembly target | 17 / 17 성공 |
| `SoketKey` 회수 | `66 78 16 18 58 06 77 58` |
| `ass` 회수 | 64 bytes |
| `DecryptByteArray` magic | `0C 07 08 0D 0B 09` |
| `SecurityUtil.xorScale` 회수 | `2D 42 26 37 17 FE 09 A5 5A 13 29 2D C9 3A 37 25 FE B9 A5 A9 13 AB` |
| raw xLua TextAsset 재추출 | 36 |
| xLua decode 시도 | 720 |
| decoded Lua-like 결과 | 36 |
| 저장된 decoded `.lua` | 36 |
| decoded Lua UI listener row | 206 |
| decoded Lua EventSystem row | 126 |
| decoded Lua 고유 UI target | 131 |
| Button/Lua module+target 정확 매칭 | 39 |
| Button/Lua 후보 module+target 매칭 | 21 |
| Button/Lua target-name-only 매칭 | 1 |
| Button/Lua 미매칭 | 16 |
| Unity 클릭 로그 Lua handler 필드 주입 | 77 |
| 현재 화면 state/raycast override | 29 |
| active state override 적용 | 26 |
| graphic raycast override 적용 | 3 |
| 시각 동적 배경 override 적용 | 1 |
| 좌표계 기준 | `1680x720` 후보로 재정렬 |
| Hero 1001 Spine 근거 분석 | 완료 |
| Hero 1001 source export | 30 |
| 1001 `DTmodelEntity.homePara` | `[1,0,0]` |
| `paintingprefabandres/1001` SkeletonGraphic-like Behaviour | 7 |
| 1001 home skeleton binary | `Painting_1001=4.0.56`, `Front/Back=4.0.56`, `SP_heroname=4.0.47` |
| 복원 프로젝트 Spine runtime | 없음, Spine 4.0 격리 probe 필요 |
| Spine runtime compatibility | `needs_probe_or_unity2022` |
| Spine 4.0 unitypackage | `_restore_tools\vendor`, 6,881,350 bytes, 646 pathnames |
| Hero 1001 raw Spine TextAsset 재추출 | 8개, 이전 text export 손상 확인 |
| Spine 4.0 Unity 6000 probe | runtime import/compile 확인, soft import exception만 존재 |
| Hero 1001 SkeletonDataAsset probe import | 4개 생성/로드 성공 |
| Hero 1001 probe SkeletonGraphic attach/capture | 성공, Unity/log return code 0 |
| Hero 1001 probe full capture | `1,203,061` visible pixels |
| Hero 1001 probe hero-only capture | `1,166,048` visible pixels |
| Hero 1001 probe layer count | 4 layers: back/main/front/name |
| Hero 1001 candidate variant capture | 10개 생성: full 5개, hero-only 5개 |
| Hero 1001 1차 적용 후보 | `main_only` = `Painting_1001` only |
| Hero 1001 `main_only` hero-only capture | `402,344` visible pixels, bounds `379,0 - 1451,719` |
| Hero 1001 `main_front_name` 판정 | 전경 나무/이름판이 얼굴과 중앙 UI를 덮어 기본 홈 적용 보류 |
| Hero 1001 `back` 판정 | 배경 계열이라 `UI_bg` 별도 로드와 충돌 가능, 기본 적용 금지 |
| 클릭 검증 전체 Button logger | 77 |
| 클릭 검증 active Button | 24 |
| hit-stack 클릭 가능 Button | 24 |
| hit-stack blocked active Button | 0 |
| 실제 `[GirlsWarRestore][Click]` 로그 | 24 |
| blocked active Button 분류 완료 | 0 |
| 최대 blocker 그룹 | 없음 |
| 전체 번들 Sprite 매핑 | 707 / 977 |
| 전체 번들 Text 컴포넌트 | 495 |
| 복사된 고유 Sprite PNG | 212 |
| 캡처 visible pixel | 1,201,680 |
| Unity batchmode 빌드 | 성공, return code 0 |
| 생성 Scene | `Assets/Scenes/MainInterface_Wireframe.unity` |
| 캡처 PNG | `Assets/RestoreCaptures/maininterface_restored_1680x720.png` |

`maininterface_sprite_map.csv` 기준으로 `sprite_ref`의 fileID/pathID가 추출 PNG와 정확히 맞는 경우만 붙였다. 전체 atlas를 임시로 덮어 쓰지 않았고, 매칭 안 된 Image는 흰 박스가 보이지 않도록 투명 처리했다. 현재 Scene은 전체 bundle이 아니라 `UI_MainInterface` prefab root 하위만 필터링한다.

중요 정정: 이전 `1280x720` 강제 방향은 `failed_visual_shape_check`로 취소한다. `UI_MainInterface` root는 prefab 안에서 0x0이고, 실제 게임에서는 `GameEntry`의 UI root/Canvas 아래에 mount되며 child anchor가 의미를 갖는다. `UI_bg`가 1680x720이고, decoded Lua가 `Screen.width * GameEntry.Instance.StandardHeight / Screen.height`를 `MinWidth`/`MaxWidth`로 clamp하는 흐름을 쓰므로 현재 MainInterface 좌표계 후보는 `1680x720`이다. 이 변경은 좌표계 교정이지 화면 완성이 아니다. `UI_heroSpine` / `UI_touchSpine`의 Spine/Live2D 런타임 렌더러와 일부 동적 텍스트/state는 아직 별도 복원 대상이다.

텍스트/폰트 정정: 현재 캡처의 글씨 위치와 폰트는 아직 원본 완성으로 보면 안 된다. 분석 결과 전체 텍스트 495개 중 271개가 `m_fontAsset`, `m_fontMaterial`, `m_textAlignment`, `m_characterSpacing`, `m_lineSpacing`, `m_margin` 등을 가진 TMP-like 원본 컴포넌트다. 현재 `MainInterfaceSceneBuilder`는 TMP/UGUI를 분리하고 active TMP 84개에 원본 `tmp/*.assetbundle`에서 재구성한 static TMP FontAsset과 원본 shared material preset을 적용했다. `riyu`/`EPM`/`num`의 정적 glyph/character table, atlas PNG, 19개 shared material은 들어갔지만, route 라벨 크기/위치가 아직 정상은 아니므로 다음 병목은 route active state, zero/tight RectTransform, font scale/autosize, sibling/sorting 정리다.

2026-06-25 14:50 추가 확인: TMP FontAsset inventory를 생성했다. `download/ui/uifont/japanese/tmp` 안에서 TMP FontAsset structured row 54개와 atlas/image PNG 73개가 확인됐고, family는 `Arial Unicode MS`, `DFMincho-SU`, `DFPMincho-SU`, `Impact`, `KswKashin`, `tway_sky` 등이 있다. `type_counts.json` 기준 Material 107개, Texture2D 81개도 존재한다. 2026-06-25 15:56 기준으로 `riyu`, `EPM`, `num` 기본 3개는 원본 정적 glyph/character table과 atlas PNG를 Unity TMP FontAsset으로 재구성했고, MainInterface가 참조하는 shared material 19개도 전부 Unity Material asset으로 재구성했다. active TMP 84개는 static font와 shared material을 참조한다. 근거 문서는 `MAININTERFACE_ORIGINAL_TMP_STATIC_FONT_ANALYSIS.md`, `MAININTERFACE_TMP_STATIC_FONT_APPLY_RESULT.md`, `MAININTERFACE_TMP_SHARED_MATERIAL_ANALYSIS.md`, `MAININTERFACE_TMP_SHARED_MATERIAL_APPLY_RESULT.md`다.

2026-06-25 14:53 추가 확인: 격리 Unity 6000 probe에서 `using TMPro`와 `TextMeshProUGUI` component 생성/컴파일이 성공했다. Unity 6000의 `com.unity.textmeshpro`는 shim이고 실제 TMP runtime은 `com.unity.ugui` 2.0에 포함되어 있으므로, 현재 main 프로젝트도 manifest에 있는 `com.unity.ugui` 기반으로 TMP 빌더 분기를 추가할 수 있다. 2026-06-25 15:44 기준으로 이 TMP 분기는 적용됐고, source font dynamic preload 대신 원본 정적 TMP table을 우선 쓰도록 연결했다.

추가 정정: 기본 홈 캐릭터는 `Painting_1001.png` 같은 atlas page를 통째 Image로 붙이는 구조가 아니다. decoded `UI_MainPage`는 `UIUtil.GetPlayerBigSpineAll(i, UI_heroSpine, "homePara", ...)`를 호출하고, 1001번 `DTmodelEntity.homePara`는 `[1,0,0]`이다. `download/roleprefabsandres/paintingprefabandres/1001.assetbundle`에는 GameObject 317개, RectTransform 317개, CanvasRenderer 317개, SkeletonGraphic-like Behaviour 7개가 있으며, `Painting_1001.atlas.txt`의 region은 117개다. `Painting_1001.skel.bytes`는 Spine `4.0.56` binary이고 현재 복원 Unity 프로젝트는 `6000.4.9f1`이다.

2026-06-25 14:32 기준으로 손상됐던 `.skel.bytes` text export를 raw TextAsset bytes로 다시 추출했고, 공식 `spine-unity 4.0` 런타임은 `_restore_tools\work`의 격리 Unity 6000 probe에서 import/compile 확인했다. 이후 `Painting_1001`, `Painting_1001_Front`, `Painting_1001_Back`, `SP_heroname_1001`의 `SkeletonDataAsset` 4개를 probe 안에서 생성/로드했고, `UI_heroSpine` 아래에 `SkeletonGraphic` 레이어로 attach/capture까지 성공했다. 캡처 결과는 `MAININTERFACE_SPINE40_HERO1001_ATTACH_CAPTURE_RESULT.md`와 `reports\maininterface\captures`에 있다.

중요 정정: 전체 4개 레이어를 그대로 main 복원 프로젝트에 넣으면 안 된다. 후보 조합 10개를 추가 캡처한 결과, `Painting_1001` 본체만 켠 `main_only`는 정상 캐릭터 형태가 나오지만, `main_front_name`은 전경 나무/이름판이 캐릭터 얼굴과 중앙 UI를 덮고, `all_layers_with_back`은 배경 계열까지 포함되어 `UI_bg` 별도 로드와 충돌한다. 따라서 다음 적용 기준은 `main_only`를 1차로 붙인 뒤 sorting/sibling order와 버튼 occlusion을 맞추고, `front/name/back`은 Lua home branch 근거가 확인될 때만 조건부로 적용하는 것이다.

레이캐스트/버튼/xLua 보고서도 추가했다. root 내부 Button 인스턴스 77개에는 클릭 로그가 붙어 있고, 이름 기준으로 56개를 핸들러 후보에 매핑했다. `LuaComGroups` 기준으로는 root 내부 Type 4 버튼 바인딩 47개가 Unity Button 컴포넌트 pathID와 정확히 매칭된다. `download/xlualogic/modules/maininterface.assetbundle`의 TextAsset 본문은 `A-EV` 32개, `K7HT` 4개 prefix를 가진 암호화 상태다. `XXTEAUtil..cctor`에서 `SoketKey`와 `ass` 정적 배열은 회수했고, `DecryptByteArray`는 `0C 07 08 0D 0B 09` 매직이 있을 때만 암호화 branch를 탄다. MainInterface xLua는 이 magic branch가 아니라 `LuaManager.GetLuaBuff`가 `TextAsset.bytes`를 읽고 `YouYouUtil.SecurityUtil.Xor`를 적용하는 경로다. `SecurityUtil.xorScale` 22바이트를 IL2CPP `.cctor`에서 회수했고, UnityPy `surrogateescape`로 raw TextAsset을 재추출한 뒤 36개 모두 Lua 평문으로 복원했다. decoded Lua는 `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua`에 저장했다. decoded Lua와 Unity Button/LuaCom을 조인해 module+target 정확 매칭 39개, 후보 module+target 매칭 21개, target-name-only 1개, 미매칭 16개까지 분리했다. Scene 재생성기와 `RestoreClickLogger`도 이 조인 CSV를 읽도록 연결했으므로, 실제 Unity 클릭 로그에는 `luaModule`, `luaHandler`, `luaConfidence`, `luaEvent`가 함께 찍힌다. Unity UI Graphic hit-stack 기준 클릭 검증기를 만들었고, `maininterface_raycast_overrides.csv`로 투명 반복 activity item, 같은 슬롯 toggle/top-menu/top-button state, decorative raycast blocker를 현재 화면 state로 분리했다. 현재 active 버튼 24개는 모두 `[GirlsWarRestore][Click]` 로그까지 호출되며, active blocker는 0개다.

## 남은 Sprite 상태

| 상태 | 개수 | 의미 |
|---|---:|---|
| `ready` | 707 | Sprite PNG까지 정확히 찾아 Unity에 적용됨 |
| `empty_sprite_ref` | 270 | 원본 Image는 있으나 Sprite 참조가 비어 있음 |

상세 파일:

`C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_sprite_map.csv`

## 상호작용/핸들러 보고서

| 파일 | 내용 |
|---|---|
| `Assets\RestoreData\reports\maininterface_root_buttons.csv` | root 내부 Button 77개 원본 컴포넌트 정보 |
| `Assets\RestoreData\reports\maininterface_root_raycast_report.csv` | Raycast target, 투명 blocker 후보, 로그 probe 대상 |
| `Assets\RestoreData\reports\maininterface_root_interaction_summary.json` | Rect/Image/Text/Button/ScrollRect 상호작용 요약 |
| `Assets\RestoreData\reports\maininterface_button_handler_candidates.csv` | Button 이름별 직접 증거와 XLua 후보 모듈 |
| `Assets\RestoreData\reports\maininterface_button_luacom_join.csv` | Button 컴포넌트 pathID와 LuaComGroups Type 4 바인딩 조인 |
| `Assets\RestoreData\reports\maininterface_lua_bindings.csv` | MainInterface prefab 안 LuaScriptPath/luaScript 컴포넌트 20개 |
| `Assets\RestoreData\reports\maininterface_lua_com_bindings.csv` | LuaComGroups 590개와 root 포함 여부 |
| `Assets\RestoreData\reports\maininterface_xlua_loader_methods.csv` | IL2CPP LuaManager/XXTEAUtil 로더 RVA |
| `Assets\RestoreData\reports\maininterface_il2cpp_xlua_disassembly.csv` | xLua/XXTEA/Security 대상 RVA, file offset, ASM 첫 줄 |
| `Assets\RestoreData\reports\maininterface_xxtea_static_arrays.csv` | `SoketKey`, `ass`, 매직, metadata offset 회수 결과 |
| `Assets\RestoreData\reports\maininterface_xlua_textasset_raw.csv` | `surrogateescape`로 되살린 raw TextAsset 36개 |
| `Assets\RestoreData\reports\maininterface_xlua_decode_attempts.csv` | xLua TextAsset decode 실험 720개 |
| `Assets\RestoreData\reports\maininterface_decoded_lua_handlers.csv` | decoded Lua의 AddListener/AddBtnClickListener/EventSystem 스캔 |
| `Assets\RestoreData\reports\maininterface_button_lua_handler_join.csv` | Unity Button/LuaCom과 decoded Lua handler 조인 |
| `Assets\RestoreData\reports\maininterface_click_validation.csv` | Button 중심점 hit-stack, blocker, 클릭 로그 호출 검증 |
| `Assets\RestoreData\reports\maininterface_click_validation_summary.json` | 클릭 검증 요약 |
| `Assets\RestoreData\reports\maininterface_click_blocker_analysis.csv` | 현재 active blocker 0개 검증 및 blocker 이력 분석 |
| `Assets\RestoreData\reports\maininterface_click_blocker_analysis_summary.json` | blocker 분류 요약 |
| `Assets\RestoreData\reports\maininterface_coordinate_root_children.csv` | `UI_MainInterface` 직계 자식 anchor/size 좌표계 증거 |
| `Assets\RestoreData\reports\maininterface_coordinate_system_summary.json` | 1680x720 좌표계 재정렬 요약 |
| `Assets\RestoreData\reports\maininterface_text_font_layout_summary.json` | Text/TMP/font/route layout audit 요약 |
| `Assets\RestoreData\reports\maininterface_text_script_type_audit.csv` | script id별 UGUI/TMP-like/InputField 분류 |
| `Assets\RestoreData\reports\maininterface_right_route_text_layout.csv` | 오른쪽 route 라벨 parent/state/rect/TMP 분류 |
| `Assets\RestoreData\reports\maininterface_tmp_font_assets_summary.json` | TMP FontAsset/uifont bundle inventory 요약 |
| `Assets\RestoreData\reports\maininterface_tmp_font_bundle_inventory.csv` | uifont/tmpshaders bundle별 type count와 atlas image 샘플 |
| `Assets\RestoreData\reports\maininterface_tmp_font_assets.csv` | TMP FontAsset face/glyph/atlas/material pathID |
| `Assets\RestoreData\reports\maininterface_tmp_compile_probe_summary.json` | Unity 6000 TMP compile/create probe 요약 |
| `Assets\RestoreData\reports\maininterface_hero1001_spine_summary.json` | 1001 기본 홈 캐릭터 Spine/DTmodel/bundle/런타임 유무 요약 |
| `Assets\RestoreData\reports\maininterface_hero1001_assets.csv` | 1001 painting/rolebig/battle 관련 PNG, atlas, skel 목록과 용도 |
| `Assets\RestoreData\reports\maininterface_hero1001_dtmodel_fields.csv` | `DTmodelEntity` 1001 row 중 homePara, paintingBg 등 복원 필드 |
| `Assets\RestoreData\reports\maininterface_hero1001_atlas_regions.csv` | 1001 atlas page별 region 수 |
| `Assets\RestoreData\reports\maininterface_hero1001_structure_roots.csv` | `paintingprefabandres/1001` root RectTransform 구조 |
| `Assets\RestoreData\reports\maininterface_hero1001_spine_source_export.csv` | Unity 프로젝트에 복사한 1001 Spine source manifest |
| `Assets\RestoreData\reports\maininterface_spine_runtime_compatibility.json` | Spine 4.0 skeleton, Unity 6000 프로젝트, runtime import 위험 요약 |
| `Assets\RestoreData\reports\maininterface_spine40_unitypackage_pathnames.csv` | 다운로드한 Spine 4.0 unitypackage pathname 646개 |
| `Assets\RestoreData\reports\maininterface_hero1001_skeleton_versions.csv` | 1001 관련 `.skel.bytes` binary version 검출 결과 |
| `Assets\RestoreData\reports\maininterface_hero1001_spine_raw_textassets.csv` | raw TextAsset bytes 기반 1001 Spine 재추출 비교 |
| `Assets\RestoreData\reports\maininterface_spine40_probe_result.json` | Unity 6000 probe의 Spine 4.0 runtime import/compile 결과 |
| `Assets\RestoreData\reports\maininterface_spine40_hero1001_import_result.json` | probe 안 1001 SkeletonDataAsset 생성/로드 결과 |
| `Assets\RestoreData\reports\maininterface_spine40_hero1001_attach_capture_result.json` | probe 안 `UI_heroSpine` attach/capture 결과 |
| `Assets\RestoreData\hero1001_spine_source` | 적용용 1001 `.atlas.txt`, `.skel.bytes`, PNG source export |
| `Assets\RestoreData\hero1001_spine_source_raw` | 손상 없는 raw 1001 `.atlas.txt`, `.skel.bytes`, PNG source |
| `Assets\RestoreData\maininterface_raycast_overrides.csv` | 현재 화면 state/raycast override 29개 |
| `Assets\RestoreData\reports\maininterface_xlua_asset_format.csv` | xLua TextAsset prefix/패킹 상태 |
| `Assets\RestoreData\reports\maininterface_xlua_modules.csv` | MainInterface XLua TextAsset 목록과 암호화/패킹 여부 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_BUTTON_HANDLER_CANDIDATES.md` | 사람이 읽는 Button 핸들러 후보 요약 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_XLUA_LOADER_ANALYSIS.md` | 사람이 읽는 xLua loader/LuaCom 바인딩 요약 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_XXTEA_STATIC_ARRAYS.md` | 사람이 읽는 XXTEA 정적 배열 회수 요약 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_XLUA_RAW_TEXTASSETS.md` | 사람이 읽는 raw TextAsset 재추출 요약 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_XLUA_DECODE_ATTEMPTS.md` | 사람이 읽는 xLua 직접 decode 실험 요약 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_LUA_HANDLER_SCAN.md` | 사람이 읽는 decoded Lua 핸들러 스캔 요약 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_BUTTON_LUA_HANDLER_JOIN.md` | 사람이 읽는 Button별 decoded Lua handler 조인 요약 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_CLICK_VALIDATION.md` | 사람이 읽는 Button hit-stack/클릭 로그 검증 요약 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_CLICK_BLOCKER_ANALYSIS.md` | 사람이 읽는 blocked active Button 원인/복원 순서 요약 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_COORDINATE_SYSTEM_REBASE.md` | 사람이 읽는 좌표계 실패 원인/1680 기준 재정렬 요약 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TEXT_FONT_LAYOUT_ANALYSIS.md` | 사람이 읽는 Text/TMP/font/right route layout 문제 분석 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TMP_FONT_ASSET_INVENTORY.md` | 사람이 읽는 TMP FontAsset/atlas/uifont bundle 인벤토리 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TMP_COMPILE_PROBE_RESULT.md` | 사람이 읽는 Unity 6000 TMP compile/create probe 결과 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_VISUAL_MISMATCH_CAUSE_AND_REVISED_DIRECTION.md` | 현재 캡처가 틀린 이유와 수정 방향 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_HERO_SPINE_RESTORE_PLAN.md` | 사람이 읽는 1001 기본 홈 캐릭터 Spine 복원 계획 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_SPINE_RUNTIME_COMPATIBILITY.md` | 사람이 읽는 Spine 4.0 / Unity 6000 호환성 판단 및 probe 순서 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_HERO1001_SPINE_RAW_TEXTASSETS.md` | 사람이 읽는 raw Spine TextAsset 재추출/손상 비교 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_SPINE40_PROBE_RESULT.md` | 사람이 읽는 Unity 6000 probe runtime import 결과 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_SPINE40_HERO1001_IMPORT_RESULT.md` | 사람이 읽는 1001 SkeletonDataAsset import 결과 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_SPINE40_HERO1001_ATTACH_CAPTURE_RESULT.md` | 사람이 읽는 1001 SkeletonGraphic attach/capture 결과 |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_1680x720.png` | 1001 Spine attach full probe capture |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_hero_only_1680x720.png` | 1001 Spine attach hero-only probe capture |
| `C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_variant_*_1680x720.png` | 1001 Spine 후보 레이어 조합 full/hero-only 캡처 |
| `C:\Users\godho\Downloads\girlswar\il2cpp_native\il2cpp_xlua_target_disassembly.asm` | xLua/XXTEA 대상 ARM64 disassembly |
| `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua` | 복원된 MainInterface Lua 36개 |

## CMD 확인 순서

실행 CMD 폴더:

`C:\Users\godho\Downloads\girlswar\_restore_tools`

추천 확인 순서:

0. `00_START_HERE_GIRLSWAR_RESTORE_MENU.cmd`
   - 검증/빌드/캡처/클릭 검증/리포트 열기를 메뉴에서 고른다.
1. `04_VERIFY_MAININTERFACE_OUTPUTS.cmd`
   - Scene 존재 여부, RectTransform/Image/Sprite/Button 수, Sprite PNG 개수를 확인한다.
2. `01_OPEN_MAININTERFACE_UNITY_PROJECT.cmd`
   - Unity 프로젝트를 연다.
3. `10_OPEN_MAININTERFACE_SCENE_FILE.cmd`
   - 생성된 Scene 파일 위치를 바로 연다.
4. `08_OPEN_MAININTERFACE_RESTORED_SPRITES.cmd`
   - 복사된 Sprite PNG 폴더를 확인한다.
5. `09_SHOW_MAININTERFACE_SPRITE_SUMMARY.cmd`
   - 아직 안 붙은 Sprite 참조 상위 20개를 확인한다.
6. `11_BUILD_MAININTERFACE_RESTORED_BACKGROUND.cmd`
   - 창 없이 백그라운드에서 다시 Scene을 생성한다.
7. `03_SHOW_MAININTERFACE_BUILD_LOG.cmd`
   - Unity 로그에서 `Applied sprites: 214/977`, `Applied texts: 138/495`, `Applied scroll rects: 3/12`, `Applied button click loggers: 77/261`, `Exiting batchmode successfully`를 확인한다.
8. `16_OPEN_MAININTERFACE_REPORTS.cmd`
   - Button, Raycast, ScrollRect, Text, Image CSV 보고서 폴더를 연다.
9. `17_REBUILD_MAININTERFACE_BUTTON_HANDLER_REPORT.cmd`
   - Button 핸들러 후보 보고서를 다시 생성한다.
10. `18_OPEN_MAININTERFACE_BUTTON_HANDLER_REPORT.cmd`
   - 사람이 읽는 핸들러 후보 MD를 연다.
11. `19_OPEN_GIRLSWAR_TOOLS.cmd`
   - 분석 스크립트가 들어 있는 `_restore_tools\scripts` 폴더를 연다.
12. `20_REBUILD_MAININTERFACE_XLUA_BINDINGS.cmd`
   - xLua loader, TextAsset prefix, LuaComGroups 보고서를 다시 생성한다.
13. `21_OPEN_MAININTERFACE_XLUA_LOADER_REPORT.cmd`
   - 사람이 읽는 xLua loader 분석 MD를 연다.
14. `22_EXTRACT_IL2CPP_NATIVE_FROM_XAPK.cmd`
   - xapk 안의 `global-metadata.dat`, `libil2cpp.so`를 `il2cpp_native` 폴더로 추출한다.
15. `23_DISASSEMBLE_MAININTERFACE_XLUA_TARGETS.cmd`
   - xLua/XXTEA/Security 주요 RVA 17개를 ARM64 disassembly로 다시 생성한다.
16. `24_OPEN_IL2CPP_NATIVE_FOLDER.cmd`
   - 추출된 native 파일과 ASM 결과 폴더를 연다.
17. `25_TRACE_XXTEA_STATIC_ARRAYS.cmd`
   - `SoketKey`, `ass`, `DecryptByteArray` magic, metadata offset을 다시 추적한다.
18. `26_TRY_MAININTERFACE_XLUA_DECODE.cmd`
   - raw TextAsset CSV가 있으면 이를 우선 사용해 SecurityUtil.Xor 포함 decode 실험 720개를 다시 실행한다.
19. `27_OPEN_XLUA_DECODE_REPORT.cmd`
   - 사람이 읽는 xLua decode 실험 MD를 연다.
20. `28_OPEN_XXTEA_STATIC_ARRAY_REPORT.cmd`
   - 사람이 읽는 XXTEA 정적 배열 MD를 연다.
21. `29_EXTRACT_XLUA_RAW_TEXTASSETS.cmd`
   - MainInterface xLua TextAsset 36개를 `surrogateescape` raw bytes로 다시 추출한다.
22. `30_DECODE_XLUA_WITH_SECURITY_XOR.cmd`
   - raw TextAsset 추출 후 `SecurityUtil.xorScale`로 36개 Lua를 다시 복원한다.
23. `31_OPEN_XLUA_RAW_TEXTASSET_REPORT.cmd`
   - 사람이 읽는 raw TextAsset 재추출 MD를 연다.
24. `32_OPEN_DECODED_XLUA_FOLDER.cmd`
   - 복원된 `.lua` 36개 폴더를 연다.
25. `33_SCAN_DECODED_LUA_HANDLERS.cmd`
   - decoded Lua에서 `AddListener`, `AddBtnClickListener`, `EventSystem.AddListener`를 CSV/MD로 다시 스캔한다.
26. `34_OPEN_DECODED_LUA_HANDLER_REPORT.cmd`
   - 사람이 읽는 decoded Lua handler scan MD를 연다.
27. `35_JOIN_BUTTONS_WITH_LUA_HANDLERS.cmd`
   - Unity Button/LuaCom 보고서와 decoded Lua handler scan을 조인한다.
28. `36_OPEN_BUTTON_LUA_HANDLER_JOIN_REPORT.cmd`
   - 사람이 읽는 Button별 Lua handler 조인 MD를 연다.
29. `37_VALIDATE_MAININTERFACE_BUTTON_CLICKS.cmd`
   - MainInterface Button hit-stack 검증을 백그라운드 Unity batchmode로 실행한다.
30. `38_OPEN_MAININTERFACE_CLICK_VALIDATION_REPORT.cmd`
   - 사람이 읽는 Button 클릭 검증 MD를 연다.
31. `39_ANALYZE_MAININTERFACE_CLICK_BLOCKERS.cmd`
   - 남은 active blocker를 종류별로 다시 분류한다. 현재 기준 active blocker는 0개다.
32. `40_OPEN_MAININTERFACE_CLICK_BLOCKER_ANALYSIS.cmd`
   - 사람이 읽는 blocker 분석 MD를 연다.
33. `41_OPEN_MAININTERFACE_RAYCAST_OVERRIDES.cmd`
   - 현재 화면 state/raycast override CSV를 연다.
34. `48_ANALYZE_MAININTERFACE_COORDINATE_SYSTEM.cmd`
   - `UI_MainInterface` root 0x0, `UI_bg` 1680x720, Lua 화면폭 clamp 증거를 다시 분석한다.
35. `49_OPEN_MAININTERFACE_COORDINATE_SYSTEM_REPORT.cmd`
   - 사람이 읽는 좌표계 재정렬 MD를 연다.
36. `66_ANALYZE_MAININTERFACE_TEXT_FONT_LAYOUT.cmd`
   - TMP-like 텍스트, OS fallback 폰트, 오른쪽 route 라벨 상태를 분석한다.
37. `67_OPEN_MAININTERFACE_TEXT_FONT_LAYOUT_REPORT.cmd`
   - 사람이 읽는 Text/font/layout 분석 MD를 연다.
38. `61_EXTRACT_HERO1001_SPINE_RAW_TEXTASSETS.cmd`
   - 손상된 text export 대신 raw TextAsset bytes로 1001 `.skel.bytes`를 다시 추출한다.
39. `58_IMPORT_HERO1001_SPINE_IN_PROBE.cmd`
   - 격리 probe 안에서 raw 1001 atlas/skel을 Spine `SkeletonDataAsset`으로 import한다.
40. `63_ATTACH_CAPTURE_HERO1001_SPINE_IN_PROBE.cmd`
   - probe의 `UI_heroSpine` 아래에 1001 Spine 레이어를 붙이고 그래픽 모드 full/hero-only 캡처를 만든다.
41. `64_OPEN_HERO1001_SPINE_PROBE_CAPTURE_REPORT.cmd`
   - attach/capture 결과 MD를 연다.
42. `65_OPEN_HERO1001_SPINE_PROBE_CAPTURE_IMAGES.cmd`
   - full/hero-only, layer별, 후보 variant 캡처 PNG를 연다.

## 다음 복원 작업

1. Button 실제 동작 추적
   - persistent `onClick`은 비어 있으므로 XLua/IL2CPP 런타임 바인딩을 따라가야 한다.
   - 현재는 모든 버튼에 검증 로그가 붙어 있다.
   - 현재 확보한 직접 증거와 LuaCom 조인은 `MAININTERFACE_BUTTON_HANDLER_CANDIDATES.md`에 정리했다.
   - xLua loader/IL2CPP RVA는 `MAININTERFACE_XLUA_LOADER_ANALYSIS.md`에 정리했다.
   - `SoketKey`/`ass`는 static으로 회수했고, MainInterface xLua는 `SecurityUtil.xorScale` 반복 XOR 경로로 평문 36개까지 복원했다.
   - decoded Lua handler scan으로 UI listener 206개, EventSystem listener 126개, 고유 UI target 131개를 뽑았다.
   - Button/Lua 조인으로 module+target 정확 매칭 39개, 후보 module+target 매칭 21개, target-name-only 1개, 미매칭 16개를 분리했다.
   - Button hit-stack 검증으로 active 24개 중 24개가 실제 클릭 로그까지 호출됐고, active blocker는 0개다.
   - inactive/source-state Button 53개는 원본 증거로 유지하고, 현재 화면 state는 `maininterface_raycast_overrides.csv`로 분리했다.
   - 다음 단계는 TMP material preset/font scale과 right route state를 정리한 뒤, `main_only` 본체 Spine을 1차 적용 후보로 두고 sorting/sibling order를 맞추는 것이다.

2. Mask/CanvasGroup 보강
   - root 밖 prefab에 속한 ScrollRect 9개는 현재 Scene에서 제외한다.
   - 현재 root 안 ScrollRect 3개는 content/viewport/RectMask2D까지 연결했다.
   - root 내부 투명 Raycast 후보 27개는 보고서로 분리했고, 큰 non-button blocker와 invisible blocker 후보는 0개다.
   - 다음 단계에서 `guide_mask`, `but_mask`, `UI_touchSpine`, `boxcollider`, redpoint 계열이 의도된 hit area인지 클릭 캡처로 확인한다.

3. 캡처 검증
   - Unity 일반 그래픽 모드에서 `Assets/RestoreCaptures/maininterface_restored_1680x720.png`를 만들었다.
   - 현재 캡처 visible pixel은 1,201,680이고, 겹친 설정창/popup prefab은 root 필터링으로 제거했다.
   - `1280x720` 기준 캡처는 형태 복원 실패로 취소했고, 좌표계 분석은 `MAININTERFACE_COORDINATE_SYSTEM_REBASE.md`에 분리했다.
   - 버튼 클릭 로그 24개는 `unity_maininterface_click_validation.log`와 `MAININTERFACE_CLICK_VALIDATION.md`로 검증했다.
   - 현재 캡처의 텍스트/폰트는 원본 정적 glyph/atlas와 shared material 적용 후 단계다. 다만 route 라벨 크기/위치가 아직 어긋나므로 route active state, zero/tight RectTransform, font scale/autosize, sibling/sorting 정리가 남았다.
   - 1001 Spine probe 캡처는 성공했고 후보 variant 캡처도 생성했다. `main_only`가 1차 적용 후보이며, `front/name/back`은 홈 화면을 과하게 덮으므로 실제 Lua branch 근거 없이는 기본 적용하지 않는다.

## 지켜야 할 기준

`C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt` 기준을 그대로 따른다.

- 좌표만 복원하지 않는다.
- 전체 atlas를 UI 요소처럼 쓰지 않는다.
- TMP-like 텍스트를 기본 `UnityEngine.UI.Text`로 대체하고 정상이라고 판단하지 않는다.
- 반투명 overlay를 최종 화면에 남기지 않는다.
- 흰 박스 placeholder를 남기지 않는다.
- 버튼은 로그로 실제 클릭 가능 여부를 확인한다.
- 캡처 검증 없이 완료 처리하지 않는다.

