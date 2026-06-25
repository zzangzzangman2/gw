local i=require("Modules/Battle/BattleUtil")
local e={}
local u=e
function e.DoAction(e,s)
local t=e:JudgeSkillPreView(s)
local a=e.CurrBattleTeam.OpponentTeam:GetAllHerosCount()
if(a==1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,t[8])
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
e:ReduceFury(s.costMp)
e:RemoveOneBeans()
local d=t[1]
local l=0
local o=303101209
local o=e.HeroBattleInfo:GetBuff(o)
if(o)then
local e=o:GetBuffData()
l=e[1]
end
local o=303101210
local n=e.HeroBattleInfo:GetBuff(o)
if(n)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.ConsumeEnergyToAddHp(n)
end
local o=nil
local n=303101218
local n=e.HeroBattleInfo:GetBuff(n)
if(n)then
local e=n:GetBuffData()
o=e[1]
end
local r=0
local h=303101225
local n=e.HeroBattleInfo:GetBuff(h)
if(n)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(h)
local e=t.GetSkillRate(n,#a,31012321)
if e~=nil then
d=e
end
r=t.DoBuffWithBigSkill(n,a)
end
local u=t[3]
local h=t[4]
if o==nil then
o=t[5]
end
local n={o,l}
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
local l=#a
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eRandomEnemyWithBuff,t[9])
for t=1,#o do
o[t].HeroBattleInfo:DispelAllGranBuff(true,nil,e.HeroId)
end
for t=1,l do
local t=a[t]
t:AddBuff(e,u,h,n)
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,s,d,0,r)
local a=a[3]
local o=a.reduceHpValue
local a=303101201
local a=e.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetBuffData()
local a=a[5]
local a=math.floor(o*a*MillionCoe)
i:AddSepsisHp(e,t,a)
end
end
local a=303101229
local o=e.HeroBattleInfo:GetBuff(a)
if(o)then
local s=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local n=303101233
local a=i:GetHeroListBuffFloor(e,BattleHeroType.enemyAll,n,true,t[10])
for h=1,#a do
local a=a[h].enemy
s.AddBuffWireRestraint(o,a,t[11])
if i:GetHeroBuffFloor(a,n)>=t[12]then
local o=t[13]
local i=t[14]
local t={}
a:AddBuff(e,o,i,t)
end
end
end
return nil
end
return u

