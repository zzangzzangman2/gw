import csv
import shutil
from pathlib import Path

import UnityPy


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = ROOT / "girlswar_maininterface_unity"
MERGED = ROOT / "girlswar_merged_extracted"
SRC_BUNDLES = ROOT / "girlswar_merged_extracted" / "extracted" / "unity" / "bundles"
CLEAN_BUNDLES = MERGED / "extracted" / "unity" / "clean_unityfs_slices"
OUT_ROOT = PROJECT / "Assets" / "RestoreData" / "uidock_spine_source_raw"
REPORT_DIR = ROOT / "reports" / "maininterface"
OUT_CSV = REPORT_DIR / "MAININTERFACE_144_source_backed_uidock_spine_source_export.csv"

SPECS = [
    ("sp_mainpage", "SP_Dock_1", "download/ui/uiprefabandres/maininterface_ext_1.assetbundle", "b_629f86ef6a4def50", -5297893166830738493, "4575077192156806730_SP_Dock_1.atlas.txt", "-402587200781072471_SP_Dock_1.png"),
    ("sp_camp", "SP_Dock_2", "download/ui/uiprefabandres/maininterface_ext_1.assetbundle", "b_629f86ef6a4def50", -965620130649004890, "-7577882141466136738_SP_Dock_2.atlas.txt", "-8829062302552757208_SP_Dock_2.png"),
    ("sp_bag", "SP_Dock_3", "download/ui/uiprefabandres/maininterface_ext_1.assetbundle", "b_629f86ef6a4def50", -9015391737978558464, "-744257193174325057_SP_Dock_3.atlas.txt", "-5575814075661461733_SP_Dock_3.png"),
    ("sp_expedition", "SP_Dock_4", "download/ui/uiprefabandres/maininterface_ext_1.assetbundle", "b_629f86ef6a4def50", 8879130499741459148, "7730467358930827345_SP_Dock_4.atlas.txt", "6758749610672273623_SP_Dock_4.png"),
    ("sp_adventureInterface", "SP_Dock_5", "download/ui/uiprefabandres/maininterface_ext_1.assetbundle", "b_629f86ef6a4def50", -1063526957802718890, "-5360108064235675155_SP_Dock_5.atlas.txt", "8188935393299346357_SP_Dock_5.png"),
    ("sp_guild", "SP_Dock_6", "download/ui/uiprefabandres/maininterface_ext_1.assetbundle", "b_629f86ef6a4def50", 228557136316383007, "1417681296484973874_SP_Dock_6.atlas.txt", "2320300384913654586_SP_Dock_6.png"),
    ("sp_maincity", "SP_Dock_7", "download/ui/uiprefabandres/maininterface_ext_1.assetbundle", "b_629f86ef6a4def50", -6868568269113120160, "2188869438949159726_SP_Dock_7.atlas.txt", "-1274836167816180811_SP_Dock_7.png"),
    ("spine_xiaoshou", "spine_xiaoshou", "download/ui/uiprefabandres/guide.assetbundle", "b_1c0cb99aac4e1472", 605372011338076756, "1261856857127291787_spine_xiaoshou.atlas.txt", "-9007552672746774543_spine_xiaoshou.png"),
]


def copy_one(src, dst):
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(src, dst)
    return dst.exists(), dst.stat().st_size if dst.exists() else 0


def textasset_payload_to_raw(payload):
    if payload is None:
        return b"", "empty", 0, 0
    if isinstance(payload, bytes):
        return payload, "bytes", 0, 0
    if isinstance(payload, bytearray):
        return bytes(payload), "bytearray", 0, 0
    if isinstance(payload, str):
        surrogate_count = sum(1 for ch in payload if 0xDC80 <= ord(ch) <= 0xDCFF)
        nonlatin_count = sum(1 for ch in payload if ord(ch) > 255 and not (0xDC80 <= ord(ch) <= 0xDCFF))
        return payload.encode("utf-8", "surrogateescape"), "str_surrogateescape_utf8", surrogate_count, nonlatin_count
    return str(payload).encode("utf-8", "surrogateescape"), f"fallback_{type(payload).__name__}", 0, 0


def export_raw_textasset(bundle_rel, path_id, dst):
    bundle_path = CLEAN_BUNDLES / bundle_rel
    if not bundle_path.exists():
        return False, 0, "missing_clean_bundle", "", 0, 0, str(bundle_path)
    env = UnityPy.load(bundle_path.read_bytes())
    for obj in env.objects:
        if obj.path_id != path_id:
            continue
        if obj.type.name != "TextAsset":
            return False, 0, "path_id_not_textasset", obj.type.name, 0, 0, str(bundle_path)
        data = obj.read()
        payload = getattr(data, "script", None)
        if payload is None:
            payload = getattr(data, "m_Script", None)
        raw, source_kind, surrogate_count, nonlatin_count = textasset_payload_to_raw(payload)
        dst.parent.mkdir(parents=True, exist_ok=True)
        dst.write_bytes(raw)
        return True, len(raw), source_kind, str(getattr(data, "m_Name", "") or getattr(data, "name", "")), surrogate_count, nonlatin_count, str(bundle_path)
    return False, 0, "path_id_not_found", "", 0, 0, str(bundle_path)


def main():
    rows = []
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    OUT_ROOT.mkdir(parents=True, exist_ok=True)
    for com_name, asset_name, bundle_rel, bundle_dir, skel_path_id, atlas_name, texture_name in SPECS:
        src_dir = SRC_BUNDLES / bundle_dir
        out_dir = OUT_ROOT / asset_name
        atlas_src = src_dir / "textassets" / atlas_name
        texture_src = src_dir / "images" / "T" / texture_name
        skel_dst = out_dir / f"{asset_name}.skel.bytes"
        atlas_dst = out_dir / f"{asset_name}.atlas.txt"
        texture_dst = out_dir / f"{asset_name}.png"
        ok, size, source_kind, textasset_name, surrogate_count, nonlatin_count, bundle_path = export_raw_textasset(bundle_rel, skel_path_id, skel_dst)
        rows.append({
            "comName": com_name,
            "assetName": asset_name,
            "role": "skeleton",
            "sourcePath": bundle_path,
            "exportPath": str(skel_dst),
            "status": "raw_textasset_exported" if ok else source_kind,
            "bytes": size,
            "sourceKind": source_kind,
            "pathId": skel_path_id,
            "textAssetName": textasset_name,
            "surrogateByteCount": surrogate_count,
            "nonLatinCodepointCount": nonlatin_count,
        })
        for role, src, dst in [
            ("atlas", atlas_src, atlas_dst),
            ("texture", texture_src, texture_dst),
        ]:
            if not src.exists():
                rows.append({
                    "comName": com_name,
                    "assetName": asset_name,
                    "role": role,
                    "sourcePath": str(src),
                    "exportPath": str(dst),
                    "status": "missing_source",
                    "bytes": 0,
                    "sourceKind": "",
                    "pathId": "",
                    "textAssetName": "",
                    "surrogateByteCount": "",
                    "nonLatinCodepointCount": "",
                })
                continue
            ok, size = copy_one(src, dst)
            rows.append({
                "comName": com_name,
                "assetName": asset_name,
                "role": role,
                "sourcePath": str(src),
                "exportPath": str(dst),
                "status": "copied" if ok else "copy_failed",
                "bytes": size,
                "sourceKind": "extracted_bundle_file_copy",
                "pathId": "",
                "textAssetName": "",
                "surrogateByteCount": "",
                "nonLatinCodepointCount": "",
            })
    with OUT_CSV.open("w", newline="", encoding="utf-8") as f:
        fieldnames = ["comName", "assetName", "role", "sourcePath", "exportPath", "status", "bytes", "sourceKind", "pathId", "textAssetName", "surrogateByteCount", "nonLatinCodepointCount"]
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        w.writerows(rows)
    missing = [r for r in rows if r["status"] not in ("copied", "raw_textasset_exported")]
    print(f"exported={len(rows) - len(missing)} missing={len(missing)} csv={OUT_CSV}")
    if missing:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
