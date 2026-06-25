local e=require("Modules/Battle/BattleUtil")
local e={
}
local i=e
function e.DoAction(t,o)
local a=t:JudgeSkillPreView(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMaxFinalAtk)
local s=a[1]
local i=a[3]
local a=#e
for a=1,a do
local e=e[a]
local a=i
if e.HeroId==n.HeroId then
a=s
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,a)
end
return nil
end
return i 
