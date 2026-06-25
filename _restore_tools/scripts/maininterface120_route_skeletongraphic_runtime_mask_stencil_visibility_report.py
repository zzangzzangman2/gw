import json
from datetime import datetime
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORTS = BASE / "reports" / "maininterface"
RESULT_JSON = PROJECT / "Assets" / "RestoreData" / "maininterface_120_route_skeletongraphic_original_runtime_mask_stencil_attachment_visibility.json"
RESULT_CSV = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_120_route_skeletongraphic_original_runtime_mask_stencil_attachment_visibility.csv"
CLICK_JSON = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_click_validation_summary.json"
UI118_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_route_spine_runtime_ui_material_bound_1680x720.png"
REPORT_MD = REPORTS / "MAININTERFACE_120_TRACE_ROUTE_SKELETONGRAPHIC_ORIGINAL_RUNTIME_MASK_STENCIL_ATTACHMENT_VISIBILITY_RESULT.md"
TOOL = BASE / "_restore_tools" / "cmd_archive" / "120_TRACE_ROUTE_SKELETONGRAPHIC_ORIGINAL_RUNTIME_MASK_STENCIL_ATTACHMENT_VISIBILITY.cmd"


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def cmd_counts():
    root_cmds = sorted(p.name for p in BASE.glob("*.cmd"))
    direct_cmds = sorted(p.name for p in (BASE / "_restore_tools").glob("*.cmd"))
    return root_cmds, direct_cmds


def fmt(value):
    if value is None:
        return ""
    if isinstance(value, float):
        return f"{value:.4f}"
    return str(value)


def main():
    REPORTS.mkdir(parents=True, exist_ok=True)
    result = read_json(RESULT_JSON)
    click = read_json(CLICK_JSON)
    root_cmds, direct_cmds = cmd_counts()
    targets = result.get("targetRows") or []
    attachments = result.get("attachmentRows") or []
    timelines = result.get("timelineRows") or []
    masks = result.get("maskRows") or []
    materials = result.get("materialRows") or []

    candidate_attachments = [
        r for r in attachments
        if r.get("classification") in ("candidate_attachment_visibility_sample", "spine_clipping_attachment_present")
    ]
    off_candidates = [
        r for r in candidate_attachments
        if (not r.get("visible")) or float(r.get("alpha") or 0) <= 0.001 or not r.get("attachmentName")
    ]
    clipping_rows = [
        r for r in attachments
        if "Clipping" in (r.get("attachmentType") or "")
    ]
    mask_rows = [
        r for r in masks
        if r.get("kind") in ("Mask", "RectMask2D")
    ]
    nonzero_stencil = [
        r for r in materials
        if r.get("hasStencilProperty") and abs(float(r.get("stencil") or 0)) > 0.001
    ]
    candidate_timeline = [
        r for r in timelines
        if r.get("classification") in ("candidate_attachment_timeline", "candidate_color_or_alpha_timeline", "draw_order_timeline")
    ]

    md = []
    md.append("# MainInterface 120 Trace Route SkeletonGraphic Original Runtime Mask Stencil Attachment Visibility Result")
    md.append("")
    md.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} KST")
    md.append("")
    md.append("## Verdict")
    md.append("")
    md.append("화면 기준으로 MainInterface는 아직 정상 UI라고 말할 수 없다. UI120은 trace-only이며 흰 route 마름모/판을 좌표, 스케일, 임의 hide, whole-atlas, fake panel로 제거하지 않았다.")
    md.append("")
    md.append(result.get("decision") or "No evidence-backed visual patch was applied.")
    md.append("")
    md.append("## Counts")
    md.append("")
    md.append("| metric | value |")
    md.append("| --- | ---: |")
    md.append(f"| visual fixes applied | `{result.get('visualFixApplied', 0)}` |")
    md.append(f"| targets considered/traced | `{result.get('targetsConsidered', 0)} / {result.get('targetsTraced', 0)}` |")
    md.append(f"| attachment sample rows | `{result.get('sampleRows', 0)}` |")
    md.append(f"| timeline rows | `{result.get('timelineRowsCount', 0)}` |")
    md.append(f"| candidate visible/off rows | `{len(candidate_attachments) - len(off_candidates)} / {len(off_candidates)}` |")
    md.append(f"| clipping attachment rows | `{len(clipping_rows)}` |")
    md.append(f"| Mask/RectMask2D ancestor rows | `{len(mask_rows)}` |")
    md.append(f"| non-zero stencil material rows | `{len(nonzero_stencil)}` |")
    md.append("")
    md.append("## Target")
    md.append("")
    md.append("| key | node | animation | mesh | CanvasRenderer texture | main texture | mask/stencil decision |")
    md.append("| --- | --- | --- | --- | --- | --- | --- |")
    for row in targets:
        mesh = f"{row.get('meshVertexCount',0)}/{row.get('meshTriangleIndexCount',0)} sub={row.get('meshSubMeshCount',0)} bounds={row.get('meshBoundsSize','')}"
        decision = f"{row.get('decision','')}; candidate visible/off={row.get('candidateVisibleRows',0)}/{row.get('candidateInvisibleRows',0)}"
        md.append(f"| `{row.get('key','')}` | `{row.get('nodeName','')}` | `{row.get('expectedAnimation','')}` found=`{row.get('animationFound')}` dur=`{fmt(row.get('animationDuration'))}` | `{mesh}` | `{row.get('canvasRendererTexture','')}` | `{row.get('mainTexture','')}` | `{decision}` |")
    md.append("")
    md.append("## Candidate Attachment Samples")
    md.append("")
    md.append("| sample | time | drawOrder | slot | attachment | type | visible | alpha | color |")
    md.append("| --- | ---: | ---: | --- | --- | --- | --- | ---: | --- |")
    for row in candidate_attachments[:36]:
        md.append(f"| `{row.get('sampleKind','')}` | `{fmt(row.get('sampleTime'))}` | `{row.get('drawOrder',0)}` | `{row.get('slotName','')}` | `{row.get('attachmentName','')}` | `{row.get('attachmentType','')}` | `{row.get('visible')}` | `{fmt(row.get('alpha'))}` | `{row.get('color','')}` |")
    md.append("")
    md.append("## Timeline Evidence")
    md.append("")
    md.append("| type | slot | bone | frames | attachments | classification |")
    md.append("| --- | --- | --- | ---: | --- | --- |")
    for row in candidate_timeline[:24]:
        md.append(f"| `{row.get('timelineType','')}` | `{row.get('slotName','')}` | `{row.get('boneName','')}` | `{row.get('frameCount',0)}` | `{row.get('attachmentNames','')}` | `{row.get('classification','')}` |")
    md.append("")
    md.append("## Mask And Stencil")
    md.append("")
    md.append("| kind/source | path/material | enabled | detail | classification |")
    md.append("| --- | --- | --- | --- | --- |")
    for row in masks[:20]:
        detail = f"maskable={row.get('maskable')};raycast={row.get('raycastTarget')};alpha={fmt(row.get('alpha'))};canvasTexture={row.get('canvasRendererTexture','')}"
        md.append(f"| `{row.get('kind','')}` | `{row.get('path','')}` | `{row.get('enabled')}` | `{detail}` | `{row.get('classification','')}` |")
    for row in materials[:12]:
        detail = f"shader={row.get('shaderName','')};tex={row.get('mainTexture','')};stencil={row.get('stencil')};comp={row.get('stencilComp')};read/write={row.get('stencilReadMask')}/{row.get('stencilWriteMask')}"
        md.append(f"| `Material:{row.get('source','')}` | `{row.get('materialName','')}` | `` | `{detail}` | `{row.get('classification','')}` |")
    md.append("")
    md.append("## Verification")
    md.append("")
    md.append("| check | result |")
    md.append("| --- | --- |")
    md.append(f"| graphics capture reviewed | `{UI118_CAPTURE}` |")
    md.append("| new visual capture generated | `False` |")
    md.append(f"| click validation generated | `{click.get('generatedAt','')}` |")
    md.append(f"| active/clickable/blocked/invoked | `{click.get('activeButtons','')} / {click.get('raycastClickableButtons','')} / {click.get('raycastBlockedButtons','')} / {click.get('invokedClicks','')}` |")
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
    md.append(f"Next blocker: `{result.get('nextBlocker', 'route SkeletonGraphic CanvasRenderer texture handoff and clipping triangulation verification for zong1/zhuye_di1')}`.")
    md.append("")
    REPORT_MD.write_text("\n".join(md), encoding="utf-8")


if __name__ == "__main__":
    main()
