import csv
import json
from pathlib import Path


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY = ROOT / "girlswar_maininterface_unity"
RESTORE = UNITY / "Assets" / "RestoreData"
REPORTS = ROOT / "reports" / "maininterface"

NAV_REPORT = REPORTS / "MAININTERFACE_BUTTON_NAVIGATION_TRACE.md"
LOAD_REPORT = REPORTS / "MAININTERFACE_NAVIGATION_TARGET_LOAD_PROTOTYPE_RESULT.md"
NAV_JSON = RESTORE / "maininterface_button_navigation_map.json"
PROBE_JSON = RESTORE / "maininterface_navigation_target_load_probe.json"
PROBE_CSV = RESTORE / "reports" / "maininterface_navigation_target_load_probe.csv"
CLICK_SUMMARY = RESTORE / "reports" / "maininterface_click_validation_summary.json"
CAPTURE_RESULT = UNITY / "Assets" / "RestoreCaptures" / "maininterface_capture_result.json"
CAPTURE_PNG = UNITY / "Assets" / "RestoreCaptures" / "maininterface_restored_1680x720.png"
BUILD_LOG = UNITY / "logs" / "unity_maininterface_button_navigation_build.log"
CAPTURE_LOG = UNITY / "logs" / "unity_maininterface_button_navigation_capture.log"
CLICK_LOG = UNITY / "logs" / "unity_maininterface_button_navigation_click_validation.log"
PROBE_LOG = UNITY / "logs" / "unity_maininterface_navigation_target_load_probe.log"


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def file_info(path: Path) -> str:
    if not path.exists():
        return "missing"
    return f"{path} ({path.stat().st_size} bytes)"


def count_navigation_log_lines() -> int:
    if not CLICK_LOG.exists():
        return 0
    text = CLICK_LOG.read_text(encoding="utf-8", errors="ignore")
    return text.count("[GirlsWarRestore][Navigation]")


def build_log_status() -> str:
    if not BUILD_LOG.exists():
        return "missing"
    text = BUILD_LOG.read_text(encoding="utf-8", errors="ignore")
    if "MainInterface restored scene generated" in text and "Applied button click loggers" in text:
        return "success"
    return "check_log"


def capture_status() -> tuple[str, str]:
    capture = read_json(CAPTURE_RESULT)
    visible = capture.get("visiblePixels", capture.get("visiblePixelCount", ""))
    status = "success" if CAPTURE_PNG.exists() and visible not in ("", 0, "0") else "check_log"
    return status, str(visible)


def update_navigation_report(nav: dict, click: dict, probe: dict) -> None:
    existing = NAV_REPORT.read_text(encoding="utf-8") if NAV_REPORT.exists() else ""
    marker = "\n## Final Verification\n"
    if marker in existing:
        existing = existing.split(marker, 1)[0].rstrip() + "\n"

    capture_ok, visible = capture_status()
    nav_lines = count_navigation_log_lines()
    section = [
        "## Final Verification",
        "",
        "| Check | Result | Evidence |",
        "| --- | --- | --- |",
        f"| Scene build | `{build_log_status()}` | `{BUILD_LOG}` |",
        f"| Graphics capture | `{capture_ok}` | `{CAPTURE_PNG}` visiblePixels=`{visible}` |",
        f"| Click validation generatedAt | `{click.get('generatedAt', '')}` | `{CLICK_SUMMARY}` |",
        f"| Active / clickable | `{click.get('activeButtons', '')}` / `{click.get('raycastClickableButtons', '')}` | blocked=`{click.get('raycastBlockedButtons', '')}`, invoked=`{click.get('invokedClicks', '')}` |",
        f"| Navigation harness log lines | `{nav_lines}` | `{CLICK_LOG}` |",
        f"| Harness connected buttons | `{nav.get('harnessConnectedCount', '')}` | `{NAV_JSON}` |",
        f"| Target load probe | `{probe.get('loadableUniqueTargets', '')}` loadable unique targets | `{PROBE_JSON}` |",
        "",
        "Harness note: the router only records original-evidence target keys and confirmed prefab/bundle candidates. It does not create fake pages and does not draw an overlay on the restored MainInterface scene.",
        "",
    ]
    NAV_REPORT.write_text(existing.rstrip() + "\n\n" + "\n".join(section), encoding="utf-8")


def write_load_report(nav: dict, click: dict, probe: dict, probe_rows: list[dict[str, str]]) -> None:
    targets = probe.get("targets", [])
    lines = [
        "# MainInterface Navigation Target Load Prototype Result",
        "",
        f"Generated: {probe.get('generatedAt', '')} KST",
        "",
        "## Verdict",
        "",
        "원본 handler/prefab evidence로 `target_prefab_resolved=1`인 MainInterface 버튼만 대상으로 실제 AssetBundle 로드 가능성을 probe했다. runtime/unknown/log-only 버튼은 임의 화면을 만들지 않고 제외했다.",
        "",
        "## Counts",
        "",
        "| Metric | Count |",
        "| --- | ---: |",
        f"| Navigation map active clickable rows | `{probe.get('activeClickableRows', '')}` |",
        f"| Target-prefab-resolved button rows | `{probe.get('targetPrefabResolvedButtonRows', '')}` |",
        f"| Unique target candidates | `{probe.get('uniqueTargetCandidates', '')}` |",
        f"| Loadable unique targets | `{probe.get('loadableUniqueTargets', '')}` |",
        f"| Failed unique targets | `{probe.get('failedUniqueTargets', '')}` |",
        f"| Log-only or unknown button rows | `{probe.get('logOnlyOrUnknownButtonRows', '')}` |",
        "",
        "## Target Probe Table",
        "",
        "| UIForm | Root | Bundle | Buttons | Status | Loaded prefab | Evidence path | Error |",
        "| --- | --- | --- | --- | --- | --- | --- | --- |",
    ]

    for target in targets:
        buttons = "; ".join(target.get("buttonNames", []))
        selected = target.get("selectedBundlePath", "")
        error = target.get("error", "")
        lines.append(
            f"| `{target.get('targetUiForm', '')}` | `{target.get('prefabRootName', '')}` | "
            f"`{target.get('prefabBundle', '')}` | `{buttons}` | `{target.get('status', '')}` | "
            f"`{target.get('loadedPrefabName', '')}` | `{selected}` | `{error}` |"
        )

    lines.extend(
        [
            "",
            "## Verification",
            "",
            "| Check | Result | Evidence |",
            "| --- | --- | --- |",
            f"| Click validation generatedAt | `{click.get('generatedAt', '')}` | `{CLICK_SUMMARY}` |",
            f"| Active / clickable / blocked / invoked | `{click.get('activeButtons', '')}` / `{click.get('raycastClickableButtons', '')}` / `{click.get('raycastBlockedButtons', '')}` / `{click.get('invokedClicks', '')}` | `{CLICK_LOG}` |",
            f"| Capture | `{file_info(CAPTURE_PNG)}` | `{CAPTURE_RESULT}` |",
            f"| Probe JSON | `{file_info(PROBE_JSON)}` | generated by `{PROBE_LOG}` |",
            f"| Probe CSV | `{file_info(PROBE_CSV)}` | rows=`{len(probe_rows)}` |",
            "",
            "## Deferred Targets",
            "",
            "These remain log-only until original runtime activity ids, event subscribers, or target prefab roots are resolved:",
            "",
            "- runtime activity targets: `onBtnLimit`, `onBtnActJump`, `UI_MainPageActItem` activity buttons, `onBtnAddHoly`, `faceGiftNode`",
            "- local-state targets: background arrows, activity banner toggle, watch animation",
            "- unknown/event targets without UIForm evidence: `UI_bg`, `p_chat_private_head`, chat event target, `worldwanfaBtn` idle target",
            "",
            "No debug overlay or synthetic target page was added.",
            "",
            "## Generated Files",
            "",
            f"- `{PROBE_JSON}`",
            f"- `{PROBE_CSV}`",
            f"- `{LOAD_REPORT}`",
        ]
    )
    LOAD_REPORT.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    nav = read_json(NAV_JSON)
    click = read_json(CLICK_SUMMARY)
    probe = read_json(PROBE_JSON)
    probe_rows = read_csv(PROBE_CSV)
    update_navigation_report(nav, click, probe)
    write_load_report(nav, click, probe, probe_rows)
    print(f"updated {NAV_REPORT}")
    print(f"wrote {LOAD_REPORT}")
    print(f"loadableUniqueTargets={probe.get('loadableUniqueTargets')} failedUniqueTargets={probe.get('failedUniqueTargets')}")


if __name__ == "__main__":
    main()
