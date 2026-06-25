local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local i=t[1]
local a=t[2]
local t={t[3]}
o:AddBuff(e.CurrHeroCtrl,i,a,t)
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

