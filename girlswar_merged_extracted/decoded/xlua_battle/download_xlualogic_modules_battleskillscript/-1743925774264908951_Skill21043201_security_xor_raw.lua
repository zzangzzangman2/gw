local e={
}
local s=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local n=302104305
local o=e.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(o)
end
local o=t[1]
if(a.profession==t[3])then
o=o+t[4]
end
if(t[5]>=RandomMgr:GetBattleRandom())then
e:AddFuryWithSkill(t[6])
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,o)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s 
