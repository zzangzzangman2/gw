local z=require('DataNode/DataTable/Create/model/DTmodelDBModel')
local A=require('DataNode/DataTable/Create/monster/DTMonsterDBModel')
local e=require('DataNode/DataManager/DataMgr/DataUtil')
local E=require('DataNode/DataTable/Create/monster/DTMonsterAttrDBModel')
local e=require('DataNode/DataTable/Create/hero/DTHeroInitialDBModel')
local T=require('DataNode/DataTable/Create/hero/DTHeroDBModel')
local _=require("Common/cs_coroutine")
local q=require('Modules/Formation/FormationModel')
local m=table.add
local e=table.deepCopy
local f=true
local d
local r=false
local o=0
local j={
[4]=1,[1]=1,
[5]=2,[2]=2,
[6]=3,[3]=3
}
local e={}
local u={}
local k={}
local a={}
local l=1
local c=1
local i=false
local b={}
local v={}
local p=nil
local t=ModulesInit.FormationManager
local s=0
local w=0
local y=0
local e=nil
local n=nil
local x=0
local h
local g=0
function OnInit(i,i)
e=q.New()
e:SetContext({
formationNoList={PROTO_ENUM.FormationNO.FN_GUILDRADAR,},
trans=Substitution,
canChange=function()
return o==0
end,
changeCallback=function(t)
if o~=0 then return false end
o=0
UpdateOnwerFormationStyle()
local e=e:GetCurFormationData()
PlayCutFormationEffect(e,ourRoot)
end
})
n=q.New()
n:SetContext({
isEnemy=true,
trans=Substitution2,
canChange=function()
return o==0
end,
changeCallback=function(e)
o=0
if o~=0 then return false end
if e==FormationType.Pre then
CreatePlayers(a.enemyFormaData)
else
CreatePlayers(a.enemyFormaData2)
end
local e=n:GetCurFormationData()
PlayCutFormationEffect(e,enemyRoot)
return true
end
})
btn_help.onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="houbu"})
end)
btn_return.onClick:AddListener(function()
if r and TimeUtil.GetServerTimeStamp()-g<5 then
return
end
GameTools.CloseUIForm(self.UIFormId)
if r then
if a.onStartBattleRetrun then
a.onStartBattleRetrun()
end
end
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
btn_tanhao.onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_PhotoArtistView,{helpId="arena.xianshou"})
end)
LuaUtils.SetActive(btn_tanhao.transform,false)
btn_tiaozhan.onClick:AddListener(function()
if r then
return
end
local a=function()
g=TimeUtil.GetServerTimeStamp()
r=true
LuaUtils.SetActive(collider,true)
SetTiaoZhanBtnState('out',false,function()
e:SaveFormationData()
SetHideAllDragArena(false)
LuaUtils.SetActive(collider,false)
local e={
positions=e.preFormationData.positions,
summonPetFormation=e.preFormationData.summonPetFormation,
}

a.onStartBattle(e)
end)
LuaUtils.DoTweenSnakePos(main,0.4,60,0,0,30,0,0.1)
end
local t=function()
local e=e.preFormationData
local o=HeroMgr:GetActiviedHeroData()
if t:GetBattleHeroCount(e)==0 then
UIUtil.ShowCommonTipsForLocalize("UI.Tower.Goal.28")
return
end
if#o>=6 and t:GetBattleHeroCount(e)<6 then
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
p=LuaUtils.StartUIBlur(function()
LuaUtils.SetBlurToImage(blurImage)
LuaUtils.SetActive(PropertyRestraint,true)
end)
end
btn_kezhi.onClick:AddListener(function()
p=LuaUtils.StartUIBlur(function()
LuaUtils.SetBlurToImage(blurImage)
LuaUtils.SetActive(PropertyRestraint,true)
end)
end)
self:AddBtnClickListener(PropertyRestraint:Find('bgBtn/Image'):GetComponent(typeof(CS.UnityEngine.UI.Button)),function()
LuaUtils.SetActive(PropertyRestraint,false)
LuaUtils.DisposeBlur(p)
end)
LuaUtils.SetLocalScale(bg_zhiye,1,0,1)
nameFollowCom=nameFollow:GetComponent(typeof(CS.YouYou.UIFollow))
end
function OnOpen(o)
a=o
x=a.enemyFightExt or 0
g=0
r=false
u={}
k={}
s=5
w=0
y=0
h=nil
SetHideAllDragArena(true)
e:SetDefaultFormationType(FormationType.Pre)
local o=CheckAndGetTeam()
local t=t:CreateNullFormationDataStructure()
e:UpdateFormationData(o,t)
e:UpdateState()
n:SetDefaultFormationType(FormationType.Pre)
n:UpdateOtherFormationData(a.enemyFormaData)
n:CheckOpen(false)
n:UpdateState()
UpdateOnwerFormationStyle()
CreatePlayers(a.enemyFormaData)
VoSelect(0)
UIUtil.SetFormationHeadPos(headGrid)
LuaUtils.SetImageSprite(btn_voselect.transform,"UICommonOther/BTN_buzhen_01")
UpdateFightValueStyle()
UpdateHeroTotalView()
EventSystem.AddListener(CommonEventId.FormationChange,OnFormationChange)
LuaUtils.SetActive(collider,false)
SetTiaoZhanBtnState(
"in",
false,
function()
SetTiaoZhanBtnState("idle",true)
end
)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
LuaUtils.SetActive(im_li.transform,false)
RefreshSummonPets()
end
function CheckAndGetTeam()
local e=t:GetFormationData(PROTO_ENUM.FormationNO.FN_GUILDRADAR)
if e then
local a=e.positions
for t=1,6 do
if a[t]then
if a[t].heroDid~=0 then
return e
end
end
end
end
local e=t:CreateNullFormationDataStructure(PROTO_ENUM.FormationNO.FN_GUILDRADAR)
e.positions=t:GetFormationDataCopy(PROTO_ENUM.FormationNO.formatioFN_MAINnNO).positions
return e
end
function CreatePlayers(o)
s=5
i=a.isNpc
do
for e=1,6 do
local o=t:GetForPositionDataByIndex2(o,e)
local t=t:GetPositonHeroData(a.enemyHeros,o)
local t=t or o
local a=UIUtil.GetChild(enemyRoot,e-1)
if t and t.heroId~=0 then
CreatePlayerModel(t,e,a,i,not i)
else
CreatePlayerModel(t,e,a,i,i)
end
end
end
end
function CreatePlayerModel(t,h,d,f,p,w)
local a
if t then
a=t.heroDid
end
local e
if t then
e=t.heroId
end
local i
local y=d:Find('spine')
local r=CurrCanvas.sortingOrder+j[h]*2
local n=0
if f then
if a then
local e=A.GetEntity(a)
if e then
i=z.GetEntity(e.modelID)
m(u,e)
local e=E.GetEntity(a)
m(k,e)
end
end
n=1
else
local e=d:GetComponent(typeof(CS.YouYou.UIDragDropItem))
if e then
e.param2=h
e.param3=nil
SetHeroTitleNameStyle(e)
end
local o=true
if not p then
o=SetHeroPosUnLockStyle(h)
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
e.param1=a
end
if a then
if p then
i=UIUtil.GetHeroModelCfgData(a)
n=t.heroFightPet and t.heroFightPet or 0
else
i=HeroMgr:GetSkinModelCfgByHeroData(t)
n=t.heroPet and t.heroPet or 0
end
if e then
local t=T.GetEntity(a)
local a=GameTools.GetLocalize(t.heroName,LanguageCategory.LangBattle)
e.param3=string.format("%s&%d&%d",a,t.profession,t.leaderType)
SetHeroTitleNameStyle(e)
end
end
end
end
local e=LuaUtils.GetChild(y,0)
UIUtil.SmallSpinePoolDespawn(e)
if i then
s=s+2
o=o+1
local e=UIUtil.DelayLoad(
i,
s,
function(i,n,t)
local e={}
if d.parent.name=='root2'then
e=Vector3(-100,100,100)
else
e=Vector3(100,100,100)
end
local e={
scale=e,
}
UIUtil.HandlePoolUISmallRolePrefab(i,n,t,y,e)
LuaUtils.SetMeshRenderer(n,r)
if t~=nil then
LuaUtils.SetMeshRenderer(t,r-1)
end
o=o-1
local e,t,t=LuaUtils.GetLocalScale(i,sx,sy,sz)
if f then
c=e
else
l=e
end
i.name=tostring(a)
if w then
w()
end
end,
n
)
table.insert(v,e)
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
LuaUtils.SetLocalScale(e,c,c,c)
else
LuaUtils.SetLocalScale(e,l,l,l)
end
GameEntry.Pool:GameObjectDespawn(e)
end
end
function OnDragerItemClick(n)

local i=e:GetCurFormationData()
local a=n:GetComponent(typeof(CS.YouYou.UIDragDropItem))
local o=a.param2
local s=a.param1
local h,r=ModulesInit.FormationManager:PosIsUnlock(o,e.curFormationType)
if not h then
return
end
local h=t:FormationIsAllowDownBattle(i)
if s and s~=0 and not h then
UIUtil.ShowCommonTipsForLocalize('UI.Campaign.StageSelect.39')
return
end
a.param1=0
a.param3=nil
DestroySpine(n)
SetHeroTitleNameStyle(a)
t:HeroDownBattle(i,o)
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
PlayTopForEffect(ourRoot,a.param2)
ApplyFormationData()
end
function OnHeroHeadItemClick(a)

local n=false
local o=nil
local i=nil
if e.curFormationType==FormationType.Pre then
local s=t:GetHeroIsJoinById(e.subFormationData,a.heroId)
if s then
if t:FormationIsFull(e.preFormationData)then
UIUtil.ShowCommonTipsForLocalize('flowerFight_92')
return
else
local n=s.heroId
t:HeroDownBattle(e.subFormationData,s.position)
local a=t:GetFormationEmptyPos(e.preFormationData)
if a then
t:HeroUpBattle(e.preFormationData,a,n)
UpdateFightValueStyle()
UpdateVoSelectListView()
e:UpdateState()
o,i=FindZhanwei()
end
end
else
n=t:GetHeroIsJoinById(e.preFormationData,a.heroId)
if not n then
o,i=FindZhanwei()
if o and i then
t:HeroUpBattle(e.preFormationData,o,a.heroId)
end
end
end
elseif e.curFormationType==FormationType.Substitute then
local s=t:GetHeroIsJoinById(e.preFormationData,a.heroId)
if s then
UIUtil.ShowCommonTipsForLocalize('候補陣布陣画面で先発キャラを帰陣させることはできません')
return
end
local s=t:GetHeroIsJoinById(e.subFormationData,a.heroId)
if not s then
if t:GetFormationUpCount(e.preFormationData)<6 then
UIUtil.ShowCommonTipsForLocalize('flowerFight_75')
return
end
end
n=t:GetHeroIsJoinById(e.subFormationData,a.heroId)
if not n then
o,i=FindZhanwei()
if o and i then
t:HeroUpBattle(e.subFormationData,o,a.heroId)
end
end
end
if n then
local e=GetHeroSpineRoot(a.heroDid)
if e then
OnDragerItemClick(e)
end
return
end
if o and i then
local t=HeroMgr:GetHeroDataByHeroId(a.heroId)
s=0
CreatePlayerModel(t,o,i,false,false,function()
PlayTopForEffect(ourRoot,o)
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
local o=t.param2
local a=UIUtil.GetChild(nameRoot,o-1)
LuaUtils.SetActive(a,false)
local e,o=ModulesInit.FormationManager:PosIsUnlock(o,e.curFormationType)
if not e then
return
end
h=i
local o=t.drager.transform
local e=UIUtil.GetPetSpine(t.drager.transform)
local i,n
local o=LuaUtils.GetMaterials(o)
for e=1,#o do
i=LuaUtils.MaterialDoTweenToAlpha(o[e],0.3,0.5,-1,1)
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
local e=LuaUtils.Instantiate(a)
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
b={}
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
local a=CurrCanvas.sortingOrder+j[a]*2-1
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
for e=1,#b do
b[e]:Kill()
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
if not e then
e={firstValue=0,position=t}
end
local t,a=GetHeroSpineInfo(t)
if t and t~=0 then
local a=HeroMgr:GetHeroDataByHeroDId(t)
e.heroId=a.heroId
e.heroDid=a.heroDid
if e.firstValue==0 then
local a=HeroMgr:GetHeroDataByHeroDId(t)
local t=0
for o=1,#a.attribute do
local e=a.attribute[o]
if(e.id==HeroAttrId.first)then
t=e.value
end
end
e.firstValue=t
end
else
e.heroId=0
e.heroDid=0
end
m(o,e)
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
local o=t:ResetFormationFightValue(e.preFormationData)
local t=t:ResetFormationFightValue(e.subFormationData)
local t=o+t+PlayerMgr.PlayerExtInfo.fightExt
local o=GetTotalFirstValue(e.preFormationData.positions)
local e=GetTotalFirstValue(e.subFormationData.positions)
local o=o+e+(PlayerMgr.PlayerInfo.firstValueExt or 0)
OnNumberRoll(ourTotalFightLabel,w,t,0.5)
OnNumberRoll(ourJulioLabel,y,o,0.5,true)
if i then
LuaUtils.SetLabelText(enemyTotalFightLabel,GetTotalFightValue(u))
LuaUtils.SetLabelTextWrap(enemyJulioLabel,GetTotalFirstValue(k))
else
local e=0
if a.enemyFormaData2 then
e=a.enemyFormaData2.fightTotal
end
LuaUtils.SetLabelText(enemyTotalFightLabel,a.enemyFormaData.fightTotal+e+x)
local e=0
if a.enemyFormaData2 then
e=a.enemyFormaData2.firstTotal
end
LuaUtils.SetLabelTextWrap(enemyJulioLabel,a.enemyFormaData.firstTotal+e)
end
LuaUtils.SetActive(our_spine_guanzhi.transform,false)
LuaUtils.SetActive(our_officer_show_num.transform,false)
local e=0
if i then
local t=u[1]
if t then
e=t.monOfficer
end
else
e=a.enemyPlayerInfo.officer
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
w=t
y=o
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
VoSelect(d)
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
LuaUtils.SetActive(jiantou,#o>10)
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(1)
e:AppendCallback(
function()
CS.YouYou.GuideMgr.AddCom(UIFormId.UI_ArenaEmbattle,"arenaEmBattleTiaozhanTrans",btn_tiaozhan)
CS.YouYou.GuideMgr.AddCom(UIFormId.UI_ArenaEmbattle,"arenaEmBattleTiaozhanTrans_touch",btn_tiaozhan)
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="OPEN_ARENAEMBATTLEVIEW_SUC"})
end
)
d=s
end
function UpdateVoSelectMenuBtnState(e)
if f then
LuaUtils.DoTweenScaleY(bg_zhiye,1,0.1);
LuaUtils.SetCanvasAlpha(bg_zhiye.transform,1)
else
LuaUtils.DoTweenScaleY(bg_zhiye,0,0.1);
LuaUtils.DoTweenAlpha(bg_zhiye.transform,0,0.1)
end
f=not f
if e then
if d~=0 then
LuaUtils.SetImageSprite(btn_voselect.transform,UIUtil.GetProfessionPath(d))
else
LuaUtils.SetImageSprite(btn_voselect.transform,'UICommonOther/BTN_buzhen_04')
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
function PlayTopForEffect(t,e)
local e=UIUtil.GetChild(t,e-1)
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
function OnEventNetReconnectSuccess()
end
function OnClose()
SpinesDespawn()
EventSystem.RemoveListener(CommonEventId.FormationChange,OnFormationChange)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.OnSummonPetFormationChange,RefreshSummonPetsOnEvent)
EventSystem.RemoveListener(CommonEventId.OnRespSummonPetLevelUp,RefreshSummonPetsOnEvent)
EventSystem.RemoveListener(CommonEventId.OnRespSummonPetStarUp,RefreshSummonPetsOnEvent)
if SummonPetMgr:GetSummonPetUnlock()then
local e=SummonPets_Our.transform:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Close()
local e=SummonPets_Enemy.transform:GetComponent(typeof(CS.YouYou.LuaUnit))
e:Close()
end
for t,e in ipairs(v or{})do
_.stop(e)
end
v={}
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
s=5
do
formationData=e:GetCurFormationData()
for e=1,6 do
local t=t:GetForPositionDataByIndex(formationData,e)
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
function PlayCutFormationEffect(e,o)
for a=1,6 do
local e=t:GetForPositionDataByIndex(e,a)
local t=UIUtil.GetChild(o,a-1)
if e and e.heroId~=0 then
PlayTopForEffect(o,e.position)
end
end
end
function UpdateHeroTotalView()
local e=t:GetBattleHeroCount(e.preFormationData)+t:GetBattleHeroCount(e.subFormationData)
local t=6
LuaUtils.SetLabelTextWrap(text_heroTotal,e,t)
end
function UpdateBg(e)
local t=LuaUtils.GetLuaComBinder(common_battle_prepare.transform)
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

