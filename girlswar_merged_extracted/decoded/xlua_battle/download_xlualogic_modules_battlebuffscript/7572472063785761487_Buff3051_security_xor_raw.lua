local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,i)
local a=o.CurrHeroCtrl.CurrBattleTeam.OpponentTeam:GetHeroCtrlWithBuffId(2011)
if(a)then
local t={}
local e=HeroBuffValueInfo:New()
e.buffId=o.buffId
e.attrId=HeroAttrId.furyRate
e.value=i[1]*#a
t[#t+1]=e
return t
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.recoverFury)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return i

