local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,n,t,t,t,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.after then
local t=43244
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if a then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(t)
local t={}
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.selfRow)
for o=1,#t do
local t=t[o]
if t.HeroId~=e.CurrHeroCtrl.HeroId then
i.AddBuffSeed(a,t)
end
end
end
elseif o.buffTriggerTime==BuffTriggerTime.after2 then
local o=43245
local t=43244
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
local i={}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for i=1,#e do
local e=e[i]
local o=e.HeroBattleInfo:GetBuff(o)
if o then
t.AddBuffGrow(a,e,n[1])
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.after
or e==BuffTriggerTime.after2)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

