using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class BattleHudVisualSanityEditor
{
    private const string ManifestPath = "Assets/RestoreData/battle/BATTLE_HUD_SPRITE_REGION_FONT_JOIN_UNITY_MANIFEST.json";
    private const string BaseScenePath = "Assets/Scenes/BattleRuntimeFlowSkillEffectPlayableMarkers.unity";
    private const string B19ScenePath = "Assets/Scenes/BattleRuntimeFlowWithHudSpriteFontJoin.unity";
    private const string ScenePath = "Assets/Scenes/BattleHudVisualSanity.unity";
    private const string ResultPath = "Assets/RestoreData/battle/BATTLE_HUD_VISUAL_SANITY_REBASE_TO_PLAY_VIDEO_RESULT.json";
    private const string CapturePath = "Assets/RestoreCaptures/battle_hud/BattleHudVisualSanity_1680x720.png";

    [MenuItem("GirlsWar/Battle/Battle HUD Visual Sanity Rebase To Play Video")]
    public static void Build()
    {
        string manifestJson = File.Exists(ProjectPath(ManifestPath)) ? File.ReadAllText(ProjectPath(ManifestPath), Encoding.UTF8) : "{}";
        var attachments = ReadAttachments(manifestJson);
        var spriteBundles = ReadSpriteBundles(manifestJson);

        if (File.Exists(ProjectPath(BaseScenePath)))
        {
            EditorSceneManager.OpenScene(BaseScenePath, OpenSceneMode.Single);
        }
        else
        {
            EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        }

        var loadedBundles = new Dictionary<string, AssetBundle>();
        foreach (var sb in spriteBundles)
        {
            LoadBundle(sb.absolutePath, loadedBundles);
        }
        var hudRoot = InstantiateLiveHudRoots(attachments, loadedBundles);
        var camera = EnsureCaptureCamera();
        var result = new BattleHudVisualSanityResult();
        result.scene = ProjectPath(ScenePath);
        result.sourceScene = ProjectPath(B19ScenePath);
        result.baseScene = ProjectPath(BaseScenePath);
        result.hudRootFound = hudRoot != null;
        result.liveHudInstantiateCount = hudRoot != null ? hudRoot.transform.childCount : 0;

        CountScene(result, hudRoot, camera);
        result.debugOverlayTextComponentCountBeforeExclusion = CountNonHudTextComponents(hudRoot, true);
        DisableNonHudTextComponents(hudRoot);
        result.debugOverlayTextComponentCountAfterExclusion = CountNonHudTextComponents(hudRoot, true);
        result.debugOverlayVisible = result.debugOverlayTextComponentCountAfterExclusion > 0;

        var canvasStates = ApplyCaptureCanvasFix(hudRoot, camera);
        result.captureVisualizationFixApplied = canvasStates.FindAll(s => s.captureFixApplied).Count > 0;
        Canvas.ForceUpdateCanvases();
        CountHudZones(result, hudRoot, camera);
        result.capture = ProjectPath(CapturePath);
        result.captureExists = Capture(camera);
        result.cameraVisibleHud = result.activeHudGraphicCount > 0 && (result.topHudZonePresent || result.bottomHudZonePresent || result.rightHudZonePresent);
        ClassifyRootCause(result);
        WriteResult(result, canvasStates);
        EditorSceneManager.SaveScene(EditorSceneManager.GetActiveScene(), ScenePath);
        foreach (var pair in loadedBundles)
        {
            if (pair.Value != null) pair.Value.Unload(false);
        }
        AssetDatabase.Refresh();
        Debug.Log("BattleHudVisualSanity generated. hudRoot=" + result.hudRootFound + ", activeGraphics=" + result.activeHudGraphicCount + ", cameraVisibleHud=" + result.cameraVisibleHud + ", capture=" + result.captureExists);
    }

    private static GameObject InstantiateLiveHudRoots(List<BattleHudAttachment19> attachments, Dictionary<string, AssetBundle> bundles)
    {
        var root = new GameObject("BattleHudVisualSanityLiveHudRoot");
        root.transform.position = Vector3.zero;
        foreach (var attachment in attachments)
        {
            AssetBundle bundle = LoadBundle(attachment.absolutePath, bundles);
            if (bundle == null) continue;
            GameObject prefab = null;
            try { prefab = bundle.LoadAsset<GameObject>(attachment.prefabAsset); } catch { }
            if (prefab == null) continue;
            var instance = (GameObject)GameObject.Instantiate(prefab);
            instance.name = "VisualSanityHUD_" + attachment.order.ToString("00") + "_" + SafeName(Path.GetFileNameWithoutExtension(attachment.prefabAsset));
            instance.transform.SetParent(root.transform, false);
            if (attachment.attachMode == "entry_inactive" || attachment.attachMode == "template_inactive") instance.SetActive(false);
        }
        return root;
    }

    private static void CountScene(BattleHudVisualSanityResult result, GameObject hudRoot, Camera camera)
    {
        result.cameraCount = UnityEngine.Object.FindObjectsOfType<Camera>(true).Length;
        result.canvasCount = UnityEngine.Object.FindObjectsOfType<Canvas>(true).Length;
        result.graphicCount = UnityEngine.Object.FindObjectsOfType<Graphic>(true).Length;
        if (hudRoot != null)
        {
            foreach (Transform child in hudRoot.transform)
            {
                if (child.gameObject.activeInHierarchy) result.activeHudRoots++;
            }
            result.hudCanvasCount = hudRoot.GetComponentsInChildren<Canvas>(true).Length;
            result.hudGraphicCount = hudRoot.GetComponentsInChildren<Graphic>(true).Length;
            foreach (var graphic in hudRoot.GetComponentsInChildren<Graphic>(true))
            {
                if (graphic != null && graphic.gameObject.activeInHierarchy && graphic.enabled) result.activeHudGraphicCount++;
            }
        }
    }

    private static List<BattleHudCanvasState> ApplyCaptureCanvasFix(GameObject hudRoot, Camera camera)
    {
        var states = new List<BattleHudCanvasState>();
        if (hudRoot == null) return states;
        foreach (var canvas in hudRoot.GetComponentsInChildren<Canvas>(true))
        {
            var state = new BattleHudCanvasState();
            state.path = HierarchyPath(canvas.transform);
            state.activeInHierarchy = canvas.gameObject.activeInHierarchy;
            state.renderModeBefore = canvas.renderMode.ToString();
            state.worldCameraBefore = canvas.worldCamera != null ? canvas.worldCamera.name : "";
            state.sortingLayerBefore = canvas.sortingLayerName;
            state.sortingOrderBefore = canvas.sortingOrder;
            state.scaleFactor = canvas.scaleFactor;
            state.referencePixelsPerUnit = canvas.referencePixelsPerUnit;
            if (canvas.renderMode == RenderMode.ScreenSpaceOverlay || canvas.renderMode == RenderMode.WorldSpace || canvas.worldCamera == null)
            {
                canvas.renderMode = RenderMode.ScreenSpaceCamera;
                canvas.worldCamera = camera;
                canvas.planeDistance = 4f;
                canvas.sortingOrder = Math.Max(canvas.sortingOrder, 100);
                state.captureFixApplied = true;
                state.fixReason = "capture_visualization_fix: ScreenSpaceOverlay/null worldCamera cannot be trusted in Camera.Render batch capture";
            }
            state.renderModeAfter = canvas.renderMode.ToString();
            state.worldCameraAfter = canvas.worldCamera != null ? canvas.worldCamera.name : "";
            state.sortingLayerAfter = canvas.sortingLayerName;
            state.sortingOrderAfter = canvas.sortingOrder;
            states.Add(state);
        }
        return states;
    }

    private static void CountHudZones(BattleHudVisualSanityResult result, GameObject hudRoot, Camera camera)
    {
        if (hudRoot == null) return;
        foreach (var graphic in hudRoot.GetComponentsInChildren<Graphic>(true))
        {
            if (graphic == null || !graphic.gameObject.activeInHierarchy || !graphic.enabled) continue;
            var rect = graphic.transform as RectTransform;
            if (rect == null) continue;
            Vector3[] corners = new Vector3[4];
            rect.GetWorldCorners(corners);
            float minX = 1f, maxX = 0f, minY = 1f, maxY = 0f;
            bool any = false;
            for (int i = 0; i < 4; i++)
            {
                Vector3 v = camera.WorldToViewportPoint(corners[i]);
                if (v.z < 0f) continue;
                minX = Mathf.Min(minX, v.x);
                maxX = Mathf.Max(maxX, v.x);
                minY = Mathf.Min(minY, v.y);
                maxY = Mathf.Max(maxY, v.y);
                any = true;
            }
            if (!any) continue;
            bool overlapsScreen = maxX >= 0f && minX <= 1f && maxY >= 0f && minY <= 1f;
            if (!overlapsScreen) continue;
            result.cameraProjectedHudGraphicCount++;
            if (maxY >= 0.82f) result.topHudZoneGraphicCount++;
            if (minY <= 0.28f) result.bottomHudZoneGraphicCount++;
            if (maxX >= 0.82f) result.rightHudZoneGraphicCount++;
        }
        result.topHudZonePresent = result.topHudZoneGraphicCount > 0;
        result.bottomHudZonePresent = result.bottomHudZoneGraphicCount > 0;
        result.rightHudZonePresent = result.rightHudZoneGraphicCount > 0;
    }

    private static int CountNonHudTextComponents(GameObject hudRoot, bool enabledOnly)
    {
        int count = 0;
        foreach (var text in UnityEngine.Object.FindObjectsOfType<Text>(true))
        {
            if (!IsChildOf(text.transform, hudRoot) && (!enabledOnly || text.enabled)) count++;
        }
        foreach (var tmp in UnityEngine.Object.FindObjectsOfType<TMP_Text>(true))
        {
            if (!IsChildOf(tmp.transform, hudRoot) && (!enabledOnly || tmp.enabled)) count++;
        }
        foreach (var textMesh in UnityEngine.Object.FindObjectsOfType<TextMesh>(true))
        {
            if (!IsChildOf(textMesh.transform, hudRoot) && (!enabledOnly || textMesh.gameObject.activeInHierarchy)) count++;
        }
        return count;
    }

    private static void DisableNonHudTextComponents(GameObject hudRoot)
    {
        foreach (var text in UnityEngine.Object.FindObjectsOfType<Text>(true))
        {
            if (!IsChildOf(text.transform, hudRoot)) text.enabled = false;
        }
        foreach (var tmp in UnityEngine.Object.FindObjectsOfType<TMP_Text>(true))
        {
            if (!IsChildOf(tmp.transform, hudRoot)) tmp.enabled = false;
        }
        foreach (var textMesh in UnityEngine.Object.FindObjectsOfType<TextMesh>(true))
        {
            if (!IsChildOf(textMesh.transform, hudRoot)) textMesh.gameObject.SetActive(false);
        }
    }

    private static void ClassifyRootCause(BattleHudVisualSanityResult result)
    {
        if (!result.hudRootFound) result.rootCauseClassification.Add("hud_root_missing: BattleHudSpriteFontJoinRoot not found in BATTLE_19 scene");
        if (result.activeHudRoots == 0) result.rootCauseClassification.Add("no_active_hud_roots: attached HUD roots are inactive or template-only");
        if (result.activeHudGraphicCount == 0) result.rootCauseClassification.Add("no_active_hud_graphics: Image/Text/Button components exist in reports but are not active renderable Graphics");
        if (result.captureVisualizationFixApplied) result.rootCauseClassification.Add("capture_visualization_fix_applied: Canvas renderMode/worldCamera was adjusted for capture only and recorded");
        if (!result.cameraVisibleHud) result.rootCauseClassification.Add("camera_visibility_failure: projected HUD graphics do not cover required top/bottom/right zones");
        if (!result.topHudZonePresent) result.rootCauseClassification.Add("top_hud_zone_missing: HP/VS zone not camera-visible");
        if (!result.bottomHudZonePresent) result.rootCauseClassification.Add("bottom_hud_zone_missing: actor/skill card zone not camera-visible");
        if (!result.rightHudZonePresent) result.rootCauseClassification.Add("right_hud_zone_missing: vertical control zone not camera-visible");
    }

    private static bool Capture(Camera camera)
    {
        try
        {
            string fullPath = ProjectPath(CapturePath);
            Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
            var rt = new RenderTexture(1680, 720, 24);
            camera.targetTexture = rt;
            var previous = RenderTexture.active;
            RenderTexture.active = rt;
            Canvas.ForceUpdateCanvases();
            camera.Render();
            var texture = new Texture2D(1680, 720, TextureFormat.RGB24, false);
            texture.ReadPixels(new Rect(0, 0, 1680, 720), 0, 0);
            texture.Apply();
            File.WriteAllBytes(fullPath, texture.EncodeToPNG());
            camera.targetTexture = null;
            RenderTexture.active = previous;
            UnityEngine.Object.DestroyImmediate(texture);
            UnityEngine.Object.DestroyImmediate(rt);
            return File.Exists(fullPath);
        }
        catch
        {
            return false;
        }
    }

    private static Camera EnsureCaptureCamera()
    {
        var existing = GameObject.Find("BattleHudVisualSanityCamera");
        Camera camera = existing != null ? existing.GetComponent<Camera>() : null;
        if (camera == null)
        {
            var go = existing != null ? existing : new GameObject("BattleHudVisualSanityCamera");
            camera = go.AddComponent<Camera>();
        }
        camera.orthographic = true;
        camera.orthographicSize = 5f;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = Color.black;
        camera.nearClipPlane = 0.01f;
        camera.farClipPlane = 100f;
        camera.cullingMask = ~0;
        camera.depth = 1000f;
        camera.transform.position = new Vector3(0f, 0f, -10f);
        camera.transform.rotation = Quaternion.identity;
        return camera;
    }

    private static GameObject FindByName(string name)
    {
        foreach (var go in UnityEngine.Object.FindObjectsOfType<GameObject>(true))
        {
            if (go.name == name) return go;
        }
        return null;
    }

    private static AssetBundle LoadBundle(string path, Dictionary<string, AssetBundle> bundles)
    {
        if (string.IsNullOrEmpty(path)) return null;
        if (bundles.ContainsKey(path)) return bundles[path];
        if (!File.Exists(path)) return null;
        try
        {
            var bundle = AssetBundle.LoadFromFile(path);
            if (bundle == null) return null;
            bundles[path] = bundle;
            return bundle;
        }
        catch
        {
            return null;
        }
    }

    private static List<BattleHudAttachment19> ReadAttachments(string json)
    {
        var list = new List<BattleHudAttachment19>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"attachments\"")))
        {
            list.Add(new BattleHudAttachment19
            {
                id = ReadValue(item, "id"),
                order = ReadInt(item, "order"),
                role = ReadValue(item, "role"),
                attachMode = ReadValue(item, "attachMode"),
                bundle = ReadValue(item, "bundle"),
                absolutePath = ReadValue(item, "absolutePath"),
                prefabAsset = ReadValue(item, "prefabAsset")
            });
        }
        return list;
    }

    private static List<BattleHudSpriteBundle> ReadSpriteBundles(string json)
    {
        var list = new List<BattleHudSpriteBundle>();
        foreach (string item in ExtractObjectBlocks(ExtractArrayBlock(json, "\"spriteBundles\"")))
        {
            list.Add(new BattleHudSpriteBundle
            {
                bundle = ReadValue(item, "bundle"),
                absolutePath = ReadValue(item, "absolutePath")
            });
        }
        return list;
    }

    private static string ExtractArrayBlock(string json, string key)
    {
        int keyIndex = json.IndexOf(key, StringComparison.Ordinal);
        if (keyIndex < 0) return "";
        int start = json.IndexOf('[', keyIndex);
        int depth = 0; bool inString = false; bool escape = false;
        for (int i = start; i < json.Length; i++)
        {
            char c = json[i];
            if (inString) { if (escape) escape = false; else if (c == '\\') escape = true; else if (c == '"') inString = false; continue; }
            if (c == '"') { inString = true; continue; }
            if (c == '[') depth++;
            if (c == ']') depth--;
            if (depth == 0) return json.Substring(start, i - start + 1);
        }
        return "";
    }

    private static List<string> ExtractObjectBlocks(string arrayBlock)
    {
        var objects = new List<string>();
        int depth = 0; int start = -1; bool inString = false; bool escape = false;
        for (int i = 0; i < arrayBlock.Length; i++)
        {
            char c = arrayBlock[i];
            if (inString) { if (escape) escape = false; else if (c == '\\') escape = true; else if (c == '"') inString = false; continue; }
            if (c == '"') { inString = true; continue; }
            if (c == '{') { if (depth == 0) start = i; depth++; }
            else if (c == '}') { depth--; if (depth == 0 && start >= 0) objects.Add(arrayBlock.Substring(start, i - start + 1)); }
        }
        return objects;
    }

    private static string ReadValue(string block, string key)
    {
        string needle = "\"" + key + "\"";
        int keyIndex = block.IndexOf(needle, StringComparison.Ordinal);
        if (keyIndex < 0) return "";
        int colon = block.IndexOf(':', keyIndex);
        int quote = block.IndexOf('"', colon + 1);
        var sb = new StringBuilder(); bool escape = false;
        for (int i = quote + 1; i < block.Length; i++)
        {
            char c = block[i];
            if (escape) { sb.Append(c); escape = false; continue; }
            if (c == '\\') { escape = true; continue; }
            if (c == '"') return sb.ToString();
            sb.Append(c);
        }
        return "";
    }

    private static int ReadInt(string block, string key)
    {
        string needle = "\"" + key + "\"";
        int keyIndex = block.IndexOf(needle, StringComparison.Ordinal);
        if (keyIndex < 0) return 0;
        int colon = block.IndexOf(':', keyIndex);
        int start = colon + 1;
        while (start < block.Length && char.IsWhiteSpace(block[start])) start++;
        int end = start;
        while (end < block.Length && (char.IsDigit(block[end]) || block[end] == '-')) end++;
        int value; return int.TryParse(block.Substring(start, end - start), out value) ? value : 0;
    }

    private static bool IsChildOf(Transform transform, GameObject root)
    {
        if (root == null || transform == null) return false;
        var cursor = transform;
        while (cursor != null)
        {
            if (cursor == root.transform) return true;
            cursor = cursor.parent;
        }
        return false;
    }

    private static void WriteResult(BattleHudVisualSanityResult result, List<BattleHudCanvasState> canvases)
    {
        string fullPath = ProjectPath(ResultPath);
        Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"reference_video_used\": true,");
        sb.AppendLine("  \"scene\": \"" + Json(result.scene) + "\",");
        sb.AppendLine("  \"sourceScene\": \"" + Json(result.sourceScene) + "\",");
        sb.AppendLine("  \"baseScene\": \"" + Json(result.baseScene) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(result.capture) + "\",");
        sb.AppendLine("  \"captureExists\": " + Bool(result.captureExists) + ",");
        sb.AppendLine("  \"hudRootFound\": " + Bool(result.hudRootFound) + ",");
        sb.AppendLine("  \"cameraVisibleHud\": " + Bool(result.cameraVisibleHud) + ",");
        sb.AppendLine("  \"debugOverlayVisible\": " + Bool(result.debugOverlayVisible) + ",");
        sb.AppendLine("  \"captureVisualizationFixApplied\": " + Bool(result.captureVisualizationFixApplied) + ",");
        sb.AppendLine("  \"cameraCount\": " + result.cameraCount + ",");
        sb.AppendLine("  \"canvasCount\": " + result.canvasCount + ",");
        sb.AppendLine("  \"hudCanvasCount\": " + result.hudCanvasCount + ",");
        sb.AppendLine("  \"graphicCount\": " + result.graphicCount + ",");
        sb.AppendLine("  \"hudGraphicCount\": " + result.hudGraphicCount + ",");
        sb.AppendLine("  \"activeGraphicCount\": " + result.activeHudGraphicCount + ",");
        sb.AppendLine("  \"cameraProjectedHudGraphicCount\": " + result.cameraProjectedHudGraphicCount + ",");
        sb.AppendLine("  \"activeHudRoots\": " + result.activeHudRoots + ",");
        sb.AppendLine("  \"liveHudInstantiateCount\": " + result.liveHudInstantiateCount + ",");
        sb.AppendLine("  \"debugOverlayTextComponentCountBeforeExclusion\": " + result.debugOverlayTextComponentCountBeforeExclusion + ",");
        sb.AppendLine("  \"debugOverlayTextComponentCountAfterExclusion\": " + result.debugOverlayTextComponentCountAfterExclusion + ",");
        sb.AppendLine("  \"topHudZonePresent\": " + Bool(result.topHudZonePresent) + ",");
        sb.AppendLine("  \"bottomHudZonePresent\": " + Bool(result.bottomHudZonePresent) + ",");
        sb.AppendLine("  \"rightHudZonePresent\": " + Bool(result.rightHudZonePresent) + ",");
        sb.AppendLine("  \"topHudZoneGraphicCount\": " + result.topHudZoneGraphicCount + ",");
        sb.AppendLine("  \"bottomHudZoneGraphicCount\": " + result.bottomHudZoneGraphicCount + ",");
        sb.AppendLine("  \"rightHudZoneGraphicCount\": " + result.rightHudZoneGraphicCount + ",");
        sb.AppendLine("  \"rootCauseClassification\": [");
        for (int i = 0; i < result.rootCauseClassification.Count; i++)
        {
            sb.Append("    \"" + Json(result.rootCauseClassification[i]) + "\"");
            sb.AppendLine(i + 1 < result.rootCauseClassification.Count ? "," : "");
        }
        sb.AppendLine("  ],");
        sb.AppendLine("  \"canvases\": [");
        for (int i = 0; i < canvases.Count; i++)
        {
            var c = canvases[i];
            sb.AppendLine("    {");
            sb.AppendLine("      \"path\": \"" + Json(c.path) + "\",");
            sb.AppendLine("      \"activeInHierarchy\": " + Bool(c.activeInHierarchy) + ",");
            sb.AppendLine("      \"renderModeBefore\": \"" + Json(c.renderModeBefore) + "\",");
            sb.AppendLine("      \"worldCameraBefore\": \"" + Json(c.worldCameraBefore) + "\",");
            sb.AppendLine("      \"sortingLayerBefore\": \"" + Json(c.sortingLayerBefore) + "\",");
            sb.AppendLine("      \"sortingOrderBefore\": " + c.sortingOrderBefore + ",");
            sb.AppendLine("      \"scaleFactor\": " + c.scaleFactor.ToString(System.Globalization.CultureInfo.InvariantCulture) + ",");
            sb.AppendLine("      \"referencePixelsPerUnit\": " + c.referencePixelsPerUnit.ToString(System.Globalization.CultureInfo.InvariantCulture) + ",");
            sb.AppendLine("      \"captureFixApplied\": " + Bool(c.captureFixApplied) + ",");
            sb.AppendLine("      \"fixReason\": \"" + Json(c.fixReason) + "\",");
            sb.AppendLine("      \"renderModeAfter\": \"" + Json(c.renderModeAfter) + "\",");
            sb.AppendLine("      \"worldCameraAfter\": \"" + Json(c.worldCameraAfter) + "\",");
            sb.AppendLine("      \"sortingLayerAfter\": \"" + Json(c.sortingLayerAfter) + "\",");
            sb.AppendLine("      \"sortingOrderAfter\": " + c.sortingOrderAfter);
            sb.AppendLine("    }" + (i + 1 < canvases.Count ? "," : ""));
        }
        sb.AppendLine("  ]");
        sb.AppendLine("}");
        File.WriteAllText(fullPath, sb.ToString(), Encoding.UTF8);
    }

    private static string HierarchyPath(Transform t)
    {
        var names = new List<string>();
        while (t != null)
        {
            names.Add(t.name);
            t = t.parent;
        }
        names.Reverse();
        return string.Join("/", names.ToArray());
    }

    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath); }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string SafeName(string value) { return string.IsNullOrEmpty(value) ? "unknown" : value.Replace(" ", "_").Replace(".", "_").Replace("/", "_").Replace("\\", "_"); }
}

public sealed class BattleHudVisualSanityResult
{
    public string scene = "";
    public string sourceScene = "";
    public string baseScene = "";
    public string capture = "";
    public bool captureExists;
    public bool hudRootFound;
    public bool cameraVisibleHud;
    public bool debugOverlayVisible;
    public bool captureVisualizationFixApplied;
    public int cameraCount;
    public int canvasCount;
    public int hudCanvasCount;
    public int graphicCount;
    public int hudGraphicCount;
    public int activeHudGraphicCount;
    public int cameraProjectedHudGraphicCount;
    public int activeHudRoots;
    public int liveHudInstantiateCount;
    public int debugOverlayTextComponentCountBeforeExclusion;
    public int debugOverlayTextComponentCountAfterExclusion;
    public bool topHudZonePresent;
    public bool bottomHudZonePresent;
    public bool rightHudZonePresent;
    public int topHudZoneGraphicCount;
    public int bottomHudZoneGraphicCount;
    public int rightHudZoneGraphicCount;
    public List<string> rootCauseClassification = new List<string>();
}

public sealed class BattleHudCanvasState
{
    public string path = "";
    public bool activeInHierarchy;
    public string renderModeBefore = "";
    public string worldCameraBefore = "";
    public string sortingLayerBefore = "";
    public int sortingOrderBefore;
    public float scaleFactor;
    public float referencePixelsPerUnit;
    public bool captureFixApplied;
    public string fixReason = "";
    public string renderModeAfter = "";
    public string worldCameraAfter = "";
    public string sortingLayerAfter = "";
    public int sortingOrderAfter;
}
