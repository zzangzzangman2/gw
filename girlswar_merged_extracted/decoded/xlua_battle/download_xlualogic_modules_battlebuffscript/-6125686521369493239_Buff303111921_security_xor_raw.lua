local n=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddImmunneCtrlBuffId(e.buffId)
end
function a.OnRemoveSelf(e,t)
e.CurrHeroCtrl.HeroBattleInfo:RemoveImmunneCtrlBuffId(e.buffId)
end
function a.DoAction(e,t,i,i,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local i=t[1]
local a=t[2]
local o={t[3],t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,a,o)
local a=t[5]
local o=t[6]
local t={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
elseif a.buffTriggerTime==BuffTriggerTime.addBuffCheckCtrl then
local a=o[1]
if n:IsCtlBuff(a)then
local a=math.floor(e.CurrHeroCtrl.HeroBattleInfo.MaxHP*t[9]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
e.CurrHeroCtrl:AddFuryWithBuff(t[10])
return{
ret=true,
remove=false
}
end
return{
ret=false
}
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local t=303111914
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t==nil then
s.AddBuffLiquidation(e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.addBuffCheckCtrl
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffLiquidation(t)
local i=t:GetBuffData()
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.enemyAll)
local e=303111915
local o=i[11]
local a,n=n:GetHeroNoBuffByType(t.CurrHeroCtrl,BattleHeroType.enemyAll,e,o,true)
local e={}
if#a<o then
local t=o-#a
e=RandomTableWithSeed(n,t)
table.appendList(e,a)
else
e=a
end
for a=1,#e do
local o=e[a]
local a=303111907
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.AddBuffLiquidation(e,o,i[12])
end
end
end
return s

