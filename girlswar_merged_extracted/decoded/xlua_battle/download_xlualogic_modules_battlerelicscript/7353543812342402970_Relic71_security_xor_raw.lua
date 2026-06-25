local a={
}
local o=a
function a.DoAction(e,t)
if(e)then
for a,e in ipairs(e.HeroCtrls)do
if(e.HeroBattleInfo.CurrHP>0 or(e.HeroBattleInfo.CurrHP==0 and e:IsNotUsualState()))then
local t=t.attr[1]
t=math.min(t,e.HeroBattleInfo.Fury-e.HeroBattleInfo.CurrFury)
e:AddFuryWithBuff(t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
return nil
end
function a.GetTriggerTime()
return RelicTriggerTime.now
end
return o 
