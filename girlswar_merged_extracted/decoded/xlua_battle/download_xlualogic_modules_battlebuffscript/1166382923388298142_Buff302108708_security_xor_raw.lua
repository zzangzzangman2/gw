local e={}
local n=e
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
function e.DoActionSmallSkill(e,o)
local a=e:GetBuffData()
local t=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()-e.CurrHeroCtrl.HeroBattleInfo:GetCurrHP()
local t=math.floor(t*a[1]*MillionCoe)
local i=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a[2]*MillionCoe)
t=math.min(t,i)
if t>0 then
e.CurrHeroCtrl:HpHealthWithBuff(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
local t=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a[3]*MillionCoe)
o:RealHurtWithBuff(t,e)
end
return n

