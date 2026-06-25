local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if e[5]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[5]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[4]=0
end
local a=e[3]
e[4]=e[4]or 0
if(e[4]>=a)then
return nil
end
e[4]=e[4]+1
t.CurrHeroCtrl:AddFuryWithBuff(e[1])
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.mateSkillAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

