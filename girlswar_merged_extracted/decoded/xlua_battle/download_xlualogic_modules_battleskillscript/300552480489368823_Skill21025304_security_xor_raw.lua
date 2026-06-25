local e={}
local h=e
function e.DoAction(e,i,o)
local t=e:JudgeSkillPreView(i)
e:ReduceFury(i.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(o)
local r=t[1]
local h=e:GetFinalAtk()
local s=0
local n=0
local a=e.HeroBattleInfo:GetBuff(302102503)
if a then
local e=a:GetBuffData()
s=e[2]
n=e[3]
end
local a=s*t[5]
a=math.min(a,t[6])
if n>0 then
a=a+t[7]
end
local a={
attrId=t[4],
value=a,
}
e:AddAttrValueInCurAttack(a)
local a=#o
for a=1,a do
local o=o[a]
local a=r
local n=o:GetFinalAtk()
if h>n then
a=a+t[3]
end
e.IgnoreBlock=true
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,i,a)
e.IgnoreBlock=false
end
return nil
end
return h

