local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(e,i,t)
local a=e:JudgeSkillPreView(i)
local n=t.skillHurtRate
local a=t.damageTargetCount
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
local t=RandomTableWithSeed(t,a)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local o=303111319
local a=e.HeroBattleInfo:GetBuff(o)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoActionLightSkill(a)
end
local a=#t
for a=1,a do
local t=t[a]
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,n)
end
return nil
end
return s 
