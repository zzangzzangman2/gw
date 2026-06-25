local v=require('DataNode/DataTable/Create/model/DTmodelDBModel')
local k=require('DataNode/DataTable/Create/monster/DTMonsterDBModel')
local e=require('DataNode/DataManager/DataMgr/DataUtil')
local q=require('DataNode/DataTable/Create/monster/DTMonsterAttrDBModel')
local e=require('DataNode/DataTable/Create/hero/DTHeroInitialDBModel')
local g=require('DataNode/DataTable/Create/hero/DTHeroDBModel')
local b=require("Common/cs_coroutine")
local i=require('Modules/Formation/FormationModel')
local y=table.add
local e=table.deepCopy
local m=true
local h
local w={
[4]=1,[1]=1,
[5]=2,[2]=2,
[6]=3,[3]=3
}
local e={}
local p={}
local j={}
local r=1
local d=1
local e={}
local l={}
local f={}
local o=nil
local t=ModulesInit.FormationManager
local n=0
local u=0
local c=0
local e=nil
local a=0
local s
function OnInit(t,t)
e=i.New()
e:SetContext({
formationNoList={PROTO_ENUM.FormationNO.FN_GUILD_TRIAL,PROTO_ENUM.FormationNO.FN_GUILD_TRIAL_ALTER},
formationType=FormationType.Pre,
trans=Substitution,
canChange=function()
return a==0
end,
changeCallback=function(e)
if a~=0 then return false end
a=0
UpdateOnwerFormationStyle()
PlayCutFormationEffect()
UpdateBg(e)
end
})
btn_help.onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="houbu"})
end)
btn_return.onClick:AddListener(function()
e:CheckAndSaveFormationData(function()
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_EmBattle_View)
end)
end)
btn_voselect.onClick:AddListener(function()
UpdateVoSelectMenuBtnState()
end)
btn_all.onClick:AddListener(function()
VoSelect(0)
UpdateVoSelectMenuBtnState(true)
end)
btn_li.onClick:AddListener(function()
VoSelect(ProfessionType.Tank)
UpdateVoSelectMenuBtnState(true)
end)
btn_zhi.onClick:AddListener(function()
VoSelect(ProfessionType.Mage)
UpdateVoSelectMenuBtnState(true)
end)
btn_yong.onClick:AddListener(function()
VoSelect(ProfessionType.Warrior)
UpdateVoSelectMenuBtnState(true)
end)
LuaUtils.GetUIEventListener(im_li).onClick=function()
o=LuaUtils.StartUIBlur(function()
LuaUtils.SetBlurToImage(blurImage)
LuaUtils.SetActive(PropertyRestraint,true)
end)
end
self:AddBtnClickListener(PropertyRestraint:Find('bgBtn/Image'):GetComponent(typeof(CS.UnityEngine.UI.Button)),function()
LuaUtils.SetActive(PropertyRestraint,false)
LuaUtils.DisposeBlur(o)
end)
LuaUtils.SetLocalScale(bg_zhiye,1,0,1)
nameFollowCom=nameFollow:GetComponent(typeof(CS.YouYou.UIFollow))
end
function OnOpen(t)
j=t
p={}
u=0
c=0
s=nil
UpdateBg(FormationType.Pre)
e:CheckOpen(true)
e:SetDefaultFormationType(FormationType.Pre)
e:UpdateFormationData()
e:UpdateState()
UpdateOnwerFormationStyle()
VoSelect(0)
UIUtil.SetFormationHeadPos(headGrid)
LuaUtils.SetImageSprite(btn_voselect.transform,'UICommonOther/BTN_buzhen_01')
UpdateFightValueStyle()
EventSystem.AddListener(CommonEventId.FormationChange,OnFormationChange)
RefreshSummonPets()
end
function CreatePlayerModel(o,h,m,s,u)
local t=o.heroDid
local e=o.heroId
local i
local c=m:Find('spine')
local l=CurrCanvas.sortingOrder+w[h]*2
if s then
if t then
local e=k.GetEntity(t)
if e then
i=v.GetEntity(e.modelID)
y(p,e)
local e=q.GetEntity(t)
end
end
else
local e=m:GetComponent(typeof(CS.YouYou.UIDragDropItem))
if e then
e.param2=h
e.param3=nil
SetHeroTitleNameStyle(e)
end
local a=SetHeroPosUnLockStyle(h)
if a then
if e then
e.enabled=true
e.gameObject.tag='DragArea'
e.baseSortingOrder=l
e.onClick=OnDragerItemClick
e.onBeginDrag=OnDragerItemBeginDrag
e.onPointerDown=OnDragerItemPointerDown
e.onPointerUp=OnDragerItemPointerUp
e.onReset=OnReset
e.param1=t
end
if t then
i=HeroMgr:GetSkinModelCfgByHeroData(o)
if e then
local t=g.GetEntity(t)
local a=GameTools.GetLocalize(t.heroName,LanguageCategory.LangBattle)
e.param3=string.format("%s&%d&%d",a,t.profession,t.leaderType)
SetHeroTitleNameStyle(e)
end
end
end
end
local e=LuaUtils.GetChild(c,0)
UIUtil.SmallSpinePoolDespawn(e)
if i then
n=n+2
a=a+1
local h=o.heroPet and o.heroPet or 0
if s then
h=1
end
local e=UIUtil.DelayLoad(
i,
n,
function(o,n,e)
local i={}
if s then
i=Vector3(-110,110,110)
else
i=Vector3(110,110,110)
end
local i={
scale=i,
}
UIUtil.HandlePoolUISmallRolePrefab(o,n,e,c,i)
LuaUtils.SetMeshRenderer(n,l)
if e~=nil then
LuaUtils.SetMeshRenderer(e,l-1)
end
a=a-1
local e,a,a=LuaUtils.GetLocalScale(o,sx,sy,sz)
if s then
d=e
else
r=e
end
o.name=tostring(t)
if u then
u()
end
end,
h
)
table.insert(f,e)
end
end
function SetHeroTitleNameStyle(t)
local a=t.param2
local a=UIUtil.GetChild(nameRoot,a-1)
if not t.param3 then
LuaUtils.SetActive(a,false)
UIUtil.RefreshEmbattleCampion(ourRoot,nameRoot,e.curFormationType)
return
end
LuaUtils.SetActive(a,true)
local t=string.split(t.param3,"&")
UIUtil.RefreshEmbattleName(a.transform,t)
UIUtil.RefreshEmbattleCampion(ourRoot,nameRoot,e.curFormationType)
end
function DestroySpine(e,t)
local e=UIUtil.GetChild(e:Find('spine'),0)
if e then
if t then
LuaUtils.SetLocalScale(e,d,d,d)
else
LuaUtils.SetLocalScale(e,r,r,r)
end
GameEntry.Pool:GameObjectDespawn(e)
end
end
function OnDragerItemClick(o)

local s=e:GetCurFormationData()
local a=o:GetComponent(typeof(CS.YouYou.UIDragDropItem))
local i=a.param2
local n=a.param1
local h,r=ModulesInit.FormationManager:PosIsUnlock(i,e.curFormationType)
if not h then
return
end
local h=t:FormationIsAllowDownBattle(s)
if n and n~=0 and not h then
UIUtil.ShowCommonTipsForLocalize('UI.Campaign.StageSelect.39')
return
end
a.param1=0
a.param3=nil
DestroySpine(o)
SetHeroTitleNameStyle(a)
t:HeroDownBattle(s,i)
UpdateVoSelectListView()
ApplyFormationData()
UpdateFightValueStyle()
e:UpdateState()
end
function OnHeroHeadItemClick(o)

local s=false
local a=nil
local i=nil
if e.curFormationType==FormationType.Pre then
local n=t:GetHeroIsJoinById(e.subFormationData,o.heroId)
if n then
if t:FormationIsFull(e.preFormationData)then
UIUtil.ShowCommonTipsForLocalize('flowerFight_92')
return
else
local s=n.heroId
t:HeroDownBattle(e.subFormationData,n.position)
local o=t:GetFormationEmptyPos(e.preFormationData)
if o then
t:HeroUpBattle(e.preFormationData,o,s)
UpdateFightValueStyle()
UpdateVoSelectListView()
e:UpdateState()
a,i=FindZhanwei()
end
end
else
s=t:GetHeroIsJoinById(e.preFormationData,o.heroId)
if not s then
a,i=FindZhanwei()
if a and i then
t:HeroUpBattle(e.preFormationData,a,o.heroId)
end
end
end
elseif e.curFormationType==FormationType.Substitute then
local n=t:GetHeroIsJoinById(e.preFormationData,o.heroId)
if n then
UIUtil.ShowCommonTipsForLocalize('actDailyBossDesc_2')
return
end
local n=t:GetHeroIsJoinById(e.subFormationData,o.heroId)
if not n then
if t:GetFormationUpCount(e.preFormationData)<6 then
UIUtil.ShowCommonTipsForLocalize('flowerFight_75')
return
end
end
s=t:GetHeroIsJoinById(e.subFormationData,o.heroId)
if not s then
a,i=FindZhanwei()
if a and i then
t:HeroUpBattle(e.subFormationData,a,o.heroId)
end
end
end
if s then
local e=GetHeroSpineRoot(o.heroDid)
if e then
OnDragerItemClick(e)
end
return
end
if a and i then
local t=HeroMgr:GetHeroDataByHeroId(o.heroId)
n=0
CreatePlayerModel(t,a,i,false,function()
PlayTopForEffect(a)
UpdateVoSelectListView()
ApplyFormationData()
UpdateFightValueStyle()
e:UpdateState()
end)
local e=HeroMgr:GetHeroSkinHeroDid(o.heroDid)
UIUtil.PlayHeroFrontVoice(e)
return
end
if t:GetUnlockPosCount(e.curFormationType)==6 then
UIUtil.ShowCommonTipsForLocalize('UI.Campaign.StageSelect.27')
else
UIUtil.ShowCommonTipsForLocalize('flowerFight_74')
end
end
function FindZhanwei()
for t=1,6 do
local a=UIUtil.GetChild(ourRoot,t-1)
local e,o=ModulesInit.FormationManager:PosIsUnlock(t,e.curFormationType)
if e and LuaUtils.GetChildrenCount(a:Find('spine'))==0 then
return t,a
end
end
return nil,nil
end
function OnDragerItemBeginDrag(i)

local t=i:GetComponent(typeof(CS.YouYou.UIDragDropItem))
if t and t.drager then
local a=t.param2
local o=UIUtil.GetChild(nameRoot,a-1)
LuaUtils.SetActive(o,false)
local e,a=ModulesInit.FormationManager:PosIsUnlock(a,e.curFormationType)
if not e then
return
end
s=i
local a=t.drager.transform
local e=UIUtil.GetPetSpine(t.drager.transform)
local i,n
local a=LuaUtils.GetMaterials(a)
for e=1,#a do
i=LuaUtils.MaterialDoTweenToAlpha(a[e],0.3,0.5,-1,1)
end
if e then
LuaUtils.SetMeshRenderer(e,9999)
local t=e:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
t.AnimationState:SetAnimation(0,"stand",true)
t.enabled=false
local e=LuaUtils.GetMaterials(e)
for t=1,#e do
n=LuaUtils.MaterialDoTweenToAlpha(e[t],0.3,0.5,-1,1)
end
end
local e=LuaUtils.Instantiate(o)
LuaUtils.SetParent(e,t.drager)
LuaUtils.SetLocalScale(e,Vector3.one)
LuaUtils.SetActive(e,true)
local e=string.split(t.param3,"&")
nameFollowCom.target=t.drager
LuaUtils.SetActive(nameFollow,true)
UIUtil.RefreshEmbattleName(nameFollow.transform,e)
end
end
function OnDragerItemPointerDown(t)

local t=t:GetComponent(typeof(CS.YouYou.UIDragDropItem))
if t then
local t=t.param2
local e,t=ModulesInit.FormationManager:PosIsUnlock(t,e.curFormationType)
if not e then
return
end
l={}
end
end
local o=nil
function OnDragerItemPointerUp(t)
local a=t:GetComponent(typeof(CS.YouYou.UIDragDropItem))

nameFollowCom.target=nil
LuaUtils.SetLocalPos(nameFollow,9999,0,0)
LuaUtils.SetActive(nameFollow,false)
o=nil
if not a then
return
end
local a=a.param2
local e,i=ModulesInit.FormationManager:PosIsUnlock(a,e.curFormationType)

if not e then
return
end
local a=CurrCanvas.sortingOrder+w[a]*2-1
if s then
local e=s:Find("spine")
if e then
local e=LuaUtils.GetChild(e,0)
local e=UIUtil.GetPetSpine(e)
if e then
local t=e:GetComponent(typeof(CS.UnityEngine.MeshRenderer))
LuaUtils.SetMeshRenderer(e,a)
end
end
s=nil
end
local e=nil
if o then
e=o.name
end
if e==t.name then
OnReset(t)
end
end
function OnReset(e)
local e=e:GetComponent(typeof(CS.YouYou.UIDragDropItem))
for e=1,#l do
l[e]:Kill()
end
if not IsNil(e.drager)then
local e=e.param2
local e=UIUtil.GetChild(nameRoot,e-1)
LuaUtils.SetActive(e,true)
end
end
function ApplyFormationData(t)
local i=function(e,t)
for a,e in pairs(e.positions)do
if e.position==t then
return e
end
end
return{firstValue=0,position=t}
end
local a=e:GetCurFormationData()
local o={}
for t=1,6 do
local e=i(a,t)
local t,a=GetHeroSpineInfo(t)
if t and t~=0 then
local t=HeroMgr:GetHeroDataByHeroDId(t)
e.heroId=t.heroId
if e.firstValue==0 then
local a=0
for o=1,#t.attribute do
local e=t.attribute[o]
if(e.id==HeroAttrId.first)then
a=e.value
end
end
e.firstValue=a
end
else
e.heroId=0
end
y(o,e)
end
a.positions=o
e:UpdateCurFormationData(a)
end
function GetHeroSpineInfo(e)
local e=ourRoot:Find('zhanwei'..tostring(e))
if e then
local e=e:GetComponent(typeof(CS.YouYou.UIDragDropItem))
local t=e.param1
local e=e.param2
return t,e
end
return nil,nil
end
function GetHeroSpineRoot(a)
for e=1,6 do
local e=LuaUtils.GetChild(ourRoot,e-1)
if e then
local t=e:GetComponent(typeof(CS.YouYou.UIDragDropItem))
local o=t.param1
local t=t.param2
if o==a then
return e
end
end
end
return nil
end
function SetHideAllDragArena(t)
for e=1,6 do
local e=LuaUtils.GetChild(ourRoot,e-1)
if e then
local e=e:GetComponent(typeof(CS.YouYou.UIDragDropItem))
e.enabled=t
end
end
end
function UpdateFightValueStyle()
local a=t:ResetFormationFightValue(e.preFormationData)
local t=t:ResetFormationFightValue(e.subFormationData)
local t=a+t+PlayerMgr.PlayerExtInfo.fightExt
local a=GetTotalFirstValue(e.preFormationData.positions)
local e=GetTotalFirstValue(e.subFormationData.positions)
local e=a+e+(PlayerMgr.PlayerInfo.firstValueExt or 0)
OnNumberRoll(ourTotalFightLabel,u,t,0.5)
OnNumberRoll(ourJulioLabel,c,e,0.5,true)
u=t
c=e
end
function OnNumberRoll(t,e,a,i,n)
local o=0
local a=a-e
local e=CS.DG.Tweening.DOTween.To(
function()
return o
end,
function(o)
if n then
LuaUtils.SetLabelTextWrap(t,e+math.floor(o*a))
else
LuaUtils.SetLabelText(t,e+math.floor(o*a))
end
end,
1,
i
)
end
function UpdateVoSelectListView()
VoSelect(h)
end
function VoSelect(s)
local o={}
local a=HeroMgr:GetActiviedHeroData()
if s~=0 then
for e=1,#a do
local e=a[e]
if e.prof==s then
table.add(o,e)
end
end
else
o=a
end
table.sort(o,function(e,t)
if e.fight~=t.fight then
return e.fight>t.fight
else
return e.heroId>t.heroId
end
end)
LuaUtils.SetChildrenActive(headGrid,false)
for n=1,#o do
local i=o[n]
local a=UIUtil.GetChild(headGrid,n-1)
if not a then
a=LuaUtils.Instantiate(head.transform)
LuaUtils.SetParent(a,headGrid)
LuaUtils.SetLocalScale(a,1,1,1)
local t,e,o=LuaUtils.GetLocalPos(a)
LuaUtils.SetLocalPos(a,t,e,0)
end
LuaUtils.SetActive(a,true)
UIUtil.SetHeroHead(a,i)
local o=a:Find('im_zhan'):GetComponent(typeof(CS.YouYou.YouYouImage))
local s=t:GetHeroIsJoinById(e.preFormationData,i.heroId)
if s then
LuaUtils.SetActive(o.transform,true)
LuaUtils.SetChildActive(a,'im_zhezhao',true)
LuaUtils.SetImageSprite(o,'UICommonOther/multilang_IC_buzhen_chuzhan')
else
local e=t:GetHeroIsJoinById(e.subFormationData,i.heroId)
if e then
LuaUtils.SetActive(o.transform,true)
LuaUtils.SetChildActive(a,'im_zhezhao',true)
LuaUtils.SetImageSprite(o,'UICommonOther/multilang_IC_fuxiaotb')
else
LuaUtils.SetActive(o.transform,false)
LuaUtils.SetChildActive(a,'im_zhezhao',false)
end
end
a.name=tonumber(n)
local e=a:GetComponent(typeof(CS.UnityEngine.UI.Button))
e.onClick:RemoveAllListeners()
e.onClick:AddListener(function()
OnHeroHeadItemClick(i)
end)
end
LuaUtils.SetActive(jiantou,#o>10)
h=s
end
function UpdateVoSelectMenuBtnState(e)
if m then
LuaUtils.DoTweenScaleY(bg_zhiye,1,0.1);
LuaUtils.SetCanvasAlpha(bg_zhiye.transform,1)
else
LuaUtils.DoTweenScaleY(bg_zhiye,0,0.1);
LuaUtils.DoTweenAlpha(bg_zhiye.transform,0,0.1)
end
m=not m
if e then
if h~=0 then
LuaUtils.SetImageSprite(btn_voselect.transform,UIUtil.GetProfessionPath(h))
else
LuaUtils.SetImageSprite(btn_voselect.transform,'UICommonOther/BTN_buzhen_04')
end
end
end
function GetTotalFightValue(t)
local e=0
for a=1,#t do
local t=t[a].fight or t[a].monValue
e=e+t
end
return e
end
function GetTotalFirstValue(t)
local e=0
for a,t in pairs(t)do
local t=t.first or t.firstValue
if t then
e=e+t
end
end
return e
end
function PlayTopForEffect(e)
local e=UIUtil.GetChild(ourRoot,e-1)
LuaUtils.SetChildActive(e,'tiaozhandig',true)
end
function OnFormationChange(a)
local o=a[1]
local a=a[2]
SetHeroTitleNameStyle(o)
SetHeroTitleNameStyle(a)
local e=e:GetCurFormationData()


t:ExchangeFormationPosData(e,o.param2,a.param2)


SetHeroTitleNameStyle(o)
SetHeroTitleNameStyle(a)
PlayTopForEffect(a.param2)
ApplyFormationData()
end
function SpinesDespawn()
for e=1,6 do
local e=UIUtil.GetChild(ourRoot,e-1)
DestroySpine(e)
end
end
function OnClose()
SpinesDespawn()
ApplyFormationData(true)
EventSystem.RemoveListener(CommonEventId.FormationChange,OnFormationChange)
EventSystem.RemoveListener(CommonEventId.OnSummonPetFormationChange,RefreshSummonPetsOnEvent)
EventSystem.RemoveListener(CommonEventId.OnRespSummonPetLevelUp,RefreshSummonPetsOnEvent)
EventSystem.RemoveListener(CommonEventId.OnRespSummonPetStarUp,RefreshSummonPetsOnEvent)
if SummonPetMgr:GetSummonPetUnlock()then
local e=SummonPets_Our.transform:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Close()
end
for t,e in ipairs(f or{})do
b.stop(e)
end
f={}
end
function SetHeroPosUnLockStyle(a)
local t=UIUtil.GetChild(lockRoot,a-1)
local e,a=ModulesInit.FormationManager:PosIsUnlock(a,e.curFormationType)
if e then
LuaUtils.SetActive(t,false)
else
LuaUtils.SetActive(t,true)
local e=GameTools.GetLocalize("UI.Soul.Main.03",LanguageCategory.LangCommon,a.unlockPara[1])
LuaUtils.SetChildLabelTextMeshText(t,'text',e)
end
return e
end
function ClearPosTransData(t)
for e=1,6 do
local e=UIUtil.GetChild(t,e-1)
local e=e:GetComponent(typeof(CS.YouYou.UIDragDropItem))
e.baseSortingOrder=nil
e.onClick=nil
e.onBeginDrag=nil
e.onPointerDown=nil
e.onPointerUp=nil
e.onReset=nil
e.param1=nil
e.param2=nil
e.param3=nil
e.gameObject.tag='Untagged'
e.enabled=false
end
end
function UpdateOnwerFormationStyle()
ClearPosTransData(ourRoot)
n=5
do
local a=e:GetCurFormationData()
for e=1,6 do
local t=t:GetForPositionDataByIndex(a,e)
local a=UIUtil.GetChild(ourRoot,e-1)
if t and t.heroId~=0 then
local t=HeroMgr:GetHeroDataByHeroId(t.heroId)
if t then
CreatePlayerModel(t,e,a)
end
else
CreatePlayerModel({},e,a)
end
end
end
end
function PlayCutFormationEffect()
local e=e:GetCurFormationData()
for a=1,6 do
local e=t:GetForPositionDataByIndex(e,a)
local t=UIUtil.GetChild(ourRoot,a-1)
if e and e.heroId~=0 then
PlayTopForEffect(e.position)
end
end
end
function UpdateBg(e)
local t=LuaUtils.GetLuaComBinder(common_battle_prepare_2.transform)
local t=t:GetComponents()
LuaUtils.SetActive(t["bg_2"].transform,e~=FormationType.Substitute)
LuaUtils.SetActive(t["bg_3"].transform,e==FormationType.Substitute)
end
function RefreshSummonPets()
local e=SummonPetMgr:GetSummonPetUnlock()
LuaUtils.SetActive(SummonPets_Our.transform,e)
EventSystem.AddListener(CommonEventId.OnSummonPetFormationChange,RefreshSummonPetsOnEvent)
EventSystem.AddListener(CommonEventId.OnRespSummonPetLevelUp,RefreshSummonPetsOnEvent)
EventSystem.AddListener(CommonEventId.OnRespSummonPetStarUp,RefreshSummonPetsOnEvent)
if e then
local e=SummonPets_Our.transform:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Init()
e:Open()
e:Refresh()
end
end
function RefreshSummonPetsOnEvent()
if SummonPetMgr:GetSummonPetUnlock()then
local e=SummonPets_Our.transform:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Refresh()
end
end
function OnBeforeDestroy()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

