from __future__ import annotations

import csv
import json
import re
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
EXTRACTED = BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices"
DECODED = BASE / "girlswar_merged_extracted" / "decoded" / "xlua_battle"

CANDIDATES_JSON = UNITY_DATA / "BATTLE_UI_HUD_CANDIDATES.json"
TARGETS_CSV = UNITY_DATA / "BATTLE_UI_HUD_BUNDLE_TARGETS.csv"
PREP_JSON = REPORT_DIR / "BATTLE_UI_HUD_CANDIDATES_PREP.json"

KEYWORDS = [
    "battleui",
    "battle_ui",
    "fightui",
    "fight_ui",
    "combat",
    "battlepanel",
    "fightpanel",
    "blood",
    "hp",
    "energy",
    "rage",
    "buff",
    "debuff",
    "damage",
    "hurt",
    "auto",
    "speed",
    "pause",
    "skip",
    "round",
    "wave",
    "result",
    "win",
    "lose",
    "settlement",
]

MANUAL_BUNDLES = [
    ("battle_hud_prefab", "download/ui/uiprefabandres/battle.assetbundle", "battle root HUD prefab candidate", 100),
    ("battle_hud_prefab_ext", "download/ui/uiprefabandres/battle_ext_prefabs.assetbundle", "battle ext prefab roots", 95),
    ("battle_hud_prefab_ext", "download/ui/uiprefabandres/battle_ext_1.assetbundle", "battle ext sprites/prefabs 1", 82),
    ("battle_hud_prefab_ext", "download/ui/uiprefabandres/battle_ext_2.assetbundle", "battle ext sprites/prefabs 2", 78),
    ("battle_hud_prefab_ext", "download/ui/uiprefabandres/battle_ext_3.assetbundle", "battle ext sprites/prefabs 3", 78),
    ("battle_hud_prefab_ext", "download/ui/uiprefabandres/battle_ext_4.assetbundle", "battle ext sprites/prefabs 4", 78),
    ("battle_result_prefab", "download/ui/uiprefabandres/winlose.assetbundle", "win/lose/result entry prefab", 94),
    ("battle_result_prefab_ext", "download/ui/uiprefabandres/winlose_ext_prefabs.assetbundle", "win/lose ext prefab roots", 90),
    ("battle_result_prefab_ext", "download/ui/uiprefabandres/winlose_ext_1.assetbundle", "win/lose ext sprites/prefabs 1", 76),
    ("battle_result_prefab_ext", "download/ui/uiprefabandres/winlose_ext_2.assetbundle", "win/lose ext sprites/prefabs 2", 76),
    ("battle_result_prefab_ext", "download/ui/uiprefabandres/winlose_ext_3.assetbundle", "win/lose ext sprites/prefabs 3", 76),
    ("battle_result_prefab_ext", "download/ui/uiprefabandres/winlose_ext_4.assetbundle", "win/lose ext sprites/prefabs 4", 76),
    ("battle_sprite_atlas", "download/artsources/uispriteres/uibattle.assetbundle", "battle HUD sprite regions", 88),
    ("buff_icon_atlas", "download/artsources/uispriteres/uibufficon.assetbundle", "buff/debuff icon sprite regions", 86),
    ("hurt_number_atlas", "download/artsources/uispriteres/uihurtnum.assetbundle", "damage/heal/critical floating number sprites", 86),
    ("actor_head_atlas", "download/artsources/uispriteres/uiheroheadbattle.assetbundle", "battle actor head/name/slot UI sprites", 82),
    ("mine_battle_ui", "download/artsources/uispriteres/uiminebattle.assetbundle", "alternate battle UI sprites", 65),
    ("auto_helper_ui", "download/artsources/uispriteres/autohelper.assetbundle", "auto helper UI sprite evidence", 55),
    ("battle_common_prefab", "download/commonprefabsandres/battle.assetbundle", "battle common prefab evidence", 60),
    ("battle_scene", "download/scenes/normalscene/gamescene_normalbattle.assetbundle", "normal battle scene UI/camera evidence", 70),
    ("battle_scene", "download/scenes/normalscene/gamescene_testbattle.assetbundle", "test battle scene UI/camera evidence", 55),
]


def norm(value: str) -> str:
    return value.replace("\\", "/").strip().lower()


def abs_bundle(bundle: str) -> Path:
    return EXTRACTED / norm(bundle)


def header(path: Path) -> str:
    if not path.exists():
        return ""
    return path.read_bytes()[:16].decode("ascii", errors="replace")


def csv_write(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            writer.writerow({field: row.get(field, "") for field in fields})


def scan_bundle_paths() -> list[tuple[str, str, str, int]]:
    found: dict[str, tuple[str, str, str, int]] = {}
    for item in MANUAL_BUNDLES:
        found[norm(item[1])] = item
    if EXTRACTED.exists():
        for path in EXTRACTED.rglob("*.assetbundle"):
            rel = norm(path.relative_to(EXTRACTED).as_posix())
            if rel in found:
                continue
            text = rel.lower()
            if any(k in text for k in KEYWORDS) and ("/ui/" in text or "/uispriteres/" in text or "/scenes/" in text or "/commonprefabsandres/" in text):
                priority = 45
                kind = "keyword_hud_candidate"
                if "/ui/uiprefabandres/" in text:
                    priority = 68
                    kind = "ui_prefab_keyword_candidate"
                elif "/artsources/uispriteres/" in text:
                    priority = 58
                    kind = "ui_sprite_keyword_candidate"
                found[rel] = (kind, rel, "keyword path match", priority)
    return sorted(found.values(), key=lambda x: (-x[3], x[1]))


def lua_evidence() -> list[dict[str, Any]]:
    patterns = [
        "OpenTestBattleUI",
        "mBattleUI3D",
        "IsHideBattleUIInStart",
        "IsAutoMode",
        "IsSkipBattle",
        "GameSpeed",
        "UI_Global",
        "Skill_BattleUI_Reset",
        "BattleInputMgr",
    ]
    results: list[dict[str, Any]] = []
    if not DECODED.exists():
        return results
    for path in DECODED.rglob("*.lua"):
        name = path.name.lower()
        if not any(k.lower().replace("_", "") in name.replace("_", "") for k in ["procedure", "battle", "input", "win", "lose", "result", "ui"]):
            continue
        try:
            lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
        except OSError:
            continue
        for index, line in enumerate(lines, 1):
            for pattern in patterns:
                if pattern in line:
                    results.append({"pattern": pattern, "path": str(path), "line": index, "snippet": line.strip()[:220]})
                    break
            if len(results) >= 48:
                return results
    return results


def hud_scope(kind: str, bundle: str) -> list[str]:
    b = bundle.lower()
    scopes: list[str] = []
    if "uiprefabandres/battle" in b:
        scopes += ["root canvas/camera/scaler", "HP/MP bars", "auto/speed/pause/skip", "wave/round/timer", "skill indicators"]
    if "winlose" in b:
        scopes += ["win/lose/result panel entry points", "settlement"]
    if "uibufficon" in b:
        scopes += ["shield/buff/debuff icons"]
    if "uihurtnum" in b:
        scopes += ["damage/heal/critical/floating text sprites"]
    if "uiheroheadbattle" in b:
        scopes += ["actor name/level/side/slot labels", "actor head icons"]
    if "uibattle.assetbundle" in b:
        scopes += ["battle HUD sprite slices", "buttons", "bars"]
    if "scene" in kind:
        scopes += ["battle camera", "sorting layer", "scene root"]
    return sorted(set(scopes)) or ["unknown HUD evidence"]


def main() -> None:
    candidates = []
    targets = []
    for idx, (kind, bundle, note, priority) in enumerate(scan_bundle_paths()):
        path = abs_bundle(bundle)
        exists = path.exists()
        row = {
            "id": f"hud_{idx:03d}",
            "kind": kind,
            "bundle": norm(bundle),
            "absolutePath": str(path),
            "exists": exists,
            "size": path.stat().st_size if exists else 0,
            "unityFsHeader": header(path),
            "priority": priority,
            "note": note,
            "hudScopes": hud_scope(kind, bundle),
            "restoreRule": "probe prefab hierarchy, RectTransform anchors/pivots/scale/sibling order, sprite regions; do not use whole atlas or fake controls",
        }
        candidates.append(row)
        targets.append(
            {
                "id": row["id"],
                "kind": row["kind"],
                "bundle": row["bundle"],
                "absolutePath": row["absolutePath"],
                "priority": row["priority"],
                "hudScopes": ";".join(row["hudScopes"]),
            }
        )
    payload = {
        "status": "prepared_battle_ui_hud_candidates",
        "rulesEvidence": r"C:\Users\godho\Downloads\apk_extracted_ui_restore_rules.txt",
        "keywordSet": KEYWORDS,
        "candidates": candidates,
        "luaEvidence": lua_evidence(),
        "targetsCsv": str(TARGETS_CSV),
        "requiredHudScope": [
            "battle root canvas / camera / canvas scaler / sorting layer",
            "HP/MP/energy/rage bars, shield/buff/debuff icons",
            "actor name/level/side/slot labels",
            "damage/heal/critical/floating text fonts/materials/positions",
            "skill button/timeline/cooldown/trigger indicators if present",
            "auto/speed/pause/setting/skip controls",
            "wave/round/timer/turn indicators",
            "win/lose/result panel entry points",
            "debug/log-only elements excluded from final overlay",
        ],
        "counts": {
            "candidateCount": len(candidates),
            "existingCandidates": sum(1 for c in candidates if c["exists"]),
            "unityFsCandidates": sum(1 for c in candidates if c["unityFsHeader"].startswith("UnityFS")),
            "luaEvidenceCount": len(lua_evidence()),
        },
    }
    CANDIDATES_JSON.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
    PREP_JSON.write_text(json.dumps(payload["counts"], ensure_ascii=False, indent=2), encoding="utf-8")
    csv_write(TARGETS_CSV, targets, ["id", "kind", "bundle", "absolutePath", "priority", "hudScopes"])
    print(json.dumps({"candidates": str(CANDIDATES_JSON), **payload["counts"]}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
