local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,t)
if t[9]==1 and t[2]==0 then
e.CurrHeroCtrl:AddImmuneAvoidDeath(e.buffId)
e.CurrHeroCtrl:AddImmuneResurgence(e.buffId)
e.CurrHeroCtrl:AddImmuneLockHp(e.buffId)
end
end
function a.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
o.RemoveCtrlAttr(e,t)
o.BackBattleField(e,t)
end
function a.DoAction(t,e,i,i,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.WillNotUsual=true
t.CurrHeroCtrl.NotUsualType=HeroState.Leave
e[1]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
o.SetSwallowHeroId(t,e,t.CurrHeroCtrl.HeroId)
elseif a.buffTriggerTime==BuffTriggerTime.backToBattleField then
if t.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
if e[2]<=0 and e[1]<ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
t.CurrHeroCtrl.NotUsualType=0
o.SetSwallowHeroId(t,e,0)
e[2]=1
t.CurrHeroCtrl.entranceType=EBattleHeroEntranceType.SplitOut
if e[3]>0 then
local o=e[3]
local a=e[4]
local e={e[5],e[6],e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.HeroDead
or a.buffTriggerTime==BuffTriggerTime.enterUnUsualStateBefore then
o.BackBattleField(t,e,a.buffTriggerTime)
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
function a.SetSwallowHeroId(a,t,e)
if e==0 then
o.RemoveCtrlAttr(a,t)
end
local t=308200601
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(a.releaseHeroId)
if a then
local a=a.HeroBattleInfo:GetBuff(t)
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.SetSwallowHeroId(a,e)
end
end
end
function a.OnBuffEffect(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.CurrHeroCtrl:HideHero()
end
function a.RemoveCtrlAttr(e,t)
if t[9]==1 and t[2]==0 then
e.CurrHeroCtrl:RemoveImmuneAvoidDeath(e.buffId)
e.CurrHeroCtrl:RemoveImmuneResurgence(e.buffId)
e.CurrHeroCtrl:RemoveImmuneLockHp(e.buffId)
end
end
function a.BackBattleField(e,t,n)
if t[2]<=0 then
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
if a and a.HeroBattleInfo then
local i=308200601
local a=a.HeroBattleInfo:GetBuff(i)
if a then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(i)
local s=i.GetSwallowHeroId(a)
if s==e.CurrHeroCtrl.HeroId then
e.CurrHeroCtrl.NotUsualType=0
e.CurrHeroCtrl.WillNotUsual=false
o.SetSwallowHeroId(e,t,0)
t[2]=1
e.CurrHeroCtrl.entranceType=EBattleHeroEntranceType.Quick
e.CurrHeroCtrl:ShowBackBattleField(true)
if t[9]>0 and n==BuffTriggerTime.HeroDead then
i.AddAttackTask(a,false)
end
end
end
end
end
end
return o

