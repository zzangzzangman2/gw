local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,o,o,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,a[1],a[2])
elseif t.buffTriggerTime==BuffTriggerTime.skillAttackComplete then
local e={
isOper=true,
remove=true,
}
return e
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillAttackComplete)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

