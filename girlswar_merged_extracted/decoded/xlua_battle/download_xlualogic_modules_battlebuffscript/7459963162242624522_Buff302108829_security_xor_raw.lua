local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,o,o,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,a[1],a[2])
elseif t.buffTriggerTime==BuffTriggerTime.attacked then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.selfRow)
if(t)then
for o,t in ipairs(t)do
if t.HeroId~=e.CurrHeroCtrl.HeroId then
local o=t.HeroBattleInfo:GetMaxHP()-t.HeroBattleInfo:GetCurrHP()
local o=o*a[3]*MillionCoe
local a=t.HeroBattleInfo:GetMaxHP()*a[4]*MillionCoe
o=math.max(o,a)
t:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

