local e={}
local n=e
function e.DoAction(t,a)
local e=t:JudgeSkillPreView(a)
local h=e[1]
local s=e[3]
local n=e[4]
local i=e[5]
local o={e[6]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
if(s>=RandomMgr:GetBattleRandom())then
e:AddBuff(t,n,i,o)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,h)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return n

