local e=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
t:ReduceFury(i.costMp)
t:RemoveOneBeans()
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local o=303102516
local n=t.HeroBattleInfo:GetBuff(o)
if(n)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(o)
t.AddBuffDragonEye(n,e[14])
end
local n=#a
if(n>1)then
local h=e[1]
local s=t:GetFinalAtk()
local o=0
local n=t.HeroBattleInfo:GetBuff(303102503)
if n then
local e=n:GetBuffData()
o=e[2]
end
local o=o*e[5]
o=math.min(o,e[6])
local o={
attrId=e[4],
value=o,
}
t:AddAttrValueInCurAttack(o)
local o=#a
for o=1,o do
local a=a[o]
local o=h
local n=a:GetFinalAtk()
if s>n then
o=o+e[3]
end
if a:CurrHPPer()>e[15]*MillionCoe then
local o=e[16]
local n=e[17]
local i={e[18],e[19]}
a:AddBuff(t,o,n,i)
local o=e[20]
local i=e[21]
local e={e[22],e[23]}
a:AddBuff(t,o,i,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
end
return nil
elseif(n==1)then
local r=e[7]
local h=t:GetFinalAtk()
local o=0
local s=0
local n=t.HeroBattleInfo:GetBuff(303102503)
if n then
local e=n:GetBuffData()
o=e[2]
s=e[3]
end
local o=o*e[11]
o=math.min(o,e[12])
if s>0 then
o=o+e[13]
end
local o={
attrId=e[10],
value=o,
}
t:AddAttrValueInCurAttack(o)
local o=#a
for o=1,o do
local a=a[o]
local o=r
local n=a:GetFinalAtk()
if h>n then
o=o+e[9]
end
if a:CurrHPPer()>e[15]*MillionCoe then
local i=e[16]
local n=e[17]
local o={e[18],e[19]}
a:AddBuff(t,i,n,o)
local o=e[20]
local i=e[21]
local e={e[22],e[23]}
a:AddBuff(t,o,i,e)
end
t.IgnoreBlock=true
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
t.IgnoreBlock=false
end
return nil
end
end
return r

