local s=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(e,o,i)
local t=e:JudgeSkillPreView(o)
local a
if i~=nil then
a=i[1]
end
if a==nil then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
end
if(a==nil)then
return
end
local i={a}
e:ReduceFury(o.costMp)
e:RemoveOneBeans()
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local n=303104105
local a=e.HeroBattleInfo:GetBuff(n)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionAllSkill(a,i)
end
local h=t[1]
local n=false
if(e:CurrHPPer()>t[6]*MillionCoe)then
n=true
local t={
attrId=t[7],
value=t[8],
}
e:AddAttrValueInCurAttack(t)
else
local t={
attrId=t[9],
value=t[10],
}
e:AddAttrValueInCurAttack(t)
end
local a=#i
for a=1,a do
local a=i[a]
local i=h
if(a.profession==t[3]or a.profession==t[4])then
i=i+t[5]
end
if n==false then
a.HeroBattleInfo:DispelAllGranBuff(true,false,e.HeroId)
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,i)
local o=o[3]
local o=o.reduceHpValue
local t=t[11]
local t=math.floor(o*t*MillionCoe)
s:AddSepsisHp(e,a,t)
end
local t=ModulesInit.BattleBuffMgr.GetBuffScript(303104103)
return t.HandleSkillChangeData(e)
end
return r

