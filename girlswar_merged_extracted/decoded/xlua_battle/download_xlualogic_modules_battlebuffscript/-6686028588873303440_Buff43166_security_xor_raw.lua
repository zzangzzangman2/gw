local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(t,e)
t.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(e[1]*MillionCoe)
end
function a.OnRemoveSelf(e,t)
e.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(t[1]*MillionCoe)
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[2],e[3])
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
if t.CurrHeroCtrl:IsAttackInCurSmallRound()then
return
end
if t.CurrHeroCtrl:CheckHeroCanDoAction()==false then
return
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.selfColumn)
if(a)then
for o=1,#a do
local a=a[o]
local n=e[4]
local i=e[5]
local o={e[6],0}
a:AddBuffAfterRemove(t.CurrHeroCtrl,n,i,o)
local o=e[7]
local i=e[8]
local n={e[9],e[10]}
a:AddBuff(t.CurrHeroCtrl,o,i,n)
local o=e[11]
local i=e[12]
local e={e[13],e[14]}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
end
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return s

