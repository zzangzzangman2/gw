local e=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumnWithBuff,nil,nil,e[4])
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
t:ReduceFury(o.costMp)
local h=e[1]
local s=e[8]
local r=e[9]
local n={e[10],e[11],e[12],e[13]}
local i=#a
for i=1,i do
local a=a[i]
a:AddBuff(t,s,r,n)
local i=a.HeroBattleInfo:GetBuff(e[14])
if i then
local e={
attrId=e[15],
value=e[16],
}
a:AddAttrValueInCurAttack(e)
t:SetRoundCanTriggerSmallSkill(true)
end
local i=e[3]
local i=e[4]
local s=e[5]
local n=a:GetFinalAtk()
local n=math.floor(n*e[6]*MillionCoe)
local e={n,e[7],0}
a:AddBuff(t,i,s,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,h)
end
return nil
end
return r

