local e=require('DataNode/DataTable/Create/shop/DTExchangeGoldDBModel')
local o=require('DataNode/DataTable/Create/vip/DTVipDBModel')
local e=require('DataNode/DataTable/Create/shop/DTExchangeGoldRateDBModel')
local a=require("DataNode/DataManager/DataMgr/DataUtil")
local t
local e
function OnInit(e,e)
Image.onClick:AddListener(closeUI)
btn_once.onClick:AddListener(btnBuyOnce)
btn_all.onClick:AddListener(btnBuyAll)
btn_wenhao.onClick:AddListener(btnGotoVip2)
but_closeVip.onClick:AddListener(function()
LuaUtils.SetActive(bg_ditu.transform,false)
end)
if GameEntry.IsCommittee then
LuaUtils.SetActive(btn_wenhao.transform,false)
LuaUtils.SetActive(im_vip.transform,false)
end
end
function OnOpen(e)
local e=PlayerMgr.PlayerInfo.vip or 0
local e=o.GetEntity(e)
t=e.goldBuyTimes
refreshView()
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
end
function OnEventNetReconnectSuccess()
closeUI()
end
function OnBeforeDestroy()
end
function refreshView()
local o,i=a:GetNextChangeInfo(PlayerMgr.PlayerInfo.buyGoldCount+1)
local a=a:GetNextChangeRate()
LuaUtils.SetLabelText(text_hc_count,o[2])
LuaUtils.SetLabelText(text_gold_count,i[2]*a)
local a=PlayerMgr.PlayerInfo.vip or 0
GameTools:SetImageSprite(im_vip,"ActNormalFrame/T_shangdian"..a)
e=t-PlayerMgr.PlayerInfo.buyGoldCount
if e<=0 then
LuaUtils.SetLabelText(text_residue_count,UIUtil.GetRedTichText(e).."/"..t)
UIUtil.SetGray(btn_once.transform,true,false,false)
UIUtil.SetGray(btn_all.transform,true,false,false)
else
LuaUtils.SetLabelText(text_residue_count,e.."/"..t)
UIUtil.SetGray(btn_once.transform,false,false,false)
UIUtil.SetGray(btn_all.transform,false,false,false)
end
end
function buyCallBack()
e=t-PlayerMgr.PlayerInfo.buyGoldCount
refreshView()
end
function btnBuyOnce()
if e<=0 then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Homepage.Tips.09",LanguageCategory.LangCommon))
return false
end
local e,t=a:GetNextChangeInfo(PlayerMgr.PlayerInfo.buyGoldCount+1)
if ModulesInit.BagManager:GetItemCountById(1001)<e[2]then
GameTools:GotoWays({id=1001})
return
end
PlayerMgr.CheckCostHCTips(e[2],function()
local e=PlayerMgr:sendChangeGold(1)
e.onCompleted=function()
buyCallBack()
end
end)
end
function btnBuyAll()
if e<=0 then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Homepage.Tips.09",LanguageCategory.LangCommon))
return false
end
local e,a=a:GetNextChangeInfo(PlayerMgr.PlayerInfo.buyGoldCount+1)
if ModulesInit.BagManager:GetItemCountById(1001)<e[2]then
GameTools:GotoWays({id=1001})
return
end
GameEntry.UI:OpenUIForm(UIFormId.UIGoldAllChangeHint,{
maxChangeCount=t,
buyGoldCount=PlayerMgr.PlayerInfo.buyGoldCount,
onOkBtnClick=function(e)
PlayerMgr.CheckCostHCTips(e,function()
local e=PlayerMgr:sendChangeGold(0)
e.onCompleted=function()
buyCallBack()
GameTools.CloseUIForm(UIFormId.UIGoldAllChangeHint)
end
end)
end,
})
end
function btnGotoVip()
local e={}
local t=ModulesInit.VIPMgr.GetVipVisibleLevel()
for t=0,t do
local a=o.GetEntity(t)
table.insert(e,GameTools.GetLocalize("UI.VIP.Main.08",LanguageCategory.LangCommon,t,a.goldBuyTimes))
end
local e=table.concat(e,"\n")
local e={
worldPos=btn_wenhao.transform.position,
hintDes=e,
offset=10,
priorPageArr={EHintPageDir.Right},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
textSizeType=EHintSizeType.Standard
}
UIUtil.ShowHint(e)
end
function btnGotoVip2()
LuaUtils.SetLocalPos(content_text.transform,0,0,0)
LuaUtils.SetActive(bg_ditu.transform,true)
local e=ModulesInit.VIPMgr.GetVipVisibleLevel()
for e=0,e do
local t=UIUtil.GetChild(content_text.transform,e)
LuaUtils.SetActive(t,true)
local a=o.GetEntity(e)
local t=t:GetComponent(typeof(CS.UnityEngine.UI.Text))
LuaUtils.SetLabelText(t,GameTools.GetLocalize("UI.VIP.Main.08",LanguageCategory.LangCommon,e,a.goldBuyTimes))
end
end
function closeUI()
local e=LuaUtils.GetChildrenCount(content_text.transform)
LuaUtils.SetChildrenActive(content_text.transform,false)
GameTools.CloseUIForm(UIFormId.UI_GoldChange)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

