// GirlsWar offline-battle — VIEW CS.YouYou.* stubs.
// Seeded by Claude as compile-OK no-ops so the headless battle (M2) runs without these
// view types erroring. CODEX owns the real M3 implementations (Spine actor playback,
// scene scroll, skill timeline). Extend/replace for M3; keep them compiling.
using System;

namespace YouYou
{
    // Hero actor view (Spine). Headless: no-op. Codex M3: drive SkeletonAnimation.
    public class LuaHeroSprite
    {
        public void Play(string anim) { }
        public void Stop() { }
        public void SetPosition(float x, float y, float z) { }
    }

    // Battle scene scroll/camera. Headless: no-op. Codex M3: camera follow/scroll.
    public class ScrollScene
    {
        public void ScrollTo(float x, float y) { }
        public void Reset() { }
    }

    // Skill/timeline FX (PlayableDirector). Headless: no-op. Codex M3: real timeline.
    public class TimelineEffect
    {
        public object CurrPlayableDirector;
        public int AttackPointCount;
        public bool IsAutoPlay;
        public Action OnStopped;
        public void Stop() { OnStopped?.Invoke(); }
        public void Resume() { }
        public void Play() { }
    }

    // NOTE: YouYou.LuaUnit already exists in Assets/Scripts/LuaUnit.cs (prior stub) — do not
    // redefine here. Same for LuaForm, LuaComBinder.
}
