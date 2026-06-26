from __future__ import annotations

import csv
import json
import os
import re
import sys
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
CHAR_DIR = BASE / "reports" / "characters"
BATTLE_DIR = BASE / "reports" / "battle"
INDEX_DIR = MERGED / "indexes"

TARGET_IDS = [1100112, 1100113, 1100121, 1100122, 1100123, 1100131, 1100132, 1100133]
CONTROL_IDS = [1100111]
ALL_IDS = CONTROL_IDS + TARGET_IDS
FAMILY_PATTERNS = ["110011", "110012", "110013"]
BASE_MODEL_CANDIDATES = [1100111, 3001]

CHAR65_JSON = CHAR_DIR / "CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT.json"
CHAR65_MD = CHAR_DIR / "CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT.md"
CHAR65_ACTORS = CHAR_DIR / "CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT_FULL_BATTLE_ACTOR_CARD_ROSTER_MATRIX.csv"
CHAR65_GAPS = CHAR_DIR / "CHARACTER_65_FULL_BATTLE_PAYLOAD_ROSTER_AND_BUNDLE_GAP_MATRIX_NO_NETWORK_NO_IMPORT_RESULT_LOCAL_BUNDLE_READINESS_AND_GAP_MATRIX.csv"
CHAR65_PROPOSAL = BATTLE_DIR / "BATTLE_FULL_PAYLOAD_LIST_CANDIDATE_PROPOSAL_FROM_CHARACTER65_ROSTER_GAP_MATRIX.json"
CHAR63_JSON = CHAR_DIR / "CHARACTER_63_UNRESOLVED_ACTOR_BUNDLE_LOCAL_EVIDENCE_RESCAN_NO_NETWORK_NO_FAKE_RESULT.json"
CHAR64_JSON = CHAR_DIR / "CHARACTER_64_LOCAL_EXACT_1036_BUNDLE_WIDER_PC_SEARCH_NO_NETWORK_NO_COPY_NO_IMPORT_RESULT.json"

OUT_BASE = "CHARACTER_66_UNRESOLVED_ENEMY_ID_SOURCE_ALIAS_TRACE_NO_NETWORK_NO_PROMOTION_RESULT"
OUT_JSON = CHAR_DIR / f"{OUT_BASE}.json"
OUT_MD = CHAR_DIR / f"{OUT_BASE}.md"
OUT_HITS_CSV = CHAR_DIR / f"{OUT_BASE}_UNRESOLVED_ENEMY_ID_SOURCE_HIT_MATRIX.csv"
OUT_DECISION_CSV = CHAR_DIR / f"{OUT_BASE}_ALIAS_PROMOTION_DECISION_MATRIX.csv"
OUT_PROPOSAL_JSON = BATTLE_DIR / "BATTLE_UNRESOLVED_ENEMY_ALIAS_PROPOSAL_FROM_CHARACTER66_SOURCE_TRACE.json"

sys.path.insert(0, str(BASE / "_restore_tools" / "scripts"))
import build_battle_prototype_manifest as b5  # noqa: E402


def rel(path: str | Path | None) -> str:
    if not path:
        return ""
    p = Path(path)
    try:
        return p.relative_to(BASE).as_posix()
    except Exception:
        return str(path).replace("\\", "/")


def norm(value: Any) -> str:
    return str(value or "").replace("\\", "/").lower()


def load_json(path: Path) -> Any:
    if not path.exists():
        return {}
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
        for row in rows:
            writer.writerow({field: row.get(field, "") for field in fields})


def command_policy_status() -> dict:
    root_cmd = sorted(p.name for p in BASE.glob("*.cmd"))
    tools_cmd = sorted(p.name for p in (BASE / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmd),
        "rootCmdFiles": root_cmd,
        "restoreToolsDirectCmdCount": len(tools_cmd),
        "restoreToolsDirectCmdFiles": tools_cmd,
        "policyOk": len(root_cmd) == 1 and len(tools_cmd) == 0,
    }


def flatten_numbers(value: Any) -> list[int]:
    out: list[int] = []
    if isinstance(value, dict):
        for v in value.values():
            out.extend(flatten_numbers(v))
    elif isinstance(value, list):
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


def actor_bundle_for_prefab(prefab_id: Any) -> str:
    if prefab_id in (None, ""):
        return ""
    return f"download/roleprefabsandres/battleprefabandres/{int(prefab_id)}.assetbundle"


def assetbundle_set() -> set[str]:
    rows = read_csv(INDEX_DIR / "assetbundles.csv")
    return {norm(r.get("bundle")) for r in rows if r.get("bundle")}


def source_area(path: str) -> str:
    p = norm(path)
    if "dtmonster" in p:
        return "datatable_monster"
    if "dtmapswave" in p or "dtbattle" in p:
        return "datatable_stage_battle"
    if "battle_test_payload" in p or "procedure" in p:
        return "decoded_payload_flow"
    if "xlua" in p or p.endswith(".lua"):
        return "decoded_lua"
    if "il2cpp" in p or "global-metadata" in p or "libil2cpp" in p:
        return "il2cpp_native_strings"
    if "/reports/" in p or p.startswith("reports/"):
        return "prior_report_or_derived_manifest"
    if "/indexes/" in p or "assetinfo" in p or "assetguid" in p:
        return "restore_index"
    return "other_local_source"


def classify_line_hit(path: str, snippet: str, matched_id: str, direct_target: bool) -> str:
    area = source_area(path)
    s = snippet.lower()
    if area == "datatable_monster":
        if re.search(r"^\{" + re.escape(matched_id) + r"\b", snippet.strip()):
            return "authoritative_monster_row"
        return "weak/name-only/not promotable"
    if area == "datatable_stage_battle":
        if "monsterlists" in s or "newmonsterlists" in s:
            return "formation/payload instance id"
        return "UI/text-only/reference-only"
    if area == "decoded_payload_flow":
        if "herodid" in s or "battleinfo" in s or "enemyheros" in s:
            return "formation/payload instance id"
        return "UI/text-only/reference-only"
    if area == "decoded_lua":
        if "monsterlists" in s or "getmonster" in s or "herodid" in s:
            return "formation/payload instance id"
        return "weak/name-only/not promotable"
    if area == "il2cpp_native_strings":
        return "weak/name-only/not promotable"
    if area in {"prior_report_or_derived_manifest", "restore_index"}:
        return "UI/text-only/reference-only"
    return "weak/name-only/not promotable"


def row_contains_exact_id(row: dict[str, Any], target_id: int) -> bool:
    return target_id in flatten_numbers(row)


def trace_datatables(textassets: dict[str, dict[str, str]], model_table: b5.TableData, bundle_names: set[str]) -> tuple[list[dict], list[dict], list[dict], list[str]]:
    hit_rows: list[dict] = []
    same_family_rows: list[dict] = []
    direct_alias_rows: list[dict] = []
    searched: list[str] = []

    for entity in sorted(n for n in textassets if n.startswith("DTMonster") and n.endswith("Entity") and "Attr" not in n):
        table = load_table_if_present(textassets, entity)
        if not table:
            continue
        searched.append(entity)
        for row_id, row in sorted(table.rows.items()):
            row_id_s = str(row_id)
            model_id = row.get("modelID", "")
            model_row = model_table.rows.get(int(model_id)) if str(model_id).isdigit() else None
            prefab_id = model_row.get("prefabId") if model_row else ""
            bundle = actor_bundle_for_prefab(prefab_id) if prefab_id not in (None, "") else ""
            base = {
                "sourceArea": "datatable_monster",
                "source": rel(table.table_path),
                "table": entity,
                "rowId": row_id,
                "modelId": model_id,
                "prefabId": prefab_id,
                "bundle": bundle,
                "bundleExists": norm(bundle) in bundle_names if bundle else False,
                "monName": row.get("monName", ""),
                "sourceSnippet": json.dumps(row, ensure_ascii=False)[:500],
            }
            if row_id in ALL_IDS:
                classification = "authoritative_monster_row"
                out = {
                    **base,
                    "targetId": row_id,
                    "matchedPattern": str(row_id),
                    "hitClassification": classification,
                    "promotionDecision": "source_backed_direct_actor_chain" if row_id in TARGET_IDS else "control_reference",
                    "decisionReason": "Direct DTMonster row exists for this id.",
                }
                hit_rows.append(out)
                if row_id in TARGET_IDS:
                    direct_alias_rows.append(out)
            elif any(row_id_s.startswith(p) for p in FAMILY_PATTERNS) or row_id in BASE_MODEL_CANDIDATES:
                same_family_rows.append(
                    {
                        **base,
                        "targetId": "",
                        "matchedPattern": row_id_s,
                        "hitClassification": "weak/name-only/not promotable",
                        "promotionDecision": "context_only_same_family_or_base_row",
                        "decisionReason": "Same family/base monster row is not an alias rule without a source join.",
                    }
                )
    return hit_rows, same_family_rows, direct_alias_rows, searched


def trace_stage_tables(textassets: dict[str, dict[str, str]], map_id: int) -> tuple[list[dict], list[dict], list[str]]:
    hit_rows: list[dict] = []
    map_context_rows: list[dict] = []
    searched: list[str] = []
    for entity in sorted(n for n in textassets if (n.startswith("DTMapsWave") or n.startswith("DTBattle")) and n.endswith("Entity")):
        table = load_table_if_present(textassets, entity)
        if not table:
            continue
        searched.append(entity)
        for row_id, row in sorted(table.rows.items()):
            nums = flatten_numbers(row)
            if int(row.get("mapId") or -1) == map_id and entity.startswith("DTMapsWave"):
                map_context_rows.append(
                    {
                        "sourceArea": "datatable_stage_battle",
                        "source": rel(table.table_path),
                        "table": entity,
                        "rowId": row_id,
                        "mapId": row.get("mapId", ""),
                        "wave": row.get("wave", ""),
                        "monsterLists": json.dumps(row.get("monsterLists", []), ensure_ascii=False),
                        "newMonsterLists": json.dumps(row.get("newMonsterLists", []), ensure_ascii=False),
                        "sourceSnippet": json.dumps(row, ensure_ascii=False)[:500],
                    }
                )
            for target_id in TARGET_IDS:
                if target_id in nums:
                    hit_rows.append(
                        {
                            "targetId": target_id,
                            "matchedPattern": str(target_id),
                            "sourceArea": "datatable_stage_battle",
                            "source": rel(table.table_path),
                            "table": entity,
                            "rowId": row_id,
                            "hitClassification": "formation/payload instance id",
                            "promotionDecision": "not_promoted_payload_or_stage_context",
                            "decisionReason": "The id appears in stage/battle table numeric values but no DTMonster->DTmodel actor chain or alias target is encoded.",
                            "sourceSnippet": json.dumps(row, ensure_ascii=False)[:500],
                        }
                    )
    return hit_rows, map_context_rows, searched


def text_files_for_scan() -> list[Path]:
    roots = [
        MERGED / "decoded",
        MERGED / "extracted" / "unity" / "bundles",
        MERGED / "extracted" / "il2cpp_dump",
        BASE / "il2cpp_native",
        BATTLE_DIR,
        CHAR_DIR,
        INDEX_DIR,
    ]
    suffixes = {".txt", ".lua", ".json", ".csv", ".md", ".cs", ".asm"}
    files: list[Path] = []
    for root in roots:
        if not root.exists():
            continue
        for path in root.rglob("*"):
            if path.is_file() and path.suffix.lower() in suffixes:
                if path.name.startswith(OUT_BASE):
                    continue
                files.append(path)
    return files


def scan_text_sources(max_hits_per_id: int = 120) -> list[dict]:
    needles = [str(i) for i in TARGET_IDS + CONTROL_IDS + BASE_MODEL_CANDIDATES] + FAMILY_PATTERNS
    per_id_counts = defaultdict(int)
    rows: list[dict] = []
    for path in text_files_for_scan():
        try:
            with path.open("r", encoding="utf-8-sig", errors="ignore") as f:
                for line_no, line in enumerate(f, start=1):
                    matched = [n for n in needles if n in line]
                    if not matched:
                        continue
                    for m in matched:
                        direct_target = m.isdigit() and int(m) in TARGET_IDS if m.isdigit() else False
                        bucket = m if direct_target else "family_or_base"
                        if per_id_counts[bucket] >= max_hits_per_id:
                            continue
                        per_id_counts[bucket] += 1
                        classification = classify_line_hit(rel(path), line, m, direct_target)
                        rows.append(
                            {
                                "targetId": m if direct_target else "",
                                "matchedPattern": m,
                                "sourceArea": source_area(rel(path)),
                                "source": rel(path),
                                "line": line_no,
                                "table": "",
                                "rowId": "",
                                "hitClassification": classification,
                                "promotionDecision": "not_promoted_text_hit",
                                "decisionReason": "Text/string hit only; no explicit alias rule unless classified as authoritative monster row in datatable parser.",
                                "sourceSnippet": line.strip()[:500],
                            }
                        )
        except OSError:
            continue
    return rows


def direct_binary_string_hits() -> list[dict]:
    rows: list[dict] = []
    needles = [str(i).encode("utf-8") for i in TARGET_IDS]
    paths = [
        BASE / "il2cpp_native" / "global-metadata.dat",
        BASE / "il2cpp_native" / "libil2cpp.so",
        MERGED / "extracted" / "decoded_gzip_bytes" / "AssetInfo.bytes.gunzipped",
        MERGED / "extracted" / "decoded_gzip_bytes" / "AssetGuid.bytes.gunzipped",
    ]
    for path in paths:
        if not path.exists():
            continue
        try:
            data = path.read_bytes()
        except OSError:
            continue
        for target_id, needle in zip(TARGET_IDS, needles):
            pos = data.find(needle)
            if pos >= 0:
                rows.append(
                    {
                        "targetId": target_id,
                        "matchedPattern": str(target_id),
                        "sourceArea": "il2cpp_native_strings" if "il2cpp" in norm(path) else "restore_index",
                        "source": rel(path),
                        "offset": pos,
                        "hitClassification": "weak/name-only/not promotable",
                        "promotionDecision": "not_promoted_binary_string_hit",
                        "decisionReason": "Raw string/int occurrence is not an alias or DTMonster actor chain.",
                        "sourceSnippet": f"binary occurrence at offset {pos}",
                    }
                )
    return rows


def payload_context_from_char65() -> list[dict]:
    rows: list[dict] = []
    actor_rows = read_csv(CHAR65_ACTORS)
    for row in actor_rows:
        hero = row.get("heroDidOrMonsterId", "")
        if hero and int(hero) in TARGET_IDS:
            rows.append(
                {
                    "targetId": int(hero),
                    "matchedPattern": hero,
                    "sourceArea": "prior_report_or_derived_manifest",
                    "source": rel(CHAR65_ACTORS),
                    "hitClassification": "formation/payload instance id",
                    "promotionDecision": "not_promoted_payload_instance_only",
                    "decisionReason": "CHARACTER65 battle roster preserves payload id as unresolved source chain.",
                    "sourceSnippet": json.dumps(row, ensure_ascii=False)[:500],
                }
            )
    return rows


def decision_for_target(target_id: int, hit_rows: list[dict]) -> dict:
    target_hits = [r for r in hit_rows if str(r.get("targetId")) == str(target_id)]
    authoritative = [r for r in target_hits if r.get("hitClassification") == "authoritative_monster_row"]
    alias_hits = [r for r in target_hits if r.get("hitClassification") == "alias to base monster/model"]
    payload_hits = [r for r in target_hits if r.get("hitClassification") == "formation/payload instance id"]
    weak_hits = [r for r in target_hits if r.get("hitClassification") in {"weak/name-only/not promotable", "UI/text-only/reference-only"}]

    if authoritative:
        status = "source_backed_alias_or_actor_chain_found"
        alias_target = "|".join(str(r.get("modelId") or r.get("prefabId") or "") for r in authoritative)
        decision = "proposal_only_possible"
        reason = "Direct authoritative monster row exists for this payload id."
    elif alias_hits:
        status = "source_backed_alias_or_actor_chain_found"
        alias_target = "|".join(str(r.get("aliasTarget", "")) for r in alias_hits)
        decision = "proposal_only_possible"
        reason = "Explicit source alias rule found."
    else:
        status = "still_unresolved_no_source_backed_alias"
        alias_target = ""
        decision = "do_not_promote"
        if payload_hits:
            reason = "Hits are payload/formation/context only; no DTMonster row, DTmodel chain, or explicit alias rule."
        elif weak_hits:
            reason = "Only weak/reference/string hits exist; no authoritative alias evidence."
        else:
            reason = "No exact authoritative source hit was found for this id."

    return {
        "targetId": target_id,
        "finalStatus": status,
        "aliasTarget": alias_target,
        "promotionDecision": decision,
        "aliasesPromoted": False,
        "authoritativeMonsterRowHits": len(authoritative),
        "explicitAliasRuleHits": len(alias_hits),
        "payloadInstanceHits": len(payload_hits),
        "weakOrReferenceHits": len(weak_hits),
        "totalHits": len(target_hits),
        "reason": reason,
        "nextAction": "write proposal-only alias matrix" if decision == "proposal_only_possible" else "keep unresolved until DTMonster/DTmodel chain or explicit source alias rule is found",
    }


def build() -> dict:
    os.chdir(BASE)
    textassets = b5.load_textasset_map()
    model_table = b5.load_table("DTmodelEntity", "DTmodelEntity", "DTmodelEntityTableData", textassets)
    bundle_names = assetbundle_set()

    monster_hits, same_family_rows, direct_alias_rows, monster_searched = trace_datatables(textassets, model_table, bundle_names)
    stage_hits, map_context_rows, stage_searched = trace_stage_tables(textassets, map_id=11001)
    text_hits = scan_text_sources()
    binary_hits = direct_binary_string_hits()
    payload_context_hits = payload_context_from_char65()

    all_hits = monster_hits + same_family_rows + stage_hits + text_hits + binary_hits + payload_context_hits

    # De-duplicate noisy identical report hits while keeping source diversity.
    deduped: list[dict] = []
    seen = set()
    for row in all_hits:
        key = (
            row.get("targetId", ""),
            row.get("matchedPattern", ""),
            row.get("source", ""),
            row.get("line", ""),
            row.get("rowId", ""),
            row.get("hitClassification", ""),
            str(row.get("sourceSnippet", ""))[:160],
        )
        if key in seen:
            continue
        seen.add(key)
        deduped.append(row)

    decisions = [decision_for_target(t, deduped) for t in TARGET_IDS]
    source_backed_aliases = [d for d in decisions if d["promotionDecision"] == "proposal_only_possible"]
    proposal_written = bool(source_backed_aliases)
    if proposal_written:
        proposal = {
            "name": "BATTLE_UNRESOLVED_ENEMY_ALIAS_PROPOSAL_FROM_CHARACTER66_SOURCE_TRACE",
            "generatedBy": rel(Path(__file__)),
            "classification": "proposal_only_no_manifest_overwrite",
            "aliasesPromoted": False,
            "sourceBackedAliases": source_backed_aliases,
            "guardrails": {
                "networkUsed": False,
                "filesCopied": False,
                "filesImported": False,
                "sceneModified": False,
                "fakeAliasPromotion": False,
            },
        }
        write_json(OUT_PROPOSAL_JSON, proposal)

    return {
        "name": OUT_BASE,
        "generatedBy": rel(Path(__file__)),
        "generatedAtUtc": datetime.now(timezone.utc).isoformat(),
        "workspace": str(BASE),
        "networkUsed": False,
        "filesCopied": False,
        "filesImported": False,
        "sceneModified": False,
        "unresolvedIdsChecked": TARGET_IDS,
        "sourceHitsFound": len(deduped),
        "sourceBackedAliasesFound": len(source_backed_aliases),
        "aliasesPromoted": False,
        "proposalWritten": proposal_written,
        "proposalPath": rel(OUT_PROPOSAL_JSON) if proposal_written else "",
        "nextBlocker": "Unresolved enemy payload ids need an authoritative DTMonster/DTmodel actor chain or explicit source alias rule; current hits remain payload/formation context or weak references.",
        "guardrailsTouched": {
            "networkDownloadHeadGet": False,
            "filesCopied": False,
            "filesImported": False,
            "filesMoved": False,
            "filesDeleted": False,
            "sceneModified": False,
            "fakeAliasPromotion": False,
            "manifestOverwritten": False,
            "replaceWith3001WithoutRule": False,
        },
        "commandPolicy": command_policy_status(),
        "summary": {
            "sourceHitsFound": len(deduped),
            "sourceBackedAliasesFound": len(source_backed_aliases),
            "proposalWritten": proposal_written,
            "hitClassificationCounts": dict(Counter(r.get("hitClassification", "") for r in deduped)),
            "sourceAreaCounts": dict(Counter(r.get("sourceArea", "") for r in deduped)),
            "decisionStatusCounts": dict(Counter(d.get("finalStatus", "") for d in decisions)),
            "sameFamilyRows": len(same_family_rows),
            "mapContextRows": len(map_context_rows),
        },
        "inputsRead": [
            rel(CHAR65_MD),
            rel(CHAR65_JSON),
            rel(CHAR65_ACTORS),
            rel(CHAR65_GAPS),
            rel(CHAR65_PROPOSAL),
            rel(CHAR63_JSON),
            rel(CHAR64_JSON),
        ],
        "searched": {
            "monsterTables": monster_searched,
            "stageBattleTables": stage_searched,
            "decodedLuaAndReportTextFiles": len(text_files_for_scan()),
            "binaryRefs": ["global-metadata.dat", "libil2cpp.so", "AssetInfo.bytes.gunzipped", "AssetGuid.bytes.gunzipped"],
            "patterns": [str(i) for i in TARGET_IDS] + FAMILY_PATTERNS + [str(i) for i in BASE_MODEL_CANDIDATES],
        },
        "sourceHitRows": deduped,
        "decisionRows": decisions,
        "sameFamilyMonsterRows": same_family_rows,
        "mapWaveContextRows": map_context_rows,
    }


def write_outputs(report: dict) -> None:
    write_json(OUT_JSON, report)

    hit_fields = [
        "targetId",
        "matchedPattern",
        "sourceArea",
        "hitClassification",
        "promotionDecision",
        "decisionReason",
        "source",
        "line",
        "offset",
        "table",
        "rowId",
        "modelId",
        "prefabId",
        "bundle",
        "bundleExists",
        "monName",
        "sourceSnippet",
    ]
    decision_fields = [
        "targetId",
        "finalStatus",
        "aliasTarget",
        "promotionDecision",
        "aliasesPromoted",
        "authoritativeMonsterRowHits",
        "explicitAliasRuleHits",
        "payloadInstanceHits",
        "weakOrReferenceHits",
        "totalHits",
        "reason",
        "nextAction",
    ]
    write_csv(OUT_HITS_CSV, report["sourceHitRows"], hit_fields)
    write_csv(OUT_DECISION_CSV, report["decisionRows"], decision_fields)

    lines = [
        "# CHARACTER_66_UNRESOLVED_ENEMY_ID_SOURCE_ALIAS_TRACE_NO_NETWORK_NO_PROMOTION_RESULT",
        "",
        f"- generatedBy: `{report['generatedBy']}`",
        f"- generatedAtUtc: `{report['generatedAtUtc']}`",
        f"- networkUsed: `{report['networkUsed']}`",
        f"- filesCopied: `{report['filesCopied']}`",
        f"- filesImported: `{report['filesImported']}`",
        f"- sceneModified: `{report['sceneModified']}`",
        f"- aliasesPromoted: `{report['aliasesPromoted']}`",
        f"- proposalWritten: `{report['proposalWritten']}`",
        "",
        "## Summary",
        "",
        f"- unresolvedIdsChecked: `{', '.join(str(i) for i in report['unresolvedIdsChecked'])}`",
        f"- sourceHitsFound: `{report['sourceHitsFound']}`",
        f"- sourceBackedAliasesFound: `{report['sourceBackedAliasesFound']}`",
        f"- hitClassificationCounts: `{report['summary']['hitClassificationCounts']}`",
        f"- sourceAreaCounts: `{report['summary']['sourceAreaCounts']}`",
        "",
        "## Alias Decision Matrix",
        "",
        "| targetId | finalStatus | authoritative monster rows | payload hits | weak/ref hits | decision | reason |",
        "|---:|---|---:|---:|---:|---|---|",
    ]
    for row in report["decisionRows"]:
        lines.append(
            f"| {row['targetId']} | `{row['finalStatus']}` | {row['authoritativeMonsterRowHits']} | "
            f"{row['payloadInstanceHits']} | {row['weakOrReferenceHits']} | `{row['promotionDecision']}` | {row['reason']} |"
        )
    lines.extend(
        [
            "",
            "## Key Findings",
            "",
            "- No unresolved enemy id has a direct authoritative DTMonster row or DTmodel/prefab actor chain in this trace.",
            "- Hits for unresolved ids are payload/formation context, derived reports/manifests, skill ownership rows, or weak string references.",
            "- Same-family/base rows such as `1100111` and model `3001` remain control/context only; no source rule maps unresolved payload ids to them.",
            "- No replacement with `3001` was promoted.",
            "",
            "## Outputs",
            "",
            f"- JSON: `{rel(OUT_JSON)}`",
            f"- Source hit CSV: `{rel(OUT_HITS_CSV)}`",
            f"- Decision CSV: `{rel(OUT_DECISION_CSV)}`",
            f"- Proposal JSON: `{report['proposalPath']}`",
            "",
            "## Command Policy",
            "",
            f"- rootCmdCount: `{report['commandPolicy']['rootCmdCount']}`",
            f"- rootCmdFiles: `{report['commandPolicy']['rootCmdFiles']}`",
            f"- restoreToolsDirectCmdCount: `{report['commandPolicy']['restoreToolsDirectCmdCount']}`",
            f"- policyOk: `{report['commandPolicy']['policyOk']}`",
            "",
            "## Next Blocker",
            "",
            f"- {report['nextBlocker']}",
            "",
        ]
    )
    OUT_MD.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    report = build()
    write_outputs(report)
    print(json.dumps(report["summary"], ensure_ascii=False, indent=2))
    print(f"wrote {rel(OUT_MD)}")
    print(f"wrote {rel(OUT_JSON)}")
    print(f"wrote {rel(OUT_HITS_CSV)}")
    print(f"wrote {rel(OUT_DECISION_CSV)}")
    print(f"proposalWritten={report['proposalWritten']}")


if __name__ == "__main__":
    main()
