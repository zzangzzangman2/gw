import json
from datetime import datetime
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORTS = BASE / "reports" / "maininterface"
RESULT_JSON = PROJECT / "Assets" / "RestoreData" / "maininterface_121_route_skeletongraphic_canvasrenderer_texture_handoff_clipping_zong1.json"
RESULT_CSV = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_121_route_skeletongraphic_canvasrenderer_texture_handoff_clipping_zong1.csv"
CLICK_JSON = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_click_validation_summary.json"
UI118_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_route_spine_runtime_ui_material_bound_1680x720.png"
REPORT_MD = REPORTS / "MAININTERFACE_121_VERIFY_ROUTE_SKELETONGRAPHIC_CANVASRENDERER_TEXTURE_HANDOFF_AND_CLIPPING_TRIANGULATION_ZONG1_RESULT.md"
TOOL = BASE / "_restore_tools" / "cmd_archive" / "121_VERIFY_ROUTE_SKELETONGRAPHIC_CANVASRENDERER_TEXTURE_HANDOFF_AND_CLIPPING_TRIANGULATION_ZONG1.cmd"


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
    textures = result.get("textureRows") or []
    clips = result.get("clipRows") or []
    uvs = result.get("uvRows") or []
    instructions = result.get("instructionRows") or []

    pre_clip = [r for r in clips if r.get("classification") == "pre_clipping_unclipped_attachment"]
    clipped = [r for r in clips if str(r.get("classification", "")).startswith("clipping_")]
    texture_present = [r for r in textures if r.get("effectiveTexturePresent")]
    texture_missing_expected = [
        r for r in textures
        if r.get("expectedTexturePresent") and not r.get("effectiveTexturePresent")
    ]

    md = []
    md.append("# MainInterface 121 Verify Route SkeletonGraphic CanvasRenderer Texture Handoff And Clipping Triangulation Zong1 Result")
    md.append("")
    md.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} KST")
    md.append("")
    md.append("## Verdict")
    md.append("")
    md.append("화면 기준으로 MainInterface는 아직 정상 UI라고 말할 수 없다. UI121은 trace-only이며 좌표/스케일/임의 hide/whole-atlas/fake panel 없이 `zong1` clipping과 texture handoff만 검증했다.")
    md.append("")
    md.append(result.get("decision") or "No evidence-backed visual patch was applied.")
    md.append("")
    md.append("## Counts")
    md.append("")
    md.append("| metric | value |")
    md.append("| --- | ---: |")
    md.append(f"| visual fixes applied | `{result.get('visualFixApplied', 0)}` |")
    md.append(f"| targets considered/traced | `{result.get('targetsConsidered', 0)} / {result.get('targetsTraced', 0)}` |")
    md.append(f"| clip rows / clipped rows | `{result.get('clipRowsCount', 0)} / {result.get('clippedRows', 0)}` |")
    md.append(f"| pre-clip zhuye rows | `{result.get('preClipCandidateRows', 0)}` |")
    md.append(f"| UV region rows | `{result.get('uvRowsCount', 0)}` |")
    md.append(f"| texture present / expected-missing rows | `{len(texture_present)} / {len(texture_missing_expected)}` |")
    md.append("")
    md.append("## Target")
    md.append("")
    md.append("| key | mesh | instructions | texture path | decision |")
    md.append("| --- | --- | --- | --- | --- |")
    for row in targets:
        mesh = f"{row.get('meshVertexCount',0)}/{row.get('meshTriangleIndexCount',0)} sub={row.get('meshSubMeshCount',0)} bounds={row.get('meshBoundsSize','')}"
        instr = f"found={row.get('currentInstructionsFound')};activeClip={row.get('hasActiveClipping')};submesh={row.get('instructionSubmeshCount')}"
        tex = f"main={row.get('mainTexture','')};base={row.get('baseTexture','')};canvas={row.get('canvasRendererTexture','')}"
        md.append(f"| `{row.get('key','')}` | `{mesh}` | `{instr}` | `{tex}` | `{row.get('decision','')}` |")
    md.append("")
    md.append("## Clipping")
    md.append("")
    md.append("| drawOrder | slot | attachment | clip active | raw verts/tris | clipped verts/tris | bounds | classification |")
    md.append("| ---: | --- | --- | --- | --- | --- | --- | --- |")
    for row in clips:
        raw = f"{row.get('rawVertexCount',0)}/{row.get('rawTriangleCount',0)}"
        clipped_text = f"{row.get('clippedVertexCount',0)}/{row.get('clippedTriangleCount',0)}"
        bounds = f"{row.get('rawBounds','')} -> {row.get('clippedBounds','')}"
        md.append(f"| `{row.get('drawOrder',0)}` | `{row.get('slotName','')}` | `{row.get('attachmentName','')}` | `{row.get('clippingActiveAtAttachment')}` | `{raw}` | `{clipped_text}` | `{bounds}` | `{row.get('classification','')}` |")
    md.append("")
    md.append("## Mesh UV Regions")
    md.append("")
    md.append("| region | atlas bounds | UV bounds | mesh vertices | mesh triangles | mesh bounds | classification |")
    md.append("| --- | --- | --- | ---: | ---: | --- | --- |")
    for row in uvs:
        md.append(f"| `{row.get('regionName','')}` | `{row.get('atlasBounds','')}` | `{row.get('uvBounds','')}` | `{row.get('meshVertexHits',0)}` | `{row.get('meshTriangleHits',0)}` | `{row.get('meshBounds','')}` | `{row.get('classification','')}` |")
    md.append("")
    md.append("## Texture Handoff")
    md.append("")
    md.append("| source | actual | expected | present | matches main | classification |")
    md.append("| --- | --- | --- | --- | --- | --- |")
    for row in textures:
        md.append(f"| `{row.get('source','')}` | `{row.get('actualTexture','')}` | `{row.get('expectedTexture','')}` | `{row.get('effectiveTexturePresent')}` | `{row.get('matchesMainTexture')}` | `{row.get('classification','')}` |")
    md.append("")
    md.append("## Renderer Instruction")
    md.append("")
    md.append("| submesh | slots | preActiveClip | material | texture | raw | classification |")
    md.append("| ---: | --- | ---: | --- | --- | --- | --- |")
    for row in instructions:
        slots = f"{row.get('startSlot',0)}-{row.get('endSlot',0)} count={row.get('slotCount',0)}"
        raw = f"{row.get('rawVertexCount',0)}/{row.get('rawTriangleCount',0)}"
        md.append(f"| `{row.get('submeshIndex',0)}` | `{slots}` | `{row.get('preActiveClippingSlotSource',0)}` | `{row.get('material','')}` | `{row.get('materialTexture','')}` | `{raw}` | `{row.get('classification','')}` |")
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
    md.append(f"Next blocker: `{result.get('nextBlocker', 'route frame visual mismatch capture review')}`.")
    md.append("")
    REPORT_MD.write_text("\n".join(md), encoding="utf-8")


if __name__ == "__main__":
    main()
