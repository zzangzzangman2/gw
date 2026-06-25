import csv
import json
from pathlib import Path


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY = ROOT / "girlswar_maininterface_unity"
RESTORE = UNITY / "Assets" / "RestoreData"
REPORTS = ROOT / "reports" / "maininterface"

BEFORE_JSON = RESTORE / "maininterface_navigation_target_visual_capture_result.json"
AFTER_JSON = RESTORE / "maininterface_navigation_target_prefab_dependency_fixes.json"
AFTER_CSV = RESTORE / "reports" / "maininterface_navigation_target_prefab_dependency_fixes.csv"
CLICK_SUMMARY = RESTORE / "reports" / "maininterface_click_validation_summary.json"
REPORT_MD = REPORTS / "MAININTERFACE_NAVIGATION_TARGET_PREFAB_DEPENDENCY_FIXES_RESULT.md"
CAPTURE_LOG = UNITY / "logs" / "unity_maininterface_navigation_target_dependency_fixes_capture.log"
CLICK_LOG = UNITY / "logs" / "unity_maininterface_button_navigation_click_validation.log"
TOOL = ROOT / "_restore_tools" / "104_FIX_MAININTERFACE_NAVIGATION_TARGET_PREFAB_DEPENDENCIES.cmd"


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def intv(value) -> int:
    try:
        return int(value)
    except Exception:
        return 0


def file_info(path: Path) -> str:
    if not path.exists():
        return "missing"
    return f"{path} ({path.stat().st_size} bytes)"


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    before = read_json(BEFORE_JSON)
    after = read_json(AFTER_JSON)
    click = read_json(CLICK_SUMMARY)
    rows = read_csv(AFTER_CSV)

    before_by_root = {t.get("prefabRootName", ""): t for t in before.get("targets", [])}
    after_targets = after.get("targets", [])

    fixed_target_count = 0
    resolved_sprite_count = 0
    resolved_white_count = 0
    resolved_script_count = 0
    loaded_dependency_count = 0

    table_rows = []
    for target in after_targets:
        root = target.get("prefabRootName", "")
        old = before_by_root.get(root, {})
        sprite_delta = intv(old.get("missingImageSpriteCount")) - intv(target.get("missingImageSpriteCount"))
        white_delta = intv(old.get("whiteNoSpriteImageCount")) - intv(target.get("whiteNoSpriteImageCount"))
        script_delta = intv(old.get("missingScriptObjectCount")) - intv(target.get("missingScriptObjectCount"))
        if sprite_delta > 0 or white_delta > 0 or script_delta > 0:
            fixed_target_count += 1
        resolved_sprite_count += max(0, sprite_delta)
        resolved_white_count += max(0, white_delta)
        resolved_script_count += max(0, script_delta)
        loaded_dependency_count += intv(target.get("loadedDependencyBundleCount"))
        table_rows.append((target, old, sprite_delta, white_delta, script_delta))

    before_white = intv(before.get("whitePlaceholderSuspicionCount"))
    after_white = intv(after.get("whitePlaceholderSuspicionCount"))
    resolved_material_count = 0
    resolved_font_count = 0
    after["fixSummary"] = {
        "fixedTargetCount": fixed_target_count,
        "loadedDependencyBundleInstances": loaded_dependency_count,
        "resolvedMissingSpriteCount": resolved_sprite_count,
        "resolvedWhiteNoSpriteImageCount": resolved_white_count,
        "resolvedMaterialCount": resolved_material_count,
        "resolvedFontCount": resolved_font_count,
        "resolvedMissingScriptObjectCount": resolved_script_count,
        "beforeWhitePlaceholderSuspicionCount": before_white,
        "afterWhitePlaceholderSuspicionCount": after_white,
    }
    AFTER_JSON.write_text(json.dumps(after, ensure_ascii=False, indent=2), encoding="utf-8")
    recommendation = (
        "target dependency fixes deeper pass"
        if after_white > 0 or resolved_sprite_count == 0
        else "remaining 18 log-only target resolution"
    )

    lines = [
        "# MainInterface Navigation Target Prefab Dependency Fixes Result",
        "",
        f"Generated: {after.get('generatedAt', '')} KST",
        "",
        "## Verdict",
        "",
        "Prefab만 단독 로드하던 navigation target loader에 원본 clean UnityFS sibling dependency bundle preload를 추가했다. 이는 atlas를 통째로 화면에 얹는 방식이 아니라, 원본 prefab의 Image/Sprite/Material 참조가 AssetBundle dependency를 통해 해소되도록 하는 수정이다.",
        "",
        "## Counts",
        "",
        "| Metric | Count |",
        "| --- | ---: |",
        f"| Targets captured after fix | `{after.get('targetCount', '')}` |",
        f"| Fixed target count | `{fixed_target_count}` |",
        f"| Loaded dependency bundle instances | `{loaded_dependency_count}` |",
        f"| Resolved missing sprite count | `{resolved_sprite_count}` |",
        f"| Resolved white no-sprite Image count | `{resolved_white_count}` |",
        f"| Resolved material count | `{resolved_material_count}` |",
        f"| Resolved font count | `{resolved_font_count}` |",
        f"| Resolved missing script object count | `{resolved_script_count}` |",
        f"| Before white placeholder suspicion | `{before_white}` |",
        f"| After white placeholder suspicion | `{after_white}` |",
        f"| Blank suspicion after fix | `{after.get('blankSuspicionCount', '')}` |",
        "",
        "## Before / After By Target",
        "",
        "| Target | Dep bundles | Missing sprite before -> after | White no-sprite before -> after | Missing script before -> after | Visible px | Capture |",
        "| --- | ---: | ---: | ---: | ---: | ---: | --- |",
    ]

    for target, old, sprite_delta, white_delta, script_delta in table_rows:
        lines.append(
            f"| `{target.get('prefabRootName', '')}` | `{target.get('loadedDependencyBundleCount', '')}` | "
            f"`{old.get('missingImageSpriteCount', '')}` -> `{target.get('missingImageSpriteCount', '')}` | "
            f"`{old.get('whiteNoSpriteImageCount', '')}` -> `{target.get('whiteNoSpriteImageCount', '')}` | "
            f"`{old.get('missingScriptObjectCount', '')}` -> `{target.get('missingScriptObjectCount', '')}` | "
            f"`{target.get('visiblePixelCount', '')}` | `{target.get('capturePath', '')}` |"
        )

    lines.extend(
        [
            "",
            "## Evidence And Blockers",
            "",
            "- Dependency source: `girlswar_merged_extracted\\extracted\\unity\\clean_unityfs_slices\\download\\ui\\uiprefabandres`, because prior probe proved `merged_content`/`restore_overlay` headers fail while clean UnityFS loads correctly.",
            "- Dependency selection rule: for each target prefab bundle, load same-prefix sibling bundles such as `guild.assetbundle`, `guild_ext_1.assetbundle`, `guild_ext_2.assetbundle` before loading `guild_ext_prefabs.assetbundle`.",
            "- Remaining white/no-sprite counts mean the prefab references still depend on unavailable script-driven binding, inactive state initialization, or additional non-sibling resource bundles. These are not coordinate issues.",
            "- Missing script object counts are expected to remain until original MonoBehaviour type mapping or compatible script stubs are restored.",
            "",
            "## Verification",
            "",
            "| Check | Result | Evidence |",
            "| --- | --- | --- |",
            f"| After-fix JSON | `{file_info(AFTER_JSON)}` | `{CAPTURE_LOG}` |",
            f"| After-fix CSV | `{file_info(AFTER_CSV)}` | rows=`{len(rows)}` |",
            f"| Click validation generatedAt | `{click.get('generatedAt', '')}` | `{CLICK_SUMMARY}` |",
            f"| Active / clickable / blocked / invoked | `{click.get('activeButtons', '')}` / `{click.get('raycastClickableButtons', '')}` / `{click.get('raycastBlockedButtons', '')}` / `{click.get('invokedClicks', '')}` | `{CLICK_LOG}` |",
            f"| Tool | `{TOOL}` | no debug overlay or synthetic page |",
            "",
            "## Recommendation",
            "",
            f"Next: `{recommendation}`",
            "",
            "## Generated Files",
            "",
            f"- `{AFTER_JSON}`",
            f"- `{AFTER_CSV}`",
            f"- `{REPORT_MD}`",
        ]
    )

    REPORT_MD.write_text("\n".join(lines), encoding="utf-8")
    print(f"wrote {REPORT_MD}")
    print(
        f"fixedTargets={fixed_target_count} resolvedSprites={resolved_sprite_count} "
        f"beforeWhite={before_white} afterWhite={after_white}"
    )


if __name__ == "__main__":
    main()
