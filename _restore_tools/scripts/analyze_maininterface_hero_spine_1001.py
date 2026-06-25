import csv
import gzip
import json
import re
import shutil
import struct
from datetime import datetime
from pathlib import Path


BASE = Path(__file__).resolve().parents[2]
MERGED = BASE / "girlswar_merged_extracted"
UNITY = BASE / "girlswar_maininterface_unity"
REPORTS = BASE / "reports" / "maininterface"
RESTORE_REPORTS = UNITY / "Assets" / "RestoreData" / "reports"

LUA_MAIN = MERGED / "decoded" / "xlua" / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"
DTMODEL_ENTITY = (
    MERGED
    / "extracted"
    / "unity"
    / "bundles"
    / "b_a6bf6dda1077db5c"
    / "textassets"
    / "4179655536068063362_DTmodelEntity.txt"
)
DTMODEL_TABLE = (
    MERGED
    / "extracted"
    / "unity"
    / "bundles"
    / "b_a6bf6dda1077db5c"
    / "textassets"
    / "-741484770043515851_DTmodelEntityTableData.txt"
)

ASSETBUNDLES_CSV = MERGED / "indexes" / "assetbundles.csv"
EXPORT_MAP_CSV = MERGED / "indexes" / "unity_bundle_export_map.csv"
UI_TEXTS_CSV = MERGED / "indexes" / "ui_texts.csv"

PAINTING_BUNDLE = (
    MERGED / "extracted" / "unity" / "bundles" / "b_4b5f2d65cb02985b"
)
ROLEBIG_BUNDLE = (
    MERGED / "extracted" / "unity" / "bundles" / "b_56fb3732c538f3bd"
)
BATTLE_BUNDLE = (
    MERGED / "extracted" / "unity" / "bundles" / "b_b39866f560e64bb6"
)

SOURCE_EXPORT_DIR = UNITY / "Assets" / "RestoreData" / "hero1001_spine_source"

SUMMARY_JSON = RESTORE_REPORTS / "maininterface_hero1001_spine_summary.json"
ASSETS_CSV = RESTORE_REPORTS / "maininterface_hero1001_assets.csv"
DTMODEL_CSV = RESTORE_REPORTS / "maininterface_hero1001_dtmodel_fields.csv"
ATLAS_CSV = RESTORE_REPORTS / "maininterface_hero1001_atlas_regions.csv"
STRUCTURE_CSV = RESTORE_REPORTS / "maininterface_hero1001_structure_roots.csv"
EXPORT_MANIFEST_CSV = RESTORE_REPORTS / "maininterface_hero1001_spine_source_export.csv"
MARKDOWN = REPORTS / "MAININTERFACE_HERO_SPINE_RESTORE_PLAN.md"


IMPORTANT_FIELDS = [
    "id",
    "painting",
    "paintingGroup",
    "paintingGroup_A2",
    "paintingGroup_A2_front",
    "live2d",
    "paintingVoice",
    "homePara",
    "teamPara",
    "haremPara",
    "bigPainting",
    "arenaBg",
    "arenaMask",
    "homepageUWPainting",
    "arenaPara",
    "battleWinMvp",
    "rankPara",
    "jieYuanPara",
    "paintingBg_back",
    "paintingBg_front",
    "paintingBg",
    "storyBg",
    "collection_normal_Pic",
    "collectionPic",
    "head",
    "head2",
    "haremPainting",
    "starHead",
    "prefabId",
    "prefabUiId",
    "prefabUiGroupId",
    "battleZoom",
    "lockZoom",
    "profileZoom",
    "uiZoom",
    "storyPainting",
    "storyPainting2",
    "lovePainting",
    "lovePaintingPara",
    "getHeroName",
    "getHeroNamePara",
    "loveFace",
    "starHeroName",
    "marryStoryBg",
    "marryMainInterfaceSelect",
    "selfMarryMainInterfaceSelect",
    "marryRingSelect",
    "marryCardBg",
    "marryCardModel",
    "marryAtlasModel",
    "tujianUnlockMarryBg",
    "marryWeddingHand",
    "marryWeddingAvg",
]


class LuaTableParser:
    def __init__(self, text):
        self.text = text
        self.i = 0

    def parse(self):
        value = self.parse_value()
        self.skip_ws()
        return value

    def peek(self):
        if self.i >= len(self.text):
            return ""
        return self.text[self.i]

    def skip_ws(self):
        while self.peek() and self.peek().isspace():
            self.i += 1

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
            if not self.peek():
                raise ValueError("Unexpected EOF while parsing table")
            raise ValueError(f"Unexpected table character {self.peek()!r} at {self.i}")

    def parse_string(self):
        self.i += 1
        out = []
        while True:
            c = self.peek()
            if not c:
                raise ValueError("Unexpected EOF while parsing string")
            self.i += 1
            if c == '"':
                return "".join(out)
            if c == "\\":
                nxt = self.peek()
                if not nxt:
                    raise ValueError("Unexpected EOF after string escape")
                self.i += 1
                out.append(nxt)
            else:
                out.append(c)

    def parse_number(self):
        start = self.i
        while self.peek() and self.peek() in "-+0123456789.eE":
            self.i += 1
        raw = self.text[start : self.i]
        if "." in raw or "e" in raw.lower():
            return float(raw)
        return int(raw)

    def parse_identifier(self):
        start = self.i
        while self.peek() and re.match(r"[A-Za-z0-9_./:-]", self.peek()):
            self.i += 1
        raw = self.text[start : self.i]
        if raw == "true":
            return True
        if raw == "false":
            return False
        if raw == "nil":
            return None
        if raw:
            return raw
        raise ValueError(f"Cannot parse value at {self.i}")


def read_text(path):
    return path.read_text(encoding="utf-8", errors="replace")


def write_csv(path, rows, fieldnames):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def read_csv(path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def as_compact(value):
    return json.dumps(value, ensure_ascii=False, separators=(",", ":"))


def parse_dtmodel_schema():
    schema = {}
    text = read_text(DTMODEL_ENTITY)
    for name, index in re.findall(r"e\.([A-Za-z_][A-Za-z0-9_]*)=t\[(\d+)\]", text):
        schema[int(index)] = name
    return schema


def extract_hero_row(hero_id=1001):
    for line in read_text(DTMODEL_TABLE).splitlines():
        stripped = line.strip()
        if stripped.startswith("{" + str(hero_id) + ","):
            if stripped.endswith(","):
                stripped = stripped[:-1]
            return LuaTableParser(stripped).parse(), stripped
    raise FileNotFoundError(f"DTmodel row for hero {hero_id} was not found")


def selected_dtmodel_rows(schema, values):
    rows = []
    by_name = {}
    for index, value in enumerate(values, 1):
        name = schema.get(index, f"t[{index}]")
        by_name[name] = value
        if name in IMPORTANT_FIELDS:
            rows.append(
                {
                    "index": index,
                    "field": name,
                    "value": as_compact(value),
                }
            )
    return rows, by_name


def png_size(path):
    try:
        with path.open("rb") as f:
            header = f.read(24)
        if not header.startswith(b"\x89PNG\r\n\x1a\n"):
            return "", ""
        width, height = struct.unpack(">II", header[16:24])
        return width, height
    except Exception:
        return "", ""


def bundle_path_rows():
    wanted = {
        "download/roleprefabsandres/paintingprefabandres/1001.assetbundle",
        "download/roleprefabsandres/rolebigsetpainting/1001.assetbundle",
        "download/roleprefabsandres/battleprefabandres/1001.assetbundle",
        "download/commonprefabsandres/spinematandshaders.assetbundle",
    }
    export_map = {
        row.get("bundle", ""): row.get("export_dir", "")
        for row in read_csv(EXPORT_MAP_CSV)
    }
    rows = []
    for row in read_csv(ASSETBUNDLES_CSV):
        bundle = row.get("bundle", "") or row.get("assetbundle", "")
        if bundle in wanted:
            rows.append(
                {
                    "bundle": bundle,
                    "size": row.get("size", ""),
                    "status": row.get("status", ""),
                    "object_count": row.get("object_count", ""),
                    "type_counts": row.get("type_counts", ""),
                    "export_folder": export_map.get(bundle, ""),
                }
            )
    return rows


def list_bundle_assets(bundle_name, folder):
    rows = []
    for path in sorted(folder.rglob("*")):
        if not path.is_file() or path.name in {"structure.jsonl.gz", "type_counts.json"}:
            continue
        rel = path.relative_to(folder).as_posix()
        width, height = png_size(path) if path.suffix.lower() == ".png" else ("", "")
        rows.append(
            {
                "bundle_role": bundle_name,
                "relative_path": rel,
                "file_name": path.name,
                "bytes": path.stat().st_size,
                "png_width": width,
                "png_height": height,
                "use_for_maininterface": classify_asset(bundle_name, path.name),
            }
        )
    return rows


def classify_asset(bundle_name, file_name):
    lower = file_name.lower()
    if bundle_name == "paintingprefabandres/1001":
        if "paintingbg_1001" in lower:
            return "runtime UI_bg background"
        if "painting_1001" in lower and (lower.endswith(".atlas.txt") or lower.endswith(".skel.txt")):
            return "runtime UI_heroSpine skeleton source"
        if "painting_1001" in lower and lower.endswith(".png"):
            return "spine atlas page; do not use as whole image"
        if "sp_heroname_1001" in lower:
            return "spine hero name source"
    if bundle_name == "rolebigsetpainting/1001":
        return "static reference or non-home fallback; not UI_heroSpine runtime"
    if bundle_name == "battleprefabandres/1001":
        return "battle skeleton; not MainInterface home default"
    return "reference"


def parse_atlas(path):
    text = read_text(path)
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    pages = []
    regions = []
    for line in lines:
        if line.endswith(".png"):
            pages.append(line)
            continue
        if ":" not in line:
            regions.append(line)
    return {
        "atlas_file": path.name,
        "page": ";".join(pages),
        "region_count": len(regions),
        "first_regions": ", ".join(regions[:12]),
    }


def analyze_structure(folder):
    path = folder / "structure.jsonl.gz"
    if not path.exists():
        return [], {}
    declared_type_counts = {}
    type_counts_path = folder / "type_counts.json"
    if type_counts_path.exists():
        declared_type_counts = json.loads(type_counts_path.read_text(encoding="utf-8"))
    game_objects = {}
    rects = {}
    type_counts = {}
    skeleton_behaviours = []
    monobehaviour_script_counts = {}

    with gzip.open(path, "rt", encoding="utf-8", errors="replace") as f:
        for line in f:
            if not line.strip():
                continue
            obj = json.loads(line)
            path_id = obj.get("path_id")
            typ = obj.get("type")
            tree = obj.get("tree", {})
            type_counts[typ] = type_counts.get(typ, 0) + 1
            if typ == "GameObject":
                game_objects[path_id] = {
                    "name": tree.get("m_Name", ""),
                    "active": tree.get("m_IsActive", ""),
                }
            elif typ == "RectTransform":
                father = tree.get("m_Father", {}).get("m_PathID", 0)
                go = tree.get("m_GameObject", {}).get("m_PathID", 0)
                rects[path_id] = {
                    "game_object": go,
                    "father": father,
                    "anchor_min_x": tree.get("m_AnchorMin", {}).get("x", ""),
                    "anchor_min_y": tree.get("m_AnchorMin", {}).get("y", ""),
                    "anchor_max_x": tree.get("m_AnchorMax", {}).get("x", ""),
                    "anchor_max_y": tree.get("m_AnchorMax", {}).get("y", ""),
                    "pos_x": tree.get("m_AnchoredPosition", {}).get("x", ""),
                    "pos_y": tree.get("m_AnchoredPosition", {}).get("y", ""),
                    "size_x": tree.get("m_SizeDelta", {}).get("x", ""),
                    "size_y": tree.get("m_SizeDelta", {}).get("y", ""),
                    "scale_x": tree.get("m_LocalScale", {}).get("x", ""),
                    "scale_y": tree.get("m_LocalScale", {}).get("y", ""),
                }
            elif typ == "MonoBehaviour":
                script = tree.get("m_Script", {}).get("m_PathID", "")
                monobehaviour_script_counts[str(script)] = monobehaviour_script_counts.get(str(script), 0) + 1
                if "skeletonDataAsset" in tree or "startingAnimation" in tree:
                    go = tree.get("m_GameObject", {}).get("m_PathID", 0)
                    skeleton_behaviours.append(
                        {
                            "game_object_id": go,
                            "game_object_name": "",
                            "script_id": script,
                            "starting_animation": tree.get("startingAnimation", ""),
                            "starting_loop": tree.get("startingLoop", ""),
                            "skeleton_data_asset": as_compact(tree.get("skeletonDataAsset", {})),
                        }
                    )

    child_count = {}
    for rect in rects.values():
        child_count[rect["father"]] = child_count.get(rect["father"], 0) + 1

    rows = []
    for rect_id, rect in rects.items():
        if rect["father"] in (0, None):
            go = game_objects.get(rect["game_object"], {})
            rows.append(
                {
                    "rect_id": rect_id,
                    "game_object_id": rect["game_object"],
                    "game_object_name": go.get("name", ""),
                    "active": go.get("active", ""),
                    "child_count": child_count.get(rect_id, 0),
                    "anchor_min_x": rect["anchor_min_x"],
                    "anchor_min_y": rect["anchor_min_y"],
                    "anchor_max_x": rect["anchor_max_x"],
                    "anchor_max_y": rect["anchor_max_y"],
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

    summary = {
        "type_counts": declared_type_counts or type_counts,
        "structure_jsonl_type_counts": type_counts,
        "root_count": len(rows),
        "skeleton_behaviour_count": len(skeleton_behaviours),
        "skeleton_behaviours_sample": skeleton_behaviours[:12],
        "monobehaviour_script_counts": monobehaviour_script_counts,
    }
    return rows, summary


def normalized_name(path):
    name = path.name
    if "_" in name:
        return name.split("_", 1)[1]
    return name


def export_source_assets():
    if SOURCE_EXPORT_DIR.exists():
        shutil.rmtree(SOURCE_EXPORT_DIR)
    SOURCE_EXPORT_DIR.mkdir(parents=True, exist_ok=True)

    rows = []
    export_sets = [
        ("paintingprefabandres_1001", PAINTING_BUNDLE),
        ("rolebigsetpainting_1001_reference", ROLEBIG_BUNDLE),
        ("battleprefabandres_1001_reference", BATTLE_BUNDLE),
    ]
    for label, folder in export_sets:
        dest_dir = SOURCE_EXPORT_DIR / label
        dest_dir.mkdir(parents=True, exist_ok=True)
        for src in sorted(folder.rglob("*")):
            if not src.is_file() or src.name in {"structure.jsonl.gz", "type_counts.json"}:
                continue
            if src.suffix.lower() == ".png" or src.name.endswith(".atlas.txt") or src.name.endswith(".skel.txt"):
                dest_name = normalized_name(src)
                if dest_name.endswith(".skel.txt"):
                    dest_name = dest_name[: -len(".skel.txt")] + ".skel.bytes"
                dest = dest_dir / dest_name
                shutil.copy2(src, dest)
                rows.append(
                    {
                        "source_bundle": label,
                        "source_path": str(src),
                        "export_path": str(dest),
                        "bytes": dest.stat().st_size,
                        "note": classify_asset(label.replace("_", "/").replace("/reference", ""), src.name),
                    }
                )

    readme = SOURCE_EXPORT_DIR / "README.md"
    readme.write_text(
        "\n".join(
            [
                "# Hero 1001 Spine Source Export",
                "",
                "These files are extracted source assets for MainInterface hero restoration.",
                "Do not place `Painting_1001.png` directly as a UI Image. It is a Spine atlas page.",
                "Use the `.atlas.txt`, `.skel.bytes`, and matching PNG pages with a real spine-unity runtime.",
                "",
                "Primary home source:",
                "`paintingprefabandres_1001/Painting_1001.atlas.txt` + `Painting_1001.skel.bytes` + `Painting_1001.png`",
                "",
                "Runtime background:",
                "`paintingprefabandres_1001/noalphabg_PaintingBG_1001.png`",
            ]
        ),
        encoding="utf-8",
    )
    return rows


def lua_evidence():
    lines = read_text(LUA_MAIN).splitlines() if LUA_MAIN.exists() else []
    evidence = []
    wanted = {
        1504: "underwear branch loader",
        1543: "default home BigSpine loader",
        1546: "homePara parameter",
        1558: "UI_touchSpine active for default branch",
        1559: "painting background lookup",
        1560: "UI_bg LoadSpriteWithFullPath",
        1640: "marry/self marry Live2D branch loader",
    }
    for line_no, note in wanted.items():
        if 1 <= line_no <= len(lines):
            evidence.append({"line": line_no, "note": note, "text": lines[line_no - 1].strip()})
    return evidence


def detect_unity_runtime():
    assets = UNITY / "Assets"
    if not assets.exists():
        return {
            "spine_runtime_present_in_restore_project": False,
            "matching_files": [],
            "dummy_dlls": [],
        }
    names = []
    for path in assets.rglob("*"):
        if not path.is_file():
            continue
        lower = path.name.lower()
        if lower in {"skeletongraphic.cs", "spine-unity.dll", "spine-csharp.dll"} or "spine" in lower:
            names.append(str(path))
    dummy_dlls = [
        str(p)
        for p in (
            MERGED / "extracted" / "il2cpp_dump" / "DummyDll"
        ).glob("spine*.dll")
    ]
    has_runtime = any(
        path.lower().endswith(("skeletongraphic.cs", "spine-unity.dll", "spine-csharp.dll"))
        for path in names
    )
    return {
        "spine_runtime_present_in_restore_project": has_runtime,
        "matching_files": names[:40],
        "matching_file_count": len(names),
        "dummy_dlls": dummy_dlls,
        "dummy_dll_note": "Il2CppDumper DummyDll files are metadata stubs, not a reliable restore runtime.",
    }


def make_markdown(summary, dt_fields, bundle_rows, runtime):
    field_lookup = {row["field"]: row["value"] for row in dt_fields}
    bundle_lines = []
    for row in bundle_rows:
        bundle_lines.append(
            f"| `{row['bundle']}` | `{row.get('status','')}` | `{row.get('size','')}` | `{row.get('export_folder','')}` |"
        )

    runtime_state = (
        "있음"
        if runtime.get("spine_runtime_present_in_restore_project")
        else "없음 - 현재 복원 프로젝트에는 실제 spine-unity 런타임이 없다"
    )
    structure = summary.get("paintingprefabandres_structure", {})
    type_counts = structure.get("type_counts", {})
    skeleton_samples = structure.get("skeleton_behaviours_sample", [])
    skeleton_lines = []
    for item in skeleton_samples[:8]:
        skeleton_lines.append(
            f"| `{item.get('game_object_name','')}` | `{item.get('starting_animation','')}` | `{item.get('starting_loop','')}` | `{item.get('skeleton_data_asset','')}` |"
        )
    atlas_lines = []
    for row in summary.get("atlas_rows", []):
        atlas_lines.append(
            f"| `{row.get('atlas_file','')}` | `{row.get('page','')}` | {row.get('region_count','')} | `{row.get('first_regions','')}` |"
        )

    return f"""# MainInterface Hero Spine Restore Plan

작성 시각: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} KST

## 결론

현재 MainInterface가 형태를 제대로 못 맞춘 가장 큰 시각 원인은 `UI_heroSpine`가 비어 있기 때문이다. 기본 홈 분기에서는 atlas PNG를 Image로 붙이는 구조가 아니라, `UI_MainPage` Lua가 `UIUtil.GetPlayerBigSpineAll(heroDid, UI_heroSpine, "homePara", ...)`로 1001번 Spine prefab/skeleton을 런타임에 붙인다.

따라서 `Painting_1001.png`를 통째로 화면에 올리면 실패다. 이 파일은 여러 파츠가 들어간 Spine atlas page이고, 실제 복원은 `.atlas`, `.skel`, texture page, `SkeletonGraphic`/Spine runtime, `DTmodelEntity.homePara` 적용 순서로 해야 한다.

## 런타임 근거

| 근거 | 값 |
|---|---|
| 기본 캐릭터 로더 | `UIUtil.GetPlayerBigSpineAll(i, UI_heroSpine, "homePara", ...)` |
| 기본 배경 로더 | `UIUtil.GetPaintingBg(i)` 후 `GameTools:LoadSpriteWithFullPath(UI_bg, e, true)` |
| 결혼/특수 분기 | `UIUtil.GetPlayerLive2dModel(a, UI_heroSpine, ...)` |
| 1001 `homePara` | `{field_lookup.get('homePara', '')}` |
| 1001 `paintingBg` | `{field_lookup.get('paintingBg', '')}` |
| 1001 `bigPainting` | `{field_lookup.get('bigPainting', '')}` |
| 1001 `starHeroName` | `{field_lookup.get('starHeroName', '')}` |
| 복원 프로젝트 Spine runtime | {runtime_state} |

## `paintingprefabandres/1001` prefab 구조

| 항목 | 값 |
|---|---:|
| GameObject | {type_counts.get('GameObject', 0)} |
| RectTransform | {type_counts.get('RectTransform', 0)} |
| CanvasRenderer | {type_counts.get('CanvasRenderer', 0)} |
| MonoBehaviour | {type_counts.get('MonoBehaviour', 0)} |
| SkeletonGraphic-like Behaviour | {structure.get('skeleton_behaviour_count', 0)} |
| Root RectTransform | {structure.get('root_count', 0)} |

| GameObject | start animation | loop | skeletonDataAsset |
|---|---:|---:|---|
{chr(10).join(skeleton_lines)}

## Atlas page 구조

| atlas | page | region count | first regions |
|---|---|---:|---|
{chr(10).join(atlas_lines)}

## 1001 관련 AssetBundle

| bundle | status | size | extracted folder |
|---|---:|---:|---|
{chr(10).join(bundle_lines)}

`paintingprefabandres/1001`이 기본 MainInterface 캐릭터 렌더링의 1순위 소스다. `rolebigsetpainting/1001`은 정적 큰 그림/도감/랭킹 등 참고용이고, `battleprefabandres/1001`은 전투 skeleton이라 홈 기본 화면에 먼저 붙이면 안 된다.

## 추출된 핵심 파일

| 역할 | 파일 |
|---|---|
| 홈 캐릭터 skeleton | `Assets/RestoreData/hero1001_spine_source/paintingprefabandres_1001/Painting_1001.skel.bytes` |
| 홈 캐릭터 atlas | `Assets/RestoreData/hero1001_spine_source/paintingprefabandres_1001/Painting_1001.atlas.txt` |
| 홈 캐릭터 atlas page | `Assets/RestoreData/hero1001_spine_source/paintingprefabandres_1001/Painting_1001.png` |
| 전면 보조 skeleton | `Assets/RestoreData/hero1001_spine_source/paintingprefabandres_1001/Painting_1001_Front.skel.bytes` |
| 후면 보조 skeleton | `Assets/RestoreData/hero1001_spine_source/paintingprefabandres_1001/Painting_1001_Back.skel.bytes` |
| 런타임 배경 | `Assets/RestoreData/hero1001_spine_source/paintingprefabandres_1001/noalphabg_PaintingBG_1001.png` |

## 정확한 복원 순서

1. 복원 Unity 프로젝트에 실제 `spine-unity` 런타임을 넣는다. `extracted/il2cpp_dump/DummyDll/spine-unity.dll`은 타입 추정용 stub라 최종 런타임으로 믿으면 안 된다.
2. `hero1001_spine_source/paintingprefabandres_1001`의 `.atlas.txt`, `.skel.bytes`, PNG page를 Unity Spine asset으로 묶는다.
3. `UI_MainInterface/middle/UI_heroSpine` 아래에 `Painting_1001`용 `SkeletonGraphic` 또는 원본 prefab 인스턴스를 붙인다.
4. `DTmodelEntity.homePara={field_lookup.get('homePara', '')}`를 scale/x/y 기준으로 적용한다. 1001은 현재 `{field_lookup.get('homePara', '')}`이므로 임의 확대/이동을 하지 않는다.
5. `UI_bg`는 `paintingBg={field_lookup.get('paintingBg', '')}`에 해당하는 `noalphabg_PaintingBG_1001.png`를 유지한다.
6. `UI_touchSpine`는 터치/드래그 hit area로만 복원하고, 투명 Image가 전체 버튼 raycast를 막지 않게 한다.
7. 그래픽 모드로 `1680x720` 캡처를 다시 찍고, public 원본 홈 레퍼런스처럼 캐릭터 중심 구도가 보이는지 눈으로 확인한다.

## 실패로 간주할 조건

- `Painting_1001.png` atlas page를 통째 UI Image로 붙인 경우.
- 캐릭터 없이 배경과 버튼만 보이는데 클릭 검증만 통과한 경우.
- `UI_heroSpine`/`UI_touchSpine`의 투명 Graphic이 배경 버튼을 막는 경우.
- `homePara`/원본 prefab 계층을 무시하고 수동 좌표로만 맞춘 경우.

## 생성된 분석 파일

- `Assets/RestoreData/reports/maininterface_hero1001_spine_summary.json`
- `Assets/RestoreData/reports/maininterface_hero1001_assets.csv`
- `Assets/RestoreData/reports/maininterface_hero1001_dtmodel_fields.csv`
- `Assets/RestoreData/reports/maininterface_hero1001_atlas_regions.csv`
- `Assets/RestoreData/reports/maininterface_hero1001_structure_roots.csv`
- `Assets/RestoreData/reports/maininterface_hero1001_spine_source_export.csv`
"""


def main():
    REPORTS.mkdir(parents=True, exist_ok=True)
    RESTORE_REPORTS.mkdir(parents=True, exist_ok=True)

    schema = parse_dtmodel_schema()
    values, raw_row = extract_hero_row(1001)
    dt_rows, fields = selected_dtmodel_rows(schema, values)

    bundle_rows = bundle_path_rows()
    asset_rows = []
    asset_rows.extend(list_bundle_assets("paintingprefabandres/1001", PAINTING_BUNDLE))
    asset_rows.extend(list_bundle_assets("rolebigsetpainting/1001", ROLEBIG_BUNDLE))
    asset_rows.extend(list_bundle_assets("battleprefabandres/1001", BATTLE_BUNDLE))

    atlas_rows = []
    for atlas in sorted(PAINTING_BUNDLE.rglob("*.atlas.txt")):
        atlas_rows.append(parse_atlas(atlas))
    for atlas in sorted(BATTLE_BUNDLE.rglob("*.atlas.txt")):
        atlas_rows.append(parse_atlas(atlas))

    structure_rows, structure_summary = analyze_structure(PAINTING_BUNDLE)
    export_rows = export_source_assets()
    runtime = detect_unity_runtime()

    write_csv(DTMODEL_CSV, dt_rows, ["index", "field", "value"])
    write_csv(
        ASSETS_CSV,
        asset_rows,
        [
            "bundle_role",
            "relative_path",
            "file_name",
            "bytes",
            "png_width",
            "png_height",
            "use_for_maininterface",
        ],
    )
    write_csv(ATLAS_CSV, atlas_rows, ["atlas_file", "page", "region_count", "first_regions"])
    write_csv(
        STRUCTURE_CSV,
        structure_rows,
        [
            "rect_id",
            "game_object_id",
            "game_object_name",
            "active",
            "child_count",
            "anchor_min_x",
            "anchor_min_y",
            "anchor_max_x",
            "anchor_max_y",
            "pos_x",
            "pos_y",
            "size_x",
            "size_y",
            "scale_x",
            "scale_y",
        ],
    )
    write_csv(
        EXPORT_MANIFEST_CSV,
        export_rows,
        ["source_bundle", "source_path", "export_path", "bytes", "note"],
    )

    summary = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S KST"),
        "hero_id": 1001,
        "dtmodel_raw_row_prefix": raw_row[:500],
        "dtmodel_selected": {row["field"]: row["value"] for row in dt_rows},
        "lua_evidence": lua_evidence(),
        "bundle_rows": bundle_rows,
        "asset_count": len(asset_rows),
        "atlas_rows": atlas_rows,
        "paintingprefabandres_structure": structure_summary,
        "source_export_dir": str(SOURCE_EXPORT_DIR),
        "source_export_count": len(export_rows),
        "runtime": runtime,
        "restore_decision": {
            "default_home_source": "download/roleprefabsandres/paintingprefabandres/1001.assetbundle",
            "do_not_use_whole_atlas_as_ui_image": True,
            "requires_real_spine_unity_runtime": not runtime.get(
                "spine_runtime_present_in_restore_project", False
            ),
            "home_parameter": fields.get("homePara"),
            "background_sprite_name": fields.get("paintingBg"),
        },
    }
    SUMMARY_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    MARKDOWN.write_text(make_markdown(summary, dt_rows, bundle_rows, runtime), encoding="utf-8")

    print("[GirlsWarRestore] Hero 1001 Spine analysis complete")
    print(f"[GirlsWarRestore] Markdown: {MARKDOWN}")
    print(f"[GirlsWarRestore] Summary: {SUMMARY_JSON}")
    print(f"[GirlsWarRestore] Source export: {SOURCE_EXPORT_DIR}")


if __name__ == "__main__":
    main()
