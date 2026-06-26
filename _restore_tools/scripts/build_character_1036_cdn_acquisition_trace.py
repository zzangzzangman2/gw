from __future__ import annotations

import csv
import hashlib
import json
import re
import zipfile
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
INDEX_DIR = MERGED / "indexes"
REPORT_DIR = BASE / "reports" / "characters"

TARGET_BUNDLE = "download/roleprefabsandres/battleprefabandres/1036.assetbundle"
TARGET_MD5 = "570c8238257cd8ca00a0856427d8c0ae"
TARGET_SIZE = 1666251
TARGET_RES_OFFSET = 224

OUT_JSON = REPORT_DIR / "CHARACTER_1036_CDN_ACQUISITION_TRACE.json"
OUT_MD = REPORT_DIR / "CHARACTER_1036_CDN_ACQUISITION_TRACE.md"
OUT_CSV = REPORT_DIR / "CHARACTER_1036_CDN_ACQUISITION_TRACE.csv"

CSV_FILES = {
    "assetbundles": INDEX_DIR / "assetbundles.csv",
    "merged_files": INDEX_DIR / "merged_files.csv",
    "conflicts": INDEX_DIR / "conflicts.csv",
    "versionfile": INDEX_DIR / "versionfile_VersionFile_bytes.csv",
    "cdn_versionfile": INDEX_DIR / "versionfile_CDNVersionFile_bytes.csv",
}

BOOTSTRAP_FILES = [
    MERGED / "merged_content" / "AssetBundles" / "VersionFile.bytes",
    MERGED / "merged_content" / "AssetBundles" / "CDNVersionFile.bytes",
    MERGED / "merged_content" / "AssetBundles" / "InitConfigVersionFile.bytes",
    MERGED / "merged_content" / "AssetBundles" / "InitCfgAppVersionFile.bytes",
    MERGED / "merged_content" / "AssetBundles" / "ResourceVersion",
    MERGED / "merged_content" / "AssetBundles" / "AppVersion",
    MERGED / "restore_overlay" / "Android" / "data" / "com.girlwars.kr" / "files" / "VersionFile.bytes",
    MERGED / "restore_overlay" / "Android" / "data" / "com.girlwars.kr" / "files" / "CDNVersionFile.bytes",
    MERGED / "restore_overlay" / "Android" / "data" / "com.girlwars.kr" / "files" / "InitConfigVersionFile.bytes",
    MERGED / "restore_overlay" / "Android" / "data" / "com.girlwars.kr" / "files" / "InitCfgAppVersionFile.bytes",
    BASE / "work" / "apk_probe" / "data.unity3d",
    BASE / "work" / "apk_probe" / "global-metadata.dat",
    BASE / "work" / "apk_probe" / "libil2cpp.so",
    BASE / "work" / "apk_probe" / "libunity.so",
    BASE / "il2cpp_native" / "global-metadata.dat",
    BASE / "il2cpp_native" / "libil2cpp.so",
]

SPLIT_APKS = [
    MERGED / "split_apks" / "com.girlwars.kr.apk",
    MERGED / "split_apks" / "config.arm64_v8a.apk",
    MERGED / "split_apks" / "abassets.apk",
]

URL_START_RE = re.compile(rb"https?://")
URL_RE = re.compile(rb"https?://[A-Za-z0-9._~:/?#\[\]@!$&'()*+,;=%-]+")
ASCII_RE = re.compile(rb"[\x20-\x7e]{4,}")
KEYWORDS = [
    "cdn",
    "asset",
    "bundle",
    "versionfile",
    "resource",
    "resurl",
    "download",
    "update",
    "oss",
    "akama",
    "qcloud",
    "aliyun",
    "tianlong",
    "girlwars",
    "girl",
    "login",
]


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


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    fields = [
        "category",
        "classification",
        "source",
        "path",
        "entry",
        "url",
        "domain",
        "evidence",
        "size",
        "md5",
        "isExactTarget",
        "note",
    ]
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def domain_of(url: str) -> str:
    m = re.match(r"https?://([^/:?#]+)", url)
    return m.group(1).lower() if m else ""


def valid_url_host(host: str) -> bool:
    if not host or "http" in host:
        return False
    return "." in host or host in {"localhost"}


def classify_url(url: str) -> str:
    host = domain_of(url)
    text = url.lower()
    if not valid_url_host(host):
        return "malformed_url_string"
    if "schemas.android.com" in host:
        return "android_schema_url"
    if any(x in host for x in ["docs.unity3d.com", "learn.microsoft.com", "developer.android.com"]):
        return "third_party_docs_url"
    if any(x in host for x in ["github.com", "gstatic.com", "firebaseio.com", "facebook.net", "facebook.com"]):
        return "third_party_sdk_or_docs_url"
    if "onestore.co.kr" in host:
        return "app_store_or_market_url"
    if any(x in text for x in ["uwa4d", "uwa-public", "uwa-private", "uwa-profdata", "uwacore", "uwa-got"]):
        return "third_party_observability_url"
    if any(x in text for x in ["login", "account", "bigdaccserver", "sdk", "pay", "auth"]):
        return "login_or_account_url"
    game_terms = ["girlwars", "girlwar", "tianlonginc"]
    asset_terms = ["cdn", "asset", "resource", "res", "bundle", "oss", "download", "update", "versionfile"]
    if any(x in text for x in game_terms) and any(x in text for x in asset_terms):
        return "candidate_asset_cdn_url"
    if "tianlonginc.com" in host or "girlwars" in host or "girlwar" in host:
        return "game_service_url_unclassified"
    return "unclassified_url"


def safe_read_bytes(path: Path, max_bytes: int | None = None) -> bytes:
    data = path.read_bytes()
    return data[:max_bytes] if max_bytes else data


def extract_url_records_from_bytes(data: bytes, source: str, path: Path, entry: str = "") -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    seen: set[str] = set()
    starts = [m.start() for m in URL_START_RE.finditer(data)]
    for idx, start in enumerate(starts):
        end = starts[idx + 1] if idx + 1 < len(starts) else min(len(data), start + 4096)
        segment = data[start:end]
        m = URL_RE.match(segment)
        if not m:
            continue
        url = m.group(0).decode("utf-8", errors="replace").rstrip(").,;'\"")
        if classify_url(url) == "malformed_url_string":
            continue
        if url in seen:
            continue
        seen.add(url)
        records.append(
            {
                "category": "url",
                "classification": classify_url(url),
                "source": source,
                "path": rel(path),
                "entry": entry,
                "url": url,
                "domain": domain_of(url),
                "evidence": url,
            }
        )
    return records


def extract_keyword_string_records(data: bytes, source: str, path: Path, entry: str = "", limit: int = 80) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    seen: set[str] = set()
    for m in ASCII_RE.finditer(data):
        s = m.group(0).decode("utf-8", errors="replace")
        low = s.lower()
        if not any(k in low for k in KEYWORDS):
            continue
        if s in seen:
            continue
        seen.add(s)
        records.append(
            {
                "category": "keyword_string",
                "classification": "bootstrap_string",
                "source": source,
                "path": rel(path),
                "entry": entry,
                "evidence": s[:260],
            }
        )
        if len(records) >= limit:
            break
    return records


def scan_regular_file(path: Path, source: str) -> list[dict[str, Any]]:
    if not path.exists() or not path.is_file():
        return []
    data = safe_read_bytes(path)
    return extract_url_records_from_bytes(data, source, path) + extract_keyword_string_records(data, source, path)


def scan_decoded_lua() -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    for root in [MERGED / "decoded" / "xlua", MERGED / "decoded" / "xlua_battle"]:
        if not root.exists():
            continue
        for path in root.rglob("*.lua"):
            try:
                data = path.read_bytes()
            except OSError:
                continue
            low = data.lower()
            if b"http" not in low and not any(k.encode() in low for k in KEYWORDS):
                continue
            records.extend(extract_url_records_from_bytes(data, "decoded_lua", path))
            # Keep keyword snippets only for files likely involved in bootstrap/download.
            name_low = path.name.lower()
            if any(k in name_low for k in ["download", "version", "res", "asset", "init", "login", "http", "sdk", "network"]):
                records.extend(extract_keyword_string_records(data, "decoded_lua", path, limit=20))
    return records


def scan_apk(path: Path) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    if not path.exists():
        return records
    with zipfile.ZipFile(path) as zf:
        for info in zf.infolist():
            name = info.filename
            low = name.lower()
            if TARGET_BUNDLE in norm(name):
                records.append(
                    {
                        "category": "zip_entry",
                        "classification": "target_path_inside_apk",
                        "source": "split_apk",
                        "path": rel(path),
                        "entry": name,
                        "size": info.file_size,
                        "isExactTarget": True,
                    }
                )
            should_scan = (
                info.file_size <= 20_000_000
                and not info.is_dir()
                and (
                    low.endswith((".txt", ".json", ".xml", ".bytes", ".dat", ".so", ".unity3d"))
                    or "assets/bin/data" in low
                    or "global-metadata" in low
                    or "libil2cpp" in low
                    or "libunity" in low
                )
            )
            if not should_scan:
                continue
            try:
                data = zf.read(info)
            except Exception:
                continue
            records.extend(extract_url_records_from_bytes(data, "split_apk", path, name))
            if b"http" in data.lower() or any(k.encode() in data.lower() for k in KEYWORDS):
                records.extend(extract_keyword_string_records(data, "split_apk", path, name, limit=30))
    return records


def exact_local_trace() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    target = norm(TARGET_BUNDLE)
    for name, path in CSV_FILES.items():
        for row in read_csv(path):
            haystack = " ".join(str(v) for v in row.values())
            if target in norm(haystack) or TARGET_MD5 in haystack.lower():
                rows.append(
                    {
                        "category": "index_row",
                        "classification": "exact_target_index_evidence",
                        "source": name,
                        "path": rel(path),
                        "evidence": json.dumps(row, ensure_ascii=False),
                        "size": row.get("Size") or row.get("size") or "",
                        "md5": row.get("MD5") or row.get("md5") or "",
                        "isExactTarget": target in norm(haystack),
                    }
                )

    exact_rel = Path(*TARGET_BUNDLE.split("/"))
    roots = [
        MERGED / "merged_content" / "AssetBundles",
        MERGED / "restore_overlay" / "Android" / "data" / "com.girlwars.kr" / "files",
        MERGED / "restore_overlay" / "Android" / "data" / "com.girlwars.kr" / "files" / "build",
        MERGED / "extracted" / "unity" / "clean_unityfs_slices",
        MERGED / "extracted" / "unity" / "bundles",
        MERGED / "split_apks",
    ]
    for root in roots:
        candidate = root / exact_rel
        rows.append(
            {
                "category": "local_exact_path",
                "classification": "local_exact_path_check",
                "source": "filesystem",
                "path": rel(candidate),
                "size": candidate.stat().st_size if candidate.exists() else "",
                "md5": hashlib.md5(candidate.read_bytes()).hexdigest() if candidate.exists() and candidate.stat().st_size < 50_000_000 else "",
                "isExactTarget": candidate.exists(),
                "note": "exists" if candidate.exists() else "missing",
            }
        )

    same_name: list[Path] = []
    for root in roots:
        if root.exists():
            same_name.extend(p for p in root.rglob("1036.assetbundle") if p.is_file())
    for path in sorted(set(same_name)):
        rows.append(
            {
                "category": "same_filename",
                "classification": "same_filename_different_path",
                "source": "filesystem",
                "path": rel(path),
                "size": path.stat().st_size,
                "md5": hashlib.md5(path.read_bytes()).hexdigest() if path.stat().st_size < 50_000_000 else "",
                "isExactTarget": norm(path).endswith(target),
                "note": "same filename; path must not be treated as target unless exact",
            }
        )
    return rows


def build_report() -> dict[str, Any]:
    local_rows = exact_local_trace()
    scan_records: list[dict[str, Any]] = []
    for path in BOOTSTRAP_FILES:
        scan_records.extend(scan_regular_file(path, "bootstrap_or_native"))
    scan_records.extend(scan_decoded_lua())
    for path in SPLIT_APKS:
        scan_records.extend(scan_apk(path))

    # Deduplicate noisy repeated strings while preserving first evidence source.
    deduped: list[dict[str, Any]] = []
    seen: set[tuple[str, str, str, str]] = set()
    for row in scan_records:
        key = (row.get("category", ""), row.get("classification", ""), row.get("url", ""), row.get("evidence", ""))
        if key in seen:
            continue
        seen.add(key)
        deduped.append(row)

    version_rows = [r for r in local_rows if r["category"] == "index_row" and r["source"] in {"cdn_versionfile", "versionfile"}]
    asset_cdn_urls = [r for r in deduped if r.get("classification") == "candidate_asset_cdn_url"]
    login_urls = [r for r in deduped if r.get("classification") == "login_or_account_url"]
    exact_local_exists = any(r.get("category") == "local_exact_path" and r.get("isExactTarget") for r in local_rows)

    if exact_local_exists:
        classification = "fetch_not_needed_local_exact_file_exists"
    elif asset_cdn_urls:
        # URL presence alone is not enough for download_ready; the report keeps it as a candidate.
        classification = "candidate_asset_cdn_found_needs_confirmation"
    else:
        classification = "not_fetchable_from_local_evidence"

    target = {
        "bundle": TARGET_BUNDLE,
        "md5": TARGET_MD5,
        "size": TARGET_SIZE,
        "isEncrypt": True,
        "resOffset": TARGET_RES_OFFSET,
        "cdnVersionFileEvidence": version_rows,
    }

    return {
        "name": "CHARACTER_1036_CDN_ACQUISITION_TRACE",
        "generatedBy": rel(Path(__file__)),
        "classification": classification,
        "target": target,
        "localAcquisitionTrace": {
            "exactLocalFileExists": exact_local_exists,
            "rows": local_rows,
        },
        "urlEvidence": {
            "candidateAssetCdnUrls": asset_cdn_urls,
            "loginOrAccountUrls": login_urls,
            "otherUrls": [r for r in deduped if r.get("category") == "url" and r not in asset_cdn_urls and r not in login_urls],
            "bootstrapKeywordStrings": [r for r in deduped if r.get("category") == "keyword_string"][:160],
        },
        "downloadAssessment": {
            "headOrGetReady": False,
            "actualDownloadExecuted": False,
            "reason": (
                "No asset CDN base URL/build rule was strong enough to combine with path+md5+size. Login/account URLs are explicitly not used for asset download."
                if not asset_cdn_urls
                else "Candidate asset CDN-like URL strings exist, but no validated URL build rule combining base URL with AssetBundleName/md5/version was proven. Control-tower confirmation is required before any HEAD/GET."
            ),
        },
        "principles": [
            "No original/evidence files were deleted or moved.",
            "No Unity scene was modified.",
            "No fake actor mapping or guessed URL was introduced.",
            "No download, HEAD, or GET was executed.",
        ],
    }


def write_reports(report: dict[str, Any]) -> None:
    write_json(OUT_JSON, report)
    flat_rows: list[dict[str, Any]] = []
    flat_rows.extend(report["localAcquisitionTrace"]["rows"])
    flat_rows.extend(report["urlEvidence"]["candidateAssetCdnUrls"])
    flat_rows.extend(report["urlEvidence"]["loginOrAccountUrls"])
    flat_rows.extend(report["urlEvidence"]["otherUrls"])
    flat_rows.extend(report["urlEvidence"]["bootstrapKeywordStrings"])
    write_csv(OUT_CSV, flat_rows)

    local_exact = [r for r in report["localAcquisitionTrace"]["rows"] if r["category"] == "local_exact_path"]
    same_name = [r for r in report["localAcquisitionTrace"]["rows"] if r["category"] == "same_filename"]
    lines = [
        "# CHARACTER_1036_CDN_ACQUISITION_TRACE",
        "",
        f"- Classification: `{report['classification']}`",
        f"- Target bundle: `{TARGET_BUNDLE}`",
        f"- Target md5/size/encrypt/offset: `{TARGET_MD5}` / `{TARGET_SIZE}` / `True` / `{TARGET_RES_OFFSET}`",
        f"- Download/HEAD/GET executed: `{report['downloadAssessment']['actualDownloadExecuted']}`",
        "",
        "## Local Acquisition Trace",
        f"- Exact local file exists: `{report['localAcquisitionTrace']['exactLocalFileExists']}`",
        f"- CDNVersionFile/VersionFile target rows: `{len(report['target']['cdnVersionFileEvidence'])}`",
        f"- Same filename non-target files: `{len(same_name)}`",
        "",
        "| check | path | exists/target | size | md5 | note |",
        "| --- | --- | --- | ---: | --- | --- |",
    ]
    for row in local_exact + same_name:
        lines.append(
            f"| {row['category']} | `{row['path']}` | `{row.get('isExactTarget')}` | {row.get('size', '')} | `{row.get('md5', '')}` | {row.get('note', '')} |"
        )
    lines.extend(
        [
            "",
            "## URL Evidence",
            f"- Candidate asset CDN URLs: `{len(report['urlEvidence']['candidateAssetCdnUrls'])}`",
            f"- Login/account URLs: `{len(report['urlEvidence']['loginOrAccountUrls'])}`",
            f"- Other URLs: `{len(report['urlEvidence']['otherUrls'])}`",
            "",
        ]
    )
    if report["urlEvidence"]["candidateAssetCdnUrls"]:
        lines.extend(["### Candidate Asset CDN-Like URLs", "| classification | domain | url | source |", "| --- | --- | --- | --- |"])
        for row in report["urlEvidence"]["candidateAssetCdnUrls"][:30]:
            lines.append(f"| `{row['classification']}` | `{row.get('domain', '')}` | `{row.get('url', '')}` | `{row.get('path', '')}` |")
    else:
        lines.append("No candidate asset CDN URL/build rule was proven from local evidence.")
    if report["urlEvidence"]["loginOrAccountUrls"]:
        lines.extend(["", "### Login/Account URLs", "| classification | domain | url | source |", "| --- | --- | --- | --- |"])
        for row in report["urlEvidence"]["loginOrAccountUrls"][:30]:
            lines.append(f"| `{row['classification']}` | `{row.get('domain', '')}` | `{row.get('url', '')}` | `{row.get('path', '')}` |")
    lines.extend(
        [
            "",
            "## Download Assessment",
            f"- HEAD/GET ready: `{report['downloadAssessment']['headOrGetReady']}`",
            f"- Reason: {report['downloadAssessment']['reason']}",
            "",
            "## Outputs",
            f"- JSON: `reports/characters/{OUT_JSON.name}`",
            f"- CSV: `reports/characters/{OUT_CSV.name}`",
        ]
    )
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    report = build_report()
    write_reports(report)
    print(f"Wrote {OUT_JSON}")
    print(f"Wrote {OUT_MD}")
    print(f"Wrote {OUT_CSV}")
    print(
        json.dumps(
            {
                "classification": report["classification"],
                "candidateAssetCdnUrls": len(report["urlEvidence"]["candidateAssetCdnUrls"]),
                "loginOrAccountUrls": len(report["urlEvidence"]["loginOrAccountUrls"]),
                "headOrGetReady": report["downloadAssessment"]["headOrGetReady"],
                "downloadExecuted": report["downloadAssessment"]["actualDownloadExecuted"],
            },
            ensure_ascii=False,
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
