local s=require("Modules/Battle/BattleUtil")
local e={}
local h=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a==nil)then
return
end
local i=#a
if(i==1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,t[11],a)
end
e:ReduceFury(o.costMp)
e:RemoveOneBeans()
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local i=303104105
local n=e.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionAllSkill(n,a)
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
local i=#a
for i=1,i do
local a=a[i]
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
local t=t[12]
local t=math.floor(o*t*MillionCoe)
s:AddSepsisHp(e,a,t)
end
local t=ModulesInit.BattleBuffMgr.GetBuffScript(303104103)
return t.HandleSkillChangeData(e)
end
return h

