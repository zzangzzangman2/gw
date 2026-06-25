local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.Leave
t[1]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
elseif a.buffTriggerTime==BuffTriggerTime.backToBattleField then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
if t[2]<=0 and t[1]<ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e.CurrHeroCtrl.NotUsualType=0
t[2]=1
end
end
elseif a.buffTriggerTime==BuffTriggerTime.HeroDead
or a.buffTriggerTime==BuffTriggerTime.enterUnUsualStateBefore then
if t[2]<=0 then
e.CurrHeroCtrl.NotUsualType=0
e.CurrHeroCtrl.WillNotUsual=false
t[2]=1
e.CurrHeroCtrl.entranceType=EBattleHeroEntranceType.Quick
e.CurrHeroCtrl:ShowBackBattleField(true)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.backToBattleField
or e==BuffTriggerTime.HeroDead
or e==BuffTriggerTime.enterUnUsualStateBefore)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

