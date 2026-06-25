local e=require("Modules/Battle/BattleUtil")
local t={
}
local n=t
function t.DoAction(t,a)
local o=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local n=o[1]
local i=#e
for i=1,i do
local e=e[i]
e.HeroBattleInfo:DispelGranBuff(true,o[3])
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,n)
end
return nil
end
function t.DoPassiveAction(t,e)
local e=t:JudgeSkillPreView(e)
return nil
end
return n 
