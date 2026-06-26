using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class Battle73RouteHudRightRailAuditEditor
{
    private const string Prefix = "BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH";
    private const string CandidateScenePath = "Assets/Scenes/Battle72Map11003TrueAspectReprojectionPersistedCandidate.unity";
    private const string SummaryPath = "Assets/RestoreData/battle/BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH_UNITY.json";
    private const string ComponentCsvPath = "Assets/RestoreData/battle/BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH_COMPONENT_STATE_UNITY.csv";

    [MenuItem("GirlsWar/Battle/BATTLE73 Route HUD Right Rail Audit No Patch")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        var result = new Result();
        result.prefix = Prefix;
        result.candidateScenePath = CandidateScenePath;
        result.sceneSaved = false;
        result.canonicalSceneOverwritten = false;
        result.packageImported = false;
        result.manifestModified = false;
        result.runtimeInstrumentationUsed = false;
        result.hudRoutePatched = false;
        result.cardPayloadPatched = false;
        result.actorPayloadPatched = false;

        var rows = new List<Row>();
        if (!File.Exists(ProjectPath(CandidateScenePath)))
        {
            result.status = "blocked_candidate_scene_not_found";
            WriteCsv(ProjectPath(ComponentCsvPath), Header(), rows);
            WriteJson(ProjectPath(SummaryPath), result);
            return;
        }

        var scene = EditorSceneManager.OpenScene(CandidateScenePath, OpenSceneMode.Single);
        result.sceneOpened = scene.IsValid();
        result.sceneDirtyBefore = scene.isDirty;

        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
        {
            string path = TransformPath(transform);
            string focus = FocusGroup(path, transform.name);
            if (focus == "") continue;
            var row = BuildRow(transform, path, focus);
            rows.Add(row);
            result.hudNodesReviewed++;
            if (focus == "right_rail" || focus == "button_or_state_child") result.rightRailNodesReviewed++;
            if (row.hasTmpText) result.tmpRowsReviewed++;
            if (row.hasMask || row.hasRectMask2D || row.hasMaskNamedComponent) result.maskStencilRowsReviewed++;
            result.siblingOrderRowsReviewed++;
        }

        result.status = "battle73_candidate_scene_component_state_exported_no_save";
        result.sceneDirtyAfter = scene.isDirty;
        WriteCsv(ProjectPath(ComponentCsvPath), Header(), rows);
        WriteJson(ProjectPath(SummaryPath), result);
        Debug.Log("BATTLE73 route HUD audit rows=" + rows.Count + " sceneSaved=false dirtyBefore=" + result.sceneDirtyBefore + " dirtyAfter=" + result.sceneDirtyAfter);
    }

    private static Row BuildRow(Transform transform, string path, string focus)
    {
        var go = transform.gameObject;
        var row = new Row();
        row.path = path;
        row.name = transform.name;
        row.parentPath = transform.parent != null ? TransformPath(transform.parent) : "";
        row.focusGroup = focus;
        row.activeSelf = go.activeSelf;
        row.activeInHierarchy = go.activeInHierarchy;
        row.layer = go.layer;
        row.siblingIndex = transform.GetSiblingIndex();
        row.siblingCount = transform.parent != null ? transform.parent.childCount : SceneManager.GetActiveScene().rootCount;
        row.localPosition = Vec3(transform.localPosition);
        row.localScale = Vec3(transform.localScale);
        row.worldPosition = Vec3(transform.position);
        row.missingScriptCount = GameObjectUtility.GetMonoBehavioursWithMissingScriptCount(go);
        row.componentTypes = ComponentTypes(go);

        var rt = transform as RectTransform;
        row.hasRectTransform = rt != null;
        if (rt != null)
        {
            row.anchorMin = Vec2(rt.anchorMin);
            row.anchorMax = Vec2(rt.anchorMax);
            row.pivot = Vec2(rt.pivot);
            row.sizeDelta = Vec2(rt.sizeDelta);
            row.anchoredPosition = Vec2(rt.anchoredPosition);
            row.rect = RectString(rt.rect);
            row.offsetMin = Vec2(rt.offsetMin);
            row.offsetMax = Vec2(rt.offsetMax);
        }

        var canvas = go.GetComponent<Canvas>();
        row.hasCanvas = canvas != null;
        if (canvas != null)
        {
            row.canvasEnabled = canvas.enabled;
            row.canvasRenderMode = canvas.renderMode.ToString();
            row.canvasSortingOrder = canvas.sortingOrder;
            row.canvasOverrideSorting = canvas.overrideSorting;
            row.canvasWorldCamera = canvas.worldCamera != null ? canvas.worldCamera.name : "";
            row.canvasPlaneDistance = canvas.planeDistance.ToString("0.######");
            row.canvasScaleFactor = canvas.scaleFactor.ToString("0.######");
            row.canvasReferencePixelsPerUnit = canvas.referencePixelsPerUnit.ToString("0.######");
            row.canvasPixelRect = RectString(canvas.pixelRect);
        }

        var scaler = go.GetComponent<CanvasScaler>();
        row.hasCanvasScaler = scaler != null;
        if (scaler != null)
        {
            row.canvasScalerUiScaleMode = scaler.uiScaleMode.ToString();
            row.canvasScalerReferenceResolution = Vec2(scaler.referenceResolution);
            row.canvasScalerScreenMatchMode = scaler.screenMatchMode.ToString();
            row.canvasScalerMatchWidthOrHeight = scaler.matchWidthOrHeight.ToString("0.######");
            row.canvasScalerScaleFactor = scaler.scaleFactor.ToString("0.######");
            row.canvasScalerReferencePixelsPerUnit = scaler.referencePixelsPerUnit.ToString("0.######");
        }

        var canvasGroup = go.GetComponent<CanvasGroup>();
        row.hasCanvasGroup = canvasGroup != null;
        if (canvasGroup != null)
        {
            row.canvasGroupAlpha = canvasGroup.alpha.ToString("0.######");
            row.canvasGroupInteractable = canvasGroup.interactable;
            row.canvasGroupBlocksRaycasts = canvasGroup.blocksRaycasts;
            row.canvasGroupIgnoreParentGroups = canvasGroup.ignoreParentGroups;
        }

        var graphic = go.GetComponent<Graphic>();
        row.hasGraphic = graphic != null;
        if (graphic != null)
        {
            row.graphicType = graphic.GetType().FullName;
            row.graphicEnabled = graphic.enabled;
            row.graphicRaycastTarget = graphic.raycastTarget;
            row.graphicColor = ColorString(graphic.color);
            row.graphicAlpha = graphic.color.a.ToString("0.######");
            row.graphicDepth = graphic.depth;
            row.graphicCanvas = graphic.canvas != null ? TransformPath(graphic.canvas.transform) : "";
            row.graphicMaterial = graphic.material != null ? graphic.material.name : "";
            row.canvasRendererCull = graphic.canvasRenderer != null && graphic.canvasRenderer.cull;
            row.canvasRendererCullTransparentMesh = graphic.canvasRenderer != null && graphic.canvasRenderer.cullTransparentMesh;
        }

        var image = go.GetComponent<Image>();
        row.hasImage = image != null;
        if (image != null)
        {
            row.imageSprite = image.sprite != null ? image.sprite.name : "";
            row.imageType = image.type.ToString();
            row.imagePreserveAspect = image.preserveAspect;
            row.imageFillAmount = image.fillAmount.ToString("0.######");
        }

        var button = go.GetComponent<Button>();
        row.hasButton = button != null;
        if (button != null)
        {
            row.buttonEnabled = button.enabled;
            row.buttonInteractable = button.interactable;
            row.buttonTargetGraphicPath = button.targetGraphic != null ? TransformPath(button.targetGraphic.transform) : "";
            row.buttonPersistentListenerCount = button.onClick != null ? button.onClick.GetPersistentEventCount() : 0;
        }

        var tmp = go.GetComponent<TMP_Text>();
        row.hasTmpText = tmp != null;
        if (tmp != null)
        {
            row.tmpText = Truncate(tmp.text, 80);
            row.tmpEnabled = tmp.enabled;
            row.tmpFontSize = tmp.fontSize.ToString("0.######");
            row.tmpEnableAutoSizing = tmp.enableAutoSizing;
            row.tmpFontSizeMin = tmp.fontSizeMin.ToString("0.######");
            row.tmpFontSizeMax = tmp.fontSizeMax.ToString("0.######");
            row.tmpCharacterSpacing = tmp.characterSpacing.ToString("0.######");
            row.tmpWordSpacing = tmp.wordSpacing.ToString("0.######");
            row.tmpLineSpacing = tmp.lineSpacing.ToString("0.######");
            row.tmpAlignment = tmp.alignment.ToString();
            row.tmpFont = tmp.font != null ? tmp.font.name : "";
            row.tmpMaterial = tmp.fontSharedMaterial != null ? tmp.fontSharedMaterial.name : "";
            row.tmpColor = ColorString(tmp.color);
            row.tmpAlpha = tmp.color.a.ToString("0.######");
            row.tmpRaycastTarget = tmp.raycastTarget;
        }

        var mask = go.GetComponent<Mask>();
        row.hasMask = mask != null;
        if (mask != null)
        {
            row.maskEnabled = mask.enabled;
            row.maskShowMaskGraphic = mask.showMaskGraphic;
        }
        var rectMask = go.GetComponent<RectMask2D>();
        row.hasRectMask2D = rectMask != null;
        if (rectMask != null) row.rectMaskEnabled = rectMask.enabled;
        row.hasMaskNamedComponent = HasMaskNamedComponent(go);

        return row;
    }

    private static string FocusGroup(string path, string name)
    {
        if (!path.Contains("CanvasLuaStateHUD_01_ui_normalbattle")) return "";
        if (path.EndsWith("CanvasLuaStateHUD_01_ui_normalbattle") || path.EndsWith("/root_battle")) return "canvas_root";
        if (path.Contains("/root_battle/root_top")) return "top_hud";
        if (path.Contains("/root_opra")) return "right_rail";
        string lower = name.ToLowerInvariant();
        if (lower.Contains("btnauto") || lower.Contains("btntwospeed") || lower.Contains("btnfastskill") || lower.Contains("btnskip") || lower.Contains("btnpause") || lower.Contains("lock") || lower.Contains("new") || lower.Contains("im_on") || lower.Contains("im_off") || lower.Contains("speed") || lower.Contains("skip") || lower.Contains("cutscene"))
            return "button_or_state_child";
        return "";
    }

    private static bool HasMaskNamedComponent(GameObject go)
    {
        foreach (var c in go.GetComponents<Component>())
        {
            if (c == null) continue;
            var name = c.GetType().FullName.ToLowerInvariant();
            if (name.Contains("mask") || name.Contains("stencil")) return true;
        }
        return false;
    }

    private static string ComponentTypes(GameObject go)
    {
        var parts = new List<string>();
        foreach (var c in go.GetComponents<Component>())
            parts.Add(c == null ? "<missing>" : c.GetType().FullName);
        return string.Join(";", parts.ToArray());
    }

    private static string[] Header()
    {
        return new[]
        {
            "path","name","parentPath","focusGroup","activeSelf","activeInHierarchy","layer","siblingIndex","siblingCount","localPosition","localScale","worldPosition","missingScriptCount","componentTypes",
            "hasRectTransform","anchorMin","anchorMax","pivot","sizeDelta","anchoredPosition","rect","offsetMin","offsetMax",
            "hasCanvas","canvasEnabled","canvasRenderMode","canvasSortingOrder","canvasOverrideSorting","canvasWorldCamera","canvasPlaneDistance","canvasScaleFactor","canvasReferencePixelsPerUnit","canvasPixelRect",
            "hasCanvasScaler","canvasScalerUiScaleMode","canvasScalerReferenceResolution","canvasScalerScreenMatchMode","canvasScalerMatchWidthOrHeight","canvasScalerScaleFactor","canvasScalerReferencePixelsPerUnit",
            "hasCanvasGroup","canvasGroupAlpha","canvasGroupInteractable","canvasGroupBlocksRaycasts","canvasGroupIgnoreParentGroups",
            "hasGraphic","graphicType","graphicEnabled","graphicRaycastTarget","graphicColor","graphicAlpha","graphicDepth","graphicCanvas","graphicMaterial","canvasRendererCull","canvasRendererCullTransparentMesh",
            "hasImage","imageSprite","imageType","imagePreserveAspect","imageFillAmount",
            "hasButton","buttonEnabled","buttonInteractable","buttonTargetGraphicPath","buttonPersistentListenerCount",
            "hasTmpText","tmpText","tmpEnabled","tmpFontSize","tmpEnableAutoSizing","tmpFontSizeMin","tmpFontSizeMax","tmpCharacterSpacing","tmpWordSpacing","tmpLineSpacing","tmpAlignment","tmpFont","tmpMaterial","tmpColor","tmpAlpha","tmpRaycastTarget",
            "hasMask","maskEnabled","maskShowMaskGraphic","hasRectMask2D","rectMaskEnabled","hasMaskNamedComponent"
        };
    }

    private static void WriteCsv(string path, string[] header, List<Row> rows)
    {
        var sb = new StringBuilder();
        sb.AppendLine(string.Join(",", header));
        foreach (var row in rows)
        {
            var values = new List<string>();
            var type = typeof(Row);
            foreach (var field in header)
            {
                var info = type.GetField(field);
                object value = info != null ? info.GetValue(row) : "";
                values.Add(Csv(value == null ? "" : value.ToString()));
            }
            sb.AppendLine(string.Join(",", values.ToArray()));
        }
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static string Csv(string value)
    {
        if (value == null) value = "";
        bool quote = value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r");
        value = value.Replace("\"", "\"\"");
        return quote ? "\"" + value + "\"" : value;
    }

    private static void WriteJson(string path, Result result)
    {
        var sb = new StringBuilder();
        sb.Append("{\n");
        Json(sb, "prefix", result.prefix, true);
        Json(sb, "status", result.status, true);
        Json(sb, "candidateScenePath", result.candidateScenePath, true);
        Json(sb, "sceneOpened", result.sceneOpened, true);
        Json(sb, "sceneSaved", result.sceneSaved, true);
        Json(sb, "canonicalSceneOverwritten", result.canonicalSceneOverwritten, true);
        Json(sb, "sceneDirtyBefore", result.sceneDirtyBefore, true);
        Json(sb, "sceneDirtyAfter", result.sceneDirtyAfter, true);
        Json(sb, "packageImported", result.packageImported, true);
        Json(sb, "manifestModified", result.manifestModified, true);
        Json(sb, "runtimeInstrumentationUsed", result.runtimeInstrumentationUsed, true);
        Json(sb, "hudRoutePatched", result.hudRoutePatched, true);
        Json(sb, "cardPayloadPatched", result.cardPayloadPatched, true);
        Json(sb, "actorPayloadPatched", result.actorPayloadPatched, true);
        Json(sb, "hudNodesReviewed", result.hudNodesReviewed, true);
        Json(sb, "rightRailNodesReviewed", result.rightRailNodesReviewed, true);
        Json(sb, "tmpRowsReviewed", result.tmpRowsReviewed, true);
        Json(sb, "maskStencilRowsReviewed", result.maskStencilRowsReviewed, true);
        Json(sb, "siblingOrderRowsReviewed", result.siblingOrderRowsReviewed, false);
        sb.Append("}\n");
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static void Json(StringBuilder sb, string key, string value, bool comma)
    {
        sb.Append("  \"").Append(key).Append("\": ");
        if (value == null) sb.Append("null");
        else sb.Append("\"").Append(value.Replace("\\", "\\\\").Replace("\"", "\\\"")).Append("\"");
        if (comma) sb.Append(",");
        sb.Append("\n");
    }

    private static void Json(StringBuilder sb, string key, bool value, bool comma)
    {
        sb.Append("  \"").Append(key).Append("\": ").Append(value ? "true" : "false");
        if (comma) sb.Append(",");
        sb.Append("\n");
    }

    private static void Json(StringBuilder sb, string key, int value, bool comma)
    {
        sb.Append("  \"").Append(key).Append("\": ").Append(value);
        if (comma) sb.Append(",");
        sb.Append("\n");
    }

    private static string ProjectPath(string assetPath)
    {
        return Path.GetFullPath(Path.Combine(Application.dataPath, "..", assetPath));
    }

    private static string TransformPath(Transform t)
    {
        if (t == null) return "";
        var parts = new List<string>();
        while (t != null)
        {
            parts.Add(t.name);
            t = t.parent;
        }
        parts.Reverse();
        return string.Join("/", parts.ToArray());
    }

    private static string Vec2(Vector2 v) { return v.x.ToString("0.######") + "/" + v.y.ToString("0.######"); }
    private static string Vec3(Vector3 v) { return v.x.ToString("0.######") + "/" + v.y.ToString("0.######") + "/" + v.z.ToString("0.######"); }
    private static string RectString(Rect r) { return r.x.ToString("0.######") + "/" + r.y.ToString("0.######") + "/" + r.width.ToString("0.######") + "/" + r.height.ToString("0.######"); }
    private static string ColorString(Color c) { return c.r.ToString("0.######") + "/" + c.g.ToString("0.######") + "/" + c.b.ToString("0.######") + "/" + c.a.ToString("0.######"); }
    private static string Truncate(string text, int max) { if (text == null) return ""; text = text.Replace("\r", "\\r").Replace("\n", "\\n"); return text.Length <= max ? text : text.Substring(0, max); }

    public sealed class Row
    {
        public string path, name, parentPath, focusGroup, localPosition, localScale, worldPosition, componentTypes;
        public bool activeSelf, activeInHierarchy;
        public int layer, siblingIndex, siblingCount, missingScriptCount;
        public bool hasRectTransform;
        public string anchorMin, anchorMax, pivot, sizeDelta, anchoredPosition, rect, offsetMin, offsetMax;
        public bool hasCanvas, canvasEnabled, canvasOverrideSorting;
        public string canvasRenderMode, canvasWorldCamera, canvasPlaneDistance, canvasScaleFactor, canvasReferencePixelsPerUnit, canvasPixelRect;
        public int canvasSortingOrder;
        public bool hasCanvasScaler;
        public string canvasScalerUiScaleMode, canvasScalerReferenceResolution, canvasScalerScreenMatchMode, canvasScalerMatchWidthOrHeight, canvasScalerScaleFactor, canvasScalerReferencePixelsPerUnit;
        public bool hasCanvasGroup, canvasGroupInteractable, canvasGroupBlocksRaycasts, canvasGroupIgnoreParentGroups;
        public string canvasGroupAlpha;
        public bool hasGraphic, graphicEnabled, graphicRaycastTarget, canvasRendererCull, canvasRendererCullTransparentMesh;
        public string graphicType, graphicColor, graphicAlpha, graphicCanvas, graphicMaterial;
        public int graphicDepth;
        public bool hasImage, imagePreserveAspect;
        public string imageSprite, imageType, imageFillAmount;
        public bool hasButton, buttonEnabled, buttonInteractable;
        public string buttonTargetGraphicPath;
        public int buttonPersistentListenerCount;
        public bool hasTmpText, tmpEnabled, tmpEnableAutoSizing, tmpRaycastTarget;
        public string tmpText, tmpFontSize, tmpFontSizeMin, tmpFontSizeMax, tmpCharacterSpacing, tmpWordSpacing, tmpLineSpacing, tmpAlignment, tmpFont, tmpMaterial, tmpColor, tmpAlpha;
        public bool hasMask, maskEnabled, maskShowMaskGraphic, hasRectMask2D, rectMaskEnabled, hasMaskNamedComponent;
    }

    private sealed class Result
    {
        public string prefix;
        public string status = "not_started";
        public string candidateScenePath;
        public bool sceneOpened, sceneSaved, canonicalSceneOverwritten, sceneDirtyBefore, sceneDirtyAfter;
        public bool packageImported, manifestModified, runtimeInstrumentationUsed, hudRoutePatched, cardPayloadPatched, actorPayloadPatched;
        public int hudNodesReviewed, rightRailNodesReviewed, tmpRowsReviewed, maskStencilRowsReviewed, siblingOrderRowsReviewed;
    }
}
