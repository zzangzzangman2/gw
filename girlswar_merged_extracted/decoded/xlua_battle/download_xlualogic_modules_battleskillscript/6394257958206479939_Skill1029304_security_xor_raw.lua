local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(a,o)
local t=a:JudgeSkillPreView(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local s=t[1]
local h=t[3]
local n=t[4]
local t=t[5]
local i=#e
for i=1,i do
local e=e[i]
e:CheckAddBuff(h,a,n,t)
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,o,s)
end
return nil
end
return n 
