local o={
}
local i=o
function o.DoAction(t,e)
local a=ModulesInit.ProcedureNormalBattle.dicePosition
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(a==0)then
return
end
local t=t:GetHeroCtrlWithPos(a)
if(t==nil)then
return
end
if(a==1)then
local a=e.attr[1]
local o=e.attr[2]
local e={e.attr[3]}
t:AddBuff(t,a,o,e)
elseif(a==2)then
local a=e.attr[4]
local o=e.attr[5]
local e={e.attr[6]}
t:AddBuff(t,a,o,e)
elseif(a==3)then
local o=e.attr[7]
local a=e.attr[8]
local e={e.attr[9]}
t:AddBuff(t,o,a,e)
elseif(a==4)then
local o=e.attr[10]
local a=e.attr[11]
local e={e.attr[12]}
t:AddBuff(t,o,a,e)
elseif(a==5)then
local a=e.attr[13]
local o=e.attr[14]
local e={e.attr[15]}
t:AddBuff(t,a,o,e)
elseif(a==6)then
local a=e.attr[16]
local o=e.attr[17]
local e={e.attr[18]}
t:AddBuff(t,a,o,e)
end
end
function o.GetTriggerTime()
return RelicTriggerTime.now
end
return i 
