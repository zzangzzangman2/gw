from __future__ import annotations

import csv
import json
import os
import re
import zipfile
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
INDEX_DIR = ROOT / "girlswar_merged_extracted" / "indexes"
REPORT_CHAR_DIR = ROOT / "reports" / "characters"
REPORT_BATTLE_DIR = ROOT / "reports" / "battle"

MANIFEST_PATH = REPORT_BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.json"

OUT_JSON = REPORT_CHAR_DIR / "CHARACTER_COMMON_SPEEDLINE_BUNDLE_DEEP_TRACE_RESULT.json"
OUT_MD = REPORT_CHAR_DIR / "CHARACTER_COMMON_SPEEDLINE_BUNDLE_DEEP_TRACE_RESULT.md"
OUT_CSV = REPORT_CHAR_DIR / "CHARACTER_COMMON_SPEEDLINE_BUNDLE_DEEP_TRACE_RESULT.csv"
OUT_SKILL_CSV = REPORT_CHAR_DIR / "CHARACTER_COMMON_SPEEDLINE_AFFECTED_SKILL_ROWS.csv"
OUT_PROPOSAL_JSON = REPORT_BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_RESOURCE_UPDATE_PROPOSAL_FROM_SPEEDLINE_TRACE.json"
OUT_PROPOSAL_CSV = REPORT_BATTLE_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_RESOURCE_UPDATE_PROPOSAL_FROM_SPEEDLINE_TRACE.csv"

PARENT_BUNDLE = "download/commonprefabsandres/skilleffect/commonskillprefabsandres1.assetbundle"
PARENT_CLEAN_SLICE = ROOT / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices" / PARENT_BUNDLE

SPEEDLINES = [
    {
        "key": "pink",
        "objectName": "pinkspeedline",
        "exactBundle": "download/commonprefabsandres/skilleffect/commonskillprefabsandres1/pinkspeedline.assetbundle",
        "assetPath": "Assets/Download/CommonPrefabsAndRes/SkillEffect/CommonSkillPrefabsAndRes1/pinkspeedline/pinkspeedline.prefab",
        "yellowAliasProbe": False,
    },
    {
        "key": "red",
        "objectName": "redspeedline",
        "exactBundle": "download/commonprefabsandres/skilleffect/commonskillprefabsandres1/redspeedline.assetbundle",
        "assetPath": "Assets/Download/CommonPrefabsAndRes/SkillEffect/CommonSkillPrefabsAndRes1/redspeedline/redspeedline.prefab",
        "yellowAliasProbe": False,
    },
    {
        "key": "yello",
        "objectName": "yellospeedline",
        "exactBundle": "download/commonprefabsandres/skilleffect/commonskillprefabsandres1/yellospeedline.assetbundle",
        "assetPath": "Assets/Download/CommonPrefabsAndRes/SkillEffect/CommonSkillPrefabsAndRes1/yellospeedline/yellospeedline.prefab",
        "yellowAliasProbe": True,
    },
]


def rel(path: Path) -> str:
    try:
        return path.relative_to(ROOT).as_posix()
    except ValueError:
        return str(path)


def norm(s: str | None) -> str:
    return (s or "").replace("\\", "/").lower()


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
            writer.writerow({k: row.get(k, "") for k in fieldnames})


def find_index_hits(csv_name: str, needles: list[str], max_hits: int = 30) -> list[dict]:
    path = INDEX_DIR / csv_name
    hits: list[dict] = []
    if not path.exists():
        return hits
    lowered = [n.lower() for n in needles]
    with path.open("r", encoding="utf-8-sig", errors="ignore", newline="") as f:
        reader = csv.DictReader(f)
        for i, row in enumerate(reader, start=2):
            joined = " ".join(str(v) for v in row.values()).replace("\\", "/").lower()
            if any(n in joined for n in lowered):
                out = {
                    "source": rel(path),
                    "line": i,
                    "matchedText": " | ".join(str(v) for v in row.values() if v)[:900],
                }
                out.update({k: row.get(k, "") for k in row.keys()})
                hits.append(out)
                if len(hits) >= max_hits:
                    break
    return hits


def grep_text_files(paths: list[Path], needles: list[str], max_hits: int = 50) -> list[dict]:
    hits: list[dict] = []
    lowered = [n.lower() for n in needles]
    for path in paths:
        if not path.exists() or not path.is_file():
            continue
        try:
            with path.open("r", encoding="utf-8-sig", errors="ignore") as f:
                for lineno, line in enumerate(f, start=1):
                    low = line.lower()
                    if any(n in low for n in lowered):
                        hits.append(
                            {
                                "source": rel(path),
                                "line": lineno,
                                "matchedText": line.strip()[:900],
                            }
                        )
                        if len(hits) >= max_hits:
                            return hits
        except OSError:
            continue
    return hits


def iter_candidate_text_files() -> list[Path]:
    roots = [
        ROOT / "reports",
        INDEX_DIR,
        ROOT / "girlswar_merged_extracted" / "extracted" / "lua",
        ROOT / "girlswar_merged_extracted" / "extracted" / "datatable",
        ROOT / "il2cpp_native",
    ]
    suffixes = {".csv", ".json", ".md", ".txt", ".lua", ".cs"}
    out: list[Path] = []
    for base in roots:
        if not base.exists():
            continue
        for path in base.rglob("*"):
            if path.is_file() and path.suffix.lower() in suffixes:
                if path.name == OUT_JSON.name:
                    continue
                out.append(path)
    return out


def local_file_checks(path_string: str) -> list[dict]:
    relative = Path(path_string)
    probes = [
        ROOT / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices" / relative,
        ROOT / "girlswar_merged_extracted" / "merged_content" / "AssetBundles" / relative,
        ROOT / "girlswar_merged_extracted" / "restore_overlay" / "files" / "build" / relative,
        ROOT / "com.girlwars.kr" / "files" / "build" / relative,
    ]
    checks = []
    for p in probes:
        checks.append(
            {
                "probePath": rel(p),
                "exists": p.exists(),
                "size": p.stat().st_size if p.exists() and p.is_file() else "",
            }
        )
    return checks


def inspect_parent_unity_bundle() -> dict:
    result = {
        "bundlePath": rel(PARENT_CLEAN_SLICE),
        "exists": PARENT_CLEAN_SLICE.exists(),
        "size": PARENT_CLEAN_SLICE.stat().st_size if PARENT_CLEAN_SLICE.exists() else "",
        "unityPyAvailable": False,
        "objectCount": 0,
        "gameObjectNames": [],
        "containerNames": [],
        "error": "",
    }
    if not PARENT_CLEAN_SLICE.exists():
        return result
    try:
        import UnityPy  # type: ignore

        result["unityPyAvailable"] = True
        env = UnityPy.load(str(PARENT_CLEAN_SLICE))
        game_names: set[str] = set()
        container_names: set[str] = set()
        count = 0
        for obj in env.objects:
            count += 1
            try:
                data = obj.read()
            except Exception:
                continue
            name = getattr(data, "m_Name", "") or ""
            if name:
                if obj.type.name == "GameObject":
                    game_names.add(name)
                if any(speed["objectName"] in name.lower() for speed in SPEEDLINES):
                    game_names.add(name)
            if obj.type.name == "AssetBundle":
                container = getattr(data, "m_Container", None)
                if container:
                    try:
                        items = container.items()
                    except AttributeError:
                        items = []
                    for key, _value in items:
                        key_s = str(key)
                        container_names.add(key_s)
        result["objectCount"] = count
        result["gameObjectNames"] = sorted(game_names)
        result["containerNames"] = sorted(container_names)
    except Exception as exc:  # pragma: no cover - diagnostic output path
        result["error"] = f"{type(exc).__name__}: {exc}"
    return result


def scan_apk_entries(needles: list[str]) -> list[dict]:
    hits: list[dict] = []
    lowered = [n.lower() for n in needles]
    apk_roots = [ROOT, ROOT / "girlswar_merged_extracted", ROOT / "work"]
    seen: set[Path] = set()
    for base in apk_roots:
        if not base.exists():
            continue
        for path in base.rglob("*.apk"):
            if path in seen:
                continue
            seen.add(path)
            try:
                with zipfile.ZipFile(path) as zf:
                    for name in zf.namelist():
                        low = name.replace("\\", "/").lower()
                        if any(n in low for n in lowered):
                            hits.append({"source": rel(path), "entry": name})
            except (OSError, zipfile.BadZipFile):
                continue
    return hits[:50]


def command_policy_status() -> dict:
    root_cmd = list(ROOT.glob("*.cmd"))
    tools_cmd = list((ROOT / "_restore_tools").glob("*.cmd")) if (ROOT / "_restore_tools").exists() else []
    return {
        "rootCmdCount": len(root_cmd),
        "rootCmdFiles": [p.name for p in root_cmd],
        "restoreToolsDirectCmdCount": len(tools_cmd),
        "restoreToolsDirectCmdFiles": [p.name for p in tools_cmd],
        "policyOk": len(root_cmd) == 1 and len(tools_cmd) == 0,
    }


def split_deps(value: str | list | None) -> list[str]:
    if value is None:
        return []
    if isinstance(value, list):
        return [str(v) for v in value if str(v)]
    s = str(value)
    if not s:
        return []
    parts = re.split(r"[|,;]", s)
    return [p.strip() for p in parts if p.strip()]


def owner_actor_status(manifest: dict, owner: str, side: str = "", wave_no: str = "") -> tuple[str, str]:
    owner_s = str(owner)
    for actor in manifest.get("actors", []):
        if str(actor.get("payloadHeroDid", "")) != owner_s:
            continue
        if side and str(actor.get("side", "")) != side:
            continue
        if wave_no and str(actor.get("waveNo", "")) != wave_no:
            continue
        return str(actor.get("localStatus", "")), str(actor.get("reason", ""))
    for actor in manifest.get("actors", []):
        if str(actor.get("payloadHeroDid", "")) == owner_s:
            return str(actor.get("localStatus", "")), str(actor.get("reason", ""))
    return "", "owner actor row not found in manifest"


def build() -> dict:
    with MANIFEST_PATH.open("r", encoding="utf-8") as f:
        manifest = json.load(f)

    exact_bundles = [s["exactBundle"] for s in SPEEDLINES]
    asset_paths = [s["assetPath"] for s in SPEEDLINES]
    object_names = [s["objectName"] for s in SPEEDLINES]
    yellow_variants = [
        "download/commonprefabsandres/skilleffect/commonskillprefabsandres1/yellowspeedline.assetbundle",
        "Assets/Download/CommonPrefabsAndRes/SkillEffect/CommonSkillPrefabsAndRes1/yellowspeedline/yellowspeedline.prefab",
        "yellowspeedline",
    ]

    parent_inspection = inspect_parent_unity_bundle()
    parent_index_hits = []
    for csv_name in [
        "assetbundles.csv",
        "merged_files.csv",
        "conflicts.csv",
        "versionfile_VersionFile_bytes.csv",
        "versionfile_CDNVersionFile_bytes.csv",
        "unity_bundle_export_map.csv",
        "unity_cab_to_bundle.csv",
        "unity_objects.csv",
        "unity_textassets.csv",
    ]:
        parent_index_hits.extend(find_index_hits(csv_name, [PARENT_BUNDLE], max_hits=20))

    exact_index_hits = []
    for csv_name in [
        "assetbundles.csv",
        "merged_files.csv",
        "conflicts.csv",
        "versionfile_VersionFile_bytes.csv",
        "versionfile_CDNVersionFile_bytes.csv",
        "unity_bundle_export_map.csv",
        "unity_cab_to_bundle.csv",
        "unity_objects.csv",
        "unity_textassets.csv",
    ]:
        exact_index_hits.extend(find_index_hits(csv_name, exact_bundles, max_hits=20))

    text_hits = grep_text_files(iter_candidate_text_files(), asset_paths + object_names, max_hits=120)
    yellow_alias_hits = grep_text_files(iter_candidate_text_files(), yellow_variants, max_hits=40)
    apk_hits = scan_apk_entries(exact_bundles + [PARENT_BUNDLE])

    parent_names = {norm(x) for x in parent_inspection.get("gameObjectNames", [])}
    parent_containers = {norm(x) for x in parent_inspection.get("containerNames", [])}
    index_joined_parent = "\n".join(json.dumps(h, ensure_ascii=False) for h in parent_index_hits).lower()
    text_joined = "\n".join(json.dumps(h, ensure_ascii=False) for h in text_hits).lower()

    speedline_rows: list[dict] = []
    resource_updates: list[dict] = []
    for speed in SPEEDLINES:
        object_name = speed["objectName"]
        exact = speed["exactBundle"]
        exact_checks = local_file_checks(exact)
        parent_checks = local_file_checks(PARENT_BUNDLE)
        exact_local = any(c["exists"] for c in exact_checks)
        parent_local = any(c["exists"] for c in parent_checks) or PARENT_CLEAN_SLICE.exists()
        object_hit = any(object_name in name for name in parent_names) or any(object_name in name for name in parent_containers)
        exact_version_hits = [h for h in exact_index_hits if norm(exact) in norm(h.get("matchedText", ""))]
        parent_version_hits = [
            h
            for h in parent_index_hits
            if "versionfile_" in h.get("source", "").lower() and norm(PARENT_BUNDLE) in norm(h.get("matchedText", ""))
        ]
        asset_path_hits = [h for h in text_hits if norm(speed["assetPath"]) in norm(h.get("matchedText", ""))]

        if exact_local:
            status = "resolved_loadable_local_bundle"
            status_reason = "exact child bundle exists locally"
            resolved_bundle = exact
        elif parent_local and object_hit and asset_path_hits:
            status = "resolved_loadable_local_bundle"
            status_reason = "exact child bundle is absent, but source asset path resolves to an object/container in local parent bundle"
            resolved_bundle = PARENT_BUNDLE
        elif exact_version_hits or parent_version_hits:
            status = "versionfile_only_not_local"
            status_reason = "versionfile evidence exists but local loadable bundle evidence is incomplete"
            resolved_bundle = ""
        else:
            status = "not_resolved_from_local_evidence"
            status_reason = "no exact local bundle and no source-backed parent bundle object evidence"
            resolved_bundle = ""

        yellow_note = ""
        if speed["yellowAliasProbe"]:
            yellow_note = (
                "authoritative source spelling is yellospeedline; yellowspeedline probe produced "
                f"{len(yellow_alias_hits)} text hits and is not used as an alias"
            )

        row = {
            "speedline": speed["key"],
            "objectName": object_name,
            "exactManifestBundle": exact,
            "assetPath": speed["assetPath"],
            "status": status,
            "statusReason": status_reason,
            "resolvedBundle": resolved_bundle,
            "exactLocalExists": exact_local,
            "parentBundle": PARENT_BUNDLE,
            "parentLocalExists": parent_local,
            "parentUnityPyAvailable": parent_inspection.get("unityPyAvailable", False),
            "parentObjectOrContainerHit": object_hit,
            "parentMatchingNames": "|".join(
                sorted(
                    {
                        n
                        for n in parent_inspection.get("gameObjectNames", []) + parent_inspection.get("containerNames", [])
                        if object_name in n.lower()
                    }
                )
            ),
            "assetPathTextHitCount": len(asset_path_hits),
            "exactVersionfileHitCount": len(exact_version_hits),
            "parentVersionfileHitCount": len(parent_version_hits),
            "yellowAliasNote": yellow_note,
        }
        speedline_rows.append(row)
        if status == "resolved_loadable_local_bundle" and resolved_bundle == PARENT_BUNDLE:
            resource_updates.append(
                {
                    "exactManifestBundle": exact,
                    "currentStatus": "unresolved_missing_common_bundle",
                    "proposedStatus": "resolved_loadable_local_bundle",
                    "resolvedBundle": PARENT_BUNDLE,
                    "resolutionType": "source_backed_parent_bundle_contains_prefab_object",
                    "assetPath": speed["assetPath"],
                    "evidenceSummary": "; ".join(
                        [
                            "BattleTimelineResMap/roster text references exact prefab asset path",
                            "assetbundles/versionfile indexes contain parent commonskillprefabsandres1.assetbundle",
                            f"UnityPy inspection found parent object/container matching {object_name}",
                        ]
                    ),
                }
            )

    resolved_bundle_by_exact = {
        r["exactManifestBundle"]: r["resolvedBundle"]
        for r in speedline_rows
        if r["status"] == "resolved_loadable_local_bundle" and r["resolvedBundle"]
    }

    affected_skill_rows: list[dict] = []
    skill_promotions: list[dict] = []
    for skill in manifest.get("skills", []):
        deps = split_deps(skill.get("missingDependencyBundles"))
        resource_deps = [d for d in deps if d in exact_bundles]
        timeline_deps = [s["exactBundle"] for s in SPEEDLINES if norm(s["assetPath"]) in norm(skill.get("timelineDependencies", ""))]
        relevant_deps = sorted(set(resource_deps + timeline_deps))
        if not relevant_deps:
            continue
        side = str(skill.get("side", ""))
        wave_no = str(skill.get("waveNo", ""))
        owner = str(skill.get("ownerHeroDid", ""))
        actor_status, actor_reason = owner_actor_status(manifest, owner, side=side, wave_no=wave_no)
        current_status = str(skill.get("localStatus", ""))
        unresolved_after = [d for d in deps if d not in resolved_bundle_by_exact]
        resource_resolved = all(d in resolved_bundle_by_exact for d in relevant_deps)

        if current_status == "loadable_with_unresolved_common_resource_deps" and resource_resolved and not unresolved_after and actor_status == "loadable":
            proposed = "loadable"
            blocker = ""
        elif actor_status != "loadable":
            proposed = current_status
            blocker = f"actor remains {actor_status}: {actor_reason}"
        elif unresolved_after:
            proposed = current_status
            blocker = "other missing dependencies remain: " + "|".join(unresolved_after)
        else:
            proposed = current_status
            blocker = "resource evidence recorded; row was not a local playable missing-common-dep row"

        row = {
            "side": side,
            "waveNo": wave_no,
            "ownerHeroDid": owner,
            "ownerHeroId": skill.get("ownerHeroId", ""),
            "skillDid": skill.get("skillDid", ""),
            "prefabField": skill.get("prefabField", ""),
            "prefabId": skill.get("prefabId", ""),
            "skillBundle": skill.get("bundle", ""),
            "currentStatus": current_status,
            "actorStatus": actor_status,
            "affectedExactBundles": "|".join(relevant_deps),
            "resolvedBundles": "|".join(resolved_bundle_by_exact.get(d, "") for d in relevant_deps),
            "remainingMissingDependencyBundles": "|".join(unresolved_after),
            "proposedStatus": proposed,
            "blocker": blocker,
        }
        affected_skill_rows.append(row)
        if proposed == "loadable" and current_status != "loadable":
            skill_promotions.append(row)

    source_evidence = {
        "parentBundleInspection": parent_inspection,
        "parentIndexHits": parent_index_hits[:80],
        "exactChildIndexHits": exact_index_hits[:80],
        "textHits": text_hits[:120],
        "yellowAliasProbeHits": yellow_alias_hits[:40],
        "apkEntryHits": apk_hits,
        "localFileChecks": {
            "parent": local_file_checks(PARENT_BUNDLE),
            **{s["exactBundle"]: local_file_checks(s["exactBundle"]) for s in SPEEDLINES},
        },
    }

    proposal = None
    if resource_updates or skill_promotions:
        proposal = {
            "name": "BATTLE_LOCAL_PLAYABLE_PAYLOAD_RESOURCE_UPDATE_PROPOSAL_FROM_SPEEDLINE_TRACE",
            "generatedBy": rel(Path(__file__)),
            "generatedAtUtc": datetime.now(timezone.utc).isoformat(),
            "classification": "source_backed_resource_update_proposal_only",
            "doesNotOverwrite": rel(MANIFEST_PATH),
            "resourceUpdates": resource_updates,
            "skillPromotions": skill_promotions,
            "unchangedActorBlockers": [
                "1036 actor exact bundle remains not_fetchable_local",
                "enemy 1100112/1100113/1100121/1100122/1100123/1100131/1100132/1100133 remain not_resolved_from_local_evidence",
            ],
            "warning": "This proposal resolves common speedline resource dependencies only; it is not a full original payload restore claim.",
        }

    command_policy = command_policy_status()
    result = {
        "name": "CHARACTER_COMMON_SPEEDLINE_BUNDLE_DEEP_TRACE_RESULT",
        "generatedBy": rel(Path(__file__)),
        "generatedAtUtc": datetime.now(timezone.utc).isoformat(),
        "workspace": str(ROOT),
        "classification": "no_fake_resource_source_backed_trace",
        "inputs": {
            "manifest": rel(MANIFEST_PATH),
            "assetbundleIndex": rel(INDEX_DIR / "assetbundles.csv"),
            "versionfile": rel(INDEX_DIR / "versionfile_VersionFile_bytes.csv"),
            "cdnVersionfile": rel(INDEX_DIR / "versionfile_CDNVersionFile_bytes.csv"),
            "cleanParentBundle": rel(PARENT_CLEAN_SLICE),
        },
        "summary": {
            "speedlineStatusCounts": dict(Counter(r["status"] for r in speedline_rows)),
            "resourceUpdateProposalWritten": proposal is not None,
            "resourceUpdates": len(resource_updates),
            "affectedSkillRows": len(affected_skill_rows),
            "skillRowsProposedLoadable": len(skill_promotions),
            "networkAccessUsed": False,
            "unitySceneModified": False,
            "fakeResourceMappingUsed": False,
        },
        "speedlines": speedline_rows,
        "affectedSkillRows": affected_skill_rows,
        "sourceEvidence": source_evidence,
        "proposal": proposal,
        "commandPolicy": command_policy,
        "nextBlockers": [
            "Battle worker must apply the proposal to treat exact speedline manifest dependency strings as objects inside the source-backed parent bundle.",
            "Full original payload remains blocked by 1036 actor not_fetchable_local and unresolved enemy payload actor mappings.",
            "No source-backed yellow spelling alias was used; yellospeedline remains the authoritative local evidence string.",
        ],
    }

    return result


def write_outputs(result: dict) -> None:
    REPORT_CHAR_DIR.mkdir(parents=True, exist_ok=True)
    REPORT_BATTLE_DIR.mkdir(parents=True, exist_ok=True)

    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    write_csv(
        OUT_CSV,
        result["speedlines"],
        [
            "speedline",
            "objectName",
            "exactManifestBundle",
            "assetPath",
            "status",
            "statusReason",
            "resolvedBundle",
            "exactLocalExists",
            "parentBundle",
            "parentLocalExists",
            "parentUnityPyAvailable",
            "parentObjectOrContainerHit",
            "parentMatchingNames",
            "assetPathTextHitCount",
            "exactVersionfileHitCount",
            "parentVersionfileHitCount",
            "yellowAliasNote",
        ],
    )

    write_csv(
        OUT_SKILL_CSV,
        result["affectedSkillRows"],
        [
            "side",
            "waveNo",
            "ownerHeroDid",
            "ownerHeroId",
            "skillDid",
            "prefabField",
            "prefabId",
            "skillBundle",
            "currentStatus",
            "actorStatus",
            "affectedExactBundles",
            "resolvedBundles",
            "remainingMissingDependencyBundles",
            "proposedStatus",
            "blocker",
        ],
    )

    proposal = result.get("proposal")
    if proposal:
        OUT_PROPOSAL_JSON.write_text(json.dumps(proposal, ensure_ascii=False, indent=2), encoding="utf-8")
        proposal_rows = []
        for row in proposal.get("resourceUpdates", []):
            out = dict(row)
            out["rowType"] = "resourceUpdate"
            proposal_rows.append(out)
        for row in proposal.get("skillPromotions", []):
            out = dict(row)
            out["rowType"] = "skillPromotion"
            proposal_rows.append(out)
        write_csv(
            OUT_PROPOSAL_CSV,
            proposal_rows,
            [
                "rowType",
                "exactManifestBundle",
                "currentStatus",
                "proposedStatus",
                "resolvedBundle",
                "resolutionType",
                "assetPath",
                "evidenceSummary",
                "side",
                "waveNo",
                "ownerHeroDid",
                "ownerHeroId",
                "skillDid",
                "prefabField",
                "prefabId",
                "skillBundle",
                "actorStatus",
                "affectedExactBundles",
                "resolvedBundles",
                "remainingMissingDependencyBundles",
                "blocker",
            ],
        )

    lines = [
        "# CHARACTER_COMMON_SPEEDLINE_BUNDLE_DEEP_TRACE_RESULT",
        "",
        f"- generatedBy: `{result['generatedBy']}`",
        f"- generatedAtUtc: `{result['generatedAtUtc']}`",
        f"- workspace: `{result['workspace']}`",
        f"- classification: `{result['classification']}`",
        f"- networkAccessUsed: `{result['summary']['networkAccessUsed']}`",
        f"- unitySceneModified: `{result['summary']['unitySceneModified']}`",
        f"- fakeResourceMappingUsed: `{result['summary']['fakeResourceMappingUsed']}`",
        "",
        "## Summary",
        "",
        f"- speedlineStatusCounts: `{result['summary']['speedlineStatusCounts']}`",
        f"- resourceUpdateProposalWritten: `{result['summary']['resourceUpdateProposalWritten']}`",
        f"- affectedSkillRows: `{result['summary']['affectedSkillRows']}`",
        f"- skillRowsProposedLoadable: `{result['summary']['skillRowsProposedLoadable']}`",
        "",
        "## Speedline Matrix",
        "",
        "| speedline | final status | exact child bundle | resolved local bundle | evidence |",
        "|---|---|---|---|---|",
    ]
    for row in result["speedlines"]:
        evidence = (
            f"parentLocal={row['parentLocalExists']}; "
            f"parentObjectHit={row['parentObjectOrContainerHit']}; "
            f"assetPathHits={row['assetPathTextHitCount']}; "
            f"names={row['parentMatchingNames']}"
        )
        lines.append(
            f"| {row['speedline']} | `{row['status']}` | `{row['exactManifestBundle']}` | "
            f"`{row['resolvedBundle']}` | {evidence} |"
        )
    lines.extend(
        [
            "",
            "## Exact vs Parent Bundle Finding",
            "",
            "- The three exact child `.assetbundle` dependency strings from the manifest are not present as local standalone bundles.",
            f"- Source-backed local resolution is the parent bundle `{PARENT_BUNDLE}`.",
            "- The parent bundle is present in assetbundle/versionfile indexes and the clean UnityFS slice can be inspected.",
            "- UnityPy inspection finds matching speedline object/container names inside the parent bundle.",
            "- `yellospeedline` is treated as authoritative source spelling. `yellow` spelling is not used as an alias.",
            "",
            "## Affected Skill Rows",
            "",
            "| side | wave | owner | skillDid | prefabId | current | proposed | affected exact bundles | blocker |",
            "|---|---:|---:|---:|---:|---|---|---|---|",
        ]
    )
    for row in result["affectedSkillRows"]:
        lines.append(
            f"| {row['side']} | {row['waveNo']} | {row['ownerHeroDid']} | {row['skillDid']} | "
            f"{row['prefabId']} | `{row['currentStatus']}` | `{row['proposedStatus']}` | "
            f"`{row['affectedExactBundles']}` | {row['blocker']} |"
        )
    lines.extend(
        [
            "",
            "## Proposal",
            "",
            f"- proposalJson: `{rel(OUT_PROPOSAL_JSON) if result.get('proposal') else ''}`",
            f"- proposalCsv: `{rel(OUT_PROPOSAL_CSV) if result.get('proposal') else ''}`",
            "- The proposal is source-backed and does not overwrite `BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST`.",
            "- It is only a common speedline resource-dependency update, not a full original payload restore claim.",
            "",
            "## Command Policy",
            "",
            f"- rootCmdCount: `{result['commandPolicy']['rootCmdCount']}`",
            f"- rootCmdFiles: `{result['commandPolicy']['rootCmdFiles']}`",
            f"- restoreToolsDirectCmdCount: `{result['commandPolicy']['restoreToolsDirectCmdCount']}`",
            f"- policyOk: `{result['commandPolicy']['policyOk']}`",
            "",
            "## Next Blockers",
            "",
        ]
    )
    for blocker in result["nextBlockers"]:
        lines.append(f"- {blocker}")
    lines.append("")
    OUT_MD.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    os.chdir(ROOT)
    result = build()
    write_outputs(result)
    print(json.dumps(result["summary"], ensure_ascii=False, indent=2))
    print(f"wrote {rel(OUT_MD)}")
    print(f"wrote {rel(OUT_JSON)}")
    print(f"wrote {rel(OUT_CSV)}")
    print(f"wrote {rel(OUT_SKILL_CSV)}")
    if result.get("proposal"):
        print(f"wrote {rel(OUT_PROPOSAL_JSON)}")
        print(f"wrote {rel(OUT_PROPOSAL_CSV)}")


if __name__ == "__main__":
    main()
