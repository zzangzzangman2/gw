local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,e)
end
function t.OnRemoveSelf(e,e,e)
end
function t.DoAction(e,t,i,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.teamHeroDead
or a.buffTriggerTime==BuffTriggerTime.addMyMate then
o.AddBuffIgnoreFury(e,t)
elseif a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl:AddImmuneThorn(e.buffId)
e.CurrHeroCtrl:AddImmunneBuffId(t[5])
o.AddBuffIgnoreFury(e,t)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.teamHeroDead
or e==BuffTriggerTime.addMyMate)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffIgnoreFury(e,t)
local a=t[6]
local t=t[7]
local o={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,t,o)
end
return o

