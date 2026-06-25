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
local r=e[1]
local i=#a
for i=1,i do
local a=a[i]
local i=a.HeroBattleInfo:GetBuff(e[8])
if i then
local e={
attrId=e[9],
value=e[10],
}
a:AddAttrValueInCurAttack(e)
t:SetRoundCanTriggerSmallSkill(true)
end
local i=e[3]
local n=e[4]
local h=e[5]
local s=a:GetFinalAtk()
local s=math.floor(s*e[6]*MillionCoe)
local e={s,e[7],0}
a:CheckAddBuff(i,t,n,h,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,r)
end
return nil
end
return r

