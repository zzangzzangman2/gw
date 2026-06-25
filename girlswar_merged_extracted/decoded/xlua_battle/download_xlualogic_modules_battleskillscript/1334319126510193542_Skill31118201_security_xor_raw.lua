local s=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,o,t,t)
local i=e:JudgeSkillPreView(o)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMinHpPercentWithCount)
local t=t[1]
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local h=0
local r=i[1]
local n=303111812
local a=e.HeroBattleInfo:GetBuff(n)
if(a)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoBeansActionSkill(a,t)
end
local a=303111802
local a=s:GetHeroBuffFloor(t,a)
if a>0 then
local e={
attrId=i[3],
value=i[4]*a,
}
t:AddAttrValueInCurAttack(e)
end
local i=303111804
local n=e.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionSmallSkill(n,t,a)
end
local i=303111816
local n=e.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoBeansActionSmallSkill(n,t,a)
end
local i=303111801
local a=e.HeroBattleInfo:GetBuff(i)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
if e.CheckAndRecordMustBeCritOnce(a)then
t:SetMustBeCritOnce(true)
end
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,r,0,h)
local t=t[3]
local t=t.criticalOrBlock
if t~=1 then
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.SetNextMustBeCritOnce(a)
end
end
local a=303111809
local t=e.HeroBattleInfo:GetBuff(a)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.DoActionBigSkill2(t,{triggerSkillAtkType=o.atkType})
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
