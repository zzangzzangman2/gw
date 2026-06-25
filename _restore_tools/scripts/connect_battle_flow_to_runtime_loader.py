from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"

PAYLOAD_PATH = REPORT_DIR / "BATTLE_TEST_PAYLOAD.json"
PROTOTYPE_MANIFEST_PATH = REPORT_DIR / "BATTLE_PROTOTYPE_MANIFEST.json"
LOAD_MAP_PATH = UNITY_DATA / "BATTLE_ASSETBUNDLE_LOAD_MAP.json"
STREAMING_MANIFEST_PATH = UNITY_DATA / "BATTLE_RUNTIME_STREAMING_MANIFEST.json"
FLOW_MANIFEST_PATH = UNITY_DATA / "BATTLE_RUNTIME_FLOW_MANIFEST.json"
PREP_RESULT_PATH = REPORT_DIR / "BATTLE_RUNTIME_FLOW_LINK_PREP.json"

PROCEDURE_PATH = BASE / "girlswar_merged_extracted" / "decoded" / "xlua_battle" / "download_xlualogic_modules_procedure" / "-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def as_int(value: Any, fallback: int = 0) -> int:
    try:
        if value in ("", None):
            return fallback
        return int(value)
    except (TypeError, ValueError):
        return fallback


def as_str(value: Any) -> str:
    if value is None:
        return ""
    return str(value)


def values_from_formation(formation: Any) -> list[tuple[int, int]]:
    slots: list[tuple[int, int]] = []
    if isinstance(formation, dict):
        for key, value in formation.items():
            slots.append((as_int(key), as_int(value)))
    elif isinstance(formation, list):
        for index, value in enumerate(formation, 1):
            if isinstance(value, dict):
                slot = as_int(value.get("slot") or value.get("position") or value.get("pos") or index)
                hero = as_int(value.get("heroId") or value.get("heroDid") or value.get("id"))
            else:
                slot = index
                hero = as_int(value)
            slots.append((slot, hero))
    return [(slot, hero) for slot, hero in slots if hero != 0]


def collect_skills(payload: dict[str, Any]) -> list[int]:
    skills: set[int] = set()

    def walk(value: Any) -> None:
        if isinstance(value, dict):
            if "skillDid" in value:
                skill = as_int(value.get("skillDid"))
                if skill:
                    skills.add(skill)
            if "skillId" in value:
                skill = as_int(value.get("skillId"))
                if skill:
                    skills.add(skill)
            for child in value.values():
                walk(child)
        elif isinstance(value, list):
            for child in value:
                walk(child)

    walk(payload)
    return sorted(skills)


def procedure_evidence() -> list[dict[str, Any]]:
    wanted = [
        ("BeginFightPlayWithServer", re.compile(r"function t\.BeginFightPlayWithServer")),
        ("LoadPlayerHeros call", re.compile(r"LoadPlayerHeros\(e\.FightPlayData")),
        ("LoadEnemyPlayerHeros call", re.compile(r"LoadEnemyPlayerHeros\(e\.FightPlay_CurrWave")),
        ("BeginBattleWithServer", re.compile(r"function t\.BeginBattleWithServer")),
        ("ResortTeamFormation call", re.compile(r"ResortTeamFormation\(t\)")),
        ("MapId assignment", re.compile(r"MapId=t\.mapId")),
        ("Random seed assignment", re.compile(r"RandomMgr\.seed=t\.randomSeed")),
        ("ResortTeamFormation function", re.compile(r"function t\.ResortTeamFormation")),
        ("BeginBattleWithServer_FightPlay", re.compile(r"function t\.BeginBattleWithServer_FightPlay")),
        ("FightPlay begin dispatch", re.compile(r"ProcedureNormalBattle\.BeginBattleWithServer\(table\.deepCopy")),
        ("FightPlay load dispatch", re.compile(r"ProcedureNormalBattle\.BeginFightPlayWithServer\(table\.deepCopy")),
    ]
    if not PROCEDURE_PATH.exists():
        return [{"label": "ProcedureNormalBattle missing", "path": str(PROCEDURE_PATH), "line": 0, "snippet": ""}]
    lines = PROCEDURE_PATH.read_text(encoding="utf-8", errors="replace").splitlines()
    result: list[dict[str, Any]] = []
    for label, pattern in wanted:
        for index, line in enumerate(lines, 1):
            if pattern.search(line):
                result.append(
                    {
                        "label": label,
                        "path": str(PROCEDURE_PATH),
                        "line": index,
                        "snippet": line.strip()[:220],
                    }
                )
                break
    return result


def actor_lookup(items: list[dict[str, Any]], key: str = "heroDid") -> dict[str, dict[str, Any]]:
    result: dict[str, dict[str, Any]] = {}
    for item in items:
        ident = as_str(item.get(key))
        if ident:
            result[ident] = item
    return result


def slot_xy(side: str, index: int, wave: int = 0) -> tuple[float, float, float]:
    if side == "our":
        return -3.3 + index * 1.65, -2.35, 0.7
    lane = index % 3
    row = max(0, wave - 1)
    return 1.05 + lane * 1.45, 2.35 - row * 1.15, 0.62


def build_actor_slots(payload: dict[str, Any], load_map: dict[str, Any], streaming: dict[str, Any]) -> list[dict[str, Any]]:
    battle = payload.get("battleInfo", payload)
    runtime_by_did = actor_lookup(streaming.get("actors", []))
    load_map_by_did = actor_lookup(load_map.get("actors", []))
    our_by_hero_id = {as_int(h.get("heroId")): h for h in battle.get("ourHeros", [])}
    our_form = values_from_formation(battle.get("ourTeamFormation"))

    slots: list[dict[str, Any]] = []
    our_entries: list[tuple[int, dict[str, Any]]] = []
    if our_form:
        for slot, hero_id in sorted(our_form):
            hero = our_by_hero_id.get(hero_id)
            if hero:
                our_entries.append((slot, hero))
    else:
        for index, hero in enumerate(battle.get("ourHeros", []), 1):
            our_entries.append((index, hero))

    for index, (slot, hero) in enumerate(our_entries):
        hero_did = as_str(hero.get("heroDid"))
        x, y, scale = slot_xy("our", index)
        slots.append(merge_actor_slot("our", 0, slot, index, hero_did, hero, runtime_by_did, load_map_by_did, x, y, scale))

    enemy_index = 0
    for wave_no, wave in enumerate(battle.get("waveData", []), 1):
        enemies = wave.get("enemyHeros", [])
        enemy_by_hero_id = {as_int(h.get("heroId")): h for h in enemies}
        enemy_entries: list[tuple[int, dict[str, Any]]] = []
        enemy_form = values_from_formation(wave.get("enemyTeamFormation"))
        if enemy_form:
            for slot, hero_id in sorted(enemy_form):
                hero = enemy_by_hero_id.get(hero_id)
                if hero:
                    enemy_entries.append((slot, hero))
        if not enemy_entries:
            for slot, hero in enumerate(enemies, 1):
                enemy_entries.append((slot, hero))
        for local_index, (slot, hero) in enumerate(enemy_entries):
            hero_did = as_str(hero.get("heroDid"))
            x, y, scale = slot_xy("enemy", local_index, wave_no)
            slots.append(merge_actor_slot("enemy", wave_no, slot, enemy_index, hero_did, hero, runtime_by_did, load_map_by_did, x, y, scale))
            enemy_index += 1

    return slots


def merge_actor_slot(
    side: str,
    wave: int,
    slot: int,
    index: int,
    hero_did: str,
    hero: dict[str, Any],
    runtime_by_did: dict[str, dict[str, Any]],
    load_map_by_did: dict[str, dict[str, Any]],
    x: float,
    y: float,
    scale: float,
) -> dict[str, Any]:
    runtime = runtime_by_did.get(hero_did, {})
    load_map = load_map_by_did.get(hero_did, {})
    status = as_str(runtime.get("loadStatus") or load_map.get("loadStatus") or "placeholder")
    if status != "runtime_prefab":
        status = "placeholder"
    missing = as_str(runtime.get("missingReason") or load_map.get("loadStatus") or "not_loadable_yet")
    return {
        "side": side,
        "wave": wave,
        "slot": slot,
        "index": index,
        "heroDid": hero_did,
        "heroId": as_int(hero.get("heroId"), as_int(load_map.get("heroId"))),
        "modelId": as_str(runtime.get("model") or load_map.get("model") or hero_did),
        "prefab": as_str(runtime.get("prefab") or load_map.get("prefab")),
        "bundle": as_str(runtime.get("bundle") or load_map.get("bundle")),
        "absolutePath": as_str(runtime.get("absolutePath")),
        "prefabAsset": as_str(runtime.get("prefabAsset")),
        "loadStatus": status,
        "missingReason": "" if status == "runtime_prefab" else missing,
        "skillIds": [as_int(s.get("skillDid")) for s in hero.get("skills", []) if as_int(s.get("skillDid"))],
        "x": runtime.get("x", x),
        "y": runtime.get("y", y),
        "scale": runtime.get("scale", scale),
    }


def main() -> None:
    payload = read_json(PAYLOAD_PATH)
    prototype_manifest = read_json(PROTOTYPE_MANIFEST_PATH)
    load_map = read_json(LOAD_MAP_PATH)
    streaming = read_json(STREAMING_MANIFEST_PATH)
    battle = payload.get("battleInfo", payload)
    actor_slots = build_actor_slots(payload, load_map, streaming)
    known_skill_ids = collect_skills(battle)
    loadable = [a for a in actor_slots if a.get("loadStatus") == "runtime_prefab"]
    missing = [a for a in actor_slots if a.get("loadStatus") != "runtime_prefab"]
    flow_manifest = {
        "status": "runtime_flow_manifest",
        "mapId": as_int(battle.get("mapId")),
        "battleType": as_int(battle.get("battleType")),
        "randomSeed": as_int(battle.get("randomSeed")),
        "waveCount": len(battle.get("waveData", [])),
        "procedureEvidence": procedure_evidence(),
        "sourceEvidence": {
            "testPayload": str(PAYLOAD_PATH),
            "prototypeManifest": str(PROTOTYPE_MANIFEST_PATH),
            "assetBundleLoadMap": str(LOAD_MAP_PATH),
            "runtimeStreamingManifest": str(STREAMING_MANIFEST_PATH),
        },
        "mapEvidence": {
            "mapId": as_int(load_map.get("mapId") or battle.get("mapId")),
            "candidateCount": len(load_map.get("mapCandidates", []) or load_map.get("mapCandidatesExisting", [])),
            "candidates": (load_map.get("mapCandidates", []) or load_map.get("mapCandidatesExisting", []))[:12],
        },
        "actorSlots": actor_slots,
        "knownSkillIds": known_skill_ids,
        "loadableActorPrefabRefs": [
            {
                "side": a.get("side"),
                "heroDid": a.get("heroDid"),
                "modelId": a.get("modelId"),
                "bundle": a.get("bundle"),
                "absolutePath": a.get("absolutePath"),
                "prefabAsset": a.get("prefabAsset"),
            }
            for a in loadable
        ],
        "missingActorPlaceholders": [
            {
                "side": a.get("side"),
                "wave": a.get("wave"),
                "slot": a.get("slot"),
                "heroDid": a.get("heroDid"),
                "modelId": a.get("modelId"),
                "missingReason": a.get("missingReason"),
            }
            for a in missing
        ],
        "nextUnresolvedJoins": [
            "our 1036 bundle is listed in CDN version metadata but is not present in extracted evidence",
            "enemy wave 1 slots 2-3 and waves 2-3 still need monsterId/model datatable joins",
            "skill/effect bundle links are indexed but not yet streamed into the runtime flow shell",
        ],
        "counts": {
            "actorSlots": len(actor_slots),
            "loadableActors": len(loadable),
            "missingActors": len(missing),
            "knownSkillIds": len(known_skill_ids),
            "procedureEvidence": len(procedure_evidence()),
            "prototypeManifestActors": len(prototype_manifest.get("actors", [])),
        },
        "next": "BATTLE_13_STREAM_SKILLS_EFFECTS_BUNDLES",
    }
    FLOW_MANIFEST_PATH.write_text(json.dumps(flow_manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    PREP_RESULT_PATH.write_text(json.dumps(flow_manifest["counts"], ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({"flowManifest": str(FLOW_MANIFEST_PATH), **flow_manifest["counts"]}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
