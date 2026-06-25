local e={
}
local h=e
function e.DoAction(t,s)
local e=t:JudgeSkillPreView(s)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local h=e[1]
local o=t:GetFinalAtk()
local n=#a
for i=1,n do
local a=a[i]
if i==1 then
local o=e[3]
local i=e[4]
local e=e[5]
a:CheckAddBuff(o,t,i,e)
end
local i=h
if o>a:GetFinalAtk()then
i=i+e[6]
end
if n<=e[12]then
local n=e[7]
local i=e[13]
local o=math.floor(o*e[16]*MillionCoe)
local e={e[14],e[15],o}
a:AddBuff(t,n,i,e)
else
local i=e[7]
local n=e[8]
local o=math.floor(o*e[11]*MillionCoe)
local e={e[9],e[10],o}
a:AddBuff(t,i,n,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,s,i)
end
t:FuryHealth(FuryHealthType.Attack)
end
return h 
