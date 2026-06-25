local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local o=t[1]
local a=t[2]
local t={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
return o

