using System.IO;
using TMPro;
using UnityEditor;
using UnityEngine;

public static class BattleTmpSettingsBootstrapEditor
{
    private const string ResourcesFolder = "Assets/Resources";
    private const string TmpSettingsPath = "Assets/Resources/TMP Settings.asset";

    [InitializeOnLoadMethod]
    public static void EnsureTmpSettingsAsset()
    {
        if (!Directory.Exists(ResourcesFolder))
            Directory.CreateDirectory(ResourcesFolder);

        var settings = AssetDatabase.LoadAssetAtPath<TMP_Settings>(TmpSettingsPath);
        if (settings == null)
        {
            settings = ScriptableObject.CreateInstance<TMP_Settings>();
            AssetDatabase.CreateAsset(settings, TmpSettingsPath);
            Debug.Log("[GirlsWarRestore] Created minimal TMP Settings asset for generated battle roster TMP text.");
        }

        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }
}
