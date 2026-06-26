using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using UnityEditor;
using UnityEngine;
using UnityEngine.Playables;

public static class Battle64TimelinePlayableAssetCompatibilityTraceEditor
{
    private const string Prefix = "BATTLE_64_TIMELINE_PLAYABLEASSET_COMPATIBILITY_AND_ORIGINAL_BINDING_SOURCE_TRACE_NO_PATCH";
    private const string BaseDir = @"C:\Users\godho\Downloads\girlswar";
    private static readonly string RestoreDataDir = Path.Combine(BaseDir, @"girlswar_battle_unity\Assets\RestoreData\battle");
    private static readonly string OutCompatibilityCsv = Path.Combine(RestoreDataDir, Prefix + "_UNITY_PACKAGE_TYPE_IDENTITY_COMPATIBILITY_MATRIX.csv");
    private static readonly string ManifestJson = Path.Combine(BaseDir, @"girlswar_battle_unity\Packages\manifest.json");
    private static readonly string LockJson = Path.Combine(BaseDir, @"girlswar_battle_unity\Packages\packages-lock.json");
    private static readonly string ProjectVersion = Path.Combine(BaseDir, @"girlswar_battle_unity\ProjectSettings\ProjectVersion.txt");

    public static void Build()
    {
        Directory.CreateDirectory(RestoreDataDir);
        var rows = new System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>>();
        var manifestText = File.Exists(ManifestJson) ? File.ReadAllText(ManifestJson, Encoding.UTF8) : "";
        var lockText = File.Exists(LockJson) ? File.ReadAllText(LockJson, Encoding.UTF8) : "";
        var versionText = File.Exists(ProjectVersion) ? File.ReadAllText(ProjectVersion, Encoding.UTF8).Replace("\r", " ").Replace("\n", " ").Trim() : "";
        var timelineManifest = manifestText.IndexOf("com.unity.timeline", StringComparison.OrdinalIgnoreCase) >= 0;
        var directorManifest = manifestText.IndexOf("com.unity.modules.director", StringComparison.OrdinalIgnoreCase) >= 0;
        var timelineLock = lockText.IndexOf("com.unity.timeline", StringComparison.OrdinalIgnoreCase) >= 0;

        AddPackageRow(rows, "project_version", "ProjectSettings/ProjectVersion.txt", versionText, timelineManifest, directorManifest, timelineLock);
        AddPackageRow(rows, "package_manifest", "com.unity.timeline", timelineManifest ? "present" : "absent", timelineManifest, directorManifest, timelineLock);
        AddPackageRow(rows, "package_manifest", "com.unity.modules.director", directorManifest ? "present" : "absent", timelineManifest, directorManifest, timelineLock);
        AddPackageRow(rows, "package_lock", "com.unity.timeline", timelineLock ? "present" : "absent", timelineManifest, directorManifest, timelineLock);

        var assemblies = AppDomain.CurrentDomain.GetAssemblies();
        var playableAssetType = typeof(PlayableAsset);
        AddTypeRow(rows, "loaded_type", "UnityEngine.Playables.PlayableAsset", playableAssetType, playableAssetType, timelineManifest, directorManifest, timelineLock);

        var timelineType = Type.GetType("UnityEngine.Timeline.TimelineAsset, Unity.Timeline", false)
            ?? assemblies.Select(a => a.GetType("UnityEngine.Timeline.TimelineAsset", false)).FirstOrDefault(t => t != null);
        AddTypeRow(rows, "loaded_type", "UnityEngine.Timeline.TimelineAsset", timelineType, playableAssetType, timelineManifest, directorManifest, timelineLock);

        var timelineAssemblies = assemblies
            .Where(a => a.GetName().Name.IndexOf("Timeline", StringComparison.OrdinalIgnoreCase) >= 0)
            .OrderBy(a => a.GetName().Name)
            .ToList();
        if (timelineAssemblies.Count == 0)
        {
            var row = NewRow();
            row["category"] = "loaded_assembly";
            row["item"] = "Timeline assemblies";
            row["value"] = "none_loaded";
            row["unityVersion"] = Application.unityVersion;
            row["timelinePackageInManifest"] = Bool(timelineManifest);
            row["directorModuleInManifest"] = Bool(directorManifest);
            row["timelinePackageInLock"] = Bool(timelineLock);
            row["timelineAssemblyLoaded"] = "False";
            row["duplicateTimelineAssemblyCount"] = "0";
            row["finding"] = "timeline_package_or_assembly_absent_in_restored_editor";
            row["evidence"] = "AppDomain has no assembly name containing Timeline.";
            rows.Add(row);
        }
        foreach (var assembly in timelineAssemblies)
        {
            var row = NewRow();
            row["category"] = "loaded_assembly";
            row["item"] = assembly.GetName().Name;
            row["value"] = assembly.FullName;
            row["unityVersion"] = Application.unityVersion;
            row["assemblyLocation"] = SafeLocation(assembly);
            row["timelinePackageInManifest"] = Bool(timelineManifest);
            row["directorModuleInManifest"] = Bool(directorManifest);
            row["timelinePackageInLock"] = Bool(timelineLock);
            row["timelineAssemblyLoaded"] = "True";
            row["duplicateTimelineAssemblyCount"] = timelineAssemblies.Count.ToString();
            row["finding"] = timelineAssemblies.Count > 1 ? "duplicate_timeline_assembly_candidate" : "timeline_assembly_loaded";
            row["evidence"] = "Loaded assembly visible to restored Editor domain.";
            rows.Add(row);
        }

        WriteCsv(OutCompatibilityCsv, rows);
        AssetDatabase.Refresh();
        Debug.Log(Prefix + " compatibility trace complete rows=" + rows.Count);
    }

    private static void AddPackageRow(System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>> rows, string category, string item, string value, bool timelineManifest, bool directorManifest, bool timelineLock)
    {
        var row = NewRow();
        row["category"] = category;
        row["item"] = item;
        row["value"] = value;
        row["unityVersion"] = Application.unityVersion;
        row["timelinePackageInManifest"] = Bool(timelineManifest);
        row["directorModuleInManifest"] = Bool(directorManifest);
        row["timelinePackageInLock"] = Bool(timelineLock);
        row["timelineAssemblyLoaded"] = "";
        row["duplicateTimelineAssemblyCount"] = "";
        row["finding"] = timelineManifest ? "timeline_package_declared" : "timeline_package_missing_from_project_manifest";
        row["evidence"] = "Source file checked without package changes.";
        rows.Add(row);
    }

    private static void AddTypeRow(System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>> rows, string category, string item, Type type, Type playableAssetType, bool timelineManifest, bool directorManifest, bool timelineLock)
    {
        var row = NewRow();
        row["category"] = category;
        row["item"] = item;
        row["value"] = type != null ? type.FullName : "not_found";
        row["unityVersion"] = Application.unityVersion;
        row["loadedTypeFullName"] = type != null ? type.FullName : "";
        row["assemblyFullName"] = type != null ? type.Assembly.FullName : "";
        row["assemblyLocation"] = type != null ? SafeLocation(type.Assembly) : "";
        row["assignableToPlayableAsset"] = type != null ? Bool(playableAssetType.IsAssignableFrom(type)) : "False";
        row["timelinePackageInManifest"] = Bool(timelineManifest);
        row["directorModuleInManifest"] = Bool(directorManifest);
        row["timelinePackageInLock"] = Bool(timelineLock);
        row["timelineAssemblyLoaded"] = Bool(type != null && type.Assembly.GetName().Name.IndexOf("Timeline", StringComparison.OrdinalIgnoreCase) >= 0);
        row["duplicateTimelineAssemblyCount"] = "";
        row["finding"] = type == null ? "type_not_loaded_in_restored_editor" : "type_loaded_in_restored_editor";
        row["evidence"] = type == null ? "Type lookup failed in AppDomain." : "Type lookup succeeded in AppDomain.";
        rows.Add(row);
    }

    private static System.Collections.Generic.Dictionary<string, string> NewRow()
    {
        var headers = Headers();
        var row = new System.Collections.Generic.Dictionary<string, string>();
        foreach (var h in headers) row[h] = "";
        return row;
    }

    private static string[] Headers()
    {
        return new[]
        {
            "category", "item", "value", "unityVersion", "loadedTypeFullName", "assemblyFullName", "assemblyLocation",
            "assignableToPlayableAsset", "timelinePackageInManifest", "directorModuleInManifest", "timelinePackageInLock",
            "timelineAssemblyLoaded", "duplicateTimelineAssemblyCount", "finding", "evidence"
        };
    }

    private static void WriteCsv(string path, System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>> rows)
    {
        var headers = Headers();
        var sb = new StringBuilder();
        sb.AppendLine(string.Join(",", headers.Select(Escape)));
        foreach (var row in rows) sb.AppendLine(string.Join(",", headers.Select(h => Escape(row.ContainsKey(h) ? row[h] : ""))));
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static string SafeLocation(Assembly assembly)
    {
        try { return assembly.Location; } catch { return ""; }
    }

    private static string Bool(bool value) { return value ? "True" : "False"; }

    private static string Escape(string value)
    {
        value = value ?? "";
        if (value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r")) return "\"" + value.Replace("\"", "\"\"") + "\"";
        return value;
    }
}
