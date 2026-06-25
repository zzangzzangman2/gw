local n=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t[3]>0 then
i.AddShield(e,t[3])
t[3]=0
end
e.isExec=true
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.now then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddShield(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t==nil or t<=0 then
return
end
local a=e:GetBuffData()
local i=e.CurrHeroCtrl.HeroBattleInfo
local n=a[2]
local a=0
local o=i:GetBuffValue(e.buffId,HeroAttrId.shield)
if o then
a=o.value
end
local o=n-a
if o<=0 then
return
end
if t>o then
t=o
end
if t<=0 then
return
end
i:CheckAddBuffValue(e.buffId,HeroAttrId.shield,a+t)
end
function t.HandleShieldReduce(e,t,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if t==nil or t<=0 then
return
end
local a=e:GetBuffData()
local a=math.floor(t*a[1]*MillionCoe)
if a<=0 then
return
end
local t=n:GetTargetHeroCtrl(o)
if t==nil or t.HeroBattleInfo==nil or t.HeroBattleInfo.CurrHP<=0 then
return
end
t:RealHurtWithBuff(a,e)
end
return i

