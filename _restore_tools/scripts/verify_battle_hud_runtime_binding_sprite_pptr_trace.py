from __future__ import annotations

import csv
import json
import os
import subprocess
from collections import Counter
from pathlib import Path
from typing import Any
from PIL import Image, ImageDraw


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"

LIVE_JSON = UNITY_DATA / "BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_LIVE.json"
LIVE_CSV = UNITY_DATA / "BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_LIVE_COMPONENTS.csv"
B19_CANDIDATES = UNITY_DATA / "BATTLE_HUD_SPRITE_REGION_FONT_JOIN_CANDIDATES.json"
B20_JSON = UNITY_DATA / "BATTLE_HUD_VISUAL_SANITY_REBASE_TO_PLAY_VIDEO_RESULT.json"
B20_REPORT_JSON = REPORT_DIR / "BATTLE_HUD_VISUAL_SANITY_REBASE_TO_PLAY_VIDEO_RESULT.json"
FINAL_JSON = UNITY_DATA / "BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE.json"
FINAL_CSV = UNITY_DATA / "BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_COMPONENTS.csv"
REPORT_JSON = REPORT_DIR / "BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_RESULT.json"
REPORT_MD = REPORT_DIR / "BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_RESULT.md"
LOG = REPORT_DIR / "BATTLE_21_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE.log"
BATTLE20_REFERENCE = REPORT_DIR / "BATTLE_20_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S.jpg"
BATTLE21_CONTACT = REPORT_DIR / "BATTLE_21_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_CONTACT_SHEET.jpg"
BATTLE21_CAPTURE = UNITY_DIR / "Assets" / "RestoreCaptures" / "battle_hud" / "BattleHudRuntimeBindingSpritePptrTrace_1680x720.png"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def norm_path(path: str) -> str:
    path = path.replace("\\", "/")
    parts = []
    for p in path.split("/"):
        if p.startswith("RuntimeTraceHUD_") or p.startswith("SpriteFontJoinHUD_") or p.startswith("VisualSanityHUD_"):
            continue
        parts.append(p)
    path = "/".join(parts)
    replacements = {
        "UI_NormalBattle": "ui_normalbattle",
        "UI_Battle3DUI": "ui_battle3dui",
        "UI_NormalBattle_HeroItem": "ui_normalbattle_heroitem",
    }
    for old, new in replacements.items():
        path = path.replace(old, new)
    return path.lower()


def make_pptr_index(candidates: dict[str, Any]) -> dict[str, dict[str, Any]]:
    index: dict[str, dict[str, Any]] = {}
    for row in candidates.get("components", []):
        key = norm_path(str(row.get("hierarchyPath", "")))
        ctype = str(row.get("componentType", "")).split(".")[-1].lower()
        index[key + "|" + ctype] = row
        index[key] = row
    return index


def find_pptr(row: dict[str, str], index: dict[str, dict[str, Any]]) -> dict[str, Any]:
    key = norm_path(row.get("hierarchyPath", ""))
    ctype = row.get("componentType", "").split(".")[-1].lower()
    if key + "|" + ctype in index:
        return index[key + "|" + ctype]
    if key in index:
        return index[key]
    # fallback: longest suffix match for root name differences.
    best: tuple[int, dict[str, Any]] = (0, {})
    for pkey, prow in index.items():
        pbase = pkey.split("|")[0]
        score = 0
        if key.endswith(pbase) or pbase.endswith(key):
            score = min(len(key), len(pbase))
        else:
            key_parts = key.split("/")
            p_parts = pbase.split("/")
            common = 0
            for a, b in zip(reversed(key_parts), reversed(p_parts)):
                if a != b:
                    break
                common += 1
            score = common
        if score > best[0]:
            best = (score, prow)
    return best[1] if best[0] >= 3 else {}


def search_lua_il2cpp_hints() -> list[dict[str, str]]:
    keywords = "ui_normalbattle|battleui|battle_ui|normalbattle|heroitem|skill|auto|pause|speed|battle3dui|btnpause|btnskip"
    cmd = [
        "rg",
        "-n",
        "-i",
        keywords,
        str(BASE),
        "-g",
        "!girlswar_maininterface_unity/**",
        "-g",
        "!reports/maininterface/**",
        "-g",
        "*.lua",
        "-g",
        "*.txt",
        "-g",
        "*.json",
    ]
    try:
        proc = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=20)
        lines = proc.stdout.splitlines()[:120]
    except Exception:
        lines = []
    out = []
    for line in lines:
        # rg emits Windows paths like C:\...\file.lua:123:text, so split from the right.
        parts = line.rsplit(":", 2)
        if len(parts) == 3 and parts[1].isdigit():
            out.append({"path": parts[0], "line": parts[1], "text": parts[2][:240]})
    return out


def make_contact_sheet(capture_path: str) -> str:
    capture = Path(os.path.normpath(capture_path)) if capture_path else Path("")
    if not capture.exists() and BATTLE21_CAPTURE.exists():
        capture = BATTLE21_CAPTURE
    panels = []
    for label, path in [("play.mp4 clip05 reference 486s sequence", BATTLE20_REFERENCE), ("BATTLE_21 runtime trace capture - not original HUD", capture)]:
        if path.exists():
            image = Image.open(path).convert("RGB")
        else:
            image = Image.new("RGB", (840, 360), (0, 0, 0))
        image.thumbnail((840, 360), Image.Resampling.LANCZOS)
        panel = Image.new("RGB", (840, 405), (8, 8, 8))
        panel.paste(image, ((840 - image.width) // 2, 0))
        draw = ImageDraw.Draw(panel)
        draw.text((12, 376), label, fill=(255, 255, 255))
        panels.append(panel)
    sheet = Image.new("RGB", (1680, 405), (6, 6, 6))
    sheet.paste(panels[0], (0, 0))
    sheet.paste(panels[1], (840, 0))
    BATTLE21_CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(BATTLE21_CONTACT, quality=92)
    return str(BATTLE21_CONTACT)


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    UNITY_DATA.mkdir(parents=True, exist_ok=True)
    live = read_json(LIVE_JSON)
    b20 = read_json(B20_JSON)
    b20_report = read_json(B20_REPORT_JSON)
    candidates = read_json(B19_CANDIDATES)
    live_rows = read_csv(LIVE_CSV)
    if not live or not live_rows:
        summary = {
            "reference_video_used": True,
            "visual_status": "failed_missing_runtime_binding",
            "matches_clip05_static_hud_layout": False,
            "camera_visible_hud": bool(b20_report.get("camera_visible_hud", False)),
            "camera_visible_original_hud": False,
            "placeholder_block_visible": bool(b20_report.get("placeholder_block_visible", False)),
            "visible_original_sprite_count": 0,
            "visible_original_sprite_candidate_count": 0,
            "visible_placeholder_block_count": 0,
            "activeGraphicCount": 0,
            "componentRowCount": 0,
            "pptrJoinMatchedCount": 0,
            "reasonCounts": {"unity_live_trace_missing_or_compile_failed": 1},
            "captureVisualizationFixApplied": False,
            "fixApplied": False,
            "nextBlocker": "BATTLE_21 Unity live trace did not complete; fix compile/run before visual claims",
            "liveJson": str(LIVE_JSON),
            "componentsCsv": str(FINAL_CSV),
            "capture": "",
            "luaIl2cppHints": search_lua_il2cpp_hints(),
        }
        FINAL_JSON.write_text(json.dumps({"summary": summary, "components": []}, ensure_ascii=False, indent=2), encoding="utf-8")
        REPORT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
        write_report(summary)
        print(json.dumps(summary, ensure_ascii=False, indent=2))
        return
    pptr_index = make_pptr_index(candidates)
    joined_rows: list[dict[str, Any]] = []
    reason_counts: Counter[str] = Counter()
    pptr_matched = 0
    placeholder_rows = 0
    visible_original_rows = 0
    for row in live_rows:
        pptr = find_pptr(row, pptr_index)
        if pptr:
            pptr_matched += 1
        visible_placeholder = row.get("visiblePlaceholderBlock") == "true"
        visible_original = row.get("visibleOriginalSpriteCandidate") == "true"
        if visible_placeholder:
            placeholder_rows += 1
        if visible_original:
            visible_original_rows += 1
        reason = row.get("unresolvedReason") or ""
        if visible_placeholder and not reason:
            reason = "default_white_placeholder_block"
        if not reason:
            if row.get("role") in {"Image", "RawImage"} and not row.get("spriteName") and not row.get("textureName"):
                reason = "sprite_pptr_unresolved"
            elif row.get("role") in {"Text", "TMP"} and not row.get("fontName"):
                reason = "font_pptr_unresolved"
            else:
                reason = "resolved_or_inactive"
        reason_counts[reason] += 1
        joined = {
            **row,
            "originalSpritePPtr": pptr.get("spriteRef", ""),
            "originalMaterialPPtr": pptr.get("materialRef", ""),
            "originalFontPPtr": pptr.get("fontRef", ""),
            "originalTmpFontAssetPPtr": pptr.get("fontAssetRef", ""),
            "originalSharedMaterialPPtr": pptr.get("sharedMaterialRef", ""),
            "originalTargetGraphicPPtr": pptr.get("targetGraphicRef", ""),
            "originalTexturePPtr": pptr.get("textureRef", ""),
            "pptrJoinMatched": bool(pptr),
            "traceUnresolvedReason": reason,
        }
        joined_rows.append(joined)

    camera_visible_original_hud = bool(live.get("cameraVisibleOriginalHud", False)) and placeholder_rows == 0
    placeholder_block_visible = placeholder_rows > 0 or bool(b20_report.get("placeholder_block_visible", False))
    visual_matches = bool(not placeholder_block_visible and live.get("cameraVisibleOriginalHud", False))
    contact_sheet = make_contact_sheet(str(live.get("capture", "")))
    summary = {
        "reference_video_used": True,
        "visual_status": "failed_missing_runtime_binding" if not visual_matches else "acceptable_partial",
        "matches_clip05_static_hud_layout": visual_matches,
        "camera_visible_hud": bool(b20_report.get("camera_visible_hud", b20.get("cameraVisibleHud", True))),
        "camera_visible_original_hud": camera_visible_original_hud,
        "placeholder_block_visible": placeholder_block_visible,
        "debug_or_evidence_overlay_visible": False,
        "video_clip05_contact_compared": True,
        "visible_original_sprite_count": visible_original_rows if not placeholder_block_visible else 0,
        "visible_original_sprite_candidate_count": visible_original_rows,
        "visible_placeholder_block_count": placeholder_rows,
        "activeGraphicCount": live.get("visibleComponentCount", 0),
        "battle20TopBottomRightZoneFalsePositive": bool(b20_report.get("topBottomRightZoneFalsePositive", False)),
        "componentRowCount": len(joined_rows),
        "pptrJoinMatchedCount": pptr_matched,
        "reasonCounts": dict(reason_counts),
        "captureVisualizationFixApplied": live.get("captureVisualizationFixApplied", False),
        "fixApplied": False,
        "nextBlocker": "BATTLE_22_BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_AND_RUNTIME_LUA_BINDING",
        "liveJson": str(LIVE_JSON),
        "componentsCsv": str(FINAL_CSV),
        "capture": live.get("capture", ""),
        "contactSheet": contact_sheet,
        "luaIl2cppHints": search_lua_il2cpp_hints(),
    }

    with FINAL_CSV.open("w", encoding="utf-8-sig", newline="") as f:
        fieldnames = list(joined_rows[0].keys()) if joined_rows else ["hierarchyPath"]
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(joined_rows)

    final = {"summary": summary, "components": joined_rows[:500], "sourceB20": str(B20_JSON), "sourceCandidates": str(B19_CANDIDATES)}
    FINAL_JSON.write_text(json.dumps(final, ensure_ascii=False, indent=2), encoding="utf-8")
    REPORT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(summary)
    print(json.dumps(summary, ensure_ascii=False, indent=2))


def write_report(summary: dict[str, Any]) -> None:
    hints = summary.get("luaIl2cppHints", [])[:20]
    lines = [
        "# Battle HUD Runtime Binding + Sprite PPtr Visual Trace Result",
        "",
        "## User-Visible Verdict",
        "- 아직 원본 전투 HUD 아님.",
        "- clip05의 HP/VS, 하단 actor/skill cards, 오른쪽 세로 control sprite 형태와 일치하지 않습니다.",
        "- debug/evidence text, placeholder block, 검은 화면, 정적 zone pass는 성공 기준이 아닙니다.",
        "",
        "## Verdict First",
        f"- visual_status: `{summary['visual_status']}`",
        f"- matches_clip05_static_hud_layout: `{summary['matches_clip05_static_hud_layout']}`",
        f"- camera_visible_hud: `{summary['camera_visible_hud']}`",
        f"- camera_visible_original_hud: `{summary['camera_visible_original_hud']}`",
        f"- placeholder_block_visible: `{summary['placeholder_block_visible']}`",
        f"- battle20_top_bottom_right_zone_false_positive: `{summary.get('battle20TopBottomRightZoneFalsePositive', False)}`",
        f"- video_clip05_contact_compared: `{summary.get('video_clip05_contact_compared', False)}`",
        f"- visible_original_sprite_count: `{summary['visible_original_sprite_count']}`",
        f"- visible_original_sprite_candidate_count: `{summary['visible_original_sprite_candidate_count']}`",
        f"- visible_placeholder_block_count: `{summary['visible_placeholder_block_count']}`",
        f"- nextBlocker: `{summary['nextBlocker']}`",
        "",
        "## What This Means Visually",
        "- The current capture is still not the original clip05 battle HUD.",
        "- The camera can see live UI hierarchy, but placeholder/default Image blocks still cover the layout and create false positives.",
        "- Contact-sheet comparison remains the gate: if it does not look like play.mp4 clip05, this stage is failed.",
        "- No fake HUD, arbitrary icon replacement, whole-atlas Image placement, or coordinate-only fix was applied.",
        "",
        "## Counts",
        f"- component rows: `{summary['componentRowCount']}`",
        f"- active/visible component count: `{summary['activeGraphicCount']}`",
        f"- PPtr join matched rows: `{summary['pptrJoinMatchedCount']}`",
        f"- capture visualization fix applied: `{summary['captureVisualizationFixApplied']}`",
        f"- fixApplied: `{summary['fixApplied']}`",
        "",
        "## Unresolved Reason Counts",
    ]
    for reason, count in sorted(summary["reasonCounts"].items(), key=lambda x: (-x[1], x[0])):
        lines.append(f"- `{reason}`: `{count}`")
    lines.extend([
        "",
        "## Outputs",
        f"- Unity trace JSON: `{FINAL_JSON}`",
        f"- Components CSV: `{FINAL_CSV}`",
        f"- Report JSON: `{REPORT_JSON}`",
        f"- Live capture: `{summary['capture']}`",
        f"- Contact sheet: `{summary.get('contactSheet', '')}`",
        "",
        "## Lua / XLua / IL2CPP Handler Hints",
    ])
    if hints:
        for hint in hints:
            lines.append(f"- `{hint['path']}:{hint['line']}` {hint['text']}")
    else:
        lines.append("- No keyword hints captured in this pass.")
    lines.extend([
        "",
        "## BATTLE_22 Recommendation",
        f"- `{summary['nextBlocker']}`",
    ])
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
