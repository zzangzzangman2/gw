local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t[2]==1 then
t[2]=0
a.hurt(e,t,e.CurrHeroCtrl)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.skillEndBuff)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.hurt(a,o,e)
local t=e.HeroBattleInfo:GetMaxHP()
local t=math.floor(t*o[1]*MillionCoe)
if t>0 then
e:RealHurtWithBuff(t,a)
end
end
return a

