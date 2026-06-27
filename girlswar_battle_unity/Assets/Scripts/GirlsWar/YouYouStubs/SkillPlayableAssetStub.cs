using UnityEngine;
using UnityEngine.Playables;

namespace YouYou.SkillPlayable
{
    public abstract class SkillPlayableAssetStub : PlayableAsset
    {
        public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
        {
            return Playable.Create(graph);
        }
    }
}
