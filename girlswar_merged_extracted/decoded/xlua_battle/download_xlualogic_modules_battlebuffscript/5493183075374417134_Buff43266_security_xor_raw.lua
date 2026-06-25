local h=require("Modules/Battle/BattleUtil")
local r=require("DataNode/DataManager/DataMgr/DataUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddImmunneCtrlBuffId(e.buffId)
end
function a.OnRemoveSelf(e,t)
e.CurrHeroCtrl.HeroBattleInfo:RemoveImmunneCtrlBuffId(e.buffId)
end
function a.DoAction(t,e,a,s,n,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[3],e[4])
t.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[9],e[10])
t.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[11],e[12])
elseif o.buffTriggerTime==BuffTriggerTime.attack then
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[5]
a.value=e[6]
s.HeroBattleInfo:AddTempBuffValue(a)
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[7]
a.value=e[8]
s.HeroBattleInfo:AddTempBuffValue(a)
elseif o.buffTriggerTime==BuffTriggerTime.addBuffCheckCtrl then
if e[17]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[17]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[16]=0
end
if e[16]<e[13]then
local a=n[1]
if h:IsStrongCtlBuff(a)then
i.ActivateBloom(t)
e[16]=e[16]+1
return{
ret=true,
remove=false
}
end
end
return{
ret=false
}
elseif o.buffTriggerTime==BuffTriggerTime.addBuff then
if n.buffHeroId==t.CurrHeroCtrl.HeroId then
local e=n.addBuffId
local e=r:GetBuffCfg(e)
if(e.isGran==0)then
i.ActivateBloom(t)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attack
or e==BuffTriggerTime.addBuffCheckCtrl
or e==BuffTriggerTime.addBuff)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.ActivateBloom(e)
local t=e:GetBuffData()
if t[15]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
t[15]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e.CurrHeroCtrl:ResetBuffTeamStatCount(e.buffId)
end
local a=e.CurrHeroCtrl:GetBuffTeamStatCount(e.buffId)
if a<t[14]then
local a=false
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for e=1,#t do
local e=t[e]
local t=43265
local e=e.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.ActiveDamage(e)
a=true
end
end
if a then
e.CurrHeroCtrl:AddBuffTeamStatCount(e.buffId,1)
end
end
end
return i

