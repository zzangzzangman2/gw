import csv
import json
import math
import shutil
import subprocess
from pathlib import Path

import cv2
import numpy as np


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
OUT_DIR = ROOT / "reports" / "video_reference"
CLIP_DIR = OUT_DIR / "clips"
FRAME_DIR = OUT_DIR / "frames"


def norm_region(frame, x0, y0, x1, y1):
    h, w = frame.shape[:2]
    return frame[int(h * y0):int(h * y1), int(w * x0):int(w * x1)]


def region_diff(a, b):
    if a.size == 0 or b.size == 0:
        return 0.0
    return float(np.mean(cv2.absdiff(a, b))) / 255.0


def contiguous_segments(rows, predicate, max_gap=1.25, min_duration=1.0):
    segments = []
    cur = None
    last_t = None
    for row in rows:
        t = row["time"]
        hit = predicate(row)
        if hit:
            if cur is None or (last_t is not None and t - last_t > max_gap):
                if cur is not None:
                    segments.append(cur)
                cur = {"start": t, "end": t, "rows": []}
            cur["end"] = t
            cur["rows"].append(row)
            last_t = t
        elif cur is not None and last_t is not None and t - last_t > max_gap:
            segments.append(cur)
            cur = None
            last_t = None
    if cur is not None:
        segments.append(cur)

    result = []
    for seg in segments:
        duration = seg["end"] - seg["start"]
        if duration >= min_duration:
            values = [r["motion_all"] for r in seg["rows"]]
            center_values = [r["motion_center"] for r in seg["rows"]]
            flash_values = [r["bright_ratio"] for r in seg["rows"]]
            result.append({
                "start": round(seg["start"], 2),
                "end": round(seg["end"], 2),
                "duration": round(duration, 2),
                "sampleCount": len(seg["rows"]),
                "meanMotion": round(float(np.mean(values)), 5) if values else 0,
                "maxMotion": round(float(np.max(values)), 5) if values else 0,
                "meanCenterMotion": round(float(np.mean(center_values)), 5) if center_values else 0,
                "maxFlashRatio": round(float(np.max(flash_values)), 5) if flash_values else 0,
            })
    return result


def write_clip(ffmpeg, start, duration, out_path):
    if not ffmpeg:
        return False
    cmd = [
        ffmpeg,
        "-y",
        "-ss", f"{max(0.0, start):.2f}",
        "-i", str(VIDEO),
        "-t", f"{duration:.2f}",
        "-vf", "scale=960:-2",
        "-an",
        "-c:v", "libx264",
        "-preset", "veryfast",
        "-crf", "25",
        str(out_path),
    ]
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=False)
    return out_path.exists() and out_path.stat().st_size > 0


def save_frame(cap, time_s, out_path):
    fps = cap.get(cv2.CAP_PROP_FPS) or 30.0
    cap.set(cv2.CAP_PROP_POS_FRAMES, int(time_s * fps))
    ok, frame = cap.read()
    if not ok:
        return False
    small = cv2.resize(frame, (960, int(frame.shape[0] * 960 / frame.shape[1])))
    return cv2.imwrite(str(out_path), small)


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    CLIP_DIR.mkdir(parents=True, exist_ok=True)
    FRAME_DIR.mkdir(parents=True, exist_ok=True)

    cap = cv2.VideoCapture(str(VIDEO))
    if not cap.isOpened():
        raise SystemExit(f"failed to open video: {VIDEO}")

    fps = cap.get(cv2.CAP_PROP_FPS) or 30.0
    frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT) or 0)
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH) or 0)
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT) or 0)
    duration = frame_count / fps if frame_count else 0
    sample_stride = max(1, int(round(fps * 0.5)))

    rows = []
    prev_gray = None
    idx = 0
    sampled = 0
    while True:
        ok = cap.grab()
        if not ok:
            break
        if idx % sample_stride != 0:
            idx += 1
            continue
        ok, frame = cap.retrieve()
        if not ok:
            break
        time_s = idx / fps
        resized = cv2.resize(frame, (480, max(1, int(frame.shape[0] * 480 / frame.shape[1]))))
        gray = cv2.cvtColor(resized, cv2.COLOR_BGR2GRAY)
        if prev_gray is None:
            motion_all = motion_top = motion_center = motion_bottom = motion_right = 0.0
        else:
            motion_all = region_diff(gray, prev_gray)
            motion_top = region_diff(norm_region(gray, 0, 0, 1, 0.18), norm_region(prev_gray, 0, 0, 1, 0.18))
            motion_center = region_diff(norm_region(gray, 0.05, 0.18, 0.85, 0.78), norm_region(prev_gray, 0.05, 0.18, 0.85, 0.78))
            motion_bottom = region_diff(norm_region(gray, 0, 0.76, 1, 1), norm_region(prev_gray, 0, 0.76, 1, 1))
            motion_right = region_diff(norm_region(gray, 0.82, 0.1, 1, 0.92), norm_region(prev_gray, 0.82, 0.1, 1, 0.92))
        bright_ratio = float(np.mean(gray > 240))
        dark_ratio = float(np.mean(gray < 20))
        rows.append({
            "time": round(time_s, 2),
            "motion_all": round(motion_all, 6),
            "motion_top": round(motion_top, 6),
            "motion_center": round(motion_center, 6),
            "motion_bottom_hud": round(motion_bottom, 6),
            "motion_right_rail": round(motion_right, 6),
            "bright_ratio": round(bright_ratio, 6),
            "dark_ratio": round(dark_ratio, 6),
        })
        prev_gray = gray
        sampled += 1
        idx += 1

    cap.release()

    csv_path = OUT_DIR / "play_motion_metrics_0p5s.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0].keys()) if rows else [])
        writer.writeheader()
        writer.writerows(rows)

    motions = np.array([r["motion_all"] for r in rows[1:]], dtype=np.float32) if len(rows) > 1 else np.array([0])
    center = np.array([r["motion_center"] for r in rows[1:]], dtype=np.float32) if len(rows) > 1 else np.array([0])
    flashes = np.array([r["bright_ratio"] for r in rows[1:]], dtype=np.float32) if len(rows) > 1 else np.array([0])
    motion_p85 = float(np.percentile(motions, 85))
    motion_p95 = float(np.percentile(motions, 95))
    center_p90 = float(np.percentile(center, 90))
    flash_p95 = float(np.percentile(flashes, 95))

    high_motion_segments = contiguous_segments(
        rows,
        lambda r: r["motion_all"] >= motion_p85 or r["motion_center"] >= center_p90,
        max_gap=1.25,
        min_duration=1.0,
    )
    flash_segments = contiguous_segments(
        rows,
        lambda r: r["bright_ratio"] >= max(0.03, flash_p95),
        max_gap=1.25,
        min_duration=0.5,
    )
    high_motion_segments.sort(key=lambda s: (s["maxMotion"], s["meanCenterMotion"]), reverse=True)
    flash_segments.sort(key=lambda s: s["maxFlashRatio"], reverse=True)

    ffmpeg = shutil.which("ffmpeg")
    cap = cv2.VideoCapture(str(VIDEO))
    clip_outputs = []
    for i, seg in enumerate(high_motion_segments[:6], 1):
        start = max(0.0, seg["start"] - 1.0)
        dur = min(8.0, max(4.0, seg["duration"] + 2.0))
        clip_path = CLIP_DIR / f"battle_motion_clip_{i:02d}_{int(start):04d}s.mp4"
        frame_path = FRAME_DIR / f"battle_motion_frame_{i:02d}_{int(seg['start']):04d}s.jpg"
        clip_ok = write_clip(ffmpeg, start, dur, clip_path)
        frame_ok = save_frame(cap, seg["start"], frame_path)
        clip_outputs.append({
            "rank": i,
            "segment": seg,
            "clip": str(clip_path) if clip_ok else "",
            "frame": str(frame_path) if frame_ok else "",
        })
    cap.release()

    summary = {
        "video": str(VIDEO),
        "generatedAt": "",
        "metadata": {
            "width": width,
            "height": height,
            "fps": round(float(fps), 3),
            "frameCount": frame_count,
            "durationSeconds": round(duration, 3),
            "sampleStrideFrames": sample_stride,
            "sampleIntervalSeconds": round(sample_stride / fps, 3),
            "sampleCount": sampled,
        },
        "thresholds": {
            "motionP85": round(motion_p85, 6),
            "motionP95": round(motion_p95, 6),
            "centerMotionP90": round(center_p90, 6),
            "flashP95": round(flash_p95, 6),
        },
        "highMotionSegments": high_motion_segments[:20],
        "flashSegments": flash_segments[:20],
        "clipOutputs": clip_outputs,
        "notes": [
            "Top-center circular overlay appears across UI and battle; treat as recording/touch artifact unless user confirms it is in-game UI.",
            "Use video clips for battle timing, camera shake, cut-in timing, hit flash, damage/floating text movement, and HUD active/inactive transitions. Contact sheets alone are insufficient.",
        ],
        "outputs": {
            "metricsCsv": str(csv_path),
            "overviewContactSheet": str(OUT_DIR / "play_overview_10s_contact.jpg"),
        },
    }
    json_path = OUT_DIR / "PLAY_REFERENCE_VIDEO_MOTION_ANALYSIS.json"
    json_path.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md_path = OUT_DIR / "PLAY_REFERENCE_VIDEO_MOTION_ANALYSIS.md"
    lines = [
        "# Play Reference Video Motion Analysis",
        "",
        "## Source",
        f"- Video: `{VIDEO}`",
        f"- Duration: `{duration:.2f}s`",
        f"- Resolution/FPS: `{width}x{height}` / `{fps:.3f}`",
        f"- Motion sample interval: `{sample_stride / fps:.3f}s`",
        "",
        "## Important Restore Notes",
        "- Treat the top-center circular overlay as a recording/touch artifact unless confirmed otherwise.",
        "- Battle restoration must use motion clips for camera shake, attack travel, hit flash, cut-in timing, floating damage, and HUD transitions.",
        "- Do not reproduce debug/log/recording overlays in final scenes.",
        "",
        "## High Motion Segments",
        "| rank | start | end | duration | mean motion | max motion | max flash | clip |",
        "| ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |",
    ]
    for item in clip_outputs:
        seg = item["segment"]
        clip = item["clip"]
        lines.append(
            f"| {item['rank']} | {seg['start']} | {seg['end']} | {seg['duration']} | "
            f"{seg['meanMotion']} | {seg['maxMotion']} | {seg['maxFlashRatio']} | `{clip}` |"
        )
    lines.extend([
        "",
        "## Flash / Cut-In Candidates",
        "| rank | start | end | duration | max flash |",
        "| ---: | ---: | ---: | ---: | ---: |",
    ])
    for i, seg in enumerate(flash_segments[:12], 1):
        lines.append(f"| {i} | {seg['start']} | {seg['end']} | {seg['duration']} | {seg['maxFlashRatio']} |")
    lines.extend([
        "",
        "## Outputs",
        f"- JSON: `{json_path}`",
        f"- Metrics CSV: `{csv_path}`",
        f"- Overview contact sheet: `{OUT_DIR / 'play_overview_10s_contact.jpg'}`",
        f"- Motion clips: `{CLIP_DIR}`",
    ])
    md_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(json.dumps({"json": str(json_path), "md": str(md_path), "clips": len(clip_outputs)}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
