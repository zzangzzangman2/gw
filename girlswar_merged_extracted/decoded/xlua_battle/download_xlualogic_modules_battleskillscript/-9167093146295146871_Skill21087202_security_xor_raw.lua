local e={
}
local h=e
function e.DoAction(e,n)
local t=e:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eOneBack)
if(a==nil)then
return nil
end
local i=302108705
local o=e.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.AddBuffBlood(o,a)
end
local o=302108708
local i=e.HeroBattleInfo:GetBuff(o)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoActionSmallSkill(i,a)
end
local i=t[1]
if(t[3]>=RandomMgr:GetBattleRandom())then
local o=t[4]
local t=t[5]
a:AddBuff(e,o,t,0)
end
local o=t[6]
local s=t[7]
local t={t[8],t[9]}
e:AddBuff(e,o,s,t)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,n,i)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
