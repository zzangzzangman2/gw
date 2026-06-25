local k=require("DataNode/DataTable/Create/model/DTmodelDBModel")
local p=require("DataNode/DataTable/Create/hero/DTHeroDBModel")
local e=Constant.calc_award_time
local e=require("Common/cs_coroutine")
local e=string.format
local v=nil
local f
local b
local w
local y
local g=nil
local l=nil
local h={}
local r={}
local e
local s
local i
local m
local o={}
local a=false
local u=1
local c={}
local d
local t
local n={}
local n=ModulesInit.CSGuildWarManager
function OnInit(e,t)
btn_statistical.onClick:AddListener(
function()
GameEntry.UI:OpenUIForm(UIFormId.UI_ArenaStatistical,v)
end
)
bgBtn.onClick:AddListener(
function()
n:EnterWarProcedure()
GameTools.CloseUIForm(UIFormId.UI_GuildWarWin)
end
)
f=spine_win1:GetComponent(typeof(CS.YouYou.UISpineCtr))
b=spine_win2:GetComponent(typeof(CS.YouYou.UISpineCtr))
w=spine_win3:GetComponent(typeof(CS.YouYou.UISpineCtr))
y=spine_win4:GetComponent(typeof(CS.YouYou.UISpineCtr))
nameNode=e:Find('victory_spine_base/node_name')
btn_ready.onClick:AddListener(
function()
if u==1 then
u=2
c=r
RefreshHeroInfo(false)
LuaUtils.SetActive(text_title1.transform,false)
LuaUtils.SetActive(text_title2.transform,true)
LuaUtils.SetTextMeshText(txt_ready,GameTools.GetLocalize("flowerFight_80",LanguageCategory.LangCommon))
else
u=1
c=h
RefreshHeroInfo(false)
LuaUtils.SetActive(text_title1.transform,true)
LuaUtils.SetActive(text_title2.transform,false)
LuaUtils.SetTextMeshText(txt_ready,GameTools.GetLocalize("flowerFight_81",LanguageCategory.LangCommon))
end
end
)
end
function OnOpen(o)
GetAllEnemyHeroArr()
v=o
a=next(r)~=nil
u=1
c=h
if a then
d=head_root2
t=text_score2
else
d=head_root
t=text_score
end
LuaUtils.SetActive(normal,not a)
LuaUtils.SetActive(substitution,a)
LuaUtils.SetActive(mvpSpineContainer,false)
LuaUtils.SetActive(bgBtn.transform,false)
LuaUtils.SetActive(nameNode,false)
LuaUtils.SetActive(t.transform,false)
f:PlayAnimation(1,"A1",false)
b:PlayAnimation(
1,
"A1",
false,
function()
f:PlayAnimation(1,"A2",true)
end
)
w:PlayAnimation(0,"A1",false,function()
w:PlayAnimation(0,"A2",true)
end)
y:PlayAnimation(0,"A1",false,function()
y:PlayAnimation(0,"A2",true)
end)
if e then
e:Stop()
e=nil
end
e=ModulesInit.TimeActionMgr:CreateTimeAction()
e:Init(
0,
2,
1,
nil,
nil,
function()
EventSystem.SendEvent(CommonEventId.OnBattleEndUIShowComplete)
LoadMVP()
LuaUtils.SetActive(bgBtn.transform,true)
LuaUtils.SetActive(t.transform,true)
LuaUtils.SetTextMeshText(t,"")
end
)
e:Run()
local e=fight_info_trans.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
e.enabled=true
LuaUtils.AnimtorPlay(e,"Ani_common_victory",0,0)
RefreshHeroInfo(true)
StopDelayDamageSequence()
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(112*0.0333)
e:AppendCallback(function()
s=nil
PlayDamageAnim()
end)
s=e
StopNumTweener()
i=UIUtil.NumRoll(t,true,"UI.Awake.Exchange.09",0,n.CurStartBattleResult.fightInfo.grade,4.5,0.8,function()
end,function()
i=nil
end)
StopPlayFanTweener()
m=UIUtil.PlayWinPageFanAudio()
end
function PlayDamageAnim()
LuaUtils.SetActive(spine_knife.transform,true)
spine_knife:PlayAnimation(0,"A",true,function()
LuaUtils.SetActive(spine_knife.transform,false)
PlayDamageHpAnim()
end)
local e=d.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
e.enabled=true
LuaUtils.AnimtorPlay(e,"guildwar_win_hero_damage",0,0)
end
function PlayDamageHpAnim()
for t=1,6 do
local e=selfEnv["head_item_"..t]
local i=h[t]
local e=LuaUtils.GetLuaComBinder(e.transform)
local a=e:GetComponents()
LuaUtils.SetActive(a["head_empty"].transform,false)
LuaUtils.SetActive(a["head_normal"].transform,false)
if not i or i.heroId==0 then
LuaUtils.SetActive(a["head_empty"].transform,true)
else
LuaUtils.SetActive(a["head_normal"].transform,true)
local e=0
if i.maxHp>0 then
e=i.curHp/i.maxHp
end
e=math.max(0,e)
e=math.min(1,e)
local n=LuaUtils.GetImageFillAmount(a["imgHP"])
local i=0.5
local i=(n-e)*i
i=math.max(0,i)
StopFillAmountTweenBykey(t)
o[t]=a["imgHP"]:DOFillAmount(e,i):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(
function()
o[t]=nil
RefreshHeroInfoByPos(t,false)
end
)
end
end
end
function SetWinHeroNameInfo(e)
local e=p.GetEntity(e)
local e=k.GetEntity(e.modelID)
LuaUtils.SetLocalPos(nameNode,e.battleWinMvpname[1],e.battleWinMvpname[2],e.battleWinMvpname[3])
local t=nameNode:Find('im_heroname'):GetComponent(typeof(CS.YouYou.YouYouImage))
GameTools:SetImageSprite(t,e.starHeroName)
LuaUtils.SetActive(nameNode,true)
end
function LoadMVP()
local e=ModulesInit.ProcedureNormalBattle.GetMVPHeroDId()
UIUtil.GetPlayerBigSpine(e,mvpSpineContainer,'battleWinMvp',function(t)
g=t
l=UIUtil.PlayHeroMvpVoice(e)
end)
SetWinHeroNameInfo(e)
LuaUtils.SetActive(mvpSpineContainer,true)
end
function DestroySpine(e)
if(not IsNil(e))then
UIUtil.SpinePoolDespawn(e)
end
e=nil
if l then
GameEntry.Audio:StopAudio(l)
l=nil
end
end
function OnClose()
if e then
e:Stop()
e=nil
end
StopDelayDamageSequence()
StopAllFillAmountTween()
StopNumTweener()
StopPlayFanTweener()
ModulesInit.ProcedureNormalBattle.Dispose()
DestroySpine(g)
end
function OnBeforeDestroy()
end
function GetAllEnemyHeroArr()
local e=ModulesInit.ProcedureNormalBattle.FightPlayData
local e=e.waveData
local o=e[1].heroStatistics
local e=e[1].enemyTeamFormation
local e=n:GetLastBattleEnemyInfo()
local t=e.heros
local a=e.alterHeros
local function n(a)
for e=1,#t do
if t[e].heroDid==a then
return t[e]
end
end
end
local function i(t)
for e=1,#a do
if a[e].heroDid==t then
return a[e]
end
end
end
local function t(t)
for e=1,#o do
if o[e].heroId==t then
return o[e]
end
end
end
for a,e in pairs(e.heroOrders)do
local e=e
local t=t(e)
if t then
local o=t.heroDid
local e=n(o)
if not e then
e=i(o)
end
if not e then
local e={
heroId=0,
heroDid=0,
position=a%6,
}
if a>6 then
table.insert(r,e)
else
table.insert(h,e)
end
end
local i=math.min(t.curHp,e.curHp)
local e={
heroId=t.heroId,
heroDid=o,
position=a%6,
curHp=i,
lastHp=e.totalHp,
maxHp=e.totalHp,
curMp=t.curMp,
lockLevel=e.lockLevel,
rankLevel=e.rankLevel,
}
local e=CreateHeroData(e)
if a>6 then
table.insert(r,e)
else
table.insert(h,e)
end
end
end
end
function RefreshHeroInfo(e)
for t=1,6 do
RefreshHeroInfoByPos(t,e)
end
end
function RefreshHeroInfoByPos(e,o)
local t=UIUtil.GetChild(d.transform,e-1)
if t==nil then
return
end
local a=c[e]
local e=LuaUtils.GetLuaComBinder(t.transform)
local e=e:GetComponents()
LuaUtils.SetActive(e["head_empty"].transform,false)
LuaUtils.SetActive(e["head_normal"].transform,false)
if not a or a.heroId==0 then
LuaUtils.SetActive(e["head_empty"].transform,true)
else
LuaUtils.SetActive(e["head_normal"].transform,true)
UIUtil.SetHeroHead(e["head"].transform,a,false)
local t=LuaUtils.GetLuaComBinder(e["head"].transform)
local t=t:GetComponents()
LuaUtils.SetActive(t["im_zhan"].transform,false)
LuaUtils.SetActive(t["im_zhezhao"].transform,false)
local t
if o then
t={
curHp=a.lastHp,
maxHp=a.maxHp,
}
else
t={
curHp=a.curHp,
maxHp=a.maxHp,
}
end
LuaUtils.SetActive(e["im_dead"].transform,t.curHp<=0)
UIUtil.SetGray(e["head"].transform,t.curHp<=0)
UIUtil.SetGray(e["imgHP"].transform,t.curHp<=0)
LuaUtils.SetImageFillAmount(e["imgHP"],t.curHp/t.maxHp)
UIUtil.SetHpBarColor(e["imgHP"],t.curHp/t.maxHp)
end
end
function CreateHeroData(t)
local a=p.GetEntity(t.heroDid)
local e={
heroId=0,
heroDid=0,
curHp=0,
curMp=0,
maxHp=0,
maxMp=0,
soul=nil,
commonSouls={},
prof=1,
fight=0,
status=0,
attribute={},
skills={},
star=1,
rankLevel=1,
rankStars={},
starMap=0,
starNum=0,
lockLevel=0,
jade=0,
jadeExp=0,
isCanLockUp=false,
loverGrade=0,
loverLevel=0,
loverExp=0,
chip=0,
equipIds={},
underwearIds={},
activeTime=0,
}
e.curHp=t.hp
e.maxHp=t.maxHp
e.prof=a.profession
e.star=a.star
for a,t in pairs(t)do
e[a]=t
end
return e
end
function StopDelayDamageSequence()
if s~=nil then
s:Kill()
s=nil
end
end
function StopAllFillAmountTween()
for t,e in pairs(o)do
if e~=nil then
e:Kill()
e=nil
end
end
o={}
end
function StopFillAmountTweenBykey(t)
local e=o[t]
if e~=nil then
e:Kill()
e=nil
end
o[t]=nil
end
function StopNumTweener()
if i~=nil then
i:Kill()
i=nil
end
end
function StopPlayFanTweener()
if m~=nil then
m:Kill()
m=nil
end
end
function CreateTestData()
ModulesInit.ProcedureNormalBattle.mvpHeroDid=1037
n.CurStartBattleResult={
fightInfo={
grade=1253,
}
}
local t={}
for e=1,6 do
if math.random()<0.5 then
local a=math.random(5000,10000)
local e={
heroId=1000+e*10,
curHp=0,
curMp=math.random(0,1000),
outputDmg=math.random(5000,2310000),
dmg=math.random(500,23100),
healHp=6,
hpRate=7,
controllRate=8,
isOurHero=false,
playerId=10000+e,
heroDid=1000+e,
rankLevel=math.random(1,7),
lockLevel=1,
pos=e,
totalHp=a,
lockLevel=1,
curAnger=math.random(0,1000),
totalAnger=1000,
}
table.insert(t,e)
end
end
ModulesInit.ProcedureNormalBattle.FightPlayData={
waveData={
[1]={
heroStatistics=t
}
}
}
local e=t
n.lastEmemyInfo={
heros=e
}
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

