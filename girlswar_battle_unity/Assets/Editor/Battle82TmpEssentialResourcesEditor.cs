using System;
using System.IO;
using System.Text;
using TMPro;
using UnityEditor;
using UnityEngine;

public static class Battle82TmpEssentialResourcesEditor
{
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_82_TMP_ESSENTIAL_RESOURCES_IMPORT.json";
    private const string ReportMdPath = @"C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_82_TMP_ESSENTIAL_RESOURCES_IMPORT.md";
    private const string ExpectedSettingsPath = "Assets/TextMesh Pro/Resources/TMP Settings.asset";
    private const string ExpectedFontPath = "Assets/TextMesh Pro/Resources/Fonts & Materials/LiberationSans SDF.asset";

    [MenuItem("GirlsWar/Battle/BATTLE82 Import TMP Essential Resources")]
    public static void Import()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(Path.GetDirectoryName(ReportMdPath));

        var result = new Result
        {
            generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
            expectedSettingsPath = ExpectedSettingsPath,
            expectedFontPath = ExpectedFontPath,
            settingsExistsBefore = File.Exists(ProjectPath(ExpectedSettingsPath)),
            liberationSansSdfExistsBefore = File.Exists(ProjectPath(ExpectedFontPath))
        };

        try
        {
            if (!result.settingsExistsBefore || !result.liberationSansSdfExistsBefore)
            {
                TMP_PackageResourceImporter.ImportResources(true, false, false);
                AssetDatabase.Refresh();
            }

            result.settingsExistsAfter = File.Exists(ProjectPath(ExpectedSettingsPath));
            result.liberationSansSdfExistsAfter = File.Exists(ProjectPath(ExpectedFontPath));
            var fontAsset = AssetDatabase.LoadAssetAtPath<TMP_FontAsset>(ExpectedFontPath);
            result.liberationSansSdfLoads = fontAsset != null;
            result.liberationSansSdfHasMaterial = fontAsset != null && fontAsset.material != null;
            result.status = result.settingsExistsAfter &&
                result.liberationSansSdfExistsAfter &&
                result.liberationSansSdfLoads &&
                result.liberationSansSdfHasMaterial
                ? "battle82_tmp_essential_resources_import_verified"
                : "battle82_tmp_essential_resources_import_failed";
        }
        catch (Exception ex)
        {
            result.status = "battle82_tmp_essential_resources_import_exception";
            result.exception = ex.GetType().Name + ": " + ex.Message;
        }

        WriteOutputs(result);
        Debug.Log("[GirlsWarRestore] BATTLE82 TMP essentials import: " + result.status);
    }

    private static void WriteOutputs(Result result)
    {
        File.WriteAllText(ProjectPath(ResultJsonPath), JsonUtility.ToJson(result, true), Encoding.UTF8);

        var sb = new StringBuilder();
        sb.AppendLine("# BATTLE_82_TMP_ESSENTIAL_RESOURCES_IMPORT");
        sb.AppendLine();
        sb.AppendLine("- status: `" + result.status + "`");
        sb.AppendLine("- settings before/after: `" + result.settingsExistsBefore + " / " + result.settingsExistsAfter + "`");
        sb.AppendLine("- LiberationSans SDF before/after: `" + result.liberationSansSdfExistsBefore + " / " + result.liberationSansSdfExistsAfter + "`");
        sb.AppendLine("- LiberationSans SDF loads/hasMaterial: `" + result.liberationSansSdfLoads + " / " + result.liberationSansSdfHasMaterial + "`");
        if (!string.IsNullOrEmpty(result.exception))
            sb.AppendLine("- exception: `" + result.exception + "`");
        File.WriteAllText(ReportMdPath, sb.ToString(), Encoding.UTF8);
    }

    private static string ProjectPath(string projectRelativePath)
    {
        return Path.GetFullPath(Path.Combine(Application.dataPath, "..", projectRelativePath));
    }

    [Serializable]
    private sealed class Result
    {
        public string generatedAt;
        public string status;
        public string expectedSettingsPath;
        public string expectedFontPath;
        public bool settingsExistsBefore;
        public bool liberationSansSdfExistsBefore;
        public bool settingsExistsAfter;
        public bool liberationSansSdfExistsAfter;
        public bool liberationSansSdfLoads;
        public bool liberationSansSdfHasMaterial;
        public string exception;
    }
}
