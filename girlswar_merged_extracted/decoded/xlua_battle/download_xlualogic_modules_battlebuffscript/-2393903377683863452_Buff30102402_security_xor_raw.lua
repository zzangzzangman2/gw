local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil then
GameInit.LogError("Buff30102402 heroBuffInfo or heroBuffInfo.CurrHeroCtrl == nil")
return
end
if#t<1 then
GameInit.LogError("Buff30102402 buffData 数量应该 大于 1")
return
end
e.CurrHeroCtrl:RealHurtWithBuff(t[1],e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return a

