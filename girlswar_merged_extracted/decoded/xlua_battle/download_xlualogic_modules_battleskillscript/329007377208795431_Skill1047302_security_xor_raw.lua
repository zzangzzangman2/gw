local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eFront)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local i=e[1]
local n=t.HeroBattleInfo:GetBuff(30104704)
if n then
local e=n:GetBuffData()
i=i+e[1]
end
local s=e[3]
local n=e[4]
local h={e[5],e[6],e[7],e[8]}
t:AddBuff(t,s,n,h)
local r=e[9]
local d=e[10]
local h=e[11]
local s={e[12],e[13]}
local n=#a
for n=1,n do
local a=a[n]
a:CheckAddBuff(r,t,d,h,s)
if(a.profession==e[14])then
local e={
attrId=e[15],
value=e[16],
}
a:AddAttrValueInCurAttack(e)
end
local n=e[17]
local s=e[18]
local e=e[19]
a:CheckAddBuff(n,t,s,e,0)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
end
return nil
end
return d 
