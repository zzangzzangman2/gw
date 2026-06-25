from __future__ import annotations

import argparse
import csv
import hashlib
import json
import shutil
import zipfile
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DIR = PROJECT / "Assets" / "RestoreData" / "reports"
REPORT_MD_DIR = BASE / "reports" / "source_cleanup"

XAPK = BASE / "girl1.xapk"
COM_DIR = BASE / "com.girlwars.kr"
SPLIT_APKS = MERGED / "split_apks"
MERGED_CONTENT = MERGED / "merged_content"
INDEX_DIR = MERGED / "indexes"
IL2CPP_NATIVE = BASE / "il2cpp_native"

OUT_CSV = REPORT_DIR / "source_disposal_file_coverage.csv"
OUT_JSON = REPORT_DIR / "source_disposal_readiness_summary.json"
OUT_MD = REPORT_MD_DIR / "SOURCE_DISPOSAL_READINESS.md"


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def sha256_zip_entry(zf: zipfile.ZipFile, name: str) -> str:
    digest = hashlib.sha256()
    with zf.open(name, "r") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def norm(path: Path | str) -> str:
    return str(Path(path)).lower()


def safe_remove_file(path: Path) -> bool:
    resolved = path.resolve()
    if resolved.parent != BASE.resolve():
        raise RuntimeError(f"Refusing to delete outside base folder: {resolved}")
    if path.exists():
        path.unlink()
        return True
    return False


def safe_remove_tree(path: Path) -> bool:
    resolved = path.resolve()
    if resolved.parent != BASE.resolve() or resolved.name != "com.girlwars.kr":
        raise RuntimeError(f"Refusing to delete unexpected folder: {resolved}")
    if path.exists():
        shutil.rmtree(path)
        return True
    return False


def verify_xapk(extract_missing_icon: bool) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    summary: dict[str, Any] = {
        "exists": XAPK.exists(),
        "ready_to_delete": False,
        "entry_count": 0,
        "matched_entries": 0,
        "missing_entries": 0,
        "mismatch_entries": 0,
        "extracted_missing_entries": 0,
        "note": "",
    }
    if not XAPK.exists():
        summary["ready_to_delete"] = True
        summary["note"] = "girl1.xapk already removed."
        return rows, summary

    SPLIT_APKS.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(XAPK, "r") as zf:
        entries = [info for info in zf.infolist() if not info.is_dir()]
        summary["entry_count"] = len(entries)
        for info in entries:
            dest = SPLIT_APKS / info.filename
            action = ""
            if not dest.exists() and extract_missing_icon and info.filename == "icon.png":
                dest.parent.mkdir(parents=True, exist_ok=True)
                with zf.open(info.filename, "r") as src, dest.open("wb") as out:
                    shutil.copyfileobj(src, out, length=1024 * 1024)
                action = "extracted_missing_icon"
                summary["extracted_missing_entries"] += 1

            zip_hash = sha256_zip_entry(zf, info.filename)
            if dest.exists():
                dest_hash = sha256_file(dest)
                if dest.stat().st_size == info.file_size and dest_hash == zip_hash:
                    status = "matched_split_copy"
                    summary["matched_entries"] += 1
                else:
                    status = "hash_or_size_mismatch"
                    summary["mismatch_entries"] += 1
            else:
                dest_hash = ""
                status = "missing_from_split_apks"
                summary["missing_entries"] += 1

            rows.append(
                {
                    "source": "girl1.xapk",
                    "relative_path": info.filename,
                    "size": info.file_size,
                    "sha256": zip_hash,
                    "coverage_status": status,
                    "covered_by": str(dest) if dest.exists() else "",
                    "action": action,
                }
            )

    summary["ready_to_delete"] = summary["missing_entries"] == 0 and summary["mismatch_entries"] == 0
    if summary["ready_to_delete"]:
        summary["note"] = "All XAPK entries are present as exact split_apks copies."
    return rows, summary


def build_index_maps() -> tuple[dict[str, list[dict[str, str]]], dict[str, dict[str, str]], dict[str, list[dict[str, str]]]]:
    conflicts = read_csv(INDEX_DIR / "conflicts.csv")
    merged_files = read_csv(INDEX_DIR / "merged_files.csv")

    by_source: dict[str, list[dict[str, str]]] = {}
    by_relative: dict[str, dict[str, str]] = {}
    conflicts_by_relative: dict[str, list[dict[str, str]]] = {}

    for row in conflicts:
        source_path = row.get("source_path", "")
        if source_path:
            by_source.setdefault(norm(source_path), []).append(row)
        rel = row.get("relative_path", "")
        if rel:
            conflicts_by_relative.setdefault(rel, []).append(row)

    for row in merged_files:
        source_path = row.get("winner_source_path", "")
        if source_path:
            by_source.setdefault(norm(source_path), []).append(
                {
                    "relative_path": row.get("relative_path", ""),
                    "kept": "True",
                    "source_kind": row.get("winner_source", ""),
                    "size": row.get("size", ""),
                    "sha256": row.get("sha256", ""),
                    "source_path": source_path,
                }
            )
        rel = row.get("relative_path", "")
        if rel:
            by_relative[rel] = row

    return by_source, by_relative, conflicts_by_relative


def expected_il2cpp_copy(source: Path) -> Path | None:
    try:
        rel = source.relative_to(COM_DIR / "files" / "il2cpp")
    except ValueError:
        return None
    if rel.parts and rel.parts[0].lower() == "metadata" and rel.name == "global-metadata.dat":
        return IL2CPP_NATIVE / "global-metadata.dat"
    if rel.name == "libil2cpp.so":
        return IL2CPP_NATIVE / "libil2cpp.so"
    return IL2CPP_NATIVE / rel


def verify_com_dir() -> tuple[list[dict[str, Any]], dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    summary: dict[str, Any] = {
        "exists": COM_DIR.exists(),
        "ready_to_delete": False,
        "file_count": 0,
        "total_size": 0,
        "covered_count": 0,
        "not_needed_cache_count": 0,
        "older_duplicate_count": 0,
        "unresolved_count": 0,
        "by_status": {},
        "note": "",
    }
    if not COM_DIR.exists():
        summary["ready_to_delete"] = True
        summary["note"] = "com.girlwars.kr already removed."
        return rows, summary

    by_source, by_relative, _ = build_index_maps()
    status_counts: Counter[str] = Counter()

    files = [p for p in COM_DIR.rglob("*") if p.is_file()]
    summary["file_count"] = len(files)
    summary["total_size"] = sum(p.stat().st_size for p in files)

    for path in files:
        rel = path.relative_to(COM_DIR).as_posix()
        size = path.stat().st_size
        source_rows = by_source.get(norm(path), [])
        coverage_status = ""
        covered_by = ""
        action = ""
        source_hash = ""

        if rel.lower().startswith("cache/unityshadercache/"):
            coverage_status = "runtime_shader_cache_not_needed"
            action = "safe_to_discard_cache"
            summary["not_needed_cache_count"] += 1
        elif source_rows:
            kept_rows = [r for r in source_rows if str(r.get("kept", "")).lower() == "true"]
            first = source_rows[0]
            source_hash = first.get("sha256", "")
            rel_out = first.get("relative_path", "")
            if kept_rows:
                coverage_status = "covered_as_latest_winner"
                covered_by = str(MERGED_CONTENT / rel_out) if rel_out else ""
            else:
                winner = by_relative.get(rel_out, {})
                coverage_status = "covered_by_newer_duplicate"
                covered_by = str(MERGED_CONTENT / rel_out) if rel_out else ""
                action = f"winner_sha256={winner.get('sha256', '')}"
                summary["older_duplicate_count"] += 1
        else:
            il2cpp_copy = expected_il2cpp_copy(path)
            if il2cpp_copy and il2cpp_copy.exists() and il2cpp_copy.stat().st_size == size:
                src_hash = sha256_file(path)
                dst_hash = sha256_file(il2cpp_copy)
                source_hash = src_hash
                if src_hash == dst_hash:
                    coverage_status = "covered_in_il2cpp_native"
                    covered_by = str(il2cpp_copy)
                else:
                    coverage_status = "unresolved_hash_mismatch"
            else:
                coverage_status = "unresolved_not_in_merge_index"
                source_hash = sha256_file(path)

        if coverage_status.startswith("covered") or coverage_status == "runtime_shader_cache_not_needed":
            summary["covered_count"] += 1
        else:
            summary["unresolved_count"] += 1

        status_counts[coverage_status] += 1
        rows.append(
            {
                "source": "com.girlwars.kr",
                "relative_path": rel,
                "size": size,
                "sha256": source_hash,
                "coverage_status": coverage_status,
                "covered_by": covered_by,
                "action": action,
            }
        )

    summary["by_status"] = dict(status_counts)
    summary["ready_to_delete"] = summary["unresolved_count"] == 0
    if summary["ready_to_delete"]:
        summary["note"] = "All useful files are merged, copied, or intentionally discarded as runtime shader cache."
    return rows, summary


def write_markdown(summary: dict[str, Any], rows: list[dict[str, Any]]) -> None:
    REPORT_MD_DIR.mkdir(parents=True, exist_ok=True)
    unresolved = [r for r in rows if str(r.get("coverage_status", "")).startswith("unresolved")]
    md = [
        "# GirlsWar Source Disposal Readiness",
        "",
        f"- Generated: `{summary['generated_at']}`",
        f"- XAPK ready to delete: `{summary['xapk']['ready_to_delete']}`",
        f"- com.girlwars.kr ready to delete: `{summary['com_dir']['ready_to_delete']}`",
        f"- Deleted in this run: `{summary['deleted_in_this_run']}`",
        "",
        "## XAPK",
        "",
        f"- Exists: `{summary['xapk']['exists']}`",
        f"- Entries: `{summary['xapk']['entry_count']}`",
        f"- Matched split copies: `{summary['xapk']['matched_entries']}`",
        f"- Missing entries: `{summary['xapk']['missing_entries']}`",
        f"- Mismatch entries: `{summary['xapk']['mismatch_entries']}`",
        f"- Extracted missing entries: `{summary['xapk']['extracted_missing_entries']}`",
        f"- Note: {summary['xapk']['note']}",
        "",
        "## com.girlwars.kr",
        "",
        f"- Exists: `{summary['com_dir']['exists']}`",
        f"- Files checked: `{summary['com_dir']['file_count']}`",
        f"- Total size: `{summary['com_dir']['total_size']}`",
        f"- Covered or intentionally discardable: `{summary['com_dir']['covered_count']}`",
        f"- Older duplicates removed by latest-only merge: `{summary['com_dir']['older_duplicate_count']}`",
        f"- Runtime shader cache files: `{summary['com_dir']['not_needed_cache_count']}`",
        f"- Unresolved files: `{summary['com_dir']['unresolved_count']}`",
        f"- Note: {summary['com_dir']['note']}",
        "",
        "## Status Counts",
        "",
    ]
    for key, value in sorted(summary["com_dir"]["by_status"].items()):
        md.append(f"- `{key}`: `{value}`")

    md.extend(["", "## Unresolved"])
    if unresolved:
        md.append("")
        for row in unresolved[:100]:
            md.append(f"- `{row['relative_path']}`: `{row['coverage_status']}`")
        if len(unresolved) > 100:
            md.append(f"- ... plus `{len(unresolved) - 100}` more")
    else:
        md.append("")
        md.append("No unresolved files remain from these two source roots.")

    md.extend(
        [
            "",
            "## Outputs",
            "",
            f"- CSV: `{OUT_CSV}`",
            f"- JSON: `{OUT_JSON}`",
            f"- Markdown: `{OUT_MD}`",
        ]
    )
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--delete-ready-sources", action="store_true")
    parser.add_argument("--no-extract-icon", action="store_true")
    args = parser.parse_args()

    xapk_rows, xapk_summary = verify_xapk(extract_missing_icon=not args.no_extract_icon)
    com_rows, com_summary = verify_com_dir()
    rows = xapk_rows + com_rows

    deleted: list[str] = []
    if args.delete_ready_sources and xapk_summary["ready_to_delete"] and XAPK.exists():
        if safe_remove_file(XAPK):
            deleted.append(str(XAPK))
    if args.delete_ready_sources and com_summary["ready_to_delete"] and COM_DIR.exists():
        if safe_remove_tree(COM_DIR):
            deleted.append(str(COM_DIR))

    summary = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "base": str(BASE),
        "xapk": xapk_summary,
        "com_dir": com_summary,
        "deleted_in_this_run": deleted,
        "csv": str(OUT_CSV),
        "json": str(OUT_JSON),
        "markdown": str(OUT_MD),
    }

    write_csv(
        OUT_CSV,
        rows,
        ["source", "relative_path", "size", "sha256", "coverage_status", "covered_by", "action"],
    )
    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    write_markdown(summary, rows)

    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
