local e={
}
local a=e
function e.DoAction(e,t)
if(ModulesInit.ProcedureNormalBattle.CurrMazeMonGroupRow and ModulesInit.ProcedureNormalBattle.CurrMazeMonGroupRow.monType==2)then
if(e)then
for a,e in ipairs(e.OpponentTeam.HeroCtrls)do
e.HeroBattleInfo:ReduceHPAndMaxHPPer(t.attr[1]*MillionCoe)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
return nil
end
function e.GetTriggerTime()
return RelicTriggerTime.now
end
return a 
