local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t)
local a=t[1]*MillionCoe
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a
a=math.floor(a)
local i=t[2]
local o=t[3]
local t={t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
e.CurrHeroCtrl:RealHurtWithBuff(a,e)
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return n

