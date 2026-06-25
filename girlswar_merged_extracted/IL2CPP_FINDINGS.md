# GirlsWar IL2CPP / AssetBundle Findings

## Version

- Package: `com.girlwars.kr`
- XAPK version: `1.0.37` / versionCode `41`
- AppVersion in latest data: `1.0.37`
- ResourceVersion in latest data: `1.0.787`

## AssetBundle loading

- Unity exposes `AssetBundle.LoadFromFile(path, crc, offset)` and `LoadFromFileAsync(path, crc, offset)` in the dumped IL2CPP symbols.
- Game code has `FlatAssetBundleInfoEntity.ResOffset`, `IsEncrypt`, `IsFirstData`, `MD5`, `Size`, `Priority`, `Category`, and `Version`.
- Many `.assetbundle` files do not start with `UnityFS`; they contain a prefix and then a valid `UnityFS` stream.
- The extraction pipeline uses the FlatBuffer `ResOffset` when available, then falls back to scanning for `UnityFS` in the first 1 MiB.
- Example observed before full extraction: `download/ui/uiprefabandres/maininterface.assetbundle` uses offset `2453` and parses into thousands of Unity objects including `RectTransform`.

## XXTEAUtil

- `XXTEAUtil.DecryptByteArray(byte[])` checks prefix `0c 07 08 0d 0b 09` before running the XXTEA + zlib text path.
- Files in the merged winning set with that exact prefix: `0`.
- `SoketKey` bytes from static initialization: `66 78 16 18 58 06 77 58`.
- `ass` key bytes from static initialization: `24 fa 49 9b 10 8d 62 59 29 26 81 67 4b f7 91 eb 36 1f 78 07 49 ca 35 a2 37 d7 b0 a6 49 d3 31 d5 9a 5b 46 86 14 ff 21 cb bc 63 ba 1c 49 fc 94 2f f8 35 d9 46 1f 15 2b 2f 37 54 9d cc 44 d9 77 c4`.
- This path appears to target encrypted text/config payloads, while the current obfuscated AssetBundles are handled by offset loading.

## Important Dump Locations

- Full dump copy: `extracted/il2cpp_dump/`
- Main C# dump: `extracted/il2cpp_dump/dump.cs`
- Script metadata: `extracted/il2cpp_dump/script.json`
- String literals: `extracted/il2cpp_dump/stringliteral.json`

## Parsed Output

- VersionFile FlatBuffer CSVs are in `indexes/versionfile_*.csv`.
- AssetBundle parse status and offsets are in `indexes/assetbundles.csv`.
- UI `RectTransform` positions are in `indexes/ui_recttransforms.csv`.
- UI text fields from MonoBehaviour type trees are in `indexes/ui_texts.csv`.
