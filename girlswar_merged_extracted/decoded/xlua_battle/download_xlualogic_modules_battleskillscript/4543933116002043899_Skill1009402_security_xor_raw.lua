local e={
}
local n=e
function e.DoAction(e,t)
local t=e:JudgeSkillPreView(t)
if(e.CurrBattleTeam:GetAllHerosCount()>e.CurrBattleTeam.OpponentTeam:GetAllHerosCount())then
local i=t[1]
local o=t[2]
local a={t[3]}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.ourAll)
if(t)then
for n,t in ipairs(t)do
t:AddBuff(e,i,o,a)
end
end
end
return nil
end
return n 
