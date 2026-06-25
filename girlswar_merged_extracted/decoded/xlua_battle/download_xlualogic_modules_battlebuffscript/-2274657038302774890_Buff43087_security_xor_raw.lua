local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,a)
if(e.CurrHeroCtrl:CurrHPPer()<t[1]*MillionCoe)then
local o=43088
local a=1
local t={t[2],t[3]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return o

