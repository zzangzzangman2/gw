local e={
}
local h=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local s=e[1]
local i=t:GetFinalAtk()
local o=#a
for o=1,o do
local a=a[o]
if o==1 then
local o=e[3]
local i=e[4]
local e=e[5]
a:CheckAddBuff(o,t,i,e)
end
local o=s
if i>a:GetFinalAtk()then
o=o+e[6]
end
local s=e[7]
local h=e[8]
local i=math.floor(i*e[11]*MillionCoe)
local e={e[9],e[10],i}
a:AddBuff(t,s,h,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,o)
end
t:FuryHealth(FuryHealthType.Attack)
end
return h 
