local _=require('DataNode/DataTable/Create/model/DTmodelDBModel')
local N=require('DataNode/DataTable/Create/monster/DTMonsterDBModel')
local e=require('DataNode/DataManager/DataMgr/DataUtil')
local O=require('DataNode/DataTable/Create/monster/DTMonsterAttrDBModel')
local e=require('DataNode/DataTable/Create/hero/DTHeroInitialDBModel')
local j=require('DataNode/DataTable/Create/hero/DTHeroDBModel')
local I=require("Common/cs_coroutine")
local q=require('Modules/Formation/FormationModel')
local f=table.add
local e=table.deepCopy
local m=true
local c
local r=false
local k={
[4]=1,[1]=1,
[5]=2,[2]=2,
[6]=3,[3]=3
}
local x=nil
local e={}
local d={}
local b={}
local A={}
local a={}
local u=1
local l=1
local i=false
local E=nil
local T=nil
local z=nil
local g={}
local t=ModulesInit.FormationManager
local v=ModulesInit.CSGuildWarManager
local n=0
local y={}
local w=0
local p=0
local e=nil
local s=nil
local o=0
local h
function OnInit(i,i)
e=q.New()
e:SetContext({
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
UpdateBg(e)
end
})
s=q.New()
s:SetContext({
isEnemy=true,
trans=Substitution2,
canChange=function()
return o==0
end,
changeCallback=function(e)
if o~=0 then return false end
o=0
if e==FormationType.Pre then
CreatePlayers(a.enemyFormaData,false)
else
CreatePlayers(a.enemyFormaData2,true)
end
end
})
btn_help.onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="houbu"})
end)
btn_return.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarEmbattle)
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
btn_tiaozhan.onClick:AddListener(function()
if r then
return
end
local a=function()
r=true
SetTiaoZhanBtnState('out',false,function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarEmbattle)
if a.onStartBattle then
a.onStartBattle(e.preFormationData.positions,e.subFormationData.positions)
end
end)
LuaUtils.DoTweenSnakePos(main,0.4,60,0,0,30,0,0.1)
end
local t=function()
local e=e.preFormationData
if t:GetBattleHeroCount(e)<=0 then
UIUtil.ShowCommonTipsForLocalize('UI.Cross.Prepare.18')
return
end
if#HeroMgr.heros>=6 and t:GetBattleHeroCount(e)<6 then
local e={
text=GameTools.GetLocalize('UI.Campaign.Tips.01',LanguageCategory.LangCommon,6),
okBtnContent=GameTools.GetLocalize('UI.Campaign.StageSelect.25'),
buttons=MessageBoxButtons.OKCancel,
cancelBtnContext=GameTools.GetLocalize('UI.Campaign.StageSelect.26'),
onOkBtnClick=function()
a()
end
}
UIUtil.ShowMessageBox(e)
return
end
a()
end
if e:CheckFormationAllowSave()then
t()
end
end)
LuaUtils.GetUIEventListener(im_li).onClick=function()
x=LuaUtils.StartUIBlur(function()
LuaUtils.SetBlurToImage(blurImage)
LuaUtils.SetActive(PropertyRestraint,true)
end)
end
self:AddBtnClickListener(PropertyRestraint:Find('bgBtn/Image'):GetComponent(typeof(CS.UnityEngine.UI.Button)),function()
LuaUtils.SetActive(PropertyRestraint,false)
LuaUtils.DisposeBlur(x)
end)
btn_report.onClick:AddListener(function()
if r then
return
end
local e=v:SendSeePlayerRecordRequest(v.CurReqBattleGroundInfo.battleGroundId,a.playerInfo.playerId)
e.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_CSGuildWarRecord,{playerInfo=a.playerInfo,isDef=true,records=v.CurReqPlayerRecord.records})
end
end)
LuaUtils.SetLocalScale(bg_zhiye,1,0,1)
nameFollowCom=nameFollow:GetComponent(typeof(CS.YouYou.UIFollow))
end
function OnOpen(o)
a=o
r=false
d={}
b={}
A={}
n=5
w=0
p=0
h=nil
UpdateBg(FormationType.Pre)
e:CheckOpen(true)
e:SetDefaultFormationType(FormationType.Pre)
local o=t:CreateNullFormationDataStructure()
local i=t:CreateNullFormationDataStructure()
e:UpdateFormationData(o,i)
e:UpdateState()
s:SetDefaultFormationType(FormationType.Pre)
s:UpdateOtherFormationData(a.enemyFormaData,a.enemyFormaData2)
s:CheckOpen(false)
s:UpdateState()
E=t:GetFormationData(PROTO_ENUM.FormationNO.FN_GUILD_WAR_DEF)
T=t:GetFormationData(PROTO_ENUM.FormationNO.FN_GUILD_WAR_DEF_ALTER)
UpdateOnwerFormationStyle()
CreatePlayers(a.enemyFormaData,false)
VoSelect(0)
UIUtil.SetFormationHeadPos(headGrid)
GameTools:SetImageSprite(btn_voselect.transform,'UICommonOther/BTN_buzhen_01')
LuaUtils.SetLabelTextWrap(text_chuci,a.playerInfo.leftHpGrade)
LuaUtils.SetLabelTextWrap(text_chuci2,a.playerInfo.leftGrade)
UpdateFightValueStyle()
SetTiaoZhanBtnState('in',false,function()
SetTiaoZhanBtnState('idle',true)
end)
UpdateHeroTotalView()
EventSystem.AddListener(CommonEventId.FormationChange,OnFormationChange)
RefreshSummonPets()
end
function CreatePlayers(e,o)
n=5
if a then
i=a.isNpc
end
do
local n={}
for o=1,6 do
local t=t:GetForPositionDataByIndex2(e,o)
local s=UIUtil.GetChild(enemyRoot,o-1)
local e=nil
if t and t.heroId~=0 then
for o,a in pairs(a.playerInfo.heros)do
if a.heroDid==t.heroDid and a.curHp>0 then
e=a
end
end
if not e then
for o,a in pairs(a.playerInfo.alterHeros)do
if a.heroDid==t.heroDid and a.curHp>0 then
e=a
end
end
end
if e then
CreatePlayerModel(e,o,s,i,not i)
else
CreatePlayerModel({},o,s,i,i)
end
else
CreatePlayerModel({},o,s,i,i)
end
SetHeroTitleNameStyle2(o,e)
if e then
table.insert(n,{heroDid=e.heroDid or 0})
else
table.insert(n,{heroDid=0})
end
end
UIUtil.RefreshEmbattleCampionByHeroData(nameRoot_enemy,s.curFormationType,n)
end
end
function CreatePlayerModel(a,s,c,m,w,v)
local t=a.heroDid
local e=a.heroId
local i
local p=c:Find('spine')
local r=CurrCanvas.sortingOrder+k[s]*2
local h=0
if m then
if t then
local e=N.GetEntity(t)
if e then
i=_.GetEntity(e.modelID)
f(d,e)
local e=O.GetEntity(t)
f(b,e)
end
end
h=1
else
local e=c:GetComponent(typeof(CS.YouYou.UIDragDropItem))
if e then
e.param2=s
e.param3=nil
SetHeroTitleNameStyle(e)
end
local o=true
if not w then
o=SetHeroPosUnLockStyle(s)
end

if o then
if e then
e.enabled=true
e.gameObject.tag='DragArea'
e.baseSortingOrder=r
e.onClick=OnDragerItemClick
e.onBeginDrag=OnDragerItemBeginDrag
e.onPointerDown=OnDragerItemPointerDown
e.onPointerUp=OnDragerItemPointerUp
e.onReset=OnReset
e.param1=t
end
if t then
if w then
i=UIUtil.GetHeroModelCfgData(t)
h=a.heroFightPet and a.heroFightPet or 0
else
i=HeroMgr:GetSkinModelCfgByHeroData(a)
h=a.heroPet and a.heroPet or 0
end
if e then
local t=j.GetEntity(t)
local a=GameTools.GetLocalize(t.heroName,LanguageCategory.LangBattle)
e.param3=string.format("%s&%d&%d",a,t.profession,t.leaderType)
SetHeroTitleNameStyle(e)
end
end
end
end
local e=LuaUtils.GetChild(p,0)
UIUtil.SmallSpinePoolDespawn(e)
if i then
n=n+2
o=o+1
local e=UIUtil.DelayLoad(
i,
n,
function(i,n,a)
local e={}
if c.parent.name=='root2'then
e=Vector3(-100,100,100)
else
e=Vector3(100,100,100)
end
local e={
scale=e,
}
UIUtil.HandlePoolUISmallRolePrefab(i,n,a,p,e)
LuaUtils.SetMeshRenderer(n,r)
if a~=nil then
LuaUtils.SetMeshRenderer(a,r-1)
end
o=o-1
local e,a,a=LuaUtils.GetLocalScale(i,sx,sy,sz)
if m then
l=e
else
u=e
end
i.name=tostring(t)
if v then
v()
end
end,
h
)
table.insert(y,e)
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
function SetHeroTitleNameStyle2(t,e)
local t=UIUtil.GetChild(nameRoot_enemy,t-1)
if e then
LuaUtils.SetActive(t,true)
local o=j.GetEntity(e.heroDid)
local a={}
table.insert(a,GameTools.GetLocalize(o.heroName,LanguageCategory.LangBattle))
table.insert(a,o.profession)
UIUtil.RefreshEmbattleName(t.transform,a,true)
local t=LuaUtils.GetLuaComBinder(t.transform)
local t=t:GetComponents()
local t=LuaUtils.GetLuaComBinder(t['UI_Common_HeadHpItem'].transform)
local t=t:GetComponents()
LuaUtils.SetImageFillAmount(t['imgHP'],e.curHp/e.totalHp)
LuaUtils.SetImageFillAmount(t['imgFury'],e.curAnger/e.totalAnger)
UIUtil.SetHpBarColor(t["imgHP"],e.curHp/e.totalHp)
else
LuaUtils.SetActive(t,false)
end
end
function DestroySpine(e,t)
local e=UIUtil.GetChild(e:Find('spine'),0)
if e then
if t then
LuaUtils.SetLocalScale(e,l,l,l)
else
LuaUtils.SetLocalScale(e,u,u,u)
end
GameEntry.Pool:GameObjectDespawn(e)
end
end
function OnDragerItemClick(i)

local o=e:GetCurFormationData()
local a=i:GetComponent(typeof(CS.YouYou.UIDragDropItem))
local s=a.param2
local n=a.param1
local h,r=ModulesInit.FormationManager:PosIsUnlock(s,e.curFormationType)
if not h then
return
end
local h=t:FormationIsAllowDownBattle(o)
if n and n~=0 and not h then
UIUtil.ShowCommonTipsForLocalize('UI.Campaign.StageSelect.39')
return
end
a.param1=0
a.param3=nil
DestroySpine(i)
SetHeroTitleNameStyle(a)
t:HeroDownBattle(o,s)
UpdateVoSelectListView()
ApplyFormationData()
UpdateFightValueStyle()
e:UpdateState()
UpdateHeroTotalView()
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
function OnHeroHeadItemClick(a)

local o=GetHeroIsDeath(a.heroId)
if o then
UIUtil.ShowCommonTipsForLocalize('tips.common_65')
return
end
local s=false
local o=nil
local i=nil
if e.curFormationType==FormationType.Pre then
local n=t:GetHeroIsJoinById(e.subFormationData,a.heroId)
if n then
if t:FormationIsFull(e.preFormationData)then
UIUtil.ShowCommonTipsForLocalize('flowerFight_92')
return
else
local s=n.heroId
t:HeroDownBattle(e.subFormationData,n.position)
local a=t:GetFormationEmptyPos(e.preFormationData)
if a then
t:HeroUpBattle(e.preFormationData,a,s)
UpdateFightValueStyle()
UpdateVoSelectListView()
e:UpdateState()
o,i=FindZhanwei()
end
end
else
s=t:GetHeroIsJoinById(e.preFormationData,a.heroId)
if not s then
o,i=FindZhanwei()
if o and i then
t:HeroUpBattle(e.preFormationData,o,a.heroId)
end
end
end
elseif e.curFormationType==FormationType.Substitute then
local n=t:GetHeroIsJoinById(e.preFormationData,a.heroId)
if n then
UIUtil.ShowCommonTipsForLocalize('선발 진영에 있는 무장을 후발 진영에 배치시킬 수 없습니다.')
return
end
local n=t:GetHeroIsJoinById(e.subFormationData,a.heroId)
if not n then
if t:GetFormationUpCount(e.preFormationData)<6 then
UIUtil.ShowCommonTipsForLocalize('flowerFight_75')
return
end
end
s=t:GetHeroIsJoinById(e.subFormationData,a.heroId)
if not s then
o,i=FindZhanwei()
if o and i then
t:HeroUpBattle(e.subFormationData,o,a.heroId)
end
end
end
if s then
local e=GetHeroSpineRoot(a.heroDid)
if e then
OnDragerItemClick(e)
end
return
end
if o and i then
local t=HeroMgr:GetHeroDataByHeroId(a.heroId)
n=0
CreatePlayerModel(t,o,i,false,false,function()
PlayTopForEffect(o)
UpdateVoSelectListView()
ApplyFormationData()
UpdateFightValueStyle()
e:UpdateState()
UpdateHeroTotalView()
end)
local e=HeroMgr:GetHeroSkinHeroDid(a.heroDid)
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
h=i
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
g={}
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
local a=CurrCanvas.sortingOrder+k[a]*2-1
if h then
local e=h:Find("spine")
if e then
local e=LuaUtils.GetChild(e,0)
local e=UIUtil.GetPetSpine(e)
if e then
local t=e:GetComponent(typeof(CS.UnityEngine.MeshRenderer))
LuaUtils.SetMeshRenderer(e,a)
end
end
h=nil
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
for e=1,#g do
g[e]:Kill()
end
if not IsNil(e.drager)then
local e=e.param2
local e=UIUtil.GetChild(nameRoot,e-1)
LuaUtils.SetActive(e,true)
end
end
function ApplyFormationData(t)
local i=function(t,e)
for a,t in pairs(t.positions)do
if t.position==e then
return t
end
end
return{firstValue=0,position=e}
end
local t=e:GetCurFormationData()
local a={}
for o=1,6 do
local e=i(t,o)
local t,o=GetHeroSpineInfo(o)
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
f(a,e)
end
t.positions=a
e:UpdateCurFormationData(t)
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
local o=t:ResetFormationFightValue(e.preFormationData)
local t=t:ResetFormationFightValue(e.subFormationData)
local o=o+t+PlayerMgr.PlayerExtInfo.fightExt
local t=GetTotalFirstValue(e.preFormationData.positions)
local e=GetTotalFirstValue(e.subFormationData.positions)
local t=t+e+(PlayerMgr.PlayerInfo.firstValueExt or 0)
OnNumberRoll(ourTotalFightLabel,w,o,0.5)
OnNumberRoll(ourJulioLabel,p,t,0.5,true)
if i then
LuaUtils.SetLabelText(enemyTotalFightLabel,GetTotalFightValue(d))
LuaUtils.SetLabelTextWrap(enemyJulioLabel,GetTotalFirstValue(b))
else
LuaUtils.SetLabelText(enemyTotalFightLabel,a.enemyFightTotal)
LuaUtils.SetLabelTextWrap(enemyJulioLabel,a.enemyFormaData.firstTotal+a.enemyFormaData2.firstTotal)
end
LuaUtils.SetActive(our_spine_guanzhi.transform,false)
LuaUtils.SetActive(our_officer_show_num.transform,false)
if PlayerMgr.PlayerInfo.officer and PlayerMgr.PlayerInfo.officer>0 then
LuaUtils.SetActive(our_spine_guanzhi.transform,true)
LuaUtils.SetActive(our_officer_show_num.transform,true)
UIUtil.SpinePlayAnimation(our_spine_guanzhi,0,UIUtil.GetOfficerNumPath(PlayerMgr.PlayerInfo.officer),true)
LuaUtils.SetTextMeshText(our_officer_show_num,ModulesInit.OfficerMgr:getOfficeSmallLevelShow(PlayerMgr.PlayerInfo.officer))
end
local e=0
if i then
local t=d[1]
if t then
e=t.monOfficer
end
else
e=a.playerInfo.officer
end
LuaUtils.SetActive(enemy_img_yazhi.transform,false)
LuaUtils.SetActive(our_img_yazhi.transform,false)
LuaUtils.SetActive(enemy_spine_guanzhi.transform,false)
if e and e>0 then
LuaUtils.SetActive(enemy_spine_guanzhi.transform,true)
UIUtil.SpinePlayAnimation(enemy_spine_guanzhi,0,UIUtil.GetOfficerNumPath(e),true)
LuaUtils.SetTextMeshText(enemy_officer_show_num,ModulesInit.OfficerMgr:getOfficeSmallLevelShow(e))
end
if e then
if PlayerMgr.PlayerInfo.officer>e then
LuaUtils.SetActive(our_img_yazhi.transform,true)
local e=ModulesInit.OfficerMgr:getAddFirstByOfficer(PlayerMgr.PlayerInfo.officer)
LuaUtils.SetTextMeshText(our_text_yahei_num,e.."%")
elseif PlayerMgr.PlayerInfo.officer<e then
LuaUtils.SetActive(enemy_img_yazhi.transform,true)
local e=ModulesInit.OfficerMgr:getAddFirstByOfficer(e)
LuaUtils.SetTextMeshText(enemy_text_yahei_num,e.."%")
end
end
w=o
p=t
end
function OnNumberRoll(t,e,o,n,i)
local a=0
local o=o-e
local e=CS.DG.Tweening.DOTween.To(
function()
return a
end,
function(a)
if i then
LuaUtils.SetLabelTextWrap(t,e+math.floor(a*o))
else
LuaUtils.SetLabelText(t,e+math.floor(a*o))
end
end,
1,
n
)
end
function UpdateVoSelectListView()
VoSelect(c)
end
function GetHeroIsDeath(e)
local t=HeroIsDefFormation(e)
local e=GetHeroBattledCount(e)
if t then
return e>=2
else
return e>=1
end
end
function GetHeroBattledCount(t)
local e=0
for o,a in pairs(a.attHeroIds)do
if t==a then
e=e+1
end
end
return e
end
function HeroIsDefFormation(t)
local e=ModulesInit.CSGuildWarManager.CurBattleInfo
if e~=0 then
local e=e.ownerInfo.players
for a,e in pairs(e)do
if e.playerId==PlayerMgr.PlayerInfo.uid then
for a,e in pairs(e.heroOrders)do
if e==t then
return true
end
end
end
end
end
return false
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
table.sort(o,function(t,e)
local o=0
local a=0
local i=GetHeroIsDeath(t.heroId)
local n=GetHeroIsDeath(e.heroId)
if i~=n then
if i then
o=1
end
if n then
a=1
end
return o>a
else
if t.fight~=e.fight then
return t.fight>e.fight
else
return t.heroDid>e.heroDid
end
end
end)
LuaUtils.SetChildrenActive(headGrid,false)
for n=1,#o do
local o=o[n]
local a=UIUtil.GetChild(headGrid,n-1)
if not a then
a=LuaUtils.Instantiate(head.transform)
LuaUtils.SetParent(a,headGrid)
LuaUtils.SetLocalScale(a,1,1,1)
local t,e,o=LuaUtils.GetLocalPos(a)
LuaUtils.SetLocalPos(a,t,e,0)
end
LuaUtils.SetActive(a,true)
UIUtil.SetHeroHead(a,o)
local i=a:Find('im_zhan'):GetComponent(typeof(CS.YouYou.YouYouImage))
local s=t:GetHeroIsJoinById(e.preFormationData,o.heroId)
if s then
LuaUtils.SetActive(i.transform,true)
LuaUtils.SetChildActive(a,'im_zhezhao',true)
GameTools:SetImageSprite(i,'UICommonOther/multilang_IC_buzhen_chuzhan')
LuaUtils.SetChildActive(a,'order',false)
UIUtil.SetGray(a,false)
else
local e=t:GetHeroIsJoinById(e.subFormationData,o.heroId)
if e then
LuaUtils.SetActive(i.transform,true)
LuaUtils.SetChildActive(a,'im_zhezhao',true)
GameTools:SetImageSprite(i,'UICommonOther/multilang_IC_fuxiaotb')
LuaUtils.SetChildActive(a,'order',false)
UIUtil.SetGray(a,false)
else
local t=false
LuaUtils.SetActive(i.transform,false)
LuaUtils.SetChildActive(a,'im_zhezhao',false)
LuaUtils.SetChildActive(a,'order',true)
local i=a:Find('order/text'):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
local n=HeroIsDefFormation(o.heroId)
local e=GetHeroBattledCount(o.heroId)
if n then
LuaUtils.SetLabelTextWrap(i,2-e,2)
t=e>=2
else
LuaUtils.SetLabelTextWrap(i,1-e,1)
t=e>=1
end
UIUtil.SetGray(a,t)
end
end
a.name=tonumber(n)
local e=a:GetComponent(typeof(CS.UnityEngine.UI.Button))
e.onClick:RemoveAllListeners()
e.onClick:AddListener(function()
OnHeroHeadItemClick(o)
end)
end
LuaUtils.SetActive(jiantou,#o>10)
c=s
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
if c~=0 then
GameTools:SetImageSprite(btn_voselect.transform,UIUtil.GetProfessionPath(c))
else
GameTools:SetImageSprite(btn_voselect.transform,'UICommonOther/BTN_buzhen_04')
end
end
end
function GetTotalFightValue(e)
local t=0
for a=1,#e do
local e=e[a].fight or e[a].monValue
t=t+e
end
return t
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
function SetTiaoZhanBtnState(e,a,t)
local o=tiaozhan_spine:GetComponent(typeof(CS.YouYou.UISpineCtr))
o:PlayAnimation(0,e,a,t)
if e=="out"or e=="out2"then
GameTools:PlayAudioLua(329)
end
end
function SpinesDespawn()
for e=1,6 do
local t=UIUtil.GetChild(ourRoot,e-1)
local e=UIUtil.GetChild(enemyRoot,e-1)
DestroySpine(t)
DestroySpine(e,true)
end
end
function OnClose()
SpinesDespawn()
EventSystem.RemoveListener(CommonEventId.FormationChange,OnFormationChange)
EventSystem.RemoveListener(CommonEventId.OnSummonPetFormationChange,RefreshSummonPetsOnEvent)
EventSystem.RemoveListener(CommonEventId.OnRespSummonPetLevelUp,RefreshSummonPetsOnEvent)
EventSystem.RemoveListener(CommonEventId.OnRespSummonPetStarUp,RefreshSummonPetsOnEvent)
if SummonPetMgr:GetSummonPetUnlock()then
local e=SummonPets_Our.transform:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Close()
local e=SummonPets_Enemy.transform:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Close()
end
for t,e in ipairs(y or{})do
I.stop(e)
end
y={}
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
z=e:GetCurFormationData()
for e=1,6 do
local t=t:GetForPositionDataByIndex(z,e)
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
local t=LuaUtils.GetLuaComBinder(common_battle_prepare.transform)
local t=t:GetComponents()
LuaUtils.SetActive(t["bg_2"].transform,e~=FormationType.Substitute)
LuaUtils.SetActive(t["bg_3"].transform,e==FormationType.Substitute)
end
function UpdateHeroTotalView()
local t=t:GetBattleHeroCount(e.preFormationData)+t:GetBattleHeroCount(e.subFormationData)
local e=6
for t=1,6 do
if ModulesInit.FormationManager:PosIsUnlock(t,FormationType.Substitute)then
e=e+1
end
end
LuaUtils.SetLabelTextWrap(text_heroTotal,t,e)
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
LuaUtils.SetActive(SummonPets_Enemy.transform,e)
if e then
local e=SummonPets_Enemy.transform:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Init()
if i then
e:Open({petDatas={}})
else
local t=a.summonPets
local a=a.summonPetFormation
e:Open({petDatas=t,formationData=a})
end
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

