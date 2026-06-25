local e={
}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local i=t[3]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
for n,t in ipairs(t)do
t.HeroBattleInfo:DispelAllGranBuff(true,nil,e.HeroId)
local n=t.HeroBattleInfo:GetBuff(2030)
if(n)then
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o+i)
else
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
end
end
end
return nil
end
return s 
