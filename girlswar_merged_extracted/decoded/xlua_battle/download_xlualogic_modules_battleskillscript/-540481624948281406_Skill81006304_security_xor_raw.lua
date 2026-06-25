local i=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
local a=i:FindMostBigAtk(a)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local i=e[1]
local n=e[3]
local s=e[4]
local e=e[5]
a:CheckAddBuff(n,t,s,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
return nil
end
return s 
