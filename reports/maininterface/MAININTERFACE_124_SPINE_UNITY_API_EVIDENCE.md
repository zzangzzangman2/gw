# MainInterface 124 Spine-Unity API Evidence

## Project Runtime

- Unity editor: `6000.4.9f1` from `girlswar_maininterface_unity/ProjectSettings/ProjectVersion.txt`.
- Runtime assembly definitions:
  - `Assets/Spine/Runtime/spine-unity.asmdef` defines `spine-unity` and references `spine-csharp`.
  - `Assets/Spine/Runtime/spine-csharp/spine-csharp.asmdef` defines `spine-csharp`.
- `Assets/Spine/Runtime/spine-csharp/package.json` reports `spine-csharp` version `4.0.0`.

## API Used By UI124

- `Assets/Spine/Runtime/spine-unity/Asset Types/SpineAtlasAsset.cs:53` exposes `SpineAtlasAsset.CreateRuntimeInstance(TextAsset atlasText, Material[] materials, bool initialize)`.
- `Assets/Spine/Runtime/spine-unity/Asset Types/SkeletonDataAsset.cs:79` and `:85` expose `SkeletonDataAsset.CreateRuntimeInstance(...)` overloads.
- `Assets/Spine/Runtime/spine-unity/Components/SkeletonGraphic.cs:164` exposes `SkeletonGraphic.NewSkeletonGraphicGameObject(SkeletonDataAsset skeletonDataAsset, Transform parent, Material material)`.
- `Assets/Spine/Runtime/spine-unity/Components/SkeletonGraphic.cs:172` exposes `SkeletonGraphic.AddSkeletonGraphicComponent(...)`.

## Previous Route Pattern Reused

- UI116 route replay already verified runtime availability by resolving `Spine.Unity.SkeletonGraphic`, `Spine.Unity.SkeletonDataAsset`, and `Spine.Unity.SpineAtlasAsset` in `Assets/Editor/MainInterface116RouteSpineRuntimeBridgeReplay.cs:67-69`.
- UI117-121 route traces validate that the route cluster uses real `SkeletonGraphic` components and spine UI material paths rather than interim bitmap fallbacks.
- UI118 specifically bound route UI materials from:
  - `Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicDefault.mat`
  - `Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicAdditive.mat`
  - `Assets/Spine/Runtime/spine-unity/Materials/SkeletonGraphicScreen.mat`

## UI124 Implementation Decision

- `Assets/Editor/MainInterface124Hero1005HomeSpineMount.cs` uses the same runtime family:
  - `SpineAtlasAsset.CreateRuntimeInstance(...)`
  - `SkeletonDataAsset.CreateRuntimeInstance(...)`
  - `SkeletonGraphic.NewSkeletonGraphicGameObject(...)`
- `Painting_1005.png` is used only as the atlas texture for the Spine material. It is not mounted as a whole UI `Image`.
- Default animation is `A`, loop `true`, matching the original painting prefab evidence recorded in UI123.
- `homePara=[1,0,0]` is recorded as source evidence only; UI124 does not overclaim its exact runtime transform semantics.

## Current Blocker

The hero now renders through real `SkeletonGraphic`, but reference match is still false. The remaining blocker is normal-home state reconstruction: the route/world cluster is still active and `right` draws above `UI_heroSpine` by sibling-order evidence.
