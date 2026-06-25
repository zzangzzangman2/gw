using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Reflection;
using System.Text;
using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.TextCore;
using UnityEngine.TextCore.LowLevel;

namespace GirlsWarRestore
{
    public static class TmpStaticFontAssetProbe
    {
        private const string GlyphCsv = "Assets/RestoreData/reports/maininterface_original_tmp_static_glyphs.csv";
        private const string CharacterCsv = "Assets/RestoreData/reports/maininterface_original_tmp_static_characters.csv";
        private const string MaterialCsv = "Assets/RestoreData/reports/maininterface_original_tmp_static_material_properties.csv";
        private const string OutputDir = "Assets/RestoreData/TMP/static_probe";
        private const string ReportJson = "Assets/RestoreData/reports/maininterface_tmp_static_font_probe_result.json";
        private const string ReportMdAbsolute = @"C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TMP_STATIC_FONT_PROBE_RESULT.md";

        private sealed class FontSpec
        {
            public string key;
            public string sourceFontPath;
            public string outputAssetPath;
            public string materialAssetPath;
            public string atlasSourcePath;
            public string atlasAssetPath;
            public int atlasWidth;
            public int atlasHeight;
            public string familyName;
            public string styleName;
            public float pointSize;
            public float lineHeight;
            public float ascentLine;
            public float descentLine;
        }

        private sealed class ProbeResult
        {
            public string key;
            public bool success;
            public string message;
            public int glyphCount;
            public int characterCount;
            public string outputAssetPath;
            public string atlasAssetPath;
        }

        private static readonly FontSpec[] FontSpecs =
        {
            new FontSpec
            {
                key = "riyu",
                sourceFontPath = "Assets/RestoreData/TMP/original_fonts/riyu_source.ttf",
                outputAssetPath = OutputDir + "/GirlsWarStaticProbe_riyu_TMP.asset",
                materialAssetPath = OutputDir + "/GirlsWarStaticProbe_riyu_Material.mat",
                atlasSourcePath = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\bundles\b_4662ff1cbab15a47\images\T\-1980486418211286436_riyu Atlas.png",
                atlasAssetPath = OutputDir + "/atlas/riyu_static_atlas.png",
                atlasWidth = 2048,
                atlasHeight = 2048,
                familyName = "DFMincho-SU",
                styleName = "Regular",
                pointSize = 40f,
                lineHeight = 40f,
                ascentLine = 34.375f,
                descentLine = -5.625f
            },
            new FontSpec
            {
                key = "EPM",
                sourceFontPath = "Assets/RestoreData/TMP/original_fonts/EPM_source.ttf",
                outputAssetPath = OutputDir + "/GirlsWarStaticProbe_EPM_TMP.asset",
                materialAssetPath = OutputDir + "/GirlsWarStaticProbe_EPM_Material.mat",
                atlasSourcePath = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\bundles\b_db045da99370f453\images\T\5218067429375919017_EPM Atlas.png",
                atlasAssetPath = OutputDir + "/atlas/EPM_static_atlas.png",
                atlasWidth = 1024,
                atlasHeight = 2048,
                familyName = "EPSON",
                styleName = "Regular",
                pointSize = 40f,
                lineHeight = 40f,
                ascentLine = 34.375f,
                descentLine = -5.625f
            },
            new FontSpec
            {
                key = "num",
                sourceFontPath = "Assets/RestoreData/TMP/original_fonts/num_source.ttf",
                outputAssetPath = OutputDir + "/GirlsWarStaticProbe_num_TMP.asset",
                materialAssetPath = OutputDir + "/GirlsWarStaticProbe_num_Material.mat",
                atlasSourcePath = @"C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\bundles\b_2e178048ca87ecfc\images\T\-3487941317702978074_num Atlas.png",
                atlasAssetPath = OutputDir + "/atlas/num_static_atlas.png",
                atlasWidth = 256,
                atlasHeight = 256,
                familyName = "Impact",
                styleName = "Regular",
                pointSize = 40f,
                lineHeight = 48.7890625f,
                ascentLine = 40.3515625f,
                descentLine = -8.4375f
            }
        };

        public static void Run()
        {
            Directory.CreateDirectory(OutputDir);
            var glyphs = LoadGlyphRows();
            var characters = LoadCharacterRows();
            var materialProperties = LoadMaterialProperties();
            var results = new List<ProbeResult>();

            foreach (var spec in FontSpecs)
            {
                try
                {
                    results.Add(BuildStaticProbeFont(spec, glyphs, characters, materialProperties));
                }
                catch (Exception ex)
                {
                    results.Add(new ProbeResult
                    {
                        key = spec.key,
                        success = false,
                        message = ex.GetType().Name + ": " + ex.Message,
                        outputAssetPath = spec.outputAssetPath,
                        atlasAssetPath = spec.atlasAssetPath
                    });
                    Debug.LogWarning("[GirlsWarRestore] TMP static probe failed for " + spec.key + ": " + ex);
                }
            }

            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh(ImportAssetOptions.ForceSynchronousImport);
            WriteReports(results);
            Debug.Log("[GirlsWarRestore] TMP static font probe complete: " + ReportJson);
        }

        private static ProbeResult BuildStaticProbeFont(
            FontSpec spec,
            Dictionary<string, List<Dictionary<string, string>>> glyphRows,
            Dictionary<string, List<Dictionary<string, string>>> characterRows,
            Dictionary<string, List<Dictionary<string, string>>> materialRows)
        {
            if (!File.Exists(spec.sourceFontPath))
                throw new FileNotFoundException(spec.sourceFontPath);
            if (!File.Exists(spec.atlasSourcePath))
                throw new FileNotFoundException(spec.atlasSourcePath);

            Directory.CreateDirectory(Path.GetDirectoryName(spec.atlasAssetPath));
            File.Copy(spec.atlasSourcePath, spec.atlasAssetPath, true);
            AssetDatabase.ImportAsset(spec.atlasAssetPath, ImportAssetOptions.ForceSynchronousImport);
            ConfigureTextureImporter(spec.atlasAssetPath);
            var atlasTexture = AssetDatabase.LoadAssetAtPath<Texture2D>(spec.atlasAssetPath);
            if (atlasTexture == null)
                throw new InvalidOperationException("Failed to import atlas texture: " + spec.atlasAssetPath);

            AssetDatabase.ImportAsset(spec.sourceFontPath, ImportAssetOptions.ForceSynchronousImport);
            var sourceFont = AssetDatabase.LoadAssetAtPath<Font>(spec.sourceFontPath);
            if (sourceFont == null)
                throw new InvalidOperationException("Failed to import source font: " + spec.sourceFontPath);

            if (File.Exists(spec.outputAssetPath))
                AssetDatabase.DeleteAsset(spec.outputAssetPath);
            if (File.Exists(spec.materialAssetPath))
                AssetDatabase.DeleteAsset(spec.materialAssetPath);

            var fontAsset = TMP_FontAsset.CreateFontAsset(
                sourceFont,
                40,
                9,
                GlyphRenderMode.SDFAA,
                spec.atlasWidth,
                spec.atlasHeight,
                AtlasPopulationMode.Static,
                true);
            if (fontAsset == null)
                throw new InvalidOperationException("TMP_FontAsset.CreateFontAsset returned null");
            fontAsset.name = "GirlsWarStaticProbe_" + spec.key + "_TMP";

            var glyphTable = BuildGlyphTable(glyphRows[spec.key]);
            var characterTable = BuildCharacterTable(characterRows[spec.key], glyphTable);
            var material = CreateMaterial(spec, atlasTexture, materialRows.TryGetValue(spec.key, out var rows) ? rows : new List<Dictionary<string, string>>());

            SetPrivateField(fontAsset, "m_GlyphTable", glyphTable);
            SetPrivateField(fontAsset, "m_CharacterTable", characterTable);
            SetPrivateField(fontAsset, "m_AtlasTextures", new[] { atlasTexture });
            SetPrivateField(fontAsset, "m_Material", material);
            SetPrivateField(fontAsset, "m_AtlasWidth", spec.atlasWidth);
            SetPrivateField(fontAsset, "m_AtlasHeight", spec.atlasHeight);
            SetPrivateField(fontAsset, "m_AtlasPadding", 9);
            SetPrivateField(fontAsset, "m_AtlasPopulationMode", AtlasPopulationMode.Static);

            ApplyFaceInfo(fontAsset, spec);
            AssetDatabase.CreateAsset(fontAsset, spec.outputAssetPath);
            EditorUtility.SetDirty(fontAsset);
            AssetDatabase.SaveAssets();
            AssetDatabase.ImportAsset(spec.outputAssetPath, ImportAssetOptions.ForceSynchronousImport);

            var saved = AssetDatabase.LoadAssetAtPath<TMP_FontAsset>(spec.outputAssetPath);
            if (saved == null)
                throw new InvalidOperationException("Saved static probe font could not be loaded: " + spec.outputAssetPath);
            var savedGlyphCount = saved.glyphTable == null ? 0 : saved.glyphTable.Count;
            var savedCharacterCount = saved.characterTable == null ? 0 : saved.characterTable.Count;

            return new ProbeResult
            {
                key = spec.key,
                success = savedGlyphCount == glyphTable.Count && savedCharacterCount == characterTable.Count,
                message = "saved",
                glyphCount = savedGlyphCount,
                characterCount = savedCharacterCount,
                outputAssetPath = spec.outputAssetPath,
                atlasAssetPath = spec.atlasAssetPath
            };
        }

        private static List<Glyph> BuildGlyphTable(List<Dictionary<string, string>> rows)
        {
            var result = new List<Glyph>();
            foreach (var row in rows)
            {
                var metrics = new GlyphMetrics(
                    F(row, "width"),
                    F(row, "height"),
                    F(row, "bearing_x"),
                    F(row, "bearing_y"),
                    F(row, "advance"));
                var rect = new GlyphRect(
                    I(row, "rect_x"),
                    I(row, "rect_y"),
                    I(row, "rect_width"),
                    I(row, "rect_height"));
                result.Add(new Glyph((uint)I(row, "glyph_index"), metrics, rect, F(row, "scale"), I(row, "atlas_index")));
            }
            return result;
        }

        private static List<TMP_Character> BuildCharacterTable(List<Dictionary<string, string>> rows, List<Glyph> glyphTable)
        {
            var glyphByIndex = new Dictionary<uint, Glyph>();
            foreach (var glyph in glyphTable)
                glyphByIndex[glyph.index] = glyph;

            var result = new List<TMP_Character>();
            foreach (var row in rows)
            {
                var unicode = (uint)I(row, "unicode");
                var glyphIndex = (uint)I(row, "glyph_index");
                if (!glyphByIndex.TryGetValue(glyphIndex, out var glyph))
                    continue;
                result.Add(new TMP_Character(unicode, glyph));
            }
            return result;
        }

        private static Material CreateMaterial(FontSpec spec, Texture2D atlasTexture, List<Dictionary<string, string>> rows)
        {
            var shader = Shader.Find("TextMeshPro/Mobile/Distance Field")
                ?? Shader.Find("TextMeshPro/Distance Field")
                ?? Shader.Find("UI/Default");
            var material = new Material(shader) { name = "GirlsWarStaticProbe_" + spec.key + "_Material" };
            material.mainTexture = atlasTexture;
            foreach (var row in rows)
            {
                var property = Get(row, "property_name");
                if (string.IsNullOrWhiteSpace(property) || !material.HasProperty(property))
                    continue;
                var type = Get(row, "property_type");
                var value = Get(row, "value");
                if (type == "float")
                    material.SetFloat(property, ParseFloat(value));
                else if (type == "color")
                    material.SetColor(property, ParseColor(value));
                else if (type == "texture" && property != "_MainTex")
                    material.SetTexture(property, atlasTexture);
            }
            material.SetTexture("_MainTex", atlasTexture);
            AssetDatabase.CreateAsset(material, spec.materialAssetPath);
            return AssetDatabase.LoadAssetAtPath<Material>(spec.materialAssetPath);
        }

        private static void ApplyFaceInfo(TMP_FontAsset fontAsset, FontSpec spec)
        {
            var serialized = new SerializedObject(fontAsset);
            SetSerializedString(serialized, "m_FaceInfo.m_FamilyName", spec.familyName);
            SetSerializedString(serialized, "m_FaceInfo.m_StyleName", spec.styleName);
            SetSerializedFloat(serialized, "m_FaceInfo.m_PointSize", spec.pointSize);
            SetSerializedFloat(serialized, "m_FaceInfo.m_LineHeight", spec.lineHeight);
            SetSerializedFloat(serialized, "m_FaceInfo.m_AscentLine", spec.ascentLine);
            SetSerializedFloat(serialized, "m_FaceInfo.m_DescentLine", spec.descentLine);
            SetSerializedBool(serialized, "m_ClearDynamicDataOnBuild", false);
            serialized.ApplyModifiedPropertiesWithoutUndo();
        }

        private static void ConfigureTextureImporter(string assetPath)
        {
            var importer = AssetImporter.GetAtPath(assetPath) as TextureImporter;
            if (importer == null)
                return;
            importer.textureType = TextureImporterType.Default;
            importer.alphaSource = TextureImporterAlphaSource.FromInput;
            importer.mipmapEnabled = false;
            importer.sRGBTexture = false;
            importer.isReadable = true;
            importer.SaveAndReimport();
        }

        private static Dictionary<string, List<Dictionary<string, string>>> LoadGlyphRows()
        {
            return GroupByFont(LoadCsv(GlyphCsv));
        }

        private static Dictionary<string, List<Dictionary<string, string>>> LoadCharacterRows()
        {
            return GroupByFont(LoadCsv(CharacterCsv));
        }

        private static Dictionary<string, List<Dictionary<string, string>>> LoadMaterialProperties()
        {
            return GroupByFont(LoadCsv(MaterialCsv));
        }

        private static Dictionary<string, List<Dictionary<string, string>>> GroupByFont(List<Dictionary<string, string>> rows)
        {
            var result = new Dictionary<string, List<Dictionary<string, string>>>();
            foreach (var row in rows)
            {
                var key = Get(row, "font_key");
                if (!result.TryGetValue(key, out var list))
                {
                    list = new List<Dictionary<string, string>>();
                    result[key] = list;
                }
                list.Add(row);
            }
            return result;
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
                {
                    inQuotes = true;
                }
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
                {
                    field.Append(c);
                }
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

        private static void WriteReports(List<ProbeResult> results)
        {
            Directory.CreateDirectory(Path.GetDirectoryName(ReportJson));
            var json = new StringBuilder();
            json.AppendLine("{");
            json.AppendLine("  \"generatedAt\": \"" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture) + "\",");
            json.AppendLine("  \"results\": [");
            for (var i = 0; i < results.Count; i++)
            {
                var r = results[i];
                json.AppendLine("    {");
                json.AppendLine("      \"key\": \"" + EscapeJson(r.key) + "\",");
                json.AppendLine("      \"success\": " + (r.success ? "true" : "false") + ",");
                json.AppendLine("      \"message\": \"" + EscapeJson(r.message) + "\",");
                json.AppendLine("      \"glyphCount\": " + r.glyphCount + ",");
                json.AppendLine("      \"characterCount\": " + r.characterCount + ",");
                json.AppendLine("      \"outputAssetPath\": \"" + EscapeJson(r.outputAssetPath) + "\",");
                json.AppendLine("      \"atlasAssetPath\": \"" + EscapeJson(r.atlasAssetPath) + "\"");
                json.Append("    }");
                json.AppendLine(i + 1 < results.Count ? "," : "");
            }
            json.AppendLine("  ]");
            json.AppendLine("}");
            File.WriteAllText(ReportJson, json.ToString(), Encoding.UTF8);

            Directory.CreateDirectory(Path.GetDirectoryName(ReportMdAbsolute));
            var md = new StringBuilder();
            md.AppendLine("# MainInterface TMP Static Font Probe Result");
            md.AppendLine();
            md.AppendLine("Generated: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture));
            md.AppendLine();
            md.AppendLine("## Result");
            md.AppendLine();
            md.AppendLine("| font | success | glyphs | chars | asset | atlas | message |");
            md.AppendLine("| --- | --- | ---: | ---: | --- | --- | --- |");
            foreach (var r in results)
                md.AppendLine("| `" + r.key + "` | `" + r.success + "` | " + r.glyphCount + " | " + r.characterCount + " | `" + r.outputAssetPath + "` | `" + r.atlasAssetPath + "` | `" + r.message + "` |");
            md.AppendLine();
            md.AppendLine("## Meaning");
            md.AppendLine();
            md.AppendLine("이 probe는 원본 TMP 정적 glyph/character table과 추출 atlas PNG를 Unity `TMP_FontAsset`에 주입할 수 있는지 확인한다. 성공하면 MainInterface 빌더에 같은 방식을 통합해 source font dynamic preload 대신 원본 정적 TMP asset을 사용할 수 있다.");
            md.AppendLine();
            md.AppendLine("## Generated Files");
            md.AppendLine();
            md.AppendLine("- `" + ReportJson + "`");
            foreach (var r in results)
            {
                md.AppendLine("- `" + r.outputAssetPath + "`");
                md.AppendLine("- `" + r.atlasAssetPath + "`");
            }
            File.WriteAllText(ReportMdAbsolute, md.ToString(), Encoding.UTF8);
        }

        private static void SetPrivateField(object target, string fieldName, object value)
        {
            var field = target.GetType().GetField(fieldName, BindingFlags.Instance | BindingFlags.NonPublic);
            if (field == null)
                throw new MissingFieldException(target.GetType().FullName, fieldName);
            field.SetValue(target, value);
        }

        private static void SetSerializedString(SerializedObject serialized, string path, string value)
        {
            var property = serialized.FindProperty(path);
            if (property != null)
                property.stringValue = value;
        }

        private static void SetSerializedFloat(SerializedObject serialized, string path, float value)
        {
            var property = serialized.FindProperty(path);
            if (property != null)
                property.floatValue = value;
        }

        private static void SetSerializedBool(SerializedObject serialized, string path, bool value)
        {
            var property = serialized.FindProperty(path);
            if (property != null)
                property.boolValue = value;
        }

        private static string Get(Dictionary<string, string> row, string key)
        {
            return row.TryGetValue(key, out var value) ? value : "";
        }

        private static int I(Dictionary<string, string> row, string key)
        {
            return Mathf.RoundToInt(ParseFloat(Get(row, key)));
        }

        private static float F(Dictionary<string, string> row, string key)
        {
            return ParseFloat(Get(row, key));
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

        private static string EscapeJson(string value)
        {
            return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"");
        }
    }
}
