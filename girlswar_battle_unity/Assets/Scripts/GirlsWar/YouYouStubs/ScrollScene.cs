using System;
using UnityEngine;

namespace YouYou
{
    public class ScrollScene : MonoBehaviour
    {
        public int PreloadCount { get; private set; }
        public bool LastMoveForward { get; private set; }
        public float LastMoveDuration { get; private set; }
        public Action OnMoveComplete;

        public void SetPreloadCount(int count)
        {
            PreloadCount = count;
        }

        public void Move(bool forward, float duration)
        {
            LastMoveForward = forward;
            LastMoveDuration = duration;
            OnMoveComplete?.Invoke();
        }

        public void ScrollTo(float x, float y)
        {
            transform.localPosition = new Vector3(x, y, transform.localPosition.z);
            OnMoveComplete?.Invoke();
        }

        public void Reset()
        {
            PreloadCount = 0;
            LastMoveForward = false;
            LastMoveDuration = 0f;
        }
    }
}
