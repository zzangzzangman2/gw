local t={}
local n=t
local o=require("Modules/Battle/BattleUtil")
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl:AddImmortal(e.buffId)
e.CurrHeroCtrl:AddIgnoreForbidHeal(e.buffId)
e.CurrHeroCtrl:AddIgnoreHealThrons(e.buffId)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveImmortal(e.buffId)
e.CurrHeroCtrl:RemoveIgnoreForbidHeal(e.buffId)
e.CurrHeroCtrl:RemoveIgnoreHealThrons(e.buffId)
end
function t.DoAction(e,a,i,i,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
elseif t.buffTriggerTime==BuffTriggerTime.eachRoundStart
or t.buffTriggerTime==BuffTriggerTime.enemyRoundStart then
if o.IsBigRoundStart(t.buffTriggerTime,e.CurrHeroCtrl)then
if ModulesInit.ProcedureNormalBattle.CurrBattleBigRound>e.CurrHeroCtrl.appearBattleBigRound then
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local i=t*a[1]*MillionCoe
e.CurrHeroCtrl:HpHealthWithBuffImmediately(i,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true,{fobidHealRate=true})
local t=math.floor(t*a[2]*MillionCoe)
o:ReduceSepsisHp(e.CurrHeroCtrl,e.CurrHeroCtrl,t,true,true)
local t=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-e.CurrHeroCtrl.appearBattleBigRound
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,a[3],a[4]*t)
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.enemyRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n 
