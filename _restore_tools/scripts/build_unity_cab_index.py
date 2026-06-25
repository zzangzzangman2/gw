from __future__ import annotations

import csv
import json
import time
from pathlib import Path

import UnityPy


SOURCE_ROOT = Path(r"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted")
CLEAN_ROOT = SOURCE_ROOT / "extracted" / "unity" / "clean_unityfs_slices"
OUT_CSV = SOURCE_ROOT / "indexes" / "unity_cab_to_bundle.csv"
OUT_JSON = SOURCE_ROOT / "indexes" / "unity_cab_to_bundle_summary.json"


def bundle_name(path: Path) -> str:
    return path.relative_to(CLEAN_ROOT).as_posix()


def main() -> None:
    started = time.time()
    files = [p for p in CLEAN_ROOT.rglob("*") if p.is_file()]
    rows: list[dict[str, str]] = []
    failures: list[dict[str, str]] = []
    for index, path in enumerate(files, start=1):
        try:
            env = UnityPy.load(path.read_bytes())
            names = sorted({asset.name for asset in env.assets if getattr(asset, "name", "")})
        except Exception as exc:
            failures.append({"bundle": bundle_name(path), "error": repr(exc)})
            continue
        for name in names:
            rows.append(
                {
                    "cab_name": name,
                    "bundle": bundle_name(path),
                    "clean_path": path.as_posix(),
                }
            )
        if index % 200 == 0:
            print(f"indexed {index}/{len(files)} files, cab rows {len(rows)}, failures {len(failures)}")

    OUT_CSV.parent.mkdir(parents=True, exist_ok=True)
    with OUT_CSV.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=["cab_name", "bundle", "clean_path"])
        writer.writeheader()
        writer.writerows(rows)

    summary = {
        "files_seen": len(files),
        "cab_rows": len(rows),
        "unique_cabs": len({row["cab_name"] for row in rows}),
        "failures": len(failures),
        "seconds": round(time.time() - started, 3),
        "failure_samples": failures[:20],
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
