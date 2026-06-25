local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
o.AddblockRateAdd(e,t)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
o.AddblockRateAdd(e,t)
elseif a.buffTriggerTime==BuffTriggerTime.attacked then
local a=t[1]
if e.CurrHeroCtrl:IsRealFirstRowHero()then
a=t[2]
end
if(a>=RandomMgr:GetBattleRandom())then
local t={
attrId=t[3],
value=t[4],
}
e.CurrHeroCtrl:AddAttrValueInCurAttack(t)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.OnRemoveGirlBuff(t)
local e=302107621
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.AddGirlFight(t)
end
end
function t.AddblockRateAdd(t,e)
local a=t.CurrHeroCtrl.CurrBattleTeam:GetAllHerosCountInBattle()
local o=e[8]+a*e[9]
local a=e[5]
local i=e[6]
local e={e[7],o}
t.CurrHeroCtrl:AddBuffAfterRemove(t.CurrHeroCtrl,a,i,e)
end
return o

