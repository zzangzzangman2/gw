local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(t,e,a,i)
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(43082)
local o=false
if(a~=nil)then
o=a.IsTriggerControl==nil and false or a.IsTriggerControl
end
local a=i.HeroBattleInfo:HasControlBuff()
if(o or a)then
local i=e[1]
local o=e[2]
local a={e[3]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local a=e[4]
local o=e[5]
local e={e[6]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]+e.buffWeight[3]*t[3]+e.buffWeight[4]*t[4]+e.buffWeight[5]*t[5]+e.buffWeight[6]*t[6]
end
return i

