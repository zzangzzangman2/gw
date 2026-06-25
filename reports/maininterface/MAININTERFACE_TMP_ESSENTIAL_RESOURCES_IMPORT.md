# MainInterface TMP Essential Resources Import

작성 시각: 2026-06-25 15:07:56

## 결과

- package: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Library\PackageCache\com.unity.ugui@1f2d1ab0d950\Package Resources\TMP Essential Resources.unitypackage`
- project: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity`
- extracted assets: 33
- extracted meta: 38

## 풀린 핵심 파일

- `Assets/TextMesh Pro/Shaders/TMP_SDF-Mobile-2-Pass.shader`
- `Assets/TextMesh Pro/Shaders/TMP_Bitmap.shader`
- `Assets/TextMesh Pro/Shaders/TMP_SDF SSD.shader`
- `Assets/TextMesh Pro/Shaders/TMP_Bitmap-Mobile.shader`
- `Assets/TextMesh Pro/Resources/Fonts & Materials/LiberationSans SDF - Fallback.asset`
- `Assets/TextMesh Pro/Shaders/TMPro_Properties.cginc`
- `Assets/TextMesh Pro/Resources/TMP Settings.asset`
- `Assets/TextMesh Pro/Shaders/TMPro.cginc`
- `Assets/TextMesh Pro/Shaders/TMP_Bitmap-Custom-Atlas.shader`
- `Assets/TextMesh Pro/Shaders/TMP_SDF.shader`
- `Assets/TextMesh Pro/Resources/Fonts & Materials/LiberationSans SDF - Outline.mat`
- `Assets/TextMesh Pro/Shaders/TMP_SDF-Surface-Mobile.shader`
- `Assets/TextMesh Pro/Resources/Fonts & Materials/LiberationSans SDF.asset`
- `Assets/TextMesh Pro/Shaders/SDFFunctions.hlsl`
- `Assets/TextMesh Pro/Shaders/TMP_SDF-Mobile Overlay.shader`
- `Assets/TextMesh Pro/Shaders/TMP_SDF-Mobile Masking.shader`
- `Assets/TextMesh Pro/Shaders/TMPro_Mobile.cginc`
- `Assets/TextMesh Pro/Shaders/TMP_SDF-Mobile SSD.shader`
- `Assets/TextMesh Pro/Shaders/TMP_Sprite.shader`
- `Assets/TextMesh Pro/Shaders/TMPro_Surface.cginc`
- `Assets/TextMesh Pro/Shaders/TMP_SDF Overlay.shader`
- `Assets/TextMesh Pro/Resources/Fonts & Materials/LiberationSans SDF - Drop Shadow.mat`
- `Assets/TextMesh Pro/Shaders/TMP_SDF-Surface.shader`
- `Assets/TextMesh Pro/Shaders/TMP_SDF-Mobile.shader`

## 의미

Unity batch import가 TMP Essential Resources를 실제 `Assets/TextMesh Pro` 아래에 만들지 못한 상태였기 때문에, unitypackage를 직접 풀어서 TMP Settings, LiberationSans SDF, TMP shader를 프로젝트 자산으로 고정했다.

다음 단계는 SceneBuilder를 다시 실행해 `GirlsWarRestore_KoreanFallback_TMP.asset` 생성과 `TextMeshProUGUI.m_fontAsset` 비어 있음 여부를 검증하는 것이다.
