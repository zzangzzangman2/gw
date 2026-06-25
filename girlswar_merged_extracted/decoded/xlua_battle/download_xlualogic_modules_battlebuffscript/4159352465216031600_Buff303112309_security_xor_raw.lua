local s=require("DataNode/DataManager/DataMgr/DataUtil")
local o={}
local h=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,a,a,n,i)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t.CurrHeroCtrl
local o=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
if i.buffTriggerTime==BuffTriggerTime.now then
a.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[1],e[2])
a.HeroBattleInfo:CheckAddBuffValue(t.buffId,e[3],e[4])
elseif i.buffTriggerTime==BuffTriggerTime.addBuff then
if n.buffHeroId~=a.HeroId then
return
end
local i=n.addBuffId
if i==t.buffId then
return
end
local i=s:GetBuffCfg(i)
if i.isGran~=1 then
return
end
if e[9]~=o then
e[9]=o
e[10]=0
end
if e[10]>=e[6]then
return
end
e[10]=e[10]+1
local e=math.floor(a.HeroBattleInfo.MaxHP*e[5]*MillionCoe)
a:HpHealthWithBuffImmediately(e,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
elseif i.buffTriggerTime==BuffTriggerTime.removeBuff then
local t=n[1]
local t=s:GetBuffCfg(t)
if t.isGran~=1 then
return
end
if e[11]~=o then
e[11]=o
e[12]=0
end
if e[12]>=e[8]then
return
end
e[12]=e[12]+1
a:AddFuryWithBuff(e[7])
end
end
function o.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.addBuff
or e==BuffTriggerTime.removeBuff then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return h

