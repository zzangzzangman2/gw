from __future__ import annotations

import json
from pathlib import Path

import cv2
from PIL import Image, ImageDraw, ImageFont


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = BASE / "reports" / "battle"
VIDEO_DIR = BASE / "reports" / "video_reference"
SOURCE_VIDEO = BASE.parent / "플레이.mp4"
CLIP05 = VIDEO_DIR / "clips" / "battle_motion_clip_05_0486s.mp4"
REFERENCE_JPG = REPORT_DIR / "BATTLE_20_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S.jpg"
REFERENCE_JSON = REPORT_DIR / "BATTLE_20_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S.json"


def read_frame(video_path: Path, second: float):
    cap = cv2.VideoCapture(str(video_path))
    if not cap.isOpened():
        return None
    fps = cap.get(cv2.CAP_PROP_FPS) or 30.0
    cap.set(cv2.CAP_PROP_POS_MSEC, second * 1000.0)
    ok, frame = cap.read()
    cap.release()
    if not ok or frame is None:
        return None
    rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    return Image.fromarray(rgb), fps


def zone_stats(image: Image.Image) -> dict[str, dict[str, float]]:
    w, h = image.size
    zones = {
        "top": (0, 0, w, int(h * 0.18)),
        "bottom": (0, int(h * 0.72), w, h),
        "right": (int(w * 0.82), 0, w, h),
    }
    out: dict[str, dict[str, float]] = {}
    gray = image.convert("L")
    for name, box in zones.items():
        crop = gray.crop(box)
        hist = crop.histogram()
        total = max(1, crop.size[0] * crop.size[1])
        non_dark = sum(hist[28:]) / total
        mean = sum(i * hist[i] for i in range(256)) / total
        out[name] = {"mean": round(mean, 3), "nonDarkRatio": round(non_dark, 5)}
    return out


def make_sheet(frames: list[tuple[float, Image.Image]], output: Path) -> None:
    thumbs: list[Image.Image] = []
    for second, image in frames:
        thumb = image.copy()
        thumb.thumbnail((480, 224), Image.Resampling.LANCZOS)
        canvas = Image.new("RGB", (480, 254), (20, 20, 20))
        canvas.paste(thumb, ((480 - thumb.width) // 2, 0))
        draw = ImageDraw.Draw(canvas)
        draw.text((8, 230), f"play.mp4 @ {second:.1f}s", fill=(255, 255, 255))
        thumbs.append(canvas)
    sheet = Image.new("RGB", (480 * len(thumbs), 254), (8, 8, 8))
    for i, thumb in enumerate(thumbs):
        sheet.paste(thumb, (480 * i, 0))
    output.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(output, quality=92)


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    sample_seconds = [486.0, 486.5, 487.0, 487.5, 488.0, 488.5]
    frames: list[tuple[float, Image.Image]] = []
    fps = 0.0
    for second in sample_seconds:
        result = read_frame(SOURCE_VIDEO, second)
        if result is None:
            continue
        image, fps = result
        frames.append((second, image))
    if frames:
        make_sheet(frames, REFERENCE_JPG)
    per_frame = []
    for second, image in frames:
        per_frame.append({"second": second, "size": list(image.size), "zones": zone_stats(image)})
    summary = {
        "reference_video_used": SOURCE_VIDEO.exists(),
        "sourceVideo": str(SOURCE_VIDEO),
        "clip05": str(CLIP05),
        "clip05Exists": CLIP05.exists(),
        "frameSampleSeconds": sample_seconds,
        "framesExtracted": len(frames),
        "fps": fps,
        "referenceContactSheet": str(REFERENCE_JPG),
        "referenceContactSheetExists": REFERENCE_JPG.exists(),
        "normalBattleHudPersistenceWindow": "486.0s-488.5s",
        "expectedHudZonesFromClip05": {
            "top": "HP/VS area should persist",
            "bottom": "actor/skill card area should persist",
            "right": "vertical controls should persist",
        },
        "perFrameZoneStats": per_frame,
    }
    REFERENCE_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
