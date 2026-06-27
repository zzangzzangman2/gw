using UnityEngine;
using System.Collections.Generic;

namespace YouYou
{
    public class LuaHeroSprite : MonoBehaviour
    {
        public static readonly List<LuaHeroSprite> OpenedSprites = new List<LuaHeroSprite>();

        public bool IsMonster;
        public int BaseHeroID;
        public int HeroID;
        public bool IsOurHero;
        public int BattleStationIndex;
        public bool IsSupplementHero;
        public Transform Shadow;
        public Renderer ShadowRenderer;
        public object CurrMaterialProperty;
        public object IdleData;
        public string CurrentAnimation { get; private set; }
        public bool IsLooping { get; private set; }
        public bool IsStopped { get; private set; } = true;

        public static void ResetOpenedSprites()
        {
            OpenedSprites.Clear();
        }

        public void Init()
        {
        }

        public void SetData(object data)
        {
        }

        public void SetHeroData(object data)
        {
        }

        public void OnOpen()
        {
            EnsureRuntimePlaceholders();
            gameObject.SetActive(true);
            if (!OpenedSprites.Contains(this))
                OpenedSprites.Add(this);
        }

        public void EnsureRuntimePlaceholders()
        {
            EnsureChild("HeroRoot");
            EnsureChild("PetRoot");
            var shadow = EnsureChild("Shadow");
            Shadow = shadow;
            if (ShadowRenderer == null)
            {
                var renderer = shadow.GetComponent<MeshRenderer>();
                if (renderer == null)
                    renderer = shadow.gameObject.AddComponent<MeshRenderer>();
                ShadowRenderer = renderer;
            }
        }

        public void Play(string animationName)
        {
            Play(animationName, true);
        }

        public void Play(string animationName, bool loop)
        {
            CurrentAnimation = animationName;
            IsLooping = loop;
            IsStopped = false;
        }

        public void PlayAnimation(string animationName)
        {
            Play(animationName, true);
        }

        public void PlayAnimation(string animationName, bool loop)
        {
            Play(animationName, loop);
        }

        public void Stop()
        {
            IsStopped = true;
        }

        public void Reset()
        {
            CurrentAnimation = string.Empty;
            IsLooping = false;
            IsStopped = true;
        }

        public void SetPosition(float x, float y, float z)
        {
            transform.position = new Vector3(x, y, z);
        }

        public void SetPosition(Vector3 position)
        {
            transform.position = position;
        }

        public void SetLocalPosition(float x, float y, float z)
        {
            transform.localPosition = new Vector3(x, y, z);
        }

        public void SetLocalPosition(Vector3 position)
        {
            transform.localPosition = position;
        }

        public void SetScale(float x, float y, float z)
        {
            transform.localScale = new Vector3(x, y, z);
        }

        public void SetLocalScale(float x, float y, float z)
        {
            transform.localScale = new Vector3(x, y, z);
        }

        public void SetActive(bool active)
        {
            gameObject.SetActive(active);
        }

        public void Show()
        {
            SetActive(true);
        }

        public void Hide()
        {
            SetActive(false);
        }

        public void SetFlipX(bool flip)
        {
            Vector3 scale = transform.localScale;
            float x = Mathf.Abs(scale.x);
            scale.x = flip ? -x : x;
            transform.localScale = scale;
        }

        public void SetMirror(bool mirror)
        {
            SetFlipX(mirror);
        }

        public void SetSortingOrder(int sortingOrder)
        {
        }

        public void Dispose()
        {
        }

        private Transform EnsureChild(string childName)
        {
            var child = transform.Find(childName);
            if (child != null) return child;

            var go = new GameObject(childName);
            go.transform.SetParent(transform, false);
            return go.transform;
        }
    }
}
