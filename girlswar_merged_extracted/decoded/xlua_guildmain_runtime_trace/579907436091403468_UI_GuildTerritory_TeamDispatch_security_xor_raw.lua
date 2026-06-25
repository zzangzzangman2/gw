local k=require('DataNode/DataTable/Create/model/DTmodelDBModel')
local x=require('DataNode/DataTable/Create/monster/DTMonsterDBModel')
local e=require('DataNode/DataManager/DataMgr/DataUtil')
local z=require('DataNode/DataTable/Create/monster/DTMonsterAttrDBModel')
local e=require('DataNode/DataTable/Create/hero/DTHeroInitialDBModel')
local j=require('DataNode/DataTable/Create/hero/DTHeroDBModel')
local q=require("Common/cs_coroutine")
local l=require('Modules/Formation/FormationModel')
local b=table.add
local e=table.deepCopy
local _=ModulesInit.GuildTerritoryMgr
local u=true
local d
local y={
[4]=1,[1]=1,
[5]=2,[2]=2,
[6]=3,[3]=3
}
local e={}
local v={}
local p={}
local h=1
local r=1
local e={}
local f={}
local w={}
local a=nil
local t=ModulesInit.FormationManager
local n=0
local m=0
local c=0
local e=nil
local o=0
local s
local i={}
local g
function OnInit(t,t)
e=l.New()
e:SetContext({
formationNoList={PROTO_ENUM.FormationNO.FN_NONE,},
formationType=FormationType.Pre,
trans=Substitution,
canChange=function()
return o==0
end,
changeCallback=function(e)
if o~=0 then return false end
o=0
UpdateOnwerFormationStyle()
PlayCutFormationEffect()
end
})
btn_help.onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="houbu"})
end)
btn_return.onClick:AddListener(function()
GameTools.CloseUIForm(self.UIFormId)
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
btn_onekey.onClick:AddListener(function()
OnClickOneKey()
end)
btn_begin.onClick:AddListener(function()
OnClickBegin()
end)
LuaUtils.GetUIEventListener(im_li).onClick=function()
a=LuaUtils.StartUIBlur(function()
LuaUtils.SetBlurToImage(blurImage)
LuaUtils.SetActive(PropertyRestraint,true)
end)
end
self:AddBtnClickListener(PropertyRestraint:Find('bgBtn/Image'):GetComponent(typeof(CS.UnityEngine.UI.Button)),function()
LuaUtils.SetActive(PropertyRestraint,false)
LuaUtils.DisposeBlur(a)
end)
LuaUtils.SetLocalScale(bg_zhiye,1,0,1)
nameFollowCom=nameFollow:GetComponent(typeof(CS.YouYou.UIFollow))
end
function OnOpen(a)
p=a
g=a.onStartBattle
v={}
local i=a.taskUseTime
m=0
c=0
s=nil
o=0
e:SetDefaultFormationType(FormationType.Pre)
local a=t:CreateNullFormationDataStructure()
local t=t:CreateNullFormationDataStructure()
e:UpdateFormationData(a,t)
e:UpdateState()
UpdateOnwerFormationStyle()
VoSelect(0)
UIUtil.SetFormationHeadPos(headGrid)
LuaUtils.SetImageSprite(btn_voselect.transform,'UICommonOther/BTN_buzhen_01')
UpdateFightValueStyle()
EventSystem.AddListener(CommonEventId.FormationChange,OnFormationChange)
local a,t,e=TimeUtil.TimestampToDate(i,true)
local e=string.format("%02d:%02d:%02d",a,t,e)
LuaUtils.SetTextMeshText(text_needTime,e)
UIUtil.DelayCall(self.UIFormId,0.7,function()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="OPEN_UI_RADAR_TEAM_SUC"})
end)
OnClickOneKey()
end
function CreatePlayerModel(a,s,c,d,u)
local t=a.heroDid
local e=a.heroId
local i
local m=c:Find('spine')
local l=CurrCanvas.sortingOrder+y[s]*2
if d then
if t then
local e=x.GetEntity(t)
if e then
i=k.GetEntity(e.modelID)
b(v,e)
local e=z.GetEntity(t)
end
end
else
local e=c:GetComponent(typeof(CS.YouYou.UIDragDropItem))
if e then
e.param2=s
e.param3=nil
SetHeroTitleNameStyle(e)
end
local o=SetHeroPosUnLockStyle(s)

if o then
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
i=HeroMgr:GetSkinModelCfgByHeroData(a)
if e then
local t=j.GetEntity(t)
local a=GameTools.GetLocalize(t.heroName,LanguageCategory.LangBattle)
e.param3=string.format("%s&%d&%d",a,t.profession,t.leaderType)
SetHeroTitleNameStyle(e)
end
end
end
end
local e=LuaUtils.GetChild(m,0)
UIUtil.SmallSpinePoolDespawn(e)
if i then
n=n+2
o=o+1
local s=a.heroPet and a.heroPet or 0
if d then
s=1
end
local e=UIUtil.DelayLoad(
i,
n,
function(i,n,e)
local a={}
if d then
a=Vector3(-110,110,110)
else
a=Vector3(110,110,110)
end
local a={
scale=a,
}
UIUtil.HandlePoolUISmallRolePrefab(i,n,e,m,a)
LuaUtils.SetMeshRenderer(n,l)
if e~=nil then
LuaUtils.SetMeshRenderer(e,l-1)
end
o=o-1
local e,a,a=LuaUtils.GetLocalScale(i,sx,sy,sz)
if d then
r=e
else
h=e
end
i.name=tostring(t)
if u then
u()
end
end,
s
)
table.insert(w,e)
end
end
function SetHeroTitleNameStyle(a)
local t=a.param2
local t=UIUtil.GetChild(nameRoot,t-1)
if not a.param3 then
LuaUtils.SetActive(t,false)
UIUtil.RefreshEmbattleCampion(ourRoot,nameRoot,e.curFormationType)
return
end
LuaUtils.SetActive(t,true)
local a=string.split(a.param3,"&")
UIUtil.RefreshEmbattleName(t.transform,a)
UIUtil.RefreshEmbattleCampion(ourRoot,nameRoot,e.curFormationType)
end
function DestroySpine(e,t)
local e=UIUtil.GetChild(e:Find('spine'),0)
if e then
if t then
LuaUtils.SetLocalScale(e,r,r,r)
else
LuaUtils.SetLocalScale(e,h,h,h)
end
GameEntry.Pool:GameObjectDespawn(e)
end
end
function OnDragerItemClick(s)

local n=e:GetCurFormationData()
local a=s:GetComponent(typeof(CS.YouYou.UIDragDropItem))
local i=a.param2
local o=a.param1
local h,r=ModulesInit.FormationManager:PosIsUnlock(i,e.curFormationType)
if not h then
return
end
local h=t:FormationIsAllowDownBattle(n)
if o and o~=0 and not h then
UIUtil.ShowCommonTipsForLocalize('UI.Campaign.StageSelect.39')
return
end
a.param1=0
a.param3=nil
DestroySpine(s)
SetHeroTitleNameStyle(a)
t:HeroDownBattle(n,i)
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
UIUtil.ShowCommonTipsForLocalize('候補陣布陣画面で先発キャラを帰陣させることはできません')
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
function OnDragerItemBeginDrag(a)

local t=a:GetComponent(typeof(CS.YouYou.UIDragDropItem))
if t and t.drager then
local i=t.param2
local o=UIUtil.GetChild(nameRoot,i-1)
LuaUtils.SetActive(o,false)
local e,i=ModulesInit.FormationManager:PosIsUnlock(i,e.curFormationType)
if not e then
return
end
s=a
local a=t.drager.transform
local e=UIUtil.GetPetSpine(t.drager.transform)
local n,i
local a=LuaUtils.GetMaterials(a)
for e=1,#a do
n=LuaUtils.MaterialDoTweenToAlpha(a[e],0.3,0.5,-1,1)
end
if e then
LuaUtils.SetMeshRenderer(e,9999)
local t=e:GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
t.AnimationState:SetAnimation(0,"stand",true)
t.enabled=false
local e=LuaUtils.GetMaterials(e)
for t=1,#e do
i=LuaUtils.MaterialDoTweenToAlpha(e[t],0.3,0.5,-1,1)
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
f={}
end
end
local a=nil
function OnDragerItemPointerUp(t)
local o=t:GetComponent(typeof(CS.YouYou.UIDragDropItem))

nameFollowCom.target=nil
LuaUtils.SetLocalPos(nameFollow,9999,0,0)
LuaUtils.SetActive(nameFollow,false)
a=nil
if not o then
return
end
local o=o.param2
local e,i=ModulesInit.FormationManager:PosIsUnlock(o,e.curFormationType)

if not e then
return
end
local o=CurrCanvas.sortingOrder+y[o]*2-1
if s then
local e=s:Find("spine")
if e then
local e=LuaUtils.GetChild(e,0)
local e=UIUtil.GetPetSpine(e)
if e then
local t=e:GetComponent(typeof(CS.UnityEngine.MeshRenderer))
LuaUtils.SetMeshRenderer(e,o)
end
end
s=nil
end
local e=nil
if a then
e=a.name
end
if e==t.name then
OnReset(t)
end
end
function OnReset(e)
local e=e:GetComponent(typeof(CS.YouYou.UIDragDropItem))
for e=1,#f do
f[e]:Kill()
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
b(o,e)
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
function GetHeroSpineRoot(o)
for e=1,6 do
local e=LuaUtils.GetChild(ourRoot,e-1)
if e then
local t=e:GetComponent(typeof(CS.YouYou.UIDragDropItem))
local a=t.param1
local t=t.param2
if a==o then
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
local t=t:ResetFormationFightValue(e.preFormationData)
local t=t
local e=GetTotalFirstValue(e.preFormationData.positions)
local e=e
OnNumberRoll(ourTotalFightLabel,m,t,0.5)
OnNumberRoll(ourJulioLabel,c,e,0.5,true)
m=t
c=e
end
function OnNumberRoll(o,e,t,n,i)
local s=0
local a=t-e
local e=CS.DG.Tweening.DOTween.To(
function()
return s
end,
function(t)
if i then
LuaUtils.SetLabelTextWrap(o,e+math.floor(t*a))
else
LuaUtils.SetLabelText(o,e+math.floor(t*a))
end
end,
1,
n
)
end
function UpdateVoSelectListView()
VoSelect(d)
end
function VoSelect(n)
i={}
local a=_:GetTmpHerosList()
if n~=0 then
for e=1,#a do
local e=a[e]
if e.prof==n then
table.add(i,e)
end
end
else
i=a
end
table.sort(i,function(t,e)
if t.fight~=e.fight then
return t.fight>e.fight
else
return t.heroId>e.heroId
end
end)
LuaUtils.SetChildrenActive(headGrid,false)
for n=1,#i do
local i=i[n]
local a=UIUtil.GetChild(headGrid,n-1)
if not a then
a=LuaUtils.Instantiate(head.transform)
LuaUtils.SetParent(a,headGrid)
LuaUtils.SetLocalScale(a,1,1,1)
local e,t,o=LuaUtils.GetLocalPos(a)
LuaUtils.SetLocalPos(a,e,t,0)
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
LuaUtils.SetActive(jiantou,#i>10)
d=n
end
function UpdateVoSelectMenuBtnState(e)
if u then
LuaUtils.DoTweenScaleY(bg_zhiye,1,0.1);
LuaUtils.SetCanvasAlpha(bg_zhiye.transform,1)
else
LuaUtils.DoTweenScaleY(bg_zhiye,0,0.1);
LuaUtils.DoTweenAlpha(bg_zhiye.transform,0,0.1)
end
u=not u
if e then
if d~=0 then
LuaUtils.SetImageSprite(btn_voselect.transform,UIUtil.GetProfessionPath(d))
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
UIUtil.StopSequence(self.UIFormId)
SpinesDespawn()
ApplyFormationData(true)
EventSystem.RemoveListener(CommonEventId.FormationChange,OnFormationChange)
for t,e in ipairs(w or{})do
q.stop(e)
end
w={}
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
function ClearPosTransData(e)
for t=1,6 do
local e=UIUtil.GetChild(e,t-1)
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
function OnClickOneKey()
if o~=0 then
return false
end
o=0
local a=t:CreateNullFormationDataStructure()
local o=t:CreateNullFormationDataStructure()
for t=1,#a.positions do
local e=i[t]
if e==nil then
break
end
a.positions[t].heroId=e.heroId
a.positions[t].heroDid=e.heroDid
end
e:UpdateFormationData(a,o)
e:UpdateState()
local e=e:GetCurFormationData()
PlayCutFormationEffect(e,ourRoot)
UpdateOnwerFormationStyle()
UpdateFightValueStyle()
UpdateVoSelectListView()
end
function OnClickBegin()
if o~=0 then return false end
if g then
local a=true
for t=1,6 do
local o=0
if e.preFormationData and e.preFormationData.positions[t]
and e.preFormationData.positions[t].heroId then
if e.preFormationData.positions[t].heroId>0 then
a=false
end
end
end
if a then
UIUtil.ShowCommonTipsForLocalize('UI_GuildTerritory_teamEmpty')
return
end
local e={
positions=e.preFormationData.positions,
}
p.onStartBattle(e)
end
end
function OnBeforeDestroy()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

