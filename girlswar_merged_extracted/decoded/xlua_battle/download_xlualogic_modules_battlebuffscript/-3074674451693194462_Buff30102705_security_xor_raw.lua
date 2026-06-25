local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[3]
local i=a-t[2]
local a=t[4]or 0
local o=t[5]or 0
if o~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
a=0
end
if a<i then
t[4]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
a=a+1
t[5]=a
local t=t[1]*MillionCoe
local t=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
function a.GetCanTrigger(e)
return false
end
function a.SetLogicData(e,e)
end
return n

