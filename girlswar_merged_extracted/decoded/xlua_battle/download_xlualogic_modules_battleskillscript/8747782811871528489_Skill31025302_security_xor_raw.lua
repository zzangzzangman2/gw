local e={}
local s=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
e:ReduceFury(i.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
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
end
return s

