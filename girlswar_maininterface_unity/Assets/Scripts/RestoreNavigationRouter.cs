using UnityEngine;

namespace GirlsWarRestore
{
    public static class RestoreNavigationRouter
    {
        public static void Route(RestoreClickLogger logger)
        {
            if (logger == null)
                return;
            Debug.Log("[GirlsWarRestore][Navigation] component=" + logger.buttonComponentPathId
                + " target=" + logger.buttonName
                + " kind=" + logger.navigationKind
                + " key=" + logger.navigationTargetKey
                + " uiForm=" + logger.navigationTargetUiForm
                + " prefabBundle=" + logger.navigationTargetPrefabBundle
                + " confidence=" + logger.navigationConfidence);
            var loader = Object.FindAnyObjectByType<RestoreNavigationTargetLoader>();
            if (loader != null)
                loader.TryShowFromLogger(logger);
        }
    }
}
