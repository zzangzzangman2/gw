local o=require("Modules/Battle/BattleUtil")
local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddForbidHeal(e.buffId)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RefreshForbidHeal()
end
function t.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=e.CurrHeroCtrl:RealHurtWithBuff(t[1],e)
if t then
if t.hurtValue>0 then
local t=math.floor(t.hurtValue)
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
o:AddSepsisHp(a,e.CurrHeroCtrl,t,true,true)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

