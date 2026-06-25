local e={
}
local n=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local n=t[1]
local i=t[3]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local a=#t
for a=1,a do
local t=t[a]
t.HeroBattleInfo:DispelAllGranBuff(true,nil,e.HeroId)
local a=n
if(t.HeroBattleInfo:GetBuff(2032))then
a=a+i
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,a)
end
end
return nil
end
return n 
