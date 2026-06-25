using UnityEngine;
using UnityEngine.EventSystems;

namespace GirlsWarRestore
{
    public sealed class RestoreClickLogger : MonoBehaviour, IPointerClickHandler
    {
        public string bundle;
        public string loggerKind = "Button";
        public string buttonName;
        public string buttonComponentPathId;
        public string gameObjectPathId;
        public string luaModule;
        public string luaHandler;
        public string luaHandlerConfidence;
        public string luaHandlerEvent;
        public string navigationKind;
        public string navigationTargetKey;
        public string navigationTargetUiForm;
        public string navigationTargetPrefabBundle;
        public string navigationConfidence;
        public bool navigationHarnessConnected;
        public bool logPointerClicks;

        public void LogClick()
        {
            Debug.Log("[GirlsWarRestore][Click] kind=" + loggerKind
                + " bundle=" + bundle
                + " target=" + buttonName
                + " component=" + buttonComponentPathId
                + " gameObject=" + gameObjectPathId
                + " luaModule=" + luaModule
                + " luaHandler=" + luaHandler
                + " luaConfidence=" + luaHandlerConfidence
                + " luaEvent=" + luaHandlerEvent
                + " navKind=" + navigationKind
                + " navTarget=" + navigationTargetKey
                + " navUiForm=" + navigationTargetUiForm
                + " navConfidence=" + navigationConfidence);
            if (navigationHarnessConnected)
                RestoreNavigationRouter.Route(this);
        }

        public void OnPointerClick(PointerEventData eventData)
        {
            if (logPointerClicks)
                LogClick();
        }
    }
}
