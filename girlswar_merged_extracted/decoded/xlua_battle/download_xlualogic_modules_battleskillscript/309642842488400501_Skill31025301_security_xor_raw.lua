local e=require("DataNode/DataTable/Create/skillAct/DTSkillActDBModel")
local e={}
local h=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
e:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a==nil)then
return
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local h=t[1]
local s=e:GetFinalAtk()
local i=0
local n=e.HeroBattleInfo:GetBuff(303102503)
if n then
local e=n:GetBuffData()
i=e[2]
end
local i=i*t[5]
i=math.min(i,t[6])
local i={
attrId=t[4],
value=i,
}
e:AddAttrValueInCurAttack(i)
local i=#a
for i=1,i do
local i=a[i]
local a=h
local n=i:GetFinalAtk()
if s>n then
a=a+t[3]
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,i,o,a)
end
return nil
end
return h

