local e={}
local n=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local i=e[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
if(t.FirstAtkSelfHeroId==a.HeroId)then
local h=e[3]
local n=e[4]
local o={e[5]}
local i=e[6]
local s=e[7]
local e={e[8]}
a:AddBuff(t,h,n,o)
a:AddBuff(t,i,s,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return n

