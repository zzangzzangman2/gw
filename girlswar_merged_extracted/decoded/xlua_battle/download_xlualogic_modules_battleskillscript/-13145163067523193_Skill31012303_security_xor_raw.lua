local l=require("Modules/Battle/BattleUtil")
local e={
}
local u=e
function e.DoAction(e,n,t,t)
local t=e:JudgeSkillPreView(n)
local a=e.CurrBattleTeam.OpponentTeam:GetAllHerosCount()
if(a==1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,t[8])
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
e:ReduceFury(n.costMp)
local r=t[1]
local d=0
local o=303101209
local o=e.HeroBattleInfo:GetBuff(o)
if(o)then
local e=o:GetBuffData()
d=e[1]
end
local i=303101210
local o=e.HeroBattleInfo:GetBuff(i)
if(o)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.ConsumeEnergyToAddHp(o)
end
local o=nil
local i=303101218
local i=e.HeroBattleInfo:GetBuff(i)
if(i)then
local e=i:GetBuffData()
o=e[1]
end
local s=0
local h=303101225
local i=e.HeroBattleInfo:GetBuff(h)
if(i)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(h)
local e=t.GetSkillRate(i,#a,31012303)
if e~=nil then
r=e
end
s=t.DoBuffWithBigSkill(i,a)
end
local h=t[3]
local u=t[4]
if o==nil then
o=t[5]
end
local i={o,d}
local o=t[6]
e:AddFuryWithSkill(o)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAllExcludeSelf)
if(o~=nil)then
for o,a in ipairs(o)do
if(a.HeroId~=e.HeroId)then
a:AddFuryWithSkill(t[7])
end
end
end
local o=#a
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eRandomEnemyWithBuff,t[9])
for a=1,#t do
t[a].HeroBattleInfo:DispelAllGranBuff(true,nil,e.HeroId)
end
for t=1,o do
local t=a[t]
t:AddBuff(e,h,u,i)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,n,r,0,s)
local a=a[3]
local o=a.reduceHpValue
local a=303101201
local a=e.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetBuffData()
local a=a[5]
local a=math.floor(o*a*MillionCoe)
l:AddSepsisHp(e,t,a)
end
end
return nil
end
return u 
