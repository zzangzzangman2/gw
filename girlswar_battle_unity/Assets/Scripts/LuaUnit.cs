using System;
using UnityEngine;

namespace YouYou
{
    public class LuaUnit : MonoBehaviour
    {
        public string LuaScriptPath;
        public TextAsset luaScript;
        public LuaComGroup[] m_LuaComGroups;
        [NonSerialized] public bool InitCalled;
        [NonSerialized] public bool OpenCalled;

        public void Init()
        {
            InitCalled = true;
        }

        public void Open()
        {
            OpenCalled = true;
        }

        public void Open(object openData)
        {
            OpenCalled = true;
        }
    }
}
