local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ePriorBack,e[2])
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local h=e[1]
local n=e[3]
local s=e[4]
local i={e[5],e[6]}
t:AddBuff(t,n,s,i)
local i=e[7]
local n=e[8]
local s={e[9],e[10]}
local e=#a
for e=1,e do
local e=a[e]
e:AddBuff(t,i,n,s)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,o,h)
end
return nil
end
return h 
