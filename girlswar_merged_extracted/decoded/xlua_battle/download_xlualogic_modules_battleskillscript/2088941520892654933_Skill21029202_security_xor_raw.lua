local e={
}
local n=e
function e.DoAction(e,i)
local a=e:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local n=a[1]
local o=a[3]
local a=a[4]
local a=t:AddBuff(e,o,a)
if a then
local o=302102906
local a=e.HeroBattleInfo:GetBuff(o)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.AddCharonMarkStatCount(a,1)
end
local a=302102908
local e=e.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddBuffNetherWorld(e,t)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,n)
e:FuryHealth(FuryHealthType.Attack)
end
return n 
