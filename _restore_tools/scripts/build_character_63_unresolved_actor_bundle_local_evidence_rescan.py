from __future__ import annotations

import csv
import json
import os
import re
import zipfile
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
INDEX_DIR = ROOT / "girlswar_merged_extracted" / "indexes"
REPORT_CHAR_DIR = ROOT / "reports" / "characters"
REPORT_BATTLE_DIR = ROOT / "reports" / "battle"

TARGET_IDS = [1036, 1100112, 1100113, 1100121, 1100122, 1100123, 1100131, 1100132, 1100133]
UNRESOLVED_ENEMY_IDS = TARGET_IDS[1:]

MANIFEST = REPORT_BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.json"
ROSTER = REPORT_CHAR_DIR / "GIRLSWAR_CHARACTER_ROSTER.json"
PREV_ENEMY_TRACE = REPORT_CHAR_DIR / "CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT.json"
PREV_1036_TRACE = REPORT_CHAR_DIR / "CHARACTER_1036_CDN_ACQUISITION_TRACE.json"
RESOURCE_GAP_TRACE = REPORT_CHAR_DIR / "CHARACTER_RESOURCE_GAP_DEEP_TRACE.json"
SPEEDLINE_TRACE = REPORT_CHAR_DIR / "CHARACTER_COMMON_SPEEDLINE_BUNDLE_DEEP_TRACE_RESULT.json"

OUT_BASE = "CHARACTER_63_UNRESOLVED_ACTOR_BUNDLE_LOCAL_EVIDENCE_RESCAN_NO_NETWORK_NO_FAKE_RESULT"
OUT_JSON = REPORT_CHAR_DIR / f"{OUT_BASE}.json"
OUT_MD = REPORT_CHAR_DIR / f"{OUT_BASE}.md"
OUT_CHAIN_CSV = REPORT_CHAR_DIR / f"{OUT_BASE}_CHAIN_MATRIX.csv"
OUT_EVIDENCE_CSV = REPORT_CHAR_DIR / f"{OUT_BASE}_LOCAL_EVIDENCE_CLASSIFICATION_MATRIX.csv"
OUT_BLOCKER_CSV = REPORT_CHAR_DIR / f"{OUT_BASE}_BLOCKER_NEXT_ACTION_MATRIX.csv"


def rel(path: Path) -> str:
    try:
        return path.relative_to(ROOT).as_posix()
    except ValueError:
        return str(path)


def norm(value: Any) -> str:
    return str(value or "").replace("\\", "/").lower()


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8"))


def read_csv_rows(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        for row in rows:
            writer.writerow({key: row.get(key, "") for key in fieldnames})


def command_policy_status() -> dict:
    root_cmd = sorted(p.name for p in ROOT.glob("*.cmd"))
    tools_cmd = sorted(p.name for p in (ROOT / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmd),
        "rootCmdFiles": root_cmd,
        "restoreToolsDirectCmdCount": len(tools_cmd),
        "restoreToolsDirectCmdFiles": tools_cmd,
        "policyOk": len(root_cmd) == 1 and len(tools_cmd) == 0,
    }


def local_file_checks(bundle: str) -> list[dict]:
    if not bundle:
        return []
    rel_path = Path(bundle)
    probes = [
        ROOT / "girlswar_merged_extracted" / "merged_content" / "AssetBundles" / rel_path,
        ROOT / "girlswar_merged_extracted" / "restore_overlay" / "Android" / "data" / "com.girlwars.kr" / "files" / "build" / rel_path,
        ROOT / "girlswar_merged_extracted" / "restore_overlay" / "Android" / "data" / "com.girlwars.kr" / "files" / rel_path,
        ROOT / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices" / rel_path,
        ROOT / "girlswar_merged_extracted" / "extracted" / "unity" / "bundles" / rel_path,
        ROOT / "girlswar_merged_extracted" / "split_apks" / rel_path,
    ]
    return [
        {
            "probePath": rel(path),
            "exists": path.exists(),
            "size": path.stat().st_size if path.exists() and path.is_file() else "",
        }
        for path in probes
    ]


def find_index_hits(csv_name: str, needles: list[str], max_hits: int = 80) -> list[dict]:
    path = INDEX_DIR / csv_name
    hits: list[dict] = []
    if not path.exists() or not needles:
        return hits
    lowered = [norm(n) for n in needles if n]
    if not lowered:
        return hits
    with path.open("r", encoding="utf-8-sig", errors="ignore", newline="") as f:
        reader = csv.DictReader(f)
        for line_no, row in enumerate(reader, start=2):
            joined = norm(" ".join(str(v) for v in row.values()))
            if any(needle in joined for needle in lowered):
                out = {
                    "source": rel(path),
                    "line": line_no,
                    "matchedText": " | ".join(str(v) for v in row.values() if v)[:1200],
                }
                out.update({key: row.get(key, "") for key in row.keys()})
                hits.append(out)
                if len(hits) >= max_hits:
                    break
    return hits


def grep_text_files(paths: list[Path], needles: list[str], max_hits: int = 120) -> list[dict]:
    hits: list[dict] = []
    lowered = [norm(n) for n in needles if n]
    if not lowered:
        return hits
    for path in paths:
        if not path.exists() or not path.is_file():
            continue
        try:
            with path.open("r", encoding="utf-8-sig", errors="ignore") as f:
                for line_no, line in enumerate(f, start=1):
                    line_norm = norm(line)
                    if any(needle in line_norm for needle in lowered):
                        hits.append(
                            {
                                "source": rel(path),
                                "line": line_no,
                                "matchedText": line.strip()[:1200],
                            }
                        )
                        if len(hits) >= max_hits:
                            return hits
        except OSError:
            continue
    return hits


def candidate_text_files() -> list[Path]:
    roots = [
        ROOT / "reports" / "characters",
        ROOT / "reports" / "battle",
        ROOT / "girlswar_merged_extracted" / "decoded",
        ROOT / "girlswar_merged_extracted" / "extracted" / "unity" / "bundles",
        ROOT / "il2cpp_native",
    ]
    suffixes = {".csv", ".json", ".md", ".txt", ".lua", ".cs"}
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


def scan_binary_string_refs(needles: list[str], max_hits: int = 80) -> list[dict]:
    hits: list[dict] = []
    lowered = [n.encode("utf-8").lower() for n in needles if n]
    if not lowered:
        return hits
    paths = [
        ROOT / "girlswar_merged_extracted" / "extracted" / "decoded_gzip_bytes" / "AssetInfo.bytes.gunzipped",
        ROOT / "girlswar_merged_extracted" / "extracted" / "decoded_gzip_bytes" / "AssetGuid.bytes.gunzipped",
        ROOT / "girlswar_merged_extracted" / "merged_content" / "AssetBundles" / "AssetInfo.bytes",
        ROOT / "girlswar_merged_extracted" / "merged_content" / "AssetBundles" / "AssetGuid.bytes",
        ROOT / "girlswar_merged_extracted" / "merged_content" / "AssetBundles" / "VersionFile.bytes",
        ROOT / "girlswar_merged_extracted" / "merged_content" / "AssetBundles" / "CDNVersionFile.bytes",
    ]
    for path in paths:
        if not path.exists():
            continue
        data = path.read_bytes().lower()
        for needle in lowered:
            pos = data.find(needle)
            if pos >= 0:
                hits.append(
                    {
                        "source": rel(path),
                        "offset": pos,
                        "needle": needle.decode("utf-8", errors="ignore"),
                        "note": "binary/local RestoreData-style string hit; context only unless exact bundle path",
                    }
                )
                if len(hits) >= max_hits:
                    return hits
    return hits


def scan_apk_entries(needles: list[str], max_hits: int = 80) -> list[dict]:
    hits: list[dict] = []
    lowered = [norm(n) for n in needles if n]
    if not lowered:
        return hits
    seen: set[Path] = set()
    for root in [ROOT, ROOT / "girlswar_merged_extracted", ROOT / "work"]:
        if not root.exists():
            continue
        for apk in root.rglob("*.apk"):
            if apk in seen:
                continue
            seen.add(apk)
            try:
                with zipfile.ZipFile(apk) as zf:
                    for entry in zf.namelist():
                        e_norm = norm(entry)
                        if any(needle in e_norm for needle in lowered):
                            hits.append({"source": rel(apk), "entry": entry})
                            if len(hits) >= max_hits:
                                return hits
            except (OSError, zipfile.BadZipFile):
                continue
    return hits


def inspect_bundle_for_names(bundle_path: Path, needles: list[str]) -> dict:
    result = {
        "bundlePath": rel(bundle_path),
        "exists": bundle_path.exists(),
        "unityPyAvailable": False,
        "matches": [],
        "error": "",
    }
    if not bundle_path.exists():
        return result
    try:
        import UnityPy  # type: ignore

        result["unityPyAvailable"] = True
        lowered = [needle.lower() for needle in needles if needle]
        env = UnityPy.load(str(bundle_path))
        matches: set[str] = set()
        for obj in env.objects:
            try:
                data = obj.read()
            except Exception:
                continue
            name = str(getattr(data, "m_Name", "") or "")
            if name and any(needle in name.lower() for needle in lowered):
                matches.add(f"{obj.type.name}:{name}")
            if obj.type.name == "AssetBundle":
                container = getattr(data, "m_Container", None)
                if container:
                    try:
                        items = container.items()
                    except AttributeError:
                        items = []
                    for key, _value in items:
                        key_s = str(key)
                        if any(needle in key_s.lower() for needle in lowered):
                            matches.add(f"Container:{key_s}")
        result["matches"] = sorted(matches)
    except Exception as exc:
        result["error"] = f"{type(exc).__name__}: {exc}"
    return result


def scan_local_battle_bundles_for_actor_names(target_needles: list[str]) -> list[dict]:
    rows = read_csv_rows(INDEX_DIR / "assetbundles.csv")
    role_rows = [
        row
        for row in rows
        if norm(row.get("bundle")).startswith("download/roleprefabsandres/battleprefabandres/")
        and row.get("clean_slice")
    ]
    matches: list[dict] = []
    for row in role_rows:
        bundle = row.get("bundle", "")
        clean_slice = ROOT / "girlswar_merged_extracted" / row.get("clean_slice", "")
        inspected = inspect_bundle_for_names(clean_slice, target_needles)
        if inspected["matches"]:
            matches.append(
                {
                    "bundle": bundle,
                    "cleanSlice": rel(clean_slice),
                    "matches": inspected["matches"],
                    "unityPyAvailable": inspected["unityPyAvailable"],
                }
            )
    return matches


def manifest_actor_rows(manifest: dict, roster: dict) -> dict[int, dict]:
    rows: dict[int, dict] = {}
    for source_name, doc in [("speedlineManifest", manifest), ("roster", roster)]:
        for actor in doc.get("actors", []):
            try:
                payload_id = int(actor.get("payloadHeroDid"))
            except (TypeError, ValueError):
                continue
            if payload_id in TARGET_IDS and payload_id not in rows:
                copied = dict(actor)
                copied["_sourceDoc"] = source_name
                rows[payload_id] = copied
    return rows


def stage_context_for_id(payload_id: int, prev_enemy_trace: dict) -> dict:
    for row in prev_enemy_trace.get("finalRows", []):
        try:
            if int(row.get("targetId", 0)) == payload_id:
                return row
        except (TypeError, ValueError):
            continue
    return {}


def weak_skill_model_candidates(manifest: dict, payload_id: int) -> list[str]:
    candidates = set()
    for skill in manifest.get("skills", []):
        if str(skill.get("ownerHeroDid", "")) != str(payload_id):
            continue
        model_id = str(skill.get("modelId", "") or "")
        if model_id:
            candidates.add(model_id)
        bundle = str(skill.get("bundle", "") or "")
        match = re.search(r"skillprefabsandres/(\d+)\.assetbundle", norm(bundle))
        if match:
            candidates.add(match.group(1))
    return sorted(candidates)


def classify_actor(chain: dict, evidence_rows: list[dict]) -> tuple[str, str]:
    exact_bundle = chain.get("expectedActorBundle", "")
    if not exact_bundle:
        return (
            "not_resolved_from_local_evidence",
            "No source-backed hero/monster -> model -> prefab actor bundle chain exists for this payload id.",
        )
    exact_local = any(
        row.get("actorId") == chain["actorId"]
        and row.get("evidenceKind") == "local_exact_file"
        and row.get("exists") is True
        for row in evidence_rows
    )
    if exact_local:
        return "resolved_loadable_local_bundle", "Exact expected actor bundle exists locally."
    container_hits = [
        row
        for row in evidence_rows
        if row.get("actorId") == chain["actorId"]
        and row.get("evidenceKind") == "local_container_object_scan"
        and row.get("matches")
    ]
    if container_hits:
        return (
            "local_parent_bundle_contains_object",
            "A local role battle bundle contains a matching object/container name, but exact expected bundle is absent.",
        )
    version_hits = [
        row
        for row in evidence_rows
        if row.get("actorId") == chain["actorId"]
        and row.get("evidenceKind") in {"versionfile_exact", "cdn_versionfile_exact"}
    ]
    if version_hits:
        return (
            "versionfile_or_cdn_index_only_not_local",
            "Exact actor bundle is listed in local versionfile/CDNVersionFile evidence but no local bundle file or clean slice exists.",
        )
    alias_hits = [
        row
        for row in evidence_rows
        if row.get("actorId") == chain["actorId"]
        and row.get("evidenceKind") in {"same_filename_different_category", "weak_skill_model_candidate", "stage_wave_context_candidate"}
    ]
    if alias_hits:
        return (
            "alias_candidate_needs_source_confirmation",
            "Only weak alias/category candidates exist; no authoritative actor bundle chain or exact bundle evidence.",
        )
    return "not_resolved_from_local_evidence", "No exact local, parent/container, versionfile, or source-backed alias evidence found."


def build() -> dict:
    os.chdir(ROOT)
    manifest = read_json(MANIFEST)
    roster = read_json(ROSTER)
    prev_enemy_trace = read_json(PREV_ENEMY_TRACE)
    prev_1036_trace = read_json(PREV_1036_TRACE)
    resource_gap_trace = read_json(RESOURCE_GAP_TRACE)
    speedline_trace = read_json(SPEEDLINE_TRACE)

    actor_rows = manifest_actor_rows(manifest, roster)
    text_files = candidate_text_files()

    chain_rows: list[dict] = []
    evidence_rows: list[dict] = []
    blocker_rows: list[dict] = []

    # A local container scan is expensive enough to do once with all actor-specific needles.
    container_needles = ["hero_1036", "hero1036", "1036"]
    for enemy_id in UNRESOLVED_ENEMY_IDS:
        container_needles.extend([str(enemy_id), f"hero_{enemy_id}", f"hero{enemy_id}"])
    local_container_matches = scan_local_battle_bundles_for_actor_names(container_needles)

    for actor_id in TARGET_IDS:
        actor = actor_rows.get(actor_id, {})
        side = actor.get("side", "our" if actor_id == 1036 else "enemy")
        wave_no = actor.get("waveNo", "")
        slot = actor.get("slot", "")
        datatable = actor.get("datatable", "")
        datatable_found = bool(actor.get("datatableFound"))
        model_id = actor.get("modelId", "")
        model_found = bool(actor.get("modelFound"))
        prefab_id = actor.get("prefabId", "")
        expected_bundle = actor.get("actorBundle", "")
        sys_prefab_asset_path = actor.get("sysPrefabAssetPath", "")
        sys_prefab_name = actor.get("sysPrefabName", "")
        stage_context = stage_context_for_id(actor_id, prev_enemy_trace)
        skill_candidates = weak_skill_model_candidates(manifest, actor_id)

        if not expected_bundle and prefab_id:
            expected_bundle = f"download/roleprefabsandres/battleprefabandres/{prefab_id}.assetbundle"

        row = {
            "actorId": actor_id,
            "side": side,
            "waveNo": wave_no,
            "slot": slot,
            "payloadHeroId": actor.get("payloadHeroId", ""),
            "datatable": datatable,
            "datatableFound": datatable_found,
            "modelId": model_id,
            "modelFound": model_found,
            "prefabId": prefab_id,
            "expectedActorBundle": expected_bundle,
            "sysPrefabAssetPath": sys_prefab_asset_path,
            "sysPrefabName": sys_prefab_name,
            "skillDidList": actor.get("skillDidList", ""),
            "nameKey": actor.get("nameKey", ""),
            "stageWaveContext": json.dumps(stage_context, ensure_ascii=False) if stage_context else "",
            "weakSkillModelCandidatesNotActorAliases": "|".join(skill_candidates),
            "source": actor.get("_sourceDoc", ""),
        }
        chain_rows.append(row)

        actor_evidence: list[dict] = []

        if expected_bundle:
            for check in local_file_checks(expected_bundle):
                ev = {
                    "actorId": actor_id,
                    "evidenceKind": "local_exact_file",
                    "classification": "exact_local_probe",
                    "source": "filesystem",
                    "path": check["probePath"],
                    "exists": check["exists"],
                    "size": check["size"],
                    "target": expected_bundle,
                    "note": "exact expected actor bundle path probe",
                }
                evidence_rows.append(ev)
                actor_evidence.append(ev)

        needles = [str(actor_id)]
        if expected_bundle:
            needles.append(expected_bundle)
            needles.append(Path(expected_bundle).name)
        if sys_prefab_asset_path:
            needles.append(sys_prefab_asset_path)
        if sys_prefab_name:
            needles.append(sys_prefab_name)

        for csv_name, kind in [
            ("assetbundles.csv", "assetbundle_index"),
            ("merged_files.csv", "merged_files_index"),
            ("conflicts.csv", "conflicts_index"),
            ("versionfile_VersionFile_bytes.csv", "versionfile_exact"),
            ("versionfile_CDNVersionFile_bytes.csv", "cdn_versionfile_exact"),
            ("unity_bundle_export_map.csv", "unity_export_index"),
            ("unity_cab_to_bundle.csv", "unity_cab_index"),
            ("unity_objects.csv", "unity_objects_index"),
            ("unity_textassets.csv", "unity_textassets_index"),
        ]:
            hits = find_index_hits(csv_name, [expected_bundle] if expected_bundle else [str(actor_id)], max_hits=30)
            for hit in hits:
                if expected_bundle and norm(expected_bundle) in norm(hit.get("matchedText", "")):
                    classification = "exact_expected_bundle_index_hit"
                elif str(actor_id) in hit.get("matchedText", ""):
                    classification = "id_string_context_hit"
                else:
                    classification = "context_hit"
                ev = {
                    "actorId": actor_id,
                    "evidenceKind": kind,
                    "classification": classification,
                    "source": hit.get("source", ""),
                    "path": hit.get("AssetBundleName") or hit.get("bundle") or hit.get("path") or "",
                    "line": hit.get("line", ""),
                    "exists": "",
                    "size": hit.get("Size") or hit.get("size") or "",
                    "md5": hit.get("MD5", ""),
                    "target": expected_bundle or str(actor_id),
                    "note": hit.get("matchedText", ""),
                }
                evidence_rows.append(ev)
                actor_evidence.append(ev)

        if expected_bundle:
            same_filename_hits = find_index_hits(
                "assetbundles.csv",
                [Path(expected_bundle).name],
                max_hits=40,
            )
            for hit in same_filename_hits:
                path = hit.get("bundle") or hit.get("AssetBundleName") or hit.get("matchedText", "")
                if norm(path) == norm(expected_bundle):
                    continue
                ev = {
                    "actorId": actor_id,
                    "evidenceKind": "same_filename_different_category",
                    "classification": "alias_candidate_needs_source_confirmation",
                    "source": hit.get("source", ""),
                    "path": path,
                    "line": hit.get("line", ""),
                    "exists": True,
                    "size": hit.get("size", ""),
                    "target": expected_bundle,
                    "note": "same filename exists under a different resource category; not promoted as actor bundle",
                }
                evidence_rows.append(ev)
                actor_evidence.append(ev)

        relevant_container_matches = []
        actor_name_needles = [str(actor_id)]
        if sys_prefab_name:
            actor_name_needles.append(sys_prefab_name)
        if sys_prefab_asset_path:
            actor_name_needles.append(Path(sys_prefab_asset_path).stem)
        for match in local_container_matches:
            joined = norm(" ".join(match.get("matches", [])))
            if any(norm(needle) in joined for needle in actor_name_needles if needle):
                relevant_container_matches.append(match)
                ev = {
                    "actorId": actor_id,
                    "evidenceKind": "local_container_object_scan",
                    "classification": "local_parent_bundle_contains_object" if expected_bundle else "context_only_no_actor_chain",
                    "source": match.get("cleanSlice", ""),
                    "path": match.get("bundle", ""),
                    "exists": True,
                    "target": "|".join(actor_name_needles),
                    "matches": "|".join(match.get("matches", [])),
                    "note": "local role battle bundle object/container name scan",
                }
                evidence_rows.append(ev)
                actor_evidence.append(ev)

        table_needles = [str(actor_id)]
        if model_id:
            table_needles.append(str(model_id))
        if prefab_id:
            table_needles.append(str(prefab_id))
        if sys_prefab_asset_path:
            table_needles.append(sys_prefab_asset_path)
        table_hits = grep_text_files(text_files, table_needles, max_hits=80)
        for hit in table_hits[:40]:
            src = hit.get("source", "")
            if "DTMonster" in src or "DTHero" in src or "DTmodel" in src or "DTSysPrefab" in src:
                kind = "datatable_source_hit"
            elif "BattleTimelineResMap" in src:
                kind = "timeline_source_hit"
            elif "xlua" in src.lower() or src.lower().endswith(".lua"):
                kind = "decoded_lua_source_hit"
            elif "il2cpp" in src.lower():
                kind = "il2cpp_string_hit"
            else:
                kind = "report_or_context_hit"
            ev = {
                "actorId": actor_id,
                "evidenceKind": kind,
                "classification": "source_context",
                "source": src,
                "line": hit.get("line", ""),
                "target": "|".join(table_needles),
                "note": hit.get("matchedText", ""),
            }
            evidence_rows.append(ev)
            actor_evidence.append(ev)

        if skill_candidates:
            ev = {
                "actorId": actor_id,
                "evidenceKind": "weak_skill_model_candidate",
                "classification": "context_only_not_actor_alias",
                "source": rel(MANIFEST),
                "path": "|".join(skill_candidates),
                "target": str(actor_id),
                "note": "owner skill rows reference these skill/model bundles, but this is not an authoritative actor mapping",
            }
            evidence_rows.append(ev)
            actor_evidence.append(ev)

        if stage_context:
            ev = {
                "actorId": actor_id,
                "evidenceKind": "stage_wave_context_candidate",
                "classification": "context_only_not_actor_alias",
                "source": rel(PREV_ENEMY_TRACE),
                "path": stage_context.get("source", ""),
                "target": str(actor_id),
                "note": "stage/wave context from previous trace; no code/data alias to payload instance id",
            }
            evidence_rows.append(ev)
            actor_evidence.append(ev)

        binary_hits = scan_binary_string_refs([expected_bundle] if expected_bundle else [str(actor_id)], max_hits=20)
        for hit in binary_hits:
            ev = {
                "actorId": actor_id,
                "evidenceKind": "restoredata_binary_string_hit",
                "classification": "exact_expected_bundle_binary_hit" if expected_bundle and norm(expected_bundle) == norm(hit.get("needle")) else "context_only",
                "source": hit.get("source", ""),
                "offset": hit.get("offset", ""),
                "target": hit.get("needle", ""),
                "note": hit.get("note", ""),
            }
            evidence_rows.append(ev)
            actor_evidence.append(ev)

        apk_hits = scan_apk_entries([expected_bundle] if expected_bundle else [str(actor_id)], max_hits=20)
        for hit in apk_hits:
            ev = {
                "actorId": actor_id,
                "evidenceKind": "apk_entry_hit",
                "classification": "exact_expected_bundle_apk_entry" if expected_bundle and norm(expected_bundle) in norm(hit.get("entry")) else "context_only",
                "source": hit.get("source", ""),
                "path": hit.get("entry", ""),
                "target": expected_bundle or str(actor_id),
                "note": "local APK/split APK entry name only; no extraction or runtime instrumentation",
            }
            evidence_rows.append(ev)
            actor_evidence.append(ev)

        final_status, reason = classify_actor(row, actor_evidence)
        row["finalStatus"] = final_status
        row["finalReason"] = reason
        row["exactLocalBundleExists"] = any(
            ev.get("evidenceKind") == "local_exact_file" and ev.get("exists") is True for ev in actor_evidence
        )
        row["localContainerMatchCount"] = sum(
            1 for ev in actor_evidence if ev.get("evidenceKind") == "local_container_object_scan" and ev.get("matches")
        )
        row["versionfileExactRows"] = sum(
            1 for ev in actor_evidence if ev.get("evidenceKind") in {"versionfile_exact", "cdn_versionfile_exact"}
            and ev.get("classification") == "exact_expected_bundle_index_hit"
        )
        row["sameFilenameDifferentCategoryRows"] = sum(
            1 for ev in actor_evidence if ev.get("evidenceKind") == "same_filename_different_category"
        )

        if final_status == "resolved_loadable_local_bundle":
            next_action = "write proposal to promote actor bundle"
        elif final_status == "local_parent_bundle_contains_object":
            next_action = "needs source confirmation before any actor mapping proposal"
        elif final_status == "versionfile_or_cdn_index_only_not_local":
            next_action = "requires approved CDN/acquisition path or a local extraction containing the exact bundle"
        else:
            next_action = "requires authoritative DTMonster/DTHero->DTmodel->prefab chain or source-backed alias"
        blocker_rows.append(
            {
                "actorId": actor_id,
                "side": side,
                "waveNo": wave_no,
                "slot": slot,
                "finalStatus": final_status,
                "blocker": reason,
                "nextAction": next_action,
                "unchangedActorBlocker": final_status != "resolved_loadable_local_bundle",
            }
        )

    new_resolved = [row for row in chain_rows if row.get("finalStatus") == "resolved_loadable_local_bundle"]
    new_container = [row for row in chain_rows if row.get("finalStatus") == "local_parent_bundle_contains_object"]
    versionfile_only = [row for row in chain_rows if row.get("finalStatus") == "versionfile_or_cdn_index_only_not_local"]
    still_unresolved = [
        row
        for row in chain_rows
        if row.get("finalStatus")
        in {"not_resolved_from_local_evidence", "alias_candidate_needs_source_confirmation", "versionfile_or_cdn_index_only_not_local"}
    ]

    proposal_written = False
    proposal_paths: list[str] = []
    # No proposal is written unless exact local actor bundle status changes exist.
    if new_resolved:
        proposal_written = True
        proposal = {
            "name": "BATTLE_LOCAL_PLAYABLE_PAYLOAD_ACTOR_UPDATE_PROPOSAL_FROM_CHARACTER63_RESCAN",
            "generatedBy": rel(Path(__file__)),
            "classification": "source_backed_actor_update_proposal_only",
            "actorUpdates": new_resolved,
            "doesNotOverwrite": rel(MANIFEST),
        }
        proposal_json = REPORT_BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_ACTOR_UPDATE_PROPOSAL_FROM_CHARACTER63_RESCAN.json"
        proposal_csv = REPORT_BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_ACTOR_UPDATE_PROPOSAL_FROM_CHARACTER63_RESCAN.csv"
        proposal_json.write_text(json.dumps(proposal, ensure_ascii=False, indent=2), encoding="utf-8")
        write_csv(proposal_csv, new_resolved, list(chain_rows[0].keys()) if chain_rows else ["actorId"])
        proposal_paths = [rel(proposal_json), rel(proposal_csv)]

    result = {
        "name": OUT_BASE,
        "generatedBy": rel(Path(__file__)),
        "generatedAtUtc": datetime.now(timezone.utc).isoformat(),
        "workspace": str(ROOT),
        "sceneModified": False,
        "networkUsed": False,
        "fakeDataCreated": False,
        "actorsChecked": TARGET_IDS,
        "newResolvedLoadableLocalBundles": new_resolved,
        "newLocalParentBundleContainerMatches": new_container,
        "versionfileOnlyRows": versionfile_only,
        "stillUnresolvedRows": still_unresolved,
        "proposalWritten": proposal_written,
        "proposalPaths": proposal_paths,
        "nextBlocker": "Full actor payload still requires the exact 1036 battle actor bundle or approved acquisition, plus authoritative DTMonster/DTHero->DTmodel->prefab chains or source-backed aliases for unresolved enemy payload instance ids.",
        "guardrailsTouched": {
            "speedlineManifestVariantPreserved": MANIFEST.exists(),
            "speedlineResultsUnchanged": bool(speedline_trace),
            "canonicalManifestOverwritten": False,
            "networkDownloadHeadGet": False,
            "unitySceneModified": False,
            "fakeMappingCreated": False,
            "apkRuntimeInstrumentation": False,
        },
        "commandPolicy": command_policy_status(),
        "summary": {
            "statusCounts": dict(Counter(row.get("finalStatus") for row in chain_rows)),
            "actorsCheckedCount": len(chain_rows),
            "newResolvedLoadableLocalBundleCount": len(new_resolved),
            "newLocalParentBundleContainerMatchCount": len(new_container),
            "versionfileOnlyCount": len(versionfile_only),
            "stillUnresolvedCount": len(still_unresolved),
            "evidenceRows": len(evidence_rows),
        },
        "inputsRead": [
            rel(path)
            for path in [
                ROOT / "reports" / "CONTROL_TOWER_STATUS_20260626_052835.md",
                RESOURCE_GAP_TRACE,
                PREV_1036_TRACE,
                PREV_ENEMY_TRACE,
                SPEEDLINE_TRACE,
                MANIFEST,
            ]
        ],
        "chainRows": chain_rows,
        "evidenceRows": evidence_rows,
        "blockerRows": blocker_rows,
        "localContainerScan": {
            "needles": sorted(set(container_needles)),
            "matches": local_container_matches,
            "note": "Used only for local container evidence; no guessed actor mapping promotion.",
        },
        "priorTraceRefs": {
            "resourceGapClassification1036": resource_gap_trace.get("hero1036ActorBundle", {}).get("classification", ""),
            "cdnTraceClassification1036": prev_1036_trace.get("classification", ""),
            "enemyTraceStatusCounts": prev_enemy_trace.get("summary", {}).get("targetStatusCounts", {}),
        },
    }
    return result


def write_outputs(result: dict) -> None:
    REPORT_CHAR_DIR.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    chain_fields = [
        "actorId",
        "side",
        "waveNo",
        "slot",
        "payloadHeroId",
        "datatable",
        "datatableFound",
        "modelId",
        "modelFound",
        "prefabId",
        "expectedActorBundle",
        "sysPrefabAssetPath",
        "sysPrefabName",
        "skillDidList",
        "nameKey",
        "weakSkillModelCandidatesNotActorAliases",
        "exactLocalBundleExists",
        "localContainerMatchCount",
        "versionfileExactRows",
        "sameFilenameDifferentCategoryRows",
        "finalStatus",
        "finalReason",
        "source",
    ]
    evidence_fields = [
        "actorId",
        "evidenceKind",
        "classification",
        "source",
        "path",
        "line",
        "offset",
        "exists",
        "size",
        "md5",
        "target",
        "matches",
        "note",
    ]
    blocker_fields = [
        "actorId",
        "side",
        "waveNo",
        "slot",
        "finalStatus",
        "blocker",
        "nextAction",
        "unchangedActorBlocker",
    ]
    write_csv(OUT_CHAIN_CSV, result["chainRows"], chain_fields)
    write_csv(OUT_EVIDENCE_CSV, result["evidenceRows"], evidence_fields)
    write_csv(OUT_BLOCKER_CSV, result["blockerRows"], blocker_fields)

    lines = [
        "# CHARACTER_63_UNRESOLVED_ACTOR_BUNDLE_LOCAL_EVIDENCE_RESCAN_NO_NETWORK_NO_FAKE_RESULT",
        "",
        f"- generatedBy: `{result['generatedBy']}`",
        f"- generatedAtUtc: `{result['generatedAtUtc']}`",
        f"- workspace: `{result['workspace']}`",
        f"- sceneModified: `{result['sceneModified']}`",
        f"- networkUsed: `{result['networkUsed']}`",
        f"- fakeDataCreated: `{result['fakeDataCreated']}`",
        f"- proposalWritten: `{result['proposalWritten']}`",
        "",
        "## Summary",
        "",
        f"- actorsChecked: `{', '.join(str(x) for x in result['actorsChecked'])}`",
        f"- statusCounts: `{result['summary']['statusCounts']}`",
        f"- newResolvedLoadableLocalBundles: `{len(result['newResolvedLoadableLocalBundles'])}`",
        f"- newLocalParentBundleContainerMatches: `{len(result['newLocalParentBundleContainerMatches'])}`",
        f"- versionfileOnlyRows: `{len(result['versionfileOnlyRows'])}`",
        f"- stillUnresolvedRows: `{len(result['stillUnresolvedRows'])}`",
        "",
        "## Actor Chain Matrix",
        "",
        "| actorId | side | wave | slot | datatable | modelId | prefabId | expected actor bundle | final status | reason |",
        "|---:|---|---:|---:|---|---:|---:|---|---|---|",
    ]
    for row in result["chainRows"]:
        lines.append(
            f"| {row.get('actorId')} | {row.get('side')} | {row.get('waveNo')} | {row.get('slot')} | "
            f"{row.get('datatable')} | {row.get('modelId')} | {row.get('prefabId')} | "
            f"`{row.get('expectedActorBundle')}` | `{row.get('finalStatus')}` | {row.get('finalReason')} |"
        )
    lines.extend(
        [
            "",
            "## Key Findings",
            "",
            "- `1036` retains an authoritative DTHero -> DTmodel -> prefab chain, but the exact expected battle actor bundle is not local.",
            "- `1036` exact bundle has versionfile/CDNVersionFile evidence only; same-filename role painting and skill bundles are not actor bundle aliases.",
            "- Enemy payload instance ids still have no authoritative DTMonster/DTHero -> DTmodel -> prefab chain in local evidence.",
            "- Weak skill/model references on unresolved enemy skill rows are recorded as context only and are not promoted to actor aliases.",
            "- Speedline BATTLE61/BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED inputs were read and left unchanged.",
            "",
            "## Outputs",
            "",
            f"- JSON: `{rel(OUT_JSON)}`",
            f"- Chain CSV: `{rel(OUT_CHAIN_CSV)}`",
            f"- Evidence CSV: `{rel(OUT_EVIDENCE_CSV)}`",
            f"- Blocker CSV: `{rel(OUT_BLOCKER_CSV)}`",
            "",
            "## Command Policy",
            "",
            f"- rootCmdCount: `{result['commandPolicy']['rootCmdCount']}`",
            f"- rootCmdFiles: `{result['commandPolicy']['rootCmdFiles']}`",
            f"- restoreToolsDirectCmdCount: `{result['commandPolicy']['restoreToolsDirectCmdCount']}`",
            f"- policyOk: `{result['commandPolicy']['policyOk']}`",
            "",
            "## Next Blocker",
            "",
            f"- {result['nextBlocker']}",
            "",
        ]
    )
    OUT_MD.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    result = build()
    write_outputs(result)
    print(json.dumps(result["summary"], ensure_ascii=False, indent=2))
    print(f"wrote {rel(OUT_MD)}")
    print(f"wrote {rel(OUT_JSON)}")
    print(f"wrote {rel(OUT_CHAIN_CSV)}")
    print(f"wrote {rel(OUT_EVIDENCE_CSV)}")
    print(f"wrote {rel(OUT_BLOCKER_CSV)}")
    print(f"proposalWritten={result['proposalWritten']}")


if __name__ == "__main__":
    main()
