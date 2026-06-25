local i=require("Modules/Battle/BattleUtil")
local e={}
local d=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=nil
local n=303111501
local n,s=i:GetHeroMostBuffFloor(e,BattleHeroType.enemyAll,n)
if n==nil or s==0 then
local t=303111502
local e,t=i:GetHeroMostBuffFloor(e,BattleHeroType.enemyAll,t)
if e==nil or t==0 then
else
a=e
end
else
a=n
end
if(a==nil)then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
end
if(a==nil)then
return nil
end
local d=0
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
e:ReduceFury(o.costMp)
e:RemoveOneBeans()
local r=t[1]
local n=303111504
local n=e.HeroBattleInfo:GetBuff(n)
local h=0
if n then
h=n:GetFloors()
end
local s=303111503
local n=e.HeroBattleInfo:GetBuff(s)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
if h>=t[3]then
e.AddAttackTask(n,{triggerSkillAtkType=o.atkType})
else
e.AddBuffGhostsPower(n,t[4])
end
end
local n=303111505
local n,i=i:GetHeroNoBuffByType(e,BattleHeroType.ourAll,n)
for a=1,#i do
local i=i[a]
local o=t[5]
local a=t[6]
local t={t[7],t[8]}
i:AddBuff(e,o,a,t)
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,r,0,d)
return nil
end
return d

