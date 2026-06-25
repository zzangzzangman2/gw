import argparse
import csv
import json
import shutil
import tarfile
from datetime import datetime
from pathlib import Path

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
RESTORE_DATA = PROJECT / "Assets" / "RestoreData"
RESTORE_REPORTS = RESTORE_DATA / "reports"
REPORTS = BASE / "reports" / "maininterface"
VENDOR_PACKAGE = BASE / "_restore_tools" / "vendor" / "spine-unity-4.0-2024-08-21.unitypackage"
PROBE_POINTER = BASE / "_restore_tools" / "work" / "spine40_unity6000_probe_latest.txt"
RUNTIME_ROOT = PROJECT / "Assets" / "Spine" / "Runtime"
ROUTE_ASSET_ROOT = PROJECT / "Assets" / "RestoreData" / "route_spine_raw_decode_recovery"

PREP_JSON = RESTORE_DATA / "maininterface_116_spine_runtime_bridge_import_prep.json"
UNITY_JSON = RESTORE_DATA / "maininterface_116_spine_runtime_bridge_unity_probe.json"
UNITY_CSV = RESTORE_REPORTS / "maininterface_116_spine_runtime_bridge_unity_probe.csv"
OUT_JSON = RESTORE_DATA / "maininterface_116_import_real_spine4_runtime_bridge_for_route_skeletongraphic_replay.json"
OUT_CSV = RESTORE_REPORTS / "maininterface_116_import_real_spine4_runtime_bridge_for_route_skeletongraphic_replay.csv"
OUT_MD = REPORTS / "MAININTERFACE_116_IMPORT_REAL_SPINE4_RUNTIME_BRIDGE_FOR_ROUTE_SKELETONGRAPHIC_REPLAY_RESULT.md"
CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_route_spine_runtime_bridge_1680x720.png"
CLICK_SUMMARY = RESTORE_REPORTS / "maininterface_click_validation_summary.json"
TOOL_CMD = BASE / "_restore_tools" / "cmd_archive" / "116_IMPORT_REAL_SPINE4_RUNTIME_BRIDGE_FOR_ROUTE_SKELETONGRAPHIC_REPLAY.cmd"


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8-sig", errors="ignore") if path.exists() else ""


def read_json(path: Path, fallback):
    if not path.exists():
        return fallback
    return json.loads(read_text(path))


def write_json(path: Path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def count_files(root: Path):
    if not root.exists():
        return {"exists": False, "fileCount": 0, "bytes": 0}
    files = [p for p in root.rglob("*") if p.is_file()]
    return {"exists": True, "fileCount": len(files), "bytes": sum(p.stat().st_size for p in files)}


def probe_project_path():
    if not PROBE_POINTER.exists():
        return None
    value = read_text(PROBE_POINTER).strip("\ufeff").strip()
    return Path(value) if value else None


def extract_spine_runtime():
    if not VENDOR_PACKAGE.exists():
        raise SystemExit(f"vendor package not found: {VENDOR_PACKAGE}")

    extracted = []
    skipped = []
    with tarfile.open(VENDOR_PACKAGE, "r:gz") as tar:
        dirs = sorted({m.name.split("/")[0] for m in tar.getmembers() if "/" in m.name})
        for directory in dirs:
            try:
                f = tar.extractfile(tar.getmember(f"{directory}/pathname"))
                pathname = f.read().decode("utf-8", "ignore") if f else ""
            except KeyError:
                continue
            if not pathname.startswith("Assets/Spine/Runtime"):
                continue
            if pathname.endswith("/"):
                skipped.append({"pathname": pathname, "reason": "directory"})
                continue
            dest = PROJECT / Path(pathname)
            try:
                member = tar.getmember(f"{directory}/asset")
            except KeyError:
                dest.mkdir(parents=True, exist_ok=True)
                skipped.append({"pathname": pathname, "reason": "directory_or_no_asset"})
                continue
            dest.parent.mkdir(parents=True, exist_ok=True)
            data = tar.extractfile(member).read()
            previous = dest.read_bytes() if dest.exists() else None
            if previous != data:
                dest.write_bytes(data)
            extracted.append({"pathname": pathname, "bytes": len(data), "changed": previous != data})
            try:
                meta_member = tar.getmember(f"{directory}/asset.meta")
                meta_data = tar.extractfile(meta_member).read()
                meta_path = Path(str(dest) + ".meta")
                previous_meta = meta_path.read_bytes() if meta_path.exists() else None
                if previous_meta != meta_data:
                    meta_path.write_bytes(meta_data)
            except KeyError:
                pass
    return extracted, skipped


def copy_route_assets_from_probe():
    probe = probe_project_path()
    copied = []
    missing = []
    if not probe or not probe.exists():
        return {"probeProject": str(probe) if probe else "", "copied": copied, "missing": ["probe project missing"]}

    src = probe / "Assets" / "RestoreData" / "route_spine_raw_decode_recovery"
    if not src.exists():
        return {"probeProject": str(probe), "copied": copied, "missing": [str(src)]}

    for file in src.rglob("*"):
        if not file.is_file():
            continue
        rel = file.relative_to(src)
        dest = ROUTE_ASSET_ROOT / rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        previous = dest.read_bytes() if dest.exists() else None
        data = file.read_bytes()
        if previous != data:
            dest.write_bytes(data)
        copied.append({"relative": str(rel).replace("\\", "/"), "bytes": len(data), "changed": previous != data})
    return {"probeProject": str(probe), "source": str(src), "destination": str(ROUTE_ASSET_ROOT), "copied": copied, "missing": missing}


def prepare():
    RESTORE_REPORTS.mkdir(parents=True, exist_ok=True)
    REPORTS.mkdir(parents=True, exist_ok=True)
    before_runtime = count_files(RUNTIME_ROOT)
    before_route = count_files(ROUTE_ASSET_ROOT)
    extracted, skipped = extract_spine_runtime()
    route_copy = copy_route_assets_from_probe()
    after_runtime = count_files(RUNTIME_ROOT)
    after_route = count_files(ROUTE_ASSET_ROOT)
    data = {
        "generatedAt": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "vendorPackage": str(VENDOR_PACKAGE),
        "vendorPackageExists": VENDOR_PACKAGE.exists(),
        "vendorPackageSize": VENDOR_PACKAGE.stat().st_size if VENDOR_PACKAGE.exists() else 0,
        "optionCompare": {
            "A_maininterfaceRuntimeBridge": {
                "chosenForProbe": True,
                "reason": "This is the only path that can attach replay to a MainInterface scene without bitmap placement.",
                "risk": "Compilation/import risk from bringing Spine runtime into girlswar_maininterface_unity.",
            },
            "B_probeProjectReplayScene": {
                "chosenForProbe": False,
                "reason": "Lower compile risk because the probe already has Spine runtime, but it would not prove replay inside the MainInterface Unity project.",
                "risk": "Useful fallback if A fails; separate project capture would remain a diagnostic, not the final scene.",
            },
        },
        "runtimeRoot": str(RUNTIME_ROOT),
        "runtimeBefore": before_runtime,
        "runtimeAfter": after_runtime,
        "runtimePackageAssetRows": len(extracted),
        "runtimePackageBytes": sum(row["bytes"] for row in extracted),
        "runtimeChangedRows": sum(1 for row in extracted if row["changed"]),
        "runtimeSample": extracted[:40],
        "runtimeSkippedSample": skipped[:20],
        "routeAssetRoot": str(ROUTE_ASSET_ROOT),
        "routeAssetBefore": before_route,
        "routeAssetAfter": after_route,
        "routeAssetCopy": {
            **route_copy,
            "copiedCount": len(route_copy.get("copied", [])),
            "changedCount": sum(1 for row in route_copy.get("copied", []) if row.get("changed")),
            "sample": route_copy.get("copied", [])[:40],
        },
    }
    write_json(PREP_JSON, data)
    print(json.dumps({
        "runtimePackageAssetRows": data["runtimePackageAssetRows"],
        "runtimeChangedRows": data["runtimeChangedRows"],
        "runtimeAfter": data["runtimeAfter"],
        "routeAssetCopied": data["routeAssetCopy"]["copiedCount"],
        "routeAssetChanged": data["routeAssetCopy"]["changedCount"],
        "prepJson": str(PREP_JSON),
    }, ensure_ascii=False, indent=2))


def write_csv_from_unity(rows):
    OUT_CSV.parent.mkdir(parents=True, exist_ok=True)
    fields = [
        "target", "node", "sceneNodeFound", "skeletonDataAssetLoaded", "skeletonGraphicTypeAvailable",
        "componentAttached", "initialized", "animation", "loop", "sceneObjectPath", "decision", "detail",
    ]
    with OUT_CSV.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            writer.writerow({k: row.get(k, "") for k in fields})


def final_report(unity_exit: int):
    prep = read_json(PREP_JSON, {})
    unity = read_json(UNITY_JSON, {})
    click = read_json(CLICK_SUMMARY, {})
    rows = unity.get("rows", [])
    write_csv_from_unity(rows)

    root_cmds = list(BASE.glob("*.cmd"))
    direct_cmds = list((BASE / "_restore_tools").glob("*.cmd"))
    capture_exists = CAPTURE.exists()
    visual_fix = int(unity.get("visualFixApplied") or 0)
    attached = sum(1 for row in rows if row.get("componentAttached"))
    initialized = sum(1 for row in rows if row.get("initialized"))
    runtime_ready = bool(unity.get("mainProjectSpineRuntimeAvailable"))
    scene_generated = bool(unity.get("sceneGenerated"))

    if visual_fix > 0 and initialized > 0 and capture_exists:
        visual_status = "partial_runtime_replay_capture_generated_manual_review_required"
        verdict = "화면 기준으로 MainInterface는 아직 정상 UI라고 말할 수 없다. 다만 UI116에서 route SkeletonGraphic replay 후보 캡처를 생성했다."
        next_blocker = "route SkeletonGraphic visual/layout validation against original/video evidence"
    elif unity_exit != 0:
        visual_status = "failed_unity_compile_or_probe"
        verdict = "화면 기준으로 MainInterface는 아직 정상 UI가 아니다. UI116 Unity compile/probe가 실패했다."
        next_blocker = "fix MainInterface Spine runtime compile/import errors"
    else:
        visual_status = "not_normal_trace_only_no_visual_fix"
        verdict = "화면 기준으로 MainInterface는 아직 정상 UI가 아니다. UI116은 안전한 visual replay 적용까지 도달하지 못했다."
        next_blocker = "fallback to MainInterface route replay scene inside Spine probe project"

    summary = {
        "generatedAt": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "visual_status": visual_status,
        "verdict": verdict,
        "unityExitCode": unity_exit,
        "runtimeReady": runtime_ready,
        "sceneGenerated": scene_generated,
        "visualFixApplied": visual_fix,
        "attachedTargets": attached,
        "initializedTargets": initialized,
        "capture": str(CAPTURE),
        "captureExists": capture_exists,
        "captureSize": CAPTURE.stat().st_size if capture_exists else 0,
        "clickValidation": {
            "generatedAt": click.get("generatedAt", ""),
            "active": click.get("activeButtons", ""),
            "clickable": click.get("raycastClickableButtons", ""),
            "blocked": click.get("raycastBlockedButtons", ""),
            "invoked": click.get("invokedClicks", ""),
        },
        "prep": prep,
        "unityProbe": unity,
        "rows": rows,
        "rootCmdCount": len(root_cmds),
        "rootCmds": [p.name for p in root_cmds],
        "restoreToolsDirectCmdCount": len(direct_cmds),
        "restoreToolsDirectCmds": [p.name for p in direct_cmds],
        "tool": str(TOOL_CMD),
        "nextBlocker": next_blocker,
    }
    write_json(OUT_JSON, summary)

    target_lines = []
    for row in rows:
        target_lines.append(
            f"| `{row.get('target','')}` | `{row.get('node','')}` | {row.get('sceneNodeFound')} | "
            f"{row.get('skeletonDataAssetLoaded')} | {row.get('componentAttached')} | {row.get('initialized')} | "
            f"`{row.get('decision','')}` | `{row.get('detail','')}` |"
        )
    if not target_lines:
        target_lines.append("| `none` | `none` | False | False | False | False | `no_rows` | `Unity probe did not write target rows.` |")

    click_line = f"{click.get('activeButtons','unknown')} / {click.get('raycastClickableButtons','unknown')} / {click.get('raycastBlockedButtons','unknown')} / {click.get('invokedClicks','unknown')}"
    md = [
        "# MainInterface 116 Import Real Spine4 Runtime Bridge For Route SkeletonGraphic Replay Result",
        "",
        f"Generated: {summary['generatedAt']} KST",
        "",
        "## Verdict",
        "",
        verdict,
        "",
        "No coordinate-only placement, whole atlas placement, crop guessing, fake icon, debug/path/evidence overlay, or arbitrary route bitmap placement was added.",
        "",
        "## A/B Path Decision",
        "",
        "| path | chosen | result | reason |",
        "| --- | ---: | --- | --- |",
        f"| A: import real Spine 4 runtime into `girlswar_maininterface_unity` | True | `{visual_status}` | MainInterface scene replay can only be proven inside the MainInterface project. |",
        "| B: build replay scene inside existing Spine probe project | False | `fallback_only` | Lower risk, but it would remain diagnostic and not prove final MainInterface scene integration. |",
        "",
        "## Counts",
        "",
        "| metric | value |",
        "| --- | ---: |",
        f"| Unity exit code | {unity_exit} |",
        f"| runtime package asset rows | {prep.get('runtimePackageAssetRows', 0)} |",
        f"| runtime package bytes | {prep.get('runtimePackageBytes', 0)} |",
        f"| runtime changed rows | {prep.get('runtimeChangedRows', 0)} |",
        f"| route raw asset copied | {prep.get('routeAssetCopy', {}).get('copiedCount', 0)} |",
        f"| main project Spine runtime ready | {runtime_ready} |",
        f"| visual fixes applied | {visual_fix} |",
        f"| attached targets | {attached} |",
        f"| initialized targets | {initialized} |",
        f"| capture exists | {capture_exists} |",
        "",
        "## Target Replay Decisions",
        "",
        "| target | node | scene node | SkeletonDataAsset | attached | initialized | decision | detail |",
        "| --- | --- | ---: | ---: | ---: | ---: | --- | --- |",
        *target_lines,
        "",
        "## Verification",
        "",
        "| check | result |",
        "| --- | --- |",
        f"| replay capture | `{CAPTURE}` |",
        f"| capture exists/size | `{capture_exists} / {summary['captureSize']}` |",
        f"| click validation generated | `{click.get('generatedAt', 'unknown')}` |",
        f"| active/clickable/blocked/invoked | `{click_line}` |",
        f"| root CMD count | `{len(root_cmds)}` |",
        f"| root CMDs | `{'; '.join(p.name for p in root_cmds)}` |",
        f"| `_restore_tools` direct CMD count | `{len(direct_cmds)}` |",
        "",
        "## Outputs",
        "",
        f"- JSON: `{OUT_JSON}`",
        f"- CSV: `{OUT_CSV}`",
        f"- Unity probe JSON: `{UNITY_JSON}`",
        f"- Unity probe CSV: `{UNITY_CSV}`",
        f"- Tool: `{TOOL_CMD}`",
        "",
        "## Remaining Blocker",
        "",
        f"Next blocker: `{next_blocker}`.",
    ]
    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps({
        "visual_status": visual_status,
        "runtimeReady": runtime_ready,
        "visualFixApplied": visual_fix,
        "attachedTargets": attached,
        "initializedTargets": initialized,
        "captureExists": capture_exists,
        "click": click_line,
        "rootCmdCount": len(root_cmds),
        "restoreToolsDirectCmdCount": len(direct_cmds),
        "report": str(OUT_MD),
        "nextBlocker": next_blocker,
    }, ensure_ascii=False, indent=2))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", choices=["prepare", "report"])
    parser.add_argument("--unity-exit", type=int, default=0)
    args = parser.parse_args()
    if args.mode == "prepare":
        prepare()
    else:
        final_report(args.unity_exit)


if __name__ == "__main__":
    main()
