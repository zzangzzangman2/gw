import csv
import json
import math
import re
import time
import urllib.request
from pathlib import Path

from PIL import Image, ImageOps


ROOT = Path(__file__).resolve().parents[2]
BOARD_URL = "https://game.naver.com/lounge/girlwars/board/34?page=1&order=new"
FEED_URL = (
    "https://comm-api.game.naver.com/nng_main/v1/community/lounge/girlwars/feed"
    "?boardId=34&buffFilteringYN=N&limit={limit}&offset={offset}&order=NEW"
)
HEADERS = {
    "Accept": "application/json",
    "Referer": BOARD_URL,
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/125.0 Safari/537.36",
}
OUT_DIR = ROOT / "reports" / "characters" / "naver_lounge_art"
IMG_DIR = ROOT / "work" / "naver_lounge_art_images"
LOCAL_IMAGE_ROOT = ROOT / "girlswar_merged_extracted" / "extracted" / "unity" / "bundles"


ID_RE = re.compile(r"(?:T_ditu|homepage_underwear|starHeroName|Painting|noalphabg_Tujian|noalphabg_Neiyi|_)(?:_)?(\d{3,6})(?:[_\.]|$)")
ART_NAME_RE = re.compile(r"^(?:소녀전쟁\s*\|\s*)?(?:UR\s*플래시|UR플래시|UR|SSR|SR|R)?\s*(.+?)\s*$")


def request_bytes(url: str) -> bytes:
    req = urllib.request.Request(url, headers=HEADERS)
    with urllib.request.urlopen(req, timeout=60) as response:
        return response.read()


def load_json_url(url: str) -> dict:
    return json.loads(request_bytes(url).decode("utf-8"))


def clean_art_name(title: str) -> str:
    title = (title or "").strip()
    match = ART_NAME_RE.match(title)
    return (match.group(1) if match else title).strip()


def extract_content_images(contents: str) -> list[dict]:
    if not contents:
        return []
    try:
        payload = json.loads(contents)
    except json.JSONDecodeError:
        return []

    images: list[dict] = []
    for component in payload.get("document", {}).get("components", []):
        if component.get("@ctype") != "image":
            continue
        src = component.get("src") or ""
        if not src:
            continue
        images.append(
            {
                "src": src,
                "fileName": component.get("fileName") or "",
                "width": component.get("width") or 0,
                "height": component.get("height") or 0,
                "originalWidth": component.get("originalWidth") or 0,
                "originalHeight": component.get("originalHeight") or 0,
            }
        )
    return images


def fetch_feeds() -> list[dict]:
    feeds: list[dict] = []
    page = 0
    limit = 25
    total = None
    while total is None or len(feeds) < total:
        payload = load_json_url(FEED_URL.format(limit=limit, offset=page))
        content = payload.get("content") or {}
        total = int(content.get("totalCount") or 0)
        page_feeds = content.get("feeds") or []
        if total and not page_feeds:
            break
        for item in content.get("feeds") or []:
            feed = item.get("feed") or {}
            images = extract_content_images(feed.get("contents") or "")
            image_url = ""
            if images:
                image_url = images[0]["src"]
            elif feed.get("repImageUrl"):
                image_url = feed.get("repImageUrl")
            feeds.append(
                {
                    "feedId": feed.get("feedId"),
                    "title": feed.get("title") or "",
                    "artName": clean_art_name(feed.get("title") or ""),
                    "createdDate": feed.get("createdDate") or "",
                    "updatedDate": feed.get("updatedDate") or "",
                    "repImageUrl": feed.get("repImageUrl") or "",
                    "imageUrl": image_url,
                    "imageCount": len(images),
                    "images": images,
                    "articleUrl": f"https://game.naver.com/lounge/girlwars/board/detail/{feed.get('feedId')}",
                }
            )
        page += 1
        time.sleep(0.1)
    return feeds


def local_image_kind(path: Path) -> str:
    name = path.name
    if "T_ditu_" in name:
        return "T_ditu"
    if "Painting_" in name:
        return "Painting"
    if "homepage_underwear_" in name:
        return "homepage_underwear"
    if "noalphabg_Tujian_" in name:
        return "noalphabg_Tujian"
    if "noalphabg_Neiyi_" in name:
        return "noalphabg_Neiyi"
    if "starHeroName_" in name:
        return "starHeroName"
    return "other"


def iter_local_art_images() -> list[dict]:
    candidates: list[dict] = []
    for path in LOCAL_IMAGE_ROOT.rglob("*"):
        if not path.is_file() or path.suffix.lower() not in {".png", ".jpg", ".jpeg"}:
            continue
        kind = local_image_kind(path)
        if kind not in {"T_ditu", "Painting"}:
            continue
        if path.parent.name != "T":
            continue
        match = ID_RE.search(path.name)
        if not match:
            continue
        actor_id = int(match.group(1))
        candidates.append({"actorId": actor_id, "kind": kind, "path": path})
    return candidates


def crop_foreground(image: Image.Image) -> Image.Image:
    image = image.convert("RGBA")
    alpha = image.getchannel("A")
    if alpha.getextrema()[0] < 250:
        bbox = alpha.point(lambda p: 255 if p > 20 else 0).getbbox()
        if bbox:
            return image.crop(bbox)
    return image


def dct_1d(values: list[float], k: int) -> list[float]:
    n = len(values)
    out = []
    for u in range(k):
        total = 0.0
        for x, value in enumerate(values):
            total += value * math.cos(((2 * x + 1) * u * math.pi) / (2 * n))
        out.append(total)
    return out


def phash(image: Image.Image) -> int:
    image = crop_foreground(image)
    image = ImageOps.grayscale(image)
    image = ImageOps.fit(image, (32, 32), method=Image.Resampling.LANCZOS)
    pixels = [[image.getpixel((x, y)) for x in range(32)] for y in range(32)]
    row_dct = [dct_1d([float(v) for v in row], 8) for row in pixels]
    coeffs = []
    for u in range(8):
        col = [row_dct[y][u] for y in range(32)]
        col_dct = dct_1d(col, 8)
        for v in range(8):
            if u == 0 and v == 0:
                continue
            coeffs.append(col_dct[v])
    median = sorted(coeffs)[len(coeffs) // 2]
    bits = 0
    for coeff in coeffs:
        bits = (bits << 1) | (1 if coeff > median else 0)
    return bits


def color_hist(image: Image.Image) -> tuple[float, ...]:
    image = crop_foreground(image)
    image = ImageOps.fit(image.convert("RGB"), (96, 96), method=Image.Resampling.LANCZOS)
    hist = []
    for channel in image.split():
        h = channel.histogram()
        bins = []
        for i in range(0, 256, 16):
            bins.append(sum(h[i : i + 16]))
        total = float(sum(bins) or 1)
        hist.extend(v / total for v in bins)
    return tuple(hist)


def hist_distance(a: tuple[float, ...], b: tuple[float, ...]) -> float:
    return sum(abs(x - y) for x, y in zip(a, b))


def hamming(a: int, b: int) -> int:
    return (a ^ b).bit_count()


def compute_feature(path: Path) -> dict | None:
    try:
        with Image.open(path) as img:
            return {
                "phash": phash(img),
                "hist": color_hist(img),
                "width": img.width,
                "height": img.height,
            }
    except Exception:
        return None


def download_feed_images(feeds: list[dict]) -> None:
    IMG_DIR.mkdir(parents=True, exist_ok=True)
    for feed in feeds:
        if not feed.get("imageUrl"):
            continue
        target = IMG_DIR / f"{feed['feedId']}.jpg"
        if target.exists() and target.stat().st_size > 0:
            continue
        try:
            data = request_bytes(feed["imageUrl"])
            target.write_bytes(data)
        except Exception as exc:
            feed["downloadError"] = str(exc)
        time.sleep(0.05)


def build_matches(feeds: list[dict], local_images: list[dict]) -> list[dict]:
    local_features = []
    for item in local_images:
        feature = compute_feature(item["path"])
        if not feature:
            continue
        local_features.append({**item, **feature})

    rows = []
    for feed in feeds:
        feed_path = IMG_DIR / f"{feed['feedId']}.jpg"
        feature = compute_feature(feed_path)
        if not feature:
            rows.append({**feed, "matchStatus": "no_remote_feature"})
            continue
        scored = []
        for local in local_features:
            hd = hamming(feature["phash"], local["phash"])
            hist = hist_distance(feature["hist"], local["hist"])
            kind_bias = {
                "T_ditu": 0.0,
                "Painting": 1.5,
            }.get(local["kind"], 6.0)
            score = hd + hist * 12.0 + kind_bias
            scored.append((score, hd, hist, local))
        scored.sort(key=lambda x: x[0])
        top = scored[:5]
        best = top[0] if top else None
        second = top[1] if len(top) > 1 else None
        if best:
            gap = (second[0] - best[0]) if second else 999.0
            status = "candidate"
            if best[1] <= 10 and gap >= 3:
                status = "strong"
            elif best[1] <= 18 and gap >= 1:
                status = "medium"
            row = {
                **feed,
                "matchStatus": status,
                "matchedActorId": best[3]["actorId"],
                "matchedKind": best[3]["kind"],
                "matchedLocalPath": str(best[3]["path"].relative_to(ROOT)).replace("\\", "/"),
                "matchScore": round(best[0], 3),
                "phashDistance": best[1],
                "histDistance": round(best[2], 4),
                "scoreGap": round(gap, 3),
                "topCandidates": [
                    {
                        "actorId": c[3]["actorId"],
                        "kind": c[3]["kind"],
                        "path": str(c[3]["path"].relative_to(ROOT)).replace("\\", "/"),
                        "score": round(c[0], 3),
                        "phashDistance": c[1],
                        "histDistance": round(c[2], 4),
                    }
                    for c in top
                ],
            }
            rows.append(row)
    return rows


def write_outputs(feeds: list[dict], rows: list[dict], local_count: int) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    (OUT_DIR / "NAVER_LOUNGE_GIRLWARS_ART_FEED_20260627.json").write_text(
        json.dumps({"source": BOARD_URL, "count": len(feeds), "feeds": feeds}, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    (OUT_DIR / "NAVER_LOUNGE_GIRLWARS_ART_MATCH_20260627.json").write_text(
        json.dumps(
            {
                "source": BOARD_URL,
                "localCandidateImageCount": local_count,
                "remoteFeedCount": len(feeds),
                "rows": rows,
            },
            ensure_ascii=False,
            indent=2,
        ),
        encoding="utf-8",
    )

    csv_path = OUT_DIR / "NAVER_LOUNGE_GIRLWARS_ART_MATCH_20260627.csv"
    fieldnames = [
        "feedId",
        "title",
        "artName",
        "createdDate",
        "articleUrl",
        "imageUrl",
        "matchStatus",
        "matchedActorId",
        "matchedKind",
        "matchScore",
        "phashDistance",
        "histDistance",
        "scoreGap",
        "matchedLocalPath",
    ]
    with csv_path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({key: row.get(key, "") for key in fieldnames})

    strong = sum(1 for row in rows if row.get("matchStatus") == "strong")
    medium = sum(1 for row in rows if row.get("matchStatus") == "medium")
    candidate = sum(1 for row in rows if row.get("matchStatus") == "candidate")
    lines = [
        "# Naver Lounge GirlsWar Art Match",
        "",
        f"- source: {BOARD_URL}",
        f"- remoteFeedCount: {len(feeds)}",
        f"- localCandidateImageCount: {local_count}",
        f"- strong: {strong}",
        f"- medium: {medium}",
        f"- candidate: {candidate}",
        "",
        "| feedId | title | actorId | status | kind | phash | score | local |",
        "|---:|---|---:|---|---|---:|---:|---|",
    ]
    for row in rows:
        lines.append(
            "| {feedId} | {title} | {actor} | {status} | {kind} | {phash} | {score} | `{path}` |".format(
                feedId=row.get("feedId", ""),
                title=(row.get("title") or "").replace("|", "\\|"),
                actor=row.get("matchedActorId", ""),
                status=row.get("matchStatus", ""),
                kind=row.get("matchedKind", ""),
                phash=row.get("phashDistance", ""),
                score=row.get("matchScore", ""),
                path=row.get("matchedLocalPath", ""),
            )
        )
    (OUT_DIR / "NAVER_LOUNGE_GIRLWARS_ART_MATCH_20260627.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    feeds = fetch_feeds()
    download_feed_images(feeds)
    local_images = iter_local_art_images()
    rows = build_matches(feeds, local_images)
    write_outputs(feeds, rows, len(local_images))
    print(
        json.dumps(
            {
                "feeds": len(feeds),
                "localCandidateImages": len(local_images),
                "outputs": str(OUT_DIR),
                "strong": sum(1 for row in rows if row.get("matchStatus") == "strong"),
                "medium": sum(1 for row in rows if row.get("matchStatus") == "medium"),
                "candidate": sum(1 for row in rows if row.get("matchStatus") == "candidate"),
            },
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()
