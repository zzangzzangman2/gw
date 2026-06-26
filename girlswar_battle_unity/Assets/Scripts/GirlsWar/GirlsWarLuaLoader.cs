// GirlsWar offline battle runtime — custom xLua loader.
//
// Resolves require("A/B/C/Name") to the already-decoded Lua source under
// <repo>/girlswar_merged_extracted/decoded/{xlua,xlua_battle,...}. The decode step
// (XOR-22) was already run by battle_extract_decode_xlua.py / try_maininterface_xlua_decode.py,
// so these files are plaintext Lua named "<pathId>_<Name>_security_xor_raw.lua".
//
// Leaf names were verified globally unique across all 4,492 decoded files, so a
// leaf-name -> file map is an unambiguous resolver for the 4,357 distinct require paths.
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;

namespace GirlsWar
{
    public static class GirlsWarLuaLoader
    {
        private static Dictionary<string, List<string>> _nameToPaths;
        private static string _decodedRoot;

        // <repo>/girlswar_merged_extracted/decoded  (dataPath = <repo>/girlswar_battle_unity/Assets)
        public static string DecodedRoot
        {
            get
            {
                if (_decodedRoot == null)
                {
                    _decodedRoot = Path.GetFullPath(Path.Combine(
                        Application.dataPath, "..", "..",
                        "girlswar_merged_extracted", "decoded"));
                }
                return _decodedRoot;
            }
            set { _decodedRoot = value; _nameToPaths = null; }
        }

        public static int IndexCount => Index().Count;

        private static Dictionary<string, List<string>> Index()
        {
            if (_nameToPaths != null) return _nameToPaths;
            _nameToPaths = new Dictionary<string, List<string>>(StringComparer.Ordinal);
            if (!Directory.Exists(DecodedRoot))
            {
                Debug.LogWarning($"[GirlsWarLua] decoded root not found: {DecodedRoot}");
                return _nameToPaths;
            }
            const string suffix = "_security_xor_raw.lua";
            foreach (var file in Directory.EnumerateFiles(DecodedRoot, "*" + suffix, SearchOption.AllDirectories))
            {
                var fn = Path.GetFileName(file);
                int us = fn.IndexOf('_'); // strip "<pathId>_" prefix and suffix -> logical Name
                if (us < 0) continue;
                var name = fn.Substring(us + 1, fn.Length - (us + 1) - suffix.Length);
                if (!_nameToPaths.TryGetValue(name, out var list))
                    _nameToPaths[name] = list = new List<string>();
                list.Add(file);
            }
            return _nameToPaths;
        }

        /// xLua custom loader. `path` is the require argument (may use '/' or '.').
        /// Path-aware: among files sharing a leaf name, prefers the one whose decoded
        /// directory matches the require path's directory (handles re-decode duplicates and
        /// genuine same-leaf collisions across bundles). The xlua_all tree mirrors the
        /// original require paths (Common/Global -> .../xlua_all/common/..._Global_...).
        public static byte[] Load(ref string path)
        {
            var norm = path.Replace('.', '/');
            int slash = norm.LastIndexOf('/');
            var leaf = slash >= 0 ? norm.Substring(slash + 1) : norm;
            var reqDir = slash >= 0 ? norm.Substring(0, slash).ToLowerInvariant() : "";

            var idx = Index();
            if (!idx.TryGetValue(leaf, out var candidates) || candidates.Count == 0)
                return null;

            string chosen = candidates[0];
            if (candidates.Count > 1 && reqDir.Length > 0)
            {
                foreach (var c in candidates)
                {
                    var dir = Path.GetDirectoryName(c).Replace('\\', '/').ToLowerInvariant();
                    if (dir.EndsWith("/" + reqDir) || dir.EndsWith(reqDir))
                    {
                        chosen = c;
                        break;
                    }
                }
            }
            return File.Exists(chosen) ? File.ReadAllBytes(chosen) : null;
        }
    }
}
