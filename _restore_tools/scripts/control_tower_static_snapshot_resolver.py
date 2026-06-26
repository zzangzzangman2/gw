"""Static snapshot resolver (control tower).

Fills `runtimeValue` in the B75 battle approval-packet field checklist using ONLY
original source-backed evidence: the extracted RectTransform index
`girlswar_merged_extracted/indexes/ui_recttransforms.csv`.

Guardrail (matches reports/RESTORE_RULES_APPLIED_CURRENT.md):
- No coordinate-only guessing. Every filled value carries `staticSource` provenance
  pointing at the original CSV row (bundle + path_id) it was derived from.
- A value is filled ONLY when the node's leaf name resolves to an UNAMBIGUOUS
  original geometry: either exactly one original node has that name, or all
  same-named original nodes share identical geometry. Otherwise it stays null.
- This resolver does NOT copy the candidate scene's own `sourceValue` into
  `runtimeValue` (that would be circular self-reference). It re-derives from the
  original extracted prefab index.
- Only geometry/serialized-invariant categories are touched (rect_transform,
  sibling_order). active/handler/tmp/mask/payload stay null as the true residual.

Output:
- <packet>_FILLED.json                 (the filled snapshot B84 consumes)
- <packet>_STATIC_RESOLVER_PROVENANCE.csv
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
# Categories we are willing to fill from the RectTransform index alone.
FILLABLE_CATEGORIES = {"rect_transform", "sibling_order"}

# Bundles whose nodes are legitimate sources for battle-HUD geometry. We prefer
# matches inside these; a leaf that only exists outside them is treated as
# ambiguous and left null.
def is_battle_bundle(bundle: str) -> bool:
    b = bundle.lower()
    return ("battle" in b) or ("ui/uiprefabandres" in b) or ("_ext_prefab" in b)


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
    """Return:
    by_name: name -> list of row dicts
    by_pathid: path_id -> row dict
    """
    by_name: dict[str, list[dict]] = defaultdict(list)
    by_pathid: dict[str, dict] = {}
    with CSV_PATH.open("r", encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            name = row.get("game_object_name", "")
            by_name[name].append(row)
            by_pathid[row.get("path_id", "")] = row
    return by_name, by_pathid


def geometry_signature(row: dict) -> tuple:
    cols = ("anchor_min_x", "anchor_min_y", "anchor_max_x", "anchor_max_y",
            "anchored_pos_x", "anchored_pos_y", "size_delta_x", "size_delta_y",
            "pivot_x", "pivot_y", "local_scale_x", "local_scale_y", "local_scale_z")
    return tuple(fmt_num(row.get(c, "")) for c in cols)


def resolve_node(leaf: str, by_name: dict) -> tuple[dict | None, str]:
    """Return (chosen_row, reason). chosen_row is None when ambiguous/absent."""
    rows = by_name.get(leaf, [])
    if not rows:
        return None, "no_original_node_with_this_name"
    battle_rows = [r for r in rows if is_battle_bundle(r.get("bundle", ""))]
    pool = battle_rows if battle_rows else rows
    if len(pool) == 1:
        return pool[0], "unique_match"
    sigs = {geometry_signature(r) for r in pool}
    if len(sigs) == 1:
        return pool[0], "identical_geometry_across_%d_nodes" % len(pool)
    return None, "ambiguous_%d_distinct_geometries" % len(sigs)


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
    by_name, by_pathid = load_csv()
    packet = json.loads(B75.read_text(encoding="utf-8-sig"))
    fields = packet.get("fieldChecklist", [])

    before_missing = sum(1 for r in fields if r.get("runtimeValue") is None)
    filled = 0
    prov_rows = []

    # cache node resolution per leaf to keep it deterministic and fast
    resolve_cache: dict[str, tuple[dict | None, str]] = {}

    for row in fields:
        if row.get("runtimeValue") is not None:
            continue
        category = row.get("category")
        if category not in FILLABLE_CATEGORIES:
            continue
        field_name = row.get("fieldName")
        object_path = row.get("objectPath", "")
        leaf = object_path.rsplit("/", 1)[-1]

        if leaf not in resolve_cache:
            resolve_cache[leaf] = resolve_node(leaf, by_name)
        node, reason = resolve_cache[leaf]
        if node is None:
            continue

        value = None
        if field_name in GEOMETRY_FIELDS:
            cols = GEOMETRY_FIELDS[field_name]
            parts = [fmt_num(node.get(c, "")) for c in cols]
            value = ",".join(parts)
        elif field_name == "siblingIndex":
            value = sibling_index_from_csv(node, by_pathid)

        if value is None:
            continue

        row["runtimeValue"] = value
        row["staticSource"] = {
            "from": "ui_recttransforms.csv",
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
            "sourceBundle", "sourcePathId", "match"])
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
