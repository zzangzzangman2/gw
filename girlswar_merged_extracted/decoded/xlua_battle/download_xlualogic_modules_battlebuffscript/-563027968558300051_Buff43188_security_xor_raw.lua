local s=require("Modules/Battle/BattleUtil")
local t={}
local h=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,i,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local n=1912202
local t=i[3]
local o={}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fHollow)
for e=1,#a do
table.insert(o,a[e].HeroId)
end
local e={
realhurt=i[4],
removeBuffId=e.buffId,
defHeroId=e.CurrHeroCtrl.HeroId,
targetHeroIds=o
}
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndTeamId(n,t)
if a then
local t=a.skillData
table.insert(t.triggerDataList,e)
return
end
local a={
teamId=t,
insertLevel=ETriggerSkillInsertLevel.SysAttack,
triggerSkillAtkType=ETriggerSkillAtkType.TeamAttack,
triggerDataList={e}
}
s:AddTriggerTeamAttackTask(t,n,a,e)
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.attacked then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return h 
