# MainInterface Spine Runtime Compatibility

Generated: 2026-06-25 13:43:01

## Verdict

1001 home skeleton is Spine 4.0.x, but the restore project is Unity 6000. Do not import the 4.0 runtime into the main project as a blind final step.

`UI_heroSpine` 복원은 단순 배치 문제가 아니다. 1001 기본 홈 캐릭터는 Spine binary skeleton과 atlas를 실제 `spine-unity` 런타임으로 묶어야 하며, 현재 프로젝트에는 그 런타임이 없다.

## Current Evidence

| 항목 | 값 |
| --- | --- |
| Unity project | `6000.4.9f1` |
| Unity revision | `6000.4.9f1 (f7258d6eebbe)` |
| Installed Unity editors | `6000.4.9f1` |
| Project manifest mentions Spine | `False` |
| Real Spine runtime in restore project | `False` |
| Official Spine 4.0 package downloaded | `True` |
| Spine 4.0 package size | `6881350` |
| Spine 4.0 package sha256 | `4a89ff00d727f9c2d67da1838edf7dc2463dc79059a4aaaa27723e84be42836d` |
| Package pathname count | `646` |

## Skeleton Versions

| source | detected Spine binary version | bytes |
| --- | --- | --- |
| `Assets/RestoreData/hero1001_spine_source/battleprefabandres_1001_reference/1001.skel.bytes` | `4.0.64` | 681766 |
| `Assets/RestoreData/hero1001_spine_source/paintingprefabandres_1001/Painting_1001.skel.bytes` | `4.0.56` | 598675 |
| `Assets/RestoreData/hero1001_spine_source/paintingprefabandres_1001/Painting_1001_Back.skel.bytes` | `4.0.56` | 22847 |
| `Assets/RestoreData/hero1001_spine_source/paintingprefabandres_1001/Painting_1001_Front.skel.bytes` | `4.0.56` | 24512 |
| `Assets/RestoreData/hero1001_spine_source/paintingprefabandres_1001/SP_heroname_1001.skel.bytes` | `4.0.47` | 5166 |

Detected 1001 source is Spine `4.0.x`. This is why a `4.3` runtime should not be treated as interchangeable without re-exported skeleton data.

## Official Compatibility Constraint

Reference: `https://en.esotericsoftware.com/spine-unity-download`

- Current `spine-unity 4.3` targets Spine `4.3` data and supports Unity `2017.1-6000.4`.
- Legacy `spine-unity 4.0` targets Spine `4.0` data and officially supports Unity `2017.1-2022.1`.
- Spine binary skeletons are version-specific; a runtime cannot be assumed to load a different exported binary version.

That creates the actual mismatch:

| Requirement | What we have | Result |
| --- | --- | --- |
| Skeleton data version | `4.0.56` family | Needs Spine 4.0 runtime |
| Current restore Unity | `6000.4.9f1` | Outside official 4.0 Unity support |
| Installed editors | `6000.4.9f1` only | No exact Unity 2022 probe editor currently installed |

## Package Inspection

The downloaded unitypackage was inspected without importing it into the main restore project.

| pathname sample | kind |
| --- | --- |
| `Assets/Spine` | `spine_runtime` |
| `Assets/Spine Examples` | `example` |
| `Assets/Spine Examples/Getting Started` | `example` |
| `Assets/Spine Examples/Getting Started/1 The Spine GameObject.unity` | `example` |
| `Assets/Spine Examples/Getting Started/2 Controlling Animation.unity` | `example` |
| `Assets/Spine Examples/Getting Started/3 Controlling Animation Continued.unity` | `example` |
| `Assets/Spine Examples/Getting Started/4 Object Oriented Sample.unity` | `example` |
| `Assets/Spine Examples/Getting Started/5 Basic Platformer.unity` | `example` |
| `Assets/Spine Examples/Getting Started/6 SkeletonGraphic.unity` | `example` |
| `Assets/Spine Examples/Images` | `example` |
| `Assets/Spine Examples/Images/outline-shaders-heading.png` | `example` |
| `Assets/Spine Examples/Other Examples` | `example` |
| `Assets/Spine Examples/Other Examples/Animation Tester` | `example` |
| `Assets/Spine Examples/Other Examples/Animation Tester/Animation Tester.unity` | `example` |
| `Assets/Spine Examples/Other Examples/Animation Tester/SpineAnimationTesterTool.cs` | `csharp` |
| `Assets/Spine Examples/Other Examples/AtlasRegionAttacher.unity` | `example` |
| `Assets/Spine Examples/Other Examples/BlendModes.unity` | `example` |
| `Assets/Spine Examples/Other Examples/Drunkboy.unity` | `example` |
| `Assets/Spine Examples/Other Examples/FixedTimestepUpdates.unity` | `example` |
| `Assets/Spine Examples/Other Examples/Freezeboy.unity` | `example` |
| `Assets/Spine Examples/Other Examples/Instantiate from Script.unity` | `example` |
| `Assets/Spine Examples/Other Examples/Mix and Match Equip Assets` | `example` |
| `Assets/Spine Examples/Other Examples/Mix and Match Equip Assets/Goggles Normal.asset` | `example` |
| `Assets/Spine Examples/Other Examples/Mix and Match Equip Assets/Goggles Tactical.asset` | `example` |
| `Assets/Spine Examples/Other Examples/Mix and Match Equip Assets/Gun Freeze.asset` | `example` |

Full package path list:

- `Assets/RestoreData/reports/maininterface_spine40_unitypackage_pathnames.csv`

## Project Runtime Scan

Runtime candidates found in the restore project:

- 없음

DummyDll files found in extracted IL2CPP output:

- `girlswar_merged_extracted/extracted/il2cpp_dump/DummyDll/spine-unity-examples.dll`
- `girlswar_merged_extracted/extracted/il2cpp_dump/DummyDll/spine-unity.dll`

Those DummyDll files are metadata stubs from Il2CppDumper and should not be used as a final Unity runtime.

## Safe Restore Plan

1. Keep `Painting_1001.png` out of normal Image placement. It is a Spine atlas page.
2. Keep the exported source in `Assets/RestoreData/hero1001_spine_source/paintingprefabandres_1001`.
3. Use `_restore_tools\55_RUN_SPINE40_PROBE_IMPORT.cmd` to create an isolated probe under `_restore_tools\work` before touching the main restore project.
4. Use `_restore_tools\56_ANALYZE_SPINE40_PROBE_RESULT.cmd` to prove whether the Unity 6000 probe imported cleanly.
5. In a clean probe, create/import `SkeletonDataAsset` from `Painting_1001.skel.bytes`, `Painting_1001.atlas.txt`, and the matching PNG pages.
6. Only after clean import/compile logs, attach the resulting `SkeletonGraphic`/prefab under `UI_MainInterface/middle/UI_heroSpine`.
7. Apply `DTmodelEntity.homePara=[1,0,0]`.
8. Capture the screen in graphics mode and compare visible shape, not just click logs.

## Do Not Mark Complete Until

- `UI_heroSpine` renders through real Spine runtime.
- The character is not a whole-atlas placeholder.
- The capture shows the home character occupying the correct middle area.
- Button/raycast validation still passes after the renderer is added.
- The restore plan records exact files, parent path, parameters, and validation output.

## Generated Files

- `Assets/RestoreData/reports/maininterface_spine_runtime_compatibility.json`
- `Assets/RestoreData/reports/maininterface_spine40_unitypackage_pathnames.csv`
- `Assets/RestoreData/reports/maininterface_hero1001_skeleton_versions.csv`
