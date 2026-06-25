local i=require("Modules/Battle/BattleUtil")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[2])
n.AddShield(e)
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
local t=e:GetBuffData()
local o=e.CurrHeroCtrl:GetFinalAtk()
local a=math.floor(o*t[3]*MillionCoe)
local i=math.floor(o*t[6]*MillionCoe)
local o=t[7]
local o=i-o
a=math.min(o,a)
t[7]=t[7]+a
local t=0
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuffValue(e.buffId,HeroAttrId.shield)
if o then
t=o.value
end
local t=t+a
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,HeroAttrId.shield,t)
end
function t.HandleShieldRemoveBefore(e,n)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local t=e:GetBuffData()
local a=303111610
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a==nil then
local o=303111607
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local a=a:GetFloors()
if a<t[4]then
return
else
i:ReduceHeroBuffFloor(e.CurrHeroCtrl,o,t[4])
end
end
end
local a=t[7]
local t=i:GetTargetHeroCtrl(n)
if t then
t:RealHurtWithBuff(a,e)
end
end
return n

