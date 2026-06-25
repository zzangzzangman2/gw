from __future__ import annotations

import csv
import json
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
RESULT_JSON = UNITY_DATA / "BATTLE_ASSETBUNDLE_STREAMING_PROBE.json"
RESULT_CSV = UNITY_DATA / "BATTLE_ASSETBUNDLE_STREAMING_PROBE.csv"
SCENE = UNITY_DIR / "Assets" / "Scenes" / "BattleAssetBundleStreamingProbe.unity"
LOG = REPORT_DIR / "BATTLE_10_UNITY_ASSETBUNDLE_STREAMING.log"
REPORT_MD = REPORT_DIR / "BATTLE_ASSETBUNDLE_STREAMING_PROBE_RESULT.md"


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def main() -> None:
    data = json.loads(RESULT_JSON.read_text(encoding="utf-8-sig")) if RESULT_JSON.exists() else {"results": []}
    rows = read_csv(RESULT_CSV)
    log_text = LOG.read_text(encoding="utf-8", errors="replace") if LOG.exists() else ""
    unity_success = "BattleAssetBundleStreamingProbe generated." in log_text
    success = sum(1 for r in rows if str(r.get("loadSuccess", "")).lower() == "true")
    fail = sum(1 for r in rows if str(r.get("loadSuccess", "")).lower() != "true")
    inst = sum(1 for r in rows if str(r.get("instantiateSuccess", "")).lower() == "true")
    texture_fallback = sum(1 for r in rows if str(r.get("textureFallback", "")).lower() == "true")
    summary = {
        "unityBatchmodeSuccess": unity_success,
        "probeSuccess": success,
        "probeFail": fail,
        "prefabInstantiate": inst,
        "textureFallback": texture_fallback,
        "scenePath": str(SCENE),
        "sceneExists": SCENE.exists(),
        "sceneBytes": SCENE.stat().st_size if SCENE.exists() else 0,
        "resultJson": str(RESULT_JSON),
        "resultCsv": str(RESULT_CSV),
        "unityLog": str(LOG),
        "nextBattle11Recommendation": data.get("nextBattle11Recommendation", "Build extracted-prefab reconstruction for loaded bundles."),
    }
    data["verification"] = summary
    RESULT_JSON.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(summary, rows, data)
    print(json.dumps(summary, ensure_ascii=False, indent=2))


def write_report(summary: dict, rows: list[dict[str, str]], data: dict) -> None:
    lines = [
        "# Battle AssetBundle Streaming Probe Result",
        "",
        "## Outputs",
        f"- Scene: `{summary['scenePath']}`",
        f"- Result JSON: `{summary['resultJson']}`",
        f"- Result CSV: `{summary['resultCsv']}`",
        f"- Unity log: `{summary['unityLog']}`",
        f"- Unity batchmode success: `{summary['unityBatchmodeSuccess']}`",
        "",
        "## Summary",
        f"- Probe load success: `{summary['probeSuccess']}`",
        f"- Probe load fail: `{summary['probeFail']}`",
        f"- Prefab instantiate success: `{summary['prefabInstantiate']}`",
        f"- Texture fallback markers: `{summary['textureFallback']}`",
        "",
        "## Bundle Results",
        "| kind | id | bundle | file | load | asset count | GameObject | Texture2D | Sprite | Material | TextAsset | instantiate | fallback | reason |",
        "| --- | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |",
    ]
    for r in rows:
        lines.append(
            "| {kind} | {id} | {bundle} | {fileExists} | {loadSuccess} | {assetNameCount} | {gameObjectCount} | {texture2DCount} | {spriteCount} | {materialCount} | {textAssetCount} | {instantiateSuccess} | {textureFallback} | {failReason} |".format(
                **{k: str(v).replace("|", "/") for k, v in r.items()}
            )
        )
    lines.extend(
        [
            "",
            "## Classification",
            "- If Unity direct streaming fails later on another machine, keep the BATTLE_09 extracted texture fallback path.",
            "- Current fastest next step: `BATTLE_11_BUILD_EXTRACTED_PREFAB_RECONSTRUCTION`, because direct AssetBundle streaming loaded the bundles and exposed names/types; full Spine runtime import is still a larger compatibility task.",
            "",
            "## BATTLE_11 Recommendation",
            f"- {summary['nextBattle11Recommendation']}",
        ]
    )
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
