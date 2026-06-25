from __future__ import annotations

import json
import re
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
DECODED = BASE / "girlswar_merged_extracted" / "decoded" / "xlua_battle"
REPORT_DIR = BASE / "reports" / "battle"
OUT_JSON = REPORT_DIR / "battle_decoded_flow_summary.json"
OUT_MD = REPORT_DIR / "BATTLE_DECODED_FLOW_ANALYSIS.md"


TARGET_FILE_PATTERNS = {
    "ProcedureNormalBattle": "*ProcedureNormalBattle*.lua",
    "BattleManager": "*BattleManager*.lua",
    "BattleTeam": "*BattleTeam*.lua",
    "HeroCtrl": "*HeroCtrl*.lua",
    "HeroBattleInfo": "*HeroBattleInfo*.lua",
    "BattleInputMgr": "*BattleInputMgr*.lua",
    "BattleUtil": "*BattleUtil*.lua",
    "fight_info": "*fight_info*.lua",
}

SECTION_RULES = {
    "ProcedureNormalBattle": [
        ("requires", re.compile(r"^\s*require")),
        ("event_listeners", re.compile(r"EventSystem\.AddListener|EventSystem\.RemoveListener")),
        ("entry_points", re.compile(r"function t\.(BeginFight|BeginBattle|ProcedureNormalBattle_|InitData|LoadPlayer|LoadEnemy|Enter|Leave|SetBattleTeam|StartBattle|OnEnter|OnLeave)")),
        ("map_and_wave", re.compile(r"MapId|CurrMapsWavesIndex|waveData|FightPlay_CurrWave|FightBefore_CurrWave")),
        ("ui_and_result", re.compile(r"OpenUIForm|CloseUIForm|FightOver|BattleResult|Win|Lose|JieSuan|jiesuan|result")),
        ("test_payload", re.compile(r"function t\.BeginBattleWithServer_FightPlay|local t='\{\"battleInfo\"")),
    ],
    "BattleTeam": [
        ("team_setup", re.compile(r"function BattleTeam:(New|Init|AddHero|GetHeroCtrl|SetTeam|Load|Reset)")),
        ("attack_pipeline", re.compile(r"function BattleTeam:(TeamFightAttack|TeamFightBeginAttack|TeamFightAttackCoroutine|TeamFightAttackCoroutine_After|OnTeamFightAttackComplete)")),
        ("skill_effect_bridge", re.compile(r"PlaySkillPrefab|CurrTimelineEffect|BattleSkillEffect|skillPrefab|SkillId|SkillDid")),
        ("death_and_hurt_checks", re.compile(r"CheckHurtValue|CheckHeroDie|isBattleEnd|CurrAttackCauseHeroDie")),
    ],
    "HeroCtrl": [
        ("data_sources", re.compile(r"DTmodel|DTMonster|DTSkill|DTBuff|HeroServerData|GetHeroServerData|PrefabId")),
        ("spine_setup", re.compile(r"SkeletonAnimation|spineboy|spinePet|SetSpine|RefreshSpine|GetSpine")),
        ("animation_state", re.compile(r"SetSpineAnimation|AddSpineAnimation|PlaySpineAnim|FindAnimation|stand|wait|run|death|disappear")),
        ("hurt_damage", re.compile(r"Hurt|hurt|HeroHurtType|CheckHp|AddFury|ReduceFury|damage|dmg")),
        ("effect_prefab", re.compile(r"PlayAutoReleaseEffect|prefabId|PrefabId|deathEffect|buffEffect|skillId")),
    ],
    "HeroBattleInfo": [
        ("skills", re.compile(r"SetHeroSkill|SetPetSkill|GetSkills|GetSkillWithType|SkillDid|skillDid|SkillMode")),
        ("buffs", re.compile(r"OnBattleHeroAddBuff|AddBuff|RemoveBuff|Buff|buff")),
        ("attrs", re.compile(r"HeroAttrId|attribute|Attr|skillInjure|Critical|Fury")),
    ],
    "BattleInputMgr": [
        ("input", re.compile(r"SetAuto|currentAuto|GenOneInput|SendEventDataRefreshed")),
    ],
    "BattleManager": [
        ("manager", re.compile(r"function|BattleManager|battle")),
    ],
    "BattleUtil": [
        ("utility", re.compile(r"function|Get|Set|BattleType|Formation|Skill")),
    ],
    "fight_info": [
        ("schema", re.compile(r"function|return|fight|hero|skill|wave|round|action")),
    ],
}


def find_one(pattern: str) -> Path | None:
    matches = sorted(DECODED.rglob(pattern))
    return matches[0] if matches else None


def trim(line: str, limit: int = 220) -> str:
    line = line.strip().replace("|", "\\|")
    if len(line) > limit:
        return line[: limit - 3] + "..."
    return line


def collect_matches(path: Path, rules: list[tuple[str, re.Pattern[str]]], max_per_section: int = 18) -> dict[str, list[dict[str, object]]]:
    buckets: dict[str, list[dict[str, object]]] = {name: [] for name, _ in rules}
    with path.open("r", encoding="utf-8", errors="replace") as f:
        for lineno, line in enumerate(f, start=1):
            for name, regex in rules:
                if len(buckets[name]) >= max_per_section:
                    continue
                if regex.search(line):
                    buckets[name].append({"line": lineno, "text": trim(line)})
    return buckets


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    files: dict[str, str] = {}
    summaries: dict[str, dict[str, list[dict[str, object]]]] = {}
    for label, pattern in TARGET_FILE_PATTERNS.items():
        path = find_one(pattern)
        if path is None:
            continue
        files[label] = str(path)
        summaries[label] = collect_matches(path, SECTION_RULES.get(label, []))

    output = {"files": files, "summaries": summaries}
    OUT_JSON.write_text(json.dumps(output, ensure_ascii=False, indent=2), encoding="utf-8")

    md: list[str] = [
        "# Battle Decoded Flow Analysis",
        "",
        "## Core Decoded Files",
        "",
        "| Role | File |",
        "|---|---|",
    ]
    for label, path in files.items():
        md.append(f"| `{label}` | `{path}` |")
    md.extend(
        [
            "",
            "## What The Flow Shows",
            "",
            "- `ProcedureNormalBattle` requires `BattleSkillEffectManager`, `BattleTeam`, `HeroCtrl`, `HeroBattleInfo`, and the skill/monster datatables directly. This is the top-level battle lifecycle module.",
            "- Entry data flows through `BeginFightPlayWithServer`, `InitDataWithFightPlayData`, and `InitDataWithFightBeforeData`, using `mapId`, `waveData`, our/enemy formations, hero lists, pets, random seed, and battle type.",
            "- Battle has an embedded test payload in `BeginBattleWithServer_FightPlay`; this is immediately useful as deterministic prototype data without needing a server.",
            "- `BattleTeam` owns the team attack pipeline: begin attack, choose skill, play skill prefab/timeline, check hurt values, check death, then complete callback.",
            "- `HeroCtrl` maps model/data rows to battle Spine objects, animation names, hurt/death/fury/effect playback, and prefab ids.",
            "- `HeroBattleInfo` maps server hero/monster skill arrays into `HeroSkillInfo` objects and applies buffs/attrs.",
            "- `BattleInputMgr` already separates manual/auto input, so the prototype should expose auto toggle even before full UI is restored.",
            "",
            "## Key Evidence Lines",
            "",
        ]
    )

    for label, sections in summaries.items():
        md.extend([f"### {label}", ""])
        for section, rows in sections.items():
            if not rows:
                continue
            md.extend([f"#### {section}", "", "| Line | Evidence |", "|---:|---|"])
            for row in rows:
                md.append(f"| `{row['line']}` | `{row['text']}` |")
            md.append("")

    md.extend(
        [
            "## Prototype-Oriented Restore Order",
            "",
            "1. Use the embedded `BeginBattleWithServer_FightPlay` payload as a first replay/test fixture, but store a shortened JSON copy separately before wiring Unity.",
            "2. Build a battle scene shell from `mapId` to `download/artsources/map/battlemap/map_<id>/...` and `download/map/battlemap/<id>.assetbundle`.",
            "3. Spawn `HeroCtrl`-compatible actor slots for our/enemy formations using battle Spine bundles from `roleprefabsandres/battleprefabandres/<prefabId>.assetbundle`.",
            "4. Implement the first visible loop as `stand/wait -> attack -> hurt number -> death/stand`, using original animation names from the skeletons.",
            "5. Add `BattleInputMgr` auto/manual state and pause/speed controls after the visual loop is stable.",
            "",
            "## Outputs",
            "",
            f"- JSON: `{OUT_JSON}`",
            f"- Markdown: `{OUT_MD}`",
        ]
    )
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")
    print(json.dumps({"files": files, "output": str(OUT_MD)}, ensure_ascii=True, indent=2))


if __name__ == "__main__":
    main()
