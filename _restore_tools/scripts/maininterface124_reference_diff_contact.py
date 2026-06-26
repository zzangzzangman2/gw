from __future__ import annotations

import csv
import json
import math
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageStat


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORTS = BASE / "reports" / "maininterface"
RESTORE_REPORTS = PROJECT / "Assets" / "RestoreData" / "reports"

REFERENCE = Path(r"C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png")
CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui124_hero1005_spine_1680x720.png"
HERO_ONLY = PROJECT / "Assets" / "RestoreCaptures" / "maininterface_ui124_hero1005_spine_hero_only_1680x720.png"

OUT_CONTACT = REPORTS / "MAININTERFACE_124_REFERENCE_DIFF_CONTACT.png"
OUT_JSON = RESTORE_REPORTS / "maininterface_124_reference_diff_summary.json"
OUT_CSV = RESTORE_REPORTS / "maininterface_124_reference_diff_regions.csv"
OUT_MD = REPORTS / "MAININTERFACE_124_REFERENCE_DIFF_RESULT.md"


REGIONS = {
    "full": (0.0, 0.0, 1.0, 1.0),
    "top_bar": (0.0, 0.0, 1.0, 0.18),
    "left_lobby": (0.0, 0.12, 0.35, 0.92),
    "center_hero": (0.18, 0.0, 0.72, 0.92),
    "right_cluster": (0.68, 0.10, 1.0, 0.92),
    "bottom_nav": (0.0, 0.76, 1.0, 1.0),
}


def open_rgb(path: Path) -> Image.Image:
    if not path.exists():
        raise FileNotFoundError(path)
    return Image.open(path).convert("RGB")


def crop_norm(image: Image.Image, box: tuple[float, float, float, float]) -> Image.Image:
    w, h = image.size
    x0, y0, x1, y1 = box
    return image.crop((round(x0 * w), round(y0 * h), round(x1 * w), round(y1 * h)))


def mean_abs_diff(a: Image.Image, b: Image.Image) -> float:
    diff = ImageChops.difference(a, b)
    stat = ImageStat.Stat(diff)
    return float(sum(stat.mean) / (3.0 * 255.0))


def rms_diff(a: Image.Image, b: Image.Image) -> float:
    diff = ImageChops.difference(a, b)
    stat = ImageStat.Stat(diff)
    squares = sum(value * value for value in stat.rms) / 3.0
    return float(math.sqrt(squares) / 255.0)


def changed_ratio(a: Image.Image, b: Image.Image, threshold: int = 30) -> float:
    diff = ImageChops.difference(a, b)
    changed = 0
    total = diff.width * diff.height
    for r, g, bch in diff.getdata():
        if max(r, g, bch) >= threshold:
            changed += 1
    return changed / total if total else 0.0


def corr(a: Image.Image, b: Image.Image) -> float:
    pa = list(a.getdata())
    pb = list(b.getdata())
    if not pa or len(pa) != len(pb):
        return 0.0
    va = []
    vb = []
    # Downsample implicitly by slicing to keep the script quick.
    step = max(1, len(pa) // 200000)
    for p, q in zip(pa[::step], pb[::step]):
        va.extend(p)
        vb.extend(q)
    ma = sum(va) / len(va)
    mb = sum(vb) / len(vb)
    num = sum((x - ma) * (y - mb) for x, y in zip(va, vb))
    da = math.sqrt(sum((x - ma) ** 2 for x in va))
    db = math.sqrt(sum((y - mb) ** 2 for y in vb))
    if da == 0 or db == 0:
        return 0.0
    return num / (da * db)


def region_rows(reference: Image.Image, capture: Image.Image) -> list[dict[str, object]]:
    rows = []
    for name, box in REGIONS.items():
        ref_crop = crop_norm(reference, box)
        cap_crop = crop_norm(capture, box)
        rows.append(
            {
                "region": name,
                "meanAbsDiff": round(mean_abs_diff(ref_crop, cap_crop), 6),
                "rmsDiff": round(rms_diff(ref_crop, cap_crop), 6),
                "changedPixelRatio30": round(changed_ratio(ref_crop, cap_crop, 30), 6),
                "pixelCorrelation": round(corr(ref_crop, cap_crop), 6),
                "boxNorm": ",".join(str(v) for v in box),
            }
        )
    return rows


def make_diff(reference: Image.Image, capture: Image.Image) -> Image.Image:
    diff = ImageChops.difference(reference, capture)
    return diff.point(lambda p: min(255, p * 3))


def add_label(image: Image.Image, label: str) -> Image.Image:
    out = image.copy()
    draw = ImageDraw.Draw(out)
    draw.rectangle((0, 0, out.width, 34), fill=(0, 0, 0))
    draw.text((10, 9), label, fill=(255, 255, 255))
    return out


def make_contact(reference: Image.Image, capture: Image.Image, diff: Image.Image) -> None:
    width = 560
    height = 240
    panels = [
        add_label(reference.resize((width, height), Image.Resampling.LANCZOS), "reference resized"),
        add_label(capture.resize((width, height), Image.Resampling.LANCZOS), "UI124 capture"),
        add_label(diff.resize((width, height), Image.Resampling.LANCZOS), "abs diff x3"),
    ]
    contact = Image.new("RGB", (width * 3, height), (0, 0, 0))
    for index, panel in enumerate(panels):
        contact.paste(panel, (index * width, 0))
    OUT_CONTACT.parent.mkdir(parents=True, exist_ok=True)
    contact.save(OUT_CONTACT)


def write_csv(rows: list[dict[str, object]]) -> None:
    OUT_CSV.parent.mkdir(parents=True, exist_ok=True)
    with OUT_CSV.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    RESTORE_REPORTS.mkdir(parents=True, exist_ok=True)

    reference_original = open_rgb(REFERENCE)
    capture = open_rgb(CAPTURE)
    reference = reference_original.resize(capture.size, Image.Resampling.LANCZOS)
    diff = make_diff(reference, capture)
    rows = region_rows(reference, capture)
    make_contact(reference, capture, diff)
    write_csv(rows)

    summary = {
        "reference": str(REFERENCE),
        "referenceOriginalSize": list(reference_original.size),
        "capture": str(CAPTURE),
        "captureSize": list(capture.size),
        "heroOnlyCapture": str(HERO_ONLY),
        "contactSheet": str(OUT_CONTACT),
        "csv": str(OUT_CSV),
        "restoredClaim": False,
        "manualVerdict": "not_restored_reference_mismatch",
        "mainBlockers": [
            "route/world cluster remains visible in UI124 capture",
            "right sibling index is above UI_heroSpine, so route can overlay the mounted hero",
            "hero mount is real SkeletonGraphic, but overall home lobby state still mismatches reference",
        ],
        "regions": rows,
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    table = "\n".join(
        f"| `{row['region']}` | `{row['meanAbsDiff']}` | `{row['rmsDiff']}` | `{row['changedPixelRatio30']}` | `{row['pixelCorrelation']}` |"
        for row in rows
    )
    OUT_MD.write_text(
        "\n".join(
            [
                "# MainInterface 124 Reference Diff Result",
                "",
                "## Verdict",
                "",
                "Restored claim remains `false`. The UI124 capture now has a real Hero1005 SkeletonGraphic, but it still does not match the reference because the route/world cluster remains visible and draws above the hero by sibling-order evidence.",
                "",
                "## Metrics",
                "",
                "| region | mean abs diff | rms diff | changed pixel ratio >=30 | pixel correlation |",
                "| --- | ---: | ---: | ---: | ---: |",
                table,
                "",
                "## Files",
                "",
                f"- reference: `{REFERENCE}`",
                f"- UI124 capture: `{CAPTURE}`",
                f"- hero-only capture: `{HERO_ONLY}`",
                f"- contact sheet: `{OUT_CONTACT}`",
                f"- JSON: `{OUT_JSON}`",
                f"- CSV: `{OUT_CSV}`",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    print(json.dumps(summary, ensure_ascii=True, indent=2))


if __name__ == "__main__":
    main()
