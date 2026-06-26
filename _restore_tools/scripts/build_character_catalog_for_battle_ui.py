from __future__ import annotations

import csv
import json
import re
import sys
import uuid
from datetime import datetime
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
INDEX_DIR = MERGED / "indexes"
REPORT_DIR = BASE / "reports" / "characters"
BATTLE_REPORT_DIR = BASE / "reports" / "battle"
BATTLE_UNITY_DATA = BASE / "girlswar_battle_unity" / "Assets" / "RestoreData" / "battle"
MAIN_UNITY_DATA = BASE / "girlswar_maininterface_unity" / "Assets" / "RestoreData"

OUT_CATALOG_JSON = REPORT_DIR / "GIRLSWAR_CHARACTER_CATALOG.json"
OUT_CATALOG_CSV = REPORT_DIR / "GIRLSWAR_CHARACTER_CATALOG.csv"
OUT_CATALOG_MD = REPORT_DIR / "GIRLSWAR_CHARACTER_CATALOG.md"
OUT_BATTLE_UI_JSON = REPORT_DIR / "GIRLSWAR_CHARACTER_BATTLE_UI_LIST.json"
OUT_BATTLE_UI_CSV = REPORT_DIR / "GIRLSWAR_CHARACTER_BATTLE_UI_LIST.csv"

UNITY_BATTLE_UI_JSON = BATTLE_UNITY_DATA / "GIRLSWAR_CHARACTER_BATTLE_UI_LIST.json"
UNITY_BATTLE_UI_CSV = BATTLE_UNITY_DATA / "GIRLSWAR_CHARACTER_BATTLE_UI_LIST.csv"
UNITY_MAIN_CATALOG_JSON = MAIN_UNITY_DATA / "GIRLSWAR_CHARACTER_CATALOG.json"
UNITY_MAIN_CATALOG_CSV = MAIN_UNITY_DATA / "GIRLSWAR_CHARACTER_CATALOG.csv"

PAYLOAD_JSON = BATTLE_UNITY_DATA / "BATTLE_TEST_PAYLOAD.json"

ASSETBUNDLES_CSV = INDEX_DIR / "assetbundles.csv"
UNITY_IMAGES_CSV = INDEX_DIR / "unity_images.csv"
UNITY_TEXTASSETS_CSV = INDEX_DIR / "unity_textassets.csv"

sys.path.insert(0, str(BASE / "_restore_tools" / "scripts"))
import build_battle_prototype_manifest as b5  # noqa: E402


def norm(value: str | Path | None) -> str:
    return str(value or "").replace("\\", "/").lower()


def rel(path: str | Path | None) -> str:
    if not path:
        return ""
    p = Path(path)
    try:
        return str(p.relative_to(BASE)).replace("\\", "/")
    except Exception:
        return str(path).replace("\\", "/")


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def copy_text(src: Path, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_text(src.read_text(encoding="utf-8"), encoding="utf-8")


def ensure_text_asset_meta(path: Path) -> None:
    meta = path.with_suffix(path.suffix + ".meta")
    if meta.exists():
        return
    guid = uuid.uuid4().hex
    meta.write_text(
        "\n".join(
            [
                "fileFormatVersion: 2",
                f"guid: {guid}",
                "TextScriptImporter:",
                "  externalObjects: {}",
                "  userData: ",
                "  assetBundleName: ",
                "  assetBundleVariant: ",
                "",
            ]
        ),
        encoding="utf-8",
    )


def as_int(value: Any) -> int | None:
    try:
        if value is None or value == "":
            return None
        return int(value)
    except (TypeError, ValueError):
        return None


def pipe(values: list[Any]) -> str:
    return "|".join(str(v) for v in values if v not in (None, "", 0))


def basename_token(value: Any) -> str:
    text = str(value or "").replace("\\", "/")
    if not text or text == "0":
        return ""
    return text.rsplit("/", 1)[-1].replace(".png", "")


def load_language(textassets: dict[str, dict[str, str]]) -> dict[str, str]:
    lang: dict[str, str] = {}
    for name in ["DTLangCommon", "DTLangBattle"]:
        row = textassets.get(name)
        if not row:
            continue
        text = (MERGED / row["output"]).read_text(encoding="utf-8", errors="replace")
        for key, value in re.findall(r"\['([^']+)'\]\s*=\s*'((?:\\'|[^'])*)'", text):
            lang[key] = value.replace("\\'", "'")
    return lang


def bundle_map() -> dict[str, dict[str, str]]:
    return {norm(r.get("bundle")): r for r in read_csv(ASSETBUNDLES_CSV) if r.get("bundle")}


def bundle_exists(bundle: str, bundles: dict[str, dict[str, str]]) -> bool:
    row = bundles.get(norm(bundle))
    return bool(row and row.get("status") == "ok")


def index_by_name(rows: list[dict[str, str]]) -> dict[str, list[dict[str, str]]]:
    out: dict[str, list[dict[str, str]]] = {}
    for row in rows:
        name = row.get("name", "")
        if not name:
            continue
        out.setdefault(name.lower(), []).append(row)
    return out


def choose_asset(
    by_name: dict[str, list[dict[str, str]]],
    name: str,
    preferred_bundle_fragments: list[str],
    preferred_type: str | None = None,
) -> dict[str, str] | None:
    if not name:
        return None
    candidates = by_name.get(name.lower(), [])
    if not candidates:
        return None
    best = None
    best_score = -10**18
    for row in candidates:
        score = 0
        bundle = norm(row.get("bundle"))
        if preferred_type and row.get("type") == preferred_type:
            score += 1_000_000_000
        for idx, fragment in enumerate(preferred_bundle_fragments):
            if fragment.lower() in bundle:
                score += 500_000_000 - idx * 1_000_000
        score += as_int(row.get("width")) or 0
        score += as_int(row.get("height")) or 0
        if row.get("output"):
            score += 10_000
        if score > best_score:
            best = row
            best_score = score
    return best


def output_path(row: dict[str, str] | None) -> str:
    return row.get("output", "") if row else ""


def absolute_output(row: dict[str, str] | None) -> str:
    if not row or not row.get("output"):
        return ""
    return str((MERGED / row["output"]).resolve())


def first_textasset_in_bundle(rows: list[dict[str, str]], bundle: str, suffix: str) -> dict[str, str] | None:
    b = norm(bundle)
    for row in rows:
        if norm(row.get("bundle")) == b and row.get("name", "").lower().endswith(suffix):
            return row
    return None


def image_exists(row: dict[str, str] | None) -> bool:
    if not row or not row.get("output"):
        return False
    return (MERGED / row["output"]).exists()


def load_payload() -> dict[str, Any]:
    data = json.loads(PAYLOAD_JSON.read_text(encoding="utf-8"))
    return data.get("battleInfo", data)


def payload_skill_ids(payload_hero: dict[str, Any]) -> list[int]:
    ids: list[int] = []
    for skill in payload_hero.get("skills", []):
        skill_id = as_int(skill.get("skillDid"))
        if skill_id:
            ids.append(skill_id)
    return ids


def build_catalog() -> tuple[dict[str, Any], list[dict[str, Any]], list[dict[str, Any]]]:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    textassets = b5.load_textasset_map()
    lang = load_language(textassets)
    hero_table = b5.load_table("hero", "DTHeroEntity", "DTHeroEntityTableData", textassets)
    model_table = b5.load_table("model", "DTmodelEntity", "DTmodelEntityTableData", textassets)
    initial_table = b5.load_table("initial", "DTHeroInitialEntity", "DTHeroInitialEntityTableData", textassets)
    bundles = bundle_map()
    image_rows = read_csv(UNITY_IMAGES_CSV)
    textasset_rows = read_csv(UNITY_TEXTASSETS_CSV)
    images_by_name = index_by_name(image_rows)
    textassets_by_name = index_by_name(textasset_rows)

    characters: list[dict[str, Any]] = []
    for hero_id in sorted(hero_table.rows):
        hero = hero_table.rows[hero_id]
        model_id = as_int(hero.get("modelID"))
        model = model_table.rows.get(model_id or -1)
        initial = initial_table.rows.get(hero_id, {})
        prefab_id = as_int(model.get("prefabId")) if model else None

        head_name = basename_token(model.get("head") if model else "")
        head = choose_asset(images_by_name, head_name, ["/uiherohead/", "/uiheroheadbattle"], "Sprite")
        battle_bundle = f"download/roleprefabsandres/battleprefabandres/{prefab_id}.assetbundle" if prefab_id else ""
        battle_skel = first_textasset_in_bundle(textasset_rows, battle_bundle, ".skel") if battle_bundle else None
        battle_atlas = first_textasset_in_bundle(textasset_rows, battle_bundle, ".atlas") if battle_bundle else None
        battle_texture = choose_asset(images_by_name, str(prefab_id or ""), [battle_bundle], "Texture2D")

        painting_bundle_fragment = f"/paintingprefabandres/{hero_id}.assetbundle"
        rolebig_bundle_fragment = f"/rolebigsetpainting/{hero_id}.assetbundle"
        big_painting_name = basename_token(model.get("bigPainting") if model else "")
        painting_name = "painting_" + str(hero_id)
        painting = choose_asset(
            images_by_name,
            painting_name,
            [rolebig_bundle_fragment, painting_bundle_fragment, "/review.assetbundle"],
            "Texture2D",
        ) or choose_asset(images_by_name, big_painting_name, [rolebig_bundle_fragment, painting_bundle_fragment], "Texture2D")
        card_name = basename_token(model.get("collection_normal_Pic") if model else "")
        card = choose_asset(images_by_name, card_name, [painting_bundle_fragment, rolebig_bundle_fragment], "Sprite")
        name_spine_name = "SP_heroname_" + str(hero_id)
        name_spine_texture = choose_asset(images_by_name, name_spine_name, [painting_bundle_fragment], "Texture2D")
        name_spine_skel = choose_asset(textassets_by_name, name_spine_name + ".skel", [painting_bundle_fragment], None)
        name_spine_atlas = choose_asset(textassets_by_name, name_spine_name + ".atlas", [painting_bundle_fragment], None)

        skill_awake = hero.get("skillAwake")
        if not isinstance(skill_awake, list):
            skill_awake = []
        skill_ids = [
            as_int(hero.get("skill1")),
            as_int(hero.get("skill2")),
            as_int(hero.get("skill3")),
            as_int(hero.get("skill4")),
            as_int(hero.get("skill5")),
            *[as_int(x) for x in skill_awake],
        ]
        skill_ids = [x for x in skill_ids if x]

        name_key = str(hero.get("heroName") or "")
        location_key = str(hero.get("location") or "")
        intro_key = str(hero.get("intro") or "")
        row = {
            "id": hero_id,
            "nameKey": name_key,
            "nameKo": lang.get(name_key, ""),
            "rarity": hero.get("star", ""),
            "rankLevel": hero.get("rankLevel", ""),
            "level": "",
            "levelSource": "catalog_static_no_runtime_level; battle payload rows carry lockLevel/rankLevel",
            "roleKey": location_key,
            "roleKo": lang.get(location_key, ""),
            "profession": hero.get("profession", ""),
            "expert": hero.get("expert", ""),
            "camp": hero.get("camp", ""),
            "isPet": hero.get("isPet", ""),
            "modelId": model_id or "",
            "modelFound": bool(model),
            "prefabId": prefab_id or "",
            "battleActorBundle": battle_bundle,
            "battleActorBundleExists": bundle_exists(battle_bundle, bundles) if battle_bundle else False,
            "battleSpineSkeletonData": output_path(battle_skel),
            "battleSpineAtlas": output_path(battle_atlas),
            "battleSpineTexture": output_path(battle_texture),
            "headSprite": head_name,
            "headImage": output_path(head),
            "headImageAbsolutePath": absolute_output(head),
            "headImageExists": image_exists(head),
            "cardImageName": card_name,
            "cardImage": output_path(card),
            "paintingImage": output_path(painting),
            "paintingImageName": painting.get("name", "") if painting else "",
            "nameSpineSkeletonData": output_path(name_spine_skel),
            "nameSpineAtlas": output_path(name_spine_atlas),
            "nameSpineTexture": output_path(name_spine_texture),
            "skin": hero.get("heroSkin", ""),
            "heroWeapons": hero.get("heroWeapons", []),
            "skillIds": skill_ids,
            "skillIdList": pipe(skill_ids),
            "baseHp": initial.get("hp", ""),
            "baseAtk": initial.get("atk", ""),
            "baseDef": initial.get("def", ""),
            "introKey": intro_key,
            "introKo": lang.get(intro_key, ""),
            "datatableEvidence": "DTHeroEntity -> DTmodelEntity; DTLangBattle/DTLangCommon; unity_images/unity_textassets indexes",
        }
        characters.append(row)

    catalog = {
        "name": "GirlsWar full character catalog",
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "generatedBy": rel(Path(__file__)),
        "characterCount": len(characters),
        "charactersWithKoreanName": sum(1 for row in characters if row["nameKo"]),
        "charactersWithHeadImage": sum(1 for row in characters if row["headImage"]),
        "charactersWithBattleSpineBundle": sum(1 for row in characters if row["battleActorBundleExists"]),
        "charactersWithBattleSpineSkeleton": sum(1 for row in characters if row["battleSpineSkeletonData"]),
        "sources": {
            "heroEntity": rel(hero_table.entity_path),
            "heroTableData": rel(hero_table.table_path),
            "modelEntity": rel(model_table.entity_path),
            "modelTableData": rel(model_table.table_path),
            "initialEntity": rel(initial_table.entity_path),
            "initialTableData": rel(initial_table.table_path),
            "languageTables": [
                rel(MERGED / textassets["DTLangCommon"]["output"]),
                rel(MERGED / textassets["DTLangBattle"]["output"]),
            ],
            "assetbundleIndex": rel(ASSETBUNDLES_CSV),
            "imageIndex": rel(UNITY_IMAGES_CSV),
            "textassetIndex": rel(UNITY_TEXTASSETS_CSV),
        },
        "characters": characters,
    }

    battle_ui = build_battle_ui_payload(catalog)
    return catalog, characters, battle_ui


def build_battle_ui_payload(catalog: dict[str, Any]) -> list[dict[str, Any]]:
    by_id = {int(row["id"]): row for row in catalog["characters"]}
    info = load_payload()
    cards: list[dict[str, Any]] = []
    for slot, payload_hero in enumerate(info.get("ourHeros", []), start=1):
        hero_did = as_int(payload_hero.get("heroDid"))
        if hero_did is None:
            continue
        catalog_row = by_id.get(hero_did, {})
        skill_ids = payload_skill_ids(payload_hero)
        cards.append(
            {
                "slot": slot,
                "heroDid": str(hero_did),
                "heroId": str(payload_hero.get("heroId", "")),
                "nameKey": catalog_row.get("nameKey", ""),
                "nameKo": catalog_row.get("nameKo", ""),
                "rarity": str(catalog_row.get("rarity", "")),
                "rankLevel": str(payload_hero.get("rankLevel", catalog_row.get("rankLevel", ""))),
                "level": str(payload_hero.get("lockLevel", "")),
                "levelSource": "battle payload lockLevel",
                "roleKey": catalog_row.get("roleKey", ""),
                "roleKo": catalog_row.get("roleKo", ""),
                "profession": str(catalog_row.get("profession", "")),
                "expert": str(catalog_row.get("expert", "")),
                "headSprite": catalog_row.get("headSprite", ""),
                "headOutput": catalog_row.get("headImage", ""),
                "headPngPath": catalog_row.get("headImageAbsolutePath", ""),
                "cardImage": catalog_row.get("cardImage", ""),
                "paintingImage": catalog_row.get("paintingImage", ""),
                "assetBundle": catalog_row.get("battleActorBundle", ""),
                "actorBundleExists": bool(catalog_row.get("battleActorBundleExists", False)),
                "spineSkeletonData": catalog_row.get("battleSpineSkeletonData", ""),
                "spineAtlas": catalog_row.get("battleSpineAtlas", ""),
                "spineTexture": catalog_row.get("battleSpineTexture", ""),
                "normalSkill": str(skill_ids[0] if len(skill_ids) > 0 else ""),
                "smallSkill": str(skill_ids[1] if len(skill_ids) > 1 else ""),
                "bigSkill": str(skill_ids[2] if len(skill_ids) > 2 else ""),
                "skillIdList": pipe(skill_ids),
                "curHp": payload_hero.get("curHp", ""),
                "curMp": payload_hero.get("curMp", ""),
                "evidence": "BATTLE_TEST_PAYLOAD.ourHeros joined to GIRLSWAR_CHARACTER_CATALOG by heroDid",
            }
        )
    return cards


def write_outputs(catalog: dict[str, Any], characters: list[dict[str, Any]], battle_cards: list[dict[str, Any]]) -> None:
    character_fields = [
        "id",
        "nameKey",
        "nameKo",
        "rarity",
        "rankLevel",
        "level",
        "levelSource",
        "roleKey",
        "roleKo",
        "profession",
        "expert",
        "camp",
        "isPet",
        "modelId",
        "modelFound",
        "prefabId",
        "battleActorBundle",
        "battleActorBundleExists",
        "battleSpineSkeletonData",
        "battleSpineAtlas",
        "battleSpineTexture",
        "headSprite",
        "headImage",
        "headImageExists",
        "cardImageName",
        "cardImage",
        "paintingImage",
        "paintingImageName",
        "nameSpineSkeletonData",
        "nameSpineAtlas",
        "nameSpineTexture",
        "skin",
        "skillIdList",
        "baseHp",
        "baseAtk",
        "baseDef",
        "introKey",
        "introKo",
        "datatableEvidence",
    ]
    battle_fields = [
        "slot",
        "heroDid",
        "heroId",
        "nameKey",
        "nameKo",
        "rarity",
        "rankLevel",
        "level",
        "levelSource",
        "roleKey",
        "roleKo",
        "profession",
        "expert",
        "headSprite",
        "headOutput",
        "headPngPath",
        "cardImage",
        "paintingImage",
        "assetBundle",
        "actorBundleExists",
        "spineSkeletonData",
        "spineAtlas",
        "spineTexture",
        "normalSkill",
        "smallSkill",
        "bigSkill",
        "skillIdList",
        "curHp",
        "curMp",
        "evidence",
    ]
    battle_payload = {
        "name": "GirlsWar battle UI character list",
        "generatedAt": catalog["generatedAt"],
        "generatedBy": catalog["generatedBy"],
        "sourceCatalog": rel(OUT_CATALOG_JSON),
        "sourcePayload": rel(PAYLOAD_JSON),
        "battleCardCount": len(battle_cards),
        "battleCards": battle_cards,
    }

    write_json(OUT_CATALOG_JSON, catalog)
    write_csv(OUT_CATALOG_CSV, characters, character_fields)
    write_json(OUT_BATTLE_UI_JSON, battle_payload)
    write_csv(OUT_BATTLE_UI_CSV, battle_cards, battle_fields)

    copy_text(OUT_BATTLE_UI_JSON, UNITY_BATTLE_UI_JSON)
    copy_text(OUT_BATTLE_UI_CSV, UNITY_BATTLE_UI_CSV)
    copy_text(OUT_CATALOG_JSON, UNITY_MAIN_CATALOG_JSON)
    copy_text(OUT_CATALOG_CSV, UNITY_MAIN_CATALOG_CSV)
    for path in [UNITY_BATTLE_UI_JSON, UNITY_BATTLE_UI_CSV, UNITY_MAIN_CATALOG_JSON, UNITY_MAIN_CATALOG_CSV]:
        ensure_text_asset_meta(path)

    lines = [
        "# GirlsWar Character Catalog",
        "",
        "Original-table and extracted-asset backed catalog for character/battle UI consumers.",
        "",
        "## Summary",
        f"- Character rows: `{catalog['characterCount']}`",
        f"- Korean names resolved: `{catalog['charactersWithKoreanName']}`",
        f"- Head sprites resolved: `{catalog['charactersWithHeadImage']}`",
        f"- Existing battle actor bundles: `{catalog['charactersWithBattleSpineBundle']}`",
        f"- Existing battle skeleton TextAssets: `{catalog['charactersWithBattleSpineSkeleton']}`",
        f"- Battle UI card rows: `{len(battle_cards)}`",
        "",
        "## Data Products",
        f"- Full catalog JSON: `{rel(OUT_CATALOG_JSON)}`",
        f"- Full catalog CSV: `{rel(OUT_CATALOG_CSV)}`",
        f"- Battle UI JSON: `{rel(OUT_BATTLE_UI_JSON)}`",
        f"- Battle UI CSV: `{rel(OUT_BATTLE_UI_CSV)}`",
        f"- Unity battle copy: `{rel(UNITY_BATTLE_UI_JSON)}`",
        f"- Unity maininterface copy: `{rel(UNITY_MAIN_CATALOG_JSON)}`",
        "",
        "## Field Notes",
        "- `level` is intentionally blank in the static catalog because no per-character runtime level exists in `DTHeroEntity`; battle UI rows use payload `lockLevel` and keep `rankLevel` separately.",
        "- `roleKo` is the localized `DTHero.location` text, paired with raw `profession`/`expert` numbers instead of guessed role names.",
        "- Asset paths are extracted-index outputs relative to `girlswar_merged_extracted`, with absolute head PNG paths included only for Unity runtime image loading.",
        "",
        "## Battle UI Cards",
        "| slot | heroDid | name | rarity | level | role | head | actor bundle |",
        "| ---: | ---: | --- | ---: | ---: | --- | --- | --- |",
    ]
    for row in battle_cards:
        lines.append(
            f"| {row['slot']} | {row['heroDid']} | {row['nameKo'] or row['nameKey']} | {row['rarity']} | {row['level']} | {row['roleKo']} | `{row['headSprite']}` | `{row['assetBundle']}` |"
        )
    OUT_CATALOG_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    catalog, characters, battle_cards = build_catalog()
    write_outputs(catalog, characters, battle_cards)
    print("Wrote character catalog and battle UI list")
    print(json.dumps({
        "characters": len(characters),
        "battleCards": len(battle_cards),
        "headResolved": catalog["charactersWithHeadImage"],
        "battleBundles": catalog["charactersWithBattleSpineBundle"],
        "outputs": [
            rel(OUT_CATALOG_JSON),
            rel(OUT_BATTLE_UI_JSON),
            rel(UNITY_BATTLE_UI_JSON),
            rel(UNITY_MAIN_CATALOG_JSON),
        ],
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
