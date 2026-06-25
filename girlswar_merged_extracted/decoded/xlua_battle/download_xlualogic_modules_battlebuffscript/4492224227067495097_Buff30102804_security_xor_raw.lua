local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
local a=math.max(0,1-e.CurrHeroCtrl:CurrHPPer())
local a=math.floor(a*t[2])
e.CurrHeroCtrl:CheckAddBuffValue(e.buffId,t[1],a)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.hpChange)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

