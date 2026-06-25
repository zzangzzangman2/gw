from __future__ import annotations

import argparse
import json
import os
import tarfile
from datetime import datetime
from pathlib import Path


def read_member_text(tar: tarfile.TarFile, name: str) -> str:
    member = tar.extractfile(name)
    if member is None:
        return ""
    return member.read().decode("utf-8", "replace").strip()


def write_member(tar: tarfile.TarFile, member_name: str, target_path: Path) -> bool:
    source = tar.extractfile(member_name)
    if source is None:
        return False
    target_path.parent.mkdir(parents=True, exist_ok=True)
    target_path.write_bytes(source.read())
    return True


def import_unitypackage(package_path: Path, project_root: Path) -> dict:
    package_path = package_path.resolve()
    project_root = project_root.resolve()
    if not package_path.exists():
        raise FileNotFoundError(package_path)
    if not (project_root / "Assets").exists():
        raise FileNotFoundError(project_root / "Assets")

    extracted_assets = []
    extracted_meta = []
    skipped = []

    with tarfile.open(package_path, "r:*") as tar:
        members_by_group: dict[str, set[str]] = {}
        for member in tar.getmembers():
            if "/" not in member.name:
                continue
            group, rest = member.name.split("/", 1)
            members_by_group.setdefault(group, set()).add(rest)

        for group in sorted(members_by_group):
            members = members_by_group[group]
            if "pathname" not in members:
                continue
            pathname = read_member_text(tar, f"{group}/pathname")
            if not pathname.startswith("Assets/TextMesh Pro/"):
                skipped.append(pathname)
                continue

            target = project_root / pathname
            if "asset" in members:
                if write_member(tar, f"{group}/asset", target):
                    extracted_assets.append(pathname)
            else:
                target.mkdir(parents=True, exist_ok=True)

            if "asset.meta" in members:
                if write_member(tar, f"{group}/asset.meta", Path(str(target) + ".meta")):
                    extracted_meta.append(pathname + ".meta")

    return {
        "package": str(package_path),
        "project": str(project_root),
        "extracted_asset_count": len(extracted_assets),
        "extracted_meta_count": len(extracted_meta),
        "skipped_count": len(skipped),
        "extracted_assets": extracted_assets,
        "extracted_meta": extracted_meta,
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    }


def write_report(summary: dict, report_path: Path) -> None:
    report_path.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "# MainInterface TMP Essential Resources Import",
        "",
        f"작성 시각: {summary['generated_at']}",
        "",
        "## 결과",
        "",
        f"- package: `{summary['package']}`",
        f"- project: `{summary['project']}`",
        f"- extracted assets: {summary['extracted_asset_count']}",
        f"- extracted meta: {summary['extracted_meta_count']}",
        "",
        "## 풀린 핵심 파일",
        "",
    ]
    important = [
        p
        for p in summary["extracted_assets"]
        if p.endswith("TMP Settings.asset")
        or "LiberationSans SDF" in p
        or p.endswith(".shader")
        or p.endswith(".cginc")
        or p.endswith(".hlsl")
    ]
    for path in important:
        lines.append(f"- `{path}`")
    lines.extend(
        [
            "",
            "## 의미",
            "",
            "Unity batch import가 TMP Essential Resources를 실제 `Assets/TextMesh Pro` 아래에 만들지 못한 상태였기 때문에, "
            "unitypackage를 직접 풀어서 TMP Settings, LiberationSans SDF, TMP shader를 프로젝트 자산으로 고정했다.",
            "",
            "다음 단계는 SceneBuilder를 다시 실행해 `GirlsWarRestore_KoreanFallback_TMP.asset` 생성과 "
            "`TextMeshProUGUI.m_fontAsset` 비어 있음 여부를 검증하는 것이다.",
            "",
        ]
    )
    report_path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--project", default=r"C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity")
    parser.add_argument(
        "--package",
        default=r"C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Library\PackageCache\com.unity.ugui@1f2d1ab0d950\Package Resources\TMP Essential Resources.unitypackage",
    )
    parser.add_argument(
        "--report",
        default=r"C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TMP_ESSENTIAL_RESOURCES_IMPORT.md",
    )
    args = parser.parse_args()

    summary = import_unitypackage(Path(args.package), Path(args.project))
    summary_path = Path(args.project) / "Assets" / "RestoreData" / "reports" / "tmp_essential_resources_import.json"
    summary_path.parent.mkdir(parents=True, exist_ok=True)
    summary_path.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(summary, Path(args.report))
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
