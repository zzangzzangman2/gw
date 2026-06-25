local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(t,e)
t.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(e[3]*MillionCoe)
end
function a.OnRemoveSelf(t,e)
t.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(e[3]*MillionCoe)
end
function a.DoAction(t,e,a,a,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
if e[10]<=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
local a=e[4]
local o=e[5]
local e={e[6],e[7],e[8],e[9]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
t.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

