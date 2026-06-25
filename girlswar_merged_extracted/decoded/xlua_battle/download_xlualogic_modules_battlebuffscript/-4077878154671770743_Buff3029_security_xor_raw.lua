local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
local t=t[1]*MillionCoe
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fAttrLowExcludeSelf,1,HeroAttrId.hpPer)
if(t~=nil and#t>0)then
local t=t[1]
t:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.HeroDead)then
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

