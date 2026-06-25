local i=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,s,h,n,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
elseif o.buffTriggerTime==BuffTriggerTime.afterAttacked then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
if e.CurrHeroCtrl.HeroId==s.HeroId then
local e=n.reduceHpValue
t[7]=math.min(t[7]+e,t[6])
end
end
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
if e.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
a.AllTransferBuffToMate(e,true)
end
elseif o.buffTriggerTime==BuffTriggerTime.HeroDead then
local t=e.buffId
local t,o=i:GetHeroNoBuffByType(e.CurrHeroCtrl,BattleHeroType.ourAll,t)
local t=RandomTableWithSeed(t,1)
if t[1]then
a.TransferBuffToMate(e,t[1],false)
end
elseif o.buffTriggerTime==BuffTriggerTime.attack then
if t[8]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
t[8]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
t[7]=0
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.eachRoundEnd
or e==BuffTriggerTime.HeroDead
or e==BuffTriggerTime.attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AllTransferBuffToMate(e,n)
local t=e:GetBuffData()
if t[9]==ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
return
end
local o=e.buffId
local t,e=i:GetHeroNoBuffByType(e.CurrHeroCtrl,BattleHeroType.ourAll,o)
local i=RandomTableWithSeed(t,#t)
for t=1,#e do
local i=i[t]
local e=e[t]
local e=e.HeroBattleInfo:GetBuff(o)
if e then
local t=e:GetBuffData()
t[9]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
a.TransferBuffToMate(e,i,n)
end
end
end
function t.TransferBuffToMate(e,t,n)
local o=false
if t then
o=i:AddBuffWithBuffInfo(t,e)
if o then
if t and t.HeroBattleInfo then
t.HeroBattleInfo:PlayBattleEffectWithBuffId(e.buffId)
end
if n then
a.HurtWithSaveDamage(e)
end
if e.CurrHeroCtrl then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(e.buffId,BuffRemoveType.Expire)
end
if(ModulesInit.ProcedureNormalBattle.IsSkipBattle==false)then
local e=t:GetMiddlePointPos()
ModulesInit.GlobalBattleEffectMgr.ShowEffectAutoRelease(SysPrefabId.BattleSKHEvilTransferEffect,e.x,e.y,50,3,0,false,function()
end)
end
end
end
if o==false then
if n then
a.HurtWithSaveDamage(e)
end
end
end
function t.HurtWithSaveDamage(e)
local t=e:GetBuffData()
if t[7]>0 then
e.CurrHeroCtrl:RealHurtWithBuff(t[7],e)
end
end
return a

