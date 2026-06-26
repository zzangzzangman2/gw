from __future__ import annotations

import csv
import json
import re
import struct
import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
INDEX_DIR = MERGED / "indexes"
CHAR_DIR = BASE / "reports" / "characters"
BATTLE_DIR = BASE / "reports" / "battle"

LOCAL_MANIFEST_JSON = BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.json"
LOCAL_MANIFEST_CSV = BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.csv"
AUDIT_CSV = BATTLE_DIR / "BATTLE_59_AUDIT_LOCAL_SOURCE_BACKED_XLUA_RUNTIME_RECOVERY_FEASIBILITY_AND_BOOTSTRAP_REQUIREMENTS_NO_STUB_NO_EXTERNAL_FULL_PAYLOAD_BLOCKER_SEPARATION.csv"
ROSTER_JSON = CHAR_DIR / "GIRLSWAR_CHARACTER_ROSTER.json"
GAP_MD = CHAR_DIR / "GIRLSWAR_CHARACTER_GAP_REPORT.md"
DEEP_TRACE_MD = CHAR_DIR / "CHARACTER_RESOURCE_GAP_DEEP_TRACE.md"
CDN_TRACE_MD = CHAR_DIR / "CHARACTER_1036_CDN_ACQUISITION_TRACE.md"
PAYLOAD_JSON = BATTLE_DIR / "BATTLE_TEST_PAYLOAD.json"
PROTOTYPE_JSON = BATTLE_DIR / "BATTLE_PROTOTYPE_MANIFEST.json"

ASSETBUNDLES_CSV = INDEX_DIR / "assetbundles.csv"
MERGED_FILES_CSV = INDEX_DIR / "merged_files.csv"
CONFLICTS_CSV = INDEX_DIR / "conflicts.csv"
VERSIONFILE_CSV = INDEX_DIR / "versionfile_VersionFile_bytes.csv"
CDN_VERSIONFILE_CSV = INDEX_DIR / "versionfile_CDNVersionFile_bytes.csv"

OUT_JSON = CHAR_DIR / "CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT.json"
OUT_CSV = CHAR_DIR / "CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT.csv"
OUT_MD = CHAR_DIR / "CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT.md"
OUT_PROPOSAL_JSON = BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_UPDATE_PROPOSAL_FROM_ENEMY_TRACE.json"
OUT_PROPOSAL_CSV = BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_UPDATE_PROPOSAL_FROM_ENEMY_TRACE.csv"

TARGET_IDS = [1100112, 1100113, 1100121, 1100122, 1100123, 1100131, 1100132, 1100133]
CONTROL_IDS = [1100111]
ALL_TRACE_IDS = CONTROL_IDS + TARGET_IDS

sys.path.insert(0, str(BASE / "_restore_tools" / "scripts"))
import build_battle_prototype_manifest as b5  # noqa: E402


def rel(path: str | Path | None) -> str:
    if not path:
        return ""
    p = Path(path)
    try:
        return str(p.relative_to(BASE)).replace("\\", "/")
    except Exception:
        return str(path).replace("\\", "/")


def norm(value: Any) -> str:
    return str(value or "").replace("\\", "/").lower()


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, Any]], fields: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def flatten_numbers(value: Any) -> list[int]:
    out: list[int] = []
    if isinstance(value, list):
        for item in value:
            out.extend(flatten_numbers(item))
    else:
        try:
            out.append(int(value))
        except Exception:
            pass
    return out


def load_table_if_present(textassets: dict[str, dict[str, str]], entity: str) -> b5.TableData | None:
    table_name = entity + "TableData"
    if entity not in textassets or table_name not in textassets:
        return None
    return b5.load_table(entity, entity, table_name, textassets)


def assetbundle_set() -> set[str]:
    return {norm(r.get("bundle")) for r in read_csv(ASSETBUNDLES_CSV) if r.get("bundle")}


def actor_bundle_for_prefab(prefab_id: Any) -> str:
    if prefab_id in (None, ""):
        return ""
    return f"download/roleprefabsandres/battleprefabandres/{int(prefab_id)}.assetbundle"


def payload_enemy_rows(payload: dict[str, Any]) -> list[dict[str, Any]]:
    info = payload.get("battleInfo", payload)
    rows = []
    for wave in info.get("waveData", []):
        wave_no = wave.get("waveNo")
        formation = {x.get("heroDid"): x for x in wave.get("enemyTeamFormation", [])}
        for hero in wave.get("enemyHeros", []):
            did = int(hero.get("heroDid"))
            if did not in ALL_TRACE_IDS:
                continue
            rows.append(
                {
                    "waveNo": wave_no,
                    "position": formation.get(did, {}).get("position", ""),
                    "payloadHeroDid": did,
                    "payloadHeroId": hero.get("heroId"),
                    "skillDids": [s.get("skillDid") for s in hero.get("skills", []) if s.get("skillDid")],
                    "rankLevel": hero.get("rankLevel"),
                    "curHp": hero.get("curHp"),
                    "curMp": hero.get("curMp"),
                }
            )
    return rows


def trace_monster_tables(textassets: dict[str, dict[str, str]], model_table: b5.TableData, bundle_names: set[str]) -> tuple[dict[int, list[dict[str, Any]]], list[str], list[dict[str, Any]]]:
    direct_hits: dict[int, list[dict[str, Any]]] = {i: [] for i in ALL_TRACE_IDS}
    searched: list[str] = []
    prefix_rows: list[dict[str, Any]] = []
    for entity in sorted(n for n in textassets if n.startswith("DTMonster") and n.endswith("Entity") and "Attr" not in n):
        table = load_table_if_present(textassets, entity)
        if not table or "modelID" not in table.fields:
            continue
        searched.append(entity)
        for monster_id in ALL_TRACE_IDS:
            row = table.rows.get(monster_id)
            if not row:
                continue
            model_id = row.get("modelID")
            model_row = model_table.rows.get(int(model_id)) if model_id not in (None, "") else None
            prefab_id = model_row.get("prefabId") if model_row else ""
            bundle = actor_bundle_for_prefab(prefab_id) if prefab_id not in (None, "") else ""
            hit = {
                "targetId": monster_id,
                "table": entity,
                "rowId": monster_id,
                "modelId": model_id,
                "modelFound": bool(model_row),
                "prefabId": prefab_id,
                "bundle": bundle,
                "bundleExists": norm(bundle) in bundle_names if bundle else False,
                "monName": row.get("monName", ""),
                "skills": [row.get("monSkill1"), row.get("monSkill2"), row.get("monSkill3"), row.get("monSkill4"), row.get("monSkillPas")],
                "source": rel(table.table_path),
            }
            direct_hits[monster_id].append(hit)
        for row_id, row in table.rows.items():
            if str(row_id).startswith("11001") and row_id not in TARGET_IDS:
                prefix_rows.append(
                    {
                        "table": entity,
                        "rowId": row_id,
                        "modelId": row.get("modelID"),
                        "monName": row.get("monName", ""),
                        "note": "same 11001 prefix evidence only; not an alias candidate without code/table join",
                    }
                )
    return direct_hits, searched, sorted(prefix_rows, key=lambda r: (r["table"], r["rowId"]))[:80]


def trace_map_and_battle_tables(textassets: dict[str, dict[str, str]], map_id: int) -> tuple[list[dict[str, Any]], list[dict[str, Any]], list[str]]:
    searched: list[str] = []
    map_rows: list[dict[str, Any]] = []
    id_mentions: list[dict[str, Any]] = []
    for entity in sorted(n for n in textassets if n.startswith("DTMapsWave") and n.endswith("Entity")):
        table = load_table_if_present(textassets, entity)
        if not table:
            continue
        searched.append(entity)
        for row_id, row in sorted(table.rows.items()):
            monster_values = flatten_numbers(row.get("monsterLists", [])) + flatten_numbers(row.get("newMonsterLists", []))
            if int(row.get("mapId") or -1) == map_id:
                map_rows.append(
                    {
                        "table": entity,
                        "rowId": row_id,
                        "mapId": row.get("mapId"),
                        "wave": row.get("wave"),
                        "monsterLists": row.get("monsterLists", []),
                        "newMonsterLists": row.get("newMonsterLists", []),
                        "monsterEffect": row.get("monsterEffect", []),
                        "name": row.get("Name", ""),
                    }
                )
            for target in ALL_TRACE_IDS:
                if target in monster_values:
                    id_mentions.append(
                        {
                            "targetId": target,
                            "table": entity,
                            "rowId": row_id,
                            "mapId": row.get("mapId"),
                            "wave": row.get("wave"),
                            "field": "monsterLists/newMonsterLists",
                            "value": monster_values,
                        }
                    )

    for entity in sorted(n for n in textassets if n.startswith("DTBattle") and n.endswith("Entity")):
        table = load_table_if_present(textassets, entity)
        if not table:
            continue
        searched.append(entity)
        for row_id, row in sorted(table.rows.items()):
            row_values = flatten_numbers(row)
            if map_id in row_values or any(target in row_values for target in ALL_TRACE_IDS):
                id_mentions.append(
                    {
                        "targetId": ",".join(str(t) for t in ALL_TRACE_IDS if t in row_values) or map_id,
                        "table": entity,
                        "rowId": row_id,
                        "field": "numeric_row_values",
                        "value": row,
                    }
                )
    return map_rows, id_mentions, searched


def line_hits(path: Path, needles: list[str], max_hits: int = 30) -> list[dict[str, Any]]:
    hits = []
    if not path.exists() or not path.is_file():
        return hits
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except Exception:
        return hits
    for no, line in enumerate(text.splitlines(), 1):
        if any(n in line for n in needles):
            snippet = line.strip()
            hits.append({"path": rel(path), "line": no, "snippet": snippet[:320]})
            if len(hits) >= max_hits:
                break
    return hits


def scan_decoded_lua() -> tuple[list[dict[str, Any]], list[str]]:
    roots = [MERGED / "decoded" / "xlua_battle", MERGED / "decoded" / "xlua_guildmain_runtime_trace"]
    id_needles = [str(i) for i in ALL_TRACE_IDS]
    flow_needles = ["GetMapsWave", "GetFormationFromMonsterList", "DTMonsterRow", "heroDid=a", "JsonUtil.decode(t).battleInfo"]
    rows: list[dict[str, Any]] = []
    searched_roots = []
    for root in roots:
        if not root.exists():
            continue
        searched_roots.append(rel(root))
        for path in root.rglob("*.lua"):
            try:
                text = path.read_text(encoding="utf-8", errors="replace")
            except Exception:
                continue
            if not any(n in text for n in id_needles + flow_needles):
                continue
            for no, line in enumerate(text.splitlines(), 1):
                matched = [n for n in id_needles if n in line]
                flow = [n for n in flow_needles if n in line]
                if not matched and not flow:
                    continue
                rows.append(
                    {
                        "targetId": ",".join(matched),
                        "evidenceKind": "decoded_lua_string_or_flow",
                        "source": rel(path),
                        "line": no,
                        "value": line.strip()[:360],
                        "note": "id hit is payload/string evidence only unless joined by DTMonster/DTmodel chain",
                    }
                )
                if len([r for r in rows if r["source"] == rel(path)]) >= 20:
                    break
    return rows, searched_roots


def scan_text_indexes() -> list[dict[str, Any]]:
    paths = [
        ASSETBUNDLES_CSV,
        MERGED_FILES_CSV,
        CONFLICTS_CSV,
        VERSIONFILE_CSV,
        CDN_VERSIONFILE_CSV,
        BATTLE_DIR / "BATTLE_ASSETBUNDLE_CANDIDATES.csv",
        BATTLE_DIR / "BATTLE_TEXTASSET_CANDIDATES.csv",
        BATTLE_DIR / "BATTLE_IMAGE_CANDIDATES.csv",
        BATTLE_DIR / "BATTLE_XLUA_DECODE_TARGETS.csv",
        BATTLE_DIR / "battle_restore_index_summary.json",
    ]
    rows = []
    needles = [str(i) for i in ALL_TRACE_IDS]
    for path in paths:
        if not path.exists():
            rows.append({"evidenceKind": "searched_index_missing", "source": rel(path), "note": "index file not present"})
            continue
        hits = line_hits(path, needles, max_hits=20)
        if hits:
            for hit in hits:
                rows.append(
                    {
                        "targetId": ",".join(n for n in needles if n in hit["snippet"]),
                        "evidenceKind": "index_string_hit",
                        "source": hit["path"],
                        "line": hit["line"],
                        "value": hit["snippet"],
                        "note": "index string hit only; not an actor mapping without DTMonster/DTmodel row",
                    }
                )
        else:
            rows.append({"evidenceKind": "searched_index_no_id_hit", "source": rel(path), "note": "no unresolved/control id string hit"})
    return rows


def scan_binary_refs() -> list[dict[str, Any]]:
    paths = [
        BASE / "il2cpp_native" / "global-metadata.dat",
        BASE / "il2cpp_native" / "libil2cpp.so",
        BASE / "work" / "apk_probe" / "global-metadata.dat",
        BASE / "work" / "apk_probe" / "libil2cpp.so",
        MERGED / "restore_overlay" / "Android" / "data" / "com.girlwars.kr" / "files" / "AssetInfo.bytes",
        MERGED / "restore_overlay" / "Android" / "data" / "com.girlwars.kr" / "files" / "AssetGuid.bytes",
        MERGED / "extracted" / "decoded_gzip_bytes" / "AssetInfo.bytes.gunzipped",
        MERGED / "extracted" / "decoded_gzip_bytes" / "AssetGuid.bytes.gunzipped",
    ]
    rows = []
    for path in paths:
        if not path.exists():
            rows.append({"evidenceKind": "searched_binary_missing", "source": rel(path), "note": "binary/source file not present"})
            continue
        data = path.read_bytes()
        any_hit = False
        for target in ALL_TRACE_IDS:
            ascii_idx = data.find(str(target).encode("ascii"))
            le_idx = data.find(struct.pack("<I", target))
            if ascii_idx >= 0:
                any_hit = True
                start = max(0, ascii_idx - 80)
                end = min(len(data), ascii_idx + 160)
                snippet = re.sub(r"\s+", " ", data[start:end].decode("utf-8", errors="replace"))
                rows.append(
                    {
                        "targetId": target,
                        "evidenceKind": "binary_ascii_string_hit",
                        "source": rel(path),
                        "offset": ascii_idx,
                        "value": snippet[:260],
                        "note": "IL2CPP/restore binary string evidence only; not used as mapping",
                    }
                )
            if le_idx >= 0:
                any_hit = True
                rows.append(
                    {
                        "targetId": target,
                        "evidenceKind": "binary_little_endian_int_hit",
                        "source": rel(path),
                        "offset": le_idx,
                        "value": f"uint32_le:{target}",
                        "note": "raw integer occurrence is weak evidence and not an actor mapping",
                    }
                )
        if not any_hit:
            rows.append({"evidenceKind": "searched_binary_no_id_hit", "source": rel(path), "note": "no ascii or uint32_le target id hit"})
    return rows


def command_policy_status() -> dict[str, Any]:
    root_cmd = sorted(p.name for p in BASE.glob("*.cmd") if p.is_file())
    restore_direct_cmd = sorted(p.name for p in (BASE / "_restore_tools").glob("*.cmd") if p.is_file()) if (BASE / "_restore_tools").exists() else []
    return {
        "rootCmdCount": len(root_cmd),
        "rootCmdFiles": root_cmd,
        "restoreToolsDirectCmdCount": len(restore_direct_cmd),
        "restoreToolsDirectCmdFiles": restore_direct_cmd,
        "status": "ok" if len(root_cmd) == 1 and len(restore_direct_cmd) == 0 else "policy_mismatch",
    }


def classify_target(target: int, direct_hits: list[dict[str, Any]]) -> tuple[str, str]:
    if not direct_hits:
        return "not_resolved_from_local_evidence", "No direct DTMonster*/DTmodel actor chain was found for this payload id."
    signatures = {(h.get("modelId"), h.get("prefabId"), h.get("bundle"), h.get("bundleExists")) for h in direct_hits}
    if len(signatures) > 1:
        return "ambiguous_multiple_candidates", "Multiple direct DTMonster actor candidates disagree."
    hit = direct_hits[0]
    if not hit.get("modelFound") or hit.get("prefabId") in (None, ""):
        return "resolved_model_missing_prefab_bundle", "DTMonster row exists but DTmodel/prefab bundle chain is incomplete."
    if hit.get("bundleExists"):
        return "resolved_loadable_actor_bundle", "DTMonster -> DTmodel.prefabId -> actor bundle exists locally."
    return "resolved_data_only_missing_bundle", "DTMonster -> DTmodel.prefabId resolves, but actor bundle is absent locally."


def build_report() -> dict[str, Any]:
    local_manifest = load_json(LOCAL_MANIFEST_JSON)
    roster = load_json(ROSTER_JSON)
    payload = load_json(PAYLOAD_JSON)
    info = payload.get("battleInfo", payload)
    map_id = int(info.get("mapId") or 0)
    textassets = b5.load_textasset_map()
    bundle_names = assetbundle_set()

    model_table = load_table_if_present(textassets, "DTmodelEntity")
    if not model_table:
        raise RuntimeError("DTmodelEntity table missing")

    payload_rows = payload_enemy_rows(payload)
    direct_hits, monster_tables_searched, prefix_rows = trace_monster_tables(textassets, model_table, bundle_names)
    map_rows, map_id_mentions, battle_tables_searched = trace_map_and_battle_tables(textassets, map_id)
    lua_rows, lua_roots = scan_decoded_lua()
    index_rows = scan_text_indexes()
    binary_rows = scan_binary_refs()
    cmd_policy = command_policy_status()

    final_rows = []
    proposal_rows = []
    actor_by_id = {int(a["payloadHeroDid"]): a for a in local_manifest.get("actors", []) if str(a.get("payloadHeroDid", "")).isdigit()}
    skill_rows = local_manifest.get("skills", [])
    for payload_row in payload_rows:
        target = int(payload_row["payloadHeroDid"])
        if target in CONTROL_IDS:
            # Keep 1100111 as a control path so the report shows the positive chain.
            target_kind = "control_resolved_reference"
        else:
            target_kind = "unresolved_target"
        status, reason = classify_target(target, direct_hits.get(target, []))
        formula_like = str(target) == f"{map_id}{payload_row.get('waveNo')}{payload_row.get('position')}"
        actor_row = actor_by_id.get(target, {})
        owner_skill_rows = [s for s in skill_rows if int(s.get("ownerHeroDid") or 0) == target and str(s.get("waveNo", "")) == str(payload_row.get("waveNo", ""))]
        impact = "no_change_existing_actor_unresolved"
        if target_kind == "control_resolved_reference":
            impact = "control_already_loadable"
        elif status.startswith("resolved_"):
            impact = "source_backed_actor_status_change_candidate"
            proposal_rows.append(
                {
                    "payloadHeroDid": target,
                    "waveNo": payload_row.get("waveNo"),
                    "position": payload_row.get("position"),
                    "proposedStatus": status,
                    "directMonsterHits": direct_hits.get(target, []),
                    "affectedSkillRows": owner_skill_rows,
                    "note": "Proposal only; existing BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST is not overwritten.",
                }
            )
        final_rows.append(
            {
                **payload_row,
                "targetKind": target_kind,
                "formulaLikeMapWaveSlot": formula_like,
                "previousLocalStatus": actor_row.get("localStatus", ""),
                "finalStatus": status,
                "reason": reason,
                "directMonsterHits": direct_hits.get(target, []),
                "directMonsterTables": sorted({h["table"] for h in direct_hits.get(target, [])}),
                "skillImpact": impact,
                "affectedSkillStatusCounts": dict(Counter(s.get("localStatus") for s in owner_skill_rows)),
            }
        )

    evidence_rows: list[dict[str, Any]] = []
    for target, hits in direct_hits.items():
        if hits:
            for hit in hits:
                evidence_rows.append(
                    {
                        "targetId": target,
                        "evidenceKind": "direct_monster_actor_chain",
                        "status": classify_target(target, hits)[0],
                        "source": hit.get("source"),
                        "table": hit.get("table"),
                        "rowId": hit.get("rowId"),
                        "modelId": hit.get("modelId"),
                        "prefabId": hit.get("prefabId"),
                        "bundle": hit.get("bundle"),
                        "bundleExists": hit.get("bundleExists"),
                        "value": hit.get("monName"),
                        "note": "authoritative direct actor chain evidence",
                    }
                )
        else:
            evidence_rows.append(
                {
                    "targetId": target,
                    "evidenceKind": "direct_monster_actor_chain_absent",
                    "status": "not_resolved_from_local_evidence",
                    "source": ", ".join(monster_tables_searched),
                    "note": "searched all decoded non-Attr DTMonster*Entity tables with modelID fields",
                }
            )
    for row in prefix_rows:
        evidence_rows.append({**row, "targetId": "", "evidenceKind": "same_prefix_monster_row", "status": "context_only"})
    for row in map_rows:
        evidence_rows.append(
            {
                "targetId": "",
                "evidenceKind": "map_wave_row_for_payload_map",
                "status": "context_only",
                "source": row["table"],
                "rowId": row["rowId"],
                "value": json.dumps(row, ensure_ascii=False),
                "note": "stage/wave source row; not an alias unless payload id appears or code maps to it",
            }
        )
    for row in map_id_mentions:
        evidence_rows.append({**row, "evidenceKind": "stage_or_battle_table_numeric_mention", "status": "context_only"})
    evidence_rows.extend(lua_rows)
    evidence_rows.extend(index_rows)
    evidence_rows.extend(binary_rows)

    status_counts = Counter(r["finalStatus"] for r in final_rows if r["targetKind"] == "unresolved_target")
    report = {
        "name": "CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_NO_FAKE_MAPPING",
        "generatedBy": rel(Path(__file__)),
        "workspace": str(BASE),
        "sourceInputs": {
            "localManifestMd": rel(BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.md"),
            "localManifestJson": rel(LOCAL_MANIFEST_JSON),
            "localManifestCsv": rel(LOCAL_MANIFEST_CSV),
            "auditCsv": rel(AUDIT_CSV),
            "rosterJson": rel(ROSTER_JSON),
            "gapReport": rel(GAP_MD),
            "resourceGapDeepTrace": rel(DEEP_TRACE_MD),
            "character1036CdnTrace": rel(CDN_TRACE_MD),
            "battleTestPayload": rel(PAYLOAD_JSON),
            "battlePrototypeManifest": rel(PROTOTYPE_JSON) if PROTOTYPE_JSON.exists() else "",
        },
        "summary": {
            "mapId": map_id,
            "targetIds": TARGET_IDS,
            "controlIds": CONTROL_IDS,
            "targetStatusCounts": dict(status_counts),
            "sourceBackedProposalCount": len(proposal_rows),
            "proposalWritten": bool(proposal_rows),
            "commandPolicy": cmd_policy,
        },
        "finalRows": final_rows,
        "proposalRows": proposal_rows,
        "searched": {
            "monsterTables": monster_tables_searched,
            "stageBattleTables": battle_tables_searched,
            "decodedLuaRoots": lua_roots,
            "assetbundleAndRestoreIndexes": [rel(p) for p in [ASSETBUNDLES_CSV, MERGED_FILES_CSV, CONFLICTS_CSV, VERSIONFILE_CSV, CDN_VERSIONFILE_CSV]],
            "binaryStringRefs": "il2cpp/global-metadata/libil2cpp plus AssetInfo/AssetGuid restore indexes",
        },
        "stageWaveRowsForMap": map_rows,
        "samePrefixMonsterRows": prefix_rows,
        "evidenceRows": evidence_rows,
        "nextBlockers": [
            "No unresolved enemy payload instance can be promoted without a source-backed DTMonster/DTmodel/prefab/bundle chain or an authoritative code/data alias.",
            "The formula-like ids mapId+wave+slot are payload instance ids unless local code/data proves otherwise.",
            "1036 actor remains not_fetchable_local; this trace does not change 1036.",
        ],
        "principles": [
            "No Unity scene was modified.",
            "No fake actor/card/skill mapping was generated.",
            "No placeholder bundle path was introduced.",
            "Existing BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST was not overwritten.",
        ],
    }
    return report


def write_reports(report: dict[str, Any]) -> None:
    write_json(OUT_JSON, report)
    flat_rows: list[dict[str, Any]] = []
    for row in report["finalRows"]:
        flat_rows.append(
            {
                "targetId": row["payloadHeroDid"],
                "waveNo": row.get("waveNo"),
                "position": row.get("position"),
                "rowType": "final_status",
                "status": row["finalStatus"],
                "previousLocalStatus": row.get("previousLocalStatus"),
                "directMonsterTables": "|".join(row.get("directMonsterTables", [])),
                "modelId": "|".join(str(h.get("modelId")) for h in row.get("directMonsterHits", [])),
                "prefabId": "|".join(str(h.get("prefabId")) for h in row.get("directMonsterHits", [])),
                "bundle": "|".join(str(h.get("bundle")) for h in row.get("directMonsterHits", [])),
                "bundleExists": "|".join(str(h.get("bundleExists")) for h in row.get("directMonsterHits", [])),
                "skillImpact": row.get("skillImpact"),
                "note": row.get("reason"),
            }
        )
    for row in report["evidenceRows"]:
        flat_rows.append(
            {
                "targetId": row.get("targetId", ""),
                "waveNo": "",
                "position": "",
                "rowType": row.get("evidenceKind", "evidence"),
                "status": row.get("status", ""),
                "source": row.get("source", ""),
                "table": row.get("table", ""),
                "rowId": row.get("rowId", ""),
                "line": row.get("line", ""),
                "offset": row.get("offset", ""),
                "modelId": row.get("modelId", ""),
                "prefabId": row.get("prefabId", ""),
                "bundle": row.get("bundle", ""),
                "bundleExists": row.get("bundleExists", ""),
                "value": str(row.get("value", ""))[:500],
                "note": row.get("note", ""),
            }
        )
    fields = [
        "targetId",
        "waveNo",
        "position",
        "rowType",
        "status",
        "previousLocalStatus",
        "source",
        "table",
        "rowId",
        "line",
        "offset",
        "directMonsterTables",
        "modelId",
        "prefabId",
        "bundle",
        "bundleExists",
        "skillImpact",
        "value",
        "note",
    ]
    write_csv(OUT_CSV, flat_rows, fields)

    if report["proposalRows"]:
        write_json(OUT_PROPOSAL_JSON, {"name": "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_UPDATE_PROPOSAL_FROM_ENEMY_TRACE", "proposalRows": report["proposalRows"]})
        proposal_flat = []
        for row in report["proposalRows"]:
            proposal_flat.append(
                {
                    "payloadHeroDid": row["payloadHeroDid"],
                    "waveNo": row["waveNo"],
                    "position": row["position"],
                    "proposedStatus": row["proposedStatus"],
                    "note": row["note"],
                }
            )
        write_csv(OUT_PROPOSAL_CSV, proposal_flat, ["payloadHeroDid", "waveNo", "position", "proposedStatus", "note"])

    summary = report["summary"]
    lines = [
        "# CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT",
        "",
        "- Scope: unresolved enemy payload instance ids only; no fake mapping.",
        f"- Target ids: `{', '.join(str(i) for i in TARGET_IDS)}`",
        f"- Control id: `1100111`",
        f"- Target status counts: `{summary['targetStatusCounts']}`",
        f"- Source-backed update proposals: `{summary['sourceBackedProposalCount']}`",
        f"- Proposal files written: `{summary['proposalWritten']}`",
        f"- Command policy: root `.cmd` `{summary['commandPolicy']['rootCmdCount']}`, `_restore_tools` direct `.cmd` `{summary['commandPolicy']['restoreToolsDirectCmdCount']}` -> `{summary['commandPolicy']['status']}`",
        "",
        "## Final Status By Payload Id",
        "| wave | pos | payloadHeroDid | previousLocalStatus | finalStatus | directTables | modelId | prefabId | bundle | note |",
        "| ---: | ---: | ---: | --- | --- | --- | --- | --- | --- | --- |",
    ]
    for row in report["finalRows"]:
        if row["targetKind"] == "control_resolved_reference":
            continue
        hits = row.get("directMonsterHits", [])
        lines.append(
            f"| {row.get('waveNo')} | {row.get('position')} | {row.get('payloadHeroDid')} | `{row.get('previousLocalStatus')}` | `{row.get('finalStatus')}` | `{', '.join(row.get('directMonsterTables', []))}` | `{', '.join(str(h.get('modelId')) for h in hits)}` | `{', '.join(str(h.get('prefabId')) for h in hits)}` | `{', '.join(str(h.get('bundle')) for h in hits)}` | {row.get('reason')} |"
        )
    lines.extend(
        [
            "",
            "## Skill / Timeline Impact",
            "| payloadHeroDid | skillImpact | affectedSkillStatusCounts |",
            "| ---: | --- | --- |",
        ]
    )
    for row in report["finalRows"]:
        if row["targetKind"] == "control_resolved_reference":
            continue
        lines.append(
            f"| {row.get('payloadHeroDid')} | `{row.get('skillImpact')}` | `{row.get('affectedSkillStatusCounts')}` |"
        )
    lines.extend(
        [
            "",
            "## Control Path: 1100111",
            "| table | modelId | prefabId | bundle | exists |",
            "| --- | ---: | ---: | --- | --- |",
        ]
    )
    for hit in report["finalRows"][0].get("directMonsterHits", []):
        lines.append(f"| {hit.get('table')} | {hit.get('modelId')} | {hit.get('prefabId')} | `{hit.get('bundle')}` | `{hit.get('bundleExists')}` |")
    lines.extend(
        [
            "",
            "## Stage/Wave Context",
            f"- DTMapsWave rows for mapId `{summary['mapId']}`: `{len(report['stageWaveRowsForMap'])}`",
            "- These rows are context only unless code/data explicitly aliases payload instance ids to their monsterLists.",
            "",
            "| table | rowId | wave | monsterLists | newMonsterLists | name |",
            "| --- | ---: | ---: | --- | --- | --- |",
        ]
    )
    for row in report["stageWaveRowsForMap"]:
        lines.append(f"| {row['table']} | {row['rowId']} | {row['wave']} | `{row['monsterLists']}` | `{row['newMonsterLists']}` | {row['name']} |")
    lines.extend(
        [
            "",
            "## Search Coverage",
            f"- Monster tables: `{', '.join(report['searched']['monsterTables'])}`",
            f"- Stage/battle tables: `{', '.join(report['searched']['stageBattleTables'])}`",
            f"- Decoded Lua roots: `{', '.join(report['searched']['decodedLuaRoots'])}`",
            "- IL2CPP/global-metadata/libil2cpp and AssetInfo/AssetGuid restore indexes were scanned for string/raw-int refs; hits are weak evidence only and not mapping evidence.",
            "",
            "## Next Blockers",
        ]
    )
    for blocker in report["nextBlockers"]:
        lines.append(f"- {blocker}")
    lines.extend(
        [
            "",
            "## Outputs",
            f"- JSON: `reports/characters/{OUT_JSON.name}`",
            f"- CSV: `reports/characters/{OUT_CSV.name}`",
            "- Proposal JSON/CSV: not written unless source-backed actor status changes exist.",
        ]
    )
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    report = build_report()
    write_reports(report)
    print(f"Wrote {OUT_JSON}")
    print(f"Wrote {OUT_CSV}")
    print(f"Wrote {OUT_MD}")
    print(json.dumps(report["summary"], ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
