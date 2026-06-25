local i={
ScreenPadding=20,
BgLeftPadding=15,
BgRightPadding=15,
}
local c=40
local m=16
local u=80
local l=300
local e=400
local t=0
local o={}
local e=0
local a=EHintPageDir.Left
local f=EHintArrowAlign.Horizontal_Center
local s=Vector3(0,0,0)
local h=0
local e=""
local e=8000
local n=true
local d={EHintPageDir.Up,EHintPageDir.Down,EHintPageDir.Left,EHintPageDir.Right}
local r={
EHintArrowAlign.Horizontal_Left,
EHintArrowAlign.Horizontal_Center,
EHintArrowAlign.Horizontal_Right,
EHintArrowAlign.Vertical_Upper,
EHintArrowAlign.Vertical_Middle,
EHintArrowAlign.Vertical_Down,
}
function OnInit(t,t)
btn_bg.onClick:AddListener(function()
CloseTip()
GameTools.CloseUIForm(UIFormId.UI_GameGuildBoxInfoView)
end)
e=self.CurrCanvas.sortingOrder
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnEventGameGuildBoxShow,OnEventGameGuildBoxShow)
EventSystem.AddListener(CommonEventId.OnEventClosePubTipView,OnEventClosePubTipView)
EventSystem.AddListener(CommonEventId.OnCloseLuaView,OnCloseLuaView)
EventSystem.AddListener(CommonEventId.OnLuaViewChange,OnLuaViewChange)
CloseTip()
if e then
OnEventGameGuildBoxShow(e)
end
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventGameGuildBoxShow,OnEventGameGuildBoxShow)
EventSystem.RemoveListener(CommonEventId.OnEventClosePubTipView,OnEventClosePubTipView)
EventSystem.RemoveListener(CommonEventId.OnCloseLuaView,OnCloseLuaView)
EventSystem.RemoveListener(CommonEventId.OnLuaViewChange,OnLuaViewChange)
end
function OnBeforeDestroy()
end
function CloseTip()
LuaUtils.SetActive(root_view.transform,false)
n=true
self.CurrCanvas.sortingOrder=e
local t=canvas_bg:GetComponent(typeof(CS.UnityEngine.Canvas))
t.sortingOrder=e
end
function OnEventClosePubTipView(e)
CloseTip()
GameTools.CloseUIForm(UIFormId.UI_GameGuildBoxInfoView)
end
function OnEventGameGuildBoxShow(e)
if e==nil then
CloseTip()
GameTools.CloseUIForm(UIFormId.UI_GameGuildBoxInfoView)
return
end
local a=e.titleName or"bigbosstips_12"
LuaUtils.SetTextMeshText(text_title,GameTools.GetLocalize(a,LanguageCategory.LangCommon))
t=e.thingDid
o=e.itemArr
if o==nil then
return
end
GameEntry.UI:SetSortingOrder(self,true)
local t=canvas_bg:GetComponent(typeof(CS.UnityEngine.Canvas))
t.sortingOrder=self.CurrCanvas.sortingOrder
LuaUtils.SetActive(root_view.transform,true)
n=false
s=e.worldPos or Vector3(0,0,0)
h=e.offset or 0
local t=e.priorPageArr or{}
r=e.priorArrowArr or{}
d=UIScreenFitUtil.CalculatePagePrior(t)
LuaUtils.SetActive(im_jiantou_up.transform,false)
LuaUtils.SetActive(im_jiantou_down.transform,false)
LuaUtils.SetActive(im_jiantou_left.transform,false)
LuaUtils.SetActive(im_jiantou_right.transform,false)
HandleTransform()
ShowRewards()
end
function ShowRewards()
function setCell(e,t)
local t=UIUtil.GetChild(grid.transform,t-1)
local a
if BagUtil.IsUnderwear(e.itemDid)then
a=e.itemId
end
if not t then
t=GetInst(e)
LuaUtils.SetParent(t.transform,grid.transform)
end
LuaUtils.SetLocalScale(t,0.8,0.8,0.8)
local o=LuaUtils.GetLuaComBinder(t)
local o=o:GetComponents()
local i=t:GetComponent(typeof(CS.YouYou.LuaUnit))
i:Open({itemDid=e.itemDid,info=e.info})
LuaUtils.SetActive(t.transform,true)
local t={
thingDid=a,
offset=45
}
UIUtil.SetItemCell(o["itemCell"].transform,{itemDid=e.itemDid,count=e.count,id=a,info=e.info},t)
LuaUtils.SetActive(o["im_times"].transform,false)
end
LuaUtils.SetChildrenActive(grid.transform,false)
for e=1,#o do
local t=o[e]
setCell(t,e)
end
end
function GetInst(t)
local e
if BagUtil.IsUnderwear(t.itemDid)then
e=LuaUtils.Instantiate(underwear_root.transform)
else
e=LuaUtils.Instantiate(item_root.transform)
end
local t=e:GetComponent(typeof(CS.YouYou.LuaUnit))
t:Init()
return e
end
function HandleTransform()
HandleTransformSize()
local e={
uiWorldPos=s,
uiRect=bg_ditu.transform.rect,
priorPageList=d,
priorArrowList=r,
uiSizeOffset=(m+h),
screenPadding=i.ScreenPadding,
arrowEdgeOffset=c,
}
local e=UIScreenFitUtil.HandleTransform(e)
a=e.pageDir
f=e.arrowAlign
local t=e.rootPos
local o=e.arrowPosInRoot
local e=nil
if a==EHintPageDir.Left then
e=im_jiantou_right
elseif a==EHintPageDir.Right then
e=im_jiantou_left
elseif a==EHintPageDir.Up then
e=im_jiantou_down
elseif a==EHintPageDir.Down then
e=im_jiantou_up
end
if e~=nil then
LuaUtils.SetActive(e.transform,true)
e.transform.localPosition=o
end
root.transform.position=t
end
function HandleTransformSize()
local e=4*u
e=math.max(e,l)
ScrollViewAct.transform.sizeDelta=Vector2(e,190)
e=e+i.BgLeftPadding+i.BgRightPadding
bg_ditu.transform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal,e)
local o,a,t=LuaUtils.GetLocalPos(root_title.transform)
root_title.transform.localPosition=Vector3(e/2,a,t)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end
function OnCloseLuaView(e)
if n==false and e~=UIFormId.UI_GameGuildBoxInfoView then
local e=GameEntry.UI:GetLastEnableUILayer()
if e==-1 then
GameEntry.UI:SetSortingOrder(self,true)
local e=canvas_bg:GetComponent(typeof(CS.UnityEngine.Canvas))
e.sortingOrder=self.CurrCanvas.sortingOrder
end
end
end
function OnLuaViewChange(e)
if not e and GameEntry.UI:IsExists(UIFormId.UI_GameGuildBoxInfoView)then
GameTools.CloseUIForm(UIFormId.UI_GameGuildBoxInfoView)
end
end

