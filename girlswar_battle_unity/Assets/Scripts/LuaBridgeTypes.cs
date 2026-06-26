using System;
using UnityEngine;

namespace YouYou
{
    [Serializable]
    public class LuaCom
    {
        public string Name;
        public int Type;
        public UnityEngine.Object ComObj;
    }

    [Serializable]
    public class LuaComGroup
    {
        public string Name;
        public LuaCom[] LuaComs;
    }
}
