local s=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,i,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local i=e[2]
if a.buffTriggerTime==BuffTriggerTime.now then
local i=e[2]
local a=e[3]
local o={e[4],e[5],e[6],e[7]}
local e=e[1]
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,a,o,e)
elseif a.buffTriggerTime==BuffTriggerTime.skillComplete
or a.buffTriggerTime==BuffTriggerTime.buffDamageComplete
or a.buffTriggerTime==BuffTriggerTime.fatalDmgBefore then
local n=0
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if i then
n=i:GetFloors()
end
if n>0 then
if a.buffTriggerTime==BuffTriggerTime.skillComplete
or a.buffTriggerTime==BuffTriggerTime.buffDamageComplete then
if t.CurrHeroCtrl.HeroBattleInfo.CurrHP>0 then
o.HandleBeAttack(t,e,i,n)
end
elseif a.buffTriggerTime==BuffTriggerTime.fatalDmgBefore then
o.HandleFatalAttack(t,e,i)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillComplete
or e==BuffTriggerTime.buffDamageComplete
or e==BuffTriggerTime.fatalDmgBefore)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.HandleBeAttack(t,e,i,s)
if e[21]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[21]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[20]=0
end
local a=e[10]
e[20]=e[20]or 0
if(e[20]>=a)then
return nil
end
e[20]=e[20]+1
local a=t.CurrHeroCtrl.HeroBattleInfo:GetCurrHP()
local n=t.CurrHeroCtrl.HeroBattleInfo.MaxHP-a
local a=e[8]*MillionCoe
local a=n*a
if a>0 then
t.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
end
t.CurrHeroCtrl:AddFuryWithBuff(e[9])
i:ReduceFloors(1)
if s-1<=0 then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(i.buffId,BuffRemoveType.Expire)
o.RemoveGirlBuff(t)
end
end
function a.HandleFatalAttack(e,t,a)
if s:CheckCanTriggerFatalDmgBefore(e.CurrHeroCtrl)==false then
return
end
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a.buffId,BuffRemoveType.Expire)
o.RemoveGirlBuff(e)
e.CurrHeroCtrl.HeroBattleInfo:ClearAllGranBuff(false)
local a=t[11]*MillionCoe
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP*a
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.DeathImmune,e.releaseHeroId,e.buffId,true)
local a=t[12]
local o=t[13]
local i={t[14],t[15]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,i)
local o=t[16]
local a=t[17]
local t={t[18],t[19]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
function a.RemoveGirlBuff(e)
local t=302107612
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.OnRemoveGirlBuff(e)
end
end
return o

