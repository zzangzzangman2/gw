local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(t,a)
local o=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMaxFinalAtk)
if(e==nil)then
return nil
end
local i=o[1]
local o=e.HeroBattleInfo:DispelGranBuff(true,o[3])
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,i)
return nil
end
return n 
