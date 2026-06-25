local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddImmuneAvoidDeath(e.buffId)
e.CurrHeroCtrl:AddImmuneResurgence(e.buffId)
e.CurrHeroCtrl:AddImmuneLockHp(e.buffId)
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if t[10]>0 then
return
end
a.BackBattleField(e,t,true)
end
function e.OnBuffEffect(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.CurrHeroCtrl:HideHero()
end
function e.DoAction(e,t,i,i,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.WillNotUsual=true
e.CurrHeroCtrl.NotUsualType=HeroState.Leave
t[9]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
elseif o.buffTriggerTime==BuffTriggerTime.backToBattleField then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
if t[10]<=0 and t[9]>0
and t[9]<ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
a.BackBattleField(e,t,false)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.HeroDead
or o.buffTriggerTime==BuffTriggerTime.enterUnUsualStateBefore then
a.BackBattleField(e,t,true)
end
end
function e.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.HeroDead
or e==BuffTriggerTime.enterUnUsualStateBefore
or e==BuffTriggerTime.backToBattleField then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.RemoveCtrlAttr(e,t)
if t[10]==0 then
e.CurrHeroCtrl:RemoveImmuneAvoidDeath(e.buffId)
e.CurrHeroCtrl:RemoveImmuneResurgence(e.buffId)
e.CurrHeroCtrl:RemoveImmuneLockHp(e.buffId)
end
end
function e.BackBattleField(e,t,o)
if t[10]>0 then
return
end
a.RemoveCtrlAttr(e,t)
e.CurrHeroCtrl.NotUsualType=0
e.CurrHeroCtrl.WillNotUsual=false
if o then
e.CurrHeroCtrl.entranceType=EBattleHeroEntranceType.Quick
e.CurrHeroCtrl:ShowBackBattleField(true)
else
e.CurrHeroCtrl.entranceType=EBattleHeroEntranceType.AutoOut
end
if t[1]==1 and e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
local o=t[2]
local i=t[3]
local a={}
for o=4,8 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,i,a)
end
t[10]=1
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
return a

