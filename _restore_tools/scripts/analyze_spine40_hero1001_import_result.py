from __future__ import annotations

import json
import re
from datetime import datetime
from pathlib import Path


BASE = Path(__file__).resolve().parents[2]
WORK = BASE / "_restore_tools" / "work"
REPORTS = BASE / "reports" / "maininterface"
RESTORE_REPORTS = BASE / "girlswar_maininterface_unity" / "Assets" / "RestoreData" / "reports"

LATEST_PROBE = WORK / "spine40_unity6000_probe_latest.txt"
LATEST_RESULT = WORK / "spine40_hero1001_import_latest_result.json"
LATEST_LOG = REPORTS / "spine40_hero1001_import_latest.log"
SUMMARY_JSON = RESTORE_REPORTS / "maininterface_spine40_hero1001_import_result.json"
MARKDOWN = REPORTS / "MAININTERFACE_SPINE40_HERO1001_IMPORT_RESULT.md"

HERO_ROOT = Path("Assets/RestoreData/hero1001_spine_source_raw/paintingprefabandres_1001")
EXPECTED = [
    "Painting_1001_SkeletonData.asset",
    "Painting_1001_Front_SkeletonData.asset",
    "Painting_1001_Back_SkeletonData.asset",
    "SP_heroname_1001_SkeletonData.asset",
]

HARD_PATTERNS = [
    re.compile(pattern, re.IGNORECASE)
    for pattern in [
        r"\berror CS\d+",
        r"\bCompilerError\b",
        r"\bCompilation failed\b",
        r"\bAborting batchmode\b",
        r"\bAsset import failed\b",
        r"\bExecuteMethod.*failed\b",
        r"\bMissing SkeletonDataAsset\b",
        r"\bSkeletonData load failed\b",
        r"\bMissing source file\b",
        r"\bIndexOutOfRangeException\b",
        r"\bEndOfStreamException\b",
        r"\bexecuteMethod method .* threw exception\b",
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


def latest_probe_path() -> Path | None:
    text = read_text(LATEST_PROBE).strip()
    if not text:
        return None
    return Path(text)


def scan_log(text: str) -> dict:
    lines = text.splitlines()
    hard = []
    probe_lines = []
    declared_return_code = None
    success_marker = False
    for index, line in enumerate(lines, start=1):
        if "[GirlsWarRestore][SpineProbe]" in line:
            probe_lines.append({"line": index, "text": line[:700]})
        if "Exiting batchmode successfully now" in line:
            success_marker = True
        code_match = re.search(r"Application will terminate with return code\s+(\d+)", line)
        if code_match:
            declared_return_code = int(code_match.group(1))
        if any(pattern.search(line) for pattern in HARD_PATTERNS):
            hard.append({"line": index, "text": line[:700]})
    return {
        "line_count": len(lines),
        "success_marker": success_marker,
        "declared_return_code": declared_return_code,
        "hard_issue_count": len(hard),
        "hard_issues": hard[:100],
        "probe_lines": probe_lines[:100],
    }


def inspect_assets(probe: Path | None) -> dict:
    if probe is None:
        return {"probe_project": "", "exists": False, "assets": []}
    rows = []
    root = probe / HERO_ROOT
    for name in EXPECTED:
        path = root / name
        rows.append(
            {
                "asset": str((HERO_ROOT / name)).replace("\\", "/"),
                "exists": path.exists(),
                "size": path.stat().st_size if path.exists() else 0,
            }
        )
    generated = []
    if root.exists():
        for path in sorted(root.glob("*")):
            if path.suffix.lower() in {".asset", ".mat"}:
                generated.append(str(path.relative_to(probe)).replace("\\", "/"))
    return {
        "probe_project": str(probe),
        "exists": probe.exists(),
        "assets": rows,
        "generated_asset_or_mat_count": len(generated),
        "generated_asset_or_mat_sample": generated[:80],
    }


def decide(summary: dict) -> dict:
    result = summary["run_result"]
    log = summary["log_scan"]
    assets = summary["asset_scan"]
    code = log["declared_return_code"]
    if code is None:
        code = result.get("unity_exit_code")
    missing = [row["asset"] for row in assets["assets"] if not row["exists"]]

    if not result:
        return {
            "status": "not_run",
            "verdict": "Hero 1001 Spine import has not been run in the probe yet.",
            "next": "Run _restore_tools\\58_IMPORT_HERO1001_SPINE_IN_PROBE.cmd.",
        }
    if code != 0:
        return {
            "status": "hero1001_import_unity_failed",
            "verdict": f"Unity returned {code}; the 1001 SkeletonDataAsset bind is not usable yet.",
            "next": "Open the log and fix the probe importer before touching the main project.",
        }
    if log["hard_issue_count"]:
        return {
            "status": "hero1001_import_hard_errors",
            "verdict": "The 1001 import log contains hard errors.",
            "next": "Fix the listed errors inside the probe.",
        }
    if missing:
        return {
            "status": "hero1001_skeletondata_missing",
            "verdict": "Unity finished, but expected 1001 SkeletonDataAsset files are missing.",
            "next": "Force reimport the hero source files or inspect atlas matching.",
        }
    return {
        "status": "hero1001_skeletondata_ready_in_probe",
        "verdict": "The probe created and loaded the 1001 SkeletonDataAsset files through Spine 4.0.",
        "next": "Attach Painting_1001_SkeletonData.asset to a SkeletonGraphic under UI_heroSpine in the probe and capture graphics output.",
    }


def make_markdown(summary: dict) -> str:
    decision = summary["decision"]
    log = summary["log_scan"]
    assets = summary["asset_scan"]
    result = summary["run_result"]

    asset_rows = "\n".join(
        "| `{asset}` | `{exists}` | {size} |".format(**row)
        for row in assets["assets"]
    )
    probe_lines = "\n".join(
        f"- line {item['line']}: `{item['text']}`" for item in log["probe_lines"][:40]
    )
    if not probe_lines:
        probe_lines = "- none"
    hard = "\n".join(
        f"- line {item['line']}: `{item['text']}`" for item in log["hard_issues"][:40]
    )
    if not hard:
        hard = "- none"
    generated = "\n".join(
        f"- `{item}`" for item in assets.get("generated_asset_or_mat_sample", [])[:40]
    )
    if not generated:
        generated = "- none"

    return f"""# Spine 4.0 Hero 1001 Import Result

Generated: {summary["generated_at"]}

## Verdict

{decision["verdict"]}

Next: {decision["next"]}

## Run

| 항목 | 값 |
| --- | --- |
| status | `{decision["status"]}` |
| probe project | `{assets["probe_project"]}` |
| Unity exit code | `{result.get("unity_exit_code", "")}` |
| Unity log return code | `{log.get("declared_return_code", "")}` |
| batchmode success marker | `{log.get("success_marker", False)}` |
| hard log issue count | `{log["hard_issue_count"]}` |
| log | `{result.get("log", "")}` |

## Expected SkeletonDataAssets

| asset | exists | bytes |
| --- | --- | ---: |
{asset_rows}

## Probe Log Lines

{probe_lines}

## Hard Issue Lines

{hard}

## Generated Assets Or Materials

{generated}

## Restore Meaning

- This is still probe-only evidence; the main restore project remains untouched.
- The next visual proof is a `SkeletonGraphic` under `UI_MainInterface/middle/UI_heroSpine`, using `DTmodelEntity.homePara=[1,0,0]`.
- A whole atlas PNG is still forbidden as a final visual substitute.

## Generated Files

- `Assets/RestoreData/reports/maininterface_spine40_hero1001_import_result.json`
- `reports/maininterface/spine40_hero1001_import_latest.log`
"""


def main() -> None:
    RESTORE_REPORTS.mkdir(parents=True, exist_ok=True)
    REPORTS.mkdir(parents=True, exist_ok=True)
    probe = latest_probe_path()
    summary = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "base": str(BASE),
        "run_result": read_json(LATEST_RESULT),
        "asset_scan": inspect_assets(probe),
        "log_scan": scan_log(read_text(LATEST_LOG)),
    }
    summary["decision"] = decide(summary)
    SUMMARY_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    MARKDOWN.write_text(make_markdown(summary), encoding="utf-8")
    print("[GirlsWarRestore] Spine 4.0 hero 1001 import analysis complete")
    print(f"[GirlsWarRestore] Report: {MARKDOWN}")
    print(f"[GirlsWarRestore] Status: {summary['decision']['status']}")


if __name__ == "__main__":
    main()
