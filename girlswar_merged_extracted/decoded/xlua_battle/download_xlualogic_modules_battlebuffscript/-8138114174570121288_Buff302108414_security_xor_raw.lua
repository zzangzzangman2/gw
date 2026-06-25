local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneReduceFury(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RefreshImmuneReduceFury()
end
function e.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
o.AddShield(e,t[1])
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
function e.AddShield(e,n)
local a=e:GetBuffData()
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local i=math.floor(t*a[2]*MillionCoe)
local a=0
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuffValue(e.buffId,HeroAttrId.shield)
if o then
a=o.value
end
local o=n*MillionCoe
local t=math.floor(t*o)
t=math.min(a+t,i)
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,HeroAttrId.shield,t)
end
return o

