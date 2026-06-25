local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=BattleHeroType.eFront
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,a)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local h=e[1]
local r=e[3]
local s=e[4]
local n=e[5]
local o={}
for t=6,9 do
table.insert(o,e[t])
end
local e=#a
for e=1,e do
local e=a[e]
e:CheckAddBuff(r,t,s,n,o)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,h)
end
return nil
end
return d 
