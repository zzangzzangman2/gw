local e=require('DataNode/DataTable/Create/item/DTItemDBModel')
local e=require("DataNode/DataTable/Create/constant/DTBattleAttrDBModel")
local t={
ScreenPadding=20,
BgUpPadding=0,
BgDownPadding=20,
TextUpPadding=10,
TextDownPadding=10,
}
local w=40
local f=16
local m=10
local p=70
local a=EHintPageDir.Left
local y=EHintArrowAlign.Horizontal_Center
local u=Vector3(0,0,0)
local c=0
local e=""
local e=8000
local l=false
local s=""
local n=""
local o=""
local i=""
local h=""
local r={EHintPageDir.Up,EHintPageDir.Down,EHintPageDir.Left,EHintPageDir.Right}
local d={
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
end)
e=self.CurrCanvas.sortingOrder
end
function OnOpen(e)
EventSystem.AddListener(CommonEventId.OnEventFuncTipShow,OnEventFuncTipShow)
EventSystem.AddListener(CommonEventId.OnEventClosePubTipView,OnEventClosePubTipView)
s=""
n=""
o=""
i=""
h=""
CloseTip()
if e then
OnEventFuncTipShow(e)
end
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventFuncTipShow,OnEventFuncTipShow)
EventSystem.RemoveListener(CommonEventId.OnEventClosePubTipView,OnEventClosePubTipView)
end
function OnBeforeDestroy()
end
function CloseTip()
LuaUtils.SetActive(root_view.transform,false)
self.CurrCanvas.sortingOrder=e
local t=canvas_bg:GetComponent(typeof(CS.UnityEngine.Canvas))
t.sortingOrder=e
UIUtil.isShowingItemTip=false
end
function OnEventClosePubTipView(e)
CloseTip()
end
function OnEventFuncTipShow(e)
if e==nil then
CloseTip()
return
end
GameEntry.UI:SetSortingOrder(self,true)
local t=canvas_bg:GetComponent(typeof(CS.UnityEngine.Canvas))
t.sortingOrder=self.CurrCanvas.sortingOrder
LuaUtils.SetActive(root_view.transform,true)
s=e.imFuncName or""
n=e.name or""
o=e.name2 or""
i=e.desc1 or""
h=e.desc2 or""
u=e.worldPos or Vector3(0,0,0)
c=e.offset or 0
local t=e.priorPageArr or{}
d=e.priorArrowArr or{}
l=e.arrowHideStatus or false
r=UIScreenFitUtil.CalculatePagePrior(t)
LuaUtils.SetActive(im_jiantou_up.transform,false)
LuaUtils.SetActive(im_jiantou_down.transform,false)
LuaUtils.SetActive(im_jiantou_left.transform,false)
LuaUtils.SetActive(im_jiantou_right.transform,false)
Refreshnfo()
HandleTransform()
end
function Refreshnfo()
local e=text_name.gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
e:SetLayoutHorizontal()
local e=text_name_2.gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
e:SetLayoutHorizontal()
local e=trans_name.gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
e:SetLayoutHorizontal()
GameTools:SetImageSprite(im_func,s,true)
LuaUtils.SetTextMeshText(text_name,n)
LuaUtils.SetLabelText(text_name_2,o)
LuaUtils.SetLabelText(text_yiyou,i)
LuaUtils.SetLabelText(text_notice_message,h)
end
function HandleTransform()
HandleTransformSize()
local e={
uiWorldPos=u,
uiRect=bg_ditu.transform.rect,
priorPageList=r,
priorArrowList=d,
uiSizeOffset=(f+c),
screenPadding=t.ScreenPadding,
arrowEdgeOffset=w,
}
local e=UIScreenFitUtil.HandleTransform(e)
a=e.pageDir
y=e.arrowAlign
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
if not l then
LuaUtils.SetActive(e.transform,true)
end
e.transform.localPosition=o
end
root.transform.position=t
end
function HandleTransformSize()
local e=0
local a=text_notice_message.preferredHeight
a=math.max(a,p)
e=t.BgDownPadding
local o=text_notice_message.transform.localPosition
text_notice_message.transform.localPosition=Vector3(o.x,e,0)
text_notice_message.transform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical,a)
local o=bg_text.transform.localPosition
bg_text.transform.localPosition=Vector3(o.x,e-t.TextDownPadding,0)
bg_text.transform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical,a+t.TextDownPadding+t.TextUpPadding)
e=e+a+m
local a=node_info.transform.localPosition
node_info.transform.localPosition=Vector3(a.x,e,0)
e=e+node_info.transform.rect.height+t.BgUpPadding
bg_ditu.transform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical,e)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

