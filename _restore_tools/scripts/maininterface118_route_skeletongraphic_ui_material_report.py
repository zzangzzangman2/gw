import json
from datetime import datetime
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORTS = BASE / "reports" / "maininterface"
RESULT_JSON = PROJECT / "Assets" / "RestoreData" / "maininterface_118_route_skeletongraphic_ui_material_shader_pass_binding.json"
RESULT_CSV = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_118_route_skeletongraphic_ui_material_shader_pass_binding.csv"
CLICK_JSON = PROJECT / "Assets" / "RestoreData" / "reports" / "maininterface_click_validation_summary.json"
CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_route_spine_runtime_ui_material_bound_1680x720.png"
SCENE = PROJECT / "Assets" / "Scenes" / "MainInterface_RouteSpineRuntimeReplay_UIMaterialBound.unity"
REPORT_MD = REPORTS / "MAININTERFACE_118_BIND_ROUTE_SKELETONGRAPHIC_UI_MATERIAL_SHADER_PASS_FROM_ORIGINAL_FIELDS_RESULT.md"
TOOL = BASE / "_restore_tools" / "cmd_archive" / "118_BIND_ROUTE_SKELETONGRAPHIC_UI_MATERIAL_SHADER_PASS_FROM_ORIGINAL_FIELDS.cmd"


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
    shaders = result.get("shaderRows") or []

    active = click.get("activeButtons", "")
    clickable = click.get("raycastClickableButtons", "")
    blocked = click.get("raycastBlockedButtons", "")
    invoked = click.get("invokedClicks", "")

    md = []
    md.append("# MainInterface 118 Bind Route SkeletonGraphic UI Material Shader Pass From Original Fields Result")
    md.append("")
    md.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} KST")
    md.append("")
    md.append("## Verdict")
    md.append("")
    md.append("화면 기준으로 MainInterface는 아직 정상 UI라고 말할 수 없다. UI118은 원본 SkeletonGraphic material slot과 Spine runtime 기본 material evidence에 따라 UI용 SkeletonGraphic shader/pass를 바인딩한 partial 후보이다.")
    md.append("")
    md.append("Manual visual review: UI118 capture still shows the large white route diamond/panel seen in UI117, so shader/pass binding alone did not resolve the route cluster visual defect.")
    md.append("")
    md.append("좌표, scale, RectTransform, sibling order, whole atlas, crop, fake icon, debug/path text는 건드리지 않았다. 최종 캡처는 여전히 수동 시각 검토 대상이다.")
    md.append("")
    md.append("## Counts")
    md.append("")
    md.append("| metric | value |")
    md.append("| --- | ---: |")
    md.append(f"| visual fixes applied | `{result.get('visualFixApplied', 0)}` |")
    md.append(f"| targets considered | `{result.get('targetsConsidered', 0)}` |")
    md.append(f"| targets bound | `{result.get('targetsBound', 0)}` |")
    md.append(f"| original refs present | `{result.get('originalRefsPresent', 0)}` |")
    md.append(f"| additive/multiply/screen bound | `{result.get('additiveBound', 0)} / {result.get('multiplyBound', 0)} / {result.get('screenBound', 0)}` |")
    md.append(f"| SkeletonGraphic.cs.meta default material evidence | `{result.get('skeletonGraphicMetaDefaultMaterialEvidence', False)}` |")
    md.append(f"| capture exists/size | `{CAPTURE.exists()} / {CAPTURE.stat().st_size if CAPTURE.exists() else 0}` |")
    md.append(f"| visible/magenta/whiteish pixels | `{result.get('visiblePixelCount', 0)} / {result.get('magentaPixelCount', 0)} / {result.get('whiteishPixelCount', 0)}` |")
    md.append("")
    md.append("## Shader Probes")
    md.append("")
    md.append("| shader | found | supported | pass count |")
    md.append("| --- | ---: | ---: | ---: |")
    for row in shaders:
        md.append(f"| `{row.get('shaderName','')}` | `{row.get('found', False)}` | `{row.get('supported', False)}` | `{row.get('passCount', 0)}` |")
    md.append("")
    md.append("## Target Binding")
    md.append("")
    md.append("| target | node | before | after | decision |")
    md.append("| --- | --- | --- | --- | --- |")
    for row in targets:
        before = f"{row.get('beforeMaterialName','')} / {row.get('beforeShaderName','')}"
        after = f"{row.get('afterMaterialName','')} / {row.get('afterShaderName','')} / pass {row.get('afterMaterialPassCount',0)}"
        md.append(f"| `{row.get('skeletonKey','')}` | `{row.get('nodeName','')}` | `{before}` | `{after}` | `{row.get('decision','')}` |")
    md.append("")
    md.append("## Verification")
    md.append("")
    md.append("| check | result |")
    md.append("| --- | --- |")
    md.append(f"| bound scene | `{SCENE}` |")
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
    md.append(f"Next blocker: `{result.get('nextBlocker', 'route SkeletonGraphic mesh bounds and CanvasRenderer submesh material validation against original runtime fields')}`.")
    md.append("")
    REPORT_MD.write_text("\n".join(md), encoding="utf-8")


if __name__ == "__main__":
    main()
