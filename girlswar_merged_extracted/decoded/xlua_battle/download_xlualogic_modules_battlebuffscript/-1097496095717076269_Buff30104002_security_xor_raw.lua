local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(a,t,o,e)
if e==nil then
GameInit.LogError("Buff30104002 beAtkHeroCtrl 不能为空 ")
return
end
if(e:CurrHPPer()<t[1]*MillionCoe)then
local e=HeroBuffValueInfo:New()
e.buffId=a.buffId
e.attrId=t[2]
e.value=t[3]
a.CurrHeroCtrl.HeroBattleInfo:AddTempBuffValue(e)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return o

