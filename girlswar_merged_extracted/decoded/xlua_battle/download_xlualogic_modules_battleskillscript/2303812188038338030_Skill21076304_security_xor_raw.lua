local s=require("Modules/Battle/BattleUtil")
local e={}
local r=e
function e.DoAction(e,o,a,t)
local a=e:JudgeSkillPreView(o)
local d=0
local r=t.realHurt
local i=t.defHeroIds
local a=t.reduceHpValue
local h=t.addHpRate
local t=nil
if i then
local e=i[1]
t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
end
if t then
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local i=302107616
local n=e.HeroBattleInfo:GetBuff(i)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionBigSkill2(n,t)
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,d,nil,r)
local t=t[3]
local t=t.reduceHpValue
a=a+t
local a=302107610
local e=e.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.SetBigSkillDamageInThisRound(e,t)
end
end
local t=math.floor(a*h*MillionCoe)
s:HpHealthWithBigSkillAndParam(e,o.skilltype,t,1)
return nil
end
return r

