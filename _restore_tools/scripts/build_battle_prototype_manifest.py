from __future__ import annotations

import csv
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
INDEX_DIR = MERGED / "indexes"
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DIR = BASE / "girlswar_battle_unity"

TEXTASSETS_CSV = INDEX_DIR / "unity_textassets.csv"
ASSETBUNDLES_CSV = INDEX_DIR / "assetbundles.csv"

PROCEDURE_FILE = (
    MERGED
    / "decoded"
    / "xlua_battle"
    / "download_xlualogic_modules_procedure"
    / "-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua"
)
BATTLE_RES_PRELOAD_FILE = (
    MERGED
    / "decoded"
    / "xlua_battle"
    / "download_xlualogic_modules_battle"
    / "4144069477662196776_BattleResPreloadMgr_security_xor_raw.lua"
)
BATTLE_TIMELINE_RES_MAP_FILE = (
    MERGED
    / "decoded"
    / "xlua_battle"
    / "download_xlualogic_modules_battle"
    / "7799402437590767611_BattleTimelineResMap_security_xor_raw.lua"
)
HERO_CTRL_FILE = (
    MERGED
    / "decoded"
    / "xlua_battle"
    / "download_xlualogic_modules_battle"
    / "-2133702496468653963_HeroCtrl_security_xor_raw.lua"
)

OUT_PAYLOAD_JSON = REPORT_DIR / "BATTLE_TEST_PAYLOAD.json"
OUT_PAYLOAD_MD = REPORT_DIR / "BATTLE_TEST_PAYLOAD_SUMMARY.md"
OUT_MANIFEST_JSON = REPORT_DIR / "BATTLE_PROTOTYPE_MANIFEST.json"
OUT_BUILD_PLAN = REPORT_DIR / "BATTLE_PROTOTYPE_BUILD_PLAN.md"
OUT_ACTORS_CSV = REPORT_DIR / "BATTLE_PROTOTYPE_ACTORS.csv"
OUT_SKILLS_CSV = REPORT_DIR / "BATTLE_PROTOTYPE_SKILLS.csv"
OUT_BUNDLES_CSV = REPORT_DIR / "BATTLE_PROTOTYPE_BUNDLES.csv"
OUT_TRACE_CSV = REPORT_DIR / "BATTLE_RESOURCE_TRACE.csv"


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


def norm(text: str | Path) -> str:
    return str(text).replace("\\", "/").lower()


def rel(path: Path) -> str:
    try:
        return str(path.relative_to(BASE)).replace("\\", "/")
    except ValueError:
        return str(path).replace("\\", "/")


def line_no_for(text: str, needle: str) -> int | None:
    idx = text.find(needle)
    if idx < 0:
        return None
    return text.count("\n", 0, idx) + 1


def load_textasset_map() -> dict[str, dict[str, str]]:
    rows = read_csv(TEXTASSETS_CSV)
    by_name: dict[str, dict[str, str]] = {}
    for row in rows:
        by_name[row.get("name", "")] = row
    return by_name


def textasset_path(row: dict[str, str]) -> Path:
    return MERGED / row["output"]


def extract_entity_fields(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8", errors="replace")
    m = re.search(r"local\s+\w+\s*=\s*\{(.*?)\}\s*\n\w+\.__index", text, re.S)
    if not m:
        raise ValueError(f"Could not parse entity fields from {path}")
    body = m.group(1)
    fields: list[str] = []
    depth = 0
    in_str = False
    escape = False
    start = 0
    parts: list[str] = []
    for i, ch in enumerate(body):
        if in_str:
            if escape:
                escape = False
            elif ch == "\\":
                escape = True
            elif ch == '"':
                in_str = False
            continue
        if ch == '"':
            in_str = True
        elif ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
        elif ch == "," and depth == 0:
            parts.append(body[start:i])
            start = i + 1
    parts.append(body[start:])
    for part in parts:
        name = part.split("=", 1)[0].strip()
        if name:
            fields.append(name)
    return fields


class LuaArrayParser:
    def __init__(self, text: str):
        self.text = text
        self.i = 0

    def skip_ws(self) -> None:
        n = len(self.text)
        while self.i < n and self.text[self.i].isspace():
            self.i += 1

    def parse(self) -> Any:
        self.skip_ws()
        return self.parse_value()

    def parse_value(self) -> Any:
        self.skip_ws()
        if self.i >= len(self.text):
            raise ValueError("Unexpected end of Lua table")
        ch = self.text[self.i]
        if ch == "{":
            return self.parse_table()
        if ch == '"':
            return self.parse_string()
        if ch == "-" or ch.isdigit():
            return self.parse_number()
        return self.parse_ident()

    def parse_table(self) -> list[Any]:
        out: list[Any] = []
        self.i += 1
        while True:
            self.skip_ws()
            if self.i >= len(self.text):
                raise ValueError("Unclosed Lua table")
            if self.text[self.i] == "}":
                self.i += 1
                return out
            out.append(self.parse_value())
            self.skip_ws()
            if self.i < len(self.text) and self.text[self.i] == ",":
                self.i += 1

    def parse_string(self) -> str:
        self.i += 1
        out: list[str] = []
        escape = False
        while self.i < len(self.text):
            ch = self.text[self.i]
            self.i += 1
            if escape:
                if ch == "n":
                    out.append("\n")
                elif ch == "t":
                    out.append("\t")
                else:
                    out.append(ch)
                escape = False
            elif ch == "\\":
                escape = True
            elif ch == '"':
                return "".join(out)
            else:
                out.append(ch)
        raise ValueError("Unclosed Lua string")

    def parse_number(self) -> int | float:
        start = self.i
        if self.text[self.i] == "-":
            self.i += 1
        while self.i < len(self.text) and self.text[self.i].isdigit():
            self.i += 1
        if self.i < len(self.text) and self.text[self.i] == ".":
            self.i += 1
            while self.i < len(self.text) and self.text[self.i].isdigit():
                self.i += 1
            return float(self.text[start:self.i])
        return int(self.text[start:self.i])

    def parse_ident(self) -> Any:
        start = self.i
        while self.i < len(self.text) and re.match(r"[A-Za-z_]", self.text[self.i]):
            self.i += 1
        ident = self.text[start:self.i]
        if ident == "nil":
            return None
        if ident == "true":
            return True
        if ident == "false":
            return False
        if ident:
            return ident
        raise ValueError(f"Unexpected char {self.text[self.i]!r} at {self.i}")


def extract_byidx_rows(path: Path) -> list[list[Any]]:
    text = path.read_text(encoding="utf-8", errors="replace")
    marker = "ByIdx="
    idx = text.find(marker)
    if idx < 0:
        raise ValueError(f"No ByIdx table in {path}")
    start = text.find("{", idx + len(marker))
    if start < 0:
        raise ValueError(f"No ByIdx opening brace in {path}")
    depth = 0
    in_str = False
    escape = False
    end = None
    for i in range(start, len(text)):
        ch = text[i]
        if in_str:
            if escape:
                escape = False
            elif ch == "\\":
                escape = True
            elif ch == '"':
                in_str = False
            continue
        if ch == '"':
            in_str = True
        elif ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                end = i + 1
                break
    if end is None:
        raise ValueError(f"Unclosed ByIdx table in {path}")
    parsed = LuaArrayParser(text[start:end]).parse()
    return parsed


@dataclass
class TableData:
    name: str
    entity_path: Path
    table_path: Path
    fields: list[str]
    rows: dict[int, dict[str, Any]]


def load_table(logical_name: str, entity_name: str, table_name: str, textassets: dict[str, dict[str, str]]) -> TableData:
    entity_row = textassets[entity_name]
    table_row = textassets[table_name]
    entity_path = textasset_path(entity_row)
    table_path = textasset_path(table_row)
    fields = extract_entity_fields(entity_path)
    raw_rows = extract_byidx_rows(table_path)
    rows: dict[int, dict[str, Any]] = {}
    for raw in raw_rows:
        if not raw:
            continue
        row = {field: raw[i] if i < len(raw) else None for i, field in enumerate(fields)}
        row["_row_len"] = len(raw)
        try:
            rows[int(raw[0])] = row
        except (TypeError, ValueError):
            pass
    return TableData(logical_name, entity_path, table_path, fields, rows)


def extract_test_payload() -> tuple[dict[str, Any], dict[str, Any]]:
    text = PROCEDURE_FILE.read_text(encoding="utf-8", errors="replace")
    func_idx = text.find("function t.BeginBattleWithServer_FightPlay()")
    if func_idx < 0:
        raise ValueError("BeginBattleWithServer_FightPlay not found")
    local_idx = text.find("local t='", func_idx)
    if local_idx < 0:
        raise ValueError("Embedded payload local string not found")
    start = local_idx + len("local t='")
    end = text.find("'\n", start)
    if end < 0:
        raise ValueError("Embedded payload string terminator not found")
    payload_raw = text[start:end]
    payload = json.loads(payload_raw)
    info = payload.get("battleInfo", payload)
    evidence = {
        "procedure_file": rel(PROCEDURE_FILE),
        "function_line": line_no_for(text, "function t.BeginBattleWithServer_FightPlay()"),
        "payload_line": line_no_for(text, "local t='"),
        "decode_line": line_no_for(text, "e.FightPlayData=JsonUtil.decode(t).battleInfo"),
    }
    return info, evidence


def unique_nonzero(values: list[Any]) -> list[int]:
    out = sorted({int(v) for v in values if isinstance(v, (int, float)) and int(v) != 0})
    return out


def collect_payload_summary(info: dict[str, Any]) -> dict[str, Any]:
    our = info.get("ourHeros", [])
    waves = info.get("waveData", [])
    enemy_from_waves: list[dict[str, Any]] = []
    for wave in waves:
        enemy_from_waves.extend(wave.get("enemyHeros", []))
    skills: list[int] = []
    for hero in our + enemy_from_waves:
        for skill in hero.get("skills", []):
            did = skill.get("skillDid")
            if did:
                skills.append(did)
    wave_enemy_dids: list[int] = []
    wave_formations: list[dict[str, Any]] = []
    for wave in waves:
        f = wave.get("enemyTeamFormation", [])
        wave_formations.append(
            {
                "waveNo": wave.get("waveNo"),
                "enemyHeroDids": [x.get("heroDid") for x in f],
                "positions": [{"heroDid": x.get("heroDid"), "heroId": x.get("heroId"), "position": x.get("position")} for x in f],
                "bigRoundCount": len(wave.get("bigRoundData", [])),
            }
        )
        for x in f:
            if x.get("heroDid"):
                wave_enemy_dids.append(x["heroDid"])
    return {
        "mapId": info.get("mapId"),
        "battleType": info.get("battleType"),
        "randomSeed": info.get("randomSeed"),
        "fightResult": info.get("fightResult"),
        "ourHeroDids": [x.get("heroDid") for x in our],
        "ourHeroIds": [x.get("heroId") for x in our],
        "enemyHeroDids": unique_nonzero([x.get("heroDid") for x in enemy_from_waves] + wave_enemy_dids),
        "skillDids": unique_nonzero(skills),
        "ourTeamFormation": info.get("ourTeamFormation", []),
        "waveCount": len(waves),
        "waves": wave_formations,
        "petLikeFieldsPresent": sorted({k for h in our + enemy_from_waves for k in h.keys() if "pet" in k.lower()}),
    }


def load_asset_bundle_index() -> tuple[set[str], dict[str, dict[str, str]]]:
    rows = read_csv(ASSETBUNDLES_CSV)
    by_bundle: dict[str, dict[str, str]] = {}
    for row in rows:
        b = norm(row.get("bundle", ""))
        if b:
            by_bundle[b] = row
    return set(by_bundle), by_bundle


def bundle_exists(bundle: str, bundle_set: set[str]) -> bool:
    return norm(bundle) in bundle_set


def actor_bundle(prefab_id: Any) -> str | None:
    if not prefab_id:
        return None
    return f"download/roleprefabsandres/battleprefabandres/{int(prefab_id)}.assetbundle"


def skill_bundle_from_asset_path(asset_path: str) -> str | None:
    p = asset_path.replace("\\", "/")
    m = re.search(r"Assets/Download/SkillPrefabsAndRes/([^/]+)/", p, re.I)
    if m:
        return f"download/skillprefabsandres/{m.group(1).lower()}.assetbundle"
    m = re.search(r"Assets/Download/CommonPrefabsAndRes/(.+?)/[^/]+$", p, re.I)
    if m:
        return "download/commonprefabsandres/" + m.group(1).lower() + ".assetbundle"
    return None


def map_bundles_for(map_id: int, bundle_set: set[str]) -> list[dict[str, Any]]:
    token = f"map_{map_id}".lower()
    exact_prefab = f"download/map/battlemap/{map_id}.assetbundle"
    out: list[str] = []
    for bundle in sorted(bundle_set):
        if token in bundle and ("download/artsources/map/battlemap/" in bundle or "download/map/battlemap/" in bundle):
            out.append(bundle)
    if exact_prefab in bundle_set and exact_prefab not in out:
        out.append(exact_prefab)
    return [{"bundle": b, "exists": True, "source": "bundle_index"} for b in out]


def scan_timeline_entries() -> tuple[dict[int, list[dict[str, Any]]], dict[str, dict[str, Any]]]:
    text = BATTLE_TIMELINE_RES_MAP_FILE.read_text(encoding="utf-8", errors="replace")
    by_prefab: dict[int, list[dict[str, Any]]] = {}
    by_path: dict[str, dict[str, Any]] = {}
    i = 0
    while True:
        key_start = text.find('["', i)
        if key_start < 0:
            break
        key_end = text.find('"]=', key_start)
        if key_end < 0:
            break
        key = text[key_start + 2 : key_end]
        value_start = text.find("{", key_end)
        if value_start < 0:
            break
        depth = 0
        in_str = False
        escape = False
        value_end = None
        for j in range(value_start, len(text)):
            ch = text[j]
            if in_str:
                if escape:
                    escape = False
                elif ch == "\\":
                    escape = True
                elif ch == '"':
                    in_str = False
                continue
            if ch == '"':
                in_str = True
            elif ch == "{":
                depth += 1
            elif ch == "}":
                depth -= 1
                if depth == 0:
                    value_end = j + 1
                    break
        if value_end is None:
            break
        value = text[value_start:value_end]
        entry = {
            "assetPath": key,
            "line": text.count("\n", 0, key_start) + 1,
            "audio": extract_timeline_string_array(value, "audio"),
            "video": extract_timeline_string_array(value, "video"),
            "prefab": extract_timeline_string_array(value, "prefab"),
        }
        by_path[key] = entry
        m = re.search(r"/(\d+)\.prefab$", key)
        if m:
            by_prefab.setdefault(int(m.group(1)), []).append(entry)
        i = value_end
    return by_prefab, by_path


def extract_timeline_string_array(block: str, key: str) -> list[str]:
    m = re.search(r'\["' + re.escape(key) + r'"\]\s*=\s*\{', block)
    if not m:
        return []
    start = m.end() - 1
    depth = 0
    in_str = False
    escape = False
    end = None
    for i in range(start, len(block)):
        ch = block[i]
        if in_str:
            if escape:
                escape = False
            elif ch == "\\":
                escape = True
            elif ch == '"':
                in_str = False
            continue
        if ch == '"':
            in_str = True
        elif ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                end = i + 1
                break
    if end is None:
        return []
    arr = LuaArrayParser(block[start:end]).parse()
    return [x for x in arr if isinstance(x, str)]


def find_line_evidence(path: Path, needles: list[str]) -> list[dict[str, Any]]:
    text = path.read_text(encoding="utf-8", errors="replace")
    rows = []
    for needle in needles:
        line = line_no_for(text, needle)
        rows.append({"file": rel(path), "line": line, "needle": needle})
    return rows


def as_int(value: Any) -> int | None:
    try:
        if value is None or value == "":
            return None
        return int(value)
    except (TypeError, ValueError):
        return None


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    UNITY_DIR.mkdir(parents=True, exist_ok=True)

    info, payload_evidence = extract_test_payload()
    write_json(OUT_PAYLOAD_JSON, {"battleInfo": info})
    summary = collect_payload_summary(info)

    textassets = load_textasset_map()
    tables = {
        "hero": load_table("hero", "DTHeroEntity", "DTHeroEntityTableData", textassets),
        "model": load_table("model", "DTmodelEntity", "DTmodelEntityTableData", textassets),
        "monster": load_table("monster", "DTMonsterEntity", "DTMonsterEntityTableData", textassets),
        "skillact": load_table("skillact", "DTSkillActEntity", "DTSkillActEntityTableData", textassets),
        "maps": load_table("maps", "DTMapsEntity", "DTMapsEntityTableData", textassets),
        "mapswave": load_table("mapswave", "DTMapsWaveEntity", "DTMapsWaveEntityTableData", textassets),
    }

    bundle_set, bundle_rows = load_asset_bundle_index()
    timeline_by_prefab, _timeline_by_path = scan_timeline_entries()

    actor_rows: list[dict[str, Any]] = []
    skill_rows: list[dict[str, Any]] = []
    bundle_rows_out: list[dict[str, Any]] = []
    trace_rows: list[dict[str, Any]] = []
    missing_ids: dict[str, list[int]] = {"hero": [], "monster": [], "model": [], "skillact": [], "timelinePrefab": []}
    joins = {
        "hero": {"ok": 0, "missing": 0},
        "monster": {"ok": 0, "missing": 0},
        "model": {"ok": 0, "missing": 0},
        "skillact": {"ok": 0, "missing": 0},
        "timelinePrefab": {"ok": 0, "missing": 0},
    }

    def add_bundle(kind: str, bundle: str | None, ref: str, source: str) -> None:
        if not bundle:
            return
        exists = bundle_exists(bundle, bundle_set)
        bundle_rows_out.append({"kind": kind, "bundle": bundle, "exists": exists, "referenced_by": ref, "source": source})

    def add_actor(side: str, hero: dict[str, Any], wave_no: Any = "") -> None:
        hero_did = as_int(hero.get("heroDid"))
        hero_id = hero.get("heroId")
        if hero_did is None:
            return
        is_monster = side == "enemy"
        source_row = None
        model_id = None
        join_kind = "monster" if is_monster else "hero"
        if is_monster:
            source_row = tables["monster"].rows.get(hero_did)
            if source_row:
                joins["monster"]["ok"] += 1
                model_id = as_int(source_row.get("modelID"))
            else:
                joins["monster"]["missing"] += 1
                missing_ids["monster"].append(hero_did)
        else:
            source_row = tables["hero"].rows.get(hero_did)
            if source_row:
                joins["hero"]["ok"] += 1
                model_id = as_int(source_row.get("modelID"))
            else:
                joins["hero"]["missing"] += 1
                missing_ids["hero"].append(hero_did)
        model_row = tables["model"].rows.get(model_id or -1)
        if model_row:
            joins["model"]["ok"] += 1
        else:
            joins["model"]["missing"] += 1
            if model_id is not None:
                missing_ids["model"].append(model_id)
        prefab_id = as_int(model_row.get("prefabId")) if model_row else None
        pet_prefab_id = as_int(model_row.get("petPainting")) if model_row else None
        halo_prefab_id = as_int(model_row.get("haloPrefabId")) if model_row else None
        bundle = actor_bundle(prefab_id)
        add_bundle("actor_spine", bundle, f"{side}:{hero_did}", "HeroCtrl->DTmodel.prefabId")
        actor_rows.append(
            {
                "side": side,
                "waveNo": wave_no,
                "payloadHeroDid": hero_did,
                "payloadHeroId": hero_id,
                "datatable": join_kind,
                "datatableFound": bool(source_row),
                "modelId": model_id,
                "modelFound": bool(model_row),
                "prefabId": prefab_id,
                "petPrefabId": pet_prefab_id,
                "haloPrefabId": halo_prefab_id,
                "actorBundle": bundle or "",
                "actorBundleExists": bundle_exists(bundle, bundle_set) if bundle else False,
                "skillDidList": ",".join(str(s.get("skillDid")) for s in hero.get("skills", []) if s.get("skillDid")),
            }
        )
        for skill in hero.get("skills", []):
            skill_id = as_int(skill.get("skillDid"))
            if skill_id:
                add_skill(side, hero_did, hero_id, skill.get("skillType"), skill_id)

    def add_skill(side: str, hero_did: int, hero_id: Any, skill_type: Any, skill_id: int) -> None:
        skill_row = tables["skillact"].rows.get(skill_id)
        if skill_row:
            joins["skillact"]["ok"] += 1
        else:
            joins["skillact"]["missing"] += 1
            missing_ids["skillact"].append(skill_id)
        prefab_ids = []
        for key in ["prefabId", "fastPrefabId", "prefabId2", "fastPrefabId2"]:
            v = as_int(skill_row.get(key)) if skill_row else None
            if v:
                prefab_ids.append((key, v))
        if not prefab_ids:
            skill_rows.append(
                {
                    "side": side,
                    "ownerHeroDid": hero_did,
                    "ownerHeroId": hero_id,
                    "skillType": skill_type,
                    "skillDid": skill_id,
                    "skillFound": bool(skill_row),
                    "skillHeroId": skill_row.get("heroId") if skill_row else "",
                    "scriptId": skill_row.get("scriptId") if skill_row else "",
                    "prefabField": "",
                    "prefabId": "",
                    "timelineFound": False,
                    "timelineAssetPath": "",
                    "timelineLine": "",
                    "skillBundle": "",
                    "skillBundleExists": False,
                    "prefabDeps": "",
                    "audioDeps": "",
                    "videoDeps": "",
                }
            )
            return
        for prefab_field, prefab_id in prefab_ids:
            entries = timeline_by_prefab.get(prefab_id, [])
            if entries:
                joins["timelinePrefab"]["ok"] += 1
            else:
                joins["timelinePrefab"]["missing"] += 1
                missing_ids["timelinePrefab"].append(prefab_id)
            for entry in entries or [{"assetPath": "", "line": "", "prefab": [], "audio": [], "video": []}]:
                skill_bundle = skill_bundle_from_asset_path(entry.get("assetPath", ""))
                add_bundle("skill_prefab", skill_bundle, f"skill:{skill_id}:{prefab_field}:{prefab_id}", "BattleResPreloadMgr->BattleTimelineResMap")
                for dep in entry.get("prefab", []):
                    add_bundle("timeline_prefab_dep", skill_bundle_from_asset_path(dep), f"timeline:{prefab_id}", "BattleTimelineResMap.prefab")
                skill_rows.append(
                    {
                        "side": side,
                        "ownerHeroDid": hero_did,
                        "ownerHeroId": hero_id,
                        "skillType": skill_type,
                        "skillDid": skill_id,
                        "skillFound": bool(skill_row),
                        "skillHeroId": skill_row.get("heroId") if skill_row else "",
                        "scriptId": skill_row.get("scriptId") if skill_row else "",
                        "prefabField": prefab_field,
                        "prefabId": prefab_id,
                        "timelineFound": bool(entries),
                        "timelineAssetPath": entry.get("assetPath", ""),
                        "timelineLine": entry.get("line", ""),
                        "skillBundle": skill_bundle or "",
                        "skillBundleExists": bundle_exists(skill_bundle, bundle_set) if skill_bundle else False,
                        "prefabDeps": "|".join(entry.get("prefab", [])),
                        "audioDeps": "|".join(entry.get("audio", [])),
                        "videoDeps": "|".join(entry.get("video", [])),
                    }
                )

    for hero in info.get("ourHeros", []):
        add_actor("our", hero)
    for wave in info.get("waveData", []):
        for hero in wave.get("enemyHeros", []):
            add_actor("enemy", hero, wave.get("waveNo"))

    map_id = as_int(info.get("mapId"))
    map_row = tables["maps"].rows.get(map_id or -1)
    map_join = {"ok": 1 if map_row else 0, "missing": 0 if map_row else 1}
    if map_id is not None and not map_row:
        missing_ids.setdefault("maps", []).append(map_id)
    if map_id is not None:
        for row in map_bundles_for(map_id, bundle_set):
            bundle_rows_out.append({"kind": "battle_map", "bundle": row["bundle"], "exists": row["exists"], "referenced_by": f"mapId:{map_id}", "source": "mapId bundle search"})

    trace_rows.extend(find_line_evidence(PROCEDURE_FILE, ["function t.BeginBattleWithServer_FightPlay()", "JsonUtil.decode(t).battleInfo", "function t.PlayFightClientBattle"]))
    trace_rows.extend(find_line_evidence(HERO_CTRL_FILE, ["DTmodelRow=n.GetEntity(o)", "self.PrefabId=self.DTmodelRow.prefabId", "self.DTMonsterRow=t.GetEntity(self.heroDid)", "self.DTHeroRow=s.GetEntity(self.heroDid)", "CS.Spine.Unity.SkeletonAnimation"]))
    trace_rows.extend(find_line_evidence(BATTLE_RES_PRELOAD_FILE, ["function t.GetHeroSkillIds", "LuaUtils.GetSysprefabData", "BattleTimelineResMap[t.AssetPath]", "PlaySkillPrefabAndRemoveAsyncPreload"]))
    trace_rows.extend(find_line_evidence(BATTLE_TIMELINE_RES_MAP_FILE, ['["Assets/Download/SkillPrefabsAndRes/1002/1002101.prefab"]', '["prefab"]=', '["audio"]=', '["video"]=']))

    # Deduplicate bundles while preserving the most useful reference string.
    dedup: dict[tuple[str, str, str], dict[str, Any]] = {}
    for row in bundle_rows_out:
        key = (row["kind"], norm(row["bundle"]), row["source"])
        if key not in dedup:
            dedup[key] = row
        else:
            dedup[key]["referenced_by"] = str(dedup[key]["referenced_by"]) + ";" + str(row["referenced_by"])
    bundle_rows_out = sorted(dedup.values(), key=lambda r: (str(r["kind"]), str(r["bundle"])))

    verification = {
        "payload": {
            "source": payload_evidence,
            "mapId": summary["mapId"],
            "battleType": summary["battleType"],
            "randomSeed": summary["randomSeed"],
            "ourHeroCount": len(summary["ourHeroDids"]),
            "enemyUniqueHeroDidCount": len(summary["enemyHeroDids"]),
            "skillUniqueCount": len(summary["skillDids"]),
            "waveCount": summary["waveCount"],
        },
        "joins": {**joins, "maps": map_join},
        "bundleReferences": {
            "total": len(bundle_rows_out),
            "existing": sum(1 for r in bundle_rows_out if r["exists"]),
            "missing": sum(1 for r in bundle_rows_out if not r["exists"]),
        },
        "datatableSources": {
            name: {
                "entity": rel(table.entity_path),
                "tableData": rel(table.table_path),
                "fields": len(table.fields),
                "rows": len(table.rows),
            }
            for name, table in tables.items()
        },
        "missingIds": {k: sorted(set(v)) for k, v in missing_ids.items() if v},
    }

    manifest = {
        "name": "GirlsWar battle prototype manifest",
        "generatedBy": rel(Path(__file__)),
        "workspace": str(BASE),
        "payloadPath": rel(OUT_PAYLOAD_JSON),
        "summary": summary,
        "map": {
            "mapId": map_id,
            "datatableFound": bool(map_row),
            "mapName": map_row.get("mapName") if map_row else "",
            "mapFullName": map_row.get("mapFullName") if map_row else "",
            "prefabId": map_row.get("prefabId") if map_row else "",
            "bundles": [r for r in bundle_rows_out if r["kind"] == "battle_map"],
        },
        "actors": actor_rows,
        "skills": skill_rows,
        "bundles": bundle_rows_out,
        "traceEvidence": trace_rows,
        "verification": verification,
        "sourcePrinciples": {
            "evidencePreserved": True,
            "notes": [
                "No source or extracted evidence files are deleted by this tool.",
                "Prototype work is isolated from MainInterface outputs.",
                "Manifest references original bundle paths and extracted evidence paths separately.",
            ],
        },
    }

    write_csv(
        OUT_ACTORS_CSV,
        actor_rows,
        ["side", "waveNo", "payloadHeroDid", "payloadHeroId", "datatable", "datatableFound", "modelId", "modelFound", "prefabId", "petPrefabId", "haloPrefabId", "actorBundle", "actorBundleExists", "skillDidList"],
    )
    write_csv(
        OUT_SKILLS_CSV,
        skill_rows,
        ["side", "ownerHeroDid", "ownerHeroId", "skillType", "skillDid", "skillFound", "skillHeroId", "scriptId", "prefabField", "prefabId", "timelineFound", "timelineAssetPath", "timelineLine", "skillBundle", "skillBundleExists", "prefabDeps", "audioDeps", "videoDeps"],
    )
    write_csv(OUT_BUNDLES_CSV, bundle_rows_out, ["kind", "bundle", "exists", "referenced_by", "source"])
    write_csv(OUT_TRACE_CSV, trace_rows, ["file", "line", "needle"])
    write_json(OUT_MANIFEST_JSON, manifest)
    write_payload_md(summary, payload_evidence, verification)
    write_build_plan(manifest)
    write_unity_readme(manifest)

    print(f"Wrote {OUT_PAYLOAD_JSON}")
    print(f"Wrote {OUT_MANIFEST_JSON}")
    print(f"Wrote {OUT_BUILD_PLAN}")
    print("Verification:")
    print(json.dumps(verification, ensure_ascii=False, indent=2))


def write_payload_md(summary: dict[str, Any], evidence: dict[str, Any], verification: dict[str, Any]) -> None:
    lines = [
        "# Battle Test Payload Summary",
        "",
        "## Source Evidence",
        f"- Procedure Lua: `{evidence['procedure_file']}`",
        f"- Function line: `{evidence['function_line']}`",
        f"- Embedded JSON line: `{evidence['payload_line']}`",
        f"- Decode assignment line: `{evidence['decode_line']}`",
        "",
        "## Top-Level Values",
        f"- mapId: `{summary['mapId']}`",
        f"- battleType: `{summary['battleType']}`",
        f"- randomSeed: `{summary['randomSeed']}`",
        f"- fightResult: `{summary['fightResult']}`",
        f"- waveCount: `{summary['waveCount']}`",
        "",
        "## Our Formation",
        "| position | heroId | heroDid |",
        "|---:|---:|---:|",
    ]
    did_by_hero_id = {}
    for hero_did, hero_id in zip(summary["ourHeroDids"], summary["ourHeroIds"]):
        did_by_hero_id[hero_id] = hero_did
    for row in summary["ourTeamFormation"]:
        hero_id = row.get("heroId")
        lines.append(f"| {row.get('position')} | {hero_id} | {did_by_hero_id.get(hero_id, '')} |")
    lines.extend(["", "## Enemy Waves", "| wave | enemy heroDids | big rounds |", "|---:|---|---:|"])
    for wave in summary["waves"]:
        lines.append(f"| {wave['waveNo']} | `{', '.join(str(x) for x in wave['enemyHeroDids'])}` | {wave['bigRoundCount']} |")
    lines.extend(
        [
            "",
            "## Skills",
            f"- Unique payload skill ids: `{len(summary['skillDids'])}`",
            f"- Skill ids: `{', '.join(str(x) for x in summary['skillDids'])}`",
            "",
            "## Verification Snapshot",
            f"- Bundle references: `{verification['bundleReferences']['existing']}/{verification['bundleReferences']['total']}` exist in assetbundle index.",
            f"- Skill datatable joins: `{verification['joins']['skillact']['ok']}` ok, `{verification['joins']['skillact']['missing']}` missing.",
            f"- Timeline prefab joins: `{verification['joins']['timelinePrefab']['ok']}` ok, `{verification['joins']['timelinePrefab']['missing']}` missing.",
        ]
    )
    OUT_PAYLOAD_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_build_plan(manifest: dict[str, Any]) -> None:
    v = manifest["verification"]
    missing = v.get("missingIds", {})
    lines = [
        "# Battle Prototype Build Plan",
        "",
        "## Prototype Inputs Now Fixed",
        f"- Test payload: `{rel(OUT_PAYLOAD_JSON)}`",
        f"- Prototype manifest: `{rel(OUT_MANIFEST_JSON)}`",
        f"- Actors CSV: `{rel(OUT_ACTORS_CSV)}`",
        f"- Skills CSV: `{rel(OUT_SKILLS_CSV)}`",
        f"- Bundles CSV: `{rel(OUT_BUNDLES_CSV)}`",
        f"- Lua/resource trace CSV: `{rel(OUT_TRACE_CSV)}`",
        "",
        "## Minimum Original Files For First Prototype",
        "- `girl1.xapk` / original extraction root remains preserved for provenance.",
        "- `com.girlwars.kr` extraction and OBB/AssetBundle evidence remain preserved.",
        "- Datatable bundles: `download/xlualogic/datanode/datatable/create/hero.assetbundle`, `model.assetbundle`, `monster.assetbundle`, `skillact.assetbundle`, `maps.assetbundle`.",
        "- Decoded Lua evidence: `ProcedureNormalBattle`, `HeroCtrl`, `BattleResPreloadMgr`, `BattleTimelineResMap` decoded files listed in `BATTLE_RESOURCE_TRACE.csv`.",
        "",
        "## Resource Load Chain",
        "1. `ProcedureNormalBattle.BeginBattleWithServer_FightPlay` embeds the serverless JSON payload.",
        "2. `HeroCtrl` resolves payload `heroDid` through `DTHero` or `DTMonster`, then `DTmodel.modelID -> DTmodel.prefabId`.",
        "3. Actor Spine bundles resolve as `download/roleprefabsandres/battleprefabandres/{prefabId}.assetbundle`.",
        "4. `BattleResPreloadMgr.GetHeroSkillIds` resolves skill ids through `DTSkillAct.prefabId` and `LuaUtils.GetSysprefabData`.",
        "5. `BattleTimelineResMap[AssetPath]` expands each skill prefab to extra prefab/audio/video deps.",
        "",
        "## Verification",
        f"- Actor joins: hero `{v['joins']['hero']['ok']}` ok / `{v['joins']['hero']['missing']}` missing, monster `{v['joins']['monster']['ok']}` ok / `{v['joins']['monster']['missing']}` missing.",
        f"- Model joins: `{v['joins']['model']['ok']}` ok / `{v['joins']['model']['missing']}` missing.",
        f"- Skill joins: `{v['joins']['skillact']['ok']}` ok / `{v['joins']['skillact']['missing']}` missing.",
        f"- Timeline prefab joins: `{v['joins']['timelinePrefab']['ok']}` ok / `{v['joins']['timelinePrefab']['missing']}` missing.",
        f"- Bundle references existing: `{v['bundleReferences']['existing']}` / `{v['bundleReferences']['total']}`.",
        "",
        "## Missing Or Open Resource IDs",
    ]
    if missing:
        for kind, ids in missing.items():
            lines.append(f"- {kind}: `{', '.join(str(x) for x in ids)}`")
    else:
        lines.append("- None for the current payload/datatable/timeline join pass.")
    lines.extend(
        [
            "",
            "## Next Unity Prototype Command",
            "- Run `_restore_tools\\BATTLE_06_PREPARE_BATTLE_UNITY_PROTOTYPE_FOLDER.cmd` to refresh the battle-only Unity prototype folder scaffold from this manifest.",
            "- The first Unity scene should consume `reports/battle/BATTLE_PROTOTYPE_MANIFEST.json`, spawn placeholder lanes by formation, then replace placeholders with actor Spine prefabs when an importer is attached.",
            "",
            "## First Scene Implementation Units",
            "- `BattlePrototypeBootstrap`: load manifest JSON and payload JSON.",
            "- `BattleFormationView`: map six formation positions per side and wave selector.",
            "- `BattleActorView`: bind `heroDid`, `modelId`, `prefabId`, bundle path, and basic HP/MP values.",
            "- `BattleSkillPreviewQueue`: list skill timeline prefab paths and dependency availability.",
            "- `BattleEvidencePanel`: show source Lua line references and datatable join status.",
        ]
    )
    OUT_BUILD_PLAN.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_unity_readme(manifest: dict[str, Any]) -> None:
    readme = UNITY_DIR / "README_BATTLE_PROTOTYPE_START.md"
    lines = [
        "# GirlsWar Battle Prototype Start",
        "",
        "This folder is reserved for battle-only prototype work. It must not modify MainInterface restore outputs.",
        "",
        "Start data:",
        f"- Manifest: `{rel(OUT_MANIFEST_JSON)}`",
        f"- Payload: `{rel(OUT_PAYLOAD_JSON)}`",
        f"- Build plan: `{rel(OUT_BUILD_PLAN)}`",
        "",
        "Suggested first Unity pass:",
        "1. Create a battle-only Unity project or scene here.",
        "2. Copy or reference the manifest JSON under an `Assets/RestoreData/Battle` folder.",
        "3. Render map 11001 as a placeholder background until the map prefab importer is attached.",
        "4. Render our/enemy formations from payload and attach actor bundle paths from the manifest.",
        "5. Render skill dependency tables from `skills` and `bundles` in the manifest.",
        "",
        "Do not delete source XAPK, APK extraction, OBB, AssetBundle, decoded Lua, or datatable evidence.",
    ]
    readme.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
