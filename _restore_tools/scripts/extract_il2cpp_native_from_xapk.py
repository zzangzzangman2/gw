from __future__ import annotations

import hashlib
import json
import zipfile
from io import BytesIO
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
XAPK = BASE / "girl1.xapk"
OUT = BASE / "il2cpp_native"

TARGETS = [
    ("com.girlwars.kr.apk", "assets/bin/Data/Managed/Metadata/global-metadata.dat", OUT / "global-metadata.dat"),
    ("config.arm64_v8a.apk", "lib/arm64-v8a/libil2cpp.so", OUT / "libil2cpp.so"),
]


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    rows = []
    with zipfile.ZipFile(XAPK, "r") as xapk:
        for apk_name, inner_name, output_path in TARGETS:
            apk_data = xapk.read(apk_name)
            with zipfile.ZipFile(BytesIO(apk_data), "r") as apk:
                data = apk.read(inner_name)
            output_path.write_bytes(data)
            rows.append(
                {
                    "xapk": str(XAPK),
                    "apk": apk_name,
                    "inner_path": inner_name,
                    "output": str(output_path),
                    "size": len(data),
                    "sha256": sha256(data),
                }
            )
    (OUT / "il2cpp_native_summary.json").write_text(json.dumps(rows, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(rows, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
