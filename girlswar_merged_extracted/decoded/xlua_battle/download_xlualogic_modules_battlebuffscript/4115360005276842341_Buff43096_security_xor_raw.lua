local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
end
function t.OnRemoveSelf(e,e)
end
function t.DoAction(t,e,o,n,a,i)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.beCriticalOrBlocked then
local t=a
if(t==1)then
local a=e[5]
local t=e[6]
local e={e[7]}
o:AddBuff(n,a,t,e)
end
elseif i.buffTriggerTime==BuffTriggerTime.hpChange then
local i=a.oldHP
local a=a.currHP
if i>a then
if e[11]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[11]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[10]=0
end
local a=e[9]
e[10]=e[10]or 0
if(e[10]>=a)then
return nil
end
o:AddFuryWithBuff(e[8],ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t.releaseHeroId),EBattleSrcType.Buff,false)
e[10]=e[10]+1
end
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.beCriticalOrBlocked or e==BuffTriggerTime.hpChange)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s

