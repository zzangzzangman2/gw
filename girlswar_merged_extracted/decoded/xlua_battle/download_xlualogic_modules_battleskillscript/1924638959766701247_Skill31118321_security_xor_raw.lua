local n=require("Modules/Battle/BattleUtil")
local e={}
local h=e
function e.DoAction(e,i)
local a=e:JudgeSkillPreView(i)
local t=nil
local o=303111802
local o,s=n:GetHeroMostBuffFloor(e,BattleHeroType.enemyAll,o)
if s==0 then
t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
else
t=o
end
if(t==nil)then
return nil
end
local h=0
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
e:ReduceFury(i.costMp)
e:RemoveOneBeans()
local r=a[1]
local o=303111812
local s=e.HeroBattleInfo:GetBuff(o)
if(s)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoBeansActionSkill(s,t)
end
local s=303111809
local o=e.HeroBattleInfo:GetBuff(s)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoActionBigSkill1(o)
end
local o=303111802
local n=n:GetHeroBuffFloor(t,o)
if n>0 then
local e={
attrId=a[3],
value=a[4]*n,
}
t:AddAttrValueInCurAttack(e)
end
local s=303111816
local o=e.HeroBattleInfo:GetBuff(s)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoBeansActionBigSkill(o,t,n)
end
local s=303111801
local o=e.HeroBattleInfo:GetBuff(s)
if n>=a[5]then
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.AddBuffDeadLine(o,t)
end
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,r,0,h)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.AddAttackTask(o,{triggerSkillAtkType=i.atkType})
end
return nil
end
return h

