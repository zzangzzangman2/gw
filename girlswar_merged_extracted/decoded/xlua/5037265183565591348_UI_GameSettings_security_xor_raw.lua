local e
local t
local a
function OnInit(o,o)
Image.onClick:AddListener(btnColse)
toggle_ui_set_30.onValueChanged:AddListener(
function(t)
if t then
e=30
RefreshUIFrameRate()
end
end
)
toggle_ui_set_45.onValueChanged:AddListener(
function(t)
if t then
e=45
RefreshUIFrameRate()
end
end
)
toggle_ui_set_60.onValueChanged:AddListener(
function(t)
if t then
e=60
RefreshUIFrameRate()
end
end
)
toggle_battle_set_30.onValueChanged:AddListener(
function(e)
t=30
RefreshBattleFrameRate()
end
)
toggle_battle_set_45.onValueChanged:AddListener(
function(e)
t=45
RefreshBattleFrameRate()
end
)
toggle_battle_set_60.onValueChanged:AddListener(
function(e)
t=60
RefreshBattleFrameRate()
end
)
toggle_game_quality_1.onValueChanged:AddListener(
function(e)
a=1
RefreshGameQuality()
end
)
toggle_game_quality_2.onValueChanged:AddListener(
function(e)
a=2
RefreshGameQuality()
end
)
end
function OnOpen(o)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
if CS.UnityEngine.Application.platform~=CS.UnityEngine.RuntimePlatform.Android then
LuaUtils.SetActive(toggle_ui_set_45.transform,false)
LuaUtils.SetActive(toggle_battle_set_45.transform,false)
else
LuaUtils.SetActive(toggle_ui_set_45.transform,true)
LuaUtils.SetActive(toggle_battle_set_45.transform,true)
end
e=GetUIFrameRate()
t=GetBattleFrameRate()
a=GetGameQuality()
RefreshUIFrameRate()
RefreshBattleFrameRate()
RefreshGameQuality()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
end
function OnEventNetReconnectSuccess()
GameTools.CloseUIForm(UIFormId.UI_GameSettings)
end
function OnBeforeDestroy()
end
function RefreshUIFrameRate()
LuaUtils.SetToggleValue(toggle_ui_set_30,e==30,false)
LuaUtils.SetToggleValue(toggle_ui_set_45,e==45,false)
LuaUtils.SetToggleValue(toggle_ui_set_60,e==60,false)
SaveUIFrameRate(e)
end
function RefreshBattleFrameRate()
LuaUtils.SetToggleValue(toggle_battle_set_30,t==30,false)
LuaUtils.SetToggleValue(toggle_battle_set_45,t==45,false)
LuaUtils.SetToggleValue(toggle_battle_set_60,t==60,false)
SaveBattleFrameRate(t)
end
function RefreshGameQuality()
LuaUtils.SetToggleValue(toggle_game_quality_1,a==1,false)
LuaUtils.SetToggleValue(toggle_game_quality_2,a==2,false)
SaveGameQuality(a)
end
function btnColse()
GameTools.CloseUIForm(UIFormId.UI_GameSettings)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

