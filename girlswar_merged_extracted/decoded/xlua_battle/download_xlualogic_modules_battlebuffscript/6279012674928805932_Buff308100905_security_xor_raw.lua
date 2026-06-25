local i=require("Modules/Battle/BattleUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,o,n,t,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local o=e.CurrHeroCtrl.HeroId
if o==n.HeroId then
if t.hurtValue>0 then
local o=a[1]
local t=math.floor(t.hurtValue*o*MillionCoe)
t=math.min(t,a[2])
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
i:AddSepsisHp(a,e.CurrHeroCtrl,t,true,true)
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
return s

