local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFrontMinHpPercentWithCount)
local a=a[1]
if(a==nil)then
return nil
end
local i=e[1]
local n=e[3]
local s=e[4]
local e={e[5],e[6]}
a:AddBuff(t,n,s,e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
return nil
end
return h 
