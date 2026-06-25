local e=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local r=e[1]
local o=t:GetFinalAtk()
local h=e[3]
local s=e[4]
local n=e[5]
local o={o}
for t=6,6 do
table.insert(o,e[t])
end
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(h,t,s,n,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,r)
end
return nil
end
return r 
