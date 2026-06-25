local e={
}
local t=e
function e.DoAction(e,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.OpponentTeam:DispelAllGranBuff(true)
end
function e.GetTriggerTime()
return RelicTriggerTime.eachRoundEnd
end
return t 
