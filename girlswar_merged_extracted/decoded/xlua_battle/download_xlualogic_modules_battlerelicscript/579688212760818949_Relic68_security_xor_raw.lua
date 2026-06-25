local a={
}
local o=a
function a.DoAction(e,t)
if(e)then
for a,e in ipairs(e.HeroCtrls)do
if(e.HeroBattleInfo.CurrHP>0 or(e.HeroBattleInfo.CurrHP==0 and e:IsNotUsualState()))then
local t=e.HeroBattleInfo.MaxHP*t.attr[1]*MillionCoe
t=math.floor(t)
t=math.min(e.HeroBattleInfo.MaxHP-e.HeroBattleInfo.CurrHP,t)
if(t>0)then
e:HpHealthImmediately(t,EBattleSrcType.Relic,EBattleSrcType.Relic,0,0)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
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
