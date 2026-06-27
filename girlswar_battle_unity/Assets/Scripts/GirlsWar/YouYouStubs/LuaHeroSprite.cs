using UnityEngine;

namespace YouYou
{
    public class LuaHeroSprite : MonoBehaviour
    {
        public bool IsMonster;
        public int BaseHeroID;
        public int HeroID;
        public bool IsOurHero;
        public int BattleStationIndex;
        public bool IsSupplementHero;
        public string CurrentAnimation { get; private set; }
        public bool IsLooping { get; private set; }
        public bool IsStopped { get; private set; } = true;

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
            gameObject.SetActive(true);
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
    }
}
