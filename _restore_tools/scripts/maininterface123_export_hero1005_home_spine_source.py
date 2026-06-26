import csv
import gzip
import json
import re
import shutil
import struct
from datetime import datetime
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
UNITY = BASE / "girlswar_maininterface_unity"
RESTORE = UNITY / "Assets" / "RestoreData"
REPORTS = BASE / "reports" / "maininterface"
INDEXES = MERGED / "indexes"

HERO_ID = 1005
SOURCE_EXPORT_DIR = RESTORE / "hero1005_spine_source"

LUA_MAIN = MERGED / "decoded" / "xlua" / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"
DTMODEL_ENTITY = MERGED / "extracted" / "unity" / "bundles" / "b_a6bf6dda1077db5c" / "textassets" / "4179655536068063362_DTmodelEntity.txt"
DTMODEL_TABLE = MERGED / "extracted" / "unity" / "bundles" / "b_a6bf6dda1077db5c" / "textassets" / "-741484770043515851_DTmodelEntityTableData.txt"

OUT_JSON = RESTORE / "maininterface_123_hero1005_home_spine_source_export.json"
OUT_MD = REPORTS / "MAININTERFACE_123_HERO1005_HOME_SPINE_SOURCE_EXPORT_RESULT.md"
OUT_EXPORT_CSV = REPORTS / "MAININTERFACE_123_hero1005_spine_source_export.csv"
OUT_DTMODEL_CSV = REPORTS / "MAININTERFACE_123_hero1005_dtmodel_fields.csv"
OUT_ATLAS_CSV = REPORTS / "MAININTERFACE_123_hero1005_atlas_regions.csv"
OUT_STRUCTURE_CSV = REPORTS / "MAININTERFACE_123_hero1005_paintingprefab_roots.csv"
TOOL = BASE / "_restore_tools" / "cmd_archive" / "123_EXPORT_HERO1005_HOME_SPINE_SOURCE.cmd"

BUNDLES = {
    "paintingprefabandres_1005": "download/roleprefabsandres/paintingprefabandres/1005.assetbundle",
    "rolebigsetpainting_1005_reference": "download/roleprefabsandres/rolebigsetpainting/1005.assetbundle",
    "battleprefabandres_1005_reference": "download/roleprefabsandres/battleprefabandres/1005.assetbundle",
}

IMPORTANT_FIELDS = [
    "id",
    "painting",
    "paintingGroup",
    "paintingGroup_A2",
    "paintingGroup_A2_front",
    "live2d",
    "homePara",
    "teamPara",
    "haremPara",
    "bigPainting",
    "paintingBg_back",
    "paintingBg_front",
    "paintingBg",
    "collection_normal_Pic",
    "collectionPic",
    "prefabId",
    "prefabUiId",
    "prefabUiGroupId",
    "battleZoom",
    "uiZoom",
    "storyPainting",
    "storyPainting2",
    "lovePainting",
    "lovePaintingPara",
    "getHeroName",
    "getHeroNamePara",
    "marryMainInterfaceSelect",
    "selfMarryMainInterfaceSelect",
]


class LuaTableParser:
    def __init__(self, text):
        self.text = text
        self.i = 0

    def peek(self):
        if self.i >= len(self.text):
            return ""
        return self.text[self.i]

    def skip_ws(self):
        while self.peek() and self.peek().isspace():
            self.i += 1

    def parse(self):
        value = self.parse_value()
        self.skip_ws()
        return value

    def parse_value(self):
        self.skip_ws()
        c = self.peek()
        if c == "{":
            return self.parse_table()
        if c == '"':
            return self.parse_string()
        if c in "-0123456789":
            return self.parse_number()
        return self.parse_identifier()

    def parse_table(self):
        items = []
        self.i += 1
        while True:
            self.skip_ws()
            if self.peek() == "}":
                self.i += 1
                return items
            items.append(self.parse_value())
            self.skip_ws()
            if self.peek() == ",":
                self.i += 1
                continue
            if self.peek() == "}":
                continue
            raise ValueError(f"Unexpected table character {self.peek()!r} at {self.i}")

    def parse_string(self):
        self.i += 1
        out = []
        while True:
            c = self.peek()
            if not c:
                raise ValueError("Unexpected EOF in string")
            self.i += 1
            if c == '"':
                return "".join(out)
            if c == "\\":
                nxt = self.peek()
                if not nxt:
                    raise ValueError("Unexpected EOF after escape")
                self.i += 1
                out.append(nxt)
            else:
                out.append(c)

    def parse_number(self):
        start = self.i
        while self.peek() and self.peek() in "-+0123456789.eE":
            self.i += 1
        raw = self.text[start:self.i]
        if "." in raw or "e" in raw.lower():
            return float(raw)
        return int(raw)

    def parse_identifier(self):
        start = self.i
        while self.peek() and re.match(r"[A-Za-z0-9_./:-]", self.peek()):
            self.i += 1
        raw = self.text[start:self.i]
        if raw == "true":
            return True
        if raw == "false":
            return False
        if raw == "nil":
            return None
        if raw:
            return raw
        raise ValueError(f"Cannot parse at {self.i}")


def read_csv(path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path, rows, fieldnames=None):
    path.parent.mkdir(parents=True, exist_ok=True)
    if fieldnames is None:
        fieldnames = sorted({k for row in rows for k in row.keys()})
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def read_text(path):
    return path.read_text(encoding="utf-8", errors="replace")


def as_compact(value):
    return json.dumps(value, ensure_ascii=False, separators=(",", ":"))


def parse_dtmodel_schema():
    text = read_text(DTMODEL_ENTITY)
    schema = {}
    for name, index in re.findall(r"e\.([A-Za-z_][A-Za-z0-9_]*)=t\[(\d+)\]", text):
        schema[int(index)] = name
    return schema


def extract_hero_row(hero_id):
    for line in read_text(DTMODEL_TABLE).splitlines():
        stripped = line.strip()
        if stripped.startswith("{" + str(hero_id) + ","):
            if stripped.endswith(","):
                stripped = stripped[:-1]
            return LuaTableParser(stripped).parse(), stripped
    raise FileNotFoundError(f"DTmodel row for hero {hero_id} was not found")


def selected_dtmodel_rows(schema, values):
    rows = []
    fields = {}
    for index, value in enumerate(values, 1):
        name = schema.get(index, f"t[{index}]")
        fields[name] = value
        if name in IMPORTANT_FIELDS:
            rows.append({"index": index, "field": name, "value": as_compact(value)})
    return rows, fields


def export_map():
    return {row.get("bundle", ""): row.get("export_dir", "") for row in read_csv(INDEXES / "unity_bundle_export_map.csv")}


def bundle_rows(bundle_names):
    meta = {row.get("bundle", ""): row for row in read_csv(INDEXES / "assetbundles.csv")}
    mapped = export_map()
    rows = []
    for bundle in bundle_names:
        row = meta.get(bundle, {})
        rows.append(
            {
                "bundle": bundle,
                "status": row.get("status", "missing_from_assetbundles_index"),
                "size": row.get("size", ""),
                "object_count": row.get("object_count", ""),
                "type_counts": row.get("type_counts", ""),
                "export_dir": mapped.get(bundle, ""),
            }
        )
    return rows


def png_size(path):
    try:
        with path.open("rb") as f:
            header = f.read(24)
        if not header.startswith(b"\x89PNG\r\n\x1a\n"):
            return "", ""
        return struct.unpack(">II", header[16:24])
    except Exception:
        return "", ""


def normalized_name(path):
    name = path.name
    if "_" in name:
        name = name.split("_", 1)[1]
    if name.endswith(".skel.txt"):
        return name[: -len(".skel.txt")] + ".skel.bytes"
    return name


def classify(label, name):
    lower = name.lower()
    if label == "paintingprefabandres_1005":
        if "paintingbg_1005" in lower:
            return "runtime UI_bg background"
        if "painting_1005" in lower and (lower.endswith(".atlas.txt") or lower.endswith(".skel.txt")):
            return "runtime UI_heroSpine skeleton source"
        if "painting_1005" in lower and lower.endswith(".png"):
            return "spine atlas page; do not use as whole UI image"
        if "sp_heroname_1005" in lower:
            return "spine hero name source"
    if label == "rolebigsetpainting_1005_reference":
        return "static reference/non-home fallback; not default UI_heroSpine runtime"
    if label == "battleprefabandres_1005_reference":
        return "battle skeleton reference; not MainInterface home default"
    return "reference"


def export_source_assets(bundle_info):
    target_root = SOURCE_EXPORT_DIR.resolve()
    restore_root = RESTORE.resolve()
    if target_root.exists():
        if restore_root not in [target_root, *target_root.parents]:
            raise RuntimeError(f"Refusing to clear outside RestoreData: {target_root}")
        shutil.rmtree(target_root)
    SOURCE_EXPORT_DIR.mkdir(parents=True, exist_ok=True)

    rows = []
    for label, bundle in BUNDLES.items():
        src_rel = next((r["export_dir"] for r in bundle_info if r["bundle"] == bundle), "")
        if not src_rel:
            continue
        src_dir = MERGED / src_rel
        dest_dir = SOURCE_EXPORT_DIR / label
        dest_dir.mkdir(parents=True, exist_ok=True)

        candidates = []
        for src in sorted(src_dir.rglob("*")):
            if not src.is_file() or src.name in {"structure.jsonl.gz", "type_counts.json"}:
                continue
            if not (src.suffix.lower() == ".png" or src.name.endswith(".atlas.txt") or src.name.endswith(".skel.txt")):
                continue
            candidates.append((src, normalized_name(src)))

        name_counts = {}
        for _, dest_name in candidates:
            name_counts[dest_name] = name_counts.get(dest_name, 0) + 1

        used_names = set()
        for src, dest_name in candidates:
            if name_counts.get(dest_name, 0) > 1 and any(part == "S" for part in src.parts):
                dest_name = "sprite_" + dest_name
            if dest_name in used_names:
                stem = Path(dest_name).stem
                suffix = Path(dest_name).suffix
                counter = 2
                while f"{stem}_{counter}{suffix}" in used_names:
                    counter += 1
                dest_name = f"{stem}_{counter}{suffix}"
            used_names.add(dest_name)
            dest = dest_dir / dest_name
            shutil.copy2(src, dest)
            width, height = png_size(dest) if dest.suffix.lower() == ".png" else ("", "")
            rows.append(
                {
                    "source_bundle": label,
                    "source_path": str(src),
                    "export_path": str(dest),
                    "file_name": dest.name,
                    "bytes": dest.stat().st_size,
                    "png_width": width,
                    "png_height": height,
                    "note": classify(label, src.name),
                }
            )

    readme = SOURCE_EXPORT_DIR / "README.md"
    readme.write_text(
        "\n".join(
            [
                "# Hero 1005 Spine Source Export",
                "",
                "Source assets for evidence-backed MainInterface hero restoration.",
                "Do not place Painting_1005.png directly as a UI Image. It is a Spine atlas page.",
                "Default home source:",
                "`paintingprefabandres_1005/Painting_1005.atlas.txt` + `Painting_1005.skel.bytes` + `Painting_1005.png`",
                "Runtime background:",
                "`paintingprefabandres_1005/noalphabg_PaintingBG_1005.png`",
            ]
        ),
        encoding="utf-8",
    )
    return rows


def parse_atlas(path):
    lines = [line.strip() for line in read_text(path).splitlines() if line.strip()]
    pages = []
    regions = []
    for line in lines:
        if line.endswith(".png"):
            pages.append(line)
        elif ":" not in line:
            regions.append(line)
    return {
        "atlas_file": path.name,
        "page": ";".join(pages),
        "region_count": len(regions),
        "first_regions": ", ".join(regions[:12]),
    }


def analyze_structure(export_dir):
    path = export_dir / "structure.jsonl.gz"
    if not path.exists():
        return [], {"root_count": 0, "skeleton_behaviour_count": 0}

    game_objects = {}
    rects = {}
    skeleton_behaviours = []
    type_counts = {}
    with gzip.open(path, "rt", encoding="utf-8", errors="replace") as f:
        for line in f:
            if not line.strip():
                continue
            obj = json.loads(line)
            typ = obj.get("type")
            tree = obj.get("tree", {})
            type_counts[typ] = type_counts.get(typ, 0) + 1
            if typ == "GameObject":
                game_objects[obj.get("path_id")] = {"name": tree.get("m_Name", ""), "active": tree.get("m_IsActive", "")}
            elif typ == "RectTransform":
                rects[obj.get("path_id")] = {
                    "game_object": tree.get("m_GameObject", {}).get("m_PathID", 0),
                    "father": tree.get("m_Father", {}).get("m_PathID", 0),
                    "pos_x": tree.get("m_AnchoredPosition", {}).get("x", ""),
                    "pos_y": tree.get("m_AnchoredPosition", {}).get("y", ""),
                    "size_x": tree.get("m_SizeDelta", {}).get("x", ""),
                    "size_y": tree.get("m_SizeDelta", {}).get("y", ""),
                    "scale_x": tree.get("m_LocalScale", {}).get("x", ""),
                    "scale_y": tree.get("m_LocalScale", {}).get("y", ""),
                }
            elif typ == "MonoBehaviour" and ("skeletonDataAsset" in tree or "startingAnimation" in tree):
                skeleton_behaviours.append(
                    {
                        "game_object_id": tree.get("m_GameObject", {}).get("m_PathID", 0),
                        "game_object_name": "",
                        "starting_animation": tree.get("startingAnimation", ""),
                        "starting_loop": tree.get("startingLoop", ""),
                        "skeleton_data_asset": as_compact(tree.get("skeletonDataAsset", {})),
                    }
                )

    child_count = {}
    for rect in rects.values():
        child_count[rect["father"]] = child_count.get(rect["father"], 0) + 1
    root_rows = []
    for rect_id, rect in rects.items():
        if rect["father"] not in (0, None):
            continue
        go = game_objects.get(rect["game_object"], {})
        root_rows.append(
            {
                "rect_id": rect_id,
                "game_object_id": rect["game_object"],
                "game_object_name": go.get("name", ""),
                "active": go.get("active", ""),
                "child_count": child_count.get(rect_id, 0),
                "pos_x": rect["pos_x"],
                "pos_y": rect["pos_y"],
                "size_x": rect["size_x"],
                "size_y": rect["size_y"],
                "scale_x": rect["scale_x"],
                "scale_y": rect["scale_y"],
            }
        )
    for item in skeleton_behaviours:
        item["game_object_name"] = game_objects.get(item["game_object_id"], {}).get("name", "")
    return root_rows, {
        "type_counts": type_counts,
        "root_count": len(root_rows),
        "skeleton_behaviour_count": len(skeleton_behaviours),
        "skeleton_behaviours_sample": skeleton_behaviours[:12],
    }


def lua_evidence():
    lines = read_text(LUA_MAIN).splitlines()
    wanted = {
        1543: "default home BigSpine loader",
        1546: "homePara parameter",
        1558: "UI_touchSpine active for default branch",
        1559: "painting background lookup",
        1560: "UI_bg LoadSpriteWithFullPath",
        1640: "marry/self marry Live2D branch loader",
    }
    return [
        {"line": line_no, "note": note, "text": lines[line_no - 1].strip()}
        for line_no, note in wanted.items()
    ]


def detect_spine_runtime():
    files = []
    for path in (UNITY / "Assets" / "Spine" / "Runtime").rglob("*"):
        if path.is_file() and path.name in {"SkeletonGraphic.cs", "SkeletonDataAsset.cs", "SpineAtlasAsset.cs"}:
            files.append(str(path))
    return {"present": len(files) >= 3, "matching_files": files}


def md_table(headers, rows):
    out = ["| " + " | ".join(headers) + " |", "| " + " | ".join("---" for _ in headers) + " |"]
    for row in rows:
        out.append("| " + " | ".join(str(row.get(h, "")).replace("|", "\\|") for h in headers) + " |")
    return "\n".join(out)


def main():
    REPORTS.mkdir(parents=True, exist_ok=True)
    RESTORE.mkdir(parents=True, exist_ok=True)

    schema = parse_dtmodel_schema()
    values, raw_row = extract_hero_row(HERO_ID)
    dt_rows, fields = selected_dtmodel_rows(schema, values)
    bundle_info = bundle_rows(list(BUNDLES.values()) + ["download/commonprefabsandres/spinematandshaders.assetbundle"])
    export_rows = export_source_assets(bundle_info)
    painting_dir = MERGED / next(r["export_dir"] for r in bundle_info if r["bundle"] == BUNDLES["paintingprefabandres_1005"])
    atlas_rows = [parse_atlas(path) for path in sorted(painting_dir.rglob("*.atlas.txt"))]
    structure_rows, structure = analyze_structure(painting_dir)
    runtime = detect_spine_runtime()
    lua_rows = lua_evidence()

    write_csv(OUT_EXPORT_CSV, export_rows)
    write_csv(OUT_DTMODEL_CSV, dt_rows, ["index", "field", "value"])
    write_csv(OUT_ATLAS_CSV, atlas_rows, ["atlas_file", "page", "region_count", "first_regions"])
    write_csv(OUT_STRUCTURE_CSV, structure_rows)

    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "heroId": HERO_ID,
        "sourceExportDir": str(SOURCE_EXPORT_DIR),
        "sourceExportCount": len(export_rows),
        "dtmodelRawRowPrefix": raw_row[:500],
        "dtmodelSelected": {row["field"]: row["value"] for row in dt_rows},
        "bundleRows": bundle_info,
        "atlasRows": atlas_rows,
        "paintingprefabStructure": structure,
        "luaEvidence": lua_rows,
        "spineRuntime": runtime,
        "restoreDecision": {
            "defaultHomeSource": BUNDLES["paintingprefabandres_1005"],
            "doNotUseWholeAtlasAsUiImage": True,
            "homeParameter": fields.get("homePara"),
            "backgroundSpriteName": fields.get("paintingBg"),
            "nextBlocker": "Create/import SpineAtlasAsset + SkeletonDataAsset for Painting_1005 and mount a SkeletonGraphic under UI_heroSpine.",
        },
    }
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    runtime_label = "present" if runtime["present"] else "missing"
    skeleton_rows = structure.get("skeleton_behaviours_sample", [])
    md = [
        "# MainInterface 123 Hero 1005 Home Spine Source Export Result",
        "",
        f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} KST",
        "",
        "## Verdict",
        "",
        "Evidence-backed source export applied. This does not claim visual restoration: it prepares the original 1005 home Spine source assets required by the Lua `GetPlayerBigSpineAll(..., \"homePara\")` branch.",
        "",
        f"- Source export dir: `{SOURCE_EXPORT_DIR}`",
        f"- Exported files: `{len(export_rows)}`",
        f"- Spine runtime in restore project: `{runtime_label}`",
        f"- 1005 `homePara`: `{as_compact(fields.get('homePara'))}`",
        f"- 1005 `paintingBg`: `{as_compact(fields.get('paintingBg'))}`",
        "",
        "## Bundle Evidence",
        "",
        md_table(["bundle", "status", "size", "object_count", "export_dir"], bundle_info),
        "",
        "## Lua Evidence",
        "",
        md_table(["line", "note", "text"], lua_rows),
        "",
        "## Painting Prefab Structure",
        "",
        f"- Root RectTransforms: `{structure.get('root_count', 0)}`",
        f"- SkeletonGraphic-like behaviours: `{structure.get('skeleton_behaviour_count', 0)}`",
        "",
        md_table(["game_object_name", "starting_animation", "starting_loop", "skeleton_data_asset"], skeleton_rows[:8]),
        "",
        "## Atlas Evidence",
        "",
        md_table(["atlas_file", "page", "region_count", "first_regions"], atlas_rows),
        "",
        "## Next Blocker",
        "",
        "Create/import Unity Spine assets for `Painting_1005.atlas.txt`, `Painting_1005.skel.bytes`, and `Painting_1005.png`, then mount a real `SkeletonGraphic` under `UI_heroSpine` using the 1005 `homePara` evidence. Do not use `Painting_1005.png` as a whole UI Image.",
        "",
        "Route/world cluster active state remains separately blocked: decoded Lua still provides no normal-home evidence to hide `wanfaWorldNode/worldwanfaBtn`.",
        "",
        "## Files",
        "",
        f"- JSON: `{OUT_JSON}`",
        f"- Export CSV: `{OUT_EXPORT_CSV}`",
        f"- DTmodel CSV: `{OUT_DTMODEL_CSV}`",
        f"- Atlas CSV: `{OUT_ATLAS_CSV}`",
        f"- Structure CSV: `{OUT_STRUCTURE_CSV}`",
        f"- Tool: `{TOOL}`",
    ]
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    TOOL.write_text(
        "@echo off\r\n"
        "setlocal\r\n"
        "cd /d C:\\Users\\godho\\Downloads\\girlswar\r\n"
        "py -3 _restore_tools\\scripts\\maininterface123_export_hero1005_home_spine_source.py\r\n",
        encoding="utf-8",
    )

    print(f"Wrote {OUT_JSON}")
    print(f"Wrote {OUT_MD}")
    print(f"Wrote {OUT_EXPORT_CSV}")
    print(f"Wrote {SOURCE_EXPORT_DIR}")
    print(f"Wrote {TOOL}")


if __name__ == "__main__":
    main()
