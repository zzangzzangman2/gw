local e=require("Modules/Battle/BattleUtil")
local e={
}
local c=e
function e.DoAction(e,i,t,t)
local o=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
e:ReduceFury(i.costMp)
local n=302109013
local t=e.HeroBattleInfo:GetBuff(n)
local s=302109014
local m=e.HeroBattleInfo:GetBuff(s)
local c=o[1]
local s=o[4]
local y=o[5]
local f=o[6]
local d=0
local h=o[7]
local w=o[8]
local l=o[9]
local u=0
local r=#a
for r=1,r do
local a=a[r]
local o=o[3]
if t then
local e=t:GetBuffData()
o=o+e[1]
end
local r=a.HeroBattleInfo:DispelGranBuff(true,o,nil,nil,e.HeroId)
local o=0
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
o=e.DoActionBigSkill(t,#r)
end
if a:IsRealFirstRowHero()or t then
local o=302109011
local t=e.HeroBattleInfo:GetBuff(o)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.AddSuperIsolatedBuff(t,a,s)
else
local t=302109016
local t=e.HeroBattleInfo:GetBuff(t)
if t==nil then
a:CheckAddBuff(s,e,y,f,d)
end
end
end
if a:IsRealLastRowHero()or t then
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.AddSuperHelplessBuff(t,a,h)
else
if m==nil then
a:CheckAddBuff(h,e,w,l,u)
end
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,c,0,o)
end
return nil
end
return c 
