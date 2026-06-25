local a=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,i,n,t,n)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if e.CurrHeroCtrl.HeroId==i.HeroId then
local t=t.reduceHpValue
local t=303112001
local i,t=a:GetHeroNoBuffByType(e.CurrHeroCtrl,BattleHeroType.ourAll,t)
if#t>0 then
local t=a:GetMinHpPercentHeroArr(t,1)
local a=t[1]
if a then
local t=e.CurrHeroCtrl:GetFinalAtk()
local t=math.floor(t*o[1]*MillionCoe)
t=math.min(t,o[2])
a:RealHurtWithBuff(t,e)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

