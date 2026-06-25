local e=require("Modules/Battle/BattleUtil")
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(t,e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=SysPrefabId.BattleHlklsLeftBgEffect
if t.teamId==1 then
e=SysPrefabId.BattleHlklsRightBgEffect
end
ModulesInit.GlobalBattleEffectMgr.HideEffect(e,0,false)
ModulesInit.GlobalBattleEffectMgr.ShowEffect(e,0,0,0,0,0,false,function()
end)
end
end
function e.OnRemoveSelf(a,e)
t.RemoveAllEnemyBuff(a,e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=SysPrefabId.BattleHlklsLeftBgEffect
if a.teamId==1 then
e=SysPrefabId.BattleHlklsRightBgEffect
end
ModulesInit.GlobalBattleEffectMgr.HideEffect(e,0,false)
end
end
function e.DoAction(e,o,i,n,n,a)
if e==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now
or a.buffTriggerTime==BuffTriggerTime.teamHeroDead then
t.AddAllEnemyBuff(e,o)
elseif a.buffTriggerTime==BuffTriggerTime.addEnemy then
t.AddEnemyBuff(e,o,i)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addEnemy
or e==BuffTriggerTime.teamHeroDead)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.ResetTaskHalo(e)
local a=e:GetBuffData()
t.AddAllEnemyBuff(e,a)
end
function e.AddAllEnemyBuff(e,o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(e.teamId,BattleHeroType.enemyAll,nil,nil,true)
for i,a in ipairs(a)do
t.AddEnemyBuff(e,o,a)
end
end
function e.AddEnemyBuff(e,a,t)
local i=e:GetFloors()
local o=a[1]
local n=a[2]
local a={a[3],a[4]}
local s=t.HeroBattleInfo:GetBuff(o)
if s then
if e.CurrHeroCtrl and s.releaseHeroId==e.CurrHeroCtrl.HeroId then
t:AddBuffWithFinalFloor(e.CurrHeroCtrl,o,n,a,i)
else
local s=s:GetFloors()
if i>s then
t:AddBuffAfterRemove(e.CurrHeroCtrl,o,n,a,i)
end
end
else
t:AddBuff(e.CurrHeroCtrl,o,n,a,i)
end
end
function e.RemoveAllEnemyBuff(e,a)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(e.teamId,BattleHeroType.enemyAll,nil,nil,true)
if t then
for t,o in ipairs(t)do
local t=a[1]
local a=o.HeroBattleInfo:GetBuff(t)
if a and e.CurrHeroCtrl and a.releaseHeroId==e.CurrHeroCtrl.HeroId then
o.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
end
end
end
return t

