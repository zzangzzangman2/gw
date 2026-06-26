using UnityEngine.UI;

namespace UnityEngine.UI
{
    public class Empty4Raycast : Graphic
    {
        protected override void OnPopulateMesh(VertexHelper vh) { vh.Clear(); }
    }
}
