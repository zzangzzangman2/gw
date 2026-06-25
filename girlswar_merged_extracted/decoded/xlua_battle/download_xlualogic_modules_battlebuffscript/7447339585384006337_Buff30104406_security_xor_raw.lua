local o={}
local i=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,a,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a==nil or a.HeroBattleInfo==nil then
return
end
if#e>=2 then
a.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
end
if#e>=4 then
a.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
end
if#e>=6 then
a.HeroBattleInfo:AddBuffValue(t.buffId,e[5],e[6])
end
t.isExec=true
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return i

