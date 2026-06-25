local e={
}
local a=e
function e.DoAction(a,e)
local t=e.attr[1]
local i=e.attr[2]
local o={e.attr[3]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeam(a,BattleHeroType.enemyAll)
if(e)then
for a,e in ipairs(e)do
e:AddBuff(e,t,i,o)
end
end
return nil
end
function e.GetTriggerTime()
return RelicTriggerTime.now
end
return a 
