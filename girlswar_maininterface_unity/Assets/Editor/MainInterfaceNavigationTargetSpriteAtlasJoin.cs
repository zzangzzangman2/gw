using UnityEditor;
using UnityEngine;

namespace GirlsWarRestore
{
    public static class MainInterfaceNavigationTargetSpriteAtlasJoin
    {
        public static void CaptureAfterSpriteAtlasSliceJoin()
        {
            MainInterfaceNavigationTargetCapture.CaptureNavigationTargetLayoutsTo(
                "Assets/RestoreCaptures/navigation_targets_after_sprite_join",
                "Assets/RestoreData/maininterface_navigation_target_sprite_atlas_slice_join_capture.json",
                "Assets/RestoreData/reports/maininterface_navigation_target_sprite_atlas_slice_join_capture.csv");
            AssetDatabase.Refresh();
            Debug.Log("[GirlsWarRestore] MainInterface navigation target sprite atlas slice join capture completed.");
        }
    }
}
