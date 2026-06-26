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
        private static Dictionary<string, string> _nameToPath;
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
            set { _decodedRoot = value; _nameToPath = null; }
        }

        public static int IndexCount => Index().Count;

        private static Dictionary<string, string> Index()
        {
            if (_nameToPath != null) return _nameToPath;
            _nameToPath = new Dictionary<string, string>(StringComparer.Ordinal);
            if (!Directory.Exists(DecodedRoot))
            {
                Debug.LogWarning($"[GirlsWarLua] decoded root not found: {DecodedRoot}");
                return _nameToPath;
            }
            const string suffix = "_security_xor_raw.lua";
            foreach (var file in Directory.EnumerateFiles(DecodedRoot, "*" + suffix, SearchOption.AllDirectories))
            {
                var fn = Path.GetFileName(file);
                // strip leading "<digits>_" and trailing suffix -> logical Name
                int us = fn.IndexOf('_');
                if (us < 0) continue;
                var name = fn.Substring(us + 1, fn.Length - (us + 1) - suffix.Length);
                if (!_nameToPath.ContainsKey(name)) _nameToPath[name] = file;
            }
            return _nameToPath;
        }

        /// xLua custom loader. `path` is the require argument (may use '/' or '.').
        public static byte[] Load(ref string path)
        {
            var norm = path.Replace('.', '/');
            var leaf = norm;
            int slash = norm.LastIndexOf('/');
            if (slash >= 0) leaf = norm.Substring(slash + 1);

            var idx = Index();
            if (idx.TryGetValue(leaf, out var file) && File.Exists(file))
            {
                return File.ReadAllBytes(file);
            }
            return null; // let xLua try other loaders / report module not found
        }
    }
}
