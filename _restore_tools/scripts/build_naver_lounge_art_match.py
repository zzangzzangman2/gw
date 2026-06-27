import csv
import html
import json
import math
import re
import time
import unicodedata
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
CATALOG_JSON = ROOT / "reports" / "characters" / "GIRLSWAR_CHARACTER_CATALOG.json"


ID_RE = re.compile(r"(?:T_ditu|homepage_underwear|starHeroName|Painting|noalphabg_Tujian|noalphabg_Neiyi|_)(?:_)?(\d{3,6})(?:[_\.]|$)")
ART_NAME_RE = re.compile(r"^(?:소녀전쟁\s*\|\s*)?(?:UR\s*플래시|UR플래시|UR|SSR|SR|R)?\s*(.+?)\s*$")
ZERO_WIDTH_RE = re.compile(r"[\ufeff\u200b\u200c\u200d\u2060]")
SPACE_RE = re.compile(r"\s+")

NAME_ALIASES = {
    "아베노 세이메이": "세이메이",
    "징기스칸": "칭기스칸",
    "타케바나 한베에": "타케나카 한베에",
    "다케바나 한베에": "타케나카 한베에",
    "타케나카 한베에": "타케나카 한베에",
    "미츠히데": "아케치 미츠히데",
}


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


def normalize_text(value: str) -> str:
    text = unicodedata.normalize("NFKC", value or "")
    text = ZERO_WIDTH_RE.sub("", text)
    text = SPACE_RE.sub(" ", text)
    return text.strip()


def canonical_art_name(value: str) -> tuple[str, str, bool]:
    cleaned = normalize_text(value)
    cleaned = re.sub(r"^소녀전쟁\s*\|\s*", "", cleaned)
    cleaned = re.sub(r"^(?:UR\s*플래시|UR플래시|UR|SSR|SR|R)\s*", "", cleaned)
    cleaned = re.sub(r"\s*원화\s*$", "", cleaned)
    cleaned = normalize_text(cleaned)
    canonical = NAME_ALIASES.get(cleaned, cleaned)
    return cleaned, canonical, canonical != cleaned


def desired_variant(title: str) -> str:
    normalized = normalize_text(title)
    if "플래시" in normalized:
        return "flash"
    if "UR" in normalized:
        return "ur"
    return "base"


def actor_variant(actor_id: int | str | None) -> str:
    try:
        value = int(actor_id)
    except (TypeError, ValueError):
        return ""
    if 31000 <= value < 32000:
        return "flash"
    if 21000 <= value < 22000:
        return "ur"
    return "base"


def catalog_rel_path(row: dict, *keys: str) -> str:
    for key in keys:
        value = row.get(key)
        if value:
            normalized = str(value).replace("\\", "/")
            return "girlswar_merged_extracted/" + normalized
    return ""


def load_character_catalog() -> dict:
    if not CATALOG_JSON.exists():
        return {"byName": {}, "byId": {}}

    payload = json.loads(CATALOG_JSON.read_text(encoding="utf-8"))
    by_name: dict[str, list[dict]] = {}
    by_id: dict[int, dict] = {}
    for row in payload.get("characters", []):
        name = normalize_text(row.get("nameKo") or "")
        if not name:
            continue
        normalized_name = canonical_art_name(name)[1]
        by_name.setdefault(normalized_name, []).append(row)
        try:
            by_id[int(row.get("id"))] = row
        except (TypeError, ValueError):
            pass

    for rows in by_name.values():
        rows.sort(key=lambda item: int(item.get("id") or 0))
    return {"byName": by_name, "byId": by_id}


def choose_catalog_row(candidates: list[dict], variant: str, visual_actor_id: int | None) -> dict | None:
    if not candidates:
        return None

    def score(row: dict) -> tuple[int, int]:
        actor_id = int(row.get("id") or 0)
        current_variant = actor_variant(actor_id)
        value = 0
        if current_variant == variant:
            value += 1000
        elif variant == "flash" and current_variant == "ur":
            value += 600
        elif variant == "ur" and current_variant == "base":
            value += 500
        elif variant == "base" and current_variant == "ur":
            value += 100
        if visual_actor_id and actor_id == visual_actor_id:
            value += 50
        if row.get("paintingImage"):
            value += 20
        if row.get("headImage"):
            value += 10
        if row.get("battleActorBundleExists"):
            value += 5
        return value, -actor_id

    return max(candidates, key=score)


def match_catalog(feed: dict, catalog: dict, visual_actor_id: int | None) -> dict:
    raw_name = feed.get("artName") or clean_art_name(feed.get("title") or "")
    normalized_name, canonical_name, alias_used = canonical_art_name(raw_name)
    variant = desired_variant(feed.get("title") or raw_name)
    candidates = catalog["byName"].get(canonical_name, [])
    row = choose_catalog_row(candidates, variant, visual_actor_id)

    if row:
        actor_id = int(row.get("id") or 0)
        status = "title_alias" if alias_used else "title_exact"
        confidence = "medium" if alias_used else "strong"
        return {
            "titleName": normalized_name,
            "canonicalName": canonical_name,
            "requestedVariant": variant,
            "matchStatus": status,
            "matchConfidence": confidence,
            "matchedActorId": actor_id,
            "matchedNameKo": row.get("nameKo", ""),
            "matchedVariant": actor_variant(actor_id),
            "nameCandidateIds": "|".join(str(candidate.get("id", "")) for candidate in candidates),
            "matchedKind": "catalog",
            "matchedLocalPath": catalog_rel_path(row, "paintingImage", "cardImage", "headImage"),
            "headImage": catalog_rel_path(row, "headImage"),
            "cardImage": catalog_rel_path(row, "cardImage"),
            "paintingImage": catalog_rel_path(row, "paintingImage"),
            "battleActorBundle": row.get("battleActorBundle", ""),
            "battleActorBundleExists": bool(row.get("battleActorBundleExists")),
            "nameEvidence": "Naver title/artName -> GIRLSWAR_CHARACTER_CATALOG.nameKo",
        }

    return {
        "titleName": normalized_name,
        "canonicalName": canonical_name,
        "requestedVariant": variant,
        "matchStatus": "title_unresolved",
        "matchConfidence": "low",
        "matchedActorId": visual_actor_id or "",
        "matchedNameKo": "",
        "matchedVariant": actor_variant(visual_actor_id),
        "nameCandidateIds": "",
        "matchedKind": "visual_fallback" if visual_actor_id else "",
        "matchedLocalPath": "",
        "headImage": "",
        "cardImage": "",
        "paintingImage": "",
        "battleActorBundle": "",
        "battleActorBundleExists": False,
        "nameEvidence": "no matching local name; visual candidate retained only as fallback",
    }


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


def build_matches(feeds: list[dict], local_images: list[dict], catalog: dict) -> list[dict]:
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
            rows.append({**feed, **match_catalog(feed, catalog, None), "visualMatchStatus": "no_remote_feature"})
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
                "visualMatchStatus": status,
                "visualBestActorId": best[3]["actorId"],
                "visualBestKind": best[3]["kind"],
                "visualBestLocalPath": str(best[3]["path"].relative_to(ROOT)).replace("\\", "/"),
                "visualBestScore": round(best[0], 3),
                "visualPhashDistance": best[1],
                "visualHistDistance": round(best[2], 4),
                "visualScoreGap": round(gap, 3),
                "visualTopCandidates": [
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
            row.update(match_catalog(feed, catalog, best[3]["actorId"]))
            if not row.get("matchedLocalPath"):
                row["matchedLocalPath"] = row.get("visualBestLocalPath", "")
            rows.append(row)
    return rows


def write_outputs(feeds: list[dict], rows: list[dict], local_count: int) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    visual_disagreement = sum(
        1
        for row in rows
        if row.get("matchedActorId") and row.get("visualBestActorId") and row.get("matchedActorId") != row.get("visualBestActorId")
    )
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
                "titleExact": sum(1 for row in rows if row.get("matchStatus") == "title_exact"),
                "titleAlias": sum(1 for row in rows if row.get("matchStatus") == "title_alias"),
                "titleUnresolved": sum(1 for row in rows if row.get("matchStatus") == "title_unresolved"),
                "visualDisagreement": visual_disagreement,
                "rows": rows,
            },
            ensure_ascii=False,
            indent=2,
        ),
        encoding="utf-8",
    )
    (OUT_DIR / "NAVER_LOUNGE_GIRLWARS_CHARACTER_MATCH_20260627.json").write_text(
        (OUT_DIR / "NAVER_LOUNGE_GIRLWARS_ART_MATCH_20260627.json").read_text(encoding="utf-8"),
        encoding="utf-8",
    )

    csv_path = OUT_DIR / "NAVER_LOUNGE_GIRLWARS_ART_MATCH_20260627.csv"
    fieldnames = [
        "feedId",
        "title",
        "artName",
        "titleName",
        "canonicalName",
        "createdDate",
        "articleUrl",
        "imageUrl",
        "requestedVariant",
        "matchStatus",
        "matchConfidence",
        "matchedActorId",
        "matchedNameKo",
        "matchedVariant",
        "nameCandidateIds",
        "matchedKind",
        "matchedLocalPath",
        "headImage",
        "cardImage",
        "paintingImage",
        "battleActorBundle",
        "battleActorBundleExists",
        "nameEvidence",
        "visualMatchStatus",
        "visualBestActorId",
        "visualBestKind",
        "visualBestScore",
        "visualPhashDistance",
        "visualHistDistance",
        "visualScoreGap",
        "visualBestLocalPath",
    ]
    with csv_path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({key: row.get(key, "") for key in fieldnames})

    title_exact = sum(1 for row in rows if row.get("matchStatus") == "title_exact")
    title_alias = sum(1 for row in rows if row.get("matchStatus") == "title_alias")
    title_unresolved = sum(1 for row in rows if row.get("matchStatus") == "title_unresolved")
    flash = sum(1 for row in rows if row.get("matchedVariant") == "flash")
    ur = sum(1 for row in rows if row.get("matchedVariant") == "ur")
    base = sum(1 for row in rows if row.get("matchedVariant") == "base")
    lines = [
        "# Naver Lounge GirlsWar Character Match",
        "",
        f"- source: {BOARD_URL}",
        f"- remoteFeedCount: {len(feeds)}",
        f"- localCandidateImageCount: {local_count}",
        f"- titleExact: {title_exact}",
        f"- titleAlias: {title_alias}",
        f"- titleUnresolved: {title_unresolved}",
        f"- matchedVariantBase: {base}",
        f"- matchedVariantUr: {ur}",
        f"- matchedVariantFlash: {flash}",
        f"- visualDisagreement: {visual_disagreement}",
        "",
        "Matching rule: Naver title/artName -> local `GIRLSWAR_CHARACTER_CATALOG.nameKo` first. Visual pHash is retained as a diagnostic only.",
        "",
        "| feedId | title name | actorId | local name | variant | status | candidates | visualBest | local art |",
        "|---:|---|---:|---|---|---|---|---:|---|",
    ]
    for row in rows:
        lines.append(
            "| {feedId} | {name} | {actor} | {local_name} | {variant} | {status} | {candidates} | {visual} | `{path}` |".format(
                feedId=row.get("feedId", ""),
                name=(row.get("canonicalName") or row.get("artName") or "").replace("|", "\\|"),
                actor=row.get("matchedActorId", ""),
                local_name=(row.get("matchedNameKo") or "").replace("|", "\\|"),
                variant=row.get("matchedVariant", ""),
                status=row.get("matchStatus", ""),
                candidates=row.get("nameCandidateIds", ""),
                visual=row.get("visualBestActorId", ""),
                path=row.get("matchedLocalPath", ""),
            )
        )
    (OUT_DIR / "NAVER_LOUNGE_GIRLWARS_ART_MATCH_20260627.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    (OUT_DIR / "NAVER_LOUNGE_GIRLWARS_CHARACTER_MATCH_20260627.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    (OUT_DIR / "NAVER_LOUNGE_GIRLWARS_CHARACTER_MATCH_20260627.csv").write_text(
        csv_path.read_text(encoding="utf-8-sig"),
        encoding="utf-8-sig",
    )
    write_html_gallery(rows, OUT_DIR / "NAVER_LOUNGE_GIRLWARS_CHARACTER_MATCH_20260627.html")


def write_html_gallery(rows: list[dict], path: Path) -> None:
    cards = []
    for row in rows:
        remote = html.escape(row.get("imageUrl") or "")
        local_rel = row.get("matchedLocalPath") or row.get("visualBestLocalPath") or ""
        local_src = html.escape("../../../" + local_rel if local_rel else "")
        title = html.escape(row.get("title") or "")
        actor = html.escape(str(row.get("matchedActorId") or ""))
        name = html.escape(row.get("matchedNameKo") or row.get("canonicalName") or "")
        variant = html.escape(row.get("matchedVariant") or "")
        status = html.escape(row.get("matchStatus") or "")
        visual = html.escape(str(row.get("visualBestActorId") or ""))
        cards.append(
            "\n".join(
                [
                    '<article class="card">',
                    f'  <a class="article" href="{html.escape(row.get("articleUrl") or "")}">{html.escape(str(row.get("feedId") or ""))}</a>',
                    f"  <h2>{name} <span>{actor} · {variant}</span></h2>",
                    f"  <p>{title}</p>",
                    '  <div class="imgs">',
                    f'    <figure><img src="{remote}" loading="lazy"><figcaption>Naver</figcaption></figure>',
                    f'    <figure><img src="{local_src}" loading="lazy"><figcaption>Local {status}; visual {visual}</figcaption></figure>',
                    "  </div>",
                    "</article>",
                ]
            )
        )

    path.write_text(
        "\n".join(
            [
                "<!doctype html>",
                '<meta charset="utf-8">',
                "<title>Naver Lounge GirlsWar Character Match</title>",
                "<style>",
                "body{margin:0;background:#171717;color:#f4f1ea;font-family:Segoe UI,Malgun Gothic,sans-serif}",
                "header{position:sticky;top:0;background:#111;padding:16px 20px;border-bottom:1px solid #333;z-index:2}",
                "h1{font-size:20px;margin:0 0 4px} header p{margin:0;color:#bbb}",
                "main{display:grid;grid-template-columns:repeat(auto-fill,minmax(360px,1fr));gap:14px;padding:14px}",
                ".card{background:#242424;border:1px solid #3a3a3a;border-radius:6px;padding:12px}",
                ".article{float:right;color:#9dc7ff;text-decoration:none;font-size:12px}",
                "h2{font-size:18px;margin:0 0 4px} h2 span{color:#b9b9b9;font-size:13px;font-weight:400}",
                "p{margin:0 0 10px;color:#cfcfcf;font-size:13px;clear:both}",
                ".imgs{display:grid;grid-template-columns:1fr 1fr;gap:8px;align-items:start}",
                "figure{margin:0;background:#111;border:1px solid #333;min-height:160px}",
                "img{display:block;width:100%;height:240px;object-fit:contain;background:#101010}",
                "figcaption{font-size:12px;color:#c4c4c4;padding:6px 8px;border-top:1px solid #333}",
                "</style>",
                "<header>",
                "<h1>Naver Lounge GirlsWar Character Match</h1>",
                f"<p>{len(rows)} feeds matched by title/name first; pHash shown only as visual diagnostic.</p>",
                "</header>",
                "<main>",
                *cards,
                "</main>",
            ]
        ),
        encoding="utf-8",
    )


def main() -> None:
    feeds = fetch_feeds()
    download_feed_images(feeds)
    local_images = iter_local_art_images()
    catalog = load_character_catalog()
    rows = build_matches(feeds, local_images, catalog)
    write_outputs(feeds, rows, len(local_images))
    print(
        json.dumps(
            {
                "feeds": len(feeds),
                "localCandidateImages": len(local_images),
                "outputs": str(OUT_DIR),
                "titleExact": sum(1 for row in rows if row.get("matchStatus") == "title_exact"),
                "titleAlias": sum(1 for row in rows if row.get("matchStatus") == "title_alias"),
                "titleUnresolved": sum(1 for row in rows if row.get("matchStatus") == "title_unresolved"),
            },
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()
