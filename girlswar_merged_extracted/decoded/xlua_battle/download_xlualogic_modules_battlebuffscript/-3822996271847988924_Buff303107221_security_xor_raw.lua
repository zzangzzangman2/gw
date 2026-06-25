local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.eMinHpPercent)
if t then
t:HpHealthWithBuffImmediately(a[1],EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
e.CurrHeroCtrl:RealHurtWithBuff(a[1],e)
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

