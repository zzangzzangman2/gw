local o=require("DataNode/DataManager/DataMgr/DataUtil")
local e=nil
local t=0
function OnInit(a,a)
btn_ok.onClick:AddListener(function()
if e.onOkBtnClick then
e.onOkBtnClick(t)
end
end)
btn_close.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UIGoldAllChangeHint)
if e.onCancelBtnClick then
e.onCancelBtnClick()
end
end)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UIGoldAllChangeHint)
if e.onCancelBtnClick then
e.onCancelBtnClick()
end
end)
end
function OnOpen(t)
e=t
OnTipsShow(e)
end
function OnTipsShow(a)
local n=o:GetNextChangeRate()
t=0
local a=0
local i=ModulesInit.BagManager:GetItemCountById(1001)
for e=PlayerMgr.PlayerInfo.buyGoldCount+1,e.maxChangeCount do
local e,o=o:GetNextChangeInfo(e)
if i<t+e[2]then
break
end
t=t+e[2]
a=a+(o[2]*n)
end
LuaUtils.SetLabelText(text_hc_count,"×"..UIUtil.toBigNum(t))
LuaUtils.SetLabelText(text_gold_count,"×"..UIUtil.toBigNum(a))
end
function OnClose()
end
function OnBeforeDestroy()
end 
