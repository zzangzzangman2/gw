using System;
using UnityEngine;
using UnityEngine.Playables;

namespace YouYou
{
    public class TimelineEffect : MonoBehaviour
    {
        public PlayableDirector CurrPlayableDirector;
        public int AttackPointCount;
        public bool IsAutoPlay;
        public Action OnStopped;
        public bool IsPaused { get; private set; }
        public bool IsPlaying { get; private set; }
        public int LastGotoPointId { get; private set; }

        public void PlayTimeLine()
        {
            Play();
        }

        public void Play()
        {
            IsPlaying = true;
            IsPaused = false;
            CurrPlayableDirector?.Play();
        }

        public void Pause()
        {
            IsPaused = true;
            CurrPlayableDirector?.Pause();
        }

        public void Resume()
        {
            IsPaused = false;
            if (CurrPlayableDirector != null)
            {
                CurrPlayableDirector.Resume();
            }
        }

        public void Stop()
        {
            IsPlaying = false;
            IsPaused = false;
            CurrPlayableDirector?.Stop();
            OnStopped?.Invoke();
        }

        public void GoToPoint(int pointId)
        {
            LastGotoPointId = pointId;
        }

        public void GoToPoint(float pointId)
        {
            GoToPoint((int)pointId);
        }

        public void GoToPoint(double pointId)
        {
            GoToPoint((int)pointId);
        }

        public void SetSkipByPass(bool skip)
        {
        }
    }
}
