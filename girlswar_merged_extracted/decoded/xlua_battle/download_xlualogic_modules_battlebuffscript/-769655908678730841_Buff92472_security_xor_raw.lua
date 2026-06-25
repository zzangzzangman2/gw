local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.OnAdd(e,t)
e.CurrHeroCtrl:AddHasImmuneDamageBuff()
end
function a.OnRemoveSelf(e,t)
e.CurrHeroCtrl:reduceHasImmuneDamageBuff()
end
function a.DoAction(t,e,o,i,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.immuneDamageConsume then
if t.CurrHeroCtrl.immuneDamageWithConsume==false then
if(e[1]>=RandomMgr:GetBattleRandom())then
if e[9]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[9]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[8]=0
end
if e[8]<e[2]then
e[8]=e[8]+1
t.CurrHeroCtrl:SetImmuneDamageWithConsume(true)
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.attacked then
local i=e[3]
local n=e[4]
local a={e[5],e[6]}
o:AddBuff(t.CurrHeroCtrl,i,n,a)
local a=92473
local a=o.HeroBattleInfo:GetBuff(a)
if a then
if t.CurrHeroCtrl and t.CurrHeroCtrl.HeroBattleInfo then
t.CurrHeroCtrl:AddFuryWithBuffImmediately(e[7])
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.immuneDamageConsume
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GetImmuneDamageCount(e,e)
return 1
end
return i

