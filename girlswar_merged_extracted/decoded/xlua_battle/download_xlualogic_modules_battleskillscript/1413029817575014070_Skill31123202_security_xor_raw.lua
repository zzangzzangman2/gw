local e={}
local n=e
function e.DoAction(e,i,t,t)
local a=e:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if t==nil then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local o=e.HeroBattleInfo:GetGranBuff(true)
local o=#o
local o=math.min(o*a[2],a[3])
if o>0 then
e:AddFuryWithSkill(o)
end
local a=a[1]
local o=#t
for o=1,o do
local t=t[o]
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,a)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n

