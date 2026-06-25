from __future__ import annotations

import json
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"

FLOW = UNITY_DATA / "BATTLE_RUNTIME_FLOW_MANIFEST.json"
SKILL_PROBE = UNITY_DATA / "BATTLE_SKILL_EFFECT_STREAMING_PROBE.json"
ATTACH_MANIFEST = UNITY_DATA / "BATTLE_FLOW_SKILL_EFFECT_ATTACH_MANIFEST.json"
PREP_JSON = REPORT_DIR / "BATTLE_SKILL_EFFECT_ATTACH_PREP.json"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def actor_positions(flow: dict[str, Any]) -> dict[tuple[str, str], dict[str, Any]]:
    result: dict[tuple[str, str], dict[str, Any]] = {}
    for slot in flow.get("actorSlots", []):
        result[(str(slot.get("side", "")), str(slot.get("heroDid", "")))] = slot
    return result


def choose_primary_bundle(skill: dict[str, Any]) -> dict[str, Any] | None:
    for candidate in skill.get("bundleCandidates", []):
        if candidate.get("exists") and "skillprefabsandres" in candidate.get("bundle", ""):
            return candidate
    for candidate in skill.get("bundleCandidates", []):
        if candidate.get("exists"):
            return candidate
    return None


def choose_timeline(skill: dict[str, Any]) -> str:
    skill_id = str(skill.get("skillId", ""))
    paths = skill.get("timelineAssetPaths", [])
    for path in paths:
        lower = str(path).lower()
        if lower.endswith(f"/{skill_id}.prefab"):
            return lower
    return str(paths[0]).lower() if paths else ""


def main() -> None:
    flow = read_json(FLOW)
    probe = read_json(SKILL_PROBE)
    positions = actor_positions(flow)
    attachments: list[dict[str, Any]] = []
    unresolved: list[dict[str, Any]] = []
    per_actor_index: dict[tuple[str, str], int] = {}

    for skill in probe.get("skills", []):
        skill_id = int(skill.get("skillId", 0))
        bundle = choose_primary_bundle(skill)
        timeline = choose_timeline(skill)
        loaded = any(r.get("loadSuccess") and r.get("matchingTimelinePrefabCount", 0) for r in skill.get("unityBundleProbe", []))
        if not bundle or not timeline or not loaded:
            unresolved.append(
                {
                    "skillId": skill_id,
                    "reason": skill.get("unresolvedReason") or "no_loadable_timeline_prefab",
                    "owners": skill.get("owners", []),
                }
            )
            continue

        owners = skill.get("owners", [])
        owner = owners[0] if owners else {}
        side = str(owner.get("side", ""))
        hero_did = str(owner.get("heroDid", ""))
        slot = positions.get((side, hero_did), {})
        actor_key = (side, hero_did)
        actor_skill_index = per_actor_index.get(actor_key, 0)
        per_actor_index[actor_key] = actor_skill_index + 1
        base_x = float(slot.get("x", 0))
        base_y = float(slot.get("y", 0))
        x_offset = (actor_skill_index - 1) * 0.55
        y_offset = 1.15 if side == "our" else -0.95

        attachments.append(
            {
                "skillId": skill_id,
                "side": side,
                "heroDid": hero_did,
                "heroId": owner.get("heroId", ""),
                "wave": owner.get("wave", 0),
                "slot": owner.get("slot", 0),
                "bundle": bundle.get("bundle", ""),
                "absolutePath": bundle.get("absolutePath", ""),
                "prefabAsset": timeline,
                "source": "BATTLE_13_LOADABLE_TIMELINE_PREFAB",
                "x": round(base_x + x_offset, 3),
                "y": round(base_y + y_offset, 3),
                "scale": 0.32,
                "luaEvidenceCount": len(skill.get("decodedLuaEvidence", [])),
            }
        )

    manifest = {
        "status": "skill_effect_attach_manifest",
        "flowManifest": str(FLOW),
        "skillProbe": str(SKILL_PROBE),
        "scene": "Assets/Scenes/BattleRuntimeFlowSkillEffectAttach.unity",
        "attachments": attachments,
        "unresolvedSkills": unresolved,
        "counts": {
            "knownSkillIds": len(probe.get("skills", [])),
            "loadableAttachments": len(attachments),
            "unresolvedSkills": len(unresolved),
            "uniqueBundles": len({a["bundle"] for a in attachments}),
        },
        "next": "BATTLE_14_ATTACH_LOADABLE_SKILL_EFFECT_TO_FLOW_SCENE",
    }
    ATTACH_MANIFEST.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    PREP_JSON.write_text(json.dumps(manifest["counts"], ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({"attachManifest": str(ATTACH_MANIFEST), **manifest["counts"]}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
