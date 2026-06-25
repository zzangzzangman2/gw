local e={}
local h=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a==nil)then
return
end
local o=#a
if(o==1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,t[7],a)
end
e:ReduceFury(i.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local s=t[1]
local h=e:GetFinalAtk()
local n=0
local o=e.HeroBattleInfo:GetBuff(302102503)
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
local a=s
local n=o:GetFinalAtk()
if h>n then
a=a+t[3]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,i,a)
end
return nil
end
return h

