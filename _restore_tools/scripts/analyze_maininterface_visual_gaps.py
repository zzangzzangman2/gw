from __future__ import annotations

import csv
import json
import re
import shutil
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DIR = PROJECT / "Assets" / "RestoreData" / "reports"
RESTORE_DATA = PROJECT / "Assets" / "RestoreData"
REPORT_MD_DIR = BASE / "reports" / "maininterface"

RECT_CSV = RESTORE_DATA / "maininterface_rects.csv"
SPRITE_CSV = RESTORE_DATA / "maininterface_sprite_map.csv"
EXPORT_MAP_CSV = MERGED / "indexes" / "unity_bundle_export_map.csv"
MAIN_LUA = MERGED / "decoded" / "xlua" / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"
HERO_INITIAL = MERGED / "extracted" / "config_zips" / "download" / "config" / "hero" / "DTHeroInitialEntityTableData.bigd"

OUT_CSV = REPORT_DIR / "maininterface_visual_gap_evidence.csv"
OUT_JSON = REPORT_DIR / "maininterface_visual_gap_summary.json"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_VISUAL_GAP_ANALYSIS.md"
OUT_VISUAL_OVERRIDES = RESTORE_DATA / "maininterface_visual_overrides.csv"
RUNTIME_SPRITE_DIR = PROJECT / "Assets" / "RestoredSprites" / "maininterface" / "runtime_dynamic"

ROOT_RECT_ID = "5568884429252053541"
ROOT_UI_BG_GO = "-1457103517121630268"
ROOT_UI_BG_COMPONENT = "6259596902678607660"

KEYWORDS = [
    "UI_bg",
    "UI_heroSpine",
    "UI_touchSpine",
    "p_changeBgHero",
    "GetPaintingBg",
    "LoadSpriteWithFullPath",
    "GetPlayerBigSpineAll",
    "GetPlayerUnderwearSpine",
    "GetPlayerLive2dModel",
    "mainShowHeroList",
    "showHeroIndex",
]


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def get_image_size(path: Path) -> tuple[int, int] | tuple[None, None]:
    try:
        from PIL import Image

        with Image.open(path) as img:
            return img.size
    except Exception:
        return None, None


def active_chain(row: dict[str, str], by_rect: dict[str, dict[str, str]]) -> bool:
    cur = row
    seen: set[str] = set()
    while cur:
        path_id = cur.get("path_id", "")
        if path_id in seen:
            break
        seen.add(path_id)
        if cur.get("game_object_active", "").lower() == "false":
            return False
        father = cur.get("father_id", "")
        cur = by_rect.get(father)
    return True


def hierarchy_path(row: dict[str, str], by_rect: dict[str, dict[str, str]]) -> str:
    parts: list[str] = []
    cur = row
    seen: set[str] = set()
    while cur:
        path_id = cur.get("path_id", "")
        if path_id in seen:
            break
        seen.add(path_id)
        name = cur.get("game_object_name", "") or "rect"
        parts.append(f"{name}({path_id})")
        cur = by_rect.get(cur.get("father_id", ""))
    return "/".join(reversed(parts))


def first_default_hero_id() -> str:
    if not HERO_INITIAL.exists():
        return "1001"
    for line in HERO_INITIAL.read_text(encoding="utf-8", errors="replace").splitlines():
        match = re.search(r'"id"\s*:\s*(\d+)', line)
        if match:
            return match.group(1)
    return "1001"


def load_export_map() -> dict[str, str]:
    result: dict[str, str] = {}
    for row in read_csv(EXPORT_MAP_CSV):
        result[row["bundle"].lower()] = row["export_dir"]
    return result


def find_texture_in_bundle(export_map: dict[str, str], bundle: str, pattern: str) -> Path | None:
    export_rel = export_map.get(bundle.lower())
    if not export_rel:
        return None
    export_dir = MERGED / export_rel
    for sub in ("images/T", "images/S"):
        folder = export_dir / sub
        if not folder.exists():
            continue
        matches = sorted(folder.glob(pattern))
        if matches:
            return matches[0]
    return None


def copy_runtime_sprite(source: Path, hero_id: str) -> str:
    RUNTIME_SPRITE_DIR.mkdir(parents=True, exist_ok=True)
    dest = RUNTIME_SPRITE_DIR / f"runtime_UI_bg_noalphabg_PaintingBG_{hero_id}.png"
    shutil.copy2(source, dest)
    return "Assets/" + dest.relative_to(PROJECT / "Assets").as_posix()


def scan_lua_evidence(rows: list[dict[str, Any]]) -> dict[str, int]:
    counts = Counter()
    if not MAIN_LUA.exists():
        return {}
    pattern = re.compile("|".join(re.escape(k) for k in KEYWORDS), re.IGNORECASE)
    for number, line in enumerate(MAIN_LUA.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
        if not pattern.search(line):
            continue
        key = next((k for k in KEYWORDS if k.lower() in line.lower()), "runtime")
        counts[key] += 1
        rows.append(
            {
                "evidence_kind": "lua_runtime",
                "target": key,
                "hierarchy_path": "",
                "path_id": "",
                "game_object_id": "",
                "game_object_name": "",
                "active_self": "",
                "active_chain": "",
                "component_path_id": "",
                "sprite_name": "",
                "sprite_status": "",
                "color_a": "",
                "asset_path": str(MAIN_LUA),
                "source_path": str(MAIN_LUA),
                "bundle": "",
                "line": number,
                "excerpt": line.strip(),
                "reason": "decoded UI_MainPage runtime loader evidence",
            }
        )
    return dict(counts)


def main() -> None:
    rects = read_csv(RECT_CSV)
    sprites = read_csv(SPRITE_CSV)
    by_rect = {r["path_id"]: r for r in rects}
    sprites_by_go: dict[str, list[dict[str, str]]] = {}
    for row in sprites:
        sprites_by_go.setdefault(row.get("game_object_id", ""), []).append(row)

    evidence: list[dict[str, Any]] = []
    target_name_re = re.compile(r"(UI_bg|UI_heroSpine|UI_touchSpine|p_changeBgHero|spine|hero|painting|bg)", re.I)

    for row in rects:
        name = row.get("game_object_name", "")
        if not target_name_re.search(name):
            continue
        go_id = row.get("game_object_id", "")
        sprite_rows = sprites_by_go.get(go_id) or [None]
        for sprite in sprite_rows:
            sprite = sprite or {}
            evidence.append(
                {
                    "evidence_kind": "prefab_node",
                    "target": name,
                    "hierarchy_path": hierarchy_path(row, by_rect),
                    "path_id": row.get("path_id", ""),
                    "game_object_id": go_id,
                    "game_object_name": name,
                    "active_self": row.get("game_object_active", ""),
                    "active_chain": active_chain(row, by_rect),
                    "component_path_id": sprite.get("component_path_id", ""),
                    "sprite_name": sprite.get("sprite_name", ""),
                    "sprite_status": sprite.get("status", ""),
                    "color_a": sprite.get("color_a", ""),
                    "asset_path": sprite.get("unity_asset_path", ""),
                    "source_path": sprite.get("source_output", ""),
                    "bundle": sprite.get("dependency_bundle", row.get("bundle", "")),
                    "line": "",
                    "excerpt": "",
                    "reason": "prefab hierarchy/image state relevant to current black capture",
                }
            )

    lua_counts = scan_lua_evidence(evidence)

    export_map = load_export_map()
    hero_id = first_default_hero_id()
    painting_bundle = f"download/roleprefabsandres/paintingprefabandres/{hero_id}.assetbundle"
    runtime_bg_source = find_texture_in_bundle(export_map, painting_bundle, f"*noalphabg_PaintingBG_{hero_id}.png")
    runtime_bg_asset = ""
    runtime_bg_size = (None, None)
    if runtime_bg_source:
        runtime_bg_asset = copy_runtime_sprite(runtime_bg_source, hero_id)
        runtime_bg_size = get_image_size(runtime_bg_source)

    prefab_ui_bg = next(
        (s for s in sprites if s.get("component_path_id") == ROOT_UI_BG_COMPONENT),
        {},
    )
    prefab_sprite_source = Path(prefab_ui_bg.get("source_output", ""))
    if prefab_sprite_source and not prefab_sprite_source.is_absolute():
        prefab_sprite_source = MERGED / prefab_sprite_source
    prefab_sprite_size = get_image_size(prefab_sprite_source) if prefab_sprite_source.exists() else (None, None)

    runtime_candidates = []
    for bundle, export_rel in export_map.items():
        if "/paintingprefabandres/" in bundle or "/rolebigsetpainting/" in bundle:
            export_dir = MERGED / export_rel
            pngs = list((export_dir / "images" / "T").glob("*.png")) + list((export_dir / "images" / "S").glob("*.png"))
            runtime_candidates.append((bundle, len(pngs)))

    visual_override_rows = []
    if runtime_bg_asset:
        visual_override_rows.append(
            {
                "target_kind": "Image",
                "component_path_id": ROOT_UI_BG_COMPONENT,
                "game_object_id": ROOT_UI_BG_GO,
                "game_object_name": "UI_bg",
                "sprite_asset_path": runtime_bg_asset,
                "color_r": "1",
                "color_g": "1",
                "color_b": "1",
                "color_a": "1",
                "preserve_aspect": "0",
                "image_type": "0",
                "raycast_target": "",
                "reason": f"UI_MainPage refreshMiddle line 1559-1560 loads UI_bg from UIUtil.GetPaintingBg(heroId); default config hero id {hero_id}",
            }
        )

    write_csv(
        OUT_VISUAL_OVERRIDES,
        visual_override_rows,
        [
            "target_kind",
            "component_path_id",
            "game_object_id",
            "game_object_name",
            "sprite_asset_path",
            "color_r",
            "color_g",
            "color_b",
            "color_a",
            "preserve_aspect",
            "image_type",
            "raycast_target",
            "reason",
        ],
    )

    fieldnames = [
        "evidence_kind",
        "target",
        "hierarchy_path",
        "path_id",
        "game_object_id",
        "game_object_name",
        "active_self",
        "active_chain",
        "component_path_id",
        "sprite_name",
        "sprite_status",
        "color_a",
        "asset_path",
        "source_path",
        "bundle",
        "line",
        "excerpt",
        "reason",
    ]
    write_csv(OUT_CSV, evidence, fieldnames)

    by_kind = Counter(row["evidence_kind"] for row in evidence)
    active_bg_rows = [
        row for row in evidence
        if row["evidence_kind"] == "prefab_node" and row["game_object_name"] == "UI_bg" and row["active_chain"] is True
    ]
    summary = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "default_hero_id": hero_id,
        "prefab_root_ui_bg_component": ROOT_UI_BG_COMPONENT,
        "prefab_root_ui_bg_color_a": prefab_ui_bg.get("color_a", ""),
        "prefab_root_ui_bg_sprite": prefab_ui_bg.get("sprite_name", ""),
        "prefab_root_ui_bg_sprite_export": str(prefab_sprite_source) if prefab_sprite_source else "",
        "prefab_root_ui_bg_sprite_export_size": prefab_sprite_size,
        "runtime_bg_bundle": painting_bundle,
        "runtime_bg_source": str(runtime_bg_source) if runtime_bg_source else "",
        "runtime_bg_source_size": runtime_bg_size,
        "runtime_bg_unity_asset_path": runtime_bg_asset,
        "visual_override_rows": len(visual_override_rows),
        "active_ui_bg_evidence_rows": len(active_bg_rows),
        "runtime_candidate_bundle_count": len(runtime_candidates),
        "runtime_candidate_image_count": sum(count for _, count in runtime_candidates),
        "lua_keyword_counts": lua_counts,
        "evidence_counts": dict(by_kind),
        "csv": str(OUT_CSV),
        "json": str(OUT_JSON),
        "markdown": str(OUT_MD),
        "visual_overrides": str(OUT_VISUAL_OVERRIDES),
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    REPORT_MD_DIR.mkdir(parents=True, exist_ok=True)
    md = [
        "# MainInterface Visual Gap Analysis",
        "",
        f"- Generated: `{summary['generated_at']}`",
        f"- Default hero candidate: `{hero_id}` from `DTHeroInitialEntityTableData.bigd`",
        f"- Root `UI_bg` component: `{ROOT_UI_BG_COMPONENT}`",
        f"- Root `UI_bg` prefab sprite: `{summary['prefab_root_ui_bg_sprite']}` alpha `{summary['prefab_root_ui_bg_color_a']}`",
        f"- Runtime background source: `{summary['runtime_bg_source']}`",
        f"- Runtime background Unity asset: `{summary['runtime_bg_unity_asset_path']}`",
        f"- Visual overrides written: `{summary['visual_override_rows']}`",
        "",
        "## Finding",
        "",
        "- The current black capture is not caused by a missing full-screen RectTransform. The root `UI_bg` exists under the active MainInterface root, but its prefab Image alpha is `0.0`.",
        "- `UI_MainPage` runtime logic loads the visible background with `UIUtil.GetPaintingBg(heroId)` and `GameTools:LoadSpriteWithFullPath(UI_bg, e, true)`.",
        "- Character display is runtime Spine/Live2D loading, not a normal Image sprite. `Painting_*.png` files are atlas textures and must not be used as final UI pieces by themselves.",
        "- The safe immediate visual restore is to apply only the runtime background texture to the existing `UI_bg` Image, leaving character/Spine as a separate renderer task.",
        "",
        "## Lua Evidence",
        "",
    ]
    for key, value in sorted(lua_counts.items()):
        md.append(f"- `{key}`: `{value}`")
    md.extend(
        [
            "",
            "## Output Files",
            "",
            f"- Evidence CSV: `{OUT_CSV}`",
            f"- Summary JSON: `{OUT_JSON}`",
            f"- Visual override CSV: `{OUT_VISUAL_OVERRIDES}`",
            f"- Markdown: `{OUT_MD}`",
        ]
    )
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
