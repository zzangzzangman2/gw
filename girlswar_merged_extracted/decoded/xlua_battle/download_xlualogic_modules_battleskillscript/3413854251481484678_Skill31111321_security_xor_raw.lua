local n=require("Modules/Battle/BattleUtil")
local e={}
local l=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
e:ReduceFury(o.costMp)
e:RemoveOneBeans()
local d=t[1]
local h=t[3]
local u=t[4]
local l={t[5],t[6]}
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
if#i>0 then
local o=303111102
local e=e.HeroBattleInfo:GetBuff(o)
if e then
local a=RandomTableWithSeed(i,t[7])
for i=1,#a do
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
o.AddBuffBrokenArmy(e,a[i],t[8])
end
end
end
local s=math.floor(e.HeroBattleInfo.MaxHP*t[12]*MillionCoe)
local i=t[10]
local c=t[11]
local s={s}
local r=table.lightCopyList(a)
local t=RandomTableWithSeed(r,t[9])
for a=1,#t do
t[a]:AddBuff(e,i,c,s)
end
local i=303111107
local t=e.HeroBattleInfo:GetBuff(i)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionBigSkill(t,a)
end
local i=303111114
local t=e.HeroBattleInfo:GetBuff(i)
if(t)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoBeansActionBigSkill(t)
end
local t=#a
for t=1,t do
local t=a[t]
local a=0
t:AddBuff(e,h,u,l)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,d,0,a)
end
if n:CheckCanTriggerAttackTask(o.atkType)then
local t=303111115
local e=e.HeroBattleInfo:GetBuff(t)
if(e)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.DoBeansActionBigSkill(e)
end
end
return nil
end
return l

