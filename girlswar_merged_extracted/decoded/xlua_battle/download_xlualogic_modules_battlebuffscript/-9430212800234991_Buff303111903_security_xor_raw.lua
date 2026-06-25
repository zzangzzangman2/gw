local o=require("Modules/Battle/BattleUtil")
local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddDispelDisturb(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveDispelDisturb(e.buffId)
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
function e.OnTriggerDispelDisturb(e,t)
local a=e:GetBuffData()
if t==false then
if e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo then
local t=e.CurrHeroCtrl.HeroBattleInfo:DispelGranBuff(true,1)
if#t<=0 and e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo then
e.CurrHeroCtrl:RealHurtWithBuff(a[1],e)
end
end
if e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo then
o:ReduceHeroBuffFloor(e.CurrHeroCtrl,e.buffId,1)
end
return true,false
end
return false,false
end
return i 
