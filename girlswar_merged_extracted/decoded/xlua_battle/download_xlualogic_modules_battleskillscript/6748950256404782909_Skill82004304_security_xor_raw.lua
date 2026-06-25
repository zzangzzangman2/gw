local i=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(a,o)
local t=a:JudgeSkillPreView(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.enemyAll)
if(e==nil or#e<=0)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local s=t[1]
local n=i:GetHeroByFinalHighAtk(e)
local i=i:FindHighTreatment(e)
local i={n,i}
local i=RandomTableWithSeed(i,1)
local i=i[1]
if i then
local n=t[3]
local e=t[4]
local t=t[5]
local o=0
i:CheckAddBuff(n,a,e,t,o)
end
local t=#e
for t=1,t do
local e=e[t]
ModulesInit.ProcedureNormalBattle.SkillHurt(a,e,o,s)
end
return nil
end
return s 
