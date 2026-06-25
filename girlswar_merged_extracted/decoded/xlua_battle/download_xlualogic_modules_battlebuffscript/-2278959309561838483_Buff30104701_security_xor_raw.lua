local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=1 then
e.CurrHeroCtrl:RealHurtWithBuff(t[1],e)
end
return{
ret=true
}
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return a

