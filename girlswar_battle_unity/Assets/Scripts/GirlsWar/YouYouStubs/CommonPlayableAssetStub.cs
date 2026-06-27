using UnityEngine;
using UnityEngine.Playables;

namespace YouYou.CommonPlayable
{
    public abstract class CommonPlayableAssetStub : PlayableAsset
    {
        public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
        {
            return Playable.Create(graph);
        }
    }
}
