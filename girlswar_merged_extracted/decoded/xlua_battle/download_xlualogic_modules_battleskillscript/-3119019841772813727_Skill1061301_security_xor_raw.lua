local e=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(i.costMp)
local r=e[1]
local o=a[1]
local h=e[3]
local d=e[4]
local n=e[5]
local s={e[6],e[7]}
t:AddBuff(t,h,n,s)
o:AddBuff(t,d,n,s)
local d=e[8]
local h=e[9]
local s=e[10]
local n={e[11],e[12]}
t:AddBuff(t,d,s,n)
o:AddBuff(t,h,s,n)
local d=e[13]
local h=e[14]
local s=e[15]
local n={e[16],e[17]}
t:AddBuff(t,d,s,n)
o:AddBuff(t,h,s,n)
local d=e[18]
local h=e[19]
local n=e[20]
local s={e[21],e[22]}
t:AddBuff(t,d,n,s)
o:AddBuff(t,h,n,s)
local o=#a
for o=1,o do
local a=a[o]
local o={
attrId=e[23],
value=e[24],
}
a:AddAttrValueInCurAttack(o)
local o=e[25]
local s=e[26]
local n=t:GetFinalAtk()
local e=math.floor(n*e[27]*MillionCoe)
local e={e}
a:AddBuff(t,o,s,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,r)
end
return nil
end
return d

