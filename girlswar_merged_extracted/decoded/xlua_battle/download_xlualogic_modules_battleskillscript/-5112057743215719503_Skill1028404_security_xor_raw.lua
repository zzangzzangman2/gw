local e={}
local n=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[1]
local o=e[2]
local a={e[3],e[4]}
t:AddBuff(t,i,o,a)
local i=e[5]
local o=e[6]
local a={e[7],e[8],e[9],e[10]}
t:AddBuff(t,i,o,a)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHerosByHeroModelId(t,BattleHeroType.all,e[11])
if#a>0 then
t:ResetFuryWithBuff(e[12])
end
local a=e[13]
local o=e[14]
local i={e[15],e[16]}
t:AddBuff(t,a,o,i)
t:AddImmunneBuffId(e[17])
t:AddImmunneBuffId(e[18])
end
return n

