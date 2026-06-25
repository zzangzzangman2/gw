local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,a,a,s)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local n=e[9]
local o=e[10]
local a={e[11],e[12],e[13],e[14]}
if s.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[5],e[6])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[7],e[8])
t.CurrHeroCtrl:AddBuff(i,n,o,a)
elseif s.buffTriggerTime==BuffTriggerTime.resurgence then
t.CurrHeroCtrl:AddBuff(i,n,o,a)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.resurgence)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

