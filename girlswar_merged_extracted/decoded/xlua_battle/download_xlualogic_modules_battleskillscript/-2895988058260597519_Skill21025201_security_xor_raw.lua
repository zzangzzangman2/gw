local e={}
local h=e
function e.DoAction(e,n)
local o=e:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local i=o[1]
local s=302102504
local t=e.HeroBattleInfo:GetBuff(s)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.DoActionSmallSkill(t)
end
local s=0
local t=e.HeroBattleInfo:GetBuff(302102503)
if t then
local e=t:GetBuffData()
s=e[2]
end
local t=s*o[3]
t=math.min(t,o[4])
i=i+t
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,n,i)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h

