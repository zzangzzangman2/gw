using UnityEngine.UI;

namespace Coffee.UIExtensions
{
    public class UIParticle : MaskableGraphic
    {
        protected override void OnPopulateMesh(VertexHelper vh) { vh.Clear(); }
    }
}
