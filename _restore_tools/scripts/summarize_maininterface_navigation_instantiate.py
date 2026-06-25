import csv
import json
from pathlib import Path


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY = ROOT / "girlswar_maininterface_unity"
RESTORE = UNITY / "Assets" / "RestoreData"
REPORTS = ROOT / "reports" / "maininterface"

RESULT_JSON = RESTORE / "maininterface_navigation_target_instantiate_result.json"
RESULT_CSV = RESTORE / "reports" / "maininterface_navigation_target_instantiate_result.csv"
CLICK_SUMMARY = RESTORE / "reports" / "maininterface_click_validation_summary.json"
LOAD_PROBE_JSON = RESTORE / "maininterface_navigation_target_load_probe.json"
REPORT_MD = REPORTS / "MAININTERFACE_NAVIGATION_TARGET_INSTANTIATE_PROTOTYPE_RESULT.md"
PROTOTYPE_SCENE = UNITY / "Assets" / "Scenes" / "MainInterface_NavigationPrototype.unity"
WIREFRAME_SCENE = UNITY / "Assets" / "Scenes" / "MainInterface_Wireframe.unity"
BUILD_LOG = UNITY / "logs" / "unity_maininterface_navigation_target_instantiate_build.log"
SMOKE_LOG = UNITY / "logs" / "unity_maininterface_navigation_target_instantiate_smoke.log"
CLICK_LOG = UNITY / "logs" / "unity_maininterface_button_navigation_click_validation.log"


def read_json(path: Path) -> dict:
    if not path.exists():
        return {}
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def file_info(path: Path) -> str:
    if not path.exists():
        return "missing"
    return f"{path} ({path.stat().st_size} bytes)"


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    result = read_json(RESULT_JSON)
    click = read_json(CLICK_SUMMARY)
    load_probe = read_json(LOAD_PROBE_JSON)
    rows = read_csv(RESULT_CSV)
    targets = result.get("targets", [])

    lines = [
        "# MainInterface Navigation Target Instantiate Prototype Result",
        "",
        f"Generated: {result.get('generatedAt', '')} KST",
        "",
        "## Verdict",
        "",
        "원본 handler/prefab evidence와 `maininterface_navigation_target_load_probe.json`에서 loadable로 확인된 target만 prototype scene에서 instantiate하도록 연결했다. runtime/unknown/log-only 버튼은 여전히 화면을 만들지 않고 로그만 남긴다.",
        "",
        "## Counts",
        "",
        "| Metric | Count |",
        "| --- | ---: |",
        f"| Active clickable buttons | `{result.get('activeClickableRows', '')}` |",
        f"| Target-prefab-resolved button rows | `{result.get('targetPrefabResolvedButtonRows', '')}` |",
        f"| Loadable unique targets from probe | `{load_probe.get('loadableUniqueTargets', result.get('loadableTargetCount', ''))}` |",
        f"| Instantiate success | `{result.get('successCount', '')}` |",
        f"| Instantiate fail | `{result.get('failCount', '')}` |",
        f"| Unknown/runtime/log-only rows | `{result.get('logOnlyOrUnknownButtonRows', '')}` |",
        "",
        "## Instantiate Smoke Test",
        "",
        "| Target key | UIForm | Root | Instantiated | Objects | Root children | Status | Reason |",
        "| --- | --- | --- | --- | ---: | ---: | --- | --- |",
    ]

    for target in targets:
        status = "success" if target.get("success") else "failed"
        lines.append(
            f"| `{target.get('targetKey', '')}` | `{target.get('targetUiForm', '')}` | "
            f"`{target.get('prefabRootName', '')}` | `{target.get('instantiatedName', '')}` | "
            f"`{target.get('instantiatedObjectCount', '')}` | `{target.get('targetRootChildCount', '')}` | "
            f"`{status}` | `{target.get('reason', '')}` |"
        )

    lines.extend(
        [
            "",
            "## Scene And Loader",
            "",
            f"- Prototype scene: `{PROTOTYPE_SCENE}`",
            f"- Source scene preserved: `{WIREFRAME_SCENE}`",
            "- Loader root: `NavigationTargetRoot` under the restored MainInterface Canvas",
            "- Loader behavior: one loadable target is shown at a time; previous target is cleared before the next target is instantiated",
            "- No debug overlay or synthetic page was added",
            "",
            "## Verification",
            "",
            "| Check | Result | Evidence |",
            "| --- | --- | --- |",
            f"| Prototype scene build | `{file_info(PROTOTYPE_SCENE)}` | `{BUILD_LOG}` |",
            f"| Instantiate smoke test JSON | `{file_info(RESULT_JSON)}` | `{SMOKE_LOG}` |",
            f"| Instantiate smoke test CSV | `{file_info(RESULT_CSV)}` | rows=`{len(rows)}` |",
            f"| Click validation generatedAt | `{click.get('generatedAt', '')}` | `{CLICK_SUMMARY}` |",
            f"| Active / clickable / blocked / invoked | `{click.get('activeButtons', '')}` / `{click.get('raycastClickableButtons', '')}` / `{click.get('raycastBlockedButtons', '')}` / `{click.get('invokedClicks', '')}` | `{CLICK_LOG}` |",
            "",
            "## Deferred Targets",
            "",
            "다음 target들은 원본 runtime activity id, event subscriber, 또는 target prefab evidence가 아직 부족해서 log-only로 유지했다:",
            "",
            "- runtime activity: `onBtnLimit`, `onBtnActJump`, `UI_MainPageActItem` activity buttons, `onBtnAddHoly`, `faceGiftNode`",
            "- local state: background arrows, activity banner description toggle, watch animation",
            "- unresolved event/unknown: `UI_bg`, `p_chat_private_head`, chat event target, `worldwanfaBtn` idle target",
            "",
            "## Generated Files",
            "",
            f"- `{RESULT_JSON}`",
            f"- `{RESULT_CSV}`",
            f"- `{REPORT_MD}`",
        ]
    )

    REPORT_MD.write_text("\n".join(lines), encoding="utf-8")
    print(f"wrote {REPORT_MD}")
    print(f"instantiateSuccess={result.get('successCount')} instantiateFail={result.get('failCount')}")


if __name__ == "__main__":
    main()
