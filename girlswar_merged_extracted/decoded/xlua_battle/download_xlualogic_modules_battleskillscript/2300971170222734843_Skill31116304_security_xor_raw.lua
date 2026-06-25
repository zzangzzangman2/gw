local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(t,o,e,e)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eMinHpPercent)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local s=e[1]
local n=e[3]
local i=e[4]
local e={e[5],e[6]}
a:AddBuff(t,n,i,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,s)
return nil
end
return n 
