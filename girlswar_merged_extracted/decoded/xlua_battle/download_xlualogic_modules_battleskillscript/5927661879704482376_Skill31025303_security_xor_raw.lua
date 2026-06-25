local e={}
local r=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a==nil)then
return
end
e:ReduceFury(i.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local n=#a
if(n>1)then
local h=t[1]
local s=e:GetFinalAtk()
local n=0
local o=e.HeroBattleInfo:GetBuff(303102503)
if o then
local e=o:GetBuffData()
n=e[2]
end
local o=n*t[5]
o=math.min(o,t[6])
local o={
attrId=t[4],
value=o,
}
e:AddAttrValueInCurAttack(o)
local o=#a
for o=1,o do
local o=a[o]
local a=h
local n=o:GetFinalAtk()
if s>n then
a=a+t[3]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,i,a)
end
return nil
elseif(n==1)then
local h=t[7]
local r=e:GetFinalAtk()
local s=0
local n=0
local o=e.HeroBattleInfo:GetBuff(303102503)
if o then
local e=o:GetBuffData()
s=e[2]
n=e[3]
end
local o=s*t[11]
o=math.min(o,t[12])
if n>0 then
o=o+t[13]
end
local o={
attrId=t[10],
value=o,
}
e:AddAttrValueInCurAttack(o)
local o=#a
for o=1,o do
local o=a[o]
local a=h
local n=o:GetFinalAtk()
if r>n then
a=a+t[9]
end
e.IgnoreBlock=true
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,i,a)
e.IgnoreBlock=false
end
return nil
end
end
return r

