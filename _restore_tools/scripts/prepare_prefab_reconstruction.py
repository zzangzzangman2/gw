from __future__ import annotations

import json
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"


def main() -> None:
    required = [
        UNITY_DATA / "BATTLE_ASSETBUNDLE_STREAMING_PROBE.json",
        UNITY_DATA / "BATTLE_ASSETBUNDLE_LOAD_MAP.json",
        UNITY_DATA / "BATTLE_ASSET_BACKED_PREVIEW_VISUALS.json",
    ]
    missing = [str(p) for p in required if not p.exists()]
    prep = {
        "status": "ready" if not missing else "missing_inputs",
        "missing": missing,
        "inputs": [str(p) for p in required],
        "outputs": {
            "manifest": str(UNITY_DATA / "BATTLE_RUNTIME_STREAMING_MANIFEST.json"),
            "hierarchyJson": str(UNITY_DATA / "BATTLE_PREFAB_HIERARCHY_DUMP.json"),
            "hierarchyCsv": str(UNITY_DATA / "BATTLE_PREFAB_HIERARCHY_DUMP.csv"),
            "scene": str(UNITY_DIR / "Assets" / "Scenes" / "BattleRuntimeStreamingReconstruction.unity"),
            "report": str(REPORT_DIR / "BATTLE_PREFAB_RECONSTRUCTION_RESULT.md"),
        },
    }
    out = UNITY_DATA / "BATTLE_11_PREFAB_RECONSTRUCTION_PREP.json"
    out.write_text(json.dumps(prep, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(prep, ensure_ascii=False, indent=2))
    if missing:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
