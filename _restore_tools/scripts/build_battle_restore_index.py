from __future__ import annotations

import csv
import json
import re
from pathlib import Path
from typing import Iterable


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
INDEX_DIR = MERGED / "indexes"
REPORT_DIR = BASE / "reports" / "battle"

ASSETBUNDLES_CSV = INDEX_DIR / "assetbundles.csv"
TEXTASSETS_CSV = INDEX_DIR / "unity_textassets.csv"
IMAGES_CSV = INDEX_DIR / "unity_images.csv"

OUT_ASSETBUNDLES = REPORT_DIR / "BATTLE_ASSETBUNDLE_CANDIDATES.csv"
OUT_TEXTASSETS = REPORT_DIR / "BATTLE_TEXTASSET_CANDIDATES.csv"
OUT_IMAGES = REPORT_DIR / "BATTLE_IMAGE_CANDIDATES.csv"
OUT_XLUA_TARGETS = REPORT_DIR / "BATTLE_XLUA_DECODE_TARGETS.csv"
OUT_SUMMARY = REPORT_DIR / "battle_restore_index_summary.json"
OUT_PLAN = REPORT_DIR / "BATTLE_RESTORE_PLAN.md"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: Iterable[dict[str, object]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def norm(text: str) -> str:
    return text.replace("\\", "/").lower()


def classify_bundle(bundle: str) -> str | None:
    b = norm(bundle)
    if "download/xlualogic/modules/battle.assetbundle" in b:
        return "xlua_core_battle"
    if "download/xlualogic/modules/procedure.assetbundle" in b:
        return "xlua_procedure"
    if re.search(r"download/xlualogic/modules/battle(buff|skill|relic)script\.assetbundle", b):
        return "xlua_battle_script_library"
    if "download/xlualogic/modules/battlepreview.assetbundle" in b:
        return "xlua_battle_preview"
    if re.search(r"download/xlualogic/datanode/datatable/create/(monster|skillact|titans|minebattle|guildbattle)\.assetbundle", b):
        return "datatable_battle"
    if re.search(r"download/xlualogic/datanode/proto/(fight|formation|battleserver|fightaward|fightrecord|titans)\.assetbundle", b):
        return "proto_battle"
    if "download/roleprefabsandres/battleprefabandres/" in b:
        return "spine_battle_actor"
    if "download/artsources/map/battlemap/" in b:
        return "battlemap_sprite_art"
    if "download/map/battlemap/" in b:
        return "battlemap_prefab_scene"
    if re.search(r"download/commonprefabsandres/(battle|buffeffect|skilleffect|spinematandshaders|uiskill)/", b) or re.search(
        r"download/commonprefabsandres/(battle|spinematandshaders)\.assetbundle", b
    ):
        return "common_battle_runtime_asset"
    if re.search(r"download/artsources/uispriteres/(uibattle|uiheroheadbattle|uiskill|uiminebattle|uibattlepass)\.assetbundle", b):
        return "battle_ui_sprite"
    if re.search(r"download/ui/uiprefabandres/(battle|jiesuan|winlose|earth|formation|lineup|uibattle)", b):
        return "battle_ui_prefab_or_ext"
    if "download/audio/battle" in b or "download/audio/battlese" in b:
        return "battle_audio_preserved"
    return None


def classify_textasset(bundle: str, name: str) -> str | None:
    bundle_class = classify_bundle(bundle)
    n = norm(name)
    if bundle_class:
        return bundle_class
    if re.search(r"battle|fight|combat|skill|buff|hurt|monster|formation|stage|titan", n):
        return "keyword_textasset"
    return None


def classify_image(bundle: str, name: str) -> str | None:
    bundle_class = classify_bundle(bundle)
    n = norm(name)
    if bundle_class in {"battlemap_sprite_art", "battle_ui_sprite", "common_battle_runtime_asset", "battle_ui_prefab_or_ext"}:
        return bundle_class
    if re.search(r"battle|fight|skill|buff|hurt|monster|formation|stage|spine|map_", n):
        return "keyword_image"
    return None


def int_value(value: str) -> int:
    try:
        return int(value)
    except Exception:
        return 0


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)

    asset_rows: list[dict[str, object]] = []
    for row in read_csv(ASSETBUNDLES_CSV):
        category = classify_bundle(row.get("bundle", ""))
        if category is None:
            continue
        asset_rows.append(
            {
                "category": category,
                "bundle": row.get("bundle", ""),
                "size": row.get("size", ""),
                "parse_status": row.get("parse_status", ""),
                "object_count": row.get("object_count", ""),
                "type_counts": row.get("type_counts", ""),
            }
        )
    asset_rows.sort(key=lambda r: (str(r["category"]), str(r["bundle"])))

    text_rows: list[dict[str, object]] = []
    for row in read_csv(TEXTASSETS_CSV):
        category = classify_textasset(row.get("bundle", ""), row.get("name", ""))
        if category is None:
            continue
        text_rows.append(
            {
                "category": category,
                "bundle": row.get("bundle", ""),
                "path_id": row.get("path_id", ""),
                "name": row.get("name", ""),
                "size": row.get("size", ""),
                "looks_text": row.get("looks_text", ""),
                "output": row.get("output", ""),
            }
        )
    text_rows.sort(key=lambda r: (str(r["category"]), str(r["bundle"]), -int_value(str(r["size"])), str(r["name"])))

    image_rows: list[dict[str, object]] = []
    for row in read_csv(IMAGES_CSV):
        category = classify_image(row.get("bundle", ""), row.get("name", ""))
        if category is None:
            continue
        image_rows.append(
            {
                "category": category,
                "bundle": row.get("bundle", ""),
                "path_id": row.get("path_id", ""),
                "type": row.get("type", ""),
                "name": row.get("name", ""),
                "width": row.get("width", ""),
                "height": row.get("height", ""),
                "output": row.get("output", ""),
                "error": row.get("error", ""),
            }
        )
    image_rows.sort(key=lambda r: (str(r["category"]), str(r["bundle"]), str(r["name"])))

    xlua_targets = [
        row
        for row in text_rows
        if str(row["category"]) in {"xlua_core_battle", "xlua_procedure", "xlua_battle_script_library", "xlua_battle_preview"}
    ]

    write_csv(
        OUT_ASSETBUNDLES,
        asset_rows,
        ["category", "bundle", "size", "parse_status", "object_count", "type_counts"],
    )
    write_csv(
        OUT_TEXTASSETS,
        text_rows,
        ["category", "bundle", "path_id", "name", "size", "looks_text", "output"],
    )
    write_csv(
        OUT_IMAGES,
        image_rows,
        ["category", "bundle", "path_id", "type", "name", "width", "height", "output", "error"],
    )
    write_csv(
        OUT_XLUA_TARGETS,
        xlua_targets,
        ["category", "bundle", "path_id", "name", "size", "looks_text", "output"],
    )

    category_counts: dict[str, int] = {}
    for row in asset_rows:
        category_counts[str(row["category"])] = category_counts.get(str(row["category"]), 0) + 1
    text_category_counts: dict[str, int] = {}
    for row in text_rows:
        text_category_counts[str(row["category"])] = text_category_counts.get(str(row["category"]), 0) + 1
    image_category_counts: dict[str, int] = {}
    for row in image_rows:
        image_category_counts[str(row["category"])] = image_category_counts.get(str(row["category"]), 0) + 1

    top_textassets = sorted(text_rows, key=lambda r: int_value(str(r["size"])), reverse=True)[:20]
    battle_maps = [r for r in asset_rows if r["category"] in {"battlemap_sprite_art", "battlemap_prefab_scene"}]
    actors = [r for r in asset_rows if r["category"] == "spine_battle_actor"]

    summary = {
        "assetbundle_candidates": len(asset_rows),
        "textasset_candidates": len(text_rows),
        "image_candidates": len(image_rows),
        "xlua_decode_targets": len(xlua_targets),
        "assetbundle_category_counts": category_counts,
        "textasset_category_counts": text_category_counts,
        "image_category_counts": image_category_counts,
        "outputs": {
            "assetbundles_csv": str(OUT_ASSETBUNDLES),
            "textassets_csv": str(OUT_TEXTASSETS),
            "images_csv": str(OUT_IMAGES),
            "xlua_targets_csv": str(OUT_XLUA_TARGETS),
            "plan_md": str(OUT_PLAN),
        },
    }
    OUT_SUMMARY.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    md: list[str] = [
        "# GirlsWar Battle Restore Plan",
        "",
        "## Scope",
        "",
        "- 작업 대상은 `C:\\Users\\godho\\Downloads\\girlswar` 아래 전투 구현/복원 산출물만이다.",
        "- `girlswar_maininterface_unity`, `reports\\maininterface`, MainInterface scene/builder는 수정하지 않는다.",
        "- 원본 evidence와 추출물은 삭제하지 않는다. 이 문서는 현재 확인된 전투 관련 evidence의 사용 지도를 만든다.",
        "",
        "## Fastest Starting Point",
        "",
        "1. `download/xlualogic/modules/battle.assetbundle`의 `HeroCtrl`, `BattleTeam`, `BattleUtil`, `HeroBattleInfo`를 raw bytes로 다시 추출하고 `SecurityUtil.xorScale`로 decode한다.",
        "2. `download/xlualogic/modules/procedure.assetbundle`의 `ProcedureNormalBattle`에서 전투 진입/종료/씬 전환 흐름을 확정한다.",
        "3. 평문 datatable `skillact.assetbundle`과 `monster.assetbundle`에서 스킬, 버프, 몬스터, hurt number schema를 모델링한다.",
        "4. `roleprefabsandres/battleprefabandres/*.assetbundle`의 Spine actor와 `artsources/map/battlemap/*` 배경 sprite를 조합해 battle 전용 Unity prototype을 만든다.",
        "",
        "## Current Evidence Counts",
        "",
        f"- Battle AssetBundle candidates: `{len(asset_rows)}`",
        f"- Battle TextAsset candidates: `{len(text_rows)}`",
        f"- Battle image candidates: `{len(image_rows)}`",
        f"- XLua decode targets: `{len(xlua_targets)}`",
        f"- Battle map bundles: `{len(battle_maps)}`",
        f"- Battle actor Spine bundles: `{len(actors)}`",
        "",
        "### AssetBundle Categories",
        "",
        "| Category | Count |",
        "|---|---:|",
    ]
    for category, count in sorted(category_counts.items()):
        md.append(f"| `{category}` | `{count}` |")
    md.extend(
        [
            "",
            "### Largest Battle TextAssets",
            "",
            "| Category | Bundle | Name | Size |",
            "|---|---|---|---:|",
        ]
    )
    for row in top_textassets:
        md.append(f"| `{row['category']}` | `{row['bundle']}` | `{row['name']}` | `{row['size']}` |")
    md.extend(
        [
            "",
            "## Core Original Files",
            "",
            "| Purpose | Original bundle/path | Notes |",
            "|---|---|---|",
            "| Battle runtime Lua | `download/xlualogic/modules/battle.assetbundle` | `HeroCtrl` is the largest core controller; encrypted XLua TextAsset. |",
            "| Battle procedure | `download/xlualogic/modules/procedure.assetbundle` | `ProcedureNormalBattle` links procedure state to battle scene lifecycle. |",
            "| Skill scripts | `download/xlualogic/modules/battleskillscript.assetbundle` | 1,728 TextAssets; decode after core flow. |",
            "| Buff scripts | `download/xlualogic/modules/battlebuffscript.assetbundle` | 2,540 TextAssets; decode/index after core flow. |",
            "| Battle data | `download/xlualogic/datanode/datatable/create/skillact.assetbundle` | Plain Lua-like tables for skills, buffs, hurt numbers, battle preview. |",
            "| Monster data | `download/xlualogic/datanode/datatable/create/monster.assetbundle` | Plain Lua-like tables for monster entities and attrs. |",
            "| Network proto | `download/xlualogic/datanode/proto/fight.assetbundle`, `formation.assetbundle`, `battleserver.assetbundle` | Protocol schema/handlers; mostly protobuf text/binary descriptors. |",
            "| Actor Spine | `download/roleprefabsandres/battleprefabandres/*.assetbundle` | Battle character/monster skeleton, atlas, material references. |",
            "| Battle maps | `download/artsources/map/battlemap/*`, `download/map/battlemap/*` | Sprite art and prefab/scene map roots. |",
            "| Battle UI sprites | `download/artsources/uispriteres/uibattle.assetbundle`, `uiheroheadbattle.assetbundle`, `uiskill_*` | HUD, head icons, skill icons. |",
            "",
            "## Implementation Units",
            "",
            "1. Data model: parse `DTSkillActEntity`, `DTBuffEntity`, `DTMonsterEntity`, fight/formation proto into JSON indexes for Unity editor import.",
            "2. Runtime shell: create `girlswar_battle_unity` with a 1680x720 battle scene, battle map layer stack, actor slots, HUD canvas, and deterministic test data.",
            "3. Spine import: reuse verified Spine 4.0 import path, but source from `battleprefabandres` instead of MainInterface painting prefabs.",
            "4. XLua bridge map: decode `BattleManager`, `HeroCtrl`, `BattleTeam`, `BattleUtil`, `ProcedureNormalBattle`, then document C#/IL2CPP calls used by Lua.",
            "5. Prototype battle loop: reproduce idle, attack, hurt, death, skill effect trigger, damage numbers, result transition with placeholder server data.",
            "6. Verification: capture desktop/mobile aspect screenshots, validate nonblank actor/map pixels, and log all battle entry/exit/pause/auto/skill buttons.",
            "",
            "## Unknowns To Close",
            "",
            "- Exact battle prefab roots under `download/map/battlemap/*` need structure.jsonl inspection before building the Unity scene.",
            "- `HeroCtrl` animation state names and event timeline must be pulled from decoded Lua plus Spine skeleton animation names.",
            "- Skill/buff script libraries are large; core flow should be decoded first, then scripts should be grouped by id and referenced prefab id.",
            "- Battle result UI may live in `winlose_ext_prefabs`, `jiesuan.assetbundle`, or mode-specific result modules; map after core `ProcedureNormalBattle` decode.",
            "",
            "## Generated Indexes",
            "",
            f"- AssetBundle candidates: `{OUT_ASSETBUNDLES}`",
            f"- TextAsset candidates: `{OUT_TEXTASSETS}`",
            f"- Image candidates: `{OUT_IMAGES}`",
            f"- XLua decode targets: `{OUT_XLUA_TARGETS}`",
            f"- Summary JSON: `{OUT_SUMMARY}`",
        ]
    )
    OUT_PLAN.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(json.dumps(summary, ensure_ascii=True, indent=2))


if __name__ == "__main__":
    main()
