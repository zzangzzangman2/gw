# MainInterface Hero Spine Restore Plan

작성 시각: 2026-06-25 14:32 KST

## 결론

현재 MainInterface가 형태를 제대로 못 맞춘 가장 큰 시각 원인은 `UI_heroSpine`가 비어 있기 때문이다. 기본 홈 분기에서는 atlas PNG를 Image로 붙이는 구조가 아니라, `UI_MainPage` Lua가 `UIUtil.GetPlayerBigSpineAll(heroDid, UI_heroSpine, "homePara", ...)`로 1001번 Spine prefab/skeleton을 런타임에 붙인다.

따라서 `Painting_1001.png`를 통째로 화면에 올리면 실패다. 이 파일은 여러 파츠가 들어간 Spine atlas page이고, 실제 복원은 `.atlas`, `.skel`, texture page, `SkeletonGraphic`/Spine runtime, `DTmodelEntity.homePara` 적용 순서로 해야 한다.

## 런타임 근거

| 근거 | 값 |
|---|---|
| 기본 캐릭터 로더 | `UIUtil.GetPlayerBigSpineAll(i, UI_heroSpine, "homePara", ...)` |
| 기본 배경 로더 | `UIUtil.GetPaintingBg(i)` 후 `GameTools:LoadSpriteWithFullPath(UI_bg, e, true)` |
| 결혼/특수 분기 | `UIUtil.GetPlayerLive2dModel(a, UI_heroSpine, ...)` |
| 1001 `homePara` | `[1,0,0]` |
| 1001 `paintingBg` | `"noalphabg_PaintingBG_1001"` |
| 1001 `bigPainting` | `"1001"` |
| 1001 `starHeroName` | `"Assets/Download/RolePrefabsAndRes/RoleBigSetPainting/1001/starHeroName_1001.png"` |
| 홈 skeleton binary | `Painting_1001=4.0.56`, `Front/Back=4.0.56`, `SP_heroname=4.0.47` |
| 복원 프로젝트 Spine runtime | 없음 - main 복원 프로젝트에는 아직 실제 spine-unity 런타임을 넣지 않았다 |
| runtime compatibility | main 직접 import 금지, `_restore_tools\work` probe에서 먼저 검증 |
| raw 1001 TextAsset 재추출 | 완료, 이전 `.skel.bytes` text export 손상 확인 |
| probe SkeletonDataAsset import | 4개 생성/로드 성공 |
| probe `UI_heroSpine` attach/capture | 성공, Unity/log return code 0 |
| probe candidate variants | 10개 생성, `main_only`를 1차 적용 후보로 판정 |

## `paintingprefabandres/1001` prefab 구조

| 항목 | 값 |
|---|---:|
| GameObject | 317 |
| RectTransform | 317 |
| CanvasRenderer | 317 |
| MonoBehaviour | 331 |
| SkeletonGraphic-like Behaviour | 7 |
| Root RectTransform | 5 |

| GameObject | start animation | loop | skeletonDataAsset |
|---|---:|---:|---|
| `SP_heroname_1001` | `A1` | `1` | `{"m_FileID":0,"m_PathID":-272527403155061953}` |
| `Painting_1001_back` | `A` | `1` | `{"m_FileID":0,"m_PathID":-8255640919415892518}` |
| `Painting_1001_front` | `A` | `1` | `{"m_FileID":0,"m_PathID":8230978638188859760}` |
| `Painting_1001` | `A` | `1` | `{"m_FileID":0,"m_PathID":2541412715913754079}` |
| `Painting_1001` | `A` | `1` | `{"m_FileID":0,"m_PathID":2541412715913754079}` |
| `Painting_1001_front` | `A` | `1` | `{"m_FileID":0,"m_PathID":8230978638188859760}` |
| `Painting_1001_back` | `A` | `1` | `{"m_FileID":0,"m_PathID":-8255640919415892518}` |

원본 root 구조상 같은 back/main/front 세트가 두 벌 있다. 독립 root 세트는 `Painting_1001_back`, `Painting_1001`, `Painting_1001_front`가 각각 father `0`이고, 다른 한 세트는 `Painting_1001_1` 아래 자식으로 `Painting_1001_back`, `Painting_1001`, `Painting_1001_front`가 들어간다. 기본 홈 Lua는 `UI_bg`를 별도로 로드하므로, probe에서 back/front/name을 모두 켠 캡처는 실제 렌더 가능성 증명이지 최종 레이어 조합 확정이 아니다.

## Probe 결과

| 항목 | 값 |
|---|---:|
| runtime probe | `C:\Users\godho\Downloads\girlswar\_restore_tools\work\spine40_unity6000_probe_20260625_134314` |
| raw source | `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001` |
| SkeletonDataAsset | 4개 생성/로드 성공 |
| attached layers | `Painting_1001_back`, `Painting_1001`, `Painting_1001_front`, `SP_heroname_1001` |
| full capture visible pixels | `1,203,061` |
| hero-only capture visible pixels | `1,166,048` |
| `main_only` hero-only visible pixels | `402,344`, bounds `379,0 - 1451,719` |
| `main_front_name` 판정 | 전경 나무/이름판이 얼굴과 중앙 UI를 덮어 기본 홈 적용 보류 |
| `all_layers_with_back` 판정 | 배경 계열이 전체 화면을 덮어 `UI_bg` 별도 로드와 충돌 가능 |
| result report | `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_SPINE40_HERO1001_ATTACH_CAPTURE_RESULT.md` |

시각 확인 결과 캐릭터는 실제 Spine으로 렌더된다. `Painting_1001`만 켠 `main_only`는 정상 캐릭터 본체 형태가 나오며 현재 1차 적용 후보로 둔다. 반대로 `main_front_name`은 전경 나무와 이름판이 캐릭터 얼굴 및 중앙 UI를 덮고, `all_layers_with_back`은 배경 계열까지 포함되어 `UI_bg`와 충돌한다. 다음 작업은 `main_only`를 기준으로 sorting/sibling order를 맞춘 뒤, `GetPlayerBigSpineAll`의 실제 홈 사용 조합, `Painting_1001_1` group 사용 여부, 독립 root set 사용 여부를 추가 확인하는 것이다.

## Atlas page 구조

| atlas | page | region count | first regions |
|---|---|---:|---|
| `-3577121971219907780_Painting_1001_Back.atlas.txt` | `Painting_1001_Back.png` | 3 | `bf_3, bgb, bgb2` |
| `3992961392396818130_SP_heroname_1001.atlas.txt` | `SP_heroname_1001.png` | 3 | `images/1001, images/sr, images/t3` |
| `5035273895345354139_Painting_1001.atlas.txt` | `Painting_1001.png` | 117 | `a00, a01, a0100, a0101, a0102, a0103, a0104, a0105, a0106, a0107, a0108, a0109` |
| `5395353901128918248_Painting_1001_Front.atlas.txt` | `Painting_1001_Front.png` | 4 | `bf_2, bf_5, bf_6, bgb1` |
| `-266615414835539183_1001.atlas.txt` | `1001.png` | 90 | `1, 2, 3, 4, 5, a11, a12, a13, a14, a15, a18, a19` |

## 1001 관련 AssetBundle

| bundle | status | size | extracted folder |
|---|---:|---:|---|
| `download/commonprefabsandres/spinematandshaders.assetbundle` | `ok` | `63615` | `extracted/unity/bundles/b_60f9c03224a30ca7` |
| `download/roleprefabsandres/battleprefabandres/1001.assetbundle` | `ok` | `615623` | `extracted/unity/bundles/b_b39866f560e64bb6` |
| `download/roleprefabsandres/paintingprefabandres/1001.assetbundle` | `ok` | `4246155` | `extracted/unity/bundles/b_4b5f2d65cb02985b` |
| `download/roleprefabsandres/rolebigsetpainting/1001.assetbundle` | `ok` | `640078` | `extracted/unity/bundles/b_56fb3732c538f3bd` |

`paintingprefabandres/1001`이 기본 MainInterface 캐릭터 렌더링의 1순위 소스다. `rolebigsetpainting/1001`은 정적 큰 그림/도감/랭킹 등 참고용이고, `battleprefabandres/1001`은 전투 skeleton이라 홈 기본 화면에 먼저 붙이면 안 된다.

## 추출된 핵심 파일

| 역할 | 파일 |
|---|---|
| 홈 캐릭터 skeleton | `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001.skel.bytes` |
| 홈 캐릭터 atlas | `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001.atlas.txt` |
| 홈 캐릭터 atlas page | `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001.png` |
| 전면 보조 skeleton | `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Front.skel.bytes` |
| 후면 보조 skeleton | `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/Painting_1001_Back.skel.bytes` |
| 런타임 배경 | `Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001/noalphabg_PaintingBG_1001.png` |

## 정확한 복원 순서

1. `extracted/il2cpp_dump/DummyDll/spine-unity.dll`은 타입 추정용 stub라 최종 런타임으로 믿으면 안 된다.
2. `_restore_tools\61_EXTRACT_HERO1001_SPINE_RAW_TEXTASSETS.cmd`로 raw TextAsset bytes를 재추출한다. 완료.
3. `_restore_tools\55_RUN_SPINE40_PROBE_IMPORT.cmd`로 격리 probe에 공식 `spine-unity 4.0` runtime을 import한다. 완료.
4. `_restore_tools\58_IMPORT_HERO1001_SPINE_IN_PROBE.cmd`로 raw `.atlas.txt`, `.skel.bytes`, PNG page를 Spine asset으로 묶는다. 완료.
5. `_restore_tools\63_ATTACH_CAPTURE_HERO1001_SPINE_IN_PROBE.cmd`로 `UI_heroSpine` 아래에 1001 `SkeletonGraphic` layers를 붙이고 graphics mode capture를 만든다. 완료.
6. `DTmodelEntity.homePara=[1,0,0]`를 scale/x/y 기준으로 적용한다. 1001은 현재 `[1,0,0]`이므로 임의 확대/이동을 하지 않는다.
7. `UI_bg`는 `paintingBg="noalphabg_PaintingBG_1001"`에 해당하는 `noalphabg_PaintingBG_1001.png`를 유지한다.
8. probe 후보 캡처 기준으로 `Painting_1001` 본체만 켠 `main_only`를 1차 적용 후보로 둔다.
9. `Painting_1001_back/front`, `SP_heroname_1001`, 독립 root set, `Painting_1001_1` child set은 실제 기본 홈 branch 근거가 있을 때만 조건부로 붙인다.
10. main 복원 프로젝트에 넣기 전 full/hero-only/variant별 그래픽 캡처를 다시 찍고, 배경/전경이 캐릭터와 UI를 비정상적으로 덮지 않는지 확인한다.
11. `UI_touchSpine`는 터치/드래그 hit area로만 복원하고, 투명 Image가 전체 버튼 raycast를 막지 않게 한다.

## 실패로 간주할 조건

- `Painting_1001.png` atlas page를 통째 UI Image로 붙인 경우.
- Unity 6000 메인 복원 프로젝트에 Spine 4.0 unitypackage를 probe 없이 바로 import한 경우.
- 캐릭터 없이 배경과 버튼만 보이는데 클릭 검증만 통과한 경우.
- `UI_heroSpine`/`UI_touchSpine`의 투명 Graphic이 배경 버튼을 막는 경우.
- `homePara`/원본 prefab 계층을 무시하고 수동 좌표로만 맞춘 경우.
- probe에서 캐릭터가 렌더됐다는 이유만으로 back/front 배경/전경 과덮임을 정상 처리하는 경우.
- `front/name/back`을 원본 home branch 근거 없이 기본 홈에 항상 켜는 경우.

## 생성된 분석 파일

- `Assets/RestoreData/reports/maininterface_hero1001_spine_summary.json`
- `Assets/RestoreData/reports/maininterface_hero1001_assets.csv`
- `Assets/RestoreData/reports/maininterface_hero1001_dtmodel_fields.csv`
- `Assets/RestoreData/reports/maininterface_hero1001_atlas_regions.csv`
- `Assets/RestoreData/reports/maininterface_hero1001_structure_roots.csv`
- `Assets/RestoreData/reports/maininterface_hero1001_spine_source_export.csv`
- `Assets/RestoreData/reports/maininterface_hero1001_spine_raw_textassets.csv`
- `Assets/RestoreData/reports/maininterface_spine_runtime_compatibility.json`
- `Assets/RestoreData/reports/maininterface_spine40_unitypackage_pathnames.csv`
- `Assets/RestoreData/reports/maininterface_hero1001_skeleton_versions.csv`
- `Assets/RestoreData/reports/maininterface_spine40_probe_result.json`
- `Assets/RestoreData/reports/maininterface_spine40_hero1001_import_result.json`
- `Assets/RestoreData/reports/maininterface_spine40_hero1001_attach_capture_result.json`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_1680x720.png`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_hero_only_1680x720.png`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\captures\maininterface_spine_hero1001_probe_variant_*_1680x720.png`
