local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetCurrFury()
local a=math.floor(a*t[2]*MillionCoe)
if a>0 then
e.CurrHeroCtrl:ReduceFuryWithBuffImmediately(a)
end
local o=e.CurrHeroCtrl.HeroBattleInfo:GetCurrHP()
local t=math.floor(o*t[1]*MillionCoe)
if t>0 then
e.CurrHeroCtrl:RealHurtWithBuff(t,e)
end
if a>0 or t>0 then
return{
ret=true
}
end
end
return{
ret=false
}
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

