local a=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneReduceFury(e.buffId)
a:AddImmuneDebuffDizzy(e.CurrHeroCtrl)
e.CurrHeroCtrl:AddImmunneBuffId(3010)
e.CurrHeroCtrl:AddImmunneBuffId(3011)
e.CurrHeroCtrl:AddMustSmallSkill(e.buffId)
e.CurrHeroCtrl:SetCurrRoundCanTriggerSmallSkill()
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RefreshImmuneReduceFury()
a:ReduceImmuneDebuffDizzy(e.CurrHeroCtrl)
e.CurrHeroCtrl:ReduceImmunneBuffId(3010)
e.CurrHeroCtrl:ReduceImmunneBuffId(3011)
e.CurrHeroCtrl:RefreshMustSmallSkill()
end
function t.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
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
return o

