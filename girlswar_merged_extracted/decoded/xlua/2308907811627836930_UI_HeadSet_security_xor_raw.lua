local j=require('DataNode/DataTable/Create/player/DTHeadDBModel')
local m=require("DataNode/DataTable/Create/hero/DTHeroDBModel")
local p=require('DataNode/DataTable/Create/player/DTHeadFrameDBModel')
local y=require("DataNode/DataTable/Create/player/DTProfileDBModel")
local e=require('DataNode/DataTable/Create/model/DTmodelDBModel')
local b=require("DataNode/DataTable/Create/constant/DTServerListDBModel")
local n=require("DataNode/DataManager/DataMgr/DataUtil")
local k=require('DataNode/DataTable/Create/constant/DTBattleAttrDBModel')
local e={
ICON=1,
FRAME=2,
FIGURE=3
}
local u={
[e.ICON]={im_icon_on,im_icon_off},
[e.FRAME]={im_frame_on,im_frame_off},
[e.FIGURE]={im_figure_on,im_figure_off},
}
local g={
roledefault=0,
heroDefault=1,
heroQ=2,
heroCai=3,
heroMarry=4,
}
local s=ELordProfileType.HeroProfile
local i
local h=nil
local q="Assets/Download/UI/UIPrefabAndRes/MainInterface_Ext_14/czxx_"
local w=nil
local t
local o
local a
local v=nil
local r=nil
local f=nil
local l=nil
local c=nil
local d
function OnInit(t,t)
Image.onClick:AddListener(closeUI)
btn_icon_use.onClick:AddListener(btnIconUse)
for e=e.ICON,e.FIGURE do
local t=u[e][2]:GetComponent(typeof(CS.UnityEngine.UI.Button))
self:AddBtnClickListener(t,handler(e,changeTab))
end
local e={}
e.mPadding1=23
e.mPadding2=23
e.mColumnOrRowCount=4
e.mItemWidthOrHeight=110
llv_icon:InitListView(0,e,OnGetItemByIndex)
llv_frame:InitListView(0,OnGetFrameItemByIndex)
local e={}
e.mPadding1=23
e.mPadding2=23
e.mColumnOrRowCount=4
e.mItemWidthOrHeight=110
llv_figure:InitListView(0,e,OnGetFigureItemByIndex)
im_offHeroProfile.onClick:AddListener(OnClickChangeLordCityProfile)
im_offLordProfile.onClick:AddListener(OnClickChangeLordCityProfile)
btn_kaiguan.onClick:AddListener(OnClickChangeLordCityAtt)
end
function OnOpen(a)
t=e.ICON
s=ELordProfileType.HeroProfile
SyncLordProfileData()
if ModulesInit.GuideMgr.isGuide and(ModulesInit.GuideMgr.unit==ModulesInit.GuideMgr.EGuideCfg.GetCityMaster_613_Item)then
t=e.FIGURE
s=ELordProfileType.LordProfile
end
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.OnPlayInfoChange,OnPlayInfoChange)
c=PlayerMgr.PlayerInfo.headFrame
local e=NetManager.Send(ProtoId.PRT_PLAYER_AVAILABLE_REQ)
e.onCompleted=function(t,e)
v=e.heads
r=e.headFrames
f=e.profiles
w=e.lordProfiles
l={}
for t,e in ipairs(e.frames or{})do
l[e.headFrame]=e.param
end
refreshView()
refreshTab()
end
end
function OnClose()
llv_icon:SetListItemCount(0)
llv_frame:SetListItemCount(0)
llv_figure:SetListItemCount(0)
UnLoadSpine()
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.OnPlayInfoChange,OnPlayInfoChange)
OnCloseCheckSaveLordCitySetting()
end
function OnEventNetReconnectSuccess()
refreshView()
refreshTab()
end
function OnBeforeDestroy()
end
function OnPlayInfoChange()
if c~=PlayerMgr.PlayerInfo.headFrame then
if t==e.FRAME then
refreshView()
end
end
if t==e.FIGURE then
SyncLordProfileData()
SetLordCityAttBtn()
end
end
function refreshIconRight()
local e=a[o]
UIUtil.SetPlayerIconFrame(head_yuan150,{head=e.id,headFrame=PlayerMgr.PlayerInfo.headFrame})
LuaUtils.SetLabelText(text_icon_name,GameTools.GetLocalize(e.headName,LanguageCategory.LangBattle))
LuaUtils.SetActive(text_icon_name.transform,true)
local t=m.GetEntity(e.heroId)
local a,t=n:CheckAndGetPasa(e)
LuaUtils.SetLabelText(text_icon_get_source,t)
local o=false
local t=""
if a then
if e.id==PlayerMgr.PlayerInfo.head then
o=true
t=GameTools.GetLocalize("UI.Setting.Profile.09",LanguageCategory.LangCommon)
else
t=GameTools.GetLocalize("UI.Setting.Profile.10",LanguageCategory.LangCommon)
end
text_icon_get_source.color=DefaultColor.green
else
text_icon_get_source.color=DefaultColor.red
t=GameTools.GetLocalize("UI.Setting.Profile.11",LanguageCategory.LangCommon)
LuaUtils.SetActive(text_icon_name.transform,e.unlockType~=3)
end
UIUtil.SetGray(btn_icon_use.transform,not a)
btn_icon_use.enabled=a and not o
LuaUtils.SetActive(im_shiyongzhong.transform,false)
LuaUtils.SetActive(btn_icon_use.transform,true)
LuaUtils.SetTextMeshText(text_icon_use,t)
SetLordCityRightView()
end
function refreshFrameRight()
local e=a[o]
UIUtil.SetPlayerIconFrame(head_yuan150,{head=PlayerMgr.PlayerInfo.head,headFrame=e.id})
LuaUtils.SetLabelText(text_icon_name,GameTools.GetLocalize(e.frameName,LanguageCategory.LangBattle))
local t=m.GetEntity(e.heroId)
local a,t=CheckAndGetPasaByFrame(e)
LuaUtils.SetLabelText(text_icon_get_source,t)
local o=false
local t=""
if a then
if e.id==PlayerMgr.PlayerInfo.headFrame then
o=true
t=GameTools.GetLocalize("UI.Setting.Profile.09",LanguageCategory.LangCommon)
else
t=GameTools.GetLocalize("UI.Setting.Profile.10",LanguageCategory.LangCommon)
end
text_icon_get_source.color=DefaultColor.green
else
text_icon_get_source.color=DefaultColor.red
t=GameTools.GetLocalize("UI.Setting.Profile.11",LanguageCategory.LangCommon)
LuaUtils.SetActive(text_icon_name.transform,e.unlockType~=3)
end
UIUtil.SetGray(btn_icon_use.transform,not a)
btn_icon_use.enabled=a and not o
LuaUtils.SetActive(im_shiyongzhong.transform,false)
LuaUtils.SetActive(btn_icon_use.transform,true)
LuaUtils.SetTextMeshText(text_icon_use,t)
SetLordCityRightView()
end
function refreshFigureRight()
local e=a[o]
LuaUtils.SetLabelText(text_figure_name,GameTools.GetLocalize(e.profileName,LanguageCategory.LangBattle))
local a,t=n:CheckAndGetPasa(e)
UIUtil.SetMarqueeWithOption(mask_figure_get_source.transform,text_figure_get_source,t,{indent=0,isMiddleAlgn=true})
local o=false
local t=""
if a then
if PlayerMgr:IsUseingProfile(e.id)then
o=true
t=GameTools.GetLocalize("UI.Setting.Profile.09",LanguageCategory.LangCommon)
else
t=GameTools.GetLocalize("UI.Setting.Profile.10",LanguageCategory.LangCommon)
end
text_figure_get_source.color=DefaultColor.green
LuaUtils.SetActive(text_figure_name.transform,true)
else
text_figure_get_source.color=DefaultColor.red
t=GameTools.GetLocalize("UI.Setting.Profile.11",LanguageCategory.LangCommon)
LuaUtils.SetActive(text_figure_name.transform,e.unlockType~=3)
end
UIUtil.SetGray(btn_icon_use.transform,not a)
btn_icon_use.enabled=a and not o
LuaUtils.SetActive(im_shiyongzhong.transform,false)
LuaUtils.SetActive(btn_icon_use.transform,true)
LuaUtils.SetTextMeshText(text_icon_use,t)
if PlayerMgr:GetProfileType(e)==ELordProfileType.LordProfile then
UnLoadSpine()
LuaUtils.SetImageSprite(img_lordCityJueSe,q..e.profile..".png")
else
showSpine(e)
end
SetLordCityRightView(e)
end
function refreshView()
LuaUtils.SetActive(right_icon_root.transform,t==e.ICON or t==e.FRAME)
LuaUtils.SetActive(right_figure_root.transform,t==e.FIGURE)
LuaUtils.SetActive(llv_icon.transform,t==e.ICON)
LuaUtils.SetActive(llv_frame.transform,t==e.FRAME)
LuaUtils.SetActive(llv_figure.transform,t==e.FIGURE)
local i=ModulesInit.ActSelfMarryMgr:GetActSelfMarryStartTimeMap()
local h={}
for e,t in pairs(i)do
local t=e
local e=HeroMgr:GetHeroCfgData(t)
if e.marryHeadFrameItemId then
h[e.marryHeadFrameItemId]=t
end
end
o=1
if t==e.ICON then
a={}
local e=j.GetList()
for t,e in pairs(e)do
if n.CheckNewIosShow(e.heroId)and e.isShow==1 then
if e.headType==g.heroMarry and i[e.heroId]then
local t=i[e.heroId]
if TimeUtil.serverTimeStep>=TimeUtil.String2ToTimeStamp2(t)then
table.insert(a,e)
end
else
table.insert(a,e)
end
end
end
table.sort(a,function(e,t)
local a=n:CheckAndGetPasa(e)
local o=n:CheckAndGetPasa(t)
if a~=o then return a end
if e.id==PlayerMgr.PlayerInfo.head then return true end
if t.id==PlayerMgr.PlayerInfo.head then return false end
return e.listNum<t.listNum
end)
llv_icon:SetListItemCount(0)
llv_icon:SetListItemCount(#a)
refreshIconRight()
elseif t==e.FRAME then
local e=p.GetList()
a={}
for t,e in pairs(e)do
if e.isShow~=0 then
local t=function()
if e.showType==0 then
table.insert(a,e)
elseif e.showType==1 then
local t=b.GetEntity(PlayerMgr.serverId)
if t.newPlayerMapRank>0 then
table.insert(a,e)
end
end
end
if h[e.id]then
local e=h[e.id]
local e=i[e]
if TimeUtil.serverTimeStep>TimeUtil.String2ToTimeStamp2(e)then
t()
end
else
t()
end
end
end
table.sort(a,function(e,t)
local a=CheckAndGetPasaByFrame(e)
local o=CheckAndGetPasaByFrame(t)
if a~=o then return a end
if e.id==PlayerMgr.PlayerInfo.headFrame then return true end
if t.id==PlayerMgr.PlayerInfo.headFrame then return false end
return e.listId>t.listId
end)
llv_frame:SetListItemCount(0)
llv_frame:SetListItemCount(#a)
refreshFrameRight()
elseif t==e.FIGURE then
a=GetProfileListBySmallType(s)
table.sort(a,function(t,e)
local a=n:CheckAndGetPasa(t)
local o=n:CheckAndGetPasa(e)
if a~=o then return a end
if PlayerMgr:IsUseingProfile(t.id)then return true end
if PlayerMgr:IsUseingProfile(e.id)then return false end
return t.id<e.id
end)
llv_figure:SetListItemCount(0)
llv_figure:SetListItemCount(#a)
refreshFigureRight()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="OPEN_UI_HEADSET_LORDPROFILE_VIEW"})
end
end
function CheckAndGetPasaByFrame(e)
local a,t=false,""
if e.unlockType==23 or e.unlockType==31 or e.unlockType==35 then
if r and next(r)then
for t=1,#r do
if r[t]==e.id then
a=true
end
end
end
t=GameTools.GetLocalize(e.unlockText,LanguageCategory.LangCommon)
else
a,t=n:CheckAndGetPasa(e)
end
return a,t
end
function OnGetItemByIndex(e,t)
t=t+1
local e=e:NewListViewItem("item")
if e.IsInitHandlerCalled==false then
local t=LuaUtils.GetLuaComBinder(e.transform)
local t=t:GetComponents()
e.BiComs=t
e.BiComs["btn_head"].onClick:AddListener(handler(e,function(e)
local a=e.UserObjectData
local t=o
o=a
llv_icon:RefreshItemByItemIndex(t-1)
llv_icon:RefreshItemByItemIndex(o-1)
LuaUtils.AnimtorPlay(e.BiComs["Group"],"Ani_Headselect",0,0)
refreshIconRight()
end))
e.IsInitHandlerCalled=true
end
local a=a[t]
local i=UIUtil.GetPlayerIcon(a.id)
local s=e.BiComs["btn_head"]:GetComponent(typeof(CS.UnityEngine.UI.Image))
GameTools:SetImageSprite(s,i,false)
local i=UIUtil.GetPlayerFrame(PlayerMgr.PlayerInfo.headFrame)
GameTools:SetImageSprite(e.BiComs["im_kuang"],i,false)
LuaUtils.SetActive(e.BiComs["im_xuanzhong"].transform,t==o)
LuaUtils.SetActive(e.BiComs["bg_shiyongzhong"].transform,a.id==PlayerMgr.PlayerInfo.head)
local a=n:CheckAndGetPasa(a)
UIUtil.SetGray(e.BiComs["btn_head"].transform,not a)
UIUtil.SetGray(e.BiComs["im_kuang"].transform,not a)
LuaUtils.SetActive(e.BiComs["im_suo"].transform,not a)
e.UserObjectData=t
return e
end
function OnGetFrameItemByIndex(e,i)
i=i+1
local e=e:NewListViewItem("bg_diban1")
if e.IsInitHandlerCalled==false then
local t=LuaUtils.GetLuaComBinder(e.transform)
local t=t:GetComponents()
e.BiComs=t
local t=e.BiComs["btn_select"]:GetComponent(typeof(CS.UnityEngine.UI.Button))
self:AddBtnClickListener(t,handler(e,function(e)
local t=e.UserObjectData
local e=o
o=t
llv_frame:RefreshItemByItemIndex(e-1)
llv_frame:RefreshItemByItemIndex(o-1)
refreshFrameRight()
end))
e.IsInitHandlerCalled=true
end
local t=a[i]
local a=UIUtil.GetPlayerFrame(t.id)
GameTools:SetImageSprite(e.BiComs["im_kuang"],a,false)
LuaUtils.SetActive(e.BiComs["im_selected"].transform,i==o)
LuaUtils.SetActive(e.BiComs["bg_shiyongzhong"].transform,t.id==PlayerMgr.PlayerInfo.headFrame)
LuaUtils.SetLabelText(e.BiComs["text_name"],GameTools.GetLocalize(t.frameName,LanguageCategory.LangBattle))
LuaUtils.SetTextMeshText(e.BiComs["text_sign"],GameTools.GetLocalize(t.line,LanguageCategory.LangBattle))
local a=UIUtil.GetPlayerIcon(PlayerMgr.PlayerInfo.head)
local o=e.BiComs["btn_head"]:GetComponent(typeof(CS.UnityEngine.UI.Image))
GameTools:SetImageSprite(o,a,false)
local a,o=CheckAndGetPasaByFrame(t)
UIUtil.SetGray(e.BiComs["im_kuang"].transform,not a)
UIUtil.SetGray(e.BiComs["btn_head"].transform,not a)
LuaUtils.SetActive(e.BiComs["im_suo"].transform,not a)
e.UserObjectData=i
local o=GameTools.GetLocalize(t.line,LanguageCategory.LangBattle)
UIUtil.SetMarqueeWithDesc(e.BiComs["mask_recruit_notice"].transform,e.BiComs["text_recruit_notice_desc"],100,o,false,true,true)
if a then
local a=GetFrameParam(t.id)
if a~=nil and t.timeText~="0"then
LuaUtils.SetLabelText(e.BiComs["text_expire_time"],GameTools.GetLocalize(t.timeText,LanguageCategory.LangCommon,tonumber(a)+1))
LuaUtils.SetActive(e.BiComs["text_expire_time"].transform,true)
else
LuaUtils.SetActive(e.BiComs["text_expire_time"].transform,false)
end
else
LuaUtils.SetActive(e.BiComs["text_expire_time"].transform,false)
end
return e
end
function GetFrameParam(e)
if l then
return l[e]
end
return nil
end
function OnGetFigureItemByIndex(e,t)
t=t+1
local e=e:NewListViewItem("item")
if e.IsInitHandlerCalled==false then
local t=LuaUtils.GetLuaComBinder(e.transform)
local t=t:GetComponents()
e.BiComs=t
e.BiComs["btn_head"].onClick:AddListener(handler(e,function(e)
local a=e.UserObjectData
local t=o
o=a
llv_figure:RefreshItemByItemIndex(t-1)
llv_figure:RefreshItemByItemIndex(o-1)
LuaUtils.AnimtorPlay(e.BiComs["Group"],"Ani_Headselect",0,0)
refreshFigureRight()
end))
e.IsInitHandlerCalled=true
end
local a=a[t]
local s=PlayerMgr:GetProfileHeadPath(a)
local i=e.BiComs["btn_head"]:GetComponent(typeof(CS.UnityEngine.UI.Image))
LuaUtils.SetImageSprite(i,s,false)
local i=UIUtil.GetPlayerFrame(PlayerMgr.PlayerInfo.headFrame)
GameTools:SetImageSprite(e.BiComs["im_kuang"],i,false)
LuaUtils.SetActive(e.BiComs["im_xuanzhong"].transform,t==o)
LuaUtils.SetActive(e.BiComs["bg_shiyongzhong"].transform,PlayerMgr:IsUseingProfile(a.id))
e.UserObjectData=t
local t=n:CheckAndGetPasa(a)
UIUtil.SetGray(e.BiComs["btn_head"].transform,not t)
UIUtil.SetGray(e.BiComs["im_kuang"].transform,not t)
LuaUtils.SetActive(e.BiComs["im_suo"].transform,not t)
return e
end
function refreshTab()
for e=e.ICON,e.FIGURE do
local t=e==t
LuaUtils.SetActive(u[e][1].transform,t)
LuaUtils.SetActive(u[e][2].transform,not t)
end
end
function changeTab(a)
local e=true
if e==true then
t=a
refreshView()
end
refreshTab()
end
function showSpine(e)
local e=e.profile
DynamicModuleRes.CheckResAndDownload(
{[1]={e}},
function()
local a=HeroMgr:IsHeroHasPet(e)and 1 or 0
local t=UIUtil.GetHeroModelCfgData(e)
UIUtil.GetUISmallSpinePool(e,
function(e,a,o)
UnLoadSpine()
local t={
scale=Vector3(t.profileZoom,t.profileZoom,t.profileZoom),
}
d=e
UIUtil.HandlePoolUISmallRolePrefab(e,a,o,im_spine_root.transform,t)
end,
a,
false
)
end
)
end
function UnLoadSpine()
if(not IsNil(d))then
UIUtil.SmallSpinePoolDespawn(d)
d=nil
end
end
function btnIconUse()
local a=a[o]
if t==e.ICON then
local e=PlayerMgr:sendChangeHead(a.id)
e.onCompleted=function()
llv_icon:RefreshAllShownItem()
refreshIconRight()
end
elseif t==e.FRAME then
local e=PlayerMgr:sendChangeHeadFrame(a.id)
e.onCompleted=function()
llv_frame:RefreshAllShownItem()
refreshFrameRight()
end
elseif t==e.FIGURE then
local e=PlayerMgr:sendChangeFigure(a.id,i)
e.onCompleted=function()
llv_figure:RefreshAllShownItem()
refreshFigureRight()
end
end
end
function closeUI()
GameTools.CloseUIForm(UIFormId.UI_HeadSet)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end
function SyncLordProfileData()
i=PlayerMgr.PlayerInfo.useLordProfileAttr

end
function OnClickChangeLordCityProfile()
if s==ELordProfileType.HeroProfile then
s=ELordProfileType.LordProfile
elseif s==ELordProfileType.LordProfile then
s=ELordProfileType.HeroProfile
end
refreshView()
end
function SetLordCityProfileBtn()
LuaUtils.SetActive(im_onHeroProfile.transform,s==ELordProfileType.HeroProfile)
LuaUtils.SetActive(im_onLordProfile.transform,s==ELordProfileType.LordProfile)
end
function OnClickChangeLordCityAtt()
if not i then
if PlayerMgr.PlayerInfo.lordProfile==nil or PlayerMgr.PlayerInfo.lordProfile==0 then
UIUtil.ShowCommonTips(GameTools.GetLocalize("ui.lordcity04",LanguageCategory.LangCommon))
return
end
end
i=not i
SetLordCityAttBtn()
end
function SetLordCityAttBtn()
LuaUtils.SetActive(im_kai_lordCity.transform,i)
LuaUtils.SetActive(im_guan_lordCity.transform,not i)
end
function SetLordCityRightView(o)
local a=t==e.FIGURE and s==ELordProfileType.LordProfile
LuaUtils.SetActive(lordCityRoot.transform,t==e.FIGURE)
LuaUtils.SetActive(text_attrInfo.transform,a)
LuaUtils.SetActive(imlordCitybg.transform,a)
if o and a then
local e=o.profileAttr[1]
local t=o.profileAttr[2]
local a=k.GetEntity(e)
LuaUtils.SetLabelText(text_attrInfo,GameTools.GetLocalize(a.attrName,LanguageCategory.LangBattle)..string.format("+%s",n:clientAttrShowValue(e,t)))
end
SetLordCityAttBtn()
SetLordCityProfileBtn()
end
function OnCloseCheckSaveLordCitySetting()
if i~=PlayerMgr.PlayerInfo.useLordProfileAttr then

if PlayerMgr.PlayerInfo.lordProfile and PlayerMgr.PlayerInfo.lordProfile~=0 then
PlayerMgr:sendChangeFigure(PlayerMgr.PlayerInfo.lordProfile,i)
else
PlayerMgr:sendChangeFigure(PlayerMgr.PlayerInfo.profile,i)
end
else

end
end
function GetProfileListBySmallType(a)
if h==nil then
h={}
local e=y.GetList()
for t=1,#e do
local t=e[t]
local e=PlayerMgr:GetProfileType(t)
if h[e]==nil then
h[e]={}
end
table.insert(h[e],t)
end
end
return h[a]
end 
