local t={
}
local n=t
function t.DoAction(a,e)
local t=e.attr[1]
local i=e.attr[2]
local o={e.attr[2],e.attr[3]}
local e=a.OpponentTeam:GetRandomHeros(1)
if(e and#e>0)then
local e=e[1]
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e:AddBuff(e,t,i,o)
end
return nil
end
function t.GetTriggerTime()
return RelicTriggerTime.now
end
return n 
