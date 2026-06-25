using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using TMPro;
using UnityEditor;
using UnityEngine;

namespace GirlsWarRestore
{
    public static class TmpSharedMaterialBuilder
    {
        private const string MaterialsCsv = "Assets/RestoreData/reports/maininterface_tmp_shared_materials.csv";
        private const string PropertiesCsv = "Assets/RestoreData/reports/maininterface_tmp_shared_material_properties.csv";
        private const string OutputDir = "Assets/RestoreData/TMP/static_probe/shared_materials";
        private const string ReportJson = "Assets/RestoreData/reports/maininterface_tmp_shared_material_build_result.json";
        private const string ReportMdAbsolute = @"C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TMP_SHARED_MATERIAL_APPLY_RESULT.md";

        private sealed class MaterialSpec
        {
            public string sharedMaterialPathId;
            public string usageCount;
            public string fontKey;
            public string materialName;
            public string bundle;
            public string textSamples;
        }

        public sealed class BuildResult
        {
            public string sharedMaterialPathId;
            public string fontKey;
            public string materialName;
            public string assetPath;
            public bool success;
            public string message;
        }

        public static string MaterialAssetPath(string sharedMaterialPathId)
        {
            if (string.IsNullOrWhiteSpace(sharedMaterialPathId) || sharedMaterialPathId == "0")
                return "";
            return OutputDir + "/TMPSharedMaterial_" + SanitizePathId(sharedMaterialPathId) + ".mat";
        }

        public static void Run()
        {
            var results = BuildAll();
            WriteReports(results);
            Debug.Log("[GirlsWarRestore] TMP shared material build complete: " + ReportJson);
        }

        public static List<BuildResult> BuildAll()
        {
            Directory.CreateDirectory(OutputDir);
            var specs = LoadMaterialSpecs();
            var propertiesByPathId = GroupByPathId(LoadCsv(PropertiesCsv));
            var results = new List<BuildResult>();
            foreach (var spec in specs)
            {
                try
                {
                    results.Add(BuildMaterial(spec, propertiesByPathId.TryGetValue(spec.sharedMaterialPathId, out var rows) ? rows : new List<Dictionary<string, string>>()));
                }
                catch (Exception ex)
                {
                    results.Add(new BuildResult
                    {
                        sharedMaterialPathId = spec.sharedMaterialPathId,
                        fontKey = spec.fontKey,
                        materialName = spec.materialName,
                        assetPath = MaterialAssetPath(spec.sharedMaterialPathId),
                        success = false,
                        message = ex.GetType().Name + ": " + ex.Message
                    });
                    Debug.LogWarning("[GirlsWarRestore] Failed to build TMP shared material " + spec.sharedMaterialPathId + ": " + ex);
                }
            }
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            return results;
        }

        private static BuildResult BuildMaterial(MaterialSpec spec, List<Dictionary<string, string>> propertyRows)
        {
            var atlas = AssetDatabase.LoadAssetAtPath<Texture2D>(AtlasPath(spec.fontKey));
            if (atlas == null)
                throw new FileNotFoundException("Static TMP atlas missing for " + spec.fontKey + ": " + AtlasPath(spec.fontKey));

            var shader = Shader.Find("TextMeshPro/Mobile/Distance Field")
                ?? Shader.Find("TextMeshPro/Distance Field")
                ?? Shader.Find("UI/Default");
            if (shader == null)
                throw new InvalidOperationException("No usable TMP/UI shader found");

            var assetPath = MaterialAssetPath(spec.sharedMaterialPathId);
            var material = AssetDatabase.LoadAssetAtPath<Material>(assetPath);
            if (material == null)
            {
                material = new Material(shader);
                AssetDatabase.CreateAsset(material, assetPath);
                material = AssetDatabase.LoadAssetAtPath<Material>(assetPath);
            }
            if (material == null)
                throw new InvalidOperationException("Could not create material asset: " + assetPath);

            material.shader = shader;
            material.name = "TMPShared_" + spec.fontKey + "_" + SanitizePathId(spec.sharedMaterialPathId);
            material.mainTexture = atlas;
            if (material.HasProperty("_MainTex"))
                material.SetTexture("_MainTex", atlas);

            foreach (var row in propertyRows)
            {
                var propertyName = Get(row, "property_name");
                var propertyType = Get(row, "property_type");
                var value = Get(row, "value");
                if (string.IsNullOrWhiteSpace(propertyName) || !material.HasProperty(propertyName))
                    continue;

                if (propertyType == "float")
                    material.SetFloat(propertyName, ParseFloat(value));
                else if (propertyType == "color")
                    material.SetColor(propertyName, ParseColor(value));
                else if (propertyType == "texture")
                    material.SetTexture(propertyName, atlas);
            }

            EditorUtility.SetDirty(material);
            return new BuildResult
            {
                sharedMaterialPathId = spec.sharedMaterialPathId,
                fontKey = spec.fontKey,
                materialName = spec.materialName,
                assetPath = assetPath,
                success = true,
                message = "saved"
            };
        }

        private static List<MaterialSpec> LoadMaterialSpecs()
        {
            var result = new List<MaterialSpec>();
            foreach (var row in LoadCsv(MaterialsCsv))
            {
                result.Add(new MaterialSpec
                {
                    sharedMaterialPathId = Get(row, "shared_material_path_id"),
                    usageCount = Get(row, "usage_count"),
                    fontKey = Get(row, "font_key"),
                    materialName = Get(row, "material_name"),
                    bundle = Get(row, "bundle"),
                    textSamples = Get(row, "text_samples")
                });
            }
            return result;
        }

        private static Dictionary<string, List<Dictionary<string, string>>> GroupByPathId(List<Dictionary<string, string>> rows)
        {
            var result = new Dictionary<string, List<Dictionary<string, string>>>();
            foreach (var row in rows)
            {
                var pathId = Get(row, "shared_material_path_id");
                if (!result.TryGetValue(pathId, out var list))
                {
                    list = new List<Dictionary<string, string>>();
                    result[pathId] = list;
                }
                list.Add(row);
            }
            return result;
        }

        private static string AtlasPath(string fontKey)
        {
            if (fontKey.Equals("EPM", StringComparison.OrdinalIgnoreCase))
                return "Assets/RestoreData/TMP/static_probe/atlas/EPM_static_atlas.png";
            if (fontKey.Equals("num", StringComparison.OrdinalIgnoreCase))
                return "Assets/RestoreData/TMP/static_probe/atlas/num_static_atlas.png";
            return "Assets/RestoreData/TMP/static_probe/atlas/riyu_static_atlas.png";
        }

        private static List<Dictionary<string, string>> LoadCsv(string path)
        {
            if (!File.Exists(path))
                return new List<Dictionary<string, string>>();
            var text = File.ReadAllText(path, Encoding.UTF8);
            var records = new List<List<string>>();
            var record = new List<string>();
            var field = new StringBuilder();
            var inQuotes = false;

            for (var i = 0; i < text.Length; i++)
            {
                var c = text[i];
                if (inQuotes)
                {
                    if (c == '"')
                    {
                        if (i + 1 < text.Length && text[i + 1] == '"')
                        {
                            field.Append('"');
                            i++;
                        }
                        else
                        {
                            inQuotes = false;
                        }
                    }
                    else
                    {
                        field.Append(c);
                    }
                    continue;
                }

                if (c == '"')
                    inQuotes = true;
                else if (c == ',')
                {
                    record.Add(field.ToString());
                    field.Length = 0;
                }
                else if (c == '\r' || c == '\n')
                {
                    if (c == '\r' && i + 1 < text.Length && text[i + 1] == '\n')
                        i++;
                    record.Add(field.ToString());
                    field.Length = 0;
                    records.Add(record);
                    record = new List<string>();
                }
                else
                    field.Append(c);
            }

            if (field.Length > 0 || record.Count > 0)
            {
                record.Add(field.ToString());
                records.Add(record);
            }
            if (records.Count == 0)
                return new List<Dictionary<string, string>>();

            var headers = records[0];
            var rows = new List<Dictionary<string, string>>();
            for (var r = 1; r < records.Count; r++)
            {
                if (records[r].Count == 1 && string.IsNullOrEmpty(records[r][0]))
                    continue;
                var row = new Dictionary<string, string>();
                for (var h = 0; h < headers.Count; h++)
                    row[headers[h]] = h < records[r].Count ? records[r][h] : "";
                rows.Add(row);
            }
            return rows;
        }

        private static void WriteReports(List<BuildResult> results)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(ReportJson));
            var json = new StringBuilder();
            json.AppendLine("{");
            json.AppendLine("  \"generatedAt\": \"" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture) + "\",");
            json.AppendLine("  \"materialCount\": " + results.Count + ",");
            json.AppendLine("  \"successCount\": " + results.FindAll(r => r.success).Count + ",");
            json.AppendLine("  \"results\": [");
            for (var i = 0; i < results.Count; i++)
            {
                var r = results[i];
                json.AppendLine("    {");
                json.AppendLine("      \"sharedMaterialPathId\": \"" + EscapeJson(r.sharedMaterialPathId) + "\",");
                json.AppendLine("      \"fontKey\": \"" + EscapeJson(r.fontKey) + "\",");
                json.AppendLine("      \"materialName\": \"" + EscapeJson(r.materialName) + "\",");
                json.AppendLine("      \"assetPath\": \"" + EscapeJson(r.assetPath) + "\",");
                json.AppendLine("      \"success\": " + (r.success ? "true" : "false") + ",");
                json.AppendLine("      \"message\": \"" + EscapeJson(r.message) + "\"");
                json.Append("    }");
                json.AppendLine(i + 1 < results.Count ? "," : "");
            }
            json.AppendLine("  ]");
            json.AppendLine("}");
            File.WriteAllText(ReportJson, json.ToString(), Encoding.UTF8);

            Directory.CreateDirectory(Path.GetDirectoryName(ReportMdAbsolute));
            var md = new StringBuilder();
            md.AppendLine("# MainInterface TMP Shared Material Apply Result");
            md.AppendLine();
            md.AppendLine("Generated: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture));
            md.AppendLine();
            md.AppendLine("## Result");
            md.AppendLine();
            md.AppendLine("| shared pathID | font | source material | success | asset | message |");
            md.AppendLine("| --- | --- | --- | --- | --- | --- |");
            foreach (var r in results)
                md.AppendLine("| `" + r.sharedMaterialPathId + "` | `" + r.fontKey + "` | `" + r.materialName + "` | `" + r.success + "` | `" + r.assetPath + "` | `" + r.message + "` |");
            md.AppendLine();
            md.AppendLine("## Meaning");
            md.AppendLine();
            md.AppendLine("원본 TMP shared material preset을 Unity Material asset으로 재구성했다. MainInterface 빌더는 `shared_material_path_id` 기준으로 이 material을 `TextMeshProUGUI.fontSharedMaterial`에 적용할 수 있다.");
            md.AppendLine();
            md.AppendLine("## Generated Files");
            md.AppendLine();
            md.AppendLine("- `" + ReportJson + "`");
            md.AppendLine("- `" + OutputDir + "`");
            File.WriteAllText(ReportMdAbsolute, md.ToString(), Encoding.UTF8);
        }

        private static string Get(Dictionary<string, string> row, string key)
        {
            return row.TryGetValue(key, out var value) ? value : "";
        }

        private static float ParseFloat(string value)
        {
            return float.TryParse(value, NumberStyles.Float, CultureInfo.InvariantCulture, out var result) ? result : 0f;
        }

        private static Color ParseColor(string value)
        {
            var parts = value.Split(',');
            if (parts.Length != 4)
                return Color.white;
            return new Color(ParseFloat(parts[0]), ParseFloat(parts[1]), ParseFloat(parts[2]), ParseFloat(parts[3]));
        }

        private static string SanitizePathId(string pathId)
        {
            return pathId.Replace("-", "m").Replace("+", "p").Replace(" ", "");
        }

        private static string EscapeJson(string value)
        {
            return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"");
        }
    }
}
