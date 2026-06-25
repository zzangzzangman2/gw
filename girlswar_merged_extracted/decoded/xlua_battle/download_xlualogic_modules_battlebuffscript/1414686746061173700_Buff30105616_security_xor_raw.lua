local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=e.CurrHeroCtrl:CurrHPPer()
local o=OneMillion-a*OneMillion
local a=OneMillion-t[3]
if a>0 then
local a=o/a
if#t>=2 then
e.CurrHeroCtrl:CheckAddBuffValue(e.buffId,t[1],math.floor(t[2]*a))
end
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

