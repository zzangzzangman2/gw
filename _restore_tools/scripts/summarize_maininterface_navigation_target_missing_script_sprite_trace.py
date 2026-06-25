import csv
import json
from pathlib import Path


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY = ROOT / "girlswar_maininterface_unity"
RESTORE = UNITY / "Assets" / "RestoreData"
REPORTS = ROOT / "reports" / "maininterface"

TRACE_JSON = RESTORE / "maininterface_navigation_target_missing_script_sprite_trace.json"
TRACE_CSV = RESTORE / "reports" / "maininterface_navigation_target_missing_script_sprite_trace.csv"
TRACE_CAPTURE_JSON = RESTORE / "maininterface_navigation_target_missing_script_sprite_trace_capture.json"
CLICK_SUMMARY = RESTORE / "reports" / "maininterface_click_validation_summary.json"
REPORT_MD = REPORTS / "MAININTERFACE_NAVIGATION_TARGET_MISSING_SCRIPT_AND_SPRITE_REFERENCE_TRACE_RESULT.md"
CLICK_LOG = UNITY / "logs" / "unity_maininterface_button_navigation_click_validation.log"
TRACE_LOG = UNITY / "logs" / "unity_maininterface_navigation_target_missing_script_sprite_trace.log"
TOOL = ROOT / "_restore_tools" / "105_TRACE_MAININTERFACE_NAVIGATION_TARGET_MISSING_SCRIPT_AND_SPRITES.cmd"


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


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    trace = read_json(TRACE_JSON)
    capture = read_json(TRACE_CAPTURE_JSON)
    click = read_json(CLICK_SUMMARY)
    rows = read_csv(TRACE_CSV)
    targets = trace.get("targets", [])
    guild = next((t for t in targets if t.get("prefabRootName") == "UI_GuildMain"), {})

    recommendation = "target runtime Lua/XLua initialization tracing"
    if guild.get("topWhiteAreas"):
        cause_classes = {r.get("causeClass", "") for r in guild.get("topWhiteAreas", [])}
        if cause_classes == {"null_sprite_no_serialized_reference"}:
            recommendation = "target runtime Lua/XLua initialization tracing"
        else:
            recommendation = "sprite/atlas slice join"

    lines = [
        "# MainInterface Navigation Target Missing Script And Sprite Reference Trace Result",
        "",
        f"Generated: {trace.get('generatedAt', '')} KST",
        "",
        "## Verdict",
        "",
        "5개 navigation target prefab을 실제 instantiate한 상태에서 Image/RawImage/Text/TMP/Button/MonoBehaviour 상태를 분리했다. 좌표 보정이나 synthetic panel은 적용하지 않았고, 원본 prefab hierarchy/RectTransform/local id와 SerializedObject reference evidence만 기록했다.",
        "",
        "## Counts",
        "",
        "| Metric | Count |",
        "| --- | ---: |",
        f"| Targets traced | `{trace.get('targetCount', '')}` |",
        f"| Total Image components | `{trace.get('totalImageCount', '')}` |",
        f"| Total Image null sprite | `{trace.get('totalImageNullSpriteCount', '')}` |",
        f"| Total white no-sprite Image | `{trace.get('totalWhiteNoSpriteImageCount', '')}` |",
        f"| Total missing script components | `{trace.get('totalMissingScriptComponentCount', '')}` |",
        f"| Total missing script objects | `{trace.get('totalMissingScriptObjectCount', '')}` |",
        f"| Applied sprite/slice fixes | `{trace.get('appliedSpriteSliceFixCount', '')}` |",
        "",
        "## Target Breakdown",
        "",
        "| Target | Images | Null sprite | Resolved sprite | White no-sprite | Missing script comps | Missing script objects | Buttons | TMP | Blocker |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |",
    ]

    for target in targets:
        lines.append(
            f"| `{target.get('prefabRootName', '')}` | `{target.get('imageCount', '')}` | "
            f"`{target.get('imageNullSpriteCount', '')}` | `{target.get('imageResolvedSpriteCount', '')}` | "
            f"`{target.get('whiteNoSpriteImageCount', '')}` | `{target.get('missingScriptComponentCount', '')}` | "
            f"`{target.get('missingScriptObjectCount', '')}` | `{target.get('buttonCount', '')}` | "
            f"`{target.get('tmpTextCount', '')}` | `{target.get('blocker', '')}` |"
        )

    lines.extend(
        [
            "",
            "## UI_GuildMain Top White Areas",
            "",
            "| Rank | Hierarchy path | Area | Size | Local id | Sprite ref | Cause | Active |",
            "| ---: | --- | ---: | --- | ---: | --- | --- | --- |",
        ]
    )

    for index, area in enumerate(guild.get("topWhiteAreas", [])[:30], start=1):
        lines.append(
            f"| `{index}` | `{area.get('hierarchyPath', '')}` | `{area.get('rectArea', '')}` | "
            f"`{area.get('sizeDeltaX', '')}x{area.get('sizeDeltaY', '')}` | "
            f"`{area.get('imageComponentLocalId', '')}` | `{area.get('spriteReferenceString', '')}` | "
            f"`{area.get('causeClass', '')}` | `{area.get('activeInHierarchy', '')}` |"
        )

    lines.extend(
        [
            "",
            "## Evidence Interpretation",
            "",
            "- `Image component exists but sprite is null` is the dominant class. These are not missing UnityEngine.UI.Image components.",
            "- `null_sprite_no_serialized_reference` on the largest `UI_GuildMain` white areas means the loaded prefab does not carry a direct serialized Sprite reference that can be safely mapped to a slice in this pass.",
            "- Missing MonoBehaviour counts remain high, so many visual elements are likely initialized by original Lua/XLua/controller scripts after prefab load.",
            "- No sprite/slice fix was applied because no top white area produced a concrete original sprite pathID/name/fileID evidence chain. Whole-atlas fallback was intentionally not used.",
            "",
            "## After Trace Capture",
            "",
            "| Metric | Count |",
            "| --- | ---: |",
            f"| Captures | `{capture.get('targetCount', '')}` |",
            f"| Capture success | `{capture.get('captureSuccessCount', '')}` |",
            f"| Blank suspicion | `{capture.get('blankSuspicionCount', '')}` |",
            f"| White placeholder suspicion | `{capture.get('whitePlaceholderSuspicionCount', '')}` |",
            "",
            "## Verification",
            "",
            "| Check | Result | Evidence |",
            "| --- | --- | --- |",
            f"| Trace JSON | `{file_info(TRACE_JSON)}` | `{TRACE_LOG}` |",
            f"| Trace CSV | `{file_info(TRACE_CSV)}` | rows=`{len(rows)}` |",
            f"| Trace capture JSON | `{file_info(TRACE_CAPTURE_JSON)}` | after trace capture directory |",
            f"| Click validation generatedAt | `{click.get('generatedAt', '')}` | `{CLICK_SUMMARY}` |",
            f"| Active / clickable / blocked / invoked | `{click.get('activeButtons', '')}` / `{click.get('raycastClickableButtons', '')}` / `{click.get('raycastBlockedButtons', '')}` / `{click.get('invokedClicks', '')}` | `{CLICK_LOG}` |",
            f"| Tool | `{TOOL}` | no source/evidence deletion |",
            "",
            "## Recommendation",
            "",
            f"Next: `{recommendation}`",
            "",
            "## Generated Files",
            "",
            f"- `{TRACE_JSON}`",
            f"- `{TRACE_CSV}`",
            f"- `{REPORT_MD}`",
        ]
    )

    REPORT_MD.write_text("\n".join(lines), encoding="utf-8")
    print(f"wrote {REPORT_MD}")
    print(
        f"targets={trace.get('targetCount')} nullSprites={trace.get('totalImageNullSpriteCount')} "
        f"missingScriptComponents={trace.get('totalMissingScriptComponentCount')} recommendation={recommendation}"
    )


if __name__ == "__main__":
    main()
