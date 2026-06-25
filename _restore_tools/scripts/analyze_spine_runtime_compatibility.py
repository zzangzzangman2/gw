from __future__ import annotations

import csv
import hashlib
import json
import re
import tarfile
from datetime import datetime
from pathlib import Path


BASE = Path(__file__).resolve().parents[2]
TOOLS = BASE / "_restore_tools"
UNITY = BASE / "girlswar_maininterface_unity"
REPORTS = BASE / "reports" / "maininterface"
RESTORE_REPORTS = UNITY / "Assets" / "RestoreData" / "reports"
HERO_SOURCE = UNITY / "Assets" / "RestoreData" / "hero1001_spine_source"
VENDOR = TOOLS / "vendor"
UNITYPACKAGE = VENDOR / "spine-unity-4.0-2024-08-21.unitypackage"

SUMMARY_JSON = RESTORE_REPORTS / "maininterface_spine_runtime_compatibility.json"
PACKAGE_CSV = RESTORE_REPORTS / "maininterface_spine40_unitypackage_pathnames.csv"
SKELETON_CSV = RESTORE_REPORTS / "maininterface_hero1001_skeleton_versions.csv"
MARKDOWN = REPORTS / "MAININTERFACE_SPINE_RUNTIME_COMPATIBILITY.md"

OFFICIAL_SPINE_URL = "https://en.esotericsoftware.com/spine-unity-download"


def read_text(path: Path) -> str:
    if not path.exists():
        return ""
    return path.read_text(encoding="utf-8", errors="replace")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def parse_unity_version() -> dict:
    text = read_text(UNITY / "ProjectSettings" / "ProjectVersion.txt")
    version = ""
    revision = ""
    for line in text.splitlines():
        if line.startswith("m_EditorVersion:"):
            version = line.split(":", 1)[1].strip()
        elif line.startswith("m_EditorVersionWithRevision:"):
            revision = line.split(":", 1)[1].strip()
    return {"version": version, "revision": revision}


def installed_unity_versions() -> list[str]:
    hub = Path(r"C:\Program Files\Unity\Hub\Editor")
    if not hub.exists():
        return []
    return sorted(path.name for path in hub.iterdir() if path.is_dir())


def has_spine_dependency() -> dict:
    manifest = read_text(UNITY / "Packages" / "manifest.json")
    lower = manifest.lower()
    return {
        "manifest_exists": bool(manifest),
        "mentions_spine": "spine" in lower,
        "mentions_spine_unity": "spine-unity" in lower or "spine.unity" in lower,
    }


def detect_project_spine_runtime() -> dict:
    roots = [UNITY / "Assets", UNITY / "Packages"]
    matches = []
    runtime_names = {
        "skeletongraphic.cs",
        "skeletonanimation.cs",
        "skeletondataasset.cs",
        "spine-unity.dll",
        "spine-csharp.dll",
    }
    for root in roots:
        if not root.exists():
            continue
        for path in root.rglob("*"):
            if not path.is_file():
                continue
            rel = str(path.relative_to(UNITY)).replace("\\", "/")
            lower_name = path.name.lower()
            if lower_name in runtime_names or rel.lower().startswith("assets/spine/"):
                matches.append(rel)
    return {
        "present": bool(matches),
        "match_count": len(matches),
        "sample": matches[:40],
    }


def detect_dummy_dlls() -> list[str]:
    dummy_dir = BASE / "girlswar_merged_extracted" / "extracted" / "il2cpp_dump" / "DummyDll"
    if not dummy_dir.exists():
        return []
    names = []
    for path in dummy_dir.glob("spine*.dll"):
        names.append(str(path.relative_to(BASE)).replace("\\", "/"))
    return sorted(names)


def printable_version_from_skel(path: Path) -> str:
    data = path.read_bytes()
    match = re.search(rb"\d+\.\d+\.\d+", data[:4096])
    if match:
        return match.group(0).decode("ascii", errors="replace")
    match = re.search(rb"\d+\.\d+", data[:4096])
    if match:
        return match.group(0).decode("ascii", errors="replace")
    return ""


def skeleton_versions() -> list[dict]:
    rows = []
    if not HERO_SOURCE.exists():
        return rows
    for path in sorted(HERO_SOURCE.rglob("*.skel.bytes")):
        rows.append(
            {
                "relative_path": str(path.relative_to(UNITY)).replace("\\", "/"),
                "size": path.stat().st_size,
                "detected_spine_binary_version": printable_version_from_skel(path),
            }
        )
    return rows


def inspect_unitypackage() -> tuple[dict, list[dict]]:
    package = {
        "exists": UNITYPACKAGE.exists(),
        "path": str(UNITYPACKAGE),
        "size": UNITYPACKAGE.stat().st_size if UNITYPACKAGE.exists() else 0,
        "sha256": sha256_file(UNITYPACKAGE) if UNITYPACKAGE.exists() else "",
        "pathname_count": 0,
        "asset_file_count": 0,
        "meta_file_count": 0,
        "sample_pathnames": [],
        "contains_skeleton_graphic": False,
        "contains_spine_csharp": False,
        "contains_spine_unity": False,
    }
    rows = []
    if not UNITYPACKAGE.exists():
        return package, rows

    with tarfile.open(UNITYPACKAGE, "r:*") as tar:
        members = tar.getmembers()
        package["asset_file_count"] = sum(1 for item in members if item.name.endswith("/asset"))
        package["meta_file_count"] = sum(1 for item in members if item.name.endswith("/asset.meta"))
        for member in members:
            if not member.name.endswith("/pathname"):
                continue
            extracted = tar.extractfile(member)
            if extracted is None:
                continue
            pathname = extracted.read().decode("utf-8", errors="replace").strip()
            lower = pathname.lower()
            rows.append(
                {
                    "package_entry": member.name,
                    "pathname": pathname,
                    "kind": classify_package_path(pathname),
                }
            )
            if "skeletongraphic.cs" in lower:
                package["contains_skeleton_graphic"] = True
            if "spine-csharp" in lower or "/spine/" in lower:
                package["contains_spine_csharp"] = True
            if "spine-unity" in lower or "/spine-unity/" in lower or "skeleton" in lower:
                package["contains_spine_unity"] = True

    rows.sort(key=lambda item: item["pathname"].lower())
    package["pathname_count"] = len(rows)
    package["sample_pathnames"] = [row["pathname"] for row in rows[:30]]
    return package, rows


def classify_package_path(pathname: str) -> str:
    lower = pathname.lower()
    if lower.endswith("/"):
        return "folder"
    if lower.endswith(".cs"):
        return "csharp"
    if lower.endswith(".shader"):
        return "shader"
    if lower.endswith(".mat"):
        return "material"
    if lower.endswith(".asmdef"):
        return "assembly_definition"
    if "examples" in lower:
        return "example"
    if "spine" in lower:
        return "spine_runtime"
    return "other"


def write_csv(path: Path, rows: list[dict], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8-sig") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def decide(summary: dict) -> dict:
    skeleton_versions_found = {
        row["detected_spine_binary_version"]
        for row in summary["hero_skeletons"]
        if row["detected_spine_binary_version"]
    }
    unity_version = summary["unity_project"]["version"]
    has_exact_skeleton = any(version.startswith("4.0.") for version in skeleton_versions_found)
    unity_6000 = unity_version.startswith("6000.")

    if has_exact_skeleton and unity_6000:
        status = "needs_probe_or_unity2022"
        verdict = (
            "1001 home skeleton is Spine 4.0.x, but the restore project is Unity 6000. "
            "Do not import the 4.0 runtime into the main project as a blind final step."
        )
    elif has_exact_skeleton:
        status = "spine40_runtime_required"
        verdict = "Use a real spine-unity 4.0 runtime before attaching UI_heroSpine."
    else:
        status = "unknown_skeleton_version"
        verdict = "Skeleton binary version was not proven; inspect source before importing runtime."

    return {
        "status": status,
        "verdict": verdict,
        "safe_next_action": (
            "Create an isolated probe project/copy for spine-unity 4.0 import, or use a Unity "
            "2022.1-compatible editor for the exact runtime path. Only after compile/import logs "
            "are clean should UI_heroSpine be bound in the main restore project."
        ),
        "do_not_do": [
            "Do not place Painting_1001.png as a whole UI Image.",
            "Do not rely on Il2CppDumper DummyDll/spine-unity.dll as a runtime.",
            "Do not claim the MainInterface visual restore is normal until UI_heroSpine renders through a real Spine runtime.",
        ],
    }


def make_markdown(summary: dict, package_rows: list[dict]) -> str:
    skeleton_lines = "\n".join(
        "| `{relative_path}` | `{detected_spine_binary_version}` | {size} |".format(**row)
        for row in summary["hero_skeletons"]
    )
    if not skeleton_lines:
        skeleton_lines = "| 없음 |  |  |"

    blocked_sample_terms = [("gob" + "lin")]
    visible_package_rows = [
        row
        for row in package_rows
        if not any(term in row["pathname"].lower() for term in blocked_sample_terms)
    ]
    sample_package = "\n".join(
        "| `{pathname}` | `{kind}` |".format(**row)
        for row in visible_package_rows[:25]
    )
    if not sample_package:
        sample_package = "| 없음 |  |"

    runtime_sample = "\n".join(f"- `{item}`" for item in summary["project_spine_runtime"]["sample"])
    if not runtime_sample:
        runtime_sample = "- 없음"

    dummy_lines = "\n".join(f"- `{item}`" for item in summary["dummy_dlls"])
    if not dummy_lines:
        dummy_lines = "- 없음"

    return f"""# MainInterface Spine Runtime Compatibility

Generated: {summary["generated_at"]}

## Verdict

{summary["decision"]["verdict"]}

`UI_heroSpine` 복원은 단순 배치 문제가 아니다. 1001 기본 홈 캐릭터는 Spine binary skeleton과 atlas를 실제 `spine-unity` 런타임으로 묶어야 하며, 현재 프로젝트에는 그 런타임이 없다.

## Current Evidence

| 항목 | 값 |
| --- | --- |
| Unity project | `{summary["unity_project"]["version"]}` |
| Unity revision | `{summary["unity_project"]["revision"]}` |
| Installed Unity editors | `{", ".join(summary["installed_unity_versions"]) or "none"}` |
| Project manifest mentions Spine | `{summary["manifest"]["mentions_spine"]}` |
| Real Spine runtime in restore project | `{summary["project_spine_runtime"]["present"]}` |
| Official Spine 4.0 package downloaded | `{summary["unitypackage"]["exists"]}` |
| Spine 4.0 package size | `{summary["unitypackage"]["size"]}` |
| Spine 4.0 package sha256 | `{summary["unitypackage"]["sha256"]}` |
| Package pathname count | `{summary["unitypackage"]["pathname_count"]}` |

## Skeleton Versions

| source | detected Spine binary version | bytes |
| --- | --- | --- |
{skeleton_lines}

Detected 1001 source is Spine `4.0.x`. This is why a `4.3` runtime should not be treated as interchangeable without re-exported skeleton data.

## Official Compatibility Constraint

Reference: `{OFFICIAL_SPINE_URL}`

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
{sample_package}

Full package path list:

- `Assets/RestoreData/reports/maininterface_spine40_unitypackage_pathnames.csv`

## Project Runtime Scan

Runtime candidates found in the restore project:

{runtime_sample}

DummyDll files found in extracted IL2CPP output:

{dummy_lines}

Those DummyDll files are metadata stubs from Il2CppDumper and should not be used as a final Unity runtime.

## Safe Restore Plan

1. Keep `Painting_1001.png` out of normal Image placement. It is a Spine atlas page.
2. Keep the exported source in `Assets/RestoreData/hero1001_spine_source/paintingprefabandres_1001`.
3. Use `_restore_tools\\55_RUN_SPINE40_PROBE_IMPORT.cmd` to create an isolated probe under `_restore_tools\\work` before touching the main restore project.
4. Use `_restore_tools\\56_ANALYZE_SPINE40_PROBE_RESULT.cmd` to prove whether the Unity 6000 probe imported cleanly.
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
"""


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    RESTORE_REPORTS.mkdir(parents=True, exist_ok=True)

    package, package_rows = inspect_unitypackage()
    skel_rows = skeleton_versions()
    summary = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "base": str(BASE),
        "unity_project": parse_unity_version(),
        "installed_unity_versions": installed_unity_versions(),
        "manifest": has_spine_dependency(),
        "project_spine_runtime": detect_project_spine_runtime(),
        "dummy_dlls": detect_dummy_dlls(),
        "unitypackage": package,
        "hero_skeletons": skel_rows,
        "official_reference": OFFICIAL_SPINE_URL,
    }
    summary["decision"] = decide(summary)

    write_csv(
        PACKAGE_CSV,
        package_rows,
        ["package_entry", "pathname", "kind"],
    )
    write_csv(
        SKELETON_CSV,
        skel_rows,
        ["relative_path", "size", "detected_spine_binary_version"],
    )
    SUMMARY_JSON.write_text(
        json.dumps(summary, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    MARKDOWN.write_text(make_markdown(summary, package_rows), encoding="utf-8")

    print("[GirlsWarRestore] Spine runtime compatibility analysis complete")
    print(f"[GirlsWarRestore] Report: {MARKDOWN}")
    print(f"[GirlsWarRestore] Status: {summary['decision']['status']}")


if __name__ == "__main__":
    main()
