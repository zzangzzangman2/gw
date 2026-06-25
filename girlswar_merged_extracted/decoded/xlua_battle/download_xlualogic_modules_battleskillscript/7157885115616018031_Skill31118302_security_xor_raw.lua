local n=require("Modules/Battle/BattleUtil")
local e={
}
local r=e
function e.DoAction(t,i,e,e)
local o=t:JudgeSkillPreView(i)
local e=nil
local a=303111802
local a,s=n:GetHeroMostBuffFloor(t,BattleHeroType.enemyAll,a)
if s==0 then
e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
else
e=a
end
if(e==nil)then
return nil
end
local r=0
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
t:ReduceFury(i.costMp)
local h=o[1]
local s=303111812
local a=t.HeroBattleInfo:GetBuff(s)
if(a)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(s)
t.DoBeansActionSkill(a,e)
end
local s=303111809
local a=t.HeroBattleInfo:GetBuff(s)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoActionBigSkill1(a)
end
local a=303111802
local a=n:GetHeroBuffFloor(e,a)
if a>0 then
local t={
attrId=o[3],
value=o[4]*a,
}
e:AddAttrValueInCurAttack(t)
end
local n=303111816
local s=t.HeroBattleInfo:GetBuff(n)
if s then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(n)
t.DoBeansActionBigSkill(s,e,a)
end
local s=303111801
local n=t.HeroBattleInfo:GetBuff(s)
if a>=o[5]then
if n then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(s)
t.AddBuffDeadLine(n,e)
end
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,h,0,r)
return nil
end
return r 
