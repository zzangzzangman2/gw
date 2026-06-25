local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,e,a,o,o,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a:IsPet()then
return
end
if e[8]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[8]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[7]=0
end
if e[7]>=e[6]then
return
end
e[7]=e[7]+1
local n=e[1]
local i=e[2]
local o=e[3]
local e={e[4],e[5]}
a:CheckAddBuff(n,t.CurrHeroCtrl,i,o,e)
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.beCritical)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

