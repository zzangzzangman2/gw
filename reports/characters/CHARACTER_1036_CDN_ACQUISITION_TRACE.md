# CHARACTER_1036_CDN_ACQUISITION_TRACE

- Classification: `not_fetchable_from_local_evidence`
- Target bundle: `download/roleprefabsandres/battleprefabandres/1036.assetbundle`
- Target md5/size/encrypt/offset: `570c8238257cd8ca00a0856427d8c0ae` / `1666251` / `True` / `224`
- Download/HEAD/GET executed: `False`

## Local Acquisition Trace
- Exact local file exists: `False`
- CDNVersionFile/VersionFile target rows: `1`
- Same filename non-target files: `6`

| check | path | exists/target | size | md5 | note |
| --- | --- | --- | ---: | --- | --- |
| local_exact_path | `girlswar_merged_extracted/merged_content/AssetBundles/download/roleprefabsandres/battleprefabandres/1036.assetbundle` | `False` |  | `` | missing |
| local_exact_path | `girlswar_merged_extracted/restore_overlay/Android/data/com.girlwars.kr/files/download/roleprefabsandres/battleprefabandres/1036.assetbundle` | `False` |  | `` | missing |
| local_exact_path | `girlswar_merged_extracted/restore_overlay/Android/data/com.girlwars.kr/files/build/download/roleprefabsandres/battleprefabandres/1036.assetbundle` | `False` |  | `` | missing |
| local_exact_path | `girlswar_merged_extracted/extracted/unity/clean_unityfs_slices/download/roleprefabsandres/battleprefabandres/1036.assetbundle` | `False` |  | `` | missing |
| local_exact_path | `girlswar_merged_extracted/extracted/unity/bundles/download/roleprefabsandres/battleprefabandres/1036.assetbundle` | `False` |  | `` | missing |
| local_exact_path | `girlswar_merged_extracted/split_apks/download/roleprefabsandres/battleprefabandres/1036.assetbundle` | `False` |  | `` | missing |
| same_filename | `girlswar_merged_extracted/extracted/unity/clean_unityfs_slices/download/roleprefabsandres/rolebigsetpainting/1036.assetbundle` | `False` | 1823276 | `0b9b8e6d04cf4bc45046b601960ed24c` | same filename; path must not be treated as target unless exact |
| same_filename | `girlswar_merged_extracted/extracted/unity/clean_unityfs_slices/download/skillprefabsandres/1036.assetbundle` | `False` | 341520 | `1dd429ec8c32f7806bd0159500681cee` | same filename; path must not be treated as target unless exact |
| same_filename | `girlswar_merged_extracted/merged_content/AssetBundles/download/roleprefabsandres/rolebigsetpainting/1036.assetbundle` | `False` | 1825731 | `14114e8e96837ed386327c7cc86b8fe3` | same filename; path must not be treated as target unless exact |
| same_filename | `girlswar_merged_extracted/merged_content/AssetBundles/download/skillprefabsandres/1036.assetbundle` | `False` | 345333 | `96d14a9638ea63431dfe928d5937a852` | same filename; path must not be treated as target unless exact |
| same_filename | `girlswar_merged_extracted/restore_overlay/Android/data/com.girlwars.kr/files/build/download/roleprefabsandres/rolebigsetpainting/1036.assetbundle` | `False` | 1825731 | `14114e8e96837ed386327c7cc86b8fe3` | same filename; path must not be treated as target unless exact |
| same_filename | `girlswar_merged_extracted/restore_overlay/Android/data/com.girlwars.kr/files/build/download/skillprefabsandres/1036.assetbundle` | `False` | 345333 | `96d14a9638ea63431dfe928d5937a852` | same filename; path must not be treated as target unless exact |

## URL Evidence
- Candidate asset CDN URLs: `0`
- Login/account URLs: `2`
- Other URLs: `212`

No candidate asset CDN URL/build rule was proven from local evidence.

### Login/Account URLs
| classification | domain | url | source |
| --- | --- | --- | --- |
| `login_or_account_url` | `girlwars-kr-login.tianlonginc.com` | `http://girlwars-kr-login.tianlonginc.com/bigdAccServer/` | `work/apk_probe/data.unity3d` |
| `login_or_account_url` | `dev.next-1b.com` | `http://dev.next-1b.com:8081/bigdAccServer/0` | `work/apk_probe/data.unity3d` |

## Download Assessment
- HEAD/GET ready: `False`
- Reason: No asset CDN base URL/build rule was strong enough to combine with path+md5+size. Login/account URLs are explicitly not used for asset download.

## Outputs
- JSON: `reports/characters/CHARACTER_1036_CDN_ACQUISITION_TRACE.json`
- CSV: `reports/characters/CHARACTER_1036_CDN_ACQUISITION_TRACE.csv`
