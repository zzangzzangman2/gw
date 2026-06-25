local e={
}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,a,t)
if t==BuffRemoveType.Dispel or t==BuffRemoveType.Purify then
local a=a[3]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=t*a
e.CurrHeroCtrl:RealHurtWithBuff(t,e,nil,nil,nil,nil,{notDead=true})
end
end
function e.DoAction(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#t>=2 then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
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
function e.GetWeight(e,t,t)
return e.buffWeight[1]
end
return o 
