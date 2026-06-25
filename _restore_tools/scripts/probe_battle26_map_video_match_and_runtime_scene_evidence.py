import csv
import json
import math
import re
from pathlib import Path

from PIL import Image, ImageDraw, ImageStat

BASE = Path(r"C:\Users\godho\Downloads\girlswar")
VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
INDEX_IMAGES = BASE / "girlswar_merged_extracted" / "indexes" / "unity_images.csv"
FLOW_MANIFEST = BASE / "girlswar_battle_unity" / "Assets" / "RestoreData" / "battle" / "BATTLE_RUNTIME_FLOW_MANIFEST.json"
HUD25_RESULT = BASE / "reports" / "battle" / "BATTLE_HUD_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05_RESULT.json"
REPORT_DIR = BASE / "reports" / "battle"
REPORT_JSON = REPORT_DIR / "BATTLE_26_MAP_VIDEO_MATCH_RUNTIME_SCENE_EVIDENCE_RESULT.json"
REPORT_MD = REPORT_DIR / "BATTLE_26_MAP_VIDEO_MATCH_RUNTIME_SCENE_EVIDENCE_RESULT.md"
CONTACT = REPORT_DIR / "BATTLE_26_MAP_VIDEO_MATCH_CANDIDATES_CONTACT_SHEET.jpg"
REFERENCE_FRAME = REPORT_DIR / "BATTLE_26_PLAY_VIDEO_CLIP05_486S_BACKGROUND_REFERENCE.jpg"
REFERENCE_SEQUENCE = REPORT_DIR / "BATTLE_26_PLAY_VIDEO_CLIP05_486S_SEQUENCE.jpg"


def read_json(path):
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def extract_frame_at(seconds=486.0):
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    try:
        import cv2  # type: ignore

        cap = cv2.VideoCapture(str(VIDEO))
        cap.set(cv2.CAP_PROP_POS_MSEC, seconds * 1000)
        ok, frame = cap.read()
        cap.release()
        if not ok:
            raise RuntimeError("cv2 could not read frame")
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        img = Image.fromarray(frame).convert("RGB")
    except Exception:
        fallback = REPORT_DIR / "BATTLE_25_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S_SEQUENCE.jpg"
        if fallback.exists():
            img = Image.open(fallback).convert("RGB").crop((0, 0, 420, 180)).resize((1920, 896), Image.Resampling.BICUBIC)
        else:
            img = Image.new("RGB", (1920, 896), (20, 20, 20))
    img.save(REFERENCE_FRAME, quality=92)
    return img


def extract_sequence():
    frames = []
    try:
        import cv2  # type: ignore

        cap = cv2.VideoCapture(str(VIDEO))
        for t in [485.0, 485.5, 486.0, 486.5, 487.0, 487.5]:
            cap.set(cv2.CAP_PROP_POS_MSEC, t * 1000)
            ok, frame = cap.read()
            if not ok:
                continue
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            frames.append((f"{t:.1f}s", Image.fromarray(frame).convert("RGB")))
        cap.release()
    except Exception:
        frames = []

    panels = []
    for label, img in frames:
        img.thumbnail((420, 180), Image.Resampling.LANCZOS)
        panel = Image.new("RGB", (420, 215), (8, 8, 8))
        panel.paste(img, ((420 - img.width) // 2, 0))
        ImageDraw.Draw(panel).text((8, 188), f"play.mp4 {label}", fill=(235, 235, 235))
        panels.append(panel)
    if not panels:
        panel = Image.new("RGB", (420, 215), (8, 8, 8))
        ImageDraw.Draw(panel).text((8, 88), "clip05 extraction failed", fill=(255, 180, 180))
        panels.append(panel)
    sheet = Image.new("RGB", (420 * len(panels), 215), (5, 5, 5))
    for idx, panel in enumerate(panels):
        sheet.paste(panel, (idx * 420, 0))
    sheet.save(REFERENCE_SEQUENCE, quality=92)
    return str(REFERENCE_SEQUENCE)


def parse_map_id(bundle):
    match = re.search(r"map[_/](\d+)", bundle.lower())
    if match:
        return int(match.group(1))
    return None


def load_map_candidates():
    candidates = []
    with INDEX_IMAGES.open("r", encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            bundle = row.get("bundle", "")
            if "battlemap" not in bundle.lower():
                continue
            if row.get("type") != "Sprite":
                continue
            try:
                width = int(row.get("width") or 0)
                height = int(row.get("height") or 0)
            except ValueError:
                continue
            if width < 500 or height < 180:
                continue
            output = row.get("output", "")
            path = BASE / "girlswar_merged_extracted" / output.replace("/", "\\")
            if not path.exists():
                path = BASE / "girlswar_merged_extracted" / output
            if not path.exists():
                continue
            candidates.append({
                "mapId": parse_map_id(bundle),
                "bundle": bundle,
                "pathId": row.get("path_id", ""),
                "name": row.get("name", ""),
                "width": width,
                "height": height,
                "output": output,
                "absolutePath": str(path),
            })
    return candidates


def crop_reference_for_map(frame):
    # Keep the stage area and discard most top/bottom HUD.
    w, h = frame.size
    return frame.crop((0, int(h * 0.10), w, int(h * 0.80))).convert("RGB")


def hist_rgb(image, bins=8):
    small = image.resize((256, 128), Image.Resampling.BILINEAR).convert("RGB")
    hist = [0] * (bins * bins * bins)
    for r, g, b in small.getdata():
        ri = min(bins - 1, r * bins // 256)
        gi = min(bins - 1, g * bins // 256)
        bi = min(bins - 1, b * bins // 256)
        hist[(ri * bins + gi) * bins + bi] += 1
    total = sum(hist) or 1
    return [v / total for v in hist]


def hist_intersection(a, b):
    return sum(min(x, y) for x, y in zip(a, b))


def mean_rgb(image):
    stat = ImageStat.Stat(image.resize((64, 64), Image.Resampling.BILINEAR).convert("RGB"))
    return stat.mean


def color_distance(a, b):
    return math.sqrt(sum((x - y) ** 2 for x, y in zip(a, b))) / 441.67295593


def edge_score(reference, candidate):
    try:
        import cv2  # type: ignore
        import numpy as np  # type: ignore

        ref = reference.resize((256, 128), Image.Resampling.BILINEAR).convert("L")
        cand = candidate.resize((256, 128), Image.Resampling.BILINEAR).convert("L")
        ref_edges = cv2.Canny(np.array(ref), 70, 150)
        cand_edges = cv2.Canny(np.array(cand), 70, 150)
        ref_edges = ref_edges.astype("float32") / 255.0
        cand_edges = cand_edges.astype("float32") / 255.0
        denom = math.sqrt(float((ref_edges * ref_edges).sum()) * float((cand_edges * cand_edges).sum())) or 1.0
        return float((ref_edges * cand_edges).sum()) / denom
    except Exception:
        return 0.0


def score_candidates(reference, candidates):
    ref_hist = hist_rgb(reference)
    ref_mean = mean_rgb(reference)
    rows = []
    for cand in candidates:
        try:
            img = Image.open(cand["absolutePath"]).convert("RGB")
        except Exception:
            continue
        cover = img.resize(reference.size, Image.Resampling.BILINEAR)
        hist_score = hist_intersection(ref_hist, hist_rgb(cover))
        mean_score = 1.0 - color_distance(ref_mean, mean_rgb(cover))
        edge = edge_score(reference, cover)
        score = hist_score * 0.62 + mean_score * 0.25 + edge * 0.13
        row = dict(cand)
        row.update({
            "histScore": round(hist_score, 6),
            "meanScore": round(mean_score, 6),
            "edgeScore": round(edge, 6),
            "score": round(score, 6),
        })
        rows.append(row)
    rows.sort(key=lambda r: r["score"], reverse=True)
    return rows


def make_contact_sheet(reference, ranked):
    top = ranked[:18]
    ref_panel = Image.new("RGB", (1680, 260), (8, 8, 8))
    ref = reference.copy()
    ref.thumbnail((840, 236), Image.Resampling.LANCZOS)
    ref_panel.paste(ref, (12, 12))
    draw = ImageDraw.Draw(ref_panel)
    draw.text((870, 36), "BATTLE_26 map check: TOP is play.mp4 clip05 stage crop", fill=(255, 255, 255))
    draw.text((870, 68), "Rows below are extracted battlemap Sprite candidates ranked by image similarity.", fill=(220, 220, 220))
    draw.text((870, 100), "This is evidence only. It is not a final restored battle screen.", fill=(255, 210, 120))

    cell_w, cell_h = 280, 210
    cols = 6
    rows = (len(top) + cols - 1) // cols
    sheet = Image.new("RGB", (1680, 260 + rows * cell_h), (5, 5, 5))
    sheet.paste(ref_panel, (0, 0))
    for idx, row in enumerate(top):
        panel = Image.new("RGB", (cell_w, cell_h), (14, 14, 14))
        try:
            img = Image.open(row["absolutePath"]).convert("RGB")
            img.thumbnail((cell_w - 16, 135), Image.Resampling.LANCZOS)
            panel.paste(img, ((cell_w - img.width) // 2, 8))
        except Exception:
            pass
        d = ImageDraw.Draw(panel)
        label1 = f"#{idx + 1} score={row['score']:.3f} map={row.get('mapId')}"
        label2 = f"{row['name']} {row['width']}x{row['height']}"
        label3 = row["bundle"][-42:]
        d.text((8, 150), label1, fill=(255, 235, 160))
        d.text((8, 168), label2[:44], fill=(235, 235, 235))
        d.text((8, 186), label3, fill=(170, 205, 255))
        x = (idx % cols) * cell_w
        y = 260 + (idx // cols) * cell_h
        sheet.paste(panel, (x, y))
    sheet.save(CONTACT, quality=92)


def summarize_actor_evidence(flow):
    actors = flow.get("actorSlots") or []
    loadable = [a for a in actors if a.get("loadStatus") == "runtime_prefab"]
    missing = [a for a in actors if a.get("loadStatus") != "runtime_prefab"]
    return {
        "actorSlotCount": len(actors),
        "loadableRuntimePrefabCount": len(loadable),
        "missingOrPlaceholderCount": len(missing),
        "loadableActors": [
            {
                "side": a.get("side"),
                "wave": a.get("wave"),
                "slot": a.get("slot"),
                "heroDid": a.get("heroDid"),
                "modelId": a.get("modelId"),
                "bundle": a.get("bundle"),
                "prefabAsset": a.get("prefabAsset"),
            }
            for a in loadable
        ],
        "missingActors": [
            {
                "side": a.get("side"),
                "wave": a.get("wave"),
                "slot": a.get("slot"),
                "heroDid": a.get("heroDid"),
                "modelId": a.get("modelId"),
                "missingReason": a.get("missingReason") or a.get("loadStatus"),
            }
            for a in missing
        ],
    }


def main():
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    frame = extract_frame_at(486.0)
    sequence = extract_sequence()
    reference = crop_reference_for_map(frame)
    candidates = load_map_candidates()
    ranked = score_candidates(reference, candidates)
    make_contact_sheet(reference, ranked)

    flow = read_json(FLOW_MANIFEST)
    hud25 = read_json(HUD25_RESULT)
    flow_map_id = flow.get("mapId")
    top = ranked[:18]
    top_map_ids = sorted({r.get("mapId") for r in top if r.get("mapId") is not None})
    flow_map_in_top = any(r.get("mapId") == flow_map_id for r in top)
    flow_map_best_rank = None
    for idx, row in enumerate(ranked, start=1):
        if row.get("mapId") == flow_map_id:
            flow_map_best_rank = idx
            break

    result = {
        "verdict": "BATTLE_26 evidence probe only, not final restored battle",
        "referenceVideo": str(VIDEO),
        "referenceFrame": str(REFERENCE_FRAME),
        "referenceSequence": sequence,
        "contactSheet": str(CONTACT),
        "flowManifest": str(FLOW_MANIFEST),
        "flowMapId": flow_map_id,
        "candidateCount": len(candidates),
        "topMapIds": top_map_ids,
        "flowMapIdInTop18": flow_map_in_top,
        "flowMapBestRank": flow_map_best_rank,
        "topCandidates": top,
        "actorEvidence": summarize_actor_evidence(flow),
        "hud25Summary": {
            "partialOriginalHudVisible": hud25.get("partial_original_hud_visible"),
            "visualStatus": hud25.get("visual_status"),
            "blankTextureRows": (hud25.get("summary") or {}).get("activeVisibleSpriteTextureBlankCount"),
            "extractedSpriteTextureBindCount": (hud25.get("summary") or {}).get("extractedSpriteTextureBindCount"),
        },
        "nextBlocker": "BATTLE_27_REBUILD_VIDEO_MATCHING_BATTLE_SCENE_WITH_CORRECT_MAP_AND_LOADABLE_ACTORS",
    }
    REPORT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        "# BATTLE_26 Map/Runtime Scene Evidence",
        "",
        "This is not a final restored battle screen. It checks whether the current runtime flow map and actor evidence match `플레이.mp4` clip05 around 486s.",
        "",
        "## Verdict",
        f"- flow mapId: `{flow_map_id}`",
        f"- battlemap candidates checked: `{len(candidates)}`",
        f"- top map ids from video similarity: `{', '.join(str(x) for x in top_map_ids[:12])}`",
        f"- flow mapId in top 18: `{flow_map_in_top}`",
        f"- flow map best rank: `{flow_map_best_rank}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Top Map Candidates",
    ]
    for idx, row in enumerate(top[:12], start=1):
        md.append(f"- `#{idx}` score `{row['score']}` map `{row.get('mapId')}` `{row['name']}` `{row['width']}x{row['height']}` `{row['bundle']}`")
    actor_summary = result["actorEvidence"]
    md += [
        "",
        "## Actor Runtime Evidence",
        f"- actor slots: `{actor_summary['actorSlotCount']}`",
        f"- loadable runtime prefabs: `{actor_summary['loadableRuntimePrefabCount']}`",
        f"- missing/placeholders: `{actor_summary['missingOrPlaceholderCount']}`",
    ]
    for actor in actor_summary["loadableActors"]:
        md.append(f"- loadable `{actor['side']}` wave `{actor['wave']}` slot `{actor['slot']}` hero `{actor['heroDid']}` model `{actor['modelId']}` `{actor['bundle']}`")
    md += [
        "",
        "## HUD Carryover From BATTLE_25",
        f"- BATTLE_25 visual_status: `{result['hud25Summary']['visualStatus']}`",
        f"- blank texture rows: `{result['hud25Summary']['blankTextureRows']}`",
        f"- extracted sprite texture bind count: `{result['hud25Summary']['extractedSpriteTextureBindCount']}`",
        "",
        "## Interpretation",
        "- BATTLE_26 does not accept `mapId=11001` blindly. If the contact sheet shows another map id closer to the video, BATTLE_27 must rebuild the scene with that map evidence.",
        "- Only extracted battlemap Sprite candidates are compared. No whole-atlas UI placement or fake HUD is used.",
        "- Actor rendering remains incomplete until loadable Spine/prefab actors are placed with the correct runtime camera and missing actors are resolved from extracted bundles or documented as unavailable.",
        "",
        "## Outputs",
        f"- result JSON: `{REPORT_JSON}`",
        f"- contact sheet: `{CONTACT}`",
        f"- reference frame: `{REFERENCE_FRAME}`",
        f"- reference sequence: `{REFERENCE_SEQUENCE}`",
    ]
    REPORT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps({
        "flowMapId": flow_map_id,
        "candidateCount": len(candidates),
        "topMapIds": top_map_ids[:8],
        "flowMapIdInTop18": flow_map_in_top,
        "flowMapBestRank": flow_map_best_rank,
        "contactSheet": str(CONTACT),
        "report": str(REPORT_MD),
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
