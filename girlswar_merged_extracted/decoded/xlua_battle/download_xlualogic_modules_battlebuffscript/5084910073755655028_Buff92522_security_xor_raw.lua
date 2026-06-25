local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddAbsorptionHeal(e.buffId)
end
function e.OnRemoveSelf(t,e)
if ModulesInit.ProcedureNormalBattle.isBattleEnd then
return
end
local a=e[2]
local e=t.CurrHeroCtrl
if e~=nil then
e:RemoveAbsorptionHeal(t.buffId)
end
if a>0 and e~=nil and e.HeroBattleInfo~=nil and e.HeroBattleInfo.CurrHP>0 then
e:RealHurtWithBuff(a,t)
end
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
function e.ExcuteAbsorptionHeal(e,o)
local t=e:GetBuffData()
local e=t[1]
local i=t[2]
local e=e-i
if e<=0 then
return 0
end
local a=o
if o>e then
a=e
end
t[2]=i+a
return a
end
return n

