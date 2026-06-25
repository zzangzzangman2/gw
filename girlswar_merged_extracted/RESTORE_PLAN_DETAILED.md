# GirlsWar UI / Content Restore Plan

기준 산출물: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted`  
원본 패키지: `com.girlwars.kr`  
XAPK / AppVersion: `1.0.37`, versionCode `41`  
ResourceVersion: `1.0.787`  
Unity 기준 버전: `2020.2.1f1` (clean UnityFS bundle header 기준)

## 1. 목표

이 문서는 APK/XAPK, 최신 앱 데이터, AssetBundle, UI 좌표 CSV, TextAsset, 이미지 추출물을 기반으로 게임을 복원하는 정확한 작업 계획이다.

복원은 두 갈래로 나눈다.

1. 원본 앱 실행 복원: split APK 설치 후 최신 `Android/data/com.girlwars.kr`를 붙여 넣어 원본 게임 상태를 되살린다.
2. Unity 재구성 복원: 추출된 prefab/root, RectTransform, sprite slice, config, XLua/IL2CPP 정보를 이용해 화면과 컨텐츠를 새 Unity 프로젝트에 재구성한다.

중요한 원칙은 "이미지를 비슷하게 덮어그리는 것"이 아니라 원본 UI 계층, sprite slice, 마스크, 레이어 순서, 입력 이벤트를 되살리는 것이다.

## 2. 현재 산출물 인벤토리

| 항목 | 값 |
|---|---:|
| 병합 후보 파일 | 7,814 |
| 중복 제거 후 병합 파일 | 5,757 |
| 중복 경로 | 1,712 |
| Unity assetbundle | 1,996 |
| Unity 파싱 성공 | 1,904 |
| 오디오 추출 생략 | 92 |
| Unity 파싱 실패 | 0 |
| Unity 오브젝트 | 719,459 |
| UI RectTransform | 129,147 |
| UI 텍스트 필드 | 68,261 |
| 이미지 PNG 저장 | 28,836 |
| TextAsset 저장 | 20,182 |
| clean UnityFS slice | 1,795 |
| IL2CPP dump 파일 | 98 |

## 3. 폴더 역할

| 경로 | 역할 |
|---|---|
| `split_apks/` | XAPK 내부 APK. `adb install-multiple` 설치용 |
| `restore_overlay/Android/data/com.girlwars.kr/` | 기기에 바로 복사할 최신 앱 데이터 |
| `merged_content/AssetBundles/` | XAPK `abassets.apk` + 최신 `files/build` + 최신 `files/download` 병합본 |
| `extracted/unity/clean_unityfs_slices/` | prefix 제거 후 `UnityFS`부터 시작하는 분석용 번들 |
| `extracted/unity/bundles/` | 번들별 구조 JSONL, 이미지, TextAsset 추출물 |
| `extracted/config_zips/` | hero/item/quest/story 등 config zip 해제 결과 |
| `extracted/il2cpp_dump/` | `dump.cs`, `script.json`, `stringliteral.json`, `il2cpp.h` |
| `indexes/assetbundles.csv` | 번들별 offset, parse status, object count |
| `indexes/unity_bundle_export_map.csv` | 원본 번들 경로와 `extracted/unity/bundles/b_...` 폴더 매핑 |
| `indexes/ui_recttransforms.csv` | UI 위치, anchor, pivot, size, parent/child ID |
| `indexes/ui_texts.csv` | MonoBehaviour에서 추출된 UI 텍스트 |
| `indexes/unity_images.csv` | Texture2D/Sprite PNG 추출 위치와 실패 사유 |
| `indexes/unity_textassets.csv` | TextAsset 추출 위치 |
| `indexes/conflicts.csv` | 중복 경로별 어떤 파일을 최신으로 남겼는지 기록 |

## 4. 절대 규칙

1. RectTransform 좌표만으로 배치하지 않는다. 반드시 parent, sibling order, anchor, pivot, sizeDelta, localScale, active state를 함께 복원한다.
2. atlas 전체 이미지를 UI 요소처럼 쓰지 않는다. Sprite name, rect, border, pivot으로 slice 단위 복원한다.
3. 원본 overlay는 참고용이다. 최종 화면에 반투명 overlay가 남아 있으면 실패다.
4. 흰 박스를 임시로 남기지 않는다. sprite 누락이면 투명 처리하거나 정확한 대체 sprite를 찾는다.
5. 버튼은 보이는 것과 동작하는 것이 별개다. Button, Raycast Target, CanvasGroup, EventSystem, 상위 blocker를 함께 검증한다.
6. 캡처 없이 완료 처리하지 않는다. Unity `-nographics` 캡처만으로 정상 판정하지 않는다.
7. Unity 명령은 로그의 완료 문구까지 확인한다. 콘솔이 먼저 반환되어도 백그라운드 프로세스가 남을 수 있다.
8. 한 화면씩 끝낸다. 전체 화면을 대충 동시에 만들지 않는다.
9. 원본/추출/분석 파일은 삭제하지 않는다. 어떤 화면이 어떤 번들을 사용했는지 먼저 기록한다.

## 4.1 2026-06-25 MainInterface 진행 상태

Unity 복원 프로젝트:

`C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity`

메인 확인 문서:

`C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_RESTORE_STATUS.md`

현재 `download/ui/uiprefabandres/maininterface.assetbundle`은 `UI_MainInterface` root 기준으로 Scene 생성, sprite/text 적용, 버튼 로그, 레이캐스트 후보 분석, 그래픽 캡처까지 검증했다.

| 항목 | 결과 |
|---|---:|
| 현재 Scene root | `UI_MainInterface` |
| RectTransform 복원 | 806 |
| Sprite PNG 실제 적용 | 214 |
| Text 컴포넌트 적용 | 138 |
| Text/font/layout audit | 완료 |
| 원본 TMP-like Text rows | 271 / 495 |
| right route TMP-like Text rows | 49 / 70 |
| 현재 SceneBuilder 폰트 상태 | OS fallback `Malgun Gothic`/`Arial`, 원본 TMP 아님 |
| UI font assetbundle 근거 | 104개 (`download/ui/uifont/japanese/...`) |
| TMP/shader target bundle inventory | 105개 (`uifont` 104 + `tmpshaders` 1) |
| TMP FontAsset structured rows | 54 |
| uifont Material / Texture2D type count | 107 / 81 |
| 추출된 TMP atlas/image PNG | 73 |
| Unity 6000 TMP compile/create probe | `tmp_compile_ok`, `TextMeshProUGUI`, compile errors 0 |
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
| MainInterface 좌표계 기준 | `1680x720` 후보 |
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
| 캡처 visible pixel | 1,203,057 |
| Unity batchmode 생성 | 성공, return code 0 |
| Hero 1001 raw Spine TextAsset 재추출 | 8개, 이전 text export 손상 확인 |
| Spine 4.0 Unity 6000 probe | runtime import/compile 확인, soft import exception만 존재 |
| Hero 1001 SkeletonDataAsset probe import | 4개 생성/로드 성공 |
| Hero 1001 probe SkeletonGraphic attach/capture | 성공, Unity/log return code 0 |
| Hero 1001 probe full capture | `1,203,061` visible pixels |
| Hero 1001 probe hero-only capture | `1,166,048` visible pixels |
| Hero 1001 candidate variant capture | 10개 생성: full 5개, hero-only 5개 |
| Hero 1001 1차 적용 후보 | `main_only` = `Painting_1001` only |
| Hero 1001 `main_only` hero-only capture | `402,344` visible pixels, bounds `379,0 - 1451,719` |

Sprite는 `maininterface_sprite_map.csv`에서 `sprite_ref`의 fileID/pathID가 추출 PNG와 정확히 맞는 경우만 적용했다. 매칭 안 된 Image는 흰 박스로 남기지 않고 투명 처리했다. 현재 Scene은 전체 bundle이 아니라 `UI_MainInterface` prefab root 하위만 필터링한다.

중요 정정: `1280x720` 강제 캡처 방향은 형태 복원 실패로 취소한다. `UI_MainInterface` root는 prefab 내부에서 0x0이고, 런타임 UI root/Canvas 아래에 mount되어야 child anchor와 size가 의미를 갖는다. `UI_bg`는 1680x720이고, decoded `UI_MainPage` Lua는 `Screen.width * GameEntry.Instance.StandardHeight / Screen.height`를 `MinWidth`/`MaxWidth`로 clamp한다. 현재 MainInterface 복원 기준은 `1680x720` 후보로 재정렬했으며, 이는 좌표계 교정일 뿐 화면 완성 판정이 아니다. 남은 핵심 시각 작업은 TMP/font/material 기반 텍스트 복원, `UI_heroSpine` / `UI_touchSpine`의 Spine/Live2D 런타임 렌더러, 동적 텍스트/state, 누락 sprite 보강이다.

텍스트/폰트 정정: 현재 캡처의 글씨 위치와 폰트는 정상 복원으로 보면 안 된다. 전체 텍스트 495개 중 271개가 TMP-like 원본 컴포넌트이고, 오른쪽 route 라벨 70개 중 49개도 TMP-like다. 현재 `MainInterfaceSceneBuilder`는 이를 모두 `UnityEngine.UI.Text`와 `Malgun Gothic`/`Arial` fallback으로 렌더하므로 원본 `m_fontAsset`, `m_fontMaterial`, alignment, margin, character/line spacing, SDF material 효과가 사라진다. `download/ui/uifont/japanese` font/TMP assetbundle 104개와 `commonprefabsandres/tmpshaders.assetbundle`을 복원 기준으로 삼아야 한다.

2026-06-25 14:50 기준 TMP FontAsset inventory도 추가했다. `download/ui/uifont/japanese/tmp`에서 TMP FontAsset structured row 54개와 atlas/image PNG 73개가 확인됐고, family 후보는 `Arial Unicode MS`, `DFMincho-SU`, `DFPMincho-SU`, `Impact`, `KswKashin`, `tway_sky` 등이다. `type_counts.json`에는 Material 107개와 Texture2D 81개가 잡히지만 현재 구조 덤프에는 Material/Texture tree가 빠져 있으므로, 먼저 TMP FontAsset metric/pathID/atlas PNG로 `TextMeshProUGUI` 복원 패스를 세우고, SDF face/outline/shader property가 필요한 폰트는 uifont bundle을 Material/Texture 포함 모드로 재추출한다.

2026-06-25 14:53 기준 격리 Unity 6000 TMP compile probe도 성공했다. `using TMPro`와 `TextMeshProUGUI` component 생성이 compile errors 0으로 통과했으며, Unity 6000에서는 TMP runtime이 `com.unity.ugui` 2.0에 포함된다. 따라서 main 프로젝트에 새 package를 무작정 추가하기보다, 기존 `com.unity.ugui` 위에서 `MainInterfaceSceneBuilder`에 UGUI/TMP 분기를 추가하는 방향으로 진행한다.

추가 정정: 기본 홈 캐릭터는 `Painting_1001.png` atlas page를 통째 Image로 붙이는 방식이 아니다. decoded `UI_MainPage`는 `UIUtil.GetPlayerBigSpineAll(i, UI_heroSpine, "homePara", ...)`를 호출하고, 1001번 `DTmodelEntity.homePara`는 `[1,0,0]`이다. `paintingprefabandres/1001.assetbundle`에는 GameObject 317개, RectTransform 317개, CanvasRenderer 317개, SkeletonGraphic-like Behaviour 7개가 있으며, `Painting_1001.atlas.txt`는 117개 region으로 구성된다. 적용용 raw source는 `girlswar_maininterface_unity\Assets\RestoreData\hero1001_spine_source_raw`에 복사했다. 기존 text export의 `.skel.bytes`는 replacement byte가 섞여 손상됐으므로 더 이상 적용 기준으로 쓰지 않는다.

공식 `spine-unity 4.0` 런타임은 `_restore_tools\work`의 Unity 6000 격리 probe에서 import/compile을 확인했고, raw 1001 `SkeletonDataAsset` 4개도 생성/로드했다. 이어 `UI_heroSpine` 아래에 `Painting_1001_back`, `Painting_1001`, `Painting_1001_front`, `SP_heroname_1001`을 `SkeletonGraphic`으로 붙인 그래픽 캡처까지 성공했다. 결과는 `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_SPINE40_HERO1001_ATTACH_CAPTURE_RESULT.md`와 `reports\maininterface\captures`에 있다. 후보 variant 10개를 추가 캡처한 결과, `Painting_1001` 본체만 켠 `main_only`가 현재 1차 적용 후보이고, `front/name/back`은 캐릭터 얼굴, 중앙 UI, 또는 `UI_bg`를 덮을 수 있어 기본 홈에 항상 켜면 안 된다. 다음 작업은 `main_only` 기준으로 sorting/sibling order를 맞추고, 원본 prefab의 독립 root set과 `Painting_1001_1` child set 중 실제 홈 branch 레이어 조합을 추가 확정하는 것이다.

상호작용 보고서는 `Assets\RestoreData\reports` 아래에 있다. `maininterface_root_raycast_report.csv`는 투명 hit area 후보 27개를 분리했고, `maininterface_button_handler_candidates.csv`는 root Button 인스턴스 77개를 이름 기준 56개로 묶어 직접 증거/XLua 후보 모듈을 매핑한다. `maininterface_button_luacom_join.csv`는 Unity Button 컴포넌트 pathID와 `LuaComGroups` Type 4 바인딩을 조인하며, root 내부 버튼 47개가 정확 매칭된다.

`download/xlualogic/modules/maininterface.assetbundle`의 TextAsset 본문은 저장 상태에서 `A-EV` 32개, `K7HT` 4개 prefix로 시작한다. IL2CPP dump 기준 로더 축은 `LuaManager.LoadUIScript`, `LuaManager.GetLuaBuff`, `LuaManager.MyLoader`, `XXTEAUtil.DecryptByteArray`, `YouYouUtil.SecurityUtil.Xor`이다. `XXTEAUtil..cctor`에서 `SoketKey`와 `ass`는 회수했지만, MainInterface xLua TextAsset 36개는 `DecryptByteArray` magic `0C 07 08 0D 0B 09`로 시작하지 않는다. 실제 경로는 `LuaManager.GetLuaBuff`가 raw `TextAsset.bytes`를 읽은 뒤 `SecurityUtil.xorScale` 22바이트 반복 XOR을 적용하는 방식이며, 이 경로로 36개 모두 Lua 평문으로 복원했다.

`girl1.xapk` 안의 `com.girlwars.kr.apk`에서 `global-metadata.dat`, `config.arm64_v8a.apk`에서 `libil2cpp.so`도 추출했다. `maininterface_il2cpp_xlua_disassembly.csv`와 `il2cpp_xlua_target_disassembly.asm`에는 `LuaManager.GetLuaBuff`, `LuaManager.LoadUIScript`, `XXTEAUtil.DecryptByteArray`, `XXTEAUtil..cctor`, `SecurityUtil.Xor`, `SecurityUtil..cctor`, `XXTEAUtil.Decrypt(byte[])`, `XXTEAUtil.Base64Decode` 등 17개 target의 RVA/file offset/ARM64 snippet이 있다. `XXTEAUtil.DecryptByteArray`에서는 `0c 07 08 0d 0b 09` 매직 검사 흐름이 보이고, `SecurityUtil.Xor`에서는 `buffer[i] ^= xorScale[i % 22]` 반복 XOR 흐름이 보인다.

decoded Lua 36개는 `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua`에 저장했다. decoded Lua handler scan으로 UI listener 206개, EventSystem listener 126개, 고유 UI target 131개를 추출했다. decoded Lua와 Unity Button/LuaCom 조인 결과는 module+target 정확 매칭 39개, 후보 module+target 매칭 21개, target-name-only 매칭 1개, 미매칭 16개다. Unity Scene의 `RestoreClickLogger`는 이 조인 CSV를 읽어 `luaModule`, `luaHandler`, `luaConfidence`, `luaEvent`를 로그에 함께 출력한다. Button hit-stack 검증도 추가했고, `maininterface_raycast_overrides.csv` 29개 규칙으로 투명 반복 activity item과 같은 슬롯 state stack을 현재 화면 state로 분리했다. 현재 active 버튼 24개는 모두 실제 `[GirlsWarRestore][Click]` 로그까지 호출되며, active blocker는 0개다. 다음 작업은 probe에서 확인한 1001 Spine layer 조합을 실제 홈 branch에 맞게 줄이고, `UI_touchSpine` hit area 복원, 동적 텍스트/state, 누락 sprite 순서로 진행하는 것이다.

## 5. 1차 복원: 원본 앱 실행 복원

목표: 추출물을 편집하지 않고 기기에서 원본 앱을 최신 데이터 상태로 실행한다.

### 5.1 준비

1. Android USB 디버깅을 켠다.
2. PC에서 `adb devices`로 기기가 보이는지 확인한다.
3. 작업 폴더로 이동한다.

```powershell
cd C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted
```

### 5.2 자동 복원

```powershell
.\install_and_restore_adb.ps1
```

스크립트가 하는 일:

1. `split_apks/com.girlwars.kr.apk`
2. `split_apks/config.arm64_v8a.apk`
3. `split_apks/abassets.apk`
4. 위 세 개를 `adb install-multiple`로 설치
5. 앱 강제 종료
6. `restore_overlay/Android/data/com.girlwars.kr`를 `/sdcard/Android/data/`로 push
7. 앱 강제 종료

### 5.3 수동 복원

```powershell
adb install-multiple `
  C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\split_apks\com.girlwars.kr.apk `
  C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\split_apks\config.arm64_v8a.apk `
  C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\split_apks\abassets.apk

adb shell am force-stop com.girlwars.kr
adb push C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\restore_overlay\Android\data\com.girlwars.kr /sdcard/Android/data/
adb shell am force-stop com.girlwars.kr
```

### 5.4 Android/data 복사 실패 시

Android 11 이상에서 `/sdcard/Android/data` 쓰기가 막히면 아래 순서로 진행한다.

1. `adb push restore_overlay\Android\data\com.girlwars.kr /sdcard/Download/com.girlwars.kr_restore`
2. 기기 파일 관리자, Shizuku 지원 파일 관리자, 또는 root 파일 관리자로 `/sdcard/Android/data/com.girlwars.kr`에 이동
3. 이동 후 앱 강제 종료 및 재실행
4. `files/AppVersion = 1.0.37`, `files/ResourceVersion = 1.0.787` 확인

## 6. 2차 복원: Unity 재구성 복원

목표: 추출된 UI/컨텐츠를 새 Unity 프로젝트 또는 기존 복원 프로젝트에 구조적으로 재구성한다.

### 6.1 프로젝트 기준

| 항목 | 기준 |
|---|---|
| Unity 버전 | `2020.2.1f1` 우선 |
| 기준 해상도 | 화면별 원본 기준값 우선. MainInterface는 현재 `1680x720` 후보 |
| CanvasScaler | `Scale With Screen Size` |
| Match | 1차 `0.5`, 캡처 비교 후 조정 |
| 폰트 | 한국어 fallback 필수 |
| 입력 | EventSystem + GraphicRaycaster + Button/Toggle/ScrollRect 검증 |

`unity.ver`는 평문으로 읽히지 않았으므로, clean UnityFS bundle header에서 확인한 `2020.2.1f1`을 기준으로 잡는다.

### 6.2 데이터 소스 우선순위

1. UI 계층: `indexes/ui_recttransforms.csv`
2. 원본 tree 전체: `extracted/unity/bundles/b_*/structure.jsonl.gz`
3. 번들 매핑: `indexes/unity_bundle_export_map.csv`
4. 이미지/sprite: `indexes/unity_images.csv` + `structure.jsonl.gz`의 Sprite type tree
5. 텍스트: `indexes/ui_texts.csv`
6. 컨텐츠 데이터: `extracted/config_zips/download/config/*`
7. 로직/모듈: `download/xlualogic/modules/*.assetbundle`의 TextAsset 및 IL2CPP dump
8. 로딩 offset/암호화 확인: `indexes/assetbundles.csv`, `IL2CPP_FINDINGS.md`

## 7. 화면별 원본 매핑

아래 표는 첫 복원 라운드에서 고정할 화면별 출처다. `ui/uiprefabandres`는 prefab/root, `artsources/uispriteres`는 sprite, `xlualogic/modules`와 `config_zips`는 로직/컨텐츠 기준으로 본다.

| 우선순위 | 화면/시스템 | prefab/root 후보 | sprite 후보 | 로직/컨텐츠 후보 | 검증 포인트 |
|---|---|---|---|---|---|
| P0 | 공통 UI | `download/ui/uiprefabandres/common*.assetbundle` | `uicommonother`, `uibutton`, `uiitems/*` | `xlualogic/modules/common.assetbundle` | 버튼, 팝업, 공통 재화, 스크롤, 마스크 |
| P0 | 메인 홈 | `download/ui/uiprefabandres/maininterface.assetbundle`, `maininterface_ext_*` | `uimaininterface`, `uimaininterface2` | `xlualogic/modules/maininterface.assetbundle` | 하단/측면 route 버튼, 재화, 알림, 배너 |
| P0 | 도시/메인시티 | `city.assetbundle`, `city_ext_prefabs.assetbundle` | `uicity` | `modules/city`, `datatable/create/city` | 홈에서 이동, 건물 버튼, 레이어 순서 |
| P0 | 전투 | `battle.assetbundle`, `battle_ext_prefabs.assetbundle` | `uibattle`, `uibufficon`, battlemap bundles | `modules/battle`, `battleskillscript`, `battlebuffscript`, `config/maps`, `monster`, `skillact` | 전투 HUD, 스킬 버튼, HP/버프, 맵 배치 |
| P0 | 편성/진형 | `buzhen.assetbundle`, `lineup_ext_prefabs.assetbundle` | hero head, role/battle prefab resources | `modules/formation`, `proto/formation` | 슬롯, 드래그/선택, 캐릭터 카드 |
| P0 | 가방/창고 | `bag.assetbundle`, `bag_ext_prefabs.assetbundle` | `uibag`, `uiitems/*`, `uiequipmentic` | `modules/bag`, `config/item`, `equip` | 아이템 그리드, 필터 탭, 상세 패널 |
| P0 | 임무/퀘스트 | `quest.assetbundle`, `quest_ext_1.assetbundle` | 공통 버튼/보상 sprite | `modules/quest`, `config/quest`, `story` | 수령 버튼, 진행도, 탭, 보상 아이콘 |
| P1 | 길드 | `guild.assetbundle`, `guild_ext_prefabs.assetbundle`, `guildterritory_*` | `uiguild`, `uiguildicon`, `uiguildterritory` | `modules/guild`, `config/guild` | 길드 홈, 멤버 리스트, 전투/영지 버튼 |
| P1 | 타워 | `tower.assetbundle`, `tower_ext_*`, `tower_ext_prefabs` | `uitower` | `modules/tower`, `proto/tower` | 층 리스트, 도전 버튼, 보상 |
| P1 | 모험/원정 | `adventure.assetbundle`, `adventure_ext_prefabs` | `uiadventure` | `modules/expedition`, `config/maps` | 지도/챕터, 이동 버튼 |
| P1 | 결제/상점 | `charge*.assetbundle`, `shangdian_ext_prefabs.assetbundle` | `uicharge`, `uichargewheel` | `modules/shop`, `proto/shop`, `datatable/create/shop` | 상품 카드, 가격, 구매 버튼 로그 |
| P1 | 결혼/호감도 | `marry.assetbundle`, `marry_ext_prefabs` | `uimarry`, `uihaogandu` | `modules/marry`, `config/hero` | 캐릭터 선택, 호감도/상태 |
| P1 | 도감/영웅 | `tujian.assetbundle`, `heroshow.assetbundle`, hero ext bundles | `uitujian`, `uiherohead*` | `modules/tujian`, `modules/heroshow`, `config/hero` | 캐릭터 리스트, 상세, 별/등급 |
| P1 | 메일/랭킹/친구 | UI bundle 존재 여부 추가 확인 | 공통 sprite | `modules/mail`, `ranklist`, `friend` | 리스트/버튼/닫기 동작 |
| P2 | 이벤트 | `act*_ext_prefabs.assetbundle`, `deepsea_ext_prefabs`, `actsauntered_ext_prefabs` 등 | `uiact*`, 이벤트 전용 sprite | `modules/act`, `config/activity` | 기간/탭/보상/이동 |
| P2 | 스토리 | `storyres/storychapters/*`, story prefab resources | `uistory` | `modules/story`, `config/story` | 대사, 배경, 캐릭터, 진행 버튼 |

## 8. 화면 하나를 복원하는 정확한 순서

예시는 `maininterface` 기준이지만 모든 화면에 같은 순서를 적용한다.

### 8.1 원본 번들 export 폴더 찾기

```powershell
Import-Csv C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\indexes\unity_bundle_export_map.csv |
  Where-Object { $_.bundle -eq "download/ui/uiprefabandres/maininterface.assetbundle" }
```

결과의 `export_dir` 아래에 `structure.jsonl.gz`, `images/`, `textassets/`, `type_counts.json`이 있다.

### 8.2 RectTransform 행 추출

```powershell
Import-Csv C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\indexes\ui_recttransforms.csv |
  Where-Object { $_.bundle -eq "download/ui/uiprefabandres/maininterface.assetbundle" } |
  Export-Csv .\maininterface_rects.csv -NoTypeInformation -Encoding UTF8
```

복원에 반드시 쓰는 필드:

- `path_id`
- `game_object_id`
- `game_object_name`
- `game_object_active`
- `father_id`
- `child_ids`
- `anchor_min_x/y`
- `anchor_max_x/y`
- `anchored_pos_x/y`
- `size_delta_x/y`
- `pivot_x/y`
- `local_pos_x/y/z`
- `local_scale_x/y/z`

### 8.3 계층 복원

1. `path_id`별 GameObject를 만든다.
2. `father_id`와 `child_ids`로 parent-child를 연결한다.
3. `child_ids` 순서를 sibling order로 사용한다.
4. `game_object_active`를 반영한다.
5. RectTransform 값은 모두 원본대로 넣는다.
6. parent size가 정해지기 전에는 child 위치를 확정하지 않는다.
7. root Canvas/Panel 크기와 CanvasScaler를 고정한 뒤 다시 좌표를 검증한다.

### 8.4 Sprite 복원

1. `unity_images.csv`에서 해당 화면의 Sprite/Texture PNG를 찾는다.
2. `structure.jsonl.gz`의 Sprite type tree에서 `m_Rect`, `m_Border`, `m_Pivot`, `m_PixelsToUnits`를 확인한다.
3. atlas 전체 PNG를 Image로 넣지 않는다.
4. 버튼/패널은 border 값이 있으면 9-slice로 만든다.
5. image export 실패 항목은 `unity_images.csv`의 `error`를 보고 처리한다.
   - `cannot convert float NaN to integer`, `Singular matrix`류는 Sprite 변환 실패다.
   - 이 경우 clean bundle을 Unity/AssetStudio/UnityPy 재시도로 열거나 같은 atlas의 원본 rect를 사용해 재추출한다.
   - 임시 흰 박스 금지. 못 찾으면 일단 투명 placeholder + TODO 로그로 남긴다.

### 8.5 텍스트/폰트 복원

1. `ui_texts.csv`에서 해당 bundle 행을 찾는다.
2. `field`가 `m_Text`, `m_text`인 값을 우선 사용한다.
3. TextMeshPro 계열과 UnityEngine.UI.Text 계열을 구분한다.
4. 한국어 fallback 폰트를 설정한다.
5. 텍스트 overflow, line spacing, alignment를 `structure.jsonl.gz`의 MonoBehaviour tree에서 확인한다.

### 8.6 Button / Toggle / Scroll 복원

1. MonoBehaviour tree에서 `m_OnClick`, `m_TargetGraphic`, `m_Interactable`, `m_Navigation`이 있는 컴포넌트를 버튼 후보로 본다.
2. Image tree에서 `m_RaycastTarget` 값을 확인한다.
3. CanvasGroup tree에서 `m_Alpha`, `m_Interactable`, `m_BlocksRaycasts`를 확인한다.
4. ScrollRect, Mask, RectMask2D, Viewport 구조를 먼저 만든 뒤 리스트 아이템을 넣는다.
5. 실제 기능이 아직 없어도 모든 버튼에 `Debug.Log("[UI] maininterface.btn_x clicked")`를 연결한다.

### 8.7 캡처 검증

한 화면마다 아래 캡처를 남긴다.

1. 화면별 원본 기준 해상도. MainInterface 현재 후보는 `1680x720`
2. 16:9
3. 19.5:9 모바일
4. 작은 모바일 해상도

검증 기준:

- overlay 잔상 없음
- atlas 통짜 노출 없음
- 흰 박스 없음
- 글자 잘림 없음
- 버튼 클릭 로그 확인
- 탭/닫기/수령/이동 버튼 동작 확인
- ScrollRect가 패널 밖으로 새지 않음
- 최종 캡처 PNG를 직접 눈으로 확인

## 9. 컨텐츠 복원 순서

컨텐츠는 UI보다 config가 기준이다. 화면에 보이는 리스트/카드/보상은 하드코딩하지 않고 config에서 생성한다.

| 컨텐츠 | 기준 폴더 |
|---|---|
| 영웅 | `extracted/config_zips/download/config/hero` |
| 아이템 | `extracted/config_zips/download/config/item` |
| 장비 | `extracted/config_zips/download/config/equip` |
| 퀘스트 | `extracted/config_zips/download/config/quest` |
| 맵 | `extracted/config_zips/download/config/maps` |
| 몬스터 | `extracted/config_zips/download/config/monster` |
| 스킬 | `extracted/config_zips/download/config/skillact` |
| 스토리 | `extracted/config_zips/download/config/story` |
| 소환수 | `extracted/config_zips/download/config/summonpet` |
| 시스템 | `extracted/config_zips/download/config/sys` |
| 보물 | `extracted/config_zips/download/config/treasure` |
| 속옷/의상 계열 | `extracted/config_zips/download/config/underwear` |
| 이벤트 | `extracted/config_zips/download/config/activity` |

복원 순서:

1. config 파일 형식 확인
2. ID/name/icon/resource reference 컬럼 찾기
3. 아이콘 reference가 `artsources/uispriteres/uiitems/*`와 연결되는지 확인
4. UI 프리팹 리스트 셀에 config 데이터를 바인딩
5. 없는 리소스는 `assetbundles.csv`와 `VersionFile`에서 경로 역추적
6. 화면마다 샘플 데이터 3개 이상 렌더링
7. 실제 스크롤/상세/수령/이동 버튼 로그 연결

## 10. IL2CPP / AssetBundle 처리 기준

확인된 사실:

- 많은 `.assetbundle`은 파일 시작이 `UnityFS`가 아니다.
- 내부에 prefix 뒤 `UnityFS`가 있고, 게임은 Unity `AssetBundle.LoadFromFile(path, crc, offset)` 계열로 읽는 구조다.
- IL2CPP dump에 `FlatAssetBundleInfoEntity.ResOffset`, `IsEncrypt`, `MD5`, `Size`가 있다.
- 추출 파이프라인은 `ResOffset` 또는 `UnityFS` scan으로 1,904개 번들을 실패 없이 파싱했다.
- `XXTEAUtil.DecryptByteArray`의 magic prefix `0c 07 08 0d 0b 09`는 병합 winning set에서 0개라, 현재 UI AssetBundle 복원 핵심은 XXTEA가 아니라 offset 기반 UnityFS 처리다.

따라서 복원 프로젝트에서 원본 번들을 직접 읽어야 할 경우:

1. `indexes/assetbundles.csv`의 `used_offset`을 확인한다.
2. `used_offset > 0`이면 clean slice를 사용하거나 Unity LoadFromFile offset을 사용한다.
3. 새 프로젝트에 import할 때는 `extracted/unity/clean_unityfs_slices`를 우선 사용한다.

## 11. 작업 단계와 완료 조건

### Phase 0. 기준 고정

작업:

- `README.md`, `IL2CPP_FINDINGS.md`, `summary.json` 확인
- 원본 `girl1.xapk`, `com.girlwars.kr`, `girlswar_merged_extracted` 백업
- Unity `2020.2.1f1` 프로젝트 준비

완료 조건:

- 결과 폴더 경로와 버전 기록 완료
- 원본 파일 삭제 금지 상태 확정

### Phase 1. 복원 도구/Importer 작성

작업:

- `ui_recttransforms.csv`를 읽어 GameObject/RectTransform 생성
- `unity_bundle_export_map.csv`로 bundle -> export folder 매핑
- `structure.jsonl.gz`를 읽어 Sprite, MonoBehaviour, CanvasGroup, Mask, ScrollRect 정보 검색
- `unity_images.csv`, `unity_textassets.csv`, `ui_texts.csv` 연결

완료 조건:

- 전체 bundle의 2,404개 RectTransform 중 화면 root별 분리가 끝남
- `UI_MainInterface` root는 806개 RectTransform으로 생성됨
- active state, sibling order, anchor/pivot/size/localScale 반영됨
- 다른 prefab root가 겹쳐 뜨지 않는 그래픽 캡처가 확보됨

### Phase 2. 공통 UI + 메인 홈

작업:

- `common*.assetbundle`, `uibutton`, `uicommonother`, `uiitems/*` 우선 복원
- `maininterface.assetbundle`과 `uimaininterface*` 연결
- route 버튼에 로그 연결
- overlay 없이 캡처

완료 조건:

- 홈 화면 버튼들이 모두 클릭 로그 출력
- 흰 박스 없음
- atlas 통짜 노출 없음
- 16:9/19.5:9 캡처 통과

### Phase 3. 핵심 플레이 화면

작업 순서:

1. `city`
2. `battle`
3. `buzhen` / `lineup`
4. `bag`
5. `quest`

완료 조건:

- 각 화면별 root prefab 계층 복원
- 리스트/카드/버튼/탭 로그 연결
- config 기반 샘플 데이터 표시
- ScrollRect/Mask 정상

### Phase 4. 컨텐츠/시스템 화면

작업 순서:

1. `guild`
2. `tower`
3. `adventure` / `expedition`
4. `charge` / `shop`
5. `marry` / `haogandu`
6. `tujian` / hero screens
7. `mail`, `ranklist`, `friend`

완료 조건:

- 각 화면 최소 1개 정상 캡처
- 주요 버튼 로그
- config 데이터 바인딩
- 누락 sprite 목록 별도 기록

### Phase 5. 이벤트/스토리 확장

작업:

- `act*_ext_prefabs`, `deepsea_ext_prefabs`, `actsauntered_ext_prefabs` 등 이벤트 UI 복원
- `config/activity`와 연결
- `storyres/storychapters/*`는 story config와 함께 복원

완료 조건:

- 이벤트 화면별 source mapping 작성
- 기간/보상/탭/이동 버튼 검증
- 스토리 배경/캐릭터/대사 흐름 샘플 검증

### Phase 6. 최종 검증 후 빌드

작업 순서:

1. 코드 수정
2. 씬 생성
3. Unity 로그 완료 문구 확인
4. 그래픽 모드 캡처
5. PNG 직접 확인
6. 클릭 검증
7. Windows 빌드
8. Android 빌드
9. 실제 실행 확인

완료 조건:

- Unity 로그에 scene generated / verification passed / Build Finished Success 등 완료 문구 존재
- 캡처 PNG 보관
- 버튼 로그 보관
- 빌드 실행 확인

## 12. 실패 판정 기준

아래 중 하나라도 있으면 해당 화면은 완료가 아니다.

- 원본 overlay가 최종 화면에 남음
- atlas 전체가 UI 조각처럼 보임
- 흰 박스/기본 Image가 노출됨
- 좌표는 맞아 보이나 parent/anchor가 틀려 해상도 변경 시 깨짐
- 버튼이 보이지만 클릭 로그가 없음
- 상위 투명 패널이 raycast를 막음
- ScrollRect 내용이 viewport 밖으로 삐져나옴
- TMP/UI.Text 구분 없이 폰트가 깨짐
- 캡처 없이 빌드만 완료 처리
- source bundle과 sprite 출처 기록 없이 임시 리소스 사용

## 13. 화면별 작업 기록 템플릿

각 화면마다 아래 형식의 기록을 남긴다.

```markdown
## Screen: maininterface

- prefab/root bundle:
- sprite bundle:
- logic module:
- config source:
- export folder:
- RectTransform rows:
- Text rows:
- Image rows:
- Missing sprites:
- Buttons:
- Masks/ScrollRects:
- Capture files:
- Validation result:
```

## 14. 즉시 다음 액션

1. `_restore_tools\48_ANALYZE_MAININTERFACE_COORDINATE_SYSTEM.cmd`로 1680x720 좌표계 후보, root 0x0, Lua screen-fit 근거를 확인한다.
2. `_restore_tools\50_ANALYZE_MAININTERFACE_HERO_SPINE_1001.cmd`로 1001 `homePara`, `paintingprefabandres/1001`, atlas region, source export를 확인한다.
3. `_restore_tools\51_OPEN_MAININTERFACE_HERO_SPINE_PLAN.cmd`로 `UI_heroSpine` 복원 계획을 열고, atlas 통짜 Image 방식이 아닌 Spine runtime 적용 순서를 따른다.
4. `_restore_tools\52_ANALYZE_SPINE_RUNTIME_COMPATIBILITY.cmd`로 1001 `.skel.bytes` binary version, 현재 Unity `6000.4.9f1`, 공식 Spine 4.0 unitypackage 상태를 확인한다.
5. `_restore_tools\53_OPEN_SPINE_RUNTIME_COMPATIBILITY_REPORT.cmd`를 열고, 메인 복원 프로젝트에 바로 import하지 말아야 하는 조건을 확인한다.
6. `_restore_tools\61_EXTRACT_HERO1001_SPINE_RAW_TEXTASSETS.cmd`로 손상 없는 raw 1001 `.skel.bytes`를 추출한다. 완료.
7. `_restore_tools\55_RUN_SPINE40_PROBE_IMPORT.cmd`와 `_restore_tools\56_ANALYZE_SPINE40_PROBE_RESULT.cmd`로 메인 프로젝트를 건드리지 않는 Unity 6000 격리 probe runtime import를 검증한다. 완료.
8. `_restore_tools\58_IMPORT_HERO1001_SPINE_IN_PROBE.cmd`와 `_restore_tools\59_ANALYZE_HERO1001_SPINE_PROBE_IMPORT.cmd`로 raw 1001 `SkeletonDataAsset` 4개를 생성/로드한다. 완료.
9. `_restore_tools\63_ATTACH_CAPTURE_HERO1001_SPINE_IN_PROBE.cmd`로 `UI_heroSpine` 아래에 1001 `SkeletonGraphic` layers를 붙이고 full/hero-only 그래픽 캡처를 만든다. 완료.
10. `_restore_tools\64_OPEN_HERO1001_SPINE_PROBE_CAPTURE_REPORT.cmd`와 `_restore_tools\65_OPEN_HERO1001_SPINE_PROBE_CAPTURE_IMAGES.cmd`로 probe 결과와 variant 캡처를 확인한다. 현재 `main_only`가 1차 적용 후보이고, `front/name/back`은 기본 홈 적용 보류다.
11. `_restore_tools\66_ANALYZE_MAININTERFACE_TEXT_FONT_LAYOUT.cmd`와 `_restore_tools\67_OPEN_MAININTERFACE_TEXT_FONT_LAYOUT_REPORT.cmd`로 TMP-like 텍스트, 원본 font bundle, 오른쪽 route 라벨 state 문제를 확인한다.
12. TMP-like 텍스트를 `TextMeshProUGUI`와 원본 font/material 기준으로 복원하고, right route의 `text_on` / `text_off` 및 selected/unselected state를 Lua branch 기준으로 필터링한다.
13. 원본 `paintingprefabandres/1001` 구조에서 독립 root set과 `Painting_1001_1` child set 중 실제 홈 branch가 쓰는 조합을 확정하고, `UI_bg` 별도 로드와 충돌하지 않게 `Painting_1001` 본체부터 main 복원 프로젝트에 붙인다.
14. `_restore_tools\04_VERIFY_MAININTERFACE_OUTPUTS.cmd`로 현재 Scene, sprite, 캡처, 상호작용, Button/LuaCom, xLua loader, Button/Lua handler 조인, Button click validation 요약을 확인한다.
15. `_restore_tools\38_OPEN_MAININTERFACE_CLICK_VALIDATION_REPORT.cmd`로 active 24개, clickable 24개, active blocker 0개 상태를 확인한다.
16. `_restore_tools\41_OPEN_MAININTERFACE_RAYCAST_OVERRIDES.cmd`로 현재 화면 state/raycast override 29개를 확인한다.
17. `UI_touchSpine`는 터치/드래그 hit area로 복원하되 투명 Image가 배경 버튼 raycast를 막지 않게 한다.
16. `autoHelper_Root`처럼 touch/down/up/drag 계열은 버튼 click과 별도 EventTrigger로 분리한다.
17. `candidate_module_and_target` 21개는 반복 prefab/list item 가능성이 높으므로 `UI_MainPageActItem` 같은 item module과 함께 검증한다.
18. `missing` 16개는 시각 버튼, 동적 생성 항목, 또는 다른 module/runtime 등록 경로 가능성이 있으므로 decoded Lua 검색과 클릭 로그로 분류한다.
19. 동적 텍스트/state와 누락 sprite를 보강해 `maininterface_restored_1680x720.png`의 시각 복원도를 높인다.
20. `guide_mask`, `but_mask`, `UI_touchSpine`, `boxcollider`, redpoint 계열 투명 Raycast 후보가 의도된 hit area인지 클릭 로그와 캡처로 검증한다.
21. `maininterface_ext_*`, `common*.assetbundle`, `uibutton`, `uicommonother`, `uiitems/*`를 같은 규칙으로 추가 연결한다.
22. `city`로 넘어가기 전에 MainInterface의 ScrollRect 3개 동작과 보강 캡처를 실제 그래픽 모드에서 한 번 더 검증한다.

## 15. 참고 파일

- 규칙 원문: `C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt`
- 상세 추출 요약: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\README.md`
- IL2CPP 분석: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\IL2CPP_FINDINGS.md`
- 복원 스크립트: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\install_and_restore_adb.ps1`
- AssetBundle 상태: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\indexes\assetbundles.csv`
- UI 위치: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\indexes\ui_recttransforms.csv`
- UI 텍스트: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\indexes\ui_texts.csv`
- 이미지: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\indexes\unity_images.csv`
- TextAsset: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\indexes\unity_textassets.csv`
- MainInterface 상태: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_RESTORE_STATUS.md`
- MainInterface 버튼 후보: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_BUTTON_HANDLER_CANDIDATES.md`
- MainInterface xLua loader 분석: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_XLUA_LOADER_ANALYSIS.md`
- MainInterface Button/Lua handler 조인: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_BUTTON_LUA_HANDLER_JOIN.md`
- MainInterface Button 클릭 검증: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_CLICK_VALIDATION.md`
- MainInterface 좌표계 재정렬: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_COORDINATE_SYSTEM_REBASE.md`
- MainInterface Text/TMP/font 분석: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TEXT_FONT_LAYOUT_ANALYSIS.md`
- MainInterface 1001 Spine 복원 계획: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_HERO_SPINE_RESTORE_PLAN.md`
- MainInterface Spine runtime 호환성: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_SPINE_RUNTIME_COMPATIBILITY.md`
- MainInterface Spine 4.0 probe 결과: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_SPINE40_PROBE_RESULT.md`
- MainInterface 1001 raw Spine TextAsset: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_HERO1001_SPINE_RAW_TEXTASSETS.md`
- MainInterface 1001 SkeletonData import: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_SPINE40_HERO1001_IMPORT_RESULT.md`
- MainInterface 1001 Spine attach/capture: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_SPINE40_HERO1001_ATTACH_CAPTURE_RESULT.md`
- MainInterface 1001 Spine captures: `C:\Users\godho\Downloads\girlswar\reports\maininterface\captures`
- MainInterface raycast override: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_raycast_overrides.csv`
- MainInterface native IL2CPP: `C:\Users\godho\Downloads\girlswar\il2cpp_native`
- MainInterface 보고서 폴더: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports`
- MainInterface 실행 CMD: `C:\Users\godho\Downloads\girlswar\_restore_tools\*.cmd`

