local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoLimitAction(e,a)
local t=a[1]
local o=302110421
local n=2
local i=0
if t>0 then
local t=e.CurrHeroCtrl:CheckAddBuff(t,e.CurrHeroCtrl,o,n,i)
if t and e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a[1],BuffRemoveType.Expire)
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleAllBuffEffect()
end
return t
else
return false
end
return false
end
return i

