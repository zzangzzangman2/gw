using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace YouYou
{
    public enum LuaComType
    {
        GameObject = 0,
        Transform = 1,
        RectTransform = 2,
        Text = 3,
        Image = 4,
        Button = 5,
        YouYouImage = 6,
        Other = 99
    }

    [Serializable]
    public sealed class LuaCom
    {
        public string Name;
        public LuaComType Type;
        public UnityEngine.Object ComObj;
    }

    [Serializable]
    public sealed class LuaComGroup
    {
        public string Name;
        public LuaCom[] LuaComs;
    }

    public class UIFormBase : MonoBehaviour
    {
        public int UIFormId { get; set; }
        public object UserData { get; set; }
        public Canvas CurrCanvas { get; set; }
        public CanvasGroup CurrCanvasGroup { get; set; }
    }

    public class LuaForm : UIFormBase
    {
        public string LuaScriptPath;
        public TextAsset luaScript;
        [SerializeField] private LuaComGroup[] m_LuaComGroups;

        public LuaComGroup[] LuaComGroups => m_LuaComGroups;
    }

    public class LuaUnit : MonoBehaviour
    {
        public int UIFormId { get; set; }
        public object UserData { get; set; }
        public string LuaScriptPath;
        public TextAsset luaScript;
        [SerializeField] private LuaComGroup[] m_LuaComGroups;

        public LuaComGroup[] LuaComGroups => m_LuaComGroups;
    }

    public class YouYouImage : Image
    {
        [SerializeField] private string m_Localization;
        [SerializeField] private int m_Category;
        [SerializeField] private bool m_OverrideUvRect;
        [SerializeField] private string m_LoadSpriteName;
        [SerializeField] private string _CurrentSpritePath;
        [SerializeField] private string _CurrentMaterialPath;
        [SerializeField] private Texture _CurrentTexture;
        [SerializeField] private string _CurrentTexturePath;

        public string CurrentSpritePath => _CurrentSpritePath;
        public string CurrentMaterialPath => _CurrentMaterialPath;
    }

    public class YouYouCanvasHelper : MonoBehaviour
    {
        [SerializeField] private int m_Depth;
        public int Depth => m_Depth;
    }

    public class UISpineCtr : MonoBehaviour
    {
        public void SetTimeScale(float timeScale) { }
    }

    public class FullscreenCenter : MonoBehaviour { }

    public class GuideNode : MonoBehaviour
    {
        [SerializeField] private string pageId;
        [SerializeField] private LuaCom[] m_LuaCom;
    }

    public class UIAniTrigger : MonoBehaviour { }

    public class ToggleEx : MonoBehaviour
    {
        public Toggle toggle;
        public GameObject active;
        public GameObject notActive;
    }

    public class UIEventListener : MonoBehaviour,
        IPointerEnterHandler,
        IPointerExitHandler,
        IPointerDownHandler,
        IPointerUpHandler,
        IPointerClickHandler,
        IUpdateSelectedHandler,
        ISelectHandler
    {
        public delegate void VoidDelegate(GameObject go);
        public delegate void ToggleDelegate(GameObject go, bool value);
        public delegate void EventDelegate(GameObject go, PointerEventData eventData);

        public VoidDelegate onClick;
        public VoidDelegate onDown;
        public VoidDelegate onEnter;
        public VoidDelegate onExit;
        public VoidDelegate onUp;
        public VoidDelegate onSelect;
        public VoidDelegate onUpdateSelect;
        public ToggleDelegate onToggleChange;
        public EventDelegate onPointerDown;
        public EventDelegate onPointerUp;
        public EventDelegate onDraging;

        public void OnPointerEnter(PointerEventData eventData) => onEnter?.Invoke(gameObject);
        public void OnPointerExit(PointerEventData eventData) => onExit?.Invoke(gameObject);
        public void OnPointerDown(PointerEventData eventData)
        {
            onDown?.Invoke(gameObject);
            onPointerDown?.Invoke(gameObject, eventData);
        }
        public void OnPointerUp(PointerEventData eventData)
        {
            onUp?.Invoke(gameObject);
            onPointerUp?.Invoke(gameObject, eventData);
        }
        public void OnPointerClick(PointerEventData eventData) => onClick?.Invoke(gameObject);
        public void OnUpdateSelected(BaseEventData eventData) => onUpdateSelect?.Invoke(gameObject);
        public void OnSelect(BaseEventData eventData) => onSelect?.Invoke(gameObject);
    }

    public class TouchEventTransfer : MonoBehaviour, IPointerClickHandler, IPointerDownHandler, IPointerUpHandler
    {
        public void OnPointerClick(PointerEventData eventData) { }
        public void OnPointerDown(PointerEventData eventData) { }
        public void OnPointerUp(PointerEventData eventData) { }
    }

    public class ClickRichText : Text { }
}

namespace LuaComponentBinder
{
    using YouYou;

    public class LuaComBinder : MonoBehaviour
    {
        public LuaCom[] LuaComs;
        public object UserObjectData { get; set; }

        public UnityEngine.Object GetComponentByName(string name)
        {
            if (LuaComs == null)
            {
                return null;
            }
            foreach (var item in LuaComs)
            {
                if (item != null && item.Name == name)
                {
                    return item.ComObj;
                }
            }
            return null;
        }

        public Dictionary<string, UnityEngine.Object> GetComponents()
        {
            var result = new Dictionary<string, UnityEngine.Object>(StringComparer.Ordinal);
            if (LuaComs == null)
            {
                return result;
            }
            foreach (var item in LuaComs)
            {
                if (item != null && !string.IsNullOrEmpty(item.Name))
                {
                    result[item.Name] = item.ComObj;
                }
            }
            return result;
        }
    }
}

namespace SuperScrollView
{
    public class LoopListViewItem2 : MonoBehaviour
    {
        public object UserObjectData { get; set; }
        public int ItemIndex { get; set; }
    }

    public class LoopListView2 : MonoBehaviour, IBeginDragHandler, IEndDragHandler, IDragHandler
    {
        public RectTransform content;
        public RectTransform viewport;
        public ScrollRect scrollRect;

        public void InitListView(int itemTotalCount, Func<LoopListView2, int, LoopListViewItem2> onGetItemByIndex) { }
        public void SetListItemCount(int itemTotalCount) { }
        public void RefreshAllShownItem() { }
        public void OnBeginDrag(PointerEventData eventData) { }
        public void OnEndDrag(PointerEventData eventData) { }
        public void OnDrag(PointerEventData eventData) { }
    }

    public class LoopStaggeredGridView : MonoBehaviour, IBeginDragHandler, IEndDragHandler, IDragHandler
    {
        public RectTransform content;
        public RectTransform viewport;
        public ScrollRect scrollRect;

        public void OnBeginDrag(PointerEventData eventData) { }
        public void OnEndDrag(PointerEventData eventData) { }
        public void OnDrag(PointerEventData eventData) { }
    }
}

namespace UnityEngine.UI
{
    public class Empty4Raycast : MaskableGraphic
    {
        protected override void OnPopulateMesh(VertexHelper toFill)
        {
            toFill.Clear();
        }
    }
}
