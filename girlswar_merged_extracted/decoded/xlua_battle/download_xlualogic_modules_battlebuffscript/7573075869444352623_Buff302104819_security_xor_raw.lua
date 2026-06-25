local s=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,a,n)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=e.CurrHeroCtrl
if n.buffTriggerTime==BuffTriggerTime.attacked then
local a=302104823
local a=o.HeroBattleInfo:GetBuff(a)
if(a)then
local o=a:GetFloors()
if o>1 then
a:ReduceFloors(1)
else
i.AddContrlBuff(e,t)
local i=21048102
local o=e.teamId
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndTeamId(i,o)
if a then
local a=a.skillData
table.insert(a.defHeroIds,e.CurrHeroCtrl.HeroId)
a.realhurt=a.realhurt+t[8]
else
local a={e.CurrHeroCtrl.HeroId}
local e={
triggerSkillAtkType=ETriggerSkillAtkType.TeamAttack,
teamId=e.teamId,
defHeroIds=a,
insertLevel=ETriggerSkillInsertLevel.SysAttack,
realhurt=t[8]
}
s:AddTriggerTeamAttackTask(o,i,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
end
elseif n.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
i.AddContrlBuff(e,t)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=e.CurrHeroCtrl:GetFootPointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.BattleUrCTZSExpoideBuff,e.x,e.y,50,3,0,false,function()
end)
end
local a=e.CurrHeroCtrl
if t[9]~=1 then
local i={}
local o=0
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.ourAll)
for e=1,#a do
local e=a[e]
local t=e.HeroBattleInfo:GetBuff(302104819)
if t then
o=o+1
local e=t:GetBuffData()
e[9]=1
else
i[e.HeroId]=true
end
end
for n=1,#a do
local a=a[n]
if i[a.HeroId]then
a:RealHurtWithBuff(t[8]*o,e)
end
end
end
if e.CurrHeroCtrl then
e.CurrHeroCtrl:DieImmediate()
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddContrlBuff(e,a)
local o=a[1]
local t=e.CurrHeroCtrl:GetTeamBuff(o)
if t then
local t=t:GetBuffData()
local t=t[6]
t[e.CurrHeroCtrl.battleStationIndex]=true
else
local i=a[2]
local t={}
for e=3,7 do
table.insert(t,a[e])
end
local a={}
a[e.CurrHeroCtrl.battleStationIndex]=true
table.insert(t,a)
e.CurrHeroCtrl:AddTeamBuff(e.CurrHeroCtrl,o,i,t)
end
end
return i

