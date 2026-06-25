local e=require("Modules/Battle/BattleUtil")
local e=require("Modules/Battle/Formula")
local e={
}
local u=e
function e.DoAction(e,i,t,t)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eColumn)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local o=e.HeroBattleInfo.MaxHP
local u=t[1]
local d=t[3]
local n=t[4]
local l=t[5]
local s=math.floor(o*t[7]*MillionCoe)
local h={s,e.HeroId,0}
local s=math.floor(o*t[6]*MillionCoe)
local o=303110811
local t=e.HeroBattleInfo:GetBuff(o)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoActionSmallSkill2(t)
end
for r=1,#a do
local a=a[r]
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoActionSmallSkill(t,a)
end
local t=a.HeroBattleInfo:GetBuff(n)
if t==nil then
a:CheckAddBuff(d,e,n,l,h)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,u,0,s)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return u 
