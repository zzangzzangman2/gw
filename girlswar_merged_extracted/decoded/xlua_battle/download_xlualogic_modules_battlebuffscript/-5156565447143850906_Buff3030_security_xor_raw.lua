local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(a,e)
local t=e[1]*MillionCoe
local o=a.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a.CurrHeroCtrl,BattleHeroType.fAttrLowExcludeSelf,1,HeroAttrId.hpPer)
if(t~=nil and#t>0)then
local t=t[1]
t:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,a.releaseHeroId,a.buffId)
local i=e[2]
local a=e[3]
local o={e[4]}
t:AddBuff(t,i,a,o)
local a=e[5]
local o=e[6]
local e={e[7]}
t:AddBuff(t,a,o,e)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.HeroDead)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]+e.buffWeight[3]*t[3]
end
return i

