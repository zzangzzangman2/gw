from __future__ import annotations

import csv
import json
from pathlib import Path

import UnityPy


SOURCE_ROOT = Path(r"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted")
PROJECT_ROOT = Path(r"C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity")
SPRITE_MAP = PROJECT_ROOT / "Assets" / "RestoreData" / "maininterface_sprite_map.csv"
OUT_ROOT = SOURCE_ROOT / "extracted" / "unity" / "manual_sprite_reextract" / "maininterface"


def clean_slice(bundle: str) -> Path:
    return SOURCE_ROOT / "extracted" / "unity" / "clean_unityfs_slices" / Path(bundle)


def safe_segment(value: str, limit: int = 90) -> str:
    result = []
    for ch in value.replace("\\", "/"):
        if ch.isalnum() or ch in "._-":
            result.append(ch)
        elif ch == "/":
            result.append("_")
        else:
            result.append("_")
    text = "".join(result).strip("._")
    return (text or "unnamed")[:limit]


def read_missing_targets() -> dict[str, set[int]]:
    with SPRITE_MAP.open("r", encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f)
        targets: dict[str, set[int]] = {}
        for row in reader:
            if row.get("status") != "missing_extracted_sprite_png":
                continue
            bundle = row.get("dependency_bundle", "")
            path_id = row.get("path_id", "")
            if not bundle or not path_id:
                continue
            targets.setdefault(bundle, set()).add(int(path_id))
        return targets


def export_sprite(bundle: str, path_id: int) -> dict[str, str]:
    env = UnityPy.load(clean_slice(bundle).read_bytes())
    objects = {obj.path_id: obj for obj in env.objects}
    sprite_obj = objects[path_id]
    sprite = sprite_obj.read()
    name = getattr(sprite, "m_Name", "") or f"sprite_{path_id}"
    rect = sprite.m_RD.textureRect
    texture_ref = sprite.m_RD.texture
    texture_obj = objects[texture_ref.m_PathID]
    texture = texture_obj.read()
    image = texture.image

    x = int(round(float(rect.x)))
    y = int(round(float(rect.y)))
    width = int(round(float(rect.width)))
    height = int(round(float(rect.height)))
    if width <= 0 or height <= 0:
        raise ValueError(f"invalid rect {rect}")

    # Unity texture coordinates are bottom-left. PIL crops from top-left.
    top = image.height - y - height
    left = x
    crop = image.crop((left, top, left + width, top + height))

    out_dir = OUT_ROOT / safe_segment(bundle.replace(".assetbundle", ""))
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / f"{path_id}_{safe_segment(name)}.png"
    crop.save(out_path)
    return {
        "bundle": bundle,
        "path_id": str(path_id),
        "type": "Sprite",
        "name": name,
        "width": str(width),
        "height": str(height),
        "output": out_path.relative_to(SOURCE_ROOT).as_posix(),
        "error": "",
        "texture_path_id": str(texture_ref.m_PathID),
        "texture_width": str(image.width),
        "texture_height": str(image.height),
    }


def main() -> None:
    targets = read_missing_targets()
    rows: list[dict[str, str]] = []
    failures: list[dict[str, str]] = []
    for bundle, path_ids in targets.items():
        for path_id in sorted(path_ids):
            try:
                rows.append(export_sprite(bundle, path_id))
            except Exception as exc:
                failures.append({"bundle": bundle, "path_id": str(path_id), "error": repr(exc)})

    out_csv = OUT_ROOT / "manual_sprite_reextract.csv"
    out_csv.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = [
        "bundle",
        "path_id",
        "type",
        "name",
        "width",
        "height",
        "output",
        "error",
        "texture_path_id",
        "texture_width",
        "texture_height",
    ]
    with out_csv.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)
        for failure in failures:
            writer.writerow({**failure, "type": "Sprite"})

    summary = {
        "targets": sum(len(v) for v in targets.values()),
        "exported": len(rows),
        "failures": len(failures),
        "csv": out_csv.as_posix(),
        "failure_samples": failures[:10],
    }
    (OUT_ROOT / "manual_sprite_reextract_summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
