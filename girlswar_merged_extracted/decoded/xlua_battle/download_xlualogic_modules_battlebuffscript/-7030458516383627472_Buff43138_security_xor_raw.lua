local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,o,t,t,t,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=o[1]
if a.buffTriggerTime==BuffTriggerTime.beCritical then
for a=1,#t do
local t=t[a]
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if a then
local t=43137
local a=a.HeroBattleInfo:GetBuff(t)
if a then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.DoActionWith4(a,e.CurrHeroCtrl)
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
for a=1,#t do
local t=t[a]
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if t then
local a=43140
local t=t.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.DoActionWith6Start(t,e.CurrHeroCtrl)
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
o[2]=e.CurrHeroCtrl:CurrHPPer()
for a=1,#t do
local t=t[a]
local t=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if t then
local a=43140
local t=t.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.DoActionWith6End(t,e.CurrHeroCtrl)
end
end
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.beCritical
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

