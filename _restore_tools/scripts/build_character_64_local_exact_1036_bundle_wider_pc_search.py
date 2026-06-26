from __future__ import annotations

import csv
import hashlib
import json
import os
import time
import zipfile
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
SEARCH_ROOTS = [
    Path(r"C:\Users\godho\Downloads"),
    Path(r"C:\Users\godho\Documents\Codex"),
]
PROJECT_LOCAL_ROOTS = [
    ROOT / "girlswar_merged_extracted",
    ROOT / "work",
    ROOT / "reports",
]

TARGET_BUNDLE = "download/roleprefabsandres/battleprefabandres/1036.assetbundle"
TARGET_FILENAME = "1036.assetbundle"
PATH_PATTERNS = [
    "roleprefabsandres/battleprefabandres/1036",
    "roleprefabsandres\\battleprefabandres\\1036",
    "roleprefabsandres/battleprefabandres/1036.assetbundle",
    "RolePrefabsAndRes/BattlePrefabAndRes/1036",
    "RolePrefabsAndRes\\BattlePrefabAndRes\\1036",
]
METADATA_NEEDLES = ["Hero_1036", "hero1036", "RolePrefab_1036", "1036"]

OUT_BASE = "CHARACTER_64_LOCAL_EXACT_1036_BUNDLE_WIDER_PC_SEARCH_NO_NETWORK_NO_COPY_NO_IMPORT_RESULT"
OUT_JSON = ROOT / "reports" / "characters" / f"{OUT_BASE}.json"
OUT_MD = ROOT / "reports" / "characters" / f"{OUT_BASE}.md"
OUT_CANDIDATES_CSV = ROOT / "reports" / "characters" / f"{OUT_BASE}_EXACT_1036_CANDIDATE_FILE_MATRIX.csv"
OUT_CLASSIFICATION_CSV = ROOT / "reports" / "characters" / f"{OUT_BASE}_CANDIDATE_CLASSIFICATION_NEXT_ACTION_MATRIX.csv"


def rel(path: Path) -> str:
    try:
        return path.relative_to(ROOT).as_posix()
    except ValueError:
        return str(path)


def norm(value: Any) -> str:
    return str(value or "").replace("\\", "/").lower()


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


def safe_stat(path: Path) -> os.stat_result | None:
    try:
        return path.stat()
    except OSError:
        return None


def should_skip_dir(path: Path) -> bool:
    name = path.name.lower()
    if name in {".git", "node_modules", "library", "temp", "obj", "bin", ".vs", "__pycache__"}:
        return True
    return False


def candidate_reason(path: Path) -> str:
    path_s = str(path)
    path_n = norm(path_s)
    reasons = []
    if path.name.lower() == TARGET_FILENAME:
        reasons.append("exact_filename_1036_assetbundle")
    if norm(TARGET_BUNDLE) in path_n:
        reasons.append("exact_target_path_substring")
    if any(norm(pattern) in path_n for pattern in PATH_PATTERNS):
        reasons.append("source_backed_path_variant_substring")
    return "|".join(sorted(set(reasons)))


def iter_targeted_files(root: Path, time_limit_s: float, max_files_seen: int = 1_500_000) -> tuple[list[Path], dict]:
    start = time.monotonic()
    found: list[Path] = []
    stats = {
        "root": str(root),
        "exists": root.exists(),
        "filesSeen": 0,
        "dirsSeen": 0,
        "skippedDirs": 0,
        "errors": 0,
        "timeLimitSeconds": time_limit_s,
        "hitTimeLimit": False,
        "hitFileLimit": False,
    }
    if not root.exists():
        return found, stats
    stack = [root]
    while stack:
        if time.monotonic() - start > time_limit_s:
            stats["hitTimeLimit"] = True
            break
        if stats["filesSeen"] > max_files_seen:
            stats["hitFileLimit"] = True
            break
        current = stack.pop()
        try:
            with os.scandir(current) as it:
                for entry in it:
                    try:
                        path = Path(entry.path)
                        if entry.is_dir(follow_symlinks=False):
                            stats["dirsSeen"] += 1
                            if should_skip_dir(path):
                                stats["skippedDirs"] += 1
                                continue
                            stack.append(path)
                        elif entry.is_file(follow_symlinks=False):
                            stats["filesSeen"] += 1
                            if entry.name.lower() == TARGET_FILENAME or candidate_reason(path):
                                found.append(path)
                    except OSError:
                        stats["errors"] += 1
        except OSError:
            stats["errors"] += 1
    return found, stats


def find_zip_entry_candidates(root: Path, time_limit_s: float, max_archives: int = 2000) -> tuple[list[dict], dict]:
    start = time.monotonic()
    hits: list[dict] = []
    stats = {
        "root": str(root),
        "archivesSeen": 0,
        "errors": 0,
        "timeLimitSeconds": time_limit_s,
        "hitTimeLimit": False,
        "hitArchiveLimit": False,
    }
    if not root.exists():
        return hits, stats
    stack = [root]
    while stack:
        if time.monotonic() - start > time_limit_s:
            stats["hitTimeLimit"] = True
            break
        if stats["archivesSeen"] > max_archives:
            stats["hitArchiveLimit"] = True
            break
        current = stack.pop()
        try:
            with os.scandir(current) as it:
                for entry in it:
                    try:
                        path = Path(entry.path)
                        if entry.is_dir(follow_symlinks=False):
                            if not should_skip_dir(path):
                                stack.append(path)
                        elif entry.is_file(follow_symlinks=False) and path.suffix.lower() in {".apk", ".xapk", ".zip"}:
                            stats["archivesSeen"] += 1
                            try:
                                with zipfile.ZipFile(path) as zf:
                                    for name in zf.namelist():
                                        name_n = norm(name)
                                        if name.lower().endswith(TARGET_FILENAME) or norm(TARGET_BUNDLE) in name_n or any(norm(p) in name_n for p in PATH_PATTERNS):
                                            info = zf.getinfo(name)
                                            hits.append(
                                                {
                                                    "archivePath": str(path),
                                                    "entry": name,
                                                    "entrySize": info.file_size,
                                                    "entryCrc": f"{info.CRC:08x}",
                                                    "reason": "archive_entry_name_match",
                                                }
                                            )
                            except (OSError, zipfile.BadZipFile):
                                stats["errors"] += 1
                    except OSError:
                        stats["errors"] += 1
        except OSError:
            stats["errors"] += 1
    return hits, stats


def header_info(path: Path) -> dict:
    info = {
        "headerAscii": "",
        "headerHex": "",
        "unityFsOffset": -1,
        "headerClassification": "missing_or_unreadable",
    }
    try:
        with path.open("rb") as f:
            data = f.read(8192)
    except OSError:
        return info
    info["headerHex"] = data[:32].hex()
    info["headerAscii"] = "".join(chr(b) if 32 <= b < 127 else "." for b in data[:32])
    offset = data.find(b"UnityFS")
    info["unityFsOffset"] = offset
    if offset == 0:
        info["headerClassification"] = "unityfs_direct"
    elif offset > 0:
        info["headerClassification"] = "known_wrapper_or_prefix_before_unityfs"
    else:
        info["headerClassification"] = "unityfs_magic_not_found_in_first_8192"
    return info


def sha256_prefix(path: Path, prefix_len: int = 16) -> str:
    h = hashlib.sha256()
    try:
        with path.open("rb") as f:
            for chunk in iter(lambda: f.read(1024 * 1024), b""):
                h.update(chunk)
    except OSError:
        return ""
    return h.hexdigest()[:prefix_len]


def inspect_unity_metadata(path: Path) -> dict:
    result = {
        "unityPyAvailable": False,
        "unityPyLoadOk": False,
        "metadataMatches": [],
        "objectCount": 0,
        "error": "",
    }
    try:
        import UnityPy  # type: ignore

        result["unityPyAvailable"] = True
        env = UnityPy.load(str(path))
        result["unityPyLoadOk"] = True
        matches: set[str] = set()
        needles = [n.lower() for n in METADATA_NEEDLES]
        for obj in env.objects:
            result["objectCount"] += 1
            try:
                data = obj.read()
            except Exception:
                continue
            name = str(getattr(data, "m_Name", "") or "")
            if name and any(n in name.lower() for n in needles):
                matches.add(f"{obj.type.name}:{name}")
            if obj.type.name == "AssetBundle":
                container = getattr(data, "m_Container", None)
                if container:
                    try:
                        items = container.items()
                    except AttributeError:
                        items = []
                    for key, _ in items:
                        key_s = str(key)
                        if any(n in key_s.lower() for n in needles):
                            matches.add(f"Container:{key_s}")
        result["metadataMatches"] = sorted(matches)
    except Exception as exc:
        result["error"] = f"{type(exc).__name__}: {exc}"
    return result


def classify_candidate(row: dict) -> tuple[str, str, str]:
    path_n = norm(row.get("absolutePath"))
    exact_path = norm(TARGET_BUNDLE) in path_n
    same_filename = Path(row.get("absolutePath", "")).name.lower() == TARGET_FILENAME
    category_actor = "roleprefabsandres/battleprefabandres" in path_n
    category_other = same_filename and not category_actor
    unity_ok = bool(row.get("unityPyLoadOk"))
    metadata = norm(row.get("metadataMatches"))
    metadata_actor = any(n in metadata for n in ["hero_1036", "hero1036", "roleprefab_1036"])
    header_ok = row.get("headerClassification") in {"unityfs_direct", "known_wrapper_or_prefix_before_unityfs"}

    if exact_path and header_ok and (metadata_actor or unity_ok):
        return (
            "source_backed_exact_actor_bundle_found",
            "Exact target path exists locally and has UnityFS/wrapper or Unity metadata evidence.",
            "write proposal only; do not copy/import/move",
        )
    if exact_path:
        return (
            "exact_path_candidate_needs_manual_validation",
            "Exact target path string exists locally, but Unity metadata/header validation is incomplete.",
            "manual inspect before proposal",
        )
    if category_other:
        return (
            "weak_same_filename_different_category",
            "Same filename exists, but resource category is not battle actor prefab path.",
            "do not promote as actor bundle",
        )
    if same_filename:
        return (
            "weak_same_filename_unrelated_or_unconfirmed",
            "Same filename exists outside exact source-backed actor path.",
            "do not promote without source path evidence",
        )
    return (
        "unrelated_weak_path_match",
        "Path contains a close string but is not an exact actor bundle candidate.",
        "context only",
    )


def write_csv(path: Path, rows: list[dict], fields: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        for row in rows:
            writer.writerow({k: row.get(k, "") for k in fields})


def build() -> dict:
    os.chdir(ROOT)
    all_candidates: dict[str, Path] = {}
    search_stats = []

    # Downloads contains the current project too; it is intentionally included by task scope.
    for search_root in SEARCH_ROOTS:
        found, stats = iter_targeted_files(search_root, time_limit_s=180.0)
        search_stats.append(stats)
        for path in found:
            all_candidates[str(path).lower()] = path

    # Explicit project-local cache/index pass with a separate shorter time limit for reporting clarity.
    for search_root in PROJECT_LOCAL_ROOTS:
        found, stats = iter_targeted_files(search_root, time_limit_s=90.0)
        stats["projectLocalExplicitPass"] = True
        search_stats.append(stats)
        for path in found:
            all_candidates[str(path).lower()] = path

    archive_hits: list[dict] = []
    archive_stats = []
    for search_root in SEARCH_ROOTS:
        hits, stats = find_zip_entry_candidates(search_root, time_limit_s=90.0)
        archive_hits.extend(hits)
        archive_stats.append(stats)

    rows: list[dict] = []
    for path in sorted(all_candidates.values(), key=lambda p: str(p).lower()):
        st = safe_stat(path)
        if not st:
            continue
        hinfo = header_info(path)
        uinfo = inspect_unity_metadata(path)
        row = {
            "absolutePath": str(path),
            "relativeToProject": rel(path),
            "size": st.st_size,
            "sha256Prefix16": sha256_prefix(path),
            "reasonFound": candidate_reason(path),
            "startsWithUnityFS": hinfo["unityFsOffset"] == 0,
            "unityFsOffset": hinfo["unityFsOffset"],
            "headerClassification": hinfo["headerClassification"],
            "headerAscii": hinfo["headerAscii"],
            "headerHex": hinfo["headerHex"],
            "unityPyAvailable": uinfo["unityPyAvailable"],
            "unityPyLoadOk": uinfo["unityPyLoadOk"],
            "objectCount": uinfo["objectCount"],
            "metadataMatches": "|".join(uinfo["metadataMatches"]),
            "unityPyError": uinfo["error"],
        }
        classification, reason, next_action = classify_candidate(row)
        row["classification"] = classification
        row["classificationReason"] = reason
        row["nextAction"] = next_action
        rows.append(row)

    archive_rows = []
    for hit in archive_hits:
        row = {
            "absolutePath": f"{hit['archivePath']}!/{hit['entry']}",
            "relativeToProject": rel(Path(hit["archivePath"])) + "!/" + hit["entry"],
            "size": hit["entrySize"],
            "sha256Prefix16": "",
            "reasonFound": hit["reason"],
            "startsWithUnityFS": "",
            "unityFsOffset": "",
            "headerClassification": "archive_entry_not_extracted_read_only",
            "headerAscii": "",
            "headerHex": "",
            "unityPyAvailable": "",
            "unityPyLoadOk": "",
            "objectCount": "",
            "metadataMatches": "",
            "unityPyError": "",
            "classification": "archive_entry_exact_or_close_match_not_imported",
            "classificationReason": "Candidate exists as an archive entry name only; no extraction/copy/import was performed.",
            "nextAction": "requires explicit approval before extraction/import; do not promote as local file",
        }
        archive_rows.append(row)

    all_rows = rows + archive_rows
    source_backed = [r for r in rows if r["classification"] == "source_backed_exact_actor_bundle_found"]
    weak_same = [
        r
        for r in all_rows
        if r["classification"]
        in {
            "weak_same_filename_different_category",
            "weak_same_filename_unrelated_or_unconfirmed",
            "archive_entry_exact_or_close_match_not_imported",
            "unrelated_weak_path_match",
            "exact_path_candidate_needs_manual_validation",
        }
    ]
    exact_candidates = [
        r
        for r in all_rows
        if norm(TARGET_BUNDLE) in norm(r.get("absolutePath")) or Path(str(r.get("absolutePath")).split("!/", 1)[0]).name.lower() == TARGET_FILENAME
    ]

    proposal_written = False
    proposal_paths: list[str] = []
    if source_backed:
        proposal_written = True
        proposal = {
            "name": "BATTLE_LOCAL_PLAYABLE_PAYLOAD_ACTOR_UPDATE_PROPOSAL_FROM_CHARACTER64_1036_WIDER_PC_SEARCH",
            "generatedBy": rel(Path(__file__)),
            "classification": "source_backed_exact_actor_bundle_found_proposal_only",
            "doesNotOverwrite": "reports/battle/BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.json",
            "actorBundleUpdates": source_backed,
            "guardrails": {
                "filesCopied": False,
                "filesImported": False,
                "sceneModified": False,
                "networkUsed": False,
            },
        }
        proposal_json = ROOT / "reports" / "battle" / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_ACTOR_UPDATE_PROPOSAL_FROM_CHARACTER64_1036_WIDER_PC_SEARCH.json"
        proposal_csv = ROOT / "reports" / "battle" / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_ACTOR_UPDATE_PROPOSAL_FROM_CHARACTER64_1036_WIDER_PC_SEARCH.csv"
        proposal_json.write_text(json.dumps(proposal, ensure_ascii=False, indent=2), encoding="utf-8")
        fields = list(rows[0].keys()) if rows else ["absolutePath"]
        write_csv(proposal_csv, source_backed, fields)
        proposal_paths = [rel(proposal_json), rel(proposal_csv)]

    result = {
        "name": OUT_BASE,
        "generatedBy": rel(Path(__file__)),
        "generatedAtUtc": datetime.now(timezone.utc).isoformat(),
        "workspace": str(ROOT),
        "networkUsed": False,
        "filesCopied": False,
        "filesImported": False,
        "sceneModified": False,
        "targetBundle": TARGET_BUNDLE,
        "searchScope": {
            "allowedRoots": [str(p) for p in SEARCH_ROOTS],
            "projectLocalRoots": [str(p) for p in PROJECT_LOCAL_ROOTS],
            "broadCDriveScanUsed": False,
            "timeLimitedTargetedFilenameAndPathSearch": True,
            "skippedDirs": [".git", "node_modules", "Library", "Temp", "obj", "bin", ".vs", "__pycache__"],
        },
        "exact1036CandidatesFound": exact_candidates,
        "sourceBackedExactActorBundlesFound": source_backed,
        "weakSameFilenameMatches": weak_same,
        "proposalWritten": proposal_written,
        "proposalPaths": proposal_paths,
        "nextBlocker": "Exact source-backed 1036 battle actor bundle was not found as an already-local file unless sourceBackedExactActorBundlesFound is non-empty; next step remains approved acquisition/local extraction of download/roleprefabsandres/battleprefabandres/1036.assetbundle.",
        "guardrailsTouched": {
            "networkDownloadHeadGet": False,
            "filesCopied": False,
            "filesImported": False,
            "filesMoved": False,
            "filesDeleted": False,
            "sceneModified": False,
            "fakeAliasPromotion": False,
            "broadUnboundedDiskCrawl": False,
        },
        "commandPolicy": command_policy_status(),
        "summary": {
            "candidateFilesInspected": len(rows),
            "archiveEntryMatches": len(archive_rows),
            "exact1036CandidatesFoundCount": len(exact_candidates),
            "sourceBackedExactActorBundleCount": len(source_backed),
            "weakSameFilenameMatchCount": len(weak_same),
            "proposalWritten": proposal_written,
        },
        "searchStats": search_stats,
        "archiveSearchStats": archive_stats,
        "candidateRows": all_rows,
    }
    return result


def write_outputs(result: dict) -> None:
    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    fields = [
        "absolutePath",
        "relativeToProject",
        "size",
        "sha256Prefix16",
        "reasonFound",
        "startsWithUnityFS",
        "unityFsOffset",
        "headerClassification",
        "headerAscii",
        "headerHex",
        "unityPyAvailable",
        "unityPyLoadOk",
        "objectCount",
        "metadataMatches",
        "unityPyError",
        "classification",
        "classificationReason",
        "nextAction",
    ]
    write_csv(OUT_CANDIDATES_CSV, result["candidateRows"], fields)
    write_csv(OUT_CLASSIFICATION_CSV, result["candidateRows"], fields)

    lines = [
        "# CHARACTER_64_LOCAL_EXACT_1036_BUNDLE_WIDER_PC_SEARCH_NO_NETWORK_NO_COPY_NO_IMPORT_RESULT",
        "",
        f"- generatedBy: `{result['generatedBy']}`",
        f"- generatedAtUtc: `{result['generatedAtUtc']}`",
        f"- workspace: `{result['workspace']}`",
        f"- networkUsed: `{result['networkUsed']}`",
        f"- filesCopied: `{result['filesCopied']}`",
        f"- filesImported: `{result['filesImported']}`",
        f"- sceneModified: `{result['sceneModified']}`",
        f"- proposalWritten: `{result['proposalWritten']}`",
        "",
        "## Summary",
        "",
        f"- exact1036CandidatesFound: `{result['summary']['exact1036CandidatesFoundCount']}`",
        f"- sourceBackedExactActorBundlesFound: `{result['summary']['sourceBackedExactActorBundleCount']}`",
        f"- weakSameFilenameMatches: `{result['summary']['weakSameFilenameMatchCount']}`",
        f"- archiveEntryMatches: `{result['summary']['archiveEntryMatches']}`",
        "",
        "## Candidate Matrix",
        "",
        "| classification | size | path | header | UnityPy | metadata matches | next action |",
        "|---|---:|---|---|---|---|---|",
    ]
    for row in result["candidateRows"]:
        lines.append(
            f"| `{row.get('classification')}` | {row.get('size')} | `{row.get('absolutePath')}` | "
            f"`{row.get('headerClassification')}` | `{row.get('unityPyLoadOk')}` | "
            f"`{row.get('metadataMatches')}` | {row.get('nextAction')} |"
        )
    lines.extend(
        [
            "",
            "## Search Scope",
            "",
            "- Searched only allowed roots: `C:\\Users\\godho\\Downloads`, `C:\\Users\\godho\\Documents\\Codex`, plus project-local cache/index folders.",
            "- No recursive `C:\\` crawl was used.",
            "- Search was targeted to filename/path patterns for `1036.assetbundle` and source-backed battle prefab paths.",
            "- Files and archive entries were inspected read-only. No copy/import/move/delete was performed.",
            "",
            "## Outputs",
            "",
            f"- JSON: `{rel(OUT_JSON)}`",
            f"- Candidate CSV: `{rel(OUT_CANDIDATES_CSV)}`",
            f"- Classification CSV: `{rel(OUT_CLASSIFICATION_CSV)}`",
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
    print(f"wrote {rel(OUT_CANDIDATES_CSV)}")
    print(f"wrote {rel(OUT_CLASSIFICATION_CSV)}")
    print(f"proposalWritten={result['proposalWritten']}")


if __name__ == "__main__":
    main()
