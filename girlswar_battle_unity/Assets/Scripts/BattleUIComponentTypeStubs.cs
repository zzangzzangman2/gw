using UnityEngine;
using UnityEngine.UI;

namespace YouYou
{
    public class YouYouImage : Image { }
    public class UIEventListener : MonoBehaviour { }
    public class ClickBase : MonoBehaviour { }
    public class LuaForm : MonoBehaviour { }
    public class LuaUnit : MonoBehaviour { }
    public class GuideNode : MonoBehaviour { }
    public class UISpineCtr : MonoBehaviour { }
    public class LookRotation : MonoBehaviour { }
    public class EffectScale : MonoBehaviour { }
    public class FullscreenCenter : MonoBehaviour { }
}

namespace LuaComponentBinder
{
    public class LuaComBinder : MonoBehaviour { }
}

namespace UnityEngine.UI
{
    public class Empty4Raycast : Graphic
    {
        protected override void OnPopulateMesh(VertexHelper vh) { vh.Clear(); }
    }
}

namespace SuperScrollView
{
    public class LoopListView2 : MonoBehaviour { }
}
