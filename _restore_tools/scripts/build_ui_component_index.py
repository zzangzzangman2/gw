"""Build a per-GameObject UI component index from the pre-exported typetrees.

Reads `structure.jsonl.gz` (full typetree per object) for every ui/uiprefabandres
bundle, joins GameObject -> its components -> sprite/material/mask/TMP fields, and
reconstructs each GameObject's full hierarchy path via the Transform m_Father chain.

Output: girlswar_merged_extracted/indexes/ui_components.csv  (one row per GameObject)

This is the lane-3 source the static snapshot resolver consumes. Read-only over the
extracted exports; does not parse raw bundles or touch original evidence.

Component classification is by typetree field-shape (robust, no cross-bundle MonoScript
resolution needed):
  m_Sprite          -> Image
  m_text/m_fontAsset -> TMP_Text
  m_OnClick         -> Button
  m_ShowMaskGraphic -> Mask
  m_Softness        -> RectMask2D
A component whose m_Script PPtr is null/0 is counted as a missing-script component.
"""
from __future__ import annotations

import csv
import gzip
import json
import sys
from pathlib import Path

ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = ROOT / "girlswar_merged_extracted"
EXPORT_MAP = MERGED / "indexes" / "unity_bundle_export_map.csv"
IMAGES_CSV = MERGED / "indexes" / "unity_images.csv"
OUT = MERGED / "indexes" / "ui_components.csv"

csv.field_size_limit(min(sys.maxsize, 2147483647))

BUNDLE_FILTER = "ui/uiprefabandres/"  # battle* and maininterface* live here


def ref(p):
    return p.get("m_PathID") if isinstance(p, dict) else None


def load_export_map():
    m = {}
    with EXPORT_MAP.open(encoding="utf-8-sig", newline="") as f:
        for r in csv.DictReader(f):
            m[r["bundle"]] = r["export_dir"]
    return m


def load_sprite_names():
    """global path_id -> sprite/image name (for cross-bundle m_Sprite refs)."""
    names = {}
    if IMAGES_CSV.exists():
        with IMAGES_CSV.open(encoding="utf-8-sig", newline="") as f:
            for r in csv.DictReader(f):
                pid = r.get("path_id")
                if pid and pid not in names:
                    names[pid] = r.get("name", "")
    return names


def classify(tree: dict) -> str:
    if "m_Sprite" in tree:
        return "Image"
    if "m_text" in tree or "m_fontAsset" in tree:
        return "TMP_Text"
    if "m_OnClick" in tree:
        return "Button"
    if "m_ShowMaskGraphic" in tree:
        return "Mask"
    if "m_Softness" in tree:
        return "RectMask2D"
    return ""


def main() -> int:
    emap = load_export_map()
    sprite_names = load_sprite_names()
    targets = [b for b in emap if BUNDLE_FILTER in b.lower()]

    rows = []
    bundles_done = 0
    for bundle in targets:
        sp = MERGED / emap[bundle] / "structure.jsonl.gz"
        if not sp.exists():
            continue
        objs = {}
        with gzip.open(sp, "rt", encoding="utf-8") as f:
            for line in f:
                o = json.loads(line)
                objs[o["path_id"]] = o
        bundles_done += 1

        # transform path_id -> (go_path_id, father_transform_path_id)
        tf_of_go = {}
        for pid, o in objs.items():
            if o.get("type") in ("Transform", "RectTransform"):
                go = ref(o.get("tree", {}).get("m_GameObject"))
                if go is not None:
                    tf_of_go[go] = o

        def full_path(go_pid: str) -> str:
            segs = []
            seen = set()
            cur = go_pid
            for _ in range(64):
                if cur is None or cur in seen:
                    break
                seen.add(cur)
                go = objs.get(cur)
                if not go:
                    break
                segs.append(go.get("tree", {}).get("m_Name", ""))
                tf = tf_of_go.get(cur)
                if not tf:
                    break
                father = ref(tf.get("tree", {}).get("m_Father"))
                if father is None:
                    break
                ftf = objs.get(father)
                if not ftf:
                    break
                cur = ref(ftf.get("tree", {}).get("m_GameObject"))
            return "/".join(reversed(segs))

        for pid, o in objs.items():
            if o.get("type") != "GameObject":
                continue
            tree = o.get("tree", {})
            name = tree.get("m_Name", "")
            comps = tree.get("m_Component", [])
            row = {
                "bundle": bundle,
                "go_path_id": pid,
                "go_name": name,
                "full_path": full_path(pid),
                "go_active": tree.get("m_IsActive"),
                "component_types": "",
                "missing_script_count": 0,
                "graphic_enabled": "",
                "raycast_target": "",
                "button_interactable": "",
                "image_sprite": "",
                "graphic_material": "",
                "has_mask": 0,
                "mask_type": "",
                "mask_enabled": "",
                "show_mask_graphic": "",
                "tmp_enabled": "",
                "tmp_text": "",
                "font_size": "",
                "font_size_min": "",
                "font_size_max": "",
                "enable_autosizing": "",
                "character_spacing": "",
                "font_asset": "",
                "tmp_material": "",
                "tmp_raycast_target": "",
                "tmp_color": "",
            }
            ctypes = []
            missing = 0
            for c in comps:
                cpid = ref(c.get("component", c))
                co = objs.get(cpid)
                if not co:
                    continue
                ct = co.get("tree", {})
                base_type = co.get("type")
                if base_type == "MonoBehaviour":
                    if ref(ct.get("m_Script")) in (None, 0):
                        missing += 1
                    kind = classify(ct) or "MonoBehaviour"
                else:
                    kind = base_type
                ctypes.append(kind)

                if kind == "Image":
                    row["graphic_enabled"] = ct.get("m_Enabled", "")
                    row["raycast_target"] = ct.get("m_RaycastTarget", "")
                    spid = ref(ct.get("m_Sprite"))
                    if spid not in (None, 0):
                        row["image_sprite"] = sprite_names.get(str(spid), str(spid))
                    mpid = ref(ct.get("m_Material"))
                    if mpid not in (None, 0):
                        row["graphic_material"] = str(mpid)
                elif kind == "Button":
                    row["button_interactable"] = ct.get("m_Interactable", "")
                elif kind == "Mask":
                    row["has_mask"] = 1
                    row["mask_type"] = "Mask"
                    row["mask_enabled"] = ct.get("m_Enabled", "")
                    row["show_mask_graphic"] = ct.get("m_ShowMaskGraphic", "")
                elif kind == "RectMask2D":
                    row["has_mask"] = 1
                    row["mask_type"] = "RectMask2D"
                    row["mask_enabled"] = ct.get("m_Enabled", "")
                elif kind == "TMP_Text":
                    row["tmp_enabled"] = ct.get("m_Enabled", "")
                    row["tmp_text"] = ct.get("m_text", "")
                    row["font_size"] = ct.get("m_fontSize", "")
                    row["font_size_min"] = ct.get("m_fontSizeMin", "")
                    row["font_size_max"] = ct.get("m_fontSizeMax", "")
                    row["enable_autosizing"] = ct.get("m_enableAutoSizing", "")
                    row["character_spacing"] = ct.get("m_characterSpacing", "")
                    fa = ref(ct.get("m_fontAsset"))
                    if fa not in (None, 0):
                        row["font_asset"] = str(fa)
                    mt = ref(ct.get("m_sharedMaterial"))
                    if mt not in (None, 0):
                        row["tmp_material"] = str(mt)
                    row["tmp_raycast_target"] = ct.get("m_RaycastTarget", "")
                    col = ct.get("m_fontColor") or ct.get("m_Color")
                    if col is not None:
                        row["tmp_color"] = json.dumps(col, ensure_ascii=False)
            row["component_types"] = ";".join(ctypes)
            row["missing_script_count"] = missing
            rows.append(row)

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = list(rows[0].keys()) if rows else ["bundle"]
    with OUT.open("w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        w.writerows(rows)

    print("bundles processed :", bundles_done, "of", len(targets), "matched")
    print("GameObject rows   :", len(rows))
    print("output            :", OUT)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
