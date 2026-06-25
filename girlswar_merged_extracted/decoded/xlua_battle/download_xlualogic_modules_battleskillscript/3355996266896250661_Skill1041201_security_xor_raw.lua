local e={}
local n=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local o=e[1]
if(e[3]>=RandomMgr:GetBattleRandom())then
local o=e[4]
local e=e[5]
a:AddBuff(t,o,e,0)
end
if(a.profession==ProfessionType.Mage)then
o=o+e[6]
end
if(e[7]>=RandomMgr:GetBattleRandom())then
t:AddFuryWithSkill(e[8])
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return n

