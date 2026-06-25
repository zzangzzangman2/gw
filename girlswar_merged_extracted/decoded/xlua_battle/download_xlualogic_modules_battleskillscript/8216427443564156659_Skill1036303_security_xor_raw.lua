local e={}
local d=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eBack)
if(a==nil)then
return
end
local i=#a
if(i==1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,1036304)
end
t:ReduceFury(o.costMp)
local n=e[1]
local l=e[3]
local d=e[4]
local h={e[5]}
local r=e[6]
local s=e[7]
local i={e[8]}
t:AddBuff(t,l,d,h)
t:AddBuff(t,r,s,i)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=#a
for i=1,i do
local i=a[i]
local a=n
if(i:CurrHPPer()<=e[9]*MillionCoe)then
a=a+e[10]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,i,o,a)
end
return nil
end
return d

