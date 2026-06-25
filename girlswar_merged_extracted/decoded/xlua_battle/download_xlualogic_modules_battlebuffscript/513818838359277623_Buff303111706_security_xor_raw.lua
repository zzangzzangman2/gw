local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.AddBuffAllFrontVijnanavada(e,false)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
if 1~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
t.AddBuffAllFrontVijnanavada(e,true)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddBuffAllFrontVijnanavada(a,i)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a.CurrHeroCtrl,BattleHeroType.selfRow)
local t=303111704
local a=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if a then
for o=1,#e do
local o=e[o]
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.AddBuffVijnanavada(a,o,nil,i)
end
end
end
return t

