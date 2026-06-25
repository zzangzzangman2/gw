import csv
import json
from collections import Counter
from datetime import datetime
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY = ROOT / "girlswar_maininterface_unity"
MERGED = ROOT / "girlswar_merged_extracted"
RESTORE = UNITY / "Assets" / "RestoreData"
REPORTS = ROOT / "reports" / "maininterface"

TRACE_JSON = RESTORE / "maininterface_guildmain_white_panel_material_shader_runtime_trace.json"
TRACE_CSV = RESTORE / "reports" / "maininterface_guildmain_white_panel_material_shader_runtime_trace.csv"
JOIN_CSV = RESTORE / "reports" / "maininterface_navigation_target_sprite_atlas_slice_join.csv"
JOIN_CAPTURE_JSON = RESTORE / "maininterface_navigation_target_sprite_atlas_slice_join_capture.json"
CLICK_SUMMARY = RESTORE / "reports" / "maininterface_click_validation_summary.json"
REPORT_MD = REPORTS / "MAININTERFACE_GUILDMAIN_WHITE_PANEL_MATERIAL_SHADER_RUNTIME_TRACE_RESULT.md"
CONTACT_SHEET = REPORTS / "GUILDMAIN_WHITE_PANEL_TRACE_CONTACT_SHEET.jpg"
TOOL = ROOT / "_restore_tools" / "107_TRACE_GUILDMAIN_WHITE_PANEL_MATERIAL_SHADER_RUNTIME.cmd"


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, str]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def normalize_path(path: str) -> str:
    return path.replace("UI_GuildMain_NavigationPrototype", "UI_GuildMain")


def source_stats(path: str) -> dict[str, str]:
    if not path:
        return {}
    image_path = Path(path)
    if not image_path.exists():
        return {"source_png_exists": "0"}
    image = Image.open(image_path).convert("RGBA")
    pixels = list(image.getdata())
    total = len(pixels) or 1
    alpha_pixels = [p for p in pixels if p[3] > 0]
    opaque = [p for p in pixels if p[3] > 220]
    white_opaque = [p for p in pixels if p[3] > 220 and p[0] > 235 and p[1] > 235 and p[2] > 235]
    bright_alpha = [p for p in pixels if p[3] > 50 and p[0] > 220 and p[1] > 220 and p[2] > 220]
    if alpha_pixels:
        avg = tuple(sum(p[i] for p in alpha_pixels) / len(alpha_pixels) for i in range(4))
    else:
        avg = (0, 0, 0, 0)
    return {
        "source_png_exists": "1",
        "source_png_width": str(image.width),
        "source_png_height": str(image.height),
        "source_alpha_ratio": f"{len(alpha_pixels) / total:.4f}",
        "source_opaque_ratio": f"{len(opaque) / total:.4f}",
        "source_opaque_white_ratio": f"{len(white_opaque) / total:.4f}",
        "source_bright_alpha_ratio": f"{len(bright_alpha) / total:.4f}",
        "source_avg_rgba_alpha_pixels": ",".join(f"{v:.1f}" for v in avg),
    }


def enrich_rows(rows: list[dict[str, str]], join_rows: list[dict[str, str]]) -> list[dict[str, str]]:
    join_by_path = {r.get("original_hierarchy_path", ""): r for r in join_rows}
    enriched = []
    for row in rows:
        original_path = normalize_path(row.get("hierarchy_path", ""))
        joined = join_by_path.get(original_path, {})
        out = dict(row)
        out["original_hierarchy_path"] = original_path
        out["was_missing_before_join"] = "1" if joined else "0"
        out["join_missing_ref"] = joined.get("missing_ref", "")
        out["join_sprite_name"] = joined.get("sprite_name", "")
        out["join_sprite_bundle"] = joined.get("sprite_bundle", "")
        out["join_sprite_png"] = joined.get("sprite_png", "")
        out["join_confidence"] = joined.get("confidence", "")
        out.update(source_stats(joined.get("sprite_png", "")))

        reason = row.get("reason_class", "")
        if row.get("sprite_name") and row.get("screen_whiteish_ratio", "0") >= "0.5000":
            if out.get("source_opaque_white_ratio") and float(out["source_opaque_white_ratio"]) > 0.5:
                reason = "resolved_sprite_but_white_texture"
            elif row.get("shader_name", "") in ("", "Hidden/InternalErrorShader"):
                reason = "missing_material_shader"
            else:
                reason = "resolved_sprite_but_white_render_or_covered"
        if not row.get("sprite_name") and joined.get("unresolved_reason") == "original_image_m_Sprite_is_null_or_runtime_bound":
            reason = "runtime_bound"
        out["final_reason_class"] = reason
        enriched.append(out)
    return enriched


def make_contact_sheet(trace: dict, rows: list[dict[str, str]]) -> None:
    capture_path = UNITY / trace.get("capturePath", "").replace("/", "\\")
    if not capture_path.exists():
        return
    capture = Image.open(capture_path).convert("RGB")
    thumb_w = 560
    thumb_h = 240
    full = capture.copy()
    full.thumbnail((thumb_w, thumb_h))
    crops = []
    for row in rows[:8]:
        try:
            x0 = int(float(row["screen_min_x"]))
            y0 = int(float(row["screen_min_y"]))
            x1 = int(float(row["screen_max_x"]))
            y1 = int(float(row["screen_max_y"]))
        except Exception:
            continue
        y0_img = max(0, capture.height - y1)
        y1_img = min(capture.height, capture.height - y0)
        x0 = max(0, min(capture.width, x0))
        x1 = max(0, min(capture.width, x1))
        if x1 <= x0 or y1_img <= y0_img:
            continue
        crop = capture.crop((x0, y0_img, x1, y1_img))
        crop.thumbnail((thumb_w // 2, thumb_h // 2))
        crops.append((row, crop))

    sheet_w = thumb_w * 2
    sheet_h = thumb_h + ((len(crops) + 1) // 2) * (thumb_h // 2 + 52) + 40
    sheet = Image.new("RGB", (sheet_w, sheet_h), "white")
    draw = ImageDraw.Draw(sheet)
    sheet.paste(full, (0, 24))
    draw.text((8, 4), "UI_GuildMain white panel trace - full capture", fill=(0, 0, 0))
    x_base = thumb_w + 12
    draw.text((x_base, 4), "Top visible white image crops", fill=(0, 0, 0))
    for idx, (row, crop) in enumerate(crops):
        col = idx % 2
        line = idx // 2
        x = x_base + col * (thumb_w // 2)
        y = 24 + line * (thumb_h // 2 + 52)
        sheet.paste(crop, (x, y))
        label = f"#{row.get('rank')} {row.get('sprite_name') or 'no sprite'} {row.get('screen_whiteish_ratio')}"
        draw.text((x, y + crop.height + 2), label[:42], fill=(0, 0, 0))
    CONTACT_SHEET.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT_SHEET, quality=92)


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    trace = read_json(TRACE_JSON)
    rows = read_csv(TRACE_CSV)
    join_rows = read_csv(JOIN_CSV)
    enriched = enrich_rows(rows, join_rows)
    fieldnames = []
    for row in enriched:
        for key in row.keys():
            if key not in fieldnames:
                fieldnames.append(key)
    if enriched:
        write_csv(TRACE_CSV, enriched, fieldnames)
    make_contact_sheet(trace, enriched)

    click = read_json(CLICK_SUMMARY)
    before_capture = read_json(JOIN_CAPTURE_JSON)
    before_guild = next((t for t in before_capture.get("targets", []) if t.get("prefabRootName") == "UI_GuildMain"), {})
    reason_counts = Counter(r.get("final_reason_class", "") for r in enriched)
    shader_counts = Counter(r.get("shader_name", "") for r in enriched)
    material_counts = Counter(r.get("material_name", "") for r in enriched)
    joined_visible = [r for r in enriched if r.get("was_missing_before_join") == "1"]
    no_sprite_rows = [r for r in enriched if not r.get("sprite_name")]
    resolved_but_white = [
        r for r in enriched
        if r.get("sprite_name") and float(r.get("screen_whiteish_ratio") or 0) >= 0.5
    ]
    large_white = [
        r for r in enriched
        if int(float(r.get("screen_whiteish_pixel_count") or 0)) >= 5000
        and float(r.get("screen_whiteish_ratio") or 0) >= 0.5
    ]

    lines = [
        "# MainInterface GuildMain White Panel Material Shader Runtime Trace Result",
        "",
        f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} KST",
        "",
        "## Verdict",
        "",
        "Not normal. The `UI_GuildMain` target still renders as a large white/bright panel even after sprite references were joined. The 106 step reduced null Sprite counts, but visual quality remains partial/failing by capture metrics.",
        "",
        "## Visual Metrics",
        "",
        "| Metric | Before 107 | 107 trace |",
        "| --- | ---: | ---: |",
        f"| Whiteish visible ratio | `{before_guild.get('whiteishVisibleRatio', '')}` | `{trace.get('whiteishVisibleRatio', '')}` |",
        f"| Whiteish pixels | `{before_guild.get('whiteishPixelCount', '')}` | `{trace.get('whiteishPixelCount', '')}` |",
        f"| White no-sprite Images | `{before_guild.get('whiteNoSpriteImageCount', '')}` | `{trace.get('whiteNoSpriteImageCount', '')}` |",
        f"| Missing Image sprites | `{before_guild.get('missingImageSpriteCount', '')}` | `{trace.get('noSpriteImageCount', '')}` |",
        f"| Large white visible Images | `` | `{trace.get('largeWhiteVisibleImageCount', '')}` |",
        f"| Missing script objects | `{before_guild.get('missingScriptObjectCount', '')}` | `{trace.get('missingScriptObjectCount', '')}` |",
        f"| Screen looks normal | `` | `{trace.get('screenLooksNormal', False)}` |",
        "",
        "## Cause Split",
        "",
        "| Class | Count |",
        "| --- | ---: |",
    ]
    for key, count in reason_counts.most_common():
        lines.append(f"| `{key}` | `{count}` |")

    lines.extend(
        [
            "",
            "## Top Visible White Images",
            "",
            "| Rank | Path | Sprite | White ratio | Pixels | Material / Shader | Source PNG white | Class |",
            "| ---: | --- | --- | ---: | ---: | --- | ---: | --- |",
        ]
    )
    for row in enriched[:20]:
        lines.append(
            f"| `{row.get('rank', '')}` | `{row.get('hierarchy_path', '')}` | "
            f"`{row.get('sprite_name', '')}` | `{row.get('screen_whiteish_ratio', '')}` | "
            f"`{row.get('screen_whiteish_pixel_count', '')}` | `{row.get('material_name', '')}` / `{row.get('shader_name', '')}` | "
            f"`{row.get('source_opaque_white_ratio', '')}` | `{row.get('final_reason_class', '')}` |"
        )

    lines.extend(
        [
            "",
            "## Evidence Interpretation",
            "",
            f"- Joined-before rows among top visible white list: `{len(joined_visible)}`.",
            f"- Resolved sprite but still white/bright rows: `{len(resolved_but_white)}`.",
            f"- No-sprite/runtime-bound rows in top list: `{len(no_sprite_rows)}`.",
            "- The dominant material/shader on traced rows remains default UI rendering; no confirmed custom material/shader replacement was found in this pass.",
            "- Several joined source sprites are not fully white in their exported PNGs, so the remaining white panel cannot be called solved by sprite join alone.",
            "- Runtime-bound rows with original `m_Sprite=0` were not guessed; they need Lua/XLua or custom script/type reconstruction evidence.",
            "",
            "## Material / Shader Counts",
            "",
            "| Name | Count |",
            "| --- | ---: |",
        ]
    )
    for key, count in shader_counts.most_common(10):
        lines.append(f"| shader `{key}` | `{count}` |")
    for key, count in material_counts.most_common(10):
        lines.append(f"| material `{key}` | `{count}` |")

    lines.extend(
        [
            "",
            "## Verification",
            "",
            "| Check | Result |",
            "| --- | --- |",
            f"| Trace JSON | `{TRACE_JSON}` |",
            f"| Trace CSV | `{TRACE_CSV}` rows=`{len(enriched)}` |",
            f"| Capture | `{UNITY / trace.get('capturePath', '').replace('/', '\\\\')}` |",
            f"| Contact sheet | `{CONTACT_SHEET}` |",
            f"| Click validation generatedAt | `{click.get('generatedAt', '')}` |",
            f"| Active / clickable / blocked / invoked | `{click.get('activeButtons', '')}` / `{click.get('raycastClickableButtons', '')}` / `{click.get('raycastBlockedButtons', '')}` / `{click.get('invokedClicks', '')}` |",
            f"| Tool | `{TOOL}` |",
            "",
            "## Fix Applied",
            "",
            "No material/shader/color/type fix was applied in this pass. The trace found evidence of unresolved runtime/custom script behavior, but not a safe material or tint override that would preserve original hierarchy and rendering semantics.",
            "",
            "## Next Recommendation",
            "",
            "Next: `target runtime Lua/XLua initialization trace`",
        ]
    )
    REPORT_MD.write_text("\n".join(lines), encoding="utf-8")
    print(f"wrote {REPORT_MD}")
    print(
        f"normal={trace.get('screenLooksNormal')} whiteRatio={trace.get('whiteishVisibleRatio')} "
        f"largeWhite={trace.get('largeWhiteVisibleImageCount')} click={click.get('activeButtons')}/"
        f"{click.get('raycastClickableButtons')}/{click.get('raycastBlockedButtons')}/{click.get('invokedClicks')}"
    )


if __name__ == "__main__":
    main()
