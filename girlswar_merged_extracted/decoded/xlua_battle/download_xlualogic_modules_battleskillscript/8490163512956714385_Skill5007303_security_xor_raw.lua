local e={
}
local n=e
function e.DoAction(e,t)
local a=e:JudgeSkillPreView(t)
local o=a[1]
local n=a[3]
local i=e.HeroBattleInfo:GetBuff(2031)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
for s,a in ipairs(a)do
a.HeroBattleInfo:DispelAllGranBuff(true,nil,e.HeroId)
if(i)then
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,t,o+n)
else
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,t,o)
end
end
end
return nil
end
return n 
