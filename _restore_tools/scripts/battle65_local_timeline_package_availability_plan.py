from __future__ import annotations

import csv
import json
import re
import tarfile
from datetime import datetime
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
REPORT_DIR = BASE / "reports" / "battle"
PREFIX = "BATTLE_65_LOCAL_TIMELINE_PACKAGE_AVAILABILITY_AND_REVERSIBLE_CANDIDATE_PLAN_NO_IMPORT_NO_PATCH"

MANIFEST = PROJECT / "Packages" / "manifest.json"
LOCK = PROJECT / "Packages" / "packages-lock.json"
PROJECT_VERSION = PROJECT / "ProjectSettings" / "ProjectVersion.txt"
OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
OUT_CANDIDATES = REPORT_DIR / f"{PREFIX}_LOCAL_TIMELINE_PACKAGE_CANDIDATE_MATRIX.csv"
OUT_DECISIONS = REPORT_DIR / f"{PREFIX}_COMPATIBILITY_APPROVAL_DECISION_MATRIX.csv"
OUT_PLAN = REPORT_DIR / f"{PREFIX}_REVERSIBLE_FOLLOWUP_CANDIDATE_PLAN_MATRIX.csv"
OUT_LOG = REPORT_DIR / f"{PREFIX}.log"

PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")


def read_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8-sig", errors="ignore")
    except Exception:
        return ""


def read_json(path: Path) -> dict[str, Any]:
    try:
        return json.loads(read_text(path))
    except Exception:
        return {}


def write_csv(path: Path, rows: list[dict[str, Any]], headers: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=headers, extrasaction="ignore")
        writer.writeheader()
        for row in rows:
            writer.writerow({h: row.get(h, "") for h in headers})


def command_policy() -> dict[str, Any]:
    root_cmds = sorted(str(p) for p in BASE.glob("*.cmd"))
    direct_cmds = sorted(str(p) for p in (BASE / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmds),
        "rootCmdFiles": root_cmds,
        "restoreToolsDirectCmdCount": len(direct_cmds),
        "restoreToolsDirectCmdFiles": direct_cmds,
    }


def current_unity_version() -> str:
    text = read_text(PROJECT_VERSION)
    m = re.search(r"m_EditorVersion:\s*([^\s]+)", text)
    return m.group(1) if m else ""


def unity_editor_root(version: str) -> Path:
    return Path(r"C:\Program Files\Unity\Hub\Editor") / version / "Editor"


def package_info_from_folder(folder: Path) -> dict[str, Any]:
    data = read_json(folder / "package.json")
    runtime = folder / "Runtime"
    return {
        "packageName": data.get("name", ""),
        "packageVersion": data.get("version", ""),
        "unityConstraint": data.get("unity", ""),
        "unityReleaseConstraint": data.get("unityRelease", ""),
        "displayName": data.get("displayName", ""),
        "containsRuntimeTimelineAsset": any(runtime.rglob("*TimelineAsset*.cs")) if runtime.exists() else False,
        "containsRuntimeAsmdef": any(runtime.rglob("*.asmdef")) if runtime.exists() else False,
        "containsTimelineDll": any(folder.rglob("Unity.Timeline.dll")),
        "packageJsonReadable": bool(data),
    }


def package_info_from_tgz(path: Path) -> dict[str, Any]:
    result = {
        "packageName": "",
        "packageVersion": "",
        "unityConstraint": "",
        "unityReleaseConstraint": "",
        "displayName": "",
        "containsRuntimeTimelineAsset": False,
        "containsRuntimeAsmdef": False,
        "containsTimelineDll": False,
        "packageJsonReadable": False,
    }
    try:
        with tarfile.open(path, "r:gz") as tf:
            names = tf.getnames()
            package_json = next((n for n in names if n.endswith("package.json")), "")
            if package_json:
                data = json.load(tf.extractfile(package_json) or None)
                result.update(
                    {
                        "packageName": data.get("name", ""),
                        "packageVersion": data.get("version", ""),
                        "unityConstraint": data.get("unity", ""),
                        "unityReleaseConstraint": data.get("unityRelease", ""),
                        "displayName": data.get("displayName", ""),
                        "packageJsonReadable": True,
                    }
                )
            result["containsRuntimeTimelineAsset"] = any("/Runtime/" in n and "TimelineAsset" in n and n.endswith(".cs") for n in names)
            result["containsRuntimeAsmdef"] = any("/Runtime/" in n and n.endswith(".asmdef") for n in names)
            result["containsTimelineDll"] = any(n.endswith("Unity.Timeline.dll") for n in names)
    except Exception as exc:
        result["readError"] = f"{type(exc).__name__}: {exc}"
    return result


def classify_location(path: Path, editor_root: Path) -> str:
    s = str(path).lower()
    if str(PROJECT).lower() in s:
        return "battle_project_local"
    if str(BASE).lower() in s:
        if "il2cpp_dump" in s or "dummydll" in s:
            return "original_dump_type_signature_only"
        return "repo_local"
    if str(editor_root).lower() in s:
        return "editor_bundled"
    if str(Path.home()).lower() in s:
        return "user_profile_cache"
    return "other_local"


def source_compatible(row: dict[str, Any], unity_version: str) -> bool:
    if row.get("packageName") != "com.unity.timeline":
        return False
    if not row.get("containsRuntimeTimelineAsset") or not row.get("containsRuntimeAsmdef"):
        return False
    if row.get("locationClass") == "editor_bundled":
        return True
    return bool(row.get("packageVersion"))


def add_candidate(candidates: list[dict[str, Any]], path: Path, kind: str, editor_root: Path, unity_version: str) -> None:
    info: dict[str, Any]
    if kind == "folder_package":
        info = package_info_from_folder(path)
    elif kind == "tarball_package":
        info = package_info_from_tgz(path)
    else:
        info = {
            "packageName": "",
            "packageVersion": "",
            "unityConstraint": "",
            "unityReleaseConstraint": "",
            "displayName": "",
            "containsRuntimeTimelineAsset": False,
            "containsRuntimeAsmdef": False,
            "containsTimelineDll": path.name.lower() == "unity.timeline.dll",
            "packageJsonReadable": False,
        }
    location = classify_location(path, editor_root)
    row = {
        "path": str(path),
        "candidateKind": kind,
        "locationClass": location,
        **info,
    }
    row["appearsSourceCompatibleWithCurrentUnity"] = source_compatible(row, unity_version)
    if row["packageName"] == "com.unity.timeline" and row["appearsSourceCompatibleWithCurrentUnity"]:
        row["candidateStatus"] = "local_candidate_found_requires_user_approval_to_import"
    elif row["packageName"] == "com.unity.timeline":
        row["candidateStatus"] = "candidate_version_mismatch_requires_manual_review"
    elif kind == "dll_type_signature_only":
        row["candidateStatus"] = "source_backed_type_signature_only_not_package_importable"
    else:
        row["candidateStatus"] = "not_a_timeline_package"
    row["evidence"] = evidence(row)
    candidates.append(row)


def evidence(row: dict[str, Any]) -> str:
    if row["candidateStatus"] == "local_candidate_found_requires_user_approval_to_import":
        return "Local com.unity.timeline package metadata and Runtime/TimelineAsset source are present; no import performed."
    if row["candidateStatus"] == "source_backed_type_signature_only_not_package_importable":
        return "Unity.Timeline.dll exists as binary/type evidence, but it is not a Unity package folder/tarball candidate."
    if row["packageName"] == "com.unity.timeline":
        return "Package name matches but compatibility/import safety needs manual review."
    return "Path matched Timeline naming but package metadata did not identify com.unity.timeline."


def search_candidates() -> list[dict[str, Any]]:
    unity_version = current_unity_version()
    editor_root = unity_editor_root(unity_version)
    candidates: list[dict[str, Any]] = []
    seen: set[str] = set()

    folder_roots = [
        PROJECT / "Packages",
        PROJECT / "Library" / "PackageCache",
        BASE / "_restore_tools",
        BASE / "girlswar_merged_extracted",
        Path.home() / "AppData" / "Local" / "Unity" / "cache" / "packages",
        Path.home() / "AppData" / "Local" / "Unity" / "cache" / "npm",
        Path.home() / "AppData" / "Local" / "Unity" / "PackageManager",
    ]
    for root in folder_roots:
        if not root.exists():
            continue
        for package_json in root.rglob("package.json"):
            try:
                data = read_json(package_json)
                folder = package_json.parent
                if data.get("name") == "com.unity.timeline" or "timeline" in str(folder).lower():
                    key = str(folder).lower()
                    if key not in seen:
                        seen.add(key)
                        add_candidate(candidates, folder, "folder_package", editor_root, unity_version)
            except Exception:
                continue

    tar_roots = [
        editor_root / "Data" / "Resources" / "PackageManager" / "Editor",
        BASE,
        Path.home() / "AppData" / "Local" / "Unity",
    ]
    for root in tar_roots:
        if not root.exists():
            continue
        for tgz in root.rglob("com.unity.timeline*.tgz"):
            key = str(tgz).lower()
            if key not in seen:
                seen.add(key)
                add_candidate(candidates, tgz, "tarball_package", editor_root, unity_version)

    dll_roots = [BASE / "girlswar_merged_extracted" / "extracted" / "il2cpp_dump" / "DummyDll"]
    for root in dll_roots:
        if root.exists():
            for dll in root.rglob("Unity.Timeline.dll"):
                key = str(dll).lower()
                if key not in seen:
                    seen.add(key)
                    add_candidate(candidates, dll, "dll_type_signature_only", editor_root, unity_version)
    return candidates


def decision_rows(candidates: list[dict[str, Any]]) -> list[dict[str, Any]]:
    compatible = [r for r in candidates if r.get("appearsSourceCompatibleWithCurrentUnity") is True]
    any_timeline = [r for r in candidates if r.get("packageName") == "com.unity.timeline"]
    if compatible:
        recommended = "local_candidate_found_requires_user_approval_to_import"
    elif any_timeline:
        recommended = "candidate_version_mismatch_requires_manual_review"
    else:
        recommended = "no_local_timeline_candidate_found"
    return [
        {
            "decision": "no_local_timeline_candidate_found",
            "status": "not_current" if candidates else "would_apply",
            "evidence": f"timelineCandidateCount={len(any_timeline)}",
            "nextAction": "If no local candidate exists, continue blocked on approved package/runtime source.",
        },
        {
            "decision": "local_candidate_found_requires_user_approval_to_import",
            "status": "recommended" if compatible else "not_current",
            "evidence": f"sourceCompatibleCandidates={len(compatible)}",
            "nextAction": "Do not import now; request explicit approval for reversible candidate test.",
        },
        {
            "decision": "candidate_version_mismatch_requires_manual_review",
            "status": "manual_review" if any_timeline and not compatible else "not_current",
            "evidence": f"timelineCandidates={len(any_timeline)}; compatible={len(compatible)}",
            "nextAction": "Review package version/unity constraints before any manifest change.",
        },
        {
            "decision": "do_not_import_external_package_without_approval",
            "status": "guardrail_active",
            "evidence": "No network/package install/import was executed.",
            "nextAction": "Keep packageImported=false and manifestModified=false until approval.",
        },
        {
            "decision": "recommendedDecision",
            "status": recommended,
            "evidence": "Derived from local candidate matrix.",
            "nextAction": "Use the reversible plan CSV only after user/control tower approval.",
        },
    ]


def plan_rows(candidates: list[dict[str, Any]]) -> list[dict[str, Any]]:
    compatible = [r for r in candidates if r.get("appearsSourceCompatibleWithCurrentUnity") is True]
    if not compatible:
        return []
    candidate = compatible[0]
    path = candidate["path"]
    return [
        {
            "step": "1",
            "phase": "backup",
            "fileOrAction": "Packages/manifest.json and Packages/packages-lock.json",
            "wouldChange": "copy to timestamped backup outside package manager mutation path",
            "revertPlan": "restore exact backup files and delete generated Library package cache entries from the candidate test only",
            "validation": "hash before/after backups; no scene changes",
            "successCriteria": "backup exists before any manifest edit",
        },
        {
            "step": "2",
            "phase": "candidate_manifest_edit_after_approval_only",
            "fileOrAction": "Packages/manifest.json",
            "wouldChange": f"add com.unity.timeline from local candidate {path}",
            "revertPlan": "remove the dependency entry and restore backup manifest/lock",
            "validation": "Unity batch import exits 0; no xLua/handler/scene patch",
            "successCriteria": "UnityEngine.Timeline.TimelineAsset type loads and is assignable to PlayableAsset",
        },
        {
            "step": "3",
            "phase": "b63_reprobe_after_approval_only",
            "fileOrAction": "BATTLE63/BATTLE64 probe rerun",
            "wouldChange": "reports only",
            "revertPlan": "discard candidate reports if import reverted",
            "validation": "timelineAssetsInspectable > 0 and PlayableAsset mismatch rows decrease",
            "successCriteria": "limited to resolving TimelineAsset assignability; no playable/restored claim",
        },
        {
            "step": "4",
            "phase": "guardrail",
            "fileOrAction": "scene/assets/handlers",
            "wouldChange": "nothing",
            "revertPlan": "not applicable",
            "validation": "git/status and JSON flags show sceneSaved=false, handlerPatchApplied=false",
            "successCriteria": "no fake timeline/binding/runtime object and no playability claim",
        },
    ]


def build_md(result: dict[str, Any]) -> str:
    return "\n".join(
        [
            f"# {PREFIX} Result",
            "",
            "**No import/no patch.** BATTLE65 only inventories local Timeline candidates and writes an approval-gated reversible plan.",
            "",
            "## Verdict",
            f"- patchApplied: `{str(result['patchApplied']).lower()}`",
            f"- packageImported: `{str(result['packageImported']).lower()}`",
            f"- manifestModified: `{str(result['manifestModified']).lower()}`",
            f"- sceneSaved: `{str(result['sceneSaved']).lower()}`",
            f"- networkUsed: `{str(result['networkUsed']).lower()}`",
            f"- recommendedDecision: `{result['recommendedDecision']}`",
            f"- approvalRequiredForImport: `{str(result['approvalRequiredForImport']).lower()}`",
            f"- nextBlocker: `{result['nextBlocker']}`",
            "",
            "## Counts",
            f"- timelineCandidatesFound: `{result['timelineCandidatesFound']}`",
            f"- sourceCompatibleCandidates: `{result['sourceCompatibleCandidates']}`",
            "",
            "## Outputs",
            f"- candidate matrix: `{OUT_CANDIDATES}`",
            f"- decision matrix: `{OUT_DECISIONS}`",
            f"- reversible plan matrix: `{OUT_PLAN}`",
            f"- result JSON: `{OUT_JSON}`",
            "",
            "## Command Policy",
            f"- root `.cmd` count: `{result['commandPolicy']['rootCmdCount']}`",
            f"- `_restore_tools` direct `.cmd` count: `{result['commandPolicy']['restoreToolsDirectCmdCount']}`",
            f"- `플레이.mp4`: `{'available' if PLAY_VIDEO.exists() else 'missing'}`",
            f"- `참고.mp4`: `{'available, auxiliary only' if AUX_VIDEO.exists() else 'missing'}`",
        ]
    ) + "\n"


def main() -> int:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    manifest = read_json(MANIFEST)
    lock = read_json(LOCK)
    candidates = search_candidates()
    decisions = decision_rows(candidates)
    plans = plan_rows(candidates)
    source_compatible = sum(1 for r in candidates if r.get("appearsSourceCompatibleWithCurrentUnity") is True)
    timeline_candidates = sum(1 for r in candidates if r.get("packageName") == "com.unity.timeline")
    recommended = next((r["status"] for r in decisions if r["decision"] == "recommendedDecision"), "no_local_timeline_candidate_found")
    result = {
        "prefix": PREFIX,
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "patchApplied": False,
        "packageImported": False,
        "manifestModified": False,
        "sceneSaved": False,
        "networkUsed": False,
        "xLuaRuntimeUsed": False,
        "handlerPatchApplied": False,
        "timelineCandidatesFound": timeline_candidates,
        "sourceCompatibleCandidates": source_compatible,
        "recommendedDecision": recommended,
        "approvalRequiredForImport": source_compatible > 0,
        "currentProject": {
            "unityVersion": current_unity_version(),
            "timelineInManifest": "com.unity.timeline" in json.dumps(manifest),
            "timelineInLock": "com.unity.timeline" in json.dumps(lock),
            "directorModuleInManifest": "com.unity.modules.director" in json.dumps(manifest),
        },
        "nextBlocker": "user_approval_required_for_reversible_local_timeline_candidate_import_test_or_original_timelineeffect_runtime_binding_context",
        "guardrailsTouched": {
            "packageImported": False,
            "manifestModified": False,
            "packagesLockModified": False,
            "sceneSaved": False,
            "networkUsed": False,
            "externalPackageDownloaded": False,
            "fakeTimelineCreated": False,
            "fakeBindingCreated": False,
            "handlerPatchApplied": False,
            "mainInterfaceTouched": False,
        },
        "commandPolicy": command_policy(),
        "outputs": {
            "resultMd": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "candidateMatrixCsv": str(OUT_CANDIDATES),
            "decisionMatrixCsv": str(OUT_DECISIONS),
            "reversiblePlanCsv": str(OUT_PLAN),
            "log": str(OUT_LOG),
        },
    }
    write_csv(
        OUT_CANDIDATES,
        candidates,
        [
            "path",
            "candidateKind",
            "locationClass",
            "packageName",
            "packageVersion",
            "unityConstraint",
            "unityReleaseConstraint",
            "displayName",
            "packageJsonReadable",
            "containsRuntimeTimelineAsset",
            "containsRuntimeAsmdef",
            "containsTimelineDll",
            "appearsSourceCompatibleWithCurrentUnity",
            "candidateStatus",
            "evidence",
        ],
    )
    write_csv(OUT_DECISIONS, decisions, ["decision", "status", "evidence", "nextAction"])
    write_csv(OUT_PLAN, plans, ["step", "phase", "fileOrAction", "wouldChange", "revertPlan", "validation", "successCriteria"])
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    OUT_MD.write_text(build_md(result), encoding="utf-8")
    OUT_LOG.write_text(
        "\n".join(
            [
                PREFIX,
                f"timelineCandidatesFound={timeline_candidates}",
                f"sourceCompatibleCandidates={source_compatible}",
                f"recommendedDecision={recommended}",
                "patchApplied=false",
                "packageImported=false",
                "manifestModified=false",
                "networkUsed=false",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
