local e=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,o,t,t)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
e:ReduceFury(o.costMp)
local r=t[1]
local d=t[3]
local u=t[4]
local l={t[5],t[6]}
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
if#i>0 then
local a=303111102
local o=e.HeroBattleInfo:GetBuff(a)
if o then
local e=RandomTableWithSeed(i,t[7])
for i=1,#e do
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddBuffBrokenArmy(o,e[i],t[8])
end
end
end
local i=math.floor(e.HeroBattleInfo.MaxHP*t[12]*MillionCoe)
local h=t[10]
local s=t[11]
local n={i}
local i=table.lightCopyList(a)
local t=RandomTableWithSeed(i,t[9])
for a=1,#t do
t[a]:AddBuff(e,h,s,n)
end
local t=303111107
local i=e.HeroBattleInfo:GetBuff(t)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.DoActionBigSkill(i,a)
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
t:AddBuff(e,d,u,l)
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,r,0,a)
end
return nil
end
return d 
