import csv
import json
from datetime import datetime
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORTS = BASE / "reports" / "maininterface"
RESULT_JSON = PROJECT / "Assets" / "RestoreData" / "maininterface_117_route_skeletongraphic_layout_validation.json"
RESULT_CSV = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_117_route_skeletongraphic_layout_validation.csv"
CLICK_JSON = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_click_validation_summary.json"
REPORT_MD = REPORTS / "MAININTERFACE_117_VALIDATE_AND_FIX_ROUTE_SKELETONGRAPHIC_LAYOUT_AGAINST_ORIGINAL_EVIDENCE_RESULT.md"
CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_route_spine_runtime_bridge_validated_1680x720.png"
TOOL = BASE / "_restore_tools" / "cmd_archive" / "117_VALIDATE_AND_FIX_ROUTE_SKELETONGRAPHIC_LAYOUT_AGAINST_ORIGINAL_EVIDENCE.cmd"


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def cmd_counts():
    root_cmds = sorted(p.name for p in BASE.glob("*.cmd"))
    direct_cmds = sorted(p.name for p in (BASE / "_restore_tools").glob("*.cmd"))
    return root_cmds, direct_cmds


def load_rows(kind: str):
    if not RESULT_CSV.exists():
        return []
    with RESULT_CSV.open("r", encoding="utf-8-sig", newline="") as f:
        return [r for r in csv.DictReader(f) if r.get("kind") == kind]


def main():
    REPORTS.mkdir(parents=True, exist_ok=True)
    result = read_json(RESULT_JSON)
    click = read_json(CLICK_JSON)
    root_cmds, direct_cmds = cmd_counts()
    targets = result.get("targetRows", []) or []
    fallbacks = result.get("fallbackRows", []) or []
    tmp_rows = result.get("tmpRows", []) or []

    active = click.get("activeButtons", click.get("active", ""))
    clickable = click.get("raycastClickableButtons", click.get("clickableButtons", click.get("clickable", "")))
    blocked = click.get("raycastBlockedButtons", click.get("blockedButtons", click.get("blocked", "")))
    invoked = click.get("invokedClicks", click.get("invokedButtons", click.get("invoked", "")))

    visual_verdict = result.get("visualVerdict", "not_normal_missing_result")
    verdict_line = "화면 기준으로 MainInterface는 아직 정상 UI라고 말할 수 없다."
    if "partial_candidate" in visual_verdict:
        verdict_line += " UI117은 원본 SpineGraphic이 확인된 후보 씬에서 이전 bitmap fallback 이중 렌더 가능성만 제거한 partial 후보이다."

    md = []
    md.append("# MainInterface 117 Validate And Fix Route SkeletonGraphic Layout Against Original Evidence Result")
    md.append("")
    md.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} KST")
    md.append("")
    md.append("## Verdict")
    md.append("")
    md.append(verdict_line)
    md.append("")
    md.append("Manual visual review: validated capture still shows a large white route diamond/panel around the world route cluster, so this is partial evidence cleanup, not a normal final MainInterface.")
    md.append("")
    md.append("좌표 보정, whole atlas 배치, crop guessing, fake icon, debug/path/evidence overlay는 추가하지 않았다. UI117 패치는 별도 replay 후보 씬에서 원본 SkeletonGraphic runtime evidence가 붙은 경우에만 synthetic fallback 레이어를 비활성화한다.")
    md.append("")
    md.append("## Counts")
    md.append("")
    md.append("| metric | value |")
    md.append("| --- | ---: |")
    md.append(f"| visual fixes applied | `{result.get('visualFixApplied', 0)}` |")
    md.append(f"| skeleton targets found | `{result.get('skeletonTargetsFound', 0)}` |")
    md.append(f"| SkeletonGraphic attached | `{result.get('skeletonGraphicAttached', 0)}` |")
    md.append(f"| Rect/sibling evidence matched | `{result.get('skeletonGraphicRectEvidenceMatched', 0)}` |")
    md.append(f"| animation evidence matched | `{result.get('skeletonGraphicAnimationEvidenceMatched', 0)}` |")
    md.append(f"| route TMP rows | `{result.get('tmpRouteRows', 0)}` |")
    md.append(f"| route TMP variant ok | `{result.get('tmpRouteVariantOk', 0)}` |")
    md.append(f"| interim fallback rows | `{result.get('interimFallbackRows', 0)}` |")
    md.append(f"| interim fallback suppressed | `{result.get('interimFallbackSuppressed', 0)}` |")
    md.append(f"| capture exists/size | `{CAPTURE.exists()} / {CAPTURE.stat().st_size if CAPTURE.exists() else 0}` |")
    md.append(f"| visible pixels | `{result.get('visiblePixelCount', 0)}` |")
    md.append(f"| magenta pixels | `{result.get('magentaPixelCount', 0)}` |")
    md.append("")
    md.append("## SkeletonGraphic Evidence")
    md.append("")
    md.append("| target | node | rect/sibling | animation | material | decision |")
    md.append("| --- | --- | --- | --- | --- | --- |")
    for row in targets:
        rect = f"{row.get('anchoredPosition','')} / {row.get('sizeDelta','')} / {row.get('localScale','')} / sibling {row.get('siblingIndex','')}"
        anim = f"{row.get('startingAnimation','')} / expected {row.get('expectedAnimation','')}"
        material = f"{row.get('materialName','')} / {row.get('shaderName','')}"
        md.append(f"| `{row.get('skeletonKey','')}` | `{row.get('nodeName','')}` | `{rect}` | `{anim}` | `{material}` | `{row.get('decision','')}` |")
    md.append("")
    md.append("## Interim Fallback Decision")
    md.append("")
    md.append("| layer | active after | decision | reason |")
    md.append("| --- | ---: | --- | --- |")
    for row in fallbacks:
        md.append(f"| `{row.get('name','')}` | `{row.get('activeInHierarchyAfter', False)}` | `{row.get('decision','')}` | {row.get('reason','')} |")
    md.append("")
    md.append("## Route TMP Check")
    md.append("")
    md.append("| text | size | font | material | decision |")
    md.append("| --- | --- | --- | --- | --- |")
    for row in tmp_rows[:12]:
        md.append(f"| `{row.get('text','')}` | `{row.get('sizeDelta','')}` | `{row.get('fontAsset','')}` | `{row.get('material','')}` | `{row.get('decision','')}` |")
    md.append("")
    md.append("## Verification")
    md.append("")
    md.append("| check | result |")
    md.append("| --- | --- |")
    md.append(f"| validated scene | `{PROJECT / 'Assets' / 'Scenes' / 'MainInterface_RouteSpineRuntimeReplay_Validated.unity'}` |")
    md.append(f"| graphics capture | `{CAPTURE}` |")
    md.append(f"| click validation generated | `{click.get('generatedAt','')}` |")
    md.append(f"| active/clickable/blocked/invoked | `{active} / {clickable} / {blocked} / {invoked}` |")
    md.append(f"| root CMD count | `{len(root_cmds)}` |")
    md.append(f"| root CMDs | `{', '.join(root_cmds)}` |")
    md.append(f"| `_restore_tools` direct CMD count | `{len(direct_cmds)}` |")
    md.append(f"| `_restore_tools` direct CMDs | `{', '.join(direct_cmds)}` |")
    md.append("")
    md.append("## Outputs")
    md.append("")
    md.append(f"- JSON: `{RESULT_JSON}`")
    md.append(f"- CSV: `{RESULT_CSV}`")
    md.append(f"- Tool: `{TOOL}`")
    md.append("")
    md.append("## Remaining Blocker")
    md.append("")
    next_blocker = result.get("nextBlocker", "route SkeletonGraphic UI material/shader pass binding validation against original runtime fields")
    shaders = {row.get("shaderName", "") for row in targets if row.get("shaderName")}
    if "Spine/Skeleton" in shaders:
        next_blocker = "route SkeletonGraphic UI material/shader pass binding validation against original SkeletonGraphic runtime fields"
    md.append(f"Next blocker: `{next_blocker}`.")
    md.append("")
    REPORT_MD.write_text("\n".join(md), encoding="utf-8")


if __name__ == "__main__":
    main()
