local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local h=e[1]
local n=e[3]
local s=e[4]
local o={}
for t=5,18 do
if e[t]then
table.insert(o,e[t])
else
table.insert(o,0)
end
end
table.insert(o,0)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fMinHpPercentWithCount,1)
local e=e[1]
if(e)then
e:AddBuff(t,n,s,o)
end
local e=#a
for e=1,e do
local e=a[e]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,h)
end
return nil
end
return h 
