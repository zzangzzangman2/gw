local t={
}
local a=t
function t.DoAction(a,e)
local t=e.attr[1]
local i=e.attr[2]
local o={e.attr[3],e.attr[4],e.attr[5],e.attr[6],e.attr[7]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeam(a,BattleHeroType.ourAll)
if(e)then
for a,e in ipairs(e)do
e:AddBuff(e,t,i,o)
end
end
return nil
end
function t.GetTriggerTime()
return RelicTriggerTime.now
end
return a 
