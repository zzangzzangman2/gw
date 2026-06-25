local i=require("Modules/Battle/BattleUtil")
local o={}
local n=o
function o.GetCanAdd(e,e)
return true
end
function o.OnAdd(t,e)
t.CurrHeroCtrl.HeroBattleInfo:SetMaxFury(e[9])
end
function o.OnRemoveSelf(e,e,e)
end
function o.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
if#a>0 then
local a=i:FindMostBigAtk(a)
if a then
local o=303111003
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if e then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
o.AddBuffBabai(e,a,t[1])
end
end
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.fMaxHpPercentWithCount)
if#a>0 then
local a=a[1]
if a then
local o=303111003
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if e then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
o.AddBuffBabai(e,a,t[2])
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.teamHeroDead
or a.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead
or a.buffTriggerTime==BuffTriggerTime.teamHeroFakeDead
or a.buffTriggerTime==BuffTriggerTime.enemyTeamHeroFakeDead then
local o=t[3]
if a.buffTriggerTime==BuffTriggerTime.teamHeroDead
or a.buffTriggerTime==BuffTriggerTime.teamHeroFakeDead then
o=o+t[4]
end
e.CurrHeroCtrl:AddFuryWithBuff(o)
local a=t[5]
local o=t[6]
local t={t[7],t[8]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.teamHeroDead
or e==BuffTriggerTime.enemyTeamHeroDead
or e==BuffTriggerTime.teamHeroFakeDead
or e==BuffTriggerTime.enemyTeamHeroFakeDead)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return n

