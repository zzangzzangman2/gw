local o=require("Modules/Battle/BattleUtil")
local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddImmunneCtrlBuffId(e.buffId)
end
function t.OnRemoveSelf(e,t)
if(ModulesInit.ProcedureNormalBattle.isBattleEnd)then
return
end
e.CurrHeroCtrl.HeroBattleInfo:RemoveImmunneCtrlBuffId(e.buffId)
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
if e and e.HeroBattleInfo then
local t=303111512
local e=e.HeroBattleInfo:GetBuff(t)
if(e)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
if t.OnRemoveGreatRivers then
t.OnRemoveGreatRivers(e)
end
end
end
end
function t.DoAction(e,t,n,n,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,HeroAttrId.shield,t[7])
elseif a.buffTriggerTime==BuffTriggerTime.addBuffCheckCtrl then
local t=i[1]
if o:IsStrongCtlBuff(t)then
if e.releaseHeroId~=e.CurrHeroCtrl.HeroId then
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e.releaseHeroId)
if t then
local e=303111511
local t=t.HeroBattleInfo:GetBuff(e)
if(t)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
if e.CheckConditionExcute(t)then
return{
ret=true,
}
end
end
end
end
end
return{
ret=false
}
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addBuffCheckCtrl)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.HandleShieldReduce(e,t)
local a=e:GetBuffData()
local t=t*a[6]*MillionCoe
e.CurrHeroCtrl:HpHealthWithDirect(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
return n

