"""Static snapshot resolver (control tower) v2.

Fills `runtimeValue` in the B75 battle approval-packet field checklist using ONLY
original source-backed evidence from the extracted indexes:
- `girlswar_merged_extracted/indexes/ui_recttransforms.csv` (RectTransform geometry,
  father_id hierarchy)  -> lane 1 (rect_transform, sibling_order)
- `girlswar_merged_extracted/indexes/ui_texts.csv` (m_text / m_Text)  -> lane 2 (text)

Crosswalk (the key to disambiguation): each B75 objectPath is matched to an ORIGINAL
node by reconstructing every original node's full path via father_id chains, then taking
the LONGEST trailing path-suffix of the B75 path that uniquely matches an original
full-path suffix. This resolves reconstruction-specific parents (e.g. a hero-card
instance node) by anchoring on the preserved original ancestors
(root_battle/BottomCenter/.../imgMask).

Guardrail (matches reports/RESTORE_RULES_APPLIED_CURRENT.md):
- No coordinate-only guessing. Every filled value carries `staticSource` provenance
  pointing at the original index row (bundle + path_id + suffix match) it came from.
- A value is filled ONLY on a confident match: a unique suffix match, or, when several
  original nodes share the suffix, only if their geometry is identical. Otherwise null.
- Never copies the candidate scene's own `sourceValue` into `runtimeValue` (circular).
- Only source-backed categories are touched (rect_transform, sibling_order, and `text`
  from tmp). Font metrics / mask / component / active / handler stay null as the true
  residual (those need lane 3 component index + lane 4 form-Lua decode).

Output:
- BATTLE_84_ORIGINAL_RUNTIME_SNAPSHOT_FILLED.json   (the filled snapshot B84 consumes)
- BATTLE_85_STATIC_SNAPSHOT_RESOLVER_PROVENANCE.csv
- prints before/after missing counts.

Run:
  python _restore_tools/scripts/control_tower_static_snapshot_resolver.py
"""
from __future__ import annotations

import csv
import json
from collections import defaultdict
from pathlib import Path

ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
CSV_PATH = ROOT / "girlswar_merged_extracted" / "indexes" / "ui_recttransforms.csv"
TEXTS_PATH = ROOT / "girlswar_merged_extracted" / "indexes" / "ui_texts.csv"
B75 = (
    ROOT / "reports" / "battle"
    / ("BATTLE_75_ORIGINAL_RUNTIME_SNAPSHOT_APPROVAL_PACKET_FOR_UI_NORMALBATTLE_"
       "ROUTE_TMP_MASK_HANDLER_AFTER_B74_NO_EXECUTION_NO_PATCH_APPROVAL_PACKET_TEMPLATE.json")
)
OUT_FILLED = ROOT / "girlswar_battle_unity" / "Assets" / "RestoreData" / "battle" / "BATTLE_84_ORIGINAL_RUNTIME_SNAPSHOT_FILLED.json"
OUT_PROV = ROOT / "reports" / "battle" / "BATTLE_85_STATIC_SNAPSHOT_RESOLVER_PROVENANCE.csv"

# fieldName -> the CSV columns that define it (and how to assemble the value)
GEOMETRY_FIELDS = {
    "anchorMin": ("anchor_min_x", "anchor_min_y"),
    "anchorMax": ("anchor_max_x", "anchor_max_y"),
    "anchoredPosition": ("anchored_pos_x", "anchored_pos_y"),
    "sizeDelta": ("size_delta_x", "size_delta_y"),
    "pivot": ("pivot_x", "pivot_y"),
    "localScale": ("local_scale_x", "local_scale_y", "local_scale_z"),
}
# Categories we fill, and which fieldNames within them.
GEOMETRY_CATEGORY = "rect_transform"
SIBLING_CATEGORY = "sibling_order"
TEXT_CATEGORY = "tmp_autosize_font_material"
SUFFIX_MAX = 4  # longest path-suffix length used for crosswalk


def fmt_num(s: str) -> str:
    """Normalize a CSV numeric string for a stable, compact value."""
    try:
        f = float(s)
        if f == int(f):
            return str(int(f))
        return repr(round(f, 6))
    except (TypeError, ValueError):
        return s


def load_csv():
    """Return by_pathid, and suffix_idx (path-suffix -> list of rows)."""
    by_pathid: dict[str, dict] = {}
    rows_all: list[dict] = []
    with CSV_PATH.open("r", encoding="utf-8-sig", newline="") as f:
        for row in csv.DictReader(f):
            by_pathid[row.get("path_id", "")] = row
            rows_all.append(row)

    def fullpath(r: dict) -> list[str]:
        segs = [r.get("game_object_name", "")]
        seen = {r.get("path_id")}
        cur = r
        for _ in range(64):
            fid = cur.get("father_id", "")
            if not fid or fid == "0" or fid in seen:
                break
            f = by_pathid.get(fid)
            if not f:
                break
            segs.append(f.get("game_object_name", ""))
            seen.add(fid)
            cur = f
        return list(reversed(segs))

    suffix_idx: dict[str, list[dict]] = defaultdict(list)
    for r in rows_all:
        fp = fullpath(r)
        for L in range(1, SUFFIX_MAX + 1):
            if len(fp) >= L:
                suffix_idx["/".join(fp[-L:])].append(r)
    return by_pathid, suffix_idx


def load_texts():
    """game_object_id -> text value (m_text / m_Text)."""
    by_goid: dict[str, str] = {}
    with TEXTS_PATH.open("r", encoding="utf-8-sig", newline="") as f:
        for row in csv.DictReader(f):
            if row.get("field") in ("m_text", "m_Text"):
                goid = row.get("game_object_id", "")
                if goid and goid != "0" and goid not in by_goid:
                    by_goid[goid] = row.get("text", "")
    return by_goid


def geometry_signature(row: dict) -> tuple:
    cols = ("anchor_min_x", "anchor_min_y", "anchor_max_x", "anchor_max_y",
            "anchored_pos_x", "anchored_pos_y", "size_delta_x", "size_delta_y",
            "pivot_x", "pivot_y", "local_scale_x", "local_scale_y", "local_scale_z")
    return tuple(fmt_num(row.get(c, "")) for c in cols)


def resolve_node(parts: list[str], suffix_idx: dict) -> tuple[dict | None, str]:
    """Crosswalk a B75 objectPath (split into segments) to one original node via the
    longest uniquely-matching path-suffix. Returns (row, reason) or (None, reason)."""
    for L in range(SUFFIX_MAX, 0, -1):
        if len(parts) < L:
            continue
        suf = "/".join(parts[-L:])
        cand = suffix_idx.get(suf, [])
        if len(cand) == 1:
            return cand[0], "unique_suffix_%d" % L
        if len(cand) > 1:
            sigs = {geometry_signature(r) for r in cand}
            if len(sigs) == 1:
                return cand[0], "identical_geom_suffix_%d_n%d" % (L, len(cand))
    return None, "ambiguous_or_absent"


def sibling_index_from_csv(row: dict, by_pathid: dict) -> str | None:
    """Sibling index = position of this node's path_id within its father's child_ids."""
    father_id = row.get("father_id", "")
    if not father_id or father_id == "0":
        return None
    father = by_pathid.get(father_id)
    if not father:
        return None
    children = [c for c in father.get("child_ids", "").split(";") if c]
    pid = row.get("path_id", "")
    if pid in children:
        return str(children.index(pid))
    return None


def main() -> int:
    by_pathid, suffix_idx = load_csv()
    texts_by_goid = load_texts()
    packet = json.loads(B75.read_text(encoding="utf-8-sig"))
    fields = packet.get("fieldChecklist", [])

    before_missing = sum(1 for r in fields if r.get("runtimeValue") is None)
    filled = 0
    prov_rows = []

    # cache node resolution per objectPath
    resolve_cache: dict[str, tuple[dict | None, str]] = {}

    for row in fields:
        if row.get("runtimeValue") is not None:
            continue
        category = row.get("category")
        field_name = row.get("fieldName")
        object_path = row.get("objectPath", "")

        # only categories/fields with a real static source
        # NOTE: lane 2 (TEXT_CATEGORY "text") is intentionally NOT filled. ui_texts.csv
        # m_text mixes effect/material param strings (EPM_*, riyu_*) with display text and
        # has CJK encoding corruption, so it cannot be used without violating the
        # no-fake/no-garbage guardrail. Display text needs the lane-3 component extraction
        # (real TMP component on the node) instead.
        want = (
            (category == GEOMETRY_CATEGORY and field_name in GEOMETRY_FIELDS)
            or (category == SIBLING_CATEGORY and field_name == "siblingIndex")
        )
        if not want:
            continue

        if object_path not in resolve_cache:
            resolve_cache[object_path] = resolve_node(object_path.split("/"), suffix_idx)
        node, reason = resolve_cache[object_path]
        if node is None:
            continue

        value = None
        source_index = "ui_recttransforms.csv"
        if field_name in GEOMETRY_FIELDS:
            cols = GEOMETRY_FIELDS[field_name]
            value = ",".join(fmt_num(node.get(c, "")) for c in cols)
        elif field_name == "siblingIndex":
            value = sibling_index_from_csv(node, by_pathid)
        elif field_name == "text":
            goid = node.get("game_object_id", "")
            if goid in texts_by_goid:
                value = texts_by_goid[goid]
                source_index = "ui_texts.csv"

        if value is None:
            continue

        row["runtimeValue"] = value
        row["staticSource"] = {
            "from": source_index,
            "bundle": node.get("bundle"),
            "path_id": node.get("path_id"),
            "game_object_name": node.get("game_object_name"),
            "match": reason,
        }
        filled += 1
        prov_rows.append({
            "objectPath": object_path,
            "fieldName": field_name,
            "category": category,
            "runtimeValue": value,
            "sourceIndex": source_index,
            "sourceBundle": node.get("bundle"),
            "sourcePathId": node.get("path_id"),
            "match": reason,
        })

    after_missing = before_missing - filled

    OUT_FILLED.parent.mkdir(parents=True, exist_ok=True)
    OUT_FILLED.write_text(json.dumps(packet, ensure_ascii=False, indent=2), encoding="utf-8")

    OUT_PROV.parent.mkdir(parents=True, exist_ok=True)
    with OUT_PROV.open("w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=[
            "objectPath", "fieldName", "category", "runtimeValue",
            "sourceIndex", "sourceBundle", "sourcePathId", "match"])
        w.writeheader()
        w.writerows(prov_rows)

    print("total fieldChecklist rows :", len(fields))
    print("missing before            :", before_missing)
    print("source-backed filled      :", filled)
    print("missing after             :", after_missing)
    print("filled by category        :")
    cat_counts: dict[str, int] = defaultdict(int)
    for r in prov_rows:
        cat_counts[r["category"]] += 1
    for c, n in sorted(cat_counts.items()):
        print("   %-16s %d" % (c, n))
    print("filled snapshot           :", OUT_FILLED)
    print("provenance csv            :", OUT_PROV)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
