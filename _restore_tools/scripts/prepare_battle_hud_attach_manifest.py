from __future__ import annotations

import json
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"

PROBE_JSON = UNITY_DATA / "BATTLE_UI_HUD_BUNDLE_PROBE.json"
MANIFEST_JSON = UNITY_DATA / "BATTLE_FLOW_WITH_HUD_ATTACH_MANIFEST.json"

BASE_SCENE = "Assets/Scenes/BattleRuntimeFlowSkillEffectPlayableMarkers.unity"
OUTPUT_SCENE = "Assets/Scenes/BattleRuntimeFlowWithHudPrototype.unity"


PRIORITY_PREFABS = [
    {
        "prefab": "assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle.prefab",
        "role": "battle_root_hud",
        "attachMode": "active_evidence_root",
        "reason": "primary normal battle HUD root candidate",
    },
    {
        "prefab": "assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_battle3dui.prefab",
        "role": "battle_3d_overlay_hud",
        "attachMode": "active_evidence_root",
        "reason": "ProcedureNormalBattle references mBattleUI3D / battle UI 3D flow",
    },
    {
        "prefab": "assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_heroitem.prefab",
        "role": "actor_heroitem_template",
        "attachMode": "template_inactive",
        "reason": "actor HP/name/slot template candidate; inactive to avoid fake repeated HUD",
    },
    {
        "prefab": "assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/item_buff_left.prefab",
        "role": "buff_icon_left_template",
        "attachMode": "template_inactive",
        "reason": "buff/debuff icon template candidate",
    },
    {
        "prefab": "assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/item_buff_right.prefab",
        "role": "buff_icon_right_template",
        "attachMode": "template_inactive",
        "reason": "buff/debuff icon template candidate",
    },
    {
        "prefab": "assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_pause.prefab",
        "role": "pause_panel_entry",
        "attachMode": "entry_inactive",
        "reason": "pause/settings entry root; not final overlay",
    },
    {
        "prefab": "assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_normalbattle_skipview.prefab",
        "role": "skip_panel_entry",
        "attachMode": "entry_inactive",
        "reason": "skip entry root; not final overlay",
    },
    {
        "prefab": "assets/download/ui/uiprefabandres/battle_ext_prefabs/prefabs/ui_testbattle.prefab",
        "role": "test_battle_ui_entry",
        "attachMode": "entry_inactive",
        "reason": "OpenTestBattleUI evidence; kept inactive/non-final",
    },
    {
        "prefab": "assets/download/ui/uiprefabandres/winlose_ext_prefabs/victory_spine_base.prefab",
        "role": "winlose_entry_victory_spine_base",
        "attachMode": "entry_inactive",
        "reason": "win/lose result entry-point marker only",
    },
    {
        "prefab": "assets/download/ui/uiprefabandres/winlose_ext_prefabs/victory_spine_base2.prefab",
        "role": "winlose_entry_victory_spine_base2",
        "attachMode": "entry_inactive",
        "reason": "win/lose result entry-point marker only",
    },
]


def load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def prefab_index(probe: dict) -> dict[str, dict]:
    out: dict[str, dict] = {}
    for result in probe.get("results", []):
        if not result.get("loadSuccess"):
            continue
        sample = result.get("prefabRootSample", "")
        for prefab in [p for p in sample.split(";") if p.strip()]:
            out[prefab.lower()] = {
                "bundle": result.get("bundle", ""),
                "absolutePath": result.get("absolutePath", ""),
                "kind": result.get("kind", ""),
                "prefabAsset": prefab,
                "bundlePrefabRootCount": result.get("prefabRootCount", 0),
                "bundleRectTransformCount": result.get("rectTransformCount", 0),
                "bundleCanvasCount": result.get("canvasCount", 0),
                "bundleMissingScriptCount": result.get("missingScriptCount", 0),
            }
    return out


def main() -> None:
    UNITY_DATA.mkdir(parents=True, exist_ok=True)
    probe = load_json(PROBE_JSON)
    index = prefab_index(probe)
    attachments = []
    missing_priority = []

    for order, item in enumerate(PRIORITY_PREFABS, start=1):
        prefab = item["prefab"]
        hit = index.get(prefab.lower())
        if not hit:
            missing_priority.append({**item, "order": order, "missingReason": "prefab_not_found_in_probe_sample"})
            continue
        attachments.append(
            {
                "id": f"hud_attach_{order:02d}",
                "order": order,
                "role": item["role"],
                "attachMode": item["attachMode"],
                "reason": item["reason"],
                "bundle": hit["bundle"],
                "absolutePath": hit["absolutePath"],
                "prefabAsset": hit["prefabAsset"],
                "sourceKind": hit["kind"],
                "bundlePrefabRootCount": hit["bundlePrefabRootCount"],
                "bundleRectTransformCount": hit["bundleRectTransformCount"],
                "bundleCanvasCount": hit["bundleCanvasCount"],
                "bundleMissingScriptCount": hit["bundleMissingScriptCount"],
            }
        )

    manifest = {
        "status": "battle_flow_with_hud_attach_manifest_ready",
        "sourceProbe": str(PROBE_JSON),
        "baseScene": BASE_SCENE,
        "outputScene": OUTPUT_SCENE,
        "rulesEvidence": str(BASE.parent / "apk_extracted_ui_restore_rules.txt"),
        "policy": {
            "fakeHud": False,
            "wholeAtlasPlacement": False,
            "preservePrefabHierarchy": True,
            "preserveRectTransformAnchorPivotScaleSiblingOrder": True,
            "debugOverlayInFinalBattle": False,
            "clickValidationRequiresResolvedButton": True,
        },
        "attachments": attachments,
        "missingPriorityPrefabs": missing_priority,
        "spriteRegionJoinDeferred": [
            "download/artsources/uispriteres/uibattle.assetbundle",
            "download/artsources/uispriteres/uibufficon.assetbundle",
            "download/artsources/uispriteres/uihurtnum.assetbundle",
            "download/artsources/uispriteres/uiheroheadbattle.assetbundle",
        ],
        "notes": [
            "HUD roots are attached as original AssetBundle prefabs only.",
            "Entry/template roots are kept inactive so they do not become fake final overlays.",
            "Sprite/region dependencies are recorded for BATTLE_18 and are not placed as whole atlases.",
        ],
    }
    MANIFEST_JSON.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    print(
        json.dumps(
            {
                "manifest": str(MANIFEST_JSON),
                "attachments": len(attachments),
                "missingPriorityPrefabs": len(missing_priority),
            },
            ensure_ascii=False,
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
