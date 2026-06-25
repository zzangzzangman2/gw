local o=require("Modules/Battle/BattleUtil")
local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
local a=t[2]
if e.releaseHeroId==e.CurrHeroCtrl.HeroId then
a=t[3]
end
local t={
buffId=e.buffId,
reduceHpMinHpPercent=t[1],
reduceHpResRate=a,
damageResHeroId=e.CurrHeroCtrl.HeroId
}
e.CurrHeroCtrl:AddDamageResData(t)
local t=303112018
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddBuffShare(e)
t.OnAddBuffAlert(e)
end
end
function e.OnRemoveSelf(e,t,t)
if ModulesInit.ProcedureNormalBattle.isBattleEnd then
return
end
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
local t=303112018
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.RemoveBuffShare(e)
end
end
function e.OnOverlap(e,t)
local t=303112018
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.OnRemoveSepsis(e)
end
end
function e.DoAction(t,e,n,o,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.afterAttacked then
local a=t.CurrHeroCtrl.HeroId
if a==o.HeroId then
if e[4]>0 and e[4]>=RandomMgr:GetBattleRandom()then
local i=e[6]
local o=e[7]
local a={}
for t=8,11 do
table.insert(a,e[t])
end
local e=e[5]
n:AddBuff(t.CurrHeroCtrl,i,o,a,e)
end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.OnReduceHpRes(e,a)
local t=e:GetBuffData()
e.CurrHeroCtrl:AddBuffTeamStatCount(e.buffId,1)
if e.CurrHeroCtrl:GetBuffTeamStatCount(e.buffId)>=t[12]and t[12]>0 then
local t=303112027
local t,e=o:GetHeroNoBuffByType(e.CurrHeroCtrl,BattleHeroType.ourAll,t)
if#e>0 then
local e=e[1]
local t=303112027
local e=e.HeroBattleInfo:GetBuff(t)
if(e)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.CheckAddAttackTask(e)
end
end
end
o:ReduceHeroBuffFloor(e.CurrHeroCtrl,e.buffId,1)
local e={
isSeparately=false,
realHurtValue=a
}
return e
end
return i

