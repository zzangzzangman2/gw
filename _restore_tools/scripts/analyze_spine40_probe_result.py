from __future__ import annotations

import json
import re
from datetime import datetime
from pathlib import Path


BASE = Path(__file__).resolve().parents[2]
TOOLS = BASE / "_restore_tools"
WORK = TOOLS / "work"
REPORTS = BASE / "reports" / "maininterface"
RESTORE_REPORTS = BASE / "girlswar_maininterface_unity" / "Assets" / "RestoreData" / "reports"

LATEST_PROBE = WORK / "spine40_unity6000_probe_latest.txt"
LATEST_RESULT = WORK / "spine40_unity6000_probe_latest_result.json"
LATEST_LOG = REPORTS / "spine40_unity6000_probe_import_latest.log"
SUMMARY_JSON = RESTORE_REPORTS / "maininterface_spine40_probe_result.json"
MARKDOWN = REPORTS / "MAININTERFACE_SPINE40_PROBE_RESULT.md"


HARD_ISSUE_PATTERNS = [
    re.compile(pattern, re.IGNORECASE)
    for pattern in [
        r"\berror CS\d+",
        r"\bCompilerError\b",
        r"\bCompilation failed\b",
        r"\bAborting batchmode\b",
        r"\bAsset import failed\b",
        r"\bFailed to import package\b",
    ]
]

SOFT_ISSUE_PATTERNS = [
    re.compile(pattern, re.IGNORECASE)
    for pattern in [
        r"\bUnityException\b",
        r"\bTargetInvocationException\b",
        r"\bNullReferenceException\b",
    ]
]


def read_text(path: Path) -> str:
    if not path.exists():
        return ""
    return path.read_text(encoding="utf-8-sig", errors="replace")


def read_json(path: Path) -> dict:
    text = read_text(path)
    if not text:
        return {}
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return {"json_error": "failed_to_parse", "raw": text[:1000]}


def scan_log(log_text: str) -> dict:
    lines = log_text.splitlines()
    hard_issues = []
    soft_issues = []
    imports = []
    declared_return_code = None
    success_marker = False
    for index, line in enumerate(lines, start=1):
        if "Import package" in line or "Importing package" in line:
            imports.append({"line": index, "text": line[:400]})
        if "Exiting batchmode successfully now" in line:
            success_marker = True
        code_match = re.search(r"Application will terminate with return code\s+(\d+)", line)
        if code_match:
            declared_return_code = int(code_match.group(1))
        if any(pattern.search(line) for pattern in HARD_ISSUE_PATTERNS):
            hard_issues.append({"line": index, "text": line[:600]})
        elif any(pattern.search(line) for pattern in SOFT_ISSUE_PATTERNS):
            soft_issues.append({"line": index, "text": line[:600]})
    return {
        "line_count": len(lines),
        "success_marker": success_marker,
        "declared_return_code": declared_return_code,
        "hard_issue_count": len(hard_issues),
        "soft_issue_count": len(soft_issues),
        "hard_issues": hard_issues[:100],
        "soft_issues": soft_issues[:100],
        "issue_count": len(hard_issues) + len(soft_issues),
        "issues": (hard_issues + soft_issues)[:100],
        "import_markers": imports[:40],
    }


def inspect_probe_project(path_text: str) -> dict:
    probe = Path(path_text.strip()) if path_text.strip() else Path()
    result = {
        "path": str(probe) if path_text.strip() else "",
        "exists": probe.exists() if path_text.strip() else False,
        "assets_spine_exists": False,
        "spine_file_count": 0,
        "skeleton_graphic_exists": False,
        "skeleton_data_asset_exists": False,
    }
    if not result["exists"]:
        return result

    spine_dir = probe / "Assets" / "Spine"
    result["assets_spine_exists"] = spine_dir.exists()
    if spine_dir.exists():
        files = [path for path in spine_dir.rglob("*") if path.is_file()]
        result["spine_file_count"] = len(files)
        result["skeleton_graphic_exists"] = any(
            path.name.lower() == "skeletongraphic.cs" for path in files
        )
        result["skeleton_data_asset_exists"] = any(
            path.name.lower() == "skeletondataasset.cs" for path in files
        )
    return result


def decide(summary: dict) -> dict:
    result = summary["probe_result"]
    log = summary["log_scan"]
    project = summary["probe_project"]
    exit_code = result.get("unity_exit_code")
    log_code = log.get("declared_return_code")
    effective_code = log_code if log_code is not None else exit_code

    if not result:
        return {
            "status": "not_run",
            "verdict": "Spine 4.0 probe import has not been run yet.",
            "next": "Run _restore_tools\\55_RUN_SPINE40_PROBE_IMPORT.cmd.",
        }
    if effective_code != 0:
        return {
            "status": "probe_unity_failed",
            "verdict": f"Unity batchmode returned {effective_code}; do not use this runtime in the main restore project yet.",
            "next": "Open the probe log and fix/import in an isolated project only.",
        }
    if log["hard_issue_count"]:
        return {
            "status": "probe_log_hard_errors",
            "verdict": "Unity returned 0, but the log still contains hard compile/import errors.",
            "next": "Review the issue lines before binding UI_heroSpine.",
        }
    if not project["assets_spine_exists"] or not project["skeleton_graphic_exists"]:
        return {
            "status": "probe_import_incomplete",
            "verdict": "Unity returned 0, but Assets/Spine runtime files were not found in the probe project.",
            "next": "Check whether the unitypackage import was skipped.",
        }
    if log["soft_issue_count"]:
        return {
            "status": "probe_runtime_present_with_soft_import_exception",
            "verdict": "Spine 4.0 runtime files imported and compiled in the Unity 6000 probe, but the log contains a non-fatal import-time exception.",
            "next": "Keep working inside the probe: create/bind the 1001 SkeletonDataAsset and capture before touching the main restore project.",
        }
    return {
        "status": "probe_import_clean_on_unity6000",
        "verdict": "The isolated Unity 6000 probe imported Spine 4.0 without detected compile/import errors.",
        "next": "Create/bind the 1001 SkeletonDataAsset in the probe first, then capture before touching the main restore project.",
    }


def make_markdown(summary: dict) -> str:
    decision = summary["decision"]
    result = summary["probe_result"]
    project = summary["probe_project"]
    log = summary["log_scan"]

    hard_issues = "\n".join(
        f"- line {item['line']}: `{item['text']}`" for item in log["hard_issues"][:40]
    )
    if not hard_issues:
        hard_issues = "- none"

    soft_issues = "\n".join(
        f"- line {item['line']}: `{item['text']}`" for item in log["soft_issues"][:40]
    )
    if not soft_issues:
        soft_issues = "- none"

    imports = "\n".join(
        f"- line {item['line']}: `{item['text']}`" for item in log["import_markers"][:20]
    )
    if not imports:
        imports = "- none"

    return f"""# Spine 4.0 Unity 6000 Probe Result

Generated: {summary["generated_at"]}

## Verdict

{decision["verdict"]}

Next: {decision["next"]}

## Probe

| 항목 | 값 |
| --- | --- |
| status | `{decision["status"]}` |
| source project | `{result.get("source_project", "")}` |
| probe project | `{project["path"]}` |
| unitypackage | `{result.get("unitypackage", "")}` |
| Unity exit code | `{result.get("unity_exit_code", "")}` |
| Unity log return code | `{log.get("declared_return_code", "")}` |
| batchmode success marker | `{log.get("success_marker", False)}` |
| robocopy exit code | `{result.get("robocopy_exit_code", "")}` |
| log | `{result.get("log", "")}` |
| `Assets/Spine` exists | `{project["assets_spine_exists"]}` |
| Spine file count | `{project["spine_file_count"]}` |
| `SkeletonGraphic.cs` exists | `{project["skeleton_graphic_exists"]}` |
| `SkeletonDataAsset.cs` exists | `{project["skeleton_data_asset_exists"]}` |
| hard log issue count | `{log["hard_issue_count"]}` |
| soft log issue count | `{log["soft_issue_count"]}` |

## Import Markers

{imports}

## Hard Issue Lines

{hard_issues}

## Soft Issue Lines

{soft_issues}

## Restore Meaning

- If status is not `probe_import_clean_on_unity6000`, do not bind this runtime into the main restore project.
- If status is clean, the next proof is still visual: build the 1001 `SkeletonDataAsset` in the probe, attach it under `UI_heroSpine`, and capture graphics mode output.
- MainInterface is not complete until the character renders as Spine, not as a whole atlas placeholder.

## Generated Files

- `Assets/RestoreData/reports/maininterface_spine40_probe_result.json`
- `reports/maininterface/spine40_unity6000_probe_import_latest.log`
"""


def main() -> None:
    RESTORE_REPORTS.mkdir(parents=True, exist_ok=True)
    REPORTS.mkdir(parents=True, exist_ok=True)

    result = read_json(LATEST_RESULT)
    probe_project = inspect_probe_project(read_text(LATEST_PROBE))
    log_text = read_text(LATEST_LOG)
    summary = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "base": str(BASE),
        "probe_result": result,
        "probe_project": probe_project,
        "log_scan": scan_log(log_text),
    }
    summary["decision"] = decide(summary)

    SUMMARY_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    MARKDOWN.write_text(make_markdown(summary), encoding="utf-8")

    print("[GirlsWarRestore] Spine 4.0 probe result analysis complete")
    print(f"[GirlsWarRestore] Report: {MARKDOWN}")
    print(f"[GirlsWarRestore] Status: {summary['decision']['status']}")


if __name__ == "__main__":
    main()
