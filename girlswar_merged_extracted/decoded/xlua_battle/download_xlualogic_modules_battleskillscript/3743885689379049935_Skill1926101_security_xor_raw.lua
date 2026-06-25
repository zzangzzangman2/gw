local n=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(o,i,a)
local e=ModulesInit.ProcedureNormalBattle:GetTeamSkillArgs(i)
local t=a.hurtDataList
local e={}
for a=1,#t do
local a=t[a]
local t=a.refractionHeroId
if e[t]==nil then
e[t]=a.reduceHpValue
else
e[t]=e[t]+a.reduceHpValue
end
end
local t={}
for e,a in pairs(e)do
local e=n:GetTargetHeroCtrl(e)
if e then
table.insert(t,e)
end
end
table.sort(t,function(t,e)
return t.HeroId<e.HeroId
end)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local n=#t
for a=1,n do
local t=t[a]
local e=e[t.HeroId]
ModulesInit.ProcedureNormalBattle.SkillHurt(o,t,i,0,0,e)
end
if a.refractionStage<a.maxRefractionCount then
local e=92480
local t=o.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.AddAttackTaskRefraction(t,a)
end
end
return nil
end
return s 
