from __future__ import annotations

import csv
import json
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DIR = BASE / "reports" / "maininterface"
DATA_DIR = PROJECT / "Assets" / "RestoreData"
DATA_REPORT_DIR = DATA_DIR / "reports"

ORIGINAL_BUNDLE = MERGED / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "ui" / "uiprefabandres" / "guild_ext_prefabs.assetbundle"
RESULT_JSON = DATA_DIR / "maininterface_guildmain_custom_component_type_reconstruction.json"
WHITE_TRACE_JSON = DATA_DIR / "maininterface_guildmain_white_panel_material_shader_runtime_trace.json"
CLICK_JSON = DATA_REPORT_DIR / "maininterface_click_validation_summary.json"
OUT_MD = REPORT_DIR / "MAININTERFACE_GUILDMAIN_CUSTOM_COMPONENT_TYPE_RECONSTRUCTION_RESULT.md"

BASELINE = {
    "whiteishVisibleRatio": 0.8171147704124451,
    "largeWhiteVisibleImageCount": 19,
    "whiteNoSpriteImageCount": 78,
    "missingImageSprites": 152,
    "missingScriptObjects": 881,
}


def read_json(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def original_script_counts() -> list[dict[str, Any]]:
    env = UnityPy.load(ORIGINAL_BUNDLE.read_bytes())
    scripts: dict[int, dict[str, Any]] = {}
    for obj in env.objects:
        if obj.type.name != "MonoScript":
            continue
        data = obj.read()
        scripts[obj.path_id] = {
            "script_path_id": obj.path_id,
            "namespace": getattr(data, "m_Namespace", "") or "",
            "class_name": getattr(data, "m_ClassName", "") or "",
            "assembly": getattr(data, "m_AssemblyName", "") or "",
        }

    counts: Counter[int] = Counter()
    for obj in env.objects:
        if obj.type.name != "MonoBehaviour":
            continue
        data = obj.read()
        script = getattr(data, "m_Script", None)
        script_id = getattr(script, "path_id", None) if script is not None else None
        counts[script_id] += 1

    rows = []
    for script_id, count in counts.most_common():
        info = scripts.get(script_id, {"script_path_id": script_id, "namespace": "", "class_name": "", "assembly": ""})
        rows.append({**info, "component_count": count, "full_name": ".".join(x for x in [info["namespace"], info["class_name"]] if x)})
    return rows


def write_original_counts_csv(rows: list[dict[str, Any]]) -> Path:
    path = DATA_REPORT_DIR / "maininterface_guildmain_original_monoscript_type_counts.csv"
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        fieldnames = ["script_path_id", "namespace", "class_name", "assembly", "full_name", "component_count"]
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)
    return path


def main() -> None:
    original_rows = original_script_counts()
    original_csv = write_original_counts_csv(original_rows)
    result = read_json(RESULT_JSON)
    white = read_json(WHITE_TRACE_JSON)
    click = read_json(CLICK_JSON)

    component_counts = {row.get("typeName"): row.get("count") for row in result.get("componentTypeCounts", [])}
    resolved_stub_components = {
        key: component_counts.get(key, 0)
        for key in [
            "YouYou.YouYouImage",
            "LuaComponentBinder.LuaComBinder",
            "YouYou.LuaForm",
            "YouYou.YouYouCanvasHelper",
            "YouYou.UISpineCtr",
            "SuperScrollView.LoopListView2",
            "SuperScrollView.LoopStaggeredGridView",
            "UnityEngine.UI.Empty4Raycast",
        ]
    }
    applied_stub_count = sum(1 for value in resolved_stub_components.values() if value)
    missing_after = result.get("missingScriptObjectCountAfter", 0)
    missing_reduction = BASELINE["missingScriptObjects"] - missing_after if isinstance(missing_after, int) else ""

    white_ratio = white.get("whiteishVisibleRatio")
    large_white = white.get("largeWhiteVisibleImageCount")
    white_no_sprite = white.get("whiteNoSpriteImageCount")
    missing_sprite = white.get("noSpriteImageCount")
    screen_ok = bool(white.get("screenLooksNormal"))

    top_blockers = result.get("topBlockerRows", [])
    top_missing = sum(int(row.get("missingScriptCount", 0) or 0) for row in top_blockers)
    unresolved_top = [row for row in top_blockers if int(row.get("missingScriptCount", 0) or 0) > 0]

    md = [
        "# MainInterface GuildMain Custom Component Type Reconstruction Result",
        "",
        f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} KST",
        "",
        "## Verdict",
        "",
        "Not normal. The custom type stubs/proxies reduced missing script objects, but `UI_GuildMain` still renders as a large white/bright panel. This remains a partial reconstruction, not a visually correct GuildMain UI.",
        "",
        "## Visual Metrics",
        "",
        "| Metric | 108 baseline | 109 after type stubs |",
        "| --- | ---: | ---: |",
        f"| Whiteish visible ratio | `{BASELINE['whiteishVisibleRatio']}` | `{white_ratio}` |",
        f"| Large white visible Images | `{BASELINE['largeWhiteVisibleImageCount']}` | `{large_white}` |",
        f"| White no-sprite Images | `{BASELINE['whiteNoSpriteImageCount']}` | `{white_no_sprite}` |",
        f"| Missing Image sprites | `{BASELINE['missingImageSprites']}` | `{missing_sprite}` |",
        f"| Missing script objects | `{BASELINE['missingScriptObjects']}` | `{missing_after}` |",
        f"| Missing script object reduction | `` | `{missing_reduction}` |",
        f"| Screen looks normal | `False` | `{screen_ok}` |",
        "",
        "## Stub / Proxy Result",
        "",
        f"- Stub/proxy class definitions added: `{result.get('stubProxyClassCount', 0)}`",
        f"- Stub/proxy component types now present in instantiated `UI_GuildMain`: `{applied_stub_count}`",
        f"- Top white blocker remaining missing script count: `{top_missing}`",
        "",
        "| Recovered type | Instantiated count | Original evidence |",
        "| --- | ---: | --- |",
    ]
    original_by_full = {row["full_name"]: row for row in original_rows}
    for type_name, count in resolved_stub_components.items():
        original = original_by_full.get(type_name, {})
        evidence = ""
        if original:
            evidence = f"`{original.get('assembly')}` pathID `{original.get('script_path_id')}`, original refs `{original.get('component_count')}`"
        else:
            evidence = "`not directly counted in original MonoScript table`"
        md.append(f"| `{type_name}` | `{count}` | {evidence} |")

    md.extend(
        [
            "",
            "## Original MonoScript Evidence",
            "",
            "| Type | Assembly | Script pathID | Original component refs | 109 action |",
            "| --- | --- | ---: | ---: | --- |",
        ]
    )
    for row in original_rows[:24]:
        full = row["full_name"] or row["class_name"]
        assembly = row["assembly"]
        action = "stub/proxy added" if full in resolved_stub_components or full in {
            "YouYou.LuaUnit",
            "YouYou.ToggleEx",
            "YouYou.UIEventListener",
            "YouYou.TouchEventTransfer",
            "YouYou.UIAniTrigger",
            "YouYou.GuideNode",
            "YouYou.FullscreenCenter",
            "YouYou.ClickRichText",
        } else "trace-only"
        if assembly not in {"Assembly-CSharp.dll", "UnityEngine.UI.dll", "Unity.TextMeshPro.dll"}:
            action = "trace-only: external assembly name"
        md.append(f"| `{full}` | `{assembly}` | `{row['script_path_id']}` | `{row['component_count']}` | {action} |")

    md.extend(
        [
            "",
            "## Top White Blockers After 109",
            "",
            "| Path | Missing scripts | Image type | Sprite | MonoBehaviour types |",
            "| --- | ---: | --- | --- | --- |",
        ]
    )
    for row in top_blockers[:30]:
        md.append(
            f"| `{row.get('hierarchyPath','')}` | `{row.get('missingScriptCount', '')}` | `{row.get('imageType','')}` | `{row.get('spriteName','')}` | `{row.get('monoBehaviourTypes','')}` |"
        )

    md.extend(
        [
            "",
            "## Interpretation",
            "",
            "- `YouYouImage` and other Assembly-CSharp custom component types now resolve as real components where Unity can bind the original script reference.",
            "- The visual white panel did not improve, which means the main blocker is no longer simply missing C# type names.",
            "- `UI_GuildMainView.OnOpen` still is not being executed with game runtime data, so layout rebuild, active-state gates, red points, guild data sprites, marquee/mask behavior, and scroll sizing remain uninitialized.",
            "- External assembly components such as Spine/Coffee UIParticle/DOTween remain trace-only because their original assembly names are not safely reconstructed in this Unity project yet.",
            "",
            "## Verification",
            "",
            f"- Report JSON: `{RESULT_JSON}`",
            f"- Report CSV: `{DATA_REPORT_DIR / 'maininterface_guildmain_custom_component_type_reconstruction.csv'}`",
            f"- Original MonoScript counts CSV: `{original_csv}`",
            f"- Capture: `{PROJECT / 'Assets' / 'RestoreCaptures' / 'guildmain_custom_component_type_reconstruction' / 'UI_GuildMain_1680x720.png'}`",
            f"- Click validation generatedAt: `{click.get('generatedAt', '')}`",
            f"- Active / clickable / blocked / invoked: `{click.get('activeButtons', '')}` / `{click.get('raycastClickableButtons', '')}` / `{click.get('raycastBlockedButtons', '')}` / `{click.get('invokedClicks', '')}`",
            "",
            "## Next Recommendation",
            "",
            "Next: `GuildMain Lua runtime harness for UI_GuildMainView.OnOpen data/layout initialization`.",
        ]
    )

    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps({
        "report": str(OUT_MD),
        "screenLooksNormal": screen_ok,
        "missingScriptObjectsAfter": missing_after,
        "missingScriptObjectReduction": missing_reduction,
        "whiteishVisibleRatio": white_ratio,
        "clickGeneratedAt": click.get("generatedAt", ""),
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
