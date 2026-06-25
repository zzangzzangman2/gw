local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,e,a,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a==nil or a.HeroBattleInfo==nil then
return
end
local o=e[1]
local i=e[2]
local e={e[3],e[4],e[5],e[6],e[7],e[8]}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
t.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

