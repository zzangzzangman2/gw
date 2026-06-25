local a={
}
local o=a
function a.DoAction(e,a)
if(e)then
for t,e in ipairs(e.HeroCtrls)do
if(e.HeroBattleInfo.CurrHP>0 or(e.HeroBattleInfo.CurrHP==0 and e:IsNotUsualState()))then
local t=e.HeroBattleInfo.OriginalHP-e.HeroBattleInfo.CurrHP
if(t>0)then
local t=t*a.attr[1]*MillionCoe
t=math.floor(t)
e:HpHealthImmediately(t,EBattleSrcType.Relic,0,0)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
end
return nil
end
function a.GetTriggerTime()
return RelicTriggerTime.battleEnd
end
return o 
