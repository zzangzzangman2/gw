# GirlsWar merged/extracted package

생성일: 2026-06-25

## 핵심 결과

- 패키지: `com.girlwars.kr`
- XAPK: `1.0.37` / versionCode `41`
- 최신 데이터 AppVersion: `1.0.37`
- 최신 데이터 ResourceVersion: `1.0.787`
- 병합 후보 파일: `7,814`
- 중복 제거 후 병합 파일: `5,757`
- 중복 경로: `1,712`
- Unity assetbundle: `1,996`
- Unity 파싱 성공: `1,904`
- 오디오라 추출 생략: `92`
- UI RectTransform 행: `129,147`
- 이미지 PNG 추출: `28,836`
- TextAsset 추출: `20,182`

## 폴더 구조

- `split_apks/`: XAPK 내부 split APK와 manifest. `adb install-multiple`에 바로 사용.
- `restore_overlay/Android/data/com.girlwars.kr/`: 최신 앱 데이터 원본 구조. 기기에 붙여넣기/adb push용.
- `merged_content/AssetBundles/`: XAPK `abassets.apk` + 최신 `files/build` + 최신 `files/download`를 하나로 합친 통합 리소스. 같은 경로가 중복되면 최신 `files/download`/root 파일이 우선.
- `extracted/config_zips/`: config zip 파일을 풀어둔 결과.
- `extracted/unity/`: 오디오를 제외한 Unity assetbundle 추출 결과.
- `extracted/unity/clean_unityfs_slices/`: 앞부분 prefix가 있던 번들을 `UnityFS` 오프셋부터 잘라낸 분석용 번들.
- `extracted/il2cpp_dump/`: Il2CppDumper 산출물 복사본.
- `indexes/`: 병합/충돌/버전/AssetBundle/UI/이미지/TextAsset CSV 인덱스.

## 바로 적용

1. Android USB 디버깅을 켠 뒤 `adb devices`에서 기기가 보이는지 확인.
2. 이 폴더에서 `install_and_restore_adb.ps1` 실행.
3. 수동으로 할 경우 APK는 `split_apks/*.apk`를 `adb install-multiple`로 설치하고, `restore_overlay/Android/data/com.girlwars.kr` 폴더를 기기의 `/sdcard/Android/data/` 아래에 복사.

## 분석 메모

- 오디오는 원본 병합본에는 보존했지만 Unity 오브젝트 추출에서는 생략했습니다.
- 일부 assetbundle은 파일 시작이 `UnityFS`가 아니며, IL2CPP의 `ResOffset`/Unity offset 로딩 구조에 맞춰 오프셋부터 파싱했습니다.
- 자세한 IL2CPP/암호화/오프셋 분석은 `IL2CPP_FINDINGS.md`를 보세요.
