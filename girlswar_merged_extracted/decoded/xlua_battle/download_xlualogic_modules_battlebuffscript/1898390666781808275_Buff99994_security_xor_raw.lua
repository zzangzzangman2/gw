local e={}
local o=e
local i=require("Modules/Battle/BattleUtil")
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(a,e)
for t=1,#e,2 do
if e[t]==HeroAttrId.hpAdd and e[t+1]then
i:AddHPAndMaxHP(a.CurrHeroCtrl,e[t+1])
break
end
end
end
function e.OnRemoveSelf(a,e)
for t=1,#e,2 do
if e[t]==HeroAttrId.hpAdd and e[t+1]then
a.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHP(e[t+1])
break
end
end
end
function e.DoAction(a,e)
for t=1,#e,2 do
if e[t]~=HeroAttrId.hpRate and e[t+1]then
a.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(a.buffId,e[t],e[t+1])
end

end
a.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return o 
