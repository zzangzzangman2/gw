local t={}
function t.AddSoulBuff(e,a,n,i,o)
local t=t.GetSoulBuffId(a)
if t~=nil and a~=e.soulId then
e:AddBuff(e,t,n,i,o)
end
end
function t.GetSoulBuffId(e)
if e==EBattleSoulId.Soul1020 then
return 3103
elseif e==EBattleSoulId.Soul1120 then
return 3104
elseif e==EBattleSoulId.Soul1220 then
return 3105
elseif e==EBattleSoulId.Soul1320 then
return 3106
elseif e==EBattleSoulId.Soul1420 then
return 3107
elseif e==EBattleSoulId.Soul1520 then
return 3108
elseif e==EBattleSoulId.Soul1620 then
return 3109
elseif e==EBattleSoulId.Soul1720 then
return 3110
end
return nil
end
return t

