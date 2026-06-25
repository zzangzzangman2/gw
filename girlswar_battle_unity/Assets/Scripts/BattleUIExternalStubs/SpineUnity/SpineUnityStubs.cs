using UnityEngine.UI;

namespace Spine.Unity
{
    public class SkeletonGraphic : MaskableGraphic
    {
        protected override void OnPopulateMesh(VertexHelper vh) { vh.Clear(); }
    }

    public class SkeletonSubmeshGraphic : MaskableGraphic
    {
        protected override void OnPopulateMesh(VertexHelper vh) { vh.Clear(); }
    }
}
