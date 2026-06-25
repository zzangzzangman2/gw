local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e={
TeamId=e.teamId,
battleStationIndex=e.battleStationIndex,
HeroId=e.releaseHeroId,
buffId=e.buffId,
prefabId=SysPrefabId.BattleBayuqianBgEffect,
targetPosX=0,
targetPosY=0,
targetPosZ=90,
delay=1,
fadeIn=0.5,
bShowSpeed=false,
onComplete=function(e)
end,
}
ModulesInit.ProcedureNormalBattle.ShowBgEffect(e)
end
end
function e.OnRemoveSelf(e,a)
t.RemoveAllEnemyBuff(e,a)
t.RemoveAllMateBuff(e,a)
if GameInit.IsClient then
local e={
HeroId=e.releaseHeroId,
buffId=e.buffId,
prefabId=SysPrefabId.BattleBayuqianBgEffect,
fadeOut=0.5,
bShowSpeed=false,
}
ModulesInit.ProcedureNormalBattle.HideBgEffect(e)
end
end
function e.DoAction(e,a,i,n,n,o)
if e==nil then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
t.AddAllEnemyBuff(e,a)
t.AddAllMateBuff(e,a)
elseif o.buffTriggerTime==BuffTriggerTime.addEnemy then
t.AddEnemyBuff(e,a,i)
elseif o.buffTriggerTime==BuffTriggerTime.addMyMate then
t.AddMateBuff(e,a,i)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addEnemy
or e==BuffTriggerTime.addMyMate)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(t,a,e)
if t and t.buffWeight[1]and t.buffWeight[2]
and e and e[4]and e[7]then
return t.buffWeight[1]*-e[4]+t.buffWeight[2]*e[7]
end
return 0
end
function e.AddAllEnemyBuff(e,a)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(e.teamId,BattleHeroType.enemyAll,nil,nil,true)
for i,o in ipairs(o)do
t.AddEnemyBuff(e,a,o)
end
end
function e.AddEnemyBuff(t,e,i)
local a=e[1]
local o=e[2]
local e={e[3],e[4]}
i:AddBuffAfterRemove(t.CurrHeroCtrl,a,o,e)
end
function e.RemoveAllEnemyBuff(e,t)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(e.teamId,BattleHeroType.enemyAll,nil,nil,true)
if e then
for a,e in ipairs(e)do
local t=t[1]
e.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
end
end
function e.AddAllMateBuff(e,a)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(e.teamId,BattleHeroType.ourAll,nil,nil,true)
for i,o in ipairs(o)do
t.AddMateBuff(e,a,o)
end
end
function e.AddMateBuff(i,e,o)
local t=e[5]
local a=e[6]
local e={e[7],e[8]}
o:AddBuffAfterRemove(i.CurrHeroCtrl,t,a,e)
end
function e.RemoveAllMateBuff(e,t)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(e.teamId,BattleHeroType.ourAll,nil,nil,true)
if e then
for e,a in ipairs(e)do
local e=t[5]
a.HeroBattleInfo:RemoveBuffWithId(e,BuffRemoveType.Expire)
end
end
end
return t

