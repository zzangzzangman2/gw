import csv
import json
from pathlib import Path

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
CLEAN_ROOT = BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices"

BASE_MANIFEST = UNITY_DATA / "BATTLE_HUD_SPRITE_REGION_FONT_JOIN_UNITY_MANIFEST.json"
B22_CSV = UNITY_DATA / "BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_RUNTIME_LUA_BINDING_COMPONENTS.csv"
B22_JSON = UNITY_DATA / "BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_RUNTIME_LUA_BINDING.json"
OUT_MANIFEST = UNITY_DATA / "BATTLE_HUD_EXTERNAL_DEPENDENCY_LOAD_MANIFEST.json"


def bundle_path(bundle: str) -> Path:
    return CLEAN_ROOT / Path(bundle.replace("/", "\\"))


def add_bundle(target: dict, bundle: str, reason: str, refs: int = 1):
    bundle = (bundle or "").strip().replace("\\", "/")
    if not bundle:
        return
    item = target.setdefault(bundle, {
        "bundle": bundle,
        "absolutePath": str(bundle_path(bundle)),
        "exists": bundle_path(bundle).exists(),
        "reason": reason,
        "referenceCount": 0,
    })
    item["referenceCount"] += refs
    if reason and reason not in item["reason"]:
        item["reason"] = (item["reason"] + ";" + reason).strip(";")


def main():
    UNITY_DATA.mkdir(parents=True, exist_ok=True)
    base = json.loads(BASE_MANIFEST.read_text(encoding="utf-8")) if BASE_MANIFEST.exists() else {}
    deps = {}
    add_bundle(deps, "download/artsources/uispriteres/uicommonother.assetbundle", "explicit_battle22_high_priority_im_bg_left_right")

    external_columns = []
    priority_rows = []
    if B22_CSV.exists():
        with B22_CSV.open("r", encoding="utf-8-sig", newline="") as f:
            rows = list(csv.DictReader(f))
        if rows:
            external_columns = [c for c in rows[0].keys() if c.endswith("ExternalBundle")]
        for row in rows:
            reason = row.get("deepUnresolvedReason") or row.get("traceUnresolvedReason") or row.get("unresolvedReason") or "battle22_external_candidate"
            priority = any([
                row.get("visiblePlaceholderBlock", "").lower() == "true",
                row.get("visibleOnCamera", "").lower() == "true" and row.get("role") in {"Image", "RawImage"},
                reason in {"external_bundle_not_loaded", "resolved_external_candidate_not_loaded_runtime", "font_bundle_missing"},
            ])
            for col in external_columns:
                bundle = row.get(col, "")
                if bundle:
                    add_bundle(deps, bundle, f"{col}:{reason}")
                    if priority and len(priority_rows) < 80:
                        priority_rows.append({
                            "hierarchyPath": row.get("hierarchyPath", ""),
                            "role": row.get("role", ""),
                            "componentType": row.get("componentType", ""),
                            "externalColumn": col,
                            "externalBundle": bundle,
                            "reason": reason,
                            "originalSpritePPtr": row.get("originalSpritePPtr", ""),
                            "spriteAssetName": row.get("spriteAssetName", ""),
                        })

    dependency_bundles = sorted(deps.values(), key=lambda x: (not x["exists"], x["bundle"]))
    out = {
        "status": "battle23_external_dependency_load_manifest_ready",
        "sourceBaseManifest": str(BASE_MANIFEST),
        "sourceBattle22Csv": str(B22_CSV),
        "sourceBattle22Json": str(B22_JSON),
        "rules": {
            "noFakeHud": True,
            "noWholeAtlasImage": True,
            "preservePrefabHierarchy": True,
            "finalCaptureDebugPathPlaceholderTextFails": True,
            "clip05SequenceGateRequired": True,
        },
        "dependencyBundles": dependency_bundles,
        "dependencyBundleCount": len(dependency_bundles),
        "dependencyBundleExistsCount": sum(1 for item in dependency_bundles if item["exists"]),
        "attachments": base.get("attachments", []),
        "spriteBundles": base.get("spriteBundles", []),
        "priorityExternalRows": priority_rows,
    }
    OUT_MANIFEST.write_text(json.dumps(out, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"BATTLE23 manifest: {OUT_MANIFEST}")
    print(f"dependency bundles: {out['dependencyBundleExistsCount']}/{out['dependencyBundleCount']} exist")


if __name__ == "__main__":
    main()
