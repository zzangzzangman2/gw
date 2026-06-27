using UnityEngine;

namespace YouYou
{
    public static class LuaUtils
    {
        public static void SetActive(object target, bool active)
        {
            var go = ToGameObject(target);
            if (go != null) go.SetActive(active);
        }

        public static void SetParent(object target, object parent)
        {
            var transform = ToTransform(target);
            var parentTransform = ToTransform(parent);
            if (transform != null) transform.SetParent(parentTransform, false);
        }

        public static void SetLocalPos(object target, float x, float y, float z)
        {
            var transform = ToTransform(target);
            if (transform != null) transform.localPosition = new Vector3(x, y, z);
        }

        public static void SetPos(object target, float x, float y, float z)
        {
            var transform = ToTransform(target);
            if (transform != null) transform.position = new Vector3(x, y, z);
        }

        public static void SetLocalScale(object target, float x, float y, float z)
        {
            var transform = ToTransform(target);
            if (transform != null) transform.localScale = new Vector3(x, y, z);
        }

        public static void SetLocalEulerAngles(object target, float x, float y, float z)
        {
            var transform = ToTransform(target);
            if (transform != null) transform.localEulerAngles = new Vector3(x, y, z);
        }

        public static void SetRotation(object target, float x, float y, float z)
        {
            var transform = ToTransform(target);
            if (transform != null) transform.rotation = Quaternion.Euler(x, y, z);
        }

        public static void Rotate(object target, float x, float y, float z)
        {
            var transform = ToTransform(target);
            if (transform != null) transform.Rotate(x, y, z);
        }

        public static void SetLayer(object target, object layer)
        {
            var go = ToGameObject(target);
            if (go != null) go.layer = 0;
        }

        public static void GetLocalPos(object target, out float x, out float y, out float z)
        {
            var transform = ToTransform(target);
            var value = transform != null ? transform.localPosition : Vector3.zero;
            x = value.x;
            y = value.y;
            z = value.z;
        }

        public static void GetLocalScale(object target, out float x, out float y, out float z)
        {
            var transform = ToTransform(target);
            var value = transform != null ? transform.localScale : Vector3.one;
            x = value.x;
            y = value.y;
            z = value.z;
        }

        public static int GetChildrenCount(object target)
        {
            var transform = ToTransform(target);
            return transform != null ? transform.childCount : 0;
        }

        public static int GetInstanceID(object target)
        {
            var obj = ToObject(target);
            return obj != null ? obj.GetInstanceID() : 0;
        }

        public static GameObject Instantiate(object target)
        {
            var go = ToGameObject(target);
            if (go != null) return Object.Instantiate(go);
            return new GameObject("LuaUtils_Instantiate");
        }

        public static object GetLuaComBinder(object target)
        {
            return GirlsWar.LuaNoopHolder.N;
        }

        public static string GetFileText(string path)
        {
            return "";
        }

        public static object DoTweenDLocalPosMoveX(params object[] args) { return GirlsWar.LuaNoopHolder.N; }
        public static object DoTweenLocalPosMove(params object[] args) { return GirlsWar.LuaNoopHolder.N; }
        public static object StartUIBlur(params object[] args) { return GirlsWar.LuaNoopHolder.N; }
        public static void DisposeBlur(params object[] args) { }
        public static void SetBlurToImage(params object[] args) { }
        public static void SetImageColor(params object[] args) { }
        public static void SetImageSprite(params object[] args) { }
        public static void SetLabelText(params object[] args) { }
        public static void SetTextMeshText(params object[] args) { }
        public static void SetChildrenActive(params object[] args) { }
        public static void SetChildActive(params object[] args) { }
        public static void AnimtorPlay(params object[] args) { }
        public static void SetMaterialPropertyFloat(params object[] args) { }
        public static void MaterialDoTweenToAlpha(params object[] args) { }
        public static void SpriteRendererDoTweenToAlpha(params object[] args) { }
        public static object GetParticleRendersInChildren(params object[] args) { return GirlsWar.LuaNoopHolder.N; }
        public static object GetSpriteRendersInChildren(params object[] args) { return GirlsWar.LuaNoopHolder.N; }
        public static void YieldGameObjectPoolDespawn(params object[] args) { }

        private static Transform ToTransform(object target)
        {
            if (target is Transform transform) return transform;
            if (target is GameObject gameObject) return gameObject.transform;
            if (target is Component component) return component.transform;
            return null;
        }

        private static GameObject ToGameObject(object target)
        {
            if (target is GameObject gameObject) return gameObject;
            if (target is Transform transform) return transform.gameObject;
            if (target is Component component) return component.gameObject;
            return null;
        }

        private static Object ToObject(object target)
        {
            if (target is Object obj) return obj;
            return ToGameObject(target);
        }
    }
}
