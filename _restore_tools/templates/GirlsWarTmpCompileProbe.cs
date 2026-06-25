using System.IO;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

namespace GirlsWarRestoreTmpProbe
{
    public static class Probe
    {
        public static void Run()
        {
            Directory.CreateDirectory("Assets/RestoreData/reports");
            Directory.CreateDirectory("Assets/Scenes");

            var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
            scene.name = "TmpCompileProbe";

            var canvasGo = new GameObject("Canvas_TMP_Probe", typeof(RectTransform), typeof(Canvas), typeof(CanvasScaler), typeof(GraphicRaycaster));
            var canvas = canvasGo.GetComponent<Canvas>();
            canvas.renderMode = RenderMode.ScreenSpaceOverlay;

            var scaler = canvasGo.GetComponent<CanvasScaler>();
            scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.referenceResolution = new Vector2(1680f, 720f);
            scaler.matchWidthOrHeight = 0.5f;

            var textGo = new GameObject("TextMeshProUGUI_Probe", typeof(RectTransform), typeof(TextMeshProUGUI));
            var textRt = textGo.GetComponent<RectTransform>();
            textRt.SetParent(canvasGo.GetComponent<RectTransform>(), false);
            textRt.anchorMin = new Vector2(0.5f, 0.5f);
            textRt.anchorMax = new Vector2(0.5f, 0.5f);
            textRt.sizeDelta = new Vector2(360f, 80f);

            var tmp = textGo.GetComponent<TextMeshProUGUI>();
            tmp.text = "모험 개최 중 전국";
            tmp.fontSize = 28f;
            tmp.alignment = TextAlignmentOptions.Center;
            tmp.enableWordWrapping = false;
            tmp.raycastTarget = false;
            tmp.color = Color.white;

            EditorSceneManager.SaveScene(scene, "Assets/Scenes/TmpCompileProbe.unity");

            var result = "{"
                + "\"status\":\"tmp_compile_ok\","
                + "\"type\":\"" + typeof(TextMeshProUGUI).FullName + "\","
                + "\"assembly\":\"" + typeof(TextMeshProUGUI).Assembly.GetName().Name + "\","
                + "\"component_created\":true,"
                + "\"scene\":\"Assets/Scenes/TmpCompileProbe.unity\""
                + "}";
            File.WriteAllText("Assets/RestoreData/reports/tmp_compile_probe_result.json", result);
            Debug.Log("[GirlsWarRestore][TMPProbe] " + result);

            AssetDatabase.SaveAssets();
            EditorApplication.Exit(0);
        }
    }
}
