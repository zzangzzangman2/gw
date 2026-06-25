local o=require("Modules/Battle/BattleUtil")
local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,e)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveHealToSepsissRate(e.buffId)
end
function e.OnOverlap(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
a.OnBuffAdd(e,t)
end
function e.DoAction(e,t,o,o,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
a.OnBuffAdd(e,t)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.OnBuffAdd(e,t)
if t[1]>0 then
local a=t[1]
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=math.floor(t*a*MillionCoe)
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
o:AddSepsisHp(a,e.CurrHeroCtrl,t,true,true)
end
if t[2]>0 then
local a=e:GetFloors()
e.CurrHeroCtrl:AddHealToSepsissRate(e.buffId,t[2]*a)
end
end
return a

