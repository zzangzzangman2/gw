local e=require("DataNode/DataTable/Create/hero/DTHeroDBModel")
local e=require("DataNode/DataTable/Create/player/DTProfileDBModel")
local e=require("DataNode/DataTable/Create/model/DTmodelDBModel")
local d=require("DataNode/DataManager/DataMgr/DataUtil")
local t=ModulesInit.HeroShowMgr
local i
local o
local l=true
local n
local u="UIMainInterface/bg_jiaobiao"
local r=false
local s=0
local h
local a={
All=0,
ProfessionTypeTank=1,
ProfessionTypeMage=2,
ProfessionTypeWarrior=3,
Battle=4,
UnderWear=5,
Marry=6,
SelfMarry=7,
LordProfile=8,
}
function OnInit(e,e)
btn_fanhui.onClick:AddListener(closeUI)
btn_jiantou1.onClick:AddListener(
function()
local e=llv_bg.ContainerTrans.transform.localPosition
if e.x>0 then
return
end
LuaUtils.DoTweenDLocalPosMoveX(llv_bg.ContainerTrans,e.x+469,0.3)
end
)
btn_jiantou2.onClick:AddListener(
function()
local e=llv_bg.ContainerTrans.transform.localPosition
if math.abs(e.x)>=llv_bg.ContainerTrans.rect.width-llv_bg.transform.rect.width then
return
end
LuaUtils.DoTweenDLocalPosMoveX(llv_bg.ContainerTrans,e.x-469,0.3)
end
)
btn_cancel.onClick:AddListener(closeUI)
btn_queding.onClick:AddListener(onSave)
btn_voselect.onClick:AddListener(
function()
UpdateVoSelectMenuBtnState()
end
)
btn_all.onClick:AddListener(
function()
VoSelect(a.All)
UpdateVoSelectMenuBtnState(true)
end
)
btn_li.onClick:AddListener(
function()
VoSelect(a.ProfessionTypeTank)
UpdateVoSelectMenuBtnState(true)
end
)
btn_zhi.onClick:AddListener(
function()
VoSelect(a.ProfessionTypeMage)
UpdateVoSelectMenuBtnState(true)
end
)
btn_yong.onClick:AddListener(
function()
VoSelect(a.ProfessionTypeWarrior)
UpdateVoSelectMenuBtnState(true)
end
)
btn_zhandou.onClick:AddListener(
function()
VoSelect(a.Battle)
UpdateVoSelectMenuBtnState(true)
end
)
btn_neiyi.onClick:AddListener(
function()
VoSelect(a.UnderWear)
UpdateVoSelectMenuBtnState(true)
end
)
btn_marry.onClick:AddListener(
function()
VoSelect(a.Marry)
UpdateVoSelectMenuBtnState(true)
end
)
btn_selfMarry.onClick:AddListener(
function()
VoSelect(a.SelfMarry)
UpdateVoSelectMenuBtnState(true)
end
)
btn_lord.onClick:AddListener(
function()
VoSelect(a.LordProfile)
UpdateVoSelectMenuBtnState(true)
end
)
llv_bg:InitListView(0,OnGetItemByIndex)
llv_bg.mOnBeginDragAction=llvDragBegin
llv_bg.mOnDragingAction=llvDraging
llv_bg.mOnEndDragAction=llvDragEnd
end
function OnOpen(e)
ModulesInit.HeroShowMgr.SetPictureDisplayClick(1005,1,1)
EventSystem.AddListener(CommonEventId.OnMainBgChange,onMainBgChange)
EventSystem.AddListener(CommonEventId.OnFavorabilityRefresh,onFavorabilityRefresh)
h=ModulesInit.ActSelfMarryMgr:GetActSelfMarryStartTimeMap()
o=table.deepCopy(PlayerMgr.mainShowHeroList)
i={}
s=0
VoSelect(a.All)
LuaUtils.SetImageSprite(btn_voselect.transform,"UICommonOther/BTN_buzhen_01")
refreshView(0)
LuaUtils.SetLocalScale(bg_zhiye.transform,1,0,1)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.OnAtlasAndExhibitionRefresh,OnGetNewHeroRefresh)
RefreshNeiyiBtnView()
end
function RefreshNeiyiBtnView()
if getBtnGaobaiStatus()then
LuaUtils.SetActive(btn_neiyi.transform,true)
LuaUtils.SetActive(btn_all.transform,true)
else
LuaUtils.SetActive(btn_neiyi.transform,false)
LuaUtils.SetActive(btn_all.transform,false)
end
end
function OnEventNetReconnectSuccess()
closeUI()
end
function OnFormBack(e)
if e==316 or e==219 then
EventSystem.SendEvent(CommonEventId.OnMainBgChange)
end
end
function OnGetNewHeroRefresh()
if r then
r=false
return
end
VoSelect(a.All)
refreshView(0)
end
function refreshView(e)
if e~=#i then
llv_bg:SetListItemCount(#i)
else
llv_bg:RefreshAllShownItem()
llv_bg:MovePanelToItemIndex(0)
end
LuaUtils.SetTextMeshText(text_select_desc,GameTools.GetLocalize("UI.Homepage.SelectBG.13",LanguageCategory.LangCommon,#o))
end
function CheckSameBgTypeByServerData(o,a,e)
if e.heroDid==o then
if a==t.EBgSetType.Battle then
if not e.isUnderwear and not e.isMarry and not e.isSelfMarry then
return true
end
elseif a==t.EBgSetType.UnderWear then
if e.isUnderwear then
return true
end
elseif a==t.EBgSetType.Marry then
if e.isMarry then
return true
end
elseif a==t.EBgSetType.SelfMarry then
if e.isSelfMarry then
return true
end
elseif a==t.EBgSetType.LordProfile then
return true
end
end
end
function isSelected(t,i)
for a,e in ipairs(o or{})do
if CheckSameBgTypeByServerData(t,i,e)then
return true,a
end
end
return false
end
function isUsed(o,a)
for e,t in ipairs(PlayerMgr.mainShowHeroList or{})do
if CheckSameBgTypeByServerData(o,a,t)then
return true,e
end
end
return false
end
function convertBgSetTypeToStuctData(e)
local a=e==t.EBgSetType.UnderWear
local o=e==t.EBgSetType.Marry
local e=e==t.EBgSetType.SelfMarry
return a,o,e
end
function isFrist(n,s)
local a=1
local e=PlayerMgr.mainShowHeroList[PlayerMgr.PlayerInfo.showHeroIndex]
for s,t in ipairs(o or{})do
local n,o,i=convertBgSetTypeToStuctData(t.bgSetType)
if t.heroDid==e.heroDid and n==e.isUnderwear and o==e.isMarry
and i==e.isSelfMarry then
a=s
break
end
end
local e=o[a]
if e and e.heroDid==n and e.bgSetType==s then
return true
else
return false
end
end
function getDataIndexAndType(e)
if not(i and i[e])then
return e,0
end
local t=i[e]
return e,t.bgSetType
end
function getBgSetState(e,a)
if a==t.EBgSetType.LordProfile then
local e=PlayerMgr:IsHasAvailableLordProfile(e.id)
return e
else
return getHeroState(e,a)
end
end
function getHeroState(o,n)
local e=false
local s=0
local i=false
local a=HeroMgr:GetHeroDataByHeroDId(o.id)
if a and a.status>PROTO_ENUM.HeroStatus.UNACTIVE then
i=true
end
if n==t.EBgSetType.Battle then
if i==true then
e=true
s=a.activeTime
end
elseif n==t.EBgSetType.UnderWear then
if i==true then
if a.loverGrade>=HeroMgr:GetHaremUnlockUnderwear(a)then
e=true
end
end
elseif n==t.EBgSetType.Marry then
if HeroMgr:MarryIsActive(o.id)then
e=true
end
elseif n==t.EBgSetType.SelfMarry then
if HeroMgr:MarryIsActive(o.id)and HeroMgr:GetHeroMarryAnimStatus(o.id,MarryExpressionGroup.selfExpression)then
e=true
end
end
return e,s,i
end
function OnGetItemByIndex(e,n)
n=n+1
local e=e:NewListViewItem("xingxiang1")
if e.IsInitHandlerCalled==false then
local a=LuaUtils.GetLuaComBinder(e.transform)
local a=a:GetComponents()
e.BiComs=a
e.BiComs["btn_select"].onClick:AddListener(
handler(
e,
function(n)
local s=n.UserObjectData
local e=s
local e=i[e]
local a,i=isSelected(e.id,e.bgSetType)
if a then
table.remove(o,i)
else
local a,n,i=getBgSetState(e,e.bgSetType)
if e.bgSetType==t.EBgSetType.Marry then
if not a then
local e=d:GetHeroRingUnlockCfg(e.id)
GameTools:GotoWays({id=e.levelUpConsumeItem})
return
end
elseif e.bgSetType==t.EBgSetType.SelfMarry then
if not a then
local e=d:GetHeroRingUnlockCfg(e.id)
GameTools:GotoWays({id=e.levelUpConsumeItem})
return
end
elseif e.bgSetType==t.EBgSetType.Battle then
if not a then
local e=HeroMgr:GetHeroDrawItemDidByData(e)
GameTools:GotoWays({id=e})
return
end
elseif e.bgSetType==t.EBgSetType.UnderWear then
if not i then
local e=HeroMgr:GetHeroDrawItemDidByData(e)
GameTools:GotoWays({id=e})
return
end
if not a then
local t=GameTools.GetLocalize(e.bgName,LanguageCategory.LangBattle)
local a=GameTools.GetLocalize("gradename"..HeroMgr:GetHaremUnlockUnderwear(e),LanguageCategory.LangCommon)
UIUtil.ShowMessageBox(
{
onOkBtnClick=function()
if GameFunction.IsFunctionUnLock(GameFunctionType.temp10029,true)then
GameEntry.UI:OpenUIForm(UIFormId.UI_FavorabilityHero,{heroDid=e.id})
end
end,
text=GameTools.GetLocalize("UI.Homepage.SelectBG.17",LanguageCategory.LangCommon,t,a),
buttons=MessageBoxButtons.OKCancel,
okBtnContent=GameTools.GetLocalize("UI.Homepage.Tips.02",LanguageCategory.LangCommon)
}
)
return
end
elseif e.bgSetType==t.EBgSetType.LordProfile then
if not a then
local e=e.unlockPara[1]
GameTools:GotoWays({id=e})
return
end
end
if#o>=6 then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Homepage.SelectBG.14",LanguageCategory.LangCommon))
return
end
local t,i,a=convertBgSetTypeToStuctData(e.bgSetType)
table.insert(o,{heroDid=e.id,isUnderwear=t,isMarry=i,isSelfMarry=a})
end
llv_bg:RefreshAllShownItem(s-1)
LuaUtils.SetTextMeshText(text_select_desc,GameTools.GetLocalize("UI.Homepage.SelectBG.13",LanguageCategory.LangCommon,#o))
if not ModulesInit.HeroShowMgr.GetPictureDisplayClick(e.id,e.bgSetType)then
ModulesInit.HeroShowMgr.SetPictureDisplayClick(e.id,e.bgSetType,1)
LuaUtils.SetActive(n.BiComs["im_red"].transform,false)
r=true
EventSystem.SendEvent(CommonEventId.OnAtlasAndExhibitionRefresh)
end
end
)
)
e.IsInitHandlerCalled=true
end
local a=n
local a=i[a]
LuaUtils.SetTextMeshText(e.BiComs["text_name"],GameTools.GetLocalize(a.bgName,LanguageCategory.LangBattle))
local o=a.id
local o=UIUtil.GetHeroModelCfgData(o)
local s=o.id
local i=e.BiComs["im_player"]
if a.bgSetType==t.EBgSetType.UnderWear then
local e=UIUtil.GetBigPaintingPath(s,o.homepageUWPainting)
i:LoadSpriteWithFullPath(e)
elseif a.bgSetType==t.EBgSetType.Battle then
local e=UIUtil.GetBigPaintingPath(s,o.bigPainting)
i:LoadSpriteWithFullPath(e)
elseif a.bgSetType==t.EBgSetType.Marry then
local e=o.marryMainInterfaceSelect..'.png'
i:LoadSpriteWithFullPath(e)
elseif a.bgSetType==t.EBgSetType.SelfMarry then
local e=o.selfMarryMainInterfaceSelect..'.png'
i:LoadSpriteWithFullPath(e)
elseif a.bgSetType==t.EBgSetType.LordProfile then
local e=UIUtil.GetBigPaintingPath(s,o.bigPainting)
i:LoadSpriteWithFullPath(e)
end
LuaUtils.SetActive(e.BiComs["starts"].transform,false)
LuaUtils.SetActive(e.BiComs["im_zhiye"].transform,false)
LuaUtils.SetActive(e.BiComs["im_pinzhi"].transform,false)
LuaUtils.SetActive(e.BiComs["im_selfMarry"].transform,false)
LuaUtils.SetActive(e.BiComs["im_marry"].transform,false)
LuaUtils.SetActive(e.BiComs["marry_kuang"].transform,false)
LuaUtils.SetActive(e.BiComs["selfmarry_kuang"].transform,false)
LuaUtils.SetActive(e.BiComs["im_lord"].transform,false)
if a.bgSetType==t.EBgSetType.Marry then
LuaUtils.SetActive(e.BiComs["im_marry"].transform,true)
LuaUtils.SetActive(e.BiComs["marry_kuang"].transform,true)
elseif a.bgSetType==t.EBgSetType.SelfMarry then
LuaUtils.SetActive(e.BiComs["im_selfMarry"].transform,true)
LuaUtils.SetActive(e.BiComs["selfmarry_kuang"].transform,true)
elseif a.bgSetType==t.EBgSetType.LordProfile then
LuaUtils.SetActive(e.BiComs["im_lord"].transform,true)
else
LuaUtils.SetActive(e.BiComs["starts"].transform,true)
LuaUtils.SetActive(e.BiComs["im_zhiye"].transform,true)
LuaUtils.SetActive(e.BiComs["im_pinzhi"].transform,true)
local o=a.rankLevel
local t=HeroMgr:GetHeroDataByHeroDId(a.id)
if t and t.status>PROTO_ENUM.HeroStatus.UNACTIVE then
o=t.rankLevel
end
local t=LuaUtils.GetChildrenCount(e.BiComs["starts"].transform)
for t=1,t do
LuaUtils.SetActive(e.BiComs["im_start"..t].transform,t<=o)
end
LuaUtils.SetImageSprite(e.BiComs["im_zhiye"],UIUtil.GetProfessionIcon(a.profession),true)
local t=string.format("UICommonOther/%s",CardQuailtyFont[a.star])
LuaUtils.SetImageSprite(e.BiComs["im_pinzhi"],t,true)
UIUtil.HandlerHeroQualityImgEff(e.BiComs["im_pinzhi"],a.star,true,true)
end
local t,o=isSelected(a.id,a.bgSetType)
LuaUtils.SetActive(e.BiComs["p_select"].transform,t)
LuaUtils.SetActive(e.BiComs["select_num_bg"].transform,t)
if t then
local t=u..o
GameTools:SetImageSprite(e.BiComs["select_num_img"],t,false)
end
local t=isUsed(a.id,a.bgSetType)
LuaUtils.SetActive(e.BiComs["text_shiyong"].transform,t)
local o=isFrist(a.id,a.bgSetType)
LuaUtils.SetActive(e.BiComs["im_huangguan"].transform,o)
LuaUtils.SetActive(e.BiComs["bg_shiyongzhong"].transform,t or o)
if t and o then
LuaUtils.RebuildLayout(e.BiComs["bg_shiyongzhong"].transform)
end
local t=d:GetHeroRingUnlockCfg(a.id)
local t=getBgSetState(a,a.bgSetType)
LuaUtils.SetActive(e.BiComs["p_inactive"].transform,not t)
e.UserObjectData=n
LuaUtils.SetActive(e.BiComs["im_red"].transform,not ModulesInit.HeroShowMgr.GetPictureDisplayClick(a.id,a.bgSetType))
return e
end
function IsSelectMarryBg()
for e,a in ipairs(i)do
local a,e=getDataIndexAndType(e)
local a=i[a]
if isFrist(a.id,e)and(e==t.EBgSetType.Marry or e==t.EBgSetType.SelfMarry)then
return true
end
end
return false
end
function UpdateVoSelectMenuBtnState(e)
if l then
LuaUtils.DoTweenScaleY(bg_zhiye.transform,1,0.1)
LuaUtils.SetCanvasAlpha(bg_zhiye.transform,1)
else
LuaUtils.DoTweenScaleY(bg_zhiye.transform,0,0.1)
LuaUtils.DoTweenAlpha(bg_zhiye.transform,0,0.1)
end
l=not l
if e then
if n~=a.All then
if n==a.UnderWear then
LuaUtils.SetImageSprite(btn_voselect.transform,"UIButton/BTN_main_underwear")
elseif n==a.Battle then
LuaUtils.SetImageSprite(btn_voselect.transform,"UIButton/BTN_main_normal")
elseif n==a.Marry then
LuaUtils.SetImageSprite(btn_voselect.transform,"UIButton/icon_hjjiez")
elseif n==a.SelfMarry then
LuaUtils.SetImageSprite(btn_voselect.transform,"UIButton/icon_hjjiez2")
elseif n==a.LordProfile then
LuaUtils.SetImageSprite(btn_voselect.transform,"UIButton/BTN_main_chengzhu")
else
GameTools:SetImageSprite(btn_voselect.transform,UIUtil.GetProfessionPath(n))
end
else
GameTools:SetImageSprite(btn_voselect.transform,"UICommonOther/BTN_buzhen_04")
end
end
end
function GetBattleBgList(e,o)
local t=t.EBgSetType.Battle
local a={}
for i,e in ipairs(e)do
if o==nil or e.profession==o then
local i,o=getHeroState(e,t)
local t={bgSetType=t,bgName=e.heroName,bgSortId=2,isActive=i,activeTime=o or 0}
setmetatable(t,{__index=e})
table.add(a,t)
end
end
return a
end
function GetUnderWearBgList(e,a)
local t=t.EBgSetType.UnderWear
local o={}
for i,e in ipairs(e)do
if a==nil or e.profession==a then
local i,a=getHeroState(e,t)
local t={bgSetType=t,bgName=e.heroName,bgSortId=3,isActive=i,activeTime=a or 0}
setmetatable(t,{__index=e})
table.add(o,t)
end
end
return o
end
function GetMarryBgList(e,a)
local t=t.EBgSetType.Marry
local o={}
local e=FilterMarryHeroData(e)
for i,e in ipairs(e)do
if a==nil or e.profession==a then
local i,a=getHeroState(e,t)
local t={bgSetType=t,bgName=e.heroName,bgSortId=5,isActive=i,activeTime=a or 0}
setmetatable(t,{__index=e})
table.add(o,t)
end
end
return o
end
function GetSelfMarryBgList(e,a)
local t=t.EBgSetType.SelfMarry
local o={}
local e=FilterSelfMarryHeroData(e)
for i,e in ipairs(e)do
if a==nil or e.profession==a then
local a,i=getHeroState(e,t)
local t={bgSetType=t,bgName=e.heroName,bgSortId=4,isActive=a,activeTime=i or 0}
setmetatable(t,{__index=e})
table.add(o,t)
end
end
return o
end
function GetLordBgList(e)
local t=t.EBgSetType.LordProfile
local a={}
for o,e in ipairs(e)do
local o=PlayerMgr:IsHasAvailableLordProfile(e.id)
local t={bgSetType=t,bgName=e.profileName,bgSortId=1,isActive=o,activeTime=0}
setmetatable(t,{__index=e})
table.add(a,t)
end
return a
end
function GetBgListByProfession(a,t)
local e=GetBattleBgList(a,t)
local o=GetUnderWearBgList(a,t)
table.appendList(e,o)
local o=GetMarryBgList(a,t)
table.appendList(e,o)
local a=GetSelfMarryBgList(a,t)
table.appendList(e,a)
if t==nil then
local t=PlayerMgr:GetAllProfileList()
local t=GetLordBgList(t)
table.appendList(e,t)
end
return e
end
function GetBgList(e)
local o=GetAllHandBookHeroData()
local t={}
if e==a.All then
t=GetBgListByProfession(o,nil)
elseif e==a.ProfessionTypeTank
or e==a.ProfessionTypeMage
or e==a.ProfessionTypeWarrior
then
t=GetBgListByProfession(o,e)
elseif e==a.Battle then
t=GetBattleBgList(o,nil)
elseif e==a.UnderWear then
t=GetUnderWearBgList(o,nil)
elseif e==a.Marry then
t=GetMarryBgList(o,nil)
elseif e==a.SelfMarry then
t=GetSelfMarryBgList(o,nil)
elseif e==a.LordProfile then
local e=PlayerMgr:GetAllProfileList()
t=GetLordBgList(e)
end
return t
end
function VoSelect(e)
local s=#i
n=e
local t=function(e)
table.sort(
e,
function(e,t)
if e.isActive~=t.isActive then
return e.isActive==true
end
local a=ModulesInit.HeroShowMgr.GetPictureDisplayClick(e.id,e.bgSetType)
local o=ModulesInit.HeroShowMgr.GetPictureDisplayClick(t.id,t.bgSetType)
local a=not a
local o=not o
if a~=o then
return a
end
if e.bgSortId~=t.bgSortId then
return e.bgSortId<t.bgSortId
end
if e.activeTime~=t.activeTime then
return e.activeTime<t.activeTime
end
return e.id<t.id
end
)
end
local e=GetBgList(n)
t(e)
i=e
refreshView(s)
end
function getBtnGaobaiStatus()
if GameTools:IsUseNormalRes()then
return true
else
if d:CheckNeiYiBtnShow()then
return false
else
return true
end
end
end
function GetAllHandBookHeroData()
return d.GetHeroOnHandBook(true)
end
function FilterMarryHeroData(e)
local t={}
for a,e in pairs(e)do
if e.isMarry~=0 then
if h[e.id]then
local a=h[e.id]
if TimeUtil.serverTimeStep>TimeUtil.String2ToTimeStamp2(a)then
table.add(t,e)
end
else
table.add(t,e)
end
end
end
return t
end
function FilterSelfMarryHeroData(e)
local t={}
for a,e in pairs(e)do
if e.isMarry~=0 then
if h[e.id]then
local a=h[e.id]
if TimeUtil.serverTimeStep>TimeUtil.String2ToTimeStamp2(a)then
local a=HeroMgr:IsVoicesCfgAnimGroupIsActivity(e.id,MarryExpressionGroup.selfExpression)
if a then
table.add(t,e)
end
end
else
local a=HeroMgr:IsVoicesCfgAnimGroupIsActivity(e.id,MarryExpressionGroup.selfExpression)
if a then
table.add(t,e)
end
end
end
end
return t
end
function getHeroStateActivity(t)
local e=false
local t=HeroMgr:GetHeroDataByHeroDId(t.id)
if t and t.status>PROTO_ENUM.HeroStatus.UNACTIVE then
e=true
end
return e
end
function getHeroStateActivity2(t)
local e=false
local t=HeroMgr:GetHeroDataByHeroDId(t.id)
if t and t.status>PROTO_ENUM.HeroStatus.UNACTIVE then
e=true
end
if e then
e=false
if t.loverGrade>=HeroMgr:GetHaremUnlockUnderwear(t)then
e=true
end
end
return e
end
function getHeroStateActivityForMarry(t)
local e=false
if HeroMgr:MarryIsActive(t.id)then
e=true
end
return e
end
function getHeroStateActivityForSelfMarry(t)
local e=false
if HeroMgr:MarryIsActive(t.id)and HeroMgr:GetHeroMarryAnimStatus(t.id,MarryExpressionGroup.selfExpression)then
e=true
end
return e
end
function onSave()
if#o<=0 then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Homepage.SelectBG.15",LanguageCategory.LangCommon))
return
end
if not GameTools:ClientIsSupportLive2D()and IsSelectMarryBg()then
GameTools:ShowNotSupportLive2DTips()
return
end
local t,e=PlayerMgr:sendMainBg(o)
t.onCompleted=function()
PlayerMgr:MainPageHeroInfoSyn({heros=o})
PlayerMgr.PlayerInfo.showHeroIndex=e
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Homepage.SelectBG.16",LanguageCategory.LangCommon))
closeUI()
EventSystem.SendEvent(CommonEventId.OnMainBgChange)
end
end
function onMainBgChange(e)
if e then
o[PlayerMgr.PlayerInfo.showHeroIndex].heroDid=e.heroDid
o[PlayerMgr.PlayerInfo.showHeroIndex].isUnderwear=e.isUnderwear
o[PlayerMgr.PlayerInfo.showHeroIndex].isMarry=e.isMarry
o[PlayerMgr.PlayerInfo.showHeroIndex].isSelfMarry=e.isSelfMarry
end
VoSelect(n)
end
function onFavorabilityRefresh()
llv_bg:RefreshAllShownItem()
end
function closeUI()
if s<llv_bg.transform.rect.width then
s=llv_bg.transform.rect.width
end
local e=math.floor(s/204)
for e=1,e do
local e,t=getDataIndexAndType(e)
local e=i[e]
if e and e.id then
ModulesInit.HeroShowMgr.SetPictureDisplayClick(e.id,t,1)
end
end
r=true
EventSystem.SendEvent(CommonEventId.OnAtlasAndExhibitionRefresh)
GameTools.CloseUIForm(UIFormId.UI_BgSet)
end
function llvDragBegin()
end
function llvDraging()
local e=llv_bg.transform.rect.width-llv_bg.ContainerTrans.localPosition.x
if e>s then
s=e
end
end
function llvDragEnd()
local e=llv_bg.transform.rect.width-llv_bg.ContainerTrans.localPosition.x
if e>s then
s=e
end
end
function OnClose()
llv_bg:SetListItemCount(0)
EventSystem.RemoveListener(CommonEventId.OnMainBgChange,onMainBgChange)
EventSystem.RemoveListener(CommonEventId.OnFavorabilityRefresh,onFavorabilityRefresh)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.OnAtlasAndExhibitionRefresh,OnGetNewHeroRefresh)
r=false
end
function OnBeforeDestroy()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

