local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(e,t,t,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionWith6Start(e,t)
local o=e:GetBuffData()
local a=t.HeroBattleInfo:GetBuff(43138)
if a then
local a=a:GetBuffData()
local a=a[2]
local t=t:CurrHPPer()
if(a-t)>=o[2]*MillionCoe then
e.CurrHeroCtrl:SetMustSmallSkill()
end
end
end
function e.DoActionWith6End(e,t)
local a=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a[1]*MillionCoe
t:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.CurrHeroCtrl.HeroId,e.buffId)
end
return i 
