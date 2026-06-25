local e={}
local o=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[1]
local a=e[2]
local i={e[3],e[4]}
t:AddBuff(t,o,a,i)
t:AddImmunneBuffId(e[5])
t:AddImmunneBuffId(e[6])
local a=ModulesInit.ProcedureNormalBattle.GetBattleHerosByHeroModelId(t,BattleHeroType.all,e[7])
if#a>0 then
t:ResetFuryWithBuff(e[8])
end
end
return o

