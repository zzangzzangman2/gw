local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetRealHurt(e,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=e:GetBuffData()
local t=o.HeroBattleInfo:GetMaxHP()
local e=0
local o=o.HeroBattleInfo:GetTotalBuffValue(HeroAttrId.shield)
if(o>0)then
e=t*a[2]*MillionCoe
else
e=t*a[1]*MillionCoe
end
return e
end
return i

