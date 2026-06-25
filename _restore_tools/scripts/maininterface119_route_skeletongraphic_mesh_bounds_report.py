import json
from datetime import datetime
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORTS = BASE / "reports" / "maininterface"
RESULT_JSON = PROJECT / "Assets" / "RestoreData" / "maininterface_119_route_skeletongraphic_mesh_bounds_canvasrenderer_submesh_material.json"
RESULT_CSV = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_119_route_skeletongraphic_mesh_bounds_canvasrenderer_submesh_material.csv"
CLICK_JSON = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_click_validation_summary.json"
UI118_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_route_spine_runtime_ui_material_bound_1680x720.png"
REPORT_MD = REPORTS / "MAININTERFACE_119_VALIDATE_ROUTE_SKELETONGRAPHIC_MESH_BOUNDS_CANVASRENDERER_SUBMESH_MATERIAL_RESULT.md"
TOOL = BASE / "_restore_tools" / "cmd_archive" / "119_VALIDATE_ROUTE_SKELETONGRAPHIC_MESH_BOUNDS_CANVASRENDERER_SUBMESH_MATERIAL.cmd"


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def cmd_counts():
    root_cmds = sorted(p.name for p in BASE.glob("*.cmd"))
    direct_cmds = sorted(p.name for p in (BASE / "_restore_tools").glob("*.cmd"))
    return root_cmds, direct_cmds


def main():
    REPORTS.mkdir(parents=True, exist_ok=True)
    result = read_json(RESULT_JSON)
    click = read_json(CLICK_JSON)
    root_cmds, direct_cmds = cmd_counts()
    targets = result.get("targetRows") or []
    submeshes = result.get("submeshRows") or []
    attachments = result.get("attachmentRows") or []
    atlas_rows = result.get("atlasRows") or []

    candidate_attachments = [
        r for r in attachments
        if r.get("classification") == "large_route_shape_candidate_from_original_attachment"
    ]
    high_white = [
        r for r in atlas_rows
        if r.get("classification") == "high_white_visible_region_candidate"
    ]

    md = []
    md.append("# MainInterface 119 Validate Route SkeletonGraphic Mesh Bounds CanvasRenderer Submesh Material Result")
    md.append("")
    md.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} KST")
    md.append("")
    md.append("## Verdict")
    md.append("")
    md.append("화면 기준으로 MainInterface는 아직 정상 UI라고 말할 수 없다. UI119는 trace-only이며 흰 route 마름모/판을 좌표나 임의 hide로 제거하지 않았다.")
    md.append("")
    md.append("이번 추적에서 큰 흰 영역은 `Spine_shijieanniu`의 원본 drawOrder attachment 후보(`zhuye_di1`, `zhuye_bian`, `diqiu`)와 연결된다. 특히 `zhuye_di1`는 원본 atlas region과 runtime bounds가 큰 route frame 계층에 해당하므로, 원본 runtime mask/stencil/attachment visibility 증거 없이 제거하면 규칙 위반이다.")
    md.append("")
    md.append("## Counts")
    md.append("")
    md.append("| metric | value |")
    md.append("| --- | ---: |")
    md.append(f"| visual fixes applied | `{result.get('visualFixApplied', 0)}` |")
    md.append(f"| targets considered/traced | `{result.get('targetsConsidered', 0)} / {result.get('targetsTraced', 0)}` |")
    md.append(f"| submesh instructions | `{result.get('submeshInstructionCount', 0)}` |")
    md.append(f"| drawOrder attachment rows | `{result.get('attachmentCount', 0)}` |")
    md.append(f"| high-white atlas regions | `{result.get('highWhiteAtlasRegions', 0)}` |")
    md.append(f"| large route shape candidates | `{len(candidate_attachments)}` |")
    md.append("")
    md.append("## Target Mesh")
    md.append("")
    md.append("| target | node | mesh vertices | mesh bounds | CanvasRenderer materials | CanvasRenderer texture | mask state | decision |")
    md.append("| --- | --- | ---: | --- | ---: | --- | --- | --- |")
    for row in targets:
        mask = f"maskable={row.get('maskable')};Mask={row.get('hasMaskAncestor')};RectMask2D={row.get('hasRectMask2DAncestor')}"
        bounds = f"{row.get('meshBoundsCenter','')} / {row.get('meshBoundsSize','')}"
        md.append(f"| `{row.get('key','')}` | `{row.get('nodeName','')}` | `{row.get('meshVertexCount',0)}` | `{bounds}` | `{row.get('canvasRendererMaterialCount',0)}` | `{row.get('canvasRendererTexture','')}` | `{mask}` | `{row.get('decision','')}` |")
    md.append("")
    md.append("## Submesh Materials")
    md.append("")
    md.append("| target | submesh | slots | raw vertices | material | texture |")
    md.append("| --- | ---: | --- | ---: | --- | --- |")
    for row in submeshes:
        md.append(f"| `{row.get('key','')}` | `{row.get('submeshIndex',0)}` | `{row.get('startSlot',0)}-{row.get('endSlot',0)}` | `{row.get('rawVertexCount',0)}` | `{row.get('material','')}` | `{row.get('texture','')}` |")
    md.append("")
    md.append("## Attachment Candidates")
    md.append("")
    md.append("| target | drawOrder | slot | attachment | type | classification |")
    md.append("| --- | ---: | --- | --- | --- | --- |")
    for row in candidate_attachments[:12]:
        md.append(f"| `{row.get('key','')}` | `{row.get('drawOrder',0)}` | `{row.get('slotName','')}` | `{row.get('attachmentName','')}` | `{row.get('attachmentType','')}` | `{row.get('classification','')}` |")
    md.append("")
    md.append("## High-White Atlas Regions")
    md.append("")
    md.append("| target | region | bounds | alpha ratio | whiteish ratio | average RGBA |")
    md.append("| --- | --- | --- | ---: | ---: | --- |")
    for row in high_white[:12]:
        md.append(f"| `{row.get('key','')}` | `{row.get('regionName','')}` | `{row.get('bounds','')}` | `{row.get('alphaPixelRatio',0):.4f}` | `{row.get('whiteishRatio',0):.4f}` | `{row.get('averageRgba','')}` |")
    md.append("")
    md.append("## Verification")
    md.append("")
    md.append("| check | result |")
    md.append("| --- | --- |")
    md.append(f"| graphics capture reviewed | `{UI118_CAPTURE}` |")
    md.append(f"| new visual capture generated | `False` |")
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
    md.append(f"Next blocker: `{result.get('nextBlocker', 'route SkeletonGraphic original runtime mask/stencil/attachment visibility state for zhuye_di1 and world route frame')}`.")
    md.append("")
    REPORT_MD.write_text("\n".join(md), encoding="utf-8")


if __name__ == "__main__":
    main()
