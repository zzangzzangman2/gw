local e={}
local n=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local r=e[1]
local i=e[3]
local a=e[4]
local d={e[5]}
local s=e[6]
local h=e[7]
local n={e[8]}
t:AddBuff(t,i,a,d)
t:AddBuff(t,s,h,n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eBack)
if(a~=nil)then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=#a
for i=1,i do
local i=a[i]
local a=r
if(i:CurrHPPer()<=e[9]*MillionCoe)then
a=a+e[10]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,i,o,a)
end
end
return nil
end
return n

