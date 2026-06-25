function OnInit(e,e)
Image.onClick:AddListener(function()
closeView()
end)
inputAcc.onValueChanged:AddListener(function(e)
if e then
end
end)
btn_queren.onClick:AddListener(OnBtnChangeName)
btn_queren_free.onClick:AddListener(OnBtnChangeName)
btn_quxiao.onClick:AddListener(closeView)
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnPlayerChangeName,onPlayerChangeName)
EventSystem.AddListener(CommonEventId.OnPlayCurrencyRefresh,Refresh)
LuaUtils.SetActive(btn_queren_free.transform,PlayerMgr.PlayerInfo.changeNameCount<=0)
inputAcc.text=""
LuaUtils.SetTextMeshText(text_num,Constant.player_rename_cost[2])
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnPlayerChangeName,onPlayerChangeName)
EventSystem.RemoveListener(CommonEventId.OnPlayCurrencyRefresh,Refresh)
end
function OnBeforeDestroy()
end
function Refresh()
local e=Color.white
if PlayerMgr:getCurrencyCount(Constant.player_rename_cost[1])<Constant.player_rename_cost[2]then
e=DefaultColor.red
end
text_num.color=e
end
function OnBtnChangeName()
local t=inputAcc.text or""
if t==""then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Setting.Profile.20",LanguageCategory.LangCommon))
return
end
local e=UIUtil.TestHasChar(test_name,inputAcc.text,test_name2)
if e==false then
UIUtil.ShowCommonTips(GameTools.GetLocalize("tips.common_83",LanguageCategory.LangCommon))
return
end
if PlayerMgr.PlayerInfo.changeNameCount>0 then
local e=Constant.player_rename_cost
local t=ModulesInit.BagManager:GetItemCountById(e[1])
if t<e[2]then
GameTools:GotoWays({id=e[1]})
return
end
end
PlayerMgr:sendChangeName(t)
end
function onPlayerChangeName()
closeView()
end
function closeView()
GameTools.CloseUIForm(UIFormId.UI_PlayerChangeName)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

