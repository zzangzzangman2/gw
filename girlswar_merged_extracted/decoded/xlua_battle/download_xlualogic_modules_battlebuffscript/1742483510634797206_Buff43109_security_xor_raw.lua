local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(t,e)
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
end
function t.OnRemoveSelf(e,e)
end
function t.DoAction(t,e,i,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=a.oldHP
local a=a.currHP
if o>a then
if e[8]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[8]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[7]=0
end
local a=e[6]
e[7]=e[7]or 0
if(e[7]>=a)then
return nil
end
i:AddFuryWithBuff(e[5],ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t.releaseHeroId),EBattleSrcType.Buff,false)
e[7]=e[7]+1
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.hpChange)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

