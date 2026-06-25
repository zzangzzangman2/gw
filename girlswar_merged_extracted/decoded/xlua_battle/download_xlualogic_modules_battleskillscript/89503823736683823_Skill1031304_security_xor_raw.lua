local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local s=t[1]
e:AddMustCritValueInCurAttack()
local h=t[3]
local n=t[4]
local i={t[5],t[6]}
local t=#a
for t=1,t do
local t=a[t]
t:AddBuff(e,h,n,i)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,s)
end
e:RemoveMustCritValueInCurAttack()
return nil
end
return n 
