local t={}
local i=t
local o=31111
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,n,i,n,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,a[1],a[2])
elseif t.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
if i.heroDid==o then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.enemyTeamHeroDead then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

