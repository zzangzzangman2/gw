local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.shield,t[1])
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddShield(e)
local a=e:GetBuffData()
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuffValue(e.buffId,HeroAttrId.shield)
if t==nil then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.shield,a[1])
else
t.value=t.value+a[1]
end
end
return o

