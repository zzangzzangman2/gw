local n=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,a,t,t)
local o=e:JudgeSkillPreView(a)
local t=nil
local i=303111501
local i,s=n:GetHeroMostBuffFloor(e,BattleHeroType.enemyAll,i)
if i==nil or s==0 then
local a=303111502
local e,a=n:GetHeroMostBuffFloor(e,BattleHeroType.enemyAll,a)
if e==nil or a==0 then
else
t=e
end
else
t=i
end
if(t==nil)then
t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
end
if(t==nil)then
return nil
end
local r=0
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
e:ReduceFury(a.costMp)
local h=o[1]
local i=303111504
local i=e.HeroBattleInfo:GetBuff(i)
local n=0
if i then
n=i:GetFloors()
end
local s=303111503
local i=e.HeroBattleInfo:GetBuff(s)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
if n>=o[3]then
e.AddAttackTask(i,{triggerSkillAtkType=a.atkType})
else
e.AddBuffGhostsPower(i,o[4])
end
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,h,0,r)
return nil
end
return d 
