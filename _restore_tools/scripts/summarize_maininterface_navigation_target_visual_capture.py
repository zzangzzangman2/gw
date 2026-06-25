import csv
import json
import re
from pathlib import Path


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY = ROOT / "girlswar_maininterface_unity"
RESTORE = UNITY / "Assets" / "RestoreData"
REPORTS = ROOT / "reports" / "maininterface"

RESULT_JSON = RESTORE / "maininterface_navigation_target_visual_capture_result.json"
RESULT_CSV = RESTORE / "reports" / "maininterface_navigation_target_visual_capture_result.csv"
CLICK_SUMMARY = RESTORE / "reports" / "maininterface_click_validation_summary.json"
REPORT_MD = REPORTS / "MAININTERFACE_NAVIGATION_TARGET_VISUAL_LAYOUT_CAPTURE_RESULT.md"
CAPTURE_LOG = UNITY / "logs" / "unity_maininterface_navigation_target_visual_capture.log"
CLICK_LOG = UNITY / "logs" / "unity_maininterface_button_navigation_click_validation.log"
PROTOTYPE_SCENE = UNITY / "Assets" / "Scenes" / "MainInterface_NavigationPrototype.unity"


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


def unity_warning_counts() -> tuple[int, int, list[str]]:
    if not CAPTURE_LOG.exists():
        return 0, 0, []
    text = CAPTURE_LOG.read_text(encoding="utf-8", errors="ignore")
    missing_script = len(re.findall(r"missing script|script.*missing", text, flags=re.IGNORECASE))
    missing_material = len(re.findall(r"missing material|material.*missing", text, flags=re.IGNORECASE))
    interesting = []
    for line in text.splitlines():
        low = line.lower()
        if "missing" in low or "shader" in low or "material" in low or "exception" in low or "error" in low:
            if "licensing" in low or "curl error 42" in low:
                continue
            interesting.append(line.strip())
    return missing_script, missing_material, interesting[:20]


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    result = read_json(RESULT_JSON)
    click = read_json(CLICK_SUMMARY)
    rows = read_csv(RESULT_CSV)
    missing_script_log, missing_material_log, interesting_log = unity_warning_counts()
    targets = result.get("targets", [])

    worst = sorted(
        targets,
        key=lambda r: (
            int(bool(r.get("blankSuspicion"))),
            int(bool(r.get("whitePlaceholderSuspicion"))),
            int(r.get("missingScriptObjectCount", 0) or 0),
            int(r.get("whiteNoSpriteImageCount", 0) or 0),
            int(r.get("missingImageSpriteCount", 0) or 0),
        ),
        reverse=True,
    )
    worst_names = ", ".join(t.get("prefabRootName", "") for t in worst[:2] if t)
    recommendation = (
        "target prefab visual/layout fixes"
        if int(result.get("whitePlaceholderSuspicionCount", 0) or 0) > 0
        or any(int(t.get("missingScriptObjectCount", 0) or 0) > 0 for t in targets)
        else "remaining 18 log-only target resolution"
    )

    lines = [
        "# MainInterface Navigation Target Visual Layout Capture Result",
        "",
        f"Generated: {result.get('generatedAt', '')} KST",
        "",
        "## Verdict",
        "",
        "Prototype scene에서 loadable target prefab 5개를 하나씩 실제 instantiate한 뒤 1680x720 그래픽 캡처를 생성했다. 좌표 보정이나 synthetic page 없이 원본 prefab hierarchy/RectTransform/anchor/localScale을 그대로 사용했다.",
        "",
        "## Counts",
        "",
        "| Metric | Count |",
        "| --- | ---: |",
        f"| Target captures | `{result.get('targetCount', '')}` |",
        f"| Capture success | `{result.get('captureSuccessCount', '')}` |",
        f"| Blank suspicion | `{result.get('blankSuspicionCount', '')}` |",
        f"| White placeholder suspicion | `{result.get('whitePlaceholderSuspicionCount', '')}` |",
        f"| Unity log missing-script warnings | `{missing_script_log}` |",
        f"| Unity log missing-material warnings | `{missing_material_log}` |",
        "",
        "## Capture Table",
        "",
        "| Target | PNG | Visible px | Objects | Rects | Missing sprite | White no-sprite | RawImage no texture | Missing script objs | Blank? | White? |",
        "| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |",
    ]

    for target in targets:
        lines.append(
            f"| `{target.get('prefabRootName', '')}` | `{target.get('capturePath', '')}` | "
            f"`{target.get('visiblePixelCount', '')}` | `{target.get('instantiatedObjectCount', '')}` | "
            f"`{target.get('rectTransformCount', '')}` | `{target.get('missingImageSpriteCount', '')}` | "
            f"`{target.get('whiteNoSpriteImageCount', '')}` | `{target.get('rawImageMissingTextureCount', '')}` | "
            f"`{target.get('missingScriptObjectCount', '')}` | `{target.get('blankSuspicion', '')}` | "
            f"`{target.get('whitePlaceholderSuspicion', '')}` |"
        )

    lines.extend(
        [
            "",
            "## Worst Targets / Issues",
            "",
            f"- Worst target candidates by automatic checks: `{worst_names or 'none'}`",
            "- Direct visual spot-check: `UI_GuildMain` renders as an almost full white screen, matching its `0.9983` white-ish visible ratio and hundreds of white no-sprite Images.",
            "- Direct visual spot-check: `UI_SystemSettings` capture still shows the MainInterface background more than a completed settings panel, so the next problem is target prefab dependency/script/sprite restoration, not manual screen-coordinate nudging.",
            "- A white placeholder suspicion means either a white no-sprite Image exists inside the instantiated prefab or a large share of visible pixels are white-ish. This is a triage signal, not a coordinate fix.",
            "- Missing sprite/material/script issues must be fixed from original prefab, sprite slice, material, font, shader, and dependency evidence rather than screen-coordinate adjustment.",
            "",
            "## Verification",
            "",
            "| Check | Result | Evidence |",
            "| --- | --- | --- |",
            f"| Prototype scene | `{file_info(PROTOTYPE_SCENE)}` | source scene remains separate |",
            f"| Visual capture JSON | `{file_info(RESULT_JSON)}` | `{CAPTURE_LOG}` |",
            f"| Visual capture CSV | `{file_info(RESULT_CSV)}` | rows=`{len(rows)}` |",
            f"| Click validation generatedAt | `{click.get('generatedAt', '')}` | `{CLICK_SUMMARY}` |",
            f"| Active / clickable / blocked / invoked | `{click.get('activeButtons', '')}` / `{click.get('raycastClickableButtons', '')}` / `{click.get('raycastBlockedButtons', '')}` / `{click.get('invokedClicks', '')}` | `{CLICK_LOG}` |",
            "",
            "## Unity Log Notes",
            "",
        ]
    )

    if interesting_log:
        for line in interesting_log:
            lines.append(f"- `{line}`")
    else:
        lines.append("- No relevant missing material/script log lines were found beyond existing Unity/licensing noise.")

    lines.extend(
        [
            "",
            "## Recommendation",
            "",
            f"Next: `{recommendation}`",
            "",
            "## Generated Files",
            "",
            f"- `{RESULT_JSON}`",
            f"- `{RESULT_CSV}`",
            f"- `{REPORT_MD}`",
        ]
    )

    REPORT_MD.write_text("\n".join(lines), encoding="utf-8")
    print(f"wrote {REPORT_MD}")
    print(
        f"captures={result.get('targetCount')} blank={result.get('blankSuspicionCount')} "
        f"white={result.get('whitePlaceholderSuspicionCount')} recommendation={recommendation}"
    )


if __name__ == "__main__":
    main()
