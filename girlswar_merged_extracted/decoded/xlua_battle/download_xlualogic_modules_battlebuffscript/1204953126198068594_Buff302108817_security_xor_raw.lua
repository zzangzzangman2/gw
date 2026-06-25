local i=require("Modules/Battle/BattleUtil")
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(t,e)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=SysPrefabId.BattleJejmsLeftBgEffect
if t.teamId==1 then
e=SysPrefabId.BattleJejmsRightBgEffect
end
ModulesInit.GlobalBattleEffectMgr.HideEffect(e,0,false)
ModulesInit.GlobalBattleEffectMgr.ShowEffect(e,0,0,0,0,0,false,function()
end)
end
end
function e.OnRemoveSelf(e,a)
t.RemoveAllMateBuff(e,a)
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local t=SysPrefabId.BattleJejmsLeftBgEffect
if e.teamId==1 then
t=SysPrefabId.BattleJejmsRightBgEffect
end
ModulesInit.GlobalBattleEffectMgr.HideEffect(t,0,false)
end
end
function e.DoAction(e,o,n,s,s,a)
if e==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.AddAllMateBuff(e,o)
elseif a.buffTriggerTime==BuffTriggerTime.addMyMate then
t.AddMateBuff(e,o,n)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(e.teamId,BattleHeroType.ourAll,nil,nil,true)
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
local e={}
for o=1,#a do
local a=a[o]
if t==nil or a.HeroId~=t.HeroId then
table.insert(e,a)
end
end
local e=i:GetNotFullFuryHero(e,1)
if t then
table.insert(e,t)
end
for t=1,#e do
e[t]:AddFuryWithBuffImmediately(o[7])
if e[t].HeroBattleInfo then
e[t].HeroBattleInfo:DispelAllGranBuff(false)
end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addMyMate
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddAllMateBuff(e,o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(e.teamId,BattleHeroType.ourAll,nil,nil,true)
for i,a in ipairs(a)do
t.AddMateBuff(e,o,a)
end
end
function e.AddMateBuff(t,e,i)
local a=e[1]
local o=e[2]
local e={e[3],e[4],e[5],e[6]}
i:AddBuffAfterRemove(t.CurrHeroCtrl,a,o,e)
end
function e.RemoveAllMateBuff(e,t)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(e.teamId,BattleHeroType.ourAll,nil,nil,true)
if e then
for a,e in ipairs(e)do
local a=t[1]
e.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
local t=t[5]
e.HeroBattleInfo:RemoveBuffWithId(t,BuffRemoveType.Expire)
end
end
end
return t

