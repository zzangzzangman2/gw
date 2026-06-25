local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if(e.CurrHeroCtrl:CurrHPPer()>t[1]*MillionCoe)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[2],t[3])
else
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[4],t[5])
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckExcuteResistFatalDamage(e)
local t=e:GetBuffData()
local t=t[6]
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local t=t:GetBuffData()
if t[2]<t[1]then
t[2]=t[2]+1
e.CurrHeroCtrl:SetResistFatalDamage(true)
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
return true
end
end
return false
end
return a

